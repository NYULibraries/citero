module Citero
  module Inputs
    module Readers
      class PnxReader
        require 'ox'
        def initialize(data)
          @data = Ox.parse(data)
        end

        def type
          @type ||= @data.locate("record/display/type")&.first&.text
        end

        def publisher
          @publisher = @data.locate("record/display/publisher")&.first&.text
        end

        def pub
          @publisher ||= @data.locate("record/addata/pub")&.first&.text
        end

        def cop
          @place_of_publication ||= @data.locate("record/addata/cop")&.first&.text
        end

        def issn
          @issn ||= @data.locate("record/addata/issn")&.first&.text
        end

        def eissn
          @eissn ||= @data.locate("record/addata/eissn")&.first&.text
        end

        def isbn
          @isbn ||= @data.locate("record/addata/isbn")&.first&.text
        end

        def title
          @title ||= @data.locate("record/display/title")&.first&.text
        end

        def publication_date
          @publication_date ||= @data.locate("record/addata/date")&.first&.text
        end

        def journal_title
          @journal_title ||= @data.locate("record/addata/jtitle")&.first&.text
        end

        def date
          @date ||= @data.locate("record/display/creationdate")&.first&.text || @data.locate("record/search/creationdate")&.first&.text
        end

        def language
          @language ||= @data.locate("record/display/language")&.first&.text
        end

        def edition
          @edition ||= @data.locate("record/display/edition")&.first&.text
        end

        def tags
          @tags ||= @data.locate("record/search/subject")&.first&.text || @data.locate("record/display/subject")&.first&.text
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
          @notes ||= @data.locate("record/display/description")&.first&.text
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
