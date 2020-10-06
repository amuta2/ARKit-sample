//
//  ViewController.swift
//  ARKit_sample
//
//  Created by Tatsuya Amida on 2020/10/01.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // デリゲートを設定
        sceneView.delegate = self
        
        // シーンを作成して登録
        sceneView.scene = SCNScene()
        
        // 特徴点を表示する
//        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showWireframe]
        
        // ライトの追加
//        sceneView.autoenablesDefaultLighting = true
        
        // 平面検出
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        sceneView.session.run(configuration)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else {fatalError()}
        
        // ノードを作成
        let planeNode = SCNNode()
        
        let geometory = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
        
        let floorColor = UIColor.red.withAlphaComponent(0.5)
        let wallColor = UIColor.blue.withAlphaComponent(0.5)
        
        if planeAnchor.alignment == .horizontal {
            geometory.materials.first?.diffuse.contents = floorColor
        } else {
            geometory.materials.first?.diffuse.contents = wallColor
        }
        
        // ノードにGeometoryとTranformを設定
        planeNode.geometry = geometory
        planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2.0, 1,0, 0)
        
        // 検出面の子要素にする
        node.addChildNode(planeNode)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else {fatalError()}
        guard let geometoryPlaneNode = node.childNodes.first, let planeGeometory = geometoryPlaneNode.geometry as? SCNPlane else {fatalError()}
        
        planeGeometory.width = CGFloat(planeAnchor.extent.x)
        planeGeometory.height = CGFloat(planeAnchor.extent.z)
        geometoryPlaneNode.simdPosition = float3(planeAnchor.center.x, 0, planeAnchor.center.z)
    }
    
}
