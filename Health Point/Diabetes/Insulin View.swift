import SwiftUI

struct InsulinView: View {
    @Bindable var vm = DiabetesVM()
    @Environment(\.dismiss) private var dismiss
    
    @AppStorage("amount_insulin") private var amountInsulin = 5.0
    
    private let insulinTypes: [InsulinType] = [
        .basal, // Long
        .bolus  // Short
    ]
    
    @AppStorage("selected_insulin") private var selectedInsulin: InsulinType = .bolus
    
    var body: some View {
        VStack(spacing: 25) {
            Spacer()
            
            DatePicker("Date and time", selection: $vm.recordDate)
                .datePickerStyle(.compact)
                .padding(.horizontal)
            
            Text(vm.timeDifference)
            
            Picker("Insulin Type", selection: $selectedInsulin) {
                ForEach(insulinTypes, id: \.self) { type in
                    Text(type.rawValue)
                        .tag(type)
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
                vm.saveInsulinDelivery(amount: amountInsulin, type: selectedInsulin, date: vm.recordDate) // METADATA
                dismiss()
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
}

#Preview {
    InsulinView()
}
