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
        @csf = CSF.new
        url    = 'https://getit.library.nyu.edu/resolve?umlaut.institution=NYU&url_ver=Z39.88-2004&url_ctx_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Actx&ctx_ver=Z39.88-2004&ctx_tim=2017-03-09T20%3A31%3A59-05%3A00&ctx_id=&ctx_enc=info%3Aofi%2Fenc%3AUTF-8&rft.jtitle=Modern+Cat&rft.object_id=2560000000238438&rft.issn=1929-3933&rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&rfr_id=info%3Asid%2Fsfxit.com%3Acitation&umlaut.institution=NYU'
        uri    = URI.parse(url)
        params = CGI.parse(uri.query)
        puts params
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
          'rft.tpages'      =>  'numPages', #special stuff here
          'rft.edition'     =>  'edition',
          'rft.series'      =>  'series'

        }
      end
    end
  end
end
