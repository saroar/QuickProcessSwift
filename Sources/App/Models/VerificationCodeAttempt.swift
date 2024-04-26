import Vapor
import MongoKitten

public struct VerificationCodeAttempt: Codable {

    static public let collectionName = "verification_code_attempts"

    public var _id: ObjectId
    public var phoneNumber: String?
    public var email: String?
    public var code: String
    public var expiresAt: Date?

    public init(
        _id: ObjectId,
        phoneNumber: String? = nil,
        email: String? = nil,
        code: String,
        expiresAt: Date?
    ) {
        self._id = _id
        self.phoneNumber = phoneNumber
        self.email = email
        self.code = code
        self.expiresAt = expiresAt
    }
}

extension VerificationCodeAttempt: Content {}

extension VerificationCodeAttempt {
    static func query(_ request: Request) -> MongoCollection {
        return request.application.mongoDB[Self.collectionName]
    }
}
