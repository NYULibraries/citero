module Citero
  class CSF
    extend Forwardable
    def_delegators :@data, :[], :[]=, :size, :each, :inspect, :to_s
    attr_reader :data
    alias_method :csf, :data

    def initialize(hash = nil)
      @data = Hash.new
      load_from_hash(hash) unless hash.nil?
    end

    def load_from_hash(hash)
      hash.each_pair do |key,value|
        next if value.nil?
        self.send(:[]=, key, value)
      end
    end

    def []=(key,value)
      @data[key] = element_or_list(@data[key], value)
    end

    private
    def element_or_list(new_value, old_value)
      temp_arr = [new_value, old_value].flatten.compact
      return temp_arr.first if temp_arr.size == 1
      return temp_arr
    end
  end
end
