//
//  CustomTextView.swift
//  crud-uds
//
//  Created by Ramiro Lima Vale Neto on 26/01/20.
//  Copyright © 2020 Ramiro Lima Vale Neto. All rights reserved.
//

import UIKit

class CustomTextView: UITextView {
	
	required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)!
		self.layer.borderColor = Colors.black.cgColor
		self.layer.borderWidth = 0.2
		self.layer.cornerRadius = 8.0
		self.font = UIFont(name: "Charter Roman", size: 17)
		
	}
}

extension UITextView :UITextViewDelegate{
	override open var bounds: CGRect {
		didSet {
			self.resizePlaceholder()
		}
	}
	
	
	public var placeholder: String? {
		get {
			var placeholderText: String?
			
			if let placeholderLabel = self.viewWithTag(100) as? UILabel {
				placeholderText = placeholderLabel.text
			}
			
			return placeholderText
		}
		set {
			if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
				placeholderLabel.text = newValue
				placeholderLabel.sizeToFit()
			} else {
				self.addPlaceholder(newValue!)
			}
		}
	}
	
	
	public func textViewDidChange(_ textView: UITextView) {
		if let placeholderLabel = self.viewWithTag(100) as? UILabel {
			placeholderLabel.isHidden = self.text.count > 0
		}
	}
	
	public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
		let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
		let numberOfChars = newText.count
		return numberOfChars < GlobalConstants.MAX_TEXTVIEW_LENGHT
	}
	
	
	private func resizePlaceholder() {
		if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
			let labelX = self.textContainer.lineFragmentPadding
			let labelY = self.textContainerInset.top - 2
			let labelWidth = self.frame.width - (labelX * 2)
			let labelHeight = placeholderLabel.frame.height
			
			placeholderLabel.frame = CGRect(x: labelX, y: labelY, width: labelWidth, height: labelHeight)
		}
	}
	
	
	private func addPlaceholder(_ placeholderText: String) {
		let placeholderLabel = UILabel()
		
		placeholderLabel.text = placeholderText
		placeholderLabel.sizeToFit()
		
		placeholderLabel.font = self.font
		placeholderLabel.textColor = UIColor.lightGray
		placeholderLabel.tag = 100
		
		placeholderLabel.isHidden = self.text.count > 0
		
		self.addSubview(placeholderLabel)
		self.resizePlaceholder()
		self.delegate = self
	}
}
