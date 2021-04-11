//
//  ViewModels.swift
//  demo
//
//  Created by Maikel Ortega Hernandez on 11/04/21.
//

import Foundation
import SwiftDate

// MARK: - PostFeed
struct PostFeed  {
    var posts: [PostItem] = []
    var nbHits: Int = 0
    var page: Int = 0
    var nbPages: Int = 0
    var hitsPerPage: Int = 0
}

// MARK: - PostItem
struct PostItem  {
    var title: String = ""
    var createdAt: DateInRegion = DateInRegion()
    var author: String = ""
    var storyId: Int = 0
    var url: String = ""
}
