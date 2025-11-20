import SwiftUI

struct DashboardCard: View {
    private let title: String
    private let icon: String
    private let value: String
    private let unit: String?
    
    init(title: String, icon: String, value: String, unit: String? = nil) {
        self.title = title
        self.icon = icon
        self.value = value
        self.unit = unit
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: icon)
                
                Text(title)
            }
            
            HStack {
                Text(value)
                
                if let unit {
                    Text(unit)
                        .secondary()
                }
            }
        }
        .frame(maxWidth: 180)
        .padding(.vertical)
        .background(.ultraThinMaterial, in: .rect(cornerRadius: 16))
    }
}

#Preview {
    Dashboard()
        .darkSchemePreferred()
}
