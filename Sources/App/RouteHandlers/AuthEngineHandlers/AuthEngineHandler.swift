
import Vapor
import VaporRouting
import BSON

public func authEngineHandler(
    request: Request,
    route: AuthEngineRoute
) async throws -> AsyncResponseEncodable {
    switch route {
    case let .users(usersRoute):
        return try await usersHandler(request: request, route: usersRoute)
    case let .authentication(authenticationRoute):
        return try await authenticationHandler(request: request, route: authenticationRoute)
    }
}
