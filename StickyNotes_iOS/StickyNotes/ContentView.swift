//
//  ContentView.swift
//  StickyNotes
//
//  Created by Sam Wolf on 1/30/25.
//

import SwiftUI
import RealityKit

struct ContentView : View {

    @State private var presentAddNewNote = false
    @State private var presentNoteDetails = false
    
    @StateObject private var viewModel = NotesARViewModel()

    
    var body: some View {
        RealityView { content in
            content.camera = .spatialTracking
            viewModel.cameraContent = content
        } update: { content in
            print("update \(viewModel.entities.count)")
            for entity in viewModel.entities {
                content.add(entity)
            }
            viewModel.cameraContent = content
        }
        .ignoresSafeArea()
        .sheet(isPresented: $presentAddNewNote) {
            Text("New Note")
        }
        .sheet(isPresented: $presentNoteDetails) {
            Text("Note Details")
        }
        .simultaneousGesture(LongPressGesture().targetedToAnyEntity().onEnded { value in
            viewModel.entities.removeAll(where: {
                return $0 == value.entity
            })
            print("LongPress")
        })
        // This should only fire when an Entity is tapped
        .simultaneousGesture(TapGesture().targetedToAnyEntity().onEnded { value in
            presentNoteDetails = true
        })
        // Double Tap to create a new note
        .simultaneousGesture(SpatialTapGesture(count: 2, coordinateSpace: .local).onEnded { location in
            viewModel.createEntity(x: location.location.x, y: location.location.y)
        })
        
        
    }
}

