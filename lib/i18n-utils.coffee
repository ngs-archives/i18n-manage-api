extend = require 'extend'
CSON = require 'cson'

find = (obj, pathComponents, fullKeyName = '') ->
  key = pathComponents.shift()
  return fullKeyName unless key
  obj = obj[key] ||= {}
  if pathComponents.length > 0
    find obj, pathComponents, "#{fullKeyName}.#{key}"
  else
    obj

toResources = (obj, prefix = '') ->
  res = {}
  for locale, dirs of obj
    for dir, resources of dirs
      res["#{prefix}#{locale}/#{dir}/index.coffee"] = resources
  res

getPendingResources = (tree, obj, prefix = '') ->
  resources = toResources obj, prefix
  res = { create: [], update: [], keep: [] }
  blobMap = {}
  for blob in tree
    {path} = blob
    blobMap[path] = blob
  for path, data of resources
    if blob = blobMap[path]
      res.update.push extend yes, {data,path}, blob
      delete blobMap[path]
    else
      res.create.push {data,path}
  for k, blob of blobMap
    res.keep.push blob
  res

removeNull = (obj) ->
  for k, v of obj
    if v is null
      delete obj[k]
    else if typeof v == 'object'
      v = removeNull v
      if Object.keys(v).length == 0
        delete obj[k]
      else
        obj[k] = v
  obj

createFile = (i18n, requires = []) ->
  cson = CSON.createCSONString removeNull(i18n), indent: '  '
  requiresCode = []
  for {key, path} in requires.reverse()
    requiresCode.push "\n  #{key}: require \"#{path}\""
  """
  "use strict"

  module.exports =#{requiresCode.join("")}
    #{cson.replace(/\n/g, "\n  ").replace '{}', ''}

  """
# requirecallback = function(key, path, resolved)
# callback = function(data)
parseFile = (file, requireCallback, callback) ->
  csonString = file.toString('utf8')
    .replace /^[.\s\S]*module\.exports\s*=/m, ''
    .replace /\n\s{2}/g, "\n"
  requires = []
  re = /\s*\w+\s*:\s*require\s*\(?["'].+["']\)?/gm
  if m = csonString.match re
    for code in m
      [_code, indent, key, path] = code.match /\n?(\s*)(\w+)\s*:\s*require\s*\(?["'](.+)["']\)?/
      if indent.length > 0
        console.warn "Found indent level #{indent.length / 2}, but currently supporting required namespaces on top level m(_ _)m"
      requires.push {key, path}
    csonString = csonString.replace re, ''
  resolveNextRequire = ->
    if requires.length == 0
      callback CSON.parse csonString
      return
    {key, path} = requires.pop()
    if requireCallback
      requireCallback key, path, ->
        resolveNextRequire()
    else
      resolveNextRequire()
  do resolveNextRequire
  return

# requirecallback = function(override, key, path, resolved)
# callback = function(content)
updateFile = (file, override, requireCallback, callback) ->
  requires = []
  parseFile file,
  (key, path, resolved) ->
    requires.push { key, path }
    if val = override[key]
      delete override[key]
      requireCallback? val, key, path, resolved
    else
      do resolved
    return
  ,
  (data) ->
    file = createFile extend(yes, data, override), requires
    callback file
  return

module.exports = {
  find
  toResources
  getPendingResources
  createFile
  parseFile
  updateFile
}
