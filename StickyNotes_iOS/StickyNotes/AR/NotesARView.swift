//
//  NotesARView.swift
//  StickyNotes
//
//  Created by Sam Wolf on 1/30/25.
//

import SwiftUI
import RealityKit

struct NotesARView : View {
    
    @State private var editViewModel = EditNoteViewModel()
    
    @StateObject private var viewModel: NotesARViewModel
    
    init(notesModel: NotesModel) {
        self._viewModel = StateObject(wrappedValue: NotesARViewModel(notesModel: notesModel))
    }
    
    var body: some View {
        ZStack {
            realityView
                .zIndex(0)
            if editViewModel.noteBeingEditted != nil {
                EditNoteView(viewModel: $editViewModel,
                               noteFromDetails: .constant(editViewModel.noteBeingEditted!),
                               notesModel: viewModel.notesModel)
                    .zIndex(1)
                    .transition(.opacity)
            }
        }
    }
    
    @ViewBuilder private var realityView: some View {
        RealityView { content in
            content.camera = .spatialTracking
            viewModel.cameraContent = content
        } update: { content in
            content.entities.removeAll()
            for entity in viewModel.entityMap.values {
                // This method will not duplicate the entity if it already exists
                content.add(entity)
            }
        }
        // Let the RealityView fill the whole area except the bottom, so the TabView isn't covered up.
        .ignoresSafeArea(.container, edges: [.top, .leading, .trailing])
        // Long Press to delete a note
        .simultaneousGesture(LongPressGesture().targetedToAnyEntity().onEnded { value in
            if let note = viewModel.notesModel.notes.first(where: { $0.id == value.entity.name }) {
                var updatedNote = note
                updatedNote.isComplete.toggle()
                viewModel.notesModel.updateNote(note: updatedNote)
            }
        })
        // Tap to edit a note
        .simultaneousGesture(TapGesture().targetedToAnyEntity().onEnded { value in
            // Find the associated note with the Entity's name, which is the note's ID
            if let note = viewModel.notesModel.notes.first(where: { $0.id == value.entity.name }) {
                withAnimation {
                    editViewModel = EditNoteViewModel(note: note)
                }
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
