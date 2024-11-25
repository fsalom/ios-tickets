import Foundation

class AuthSwitcherViewBuilder {
    func build(isSocialLoginActived: Bool) -> AuthSwitcherView {
        let viewModel = AuthSwitcherViewModel()
        let view = AuthSwitcherView(viewModel: viewModel)
        return view
    }
}
