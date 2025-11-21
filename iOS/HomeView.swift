import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var store: ValueStore
    
    var body: some View {
        TabView(selection: $store.lastTab) {
            Tab("Dashboard", systemImage: "house", value: 0) {
                Dashboard()
            }
        }
    }
}

#Preview {
    HomeView()
        .darkSchemePreferred()
        .environmentObject(ValueStore())
}
