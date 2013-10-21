if (process.env.LOCA_DEV) {
  module.exports = require('./lib-coffee');
} else {
  module.exports = require('./lib');
}
