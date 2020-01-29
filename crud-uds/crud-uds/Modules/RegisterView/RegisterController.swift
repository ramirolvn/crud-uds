//
//  RegisterController.swift
//  crud-uds
//
//  Created by Ramiro Lima Vale Neto on 24/01/20.
//  Copyright © 2020 Ramiro Lima Vale Neto. All rights reserved.
//

import UIKit
import RxSwift

class RegisterController: UIViewController {
	@IBOutlet weak var nameTF: UITextField!
	@IBOutlet weak var emailTF: UITextField!
	@IBOutlet weak var passwordTF: UITextField!
	
	private let viewModel: RegisterViewModelProtocol = RegisterViewModel()
	private var disposeBag: DisposeBag? = DisposeBag()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		prepareObservables()
		configView()
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
			weakSelf.showDialog(title: "Sucesso", message: "Sucesso ao cadastrar!", buttonTitle: "Ok", buttonAction: {
				weakSelf.goTosecondNavigation()
			})
		}).disposed(by: disposeBag)
		
		viewModel.isLoading.subscribe({ [weak self] event in
			guard let weakSelf = self, let element = event.element, let isLoading = element else { return }
			isLoading ? weakSelf.startLoad(labelText: "Registrando...") : weakSelf.stopLoad()
		}).disposed(by: disposeBag)
	}
	
	private func goTosecondNavigation(){
		let newRootController = ViewControllers.loggedNavigation
		newRootController.stopLoad()
		self.view.window?.rootViewController = newRootController
	}
	
	@IBAction func registerAction(_ sender: UIButton) {
		guard let name = nameTF.text,
			let email = emailTF.text,
			let passsword = passwordTF.text else{
				fatalError("Error to get textfields values!")
		}
		self.dismissKeyboard()
		viewModel.registerUser(name: name, email: email, password: passsword)
	}
	
	
	
}
