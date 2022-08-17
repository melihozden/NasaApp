//
//  Camera.swift
//  NasaApp
//
//  Created by Melih Ozden on 17.08.2022.
//

import Foundation

struct Camera: Codable {
    let id: Int?
    let name: String?
    let roverId: Int?
    let fullName: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case roverId = "rover_id"
        case fullName = "full_name"
    }
}
