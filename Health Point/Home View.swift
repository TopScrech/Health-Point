import SwiftUI

struct HomeView: View {
    @State private var sheetInsulin = false
    
    var body: some View {
        VStack {
            DataList()
            
            Button {
                sheetInsulin = true
            } label: {
                Text("New injection")
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
