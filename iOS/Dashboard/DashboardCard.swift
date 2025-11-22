import SwiftUI

struct DashboardCard: View {
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    
    private let title: String
    private let icon: String
    private let iconColor: Color
    private let value: String
    private let unit: String?
    
    init(_ title: String, icon: String, iconColor: Color, value: String, unit: String? = nil) {
        self.title = title
        self.icon = icon
        self.iconColor = iconColor
        self.value = value
        self.unit = unit
    }
    
    @State private var beatAnimation = false
    @State private var showPusles = false
    @State private var pulsedHearts: [HeartParticle] = []
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                if title == "Heart Rate" {
                    if reduceMotion {
                        Image(systemName: "heart.fill")
                            .foregroundStyle(iconColor.gradient)
                    } else {
                        HeartView(
                            beatAnimation: $beatAnimation,
                            showPusles: $showPusles,
                            pulsedHearts: $pulsedHearts,
                            addPulsedHeart: addPulsedHeart
                        )
                    }
                } else {
                    Image(systemName: icon)
                        .title()
                        .symbolVariant(.fill)
                        .foregroundStyle(iconColor.gradient)
                }
                
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
        .frame(height: 70)
        .padding()
        .background(.ultraThinMaterial, in: .rect(cornerRadius: 16))
        //        .overlay {
        //            RoundedRectangle(cornerRadius: 16)
        //                .stroke(.red.gradient, lineWidth: 1)
        //        }
        .onAppear {
            showPusles = true
            beatAnimation = true
        }
    }
    
    func addPulsedHeart() {
        let pulsedHeart = HeartParticle()
        pulsedHearts.append(pulsedHeart)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            pulsedHearts.removeAll {
                $0.id == pulsedHeart.id
            }
            
            if pulsedHearts.isEmpty {
                showPusles = false
            }
        }
    }
}

#Preview {
    Dashboard()
        .darkSchemePreferred()
}
