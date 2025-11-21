import SwiftUI
import HealthKit
import HealthyKit

struct HealthList: View {
    @EnvironmentObject private var store: ValueStore
    
    private let healthStore = HKHealthStore()
    
    @State private var bounce = false
    
    var body: some View {
        VStack {
            Image(systemName: "heart")
                .largeTitle()
                .symbolRenderingMode(.multicolor)
                .symbolEffect(.bounce, options: .repeating, value: bounce)
                .onAppear {
                    bounce.toggle()
                }
            
            Button("Request access") {
                requestAccess()
            }
            .padding()
            
            Button("Fetch workouts") {
                fetchWorkouts()
            }
            .padding()
            
            Button("Fetch hearthrate") {
                fetchHeartrate()
            }
            .padding()
        }
    }
    
    private func requestAccess() {
        let heartRate = HKObjectType.quantityType(forIdentifier: .heartRate)!
        let bodyMassIndex = HKObjectType.quantityType(forIdentifier: .bodyMassIndex)!
        let workout = HKObjectType.workoutType()
        let shareTypes: Set = [bodyMassIndex]
        let readTypes: Set = [heartRate, bodyMassIndex, workout]
        
        healthStore.requestAuthorization(toShare: shareTypes, read: readTypes) { success, error in
            if let error {
                print("Error requesting authorization:", error.localizedDescription)
            }
            
            if success {
                print("Authorization successful")
            }
        }
    }
    
    private func fetchHeartrate() {
        let heartRateUnit = HKUnit(from: "count/min")
        
        let endDate = Date()
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: endDate)
        let mostRecentPredicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        let heartRateQuery = HKSampleQuery(
            sampleType: HKQuantityType.heartRate,
            predicate: mostRecentPredicate,
            limit: HKObjectQueryNoLimit,
            sortDescriptors: [sortDescriptor]
        ) { _, results, error in
            
            if let error {
                print("Error retrieving heart rate data:", error.localizedDescription)
                return
            }
            
            guard let results = results as? [HKQuantitySample] else {
                return
            }
            
            for sample in results {
                let rate = sample.quantity.doubleValue(for: heartRateUnit)
                print("Heart rate:", rate)
            }
        }
        
        healthStore.execute(heartRateQuery)
    }
    
    private func fetchWorkouts() {
        let predicate = HKQuery.predicateForWorkouts(with: .running)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        let workoutQuery = HKSampleQuery (
            sampleType: .workoutType(),
            predicate: predicate,
            limit: HKObjectQueryNoLimit,
            sortDescriptors: [sortDescriptor]
        ) { _, results, error in
            
            if let error {
                print("Error retrieving workouts:", error.localizedDescription)
                return
            }
            
            guard let results = results as? [HKWorkout] else {
                return
            }
            
            for workout in results {
                print("Workout:", workout)
            }
        }
        
        healthStore.execute(workoutQuery)
    }
}

#Preview {
    HealthList()
        .darkSchemePreferred()
        .environmentObject(ValueStore())
}
