const fs = require('fs');
const sfdx = require('sfdx-node/parallel');

const fileEncoding = 'utf8';
const cachePath = 'cache';




const alias = process.argv[2] ? process.argv[2] :'tempScratchOrg';

const scratchOrgUsername = 'test-w07u0jt73usz@example.com';
const scratchOrgInstanceurl = 'https://speed-java-7971-dev-ed.my.salesforce.com';
const consumerKey =  process.env.SFDX_CONSUMER_KEY;
const serverKeyPath = './server.key'


sfdx.auth.jwt.grant({
  clientid: consumerKey,
  username: scratchOrgUsername,
  jwtkeyfile: serverKeyPath,
  instanceurl: scratchOrgInstanceurl,
  setalias: alias,
  setdefaultusername:true
}).then(result => {
  console.log('then: ' + result);
})
.catch(error => {
  console.log('catch: ' + error);
});




/*
const fullPath = filename => {return cachePath + '/' + filename};

const files = fs.readdirSync(cachePath);

//read private key for authentication
const filePromisses = [loadPromiseBinary('server.key')];


files.filter( filename => {
  // 1. Scratch orgs start with 'test-'
  console.log('filtering: ' + filename);
  return filename.startsWith('test');
})
.map( filename => {
  // 2. reading filecontent reqires the full path
  return fullPath(filename);
}).map(filePath => {
  console.log('promising: ' + filePath);
  // 3. reading each file returns a Promise
  return filePromisses.push(loadPromiseJson(filePath));
})


Promise.all(filePromisses).then(files => {


  const credentials = {
    //jwt: Buffer.from(files[0]).toString('base64'),
    clientId: files[1].clientId,
    username: files[1].username,
    instanceUrl: files[1].instanceUrl
  }

  console.log(JSON.stringify(credentials));

  const setalias = 'tempScratchOrg2'


  sfdx.auth.jwt.grant({
    setalias:setalias,
    jwtkeyfile: fullPath('server.key'),
    clientid: credentials.clientId,
    instanceurl: credentials.instanceUrl,
    username: credentials.username,
    setdefaultusername: true
  }).then(result => {
    console.log('Auth sucess. ' + result)
  }).catch(error => {
    console.log('Auth fail. ' + error)
  })
});


function loadPromiseBinary(fullPath) {
  return new Promise(function(resolve, reject) {
    fs.readFile(fullPath, fileEncoding, (err,data) => {
      if (err) {reject(err)};
      resolve(data);
    });
  });
}

function loadPromiseJson(fullPath) {
  return new Promise(function(resolve, reject) {
    fs.readFile(fullPath, fileEncoding, (err,data) => {
      if (err) {reject(err)};
      resolve(JSON.parse(data));
    });
  });
}*/