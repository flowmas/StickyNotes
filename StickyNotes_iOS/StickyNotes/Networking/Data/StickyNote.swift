//
//  StickyNote.swift
//  StickyNotes
//
//  Created by Sam Wolf on 2/1/25.
//

import Foundation

struct StickyNote: Codable, Identifiable {
    var id: String
    var text: String
    var isComplete: Bool
    var position: StickyNotePosition
    var textColor: StickyNoteColor
    var noteColor: StickyNoteColor
}
