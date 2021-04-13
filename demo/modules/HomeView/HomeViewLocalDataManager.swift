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

    var stack : DataStack = DataStack(
        CoreStoreSchema(
            modelVersion: "V1",
            entities: [
                Entity<LocalPost>("LocalPost")
            ],
            versionLock: [
                "LocalPost": [0x534826adb4fd67e4, 0x411f4bd6234ab3af, 0xc90c1dc0c8fe6039, 0xc67625a187139c34]
            ]
        ),
        migrationChain: ["V1"]
    )
    
    var localRequestRemoteHandler: HomeViewLocalDataManagerOutputProtocol?
    
    func registerDataStack() {
        //setup local core data

        let _ = self.stack.addStorage(
            SQLiteStore(fileName: "demo_reign.sqlite"),
            completion: { (result) -> Void in
                switch result {
                case .success( _):
                    print("added sqlite storage")

                case .failure(let error):
                    print("Error adding sqlite store with error: \(error)")
                }
            }
        )
//        CoreStoreDefaults.dataStack = self.stack!
    }
    
    func importPostItem(withData: PostItem) {
        self.stack.perform(
            asynchronous: { (transaction) -> Void in
                let _ = try! transaction.importUniqueObject(
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
                let localPosts = try self.stack.fetchAll(
                    From<LocalPost>()
                    .where(\.$markedDeleted == false)
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
        self.stack.perform(
            asynchronous: { (transaction) -> Void in
                let toDeletePost = try transaction.fetchOne(
                    From<LocalPost>()
                        .where(\.$storyId == post.storyId)
                )
                
                if(toDeletePost != nil){
                    toDeletePost!.markedDeleted =  true
                }
            },
            completion: { _ in
                
            }
        )
        
    }
    
    //check if post is already delete and ignore
    func postIsMarkedAsDeleteBefore(storyId: Int) -> Bool {
        do {
            let localPost = try self.stack.fetchOne(
                From<LocalPost>()
                    .where(\.$storyId == storyId )
                    .tweak {
                                $0.includesPendingChanges = true
                            }
            )
            let isDeleted = localPost?.markedDeleted ?? false
            return isDeleted
        } catch {
            return false
        }
        
    }
}
