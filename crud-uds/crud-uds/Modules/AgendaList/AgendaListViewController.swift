//
//  AgendaListViewController.swift
//  crud-uds
//
//  Created by Ramiro Lima Vale Neto on 24/01/20.
//  Copyright © 2020 Ramiro Lima Vale Neto. All rights reserved.
//

import UIKit
import RxSwift
import ExpyTableView

fileprivate let agendaCellIdentifier = "agendaCell"

class AgendaListViewController: UIViewController {
	@IBOutlet weak var listTable: ExpyTableView!
	@IBOutlet weak var segmentControl: UISegmentedControl!
	
	private let viewModel: AgendaListViewModelProtocol = AgendaListViewModel()
	private var disposeBag: DisposeBag? = DisposeBag()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		prepareObservables()
		configureTableView()
		configView()
	}
	
	private func configView(){
		segmentControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
		segmentControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: Colors.waterBlue], for: .normal)
	}
	
	
	private func configureTableView(){
		listTable.delegate = self
		listTable.dataSource = self
	}
	
	private func prepareObservables(){
		guard let disposeBag = disposeBag else { return }
		viewModel.error.subscribe({ [weak self] event in
			guard let weakSelf = self, let element = event.element, let error = element else {return}
			weakSelf.showDialog(title: "Erro", message: error, buttonTitle: "Ok", buttonAction: nil)
			
		}).disposed(by: disposeBag)
		
		viewModel.currentUser.subscribe({ [weak self] event in
			guard let weakSelf = self, let element = event.element, element == nil else {return}
			weakSelf.goToLoggout()
		}).disposed(by: disposeBag)
		
		viewModel.isLoading.subscribe({ [weak self] event in
			guard let weakSelf = self, let element = event.element, let isLoading = element else { return }
			isLoading ? weakSelf.startLoad(labelText: "Carregando...") : weakSelf.stopLoad()
		}).disposed(by: disposeBag)
		
		viewModel.agendaStatus.subscribe({ [weak self] event in
			guard let weakSelf = self, let agendaStatus = event.element else { return }
			switch agendaStatus{
			case .active:
				weakSelf.viewModel.listActiveAgendas()
			case .inactive:
				weakSelf.viewModel.listInactiveAgendas()
			}
			
		}).disposed(by: disposeBag)
		
		viewModel.activesAgendas.subscribe({ [weak self] event in
			guard let weakSelf = self, let element = event.element, let _ = element else { return }
			weakSelf.reloadTableView()
			
		}).disposed(by: disposeBag)
		
		viewModel.inactivesAgendas.subscribe({ [weak self] event in
			guard let weakSelf = self, let element = event.element, let _ = element else { return }
			weakSelf.reloadTableView()
			
		}).disposed(by: disposeBag)
	}
	
	
	private func reloadTableView(){
		DispatchQueue.main.async {[weak self] in
			guard let weakSelf = self else { return }
			weakSelf.listTable.reloadData()
		}
	}
	
	private func goToLoggout(){
		let loginController = ViewControllers.mainNavigation
		UIApplication.shared.windows.first?.rootViewController = loginController
		UIApplication.shared.windows.first?.makeKeyAndVisible()
	}
	
	@IBAction func logoutAction(_ sender: UIBarButtonItem) {
		viewModel.logoutUser()
	}
	
	@IBAction func addAgendaAction(_ sender: UIButton) {
		self.performSegue(withIdentifier: SeguesIdentifiers.addNewAgendaFromMain, sender: nil)
	}
	
	@IBAction func changeListAction(_ sender: UISegmentedControl) {
		viewModel.changeAgendaStatus(index: sender.selectedSegmentIndex)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier  == SeguesIdentifiers.addNewAgendaFromMain {
			if let destination = segue.destination as? NewAgendaViewController{
				destination.delegate = self
				if let agenda = sender as? Agenda{
					destination.viewModel.selectedAgenda.accept(agenda)
					destination.viewModel.agendaStatus.accept(viewModel.agendaStatus.value)
				}
			}else{
				fatalError("Error in flow")
			}
		}
	}
	
}

extension AgendaListViewController: ExpyTableViewDataSource, ExpyTableViewDelegate{
	func tableView(_ tableView: ExpyTableView, expandableCellForSection section: Int) -> UITableViewCell {
		let cell = UITableViewCell()
		guard let agenda = viewModel.agenda(at: section) else {
			fatalError("Erro in mount view")
		}
		cell.textLabel?.text = agenda.title
		return cell
	}
	
	func tableView(_ tableView: ExpyTableView, canExpandSection section: Int) -> Bool {
		return true
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		2
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		viewModel.sectionsQnt()
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		guard let agenda = viewModel.agenda(at: indexPath.item-1), let agendaCell = tableView.dequeueReusableCell(withIdentifier: agendaCellIdentifier) as? AgendaViewCell else {
			fatalError("Erro in mount view")
		}
		agendaCell.config(agenda: agenda)
		return agendaCell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if indexPath.row == 1{
			guard let agenda = viewModel.agenda(at: indexPath.section) else {
				fatalError("Erro in mount view")
			}
			self.performSegue(withIdentifier: SeguesIdentifiers.addNewAgendaFromMain, sender: agenda)
		}
		
	}
	
	func tableView(_ tableView: ExpyTableView, expyState state: ExpyState, changeForSection section: Int) {
		
		switch state {
		case .didExpand:
			var sectionIndex = 0
			while sectionIndex < self.listTable.expandedSections.count{
				if self.listTable.expandedSections[sectionIndex] ?? false, section != sectionIndex{
					self.listTable.collapse(sectionIndex)
				}
				sectionIndex+=1
			}
		default:
			print("Do nothing")
		}
	}
}

extension AgendaListViewController: NewAgendaViewControllerDelegate{
	func reloadAgendaListAfterDismiss(){
		switch viewModel.agendaStatus.value{
		case .active:
			self.viewModel.listActiveAgendas()
		case .inactive:
			self.viewModel.listInactiveAgendas()
		}
	}
}
