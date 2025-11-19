import HealthKit

struct DataRecord: Identifiable {
    let id = UUID()
    
    let data: String
    let type: DataType
    let date: Date
    let healthKitObject: HKQuantitySample
}

enum DataType: Equatable {
    case glucose, insulin(_ type: InsulinType)
}

enum InsulinType: String, Identifiable, CaseIterable {
    case basal, bolus
    
    var id: String {
        self.rawValue
    }
}
