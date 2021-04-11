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

class HomeViewView: UIViewController {

    var presenter: HomeViewPresenterProtocol?
    var feed = PostFeed()

    //referencias a objetos de la vista
    @IBOutlet weak var feedTable: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        self.navigationItem.title = "HN FEED"
        self.feedTable.rowHeight = UITableView.automaticDimension
        self.feedTable.estimatedRowHeight = 200
    }
}

extension HomeViewView: HomeViewViewProtocol {
    
    // obtengo los datos y recargo la tabla
    func presenterPushData(receivedData: PostFeed) {
        self.feed = receivedData
        self.feedTable.reloadData()
    }
    
    func cargarActivity() {
        self.loadingIndicator.startAnimating()
    }
    
    func detenerActivity() {
        self.loadingIndicator.stopAnimating()
        self.loadingIndicator.hidesWhenStopped = true
    }
}

extension HomeViewView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.feed.nbHits
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedItem", for: indexPath) as! FeedItemTableViewCell
        let post = self.feed.posts[indexPath.row]
        var style = RelativeFormatter.defaultStyle()
        style.flavours = [RelativeFormatter.Flavour.quantify]
        
        cell.nombreLabel.text = post.title
        cell.fechaLabel.text  = post.createdAt.toRelative(since: nil, style: style, locale: Locales.spanish)
        cell.authorLabel.text = post.author
        return cell;
    }
    
    
}

extension HomeViewView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = self.feed.posts[indexPath.row]
        self.presenter?.loadPageDetalle(with: post)
    }
}
