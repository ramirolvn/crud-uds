//
//  LoginViewModel.swift
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


protocol LoginViewModelProtocol{
	func loginUser(email: String, password: String)
	func recoverPassword(email: String)
	var firebaseUser: BehaviorRelay<User?> { get }
	var error: BehaviorRelay<String?> { get }
	var isLoading: BehaviorRelay<Bool?> { get }
	var successResetMsg: BehaviorRelay<String?> { get }
}

class LoginViewModel: LoginViewModelProtocol {
	
	var firebaseUser: BehaviorRelay<User?> = BehaviorRelay(value: nil)
	var error: BehaviorRelay<String?> = BehaviorRelay(value: nil)
	var successResetMsg: BehaviorRelay<String?> = BehaviorRelay(value: nil)
	var isLoading: BehaviorRelay<Bool?> = BehaviorRelay(value: nil)
	private let userCrudService: UserCrudServiceProtocol = UserCrudService()
	
	init() {
		print("INITIALIZATION -> LoginViewModel")
	}
	
	deinit {
		print("DEINITIALIZATION -> LoginViewModel")
	}
	
	func loginUser(email: String, password: String){
		if email.count > 0, password.count > 0{
			self.isLoading.accept(true)
			userCrudService.userSignInWithEmail(email, password: password, completion: {[weak self]
				user, error in
				guard let weakSelf = self else { return }
				weakSelf.isLoading.accept(false)
				weakSelf.error.accept(error)
				weakSelf.firebaseUser.accept(user)
			})
		}else{
			self.isLoading.accept(false)
			self.error.accept("E-mail ou senha vazios")
		}
	}
	
	func recoverPassword(email: String){
		if email.count > 0{
			self.isLoading.accept(true)
			userCrudService.sendPasswordReset(email: email, completion: {[weak self]
				error in
				guard let weakSelf = self else { return }
				weakSelf.isLoading.accept(false)
				if let e = error{
					weakSelf.error.accept(e)
				}else{
					weakSelf.successResetMsg.accept("Email de resgate de senha enviado com sucesso!")
				}
			})
		}else{
			self.error.accept("Digite o e-mail da conta")
		}
	}
	
}
