//
//  ViewController.swift
//  chairARkit
//
//  Created by Syed ShahRukh Haider on 04/10/2017.
//  Copyright © 2017 Syed ShahRukh Haider. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var labelUI: UIView!
    // ARKit SceneView
    @IBOutlet weak var sceneView: ARSCNView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
//        let dicescene = SCNScene(named: "art.scnassets/chair.scn")!
        sceneView.autoenablesDefaultLighting = true

        sceneView.automaticallyUpdatesLighting = true
        
        let addTap = UITapGestureRecognizer(target: self, action: #selector(addItem))
        addTap.numberOfTapsRequired = 2
        sceneView.addGestureRecognizer(addTap)
        
        let menuTap = UITapGestureRecognizer(target: self, action: #selector(menuView))
        menuTap.numberOfTapsRequired = 1
        sceneView.addGestureRecognizer(menuTap)
        
//
        // Set the scene to the view
        
        
//        if let label = Bundle.main.loadNibNamed("menuLabel", owner: self, options: nil)?.first as? labelView{
//
//            self.sceneView.addSubview(label)
//    }
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
    
    
    @objc func addItem(recognizer : UITapGestureRecognizer){
        
        let scene = recognizer.view as! ARSCNView
        let location = recognizer.location(in: scene)
        
        let hitResult = scene.hitTest(location, types: .existingPlaneUsingExtent)
        
        if !hitResult.isEmpty{
            
            let hitPt = hitResult.first
            
            let chair = SCNScene(named: "art.scnassets/chair.scn")!
            
            if let chairNode = chair.rootNode.childNode(withName: "Saya", recursively: true){
                
                chairNode.position = SCNVector3(CGFloat((hitPt?.worldTransform.columns.3.x)!), CGFloat((hitPt?.worldTransform.columns.3.y)!), CGFloat((hitPt?.worldTransform.columns.3.z)!))
                
                
                self.sceneView.scene.rootNode.addChildNode(chairNode)
                
            }
            
            
        }
        
    }
    
  
    @objc func menuView(recognizer: UITapGestureRecognizer){
        
        
        let nodeView = recognizer.view as! ARSCNView
        let nodePt = recognizer.location(in: nodeView)
        
        let hitResponse = nodeView.hitTest(nodePt, types: .existingPlaneUsingExtent)
        
        if !hitResponse.isEmpty{
            let hitPT = hitResponse.first!
            
       
            if let label = Bundle.main.loadNibNamed("menuLabel", owner: self, options: nil)?.first as? labelView{
            
                label.frame.origin.y = sceneView.frame.maxY/2
                label.frame.origin.x = sceneView.frame.maxX/2
                
                sceneView.addSubview(label)
                
//                label.frame = CGRect(x: CGFloat(hitPT.worldTransform.columns.3.x), y: CGFloat(hitPT.worldTransform.columns.3.z), width: 10.0, height: 10.0)
//                let plane = SCNPlane(width: 0.1, height: 0.1)
//
//                let planeMaterial = SCNMaterial()
//                planeMaterial.diffuse.contents =
//                plane.firstMaterial = planeMaterial
//
//                let node = SCNNode(geometry: plane)
//                node.position = SCNVector3(hitPT.worldTransform.columns.3.x,hitPT.worldTransform.columns.3.y,hitPT.worldTransform.columns.3.z)
//                self.sceneView.scene.rootNode.addChildNode(node)
//                let view = SCNView(frame: label.frame)
//
//        view.frame.origin.x = CGFloat(hitPT.worldCoordinates.x)
//                view.addSubview(label)
//
//               nodeView.addSubview(label)
                
                
            }
            
            
        }
        
    }
  
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        if anchor is ARPlaneAnchor
        {
            
            let plane = anchor as! ARPlaneAnchor
            
            let floor = SCNPlane(width: CGFloat(plane.extent.x), height: CGFloat(plane.extent.x))
            
            let floorNode = SCNNode(geometry: floor)
            
            floorNode.simdPosition = simd_float3(plane.center.x, 0, plane.center.z)
            
            floorNode.eulerAngles.x = -Float.pi/2
            
            floorNode.opacity = 0.25
            
            node.addChildNode(floorNode)
            
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        if anchor is ARPlaneAnchor{
            
            let planeAnchor = anchor as! ARPlaneAnchor
            
            let planeNode = node.childNodes.first
            
            let plane = planeNode?.geometry as! SCNPlane
            
            planeNode?.simdPosition = simd_float3(planeAnchor.center.x, 0, planeAnchor.center.z)
            
            plane.width = CGFloat(planeAnchor.extent.x)
            plane.height = CGFloat(planeAnchor.extent.z)  
            
            
        }
    }
    
    
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
