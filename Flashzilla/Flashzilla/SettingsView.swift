//
//  SettingsView.swift
//  Flashzilla
//
//  Created by Andreas Zwikirsch on 12.09.22.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var leftHandMode: Bool
    @Binding var retryIncorrectCards: Bool

    var body: some View {
        NavigationView {
            Form {
                Section(footer: Text("Turn on left hand mode")) {
                    Toggle(isOn: $leftHandMode) {
                        Text("Left-Hand Mode")
                    }
                }
                
                Section(footer: Text("Cards for which you did not know the answer will go back to the end of the stack")) {
                    Toggle(isOn: $retryIncorrectCards) {
                        Text("Retry incorrect cards")
                    }
                }
            }
            .navigationBarTitle("Settings")
            .navigationBarItems(trailing: Button("Done", action: dismiss))
        }
    }

    func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(leftHandMode: Binding.constant(false), retryIncorrectCards: Binding.constant(false))
    }
}
