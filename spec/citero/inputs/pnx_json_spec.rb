require 'spec_helper'

describe Citero::Inputs::PnxJson do
  let(:pnx_json_contributor_not_array) { JSON.parse(File.read(File.join(File.expand_path(File.dirname(File.dirname(__FILE__))), 'fixtures', 'pnx_json_contributor_not_array.json'))) }
  let(:pnx_json_contributor_array) { JSON.parse(File.read(File.join(File.expand_path(File.dirname(File.dirname(__FILE__))), 'fixtures', 'pnx_json.json'))) }
  let(:raw_pnx_json) { pnx_json_contributor_array }
  let(:pnx_json) { Citero::Inputs::PnxJson.new(raw_pnx_json) }

  describe "#initialize" do
  end

  describe "#csf" do
    subject { pnx_json.csf }
    context 'when contributor is not an array' do
      let(:raw_pnx_json) { pnx_json_contributor_not_array }
      it 'should be valid CSF' do
        expect { subject }.to_not raise_error
      end
    end
    context 'when contributor is an array' do
      let(:raw_pnx_json) { pnx_json_contributor_array }
      it 'should be valid CSF' do
        expect { subject }.to_not raise_error
      end
    end
  end

end
