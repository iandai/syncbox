require 'spec_helper'


describe PrettyTable do

  before(:each) do
    header = ["File Name", "Local", "S3"]
    contents = [["1", "XXXXXXXXXXXXXXXXXX-2012-01-01.json", "XXXXXXXXXXXXXXXXXX-2012-01-01.json"],["2", "XXXXXXXXXXXXXXXXXX-2012-01-01.json", "XXXXXXXXXXXXXXXXXX-2012-01-01.json"]]
    @pt = PrettyTable.new(header, contents)
  end
  
  it "should have a total array generated from header and content" do
    @pt.instance_variable_get(:@total).should eql [["File Name", "Local", "S3"],["1", "XXXXXXXXXXXXXXXXXX-2012-01-01.json", "XXXXXXXXXXXXXXXXXX-2012-01-01.json"],["2", "XXXXXXXXXXXXXXXXXX-2012-01-01.json", "XXXXXXXXXXXXXXXXXX-2012-01-01.json"]]
  end
  
  it "should return the size of array which own the most elements" do
    @pt.max_column.should eql 3
  end
  
  it "should return an array which contains widthest size of each column plus 5" do
    @pt.cell_width.should eql [14, 39, 39]
  end
  
  it "should print the table properly on the screen" do 
    @pt.print 
  end
  
end