module Citero
  module Utils
    class NameFormatter
      def initialize(raw_name)
        raw_name_array = raw_name.gsub(",", ", ").gsub(/\s+/, " ").split
        raw_name_array.each_with_index do |name, index|
          if (name.contains(",") && index == 0)
            @last_name = name.gsub(",", "")
          elsif (index == 0 && @last_name.nil?)
            @first_name = name.gsub(",", "")
          elsif (index == 1 && @first_name.nil? && @last_name)
            @first_name = name.gsub(",", "")
          elsif (index >= 1 && @first_name && index < raw_name_array.length - 1)
            @middle_name += (@middle_name ? "" : " ") + name.gsub(",", "")
          elsif (@first_name && @middle_name && name.matches(/[^0-9]+/))
            @last_name = name.gsub(",", "")
          elsif (index > 1 && @first_name && @last_name)
            if (name.matches(/[a-zA-Z\-'\.]+/))
              @middle_name += (@middle_name ? "" : " ") + name.gsub(",", "");
            elsif (name.matches(/[a-zA-Z\.0-9]{1,4}/))
              @suffix = name;
            end
          end
          if (index == raw_name_array.length - 1 && !@last_name)
            if(!@middle_name)
              @last_name = name
            else
              @last_name = @middle_name
            end
          end
        end
      end
    end
  end
end
