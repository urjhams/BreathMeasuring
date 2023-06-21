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
  
  @State var isTrackingBreath = false {
    didSet {
      if isTrackingBreath {
        buttonTitle = "Stop monitoring"
        breathObserver.startTrackAudioSignal()
      } else {
        buttonTitle = "Start monitoring"
        breathObserver.stopTrackAudioSignal()
      }
    }
  }
  
  var body: some View {
    VStack {
      // TODO: add the live graph based on the value from breath Observer
      // https://developer.apple.com/documentation/charts/creating-a-chart-using-swift-charts
      Button(buttonTitle) {
        isTrackingBreath.toggle()
      }
      .onReceive(timer) { _ in
        guard isTrackingBreath else {
          return
        }
        do {
          let value = try breathObserver.trackAudioSignal()
          print("🙆🏻🙆🏻🙆🏻 \(value)")
        } catch {
          print("error: \(error.localizedDescription)")
        }
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
