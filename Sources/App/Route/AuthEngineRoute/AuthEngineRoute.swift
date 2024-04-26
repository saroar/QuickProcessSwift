
import URLRouting

public enum AuthEngineRoute: Equatable {
    case authentication(AuthenticationRoute)
    case users(UsersRoute)
}

public struct AuthEngineRouter: ParserPrinter {
    public var body: some Router<AuthEngineRoute> {
        OneOf {
            Route(.case(AuthEngineRoute.authentication)) {
                AuthenticationRouter()
            }

            Route(.case(AuthEngineRoute.users)) {
                Path { "users" }
                UsersRouter()
            }
        }
    }
}
