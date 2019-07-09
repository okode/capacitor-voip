declare module "@capacitor/core" {
  interface PluginRegistry {
    Voip: VoipPlugin;
  }
}

export interface VoipPlugin {
  echo(options: { value: string }): Promise<{value: string}>;
}
