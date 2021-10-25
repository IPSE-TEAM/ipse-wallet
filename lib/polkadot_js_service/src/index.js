import "@babel/polyfill";
import {
  WsProvider,
  ApiPromise
} from "@polkadot/api";
import account from "./service/account";
import staking from "./service/staking";
import gov from "./service/gov";
import ipse from "./service/ipse";
import {
  genLinks
} from "./utils/config/config";
import customsTypes from './utils/customsTypes'
import {
  POLKADOT_GENESIS
} from "./constants/networkSpect";

// send message to JSChannel: IpseWallet
function send(path, data) {
  if (window.location.href === "about:blank") {
    IpseWallet.postMessage(JSON.stringify({
      path,
      data
    }));
  } else {
    console.log(path, data);
  }
}
send("log", "main js loaded");
window.send = send;


function connect(endpoint, isIpse, newTypes) {
  return new Promise(async (resolve, reject) => {
    const wsProvider = new WsProvider(endpoint);
    try {
      var api = new ApiPromise({
        provider: wsProvider,
        types: isIpse == 1 ? (newTypes || customsTypes) : null,
      });
      api.on('connected', () => {
        send("disconnected", false);
      });
      api.on('disconnected', () => {
        send("disconnected", true);

      });
      await api.isReady
      window.api = api;
      send("log", `${endpoint} wss ready`);
      resolve(endpoint);
    } catch (error) {
      send("log", `connect ${endpoint} failed`);

      resolve(null);
    }

  });
}

const test = async (address) => {
  // const props = await api.rpc.system.properties();
  // send("log", props);
};

async function getNetworkConst() {
  return api.consts;
}

function changeEndpoint(endpoint) {
  try {
    send("log", "disconnect");
    window.api.disconnect();
  } catch (err) {
    send("log", err.message);
  }
  return connect(endpoint);
}

async function subscribeMessage(section, method, params, msgChannel) {
  return api.derive[section][method](...params, (res) => {
    send(msgChannel, res);
  }).then((unsub) => {
    const unsubFuncName = `unsub${msgChannel}`;
    window[unsubFuncName] = unsub;
    return {};
  });
}

async function getNetworkPropoerties() {
  const chainProperties = await api.rpc.system.properties();
  
  return api.genesisHash.toHuman() == POLKADOT_GENESIS ?
    api.registry.createType("ChainProperties", {
      ...chainProperties,
      tokenDecimals: 10,
      tokenSymbol: "DOT",
    }) :
    chainProperties;
}

async function fetchNetworkInfo() {
  return await Promise.all([
    getNetworkConst(),
    getNetworkPropoerties(),
    api.rpc.system.chain()
  ])
}

window.settings = {
  test,
  connect,
  fetchNetworkInfo,
  getNetworkConst,
  getNetworkPropoerties,
  changeEndpoint,
  subscribeMessage,
  genLinks,
};

window.account = account;
window.staking = staking;
window.gov = gov;
window.ipse = ipse;