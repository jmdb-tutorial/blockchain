#!/usr/local/bin/python
import hashlib

difficulty = 1

message = "Hello Agile On the Beach!"
messageHash = hashlib.sha256(message).hexdigest()

print "Going to try and find a block hash for message hash " + messageHash



