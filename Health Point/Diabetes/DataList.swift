import ScrechKit

struct DataList: View {
    private var vm = DiabetesVM()
    
    var body: some View {
        List {
            NavigationLink("LibreView") {
                LibreView()
            }
            
            ForEach(Array(vm.recordsByDay.enumerated()), id: \.offset) { _, dayRecords in
                DataListRow(dayRecords)
            }
            
            Section {
                Button("Fetch insulin") {
                    vm.readInsulin()
                }
                
                Button("Fetch glucose") {
                    vm.fetchGlucoseData()
                }
            }
        }
        .navigationTitle("Insulin Delivery")
        .environment(vm)
        .refreshableTask {
            vm.readInsulin()
        }
    }
}

#Preview {
    DataList()
}
