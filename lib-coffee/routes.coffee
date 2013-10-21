###
|--------------------------------------------------------------------------
| routes.coffee
|--------------------------------------------------------------------------
|
|
|
###


###
|--------------------------------------------------------------------------
| Static Pages + Log In + Sign Up + Forgot
|--------------------------------------------------------------------------
###
app.get('/', app.controllers.StaticPageController.index)

###
|--------------------------------------------------------------------------
| Catch All
|--------------------------------------------------------------------------
###
app.get('/*', app.controllers.StaticPageController.index)

###
|--------------------------------------------------------------------------
| Errors
|--------------------------------------------------------------------------
###
# 404 Not Found Error
# 404 Is not used because we serve the landing / dashboard per default
# and BackboneJS should handle the 404
#
# app.use((req, res, next) ->
#   method = req.method
#   url = req.url
#   res.status 404
#   res.render 'error404', {method, url, page: '404'}
# )

# Internal Server Error
app.use((err, req, res, next) ->
  res.status 500
  res.render 'error5xx', { error: err, page: '404' }
)
