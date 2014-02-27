require 'spec_helper.rb'
require 'yaml'

describe Syncbox::S3Bucket do

  before(:each) do
    @file_path = "#{File.dirname(__FILE__)}/../../../README.md"
    config_file = YAML.load_file('spec/syncbox/store/s3.yml')
    @config = config_file["s3"]
    
    # AWS::S3 class should response to :new method
    s3 = an_instance_of(AWS::S3)
    AWS::S3.stub(:new).with(:access_key_id => @config["access_key_id"], :secret_access_key => @config["secret_access_key"]).and_return(s3)
    
    # build bucket object with method exists?
    bucket = an_instance_of(AWS::S3::Bucket)
    s3.stub_chain(:buckets, :[]).and_return(bucket)
    bucket.stub(:exists?).and_return(true)
    
    # build s3 object with method upload and delete
    s3_obj = an_instance_of(AWS::S3::S3Object)
    bucket.stub_chain(:objects, :[]).and_return(s3_obj)
    s3_obj.stub(:write).with(:file => @file_path)   
    @test_url = URI::HTTPS.build({:host => 'www.example.com', :path => '/foo/bar'})
    s3_obj.stub(:public_url).and_return(@test_url)
    s3_obj.stub(:delete).and_return(nil)
  end
  
  it "initialize s3 bucket with " do
    s3b = Syncbox::S3Bucket.new(@config)
    expect(s3b).to be_an_instance_of(Syncbox::S3Bucket)
  end
    
  it "initialize s3 bucket without access_key_id in arguments" do
    @config.delete("access_key_id")
    expect{Syncbox::S3Bucket.new(@config)}.to raise_error(ArgumentError, "Argument access_key_id is required.")
  end
  
  it "initialize s3 bucket without secret_access_key in arguments" do
    @config.delete("secret_access_key")
    expect{Syncbox::S3Bucket.new(@config)}.to raise_error(ArgumentError, "Argument secret_access_key is required.")
  end
  
  it "initialize s3 bucket without bucket_name in arguments" do
    @config.delete("bucket_name")
    expect{Syncbox::S3Bucket.new(@config)}.to raise_error(ArgumentError, "Argument bucket_name is required.")
  end
  
  it "check the existance of bucket" do  
    s3b = Syncbox::S3Bucket.new(@config)
    expect(s3b.exists?).to be true
  end
     
  it "upload file to s3" do
    s3b = Syncbox::S3Bucket.new(@config)
    public_url = s3b.upload(@file_path)
    expect(public_url).to eq(@test_url)
  end
  
  it "delete file from s3" do   
    s3b = Syncbox::S3Bucket.new(@config)
    expect(s3b.delete(@file_path)).to be_nil
  end
  
end
