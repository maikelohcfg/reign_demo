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

    var localRequestRemoteHandler: HomeViewLocalDataManagerOutputProtocol?
    
    func registerDataStack() {
        //setup local core data
    
        let stack = DataStack(
            CoreStoreSchema(
                modelVersion: "V1",
                entities: [
                    Entity<LocalPost>("LocalPost")
                ],
                versionLock: [
                    "LocalPost": [0xed31bd7501b366bc, 0xc62c5ff125c3337b, 0x44b84155f1b0d86f, 0x378f89d8ebb1903d]
                ]
            ),
            migrationChain: ["V1"]
        )
        let _ = stack.addStorage(
            SQLiteStore(fileName: "demo_reign"),
            completion: { (result) -> Void in
                switch result {
                case .success( _):
                        print("added sqlite storage")
                case .failure(let error):
                    print("Error adding sqlite store with error: \(error)")
                }
            }
        )
        CoreStoreDefaults.dataStack = stack
    }
    
    func importPostItem(withData: PostItem) {
        CoreStoreDefaults.dataStack.perform(
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
                let localPosts = try CoreStoreDefaults.dataStack.fetchAll(
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
}
