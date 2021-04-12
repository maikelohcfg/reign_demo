//
//  LocalPost.swift
//  demo
//
//  Created by Maikel Ortega Hernandez on 11/04/21.
// Local Core Data Model

import Foundation
import CoreStore

enum V1 {
    class LocalPost: CoreStoreObject, ImportableUniqueObject {
        
        static var uniqueIDKeyPath: String {
            return #keyPath(V1.LocalPost.storyId)
        }
        
        typealias UniqueIDType = Int
        
        typealias ImportSource = PostItem
        
        @Field.Stored("title")
        var title: String = ""
        
        @Field.Stored("createdAt", dynamicInitialValue: { Date() })
        var createdAt: Date
        
        @Field.Stored("author")
        var author: String = ""
        
        @objc @Field.Stored("storyId")
        var storyId: Int = 0
        
        @Field.Stored("url")
        var url: String = ""
        
        @Field.Stored("deleted")
        var deleted : Bool = false
        
        
        
        var uniqueIDValue: Int {
            get { return self.storyId }
            set { self.storyId = newValue }
        }
        class func uniqueID(from source: PostItem, in transaction: BaseDataTransaction) throws -> Int? {
            return source.storyId as Int
        }
        
        func update(from source: PostItem, in transaction: BaseDataTransaction) throws {
            
        }
        
        
        func didInsert(from source: PostItem, in transaction: BaseDataTransaction) throws {
            self.title     = source.title
            self.createdAt = source.createdAt.date
            self.author    = source.author
            self.storyId   = source.storyId
            self.url       = source.url
        }
    }
}
