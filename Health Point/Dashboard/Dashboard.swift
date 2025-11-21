import SwiftUI

struct Dashboard: View {
    private let gridItems: [GridItem] = [
        GridItem(.flexible(minimum: 100, maximum: 200)),
        GridItem(.flexible(minimum: 100, maximum: 200))
    ]
    
    var body: some View {
        LazyVGrid(columns: gridItems) {
            DashboardCard(title: "Steps", icon: "figure.walk", iconColor: .yellow, value: "911")
            DashboardCard(title: "Heart Rate", icon: "heart", iconColor: .red, value: "80", unit: "bpm")
            DashboardCard(title: "Oxygen", icon: "drop", iconColor: .blue, value: "98", unit: "%")
            DashboardCard(title: "Weight", icon: "scalemass", iconColor: .blue, value: "101.14", unit: "kg")
            DashboardCard(title: "Height", icon: "ruler", iconColor: .purple, value: "177", unit: "cm")
            DashboardCard(title: "Blood Press.", icon: "blood.pressure.cuff", iconColor: .red, value: "120/76", unit: "mmHg")
            DashboardCard(title: "Carbs", icon: "carrot", iconColor: .green, value: "120", unit: "g")
            DashboardCard(title: "Insulin", icon: "syringe", iconColor: .blue, value: "16", unit: "units")
            DashboardCard(title: "Calories", icon: "flame", iconColor: .orange, value: "2000", unit: "kcal")
        }
    }
}

#Preview {
    Dashboard()
        .darkSchemePreferred()
}
