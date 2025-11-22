import SwiftUI

struct HeartView: View {
    @Binding var beatAnimation: Bool
    @Binding var showPusles: Bool
    @Binding var pulsedHearts: [HeartParticle]
    let addPulsedHeart: () -> Void
    
    var body: some View {
        ZStack {
            if showPusles {
                TimelineView(.animation(minimumInterval: 1.4, paused: false)) { timeline in
                    ZStack {
                        /// Inserting into Canvas with Unique ID
                        ForEach(pulsedHearts) { _ in
                            PulseHeartView()
                        }
                    }
                    .onChange(of: timeline.date) {
                        if beatAnimation {
                            addPulsedHeart()
                        }
                    }
                }
            }
            
            Image(systemName: "suit.heart.fill")
                .fontSize(20)
                .foregroundStyle(.pink.gradient)
                .symbolEffect(.bounce, options: !beatAnimation ? .default : .repeating.speed(1), value: beatAnimation)
        }
    }
}

struct PulseHeartView: View {
    @State private var startAnimation = false
    
    var body: some View {
        Image(systemName: "suit.heart.fill")
            .fontSize(20)
            .foregroundStyle(.pink)
            .background {
                Image(systemName: "suit.heart.fill")
                    .fontSize(20)
                    .foregroundStyle(.black)
                    .blur(radius: 5, opaque: false)
                    .scaleEffect(startAnimation ? 1.1 : 0)
                    .animation(.linear(duration: 1.5), value: startAnimation)
            }
            .scaleEffect(startAnimation ? 2 : 1)
            .opacity(startAnimation ? 0 : 0.7)
            .onAppear {
                withAnimation(.linear(duration: 3)) {
                    startAnimation = true
                }
            }
    }
}
