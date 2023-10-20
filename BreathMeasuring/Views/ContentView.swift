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
  
  @State var amplitudes = [Float]()
  
  private let offSet: CGFloat = 3
    
  // breath observer
  let observer = BreathObsever()
  
  var body: some View {
    VStack {
      HStack {
        Button {
          if running {
            // stop process
            observer.stopAnalyzing()
            running = false
          } else {
            // start process
            try? observer.startAnalyzing()
            amplitudes = []
            running = true
          }
        } label: {
          Image(systemName: running ? "square.fill" : "play.fill")
            .font(.largeTitle)
            .foregroundColor(.accentColor)
        }
      }
      HStack(spacing: 1) {
        ForEach(amplitudes, id: \.self) { amplitude in
          RoundedRectangle(cornerRadius: 2)
            .frame(width: offSet, height: CGFloat(amplitude) * offSet)
            .foregroundColor(.white)
        }
      }
      .frame(height: 80 * offSet)
    }
    .onReceive(observer.amplitudeSubject) { value in
      amplitudes.append(value * 1000)
    }
    .padding()
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
