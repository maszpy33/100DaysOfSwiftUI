//
//  SettingsView.swift
//  edutainment
//
//  Created by Andreas Zwikirsch on 21.10.21.
//

import Foundation
import SwiftUI



struct SettingsView: View {
    @State private var settingIsShowing = true
    
    var body: some View {
        VStack {
            Text("Hello Settings World!")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView().preferredColorScheme(.dark)
    }
}
