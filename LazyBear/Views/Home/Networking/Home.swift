//
//  Home.swift
//  LazyBear
//
//  Created by Dennis Concepción Martín on 11/4/21.
//

import SwiftUI
import Alamofire

class Home: ObservableObject {
    @Published var showView = false
    @Published var data = HomeResponse()
    
    func request(_ url: String, _ requestType: RequestType) {
        AF.request(url).responseDecodable(of: HomeResponse.self) { response in
            if let value = response.value {
                switch requestType {
                case .initial:
                    self.data = value
                default:
                    self.data.lists = value.lists
                    self.data.sectorPerformance = value.sectorPerformance
                }
                
                self.showView = true
            }
        }
    }
}
