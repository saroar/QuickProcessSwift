
import Vapor
import URLRouting
import MongoKitten

extension UserModel: Content {}

public func userHandler(
    request: Request,
    userId: ObjectId,
    route: UserRoute
) async throws -> AsyncResponseEncodable {
    switch route {
    case .find:

        guard let user = try await UserModel.query(request).findOne("_id" == userId, as: UserModel.self) else {
            throw Abort(.notFound, reason: "\(#line) parameters user id is missing")
        }

        if request.loggedIn == false { throw Abort(.unauthorized) }

        if userId == request.payload.user._id {
            return user.mapGet()
        }

        return user.mapGetPublic()

    case .delete:

        try request.isAuthorized(userId)

        let schema = request.application.mongoDB[UserModel.collectionName]

        guard let _ = try await schema.findOne("_id" == userId, as: UserModel.self) else {
            throw Abort(.notFound, reason: "\(#line) parameters user id is missing")
        }
        
        return HTTPStatus.ok

    }
}
