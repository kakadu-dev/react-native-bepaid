import { NativeModules } from 'react-native';
import BeGatewayCSE from './begateway/BegatewayEncrypt'

const RNBepaidModule = NativeModules.RNBepaid;

export default class RNBepaid
{
    static async createEncryptedFields(cardNumber, cardExp, cardCvv, cartHolder, publicKey)
    {
        try {
            const begateway = new BeGatewayCSE(publicKey)

            return begateway.encrypt(cardNumber, cardExp, cardCvv, cartHolder)
        } catch (error) {
            return createError(error);
        }
    }

    static async show3DS(url)
    {
        try {
            return await RNBepaidModule.show3DS(url);
        } catch (error) {
            return createError(error);
        }
    }
}

class RNBepaidError extends Error
{
    constructor(details)
    {
        super();

        this.name    = 'RNBepaidError';
        this.message = typeof details === 'string' ? details : details.message;
    }
}

function createError(error)
{
    return new RNBepaidError(error);
}
