//
//  NotesARView.swift
//  StickyNotes
//
//  Created by Sam Wolf on 1/30/25.
//

import SwiftUI
import RealityKit

struct NotesARView : View {

    @State private var selectedNote: Entity?
    @State private var testText = ""
    
    @StateObject private var viewModel: NotesARViewModel
    
    init(notesModel: NotesModel) {
        self._viewModel = StateObject(wrappedValue: NotesARViewModel(notesModel: notesModel))
    }
    
    var body: some View {
        ZStack {
            realityView
                .zIndex(0)
            if selectedNote != nil {
                editNoteOverlayView
                    .zIndex(1)
                    .transition(.opacity)
            }
        }
    }
    
    @ViewBuilder private var editNoteOverlayView: some View {
        VStack {
            
            Spacer()
            
            VStack {
                TextField("Edit Note Text", text: $testText)
                
                HStack(spacing: 16.0) {
                    ColorPicker("Text Color", selection: $viewModel.textColor)
                    ColorPicker("Note Color", selection: $viewModel.noteColor)
                }
                .padding(.top, 16.0)
                
                HStack {
                    Button("Cancel") {
                        withAnimation {
                            selectedNote = nil
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.red)
                    
                    Spacer()
                    
                    Button("Save") {
                        withAnimation {
                            selectedNote = nil
                        }
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding(.top, 32.0)
                
            }
            .padding()
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 10.0))
            
        }
        .padding()
        
    }
    
    @ViewBuilder private var realityView: some View {
        RealityView { content in
            content.camera = .spatialTracking
            viewModel.cameraContent = content
        } update: { content in
            for entity in viewModel.entityMap.values {
                // This method will not duplicate the entity if it already exists
                content.add(entity)
            }
        }
        // Let the RealityView fill the whole area except the bottom, so the TabView isn't covered up.
        .ignoresSafeArea(.container, edges: [.top, .leading, .trailing])
        // Long Press to delete a note
        .simultaneousGesture(LongPressGesture().targetedToAnyEntity().onEnded { value in
            print("LongPress")
        })
        // Tap to edit a note
        .simultaneousGesture(TapGesture().targetedToAnyEntity().onEnded { value in
            withAnimation {
                selectedNote = value.entity
            }
        })
        // Double Tap to create a new note
        .simultaneousGesture(SpatialTapGesture(count: 2, coordinateSpace: .local).onEnded { location in
            Task {
                do {
                    try await viewModel.createEntity(x: location.location.x, y: location.location.y)
                } catch {
                    print(error.localizedDescription)
                }
            }
        })
    }
}


