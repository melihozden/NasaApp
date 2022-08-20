//
//  NasaService.swift
//  NasaApp
//
//  Created by Melih Ozden on 17.08.2022.
//

import Foundation
import Alamofire

class NasaService {
    let api = NasaApi()
    
    func getPhotos(roverType: RoverType, page: Int, completion: @escaping ([Photo]) -> ()) {
     
        guard let url = URL(string: "\(api.baseUrlRovers)/mars-photos/api/v1/rovers/\(roverType)/photos?sol=\(api.sol)&api_key=\(api.demoKey)&page=\(page)") else { return }
        
        AF.request(url, method: .get).responseDecodable(of: PhotoResponse.self) { response in
            switch response.result {
            case .success(let response):
                completion(response.photos)
            case .failure(let error):
                print(error)
            }
        }
    }
}
