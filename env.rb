base = __FILE__

while File.symlink?(base)
  base = File.expand_path(File.readlink(base), File.dirname(base))
end

app_path = File.expand_path(File.join(File.dirname(base)))
$LOAD_PATH.unshift(app_path)

require 'bundler'
require 'colorize'
require 'date'
require 'digest'
require 'epubinfo'
require 'fileutils'
require 'sequel'
require 'sucker_punch'
require 'sinatra/base'
require 'sinatra/json'
require 'yaml'

require 'db/environment'
require 'vendor/epubinfo/cover_patch'
require 'lib/logging/logger'
