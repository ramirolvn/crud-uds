//
//  FirebaseUser.swift
//  crud-uds
//
//  Created by Ramiro Lima Vale Neto on 24/01/20.
//  Copyright © 2020 Ramiro Lima Vale Neto. All rights reserved.
//

import Foundation

struct Agenda{
	var documentID: String? = nil
	let title: String
	let short_description: String
	let details: String
	let author: String
	var isActive: Bool = true
	
	var asDictionary : [String:Any]? {
		let mirror = Mirror(reflecting: self)
		let dict = Dictionary(uniqueKeysWithValues: mirror.children.lazy.map({ (label:String?, value:Any) -> (String, Any)? in
			guard let label = label else { return nil }
			return (label, value)
		}).compactMap { $0 })
		return dict
	}
	
	init(title: String, short_description: String, details: String, author: String, isActive: Bool = true) {
		self.title = title
		self.short_description = short_description
		self.details = details
		self.author = author
		self.isActive = true
	}
	
	init(documentID: String, firebaseData: [String: Any]) {
		self.documentID = documentID
		self.title = firebaseData["title"] as! String
		self.short_description = firebaseData["short_description"] as! String
		self.details = firebaseData["details"] as! String
		self.author = firebaseData["author"] as! String
	}
	
	
}
