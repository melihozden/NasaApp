//
//  Photo.swift
//  NasaApp
//
//  Created by Melih Ozden on 17.08.2022.
//

import Foundation

struct Photo: Codable {
    let id: Int?
    let sol: Int?
    let imageSource: String?
    let earthDate: String?
    let camera: Camera?
    let rover: Rover?
    
    enum CodingKeys: String, CodingKey {
        case id
        case sol
        case imageSource = "img_src"
        case earthDate = "earth_date"
        case camera
        case rover
    }
}
