//
//  SuccesConfig.swift
//  Gula
//
//  Created by Jesu Castellano on 6/11/24.
//

import Foundation
import SwiftUI

struct SuccesConfig {
    let title: String
    let message: LocalizedStringKey
    let parameter: String?
    let messageType: MessageType
    
    enum MessageType {
        case changeEmail
        case recoverPassword
    }
}
