import Combine
import HeartRateObserver
import WatchConnectivity

final class ConnectivityCenter: NSObject {
  
  let session = WCSession.default
  
  public let messageSubject = PassthroughSubject<HeartRateObservingCommand, Never>()
  
  override init() {
    super.init()
    session.delegate = self
    session.activate()
  }
}

extension ConnectivityCenter {
  public func sendMessage(_ heartRate: HeartRate) {
    guard session.isReachable else {
      return
    }
    
    let data = [HeartRate.messageIdentifier : heartRate as Any]
    session.sendMessage(data, replyHandler: nil)
  }
}

extension ConnectivityCenter: WCSessionDelegate {
  func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
    typealias Command = HeartRateObservingCommand
    guard let command = message[Command.messageIdentifier] as? Command else {
      return
    }
    messageSubject.send(command)
  }
  
  func session(
    _ session: WCSession,
    activationDidCompleteWith activationState: WCSessionActivationState,
    error: Error?
  ) { }
}
