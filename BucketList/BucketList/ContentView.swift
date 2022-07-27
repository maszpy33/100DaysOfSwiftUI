//
//  ContentView.swift
//  BucketList
//
//  Created by Andreas Zwikirsch on 18.07.22.
//

import SwiftUI
import MapKit


struct ContentView: View {
    
    @StateObject var contentViewModel = ViewModel()
    
    @State var indexToDelete: Int = 0
    
    var body: some View {
        if contentViewModel.isUnlocked {
            ZStack {
                if !contentViewModel.changePinStyle {
                    Map(coordinateRegion: $contentViewModel.mapRegion, annotationItems: contentViewModel.locations) { location in
                        MapAnnotation(coordinate: location.coordinate) {
                            VStack {
                                Image(systemName: "star.circle")
                                    .resizable()
                                    .foregroundColor(.red)
                                    .frame(width: 44, height: 44)
                                    .background(.white)
                                    .clipShape(Circle())
                                Text(location.name)
                                    .fixedSize()
                            }
                            .onTapGesture {
                                contentViewModel.selectedPlace = location
                            }
                        }
                    }
                    .ignoresSafeArea()
                } else {
                    Map(coordinateRegion: $contentViewModel.mapRegion, annotationItems: contentViewModel.locations) { location in
                        MapPin(coordinate: location.coordinate, tint: .red)
                    }
                    .ignoresSafeArea()
                }
                
                
                Circle()
                    .fill(.blue)
                    .opacity(0.3)
                    .frame(width: 32, height: 32)
                    .offset(x: 0, y: -15)
                
                VStack {
                    Spacer()
                    
                    HStack {
                        Button {
                            contentViewModel.changePinStyle.toggle()
                        } label: {
                            Image(systemName: contentViewModel.changePinStyle ? "paintbrush" : "paintbrush.fill")
                                .padding()
                                .background(.black.opacity(0.75))
                                .foregroundColor(.white)
                                .font(.title)
                                .clipShape(Circle())
                                .padding(.leading)
                        }
                        
                        Button {
                            contentViewModel.errorTitle = "Deleting all marked locations"
                            contentViewModel.errorMessage = "do you really want to continue and delte all data?"
                            contentViewModel.showDeleteAllAlert.toggle()
                        } label: {
                            Image(systemName: "trash")
                                .padding()
                                .background(.black.opacity(0.75))
                                .foregroundColor(.white)
                                .font(.title)
                                .clipShape(Circle())
                                .padding(.leading)
                        }
                        .alert(isPresented: $contentViewModel.showDeleteAllAlert) {
                            Alert(
                                title: Text(contentViewModel.errorTitle),
                                message: Text(contentViewModel.errorMessage),
                                primaryButton: .destructive(Text("Delete all")) {
                                    contentViewModel.deleteAllData()
                                },
                                secondaryButton: .cancel()
                            )
                        }
                        
                        Spacer()
                        
                        Button {
                            contentViewModel.addLocation()
                        } label: {
                            // 1.Challenge: Circle() is now also part of the button and reacts on press
                            Image(systemName: "plus")
                                .padding()
                                .background(.black.opacity(0.75))
                                .foregroundColor(.white)
                                .font(.title)
                                .clipShape(Circle())
                                .padding(.trailing)
                        }
                    }
                }
            }
            .sheet(item: $contentViewModel.selectedPlace) { place in
                EditView(location: place) { newLocation in
                    contentViewModel.updateLocation(location: newLocation)
                }
                .environmentObject(contentViewModel)
            }
        } else {
            Button("Unlock Places") {
                contentViewModel.authenticate()
            }
            .padding()
            .background(.blue)
            .foregroundColor(.white)
            .clipShape(Capsule())
            // 2. Challenge
            .alert(isPresented: self.$contentViewModel.showErrorMessage) {
                Alert(title: Text(contentViewModel.errorTitle), message: Text(contentViewModel.errorMessage))
            }
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
