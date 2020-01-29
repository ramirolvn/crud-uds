//
//  RegisterViewModel.swift
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


protocol RegisterViewModelProtocol{
	func registerUser(name: String, email: String, password: String)
	var firebaseUser: BehaviorRelay<User?>{ get }
	var error: BehaviorRelay<String?> { get }
	var isLoading: BehaviorRelay<Bool?> { get }
}

class RegisterViewModel: RegisterViewModelProtocol {
	
	var firebaseUser: BehaviorRelay<User?> = BehaviorRelay(value: nil)
	var error: BehaviorRelay<String?> = BehaviorRelay(value: nil)
	var isLoading: BehaviorRelay<Bool?> = BehaviorRelay(value: nil)
	private let userCrudService: UserCrudServiceProtocol = UserCrudService()
	
	init() {
		print("INITIALIZATION -> RegisterViewModel")
	}
	
	deinit {
		print("DEINITIALIZATION -> RegisterViewModel")
	}
	
	
	func registerUser(name: String, email: String, password: String){
		if name.count > 0, email.count > 0, password.count > 0{
			self.isLoading.accept(true)
			userCrudService.userRegisterWithEmail(email, name: name, password: password, completion: {[weak self]
				user, error in
				guard let weakSelf = self else { return }
				weakSelf.isLoading.accept(false)
				weakSelf.error.accept(error)
				weakSelf.firebaseUser.accept(user)
			})
		}else{
			self.isLoading.accept(false)
			self.error.accept("Atenção, todos os campos devem ser preenchidos!")
		}
	}
	
}

