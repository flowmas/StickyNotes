//
//  NotesListView.swift
//  StickyNotes
//
//  Created by Sam Wolf on 2/2/25.
//

import SwiftUI

struct NotesListView: View {
    
    @ObservedObject var notesModel: NotesModel
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(notesModel.notes) { note in
                    NavigationLink {
                        Text("Details")
                    } label: {
                        NotesRowView(note: note)
                    }
                    
                }
                .onDelete { indexSet in
                    // We are only deleting notes one at a time
                    // Only the first index is required
                    if let indexToDelete = indexSet.first {
                        notesModel.deleteNote(id: notesModel.notes[indexToDelete].id)
                    }
                }
            }
            .refreshable {
                notesModel.getNotes()
            }
            .navigationTitle("Notes")
        }
    }
        
}

#Preview {
    @Previewable @StateObject var notesModel = NotesModel()
    NotesListView(notesModel: notesModel)
        .onAppear {
            notesModel.getNotes()
        }
}
