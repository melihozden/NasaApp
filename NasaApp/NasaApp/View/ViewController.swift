//
//  ViewController.swift
//  NasaApp
//
//  Created by Melih Ozden on 16.08.2022.
//

import UIKit

class ViewController: UIViewController{
    
    

    private let presenter = NasaPresenter()
    private var photos: [Photo]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        // Presenter
        presenter.setDelegate(delegate: self)
        presenter.getPhotos()
    }
}

extension ViewController: NasaPresenterDelegate {
    func getPhotos(photos: [Photo]?) {
        self.photos = photos
    }
}

