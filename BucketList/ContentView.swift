//
//  ContentView.swift
//  BucketList
//
//  Created by Anthony Candelino on 2024-09-12.
//

import MapKit
import SwiftUI

struct ContentView: View {
    @State private var viewModel = ViewModel()
    @State private var mapType = "standard"
    
    let startPosition = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 43.4643, longitude: -80.5204),
            span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
        )
    )
    
    var body: some View {
        if viewModel.isUnlocked {
            ZStack {
                MapReader { proxy in
                    Map(initialPosition: startPosition) {
                        ForEach(viewModel.locations) { location in
                            Annotation(location.name, coordinate: location.coordinate) {
                                Image(systemName: "pin.circle")
                                    .resizable()
                                    .foregroundStyle(.blue)
                                    .frame(width: 44, height: 44)
                                    .background(.white)
                                    .clipShape(.circle)
                                    .onLongPressGesture {
                                        viewModel.selectedPlace = location
                                    }
                            }
                        }
                    }
                    .mapStyle(getMapStyle(mapType: mapType))
                    .onTapGesture { position in
                        if let coordinate = proxy.convert(position, from: .local) {
                            viewModel.addLocation(at: coordinate)
                        }
                    }
                    .sheet(item: $viewModel.selectedPlace) { place in
                        EditView(location: place) {
                            viewModel.update(location: $0)
                        }
                    }
                }
                VStack {
                    Spacer()
                    Picker("Map Type", selection: $mapType) {
                        Text("Standard Map").tag("standard")
                        Text("Hybrid Map").tag("hybrid")
                    }
                    .accentColor(.blue)
                    .background(.white)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.blue, lineWidth: 1)
                    )
                    .padding(.trailing)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    
                }
            }
        } else {
            VStack {
                Button("Unlock Places", action: viewModel.authenticate)
                    .padding()
                    .background(.blue)
                    .foregroundStyle(.white)
                    .clipShape(.capsule)
            }
            .alert("Error Authenticating", isPresented: $viewModel.errorAuthenticating) {
                Button("Ok", role: .cancel) { }
            } message: {
                Text("Failed to authenticate, please try again.")
            }
        }
    }
    
    func getMapStyle(mapType: String) -> MapStyle {
        mapType == "standard" ? .standard : .hybrid
    }
}

#Preview {
    ContentView()
}
