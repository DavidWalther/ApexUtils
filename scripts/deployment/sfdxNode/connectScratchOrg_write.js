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

if (fs.existsSync(fullPath)) {
  console.log(filename + ' does exist > return')
  return;
}

//createScratchOrg();

function writeCredentialsJson(jsonObj) {
  return new Promise((resolve) => {
    if (!fs.existsSync(fullPath)) {
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
      definitionfile: './config/project-scratch-def.json',
      verbose: true
    }).then(result => {
      console.log(result);
      writeCredentialsJson(result);
    }).catch(error => {
      console.log(error);
    });
}
