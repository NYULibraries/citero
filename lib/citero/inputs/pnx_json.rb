module Citero
  module Inputs
    class PnxJson

      attr_reader :csf

      def initialize(raw_data)
        @json = raw_data
        to_csf
        @csf
      end

      private

      def to_csf
        return @csf unless @csf.nil?
        @csf = CSF.new
        @hash = {}
        add_item_type
        parse_and_add_creators
        parse_and_add_publisher
        add_pages
        add_isbn
        add_issn
        add_eissn
        add_all_other_fields
        add_imported_from
        @csf.load_from_hash(@hash)
      end

      private

      def item_type_conversion_hash
        @item_type_conversion_hash ||= {
          #"audio"   =>    "audioRecording",
          #"video"   =>    "videoRecording",
          "article" =>    "journalArticle",
          "books"   =>    "book",
        }
      end

      def item_type_conversion_array
        @item_type_conversion_array ||= [
          "book",
          "report",
          "webpage",
          "journal",
          "map",
          "thesis",
          "database",
          "archives",
          "audio",
          "equipment",
          "geospatial_data",
          "image",
          "other",
          "score",
          "software",
          "statistical_data_set",
          "text_resource",
          "video",
          "website",
        ]
      end

      def qualified_method_names
        @qualified_method_names ||= {
          "title" => "title",
          "publicationDate" => "publicationDate",
          "journalTitle" => "journalTitle",
          "date" => "date",
          "language" => "languageId",
          "edition" => "edition",
          "tags" => "subject",
          "callNumber" => "callNumber",
          "pnxRecordId" => "pnxId",
          "description" => "description",
          "notes" => "notes"
        }
      end

      def get_item_type(raw_item_type)
        raw_item_type.downcase!
        return raw_item_type if item_type_conversion_array.include?(raw_item_type)
        return item_type_conversion_hash[raw_item_type] if item_type_conversion_hash.include?(raw_item_type)
        return 'document'
      end

      def add_item_type
        type =  @json["type"] || @json["@TYPE"] || 'document'
        @hash["itemType"] = get_item_type(type)
      end


      def parse_and_add_creators(creators=[],contributors=[])
        # Attempt to add creator from creator field
        creators = creators.push(@json["creator"]).compact
        # If can't find creator, treat contributor as creator
        if creators.empty?
          creators = creators.push(@json["contributor"]).compact
        # If we already have a creator, add contributors as contributors
        else
          contributors = [@json["contributor"]].compact 
        end
        # If we got here and have no creators or contributors try addau field
        if (creators.empty? && contributors.empty?)
          creators = creators.push(@json["addau"]).compact
        end

        add_creators(creators.flatten, "author")
        add_creators(contributors.flatten, "contributor")
      end

      def add_creators(creators,creator_type)
        if (creators && !creators.empty?)
          creators.each do |name|
            @hash[creator_type] = [@hash[creator_type], name.strip].flatten.compact
          end
        end
      end

      def parse_and_add_publisher(publishers=[])
        publishers.push(@json["publisher"])
        return if publishers.compact.empty?
        publishers.each do |json_pub|
          if json_pub.include? " : "
            pub_place, publisher = json_pub.split(" : ",2).map(&:strip)
            add_publisher_and_place(publisher, pub_place)
          else
            add_publisher_and_place(json_pub)
          end
        end
      end

      def add_publisher_and_place(publisher = nil, place = nil)
        @hash['publisher'] = publisher if publisher
        @hash['place'] = place if place
      end

      def add_pages
        return unless @json["pages"]
        raw_pages = @json["pages"].gsub(/[\(\)\[\]]/, "").gsub(/\D/, " ").strip()
        @hash['numPages'] = raw_pages.split(" ").first unless raw_pages.empty?
      end

      def add_isbn
        isbn = [@json['isbn'], @json['isbn10'], @json['isbn13']].flatten.compact.uniq
        @hash['isbn']  = [@hash['isbn'], isbn].flatten.compact unless isbn.empty?
      end

      def add_eissn
        eissn = @json['eissn'] || []
        @hash['eissn']  = [@hash['eissn'], eissn].flatten.compact unless eissn.empty?
      end

      def add_issn
        issn = @json['issn'] || []
        @hash['issn']  = [@hash['issn'], issn].flatten.compact unless issn.empty?
      end

      def add_all_other_fields
        qualified_method_names.each do |standard_form, method_name|
          @hash[standard_form] = @json[method_name] unless [@json[method_name]].compact.empty?
        end
      end

      def add_imported_from
        @hash['importedFrom'] = "PNX_JSON"
      end
    end
  end
end
