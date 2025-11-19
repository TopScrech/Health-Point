import Foundation

struct GlucoseData: Hashable {
    let data: Double
    let date: Date
    
    init(_ data: Double, _ date: Date) {
        self.data = data
        self.date = date
    }
}
