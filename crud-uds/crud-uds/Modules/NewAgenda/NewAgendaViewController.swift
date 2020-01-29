//
//  NewAgendaViewController.swift
//  crud-uds
//
//  Created by Ramiro Lima Vale Neto on 25/01/20.
//  Copyright © 2020 Ramiro Lima Vale Neto. All rights reserved.
//

import UIKit
import RxSwift
import Firebase

protocol NewAgendaViewControllerDelegate: class {
	func reloadAgendaListAfterDismiss()
}

class NewAgendaViewController: UIViewController {
	@IBOutlet weak var titleTF: UITextField!
	@IBOutlet weak var shortDescriptionTF: UITextField!
	@IBOutlet weak var detailsTV: UITextView!
	@IBOutlet weak var authorTF: UITextField!
	@IBOutlet weak var saveButton: UIBarButtonItem!
	@IBOutlet weak var closeOrOpenButton: PrimaryButton!
	
	let viewModel: NewAgendaViewModelProtocol = NewAgendaViewModel()
	weak var delegate: NewAgendaViewControllerDelegate?
	private var disposeBag: DisposeBag? = DisposeBag()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		prepareObservables()
		configView()
		
	}
	
	
	private func configView(){
		self.authorTF.backgroundColor = Colors.gray
		if viewModel.canEdit() {detailsTV.placeholder = viewModel.placeHolder}
		authorTF.text = viewModel.currentUser.value?.displayName
		self.hideKeyboardWhenTappedAround()
		if !viewModel.canFinalize() { self.closeOrOpenButton.disable()}
		canEditView()
	}
	
	private func prepareObservables(){
		guard let disposeBag = disposeBag else { return }
		viewModel.error.subscribe({ [weak self] event in
			guard let weakSelf = self, let element = event.element, let error = element else {return}
			weakSelf.showDialog(title: "Erro", message: error, buttonTitle: "Ok", buttonAction: nil)
			
		}).disposed(by: disposeBag)
		
		viewModel.currentUser.subscribe({ [weak self] event in
			guard let weakSelf = self, let element = event.element, element == nil else {return}
			weakSelf.goToLogin()
		}).disposed(by: disposeBag)
		
		viewModel.isLoading.subscribe({ [weak self] event in
			guard let weakSelf = self, let element = event.element, let isLoading = element else { return }
			isLoading ? weakSelf.startLoad(labelText: "Salvando...") : weakSelf.stopLoad()
		}).disposed(by: disposeBag)
		
		viewModel.selectedAgenda.subscribe({ [weak self] event in
			guard let weakSelf = self, let element = event.element, let selectedAgenda = element  else {return}
			weakSelf.populateView(agenda: selectedAgenda)
		}).disposed(by: disposeBag)
		
		viewModel.didSuccessRequest.subscribe({ [weak self] event in
			guard let weakSelf = self, let didSuccessRequest = event.element, didSuccessRequest == true else {return}
			weakSelf.popAndCallDelegate()
		}).disposed(by: disposeBag)
		
		viewModel.agendaStatus.subscribe({ [weak self] event in
			guard let weakSelf = self, let element = event.element, let agendaStatus = element else {return}
			weakSelf.activeOrInactiveAgendas(agendaStatus: agendaStatus)
		}).disposed(by: disposeBag)
	}
	
	
	private func populateView(agenda: Agenda){
		self.titleTF.text = agenda.title
		self.shortDescriptionTF.text = agenda.short_description
		self.shortDescriptionTF.textColor = .black
		self.detailsTV.text = agenda.details
		self.authorTF.text = agenda.author
	}
	
	private func canEditView(){
		self.titleTF.isEnabled = viewModel.canEdit()
		self.shortDescriptionTF.isEnabled = viewModel.canEdit()
		self.detailsTV.isEditable = viewModel.canEdit()
		self.saveButton.isEnabled = viewModel.canEdit()
		self.titleTF.backgroundColor = viewModel.canEdit() ? .white : Colors.gray
		self.shortDescriptionTF.backgroundColor = viewModel.canEdit() ? .white : Colors.gray
		self.detailsTV.backgroundColor = viewModel.canEdit() ? .white : Colors.gray
		self.saveButton.title = viewModel.canEdit() ? "Salvar" : ""
	}
	
	private func goToLogin(){
		let loginController = ViewControllers.mainNavigation
		UIApplication.shared.windows.first?.rootViewController = loginController
		UIApplication.shared.windows.first?.makeKeyAndVisible()
	}
	
	private func popAndCallDelegate(){
		if let delegate = self.delegate{
			delegate.reloadAgendaListAfterDismiss()
		}
		self.navigationController?.popViewController(animated: true)
	}
	
	private func activeOrInactiveAgendas(agendaStatus: AgendaStatus){
		self.closeOrOpenButton.isHidden = false
		self.closeOrOpenButton.setTitle(agendaStatus.buttonTitle, for: .normal)
	}
	
	
	@IBAction func saveAction(_ sender: UIBarButtonItem) {
		guard let title = titleTF.text,
			let short_description = shortDescriptionTF.text,
			let details = detailsTV.text,
			let author = authorTF.text else {
				fatalError("Error outlet")
		}
		dismissKeyboard()
		viewModel.saveAgenda(title: title, shortDescription: short_description, details: details, author: author)
	}
	
	@IBAction func closeOrOpenAction(_ sender: UIButton) {
		viewModel.closeOrOpenAgenda()
	}
	
}
