//
//  DetailView.swift
//  demo
//
//  Created by Maikel Ortega Hernandez on 11/04/21.
//  
//

import Foundation
import UIKit
import WebKit


class DetailView: UIViewController {

    // MARK: Properties
    var presenter: DetailPresenterProtocol?
    @IBOutlet weak var navegador: WKWebView!
    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        self.navigationItem.title = "Detalle"
    }
}

extension DetailView: DetailViewProtocol {
    func loadDetalle(post: PostItem) {
        self.navegador.load(URLRequest(url: URL(string: post.url)!))
    }
    
    // TODO: implement view output methods
}
