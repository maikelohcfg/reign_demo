//
//  HomeViewPresenter.swift
//  demo
//
//  Created by Maikel Ortega Hernandez on 10/04/21.
//  
//

import Foundation
import UIKit

class HomeViewPresenter  {
    
    // MARK: Properties
    weak var view: HomeViewViewProtocol?
    var interactor: HomeViewInteractorInputProtocol?
    var wireFrame: HomeViewWireFrameProtocol?
    
}

extension HomeViewPresenter: HomeViewPresenterProtocol {
    func viewDidLoad() {
        //aqui le pido los datos al interactor
        interactor?.interactorGetData(with: nil)
        view?.cargarActivity()
    }
    
    //para el paginado
    func loadPageData(with page: Int) {
        self.interactor?.interactorGetData(with: page)
    }
    
    //paso para la pagina de detalle
    func loadPageDetalle(with post: PostItem) {
        self.wireFrame?.presentDetailView(from: self.view as! UIViewController, withData: post)
    }
}

extension HomeViewPresenter: HomeViewInteractorOutputProtocol {
    func interactorPushDataPresenter(with feed: PostFeed) {
        //recibi los datos filtrados y parseados del data manager
        view?.detenerActivity()
        self.view?.presenterPushData(receivedData: feed)
    }
}
