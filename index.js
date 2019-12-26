import BeGatewayCSE from './begateway/BegatewayEncrypt';

export default class RNBepaid
{
    static async createEncryptedFields(cardNumber, cardExp, cardCvv, cardHolder, publicKey)
    {
        try {
            const begateway = new BeGatewayCSE(publicKey)

            return begateway.encrypt(cardNumber, cardExp, cardCvv, cardHolder)
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
