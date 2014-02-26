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
      remote_accessible_check
    end
    
    # Uploads file to bucket.
    #
    # @param [String] file_path 
    #
    # @return a public (not authenticated) URL for the object
    #
    def upload(file_path)
      file_name = File.basename(file_path)
      object = @bucket.objects[file_name]
      object.write(:file => file_path)
      object.public_url
    end

    # delete file from bucket.
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
  
  
  private
    # check s3 arguments contains access_key_id, secret_access_key and bucket_name
    #
    def arguement_check(options)
      begin
        options.fetch("access_key_id") && options.fetch("secret_access_key") && options.fetch("bucket_name")
      rescue KeyError
        raise ArgumentError, "The access_key_id, secret_access_key and bucket_name options are required."
      end
    end

    # check S3 access_key_id, secret_access_key is valid and bucket_name exists.
    #
    def remote_accessible_check
      begin
        raise ArgumentError, "Bucket doesn't exsit."  unless @bucket.exists?
      rescue AWS::S3::Errors::InvalidAccessKeyId
        raise ArgumentError, 'AWS Access Key Id does not exist in our records.'
      rescue AWS::S3::Errors::SignatureDoesNotMatch
        raise ArgumentError, 'The request signature we calculated does not match the signature you provided. Check your key and signing method.'
      end
    end
  end
end