import Vapor
import VaporRouting

public func siteHandler(
    request: Request,
    route: SiteRoute
) async throws -> AsyncResponseEncodable {
    switch route {

    case let .authEngine(authRoute):
        return try await authEngineHandler(request: request, route: authRoute)

    case .terms:
        return try await request.view.render("terms")

    case .privacy:
        return try await request.view.render("privacy")

    case let .admin(authRoute):
        return try await adminHandler(request: request, route: authRoute)
    }
}
