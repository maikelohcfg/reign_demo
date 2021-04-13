//
//  HomeViewView.swift
//  demo
//
//  Created by Maikel Ortega Hernandez on 10/04/21.
//  
//

import Foundation
import UIKit
import SwiftDate

class HomeViewView: UITableViewController {

    var presenter: HomeViewPresenterProtocol?
    var feed = PostFeed()

    //referencias a objetos de la vista
    @IBOutlet weak var feedTable: UITableView!
    @IBOutlet weak var loading: UIRefreshControl!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        self.navigationItem.title = "HN FEED"
        self.feedTable.rowHeight = UITableView.automaticDimension
        self.feedTable.estimatedRowHeight = 200
    }
    
    @IBAction func pullAndRefresh(_ sender: UIRefreshControl) {
        self.feed.page += 1
        if( self.feed.page > self.feed.nbPages ){
            self.loading.endRefreshing()
            return
        }
        self.presenter?.loadPageData(with: self.feed.page)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.feed.nbHits
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedItem", for: indexPath) as! FeedItemTableViewCell
        let post = self.feed.posts[indexPath.row]
        var style = RelativeFormatter.defaultStyle()
        style.flavours = [RelativeFormatter.Flavour.quantify]
        
        cell.nombreLabel.text = post.title
        cell.fechaLabel.text  = post.createdAt.isYesterday ? "Ayer" : post.createdAt.toRelative(since: nil, style: style, locale: Locales.spanish)
        cell.authorLabel.text = post.author
        return cell;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = self.feed.posts[indexPath.row]
        self.presenter?.loadPageDetalle(with: post)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let post = feed.posts.remove(at: indexPath.row)
            self.presenter?.markPostAsDeleted(post: post, index: indexPath.row)
            feed.nbHits -= 1
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
            print("deleted row")
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
}

extension HomeViewView: HomeViewViewProtocol {
    
    // obtengo los datos y recargo la tabla
    func presenterPushData(receivedData: PostFeed) {
        self.feed = receivedData
        self.feedTable.reloadData()
    }
    
    func cargarActivity() {
        
    }
    
    func detenerActivity() {
        self.loading.endRefreshing()
    }
}
