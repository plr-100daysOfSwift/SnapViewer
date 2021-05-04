//
//  ViewController.swift
//  SnapViewer
//
//  Created by Paul Richardson on 04/05/2021.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

	let defaults = UserDefaults.standard
	var snaps = [Snap]()

	override func viewDidLoad() {
		super.viewDidLoad()

		title = "SnapViewer"
		navigationController?.navigationBar.prefersLargeTitles = true

		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addSnap))

//		let snap = Snap(name: "foo", image: "bar")
//		snaps.append(snap)
//		tableView.reloadData()
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

	// ImagePicker Delegate

	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		guard let image = info[.editedImage] as? UIImage else { return }
		let imageName = UUID().uuidString
		let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
		if let imageData = image.jpegData(compressionQuality: 0.8) {
			try? imageData.write(to: imagePath)
		}

		let snap = Snap(name: "Unknown", image: imageName)
		snaps.append(snap)
		tableView.reloadData()

		dismiss(animated: true, completion: addName)
	}

	func addName() {

	}

	func save() {
		let encoder = JSONEncoder()
		if let encodedData = try? encoder.encode(snaps) {
			defaults.set(encodedData, forKey: "Snaps")
		}
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
			vc.selectedImage = snap.image
			navigationController?.pushViewController(vc, animated: true)
		}
	}
}

