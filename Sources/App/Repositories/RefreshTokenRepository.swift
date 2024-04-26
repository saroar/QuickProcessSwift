import Vapor
import MongoKitten

protocol RefreshTokenRepository: Repository {
	func create(_ token: RefreshTokenModel) async throws -> Void
	func find(id: ObjectId?) async throws -> RefreshTokenModel?
	func find(token: String) async throws -> RefreshTokenModel?
	func delete(_ token: RefreshTokenModel) async throws -> Void
	func count() async throws -> Int
	func delete(for userID: ObjectId) async throws -> Void
}

struct DatabaseRefreshTokenRepository: RefreshTokenRepository, DatabaseRepository {
	let database: MongoDatabase

	func create(_ token: RefreshTokenModel) async throws {
        let schema = database[RefreshTokenModel.collectionName]
        try await schema.insertEncoded(token)
	}

	func find(id: ObjectId?) async throws -> RefreshTokenModel? {
        let schema = database[RefreshTokenModel.collectionName]
        return try await schema.findOne("_id" == id, as: RefreshTokenModel.self)
	}

	func find(token: String) async throws -> RefreshTokenModel? {
        let schema = database[RefreshTokenModel.collectionName]
        return try await schema.findOne("token" == token, as: RefreshTokenModel.self)
	}

	func delete(_ token: RefreshTokenModel) async throws {
        let schema = database[RefreshTokenModel.collectionName]
        try await schema.deleteOne(where: "token" == token.token)
	}

	func count() async throws -> Int {
        let schema = database[RefreshTokenModel.collectionName]
        return try await schema.count()
	}

	func delete(for userID: ObjectId) async throws {
        let schema = database[RefreshTokenModel.collectionName]
        try await schema.deleteOne(where: "_id" == userID)
	}
}

extension Application.Repositories {
	var refreshTokens: RefreshTokenRepository {
		guard let factory = storage.makeRefreshTokenRepository else {
			fatalError("RefreshToken repository not configured, use: app.repositories.use")
		}
		return factory(app)
	}

	func use(_ make: @escaping (Application) -> (RefreshTokenRepository)) {
		storage.makeRefreshTokenRepository = make
	}
}
