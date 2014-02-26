class PrettyTable  
  
  # header is an array, and content is an two level array
  #
  def initialize(header, content)
    @total = total(header, content)
  end
  
  def total(header, content)
    total = []
    total << header
    total = total +  content
  end
  
  def max_column
    @total.max_by {|x| x.size}.size
  end
  
  def cell_width
    width = []  
    for i in 0...max_column
      width << @total.map {|x| x[i].size}.max + 5
    end
    width
  end

  def print
    @total.each do |row|
      for i in 0...max_column-1
        printf "%-#{cell_width[i]}s ", row[i]
      end
      printf "%-#{cell_width[max_column-1]}s \n", row[max_column-1]
    end
  end  
end




# header = ["File Name", "Local", "S3"]
# contents = [["1", "XXXXXXXXXXXXXXXXXX-2012-01-01.json", "XXXXXXXXXXXXXXXXXX-2012-01-01.json"],["2", "XXXXXXXXXXXXXXXXXX-2012-01-01.json", "XXXXXXXXXXXXXXXXXX-2012-01-01.json"]]
# pt = PrettyTable.new(header, contents)
# pt.print