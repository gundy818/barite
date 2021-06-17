# These tests require a working Backblaze bucket name, key id, and key, stored in
# the BARITE_TEST_BUCKET, BARITE_TEST_KEY, and BARITE_TEST_KEY_ID environment variables.
#
# - The key must give read/write access to the bucket,
# - The bucket must exist,
#
# The key must have access to this bucket ONLY! It must not be able to list other buckets.
#
# TODO: Replace all success cases with a successfil file put/file get, then the
# remaining tests just need to check for the failure cases.
#
require "../spec_helper"

describe Barite do
  barite_key_id = "fake_key_id";
  barite_key = "fake_key";

  describe "initialisation" do
    b2 = Barite::B2::API.new(barite_key_id, barite_key)

    it "works" do
      b2
    end

    it "initialises key" do
      b2.key.should eq barite_key
      b2.key_id.should eq barite_key_id
    end
  end

  describe "account_id" do
    b2 = Barite::B2::API.new(barite_key_id, barite_key)
    the_id = "theid";
    b2.account_id = the_id;

    it "honours cache" do
      b2.account_id.should eq the_id
    end
  end

  describe "api_token" do
    b2 = Barite::B2::API.new(barite_key_id, barite_key)
    the_token = "a token";
    b2.api_token = the_token;
    it "honours cache" do
      b2.api_token.should eq the_token
    end
  end

  describe "api_url" do
    b2 = Barite::B2::API.new(barite_key_id, barite_key)
    the_url = "a url";
    b2.api_url = the_url;
    it "honours cache" do
      b2.api_url().should eq the_url;
    end
  end
end

