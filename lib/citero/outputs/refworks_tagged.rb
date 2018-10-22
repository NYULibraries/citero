module Citero
  module Outputs
    # https://www.refworks.com/refworks/help/RefWorks_Tagged_Format.htm
    class RefworksTagged < Ris
      def initialize(csf)
        super(csf)
        @csf = csf.csf
      end

      def to_refworks_tagged
        ris = to_ris
        output = ""
        ris.each_line do |line|
          output = "#{output}#{ris_to_refworks_tagged(line)}"
        end
        output
      end

      # Refworks tagged format does not expect a closing tag, as RIS does
      # Parent class expects empty string because it is concatenating
      def output_ris_end
        ""
      end

      private

      def ris_to_refworks_tagged(line)
        key,val = line.split('-',2).collect {|x| x.strip }
        key = tag_map[key] if tag_map[key]
        val = type_map[val] || default_type if key.eql?('RT')
        "#{key} #{val}\n"
      end

      def tag_map
        @tag_map ||= {
          'TY' => 'RT',
          'CY' => 'PP',
          'DP' => 'DS',
          'ET' => 'ED',
          'KW' => 'K1',
          'N1' => 'NO',
          'PY' => 'YR',
          'TI' => 'T1'
        }
      end

      def type_map
        @type_map ||= {
          'ABST' => 'Abstract',
          'ART' => 'Artwork',
          'BILL' => 'Bills/Resolutions',
          'CHAP' => 'Book, Section',
          'EDBOOK' => 'Book, Edited',
          'BOOK' => 'Book, Whole',
          'CASE' => 'Case/Court Decisions',
          'COMP' => 'Computer Program',
          'CONF' => 'Conference Proceedings',
          'THES' => 'Dissertation/Thesis',
          'GEN' => 'Generic',
          'GRANT' => 'Grant',
          'HEAR' => 'Hearing',
          'JOUR' => 'Journal Article',
          'EJOUR' => 'Journal, Electronic',
          'LEGAL' => 'Laws/Statutes',
          'MGZN' => 'Magazine Article',
          'MAP' => 'Map',
          'MPCT' => 'Motion Picture',
          'MUSIC' => 'Music Score',
          'NEWS' => 'Newspaper Article',
          'PAT' => 'Patent',
          'PCOMM' => 'Personal Communication',
          'RPRT' => 'Report',
          'SOUND' => 'Sound Recording',
          'UNPB' => 'Unpublished Material',
          'VIDEO' => 'Video/ DVD',
          'ELEC' => 'Web Page'
        }
      end

      def default_type
        @default_type ||= type_map['GEN']
      end
    end
  end
end
