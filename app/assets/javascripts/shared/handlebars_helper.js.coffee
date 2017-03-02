# A utiliser dans un template handlebars
# ex : {{debug a_value}}
Handlebars.registerHelper 'debug', (optionalValue) ->
  console.log 'Current Context'
  console.log '===================='
  console.log this
  if optionalValue
    console.log 'Value'
    console.log '===================='
    console.log optionalValue
  return