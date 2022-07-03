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

const fileEncoding = 'utf8';
const directory = './cache';
const filename = 'org.credentials';
const fullPath = directory + '/' + filename;

const scratchOrgAlias = process.argv[2];

if (!fs.existsSync(fullPath)) { 
  console.log('no credentials saved yet.');
  checkScrathOrg(scratchOrgAlias, checkCallback);
} else {
  console.log('credentials already saved.');
  console.log('SKIP');
}

function checkScrathOrg(alias, callback) {
  console.log('retrieving scratch org credentials');
  sfdx.force.org.display({
    targetusername: alias
  })
  .then(result => {
    console.log('Retrieved scratch org credentials. scratchorg details:');
    console.log(result);
    callback(result);
  })
}

function checkCallback(result) {
  save(fullPath, result);
}

function save(fullPath, jsonObj) {
  console.log('saving credentials');
  fs.writeFile(fullPath, JSON.stringify(jsonObj), fileEncoding, function (err) {
    if (err) {
      console.log('Error on saving credentials: ' + err);
      throw err
    };
    console.log('credentials saved');
  });
}
