require 'spec_helper'

describe Citero::Utils::NameFormatter do
  describe "#to_standardized" do
    let(:standardized_name)   { Citero::Utils::NameFormatter.new(name).to_standardized }

    context "with only first name" do
      let(:name)                { "First" }

      it "returns only the first name" do
        expect(standardized_name).to eq "First"
      end
    end

    context "with first and last name" do
      let(:name)                { "First Last" }

      it "returns with 'last name, first name'" do
        expect(standardized_name).to eq "Last, First"
      end
    end

    context "with first, middle and last name" do
      let(:name)                { "First Middle Last" }

      it "returns with 'last name, first name middle name'" do
        expect(standardized_name).to eq "Last, First Middle"
      end

      context "with superfluous data in parenthesis" do
        let(:name)                { "First Middle Last (FML)" }

        it "removes superfluous data in parenthesis, returns with 'last name, first name middle name'" do
          expect(standardized_name).to eq "Last, First Middle"
        end
      end
      context "with unrelated data pertaining to the person" do
        let(:name)                { "First  Last (dd) 1943-" }

        it "removes unrelated data pertaining to the person, returns with 'last name, first name middle name'" do
          expect(standardized_name).to eq "Last, First"
        end
      end
    end
  end
end
