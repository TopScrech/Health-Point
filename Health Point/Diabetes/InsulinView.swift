import SwiftUI

struct InsulinView: View {
    @Bindable private var vm = DiabetesVM()
    @Environment(\.dismiss) private var dismiss
    
    @AppStorage("amount_insulin") private var amountInsulin = 5.0
    @AppStorage("selected_insulin") private var selectedInsulin: InsulinType = .bolus
    
    var body: some View {
        VStack(spacing: 25) {
            Spacer()
            
            DatePicker("Date and time", selection: $vm.recordDate)
                .datePickerStyle(.compact)
                .padding(.horizontal)
            
            Text(vm.timeDifference)
            
            Picker("Insulin Type", selection: $selectedInsulin) {
                ForEach(InsulinType.allCases) {
                    Text($0.rawValue)
                        .tag($0)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            
            HStack(spacing: 50) {
                Button {
                    vm.previousValue = amountInsulin
                    amountInsulin -= 1
                } label: {
                    Text("-1")
                        .padding()
                        .foregroundStyle(.white)
                        .background(.red, in: .rect(cornerRadius: 16))
                }
                
                Text(amountInsulin)
                    .monospaced()
                    .animation(.default, value: amountInsulin)
                    .modifier(NumericContentTransitionModifier(newValue: amountInsulin, oldValue: vm.previousValue))
                
                Button {
                    vm.previousValue = amountInsulin
                    amountInsulin += 1
                } label: {
                    Text("+1")
                        .padding()
                        .foregroundStyle(.white)
                        .background(.green, in: .rect(cornerRadius: 16))
                }
            }
            .title(.semibold)
            
            Spacer()
            
            Button {
                save()
            } label: {
                Text("Save")
                    .title3(.semibold)
                    .foregroundStyle(.white)
                    .frame(width: .infinity, height: 60)
                    .frame(maxWidth: .infinity)
                    .background(.blue, in: .rect(cornerRadius: 20))
            }
            .padding(.horizontal)
        }
        .task {
            vm.previousValue = amountInsulin
        }
    }
    
    private func save() {
        // METADATA???
        vm.saveInsulinDelivery(amount: amountInsulin, type: selectedInsulin, date: vm.recordDate)
        
        dismiss()
    }
}

#Preview {
    InsulinView()
}
