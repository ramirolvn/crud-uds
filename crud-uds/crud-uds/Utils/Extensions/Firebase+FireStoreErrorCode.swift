//
//  Firebase+FireStoreErrorCode.swift
//  crud-uds
//
//  Created by Ramiro Lima Vale Neto on 25/01/20.
//  Copyright © 2020 Ramiro Lima Vale Neto. All rights reserved.
//

import Foundation
import FirebaseFirestore

extension FirestoreErrorCode {
	var errorMessage: String {
		switch self {
		case .permissionDenied:
			return "Permissão negada! Por favor fale com o Ramiro Lima"
		case .alreadyExists:
			return "O objeto já existe no nosso banco!"
		case .unauthenticated:
			return "Você precisa logar para visualizar esses arquivos!"
		case .dataLoss:
			return "Tivemos um problema nos servidores, por favor tente novamente!"
		default:
			return "Erro desconhecido. Por favor tente novamente!"
		}
	}
}
