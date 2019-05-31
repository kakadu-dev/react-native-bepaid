import ASN1 from './asn1/ASN1'
import Base64 from './asn1/Base64'
import Hex from './asn1/Hex'
import hex2b64 from './jsbn/base64'
import {
	parseBigInt,
	RSAKey,
} from './jsbn/OneFile'

RSAKey.prototype.parseKey = function(pem) {
	var modulus
	var publicExponent
	var reHex
	var der
	var asn1
	var bitString
	var sequence

	try {
		modulus        = 0
		publicExponent = 0
		reHex          = /^\s*(?:[0-9A-Fa-f][0-9A-Fa-f]\s*)+$/
		der            = reHex.test(pem) ? Hex.decode(pem) : Base64.prototype.unarmorCSE(pem)
		asn1           = ASN1.decode(der)

		if (asn1.sub.length === 2) {

			// Parse the public key.
			bitString = asn1.sub[1]
			sequence  = bitString.sub[0]

			modulus = sequence.sub[0].getHexStringValue()
			this.n  = parseBigInt(modulus, 16)

			publicExponent = sequence.sub[1].getHexStringValue()
			this.e         = parseInt(publicExponent, 16)
		} else {
			return false
		}
		return true
	} catch (ex) {
		return false
	}
}

var BeGatewayCSE = function(options) {
	this.key     = options.publicKey ? options.publicKey : options
	this.version = options.version || '1_0_0'

	RSAKey.call(this)
	var parseResult = RSAKey.prototype.parseKey(this.key)

	if (!parseResult) {
		throw new Error('BeGatewayCSE: Error parse public key.')
	}
}

function encryptValue(value, version)
{
	var encryptedData = hex2b64(RSAKey.prototype.encrypt(value))
	return '$begatewaycsejs_' + version + '$' + encryptedData
}

BeGatewayCSE.prototype.encrypt = function(cardNumber, cardExp, cardCvv, cartHolder) {
	var exp = cardExp.split('/')
	var year

	// Check year length and fix if needed
	if (exp[1].length === 2) {
		year = (new Date()).getFullYear().toString().slice(0, 2) + exp[1]
	}

	return {
		encryptedNumber:       encryptValue(cardNumber, this.version),
		cardNumberLast4:       cardNumber.toString().slice(-4),
		encryptedCardExpMonth: encryptValue(exp[0], this.version),
		encryptedCardExpYear:  encryptValue(year, this.version),
		encryptedCvv:          encryptValue(cardCvv, this.version),
		encryptedHolder:       encryptValue(cartHolder, this.version),
	}
}

export default BeGatewayCSE
