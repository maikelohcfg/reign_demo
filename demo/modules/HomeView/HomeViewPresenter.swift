//
//  HomeViewPresenter.swift
//  demo
//
//  Created by Maikel Ortega Hernandez on 10/04/21.
//  
//

import Foundation

class HomeViewPresenter  {
    
    // MARK: Properties
    weak var view: HomeViewViewProtocol?
    var interactor: HomeViewInteractorInputProtocol?
    var wireFrame: HomeViewWireFrameProtocol?
    
}

extension HomeViewPresenter: HomeViewPresenterProtocol {
    func viewDidLoad() {
        //aqui le pido los datos al interactor
        interactor?.interactorGetData()
    }
}

extension HomeViewPresenter: HomeViewInteractorOutputProtocol {
    func interactorPushDataPresenter(with feed: PostFeed) {
        //recibi los datos filtrados y parseados del data manager
        self.view?.presenterPushData(receivedData: feed)
    }
}
