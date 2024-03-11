import HealthKit

struct DataRecord {
    let id = UUID()
    
    let data: String
    let type: DataType
    let date: Date
    let healthKitObject: HKQuantitySample
}

enum DataType: Equatable {
    case insulin(_ type: InsulinType), glucose
}

enum InsulinType: String {
    case basal, bolus
}
