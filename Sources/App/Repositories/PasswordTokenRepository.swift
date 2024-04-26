import Vapor
import MongoKitten

protocol PasswordTokenRepository: Repository {
	func find(userID: ObjectId) async throws -> PasswordToken?
	func find(token: String) async throws -> PasswordToken?
	func count() async throws -> Int
	func create(_ passwordToken: PasswordToken) async throws
	func delete(_ passwordToken: PasswordToken) async throws
	func delete(for userID: ObjectId) async throws
}

struct DatabasePasswordTokenRepository: PasswordTokenRepository, DatabaseRepository {
	var database: MongoDatabase

	func find(userID: ObjectId) async throws -> PasswordToken? {
        let schema = database[PasswordToken.collectionName]
        return try await schema.findOne("_id" == userID, as: PasswordToken.self)
	}

	func find(token: String) async throws -> PasswordToken? {
        let schema = database[PasswordToken.collectionName]
        return try await schema.findOne("token" == token, as: PasswordToken.self)
	}

	func count() async throws -> Int {
        let schema = database[PasswordToken.collectionName]
        return try await schema.count()
	}

	func create(_ passwordToken: PasswordToken) async throws {
        let schema = database[PasswordToken.collectionName]
        try await schema.insertEncoded(passwordToken)
	}

	func delete(_ passwordToken: PasswordToken) async throws {
        let schema = database[PasswordToken.collectionName]
        try await schema.deleteOne(where: "_id" == passwordToken._id)
	}

	func delete(for userID: ObjectId) async throws {
        let schema = database[PasswordToken.collectionName]
        try await schema.deleteOne(where: "userId" == userID)
	}
}

extension Application.Repositories {
	var passwordTokens: PasswordTokenRepository {
		guard let factory = storage.makePasswordTokenRepository else {
			fatalError("PasswordToken repository not configured, use: app.repositories.use")
		}
		return factory(app)
	}

	func use(_ make: @escaping (Application) -> (PasswordTokenRepository)) {
		storage.makePasswordTokenRepository = make
	}
}
