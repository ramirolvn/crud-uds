//
//  UserCrudService.swift
//  crud-uds
//
//  Created by Ramiro Lima Vale Neto on 24/01/20.
//  Copyright © 2020 Ramiro Lima Vale Neto. All rights reserved.
//

import Foundation
import FirebaseAuth

protocol UserCrudServiceProtocol {
	func userRegisterWithEmail(_ email: String, name:String, password: String, completion: @escaping (_ user: User?, _ error: String?)->())
	func userSignInWithEmail(_ email: String, password: String, completion: @escaping (_ user: User?, _ error: String?)->())
	func sendPasswordReset(email: String, completion: @escaping (_ error: String?)->())
	func logoutUser(completion: @escaping (_ error: String?)->())
}


class UserCrudService: UserCrudServiceProtocol {
	
	init() {
		print("INITIALIZATION -> UserCrudService")
	}
	
	public func userRegisterWithEmail(_ email: String, name:String, password: String, completion: @escaping (_ user: User?, _ error: String?)->()){
		Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
			guard let user = authResult?.user else {
				if let error = error, let auth = AuthErrorCode(rawValue: error._code){
					completion(nil,auth.errorMessage)
				}
				return
			}
			guard let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest() else {
				completion(user,nil)
				return
			}
			changeRequest.displayName = name
			changeRequest.commitChanges { (error) in
				completion(user,nil)
			}
		}
	}
	
	public func userSignInWithEmail(_ email: String, password: String, completion: @escaping (_ user: User?, _ error: String?)->()){
		Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
			guard let user = authResult?.user else {
				if let error = error, let auth = AuthErrorCode(rawValue: error._code){
					completion(nil,auth.errorMessage)
				}
				return
			}
			completion(user,nil)
		}
	}
	
	public func sendPasswordReset(email: String, completion: @escaping (_ error: String?)->()){
		Auth.auth().sendPasswordReset(withEmail: email) { error in
			guard let error = error, let auth = AuthErrorCode(rawValue: error._code) else {
				completion(nil)
				return
			}
			completion(auth.errorMessage)
		}
	}
	
	public func logoutUser(completion: @escaping (_ error: String?)->()){
		do{
			try Auth.auth().signOut()
			completion(nil)
		}
		catch let error{
			if let auth = AuthErrorCode(rawValue: error._code){
				completion(auth.errorMessage)
			}
		}
	}
	
	
	
	
}
