//
//  NasaPresenter.swift
//  NasaApp
//
//  Created by Melih Ozden on 17.08.2022.
//

import Foundation

protocol NasaPresenterDelegate: AnyObject {
    func getPhotos(photos: [Photo]?)
}

typealias PresenterDelegate = NasaPresenterDelegate

class NasaPresenter {
    
    // weak bcs prevent strong reference
    weak var delegate: PresenterDelegate?
    var nasaService = NasaService()

    func getPhotos(roverType: RoverType) {
        nasaService.getPhotos(roverType: roverType, completion: { result in
            self.delegate?.getPhotos(photos: result)
        })
    }
    
    public func setDelegate(delegate: PresenterDelegate) {
        self.delegate = delegate
    }
}
