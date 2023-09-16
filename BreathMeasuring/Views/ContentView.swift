//
//  ContentView.swift
//  BreathMeasuring
//
//  Created by Quân Đinh on 21.06.23.
//

import SwiftUI
import BreathObsever

struct ContentView: View {
  
  @State var running = false

  // breath observer
  private var breathObserver = BreathObsever()
  
  var body: some View {
    VStack {
      
      
      Button(running ? "Stop" : "Start") {
        running.toggle()
        running ? breathObserver.startProcess() : breathObserver.stopProcess()
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
