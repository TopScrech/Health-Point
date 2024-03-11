import SwiftUI

struct NumericContentTransitionModifier: ViewModifier {
    let newValue: Double
    let oldValue: Double
    
    func body(content: Content) -> some View {
        content
            .contentTransition(newValue > oldValue ? .numericText(countsDown: false) : .numericText(countsDown: true))
    }
}
