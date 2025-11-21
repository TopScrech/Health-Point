import SwiftUI

struct Dashboard: View {
    private let columns = [
        GridItem(.flexible(minimum: 100, maximum: 200)),
        GridItem(.flexible(minimum: 100, maximum: 200))
    ]
    
    var body: some View {
        LazyVGrid(columns: columns) {
            DashboardCard(title: "Steps", icon: "figure.walk", iconColor: .yellow, value: "911")
            DashboardCard(title: "Heart Rate", icon: "heart", iconColor: .red, value: "80", unit: "bpm")
            DashboardCard(title: "Oxygen", icon: "drop", iconColor: .blue, value: "98", unit: "%")
            DashboardCard(title: "Weight", icon: "scalemass", iconColor: .blue, value: "101.14", unit: "kg")
            DashboardCard(title: "Height", icon: "ruler", iconColor: .purple, value: "177", unit: "cm")
            DashboardCard(title: "Blood Press.", icon: "blood.pressure.cuff", iconColor: .red, value: "120/76", unit: "mmHg")
            DashboardCard(title: "Carbs", icon: "carrot", iconColor: .green, value: "120", unit: "g")
            DashboardCard(title: "Insulin", icon: "syringe", iconColor: .blue, value: "16", unit: "units")
            DashboardCard(title: "Calories", icon: "flame", iconColor: .orange, value: "2000", unit: "kcal")
            DashboardCard(title: "Blood Glucose", icon: "waveform.path.ecg.rectangle", iconColor: .red, value: "16.16", unit: "mmol/L")
            DashboardCard(title: "Handwashing", icon: "hands.and.sparkles", iconColor: .blue, value: "20", unit: "sec (avg)")
            DashboardCard(title: "Sleep", icon: "bed.double", iconColor: .purple, value: "4:58")
        }
    }
}

#Preview {
    Dashboard()
        .darkSchemePreferred()
}
