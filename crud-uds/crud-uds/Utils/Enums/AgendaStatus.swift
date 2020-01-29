//
//  AgendaStatus.swift
//  crud-uds
//
//  Created by Ramiro Lima Vale Neto on 25/01/20.
//  Copyright © 2020 Ramiro Lima Vale Neto. All rights reserved.
//

import Foundation

enum AgendaStatus {
	case active
	case inactive
	
	
	var buttonTitle: String{
		switch self {
		case .active:
			return "Finalizar"
		case .inactive:
			return "Reabrir"
		}
	}
	
	
	var statusName: String{
		switch self {
		case .active:
			return "Ativas"
		case .inactive:
			return "Inativas"
		}
	}
	
	init(index: Int) {
		self = index == 0 ? AgendaStatus.active : AgendaStatus.inactive
	}
	
}
