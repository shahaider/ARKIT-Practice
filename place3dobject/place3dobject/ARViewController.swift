//
//  ARViewController.swift
//  place3dobject
//
//  Created by Syed ShahRukh Haider on 11/10/2017.
//  Copyright © 2017 Syed ShahRukh Haider. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ARViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var sceneView: ARSCNView!
    
    var planes =  [overlayPlane]()
    
    var selected = 1
    
    //    var Floors = [ARPlaneAnchor]()
    var floorGrid : SCNPlane!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        sceneView.autoenablesDefaultLighting = true
        // Create a new scene
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped))
        sceneView.addGestureRecognizer(tapGesture)
        
        
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        
        
        
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
        
        
        if anchor is ARPlaneAnchor{
            
            let planeAnchor = anchor as! ARPlaneAnchor
            
            let plane = overlayPlane(anchor: planeAnchor)
            
            self.planes.append(plane)
            
            // add to the node
            node.addChildNode(plane)
        }
        
        
        //        if anchor is  ARPlaneAnchor{
        //
        //
        //            print("plane")
        //            let plane = anchor as! ARPlaneAnchor
        //
        //            self.floorGrid = SCNPlane(width: CGFloat(Float(plane.extent.x)), height: CGFloat(plane.extent.z))
        //
        //            let floorMaterial = SCNMaterial()
        //            floorMaterial.diffuse.contents = ("art.scnassets/2_wood2.jpg")
        //
        //
        //            let floorNode = SCNNode()
        //            floorNode.geometry = self.floorGrid
        //            floorNode.geometry?.materials = [floorMaterial]
        //
        //            floorNode.position = SCNVector3(plane.center.x,plane.center.y,plane.center.z)
        //            floorNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)
        //
        //            self.Floors.append(plane)
        //
        //            node.addChildNode(floorNode)
        //
        //
        //        }
    }
    
    
    
    func renderer(_ renderer: SCNSceneRenderer, willUpdate node: SCNNode, for anchor: ARAnchor) {
        
        
        let plane = planes.filter { (plane) -> Bool in
            return plane.anchor.identifier == anchor.identifier
            }.first
        
        if plane == nil{
            
            return
        }
        plane?.update(updateAnchor: anchor as! ARPlaneAnchor)
        
        //        print("update")
        //                if anchor is ARPlaneAnchor{
        //
        //                    let plane = anchor as! ARPlaneAnchor
        //                    self.floorGrid.width = CGFloat(plane.extent.x)
        //                    self.floorGrid.height = CGFloat(plane.extent.z)
        //
        //                    node.position = SCNVector3(plane.center.x, 0, plane.center.z)
        //
        //
        //                }
        
        //        let floor = Floors.filter { (plane) -> Bool in
        //            return plane.identifier == anchor.identifier
        //        }.first
        //
        //        if floor == nil{
        //            return
        //        }
        //
        //        if let updateFloor = floor {
        //
        //        self.floorGrid.width = CGFloat(updateFloor.extent.x)
        //        self.floorGrid.height = CGFloat(updateFloor.extent.z)
        //
        //            node.position = SCNVector3(updateFloor.center.x,0, updateFloor.center.z)
        //
        //
        //        }
    }
    
    @objc func tapped (recognizer: UITapGestureRecognizer){
        
        let view = recognizer.view as! ARSCNView
        let location = recognizer.location(in: view)
        
        let hitResult = view.hitTest(location, types: .existingPlaneUsingExtent)
        
        if !hitResult.isEmpty{
            
            let hit = hitResult.first
            
            
            if selected == 1{
                        let sofa = SCNScene(named: "art.scnassets/sofa.scn")!
            
            
                        if let sofaNode = sofa.rootNode.childNode(withName: "___DUMMY_Rectangle1", recursively: true){
                        sofaNode.position = SCNVector3((hit?.worldTransform.columns.3.x)!,(hit?.worldTransform.columns.3.y)! + Float(0.3),(hit?.worldTransform.columns.3.z)!)
            
            
            
                            self.sceneView.scene.rootNode.addChildNode(sofaNode)
            //
                        }
            }
            else if selected == 2{
            let lamp = SCNScene(named: "art.scnassets/FloorLamp.scn")!

            if let lampNode = lamp.rootNode.childNode(withName: "FloorLamp", recursively: true){
                lampNode.position = SCNVector3((hit?.worldTransform.columns.3.x)!,(hit?.worldTransform.columns.3.y)! + Float(0.1),(hit?.worldTransform.columns.3.z)!)
                
                
                
                self.sceneView.scene.rootNode.addChildNode(lampNode)
            }
            }
            //            sceneNode.scale = SCNVector3(0.01,0.01,0.01)
        }
        
        
    }
    
    @IBAction func sofaButton(_ sender: Any) {
        selected = 1
    }
    
    @IBAction func lampButton(_ sender: Any) {
        selected = 2
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
