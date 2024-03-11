import Foundation
import HealthKit

@Observable
final class GlucoseVM {
    private let healthStore = HKHealthStore()
    
    var recordDate = Date()
    
    func saveGlucoseLevel(amount: Double, date: Date) {
        guard let glucoseType = HKObjectType.quantityType(forIdentifier: .bloodGlucose) else {
            print("Glucose Type is unavailable in HealthKit")
            return
        }
        
        let glucoseAmountInMgDL = amount * 18.0182
        let glucoseUnit = HKUnit(from: "mg/dL")
        let glucoseQuantity = HKQuantity(
            unit: glucoseUnit,
            doubleValue: glucoseAmountInMgDL
        )
        
        let glucoseSample = HKQuantitySample(
            type: glucoseType,
            quantity: glucoseQuantity,
            start: date,
            end: date
        )
        
        healthStore.save(glucoseSample) { success, error in
            if let error {
                print("Error saving glucose level: \(error.localizedDescription)")
            } else {
                print("Successfully saved glucose level")
            }
        }
    }
    
    func extractData(_ data: String) -> [Double] {
        let split = data.split(separator: "\n")
        
        let doubles = split.compactMap {
            Double($0)
        }
        
        var averages = [Double]()
        for index in stride(from: 0, to: doubles.count, by: 2) {
            let average = (doubles[index] + doubles[index + 1]) / 2
            averages.append(round(average * 10) / 10)
        }
        
        return averages
    }
    
    func createDates(_ givenDate: Date) -> [Date] {
        let calendar = Calendar.current
        
        var dates: [Date] = []
        
        for hour in 0..<24 {
            var dateComponents = calendar.dateComponents([.year, .month, .day], from: givenDate)
            dateComponents.hour = hour
            dateComponents.minute = 30
            
            if let hourDate = calendar.date(from: dateComponents) {
                dates.append(hourDate)
            }
        }
        
        return dates
    }
    
    func joinDataAndDates(_ data: [Double], _ dates: [Date]) -> [GlucoseData] {
        var jointData: [GlucoseData] = []
        
        for index in 0..<data.count {
            jointData.append(.init(data[index], dates[index]))
        }
        
        return jointData
    }
}
