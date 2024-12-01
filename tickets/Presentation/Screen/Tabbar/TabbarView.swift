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
                    Label("Search", systemImage: "magnifyingglass")
                }

            ProfileBuilder().build()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
        }
        .accentColor(.black)
    }
}
