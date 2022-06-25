const fs = require('fs');

console.log('i am a node script');

let currentDate = new Date();
const dd = String(currentDate.getDate()).padStart(2, '0');
const mm = String(currentDate.getMonth() + 1).padStart(2, '0'); //January is 0!
const yyyy = currentDate.getFullYear();

currentDate = yyyy + '-' + mm + '-' + dd;
console.log(currentDate);
