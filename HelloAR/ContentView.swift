//
//  ContentView.swift
//  HelloAR
//
//  Created by Leonardo Fernandes on 05/05/22.
//

import SwiftUI
import RealityKit

struct ContentView: View {
  @EnvironmentObject var placementSettings: PlacementSettings
  @State private var isControlsVisible: Bool = true
  @State private var showBrowse: Bool = false
  @State private var showSettings: Bool = false

  var body: some View {
    ZStack(alignment: .bottom) {

      ARViewContainer()

      if self.placementSettings.selectedModel == nil {
        ControlView(isControlsVisible: $isControlsVisible, showBrowse: $showBrowse, showSettings: $showSettings)
      } else {
        PlacementView()
      }
    }
    .edgesIgnoringSafeArea(.all)
  }
}


struct ARViewContainer: UIViewRepresentable {
  @EnvironmentObject var placementSetting: PlacementSettings
  @EnvironmentObject var sessionSettings: SessionSettings

  func makeUIView(context: Context) -> CustomARView {

    let arView = CustomARView(frame: .zero, sessionSettings: sessionSettings) 

    self.placementSetting.sceneObserver = arView.scene.subscribe(to:
       SceneEvents.Update.self, { (event) in

      self.updateScene(for: arView)

        })

    return arView
  }

  func updateUIView(_ uiView: CustomARView, context: Context) {}

  private func updateScene(for arView: CustomARView) {

    arView.focusEntity?.isEnabled = self.placementSetting.selectedModel != nil

    if let confirmedModel = self.placementSetting.confirmedModel, let modelEntity = confirmedModel.modelEntity {

      self.place(modelEntity, in: arView)

      self.placementSetting.confirmedModel = nil
    }
  }

  private func place (_ modelEntity: ModelEntity, in arView: ARView) {

    let clonedEntity = modelEntity.clone(recursive: true)

    clonedEntity.generateCollisionShapes(recursive: true)
    arView.installGestures([.translation, .rotation], for: clonedEntity)

    let anchorEntity = AnchorEntity(plane: .any)
    anchorEntity.addChild(clonedEntity)

    arView.scene.addAnchor(anchorEntity)

    print("added modelEntity")
  }
}


struct ContentView_Previews:
  PreviewProvider {
    static var previews: some View {
      ContentView()
        .environmentObject(PlacementSettings())
        .environmentObject(SessionSettings())
    }
  }
