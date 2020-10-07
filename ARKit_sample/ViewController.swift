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
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        // ライトの追加
        sceneView.autoenablesDefaultLighting = true
        
        // 平面検出
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        sceneView.session.run(configuration)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 最初にタップした座標を取り出す
        guard let touch = touches.first else {return}
        
        // スクリーン座標に変換する
        let touchPosition = touch.location(in: sceneView)
        
        // タップされた位置のARアンカーを探す
        let hitTest = sceneView.hitTest(touchPosition, types: .existingPlaneUsingExtent)
        
        if !hitTest.isEmpty {
            // タップした箇所が取得できていればアンカーを追加
            let anchor = ARAnchor(transform: hitTest.first!.worldTransform)
            sceneView.session.add(anchor: anchor)
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard !(anchor is ARPlaneAnchor) else { return }
        
        // 球のノードを作成
        let sphereNode = SCNNode()

        // ノードにGeometoryとTranformを設定
        sphereNode.geometry = SCNSphere(radius: 0.05)
        sphereNode.position.y += Float(0.05)
        
        // 検出面の子要素にする
        node.addChildNode(sphereNode)
    }
    
//    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
//        guard let planeAnchor = anchor as? ARPlaneAnchor else {fatalError()}
//        guard let geometoryPlaneNode = node.childNodes.first, let planeGeometory = geometoryPlaneNode.geometry as? SCNPlane else {fatalError()}
//
//        planeGeometory.width = CGFloat(planeAnchor.extent.x)
//        planeGeometory.height = CGFloat(planeAnchor.extent.z)
//        geometoryPlaneNode.simdPosition = float3(planeAnchor.center.x, 0, planeAnchor.center.z)
//    }
    
}
