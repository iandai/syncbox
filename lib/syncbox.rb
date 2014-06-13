require_relative 'syncbox/store.rb'
require_relative 'syncbox/syncer.rb'

module Syncbox
  class Syncbox

    def self.start(store, store_config, local_directory)
      syncbox = Syncbox.new(store, store_config, local_directory)
      syncbox.start
    end
    
    # init a store instance
    #
    def initialize(store, store_config, local_directory)
      @local_directory = local_directory
      @store = Store.new(store, store_config)
    end

    # Init a Syncer object, and start syncing
    #
    def start
      syncer = Syncer.new(@local_directory, @store)
      syncer.sync
    end
    
  end
end

