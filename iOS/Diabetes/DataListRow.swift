import ScrechKit

struct DataListRow: View {
    @Environment(DiabetesVM.self) private var vm
    
    private let dayRecords: [DataRecord]
    
    init(_ dayRecords: [DataRecord]) {
        self.dayRecords = dayRecords
    }
    
    var body: some View {
        Section(dayRecords.first?.date.formatted(date: .long, time: .omitted) ?? "") {
            ForEach(dayRecords, id: \.id) { record in
#warning("Split & rename")
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

//#Preview {
//    List {
//        DataListRow()
//    }
//    .darkSchemePreferred()
//}
