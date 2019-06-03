import { NativeModules } from 'react-native';
import BeGatewayCSE from './begateway/BegatewayEncrypt'

const RNBepaidModule = NativeModules.RNBepaid;

export default class RNBepaid
{
    static endUrl = 'https://bepaid.by'

    static async createEncryptedFields(cardNumber, cardExp, cardCvv, cardHolder, publicKey)
    {
        try {
            const begateway = new BeGatewayCSE(publicKey)

            return begateway.encrypt(cardNumber, cardExp, cardCvv, cardHolder)
        } catch (error) {
            return createError(error);
        }
    }

    static async show3DS(url, redirectUrl)
    {
        try {
            return await RNBepaidModule.show3DS(url, redirectUrl || RNBepaid.endUrl);
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
