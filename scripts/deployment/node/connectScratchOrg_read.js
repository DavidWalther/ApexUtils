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

load(fullPath).then(result => {
  checkScrathOrg(result.username);
});


function checkScrathOrg(alias) {
  sfdx.force.org.display({
    targetusername: alias
  })
  .then(result=>{
    console.log('result: sfdx.force.org.display');
    console.log(result);
  })
}

function load(fullPath) {
  return new Promise(function(resolve, reject) {

    fs.readFile(fullPath, fileEncoding, (err,data) => {
      if (err) {reject(err)};
      resolve(JSON.parse(data));
    });
  });
}
