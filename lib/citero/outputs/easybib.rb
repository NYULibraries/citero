module Citero
  module Outputs
    class EasyBIB
      require 'json'
      def initialize(csf)
        @csf = csf.csf
      end

      def to_easybib
        [create_json].to_json
      end

      private

      def create_json
        hashes =[
          source(@csf["itemType"]),
          item_object(@csf["itemType"]),
          pubtype(@csf["itemType"]),
          main(),
          contributors(@csf["itemType"])
        ]
        hashes.reduce({},:merge)
      end

      def source(friend)
        { source: get_type(friend) }
      end

      def item_object(friend)
        { "#{get_type(friend)}": title }
      end

      def title
        @title ||= { title: @csf['title']  } if @csf['title']
      end

      def pubtype(friend)
        { pubtype: { main: get_pub_type(friend) } }
      end

      def main()
        { "#{@pub_type}": send(@pub_type.to_sym)  }
      end

      def pubnonperiodical
        title.merge(💩({
          publisher: "publisher",
          city: "place",
          vol: "volume",
          edition: "edition"
        })).merge(errata)
      end

      def pubmagazine
        title.merge(💩({vol: "volume"})).merge(errata)
      end

      def pubnewspaper
        title.merge(💩({
              edition: "edition",
              section: "section",
              city: "place"
            })).merge(errata)
      end

      def pubjournal
        title.merge(💩({
            issue: "issue",
              vol: "volume",
              series: "series"})).merge(errata)
      end

      def pubonline
        title.merge(💩({
          inst: "institution",
          year:"date",
          url:"url",
          dayaccessed:"accessDate"
        }))
      end

      def pages
        pages = {}
        if @csf["numPages"]
          if @csf["firstPage"]
            pages = { end: @csf["firstPage"].to_i + @csf["numPages"].to_i }
          else
            pages = { end: @csf["numPages"].to_i }
          end
        end
        pages.merge(💩({ start: "firstPage"}))
      end

      def errata
        💩({
          year: "date",
          start: "firstPage"
        }).merge(pages)
      end

      def 💩(hash)
        hashes = []
        hash.each do |key, value|
          hashes << { "#{key}": @csf[value] } if @csf[value]
        end
        hashes.reduce({},:merge)
      end

      def contributors(friend)
        { contributors: get_contributor_array }
      end


      def get_type(friend)
        return type_map[friend.to_sym] if type_map.include?(friend.to_sym)
        return 'book'
      end

      def get_pub_type(friend)
        @pub_type ||= pub_type_map.include?(friend.to_sym) ? pub_type_map[friend.to_sym] : 'pubnonperiodical'
      end

      def author_contributors
        ['author', 'inventor', 'contributor']
      end

      def editor_contributors
        ['editor', 'seriesEditor']
      end

      def translator_contributors
        ['translator']
      end

      def all_contributors
        [author_contributors, editor_contributors, translator_contributors].flatten
      end

      def get_csf_contributor_array(contributor_type)
        [@csf[contributor_type]].compact.flatten
      end

      def get_contributor_symbol(param)
        return :author     if author_contributors.include?(param)
        return :editor     if editor_contributors.include?(param)
        return :translator if translator_contributors.include?(param)
      end

      def get_contributor_array
        contributor_array = []
        all_contributors.each do |contrib|
          get_csf_contributor_array(contrib).each do |cont|
            contributor_array << add_contributor(get_contributor_symbol(contrib), cont)
          end
        end
        contributor_array
      end

      def add_contributor(contributor_symbol,raw_name)
        name = Citero::Utils::NameFormatter.new(raw_name)
        hashes = []
        hashes << { function: contributor_symbol }
        hashes << { first: name.first_name } if name.first_name
        hashes << { middle: name.middle_name } if name.middle_name
        hashes << { last: name.last_name } if name.last_name
        hashes.reduce({},:merge)
      end

      def pub_type_map
        @type_map ||= {
           magazineArticle: 'pubmagazine',
          newspaperArticle: 'pubnewspaper',
            journalArticle: 'pubjournal',
                   journal: 'pubjournal',
                   webpage: 'pubonline'
        }
      end

      def type_map
        @type_map ||= {
                   journal: 'journal',
                    report: 'report',
                  blogPost: 'blog',
               bookSection: 'chapter',
           conferencePaper: 'conference',
                    thesis: 'dissertation',
            videoRecording: 'film',
            journalArticle: 'journal',
           magazineArticle: 'magazine',
          newspaperArticle: 'newspaper',
                   artwork: 'painting',
           computerProgram: 'software',
                   webpage: 'website'
        }
      end
    end
  end
end
