//
//  UITextField+MaxCharacters.swift
//  crud-uds
//
//  Created by Ramiro Lima Vale Neto on 28/01/20.
//  Copyright © 2020 Ramiro Lima Vale Neto. All rights reserved.
//


import UIKit

extension UITextField {
	private struct AssociatedKeys {
		static var maxlength: UInt8 = 0
		static var tempString: UInt8 = 0
	}
	@IBInspectable var maxLength: Int {
		get {
			return objc_getAssociatedObject(self, &AssociatedKeys.maxlength) as? Int ?? 0
		}
		set {
			objc_setAssociatedObject(self, &AssociatedKeys.maxlength, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
			addTarget(self, action: #selector(handleEditingChanged(textField:)), for: .editingChanged)
		}
	}
	
	private var tempString: String? {
		get {
			return objc_getAssociatedObject(self, &AssociatedKeys.tempString) as? String
		}
		set {
			objc_setAssociatedObject(self, &AssociatedKeys.tempString, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
		}
	}
	
	@objc private func handleEditingChanged(textField: UITextField) {
		guard markedTextRange == nil else { return }
		
		if textField.text?.count == maxLength {
			tempString = textField.text
		} else if textField.text?.count ?? 0 < maxLength {
			tempString = nil
		}
		let archivesEditRange: UITextRange?
		
		if textField.text?.count ?? 0 > maxLength {
			
			let position = textField.position(from: safeTextPosition(selectedTextRange?.start), offset: -1) ?? textField.endOfDocument
			archivesEditRange = textField.textRange(from: safeTextPosition(position), to: safeTextPosition(position))
		} else {
			archivesEditRange = selectedTextRange
		}
		textField.text = tempString ?? String((textField.text ?? "").prefix(maxLength))
		textField.selectedTextRange = archivesEditRange
	}
	
	private func safeTextPosition(_ optionlTextPosition: UITextPosition?) -> UITextPosition {
		return optionlTextPosition ?? endOfDocument
	}
}

