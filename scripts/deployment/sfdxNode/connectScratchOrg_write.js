/**
 * This script will circumvent limitations on scratch org imposed by salesforce.
 * Those limitations only apply on UNPAID devhubs.
 * 
 * The limitations are:
 * - number of active scratch orgs - (3)
 * - number of created scratch orgs (per 24h?) - (5)
 * - number of new gen2 package version (per 24h?) - (?) 
 */

//const sfdx = require('sfdx-node/parallel');
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



/* 
console.log('try promie - start');
fs.existsSync(fullPath)
  .then(() => {
    console.log('file found');
  })
  .catch(() => {
    console.log('file NOT found');
  })
  .finally(() => {
    console.log('file finish');
  });
console.log('try promie - start');
 */

const jsonObj = {
  key1: 'abc',
  key2: 'def'
}


console.log('check directory');
if (fs.existsSync(directory)) {
  console.log(directory + ' does exist > return');
} else {
  console.log(directory + ' does NOT exist > create');
  fs.mkdirSync(directory);
}

fs.writeFile(fullPath, JSON.stringify(jsonObj), fileEncoding, function (err) {
  if (err) throw err;
});


// createScratchOrg(scratchOrgAlias);

function createScratchOrg(alias) {
  sfdx.force.org.create({
      setalias: alias,
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
