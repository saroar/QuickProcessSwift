import Vapor
import MongoKitten

public struct UserModel: Codable, Hashable {

    public static var collectionName = "users"

    public init(
        _id: ObjectId,
        fullName: String,
        language: UserLanguage,
        role: UserRole = .basic,
        isEmailVerified: Bool = false,
        phoneNumber: String? = nil,
        email: String? = nil
    ) {
        self._id = _id
        self.fullName = fullName
        self.language = language
        self.role = role
        self.isEmailVerified = isEmailVerified
        self.phoneNumber = phoneNumber
        self.email = email
    }

    public var _id: ObjectId
    public var fullName: String?
    public var language: UserLanguage
    public var role: UserRole
    public var isEmailVerified: Bool

    public var email: String?
    public var phoneNumber: String?

    public var createdAt: Date?
    public var updatedAt: Date?
    public var deletedAt: Date?

    public func toBSON() throws -> Document {
        let encoder = BSONEncoder()
        let bson = try encoder.encode(self)
        return bson
    }

}

extension UserModel {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(_id)
    }

    public static func == (lhs: UserModel, rhs: UserModel) -> Bool {
        lhs._id == rhs._id
    }
}

extension UserModel {
    static func query(_ request: Request) -> MongoCollection {
        return request.application.mongoDB[Self.collectionName]
    }
}

extension UserOutput: Content {}

extension UserModel {
    /// User map get
    /// - Returns: it return user without eager loading
    public func mapGet() -> UserOutput {
        return .init(
            id: _id,
            fullName: fullName ?? "unknown",
            email: email, phoneNumber: phoneNumber,
            role: role,
            language: language,
            url: URL(string: "http://localhost:8080")!,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }

    public func mapGetPublic() -> UserOutput {
        return .init(
            id: _id,
            fullName: fullName ?? "unknown",
            role: role,
            language: language,
            url: URL(string: "http://localhost:8080/admin/auth/login")!,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }

}

