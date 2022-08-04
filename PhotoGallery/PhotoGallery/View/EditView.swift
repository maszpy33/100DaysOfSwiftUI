//
//  NewEditView.swift
//  PhotoGallery
//
//  Created by Andreas Zwikirsch on 02.08.22.
//

import SwiftUI

struct EditView: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var photoVM: PhotoViewModel
    
    @State var image: Image?
    @State var photo: Photo
    @State var showAlert: Bool = false
    
    @State private var name: String = ""
    @State private var description: String = ""
    
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    VStack {
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
                        
                        HStack {
                            Text("Photo Name: ")
                                .font(.subheadline)
                                .bold()
                            Text("\(name)")
                                .font(.subheadline)
                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                }
                
                Section(header: Text("Name: ")) {
                    VStack(alignment: .leading) {
                        //                        Text("Name: ")
                        //                            .bold()
                        TextField("enter photo name", text: $name)
                            .padding()
                        //                            .overlay(
                        //                                RoundedRectangle(cornerRadius: 16)
                        //                                    .stroke(.blue, lineWidth: 2)
                        //                            )
                    }
                    .padding(.horizontal)
                }
                
                Section(header: Text("Description: ")) {
                    VStack(alignment: .leading) {
                        //                        Text("Description: ")
                        //                            .bold()
                        
                        TextEditor(text: $description)
                            .frame(minHeight: 100)
                            .multilineTextAlignment(.leading)
                        //                            .overlay(
                        //                                RoundedRectangle(cornerRadius: 10)
                        //                                    .stroke(.blue, lineWidth: 2)
                        //                            )
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
