module Citero
  module Inputs
    class Pnx

      attr_reader :csf

      def initialize(raw_data)
        @pnx_reader = Citero::Inputs::Readers::PnxReader.new(raw_data)
        construct_csf
        @csf
      end

      private

      def construct_csf
        return @csf unless @csf.nil?
        @csf = CSF.new
        @hash = {}
        add_item_type
        parse_and_add_creators
        parse_and_add_publisher
        pages
        add_identifiers
        add_all_other_fields
        @hash['importedFrom'] = 'PNX'
        @csf.load_from_hash(@hash)
      end


      def item_type_conversion_hash
        @item_type_conversion_hash ||= {
          "audio"   =>    "audioRecording",
          "video"   =>    "videoRecording",
          "article" =>    "journalArticle",
          "books"   =>    "book",
          "book"    =>    "book",
          "report"  =>    "report",
          "webpage" =>    "webpage",
          "journal" =>    "journal",
          "map"     =>    "map",
          "thesis"  =>    "thesis"
        }
      end

      def get_item_type(raw_type)
        return item_type_conversion_hash[raw_type.downcase] if item_type_conversion_hash.include? raw_type.downcase
        return 'document'
      end

      def add_item_type
        @hash["itemType"] = get_item_type(@pnx_reader.type || '')
      end

      def parse_and_add_creators
        contributors = []

        creators = @pnx_reader.creator || @pnx_reader.contributor
        contributors = @pnx_reader.contributor if !@pnx_reader.creator.nil?

        creators = @pnx_reader.addau if (@pnx_reader.creator.to_s.empty? && @pnx_reader.contributor.to_s.empty?)
        add_creators(creators, "author")
        add_creators(contributors, "contributor")
      end

      def add_creators(creators,creator_type)
        if (creators && !creators.empty?)
          creators.split(";").each do |name|
            @hash[creator_type] = [@hash[creator_type], name.strip].flatten.compact
          end
        end
      end

      def add_identifiers
        if @pnx_reader.identifier?
          identifiers =  @pnx_reader.identifier.split(";")
          identifiers.each do |id|
            if(id.include? "isbn")
              @hash['isbn'] = [@hash['isbn'], id.scan(/[0-9]+/).to_a.join].flatten.compact
            else
              @hash['issn'] = [@hash['issn'], id.scan(/[0-9]+/).to_a.join].flatten.compact
            end
          end
        else
          @hash['eissn'] = @pnx_reader.eissn unless @pnx_reader.eissn.empty?
          @hash['issn'] = [@hash['issn'], @pnx_reader.issn].flatten.compact unless @pnx_reader.issn.empty?
          @hash['isbn'] = [@hash['isbn'], @pnx_reader.isbn].flatten.compact unless @pnx_reader.isbn.empty?
        end
      end

      def parse_and_add_publisher
        if (@pnx_reader.pub.empty? && @pnx_reader.cop.empty? && @pnx_reader.publisher)
          if @pnx_reader.publisher.include? " : "
            pub_place =  @pnx_reader.publisher.split(" : ",2).map(&:strip)
            add_publisher_and_place(nil, pub_place.first)
          else
            add_publisher_and_place(@pnx_reader.publisher)
          end
        else
          add_publisher_and_place(@pnx_reader.pub, @pnx_reader.cop)
        end
      end

      def add_publisher_and_place(publisher = nil, place = nil)
        @hash['publisher'] = publisher if publisher
        @hash['place'] = place if place
      end

      def pages
        return unless @pnx_reader.pages
        raw_pages = @pnx_reader.pages.gsub(/[\(\)\[\]]/, "").gsub(/\D/, " ").strip()
        @hash['numPages'] = raw_pages.split(" ").first unless raw_pages.empty?
      end

      def qualified_method_names
        @qualified_method_names ||= {
          "title" => "title",
          "publicationDate" => "publication_date",
          "journalTitle" => "journal_title",
          "date" => "date",
          "language" => "language",
          "edition" => "edition",
          "tags" => "tags",
          "callNumber" => "call_number",
          "pnxRecordId" => "pnx_record_id",
          "description" => "description",
          "notes" => "notes"
        }
      end

      def add_all_other_fields
        qualified_method_names.each do |standard_form, method_name|
          @hash[standard_form] = @pnx_reader.send(method_name.to_sym) if @pnx_reader.send("#{method_name}?".to_sym)
        end
      end
    end
  end
end
