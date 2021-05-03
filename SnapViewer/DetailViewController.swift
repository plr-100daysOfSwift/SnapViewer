//
//  DetailViewController.swift
//  SnapViewer
//
//  Created by Paul Richardson on 04/05/2021.
//

import UIKit

class DetailViewController: UIViewController {

	var name: String?
	var image: String?

	override func viewDidLoad() {
		super.viewDidLoad()

		title = name

		print("Image: \(image)")
	}

}
