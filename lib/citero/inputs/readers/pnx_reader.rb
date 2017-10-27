module Citero
  module Inputs
    module Readers
      class PnxReader
        require 'ox'

        XML_DECLARATION_START = "<?xml"
        XML_DECLARATION = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"

        def initialize(data)
          Ox.default_options = Ox.default_options.merge({ skip: :skip_none })
          parse_data = data
          parse_data = "#{XML_DECLARATION}#{data}" unless data.start_with?(XML_DECLARATION_START)
          @data = Ox.parse(parse_data)
        end

        def type
          @type ||=           get_value_from_pnx("record/display/type")
        end

        def publisher
          @publisher =        get_value_from_pnx("record/display/publisher")
        end

        def language
          @language ||=       get_value_from_pnx("record/display/language")
        end

        def edition
          @edition ||=        get_value_from_pnx("record/display/edition")
        end

        def pages
          @pages ||=          get_value_from_pnx("record/display/format")
        end

        def identifier
          @identifier ||=     get_value_from_pnx("record/display/identifier")
        end

        def creator
          @creator ||=        get_value_from_pnx("record/display/creator")
        end

        def addau
          @addau ||=          get_value_from_pnx("record/addata/addau")
        end

        def contributor
          @contributor ||=    get_value_from_pnx("record/display/contributor")
        end

        def call_number
          @call_number ||=    get_value_from_pnx("record/enrichment/classificationlcc")
        end

        def pnx_record_id
          @pnx_record_id ||=  get_value_from_pnx("record/control/recordid")
        end

        def description
          @description ||=    get_value_from_pnx("record/display/format")
        end

        def pub
          @publisher ||=            get_all_values_from_pnx("record/addata/pub"    )
        end

        def cop
          @place_of_publication ||= get_all_values_from_pnx("record/addata/cop"    )
        end

        def issn
          @issn ||=                 get_all_values_from_pnx("record/addata/issn"   )
        end

        def eissn
          @eissn ||=                get_all_values_from_pnx("record/addata/eissn"  )
        end

        def isbn
          @isbn ||=                 get_all_values_from_pnx("record/addata/isbn"   )
        end

        def title
          @title ||=                get_all_values_from_pnx("record/display/title" )
        end

        def journal_title
          @journal_title ||=        get_all_values_from_pnx("record/addata/jtitle" )
        end

        def publication_date
          @publication_date ||= [@data.locate("record/addata/date")].flatten.collect {|d| d&.nodes}.flatten
        end

        def date
          @date ||= [@data.locate("record/display/creationdate") , @data.locate("record/search/creationdate")].flatten.collect {|d| d&.nodes}.flatten
        end

        def tags
          @tags ||= [
            @data.locate("record/search/subject")&.collect {|element| element&.nodes}.flatten,
            @data.locate("record/display/subject")&.collect {|element| element&.nodes}.flatten
          ].flatten
          return @tags unless @tags.empty?
        end

        def notes
          notes = @data.locate("record/display/description").collect{ |element|
            element = element.nodes while !element.is_a?(Array)
            element.collect{|val| val.is_a?(String) ? val : val.value }
          }.flatten

          @notes ||= notes
        end

        private

        def get_value_from_pnx(path)
          @data.locate(path)&.first&.text
        end

        def get_all_values_from_pnx(path)
          @data.locate(path).flatten.collect {|d| d.text}.flatten
        end

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
      end
    end
  end
end
