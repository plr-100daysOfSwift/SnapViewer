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
		navigationItem.largeTitleDisplayMode = .never

		if let image = selectedImage {
			let imagePath = getDocumentsDirectory().appendingPathComponent(image)
			imageView.image = UIImage(contentsOfFile: imagePath.path)
		}

	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationController?.hidesBarsOnTap = true
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		navigationController?.hidesBarsOnTap = false
	}

}
