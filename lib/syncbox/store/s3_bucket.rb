require 'aws-sdk'

module Syncbox
  class S3Bucket
  
    # Initializes a s3 bucket object
    #
    # @param [Hash] options
    #
    # options must include:
    # * access_key_id
    # * secret_access_key
    # * bucket_name
    #
    # Note: modify the local files, triggers upload.  
    #       Upload same name file, S3 will automatically replaced the original file.      
    #       Cancel the upload in the middle of uploading will not replace the originmal file. 
    # 
    def initialize(options)
      arguement_check(options)
      s3 = AWS::S3.new(:access_key_id => options["access_key_id"], :secret_access_key => options["secret_access_key"])
      bucket_name = options["bucket_name"]
      @bucket = s3.buckets[bucket_name]      
    end

    # Check bucket existance
    #
    # @return a boolean value
    #
    def exists?
      @bucket.exists?
    end
    
    # Uploads file to bucket
    #
    # @param [String] file_path 
    #
    # @return a public (not authenticated) URI::HTTPS URL for the object
    #
    def upload(file_path)
      file_name = File.basename(file_path)
      object = @bucket.objects[file_name]
      object.write(:file => file_path)
      object.public_url
    end

    # delete file from bucket
    #
    # @param [String] file_path 
    #
    # @return nil
    #
    def delete(file_path)
      file_name = File.basename(file_path)
      object = @bucket.objects[file_name]
      object.delete
    end
  
    # get file's etag
    #
    # @param [String] file_path
    #
    # @return etag
    #
    def etag(file_path)
      file_name = File.basename(file_path)
      object = @bucket.objects[file_name]
      object.etag.gsub('"', '')
    end
    
    # get bucket all file names
    #
    # @return file name array
    #
    def file_names
      file_names = []
      @bucket.objects.each do |obj|
        file_names << obj.key
      end
      file_names
    end
    
    
  private
    # check s3 arguments contains access_key_id, secret_access_key and bucket_name
    #
    def arguement_check(options)
      args = ["access_key_id", "secret_access_key", "bucket_name"]  
      args.each do |arg|
        begin
          options.fetch(arg)
        rescue KeyError
          raise ArgumentError, "Argument #{arg} is required."
        end
      end
    end
    
  end
end