module Citero
  module Outputs
    class Bibtex
      def initialize(csf)
        @csf = csf.csf
      end

      def to_bibtex
        "@#{bibtex_type}{#{cite_key}#{bibtex_fields}\n}"
      end

      def bibtex_type
        export_type_map[@csf['itemType']] || 'misc'
      end

      def cite_key
        [cite_key_author, cite_key_title, cite_key_date].compact.join('_')
      end

      def bibtex_fields
        start = [""]
        start << creators unless creators.empty?
        start << publisher
        export_field_map.each do |key,value|
          start << map_to_bibtex_value(value,key)
        end
        start << note
        start << tags
        start << publicationTitle
        start << pages
        start << webpage
        start.compact.join(",\n\t")
      end

      def publisher
        return map_to_bibtex_value("publisher","school") if @csf['itemType'].eql?("thesis")
        return map_to_bibtex_value("report","institution") if @csf['itemType'].eql?("report")
        map_to_bibtex_value("publisher","publisher")
      end

      # TODO gotta concat these tags
      def note
        map_to_bibtex_value('annote', 'note')
      end

      def tags
        map_to_bibtex_value('keywords', 'tags')
      end

      def publicationTitle
        if ['bookSection', 'conferencePaper'].include? @csf['itemType']
          map_to_bibtex_value('booktitle', 'publicationTitle')
        else
          map_to_bibtex_value('journal', 'publicationTitle')
        end
      end

      def join_names(name)
        [name].flatten.collect do |name|
          Citero::Utils::NameFormatter.new(name).to_standardized
        end.join(' and ')
      end

      def creators
        ['author', 'inventor', 'contributor', 'editor',
          'seriesEditor', 'translator'].collect do |creator|
            name = join_names(@csf[creator])
            creator = 'editor' if creator.eql?('seriesEditor')
            add_to_bibtex_output(creator, name)
        end.compact
      end

      def pages
        add_to_bibtex_output('pages', @csf['pages']&.gsub("-", "--"))
        add_to_bibtex_output('numPages', @csf['numPages']&.gsub(",", "\\,"))
      end

      def webpage
        # Gotta see what this is supposed to be..
        add_to_bibtex_output('howpublished','website') if @csf['itemType'].eql? 'webpage'
      end

      def expects_number_value?(key,value)
        (/\A[-+]?\d+\z/ === value) && !['numPages','isbn','issn'].include?(key)
      end

      def add_to_bibtex_output(key,value)
        return if value.nil? || !value.class.eql?(Array) && value.strip.empty?
        value = value.join(', ') if value.class.eql?(Array)
        output = "#{key} = "
        value = "{#{value}}" unless expects_number_value?(key,value)
        output = "#{output}#{value}"
      end

      def map_to_bibtex_value(key,csf_key)
        value = @csf[csf_key]
        add_to_bibtex_output(key,value)
      end

      def cite_key_author_last_name(name)
        name = name.first if name.is_a? Array
        Citero::Utils::NameFormatter.new(name).last_name&.downcase
      end

      def cite_key_author
        cite_key_author_last_name(@csf['author']) || cite_key_author_last_name(@csf['contributor'])
      end

      def cite_key_title_first_non_stop_word(title)
        title = title.first if title.is_a? Array
        title&.downcase&.gsub(/^((a+|the+|on+)\s)+/,"")&.split(" ")&.first
      end

      def cite_key_title
        cite_key_title_first_non_stop_word(@csf["title"])
      end

      def cite_key_date
        @csf['date'].first&.gsub(/[^0-9]/,'') || "????"
      end

      def export_type_map
        @export_type_map ||= {
          "book"              => "book",
          "bookSection"       => "incollection",
          "journalArticle"    => "article",
          "magazineArticle"   => "article",
          "newspaperArticle"  => "article",
          "thesis"            => "phdthesis",
          "manuscript"        => "unpublished",
          "patent"            => "patent",
          "letter"            => "misc",
          "interview"         => "misc",
          "film"              => "misc",
          "artwork"           => "misc",
          "webpage"           => "misc",
          "conferencePaper"   => "inproceedings",
          "report"            => "techreport"
        }
      end

      def export_field_map
        @export_field_map ||= {
          "attachments"     => "file",
          "extra"           => "note",
          "accessDate"      => "urldate",
          "reportNumber"    => "number",
          "seriesNumber"    => "number",
          "patentNumber"    => "number",
          "issue"           => "number",
          "place"           => "address",
          "section"         => "chapter",
          "rights"          => "copyright",
          "isbn"            => "isbn",
          "issn"            => "issn",
          "title"           => "title",
          "date"            => "date",
          "callNumber"      => "iccn",
          "archiveLocation" => "location",
          "shortTitle"      => "shorttitle",
          "doi"             => "doi",
          "abstractNote"    => "abstract",
          "country"         => "nationality",
          "edition"         => "edition",
          "language"        => "language",
          "type"            => "type",
          "series"          => "series",
          "volume"          => "volume",
          "assignee"        => "assignee"
        }
      end
    end
  end
end
