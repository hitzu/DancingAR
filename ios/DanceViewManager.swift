import Foundation
import UIKit
import ARKit
import SceneKit

@objc(DanceViewManager)
class DanceViewManager: RCTViewManager, ARSCNViewDelegate {
  var arView: ARSCNView!
  var boxPickCount: Int = 0;
  var animations = [String: CAAnimation]()
  var idle:Bool = true
  
  override static func requiresMainQueueSetup() -> Bool {
    return true
  }
  
  override func view() -> UIView! {
    self.arView = ARSCNView()
    let configuration = ARWorldTrackingConfiguration()
    configuration.planeDetection = .horizontal
    arView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
    arView.delegate = self
    arView.session.run(configuration)
    return arView
  }
  
  func loadAnimations (x: Float, y: Float, z: Float) {
    var sceneName: String = "art.scnassets/momo_samba_fixed.dae"
    if (self.boxPickCount == 1) {
      sceneName = "art.scnassets/momo_hiphop_fixed.dae"
    } else if (self.boxPickCount == 2) {
      sceneName = "art.scnassets/momo_salsa_fixed.dae"
    }
    let idleScene = SCNScene(named: sceneName)!
    
    let node = SCNNode()
    for child in idleScene.rootNode.childNodes {
      node.addChildNode(child)
    }
    node.position = SCNVector3(x, y, z)
    node.scale = SCNVector3(0.04, 0.04, 0.04)
    arView.scene.rootNode.addChildNode(node)
  }
  
  func playAnimation(key: String) {
    // Add the animation to start playing it right away
    arView.scene.rootNode.addAnimation(animations[key]!, forKey: key)
  }
  
  func stopAnimation(key: String) {
    // Stop the animation with a smooth transition
    arView.scene.rootNode.removeAnimation(forKey: key, blendOutDuration: CGFloat(0.5))
  }
  
  func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
    guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
    
    let width = CGFloat(planeAnchor.extent.x)
    let height = CGFloat(planeAnchor.extent.z)
    let plane = SCNPlane(width: width, height: height)
    
    plane.materials.first?.diffuse.contents = UIColor.white.withAlphaComponent(0.5)
    
    let planeNode = SCNNode(geometry: plane)
    
    let x = CGFloat(planeAnchor.center.x)
    let y = CGFloat(planeAnchor.center.y)
    let z = CGFloat(planeAnchor.center.z)
    planeNode.position = SCNVector3(x,y,z)
    planeNode.eulerAngles.x = -.pi / 2
    
    node.addChildNode(planeNode)
  }
  
  func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
    guard let planeAnchor = anchor as?  ARPlaneAnchor,
      let planeNode = node.childNodes.first,
      let plane = planeNode.geometry as? SCNPlane
      else { return }
    
    let width = CGFloat(planeAnchor.extent.x)
    let height = CGFloat(planeAnchor.extent.z)
    plane.width = width
    plane.height = height
    
    let x = CGFloat(planeAnchor.center.x)
    let y = CGFloat(planeAnchor.center.y)
    let z = CGFloat(planeAnchor.center.z)
    planeNode.position = SCNVector3(x, y, z)
  }
  
  @objc func addNodeToPlane() {
    let origin = CGPoint(x: self.arView.frame.width / 2, y: self.arView.frame.height / 2)
    let result = arView.hitTest(origin, types: .existingPlaneUsingExtent)
    guard let xPos = result.first?.worldTransform.columns.3.x else { return }
    guard let yPos = result.first?.worldTransform.columns.3.y else { return }
    guard let zPos = result.first?.worldTransform.columns.3.z else { return }
    self.boxPickCount = 0
    loadAnimations(x: xPos, y: yPos, z: zPos)
  }
  
  
  @objc func addNodeViaManager(_ node:NSNumber) {
    DispatchQueue.main.async {
      self.addNodeToPlane()
    }
  }
  
  @objc func incrementBoxPickerViaManager(_ node:NSNumber) {
    DispatchQueue.main.async {
      self.boxPickCount = self.boxPickCount + 1
    }
  }
  
}
