module Citero
  module Inputs
    class RIS
      attr_reader :csf

      def initialize(raw_data)
        @raw_data = raw_data
        construct_csf
      end

      private

      def construct_csf
        return @csf if @csf
        # hush = Hash.new
        @csf = CSF.new
        @raw_data.each_line do |line|
          tag,value = line.split("-").collect{|txt| txt.strip}
          break if tag.eql?("ER")
          puts "#{tag} => #{value}"
          if value.blank?
            @value = "#{@value}\n#{tag}"
          else
            @tag = tag
            @value = value
          end
          @csf.add(@tag,@value)
        end
        p @csf.to_s
        # @csf

        @csf = CSF.new
      end
    end
  end
end
