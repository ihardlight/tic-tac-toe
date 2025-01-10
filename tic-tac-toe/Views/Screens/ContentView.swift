import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            NavigationView {
                MainView()
            }
                .navigationTitle(NSLocalizedString("main_screen", comment: "Main Screen Title"))
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
