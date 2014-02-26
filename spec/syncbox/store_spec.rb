require 'spec_helper.rb'

describe Syncbox::Store do
  
  before(:each) do
    config_file = YAML.load_file('spec/syncbox/store/s3.yml')
    @config = {
      "access_key_id" => config_file["s3"]["access_key_id"], 
      "secret_access_key" => config_file["s3"]["secret_access_key"],
      "bucket_name" => config_file["s3"]["bucket_name"],
    }
    @file_path = "#{File.dirname(__FILE__)}/store/s3.yml"
  end
  
  it "initialize a store" do
    store = Syncbox::Store.new("S3", @config)
    expect(store).to be_an_instance_of(Syncbox::Store)
  end
  
  it "initialize a store without key access_key_id in options" do
    @config.delete("access_key_id")
    expect { Syncbox::Store.new("S3", @config) }.to raise_error(ArgumentError, "The access_key_id, secret_access_key and bucket_name options are required.")    
  end
  
  it "initialize a store without key secret_access_key in options" do
    @config.delete("secret_access_key")
    expect { Syncbox::Store.new("S3", @config) }.to raise_error(ArgumentError, "The access_key_id, secret_access_key and bucket_name options are required.")    
  end
  
  it "initialize a store without key bucket_name in options" do
    @config.delete("bucket_name")
    expect { Syncbox::Store.new("S3", @config) }.to raise_error(ArgumentError, "The access_key_id, secret_access_key and bucket_name options are required.")    
  end
  
  it "add file to store" do
    store = Syncbox::Store.new("S3", @config)
    public_url = store.add(@file_path)
    expect(public_url).to be_an_instance_of(URI::HTTPS)
  end
  
  it "modify file to store" do
    store = Syncbox::Store.new("S3", @config)
    public_url = store.modify(@file_path)
    expect(public_url).to be_an_instance_of(URI::HTTPS)
  end
  
  it "delete file to store" do
    store = Syncbox::Store.new("S3", @config)
    store.delete(@file_path)
  end
  
end