import SwiftUI

struct LibreView: View {
    @Bindable private var vm = GlucoseVM()
    
    @State private var data: [GlucoseData] = []
    @State private var stringData = ""
    
    var body: some View {
        List {
            Section {
                DatePicker("Record date", selection: $vm.recordDate, displayedComponents: .date)
                
                Button("Import data from LibreView") {
                    importFromLibreView()
                }
                
                if !data.isEmpty {
                    Button("Save to Apple Health") {
                        saveRecords()
                    }
                }
            }
            .foregroundStyle(.foreground)
            
            ForEach(data, id: \.self) {
                LibreViewRecordCard($0)
            }
        }
        .onChange(of: vm.recordDate) { _, newDate in
            data = vm.joinDataAndDates(
                vm.extractData(stringData),
                vm.createDates(newDate)
            )
        }
        .task {
            data = vm.joinDataAndDates(
                vm.extractData(stringData),
                vm.createDates(vm.recordDate)
            )
        }
    }
    
    private func saveRecords() {
        for record in data {
            vm.saveGlucoseLevel(amount: record.data, date: record.date)
        }
        
        stringData = ""
        data = []
    }
    
    private func importFromLibreView() {
        if let string = UIPasteboard.general.string {
            stringData = string
            
            data = vm.joinDataAndDates(
                vm.extractData(stringData),
                vm.createDates(vm.recordDate)
            )
        }
    }
}

#Preview {
    LibreView()
}
