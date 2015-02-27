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

hasSubModule = (dir) ->
  dir is 'views'

toResources = (obj, prefix = '') ->
  res = {}
  for locale, dirs of obj
    for dir, resources of dirs
      if hasSubModule dir
        for dir2, resources2 of resources
          res["#{prefix}#{locale}/#{dir}/#{dir2}.coffee"] = resources2
      else
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

createFile = (i18n) ->
  cson = CSON.createCSONString i18n, indent: '  '
  """
  'use strict'

  module.exports =
    #{cson.replace /\n/g, "\n  "}
  """

parseFile = (file) ->
  csonString = file.toString('utf8')
    .replace /^[.\s\S]*module\.exports\s*=/m, ''
    .replace /\n\s{2}/g, "\n"
  CSON.parse csonString

updateFile = (file, override) ->
  createFile extend yes, parseFile(file), override

module.exports = {
  find
  toResources
  getPendingResources
  createFile
  parseFile
  updateFile
}
