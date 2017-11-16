require 'spec_helper'

describe Citero::CSF do
  let(:input_data) { nil }
  let(:csf_object) { Citero::CSF.new(input_data) }

  describe "#initialize" do
    context "when no data is provided" do
      it "should be empty" do
        expect(csf_object.size).to equal(0)
      end
    end
    context "when data is provided" do
      let(:input_data) { { item1: :value1 } }
      it "should be empty" do
        expect(csf_object.size).to equal(input_data.size)
      end
    end
  end

  describe "#inspect" do
    it "should inspect the underlying hash" do
      expect(csf_object.inspect).to eq("{}")
    end
  end
  describe "#to_s" do
    it "should stringify the underlying hash" do
      expect(csf_object.to_s).to eq("{}")
    end
  end

  describe "#[]=" do
    it "should set an item from the hash" do
      csf_object[:key] = :value
      expect(csf_object[:key]).to be(:value)
    end
  end

  describe "#[]" do
    it "should retrieve an item from the hash" do
      csf_object[:key] = :value
      expect(csf_object[:key]).to be(:value)
    end
  end

  describe "#size" do
    it 'should reflect the size of the hash' do
      expect(csf_object.size).to equal(0)
      csf_object[:key] = :value
      expect(csf_object.size).to equal(1)
    end
  end

  describe "#each" do
    it 'should allow one to iterate through the hash' do
      expect(csf_object.each).to be_an(Enumerator)
    end
  end

  describe "#load_from_hash" do
    context 'when the source hash is nil' do
      let(:source_hash) { nil }
      let(:result_hash) {}

    end
    context 'when the source hash is empty' do
      let(:source_hash) { {} }

      it 'should\'t transform the hash' do
        csf_object.load_from_hash(source_hash)
        expect(csf_object.data).to eq(source_hash)
      end
    end
    context 'when the source hash has single element values' do
      let(:source_hash) { { item1: :value1 } }

      it 'should not transform the hash' do
        csf_object.load_from_hash(source_hash)
        expect(csf_object.data).to eq(source_hash)
      end
    end
    context 'when the source hash has nil values' do
      context 'and there is only one key' do
        let(:source_hash) { { item1: nil } }
        let(:result_hash) { {} }

        it 'ould return empty hash' do
          csf_object.load_from_hash(source_hash)
          expect(csf_object.data).to eq(result_hash)
        end
      end
      context 'and there are multiple keys' do
        context 'and they all map to nil' do
          let(:source_hash) { { item1: nil, item2: nil } }
          let(:result_hash) { {} }

          it 'should return empty hash' do
            csf_object.load_from_hash(source_hash)
            expect(csf_object.data).to eq(result_hash)
          end
        end
        context 'and some of them map to nil' do
          let(:source_hash) { { item1: nil, item2: :value1, item3: nil } }
          let(:result_hash) { { item2: :value1 } }

          it 'should remove keys with nil values and keep the others ' do
            csf_object.load_from_hash(source_hash)
            expect(csf_object.data).to eq(result_hash)
          end
        end
      end
    end
    context 'when the source hash has array values' do
      context 'and the array values have single values in them' do
        let(:source_hash) { { item1: [:value1] } }
        let(:result_hash) { { item1: :value1 } }

        it 'should convert all single valued lists into the value' do
          csf_object.load_from_hash(source_hash)
          expect(csf_object.data).to eq(result_hash)
        end
      end
      context 'and the array values have multiple values in them' do
        let(:source_hash) { { item1: [:value1, :value2] } }

        it 'should not transform the hash' do
          csf_object.load_from_hash(source_hash)
          expect(csf_object.data).to eq(source_hash)
        end
      end
      context 'and the array values have single and multiple values in them' do
        let(:source_hash) { { item1: [:value1, :value2], item2: [:value3] } }
        let(:result_hash) { { item1: [:value1, :value2], item2: :value3 } }

        it 'should convert all single valued lists into the value' do
          csf_object.load_from_hash(source_hash)
          expect(csf_object.data).to eq(result_hash)
        end
      end
    end
  end
  
  describe "#keys" do
    context "when the keys are snake cased" do
      let(:input_data) { { key1: :value1, key2: :value2, "random_key": :random_value } }
      it 'should get me a list of keys in the hash as lower snake case' do
        expect(csf_object.keys).to eql([:key1, :key2, :random_key])
      end
    end
    context "when the keys are camel cased" do
      let(:input_data) { { key1: :value1, key2: :value2, "RandomKey": :random_value } }
      it 'should get me a list of keys in the hash' do
        expect(csf_object.keys).to eql([:key1, :key2, :random_key])
      end
    end
  end
  
  describe "#respond_to?" do
    let(:input_data) { { key1: :value1, key2: :value2, "random_key": :random_value } }
    it 'should respond to keys' do
      expect(csf_object.respond_to?(:key1)).to be true
      expect(csf_object.respond_to?(:key2)).to be true
      expect(csf_object.respond_to?(:random_key)).to be true
    end
  end
  describe "#method_missing" do
    context "when the keys are snake cased" do
      let(:input_data) { { key1: :value1, key2: :value2, "random_key": :random_value } }
      it 'should get value from keys' do
        expect(csf_object.send(:key1)).to be :value1
        expect(csf_object.send(:key2)).to be :value2
        expect(csf_object.send(:random_key)).to be :random_value
      end
    end
    context "when the keys are camel cased" do
      let(:input_data) { { key1: :value1, key2: :value2, "randomKey": :random_value } }
      it 'should get me a list of keys in the hash' do
        expect(csf_object.send(:key1)).to be :value1
        expect(csf_object.send(:key2)).to be :value2
        expect(csf_object.send(:random_key)).to be :random_value
      end
    end
  end
end
