import SwiftUI

struct LibreViewRecordCard: View {
    private let record: GlucoseData
    
    init(_ record: GlucoseData) {
        self.record = record
    }
    
    var body: some View {
        HStack {
            Text(record.data)
            
            Spacer()
            
            Text(record.date, format: .dateTime)
                .footnote()
                .foregroundStyle(.secondary)
        }
    }
}

//#Preview {
//    LibreViewRecordCard()
//        .darkSchemePreferred()
//}
