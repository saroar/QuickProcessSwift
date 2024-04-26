import URLRouting

public enum AdminRoute: Equatable {
    case admin
    case auth(AuthEngineRoute)
    case missions(MissionsRoute)
}

struct AdminRouter: ParserPrinter {
    var body: some Router<AdminRoute> {
        OneOf {
            Route(.case(AdminRoute.admin))

            Route(.case(AdminRoute.missions)) {
                Path { "missions" }
                MissionsRouter()
            }

            Route(.case(AdminRoute.auth)) {
                Path { "auth" }
                AuthEngineRouter()
            }
        }
    }
}

public enum MissionsRoute: Equatable {
    case list
    case start
    case stop
}

struct MissionsRouter: ParserPrinter {
    var body: some Router<MissionsRoute> {
        OneOf {
            Route(.case(MissionsRoute.list))

            Route(.case(MissionsRoute.start)) {
                Path { "start" }
                Method.post
            }

            Route(.case(MissionsRoute.stop)) {
                Path { "stop" }
                Method.post
            }
        }
    }
}
