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

// process.argv[0] - command name
// process.argv[1] - script name
const scratchOrgAlias = process.argv[2] // first parameter

if(!scratchOrgAlias) {
  console.log('no org alias');
  return;
}

console.log(scratchOrgAlias);

const directory = './cache';
const filename = 'org.credentials';
const fullPath = directory + '/' + filename;

const fileEncoding = 'utf8';

const dataObject = {
  key1: 'abcd',
  key2: 'efg'
}
console.log(dataObject);

console.log('call write');
writeCredentialsJson(dataObject)
  .then(() => {
    console.log('then');
  })
  .catch((error) => {
    console.log('catch');
    console.log(error);
  })
  .finally(() => {
    console.log('finally');
  });

function writeCredentialsJson(jsonObj) {
  return new Promise((resolve) => {
    if (!fs.existsSync(fullPath)) {
      console.log(filename + ' does not exist')
      fs.mkdirSync(directory);
      fs.writeFile(fullPath, JSON.stringify(jsonObj), fileEncoding, function (err) {
        if (!err) {
          resolve();
        }
      });
    };
  })
}

function createScratchOrg() {
  sfdx.force.org.create({
      setalias: scratchOrgAlias,
      setdefaultusername: true,
      durationdays: 1,
      definitionfile: './config/project-scratch-def.json'
    }).then(result => {
      console.log(result);
    }).catch(error => {
      console.log(result);
    });
}
