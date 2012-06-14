require "fe/version"
require "active_record"
require 'active_record/fixtures'
require "active_support/all"
require "set" # introduced in Ruby standard lib in 1.9
require "fileutils"
module Fe
  extend ActiveSupport::Autoload
  autoload :Extractor
  autoload :YmlWriter
  autoload :Rebuilder
  autoload :Manifest

  # global configuration
   
  @@fixtures_root = 'test/fe_fixtures'
  mattr_accessor :fixtures_root

  # Top-level API methods
  class << self
    def extract(*args)
      extractor = Fe::Extractor.new(*args)
      extractor.write_fixtures
      extractor
    end
    # Algorithm Overview
    # * Resolve the query if it's been given as a string
    # * Instantiate underlying object with the resolved rows
    #   to do the dirty work
    # * Spit out some stats about what just happened
    #def extract(query,*args)
      #options = args.extract_options!
      #if query.kind_of? String
        #query_code = query
        #query_results = Array(eval(query))
      #else
        #query_code = "load code not specified as string, you won't be able to reload this fixture from another database"
        #query_results = Array(query)
      #end
      #extractor = Fe::Extractor.new
      #extractor.extract_code = query_code
      #extractor.input_array = query_results
      #yml_writer = Fe::YmlWriter.new(extractor, 
                                     #options[:name] || Time.now.strftime("%Y_%m_%d_%H_%M_%S"),
                                     #self.fixtures_root)
      #yml_writer.write
      #extractor.write_manifest
      #yml_writer.stats_hash
    #end

    def load_db(extract_name)
      fixture_path_for_extract = File.join(Fe.fixtures_root,extract_name.to_s)
      manifest = Fe::Manifest.new(fixture_path_for_extract)
      manifest.load
      manifest.mappings.each_pair do |key,hash|
        ActiveRecord::Fixtures.create_fixtures(fixture_path_for_extract, hash['table_name'])
      end
    end
    def rebuild(extract_name)
      
    end
  end
  # Internalish API methods used to support the top-level ones
  class << self
  end
end
