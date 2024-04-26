import Vapor
import VFS_Bot

extension CountryMission: Content {}

struct MissionStartData: Content {
    var id: Int
    var countryCode: String
    var missionCode: String
    var requestSleepSec: Int
    var earliestDateRetrySec: Double
}

public func missionsHandler(
    request: Request,
    route: MissionsRoute
) async throws -> AsyncResponseEncodable {
    switch route {
        case .list:
            var tlsConfiguration = TLSConfiguration.makeClientConfiguration()
            tlsConfiguration.certificateVerification = .none

            var configuration = HTTPClient.Configuration(
                tlsConfiguration: tlsConfiguration,
                ignoreUncleanSSLShutdown: true
            )

            configuration.httpVersion = .http1Only
            configuration.decompression = .enabled(limit: .ratio(100))

            let httpClient = HTTPClient(
                eventLoopGroupProvider: .singleton,
                configuration: configuration
            )

            let networkService = NetworkService(httpClient: httpClient)

            let list: CountryMissions = try await networkService.request(
                endpoint: .missions,
                method: .GET,
                headers: [HTTPHeaderField.contentType.key: HTTPHeaderField.contentType.value]
            )

            let sortedList = list.sorted { $0.activeClientsCount > $1.activeClientsCount }
                .map { $0.newData() }

            return try await request.view.render("bot_list", ["missions": sortedList])

        case .start:
            if request.loggedIn == false { throw Abort(.unauthorized) }

            if request.payload.user.role != .superAdmin {
                throw Abort(.unauthorized)
            }

            let formData = try request.content.decode(MissionStartData.self)
            request.logger.info("Starting mission with ID: \(formData.id) Country Code: \(formData.countryCode) Mission Code: \(formData.missionCode)")

            // Parse the seconds input as Double first to handle fractional values
            let requestSleepSec = formData.requestSleepSec
            let nanoseconds = UInt64(formData.earliestDateRetrySec * 1_000_000_000)


            guard
                let countryCode = CountryCode(rawValue: formData.countryCode.lowercased()),
                let missionCode = CountryCode(rawValue: formData.missionCode.lowercased())
            else {
                request.logger.error("Missing CountryCode or MissionCode")
                return Response(status: .badRequest, body: .init(string: "Missing CountryCode/MissionCode"))
            }

            let httpClient = HTTPClient(eventLoopGroupProvider: .singleton)
            let networkService = NetworkService(httpClient: httpClient)


            let result = BotManager(
                requestSleepSec: requestSleepSec,
                nanoseconds: nanoseconds, // 1_000_000_000 1 sec
                caQuery: .init(countryCode: countryCode, missionCode: missionCode),
                networkService: networkService,
                telegramManager: .init(networkService: networkService)
            )


            Task {
               try await result.run()
            }

            return request.redirect(to: "/missions")

        case .stop:
            if request.loggedIn == false { throw Abort(.unauthorized) }

            if request.payload.user.role != .superAdmin {
                throw Abort(.unauthorized)
            }

            let formData = try request.content.decode(MissionStartData.self)
            request.logger.info("Ending mission with ID: \(formData.id) Country Code: \(formData.countryCode) Mission Code: \(formData.missionCode)")

            return request.redirect(to: "/bots")
    }
}
