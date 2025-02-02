//
//  NotesARViewModel.swift
//  StickyNotes
//
//  Created by Sam Wolf on 1/30/25.
//

import Foundation
import RealityKit
import SwiftUI

typealias EntityMap = [String: Entity]

@MainActor class NotesARViewModel: ObservableObject {
    
    @Published var entityMap: EntityMap = [:]
    
    // Strong refenece, but ok since NotesModel should never be deallocated.
    var notesModel: NotesModel
    
    init(notesModel: NotesModel) {
        self.notesModel = notesModel
        // Register the update callback with the Notes Model
        self.notesModel.updateEntities = self.updateEntities
    }

    // Capture the camera content so we can project coordinates for user screen taps
    var cameraContent: RealityViewCameraContent?

    // 0.1 meters in x and y space, 0.001 to simulate paper thin depth
    fileprivate struct StickNoteBox {
        static let widthX: Float = 0.1
        static let heightY: Float = 0.1
        static let depthZ: Float = 0.001
    }
    
    func updateEntities() {
        var newEntityMap = EntityMap()
        for note in notesModel.notes {
            buildEntity(note: note, entityMap: &newEntityMap)
        }
        entityMap = newEntityMap
    }
    
    func buildEntity(note: StickyNote, entityMap: inout EntityMap) {
        
        let noteEntity = Entity()
        let textEntity = Entity()
        
        noteEntity.position = [note.position.positionX, note.position.positionY, note.position.positionZ]
        
        print("Position: \(noteEntity.position) | Transform: \(noteEntity.transform)")
        
        let noteMesh = MeshResource.generateBox(width: StickNoteBox.widthX,
                                                height: StickNoteBox.heightY,
                                                depth: StickNoteBox.depthZ)
        // 0.002 meters for text extrusion
        let textMesh = MeshResource.generateText(note.text,
                                                 extrusionDepth: 0.002,
                                                 font: UIFont.systemFont(ofSize: 0.01),
                                                 containerFrame: CGRect(x: -0.05, y: -0.05, width: 0.1, height: 0.1),
                                                 alignment: .center,
                                                 lineBreakMode: .byWordWrapping)
        
        let noteColor = UIColor(red: CGFloat(note.noteColor.red),
                                green: CGFloat(note.noteColor.green),
                                blue: CGFloat(note.noteColor.blue),
                                alpha: 1.0)
        let noteMaterial = SimpleMaterial(color: noteColor, isMetallic: false)
        
        let textColor = UIColor(red: CGFloat(note.textColor.red),
                                green: CGFloat(note.textColor.green),
                                blue: CGFloat(note.textColor.blue),
                                alpha: 1.0)
        let textMaterial = SimpleMaterial(color: textColor, isMetallic: false)
        
        // This builds the size of the tap target
        let collisionComponent = CollisionComponent(shapes: [
                ShapeResource.generateBox(
                    width: StickNoteBox.widthX,
                    height: StickNoteBox.heightY,
                    depth: StickNoteBox.depthZ
                )
            ]
        )
        
        // These components setup the Text, Mesh, Material, and TapGesture of the Entity
        noteEntity.components.set(
            [
                collisionComponent,
                InputTargetComponent(),
                ModelComponent(mesh: noteMesh, materials: [noteMaterial])
            ]
        )
        
        textEntity.components.set(
            [
                ModelComponent(mesh: textMesh, materials: [textMaterial])
            ]
        )
        
        noteEntity.addChild(textEntity)
        noteEntity.name = note.id

        // Add to the list of notes the RealityView is rendering
        entityMap[noteEntity.name] = noteEntity
    }
    
    func createEntity(x: CGFloat, y: CGFloat) async throws {
        
        // x, y, z position in meters (I think)
        // Seems unclear in the documentation what the position values represent
        guard var result = cameraContent?.ray(through: CGPoint(x: x, y: y),
                                           in: .local,
                                           to: .scene)?.origin else {
            // Could do some better error handling here
            return
        }
        // Pushing out the value a little ways on the z-axis for a better user experience
        result.z -= 0.25
        try await notesModel.createStickyNote(arSpacePosition: result)
    }
}
