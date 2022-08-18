//
//  RoverType.swift
//  NasaApp
//
//  Created by Melih Ozden on 18.08.2022.
//

import Foundation

public enum RoverType: Int, Codable {
    case curiosity
    case opportunity
    case spirit
    case undefined
    
    static let mapper: [RoverType: String] = [
        .curiosity: "curiosity",
        .opportunity: "oppurtunity",
        .spirit: "spirit",
        .undefined: "undefined"
    ]
    
    public init(from decoder: Decoder) throws {
        self = try RoverType(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .undefined
    }
}
