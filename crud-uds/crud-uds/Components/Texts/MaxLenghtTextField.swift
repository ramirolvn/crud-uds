//
//  MaxLenghtTextField.swift
//  crud-uds
//
//  Created by Ramiro Lima Vale Neto on 28/01/20.
//  Copyright © 2020 Ramiro Lima Vale Neto. All rights reserved.
//
fileprivate let max_length_text_field: Int = 30
import UIKit

class MaxLenghtTextField: UITextField {
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)!
		self.maxLength = max_length_text_field
	}
	
}
