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
    func presenterPushData(receivedData: PostFeed)
    func cargarActivity()
    func detenerActivity()
}

protocol HomeViewWireFrameProtocol: class {
    // PRESENTER -> WIREFRAME
    static func createHomeViewModule() -> UIViewController
    func presentDetailView(from view: UIViewController, withData: PostItem)
}

protocol HomeViewPresenterProtocol: class {
    // VIEW -> PRESENTER
    var view: HomeViewViewProtocol? { get set }
    var interactor: HomeViewInteractorInputProtocol? { get set }
    var wireFrame: HomeViewWireFrameProtocol? { get set }
    
    func viewDidLoad()
    func loadPageDetalle(with post:PostItem)
    func loadPageData(with page: Int)
}

protocol HomeViewInteractorOutputProtocol: class {
// INTERACTOR -> PRESENTER
    func interactorPushDataPresenter(with feed: PostFeed)
}

protocol HomeViewInteractorInputProtocol: class {
    // PRESENTER -> INTERACTOR
    var presenter: HomeViewInteractorOutputProtocol? { get set }
    var localDatamanager: HomeViewLocalDataManagerInputProtocol? { get set }
    var remoteDatamanager: HomeViewRemoteDataManagerInputProtocol? { get set }
    
    // para obtener los datos desde los data manager desde el presenter
    func interactorGetData(with page: Int?)
}

protocol HomeViewDataManagerInputProtocol: class {
    // INTERACTOR -> DATAMANAGER
}

protocol HomeViewRemoteDataManagerInputProtocol: class {
    // INTERACTOR -> REMOTEDATAMANAGER
    var remoteRequestHandler: HomeViewRemoteDataManagerOutputProtocol? { get set }
    func getHNFeedData(with page: Int?)
}

protocol HomeViewRemoteDataManagerOutputProtocol: class {
    // REMOTEDATAMANAGER -> INTERACTOR
    func hackedNewCallbackFeedData(with feed: Feed)
}

protocol HomeViewLocalDataManagerInputProtocol: class {
    // INTERACTOR -> LOCALDATAMANAGER
    var localRequestRemoteHandler: HomeViewLocalDataManagerOutputProtocol? { get set }
    func registerDataStack()
    
    // Se importan los post desde el remote data manager para el storage local teniendo en cuenta su ID para evitar duplicados
    func importPostItem(withData: PostItem)
    
    func loadPosts( with page: Int?)
}

protocol HomeViewLocalDataManagerOutputProtocol: class {
    func localPostDataCallback(with feed:PostFeed)
}
