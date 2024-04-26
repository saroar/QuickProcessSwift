import Vapor
import VaporRouting
import BSON

public func adminHandler(
    request: Request,
    route: AdminRoute
) async throws -> AsyncResponseEncodable {
    switch route {
    case .auth(let authRoute):
        return try await authEngineHandler(request: request, route: authRoute)
    
    case .admin:
        var currentUser: UserOutput = .init(id: .init(), role: .basic, language: .english, url: URL(string: "http://localhost:8080")!)

        if let token = request.accessToken {
            do {
                currentUser = try request.jwt.verify(token, as: Payload.self).user.mapGet()
            } catch {
                return request.redirect(to: "/")
            }
        }

        // return try await req.view.render("bot_list", ["missions": sortedList])
        return try await request.view.render("admin", ["currentUser": currentUser])
        case .missions(let mRoute):
            return try await missionsHandler(request: request, route: mRoute)
    }
}
