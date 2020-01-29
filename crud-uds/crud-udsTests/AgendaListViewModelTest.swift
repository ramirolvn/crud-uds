//
//  AgendaListViewModelTest.swift
//  crud-udsTests
//
//  Created by Ramiro Lima Vale Neto on 24/01/20.
//  Copyright © 2020 Ramiro Lima Vale Neto. All rights reserved.
//

import XCTest
import Firebase
@testable import crud_uds
fileprivate let mockActivesAgendas: [Agenda] = [Agenda(title: "Primeira agenda", short_description: "1", details: "Sou a primeira agenda", author: "Ramiro Lima"),
												Agenda(title: "Segunda agenda", short_description: "2", details: "Sou a segunda agenda", author: "Ramiro Lima"),
												Agenda(title: "Terceira agenda", short_description: "3", details: "Sou a terceira agenda", author: "Ramiro Lima"),
												Agenda(title: "Quarta agenda", short_description: "4", details: "Sou a quarta agenda", author: "Ramiro Lima"),
												Agenda(title: "Quinta agenda", short_description: "5", details: "Sou a quinta agenda", author: "Ramiro Lima"),
												Agenda(title: "Sexta agenda", short_description: "6", details: "Sou a sexta agenda", author: "Ramiro Lima"),
												Agenda(title: "Sétima agenda", short_description: "7", details: "Sou a sétima agenda", author: "Ramiro Lima")]
fileprivate let mockInactivesAgendas: [Agenda] = [Agenda(title: "Primeira agenda", short_description: "1", details: "Sou a primeira agenda inativa", author: "Ramiro Lima"),
												  Agenda(title: "Segunda agenda", short_description: "2", details: "Sou a segunda agenda inativa", author: "Ramiro Lima"),
												  Agenda(title: "Terceira agenda", short_description: "3", details: "Sou a terceira agenda inativa", author: "Ramiro Lima"),
												  Agenda(title: "Quarta agenda", short_description: "4", details: "Sou a quarta agenda inativa", author: "Ramiro Lima"),
												  Agenda(title: "Quinta agenda", short_description: "5", details: "Sou a quinta agenda inativa", author: "Ramiro Lima"),
												  Agenda(title: "Sexta agenda", short_description: "6", details: "Sou a sexta agenda inativa", author: "Ramiro Lima"),
												  Agenda(title: "Sétima agenda", short_description: "7", details: "Sou a sétima agenda inativa", author: "Ramiro Lima")]

class AgendaListViewModelTest: XCTestCase {
	var agendaListViewModel: AgendaListViewModel?
	
	override func setUp() {
		FirebaseApp.configure()
		agendaListViewModel = AgendaListViewModel()
	}
	
	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
	}
	
	func testgetAgendaFail(){
		agendaListViewModel?.activesAgendas.accept(nil)
		agendaListViewModel?.inactivesAgendas.accept(mockInactivesAgendas)
		let index = 0
		XCTAssertTrue(agendaListViewModel?.agenda(at: index) != nil)
	}
	
	func testgetAgendaSuccess(){
		agendaListViewModel?.activesAgendas.accept(mockActivesAgendas)
		agendaListViewModel?.inactivesAgendas.accept(mockInactivesAgendas)
		//Change to Inactives tab
		agendaListViewModel?.changeAgendaStatus(index: 1)
		//get first Agenda
		let index = 0
		XCTAssertTrue(agendaListViewModel?.agenda(at: index)?.details == mockInactivesAgendas[0].details)
	}
	
	func testChangeStatusSuccess(){
		//initial is active = 0
		let nextIndex = 1
		agendaListViewModel?.changeAgendaStatus(index: nextIndex)
		XCTAssertEqual(agendaListViewModel?.agendaStatus.value, .inactive)
	}
	
	func testChangeStatusError(){
		//initial is active = 0
		let nextIndex = 1
		agendaListViewModel?.changeAgendaStatus(index: nextIndex)
		XCTAssertEqual(agendaListViewModel?.agendaStatus.value, .active)
	}
	
	
	
}
