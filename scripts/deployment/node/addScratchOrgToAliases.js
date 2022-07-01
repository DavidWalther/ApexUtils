const fs = require('fs');



const fileEncoding = 'utf8';
const path = process.argv[2] ? process.argv[2] : '.sfdx';

const scratchOrgUsernames = fs.readdirSync(path).filter(filename => filename.startsWith('test-'));

console.log(scratchOrgUsernames);



loadPromise('.sfdx/alias.json').then( aliasJson => {
  console.log(aliasJson);
});




function loadPromise(fullPath) {
  return new Promise(function(resolve, reject) {
    fs.readFile(fullPath, fileEncoding, (err,data) => {
      if (err) {reject(err)};
      resolve(JSON.parse(data));
    });
  });
}