//
//  ViewController.swift
//  NodePositionHandler
//
//  Created by user on 12/13/18.
//  Copyright © 2018 Vitaliy Manov. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var nodeWasAdded: Bool = false
    var planeNode: SCNNode?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        let scene = SCNScene()
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        
        sceneView.session.run(configuration)
        
        sceneView.delegate = self
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else {
            return
        }
        
        guard nodeWasAdded == false else {
            return
        }
        
        let width = CGFloat(planeAnchor.extent.z) / 5
        let height = CGFloat(planeAnchor.extent.z) / 5
        let plane = SCNPlane(width: width, height: height)
        
        plane.materials.first?.diffuse.contents = UIColor.lightGray
        
        planeNode = SCNNode(geometry: plane)
        
        let x = CGFloat(planeAnchor.center.x)
        let y = CGFloat(planeAnchor.center.y)
        let z = CGFloat(planeAnchor.center.z)
        planeNode?.position = SCNVector3(x, y, z)
        planeNode?.eulerAngles.x = -.pi / 2
        
        node.addChildNode(planeNode!)
        nodeWasAdded = true
    }
    
    @IBAction func addToFrontButtonTapped(_ sender: Any) {
        planeNode = sceneView.pointOfView
        if let planeNode = planeNode {
            planeNode.removeFromParentNode()
            planeNode.position = SCNVector3Make(0, 0, -0.5)
            planeNode.eulerAngles.x = 0
            sceneView.pointOfView?.addChildNode(planeNode)
        }
    }
    
    @IBAction func removeFromFrontButtonTapped(_ sender: Any) {
        if let planeNode = planeNode {
            planeNode.removeFromParentNode()
            self.planeNode = nil
            nodeWasAdded = false
        }
    }
}
