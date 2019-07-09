import { WebPlugin } from '@capacitor/core';
import { VoipPlugin } from './definitions';

export class VoipWeb extends WebPlugin implements VoipPlugin {
  constructor() {
    super({
      name: 'Voip',
      platforms: ['web']
    });
  }

  async echo(options: { value: string }): Promise<{value: string}> {
    console.log('ECHO', options);
    return options;
  }
}

const Voip = new VoipWeb();

export { Voip };

import { registerWebPlugin } from '@capacitor/core';
registerWebPlugin(Voip);
