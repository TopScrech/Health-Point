import SwiftUI

struct LibreView: View {
    @Bindable private var vm = GlucoseVM()
    
    @State private var data: [GlucoseData] = []
    @State private var stringData = ""
    
    var body: some View {
        List {
            Section {
                DatePicker("Record date", selection: $vm.recordDate, displayedComponents: .date)
                
                Button {
                    if let string = UIPasteboard.general.string {
                        stringData = string
                        
                        data = vm.joinDataAndDates(
                            vm.extractData(stringData),
                            vm.createDates(vm.recordDate)
                        )
                    }
                } label: {
                    Text("Import data from LibreView")
                }
                
                if !data.isEmpty {
                    Button {
                        for record in data {
                            vm.saveGlucoseLevel(
                                amount: record.data,
                                date: record.date
                            )
                        }
                        
                        stringData = ""
                        data = []
                    } label: {
                        Text("Save to Apple Health")
                    }
                }
            }
            .foregroundStyle(.foreground)
            
            ForEach(data, id: \.self) { record in
                HStack {
                    Text(record.data)
                    
                    Spacer()
                    
                    Text(record.date, format: .dateTime)
                        .footnote()
                        .foregroundStyle(.secondary)
                }
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
}

#Preview {
    LibreView()
}
