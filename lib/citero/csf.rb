module Citero
  class CSF
    attr_reader :raw_data
    def initialize(data=nil)
      raw_data = data
      @csf_hash = Hash.new
      csf_string_to_obj(data) if data.is_a? String
      @csf_hash = data if data.is_a? Hash
    end

    def csf
      self
    end


    #better names
    def add(key,value)
      if @csf_hash.include? key
        if @csf_hash[key].kind_of?(Array)
          @csf_hash[key] << value unless @csf_hash[key].include? value
        else
          original_value = @csf_hash[key]
          @csf_hash[key] = [original_value]
          @csf_hash[key] << value unless @csf_hash[key].include? value
        end
      else
        @csf_hash[key] = value
      end
    end

    def [](param)
      @csf_hash[param]
    end

    def inspect
      @csf_hash
    end

    def to_s
      @csf_hash
    end

    def csf_string_to_obj(data)
      lines = data.split("\n")
      # itemType: book
      # author: hannan; barnaby
      # author: eric
      # fix for semicolons
      lines.each do |line|
        field, value = line.split(':').collect{|str| str.strip }
        add(field,value)
      end
    end
  end

end
