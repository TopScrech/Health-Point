import Foundation
import HealthyKit
import Algorithms

@Observable
final class DiabetesVM {
    private let healthStore: HKHealthStore
    
    init() {
        healthStore = HKHealthStore()
        requestAccess()
    }
    
    var recordDate = Date()
    
    var timeDifference: String {
        timeDifferenceFromNow(recordDate)
    }
    
    var records: [DataRecord] = []
    
    var recordsByDay: [[DataRecord]] {
        records.chunked {
            Calendar.current.isDate($0.date, equalTo: $1.date, toGranularity: .day)
        }
        .map(Array.init)
    }
    
    func deleteRecord(_ record: HKObject, completion: @escaping (Bool, Error?) -> Void) {
        healthStore.delete([record]) { success, error in
            completion(success, error)
        }
    }
    
    func timeDifferenceFromNow(_ date2: Date) -> String {
        let calendar = Calendar.current
        let date1 = Date()
        
        let components = calendar.dateComponents([.day, .hour, .minute], from: date1, to: date2)
        var timeDifference = ""
        
        if let days = components.day, days != 0 {
            timeDifference += "\(days) day"
        }
        
        if let hours = components.hour, hours != 0 {
            if !timeDifference.isEmpty { timeDifference += ", " }
            timeDifference += "\(hours) hour"
        }
        
        if let minutes = components.minute, minutes != 0 {
            if !timeDifference.isEmpty { timeDifference += ", " }
            timeDifference += "\(minutes) minute"
        }
        
        if timeDifference.contains("-") {
            let formatted = timeDifference.replacingOccurrences(of: "-", with: "") + " ago"
            return formatted
        } else {
            return timeDifference
        }
    }
    
    let glucoseType: HKQuantityType? = .bloodGlucose()
    let insulinType: HKQuantityType? = .insulinDelivery()
    let carbsType: HKQuantityType? = .dietaryCarbohydrates()
    
    private var dataTypes: Set<HKQuantityType> {
        if let glucoseType, let insulinType, let carbsType {
            Set([glucoseType, insulinType, carbsType])
        } else {
            []
        }
    }
    
    private func requestAccess() {
        healthStore.requestAuthorization(toShare: dataTypes, read: dataTypes) { success, error in
            if let error {
                print("Error requesting authorization:", error.localizedDescription)
            }
            
            if success {
                print("Authorization successful")
            }
        }
    }
    
    func readInsulin() {
        guard let insulinType = HKObjectType.quantityType(forIdentifier: .insulinDelivery) else {
            print("Insulin Delivery Type is unavailable in HealthKit")
            return
        }
        
        // from 1 month ago to now
        let endDate = Date()
        let startDate = Calendar.current.date(byAdding: .month, value: -12, to: Date())
        
        let predicate = HKQuery.predicateForSamples(
            withStart: startDate,
            end: endDate,
            options: .strictStartDate
        )
        
        let sortDescriptor = NSSortDescriptor(
            key: HKSampleSortIdentifierStartDate,
            ascending: false
        )
        
        let insulinQuery = HKSampleQuery(
            sampleType: insulinType,
            predicate: predicate,
            limit: HKObjectQueryNoLimit,
            sortDescriptors: [sortDescriptor]
        ) { _, results, error in
            if let error {
                print("Error retrieving insulin delivery data:", error.localizedDescription)
                return
            }
            
            guard let insulinSamples = results as? [HKQuantitySample] else {
                print("Could not fetch insulin delivery samples")
                return
            }
            
            var loadedRecords: [DataRecord] = []
            
            // MARK: Metadata: ["HKInsulinDeliveryReason": 2, "HKWasUserEntered": 1]
            for sample in insulinSamples {
                let insulinUnit = sample.quantity.doubleValue(for: HKUnit.internationalUnit())
                
                print("Insulin Delivered:", insulinUnit)
                print("Date:", sample.startDate)
                print("Meta:", sample.metadata?.description ?? "-")
                
                guard
                    let insulinMetadata = sample.metadata,
                    let insulinCategory = insulinMetadata["HKInsulinDeliveryReason"] as? Int
                else {
                    return
                }
                
                var insulinType: InsulinType
                insulinType = insulinCategory == 1 ? .basal : .bolus
                
                let record = DataRecord(
                    data: Int(insulinUnit).description,
                    type: .insulin(insulinType),
                    date: sample.startDate,
                    healthKitObject: sample
                )
                
                loadedRecords.append(record)
            }
            
            self.records = loadedRecords
        }
        
        healthStore.execute(insulinQuery)
    }
    
    func deleteRecord(_ record: DataRecord, completion: @escaping (Bool, Error?) -> Void) {
        healthStore.delete([record.healthKitObject]) { success, error in
            completion(success, error)
        }
    }
    
    func fetchGlucoseData() {
        guard let bloodGlucoseType = HKObjectType.quantityType(forIdentifier: .bloodGlucose) else {
            print("Blood Glucose Type is unavailable in HealthKit")
            return
        }
        
        // 1 month ago to now
        let startDate = Calendar.current.date(byAdding: .month, value: -1, to: Date())
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictStartDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        let glucoseQuery = HKSampleQuery(
            sampleType: bloodGlucoseType,
            predicate: predicate,
            limit: HKObjectQueryNoLimit,
            sortDescriptors: [sortDescriptor]
        ) { _, results, error in
            if let error {
                print("Error retrieving glucose data:", error.localizedDescription)
                return
            }
            
            guard let glucoseSamples = results as? [HKQuantitySample] else {
                print("Could not fetch glucose samples")
                return
            }
            
            let unit = HKUnit(from: "mg/dL")
            
            for sample in glucoseSamples {
                let glucoseValueMgDL = sample.quantity.doubleValue(for: unit)
                
                // Converting mg/dL to mmol/L
                let glucoseValueMmolL = glucoseValueMgDL / 18.0182
                let roundedGlucose = String(format: "%0.1f", glucoseValueMmolL)
                
                print("Glucose:", roundedGlucose, "mmol/L")
                print("Date:", sample.startDate)
            }
        }
        
        healthStore.execute(glucoseQuery)
    }
    
    func saveInsulinDelivery(amount: Double, type: InsulinType, date: Date) {
        guard let insulinDeliveryType = HKObjectType.quantityType(forIdentifier: .insulinDelivery) else {
            print("Insulin Delivery Type is unavailable in HealthKit")
            return
        }
        
        let insulinUnit = HKUnit.internationalUnit()
        let insulinQuantity = HKQuantity(unit: insulinUnit, doubleValue: amount)
        
        let insulinSample = HKQuantitySample(
            type: insulinDeliveryType,
            quantity: insulinQuantity,
            start: date,
            end: date,
            metadata: ["HKInsulinDeliveryReason": 21]
        )
        
        healthStore.save(insulinSample) { _, error in
            if let error {
                print("Error saving insulin delivery:", error.localizedDescription)
            } else {
                print("Successfully saved insulin delivery")
            }
        }
    }
}
