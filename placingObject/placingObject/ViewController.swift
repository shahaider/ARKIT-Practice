//
//  ViewController.swift
//  placingObject
//
//  Created by Syed ShahRukh Haider on 09/10/2017.
//  Copyright © 2017 Syed ShahRukh Haider. All rights reserved.
//

import UIKit
import ARKit
import SceneKit




enum shape: Int{
    
    case  grid = 10
    case sphere = 3
    case prism = 1
    case cube = 4
}

class ViewController: UIViewController,ARSCNViewDelegate {

    
    // ARScreenView IBOutlet
    @IBOutlet weak var ARSceneView: ARSCNView!
    
    var planes =  [overlayPlane]()
    
//    var planeGrid : SCNPlane!
    
    var selectedShape : Int!

    
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.selectedShape = 1
        
        // Set the view's delegate
        ARSceneView.delegate = self
        
        // Show statistics such as fps and timing information
        ARSceneView.showsStatistics = true
        
        ARSceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints,ARSCNDebugOptions.showWorldOrigin]
        // Create a new scene
        let ARScene = SCNScene()
        
        self.ARSceneView.autoenablesDefaultLighting = true

        ARSceneView.scene = ARScene

        // Tappedd gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped))
        tapGesture.numberOfTapsRequired = 2
        ARSceneView.addGestureRecognizer(tapGesture)
        
        
        let forceTapGesture = UITapGestureRecognizer(target: self, action: #selector(forcetapped))
       forceTapGesture.numberOfTapsRequired = 1
       ARSceneView.addGestureRecognizer(forceTapGesture)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        configuration.planeDetection = .horizontal
        
        // Run the view's session
        ARSceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        ARSceneView.session.pause()
    }
    
    
    @objc func tapped(recognizer : UITapGestureRecognizer){
        
    
        
        let screenView = recognizer.view as! ARSCNView
        let touchlocation = recognizer.location(in: screenView)

        let hitResult = screenView.hitTest(touchlocation, types: .estimatedHorizontalPlane)

        if !hitResult.isEmpty{

            let coordinate = hitResult.first


            // Select desire SHAPE
            switch selectedShape{
            case 2:
                let prism = SCNPyramid(width: 0.2, height: 0.2, length: 0.2)
                let prismMaterial = SCNMaterial()
                prismMaterial.diffuse.contents = ("resources/brick.jpg")
                prism.firstMaterial = prismMaterial
                
                let prismNode = SCNNode(geometry : prism)
                
                prismNode.position = SCNVector3((coordinate?.worldTransform.columns.3.x)!, (coordinate?.worldTransform.columns.3.y)!, (coordinate?.worldTransform.columns.3.z)!)

                prismNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
                prismNode.physicsBody?.categoryBitMask = shape.prism.rawValue


                prismNode.position = SCNVector3((coordinate?.worldTransform.columns.3.x)!, (coordinate?.worldTransform.columns.3.y)! + Float(prism.height/2), (coordinate?.worldTransform.columns.3.z)!)
                
                ARSceneView.scene.rootNode.addChildNode(prismNode)

            case 3:
                let cube = SCNBox(width: 0.2, height: 0.1, length: 0.3, chamferRadius: 0.025)
                let cubeMaterial = SCNMaterial()
                cubeMaterial.diffuse.contents = ("resources/ice.jpg")
                cube.firstMaterial = cubeMaterial

                let cubeNode = SCNNode(geometry: cube)
                
                cubeNode.position = SCNVector3((coordinate?.worldTransform.columns.3.x)!, (coordinate?.worldTransform.columns.3.y)! + Float(cube.height/2) , (coordinate?.worldTransform.columns.3.z)!)

                cubeNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
                cubeNode.physicsBody?.categoryBitMask = shape.cube.rawValue
               
                
                

                ARSceneView.scene.rootNode.addChildNode(cubeNode)

            default:
                let sphere = SCNSphere(radius: 0.075)
                let sphereMaterial = SCNMaterial()
                sphereMaterial.diffuse.contents = ("resources/tennisball.jpg")
                sphere.firstMaterial = sphereMaterial
                
                let sphereNode = SCNNode(geometry: sphere)
                
                sphereNode.position = SCNVector3((coordinate?.worldTransform.columns.3.x)!, (coordinate?.worldTransform.columns.3.y)! + Float(sphere.radius/2), (coordinate?.worldTransform.columns.3.z)!)

                sphereNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
                sphereNode.physicsBody?.categoryBitMask = shape.sphere.rawValue

                ARSceneView.scene.rootNode.addChildNode(sphereNode)

            }

        }
        
        
        
    }
    
   
    
    @objc func forcetapped(reconizer : UITapGestureRecognizer){
        
        let nodeView = reconizer.view as! ARSCNView
        let nodeLocation = reconizer.location(in: nodeView)
        
        let hitResults =  nodeView.hitTest(nodeLocation, options: [:])
        
        if !hitResults.isEmpty{
            
            guard let hitResult = hitResults.first else{
                
                return
            }
            let node = hitResult.node
            
            let coordinate = SCNVector3(hitResult.worldCoordinates.x * Float(2.0), hitResult.worldCoordinates.y * Float(2.0), hitResult.worldCoordinates.z * Float(2.0))
            node.physicsBody?.applyForce(coordinate, asImpulse: true)
            
        
            
        }
        
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        print("*************PLANE DETECTED***********")
        
        if anchor is ARPlaneAnchor{
            
            let planeAnchor = anchor as! ARPlaneAnchor
            
            let plane = overlayPlane(anchor: planeAnchor)
            
            self.planes.append(plane)
            
            // add to the node
            node.addChildNode(plane)
        }

//        if anchor is ARPlaneAnchor{
//
//            let plane = anchor as! ARPlaneAnchor
//
//            self.planeGrid = SCNPlane(width: CGFloat(plane.extent.x), height: CGFloat(plane.extent.z))
//
//            let gridMaterial = SCNMaterial()
//            gridMaterial.diffuse.contents = ("resources/grid.png")
//
//            let gridNode = SCNNode()
//            gridNode.geometry = planeGrid
//            gridNode.geometry?.materials = [gridMaterial]
//
//            gridNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
//            gridNode.physicsBody?.categoryBitMask = shape.grid.rawValue
//            gridNode.position = SCNVector3Make(plane.center.x, plane.center.y, plane.center.z)
//            gridNode.transform = SCNMatrix4MakeRotation(-Float.pi/2,1, 0, 0)
//
//
//            self.planes.append(plane)
//            node.addChildNode(gridNode)
//
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
        
        
        
        
//        if anchor is ARPlaneAnchor{
//
//            let plane = anchor as! ARPlaneAnchor
//            self.planeGrid.width = CGFloat(plane.extent.x)
//            self.planeGrid.height = CGFloat(plane.extent.z)
//
//            node.position = SCNVector3(plane.center.x, 0, plane.center.z)
//
//            let planeNode = node.childNodes.first!
//            planeNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
//            planeNode.physicsBody?.categoryBitMask = shape.grid.rawValue
//        }
    }
    
    
    @IBAction func sphereButton(_ sender: Any) {
        
        selectedShape = 1
        

        
    }
    @IBAction func prismButton(_ sender: Any) {
        selectedShape = 2


    }
    @IBAction func cubeButton(_ sender: Any) {
        selectedShape = 3
        

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


