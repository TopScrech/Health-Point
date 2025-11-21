import SwiftUI

final class ValueStore: ObservableObject {
    @AppStorage("amount_insulin") var amountInsulin = 5.0
    @AppStorage("selected_insulin") var selectedInsulin: InsulinType = .bolus
    
    @AppStorage("last_tab") var lastTab = 0
    
    @AppStorage("isAuthorised") var isAuthorised = false
}
