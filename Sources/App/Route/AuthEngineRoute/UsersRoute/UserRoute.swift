
import URLRouting

public enum UserRoute: Equatable {
    case find
    case delete

}

struct UserRouter: ParserPrinter {
    var body: some Router<UserRoute> {
        OneOf {
            Route(.case(UserRoute.find))

            Route(.case(UserRoute.delete)) {
                Method.delete
            }
        }
    }
}
