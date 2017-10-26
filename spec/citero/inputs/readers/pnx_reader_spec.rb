require 'spec_helper'

describe Citero::Inputs::Readers::PnxReader do
  let(:pnx_input)   { Citero::Inputs::Readers::PnxReader.new(pnx_data) }
  let(:action)      { pnx_input.send(method_sym) }
  let(:result)      { "#{method_sym.to_s}-test" }
  
  describe "#type" do
    let(:method_sym)      { :type }
    it "should give me a value" do
      expect(action).to eq result
    end
  end

  describe "#publisher" do
    let(:method_sym)      { :publisher }
    it "should give me a value" do
      expect(action).to eq result
    end
  end

  describe "#language" do
    let(:method_sym)      { :language }
    it "should give me a value" do
      expect(action).to eq result
    end
  end

  describe "#edition" do
    let(:method_sym)      { :edition }
    it "should give me a value" do
      expect(action).to eq result
    end
  end

  describe "#pages" do
    let(:method_sym)      { :pages }
    let(:result)          { "format-test" }
    it "should give me a value" do
      expect(action).to eq result
    end
  end

  describe "#identifier" do
    let(:method_sym)      { :identifier }
    it "should give me a value" do
      expect(action).to eq result
    end
  end

  describe "#creator" do
    let(:method_sym)      { :creator }
    it "should give me a value" do
      expect(action).to eq result
    end
  end

  describe "#addau" do
    let(:method_sym)      { :addau }
    it "should give me a value" do
      expect(action).to eq result
    end
  end

  describe "#pub" do
    let(:method_sym)    { :pub }
    it "should give me a value" do
      expect(action).to eq [result]
    end
  end

  describe "#cop" do
    let(:method_sym)    { :cop }
    it "should give me a value" do
      expect(action).to eq [result]
    end
  end

  describe "#issn" do
    let(:method_sym)    { :issn }
    it "should give me a value" do
      expect(action).to eq [result]
    end
  end

  describe "#eissn" do
    let(:method_sym)    { :eissn }
    it "should give me a value" do
      expect(action).to eq [result]
    end
  end

  describe "#isbn" do
    let(:method_sym)    { :isbn }
    it "should give me a value" do
      expect(action).to eq [result]
    end
  end

  describe "#title" do
    let(:method_sym)    { :title }
    it "should give me a value" do
      expect(action).to eq [result]
    end
  end

  describe "#journal_title" do
    let(:method_sym)    { :journal_title }
    let(:result)        { "jtitle-test" }
    it "should give me a value" do
      expect(action).to eq [result]
    end
  end

  describe "#description" do
    let(:method_sym)    { :notes }
    let(:result)        { "description-test" }
    it "should give me a value" do
      expect(action).to eq [result]
    end
  end

  describe "#tags" do
    let(:method_sym)    { :tags }
    let(:result)        { ["subject-test", "subject-test"] }
    it "should give me a value" do
      expect(action).to eq result
    end
  end

  describe "#date" do
    let(:method_sym)    { :date }
    let(:result)        { ["creationdate-test", "creationdate-test"] }
    it "should give me a value" do
      expect(action).to eq result
    end
  end

  describe "#publication_date" do
    let(:method_sym)    { :publication_date }
    let(:result)        { ["date-test", "date-test"] }
    it "should give me a value" do
      expect(action).to eq result
    end
  end
end
