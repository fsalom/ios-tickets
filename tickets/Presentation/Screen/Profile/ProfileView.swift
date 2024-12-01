import SwiftUI

struct ProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel

    var body: some View {
        List {
        }
    }
}

#Preview {
    ProfileView(viewModel: ProfileViewModel())
}
