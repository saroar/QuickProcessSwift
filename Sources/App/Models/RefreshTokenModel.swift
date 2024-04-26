
import Vapor
import MongoKitten
import JWT

public final class RefreshTokenModel: Codable {
  public static let collectionName = "user_refresh_tokens"

	public var _id: ObjectId?
	public var token: String
	public var userId: ObjectId

	public var expiresAt: Date
	public var issuedAt: Date

    public init(
        _id: ObjectId? = nil,
        token: String,
        userId: ObjectId,
        expiresAt: Date = Date().addingTimeInterval(Constants.REFRESH_TOKEN_LIFETIME),
        issuedAt: Date = Date()
    ) {
		self._id = _id
		self.token = token
		self.userId = userId
		self.expiresAt = expiresAt
		self.issuedAt = issuedAt
	}
}

extension RefreshTokenModel {
    static func query(_ request: Request) -> MongoCollection {
        return request.application.mongoDB[Self.collectionName]
    }
}

public struct JWTRefreshToken: JWTPayload {
    public var id: ObjectId?
    public var iat: Int
    public var exp: Int

  public init(user: UserModel, expiration: Int = 31536000) { // Expiration 1 year
        let now = Date().timeIntervalSince1970
        self.id = user._id
        self.iat = Int(now)
        self.exp = Int(now) + expiration
    }

   public func verify(using signer: JWTSigner) throws {
        let expiration = Date(timeIntervalSince1970: TimeInterval(self.exp))
        try ExpirationClaim(value: expiration).verifyNotExpired()
    }
}
