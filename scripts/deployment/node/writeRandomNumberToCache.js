const fs = require('fs');

//import { access, constants } from 'fs';

const directory = './cache';
const filename = 'random.number';
const fullPath = directory + '/' + filename;


if (!fs.existsSync(fullPath)){
  fs.mkdirSync(directory);
  
  const milisecounds = '' + new Date().getTime();
  fs.writeFile(fullPath, milisecounds, 'utf8', function (err) {
    if (err) {
        console.log("An error occured while writing JSON Object to File.");
        return console.log(err);
    }
  
    console.log("milliseconds written: " + milisecounds);
  });
} else {
  fs.readFile(fullPath, 'utf8' , (err,data) => {
    if (err) throw err;
    console.log('content read: ' + data);
  });

  fs.re
}
