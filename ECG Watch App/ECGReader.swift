import HealthKit
import Combine
import SwiftUI

public final class ECGReader: NSObject, ObservableObject {
  
  @Published public var isAvailable = false
  
  @Published public var value = 0.0
  
  private var healthStore: HKHealthStore?
  
  public override init() {

  }
}

extension ECGReader {
  public func start() {
    
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
    
    // process the queries
    process()
  }
  
  public func stop() {
    healthStore = nil
  }
}

extension ECGReader {
  
  private func process() {
    // Set up the predicate source from current device (Apple watch)
    let device = HKDevice.local()
    let predicate = HKQuery.predicateForObjects(from: [device])
    
    guard let sampleType = HKObjectType.quantityType(forIdentifier: .heartRate) else {
      isAvailable = false
      return
    }
    
    let query = HKAnchoredObjectQuery(
      type: sampleType,
      predicate: predicate,
      anchor: nil,
      limit: HKObjectQueryNoLimit
    ) { query, samples, deletedObjects, anchor, error in
      samples?.forEach { [weak self] sample in
        guard let sample = sample as? HKQuantitySample else {
          return
        }
        let hearRateQuantity = HKUnit(from: "count/min")
        self?.value = sample.quantity.doubleValue(for: hearRateQuantity)
      }
    }
    
    healthStore?.execute(query)
  }
  
}
