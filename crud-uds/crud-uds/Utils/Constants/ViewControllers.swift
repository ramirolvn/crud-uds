//
//  ViewControllers.swift
//  crud-uds
//
//  Created by Ramiro Lima Vale Neto on 24/01/20.
//  Copyright © 2020 Ramiro Lima Vale Neto. All rights reserved.
//

import Foundation
import UIKit

struct ViewControllers {
	static let loggedNavigation: UINavigationController = StoryBoards.mainStoryBoard.instantiateViewController(identifier: "LoggedNavigation") as! UINavigationController
	
	static let appDelegate = UIApplication.shared.delegate as! AppDelegate
	static let mainNavigation: UINavigationController = StoryBoards.mainStoryBoard.instantiateViewController(identifier: "MainNavigation") as! UINavigationController
	
}
