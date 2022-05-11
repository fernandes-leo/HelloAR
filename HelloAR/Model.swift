//
//  Model.swift
//  HelloAR
//
//  Created by Leonardo Fernandes on 05/05/22.
//

import SwiftUI
import RealityKit
import Combine

enum ModelCategory: CaseIterable {
  case table
  case chair
  case decor
  case light

  var label: String {
    get {
      switch self {
      case .table:
          return "Diversos"
      case .chair:
        return "Pessoas"
      case .decor:
        return "Veiculos"
      case .light:
        return "Móveis"
      }
    }
  }
}


class Model {
  var name: String
  var category: ModelCategory
  var thumbnail: UIImage
  var modelEntity: ModelEntity?
  var scaleCompensation: Float

  private var cancellable: AnyCancellable?

  init(name: String, category: ModelCategory, scaleCompensation: Float = 1.0) {
    self.name = name
    self.category = category
    self.thumbnail = UIImage(named: name) ?? UIImage(systemName: "photo")!
    self.scaleCompensation = scaleCompensation
  }

  func asyncLoadModelEntity() {
    let filename = self.name + ".usdz"

    self.cancellable = ModelEntity.loadModelAsync(named: filename)
      .sink(receiveCompletion: {loadCompletion in

        switch loadCompletion {
        case.failure(let error): print ("Unable to load modelEntity for \(filename). Error: \(error.localizedDescription)")
        case .finished:
          break
        }

      }, receiveValue: {modelEntity in

        self.modelEntity = modelEntity
        self.modelEntity?.scale *= self.scaleCompensation

        print("modelEntity for \(self.name) has been loaded.")

      })
  }

}

struct Models {
  var all: [Model] = []

  init() {
    //
    let papel = Model(name: "papelHigi", category: .table, scaleCompensation: 1/100)
    let mcdonald = Model(name: "mcdonald", category: .table, scaleCompensation: 40/100)
    let tv = Model(name: "tv", category: .table, scaleCompensation: 25/100)
    let coca = Model(name: "coca", category: .table, scaleCompensation: 45/100)
    self.all += [papel, mcdonald, tv, coca]


    //
    let mulher1 = Model(name: "mulher1", category: .chair, scaleCompensation: 7000/10000)
    self.all += [mulher1]

    //

    let carro = Model(name: "carro", category: .decor, scaleCompensation: 650/1000)
    let mercedes = Model(name: "mercedes", category: .decor, scaleCompensation: 650/1000)
    self.all += [carro, mercedes]

    //

    let chair = Model(name: "chair", category: .light, scaleCompensation: 500/1000)
    let chair2 = Model(name: "chair2", category: .light, scaleCompensation: 380/1000)
    self.all += [chair, chair2]


  }

  func get(category: ModelCategory) -> [Model] {
    return all.filter({$0.category == category})

  }
}
