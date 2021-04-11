//
//  Post.swift
//  demo
//
//  Created by Maikel Ortega Hernandez on 11/04/21.
//

import Foundation

// MARK: - Feed
struct Feed: Codable {
    var hits: [Hit]
    var nbHits, page, nbPages, hitsPerPage: Int
    var exhaustiveNbHits: Bool
    var query: Query
    var params: String
    var processingTimeMS: Int
}

// MARK: - Hit
struct Hit: Codable {
    var createdAt: String
    var title: String?
    var url: JSONNull?
    var author: String
    var points: Int?
    var storyText, commentText: String?
    var numComments, storyID: Int?
    var storyTitle: String?
    var storyURL: String?
    var parentID: Int?
    var createdAtI: Int
    var tags: [String]
    var objectID: String
    var highlightResult: HighlightResult

    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case title, url, author, points
        case storyText = "story_text"
        case commentText = "comment_text"
        case numComments = "num_comments"
        case storyID = "story_id"
        case storyTitle = "story_title"
        case storyURL = "story_url"
        case parentID = "parent_id"
        case createdAtI = "created_at_i"
        case tags = "_tags"
        case objectID
        case highlightResult = "_highlightResult"
    }
}

// MARK: - HighlightResult
struct HighlightResult: Codable {
    var author: Author
    var commentText, storyTitle, storyURL, title: Author?
    var storyText: Author?

    enum CodingKeys: String, CodingKey {
        case author
        case commentText = "comment_text"
        case storyTitle = "story_title"
        case storyURL = "story_url"
        case title
        case storyText = "story_text"
    }
}

// MARK: - Author
struct Author: Codable {
    var value: String
    var matchLevel: MatchLevel
    var matchedWords: [Query]
    var fullyHighlighted: Bool?
}

enum MatchLevel: String, Codable {
    case full = "full"
    case none = "none"
}

enum Query: String, Codable {
    case mobile = "mobile"
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }
    
    public func hash(into hasher: inout Hasher) {
        
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
