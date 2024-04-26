import Vapor
import MongoKitten

public struct PasswordToken: Codable {
    
    public static var collectionName: String = "userPasswordTokens"
    
    public var _id: ObjectId?
    public var userId: ObjectId
    public var token: String
    public var expiresAt: Date
    
    public init(
        id: ObjectId? = nil,
        userId: ObjectId,
        token: String,
        expiresAt: Date = Date().addingTimeInterval(Constants.RESET_PASSWORD_TOKEN_LIFETIME)
    ) {
        self._id = id
        self.userId = userId
        self.token = token
        self.expiresAt = expiresAt
    }
    
}

extension PasswordToken {
    static func query(_ request: Request) -> MongoCollection {
        return request.application.mongoDB[Self.collectionName]
    }
}
