//
//  NotesRowView.swift
//  StickyNotes
//
//  Created by Sam Wolf on 2/2/25.
//

import SwiftUI

struct NotesRowView: View {
    
    var note: StickyNote
    
    var body: some View {
        HStack {
            Rectangle()
                .fill(Color(red: Double(note.noteColor.red),
                            green: Double(note.noteColor.green),
                            blue: Double(note.noteColor.blue)))
                .frame(width: 64.0, height: 64.0)
                .overlay {
                    VStack {
                        if note.isComplete {
                            Text("Complete")
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.green)
                                .font(.system(size: 8.0))
                        } else {
                            Text(note.text)
                                .multilineTextAlignment(.center)
                                .foregroundStyle(Color(red: Double(note.textColor.red),
                                                       green: Double(note.textColor.green),
                                                       blue: Double(note.textColor.blue))
                                )
                                .font(.system(size: 8.0))
                            Spacer()
                        }
                    }
                    .frame(width: 64.0, height: 64.0)
                }
            VStack(alignment: .leading) {
                Text("Sticky Note")
                Text("X: \(note.position.positionX)")
                Text("Y: \(note.position.positionY)")
                Text("Z: \(note.position.positionZ)")
                    .padding(.bottom, 4.0)
                Text("ID: \(note.id)")
                    .font(.system(size: 8.0))
            }
        }
    }
}

#Preview {
    List {
        NotesRowView(note: StickyNote(id: UUID().uuidString,
                                      text: "Hello World Hello World Hello World Hello World Hello World ",
                                      isComplete: false,
                                      position: StickyNotePosition(positionX: 0.0,
                                                                   positionY: 0.0,
                                                                   positionZ: 0.0),
                                      textColor: StickyNoteColor(red: 0.0,
                                                                 green: 0.0,
                                                                 blue: 0.0),
                                      noteColor: StickyNoteColor(red: 0.0,
                                                                 green: 1.0,
                                                                 blue: 0.0)))
        NotesRowView(note: StickyNote(id: UUID().uuidString,
                                      text: "Hello World Hello World Hello World Hello World Hello World Hello World Hello World Hello World Hello WorldHello WorldHello WorldHello World",
                                      isComplete: true,
                                      position: StickyNotePosition(positionX: 0.7988,
                                                                   positionY: 1.25,
                                                                   positionZ: 1.3),
                                      textColor: StickyNoteColor(red: 1.0,
                                                                 green: 1.0,
                                                                 blue: 1.0),
                                      noteColor: StickyNoteColor(red: 1.0,
                                                                 green: 0.0,
                                                                 blue: 1.0)))
    }
}
