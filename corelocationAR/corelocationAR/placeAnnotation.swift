//
//  placeAnnotation.swift
//  corelocationAR
//
//  Created by Syed ShahRukh Haider on 13/11/2017.
//  Copyright © 2017 Syed ShahRukh Haider. All rights reserved.
//

import Foundation
import ARCL
import CoreLocation
import SceneKit

class placeAnnotation: LocationNode{
    
    
    var title : String
    var AnnotationNode : SCNNode
    
    init(location : CLLocation?, Title: String){
        
        self.AnnotationNode =  SCNNode()
        self.title = Title

        super.init(location: location)
        
        self.initializeUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func center(node:SCNNode){
        let (min,max) =  node.boundingBox
        let dx = min.x  + 0.5 * (max.x - min.x)
        let dy = min.y  + 0.5 * (max.y - min.y)
        let dz = min.z  + 0.5 * (max.z - min.z)

        node.pivot = SCNMatrix4MakeTranslation(dx, dy, dz)
        
    }
    
    private func initializeUI(){
        
        let plane = SCNPlane(width: 5, height: 0.1)
        plane.cornerRadius = 0.2
        plane.firstMaterial?.diffuse.contents = UIColor.blue
        
        
        // text
        
        let text = SCNText(string: self.title, extrusionDepth: 0)
        text.containerFrame = CGRect(x: 0, y: 0, width: 5, height: 3)
        text.isWrapped = true
        text.font = UIFont(name: "Futura", size: 1)
        text.alignmentMode = kCAAlignmentCenter
        text.truncationMode = kCATruncationMiddle
        text.firstMaterial?.diffuse.contents = UIColor.white
        
        let textNode = SCNNode(geometry: text)
        textNode.position = SCNVector3(0,0,0.2)
        center(node: textNode)
        
        let planeNode = SCNNode(geometry: plane)
        self.AnnotationNode.scale = SCNVector3(3,3,3)
        self.AnnotationNode.addChildNode(planeNode)
        
        let billboardConstraint = SCNBillboardConstraint()
        billboardConstraint.freeAxes = SCNBillboardAxis.Y
        constraints = [billboardConstraint]
        
        
        self.addChildNode(self.AnnotationNode)
        
    }
    
    
    
}
