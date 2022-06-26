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

readCredentialsJson()
  .then(data => {
    console.log(data);
  });


function readCredentialsJson() {
  return new Promise((resolve, reject) => {
    if (!fs.existsSync(fullPath)){
      reject('File does not exist!');
    }

    fs.readFile(fullPath, fileEncoding , (err,data) => {
      if (err) {
        reject(err);
      }
      if (data) {
        resolve(JSON.parse(data));
      }
    });  
  });
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
