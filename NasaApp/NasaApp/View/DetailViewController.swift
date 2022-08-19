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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
