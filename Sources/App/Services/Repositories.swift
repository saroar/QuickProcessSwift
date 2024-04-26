import Vapor
import MongoKitten

protocol Repository: RequestService {}

protocol DatabaseRepository: Repository {
	var database: MongoDatabase { get }
	init(database: MongoDatabase)
}

extension DatabaseRepository {
	func `for`(_ req: Request) -> Self {
		return Self.init(database: req.mongoDB)
	}
}

extension Application {
	struct Repositories {
		struct Provider {
			static var database: Self {
				.init {
                    $0.repositories.use { DatabaseUserRepository(database: $0.mongoDB ) }
					$0.repositories.use { DatabaseEmailTokenRepository(database: $0.mongoDB) }
					$0.repositories.use { DatabaseRefreshTokenRepository(database: $0.mongoDB) }
					$0.repositories.use { DatabasePasswordTokenRepository(database: $0.mongoDB) }
				}
			}
			
			let run: (Application) -> ()
		}
		
		final class Storage {
			var makeUserRepository: ((Application) -> UserRepository)?
			var makeEmailTokenRepository: ((Application) -> EmailTokenRepository)?
			var makeRefreshTokenRepository: ((Application) -> RefreshTokenRepository)?
			var makePasswordTokenRepository: ((Application) -> PasswordTokenRepository)?
			init() { }
		}
		
		struct Key: StorageKey {
			typealias Value = Storage
		}
		
		let app: Application
		
		func use(_ provider: Provider) {
			provider.run(app)
		}
		
		var storage: Storage {
			if app.storage[Key.self] == nil {
				app.storage[Key.self] = .init()
			}
			
			return app.storage[Key.self]!
		}
	}
	
	var repositories: Repositories {
		.init(app: self)
	}
}
