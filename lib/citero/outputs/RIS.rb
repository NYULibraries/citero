module Citero
  module Outputs
    class RIS
      def initialize(csf)
        @csf = csf.csf
      end

      def to_ris
        output = ""
        output_order.each do |method_sym|
          output += send(method_sym)
        end
        output
      end

      private

      def ris_output_line(key,value)
        output = ""
        return output if value.nil?
        if value.is_a?(Array)
          value.each {|val| output += "#{key}  - #{val}\n" }
        else
          output += "#{key}  - #{value}\n"
        end
        output
      end

      def output_type
        ris_output_line('TY', (type_output_map[@csf['itemType']] || "BOOK"))
      end

      def output_author
        ris_output_line('A1', @csf['author'])
      end

      def output_title
        ris_output_line('TI', @csf['title'])
      end

      def output_bookTitle
        ris_output_line('BT', @csf['bookTitle'])
      end

      def output_publicationTitle
        ris_output_line('JO', @csf['publicationTitle'])
      end

      def output_backupPublicationTitle
        ris_output_line('T2', @csf['backupPublicationTitle'])
      end

      def output_editor
        ris_output_line('ED', @csf['editor'])
      end

      def output_contributor
        ris_output_line('A2', @csf['contributor'])
      end

      def output_assignee
        ris_output_line('A2', @csf['assignee'])
      end

      def output_volume
        ris_output_line('VL', @csf['volume'])
      end

      def output_applicationNumber
        ris_output_line('VL', @csf['applicationNumber'])
      end

      def output_reportNumber
        ris_output_line('VL', @csf['reportNumber'])
      end

      def output_issue
        ris_output_line('IS', @csf['issue'])
      end

      def output_patentNumber
        ris_output_line('IS', @csf['patentNumber'])
      end

      def output_publisher
        ris_output_line('PB', @csf['publisher'])
      end

      def output_references
        ris_output_line('PB', @csf['references'])
      end

      def output_place
        ris_output_line('CY', @csf['place'])
      end

      def output_date
        ris_output_line('PY', @csf['date']&.first)
      end

      def output_filingDate
        ris_output_line('Y2', @csf['filingDate'])
      end

      def output_abstractNote
        ris_output_line('N2', @csf['abstractNote'])
      end

      def output_startPage
        ris_output_line('SP', @csf['startPage'])
      end

      def output_endPage
        ris_output_line('EP', @csf['endPage'])
      end

      def output_isbn
        ris_output_line('SN', @csf['isbn'])
      end

      def output_issn
        ris_output_line('SN', @csf['issn'])
      end

      def output_url
        ris_output_line('UR', @csf['url'])
      end

      def output_tags
        ris_output_line('KW', @csf['tags']&.sort)
      end

      def output_ris_end
        "ER  -\n\n"
      end

      def output_order
        [
          :output_type,
          :output_author,
          :output_publisher,
          :output_place,
          :output_isbn,
          :output_issn,
          :output_title,
          :output_bookTitle,
          :output_publicationTitle,
          :output_backupPublicationTitle,
          :output_editor,
          :output_contributor,
          :output_assignee,
          :output_volume,
          :output_applicationNumber,
          :output_reportNumber,
          :output_issue,
          :output_patentNumber,
          :output_references,
          :output_date,
          :output_filingDate,
          :output_abstractNote,
          :output_startPage,
          :output_endPage,
          :output_url,
          :output_tags,
          :output_ris_end
        ]
      end

      def type_output_map
        @type_output_map ||= {
                            "book"              => "BOOK",
                            "bookSection"       => "CHAP",
                            "journalArticle"    => "JOUR",
                            "journal"           => "JFULL",
                            "magazineArticle"   => "MGZN",
                            "newspaperArticle"  => "NEWS",
                            "thesis"            => "THES",
                            "dissertation"      => "THES",
                            "letter"            => "PCOMM",
                            "interview"         => "PCOMM",
                            "manuscript"        => "PAMP",
                            "film"              => "MPCT",
                            "artwork"           => "ART",
                            "report"            => "RPRT",
                            "bill"              => "BILL",
                            "case"              => "CASE",
                            "hearing"           => "HEAR",
                            "patent"            => "PAT",
                            "statute"           => "STAT",
                            "map"               => "MAP",
                            "blogPost"          => "ELEC",
                            "webpage"           => "ELEC",
                            "instantMessage"    => "ICOMM",
                            "forumPost"         => "ICOMM",
                            "email"             => "ICOMM",
                            "audioRecording"    => "SOUND",
                            "videoRecording"    => "VIDEO",
                            "computerProgram"   => "COMP",
                            "conferencePaper"   => "CONF",
                            "tvBroadcast"       => "GEN",
                            "presentation"      => "GEN",
                            "radioBroadcast"    => "GEN",
                            "podcast"           => "GEN",
                            "document"          => "GEN"
                          }
      end
    end
  end
end
