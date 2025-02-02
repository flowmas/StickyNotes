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
   
        let newNewNote = NewStickyNote(position: StickyNotePosition(positionX: arSpacePosition.x,
                                                                    positionY: arSpacePosition.y,
                                                                    positionZ: arSpacePosition.z))
        let newNoteData = try JSONEncoder().encode(newNewNote)
        
        notes.append(try await networking.createNewNote(noteData: newNoteData))
    }
    
    func updateNote(note: StickyNote?) {
        
        guard let updatedNote = note else {
            return
        }
        
        guard let noteToUpdateIndex = notes.firstIndex(where: { $0.id == updatedNote.id }) else {
            return
        }
        
        Task { @MainActor in
            do {
                let updatedNoteData = try JSONEncoder().encode(updatedNote)
                notes[noteToUpdateIndex] = try await networking.editNote(id: updatedNote.id, noteData: updatedNoteData)
            } catch {
                print(error.localizedDescription)
            }
        }
        
    }
    
    func deleteNote(id: String?) {
        guard let id = id, let noteToUpdateIndex = notes.firstIndex(where: { $0.id == id }) else {
            return
        }
        
        Task { @MainActor in
            do {
                try await networking.deleteNote(id: id)
                notes.remove(at: noteToUpdateIndex)
            } catch {
                print(error.localizedDescription)
            }
        }
        
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
