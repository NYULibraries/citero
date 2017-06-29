module Citero
  module Outputs
    class OpenUrl
      require 'open-uri'
      require "erb"
      require "cgi"
      def initialize(csf)
        @csf = csf.csf
      end

      def to_openurl
        output = ""
        output_methods.each do |method_sym|
          output += send(method_sym)
        end
        output.chop if output[-1].eql? "&"
      end

      private

      def openurl_param(key,value, with_prefix = true, encoded = true)
        output = ""
        return output if value.nil?
        key = "rft.#{key}" if with_prefix
        if value.is_a?(Array)
          value.each do |val|
            val = CGI::escape(val) if encoded
            output += "#{key}=#{val}&"
          end
        else
          value = CGI::escape(value) if encoded
          output += "#{key}=#{value}&"
        end
        output
      end

      def output_start
        output = ""
        output += openurl_param("ulr_ver", "Z39.88-2004")
        output += openurl_param("ctx_ver", "Z39.88-2004")
        if @csf['pnxRecordId']
          output += openurl_param("rfr_id", "info:sid/primo.exlibrisgroup.com:primo-#{@csf['pnxRecordId']}", false, false)
        else
          output += openurl_param("rfr_id", "info:sid/libraries.nyu.edu:citero", false, false)
        end
      end

      def output_doi
        openurl_param('rft_id=info:doi/', @csf['doi'])
      end

      def output_isbn
        openurl_param('rft_id=info:isbn/', @csf['isbn'])
      end

      def output_type
        if type_output_map[@csf['itemType']]
          str = openurl_param('rft_val_fmlt', type_output_map[@csf['itemType']], false, false)
          str += openurl_param('genre', genre_output_map[@csf['itemType']]) if genre_output_map[@csf['itemType']]
          str
        else
          openurl_param('rft_val_fmlt', "info:ofi/fmt:kev:mtx:book", false, false) + openurl_param('genre', "book")
        end
      end

      def output_date
        openurl_param('date', @csf['date'])
      end

      def output_title
        openurl_param('title', @csf['title'])
      end

      def output_author
        openurl_param('au', @csf['author'])
      end

      def output_bookTitle
        openurl_param('btitle', @csf['bookTitle'])
      end

      def output_publicationTitle
        openurl_param('jtitle', @csf['publicationTitle'])
      end

      def output_edition
        openurl_param('edition', @csf['edition'])
      end

      def output_contributor
        openurl_param('contributor', @csf['contributor'])
      end

      def output_assignee
        openurl_param('assignee', @csf['assignee'])
      end

      def output_volume
        openurl_param('volume', @csf['volume'])
      end

      def output_reportNumber
        openurl_param('volume', @csf['reportNumber'])
      end

      def output_issue
        openurl_param('issue', @csf['issue'])
      end

      def output_patentNumber
        openurl_param('number', @csf['patentNumber'])
      end

      def output_publisher
        openurl_param('publisher', @csf['publisher'])
      end

      def output_place
        openurl_param('place', @csf['place'])
      end

      def output_abstractNote
        openurl_param('description', @csf['abstractNote'])
      end

      def output_startPage
        openurl_param('spage', @csf['startPage'])
      end

      def output_endPage
        openurl_param('epage', @csf['endPage'])
      end

      def output_numPages
        openurl_param('tpages', @csf['numPages'])
      end

      def output_issn
        openurl_param('issn', @csf['issn'])
      end

      def output_tags
        openurl_param('subject', @csf['tags'])
      end

      def type_output_map
        @type_output_map ||= {
          "bookSection"       => "info:ofi/fmt:kev:mtx:book",
          "journalArticle"    => "info:ofi/fmt:kev:mtx:journal",
          "thesis"            => "info:ofi/fmt:kev:mtx:dissertation",
          "patent"            => "info:ofi/fmt:kev:mtx:patent",
          "webpage"           => "info:ofi/fmt:kev:mtx:dc"
        }
      end

      def genre_output_map
        @genre_output_map ||= {
          "bookSection"       => "bookitem",
          "conferencePaper"   => "conference",
          "report"            => "report",
          "document"          => "document",
          "journalArticle"    => "article",
          "thesis"            => "dissertation",
          "patent"            => "patent"
        }
      end

      def output_methods
        @output_methods ||= [
          :output_start,
          :output_doi,
          :output_isbn,
          :output_type,
          :output_date,
          :output_title,
          :output_author,
          :output_bookTitle,
          :output_publicationTitle,
          :output_edition,
          :output_contributor,
          :output_assignee,
          :output_volume,
          :output_reportNumber,
          :output_issue,
          :output_patentNumber,
          :output_publisher,
          :output_place,
          :output_abstractNote,
          :output_startPage,
          :output_endPage,
          :output_numPages,
          :output_isbn,
          :output_issn,
          :output_tags
        ]
      end
    end
  end
end
