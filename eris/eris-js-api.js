# https://docs.erisindustries.com/documentation/eris-db.js/README/

var edbFactory = require('eris-db');

var cb=function(error, data) { console.log("Eris Response!\nerror: " + error + "\ndata: " + JSON.stringify(data, null, 2)); return 0 };


var erisdb = edbFactory.createInstance("http://192.168.99.100:1337/rpc");

erisdb.start(function(error){
    if(!error){
        console.log("Ready to go");
    }
});

erisdb.blockchain().getInfo(cb);
erisdb.accounts().getAccounts(cb);
erisdb.accounts().getAccount("DA853491290DCCFB8E6BBFD85B471324381D4B54", cb);

erisdb.blockchain().getLatestBlock(cb);
erisdb.blockchain().getBlock(7372, cb);


erisdb.consensus().getState(cb);

erisdb.network().getInfo(cb);

erisdb.txs().getUnconfirmedTxs(cb);

erisdb.blockchain().getBlocks(cb);

# To understand the structure of blocks you need to look at https://github.com/tendermint/tendermint/wiki/Block-Structure#transaction

# https://github.com/tendermint/tendermint/wiki/Block-Structure#transaction
# https://bitsonblocks.net/tag/erisdb/
