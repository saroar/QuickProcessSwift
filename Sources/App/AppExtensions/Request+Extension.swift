//
//  Request+Extension.swift
//  
//
//  Created by Alif on 7/6/20.
//

import Vapor
import MongoQueue
import MongoKitten

extension Request {
    public var mongoDB: MongoDatabase {
        return application.mongoDB.adoptingLogMetadata([
            "request-id": .string(id)
        ])
    }

    public var mongoQueue: MongoQueue {
        return application.mongoQueue
    }
}

extension Request {
    func isAuthorized(_ userId: ObjectId) throws {
        if payload.user._id != userId {
            throw Abort(.unauthorized, reason: "\(#line) not authorized")
        }
    }
}
