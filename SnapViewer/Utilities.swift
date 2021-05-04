//
//  Utilities.swift
//  SnapViewer
//
//  Created by Paul Richardson on 04/05/2021.
//

import Foundation

func getDocumentsDirectory() -> URL {
	let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
	return paths[0]
}
