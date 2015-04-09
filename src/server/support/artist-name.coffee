queryValues =
  meta: /(\([^\)]*\))+/gi
  stopwords: /\b(and|\s*&\s*)\b/gi
  the: /^\bthe\b/gi

module.exports =
  querify: (input) ->
    output = input
    for valueType, valueRegex of [queryValues]
      output = output.replace(valueRegex, '')
    @clean(output)

  clean: (string) ->
    string.replace(/\s+/g, ' ').replace(queryValues.meta, '').trim()
