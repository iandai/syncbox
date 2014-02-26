require_relative 'store.rb'
require 'listen'

module Syncbox  
  class Syncer
 
    # Initializes listener
    #
    # @param [String] local_directory
    # @param [Store] store
    #
    # Note: raise arguement error when local_directory does not exist.
    def initialize(local_directory, store)
      raise ArgumentError, "Local directory #{local_directory} does not exist." unless Dir.exists?(local_directory)
      @local_directory = local_directory    
      @store = store
      @listener = Listen.to(local_directory).latency(0.1)
    end
    
    # Listen to local directory
    # Sync local action to remote store
    #
    def sync
      callback = Proc.new do |modified, added, removed|
        added && added.each do |add_file|
          @store.add(@local_directory + "/" + add_file)
        end
        modified && modified.each do |modified_file|
          @store.modify(@local_directory + "/" + modified_file)
        end
        removed && removed.each do |remove_file|
          @store.remove(@local_directory + "/" + remove_file)
        end
      end
      @listener.change(&callback)     # convert the callback to a block and register it
      @listener.start!                # have to use !
    end

  end
end