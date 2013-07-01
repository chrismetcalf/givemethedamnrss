require 'bundler/setup'
require 'logger'

require './givemethedamnrss'

$stdout.sync = true

use Rack::CommonLogger

run GiveMeTheDamnRSS
