
import Vapor

extension Application {
    // configures your application
    public func setupDatabaseConnections(_ connectionString: inout String) {

        let environmentNameUppercased = environment.name.uppercased()

        switch environment {

        case .production:
            guard let mongoURL = Environment.get("MONGO_DB_\(environmentNameUppercased)_URL") else {
                fatalError("No MongoDB connection string is available in .env.production")
            }
            connectionString = mongoURL

        case .development:
            guard let mongoURL = Environment.get("MONGO_DB_\(environmentNameUppercased)_URL") else {
                fatalError("\(#line) No MongoDB connection string is available in .env.development")
            }
            connectionString = mongoURL
            self.logger.info("\(#line) mongoURL: \(connectionString)")

        case .testing:
            self.logger.info("\(#line) MONGO_DB_\(environmentNameUppercased)_URL")
            guard let mongoURL = Environment.get("MONGO_DB_\(environmentNameUppercased)_URL") else {
                fatalError("\(#line) No MongoDB connection string is available in .env.testing")
            }
            connectionString = mongoURL
            self.logger.info("\(#line) MONGO_DB_\(environmentNameUppercased)_URL mongoURL: \(connectionString) ")

        default:
            guard let mongoURL = Environment.get("MONGO_DB_\(environmentNameUppercased)_URL") else {
                fatalError("No MongoDB connection string is available in .env.development")
            }
            connectionString = mongoURL
            self.logger.info("\(#line) mongoURL: \(connectionString)")
        }
    }

    public func setupHostAndPort() {
        switch environment {
        case .production:
            http.server.configuration.hostname = "0.0.0.0"
            http.server.configuration.port = 8181

        case .testing:
            http.server.configuration.port = 8183
            http.server.configuration.hostname = "0.0.0.0"

        case .development:
            http.server.configuration.port = 8181
            http.server.configuration.hostname = "0.0.0.0"

            //_ = try await FakeGenerate.createUserAttactment(db: mongoDB)
        default:
            http.server.configuration.port = 8181
            http.server.configuration.hostname = "0.0.0.0"

        }
    }


}
