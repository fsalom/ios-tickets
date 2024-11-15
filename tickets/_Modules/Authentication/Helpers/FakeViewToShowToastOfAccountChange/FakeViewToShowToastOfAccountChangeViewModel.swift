//
//  FakeViewForChangeEmailConfirmationViewModel.swift
//  Gula
//
//  Created by Jorge Miguel on 6/11/24.
//

import Foundation

enum AccountParamChange {
    case email
    case password
}

class FakeViewToShowToastOfAccountChangeViewModel: ObservableObject {
    // MARK: - UIState
    struct UIState {
        var hasEmailChanged = false
        var hasPasswordChanged = false
    }
    // MARK: - Properties
    @Published var uiState = UIState()
    var typeChange: AccountParamChange

    init(typeChange: AccountParamChange) {
        self.typeChange = typeChange
    }
}
