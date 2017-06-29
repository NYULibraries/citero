module Citero
  class CSF
    attr_reader :raw_data
    def initialize()
      @csf_hash = Hash.new
    end

    def load_from_hash(hash)
      hash.keys.each do |key|
        value = hash[key]
        @csf_hash[key] = [@csf_hash[key], value].flatten.compact
        @csf_hash[key] = @csf_hash[key].first if @csf_hash[key].size == 1
      end
    end

    def load_from_yaml(data)
      load_from_hash(YAML::parse(data))
    end

    def csf
      self
    end

    def [](param)
      @csf_hash[param]
    end

    def inspect
      @csf_hash
    end

    def to_s
      hash = @csf_hash.dup
      hash.each do |k,v|
        v = [v].flatten.compact
        # p v
        v = v.collect {|a| a.gsub('.','\.').gsub(',','\,')}
        v = v.first if v.size == 1
        hash[k] = v
      end
      hash
    end
  end
end
