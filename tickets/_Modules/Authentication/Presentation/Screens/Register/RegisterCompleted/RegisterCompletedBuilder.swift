//
//  RegisterCompletedBuilder.swift
//  Gula
//
//  Created by María on 5/8/24.
//

import Foundation

class RegisterCompletedBuilder {
    func build() -> RegisterCompletedView {
        let viewModel = RegisterCompletedViewModel()
        let view = RegisterCompletedView(viewModel: viewModel)
        return view
    }
}
