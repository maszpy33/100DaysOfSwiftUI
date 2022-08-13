//
//  NewEditView.swift
//  PhotoGallery
//
//  Created by Andreas Zwikirsch on 02.08.22.
//

import SwiftUI
import MapKit


struct Marker: Identifiable {
    let id = UUID()
    var location: MapMarker
}

struct EditView: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var photoVM: PhotoViewModel
    
    @State var image: Image?
    @State var photo: Photo
    @State var showAlert: Bool = false
    
    @State private var name: String = ""
    @State private var description: String = ""
    
    @State var photoLocationToggle: Bool = false
    
    let markers = [Marker(location: MapMarker(coordinate: CLLocationCoordinate2D(latitude: 38.8977, longitude: -77.0365), tint: .red))]
    
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    VStack {
                        CustomToggleSwitch(photoLocationToggle: $photoLocationToggle, leftButtonText: "Photo", rightButtonText: "Location")
                        
                        if !photoLocationToggle {
                            Image(uiImage: UIImage(data: photo.photoData)!)
                                .resizable()
                                .scaledToFit()
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(.gray, lineWidth: 3)
                                )
                                .frame(width: 250, height: 250)
                                .padding(.horizontal)
                        } else {
                            VStack {
                                Map(coordinateRegion: $photoVM.mapRegion, interactionModes: .all, showsUserLocation: true, annotationItems: photoVM.photoList) { photo in
                                    MapAnnotation(coordinate: photo.coordinate) {
                                        VStack {
        //                                    MapPin(coordinate: photo.coordinate)
                                            Image(systemName: "mappin")
                                                .resizable()
                                                .symbolRenderingMode(.palette)
                                                .foregroundStyle(.red, .gray)
                                                .frame(width: 10, height: 25)
                                            
                                            
                                        }
                                    }
                                }
                                .frame(width: 250, height: 250)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(.gray, lineWidth: 3)
                                )
                                .frame(width: 250, height: 250)
                                .padding(.horizontal)
                                .padding(.horizontal)
                                
    //                            Map(coordinateRegion: .constant(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: photo.coordinate.latitude, longitude: photo.coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))), interactionModes: [.zoom])
    //                                .clipShape(RoundedRectangle(cornerRadius: 16))
    //                                .overlay(
    //                                    RoundedRectangle(cornerRadius: 16)
    //                                        .stroke(.gray, lineWidth: 3)
    //                                )
    //                                .frame(width: 250, height: 250)
    //                                .padding(.horizontal)
                            }
                        }
                        HStack {
                            Text("Longitude: \(photo.longitude, specifier: "%.2f")")
                            Text("Latitude: \(photo.latitude, specifier: "%.2f")")
                        }
                    }
                }
                
                Section(header: Text("Name: ")) {
                    VStack(alignment: .leading) {
                        TextField("enter photo name", text: $name)
                            .padding()
                    }
                    .padding(.horizontal)
                }
                
                Section(header: Text("Description: ")) {
                    VStack(alignment: .leading) {
                        TextEditor(text: $description)
                            .frame(minHeight: 100)
                            .multilineTextAlignment(.leading)
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Add New Photo")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Button("Delete") {
                            photoVM.deletePhoto(photo: photo)
                            
                            dismiss()
                        }
                        .foregroundColor(.red)
                        
                        Button("Save") {
                            if name.replacingOccurrences(of: " ", with: "") != "" {
                                photoVM.photoName = name
                                photoVM.photoDescription = description
                                
                                photoVM.updatePhoto(photo: photo)
                                print("updated image")
                                
                                dismiss()
                            } else {
                                showAlert = true
                            }
                        }

                    }
                }
            }
            .alert("Pleace enter a Name for the image", isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            }
            .onAppear {
                name = photo.name
                if photo.description != nil {
                    description = photo.description!
                }
            }
        }
    }
}

//struct EditView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditView()
//    }
//}
