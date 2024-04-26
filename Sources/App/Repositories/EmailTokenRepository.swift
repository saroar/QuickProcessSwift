import Vapor
import MongoKitten

protocol EmailTokenRepository: Repository {
	func find(token: String) async throws -> EmailToken?
	func create(_ emailToken: EmailToken) async throws
	func delete(_ emailToken: EmailToken) async throws
	func find(userID: ObjectId) async throws -> EmailToken?
}

struct DatabaseEmailTokenRepository: EmailTokenRepository, DatabaseRepository {
	let database: MongoDatabase

	func find(token: String) async throws -> EmailToken? {
        let schema = database[EmailToken.collectionName]
        return try await schema.findOne("token" == token, as: EmailToken.self)
	}

	func create(_ emailToken: EmailToken) async throws {
        let schema = database[EmailToken.collectionName]
        try await schema.insertEncoded(emailToken)
	}

	func delete(_ emailToken: EmailToken) async throws {
        let schema = database[EmailToken.collectionName]
        try await schema.deleteOne(where: "_id" == emailToken._id)
	}

	func find(userID: ObjectId) async throws -> EmailToken? {
        let schema = database[EmailToken.collectionName]
        return try await schema.findOne("userId" == userID, as: EmailToken.self)
	}
}

extension Application.Repositories {
	var emailTokens: EmailTokenRepository {
		guard let factory = storage.makeEmailTokenRepository else {
			fatalError("EmailToken repository not configured, use: app.repositories.use")
		}
		return factory(app)
	}

	func use(_ make: @escaping (Application) -> (EmailTokenRepository)) {
		storage.makeEmailTokenRepository = make
	}
}
