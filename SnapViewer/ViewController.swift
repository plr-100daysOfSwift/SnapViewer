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

		navigationItem.leftBarButtonItem = self.editButtonItem

		if let encodedData = defaults.object(forKey: "Snaps") as? Data {
			let decoder = JSONDecoder()
			if let snaps = try? decoder.decode([Snap].self, from: encodedData) {
				self.snaps = snaps
				tableView.reloadData()
			}
		}

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

	// MARK: - ImagePicker Delegate

	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		guard let image = info[.editedImage] as? UIImage else { return }
		let imageName = UUID().uuidString
		let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
		if let imageData = image.jpegData(compressionQuality: 0.8) {
			try? imageData.write(to: imagePath)
		}

		let snap = Snap(name: "", image: imageName)
		snaps.insert(snap, at: 0)
		let firstIndex = IndexPath(item: 0, section: 0)
		tableView.insertRows(at: [firstIndex], with: .automatic)
		save()

		dismiss(animated: true, completion: addName)
	}

	// TODO: allow renaming of snaps

	func addName() {
		let ac = UIAlertController(title: "Please enter a title.", message: nil, preferredStyle: .alert)
		ac.addTextField() { textfield in
			textfield.text = self.snaps[0].name
			textfield.clearButtonMode = .always
			textfield.autocapitalizationType = .words
		}
		let okay = UIAlertAction(title: "OK", style: .default) { action in
			if let title = ac.textFields?[0].text {
				saveTitle(title)
			}
		}
		ac.addAction(okay)
		ac.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in saveTitle("Unknown")})
		present(ac, animated: true)

		func saveTitle(_ title: String) {
			self.snaps[0].name = title.trimmingCharacters(in: .whitespacesAndNewlines)
			let firstIndex = IndexPath(item: 0, section: 0)
			self.tableView.reloadRows(at: [firstIndex], with: .automatic)
			self.save()
		}

	}

	func save() {
		let encoder = JSONEncoder()
		if let encodedData = try? encoder.encode(snaps) {
			defaults.set(encodedData, forKey: "Snaps")
		}
	}

	// MARK: - Table View Data Source

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return snaps.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let snap = snaps[indexPath.row]
		let cell = tableView.dequeueReusableCell(withIdentifier: "Snap", for: indexPath)

		cell.textLabel?.text = snap.name

		let formatter = DateFormatter()
		formatter.dateStyle = .medium
		formatter.timeStyle = .short
		let dateString = formatter.string(from: snap.dateAdded)
		cell.detailTextLabel?.text = "Date added: \(dateString)"

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

	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			let imagePath = getDocumentsDirectory().appendingPathComponent(snaps[indexPath.row].image)
			try? FileManager.default.removeItem(atPath: imagePath.path)
			snaps.remove(at: indexPath.row)
			tableView.deleteRows(at: [indexPath], with: .automatic)
			save()
		}
	}

	override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
		let rowToMove = snaps.remove(at: sourceIndexPath.row)
		snaps.insert(rowToMove, at: destinationIndexPath.row)
		tableView.reloadData()
	}
}
