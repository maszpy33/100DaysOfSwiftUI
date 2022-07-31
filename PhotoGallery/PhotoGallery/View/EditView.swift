//
//  PhotoEditView.swift
//  PhotoGallery
//
//  Created by Andreas Zwikirsch on 31.07.22.
//

import SwiftUI

struct PhotoEditView: View {
    
    let exampleImage: UIImage = UIImage(named: "example6")!
    @State private var name: String = "Photo Name"
    @State private var description: String = "description"
    
    var body: some View {
        NavigationView {
            ScrollView {
                Image(uiImage: exampleImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
                    .padding()
                Text("Photo Name: \(name)")
                    .font(.title)
                Text("Photo Description: \(description)")
                    .font(.title3)
                    .opacity(0.8)
                    .padding(.bottom, 25)
                
                HStack {
                    Text("Name: ")
                        .bold()
                    TextField("enter photo name", text: $name)
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.blue, lineWidth: 4)
                )
                
                HStack {
                    Text("Description: ")
                        .bold()
                    TextField("enter photo description", text: $description)
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.blue, lineWidth: 4)
                )

            }
        }
    }
}

struct PhotoEditView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoEditView()
    }
}
