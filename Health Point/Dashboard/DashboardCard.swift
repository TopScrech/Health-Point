import SwiftUI

struct DashboardCard: View {
    private let title: String
    private let icon: String
    private let iconColor: Color
    private let value: String
    private let unit: String?
    
    init(title: String, icon: String, iconColor: Color, value: String, unit: String? = nil) {
        self.title = title
        self.icon = icon
        self.iconColor = iconColor
        self.value = value
        self.unit = unit
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: icon)
                    .title()
                    .symbolVariant(.fill)
                    .foregroundStyle(iconColor.gradient)
                
                Text(title)
                    .title3(.semibold)
            }
            
            HStack(alignment: .bottom, spacing: 5) {
                Text(value)
                    .largeTitle(.semibold)
                
                if let unit {
                    Text(unit)
                        .secondary()
                        .offset(y: -4)
                }
            }
        }
        .frame(maxWidth: 180, alignment: .leading)
        .padding()
        .background(.ultraThinMaterial, in: .rect(cornerRadius: 16))
        //        .overlay {
        //            RoundedRectangle(cornerRadius: 16)
        //                .stroke(.red.gradient, lineWidth: 1)
        //        }
    }
}

#Preview {
    Dashboard()
        .darkSchemePreferred()
}
