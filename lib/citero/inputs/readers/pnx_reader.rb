module Citero
  module Inputs
    module Readers
      class PnxReader
        require 'ox'

        def initialize(data)
          @allow = data
          Ox.default_options = Ox.default_options.merge({ skip: :skip_none })
          @data = Ox.parse(data)
        end

        def type
          @type ||= @data.locate("record/display/type")&.first&.text
        end

        def publisher
          @publisher = @data.locate("record/display/publisher")&.first&.text
        end

        def pub
          @publisher ||= @data.locate("record/addata/pub").flatten.collect {|d| d.text}.flatten
        end

        def cop
          @place_of_publication ||= @data.locate("record/addata/cop").flatten.collect {|d| d.text}.flatten
        end

        def issn
          @issn ||= @data.locate("record/addata/issn").flatten.collect {|d| d.text}.flatten
        end

        def eissn
          @eissn ||= @data.locate("record/addata/eissn").flatten.collect {|d| d.text}.flatten
        end

        def isbn
          @isbn ||= @data.locate("record/addata/isbn").flatten.collect {|d| d.text}.flatten
        end

        def title
          @title ||= @data.locate("record/display/title").flatten.collect {|d| d.text}.flatten
        end

        def publication_date
          @publication_date ||= [@data.locate("record/addata/date")].flatten.collect {|d| d&.nodes}.flatten
        end

        def journal_title
          @journal_title ||= @data.locate("record/addata/jtitle").flatten.collect {|d| d.text}.flatten
        end

        def date
          @date ||= [@data.locate("record/display/creationdate") , @data.locate("record/search/creationdate")].flatten.collect {|d| d&.nodes}.flatten
        end

        def language
          @language ||= @data.locate("record/display/language")&.first&.text
        end

        def edition
          @edition ||= @data.locate("record/display/edition")&.first&.text
        end

        def tags
          @tags ||= [
            @data.locate("record/search/subject")&.collect {|element| element&.nodes}.flatten,
            @data.locate("record/display/subject")&.collect {|element| element&.nodes}.flatten
          ].flatten
          return @tags unless @tags.empty?
        end

        def call_number
          @call_number ||= @data.locate("record/enrichment/classificationlcc")&.first&.text
        end

        def pnx_record_id
          @pnx_record_id ||= @data.locate("record/control/recordid")&.first&.text
        end

        def description
          @description ||= @data.locate("record/display/format")&.first&.text
        end

        def notes
          notes = @data.locate("record/display/description").collect{ |element|
            element = element.nodes while !element.is_a?(Array)
            element.collect{|val| val.is_a?(String) ? val : val.value }
          }.flatten

          @notes ||= notes
        end

        def pages
          @pages ||= @data.locate("record/display/format")&.first&.text
        end

        def identifier
          @identifier ||= @data.locate("record/display/identifier")&.first&.text
        end

        def creator
          @creator ||= @data.locate("record/display/creator")&.first&.text
        end

        def addau
          @addau ||= @data.locate("record/addata/addau")&.first&.text
        end

        def contributor
          @contributor ||= get_value_from_pnx("record/display/contributor")
        end

        def get_value_from_pnx(path)
          @data.locate(path)&.first&.text
        end
        private :get_value_from_pnx

        def method_missing(method_sym, *arguments, &block)
          method_str = method_sym.to_s
          if is_attribute_validator?(method_sym)
            !send(method_str.chomp('?').to_sym).nil?
          else
            super
          end
        end

        def respond_to?(method_sym, include_private = false)
          if is_attribute_validator?(method_sym)
            true
          else
            super
          end
        end

        def is_attribute_validator?(method_sym)
          method_sym.to_s[-1].eql?('?')
        end
        private :is_attribute_validator?
      end
    end
  end
end
