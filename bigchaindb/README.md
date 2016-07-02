# bigchaindb


## bigchaindb setup and testing

BigChainDB provides a docker image which you can run on osx using docker-machine. There is some documents here https://media.readthedocs.org/pdf/bigchaindb/latest/bigchaindb.pdf

You can follow the instructions at https://bigchaindb.readthedocs.io/en/latest/nodes/run-with-docker.html

This basically runs a docker image on your default dockermachine.

DockerMachine creates a virtual machine using oracle virtualbox. You can connect to your virtual docker host machine using:

	eval "$(docker-machine env default)"

From that point on in your shell, any `docker` commands get sent to that particular machine, so its as if you are local to it. If you do

	docker ps

You will see if you have the bigchaindb running. You should see something like this:

	CONTAINER ID        IMAGE                   COMMAND                  CREATED             STATUS              PORTS                                                                    NAMES
	<container-id>      bigchaindb/bigchaindb   "bigchaindb --experim"   12 days ago         Up 10 days          28015/tcp, 29015/tcp, 0.0.0.0:58080->8080/tcp, 0.0.0.0:59984->9984/tcp   bigchaindb

If you want to get into that machine so that you can play around then you can try:

	docker exec -i -t <container-id> /bin/bash 

For example you can now run bichaindb CLI commands (https://bigchaindb.readthedocs.io/en/latest/nodes/bigchaindb-cli.html). Try

	bigchaindb show-config

There is some basic tests of the client here:

	http://bigchaindb.readthedocs.io/en/latest/drivers-clients/python-driver-api-examples.html

We can run these from a python shell:

	/usr/bin/python3

Here is a session that shows how this works:

```python
root@ed3cb29da6bd:/data# /usr/bin/python3
Python 3.4.2 (default, Oct  8 2014, 10:45:20) 
[GCC 4.9.1] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> from bigchaindb.client import temp_client
>>> c1 = temp_client()
>>> c2 = temp_client()
>>> c1.public_key
'2yZtr7tCMSa7TEwh5SFY3MUgfWqsdRvgu8ki2az1bVYk'
>>> c2.public_key
'HAUqyLKGCH8mj94oqmV9BLJBbcP4JkmocGGVqKNv9g2s'
>>> tx1 = c1.create()
>>> tx1
{'id': '06e3fb108b334f39f160c792c47cc27a4b557086156e88b5ff2b4cfc17aebed9', 'transaction': {'new_owner': '2yZtr7tCMSa7TEwh5SFY3MUgfWqsdRvgu8ki2az1bVYk', 'operation': 'CREATE', 'data': {'hash': 'efbde2c3aee204a69b7696d4b10ff31137fe78e3946306284f806e2dfc68b805', 'payload': None}, 'timestamp': '1466352177.591625', 'current_owner': 'EMHGDT6bkWWduR25CKAL31rR7PwQaM32o8gcMZkG2H6j', 'input': None}, 'assignee': 'EMHGDT6bkWWduR25CKAL31rR7PwQaM32o8gcMZkG2H6j', 'signature': '378zeTjVwfiYG39HkwHxKHerbwqPgfJBwnz5tTAcQEwA8eihF9gG4Gabpyeyn3P2RB7k6tC9GJbT7y6kqkMH2DXc'}
>>> c1.transfer(c2.public_key, tx1['id'])
{'id': 'fd288ab5b43b79fcbded5e7e9feddf7277edc17d23726a4b73dfe4296ab36fea', 'transaction': {'new_owner': 'HAUqyLKGCH8mj94oqmV9BLJBbcP4JkmocGGVqKNv9g2s', 'operation': 'TRANSFER', 'data': {'hash': 'efbde2c3aee204a69b7696d4b10ff31137fe78e3946306284f806e2dfc68b805', 'payload': None}, 'timestamp': '1466352197.364388', 'current_owner': '2yZtr7tCMSa7TEwh5SFY3MUgfWqsdRvgu8ki2az1bVYk', 'input': '06e3fb108b334f39f160c792c47cc27a4b557086156e88b5ff2b4cfc17aebed9'}, 'assignee': 'EMHGDT6bkWWduR25CKAL31rR7PwQaM32o8gcMZkG2H6j', 'signature': '2WuipdcZbTCU5BocmHTU4a2SH6HJky9h9T6bUDnsvbGj2tzW9BGud6Zs6yPnMBJF1c6W3UrRptXtRcvL31WFE7rF'}
>>> 
```

The server can be accessed from:

	http://<docker-machine-ip>:58080/
	http://<docker-machine-ip>:59984/api/v1/transactions/<transaction_id>

You can discover your docker-machine ip address like this:

	docker-machine ip default

Try putting the transaction ID from your test transaction in there.

You can also see what the bigchain server is doing by running

	docker logs --follow bigchaindb

this is particularly useful to see errors


## Python client outside Docker

Lets try connecting to the docker image remotely. The endpoint is stored in a dict called `bigchain` here `bigchain['api_endpoint']`

We need to setup a clean bigchain environment so we can use the docker image that we already have or a new one

	docker run -t -i ubuntu /bin/bash



import bigchaindb
bigchaindb.config['api_endpoint']

from bigchaindb import crypto
from bigchaindb.client import Client

private_key, public_key = crypto.generate_key_pair()
c1 = Client(private_key=private_key, public_key=public_key, api_endpoint='http://192.168.99.100:59984/api/v1')

tx1 = c1.create()

## BigchainDB Examples

These can be worked through from here

https://media.readthedocs.org/pdf/bigchaindb-examples/latest/bigchaindb-examples.pdf

## Server API

https://bigchaindb.readthedocs.io/en/latest/nodes/python-server-api-examples.html

This gives us some detailed use case

# Clojure client project

The project uses [Midje](https://github.com/marick/Midje/).

This is a demonstration of using the http interface to CREATE and TRANSFER assests.

The api is described here http://bigchaindb.readthedocs.io/en/latest/drivers-clients/http-client-server-api.html

And theres interactive docs here: http://docs.bigchaindb.apiary.io/#



## How to run the tests

`lein midje` will run all tests.

`lein midje namespace.*` will run only tests beginning with "namespace.".

`lein midje :autotest` will run all the tests indefinitely. It sets up a
watcher on the code files. If they change, only the relevant tests will be
run again.
