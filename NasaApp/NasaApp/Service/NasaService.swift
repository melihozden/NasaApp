//
//  NasaService.swift
//  NasaApp
//
//  Created by Melih Ozden on 17.08.2022.
//

import Foundation
import Alamofire

class NasaService {
    
    func getPhotos(roverType: RoverType, page: Int, completion: @escaping ([Photo]) -> ()) {
     
        guard let url = URL(string: "https://api.nasa.gov/mars-photos/api/v1/rovers/\(roverType)/photos?sol=1000&api_key=Q4GdvPFnMzJSdi9hqHmn4w8tr2wWHo7x9NuVuxVW&page=\(page)") else { return }
        
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
