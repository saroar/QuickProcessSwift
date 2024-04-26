
import Vapor
import JWT
import JWTKit
import MongoKitten

public struct PayloadKey: StorageKey {
    public typealias Value = Payload
}

public struct Payload: JWTPayload, Authenticatable {
    // User-releated stuff
    public var user: UserModel
    // JWT stuff
    public var exp: ExpirationClaim

    public func verify(using signer: JWTSigner) throws {
        try self.exp.verifyNotExpired()
    }

    public init(with user: UserModel) throws {
        self.user = user
        self.exp = ExpirationClaim(value: Date().addingTimeInterval(Constants.ACCESS_TOKEN_LIFETIME))
    }
}

extension UserModel {
    public init(from payload: Payload) {
        self.init(
            _id: payload.user._id,
            fullName: payload.user.fullName ?? "unknown",
            language: payload.user.language,
            role: payload.user.role,
            email: payload.user.email
        )
    }
}


