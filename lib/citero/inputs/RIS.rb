module Citero
  module Inputs
    class RIS
      def initialize(raw_data)
        @raw_data = raw_data
        CSF.new("")
      end
    end
  end
end
