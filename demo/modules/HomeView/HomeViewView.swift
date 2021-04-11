//
//  HomeViewView.swift
//  demo
//
//  Created by Maikel Ortega Hernandez on 10/04/21.
//  
//

import Foundation
import UIKit

class HomeViewView: UIViewController {

    var presenter: HomeViewPresenterProtocol?

    //referencias a objetos de la vista
    @IBOutlet weak var feedTable: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.viewDidLoad()
        self.navigationItem.title = "HN FEED"
    }
}

extension HomeViewView: HomeViewViewProtocol {
    // TODO: implement view output methods
}
