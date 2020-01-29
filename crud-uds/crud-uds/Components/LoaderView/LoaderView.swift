//
//  LoaderView.swift
//  crud-uds
//
//  Created by Ramiro Lima Vale Neto on 24/01/20.
//  Copyright © 2020 Ramiro Lima Vale Neto. All rights reserved.
//

import Foundation
import UIKit

class LoaderView: UIView {
	
	
	@IBOutlet weak var loaderLabel: UILabel!
	@IBOutlet weak var blackView: UIView!
	@IBOutlet weak var activityLoader: UIActivityIndicatorView!
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		backgroundColor = Colors.waterBlue.withAlphaComponent(0.5)
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		blackView.clipsToBounds = true
		blackView.layer.cornerRadius = 12
		activityLoader.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		backgroundColor = Colors.black.withAlphaComponent(0.5)
	}
	
}
