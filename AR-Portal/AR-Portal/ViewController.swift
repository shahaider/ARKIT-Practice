//
//  ViewController.swift
//  AR-Portal
//
//  Created by Syed ShahRukh Haider on 28/10/2017.
//  Copyright © 2017 Syed ShahRukh Haider. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var portalView: ARSCNView!
    @IBOutlet weak var planeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // ARKit configuration
        
        planeLabel.isHidden = true
        portalView.delegate = self
        portalView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        
        let configuration = ARWorldTrackingConfiguration()
        portalView.autoenablesDefaultLighting = true
        configuration.planeDetection = .horizontal
        
        portalView.session.run(configuration)
        let portalScene = SCNScene()

        self.portalView.scene = portalScene
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        portalView.addGestureRecognizer(tapGesture)
        
    }

    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        DispatchQueue.main.async {
            guard anchor is ARPlaneAnchor else {
                return
            }
            self.planeLabel.isHidden = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()+3) {
            self.planeLabel.isHidden = true
        }
       
    }
    
    @objc func handleTap(recognize: UITapGestureRecognizer){
        
        let scene = recognize.view as! ARSCNView
        let touchLocation = recognize.location(in: scene)
        
        let HitResult =  scene.hitTest(touchLocation, types: .existingPlaneUsingExtent)
        
        if !HitResult.isEmpty{
            
            self.addPortal(result: HitResult.first!)
        }
        
        
        
    }

    func addPortal(result: ARHitTestResult){
        
        let portalScene = SCNScene(named: "portal.scnassets/portal.scn")
        
        let portalNode = portalScene?.rootNode.childNode(withName: "portal", recursively: false)
        
        let transform = result.worldTransform
        
        let planeX = transform.columns.3.x
        let planeY = transform.columns.3.y
        let planeZ = transform.columns.3.z
        
        portalNode!.position = SCNVector3(planeX,planeY,planeZ)
        
        self.portalView.scene.rootNode.addChildNode(portalNode!)
        
        self.addToPlane(nodeName: "Roof", portalNode: portalNode!, imageName: "cubeRoof")
        self.addToPlane(nodeName: "Floor", portalNode: portalNode!, imageName: "Floor")
        self.addWall(nodeName: "Leftwall", portalNode: portalNode!, imageName: "rightwall")
        self.addWall(nodeName: "Righwall", portalNode: portalNode!, imageName: "leftwall")
        self.addWall(nodeName: "Backwall", portalNode: portalNode!, imageName: "backwall")
        self.addWall(nodeName: "Greywall", portalNode: portalNode!, imageName: "frontwall left")
        self.addWall(nodeName: "Blackwall", portalNode: portalNode!, imageName: "frontwall right")

        


    }
    
    func addWall(nodeName:String, portalNode:SCNNode, imageName:String){
        
        let child = portalNode.childNode(withName: nodeName, recursively: true)
        child?.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "portal.scnassets/\(imageName).png")
        child?.renderingOrder = 200
        if let mask = child?.childNode(withName: "mask", recursively: false){
            
            mask.geometry?.firstMaterial?.transparency = 0.000001
            
            
        }
        
    }
    
    func addToPlane(nodeName:String, portalNode:SCNNode, imageName:String){
        
        let child = portalNode.childNode(withName: nodeName, recursively: true)
        child?.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "portal.scnassets/\(imageName).png")
        child?.renderingOrder = 200
        
    }
}

