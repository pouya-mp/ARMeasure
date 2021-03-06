//
//  ViewController.swift
//  ARMeasure
//
//  Created by pouyaa on 10/12/1398 AP.
//  Copyright © 1398 pouyaa. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var dotnNodes = [SCNNode]()
    var textNode = SCNNode()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        

    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touchLocation = touches.first?.location(in: sceneView) {
            
            if dotnNodes.count >= 2{
                for dot in dotnNodes{
                    dot.removeFromParentNode()
                }
                dotnNodes = [SCNNode]()
            }
            
            let hitTestResults = sceneView.hitTest(touchLocation, types: .featurePoint)
            if let hitResult = hitTestResults.first {
                addDot(at: hitResult)
            }
            
        }
    }
    
    func addDot(at hitResult : ARHitTestResult){
        let dot = SCNSphere(radius: 0.005)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.red
        dot.materials = [material]
        let dotNode = SCNNode()
        dotNode.position = SCNVector3(CGFloat(hitResult.worldTransform.columns.3.x), CGFloat(hitResult.worldTransform.columns.3.y), CGFloat(hitResult.worldTransform.columns.3.z))
        dotNode.geometry = dot
        sceneView.scene.rootNode.addChildNode(dotNode)
        dotnNodes.append(dotNode)
        
        if dotnNodes.count >= 2 {
            calculate()
        }
        
    }
    
    func calculate(){
        
        let start = dotnNodes[0]
        let end = dotnNodes[1]
        
        print(start.position)
        print(end.position)
        
        let a = (end.position.x - start.position.x)
        let b = (end.position.y - start.position.y)
        let c = (end.position.z - start.position.z)
        
        let distance = sqrt(pow(a, 2) + pow(b, 2) + pow(c, 2))
        print(abs(distance))
        
        updateText(text: "\(abs(distance))", atPosition: end.position)
        
    }
    
    func updateText(text : String, atPosition position :SCNVector3){
        
        textNode.removeFromParentNode()
        
        let textGeometry = SCNText(string: text, extrusionDepth: 1.0)
        textGeometry.firstMaterial?.diffuse.contents = UIColor.cyan
        textNode = SCNNode(geometry: textGeometry)
        textNode.position = SCNVector3(position.x, position.y + 0.01, position.z)
        textNode.scale = SCNVector3(0.01, 0.01, 0.01)
        sceneView.scene.rootNode.addChildNode(textNode)
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

}
