//
//  ImageSet.swift
//  NasaApp
//
//  Created by Melih Ozden on 20.08.2022.
//

import Foundation

// Logo
public enum Logo: String, ImageConvertible {
    case logoWhite = "NasaWhiteLogo"
}

// Project Icons
public enum Icon: String, ImageConvertible {
    case camera = "camera"
    case close = "close"
    case landing = "landing"
    case launch = "launch"
    case noDataFound = "noDataFound"
}
