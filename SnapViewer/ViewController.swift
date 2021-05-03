//
//  ViewController.swift
//  SnapViewer
//
//  Created by Paul Richardson on 04/05/2021.
//

import UIKit

class ViewController: UITableViewController {

	var snaps = [Snap]()

	override func viewDidLoad() {
		super.viewDidLoad()

		title = "SnapViewer"

		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addSnap))

		let snap = Snap(name: "foo", image: "bar")
		snaps.append(snap)
		tableView.reloadData()
	}

	@objc func addSnap() {
		let picker = UIImagePickerController()
		picker.delegate = self
		if UIImagePickerController.isSourceTypeAvailable(.camera) {
			picker.sourceType = .camera
		}
		picker.allowsEditing = true
		present(picker, animated: true)
	}

	// Table View Data Source

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return snaps.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let snap = snaps[indexPath.row]
		let cell = tableView.dequeueReusableCell(withIdentifier: "Snap", for: indexPath)
		cell.textLabel?.text = snap.name
		cell.detailTextLabel?.text = snap.image
		return cell
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let snap = snaps[indexPath.row]
		if let vc = storyboard.instantiateViewController(identifier: "DetailViewController") as? DetailViewController {
			vc.name = snap.name
			vc.image = snap.image
			navigationController?.pushViewController(vc, animated: true)
		}
	}
}

