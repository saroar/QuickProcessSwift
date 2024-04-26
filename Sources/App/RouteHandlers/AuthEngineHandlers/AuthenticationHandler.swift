import JWT
import Vapor
import VaporRouting
import MongoKitten

public func authenticationHandler(
    request: Request,
    route: AuthenticationRoute
) async throws -> AsyncResponseEncodable {
    switch route {

    case .loginViaEmailGet:
            return try await request.view.render("admin_login")

    case .loginViaEmailPost(let input):

            if !input.email.isEmailValid {
                throw Abort(.badRequest, reason: "your email is not valied")
            }

            let email = input.email.lowercased()

            guard let user = try await request.users.find(email: email) else {
                throw AuthenticationError.invalidEmailOrPassword
            }

            let randomDigits =
            request.application.environment == .development ||
            request.application.environment == .testing ? "336699" : String.randomDigits(ofLength: 6)

            let otp = "\(randomDigits)"
            let minutes = 5.0
            let expiresAt = Date().addingTimeInterval(minutes * 60.0)

            let smsAttempt = VerificationCodeAttempt(
                _id: .init(),
                email: email,
                code: otp,
                expiresAt: expiresAt
            )

            try await VerificationCodeAttempt
                .query(request)
                .insertEncoded(smsAttempt)

            let otpEmail = OTPEmail(
              templateName: "learnplaygrow_otp",
              name: user.fullName ?? "Nice Person",
              bodyWithOtp: otp,
              duration: "\(minutes)",
              subject: "Your LearnPlayGrow OTP Verification Code."
            )

            let emailPayload = EmailPayload(otpEmail, to: email)
            let task = EmailJobMongoQueue(payload: emailPayload, vCodeAttempt: smsAttempt)
            do {
                try await request.mongoQueue.queueTask(task)
            } catch {
                throw Abort(.forbidden, reason: "Request mongoQueue QueueTask: \(error)")
            }

            return EmailLoginOutput(
                email: email,
                attemptId: smsAttempt._id
            )

    case .verifyEmailGet:
        return try await request.view.render("")

    case .verifyEmailPost(let input):

        guard let attempt = try await VerificationCodeAttempt
            .query(request)
            .findOne(
                "_id" == input.attemptId &&
                "email" == input.email &&
                "code" == input.code,
                as: VerificationCodeAttempt.self
            )
        else {
            throw Abort(.notFound, reason: "\(#line) VerificationCodeAttempt not found!")
        }

        guard let expirationDate = attempt.expiresAt else {
            throw Abort(.notFound, reason: "\(#line) code expired")
        }

        guard expirationDate > Date() else {
            throw Abort(.notFound, reason: "\(#line) expiration date over")
        }

        let res = try await emailVerificationResponseForValidUser(with: input, on: request)


        var cookieAccess = HTTPCookies.Value(
            string: res.access.accessToken,
            isSecure: request.application.environment == .production ? true : false,
            isHTTPOnly: request.application.environment == .production ? true : false,
            sameSite: .lax
        )
        cookieAccess.expires = request.payload.exp.value

        let response = Response(status: .ok)
        try response.content.encode(["redirect": "/admin"])
        response.cookies["quick_visa_process"] = cookieAccess

        return response

    case .refreshToken(input: let data):

        let refreshTokenFromData = data.refreshToken
        let jwtPayload: JWTRefreshToken = try request.application
            .jwt.signers.verify(refreshTokenFromData, as: JWTRefreshToken.self)

        guard let userID = jwtPayload.id else {
            throw Abort(.notFound, reason: "User id missing from RefreshToken")
        }

        guard let user = try await UserModel
            .query(request)
            .findOne("_id" == userID, as: UserModel.self)
        else {
            throw Abort(.notFound, reason: "User not found by id: \(userID) for refresh token")
        }

        let payload = try Payload(with: user)
        let refreshPayload = JWTRefreshToken(user: user)

        do {
            let refreshToken = try request.application.jwt.signers.sign(refreshPayload)
            let payloadString = try request.application.jwt.signers.sign(payload)
            return RefreshTokenResponse(accessToken: payloadString, refreshToken: refreshToken)
        } catch {
            throw Abort(.notFound, reason: "jwt signers error: \(error)")
        }
        case .registerGet:
            return try await request.view.render("")

        case .registerPost(let input):

            return try await request.view.render("")
    }
}

private func emailVerificationResponseForValidUser(
    with input: VerifyEmailInput,
    on req: Request) async throws -> SuccessfulLoginResponse {

        let email = input.email.lowercased()

        guard let user = try await req.users.find(email: email) else {
            throw AuthenticationError.invalidEmailOrPassword
        }

        do {
            let userPayload = try Payload(with: user)
            let refreshPayload = JWTRefreshToken(user: user)

            let accessToken = try req.application.jwt.signers.sign(userPayload)
            let refreshToken = try req.application.jwt.signers.sign(refreshPayload)

            let access = RefreshTokenResponse(accessToken: accessToken, refreshToken: refreshToken)
            req.payload = userPayload

            try await VerificationCodeAttempt
                .query(req)
                .deleteOne(where:
                   "_id" == input.attemptId &&
                   "email" == input.email &&
                   "code" == input.code
                )

            return SuccessfulLoginResponse(
                status: "ok",
                user: user.mapGet(),
                access: access
            )

        } catch {
            throw Abort(.notFound, reason: error.localizedDescription)
        }

}

// MARK: - Login Response for mobile auth

public struct SuccessfulLoginResponse: Codable {
    public let status: String
    public let user: UserOutput
    public let access: RefreshTokenResponse

    public init(
      status: String,
      user: UserOutput,
      access: RefreshTokenResponse
    ) {
      self.status = status
      self.user = user
      self.access = access
    }

    public static func == (lhs: Self, rhs: Self) -> Bool {
      lhs.user == rhs.user
      && lhs.access.accessToken == rhs.access.accessToken
    }
}

extension SuccessfulLoginResponse: Equatable {}


public struct LoginRequest: Content {
    public let email: String
    public let password: String
}

extension LoginRequest: Equatable {}

extension LoginRequest: Validatable {
    public static func validations(_ validations: inout Validations) {
        validations.add("email", as: String.self, is: .email)
        validations.add("password", as: String.self, is: !.empty)
    }
}
