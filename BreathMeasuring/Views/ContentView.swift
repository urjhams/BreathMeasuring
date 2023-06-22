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
  
  var body: some View {
    VStack {
      // https://developer.apple.com/documentation/charts/creating-a-chart-using-swift-charts
      Button(breathObserver.isTracking ? "Stop monitoring" : "Start monitoring") {
        breathObserver.isTracking.toggle()
      }
      .onReceive(breathObserver.$convertedPowerLevel) { powerLevel in
        print("🙆🏻🙆🏻🙆🏻 \(powerLevel)")
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
