//
//  ViewController.swift
//  NasaApp
//
//  Created by Melih Ozden on 16.08.2022.
//

import UIKit
import Kingfisher

class ViewController: UIViewController{

    @IBOutlet weak var photosCollectionView: UICollectionView!
    let searchController = UISearchController(searchResultsController: nil)
    private let presenter = NasaPresenter()
    private var photos: [Photo]?
    private var filteredPhotos: [Photo]?
    private var isSearching: Bool = false
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        photosCollectionView.backgroundColor = .smokeBlack;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        configureUI()
        configureSearchController()
        setupNavBar()
        // Presenter
        presenter.setDelegate(delegate: self)
        presenter.getPhotos()
    }
    
    private func configureUI() {
        view.backgroundColor = .smokeBlack
        
        // Design CollectionView cells
        let design:UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let width = self.photosCollectionView.frame.size.width    // for iPhone 13 it's 414
        
        design.sectionInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
        design.minimumLineSpacing = 5
        design.minimumInteritemSpacing = 5
        
        let cellWidth = (width-40) / 2
        
        design.itemSize = CGSize(width: cellWidth, height: cellWidth)
        
        photosCollectionView!.collectionViewLayout = design
        
    }
    
    private func setupNavBar(){
        UINavigationBar.appearance().isTranslucent = true
        
        self.navigationItem.title = ""
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 30))
        imageView.contentMode = .scaleAspectFit
        
        let image = UIImage(named: "NasaLogo")
        imageView.layer.cornerRadius = 5.0
        imageView.image = image
        
        navigationItem.titleView = imageView
    }
}

extension ViewController: NasaPresenterDelegate {
    func getPhotos(photos: [Photo]?) {
        self.photos = photos
        
        DispatchQueue.main.async {
            self.photosCollectionView.reloadData()
        }
    }
}

extension ViewController {
    private func configureSearchController() {
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType = UIReturnKeyType.default
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        searchController.searchBar.placeholder = "Search Camera"
        searchController.hidesNavigationBarDuringPresentation = false
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UISearchResultsUpdating, UISearchBarDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return isSearching ? filteredPhotos?.count ?? 0 : photos?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = photosCollectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoCell
        
        cell.photoImageView.kf.indicatorType = .activity
        if isSearching {
            cell.photoImageView.kf.setImage(with: URL(string: filteredPhotos?[indexPath.row].imageSource ?? ""),
                                            placeholder: UIImage(named: "NasaLogo"),
                                            options: [
                                                .scaleFactor(UIScreen.main.scale),
                                                .transition(.fade(1)),
                                                .cacheOriginalImage
                                            ])
        } else {
            cell.photoImageView.kf.setImage(with: URL(string: photos?[indexPath.row].imageSource ?? ""),
                                            options: [
                                                .scaleFactor(UIScreen.main.scale),
                                                .transition(.fade(1)),
                                                .cacheOriginalImage
                                            ])
        }
        return cell
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text!
        if !searchText.isEmpty {
            isSearching = true
            filteredPhotos?.removeAll()
            for photo in photos ?? [] {
                if (photo.camera?.fullName?.lowercased().contains(searchText.lowercased()) == true) {
                    filteredPhotos?.append(photo)
                }
            }
            
        } else {
            isSearching = false
            filteredPhotos?.removeAll()
            filteredPhotos = photos
        }
        photosCollectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        filteredPhotos?.removeAll()
        photosCollectionView.reloadData()
    }
}

