# There is not a lot to test here?
# How do you test this library without providing working creds for backblaze?
#
require "./spec_helper"

describe Barite do
  # TODO: Write tests

  b2 = Barite::B2.new("key_id", "key")

  it "works" do
    b2
  end
end
