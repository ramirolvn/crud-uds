//
//  UIViewController+LoaderView.swift
//  crud-uds
//
//  Created by Ramiro Lima Vale Neto on 24/01/20.
//  Copyright © 2020 Ramiro Lima Vale Neto. All rights reserved.
//

import Foundation
import UIKit
extension UIViewController {
	func startLoad(labelText: String) {
		let nib = UINib(nibName: "LoaderView", bundle: nil)
		let customAlert = nib.instantiate(withOwner: self, options: nil).first as! LoaderView
		
		customAlert.tag = ViewsTag.tagLoaderView
		
		let screen = UIScreen.main.bounds
		customAlert.center = CGPoint(x: screen.midX, y: screen.midY)
		customAlert.frame = screen
		customAlert.loaderLabel.text = labelText
		DispatchQueue.main.async {
			self.view.addSubview(customAlert)
		}
	}
	
	func stopLoad() {
		if let view = self.view.viewWithTag(ViewsTag.tagLoaderView) {
			DispatchQueue.main.async {
				view.removeFromSuperview()
			}
		}
	}
}
