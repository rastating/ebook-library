#\ -s puma -q

require_relative 'env'

require 'app/jobs/epub_scan_job'
require 'app/controllers/application'
require 'app/controllers/authors'
require 'app/controllers/session'
require 'app/controllers/books'

map('/')            { run EBL::Controllers::Application }
map('/api/authors') { run EBL::Controllers::Authors }
map('/api/session') { run EBL::Controllers::Session }
map('/api/books')   { run EBL::Controllers::Books }
