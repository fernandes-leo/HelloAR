//
//  SettingsView.swift
//  HelloAR
//
//  Created by Leonardo Fernandes on 06/05/22.
//

import SwiftUI
import RealityKit

enum Setting {
  case peopleOcclusion
  case objetcOcclusion
  case lidarDebug
  case multiuser

  var label: String {
    get {
      switch self {
      case .peopleOcclusion, .objetcOcclusion:
        return "Occlusion"
      case .lidarDebug:
        return "LiDAR"
      case .multiuser:
        return "Multiuser"
      }
    }
  }

  var systemIconName: String {
    get {
      switch self {
      case .peopleOcclusion:
        return "person"
      case .objetcOcclusion:
        return "cube.box.fill"
      case .lidarDebug:
        return "light.min"
      case .multiuser:
        return "person.2"
      }
    }
  }
}

struct SettingsView: View{
  @Binding var showSettings: Bool

  var body: some View {
    NavigationView{
      SettingsGrid()
        .navigationBarTitle(Text("Configurações"), displayMode: .inline)
        .navigationBarItems(trailing:
          Button(action: {
          self.showSettings.toggle()
        }) {
          Text("Feito").bold()
        })
    }
  }
}

struct SettingsGrid: View {
  @EnvironmentObject var sessionSettings: SessionSettings

  private var gridItemLayout = [GridItem(.adaptive(minimum: 100, maximum: 100), spacing: 25)]

  var body: some View {
    ScrollView {

      LazyVGrid(columns: gridItemLayout,spacing: 25) {

        SettingToggleButton(setting: .peopleOcclusion, isOn: $sessionSettings.isPeopleOcclusionEnabled)

        SettingToggleButton(setting: .objetcOcclusion, isOn: $sessionSettings.isObjectOcclusionEnabled)

        SettingToggleButton(setting: .lidarDebug, isOn: $sessionSettings.isLidarDebugEnable)

        SettingToggleButton(setting: .multiuser, isOn: $sessionSettings.isMultiuserEnable)
      }
    }
    .padding(.top, 35)
  }
}

struct SettingToggleButton: View {
  let setting: Setting
  @Binding var isOn: Bool

  var body: some View {
    Button(action: {
      self.isOn.toggle()
      print("\(#file) - \(setting): \(self.isOn)")
    }) {
      VStack {

        Image(systemName: setting.systemIconName)
          .font(.system(size:35))
          .foregroundColor(self.isOn ? .green : Color(UIColor.secondaryLabel))
          .buttonStyle(PlainButtonStyle())

        Text(setting.label)
          .font(.system(size:17, weight: .medium, design: .default))
          .foregroundColor(self.isOn ? Color(UIColor.label) : Color(UIColor.secondaryLabel))
          .padding(.top, 5)
      }
    }
    .frame(width: 100, height: 100)
    .background(Color(UIColor.secondarySystemFill))
    .cornerRadius(8.0)
  }
}
