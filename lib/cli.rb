require 'optparse'

module Syncbox
  class Options

    def self.parse_options
      options = {}
      option_parser = OptionParser.new do |opts|
        opts.banner = 'Usage: syncbox sync|diff [options].'
        opts.on('-c file', '--config file', 'config file path') do |value|
          options[:config] = value
        end
      end
      
      begin 
        option_parser.parse!
      rescue => e
         puts e
         exit!
      end

      if !options[:config]
        puts "Please specify config file path."
        exit!
      elsif !File.exists?(options[:config])
        puts "File path does not exist."
        exit!
      end
      
      options
    end

  end
end

