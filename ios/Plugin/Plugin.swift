import Foundation
import Capacitor
import PushKit

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitor.ionicframework.com/docs/plugins/ios
 */
@objc(Voip)
public class Voip: CAPPlugin {
    
    private static let UpdatePushCredentialsNotificationName = "updatePushKitCredentialsNotification"
    private static let InvalidatePushCredentialsNotificationName = "invalidatePushKitCredentialsNotification"
    private static let IncomingPushNotificationName = "incomingPushKitPushNotification"

    override public func load() {
        super.load()
        NotificationCenter.default.addObserver(self, selector: #selector(self.pushRegistryUpdateCredentials(notification:)), name: Notification.Name(Voip.UpdatePushCredentialsNotificationName), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.pushRegistryInvalidCredentials(notification:)), name: Notification.Name(Voip.InvalidatePushCredentialsNotificationName), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.pushRegistryIncomingPush(notification:)), name: Notification.Name(Voip.IncomingPushNotificationName), object: nil)
    }
    
    @objc func echo(_ call: CAPPluginCall) {
        let value = call.getString("value") ?? ""
        call.success([
            "value": value
        ])
    }
    
    @objc public static func registerForVOIPNotifications(delegate: PKPushRegistryDelegate?) {
        let voipRegistry = PKPushRegistry(queue: DispatchQueue.main)
        voipRegistry.delegate = delegate
        voipRegistry.desiredPushTypes = [PKPushType.voIP]
    }

    @objc public func pushRegistryUpdateCredentials(notification: NSNotification){
        guard let deviceToken = notification.object as? String else {
          return
        }
        self.notifyListeners("registration", data: [
            "token": deviceToken
        ], retainUntilConsumed: true)
    }
    
    @objc public func pushRegistryInvalidCredentials(notification: NSNotification) {
        print("Voip Plugin - Error registering device");
        self.notifyListeners("registrationError", data: [:], retainUntilConsumed: true)
    }
    
    @objc public func pushRegistryIncomingPush(notification: NSNotification) {
        guard let payload = notification.object as? [AnyHashable : Any] else {
          return
        }
        self.notifyListeners("pushNotificationReceived", data: [
            "data": payload
        ], retainUntilConsumed: true)
    }
    
    @objc public static func handlePushRegistry(_ registry: PKPushRegistry, didUpdate pushCredentials: PKPushCredentials, for type: PKPushType) {
        if (pushCredentials.token.count == 0) {
            print("Voip Plugin - No device token");
            return;
        }
        print("Voip Plugin - Device registered successfully");
        let token = pushCredentials.token.map { String(format: "%.2hhx", $0) }.joined()
        NotificationCenter.default.post(name: Notification.Name(Voip.UpdatePushCredentialsNotificationName), object: token)
    }
    
    @objc public static func handlePushRegistry(_ registry: PKPushRegistry, didInvalidatePushTokenFor type: PKPushType) {
        print("Voip Plugin - Error registering device");
        NotificationCenter.default.post(name: Notification.Name(Voip.InvalidatePushCredentialsNotificationName), object: nil)
    }
    
    @objc public static func handlePushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType) {
        print("Voip Plugin - VOIP notification received");
        NotificationCenter.default.post(name: Notification.Name(Voip.IncomingPushNotificationName), object: payload.dictionaryPayload)
    }
        
}
