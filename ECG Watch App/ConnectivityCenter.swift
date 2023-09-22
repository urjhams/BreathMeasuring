import Combine
import HeartRateObserver
import WatchConnectivity

final class ConnectivityCenter: NSObject, WCSessionDelegate {
  
  let session = WCSession.default
  
  public let messageSubject = PassthroughSubject<HeartRateObservingCommand, Never>()
  
  override init() {
    super.init()
    session.delegate = self
    session.activate()
  }
}

extension ConnectivityCenter {
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
