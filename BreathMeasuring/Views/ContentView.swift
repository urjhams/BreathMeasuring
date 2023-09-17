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
  
  @State var running = false

  // breath observer
  private var observer = BreathObsever()
  
  var body: some View {
    VStack {
      HStack {
        Button {
          if running {
            observer.stopProcess()
            running.toggle()
          } else {
            do {
              try observer.startProcess()
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
      Publishers.CombineLatest(observer.soundAnalysisSubject, observer.powerSubject)
    ) { breathing, power in
      // TODO: handle the combine value of sound classfy result and fft result
      Task { @MainActor in
        // breathing is in around between -85 to -60 (~64 when almost snooring, breathing loud)
        print("🎉 power: \(Int(power)) db - breath: \(breathing.confidence)%")
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
