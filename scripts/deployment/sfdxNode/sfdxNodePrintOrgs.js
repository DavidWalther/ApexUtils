const sfdx = require('sfdx-node/parallel');

sfdx.force.org.list({
  _rejectOnError: true
})
.then(response => {
  console.log(response);
})
.catch(error => {
  console.log(error);
});