//
//  ViewController.swift
//  firstARkit
//
//  Created by Syed ShahRukh Haider on 29/09/2017.
//  Copyright © 2017 Syed ShahRukh Haider. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Tapping recognizer
        
        let singleTap = UITapGestureRecognizer (target: self, action: #selector(tapped))
        singleTap.numberOfTapsRequired = 1
        sceneView.addGestureRecognizer(singleTap)
        
        let doubletap = UITapGestureRecognizer(target: self, action: #selector(rotateTap))
        doubletap.numberOfTapsRequired = 2
        sceneView.addGestureRecognizer(doubletap)
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        sceneView.autoenablesDefaultLighting = true
//        sceneView.automaticallyUpdatesLighting = true
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
       
        
        // BOX SCENE
        let box = SCNBox(width: 0.2, height: 0.2, length: 0.2, chamferRadius: 0)
        let boxMaterial = SCNMaterial()
        boxMaterial.diffuse.contents = UIColor.blue
        boxMaterial.name = "color"
        
        let boxNode = SCNNode()
        boxNode.geometry = box
        boxNode.geometry?.materials = [boxMaterial]
        boxNode.position = SCNVector3(-0.1, 0.1, -0.5)
        
        
 
        let sphere = SCNSphere(radius: 1)
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "art.scnassets/earth.jpg")
//        material.diffuse.contents = UIColor.green
//        material.name = "color"
      

        
//        let sphereNode = SCNNode(geometry: sphere)
        
        let sphereNode = SCNNode()
        sphereNode.geometry = sphere
        sphereNode.geometry?.materials = [material]
        sphereNode.position = SCNVector3(1,0.1,-5)
    
        
        
        scene.rootNode.addChildNode(sphereNode)
        scene.rootNode.addChildNode(boxNode)
        
        // Set the scene to the view
        self.sceneView.scene = scene

    }
    
    
   @objc func tapped(recognizer : UITapGestureRecognizer){
        
        let tapScene = recognizer.view as! ARSCNView
        let touchLocation = recognizer.location(in: tapScene)
        
        
        let hitResult = tapScene.hitTest(touchLocation, options: [:])
        
        if !hitResult.isEmpty{
            let node = hitResult[0].node
            let material = node.geometry?.material(named: "color")

            material?.diffuse.contents = UIColor.random()
     
        }
        
        
    }
    
    
    
    @objc func rotateTap(recognizer  : UITapGestureRecognizer){
        
        let view = recognizer.view as! ARSCNView
        let point = recognizer.location(in: view)
        
        let hitResult = view.hitTest(point, options: [:])
        
        if !hitResult.isEmpty{
            
            let node = hitResult.first!.node
            node.runAction(SCNAction.rotateBy(
                x: 0,
                y: 0.2,
                z: 0,
                duration: 0.2))
            
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        
        print ("hit")
        if  anchor is ARPlaneAnchor{
            
            let plane =  anchor as! ARPlaneAnchor
            
            let planeAnchor = SCNPlane(width: CGFloat(plane.extent.x), height: CGFloat(plane.extent.z))
            
            let planeNode = SCNNode(geometry: planeAnchor)
            let material = SCNMaterial()
//            material.diffuse.contents =
            
            planeNode.simdPosition = float3(plane.center.x, 0, plane.center.z)
            planeNode.eulerAngles.x = -Float.pi/2
            planeNode.opacity = 0.25
            
            node.addChildNode(planeNode)
            
        }
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        
        if anchor is ARPlaneAnchor{
            
            let planeAnchor = anchor as! ARPlaneAnchor
            
            let planeNode = node.childNodes.first
            
        let plane = planeNode?.geometry as! SCNPlane
            
            planeNode?.simdPosition = float3(planeAnchor.extent.x, 0, planeAnchor.extent.z)
            
            plane.width = CGFloat(planeAnchor.extent.x)
            plane.height = CGFloat(planeAnchor.extent.z)
        }
        
    }
    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}


extension CGFloat{
    
    static func rand () -> CGFloat{
        
        
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
        
    }
    
    
}

extension UIColor{
    
    static func random() -> UIColor{
        
        return UIColor(red: .rand(), green: .rand(), blue: .rand(), alpha: 1)
        
    }
    
    
}
