import {
  hexToString,
  u8aToString,
  u8aToHex
} from "@polkadot/util";
import {
  Keyring
} from "@polkadot/api";
let keyring = new Keyring({
  ss58Format: 42,
  type: "sr25519"
});

function _extractEvents(api, result) {
  if (!result || !result.events) {
    return;
  }

  let success = false;
  let error;
  result.events
    .filter((event) => !!event.event)
    .map(({
      event: {
        data,
        method,
        section
      }
    }) => {
      if (section === "system" && method === "ExtrinsicFailed") {
        const [dispatchError] = data;
        let message = dispatchError.type;

        if (dispatchError.isModule) {
          try {
            const mod = dispatchError.asModule;
            const error = api.registry.findMetaError(
              new Uint8Array([mod.index.toNumber(), mod.error.toNumber()])
            );

            message = `${error.section}.${error.name}`;
          } catch (error) {
            // swallow error
          }
        }
        window.send("txUpdateEvent", {
          title: `${section}.${method}`,
          message,
        });
        error = message;
      } else {
        window.send("txUpdateEvent", {
          title: `${section}.${method}`,
          message: "ok",
        });
        if (section == "system" && method == "ExtrinsicSuccess") {
          success = true;
        }
      }
    });
  return {
    success,
    error
  };
}

function sendTx(txInfo, paramList) {
  return new Promise((resolve, reject) => {
    let keyPair;
    try {
      keyPair = keyring.addFromJson(txInfo.keystore);
      keyPair.decodePkcs8(txInfo.password);
    } catch (err) {
      resolve(null);
    }

    let unsub = () => {};
    const onStatusChange = result => {
      if (result.status.isFinalized || result.status.isInBlock) {
        unsub();
        result.events
          .filter(({
            event: {
              section
            }
          }) => section === 'system')
          .forEach(({
            event: {
              data,
              method
            }
          }) => {
            if (method === 'ExtrinsicFailed') {
              const [dispatchError] = data;
              if (dispatchError.isModule) {
                try {
                  const mod = dispatchError.asModule;
                  const error = data.registry.findMetaError(new Uint8Array([mod.index.toNumber(), mod.error.toNumber()]));
                  resolve(error.name);

                } catch (error) {
                  // swallow
                  console.log(error);
                  resolve(error);

                }
              }
            } else if (method === 'ExtrinsicSuccess') {
              resolve('ok')
            }
          });
      } else if (result.isError) {
        console.log('fail2,', result.toHuman());
        resolve('fail')
      }
    };

    const tx = api.tx[txInfo.module][txInfo.call](...paramList);
    tx.signAndSend(keyPair, onStatusChange)
      .then(res => {
        unsub = res;
      })
      .catch(err => {
        resolve(err.message);
      });
  });
}

async function fetchIpseMiner(address) {

  let res = {}
  try {
    res = await api.query.ipse.miners(address);
    if (res != null) {
      res = res.toJSON();
      if (res != null) {
        res['nickname'] = hexToString(res['nickname']);
        res['url'] = hexToString(res['url']);
        res['public_key'] = hexToString(res['public_key']);
        res['region'] = hexToString(res['region']);
      }
    }
  } catch (error) {
    window.send('fetchIpseMiner error: ' + error);
  }
  return res
}

async function fetchClaimList(address) {

  let res =[]
  try {
    res = await api.query.exchange.eosExchangeInfo.entries(address);
    if (res != null) {
      
      return res.map((e)=>e.map(x=>x.toHuman()))
    }
  } catch (error) {
    window.send('fetchClaimList error: ' + error);
  }
  return res
}

async function fetchPocMinersList() {

  let miners = []
  let res = []
  try {
    miners = await api.query.pocStaking.recommendList();
    miners = miners.toJSON();
    let addrs = miners.map(e => e[0]);
    let amountList = miners.map(e => e[1]);
    res = await api.query.pocStaking.stakingInfoOf.multi(addrs);
    var resIsStop = await api.query.pocStaking.diskOf.multi(addrs)
    res = res.map((e, i) => {
      e = e.toJSON();
      e["is_stop"] = resIsStop[i].toJSON()["is_stop"];
      e["plot_size"] = resIsStop[i].toJSON()["plot_size"];
      e["miner_staking"] = amountList[i];
      return e;
    })
  } catch (error) {
    window.send('fetchPocMinersList error' + error);
  }
  return res
}

async function fetchIpseMinersList() {

  let miners = []
  let res = []
  try {
    miners = await api.query.ipse.recommendList();
    miners = miners.toJSON();
    let addrs = miners.map(e => e[0]);
    let amountList = miners.map(e => e[1]);
    res = await api.query.ipse.miners.multi(addrs);
    if (res != null) {
      res = res.map((e, i) => {
        e = e.toJSON();
        e["miner_staking"] = amountList[i];
        e['nickname'] = hexToString(e['nickname']);
        e['url'] = hexToString(e['url']);
        e['public_key'] = hexToString(e['public_key']);
        e['region'] = hexToString(e['region']);
        return e;
      })
    }
  } catch (error) {
    window.send('fetchIpseMinersList error' + error);
  }
  return res
}

async function fetchIpseOrderList() {
  var res;
  try {
    res = await api.query.ipse.listOrder()
    res = res.toJSON();
    res = res.map(e => {
      e["hash"] = hexToString(e["hash"]);
      e["label"] = hexToString(e["label"]);
      e["orders"] = e["orders"].map(k => {
        k["url"] = hexToString(k["url"]);
        return k
      })
      return e
    })
  } catch (error) {
    window.send('fetchIpseOrderList error' + error);
  }
  return res
}


async function fetchIpseMinerOrderList(address) {
  var res;
  try {
    res = await api.query.ipse.minerHistory(address)
    res = res.toJSON();
    res = res.map(e => {
      e["hash"] = hexToString(e["hash"]);
      e["label"] = hexToString(e["label"]);
      e["orders"] = e["orders"].map(k => {
        k["url"] = hexToString(k["url"]);
        return k
      })
      return e
    })
  } catch (error) {
    window.send('fetchIpseMinerOrderList error' + error);
  }
  return res
}


async function fetchGlobalData(address) {
  var res;
  try {
    res = await Promise.all([
      api.query.poC.netPower(),
      api.query.poC.capacityPrice(),
      api.consts.babe.expectedBlockTime,
    ])
    
    res=res.map(e=>e.toJSON());
  } catch (error) {
    window.send('fetchGlobalData  error' + error);
  }
  return res
}

var unsubBalance;

async function subBalance(addr,pubKey) {
  if (unsubBalance != null) {
   
    window.send('Cancel function:'+unsubBalance.toString());
   await unsubBalance()
  }
  unsubBalance =await api.derive.balances.all(addr, (all) => {
    const lockedBreakdown = all.lockedBreakdown.map((i) => {
      return {
        ...i,
        use: hexToString(i.id.toHex()),
      };
    });
    window.send("balanceChange", {
      ...all,
      pubKey,
      lockedBreakdown,
    });
  });

  return 'ok';
}


function subNewHeads() {
  return new Promise((resolve, reject) => {
    api.rpc.chain.subscribeNewHeads((lastHeader) => {
      window.send("newHeadsChange", lastHeader);
    });

    resolve('ok');
  });
}


export default {
  sendTx,
  subBalance,
  subNewHeads,
  fetchPocMinersList,
  fetchIpseMinersList,
  fetchIpseMiner,
  fetchIpseOrderList,
  fetchClaimList,
  fetchGlobalData,
  fetchIpseMinerOrderList
};