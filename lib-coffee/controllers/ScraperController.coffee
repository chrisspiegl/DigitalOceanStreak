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

class ScraperController

  @start: () ->
    miliSeconds = 1000 * 60 * 60
    setImmediate(ScraperController.scrape)
    setInterval(ScraperController.scrape, miliSeconds)

  @getCache: () ->
    return cache

  @scrape: () ->
    options = {
      timeout: 10
    }
    userAgent = config.app.userAgent

    scarper = new nodeio.Job(options, {
      run: (keyword) ->
        @setUserAgent(userAgent)
        @getHtml(config.app.DOSURL, (err, $) ->
          longestStreak = 0
          longestStreakStart = new Date()
          longestStreakEnd = new Date()
          before = -1
          streak = 0
          streakStart = new Date()
          streakEnd = new Date()
          streaks = []
          currentStreak = {}
          $('.date_container').each((el) ->
            date = new Date($('.date', el).text)
            current = false
            if el.children.has('.events_container').length
              current = true

            if before < 0
              before = current

            if before == current && current == false
              streak++
              streakStart = date
            else
              if streak >= longestStreak
                longestStreak = streak
                longestStreakStart = streakStart
                longestStreakEnd = streakEnd
              if streaks.length == 0
                currentStreak =
                  streak: streak
                  start: streakStart
                  end: new Date()
              streaks.push({
                start: streakStart
                end: streakEnd
                streak: streak
              })
              streak = 0
              streakStart = date
              streakEnd = date
            before = current
            return true
          )


          streaks.sortOn('streak')
          streaks.reverse()
          streaks.splice(0,1)

          expire = new Date()
          expire.setSeconds(expire.getSeconds() + 60 * 60)

          logger.info 'Cache filled with new data'
          cache = {
            expire
            longestStreak
            longestStreakStart
            longestStreakEnd
            streaks
            currentStreak
          }
        )
    })

    scarper.run()

module.exports = ScraperController
