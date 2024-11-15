//
//  FakeViewForChangeEmailConfirmationBuilder.swift
//  Gula
//
//  Created by Jorge Miguel on 6/11/24.
//

import Foundation

class FakeViewToShowToastOfAccountChangeBuilder {
    func build(_ typeChange: AccountParamChange) -> FakeViewToShowToastOfAccountChangeView {
        let viewModel = FakeViewToShowToastOfAccountChangeViewModel(typeChange: typeChange)
        let view = FakeViewToShowToastOfAccountChangeView(viewModel: viewModel)
        return view
    }
}
