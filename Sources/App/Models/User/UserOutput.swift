//
//  User.swift
//  
//
//  Created by Saroar Khandoker on 12.10.2020.
//

import Foundation
import BSON

/// Dont have any role and language Need to combine with UserGetObject
public struct UserOutput: Codable, Identifiable {

    public var id: ObjectId
    public var fullName, phoneNumber, email: String?
    public var role: UserRole
    public var language: UserLanguage


    /// Date
    public var createdAt, updatedAt: Date?

    public var url: URL

    /// Init
    /// - Parameters:
    ///   - id: An ObjectId is a 12-byte unique identifier used in MongoDB to uniquely identify a document within a collection. It consists of a timestamp, a machine identifier, a process id, and a counter.
    ///   - fullName: String combine Firstname + Lastname
    ///   - email: Email
    ///   - phoneNumber: phoneNumber
    ///   - url: url description
    ///   - createdAt: createdAt its Date
    ///   - updatedAt: updatedAt its Date

    public init(
        id: ObjectId,
        fullName: String? = nil,
        email: String? = nil,
        phoneNumber: String? = nil,
        role: UserRole,
        language: UserLanguage,
        url: URL,
        createdAt: Date? = nil,
        updatedAt: Date? = nil
    ) {
        self.id = id
        self.fullName = fullName
        self.email = email
        self.phoneNumber = phoneNumber
        self.role = role
        self.language = language
        self.url = url
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
}


extension UserOutput: Equatable, Hashable {

    public func hash(into hasher: inout Hasher) {
      hasher.combine(id)
    }

    public static func == (lhs: UserOutput, rhs: UserOutput) -> Bool {
      return
        lhs.id == rhs.id 
        && lhs.email == rhs.email
        && lhs.fullName == rhs.fullName
    }
}
