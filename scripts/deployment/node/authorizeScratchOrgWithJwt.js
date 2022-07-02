const fs = require('fs');
const sfdx = require('sfdx-node/parallel');

const fileEncoding = 'utf8';
const cachePath = 'cache';

const alias = process.argv[2] ? process.argv[2] :'tempScratchOrg';

const consumerKey =  process.env.SFDX_CONSUMER_KEY;
const serverKeyPath = './server.key'


const scratchOrgNameFiler = filename => {return filename.startsWith('test-') && filename.endsWith('.json')}
const fullPath = filename => {return cachePath + '/' + filename};



//get all filenames in directory
const filePromises = fs.readdirSync(cachePath)
  .filter(scratchOrgNameFiler)
  .map(fullPath)
  .map(loadPromise);

Promise.all(filePromises)
  .then(values => {

    const scratchorg = values[0];

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

