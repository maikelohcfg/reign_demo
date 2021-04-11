//
//  HomeViewInteractor.swift
//  demo
//
//  Created by Maikel Ortega Hernandez on 10/04/21.
//  
//

import Foundation
import SwiftDate

class HomeViewInteractor: HomeViewInteractorInputProtocol {
    
    weak var presenter: HomeViewInteractorOutputProtocol?
    var localDatamanager: HomeViewLocalDataManagerInputProtocol?
    var remoteDatamanager: HomeViewRemoteDataManagerInputProtocol?
    
    func interactorGetData() {
        remoteDatamanager?.getHNFeedData()
    }
}

extension HomeViewInteractor: HomeViewRemoteDataManagerOutputProtocol {
    func hackedNewCallbackFeedData(with feed: Feed) {
        //obtengo la data del data manager y se lo paso al presenter
        var remoteFeed = PostFeed()
//        remoteFeed.nbHits =
        remoteFeed.page = feed.page
        remoteFeed.nbPages = feed.nbPages
        for item: Hit in feed.hits {
            if( item.storyTitle == nil && item.title == nil ){
                continue
            }
            
            if(item.storyID == nil || item.storyURL == nil){
                continue;
            }
            var feedItem       = PostItem()
            feedItem.title     = item.storyTitle ?? item.title!
            feedItem.createdAt = item.createdAt.toISODate()!
            feedItem.author    = item.author
            feedItem.storyId   = item.storyID!
            feedItem.url       = item.storyURL!
            remoteFeed.posts.append(feedItem)
        }
        
        remoteFeed.nbHits = remoteFeed.posts.count
        self.presenter?.interactorPushDataPresenter(with: remoteFeed)
    }
}
