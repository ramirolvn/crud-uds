//
//  AgendaListViewModel.swift
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


protocol AgendaListViewModelProtocol{
	func logoutUser()
	func listInactiveAgendas()
	func listActiveAgendas()
	func sectionsQnt() -> Int
	func changeAgendaStatus(index: Int)
	func agenda(at section: Int) -> Agenda?
	var currentUser: BehaviorRelay<User?> { get }
	var error: BehaviorRelay<String?> { get }
	var isLoading: BehaviorRelay<Bool?> { get }
	var activesAgendas: BehaviorRelay<[Agenda]?> { get }
	var inactivesAgendas: BehaviorRelay<[Agenda]?> { get }
	var agendaStatus: BehaviorRelay<AgendaStatus> { get }
}

class AgendaListViewModel: AgendaListViewModelProtocol {
	var currentUser: BehaviorRelay<User?>
	var error: BehaviorRelay<String?> = BehaviorRelay(value: nil)
	var isLoading: BehaviorRelay<Bool?> = BehaviorRelay(value: nil)
	var activesAgendas: BehaviorRelay<[Agenda]?> = BehaviorRelay(value: nil)
	var inactivesAgendas: BehaviorRelay<[Agenda]?> = BehaviorRelay(value: nil)
	var agendaStatus: BehaviorRelay<AgendaStatus> =  BehaviorRelay(value: .active)
	private let userCrudService: UserCrudServiceProtocol = UserCrudService()
	private let agendaService: AgendaServiceProtocol = AgendaService()
	
	init() {
		self.currentUser = BehaviorRelay(value: Auth.auth().currentUser)
		print("INITIALIZATION -> AgendaListModel")
	}
	
	deinit {
		print("DEINITIALIZATION -> AgendaListModel")
	}
	
	
	func logoutUser(){
		self.isLoading.accept(true)
		userCrudService.logoutUser(completion: { [weak self] error in
			guard let weakSelf = self else { return }
			weakSelf.isLoading.accept(false)
			guard let error = error else {
				weakSelf.currentUser.accept(nil)
				return
			}
			weakSelf.error.accept(error)
		})
	}
	
	func listActiveAgendas(){
		getAllActiveAgendas()
	}
	
	func listInactiveAgendas(){
		getAllInactiveAgendas()
	}
	
	private func getAllActiveAgendas(){
		self.isLoading.accept(true)
		agendaService.getAllUserActivesAgendas(completion: { [weak self] agendas, error in
			guard let weakSelf = self else { return }
			weakSelf.activesAgendas.accept(agendas)
			weakSelf.error.accept(error)
			weakSelf.isLoading.accept(false)
		})
	}
	
	private func getAllInactiveAgendas(){
		self.isLoading.accept(true)
		agendaService.getAllUserInactivesAgendas(completion: { [weak self] agendas, error in
			guard let weakSelf = self else { return }
			weakSelf.inactivesAgendas.accept(agendas)
			weakSelf.error.accept(error)
			weakSelf.isLoading.accept(false)
		})
	}
	
	func sectionsQnt() -> Int {
		switch self.agendaStatus.value {
		case .active:
			guard let activeAgendas = self.activesAgendas.value else {return 0}
			return activeAgendas.count
		case .inactive:
			guard let inactiveAgendas = self.inactivesAgendas.value else {return 0}
			return inactiveAgendas.count
		}
	}
	
	func agenda(at section: Int) -> Agenda?{
		switch self.agendaStatus.value {
		case .active:
			guard let activeAgendas = self.activesAgendas.value, activeAgendas.count > section  else {return nil}
			return activeAgendas[section]
		case .inactive:
			guard let inactiveAgendas = self.inactivesAgendas.value, inactiveAgendas.count > section  else {return nil}
			return inactiveAgendas[section]
		}
		
	}
	
	func changeAgendaStatus(index: Int){
		let newStatus = AgendaStatus(index: index)
		self.agendaStatus.accept(newStatus)
	}
	
}
