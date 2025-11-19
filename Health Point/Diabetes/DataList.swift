import ScrechKit

struct DataList: View {
    private var vm = DiabetesVM()
    
    var body: some View {
        List {
            NavigationLink("LibreView") {
                LibreView()
            }
            
            ForEach(Array(vm.recordsByDay.enumerated()), id: \.offset) { _, dayRecords in
#warning("split")
                Section(dayRecords.first?.date.formatted(date: .long, time: .omitted) ?? "") {
                    ForEach(dayRecords, id: \.id) { record in
                        HStack {
                            if record.type == .insulin(.bolus) {
                                Image(systemName: "syringe")
                            } else {
                                Image(systemName: "syringe.fill")
                                    .foregroundStyle(.purple)
                            }
                            
                            Text(record.data)
                            
                            Spacer()
                            
                            Text(timeFromDate(record.date))
                                .footnote()
                                .foregroundStyle(.secondary)
                        }
                        .contextMenu {
                            Button("Edit", systemImage: "pencil") {
#warning("Does nothing")
                            }
                            
                            Section {
                                Button("Delete", systemImage: "trash", role: .destructive) {
                                    delete(record)
                                }
                            }
                        }
                    }
                }
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
        .refreshableTask {
            vm.readInsulin()
        }
    }
    
    private func delete(_ record: DataRecord) {
        vm.deleteRecord(record) { error, success in
            //            if let error {
            //                print(error.localizedDescription)
            //            } else {
            //                print("Success:", success)
            //            }
        }
    }
}

#Preview {
    DataList()
}
