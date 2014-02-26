require 'optparse'
require 'yaml'
require_relative 'syncbox/store.rb'
require_relative 'syncbox/syncer.rb'

module Syncbox
  class Syncbox

    def self.start      
      syncbox = Syncbox.new
      syncbox.start
    end
    
    # read config path from command line, and load configs
    # init a store instance
    #
    def initialize      
      config_file = option_parser[:config]
      @local_directory = read_config(config_file, "local_directory")
      config_s3 = read_config(config_file, "s3")
      @store = Store.new("S3", config_s3)
    end

    # Init a Syncer object, and start sync
    #
    def start
      syncer = Syncer.new(@local_directory, @store)
      syncer.sync
    end
    
  private
    def read_config(config_file, store)
      config = YAML.load_file(config_file)
      config[store]      
    end
    
    def option_parser   
      options = {}
      option_parser = OptionParser.new do |opts|
        opts.banner = 'This is help messages.'
        opts.on('-c file', '--config file', 'Pass-in config file path') do |value|
          options[:config] = value
        end
      end.parse!
      options
    end
  end
end


