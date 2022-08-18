//
//  ViewController.swift
//  NasaApp
//
//  Created by Melih Ozden on 16.08.2022.
//

import UIKit
import Kingfisher

class ViewController: UIViewController {
    
    @IBOutlet weak var photosCollectionView: UICollectionView!
    @IBOutlet weak var roverSegmentedControl: UISegmentedControl!
    
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
        presenter.getPhotos(roverType: .curiosity)
    }

// MARK: - Private Methods
    private func configureUI() {
        view.backgroundColor = .smokeBlack
        
        // Design CollectionView cells
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        
        layout.itemSize = CGSize(width: (view.frame.size.width / 2) - 2, height: (view.frame.size.width / 2) - 2)
        photosCollectionView!.collectionViewLayout = layout
        
        // Segmented Control
        roverSegmentedControl.backgroundColor = .lightGray
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
    
// MARK: - Action
    @IBAction func roverChanged(_ sender: Any) {
        searchController.searchBar.text = ""
        if let value = RoverType(rawValue: roverSegmentedControl.selectedSegmentIndex) {
            presenter.getPhotos(roverType: value)
        }
    }
}

// MARK: - Extension
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
        searchController.searchBar.searchTextField.textColor = .white
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UISearchResultsUpdating, UISearchBarDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isSearching ? filteredPhotos?.count ?? 0 : photos?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = photosCollectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.identifier, for: indexPath) as! PhotoCell
        cell.layer.cornerRadius = 5.0
        cell.photoImageView.contentMode = .scaleAspectFill
        
        if isSearching {
            cell.photoImageView.kf.setImage(with: URL(string: filteredPhotos?[indexPath.row].imageSource ?? ""),
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

