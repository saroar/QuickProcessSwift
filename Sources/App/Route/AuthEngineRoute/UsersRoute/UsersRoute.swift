
import URLRouting
import BSON

public enum UsersRoute: Equatable {
    case user(id: ObjectId, route: UserRoute)
    case update(input: UserOutput)
}

public struct UsersRouter: ParserPrinter {
    public var body: some Router<UsersRoute> {
        OneOf {
            Route(.case(UsersRoute.user)) {
                Path { objectIdParser }
                UserRouter()
            }

            Route(.case(UsersRoute.update)) {
                Method.put
                Body(.json(UserOutput.self))
            }
        }
    }
}


