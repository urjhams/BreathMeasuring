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
  
  let observer = HeartRateObserver()
  
  let connectivity = ConnectivityCenter()
  
  @State var state: InterfaceState = .disable
  
  var body: some View {
    VStack {
      Image(systemName: state == .measuring ? "heart.fill" : "suit.heart")
        .imageScale(.large)
        .foregroundStyle(state == .measuring ? .red : .gray)
    }
    .onReceive(observer.observedSubject) { heartRate in
      guard let heartRate else {
        state = .disable
        return
      }
      state = .measuring
      
      // send the heartRate to iOS app
      connectivity.sendData(heartRate)
    }
    .onReceive(connectivity.messageSubject) { message in
      switch message {
      case .start:
        observer.start()
      case .stop:
        observer.stop()
      }
    }
    .padding()
  }
}

#Preview {
  ContentView()
}
