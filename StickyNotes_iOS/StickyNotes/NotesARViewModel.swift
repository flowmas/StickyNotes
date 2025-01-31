//
//  NotesARViewModel.swift
//  StickyNotes
//
//  Created by Sam Wolf on 1/30/25.
//

import Foundation
import RealityKit
import SwiftUI
import UIKit.UIFont

@MainActor class NotesARViewModel: ObservableObject {
    
    
    
    @Published var entities: [Entity] = []
    var cameraContent: RealityViewCameraContent?

    
    // 0.1 meters in x and y space, 0.001 to simulate paper thin depth
    fileprivate struct StickNoteBox {
        static let widthX: Float = 0.1
        static let heightY: Float = 0.1
        static let depthZ: Float = 0.001
    }
    
    func createEntity(x: CGFloat, y: CGFloat) {
        // Create a sticky note Anchor
        let anchor = AnchorEntity()
        let noteEntity = Entity()
        let textEntity = Entity()
        
        let mesh = MeshResource.generateBox(width: StickNoteBox.widthX,
                                            height: StickNoteBox.heightY,
                                            depth: StickNoteBox.depthZ)
        // 0.002 meters for text extrusion
        let textMesh = MeshResource.generateText("Hello World! | (\(self.entities.count)",
                                                 extrusionDepth: 0.002,
                                                 font: UIFont.systemFont(ofSize: 0.01),
                                                 containerFrame: CGRect(x: -0.05, y: -0.05, width: 0.1, height: 0.1),
                                                 alignment: .center,
                                                 lineBreakMode: .byWordWrapping)
        
        let material = SimpleMaterial(color: .systemPink, isMetallic: false)
        let textMaterial = SimpleMaterial(color: .white, isMetallic: false)

        // x, y, z position in meters (I think)
        // Seems unclear in the documentation what the position values represent
        if let result = cameraContent?.ray(through: CGPoint(x: x, y: y),
                                           in: .local,
                                           to: .scene)?.origin {
            anchor.position = result
            print("Projection result: \(result)")
        } else {
            // This will shift new Sticky Notes to the right
            // A fallback if coordinate projection fails
            anchor.position = [
                Float(0.2) * Float(self.entities.count),
                Float(0.1),
                Float(0.0)
            ]
        }
        
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
                ModelComponent(mesh: mesh, materials: [material])
            ]
        )
        
        textEntity.components.set(
            [
                ModelComponent(mesh: textMesh, materials: [textMaterial])
            ]
        )
                                  
        anchor.addChild(noteEntity)
        anchor.addChild(textEntity)
       // anchor.transform = Transform(matrix: )
        
       // let cameraTransform = parent.transformMatrix(relativeTo: nil)
       //Preferably something from Leetcode or well known. The place I'm preparing for told me explicitly that studying well known / Leetcode problems easy/medium is best preparation for their Whiteboard Onsite. HasTransform().look(at: , from: , relativeTo: )
        // Add to the list of notes the RealityView is rendering
        entities.append(anchor)
    }
}
