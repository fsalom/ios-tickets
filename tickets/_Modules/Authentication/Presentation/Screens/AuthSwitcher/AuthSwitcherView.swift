import SwiftUI
import TripleA

struct AuthSwitcherView: View {
    @EnvironmentObject var authenticator: AuthenticatorSUI
    @EnvironmentObject var deepLinkManager: DeepLinkManager
    @StateObject var viewModel: AuthSwitcherViewModel

    var body: some View {
        switch authenticator.screen {
            case .login:
                NavigationStack {
                    LoginViewBuilder().build(isSocialLoginActived: true)
                }
            case .home:
                NavigationStack {
                    TabbarView()
                }
            case .loading:
                ProgressView()
        }
    }
}
