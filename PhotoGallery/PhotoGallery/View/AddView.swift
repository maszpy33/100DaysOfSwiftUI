//
//  PhotoEditView.swift
//  PhotoGallery
//
//  Created by Andreas Zwikirsch on 31.07.22.
//

import SwiftUI
import Combine
import CoreLocation


struct AddView: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var photoVM: PhotoViewModel
    let locationFetcher: LocationFetcher
    
    let exampleImage: UIImage = UIImage(systemName: "questionmark")!
    @State private var name: String = ""
    @State private var description: String = ""
    
    @State private var showAlert: Bool = false
    
    @Binding var showAddView: Bool
    
    var body: some View {
        NavigationView {
            Form {
                Image(uiImage: photoVM.selectedPhoto ?? exampleImage)
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.gray, lineWidth: 3)
                    )
                    .frame(width: 250, height: 250)
                    .padding(.horizontal)
                
                HStack {
                    Text("Photo Name: ")
                        .font(.subheadline)
                        .bold()
                    Text("\(name)")
                        .font(.subheadline)
                    Spacer()
                }
                .padding(.horizontal)
                
                VStack(alignment: .leading) {
                    Text("Name: ")
                        .bold()
                    TextField("enter photo name", text: $name)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(.blue, lineWidth: 2)
                        )
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                
                VStack(alignment: .leading) {
                    Text("Description: ")
                        .bold()
                    
                    TextEditor(text: $description)
                        .frame(minHeight: 100)
                        .multilineTextAlignment(.leading)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.blue, lineWidth: 2)
                        )
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
            }
            .navigationTitle("Add New Photo")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Button("Cancel") {
                            photoVM.photoName = ""
                            photoVM.photoDescription = ""
                            photoVM.selectedPhoto = nil
                            
                            showAddView = false
                            dismiss()
                        }
                        
                        Button("Save") {
                            if name.replacingOccurrences(of: " ", with: "") != "" {
                                photoVM.photoName = name
                                photoVM.photoDescription = description
                                
                                self.locationFetcher.start()
                                if let location = self.locationFetcher.lastKnownLocation {
                                    print("before")
                                    print("\(photoVM.latitude)")
                                    print("\(photoVM.longitude)")
                                    photoVM.latitude = location.latitude
                                    photoVM.longitude = location.longitude
                                    print("after")
                                    print("\(photoVM.latitude)")
                                    print("\(photoVM.longitude)")
                                } else {
                                    print("Location detection error")
                                }
                                
                                photoVM.addPhoto(photo: photoVM.selectedPhoto!, name: photoVM.photoName, description: photoVM.photoDescription, currentLatitude: photoVM.latitude, currentLongitude: photoVM.longitude)
                                
                                showAddView = false
                                
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
        }
    }
}
//
//struct PhotoEditView_Previews: PreviewProvider {
//    static var previews: some View {
//        PhotoEditView()
//    }
//}
