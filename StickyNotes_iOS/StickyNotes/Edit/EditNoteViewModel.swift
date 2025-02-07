//
//  EditNoteViewModel.swift
//  StickyNotes
//
//  Created by Sam Wolf on 2/1/25.
//

import Foundation
import SwiftUI

struct EditNoteViewModel {
    var noteBeingEditted: StickyNote?
    
    var text: String
    var noteColor: Color
    var textColor: Color
    
    init() {
        text = ""
        noteColor = .pink
        textColor = .white
    }
    
    init(note: StickyNote) {
        noteBeingEditted = note
        text = note.text
        noteColor = Color(red: Double(note.noteColor.red),
                          green: Double(note.noteColor.green),
                          blue: Double(note.noteColor.blue))
        textColor = Color(red: Double(note.textColor.red),
                          green: Double(note.textColor.green),
                          blue: Double(note.textColor.blue))
    }
    
    func updatedNote(colorEnvironment: EnvironmentValues) -> StickyNote? {
        if let noteBeingEditted = noteBeingEditted {
            let newNoteColor = noteColor.resolve(in: colorEnvironment)
            let newTextColor = textColor.resolve(in: colorEnvironment)
            return StickyNote(id: noteBeingEditted.id,
                              text: text,
                              isComplete: noteBeingEditted.isComplete,
                              position: noteBeingEditted.position,
                              textColor: StickyNoteColor(red: newTextColor.red,
                                                         green: newTextColor.green,
                                                         blue: newTextColor.blue),
                              noteColor: StickyNoteColor(red: newNoteColor.red,
                                                         green: newNoteColor.green,
                                                         blue: newNoteColor.blue))
        }
        return nil
    }
}
