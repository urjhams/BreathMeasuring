//
//  ContentView.swift
//  BreathMeasuring
//
//  Created by Quân Đinh on 21.06.23.
//

import SwiftUI
import BreathObsever

struct ContentView: View {
  
  // breath observer
  @ObservedObject private var breathObserver = BreathObsever()
  
  // timer
  let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
  
  @State var buttonTitle = "Start monitoring"
  
  @State var isTrackingBreath = false
  
  var body: some View {
    VStack {
      Button(buttonTitle) {
        isTrackingBreath.toggle()
        if isTrackingBreath {
          buttonTitle = "Stop monitoring"
          breathObserver.stopTrackAudioSignal()
        } else {
          buttonTitle = "Start monitoring"
          breathObserver.startTrackAudioSignal()
        }
      }
      .onReceive(timer) { _ in
        guard isTrackingBreath else {
          return
        }
        let value = breathObserver.trackAudioSignal()
        print("🙆🏻🙆🏻🙆🏻 \(value)")
      }
    }
    .padding()
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
