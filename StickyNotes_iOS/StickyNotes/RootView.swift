//
//  RootView.swift
//  StickyNotes
//
//  Created by Sam Wolf on 1/31/25.
//

import SwiftUI

struct RootView: View {
    
    @StateObject private var notesModel = NotesModel()
    
    var body: some View {
        TabView {
            Tab("AR", systemImage: "arkit") {
                NotesARView(notesModel: notesModel)
            }
            Tab("List", systemImage: "pencil.and.list.clipboard") {
                ForEach(notesModel.notes) { note in
                    Text("\(note)")
                }
            }
        }
        .onAppear {
            notesModel.updateNotes()
        }
    }
}
