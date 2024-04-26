
import Vapor
import JWT

extension Request {
    var accessToken: String? {
        self.headers.bearerAuthorization?.token ?? self.cookies["quick_visa_process"]?.string
        // < cookies for backend but for now we dont use it
    }
}

public final class JWTMiddleware: AsyncMiddleware {
    public init() {}

    public func respond(to req: Request, chainingTo next: AsyncResponder) async throws -> Response {
        if ["/admin/auth/login",
            "/admin/auth/loginp",
            "/admin/auth/verify_otp_email",

            "/terms", "/privacy",
            "/admin",

            "/admin/auth/register",
            "/admin/auth/create",
            "/admin/auth/register/create/",
            "/api/auth/email-verification",
            "/api/auth/reset-password/verify",
            "/api/auth/reset-password/",

            "/js/web.js", "/css/web.css", "/images/logo.png",
            "/"
        ].contains(req.url.path) {
            return try await next.respond(to: req)
        }

        if let token = req.accessToken {
            do {
                req.payload = try req.jwt.verify(Array(token.utf8), as: Payload.self)
            } catch let JWTError.claimVerificationFailure(name: name, reason: reason) {
                throw JWTError.claimVerificationFailure(name: name, reason: reason)
            } catch let error {
                req.logger.info("\(self) \(#line) \(#file) \(error)")
                if req.accessToken == "" {
                    return try await next.respond(to: req)
                }

                return req.redirect(to: "/auth/login")
                //return Response(status: .unauthorized, body: .init(string: "You are not authorized this token \(error)"))
            }

            return try await next.respond(to: req)

        } else {
            req.logger.error("Unauthorized missing token \(req.url.path) \(String(describing: req.body.string))")
            return Response(status: .unauthorized, body: .init(string: "Missing authorization bearer header"))
        }
    }

}

extension AnyHashable {
    static let payload: String = "jwt_payload"
}

extension Request {
    public var loggedIn: Bool {
        return self.storage[PayloadKey.self] != nil ?  true : false
    }

    public var payload: Payload {
        get { self.storage[PayloadKey.self]! } // should not use it
        set { self.storage[PayloadKey.self] = newValue }
    }
}
