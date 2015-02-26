CSON = require 'cson'
path = require 'path'

loadFixture = (path) ->
  CSON.load "#{__dirname}/fixtures/#{path}.cson"

module.exports = {loadFixture}
