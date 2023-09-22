import HealthKit
import Combine
import SwiftUI

public final class ECGReader: NSObject, ObservableObject {
  
  @Published public var isAvailable = false
  
  @Published public var value = 0
  
  let bpm = HKUnit(from: "count/min")
  
  var healthStore: HKHealthStore?
  
  public override init() {
    super.init()
    authorize()
  }
}

extension ECGReader {
  private func authorize() {
    
    guard HKHealthStore.isHealthDataAvailable() else {
      return
    }
    
    let newHealthStore = HKHealthStore()
    healthStore = newHealthStore
    
    guard 
      let desiredType = [HKObjectType.quantityType(forIdentifier: .heartRate)] as? Set<HKSampleType>
    else {
      return
    }
    
    isAvailable = true
    
    // request authorization to access heart rate data
    newHealthStore
      .requestAuthorization(toShare: desiredType, read: desiredType) { [weak self] success, error in
        guard success, error == nil else {
          self?.isAvailable = false
          return
        }
      }
  }
}
