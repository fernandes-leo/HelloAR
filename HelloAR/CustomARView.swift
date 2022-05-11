//
//  CustomARView.swift
//  HelloAR
//
//  Created by Leonardo Fernandes on 06/05/22.
//

import RealityKit
import ARKit
import FocusEntity
import SwiftUI
import Combine

class CustomARView: ARView {

  var focusEntity: FocusEntity?
  var sessionSettings: SessionSettings


  private var peopleOcclusionCancellable: AnyCancellable?
  private var objectOcclusionCancellable: AnyCancellable?
  private var lidarDebugCancellable: AnyCancellable?
  private var multiuserCancellable: AnyCancellable?

  required init(frame frameRect: CGRect, sessionSettings: SessionSettings) {
    self.sessionSettings = sessionSettings

    super.init(frame: frameRect)

    focusEntity = FocusEntity(on: self, focus: .classic)

    configure()

    self.setupSubscribers()

    self.setupSubscribers()
  }

  required init(frame frameRect: CGRect) {
    fatalError("init(frame:) has not been implemented")
  }

  @objc required dynamic init?(coder decoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func configure() {
    let config = ARWorldTrackingConfiguration()
    config.planeDetection = [.horizontal, .vertical]

    if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh) {
      config.sceneReconstruction = .mesh
    }

    session.run(config)
    
  }

  private func initializeSettings() {
    self.updatePeopleOcclusion(isEnabled: sessionSettings.isPeopleOcclusionEnabled)
    self.updateObjectOcclusion(isEnabled: sessionSettings.isObjectOcclusionEnabled)
    self.updateLidarDebug(isEnabled: sessionSettings.isLidarDebugEnable)
    self.updateMultiuser(isEnabled: sessionSettings.isMultiuserEnable)
  }

  private func setupSubscribers() {
    self.peopleOcclusionCancellable = sessionSettings.$isPeopleOcclusionEnabled.sink { [weak self] isEnabled in
      self?.updatePeopleOcclusion(isEnabled: isEnabled)
    }
    self.objectOcclusionCancellable = sessionSettings.$isObjectOcclusionEnabled.sink { [weak self] isEnabled in
      self?.updateObjectOcclusion(isEnabled: isEnabled)
    }
    self.lidarDebugCancellable = sessionSettings.$isLidarDebugEnable.sink { [weak self] isEnabled in
      self?.updateLidarDebug(isEnabled: isEnabled)
    }
    self.multiuserCancellable = sessionSettings.$isMultiuserEnable.sink { [weak self] isEnabled in
      self?.updateMultiuser(isEnabled: isEnabled)
    }
  }

  private func updatePeopleOcclusion(isEnabled: Bool) {
    print("\(#file): isPeopleOcclusionEnabled is now \(isEnabled)")

    guard ARWorldTrackingConfiguration.supportsFrameSemantics(.personSegmentationWithDepth) else {
      return
    }

    guard let configuration = self.session.configuration as? ARWorldTrackingConfiguration else {
      return
    }

    if configuration.frameSemantics.contains(.personSegmentationWithDepth) {
      configuration.frameSemantics.remove(.personSegmentationWithDepth)
    } else {
      configuration.frameSemantics.insert(.personSegmentationWithDepth)
    }
    self.session.run(configuration)
  }

  private func updateObjectOcclusion(isEnabled: Bool) {
    print("\(#file): isObjectOcclusionEnabled is now \(isEnabled)")

    if self.environment.sceneUnderstanding.options.contains(.occlusion) {
      self.environment.sceneUnderstanding.options.remove(.occlusion)
    } else {
      self.environment.sceneUnderstanding.options.insert(.occlusion)
    }
  }

  private func updateLidarDebug(isEnabled: Bool) {
    print("\(#file): isLidarDebugEnabled is now \(isEnabled)")

    if self.debugOptions.contains(.showSceneUnderstanding){
      self.debugOptions.remove(.showSceneUnderstanding)
    }else{
      self.debugOptions.insert(.showSceneUnderstanding)
    }
  }

  private func updateMultiuser(isEnabled: Bool) {
    print("\(#file): isMultiuserEnabled is now \(isEnabled)")
  }

}
