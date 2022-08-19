//
//  DetailViewController.swift
//  NasaApp
//
//  Created by Melih Ozden on 19.08.2022.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var photoTakenDateLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var roverNameLabel: UILabel!
    @IBOutlet weak var cameraNameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var launchDateLabel: UILabel!
    @IBOutlet weak var landingDateLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var contentView: UIView!
    
    public var detailPresenter = DetailPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        definesPresentationContext = true
        configureUI()
    }
    
    private func configureUI() {
        contentView.layer.cornerRadius = 5.0
        photoImageView.layer.cornerRadius = 5.0
        
        photoTakenDateLabel.text = detailPresenter.selectedPhoto?.earthDate
        photoImageView.kf.setImage(with: URL(string: detailPresenter.selectedPhoto?.imageSource ?? ""))
        roverNameLabel.text = detailPresenter.selectedPhoto?.rover?.name
        cameraNameLabel.text = "(\(detailPresenter.selectedPhoto?.camera?.name ?? "")) \(detailPresenter.selectedPhoto?.camera?.fullName ?? "")"
        statusLabel.text = "Status: \(detailPresenter.selectedPhoto?.rover?.status ?? "")"
        statusLabel.textColor = detailPresenter.selectedPhoto?.rover?.status == "active" ? .green : .blue
        
        launchDateLabel.text = detailPresenter.selectedPhoto?.rover?.launchDate
        landingDateLabel.text = detailPresenter.selectedPhoto?.rover?.landingDate
    }
    
    // MARK: - Action
    @IBAction func closeButtonTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
