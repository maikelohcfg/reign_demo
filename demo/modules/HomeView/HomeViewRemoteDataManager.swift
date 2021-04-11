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
    
    func getHNFeedData() {
    
        AF.request("https://hn.algolia.com/api/v1/search_by_date?query=mobile")
            .validate(statusCode: 200..<299)
            .responseDecodable(of: Feed.self) { (response) in
                switch response.result {
                    case .success:
                        guard let feeds = response.value else {return}
                        self.remoteRequestHandler?.hackedNewCallbackFeedData(with: feeds)
                        print("aki")
                        break;
                case .failure(_):
                    print(response.error?.errorDescription)
                    print("error")
                }
            }
    }
    
}
