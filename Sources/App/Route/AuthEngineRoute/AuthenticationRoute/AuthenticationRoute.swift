import URLRouting

extension UserCreateObject: Equatable {
    public static func == (lhs: UserCreateObject, rhs: UserCreateObject) -> Bool {
        return lhs.fullName == rhs.fullName
        && lhs.email == rhs.email
        && lhs.phoneNumber == rhs.phoneNumber
    }
}


public enum AuthenticationRoute: Equatable {

    case registerGet
    case registerPost(UserCreateObject)

    case loginViaEmailGet
    case loginViaEmailPost(EmailLoginInput)

    case verifyEmailGet
    case verifyEmailPost(VerifyEmailInput)

    case refreshToken(input: RefreshTokenInput)
}

public struct AuthenticationRouter: ParserPrinter {
    public var body: some Router<AuthenticationRoute> {
         OneOf {

             Route(.case(AuthenticationRoute.registerGet)) {
                 Path { "register" }
             }

             Route(.case(AuthenticationRoute.registerPost)) {
                 Path { "register" }
                 Method.post
                 Body(.json(UserCreateObject.self))
             }

             Route(.case(AuthenticationRoute.loginViaEmailGet)) {
                 Path { "login" }
             }

            Route(.case(AuthenticationRoute.loginViaEmailPost)) {
                Path { "loginp" }
                Method.post
                Body(.json(EmailLoginInput.self))
            }

             Route(.case(AuthenticationRoute.verifyEmailGet)) {
                 Path { "verify_otp_email" }
             }

            Route(.case(AuthenticationRoute.verifyEmailPost)) {
                Path { "verify_otp_email" }
                Method.post
                Body(.json(VerifyEmailInput.self))
            }

            Route(.case(AuthenticationRoute.refreshToken)) {
                Path { "refresh_token" }
                Method.post
                Body(.json(RefreshTokenInput.self))
            }
        }
    }
}
