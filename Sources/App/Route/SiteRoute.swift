
import URLRouting
import BSON

let objectIdParser = ParsePrint {
  Prefix<Substring> { $0.isHexDigit }
    .map(.string)
    .map(
      .convert(
        apply: { ObjectId($0) },
        unapply: { $0.hexString }
      )
    )
}

public enum SiteRoute: Equatable {
    case admin(AdminRoute)
    case authEngine(AuthEngineRoute)
    case terms
    case privacy
}

public struct SiteRouter: ParserPrinter {

    public init() {}

    public var body: some Router<SiteRoute> {
        OneOf {

            Route(.case(SiteRoute.admin)) {
                Path { "admin" }
                AdminRouter()
            }

            Route(.case(SiteRoute.terms)) {
                Path { "terms" }
            }

            Route(.case(SiteRoute.privacy)) {
                Path { "privacy" }
            }
        }
    }
}
