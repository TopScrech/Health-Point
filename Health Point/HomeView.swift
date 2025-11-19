import SwiftUI

struct HomeView: View {
    @State private var sheetInsulin = false
    
    var body: some View {
        VStack {
            DataList()
            
            Button("New injection") {
                sheetInsulin = true
            }
        }
        .sheet($sheetInsulin) {
            InsulinView()
        }
    }
}

#Preview {
    HomeView()
}
