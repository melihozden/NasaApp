//
//  ViewController.swift
//  NasaApp
//
//  Created by Melih Ozden on 16.08.2022.
//

import UIKit
import Kingfisher
import NVActivityIndicatorView

class ViewController: UIViewController {
    
    @IBOutlet weak var photosCollectionView: UICollectionView!
    @IBOutlet weak var roverSegmentedControl: UISegmentedControl!
    @IBOutlet weak var noPhotoView: UIView!
    @IBOutlet weak var noPhotoImageView: UIImageView!
    
    let searchController = UISearchController(searchResultsController: nil)
    public var presenter = NasaPresenter()
    private var photos: [Photo] = []
    private var filteredPhotos: [Photo] = []
    private var isSearching: Bool = false
    private let indicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50), type: .ballTrianglePath, color: .white, padding: 0)
    private let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        photosCollectionView.backgroundColor = .smokeBlack;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup
        configureUI()
        configureSearchController()
        setupNavBar()
        
        // Presenter
        presenter.setDelegate(delegate: self)
        
        // Indicator
        indicator.startAnimating()
        userInteraction(false)
        
        // Service Call
        presenter.getPhotos(roverType: .curiosity)
    }

// MARK: - Private Methods
    private func configureUI() {
        view.backgroundColor = .smokeBlack
        noPhotoView.isHidden = true
        noPhotoImageView.image = Icon.noDataFound.image
        
        // Design CollectionView cells
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        
        layout.itemSize = CGSize(width: (view.frame.size.width / 2) - 2, height: (view.frame.size.width / 2) - 2)
        photosCollectionView!.collectionViewLayout = layout
        
        // Segmented Control
        roverSegmentedControl.backgroundColor = .lightGray
        roverSegmentedControl.selectedSegmentTintColor = .smokeWhite
        roverSegmentedControl.setTitleTextAttributes([.foregroundColor: UIColor.smokeBlack], for: .normal)
        
        // LoadingIndicator
        view.addSubview(indicator)
        indicator.center = self.view.center
    }
    
    private func setupNavBar(){
        UINavigationBar.appearance().isTranslucent = true
        
        self.navigationItem.title = ""
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 30))
        imageView.contentMode = .scaleAspectFit
        
        let image = Logo.logoWhite.image
        imageView.layer.cornerRadius = 5.0
        imageView.image = image
        
        navigationItem.titleView = imageView
    }
    
    private func userInteraction(_ set: Bool) {
        searchController.searchBar.isUserInteractionEnabled = set
        view.isUserInteractionEnabled = set
    }
    
// MARK: - Action
    @IBAction func roverChanged(_ sender: Any) {
        searchController.searchBar.text = ""
        presenter.page = 1 // refresh the page count when tabbed changed.
        if let roverType = RoverType(rawValue: roverSegmentedControl.selectedSegmentIndex) {
            photos.removeAll()
            indicator.startAnimating()
            userInteraction(false)
            presenter.getPhotos(roverType: roverType)
        }
    }
}

// MARK: - Extension
extension ViewController: NasaPresenterDelegate {
    func getPhotos(photos: [Photo]) {
        self.photos.append(contentsOf: photos)
        
        indicator.stopAnimating()
        userInteraction(true)
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.presenter.page += 1
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
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
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
        return isSearching ? filteredPhotos.count : photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = photosCollectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.identifier, for: indexPath) as! PhotoCell
        cell.layer.cornerRadius = 5.0
        cell.photoImageView.contentMode = .scaleAspectFill
        
        if isSearching {
            cell.photoImageView.kf.setImage(with: URL(string: filteredPhotos[indexPath.row].imageSource ?? ""),
                                            options: [
                                                .scaleFactor(UIScreen.main.scale),
                                                .transition(.fade(1)),
                                                .cacheOriginalImage
                                            ])
        } else {
            cell.photoImageView.kf.setImage(with: URL(string: photos[indexPath.row].imageSource ?? ""),
                                            options: [
                                                .scaleFactor(UIScreen.main.scale),
                                                .transition(.fade(1)),
                                                .cacheOriginalImage
                                            ])
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = mainStoryboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        
        if isSearching == true {
            detailVC.detailPresenter.selectedPhoto = filteredPhotos[indexPath.row]
        } else {
            detailVC.detailPresenter.selectedPhoto = photos[indexPath.row]
        }
        
        if searchController.isActive {
            self.searchController.dismiss(animated: false) {
                detailVC.modalPresentationStyle = .overCurrentContext
                detailVC.modalTransitionStyle = .crossDissolve
                self.present(detailVC, animated: true)
            }
        } else {
            detailVC.modalPresentationStyle = .overCurrentContext
            detailVC.modalTransitionStyle = .crossDissolve
            self.present(detailVC, animated: true)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offSetY = scrollView.contentOffset.y
        let height = scrollView.contentSize.height
        
        if offSetY > height - scrollView.frame.size.height {
            if let value = RoverType(rawValue: roverSegmentedControl.selectedSegmentIndex) {
                indicator.startAnimating()
                presenter.getPhotos(roverType: value, page: presenter.page)
            }
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text!
        if !searchText.isEmpty {
            isSearching = true
            filteredPhotos.removeAll()
            for photo in photos {
                if (photo.camera?.fullName?.lowercased().contains(searchText.lowercased()) == true) {
                    filteredPhotos.append(photo)
                }
            }
        } else {
            isSearching = false
            filteredPhotos.removeAll()
            filteredPhotos = photos
        }
        photosCollectionView.reloadData()
        noPhotoView.isHidden = !filteredPhotos.isEmpty
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        filteredPhotos.removeAll()
        photosCollectionView.reloadData()
    }
}

