const fs = require('fs');

const filepath = 'checksum_24h.cache';


const checksumObj = {
  currentDateString: getCurrentDateString(),
  version: process.env.CircleCI_Cache_Version
}


fs.writeFile(filepath, JSON.stringify(checksumObj), 'utf8', function (err) {
  if (err) {
      console.log("An error occured while writing JSON Object to File.");
      return console.log(err);
  }

  console.log("checksum written");
});

function getCurrentDateString() {
  let currentDate = new Date();
  const dd = String(currentDate.getDate()).padStart(2, '0');
  const mm = String(currentDate.getMonth() + 1).padStart(2, '0'); //January is 0!
  const yyyy = currentDate.getFullYear();
  
  return yyyy + '-' + mm + '-' + dd;
}