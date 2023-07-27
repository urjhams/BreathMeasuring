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
      // TODO: button will start a session
      // https://developer.apple.com/documentation/charts/creating-a-chart-using-swift-charts
      Button(breathObserver.isTracking ? "Stop monitoring" : "Start monitoring") {
        breathObserver.isTracking.toggle()
      }
      .onReceive(breathObserver.$convertedPowerLevel) { powerLevel in
        // TODO: need audio processing (?)
        print("🙆🏻🙆🏻🙆🏻 \(powerLevel)")
      }
      
      // TODO: implement something relate to applw watch
      // TODO: combine with cognitive load result from BreathObserver
      // TODO: add the 2 results above to the session (as CSV(?)) and store on Firebase.
    }
    .padding()
    
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
