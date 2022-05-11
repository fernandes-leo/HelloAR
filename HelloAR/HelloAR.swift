//
//  HelloAR.swift
//  HelloAR
//
//  Created by Leonardo Fernandes on 06/05/22.
//

import SwiftUI
import Firebase

@main
struct HelloAR: App {
  @StateObject var placementSettings = PlacementSettings()
  @StateObject var sessionSettings = SessionSettings()

  init() {
    FirebaseApp.configure()

    Auth.auth().signInAnonymously{authResult, error in
      guard let user = authResult?.user else {
        print("Falha: Autenticacao anonima com firebase")
        return
      }

      let uid = user.uid
      print("Falha: Autenticacao feita com o uid:\(uid). ")
    }
  }

  var body: some Scene {
    WindowGroup {
      ContentView()
        .environmentObject(placementSettings)
        .environmentObject(sessionSettings)
    }
  }
}
