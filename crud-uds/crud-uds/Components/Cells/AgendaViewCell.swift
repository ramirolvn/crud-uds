//
//  AgendaViewCell.swift
//  crud-uds
//
//  Created by Ramiro Lima Vale Neto on 26/01/20.
//  Copyright © 2020 Ramiro Lima Vale Neto. All rights reserved.
//

import UIKit

class AgendaViewCell: UITableViewCell {
	@IBOutlet weak var title: UILabel!
	@IBOutlet weak var shortDescription: UILabel!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		// Initialization code
	}
	
	func config(agenda: Agenda){
		self.title.text = agenda.short_description
		self.shortDescription.text = agenda.details
	}
	
}
