module Huffman
  class FrequencyTable
    def initialize(file)
      @table = {}
      @file = file
    end

    def each
      @table.each { |k, v| yield k, v }
    end

    def [](i)
      @table[i]
    end

    def generate
      File.open(@file).each_line do |line|
        # Capturing similar consecutive characters
        line.gsub(/(.)\1*/) do
          @table[$1] ||= 0
          @table[$1] += $&.length
        end
      end
    end

  end
end

if __FILE__ == $0
  class App
    def initialize(file)
      @table = Huffman::FrequencyTable.new(file)
    end

    def run
      @table.generate
      @table.each { |k, v| puts "#{k}: #{v}"}
    end
  end

  require 'optparse'
  OptionParser.new do |opts|
    opts.on("-t", "--test", "Test the frequency table values") do |t|
      App.new(ARGV[0]).run
    end
  end.parse!
end
