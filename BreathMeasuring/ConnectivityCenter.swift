import Combine
import HeartRateObserver
import WatchConnectivity

final class ConnectivityCenter: NSObject {
  
  let session = WCSession.default
  
  public let messageSubject = PassthroughSubject<HeartRate, Never>()
  
  override init() {
    super.init()
    session.delegate = self
    session.activate()
  }
}

extension ConnectivityCenter {
  public func sendMessage(_ command: HeartRateObservingCommand) {
    guard session.isReachable else {
      return
    }
    
    let data = [HeartRateObservingCommand.messageIdentifier : command.value as Any]
    session.sendMessage(data, replyHandler: nil)
  }
}

extension ConnectivityCenter: WCSessionDelegate {
  func sessionDidBecomeInactive(_ session: WCSession) {
    
  }
  
  func sessionDidDeactivate(_ session: WCSession) {
    
  }
  
  func session(_ session: WCSession, didReceiveMessageData messageData: Data) {
    guard let heartRate = try? JSONDecoder().decode(HeartRate.self, from: messageData) else {
      return
    }
    Task { @MainActor [weak self] in
      self?.messageSubject.send(heartRate)
    }
  }
  
  func session(
    _ session: WCSession,
    activationDidCompleteWith activationState: WCSessionActivationState,
    error: Error?
  ) { }
}
