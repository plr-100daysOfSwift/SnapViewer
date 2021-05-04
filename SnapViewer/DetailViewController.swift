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

		print("Image: \(image)")
	}

}
