import { PluginListenerHandle } from "@capacitor/core";

export interface RegistrationToken {
  token: string;
}
export interface VoipNotification {
  data: any;
}
declare module "@capacitor/core" {
  interface PluginRegistry {
    Voip: VoipPlugin;
  }
}

export interface VoipPlugin {
  echo(options: { value: string }): Promise<{value: string}>;
  addListener(eventName: 'registration', listenerFunc: (res: RegistrationToken) => void): PluginListenerHandle;
  addListener(eventName: 'registrationError', listenerFunc: () => void): PluginListenerHandle;
  addListener(eventName: 'pushNotificationReceived', listenerFunc: (notification: VoipNotification) => void): PluginListenerHandle;
}
