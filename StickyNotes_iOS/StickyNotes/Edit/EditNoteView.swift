//
//  EditNoteView.swift
//  StickyNotes
//
//  Created by Sam Wolf on 2/1/25.
//

import SwiftUI

struct EditNoteView: View {
    @Environment(\.self) var environment
    @Environment(\.dismiss) var dismiss

    @Binding var viewModel: EditNoteViewModel
    @Binding var noteFromDetails: StickyNote
    var notesModel: NotesModel
    
    var body: some View {
        
        VStack {
            
            Spacer()
            
            VStack {
                
                TextField("Edit Note Text", text: $viewModel.text)
                
                HStack(spacing: 16.0) {
                    ColorPicker("Text Color", selection: $viewModel.textColor)
                    ColorPicker("Note Color", selection: $viewModel.noteColor)
                }
                .padding(.top, 16.0)
                
                HStack {
                    Button("Cancel") {
                        withAnimation {
                            viewModel.noteBeingEditted = nil
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Spacer()
                    
                    Button("Delete") {
                        withAnimation {
                            notesModel.deleteNote(id: viewModel.noteBeingEditted?.id)
                            viewModel.noteBeingEditted = nil
                            // Pops the navigation stack on the NotesListView
                            dismiss()
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.red)
                    
                    Spacer()
                    
                    Button("Save") {
                        withAnimation {
                            if let updatedNote = viewModel.updatedNote(colorEnvironment: environment) {
                                notesModel.updateNote(note: updatedNote)
                                noteFromDetails = updatedNote
                                viewModel.noteBeingEditted = nil
                            }
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
}
