//
//  NotesDetailView.swift
//  StickyNotes
//
//  Created by Sam Wolf on 2/6/25.
//

import SwiftUI

struct NotesDetailView: View {
    
    @ObservedObject var notesModel: NotesModel
    
    @State private var editViewModel = EditNoteViewModel()
    @State var note: StickyNote
    
    var body: some View {
        
        Group {
            if !note.isComplete {
                Button("Complete Note") {
                    withAnimation {
                        note.isComplete = true
                        notesModel.updateNote(note: note)
                    }
                }
                .buttonStyle(.borderedProminent)
                .tint(.green)
                .transition(.opacity)
            } else {
                Button("Uncomplete Note") {
                    withAnimation {
                        note.isComplete = false
                        notesModel.updateNote(note: note)
                    }
                }
                .buttonStyle(.borderedProminent)
                .tint(.orange)
                .transition(.opacity)
            }
        }
        .padding(.bottom, 16.0)
        
        Rectangle()
            .fill(Color(red: Double(note.noteColor.red),
                        green: Double(note.noteColor.green),
                        blue: Double(note.noteColor.blue)))
            .overlay {
                VStack {
                    if note.isComplete {
                        Text("Complete")
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.green)
                            .font(.system(size: 16.0))
                    } else {
                        Text(note.text)
                            .multilineTextAlignment(.center)
                            .foregroundStyle(Color(red: Double(note.textColor.red),
                                                   green: Double(note.textColor.green),
                                                   blue: Double(note.textColor.blue))
                            )
                            .font(.system(size: 16.0))
                        Spacer()
                    }
                }
            }
            .frame(width: 256, height: 256)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    if editViewModel.noteBeingEditted == nil {
                        Button("Edit") {
                            withAnimation {
                                editViewModel = EditNoteViewModel(note: note)
                            }
                        }
                        .transition(.opacity)
                    }
                }
            }
        
        if editViewModel.noteBeingEditted != nil {
            EditNoteView(viewModel: $editViewModel,
                           noteFromDetails: $note,
                           notesModel: notesModel)
                .transition(.opacity)
        }
        
    }
}

#Preview {
    NotesDetailView(notesModel: NotesModel(), note: StickyNote(id: UUID().uuidString,
                                     text: "Hello World Hello World Hello World Hello World Hello World ",
                                     isComplete: false,
                                     position: StickyNotePosition(positionX: 0.0,
                                                                  positionY: 0.0,
                                                                  positionZ: 0.0),
                                     textColor: StickyNoteColor(red: 1.0,
                                                                green: 1.0,
                                                                blue: 1.0),
                                     noteColor: StickyNoteColor(red: 1.0,
                                                                green: 0.0,
                                                                blue: 1.0)))
}
