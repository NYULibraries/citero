module Citero
  module Outputs
    class RefworksTagged < RIS
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

      private

      def ris_to_refworks_tagged(line)
        key,val = line.split('-',2).collect {|x| x.strip }
        key = tag_map[key] if tag_map[key]
        val = type_map[val] if key.eql?('RT')
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
          'JOUR' => 'Journal Article',
          'THES' => 'Dissertation',
          'BOOK' => 'Book, whole',
          'RPRT' => 'Report',
          'CHAP' => 'Book, section',
          'ELEC' => 'Webpage'
        }
      end
    end
  end
end
