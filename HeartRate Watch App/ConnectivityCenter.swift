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
  public func sendData(_ heartRate: HeartRate) {
    guard session.isReachable, let data = heartRate.data else {
      return
    }
    
    session.sendMessageData(data, replyHandler: nil)
  }
}

extension ConnectivityCenter: WCSessionDelegate {
  func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
    typealias Command = HeartRateObservingCommand
    guard
      let command = message[Command.messageIdentifier] as? String,
        let command = Command(rawValue: command)
    else {
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
