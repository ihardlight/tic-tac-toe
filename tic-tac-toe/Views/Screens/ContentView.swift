import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            NavigationView {
                MainView()
            }
            .navigationTitle("main_screen".localized(comment: "Main Screen Title"))
                .tabItem {
                    Image(systemName: "gamecontroller")
                }
        
            // Экран настроек
            SettingsView()
                .tabItem {
                    Image(systemName: "gear")
                }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(SettingsManager())
}
