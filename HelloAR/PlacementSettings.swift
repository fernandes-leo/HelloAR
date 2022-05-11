//
//  PlacementSettings.swift
//  HelloAR
//
//  Created by Leonardo Fernandes on 06/05/22.
//

import SwiftUI
import RealityKit
import Combine

class PlacementSettings: ObservableObject {


  @Published var selectedModel: Model? {
    willSet(newValue) {
      print("settings selectedModel to \(String(describing: newValue?.name))")
    }
  }

  @Published var confirmedModel: Model? {
    willSet(newValue) {
      guard let model = newValue else {
        print ("Clearing confirmedModel")
        return
      }
      print ("settings confirmedModel to \(model.name)")

      self.recentlyPlaced.append(model)
    }
  }

  @Published var recentlyPlaced: [Model] = []

  var sceneObserver: Cancellable?
}
