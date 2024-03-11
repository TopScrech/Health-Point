import ScrechKit
import HealthKit

struct HealthList: View {
    @AppStorage("isAuthorised") private var isAuthorised = false
    
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
                let heartRate = HKObjectType.quantityType(forIdentifier: .heartRate)!
                let bodyMassIndex = HKObjectType.quantityType(forIdentifier: .bodyMassIndex)!
                let workout = HKObjectType.workoutType()
                let shareTypes: Set = [bodyMassIndex]
                let readTypes: Set = [heartRate, bodyMassIndex, workout]
                
                main {
                    healthStore.requestAuthorization(toShare: shareTypes, read: readTypes) { (success, error) in
                        if let error {
                            print("Error requesting authorization: \(error.localizedDescription)")
                        }
                        
                        if success {
                            print("Authorization successful")
                        }
                    }
                }
            }
            .padding()
            
            Button("Fetch workouts") {
                let workout = HKObjectType.workoutType()
                let predicate = HKQuery.predicateForWorkouts(with: .running)
                let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
                
                let workoutQuery = HKSampleQuery (
                    sampleType: workout,
                    predicate: predicate,
                    limit: HKObjectQueryNoLimit,
                    sortDescriptors: [sortDescriptor]
                ) { query, results, error in
                    
                    if let error {
                        print("Error retrieving workouts: \(error.localizedDescription)")
                        return
                    }
                    
                    guard let results = results as? [HKWorkout] else { return }
                    
                    for workout in results {
                        print("Workout: \(workout)")
                    }
                }
                
                healthStore.execute(workoutQuery)
            }
            .padding()
            
            Button("Fetch hearthrate") {
                let heartRateUnit = HKUnit(from: "count/min")
                let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
                
                let endDate = Date()
                let startDate = Calendar.current.date(byAdding: .day, value: -7, to: endDate)
                
                let mostRecentPredicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
                let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
                
                let heartRateQuery = HKSampleQuery (
                    sampleType: heartRateType,
                    predicate: mostRecentPredicate,
                    limit: HKObjectQueryNoLimit,
                    sortDescriptors: [sortDescriptor]
                ) { query, results, error in
                    
                    if let error {
                        print("Error retrieving heart rate data: \(error.localizedDescription)")
                        return
                    }
                    
                    guard let results = results as? [HKQuantitySample] else { return }
                    
                    for sample in results {
                        let rate = sample.quantity.doubleValue(for: heartRateUnit)
                        print("Heart Rate: \(rate)")
                    }
                }
                
                healthStore.execute(heartRateQuery)
            }
            .padding()
        }
    }
}

#Preview {
    HealthList()
}
