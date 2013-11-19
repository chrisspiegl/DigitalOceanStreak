if (process.env.DOS_DEV) {
  module.exports = require('./lib-coffee');
} else {
  module.exports = require('./lib');
}
