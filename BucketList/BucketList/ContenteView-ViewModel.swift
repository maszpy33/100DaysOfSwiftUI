//
//  ViewModel.swift
//  BucketList
//
//  Created by Andreas Zwikirsch on 25.07.22.
//

import Foundation
import MapKit
import LocalAuthentication


extension ContentView {
    @MainActor class ViewModel: ObservableObject {
        @Published var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 25, longitudeDelta: 25))
        @Published var locations: [Location]
        @Published var selectedPlace: Location?
        @Published var isUnlocked = false
        
        @Published var changePinStyle = false
        
        // 2. Challenge: Error message
        @Published var showErrorMessage = false
        @Published var errorTitle = ""
        @Published var errorMessage = ""
        
        @Published var showDeleteAllAlert = false
        
        let savePath = FileManager.documentsDirectory.appendingPathComponent("SavedPlaces")
        
        
        init() {
            do {
                let data = try Data(contentsOf: savePath)
                locations = try JSONDecoder().decode([Location].self, from: data)
            } catch {
                locations = []
            }
        }
        
        func save() {
            do {
                let data = try JSONEncoder().encode(locations)
                // .completeFileProtection encryptes the data
                try data.write(to: savePath, options: [.atomicWrite, .completeFileProtection])
            } catch {
                print("Unable to save data")
            }
        }
        
        func addLocation() {
            let newLocation = Location(id: UUID(), name: "New location", description: "", latitude: mapRegion.center.latitude, longitude: mapRegion.center.longitude)
            locations.append(newLocation)
            save()
        }
        
        
        
        func updateLocation(location: Location) {
            guard let selectedPlace = selectedPlace else {
                return
            }
            
            if let index = locations.firstIndex(of: selectedPlace) {
                locations[index] = location
                save()
            }
        }
        
//        func deleteLocation(locationToDelete: Location) {
//            let indexOfLocation = locations.firstIndex { $0.id == locationToDelete.id }
//            print("Index: \(String(describing: indexOfLocation))")
//            print("Type of index: \(type(of: indexOfLocation))")
//////            guard indexOfLocation != nil else {
////                return
////            }
////
////            locations.remove(at: indexOfLocation)
//            
//        }
        
        func deleteAllData() {
            locations.removeAll()
            save()
        }
        
        func authenticate() {
            let context = LAContext()
            var error: NSError?
            
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Please authenticate yourself to unlock your places."
                
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authentificationError in
                    if success {
                        Task { @MainActor in
                            self.isUnlocked = true
                        }
                    } else {
                        Task { @MainActor in
                            self.errorTitle = "Unlock Failed"
                            self.errorMessage = authentificationError?.localizedDescription ?? "Something went wrong! Try again."
                            self.showErrorMessage = true
                        }
                    }
                }
            } else {
                self.errorTitle = "Unlock Failed"
                self.errorMessage = "Can not access Touch ID or Face ID"
            }
        }
    }
}
