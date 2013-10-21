nodeio = require('node.io')

Array.prototype.sortOn = (key) ->
  @sort((a, b) ->
      if (a[key] < b[key])
          return -1
      else if(a[key] > b[key])
          return 1
      return 0
  )

cache = {
  expire: new Date() - 1
  longestStreak: 0
  longestStreakStart: new Date()
  longestStreakEnd: new Date()
  streaks: []
  currentStreak:
    streak: 0
    start: new Date()
    end: new Date()
}

class StaticPageController

  @index: (req, res) ->
    obj = app.controllers.ScraperController.getCache()
    res.render('index', {
      longestStreak: obj.longestStreak
      longestStreakStart: obj.longestStreakStart
      longestStreakEnd: obj.longestStreakEnd
      streaks: obj.streaks
      currentStreak: obj.currentStreak
      page: 'index'
    })

module.exports = StaticPageController
