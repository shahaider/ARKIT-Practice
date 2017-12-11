//
//  ViewController.swift
//  measureArkit
//
//  Created by Syed ShahRukh Haider on 06/10/2017.
//  Copyright © 2017 Syed ShahRukh Haider. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var ARSceneView: ARSCNView!
   
    var dotNodes = [SCNNode]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ARSceneView.delegate = self
ARSceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        let configuration = ARWorldTrackingConfiguration()
        
        ARSceneView.session.run(configuration)
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    
        if let location = touches.first?.location(in: ARSceneView){
        
        let hitResult = ARSceneView.hitTest(location, types:.featurePoint)
            
            if let hitTest = hitResult.first{
                addDot(point: hitTest)
            }
            
    }
    }
    
    func addDot(point : ARHitTestResult){
        
        let dot = SCNSphere(radius: 0.005)
        let dotMaterial = SCNMaterial()
        dotMaterial.diffuse.contents = UIColor.red
        dot.firstMaterial = dotMaterial
        
        let dotNode = SCNNode()
        dotNode.geometry = dot
        dotNode.position = SCNVector3(point.worldTransform.columns.3.y, point.worldTransform.columns.3.y, point.worldTransform.columns.3.z)
        
        ARSceneView.scene.rootNode.addChildNode(dotNode)
        
        self.dotNodes.append(dotNode)
        
        if dotNodes.count >= 2{
            
            measure()
            print("second point")
        }
        
    }

    func measure(){

        let firstPt = dotNodes[0]
        let secondPt = dotNodes[1]

        print("""
            first point : \(firstPt)
            second point : \(secondPt)
            """)

        let distance = sqrt(
            pow(secondPt.position.x - firstPt.position.x, 2) +
            pow(secondPt.position.y - firstPt.position.y, 2) +
            pow(secondPt.position.z - firstPt.position.z, 2)
        )

        print(distance)
        label(text: String(distance))

    }
    
    func label(text : String) {
        
        let textLabel = SCNText(string: text, extrusionDepth: 1)
        textLabel.firstMaterial?.diffuse.contents = UIColor.orange
        let textNode = SCNNode()
        textNode.geometry = textLabel
        textNode.position = SCNVector3(0, 0, 0)
        textNode.scale = SCNVector3(0.01,0.01,0.01)
        ARSceneView.scene.rootNode.addChildNode(textNode)
    }
}

