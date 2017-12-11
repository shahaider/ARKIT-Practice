//
//  overlayPlane.swift
//  plane detection
//
//  Created by Syed ShahRukh Haider on 05/10/2017.
//  Copyright © 2017 Syed ShahRukh Haider. All rights reserved.
//

import Foundation
import ARKit
import SceneKit

class overlayPlane : SCNNode {
    
    var anchor : ARPlaneAnchor
    var planeGeometry : SCNPlane!
    
    init(anchor: ARPlaneAnchor){
        self.anchor = anchor
        super.init()

        setup()
    }
    
    
    func update(updateAnchor: ARPlaneAnchor){
        
        // storing width and height of plane
        self.planeGeometry.width = CGFloat(updateAnchor.extent.x)
        self.planeGeometry.height = CGFloat(updateAnchor.extent.z)
        
        self.position = SCNVector3Make(updateAnchor.center.x, 0, updateAnchor.center.z)
        
//               let planeNode = self.childNodes.first!
//                planeNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
//                planeNode.physicsBody?.categoryBitMask = shape.grid.rawValue

    }
    
    
    func setup(){
        
        self.planeGeometry = SCNPlane(width: CGFloat(self.anchor.extent.x), height: CGFloat(self.anchor.extent.z))
        
       let planeMaterials =  SCNMaterial()
        planeMaterials.diffuse.contents = ("art.scnassets/2_wood2.jpg")
        planeGeometry.materials = [planeMaterials]
        
        // setting node
        
        let planeNode =  SCNNode()
//        planeNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
//        planeNode.physicsBody?.categoryBitMask = shape.grid.rawValue
        planeNode.position = SCNVector3Make(anchor.center.x, anchor.center.y, anchor.center.z)
        
        
        // 90 degree shift
        
        planeNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)
       
        
        // Add planegeometry to  the node
        planeNode.geometry = planeGeometry
        self.addChildNode(planeNode)
        
        
        
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implement")
    }
    
}
