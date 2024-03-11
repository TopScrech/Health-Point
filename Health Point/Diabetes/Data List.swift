import ScrechKit

struct DataList: View {
    private var vm = DiabetesVM()
    
    var body: some View {
        List {
            NavigationLink {
                LibreView()
            } label: {
                Text("LibreView")
            }
            
            ForEach(Array(vm.recordsByDay.enumerated()), id: \.offset) { _, dayRecords in
                Section(header: Text(dayRecords.first?.date.formatted(date: .long, time: .omitted) ?? "")) {
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
                            Button {
                                
                            } label: {
                                Label("Edit", systemImage: "pencil")
                            }
                            
                            Section {
                                Button(role: .destructive) {
                                    vm.deleteRecord(record) { error, success in
//                                        if let error {
//                                            print(error.localizedDescription)
//                                        } else {
//                                            print("Success: \(success)"
//                                        }
                                    }
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }
                }
            }
            
            Section {
                Button {
                    vm.fetchInsulinDelivery()
                } label: {
                    Text("Fetch insulin")
                }
                
                Button {
                    vm.fetchGlucoseData()
                } label: {
                    Text("Fetch glucose")
                }
            }
        }
        .navigationTitle("Insulin Delivery")
        .refreshableTask {
            vm.fetchInsulinDelivery()
        }
    }
}

#Preview {
    DataList()
}
