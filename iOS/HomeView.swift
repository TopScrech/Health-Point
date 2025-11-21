import SwiftUI

struct HomeView: View {
    @AppStorage("last_tab") private var lastTab = 0
    
    var body: some View {
        TabView(selection: $lastTab) {
            Tab("Dashboard", systemImage: "house", value: 0) {
                Dashboard()
            }
        }
    }
}

#Preview {
    HomeView()
        .darkSchemePreferred()
}
