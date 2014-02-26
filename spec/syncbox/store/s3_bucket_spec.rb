require 'spec_helper.rb'
require 'yaml'

describe Syncbox::S3Bucket do
  
  before(:each) do
    config_file = YAML.load_file('spec/syncbox/store/s3.yml')
    @config = {
      "access_key_id" => config_file["s3"]["access_key_id"], 
      "secret_access_key" => config_file["s3"]["secret_access_key"],
      "bucket_name" => config_file["s3"]["bucket_name"],
    }
  end
  
  it "initialize s3 bucket" do
    s3b = Syncbox::S3Bucket.new(@config)
    expect(s3b).to be_an_instance_of(Syncbox::S3Bucket)
  end
  
  it "initialize s3 bucket with wrong access_key_id" do
    @config["access_key_id"] = @config["access_key_id"] + "1"
    expect { Syncbox::S3Bucket.new(@config) }.to raise_error(ArgumentError, "AWS Access Key Id does not exist in our records.")
  end
  
  it "initialize s3 bucket with wrong secret_access_key" do
    @config["secret_access_key"] = @config["secret_access_key"] + "1"
    expect { Syncbox::S3Bucket.new(@config) }.to raise_error(ArgumentError, "The request signature we calculated does not match the signature you provided. Check your key and signing method.")
  end
  
  it "initialize s3 bucket with wrong bucket-name" do
    @config["bucket_name"] = @config["bucket_name"] + Time.now.to_i.to_s
    expect { Syncbox::S3Bucket.new(@config) }.to raise_error(ArgumentError, "Bucket doesn't exsit.")
  end
  
  it "upload file to s3" do
    s3b = Syncbox::S3Bucket.new(@config)
    public_url = s3b.upload("#{File.dirname(__FILE__)}/s3.yml")
    expect(public_url).to be_an_instance_of(URI::HTTPS)
  end
  
  it "delete file from s3" do
    s3b = Syncbox::S3Bucket.new(@config)
    s3b.delete("#{File.dirname(__FILE__)}/s3.yml")
  end
  
end
