//
//  ViewController.swift
//  plane detection
//
//  Created by Syed ShahRukh Haider on 05/10/2017.
//  Copyright © 2017 Syed ShahRukh Haider. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

enum BodyType : Int {
    case box = 1
     case plane = 2
    
}


class ViewController: UIViewController, ARSCNViewDelegate {

  
    
    @IBOutlet var sceneView: ARSCNView!

    
    
    // variable to assosciate with overlayPlane

    var planes = [overlayPlane]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Enable  Debugging
        
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        // Create a new scene
        let scene = SCNScene()
        
        sceneView.autoenablesDefaultLighting = true
        
        // Set the scene to the view
        sceneView.scene = scene
        
        // screen tapping configuration
        
        let tap  = UITapGestureRecognizer(target: self, action: #selector(tapped))
        sceneView.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    @objc func tapped(recognizer : UIGestureRecognizer){
        
        print ("knock")
        let tapScreen = recognizer.view as! ARSCNView
        let touchLocation = recognizer.location(in: tapScreen)

        let Result =  tapScreen.hitTest(touchLocation, types: .existingPlaneUsingExtent)
        if !Result.isEmpty{

            guard let hitResult = Result.first else{

                return
            }
            addObject(hitResult: hitResult)
        }
    }
    
      func addObject(hitResult : ARHitTestResult){
        
       
        
        let box = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
        
        let boxMaterial = SCNMaterial()
        boxMaterial.diffuse.contents = UIImage(named: "art.scnassets/brick.jpg")
        
        box.materials = [boxMaterial]
        
//        let boxNode = SCNNode(geometry: box)
        let boxNode = SCNNode()
        // add physic detection element
        boxNode.geometry = box

        boxNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        
        // allocate physical catergory
        boxNode.physicsBody?.categoryBitMask = BodyType.box.rawValue
        
        
        boxNode.position = SCNVector3(hitResult.worldTransform.columns.3.x, hitResult.worldTransform.columns.3.y + Float(box.height/2), hitResult.worldTransform.columns.3.z)

        
        sceneView.scene.rootNode.addChildNode(boxNode)
        
        
    }
  
     
     
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        
                    print("PLANE DETECTED")

        // *********** CODING W.R.T OVERLAYPLANE.SWIFT ************

        if anchor is ARPlaneAnchor{
            
            let planeAnchor = anchor as! ARPlaneAnchor
            
            let plane = overlayPlane(anchor: planeAnchor)
            
            self.planes.append(plane)
            
            // add to the node
            node.addChildNode(plane)
        }

        
        // **************** other method **************
        
//        if anchor is ARPlaneAnchor{
//
//
//            let planeAnchor =  anchor as! ARPlaneAnchor
//
//
//            let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
//
//
//
//            // setting node
//
//            let sceneNode = SCNNode()
//
//            sceneNode.position = SCNVector3(planeAnchor.center.x, 0, planeAnchor.center.z)
//            sceneNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)
//
//            // creating plane material
//            let sceneMaterial = SCNMaterial()
//            sceneMaterial.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
//            plane.materials = [sceneMaterial]
//            sceneNode.geometry = plane
//
//            node.addChildNode(sceneNode)
//
//        }
//
        
        

       
    }
    
    // ****************** joining multiple planes *********************
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {


    
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Pause the view's session
        sceneView.session.pause()
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
