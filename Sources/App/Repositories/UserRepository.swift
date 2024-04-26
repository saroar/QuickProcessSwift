import Vapor
import MongoKitten

protocol UserRepository: Repository {
	func create(_ user: UserModel) async throws
	func delete(id: ObjectId) async throws
	func all() async throws -> [UserModel]
	func find(id: ObjectId?) async throws -> UserModel?
	func find(email: String) async throws -> UserModel?
    func find(phoneNumber: String) async throws -> UserModel?
	//func set<Field>(_ field: KeyPath<UserModel, Field>, to value: Field.Value, for userID: ObjectId) async throws -> Void where Field: QueryableProperty, Field.Model == UserModel
	func count() async throws -> Int
}

struct DatabaseUserRepository: UserRepository, DatabaseRepository {
	let database: MongoDatabase

	func create(_ user: UserModel) async throws {
        let schema = database[UserModel.collectionName]
        try await schema.insertEncoded(user)
	}

	func delete(id: ObjectId) async throws {
        let schema = database[UserModel.collectionName]
        try await schema.deleteOne(where: "_id" == id)
	}

	func all()  async throws -> [UserModel] {
        let schema = database[UserModel.collectionName]
        return try await schema.find().decode(UserModel.self).drain()
	}

	func find(id: ObjectId?) async throws -> UserModel? {
        let schema = database[UserModel.collectionName]
        return try await schema.findOne("_id" == id, as: UserModel.self)
	}

    func find(phoneNumber: String) async throws -> UserModel? {
        let schema = database[UserModel.collectionName]
        return try await schema.findOne("phoneNumber" == phoneNumber, as: UserModel.self)
    }

	func find(email: String) async throws -> UserModel? {
        let schema = database[UserModel.collectionName]
        return try await schema.findOne("email" == email, as: UserModel.self)
	}

//	func set<Field>(_ field: KeyPath<UserModel, Field>, to value: Field.Value, for userID: ObjectId) async throws -> Void
//	where Field: QueryableProperty, Field.Model == UserModel
//	{
//		try await UserModel.query(on: database)
//			.filter(\.$id == userID)
//			.set(field, to: value)
//			.update()
//	}

	func count() async throws -> Int {
        return try await database[PasswordToken.collectionName].count()
	}
}

extension Application.Repositories {
	var users: UserRepository {
		guard let storage = storage.makeUserRepository else {
			fatalError("UserRepository not configured, use: app.userRepository.use()")
		}

		return storage(app)
	}

	func use(_ make: @escaping (Application) -> (UserRepository)) {
		storage.makeUserRepository = make
	}
}
