require_relative 'store/s3_bucket.rb'

module Syncbox
  class Store
    
    STORES = { "S3" => "S3Bucket", "Glacier" => "Glacier"}
  
    # Initializes a store object
    #
    # @param [String] store
    # @param [HASH] options
    #
    def initialize(store, options={})
      raise ArgumentError, "Store #{store} is not supported." unless STORES.fetch(store)
      class_name = STORES[store]
      @store = Object.const_get("Syncbox").const_get(class_name).new(options)
    end

    # Add file to store.
    #
    # @param [String] file_path 
    #
    # @return a public (not authenticated) URL for the object
    #
    def add(file_path)
      @store.upload(file_path)
    end
  
    # delete file from store.
    #
    # @param [String] file_path 
    #
    # @return nil
    #
    def delete(file_path)
      @store.delete(file_path)
    end

    alias modify add
  
  
    # get etag of file from store.
    #
    # @param [String] file_path 
    #
    # @return etag string
    #
    def etag(file_path)
      @store.etag(file_path)
    end
    
    
    # get all file names from store.
    #
    # @return file name array
    #
    def file_names
      @store.file_names
    end
    
      
  end
end