//
//  NasaPresenter.swift
//  NasaApp
//
//  Created by Melih Ozden on 17.08.2022.
//

import Foundation

protocol NasaPresenterDelegate: AnyObject {
    func getPhotos(photos: [Photo])
}

typealias PresenterDelegate = NasaPresenterDelegate

class NasaPresenter {
    
    // weak bcs prevent strong reference
    weak var delegate: PresenterDelegate?
    var nasaService = NasaService()
    var page = 1
    var selectedPhoto: Photo?

    // MARK: - ServiceCalls
    func getPhotos(roverType: RoverType, page: Int = 1) {
        nasaService.getPhotos(roverType: roverType, page: page, completion: { result in
            self.delegate?.getPhotos(photos: result)
        })
    }
    
    // MARK: - Public Methods
    public func setDelegate(delegate: PresenterDelegate) {
        self.delegate = delegate
    }
}
