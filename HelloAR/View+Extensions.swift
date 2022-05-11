//
//  View+Extensions.swift
//  HelloAR
//
//  Created by Leonardo Fernandes on 06/05/22.
//

import SwiftUI

extension View {
  @ViewBuilder func hidden(_ shouldHide: Bool) -> some View {
    switch shouldHide {
    case true: self.hidden()
    case false: self
    }
  }
}
