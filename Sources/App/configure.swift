import Leaf
import Vapor
import IkigaJSON

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    app.views.use(.leaf)

    app.middleware.use(CORSMiddleware())

    // how i can check if request coming from web or ios client
    app.middleware.use(JWTMiddleware())

    // MARK: JWT
    app.passwords.use(.bcrypt)
    // Add HMAC with SHA-256 signer.
    let environmentNameUppercased = app.environment.name.uppercased()
    let jwtSecret = Environment.get("JWT_SECRET_" + environmentNameUppercased) ?? String.random(length: 64)
    app.jwt.signers.use(.hs256(key: jwtSecret))

    // MARK: Setup MongoDB
    var connectionString: String = ""
    app.setupDatabaseConnections(&connectionString)
    try app.initializeMongoDB(connectionString: connectionString)


    // MARK: Mailgun
    app.mailgun.configuration = .environment
    app.mailgun.defaultDomain = .productoin

    // MARK: MongoQueues
    app.initializeMongoQueue()
    try mongoQueue(app)

    AppConfig.env = app.environment
    app.config = AppConfig.environment

    let decoder = IkigaJSONDecoder()
    decoder.settings.dateDecodingStrategy = .iso8601
    ContentConfiguration.global.use(decoder: decoder, for: .json)

    var encoder = IkigaJSONEncoder()
    encoder.settings.dateEncodingStrategy = .iso8601
    ContentConfiguration.global.use(encoder: encoder, for: .json)


    // MARK: Services
    app.randomGenerators.use(.random)
    app.repositories.use(.database)

    // register routes
    try routes(app)

    let baseURL = "http://\(app.http.server.configuration.hostname):\(app.http.server.configuration.port)"

    app.router = SiteRouter()
        .baseURL(baseURL)
        .eraseToAnyParserPrinter()

    app.mount(app.router, use: siteHandler)
}

func dateFormatter() -> DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    return formatter
}
