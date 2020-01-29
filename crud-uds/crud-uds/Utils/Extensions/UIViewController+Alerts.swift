//
//  UIViewController+Alerts.swift
//  crud-uds
//
//  Created by Ramiro Lima Vale Neto on 24/01/20.
//  Copyright © 2020 Ramiro Lima Vale Neto. All rights reserved.
//

import Foundation
import UIKit
extension UIViewController{
	// MARK: - Dialog
	func showDialog(title: String,
					message: String,
					buttonTitle: String,
					buttonAction: (() -> ())?,
					showCloseButton: Bool = true) {
		
		let nib = UINib(nibName: "SimpleDialog", bundle: nil)
		let dialog = nib.instantiate(withOwner: self, options: nil).first as! SimpleDialog
		
		dialog.config(title: title, message: message, buttonTitle: buttonTitle, buttonAction: buttonAction, showCloseButton: showCloseButton)
		
		dialog.tag = ViewsTag.tagDialog
		
		let screen = UIScreen.main.bounds
		dialog.center = CGPoint(x: screen.midX, y: screen.midY)
		dialog.frame = screen
		
		self.view.addSubview(dialog)
	}
}
