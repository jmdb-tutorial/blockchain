#!/usr/local/bin/python
import hashlib, time


message = "Hello Agile On the Beach!"
messageHash = hashlib.sha256(message).hexdigest()

print "Going to try and find a block hash for message hash " + messageHash

difficulty = 1 # Big difference between 4 and 5

def isValidHash ( hash ):
    return blockHash.startswith('0' * difficulty)

validHash = "not-found"
start = time.time()
for nonce in range(0,  100000):
    blockHash = hashlib.sha256(messageHash + str(nonce)).hexdigest()
    print "trying  : " + blockHash
    if (isValidHash(blockHash)):
        validHash = blockHash
        stop = time.time()
        break

print "\nFound One! :  " + validHash + " in " + "{0:.2f}".format(stop - start) + " seconds\n"
