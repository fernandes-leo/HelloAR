//
//  SessionSettings.swift
//  HelloAR
//
//  Created by Leonardo Fernandes on 06/05/22.
//

import SwiftUI

class SessionSettings: ObservableObject {
  @Published var isPeopleOcclusionEnabled: Bool = false
  @Published var isObjectOcclusionEnabled: Bool = false
  @Published var isLidarDebugEnable: Bool = false
  @Published var isMultiuserEnable: Bool = false

}
