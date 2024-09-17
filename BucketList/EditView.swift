//
//  EditView.swift
//  BucketList
//
//  Created by Anthony Candelino on 2024-09-15.
//

import SwiftUI

struct EditView: View {
    @Environment(\.dismiss) var dismiss
    @State private var viewModel: ViewModel
    var onSave: (Location) -> Void
    
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Location name", text: $viewModel.name)
                    TextField("Description", text: $viewModel.description)
                }
                
                Section("Nearby...") {
                    switch viewModel.loadingState {
                    case .loading:
                        HStack {
                            ProgressView()
                            Text("Loading...")
                                .padding(.leading)
                        }
                    case .loaded:
                        ForEach(viewModel.pages, id: \.pageid) { page in
                            Text(page.title)
                                .font(.headline)
                            + Text(": ") +
                            Text(page.description)
                                .italic()
                        }
                    case .failed:
                        Text("Please try again later. ❌")
                    }
                }
            }
            .navigationTitle("Place details")
            .toolbar {
                Button("Save") {
                    let newLocation = viewModel.save()
                    onSave(newLocation)
                    dismiss()
                }
            }
            .task {
                await viewModel.fetchNearbyPlaces()
            }
        }
    }
    
    // marked as @escaping so that we store function for later instead of called initially
    init(location: Location, onSave: @escaping (Location) -> Void) {
        self.onSave = onSave
        _viewModel = State(initialValue: ViewModel(location: location))
    }
    
    
}

#Preview {
    EditView(location: .example) { _ in }
}
