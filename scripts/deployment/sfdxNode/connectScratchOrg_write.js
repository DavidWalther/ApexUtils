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

const fileEncoding = 'utf8';
const directory = './cache';
const filename = 'org.credentials';
const fullPath = directory + '/' + filename;


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
        definitionfile: './config/project-scratch-def.json',
        defaultusername: true
      }).then(()=> {
        console.log('scratch org created');
        resolve();
      }).catch(error =>{
        console.log('Error on creating scratch org: ' + error);
      });
  });
}
/*
function checkScrathOrg(alias) {
  console.log('retrieving scratch org credentials');
  sfdx.force.org.display({
    targetusername: alias
  })
  .then(result=>{
    console.log('retrieved scratch org credentials');
    save(fullPath, result);
  })
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
*/