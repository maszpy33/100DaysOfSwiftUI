//
//  EditView.swift
//  BucketList
//
//  Created by Andreas Zwikirsch on 24.07.22.
//

import SwiftUI


struct EditView: View {
    
    @Environment(\.dismiss) var dismiss
    @StateObject var editVM: EditViewModel
    
    var location: Location
    var onSave: (Location) -> Void
    
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Place name", text: $editVM.name)
                    TextField("Description", text: $editVM.description)
                }
                
                Section("Nearby...") {
                    switch editVM.loadingState {
                    case .loading:
                        Text("Loading...")
                    case .loaded:
                        ForEach(editVM.pages, id: \.pageid) { page in
                            Text(page.title)
                                .font(.headline)
                            + Text(": ")
                            + Text("Page description here")
                                .italic()
                        }
                    case .failed:
                        Text("Pleace try again later.")
                    }
                }
            }
            .navigationTitle("Place details")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Delete") {
                        // delte location
                        
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        onSave(editVM.newLocation)
                        dismiss()
                    }
                }
            }
            .task {
                await editVM.fetchNearbyPlaces()
            }
        }
    }
    
    init(location: Location, onSave: @escaping (Location) -> Void) {
        self.location = location
        self.onSave = onSave
        
        _editVM = StateObject(wrappedValue: EditViewModel(location: location))
    }
    
    //    init(location: Location, onSave: @escaping (Location) -> Void) {
    //        self.location = location
    //        self.onSave = onSave
    //
    //        _name = State(initialValue: location.name)
    //        _description = State(initialValue: location.description)
    //    }
    //
    //    func fetchNearbyPlaces() async {
    //        let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(location.latitude)%7C\(location.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"
    //
    //        guard let url = URL(string: urlString) else {
    //            print("Bad URL: \(urlString)")
    //            return
    //        }
    //
    //        do {
    //            let (data, _) = try await URLSession.shared.data(from: url)
    //            let items = try JSONDecoder().decode(Result.self, from: data)
    //            pages = items.query.pages.values.sorted()
    //            loadingState = .loaded
    //        } catch {
    //            loadingState = .failed
    //        }
    //    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(location: Location.example) { newLocation in }
    }
}
