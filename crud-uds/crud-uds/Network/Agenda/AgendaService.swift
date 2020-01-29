//
//  AgendaService.swift
//  crud-uds
//
//  Created by Ramiro Lima Vale Neto on 25/01/20.
//  Copyright © 2020 Ramiro Lima Vale Neto. All rights reserved.
//

import Foundation
import Firebase

fileprivate let agendaInitError: String = "Erro ao conectar com o servidor"

protocol AgendaServiceProtocol {
	func saveAgenda(_ agenda: [String:Any], completion: @escaping (_ error: String?)->())
	func updateAgenda(documentId:String,_ isActive: Bool, completion: @escaping (_ error: String?)->())
	func getAllUserActivesAgendas(completion: @escaping (_ userAgendas: [Agenda]?,_ error: String?)->())
	func getAllUserInactivesAgendas(completion: @escaping (_ userAgendas: [Agenda]?,_ error: String?)->())
}


class AgendaService: AgendaServiceProtocol {
	var agendaDB: CollectionReference? = nil
	
	init() {
		guard let user = Auth.auth().currentUser else {return}
		agendaDB = Firestore.firestore().collection("userIds").document(user.uid).collection("agendas")
		print("INITIALIZATION -> AgendaService")
	}
	
	public func saveAgenda(_ agenda: [String:Any], completion: @escaping (_ error: String?)->()){
		guard let agendaDB = self.agendaDB else {
			completion(agendaInitError)
			return
		}
		var ref: DocumentReference? = nil
		ref = agendaDB.addDocument(data: agenda){ err in
			if let err = err, let fireError = FirestoreErrorCode(rawValue: err._code) {
				completion(fireError.errorMessage)
			} else {
				print(ref as Any)
				completion(nil)
			}
		}
	}
	
	public func getAllUserActivesAgendas(completion: @escaping (_ userAgendas: [Agenda]?,_ error: String?)->()){
		guard let agendaDB = self.agendaDB else {
			completion(nil,agendaInitError)
			return
		}
		agendaDB.whereField("isActive", isEqualTo: true).getDocuments(completion: { (querySnapshot, err) in
			if let err = err, let fireError = FirestoreErrorCode(rawValue: err._code) {
				completion(nil,fireError.errorMessage)
			} else {
				var userAgendas = [Agenda]()
				for document in querySnapshot!.documents {
					userAgendas.append(Agenda(documentID: document.documentID, firebaseData: document.data()))
				}
				completion(userAgendas,nil)
			}
		})
	}
	
	public func getAllUserInactivesAgendas(completion: @escaping (_ userAgendas: [Agenda]?,_ error: String?)->()){
		guard let agendaDB = self.agendaDB else {
			completion(nil,agendaInitError)
			return
		}
		agendaDB.whereField("isActive", isEqualTo: false).getDocuments(completion: { (querySnapshot, err) in
			if let err = err, let fireError = FirestoreErrorCode(rawValue: err._code) {
				completion(nil,fireError.errorMessage)
			} else {
				var userAgendas = [Agenda]()
				for document in querySnapshot!.documents {
					userAgendas.append(Agenda(documentID: document.documentID, firebaseData: document.data()))
				}
				completion(userAgendas,nil)
			}
		})
	}
	
	public func updateAgenda(documentId:String,_ isActive: Bool, completion: @escaping (_ error: String?)->()){
		guard let agendaDB = self.agendaDB else {
			completion(agendaInitError)
			return
		}
		agendaDB.document(documentId).updateData([
			"isActive": isActive
		])
		completion(nil)
	}
	
}

