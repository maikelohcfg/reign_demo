//
//  HomeViewProtocols.swift
//  demo
//
//  Created by Maikel Ortega Hernandez on 10/04/21.
//  
//

import Foundation
import UIKit

protocol HomeViewViewProtocol: class {
    // PRESENTER -> VIEW
    var presenter: HomeViewPresenterProtocol? { get set }
}

protocol HomeViewWireFrameProtocol: class {
    // PRESENTER -> WIREFRAME
    static func createHomeViewModule() -> UIViewController
}

protocol HomeViewPresenterProtocol: class {
    // VIEW -> PRESENTER
    var view: HomeViewViewProtocol? { get set }
    var interactor: HomeViewInteractorInputProtocol? { get set }
    var wireFrame: HomeViewWireFrameProtocol? { get set }
    
    func viewDidLoad()
}

protocol HomeViewInteractorOutputProtocol: class {
// INTERACTOR -> PRESENTER
}

protocol HomeViewInteractorInputProtocol: class {
    // PRESENTER -> INTERACTOR
    var presenter: HomeViewInteractorOutputProtocol? { get set }
    var localDatamanager: HomeViewLocalDataManagerInputProtocol? { get set }
    var remoteDatamanager: HomeViewRemoteDataManagerInputProtocol? { get set }
    
    // para obtener los datos desde los data manager desde el presenter
    func interactorGetData()
}

protocol HomeViewDataManagerInputProtocol: class {
    // INTERACTOR -> DATAMANAGER
}

protocol HomeViewRemoteDataManagerInputProtocol: class {
    // INTERACTOR -> REMOTEDATAMANAGER
    var remoteRequestHandler: HomeViewRemoteDataManagerOutputProtocol? { get set }
    func getHNFeedData()
}

protocol HomeViewRemoteDataManagerOutputProtocol: class {
    // REMOTEDATAMANAGER -> INTERACTOR
    func hackedNewCallbackFeedData(with feed: Feed)
}

protocol HomeViewLocalDataManagerInputProtocol: class {
    // INTERACTOR -> LOCALDATAMANAGER
}
