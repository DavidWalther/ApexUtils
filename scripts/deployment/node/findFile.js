const fs = require('fs');
const sfdx = require('sfdx-node/parallel');

const fileEncoding = 'utf8';
const path = process.argv[2] ? process.argv[2] : './.sfdx';

const files = fs.readdirSync(path);

const fullPath = filename => {return path + '/' + filename};



const filePromisses = [];
files.filter( filename => {
    console.log('filename filter, filtering: ' + filename);
    // 1. Scratch orgs start with 'test-'
    return filename.startsWith('test');
  })
  .map( filename => {
    // 2. reading filecontent reqires the full path
    return fullPath(filename);
  }).map(filePath => {
    console.log('reading file: ' + filePath);
    // 3. reading each file returns a Promise
    return filePromisses.push(loadPromise(filePath));
  })

const allOrgs = [];
Promise.all(filePromisses).then(values => {
  console.log(values);
});


function loadPromise(fullPath) {
  return new Promise(function(resolve, reject) {
    fs.readFile(fullPath, fileEncoding, (err,data) => {
      if (err) {reject(err)};
      resolve(JSON.parse(data));
    });
  });
}
