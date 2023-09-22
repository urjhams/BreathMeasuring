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
    isAvailable = authorize()
  }
}

extension ECGReader {
  private func authorize() -> Bool {
    
    guard HKHealthStore.isHealthDataAvailable() else {
      return false
    }
    
    let newHealthStore = HKHealthStore()
    healthStore = newHealthStore
    
    guard 
      let desiredType = [HKObjectType.quantityType(forIdentifier: .heartRate)] as? Set<HKSampleType>
    else {
      return false
    }
    
    newHealthStore.getRequestStatusForAuthorization(
      toShare: desiredType,
      read: desiredType
    ) { [weak self] _, error in
      guard error == nil else {
        self?.isAvailable = false
        return
      }
    }
    
    return true
  }
}
