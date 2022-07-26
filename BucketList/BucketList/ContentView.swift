//
//  ContentView.swift
//  BucketList
//
//  Created by Andreas Zwikirsch on 18.07.22.
//

import SwiftUI
import MapKit


struct ContentView: View {
    
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        if viewModel.isUnlocked {
            ZStack {
                if !viewModel.changePinStyle {
                    Map(coordinateRegion: $viewModel.mapRegion, annotationItems: viewModel.locations) { location in
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
                                viewModel.selectedPlace = location
                            }
                        }
                    }
                    .ignoresSafeArea()
                } else {
                    Map(coordinateRegion: $viewModel.mapRegion, annotationItems: viewModel.locations) { location in
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
                            viewModel.changePinStyle.toggle()
                        } label: {
                            Image(systemName: viewModel.changePinStyle ? "paintbrush" : "paintbrush.fill")
                                .padding()
                                .background(.black.opacity(0.75))
                                .foregroundColor(.white)
                                .font(.title)
                                .clipShape(Circle())
                                .padding(.leading)
                        }
                        
                        Spacer()
                        
                        Button {
                            viewModel.addLocation()
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
            .sheet(item: $viewModel.selectedPlace) { place in
                EditView(location: place) { newLocation in
                    viewModel.updateLocation(location: newLocation)
                }
            }
        } else {
            Button("Unlock Places") {
                viewModel.authenticate()
            }
            .padding()
            .background(.blue)
            .foregroundColor(.white)
            .clipShape(Capsule())
            // 2. Challenge
            .alert(isPresented: self.$viewModel.showUnlockError) {
                Alert(title: Text(viewModel.errorTitle), message: Text(viewModel.errorMessage))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
