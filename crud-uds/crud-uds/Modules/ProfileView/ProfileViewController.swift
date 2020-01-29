//
//  ProfileViewController.swift
//  crud-uds
//
//  Created by Ramiro Lima Vale Neto on 24/01/20.
//  Copyright © 2020 Ramiro Lima Vale Neto. All rights reserved.
//

import UIKit
import RxSwift
import Firebase

class ProfileViewController: UIViewController {
	
	@IBOutlet weak var nameTF: UITextField!
	@IBOutlet weak var emailTF: UITextField!
	
	private let viewModel: ProfileViewModelProtocol = ProfileViewModel()
	private var disposeBag: DisposeBag? = DisposeBag()
	
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		prepareObservables()
	}
	
	private func prepareObservables(){
		guard let disposeBag = disposeBag else { return }
		viewModel.error.subscribe({ [weak self] event in
			guard let weakSelf = self, let element = event.element, let error = element else {return}
			weakSelf.stopLoad()
			weakSelf.showDialog(title: "Erro", message: error, buttonTitle: "Ok", buttonAction: nil)
			
		}).disposed(by: disposeBag)
		
		viewModel.currentUser.subscribe({ [weak self] event in
			guard let weakSelf = self else { return }
			weakSelf.stopLoad()
			guard let element = event.element, let user = element else {
				weakSelf.goToLoggoutView()
				return
			}
			weakSelf.populateView(user: user)
		}).disposed(by: disposeBag)
		
		viewModel.isLoading.subscribe({ [weak self] event in
			guard let weakSelf = self, let element = event.element, let isLoading = element else { return }
			isLoading ? weakSelf.startLoad(labelText: "Carregando...") : weakSelf.stopLoad()
			
		}).disposed(by: disposeBag)
	}
	
	private func populateView(user: User){
		self.nameTF.text = user.displayName
		self.emailTF.text = user.email
	}
	
	private func goToLoggoutView(){
		let loginController = ViewControllers.mainNavigation
		UIApplication.shared.windows.first?.rootViewController = loginController
		UIApplication.shared.windows.first?.makeKeyAndVisible()
	}
	
	@IBAction func logoutAction(_ sender: UIBarButtonItem) {
		viewModel.logoutUser()
	}
	
	
}
