//
//  LineChartView.swift
//  BreathMeasuring
//
//  Created by Quân Đinh on 27.07.23.
//

import SwiftUI
import Charts

struct LineChartView: View {
  @State var data: [Int] = []
  
  var body: some View {
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    Chart(Array(data.enumerated()), id: \.0) { index, magnitude in
      LineMark(x: .value("index", String(index)) , y: .value("power", magnitude))
    }
    .onReceive(timer, perform: updateData(_:))
    .padding()
  }
  
  private func updateData(_ date: Date) {
    data.append(.random(in: 1...100000))
  }
}
