//
//  PrimaryButton.swift
//  crud-uds
//
//  Created by Ramiro Lima Vale Neto on 26/01/20.
//  Copyright © 2020 Ramiro Lima Vale Neto. All rights reserved.
//

import UIKit

class PrimaryButton: UIButton {
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.configPrimaryButton()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.configPrimaryButton()
	}
	
	private func configPrimaryButton() {
		self.layer.cornerRadius = 8
		self.titleLabel?.font = UIFont(name: "Charter Roman" , size: 17.0)
		self.setTitleColor(Colors.waterBlue, for: .normal)
		self.tintColor = Colors.waterBlue
		self.layer.borderColor = Colors.waterBlue.cgColor
		self.layer.borderWidth = 1.0
		self.enable()
	}
	
	func disable() {
		self.isEnabled = false
		self.backgroundColor = Colors.gray
	}
	
	func enable() {
		self.isEnabled = true
		self.backgroundColor = .white
		
	}
	
}
