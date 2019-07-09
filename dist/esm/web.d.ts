import { WebPlugin } from '@capacitor/core';
import { VoipPlugin } from './definitions';
export declare class VoipWeb extends WebPlugin implements VoipPlugin {
    constructor();
    echo(options: {
        value: string;
    }): Promise<{
        value: string;
    }>;
}
declare const Voip: VoipWeb;
export { Voip };
