const fs = require('fs');

console.log('i am a node script');

const currentDateString = getCurrentDateString();
console.log('date for caching checksum:' + currentDateString);


fs.writeFile("checksum_24h.cache", currentDateString, 'utf8', function (err) {
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