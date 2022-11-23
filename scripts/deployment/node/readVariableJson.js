const fs = require('fs');
const paramsObj = {
  filepath : process.argv[2]
}

console.table(paramsObj);

process.env.JSON_PARAMETER_FIRST = paramsObj.filepath;
console.log(process.env.JSON_PARAMETER_FIRST);

function loadPromiseJson(fullPath) {
  return new Promise(function(resolve, reject) {
    fs.readFile(fullPath, fileEncoding, (err,data) => {
      if (err) {reject(err)};
      resolve(JSON.parse(data));
    });
  });
}