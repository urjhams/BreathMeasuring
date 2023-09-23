//
//  ContentView.swift
//  BreathMeasuring
//
//  Created by Quân Đinh on 21.06.23.
//

import SwiftUI
import BreathObsever
import Combine
import CombineExt

struct ContentView: View {
  
  @State var running = false
  
  // breath observer
  let observer = BreathObsever()
  
  // watch connectivity
  let connectivity = ConnectivityCenter()
  
  var body: some View {
    VStack {
      HStack {
        Button {
          if running {
            observer.stopProcess()
            connectivity.sendMessage(.stop)
            running.toggle()
          } else {
            do {
              try observer.startProcess()
              connectivity.sendMessage(.start)
              running = true
            } catch {
              running = false
            }
          }
        } label: {
          Image(systemName: running ? "square.fill" : "play.fill")
            .font(.largeTitle)
            .foregroundColor(.accentColor)
        }
      }
    }
    .onReceive(
      observer.powerSubject.withLatestFrom(
        observer.soundAnalysisSubject,
        connectivity.messageSubject,
        resultSelector: {
          ($0, $1.0, $1.1)
        }
      )
    ) { (power, breathing, heartRate) in
      guard !power.isNaN, !power.isInfinite else {
        return
      }
      // TODO: handle the combine value of sound classfy result and fft result
      Task { @MainActor in
        // breathing is in around between -85 to -60 (~64 when almost snooring, breathing loud)
        print("🎉 power: \(Int(power)) db - breath: \(breathing.confidence)% - heart rate: \(heartRate.int)")
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
