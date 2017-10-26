require 'spec_helper'

describe Citero::Inputs::Pnx do
  let(:pnx_input)   { Citero::Inputs::Pnx.new(pnx_data_book) }
  let(:csf)         { Citero::CSF.new(
      {
        "itemType"=>"book",
        "author"=>"creator-test",
        "contributor"=>"contributor-test",
        "publisher"=>"pub-test",
        "place"=>"cop-test",
        "issn"=>"",
        "title"=>"title-test",
        "publicationDate"=>["date-test", "date-test"],
        "journalTitle"=>"jtitle-test",
        "date"=>["creationdate-test", "creationdate-test"],
        "language"=>"language-test",
        "edition"=>"edition-test",
        "tags"=>["subject-test", "subject-test"],
        "callNumber"=>"classificationlcc-test",
        "pnxRecordId"=>"recordid-test",
        "description"=>"format-test",
        "notes"=>"description-test",
        "importedFrom"=>"PNX"
      }
    )
  }
  let(:pnx_input_csf_data)    { pnx_input.csf.data }
  let(:csf_data)              { csf.data }
  describe "#initialize" do
  end
  describe "#csf" do
    it "should give me a value" do
      expect(pnx_input_csf_data).to eq csf_data
    end
  end
end
