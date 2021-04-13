//
//  HomeViewLocalDataManager.swift
//  demo
//
//  Created by Maikel Ortega Hernandez on 10/04/21.
//  
//

import Foundation
import CoreStore
import SwiftDate
typealias LocalPost = V1.LocalPost


class HomeViewLocalDataManager:HomeViewLocalDataManagerInputProtocol {

    static let stack: DataStack = {
        let stack = DataStack(
            CoreStoreSchema(
                modelVersion: "V1",
                entities: [
                    Entity<LocalPost>("LocalPost")
                ],
                versionLock: [
                    "LocalPost": [0x8760984b2f49c4c0, 0x8f2221539e237a60, 0xdf235422d3d8ff0, 0xadf8542e5f6cde5d]
                ]
            ),
            migrationChain: ["V1"]
        )
        try! stack.addStorageAndWait(
            SQLiteStore(
                fileName: "demo_reign.sqlite",
                localStorageOptions: .recreateStoreOnModelMismatch
            )
        )
        
        return stack
    }()
    
    var localRequestRemoteHandler: HomeViewLocalDataManagerOutputProtocol?
    
    func registerDataStack() {
        //setup local core data
    
//        self.stack = DataStack(
//            CoreStoreSchema(
//                modelVersion: "V1",
//                entities: [
//                    Entity<LocalPost>("LocalPost")
//                ],
//                versionLock: [
//                    "LocalPost": [0x8760984b2f49c4c0, 0x8f2221539e237a60, 0xdf235422d3d8ff0, 0xadf8542e5f6cde5d]
//                ]
//            ),
//            migrationChain: ["V1"]
//        )
//        let _ = self.stack!.addStorage(
//            SQLiteStore(fileName: "demo_reign"),
//            completion: { (result) -> Void in
//                switch result {
//                case .success( _):
//                    print("added sqlite storage")
//
//                case .failure(let error):
//                    print("Error adding sqlite store with error: \(error)")
//                }
//            }
//        )
//        CoreStoreDefaults.dataStack = self.stack!
//        //deleted publisher setup
//        self.deletedPublisher =  self.stack!.publishList(
//            From<LocalPost>()
//                .where(\.$deleted == true)
//        )
    }
    
    func importPostItem(withData: PostItem) {
        HomeViewLocalDataManager.stack.perform(
            asynchronous: { (transaction) -> Void in
                try! transaction.importUniqueObject(
                    Into<LocalPost>(),
                    source: withData
                )
            },
            completion: { _ in }
        )
    }
    
    func loadPosts(with page: Int?) {
        var feed   = PostFeed()
        feed.posts = []
        DispatchQueue.main.async {
            do {
                let localPosts = try HomeViewLocalDataManager.stack.fetchAll(
                    From<LocalPost>()
                    .where(\.$deleted == false)
                    .orderBy(.descending(\.$createdAt))
                )
                
                for localPost: LocalPost in localPosts {
                    var feedItem       = PostItem()
                    feedItem.title     = localPost.title
                    feedItem.createdAt = localPost.createdAt.inDefaultRegion()
                    feedItem.author    = localPost.author
                    feedItem.storyId   = localPost.storyId
                    feedItem.url       = localPost.url
                    feed.posts.append(feedItem)
                }
            } catch  {
                feed.posts =  []
            }
            feed.page = 0
            feed.nbHits = feed.posts.count
            feed.nbPages = 0
            self.localRequestRemoteHandler?.localPostDataCallback(with: feed)
        }
    }
    
    func markPostAsDeleted(post: PostItem) {
        HomeViewLocalDataManager.stack.perform(
            asynchronous: { (transaction) -> Void in
                let localPost = try transaction.fetchOne(
                    From<LocalPost>()
                        .where(\.$storyId == post.storyId)
                )
                localPost?.deleted = true
            },
            completion: { _ in }
        )
        
    }
    
    //check if post is already delete and ignore
    func postIsMarkedAsDeleteBefore(storyId: Int) -> Bool {
        do {
            let localPost = try HomeViewLocalDataManager.stack.fetchOne(
                From<LocalPost>()
                    .where(\.$storyId == storyId && \.$deleted == true)
                    .tweak {
                                $0.includesPendingChanges = true
                            }
            )
           return localPost != nil
        } catch {
            return false
        }
        
    }
}
