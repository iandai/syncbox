require 'spec_helper.rb'

describe Syncbox::Store do
  
  before(:each) do
    config_file = YAML.load_file('spec/syncbox/store/s3.yml')
    @config = config_file["s3"]
    @file_path = "#{File.dirname(__FILE__)}/store/s3.yml"
  end
  
  it "initialize a store" do
    store = Syncbox::Store.new("S3", @config)
    expect(store).to be_an_instance_of(Syncbox::Store)
  end
  
  # stub upload method for s3 object
  it "add file to store" do
    test_url = URI::HTTPS.build({:host => 'www.example.com', :path => '/foo/bar'})    
    Syncbox::S3Bucket.any_instance.stub(:upload).and_return(test_url)
  
    store = Syncbox::Store.new("S3", @config)
    public_url = store.add(@file_path)
    expect(public_url).to eq(test_url)
  end
  
  it "modify file to store" do
    store = Syncbox::Store.new("S3", @config) 
    expect(store.method(:add)).to eq(store.method(:modify))
  end
  
  it "delete file to store" do
    Syncbox::S3Bucket.any_instance.stub(:delete).and_return(nil)
    store = Syncbox::Store.new("S3", @config)
    expect(store.delete(@file_path)).to be_nil
  end
  
end
