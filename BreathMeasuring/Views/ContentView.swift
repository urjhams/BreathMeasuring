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
  
  var body: some View {
    VStack {
      HStack {
        Button {
          if running {
            //TODO: stop process
            running = false
          } else {
            // TODO: start process
            running = true
          }
        } label: {
          Image(systemName: running ? "square.fill" : "play.fill")
            .font(.largeTitle)
            .foregroundColor(.accentColor)
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
