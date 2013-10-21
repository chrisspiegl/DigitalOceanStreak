###
|------------------------------------------------------------------------------
| App Defaults
|------------------------------------------------------------------------------
###
module.exports =
    name: 'DigitalOceanStreak'
    version: require('../../package.json').version
    frontEndVersion: '0.0.0'
    apiVersion: 0
    testing: process.env.TESTING || false
    secret: '8rC4HA3Zi9SVKazl98Z3RyrWuAKykgb5RNuOKbg3PtL'
    email: 'YOUR@EMAIL.COM' # Admin Email Address
    DOSURL: 'https://www.digitaloceanstatus.com/history'
    userAgent: 'DigitalOceanStreak Analyzer (Site: http://dos.chrissp.com) (Contact: chris@chrissp.com)'
