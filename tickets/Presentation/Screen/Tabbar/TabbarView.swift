import SwiftUI

struct TabbarView: View {
    var body: some View {
        TabView {
            HomeViewBuilder().build()
                .tabItem {
                    Label("Home", systemImage: "house")
                }

            PreviewerBuilder().build()
                .tabItem {
                    Label("Cámara", systemImage: "camera")
                }

            ProfileBuilder().build()
                .tabItem {
                    Label("Perfil", systemImage: "person")
                }
        }
        .accentColor(.black)
    }
}
