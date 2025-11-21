import SwiftUI

struct     HeartAnimation: View {
    @State private var beatAnimation = false
    @State private var showPusles = false
    @State private var pulsedHearts: [HeartParticle] = []
    @State private var heartBeat = 85
    
    var body: some View {
        VStack {
            ZStack {
                if showPusles {
                    TimelineView(.animation(minimumInterval: 0.7, paused: false)) { timeline in
                        
                        // Method 2
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
                        
                        /// Method 1
                        //                        Canvas { context, size in
                        //                            /// Drawing into the Canvas
                        //                            for heart in pulsedHearts {
                        //                                if let resolvedView = context.resolveSymbol(id: heart.id) {
                        //                                    let centerX = size.width / 2
                        //                                    let centerY = size.height / 2
                        //
                        //                                    context.draw(resolvedView, at: CGPoint(x: centerX, y: centerY))
                        //                                }
                        //                            }
                        //                        } symbols: {
                        //                            /// Inserting into Canvas with Unique ID
                        //                            ForEach(pulsedHearts) {
                        //                                PulseHeartView()
                        //                                    .id($0.id)
                        //                            }
                        //                        }
                        //                        .onChange(of: timeline.date) {
                        //                            if beatAnimation {
                        //                                addPulsedHeart()
                        //                            }
                        //                        }
                    }
                }
                
                Image(systemName: "suit.heart.fill")
                    .fontSize(20)
                    .foregroundStyle(.pink.gradient)
                    .symbolEffect(.bounce, options: !beatAnimation ? .default : .repeating.speed(1), value: beatAnimation)
            }
            .frame(maxWidth: 350, maxHeight: 350)
            .overlay(alignment: .bottomLeading) {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Current")
                        .title3(.bold)
                        .foregroundStyle(.white)
                    
                    HStack(alignment: .bottom, spacing: 6) {
                        if beatAnimation {
                            TimelineView(.animation(minimumInterval: 1.5, paused: false)) { timeline in
                                Text(heartBeat)
                                    .fontSize(45)
                                    .bold()
                                    .numericTransition(heartBeat)
                                    .foregroundStyle(.white)
                                    .onChange(of: timeline.date) {
                                        withAnimation(.bouncy) {
                                            heartBeat = .random(in: 80...130)
                                        }
                                    }
                            }
                        } else {
                            Text(heartBeat)
                                .fontSize(45)
                                .bold()
                                .foregroundStyle(.white)
                        }
                        
                        Text("BPM")
                            .callout(.bold)
                            .foregroundStyle(.pink.gradient)
                    }
                    .monospacedDigit()
                    
                    Text("88 BPM, 10m ago")
                        .font(.callout)
                        .foregroundStyle(.gray)
                }
                .offset(x: 30, y: -35)
            }
            .background(.bar, in: .rect(cornerRadius: 30))
            
            Toggle("Beat Animation", isOn: $beatAnimation)
                .padding(15)
                .frame(maxWidth: 350)
                .background(.bar, in: .rect(cornerRadius: 15))
                .padding(.top, 20)
                .onChange(of: beatAnimation) { _, newValue in
                    if pulsedHearts.isEmpty {
                        showPusles = true
                    }
                    
                    if newValue && pulsedHearts.isEmpty {
                        addPulsedHeart()
                    }
                }
                .disabled(!beatAnimation && !pulsedHearts.isEmpty)
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

#Preview {
    HeartAnimation()
        .darkSchemePreferred()
}
