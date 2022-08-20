//
//  Bundle+Extension.swift
//  NasaApp
//
//  Created by Melih Ozden on 20.08.2022.
//

import Foundation

public class ImageBundle {
    public static var bundle: Bundle {
        Bundle(for: Self.self)
    }
}
