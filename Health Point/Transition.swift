import SwiftUI

struct NumericContentTransitionModifier: ViewModifier {
    let newValue: Double
    let oldValue: Double
    
    private var oldValueBigger: Bool {
        oldValue > newValue
    }
    
    func body(content: Content) -> some View {
        content
            .contentTransition(.numericText(countsDown: oldValueBigger))
    }
}
