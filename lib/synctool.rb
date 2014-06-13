require_relative 'syncbox/store.rb'
require 'digest/md5'

module Syncbox
  class Synctool
    
    def initialize(store, store_config, local_directory)
      @local_directory = local_directory
      @store = Store.new(store, store_config)
    end
        
    def compare(file_path)
      remote_digest = @store.etag(file_path)
      local_digest = Digest::MD5.hexdigest(File.read(file_path))
      (remote_digest == local_digest) ? true : false
    end

    def diff
      local_files = Dir.entries(@local_directory).select { |x| x != "." && x != ".." && x != ".DS_Store"}
      remote_files = @store.file_names
      added_files = local_files - remote_files
      removed_files = remote_files - local_files
      modified_files = []
      unchanged_files = (local_files + remote_files - added_files - removed_files).uniq
      unchanged_files.each do |file|  
        file_path = @local_directory + "/" + file
        modified_files << file unless compare(file_path)
      end

      {added_files: added_files, removed_files: removed_files, modified_files: modified_files}
    end
    
    def sync
      diff_files = diff
      
      if diff_files[:added_files]
        added_files = diff_files[:added_files]
        added_files.each do |file|
          @store.add(@local_directory + "/" + file)
        end
      end
      
      if diff_files[:added_files]
        modified_files = diff_files[:modified_files]
        modified_files.each do |file|
          @store.modify(@local_directory + "/" + file)
        end
      end
      
      if diff_files[:added_files]
        removed_files = diff_files[:removed_files]
        removed_files.each do |file|
          @store.delete(@local_directory + "/" + file)
        end
      end              
    end

  end
end

