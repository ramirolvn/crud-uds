//
//  ProfileViewModel.swift
//  crud-uds
//
//  Created by Ramiro Lima Vale Neto on 24/01/20.
//  Copyright © 2020 Ramiro Lima Vale Neto. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Firebase


protocol ProfileViewModelProtocol{
	func logoutUser()
	var currentUser: BehaviorRelay<User?> { get }
	var error: BehaviorRelay<String?> { get }
	var isLoading: BehaviorRelay<Bool?> { get }
}

class ProfileViewModel: ProfileViewModelProtocol {
	var currentUser: BehaviorRelay<User?> = BehaviorRelay(value: nil)
	var error: BehaviorRelay<String?> = BehaviorRelay(value: nil)
	var isLoading: BehaviorRelay<Bool?> = BehaviorRelay(value: nil)
	private let userCrudService: UserCrudServiceProtocol = UserCrudService()
	
	init() {
		self.currentUser = BehaviorRelay(value: Auth.auth().currentUser)
		print("INITIALIZATION -> ProfileViewModel")
	}
	
	deinit {
		print("DEINITIALIZATION -> ProfileViewModel")
	}
	
	func logoutUser(){
		self.isLoading.accept(true)
		userCrudService.logoutUser(completion: { [weak self] error in
			guard let weakSelf = self else { return }
			weakSelf.isLoading.accept(true)
			guard let error = error else {
				weakSelf.currentUser.accept(nil)
				return
			}
			weakSelf.error.accept(error)
		})
	}
	
}
