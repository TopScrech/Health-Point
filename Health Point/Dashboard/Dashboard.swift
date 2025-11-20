import SwiftUI

struct Dashboard: View {
    private let gridItems: [GridItem] = [
        GridItem(.flexible(minimum: 100, maximum: 200)),
        GridItem(.flexible(minimum: 100, maximum: 200))
    ]
    
    var body: some View {
        LazyVGrid(columns: gridItems) {
            DashboardCard(title: "Steps", icon: "figure.walk", value: "911")
            DashboardCard(title: "Heart Rate", icon: "heart", value: "80", unit: "bpm")
        }
    }
}

#Preview {
    Dashboard()
        .darkSchemePreferred()
}
