//
//  ImageConvertible.swift
//  NasaApp
//
//  Created by Melih Ozden on 20.08.2022.
//

import Foundation
import UIKit

public protocol ImageConvertible {
    var bundle: Bundle { get }
    var imageName: String { get }
    var image: UIImage { get }
}

public extension ImageConvertible {
    var bundle: Bundle { ImageBundle.bundle}
    var imageName: String { "" }
    var image: UIImage { UIImage(image: self) ?? UIImage() }
}

extension UIImage {
    convenience init?(image: ImageConvertible) {
        self.init(named: image.imageName,
                  in: image.bundle,
                  compatibleWith: nil)
    }
}

public extension RawRepresentable where Self: ImageConvertible, RawValue == String {
    var imageName: String { rawValue }
}

extension String: ImageConvertible {
    public var imageName: String { self }
}

extension UIImage: ImageConvertible {
    public var image: UIImage { self }
}
