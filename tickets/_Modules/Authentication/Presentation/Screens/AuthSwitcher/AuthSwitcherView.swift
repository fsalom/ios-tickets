import SwiftUI
import TripleA

struct AuthSwitcherView: View {
    @EnvironmentObject var authenticator: AuthenticatorSUI
    @EnvironmentObject var deepLinkManager: DeepLinkManager
    @StateObject var viewModel: AuthSwitcherViewModel
    let isSocialLoginActived: Bool

    var body: some View {
        switch authenticator.screen {
            case .login:
                NavigationStack {
                    LoginViewBuilder().build(isSocialLoginActived: isSocialLoginActived)
                }
            case .home:
            EmptyView()
                
        }
    }
}
