//
//  ViewController.swift
//  obeseMan
//
//  Created by Syed ShahRukh Haider on 17/10/2017.
//  Copyright © 2017 Syed ShahRukh Haider. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    
    
    var animations = ["art.scnassets/Stand Upfix.dae",
                      "art.scnassets/SambaFix.dae",
                      "art.scnassets/Robot Hip Hop Dance.dae",
                      "art.scnassets/Wave Hip Hop Dance.dae",
                      "art.scnassets/House Dancing.dae"]
    var count = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
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
    
    func loadAnimated(hitTest: SCNHitTestResult){
        
        let standScene = SCNScene(named:animations[0])!
        
        let node = SCNNode()
        
        for child in standScene.rootNode.childNodes{
            
            node.addChildNode(child)
        }
        
        node.position = SCNVector3(hitTest.worldCoordinates.x,hitTest.worldCoordinates.y,hitTest.worldCoordinates.z)
        node.scale = SCNVector3(0.07,0.07,0.07)
        
        sceneView.scene.rootNode.addChildNode(node)
        
//        loadAnimation(withKey: "dancing", sceneName: "art.scnassets/SambaFix", animationIdentifier: "SambaFix-1")

    }
    
    
    
//    func loadAnimation(withKey: String, sceneName:String, animationIdentifier:String) {
//        let sceneURL = Bundle.main.url(forResource: sceneName, withExtension: "dae")
//        let sceneSource = SCNSceneSource(url: sceneURL!, options: nil)
//
//        if let animationObject = sceneSource?.entryWithIdentifier(animationIdentifier, withClass: CAAnimation.self) {
//            // The animation will only play once
//            animationObject.repeatCount = 1
//            // To create smooth transitions between animations
//            animationObject.fadeInDuration = CGFloat(1)
//            animationObject.fadeOutDuration = CGFloat(0.5)
//
//            // Store the animation for later use
//            animations[withKey] = animationObject
//        }
//    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first!.location(in: sceneView)
        
        
        // Let's test if a 3D Object was touch
        var hitTestOptions = [SCNHitTestOption: Any]()
        hitTestOptions[SCNHitTestOption.boundingBoxOnly] = true
        
        let hitResults: [SCNHitTestResult]  = sceneView.hitTest(location, options: hitTestOptions)
        
        if hitResults.first != nil {
            if self.count == 0 {
                loadAnimated(hitTest: hitResults.first!)
                self.count += 1
                
            }
            else if self.count > 0 {
                playAnimation(hitTest : hitResults.first!)
                self.count += 1
                if self.count > 4{
                    self.count = 0
                }
            }
            return
        }
    }
    
    
    func playAnimation(hitTest: SCNHitTestResult) {
        // Add the animation to start playing it right away
      
        
        let danceScene = SCNScene(named : animations[self.count])!
        
        let node = SCNNode()
        
        for child in danceScene.rootNode.childNodes{
            
            node.addChildNode(child)
        }
        
        node.position = SCNVector3(hitTest.worldCoordinates.x,hitTest.worldCoordinates.y,hitTest.worldCoordinates.z)
        node.scale = SCNVector3(0.07,0.07,0.07)
        
        sceneView.scene.rootNode.addChildNode(node)
        
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
    func stopAnimation() {
        // Stop the animation with a smooth transition
//        sceneView.scene.rootNode.removeAnimation(forKey: key, blendOutDuration: CGFloat(0.5))
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
