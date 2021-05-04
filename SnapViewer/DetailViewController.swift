//
//  DetailViewController.swift
//  SnapViewer
//
//  Created by Paul Richardson on 04/05/2021.
//

import UIKit

class DetailViewController: UIViewController {
	@IBOutlet var imageView: UIImageView!
	var name: String?
	var selectedImage: String?

	override func viewDidLoad() {
		super.viewDidLoad()

		title = name

		if let image = selectedImage {
			let imagePath = getDocumentsDirectory().appendingPathComponent(image)
			imageView.image = UIImage(contentsOfFile: imagePath.path)
		}

	}



}
