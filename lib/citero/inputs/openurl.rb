module Citero
  module Inputs
    class OpenUrl
      require 'open-uri'
      require 'cgi'

      attr_reader :csf

      def initialize(raw_data)
        @raw_data = raw_data
        construct_csf
      end

      private

      def construct_csf
        @csf    = CSF.new
        url     = @raw_data
        @params = CGI.parse(CGI::unescape(URI.parse(url).query))
        @params.each do |key,values|
          values = values.uniq.compact.reject { |value| value.empty? }
          if values.empty?
            @params.delete(key)
          else
            @params[key] = values
          end
        end

        hash = [
          {"itemType" => item_type},
          rft_id,
          map_one_to_one_fields,
          isbn,
          # rfr_id,
          btitle,
          atitle,
          jtitle,
          stitle,
          title,
          date,
          author,
          issn,
          inventor,
          authors,
          publisher,
          thesis_elements,
          patent_elements,
          webpage_elements,
          {"importedFrom" => "OpenURL"}
        ].compact.reduce({}, :merge)

        hash.each do |k,v|
          v = [v].flatten.compact
          v = v.collect {|a| a.gsub(',','\,')}
          v = v.first if v.size == 1
          hash[k] = v
        end

        @csf.load_from_hash(hash)
      end

      def params
        @params
      end

      def get_format(openurl_format)
        return simple_types[openurl_format] if simple_types.has_key?(openurl_format)
        return get_book_format(openurl_format)
      end

      def get_book_format(openurl_format)
        return 'document' unless openurl_format.eql?('info:ofi/fmt:kev:mtx:book')
        return book_type[params['rft.genre']] if book_type.has_key?(params['rft.genre'])
        return 'book'
      end

      def item_type
        get_format(params["rft_val_fmt"].first)
      end

      def book_type
        {
          "bookitem" => "bookSection",
          "conference" => "conferencePaper",
          "proceeding" => "conferencePaper",
          "report" => "report",
          "document" => "document"
        }
      end

      def simple_types
        {
          "info:ofi/fmt:kev:mtx:journal" => "journalArticle",
          "info:ofi/fmt:kev:mtx:dissertation" => "thesis",
          "info:ofi/fmt:kev:mtx:patent" => "patent",
          "info:ofi/fmt:kev:mtx:dc" => "webpage",
          "info:ofi/fmt:kev:mtx:audio" => "audioRecording"
        }
      end

      def key_mappings
        {
          'rft.type'        =>  'itemType',
          'rft.description' =>  'abstractNote',
          'rft.rights'      =>  'rights',
          'rft.language'    =>  'language',
          'rft.subject'     =>  'tags',
          'rft.source'      =>  'publicationTitle',
          'rft.pub'         =>  'publisher',
          'rft.publisher'   =>  'publisher',
          'rft.place'       =>  'place',
          'rft.edition'     =>  'edition',
          'rft.series'      =>  'series',
          "rft.volume"    =>  "volume",
          "rft.issue"   =>  "issue",
          "rft.inventor"    =>  "inventor",
          "rft.contributor"   =>  "contributor",
          "rft.aucorp"    =>  "author",
          "rft.pages" => "pages",
          "rft.spage" => "startPage",
          "rft.epage" => "endPage",
          "rft.tpages" => "numPages"
        }
      end

      def map_one_to_one_fields
        arr = []
        key_mappings.each do |k,v|
          arr << create_sub_hash(v,k)
        end
        arr.compact.reduce({}, :merge)
      end


      def rft_id
        rft_id = params['rft_id'].first
        return if rft_id.nil?
        if rft_id.start_with? 'info:doi/' || rft_id.start_with?('urn.isbn/')
          return { "isbn" => rft_id[9..-1] } unless rft_id[9..-1].empty?
        end
        return { "url" => rft_id, "accessDate" => "" } if rft_id.match /^https?:\/\/.*/
        return {}
      end

      def rfr_id
        return { "rfr_id" => params['rfr_id'].first } if params['rfr_id'].first
        return {}
      end

      def create_processed_sub_hash(key, value)
        return nil unless key and value and !value.empty?
        return { key => value }
      end

      def create_sub_hash(key,value)
        create_processed_sub_hash(key, params[value])
      end

      def btitle
        key = 'title'             if ['book','report'].include?(item_type)
        key = 'publicationTitle'  if ['bookSection','conferencePaper'].include?(item_type)
        create_sub_hash(key, 'rft.btitle')
      end

      def atitle
        key = 'title' if ['journalArticle','bookSection','conferencePaper'].include?(item_type)
        create_sub_hash(key, 'rft.atitle')
      end

      def jtitle
        key = 'publicationTitle' if ['journalArticle'].include?(item_type)
        create_sub_hash(key, 'rft.jtitle')
      end

      def stitle
        key = 'journalAbbreviation' if ['journalArticle'].include?(item_type)
        create_sub_hash(key, 'rft.stitle')
      end

      def title
        key = 'title'
        key = 'publicationTitle' if ['journalArticle','bookSection','conferencePaper'].include? item_type
        create_sub_hash(key, 'rft.title')
      end

      def date
        key = "date"
        key = "issueDate" if item_type.eql? "patent"
        create_sub_hash(key , 'rft.date')
      end

      def issn
        issn = [params['rft.issn'], params['rft.eissn']].flatten.compact.uniq.reject(&:empty?)
        create_processed_sub_hash("issn", issn)
      end

      def author
        first_name = params['rft.aufirst'].first&.strip
        last_name = params['rft.aulast'].first&.strip

        name = "#{last_name}," if last_name
        name = "#{name} #{first_name}".strip

        name = nil if name.empty?
        output_name = name || params['rft.au'] || params['rft.creator']

        if first_name and last_name
          pp create_processed_sub_hash("author", [output_name,output_name])
          return create_processed_sub_hash("author", [output_name,output_name])
        end
        create_processed_sub_hash("author", output_name)
      end

      def inventor
        first_name = params['rft.invfirst'].first
        last_name = params['rft.invlast'].first
        name = Citero::Utils::NameFormatter.new("#{first_name} #{last_name}")
        output_name = name.to_standardized || params['rft.inventor']
        create_processed_sub_hash("author", output_name)
      end

      def authors
        authors = ['rft.au', 'rft.creator', 'rft.addau'].collect{|key| params[key]}.flatten.collect(&:to_s)
        authors.reject!(&:empty?)
        create_processed_sub_hash('author',  authors ) unless authors.empty?
      end

      def isbn
        create_sub_hash("isbn", 'rft.isbn')
      end

      def publisher
        publisher = [params['rft.pub'], params['rft.publisher']].flatten
        create_processed_sub_hash("publisher", publisher)
      end


      def thesis_elements
        hash = []
        hash << create_sub_hash("publisher", "rft.inst")
        hash << create_sub_hash("type", "rft.degree")
        merged = hash.compact.reduce({}, :merge)
        return nil if merged.empty?
        merged
      end

      def patent_elements
        hash = []
        hash << create_sub_hash("assignee", "rft.assignee")
        hash << create_sub_hash("patentNumber", "rft.number")
        hash << create_sub_hash("date", "rft.appldate")
        merged = hash.compact.reduce({}, :merge)
        return nil if merged.empty?
        merged
      end

      def webpage_elements
        hash = []
        hash << create_sub_hash("abstractNote", "rft.description")
        hash << create_sub_hash("rights", "rft.rights")
        hash << create_sub_hash("language", "rft.language")
        hash << create_sub_hash("tags", "rft.subject")
        hash << create_sub_hash("itemType", "rft.type")
        hash << create_sub_hash("publicationTitle", "rft.source")
        unless params["rft.identifier"].empty?
          identifier = params["rft.identifier"].first
          hash << create_processed_sub_hash("isbn",  (identifier - 'isbn').strip) if identifier.start_with? 'isbn'
          hash << create_processed_sub_hash("issn",  (identifier - 'issn').strip) if identifier.start_with? 'issn'
          hash << create_processed_sub_hash("doi", (identifier - 'urn:doi:').strip) if  identifier.start_with? 'urn:doi:'
          hash << create_processed_sub_hash("url", identifier.strip) if identifier.match /^https?:\/\/.*/
        end
        merged = hash.compact.reduce({}, :merge)
        return nil if merged.empty?
        merged
      end

    end
  end
end
