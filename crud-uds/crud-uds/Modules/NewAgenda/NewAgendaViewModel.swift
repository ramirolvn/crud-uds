//
//  NewAgendaViewModel.swift
//  crud-uds
//
//  Created by Ramiro Lima Vale Neto on 25/01/20.
//  Copyright © 2020 Ramiro Lima Vale Neto. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Firebase


protocol NewAgendaViewModelProtocol{
	func saveAgenda(title: String, shortDescription: String, details: String, author: String)
	func canEdit() -> Bool
	func closeOrOpenAgenda()
	func canFinalize() -> Bool
	var currentUser: BehaviorRelay<User?> { get }
	var error: BehaviorRelay<String?> { get }
	var isLoading: BehaviorRelay<Bool?> { get }
	var didSuccessRequest: BehaviorRelay<Bool?> { get }
	var selectedAgenda: BehaviorRelay<Agenda?> { get set }
	var placeHolder: String { get }
	var agendaStatus: BehaviorRelay<AgendaStatus?> {get set}
}

class NewAgendaViewModel: NewAgendaViewModelProtocol {
	var currentUser: BehaviorRelay<User?> = BehaviorRelay(value: nil)
	var error: BehaviorRelay<String?> = BehaviorRelay(value: nil)
	var didSuccessRequest: BehaviorRelay<Bool?> = BehaviorRelay(value: nil)
	var didSuccessUpdate: BehaviorRelay<Bool?> = BehaviorRelay(value: nil)
	var isLoading: BehaviorRelay<Bool?> = BehaviorRelay(value: nil)
	var selectedAgenda: BehaviorRelay<Agenda?> = BehaviorRelay(value: nil)
	var agendaStatus: BehaviorRelay<AgendaStatus?> =  BehaviorRelay(value: nil)
	let placeHolder: String = "Detalhes até \(GlobalConstants.MAX_TEXTVIEW_LENGHT) caractéres"
	private let agendaService: AgendaServiceProtocol = AgendaService()
	
	init() {
		self.currentUser = BehaviorRelay(value: Auth.auth().currentUser)
		print("INITIALIZATION -> NewAgendaViewModel")
	}
	
	deinit {
		print("DEINITIALIZATION -> NewAgendaViewModel")
	}
	
	func saveAgenda(title: String, shortDescription: String, details: String, author: String){
		if title.count > 0, shortDescription.count > 0, author.count > 0 {
			self.isLoading.accept(true)
			if let agenda = Agenda(title: title, short_description: shortDescription, details: details, author: author, isActive: true).asDictionary{
				agendaService.saveAgenda(agenda, completion: {[weak self]
					error in
					guard let weakSelf = self else { return }
					if let err = error{
						weakSelf.error.accept(err)
					}else{
						weakSelf.didSuccessRequest.accept(true)
					}
				})
			}else{
				self.isLoading.accept(false)
				self.error.accept("Erro desconhecido, pora favor procurar Ramiro Lima")
			}
		}else{
			self.error.accept("Título e descrição obrigatórios!")
		}
		
	}
	
	func canEdit() -> Bool{
		if self.selectedAgenda.value != nil {
			return false
		}
		return true
	}
	
	func canFinalize() -> Bool{
		if let selectedAgenda = self.selectedAgenda.value, selectedAgenda.author.count > 0 , selectedAgenda.details.count > 0 , selectedAgenda.title.count > 0, selectedAgenda.short_description.count > 0{
			return true
		}
		return false
	}
	
	func closeOrOpenAgenda(){
		guard let status = self.agendaStatus.value, let selectedAgenda = self.selectedAgenda.value, let agendaID = selectedAgenda.documentID else { return }
		var newStatus: Bool
		switch status {
		case .active:
			newStatus = false
		case .inactive:
			newStatus  = true
		}
		self.isLoading.accept(true)
		agendaService.updateAgenda(documentId: agendaID, newStatus, completion: { [weak self]
			error in
			guard let weakSelf = self else { return }
			weakSelf.isLoading.accept(false)
			if let e = error{
				weakSelf.error.accept(e)
			}else{
				weakSelf.didSuccessRequest.accept(true)
			}
		})
	}
	
}
