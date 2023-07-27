//
//  ContentView.swift
//  BreathMeasuring
//
//  Created by Quân Đinh on 21.06.23.
//

import SwiftUI
import BreathObsever
import Combine

struct ContentView: View {
  
  @State var timer = Timer
    .publish(every: 0.05, on: .main, in: .default)
    .autoconnect()
    .eraseToAnyPublisher()
  
  @State var tracking: Bool = false
  
  // breath observer
  @ObservedObject private var breathObserver = BreathObsever()
  
  var body: some View {
    VStack {
      
      // TODO: maybe we could use a threshold to decice is that sounds still in breathing sound range (like under 200)
      LineChartView(
        timer: timer,
        latestData: $breathObserver.convertedPowerLevel,
        dataRange: 1000,
        tracking: $tracking
      )
      .frame(height: 400)
      
      // TODO: button will start a session
      // https://developer.apple.com/documentation/charts/creating-a-chart-using-swift-charts
      Button(breathObserver.isTracking ? "Stop monitoring" : "Start monitoring") {
        guard breathObserver.hasTimer else {
          return
        }
        breathObserver.isTracking.toggle()
        tracking = breathObserver.isTracking
      }
      
      // TODO: implement something relate to applw watch
      // TODO: combine with cognitive load result from BreathObserver
      // TODO: add the 2 results above to the session (as CSV(?)) and store on Firebase.
    }
    .padding()
    .onAppear {
      try? breathObserver.assignTimer(timer: timer)
    }
    
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
