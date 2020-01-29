//
//  SimpleDialog.swift
//  crud-uds
//
//  Created by Ramiro Lima Vale Neto on 24/01/20.
//  Copyright © 2020 Ramiro Lima Vale Neto. All rights reserved.
//

import Foundation
import UIKit

class SimpleDialog: UIView {
	
	@IBOutlet weak var dialogTitle: UILabel!
	@IBOutlet weak var dialogBody: UILabel!
	@IBOutlet weak var dialogButton: UIButton!
	@IBOutlet weak var dialogContent: UIView!
	
	var actionHandler: (() -> ())?
	var isVisibilityStatusChanged: Bool = false
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		self.prepareDialog()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		self.prepareDialog()
	}
	
	// MARK: - Prepare common
	private func prepareDialog() {
		DispatchQueue.main.async {
			self.backgroundColor = Colors.gray.withAlphaComponent(0.8)
		}
	}
	
	private func prepare() {
		DispatchQueue.main.async {
			self.layer.shadowColor = Colors.waterBlue.cgColor
			self.layer.shadowOpacity = 0.2
			self.layer.shadowOffset = .zero
			self.layer.shadowRadius = 5
			self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
			self.layer.shouldRasterize = true
			self.layer.rasterizationScale = UIScreen.main.scale
			self.dialogContent.layer.cornerRadius = 8
			self.dialogContent.clipsToBounds = true
			self.dialogButton.layer.cornerRadius = 8
			self.dialogButton.clipsToBounds = true
			self.dialogButton.layer.borderColor = Colors.waterBlue.cgColor
			self.dialogButton.layer.borderWidth = 2
		}
	}
	
	// MARK: - Config simple alert
	public func config(
		title: String,
		message: String,
		buttonTitle: String,
		buttonAction: (() -> ())?,
		showCloseButton: Bool = false) {
		self.prepare()
		self.dialogTitle.text = title
		self.dialogBody.text = message
		self.dialogButton.setTitle(buttonTitle, for: .normal)
		self.actionHandler = buttonAction
	}
	
	// MARK: - Action
	
	@IBAction func action(_ sender: UIButton) {
		if let action = self.actionHandler {
			action()
		}
		self.removeFromSuperview()
	}
}

