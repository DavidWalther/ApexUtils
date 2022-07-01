/**
 * This script will circumvent limitations on scratch org imposed by salesforce.
 * Those limitations only apply on UNPAID devhubs.
 * 
 * The limitations are:
 * - number of active scratch orgs - (3)
 * - number of created scratch orgs (per 24h?) - (5)
 * - number of new gen2 package version (per 24h?) - (?) 
 */

const sfdx = require('sfdx-node/parallel');
const fs = require('fs');

const directory = './cache';
const filename = 'org.credentials';
const fullPath = directory + '/' + filename;

const fileEncoding = 'utf8';

load(fullPath).then( credentials =>{
  process.env.SFDX_ACCESS_TOKEN = credentials.accessToken;

  sfdx.auth.accesstoken.store({
    noprompt: true,
    setAlias: 'temp-Scratch-Org',
    instanceurl: credentials.instanceUrl
  }).then(() => {
    console.log('auth success');
  });
});

function load(fullPath) {
  return new Promise(function(resolve, reject) {
    fs.readFile(fullPath, fileEncoding, (err,data) => {
      if (err) {reject(err)};
      resolve(JSON.parse(data));
    });
  });
}