//
//  ViewController.swift
//  SnapViewer
//
//  Created by Paul Richardson on 04/05/2021.
//

import UIKit

class ViewController: UITableViewController {

	override func viewDidLoad() {
		super.viewDidLoad()

		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addSnap))
	}

	@objc func addSnap() {
		print("adding snap")
	}

}

