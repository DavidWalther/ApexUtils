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

const scratchOrgAlias = process.argv[2];

try {
  console.log('check directory');
  if (fs.existsSync(directory)) {
    console.log(directory + ' does exist > return');
  } else {
    console.log(directory + ' does NOT exist > create');
    fs.mkdirSync(directory);
    createScratchOrg(scratchOrgAlias);
  }
} catch ( error){
  console.log('failure on creation of scratch org');
}


function createScratchOrg(alias) {
  return new Promise(function(resolve) {
    console.log('creating scratch org');
    sfdx.force.org.create({
        setalias: alias,
        durationdays: 1,
        definitionfile: './config/project-scratch-def.json'
      }).then(()=> {
        console.log('scratch org created');
        resolve();
      }).catch(error =>{
        console.log('Error on creating scratch org: ' + error);
      });
  });
}
