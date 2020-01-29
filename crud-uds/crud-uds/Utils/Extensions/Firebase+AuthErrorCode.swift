//
//  Firebase+AuthErrorCode.swift
//  crud-uds
//
//  Created by Ramiro Lima Vale Neto on 25/01/20.
//  Copyright © 2020 Ramiro Lima Vale Neto. All rights reserved.
//

import Foundation
import FirebaseAuth

extension AuthErrorCode {
    var errorMessage: String {
        switch self {
        case .emailAlreadyInUse:
            return "Este e-mail já está sendo usado em outra conta!"
        case .userNotFound:
            return "Conta não encontrada para este usuário. Por favor cheque os dados e tente novamente!"
        case .userDisabled:
            return "Sua conta foi desabilitada. Por favor contate o Ramiro Lima."
        case .invalidEmail, .invalidSender, .invalidRecipientEmail:
            return "Por favor digite um e-mail válido!"
        case .networkError:
            return "Erro de coneção. Por favor tente novamente"
        case .weakPassword:
            return "Senha muito fraca. A senha deve conter pelo menos 6 caractéres"
        case .wrongPassword:
            return "Senha incorreta.Por favor tente de novo ou aperte 'Esqueci minha senha' para recebê-la por e-mail!"
        default:
            return "Erro desconhecido"
        }
    }
}
