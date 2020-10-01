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
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showWireframe]
        
        // ライトの追加
        sceneView.autoenablesDefaultLighting = true
        
        // 平面検出
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        // 球のノードを作成
        let sphereNode = SCNNode()
        
        // ノードにGeometoryとTranformを設定
        sphereNode.geometry = SCNSphere(radius: 0.05)
        sphereNode.position.y += Float(0.05)
        
        // 検出面の子要素にする
        node.addChildNode(sphereNode)
    }
    
}
