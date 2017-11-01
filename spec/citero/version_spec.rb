require 'spec_helper'

describe Citero do
  subject(:version) { Citero::VERSION }

  it { is_expected.to match /^(\d+)\.(\d+)\.(\d+)(?:-([0-9A-Za-z-]+(?:\.[0-9A-Za-z-]+)*))?(?:\+([0-9A-Za-z-]+(?:\.[0-9A-Za-z-]+)*))?(\.((pre)|(alpha)|(beta)|(rc\d)))?$/ }

end
