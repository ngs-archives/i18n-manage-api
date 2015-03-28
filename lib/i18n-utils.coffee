extend = require 'extend'
CSON = require 'cson'

DEFAULT_PREFIX = """
"use strict"

module.exports =

"""

DEFAULT_SUFFIX = "\n"

find = (obj, pathComponents, fullKeyName = '') ->
  key = pathComponents.shift()
  return fullKeyName unless key
  obj = obj[key] ||= {}
  if pathComponents.length > 0
    find obj, pathComponents, "#{fullKeyName}.#{key}"
  else
    obj

toResources = (obj, prefix = '', index = yes, extension = 'coffee') ->
  res = {}
  for locale, dirs of obj
    if index
      for dir, resources of dirs
        res["#{prefix}#{locale}/#{dir}/index.#{extension}"] = resources
    else
      res["#{prefix}#{locale}.#{extension}"] = dirs
  res

getPendingResources = (tree, obj, prefix = '', index = yes, extension = 'coffee') ->
  resources = toResources obj, prefix, index, extension
  localeFromPath = (path) ->
    (if prefix then path.split(prefix)[1] else path)?.split(/[.\/]/)[0]
  res = { create: [], update: [], keep: [] }
  blobMap = {}
  for blob in tree
    {path} = blob
    blobMap[path] = blob
  for path, data of resources
    if blob = blobMap[path]
      locale = localeFromPath path
      res.update.push extend yes, {data,path,locale}, blob
      delete blobMap[path]
    else
      locale = localeFromPath path
      res.create.push {data,path,locale}
  for k, blob of blobMap
    blob.locale = localeFromPath blob.path
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

createFile = (i18n, requires, fileOptions) ->
  if typeof fileOptions is 'undefined' && !(requires instanceof Array)
    fileOptions = requires
    requires = []
  { extension, suffix, prefix, indent, locale } = fileOptions || {}
  indent ||= 2
  extension ||= 'coffee'
  prefix ||= DEFAULT_PREFIX
  suffix ||= DEFAULT_SUFFIX
  if typeof indent is 'number'
    istr = ''
    istr += ' ' while istr.length < indent
    indent = istr
  requiresCode = []
  baseIndent = prefix.split("\n").pop().match(/^(\s+)/)?[1] || ''
  for {key, path} in requires.reverse()
    if extension is 'js'
      requiresCode.push """\n#{baseIndent}#{indent}"#{key}": require(\"#{path}\"),"""
    else
      requiresCode.push """#{baseIndent}#{indent}#{key}: require \"#{path}\"\n"""
  data = switch extension
    when 'js', 'json'
      '/* begin:generatedData */' + JSON.stringify(removeNull(i18n), null, indent)
      .replace(/\n/g, "\n#{baseIndent}")
      .replace(/^{/, "{#{requiresCode.join('')}") + '/* end:generatedData */'
    when 'cson', 'coffee'
      ret = requiresCode.join ''
      ret += indent + CSON.createCSONString(removeNull(i18n), {indent})
      .replace(/\n/g, "\n  ").replace('{}', '').replace(/#{([^\}]+)}/, '\\#\\{$1\\}')
      ret
  prefix.replace(/{{locale}}/g, locale) + data + suffix

# requirecallback = function(key, path, resolved)
# callback = function(data)
parseFile = (file, fileOptions, requireCallback, callback) ->
  fileOptions ||= {}
  dataString = file.toString('utf8')
    .replace(/\n\s{2}/gm, "\n")
    .replace(/^[.\s\S]*module\.exports\s*=/m, '')
    .replace(/^[.\s\S]*\/\*\sbegin:generatedData\s\*\//m, '')
    .replace(/\s*\/\*\send:generatedData\s\*\/[.\s\S]*$/m, '')
  requires = []
  re = /\s*\w+\s*:\s*require\s*\(?["'].+["']\)?/gm
  if m = dataString.match re
    for code in m
      [_code, indent, key, path] = code.match /\n?(\s*)(\w+)\s*:\s*require\s*\(?["'](.+)["']\)?/
      if indent.length > 0
        console.warn "Found indent level #{indent.length / 2}, but currently supporting required namespaces on top level m(_ _)m"
      requires.push {key, path}
    dataString = dataString.replace re, ''
  resolveNextRequire = ->
    if requires.length == 0
      try
        callback CSON.parse dataString
      catch e
        callback JSON.parse dataString
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
updateFile = (file, override, fileOptions, requireCallback, callback) ->
  requires = []
  parseFile file, fileOptions,
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
    file = createFile extend(yes, data, override), requires, fileOptions
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
