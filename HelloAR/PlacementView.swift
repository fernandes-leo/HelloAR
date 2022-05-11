//
//  PlacementView.swift
//  HelloAR
//
//  Created by Leonardo Fernandes on 06/05/22.
//

import SwiftUI

struct PlacementView: View {
  @EnvironmentObject var placementSettings: PlacementSettings

  var body: some View {
    HStack {

      Spacer()

      PlacementButton(systemIconName: "xmark.circle.fill") {
        print("botao cancelar ativado")
        self.placementSettings.selectedModel = nil
      }

      Spacer()

      PlacementButton(systemIconName: "checkmark.circle.fill") {
        print("botao confirmar apertado")
        self.placementSettings.confirmedModel = self.placementSettings.selectedModel

        self.placementSettings.selectedModel = nil
      }
      Spacer()
    }
    .padding(.bottom, 30)
  }
}

struct PlacementButton: View {
  let systemIconName: String
  let action: () -> Void

  var body: some View {

    Button(action: {
      self.action()
    }) {
      Image(systemName: systemIconName)
        .font(.system(size: 50, weight: .light, design: .default))
        .foregroundColor(.white)
        .buttonStyle(PlainButtonStyle())
    }
    .frame(width: 75, height: 75)
  }
}
