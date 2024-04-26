import Vapor
import MongoKitten

public struct BlockListModel: Codable {

    public static var collectionName = "block_lists"

    public init(
        _id: ObjectId?,
        ownerID: ObjectId,
        blockUserIDs: Set<[ObjectId]>
    ) {
        self._id = _id
        self.ownerID = ownerID
        self.blockUserIDs = blockUserIDs
    }

    public var _id: ObjectId?
    public var ownerID: ObjectId
    public var blockUserIDs: Set<[ObjectId]>

    public var createdAt: Date?
    public var updatedAt: Date?
    public var deletedAt: Date?

    public func toBSON() throws -> Document {
        let encoder = BSONEncoder()
        let bson = try encoder.encode(self)
        return bson
    }
}

extension BlockListModel: Content {}

extension BlockListModel {
    static func query(_ request: Request) -> MongoCollection {
        return request.application.mongoDB[Self.collectionName]
    }
}
