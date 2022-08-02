//
//  PhotoEditView.swift
//  PhotoGallery
//
//  Created by Andreas Zwikirsch on 31.07.22.
//

import SwiftUI
import Combine

struct AddView: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var photoVM: PhotoViewModel
    
    let exampleImage: UIImage = UIImage(systemName: "questionmark")!
    @State private var name: String = ""
    @State private var description: String = ""
    
    @State private var showAlert: Bool = false
    
    
    var body: some View {
        NavigationView {
            ScrollView {
                Image(uiImage: photoVM.selectedPhoto ?? exampleImage)
                    .resizable()
                    .scaledToFit()
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
                    Button("Save") {
                        if name.replacingOccurrences(of: " ", with: "") != "" {
                            photoVM.photoName = name
                            photoVM.photoDescription = description
                            
                            photoVM.addPhoto(photo: photoVM.selectedPhoto!, name: photoVM.photoName, description: photoVM.photoDescription)
                            print("saved new image")
                            
                            dismiss()
                        } else {
                            showAlert = true
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