//
//  Rover.swift
//  NasaApp
//
//  Created by Melih Ozden on 17.08.2022.
//

import Foundation

struct Rover: Codable {
    let id: Int?
    let name: String?
    let landingDate: String?
    let launchDate: String?
    let status: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case landingDate = "landing_date"
        case launchDate = "launch_date"
        case status
    }
}
