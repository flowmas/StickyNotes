//
//  EditNoteARView.swift
//  StickyNotes
//
//  Created by Sam Wolf on 2/1/25.
//

import SwiftUI

struct EditNoteARView: View {
    @Environment(\.self) var environment

    @Binding var viewModel: EditNoteARViewModel
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
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.red)
                    
                    Spacer()
                    
                    Button("Save") {
                        withAnimation {
                            notesModel.updateNote(note: viewModel.updatedNote(colorEnvironment: environment))
                            viewModel.noteBeingEditted = nil
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
