# Eris / Tendermint Transaction structure:

    "txs": [
      [
        2,
        {
          "input": {
            "address": "DFF784DB8C4B164E987F25E44A76E6201F3C4D57",
            "amount": 1,
            "sequence": 37,
            "signature": [
              1,
              "2D69CAB5DF64B9349E3DE4714F4D0768CEE8CABBA5052A37ADBAC401924DCAEA9377063DCD345813C013336D5C809F3DCD51257E4097DB0B3F9FC6D0E7CE040B"
            ],
            "pub_key": null
          },
          "address": "DA853491290DCCFB8E6BBFD85B471324381D4B54",
          "gas_limit": 1000000,
          "fee": 0,
          "data": "2F9530F70000000000000000000000000000000000000000000000000000000000892550"
        }
      ]
    ]
  },

The Signature structure is defined here https://github.com/eris-ltd/eris-db/blob/develop/txs/tx.go

	TxInput struct {
		Address   []byte           `json:"address"`   // Hash of the PubKey
		Amount    int64            `json:"amount"`    // Must not exceed account balance
		Sequence  int              `json:"sequence"`  // Must be 1 greater than the last committed TxInput
		Signature crypto.Signature `json:"signature"` // Depends on the PubKey type and the whole Tx
		PubKey    crypto.PubKey    `json:"pub_key"`   // Must not be nil, may be nil
	}

crypto.Signature is https://github.com/tendermint/go-crypto/blob/master/signature.go

Which defines

	// Types of Signature implementations
	const (
		SignatureTypeEd25519   = byte(0x01)
		SignatureTypeSecp256k1 = byte(0x02)
	)

So we can see that our above signature has 1 as the first parameter meaning its an Ed25519 signature. Which are elliptic curve signatures. Its implemented here https://github.com/tendermint/ed25519
Seems to derive from http://bench.cr.yp.to/supercop.html -> http://bench.cr.yp.to/impl-sign/ed25519.html the ref10 version. not sure where the source for this is.


See here for a list of other implementations:

http://stackoverflow.com/questions/19147619/what-implementions-of-ed25519-exist

Theres a Java Port: https://github.com/str4d/ed25519-java

And a C Version https://github.com/orlp/ed25519




Basically its using tendermint underneath

http://tendermint.com/blog/tendermint-socket-protocol/
http://tendermint.com/guide/run-your-first-tmsp-application/
http://tendermint.com/guide/launch-a-tmsp-testnet/

https://github.com/eris-ltd/eris-db.js

# Signing

Occurs here:

https://github.com/eris-ltd/eris-db/blob/develop/account/priv_account.go

Which uses the lib from tendermint @ https://github.com/tendermint/go-crypto

https://github.com/tendermint/go-crypto/blob/master/signature.go
https://github.com/tendermint/ed25519


Eris uses either : Secp256k1 or Ed25519 signatures.

https://github.com/tendermint/ed25519/blob/master/ed25519.go
http://ed25519.cr.yp.to/

https://github.com/eris-ltd/eris-db/blob/develop/account/priv_account.go

	func (pA *PrivAccount) Sign(chainID string, o Signable) crypto.Signature {
		return pA.PrivKey.Sign(SignBytes(chainID, o))
		}

The Private key sign function is here https://github.com/tendermint/go-crypto/blob/master/priv_key.go

	func (privKey PrivKeyEd25519) Sign(msg []byte) Signature {
		privKeyBytes := [64]byte(privKey)
		signatureBytes := ed25519.Sign(&privKeyBytes, msg)
		return SignatureEd25519(*signatureBytes)
	}

Which delegates to the ed25519 function @ https://github.com/tendermint/ed25519/blob/master/ed25519.go Which just has `sign` and `verify` in it. 




https://github.com/eris-ltd/eris-db/blob/develop/txs/tx.go

	func (tx *CallTx) WriteSignBytes(chainID string, w io.Writer, n *int, err *error) {
		wire.WriteTo([]byte(Fmt(`{"chain_id":%s`, jsonEscape(chainID))), w, n, err)
		wire.WriteTo([]byte(Fmt(`,"tx":[%v,{"address":"%X","data":"%X"`, TxTypeCall, tx.Address, tx.Data)), w, n, err)
		wire.WriteTo([]byte(Fmt(`,"fee":%v,"gas_limit":%v,"input":`, tx.Fee, tx.GasLimit)), w, n, err)
		tx.Input.WriteSignBytes(w, n, err)
		wire.WriteTo([]byte(`}]}`), w, n, err)
	}

Bytes are written using https://github.com/tendermint/go-wire

	func WriteTo(bz []byte, w io.Writer, n *int, err *error) {
		if *err != nil {
			return
		}
		n_, err_ := w.Write(bz)
		*n += n_
		*err = err_
	}


Which is called from https://github.com/eris-ltd/eris-db/blob/develop/account/account.go

	// SignBytes is a convenience method for getting the bytes to sign of a Signable.
	func SignBytes(chainID string, o Signable) []byte {
		buf, n, err := new(bytes.Buffer), new(int), new(error)
		o.WriteSignBytes(chainID, buf, n, err)
		if *err != nil {
			PanicCrisis(err)
		}
		return buf.Bytes()
	}

