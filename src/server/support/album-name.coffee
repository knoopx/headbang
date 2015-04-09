stripValues =
  notes: /\b(TRACKFIX|DIRFIX|READ\s+NFO)\b/g
  vinyl: /(\d+[\s\-_]*?(inch\.?|"|i\b))?([\s\-_]*?\bvinyl\b)?/gi
  #extra3: /\b((feat|ft|vs|incl)\.?|presents)\b/g
  #volume: /\b(cd|disk|part|pt\.?|chapter|vol\.?(ume)?)\b(\d+|[ivmcldx]+|(one|two|three))*\b/g

matchValues =
  source: /\b(CDM|CDEP|CDR|CDS|CD|MCD|DVDA|DVD|TAPE|VINYL|VLS|WEB|SAT)\b/g
  format: /\b(EP|LP|BOOTLEG|SINGLE)\b/g
  extra: /\b(ADVANCE|PROMO|SAMPLER|PROPER|RERIP|RETAIL|REMIX|BONUS|LTD\.?|LIMITED)\b/g
  reissue: /\b((RE[\-_]*)?(MASTERED|ISSUE|PACKAGE|EDITION))\b/g

queryValues =
  meta: /(\([^\)]*\))+/gi
  stopwords: /\b(and|\s*&\s*|)\b/gi

module.exports =
  strip: (input) ->
    output = input
    for values in [stripValues, matchValues]
      for valueType, valueRegex of values
        output = output.replace(valueRegex, '')

    @clean(output)

  querify: (input) ->
    output = input
    for valueType, valueRegex of [queryValues, stripValues, matchValues]
      output = output.replace(valueRegex, '')
    @strip(output)

  tags: (input) ->
    matches = []
    input = input.replace(/[\-_]+/g, ' ')
    for valueType, valueRegex of matchValues
      if m = valueRegex.exec(input)
        matches.push(m[1]) if m[1]

    matches.push("VINYL")  unless input == input.replace(stripValues.vinyl, "")

    matches.unique().sort()

  clean: (string) ->
    string.replace(/\s+/g, ' ').replace(queryValues.meta, '').trim()
