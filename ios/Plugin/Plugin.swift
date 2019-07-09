import Foundation
import Capacitor
import PushKit

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitor.ionicframework.com/docs/plugins/ios
 */
@objc(Voip)
public class Voip: CAPPlugin, PKPushRegistryDelegate {
    
    override public func load() {
        super.load()
        let voipRegistry = PKPushRegistry(queue: DispatchQueue.main)
        voipRegistry.delegate = self
        voipRegistry.desiredPushTypes = [PKPushType.voIP]
    }
    
    @objc func echo(_ call: CAPPluginCall) {
        let value = call.getString("value") ?? ""
        call.success([
            "value": value
        ])
    }
    
    // PKPushRegistryDelegate
    
    public func pushRegistry(_ registry: PKPushRegistry, didUpdate pushCredentials: PKPushCredentials, for type: PKPushType) {
        if (pushCredentials.token.count == 0) {
            print("Voip Plugin - No device token");
            return;
        }
        print("Voip Plugin - Device registered successfully");
        let token = pushCredentials.token.map { String(format: "%.2hhx", $0) }.joined()
        self.notifyListeners("registration", data: [
            "token": token
        ], retainUntilConsumed: true)
    }
    
    public func pushRegistry(_ registry: PKPushRegistry, didInvalidatePushTokenFor type: PKPushType) {
        print("Voip Plugin - Error registering device");
        self.notifyListeners("registrationError", data: [:], retainUntilConsumed: true)
    }
    
    public func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
        self.notifyListeners("pushNotificationReceived", data: [
            "data": payload.dictionaryPayload
        ])
    }
    
}
