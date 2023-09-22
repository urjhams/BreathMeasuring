//
//  ContentView.swift
//  ECG Watch App
//
//  Created by Quân Đinh on 22.09.23.
//

import SwiftUI
import HeartRateObserver

enum InterfaceState {
  case measuring
  case disable
}

struct ContentView: View {
  
  var observer = HeartRateObserver()
  
  @State var state: InterfaceState = .disable
  
  var body: some View {
    VStack {
      Image(systemName: state == .measuring ? "heart.fill" : "suit.geart")
        .imageScale(.large)
        .foregroundStyle(state == .measuring ? .red : .gray)
    }
    .onReceive(observer.observedSubject) { heartRate in
      guard let heartRate else {
        state = .disable
        return
      }
      state = .measuring
      
      // TODO: send the heartRate to iOS app
    }
    // TODO: recieve message from iOS app to start or stop the observing
    .padding()
  }
}

#Preview {
  ContentView()
}
