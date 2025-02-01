//
//  NotesModel.swift
//  StickyNotes
//
//  Created by Sam Wolf on 2/1/25.
//

import Foundation

@MainActor class NotesModel: ObservableObject {
    @Published var notes: [StickyNote] = [] {
        didSet {
            // Incase the notes update, make sure we notify the Entities as well
            updateEntities?()
        }
    }
    
    private let networking = NetworkingModel()
    var updateEntities: (() -> ())?

    func updateNotes() {
        Task { @MainActor in
            do {
                notes = try await networking.getNotes()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func createStickyNote(arSpacePosition: SIMD3<Float>) async throws {
   
        let newStickyNote = NewStickyNote(position: StickyNotePosition(positionX: arSpacePosition.x,
                                                                       positionY: arSpacePosition.y,
                                                                       positionZ: arSpacePosition.z))
        let noteData = try JSONEncoder().encode(newStickyNote)
        
        notes.append(try await networking.createNewNote(noteData: noteData))
    }
    
    fileprivate struct NewStickyNote: Codable {
        // Notes will not be complete by default
        var text = ""
        // Notes will not be complete by default
        var isComplete = false
        var position: StickyNotePosition
        // Default text color will be white
        var textColor = StickyNoteColor(red: 1.0, green: 1.0, blue: 1.0)
        // Default note color will be magenta
        var noteColor = StickyNoteColor(red: 1.0, green: 0.0, blue: 1.0)
    }
}
