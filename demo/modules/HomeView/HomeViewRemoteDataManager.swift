//
//  HomeViewRemoteDataManager.swift
//  demo
//
//  Created by Maikel Ortega Hernandez on 10/04/21.
//  
//

import Foundation
import Alamofire

class HomeViewRemoteDataManager:HomeViewRemoteDataManagerInputProtocol {
    
    var remoteRequestHandler: HomeViewRemoteDataManagerOutputProtocol?
    
    func getHNFeedData(with page: Int?) {
    
        let parameters : [String: Any] = [
            "query": "mobile",
            "page" : page ?? 0
        ]
        
//        AF.request("https://hn.algolia.com/api/v1/search_by_date?query=mobile")
        AF.request("https://hn.algolia.com/api/v1/search_by_date", parameters: parameters)
            .validate(statusCode: 200..<299)
            .responseDecodable(of: Feed.self) { (response) in
                switch response.result {
                    case .success:
                        guard let feeds = response.value else {return}
                        self.remoteRequestHandler?.hackedNewCallbackFeedData(with:feeds)
                        break;
                case .failure(_):
                    print("error")
                    print(response.error?.errorDescription as Any)
                    break;
                }
            }
    }
    
}
