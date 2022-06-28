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
  console.log(credentials);
  process.env.SFDX_ACCESS_TOKEN = credentials.accessToken;
});


function load(fullPath) {
  return new Promise(function(resolve, reject) {
    fs.readFile('cache/org.credentials', fileEncoding, (err,data) => {
      if (err) {reject(err)};
      resolve(JSON.parse(data));
    });
  });
}