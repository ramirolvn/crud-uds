//
//  LoginViewController.swift
//  crud-uds
//
//  Created by Ramiro Lima Vale Neto on 24/01/20.
//  Copyright © 2020 Ramiro Lima Vale Neto. All rights reserved.
//

import UIKit

import RxSwift

class LoginController: UIViewController {
	@IBOutlet weak var emailTF: UITextField!
	@IBOutlet weak var passwordTF: UITextField!
	@IBOutlet weak var recoverPasswordButton: UIButton!
	
	private let viewModel: LoginViewModelProtocol = LoginViewModel()
	private var disposeBag: DisposeBag? = DisposeBag()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		configView()
		prepareObservables()
	}
	
	private func configView(){
		self.hideKeyboardWhenTappedAround()
	}
	
	private func prepareObservables(){
		guard let disposeBag = disposeBag else { return }
		viewModel.error.subscribe({ [weak self] event in
			guard let weakSelf = self, let element = event.element, let error = element else {return}
			weakSelf.showDialog(title: "Erro", message: error, buttonTitle: "Ok", buttonAction: nil)
			
		}).disposed(by: disposeBag)
		
		viewModel.firebaseUser.subscribe({ [weak self] event in
			guard let weakSelf = self, let element = event.element, element != nil else { return }
			weakSelf.goTologgedNavigation()
		}).disposed(by: disposeBag)
		
		viewModel.isLoading.subscribe({ [weak self] event in
			guard let weakSelf = self, let element = event.element, let isLoading = element else { return }
			isLoading ? weakSelf.startLoad(labelText: "Carregando...") : weakSelf.stopLoad()
			
		}).disposed(by: disposeBag)
		
		viewModel.successResetMsg.subscribe({ [weak self] event in
			guard let weakSelf = self, let element = event.element, let msg = element else {return}
			weakSelf.showDialog(title: "Sucesso!", message: msg, buttonTitle: "Ok", buttonAction: nil)
			
		}).disposed(by: disposeBag)
	}
	
	private func goTologgedNavigation(){
		let newRootController = ViewControllers.loggedNavigation
		newRootController.stopLoad()
		self.view.window?.rootViewController = newRootController
	}
	
	@IBAction func loginAction(_ sender: UIButton) {
		guard let email = emailTF.text,
			let password = passwordTF.text
			else { fatalError("Error in outlets") }
		self.dismissKeyboard()
		viewModel.loginUser(email: email, password: password)
	}
	
	@IBAction func recoverPasswordAction(_ sender: UIButton) {
		guard let email = emailTF.text
			else { fatalError("Error in outlets") }
		viewModel.recoverPassword(email: email)
		
	}
}
