module Citero
  module Outputs
    class OpenUrl
      require 'open-uri'
      def initialize(csf)
        @csf = csf.csf
      end

      def to_openurl
        output = ""
        (private_methods - Object.private_methods - Module.methods).each do |method_sym|
          output += send(method_sym) if method_sym.to_s.start_with? "output_"
        end
        puts output
      end

      private

      def openurl_param(key,value, with_prefix = true, encoded = true)
        output = ""
        return output if value.nil?
        key = "rft.#{key}" if with_prefix
        if value.is_a?(Array)
          value.each do |val|
            val = URI::encode(val) if encoded
            output += "#{key}=#{val}&"
          end
        else
          value = URI::encode(value) if encoded
          output += "#{key}=#{value}&"
        end
        output
      end

      def output_start
        openurl_param("ulr_ver", "Z39.88-2004")
        openurl_param("ctx_ver", "Z39.88-2004")
        if @csf['pnxRecordId']
          openurl_param("rfr_id", "info:sid/primo.exlibrisgroup.com:primo-#{@csf['pnxRecordId']}", false)
        else
          openurl_param("rfr_id", "info:sid/libraries.nyu.edu:citero", false)
        end
      end

      def output_doi
        openurl_param('rft_id=info:doi/', @csf['doi'])
      end

      def output_isbn
        openurl_param('rft_id=info:isbn/', @csf['isbn'])
      end

      def output_type
        openurl_param('rft_val_fmlt', type_output_map[@csf['itemType']], false, false) if type_output_map[@csf['itemType']]
        openurl_param('rft_val_fmlt', "info:ofi/fmt:kev:mtx:book", false, false)
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

      def output_date
        openurl_param('PY', @csf['date'])
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

      def output_isbn
        openurl_param('isbn', @csf['isbn'])
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
    end
  end
end
