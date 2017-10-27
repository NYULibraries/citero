module Citero
  module Utils
    class NameFormatter
      attr_reader :first_name, :middle_name, :last_name
      def initialize(raw_name)
        return unless raw_name
        raw_name_array = raw_name.gsub(/\(.*\)/, "").gsub(",", ", ").gsub(/\s+/, " ").split
        # puts raw_name_array
        raw_name_array.each_with_index do |name, index|
          if (name.include?(",") && index == 0)
            @last_name = name.gsub(",", "")
          elsif (index == 0 && @last_name.nil?)
            @first_name = name.gsub(",", "")
          elsif (index == 1 && @first_name.nil? && @last_name)
            @first_name = name.gsub(",", "")
          elsif (index >= 1 && @first_name && index < raw_name_array.length - 1)
            @middle_name = (@middle_name ? "#{@middle_name} " : "") + name.gsub(",", "")
          elsif (@first_name && @middle_name && name.match(/[a-zA-Z]+/))
            @last_name = name.gsub(",", "")
          elsif (index > 1 && @first_name && @last_name)
            if (name.match(/[a-zA-Z\-'\.]+/))
              @middle_name = (@middle_name ? "#{middle_name} " : "") + name.gsub(",", "");
            elsif (name.match(/[a-zA-Z\.0-9]{1,4}/))
              @suffix = name;
            end
          end
          if (index == raw_name_array.length - 1 && !@last_name)
            if(!@middle_name)
              @last_name = name unless name == @first_name
            else
              @last_name = @middle_name.split.last
              @middle_name = (@middle_name.split  - @last_name.split).join
            end
          end
        end

        @first_name = nil   if first_name&.empty?
        @middle_name = nil  if middle_name&.empty?
        @last_name = nil    if last_name&.empty?
        @suffix = nil       if @suffix&.empty?

        @first_name = @first_name.strip   if first_name
        @middle_name = @middle_name.strip if middle_name
        @last_name = @last_name.strip     if last_name
        @suffix = @suffix.strip           if @suffix

      end
      def to_standardized
        str_builder = ""
        str_builder = "#{last_name.strip}, " if last_name
        str_builder = "#{str_builder}#{first_name.strip}" if first_name
        str_builder = "#{str_builder} #{middle_name.strip}" if middle_name
        str_builder
      end
    end
  end
end
