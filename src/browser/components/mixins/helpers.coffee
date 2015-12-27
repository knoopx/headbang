QS = require('qs')

module.exports =
  setQueryString: (obj, title = "") ->
    window.history.pushState(null, title, "?#{QS.stringify(Object.merge(@getQueryString(), obj))}")

  getQueryString: ->
    QS.parse(window.location.search.from(1))

  getItem: (key, defaultValue)->
    try
      JSON.parse(localStorage.getItem(key)) || defaultValue
    catch
      defaultValue

  setItem: (key, obj)->
    localStorage.setItem(key, JSON.stringify(obj))

  setDocumentTitle: (title) ->
    document.title = title
