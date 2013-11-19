
if (process.env.DOS_COV) {
  console.log('Running COVERAGE');
  require('coffee-script');
  require('coffee-cache').setCacheDir('tmp/cachedCoffee/');
  module.exports = require('./lib-cov');

} else if (process.env.DOS_DEV) {
  console.log('Running DEVELOPMENT');
  process.env.NODSTR_DEV = true;
  require('coffee-script');
  require('coffee-backtrace').setContext(5);
  require('coffee-cache').setCacheDir('tmp/cachedCoffee/');
  require('source-map-support')
  module.exports = require('./lib-coffee');

} else {
  console.log('Running PRODUCTION');
  module.exports = require('./lib');

}
