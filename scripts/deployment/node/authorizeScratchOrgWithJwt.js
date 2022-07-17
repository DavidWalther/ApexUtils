const fs = require('fs');
const sfdx = require('sfdx-node/parallel');

const fileEncoding = 'utf8';
const filepath = 'cache/org.credentials';

const alias = process.argv[2] ? process.argv[2] :'tempScratchOrg';
const consumerKey =  process.env.SFDX_CONSUMER_KEY;
const serverKeyPath = './server.key'


loadPromise(filepath)
  .then(scratchorg => {
    sfdx.auth.jwt.grant({
      clientid: consumerKey,
      username: scratchorg.username,
      jwtkeyfile: serverKeyPath,
      instanceurl: scratchorg.instanceUrl,
      setalias: alias,
      setdefaultusername:true
    }).then(() => {
      console.log('Authorization successfull');
    })
    .catch(error => {
      console.log('Authorization failed: ' + error);
    });
  })


function loadPromise(fullPath) {
  return new Promise(function(resolve, reject) {
    fs.readFile(fullPath, fileEncoding, (err,data) => {
      if (err) {reject(err)};
      resolve(JSON.parse(data));
    });
  });
}

