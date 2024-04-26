import Vapor
import MongoKitten

public struct EmailToken: Codable {
    public static let collectionName = "userEmailTokens"
    
    public var _id: ObjectId?
    public var userId: ObjectId
    public var token: String
    public var expiresAt: Date
    
    public init(
        _id: ObjectId? = nil,
        userID: ObjectId,
        token: String,
        expiresAt: Date = Date().addingTimeInterval(Constants.EMAIL_TOKEN_LIFETIME)
    ) {
        self._id = _id
        self.userId = userID
        self.token = token
        self.expiresAt = expiresAt
    }
}

extension EmailToken {
    static func query(_ request: Request) -> MongoCollection {
        return request.application.mongoDB[Self.collectionName]
    }
}
