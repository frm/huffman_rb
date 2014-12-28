#!/usr/bin/env ruby

module Huffman
  class Code
    require 'priority_queue'

    def initialize(table)
      @code = {}
      @queue = PriorityQueue.new
      @table = table
    end

    def each
      @code.each { |k, v| yield k, v }
    end

    def generate
      self.enqueue
      while @queue.length > 1
        # Retrieving the values with the least occurences
        zero_bit_chars, zero_bit_occurences = @queue.delete_min
        one_bit_chars, one_bit_occurences = @queue.delete_min

        # Adding the corresponding bits to the code
        zero_bit_chars.each { |c| add_bit(c, '0') }
        one_bit_chars.each { |c| add_bit(c, '1') }

        # We are now reinserting the groups, with the sum of occurences
        @queue.push(zero_bit_chars + one_bit_chars, zero_bit_occurences + one_bit_occurences)
      end

      @code
    end

    protected

    def enqueue
      # Enqueuing is made carrying the number of occurences as value
      @table.each { |key, value| @queue.push([key], value)}
    end

    def add_bit(char, bit)
      @code[char] ||= ""
      @code[char].insert(0, bit)
    end
  end
end

if __FILE__ == $0
  class App
    require_relative 'frequency_table.rb'
    attr_reader :code

    def initialize(file)
      @table = Huffman::FrequencyTable.new(file)
    end

    def run
      @table.generate
      @code = Huffman::Code.new(@table)
      @code.generate
    end
  end

  require 'optparse'
  OptionParser.new do |opts|
    app = App.new(ARGV[1])
    app.run

    opts.on("-v", "--verbose", "Print the result code") do |t|
      app.code.each { |k, v| puts "#{k}: #{v}"}
    end
  end.parse!
end
