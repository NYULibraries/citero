module Citero
  module Inputs
    class PNX

      attr_reader :csf
      
      def initialize(raw_data)
        @pnx_reader = Citero::Inputs::Readers::PnxReader.new(raw_data)
        construct_csf
      end

      private

      def construct_csf
        return @csf unless @csf.nil?
        @csf = CSF.new
        add_item_type
        parse_and_add_creators
        add_identifiers
        parse_and_add_publisher
        add_all_other_fields
        @csf
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
        @csf.add("itemType", get_item_type(@pnx_reader.type))
      end

      def parse_and_add_creators
        contributors = []

        creators = @pnx_reader.creator || @pnx_reader.contributor
        contributors = @pnx_reader.contributor unless creators.empty?

        creators = @pnx_reader.addau if (@pnx_reader.creator.empty? && @pnx_reader.contributor.empty?)

        add_creators(creators, "author")
        add_creators(contributors, "contributor")
      end

      def add_creators(creators,creator_type)
        if (!creators.empty?)
          creators.split(";").each do |name|
            @csf.add(creator_type, name.strip)
          end
        end
      end

      def add_identifiers
        if @pnx_reader.identifier?
          identifiers =  @pnx_reader.identifier.split(";")
          identifiers.each do |id|
            if(id.include? "isbn")
              @csf.add("isbn", id.match(/[0-9]+/)[0])
            else
              @csf.add("issn", id.match(/[0-9]+/)[0])
            end
          end
        end
      end

      def parse_and_add_publisher
        if (!@pnx_reader.pub? && !@pnx_reader.cop? && @pnx_reader.publisher)
          if @pnx_reader.publisher.contains? ":"
            pub_place =  @pnx_reader.publisher.split(":")
            add_publisher_and_place(pub_place.first, pub_place.second)
          else
            add_publisher_and_place(@pnx_reader.publisher)
          end
        else
          add_publisher_and_place(@pnx_reader.pub, @pnx_reader.pub)
        end
      end

      def add_publisher_and_place(publisher = nil, place = nil)
        @csf.add("publisher", publisher) if publisher
        @csf.add("place", place) if place
      end

      def qualified_method_names
        @qualified_method_names ||= {
          "publicationDate" => "publication_date",
          "journalTitle" => "journal_title",
          "callNumber" => "call_number",
          "pnxRecordId" => "pnx_record_id",
          "pages" => "pages",
          "title" => "title",
          "date" => "date",
          "language" => "language",
          "edition" => "edition",
          "tags" => "tags",
          "description" => "description",
          "notes" => "notes"
        }
      end

      def add_all_other_fields
        qualified_method_names.each do |standard_form, method_name|
          @csf.add(standard_form, @pnx_reader.send(method_name.to_sym)) if @pnx_reader.send("#{method_name}?".to_sym)
        end
      end
    end
  end
end
