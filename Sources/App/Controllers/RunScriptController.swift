
import Vapor
import VFS_Bot

struct MissionController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let routeGroup = routes.grouped("missions")
        routeGroup.get(use: indexHandler)
        routeGroup.get("start", use: startHander)
    }

    func indexHandler(req: Request) async throws -> View {
        return try await req.view.render("index")
    }

    func startHander(req: Request) async throws -> View {
        // Simulate an async task, e.g., database access
        try await Task.sleep(nanoseconds: 1_000_000_000) // Sleep for 1 second

        req.logger.info("Async Start executed")

        try await setupAndStart()

        return try await req.view.render("index", ["title": "Hello Vapor!"])
    }
}
