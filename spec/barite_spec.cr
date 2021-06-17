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
require "./spec_helper"

describe Barite do
  barite_bucket = ENV["BARITE_TEST_BUCKET"]
  barite_key = ENV["BARITE_TEST_KEY"]
  barite_key_id = ENV["BARITE_TEST_KEY_ID"]

  describe "initialisation" do
    b2 = Barite::B2::API.new(barite_key_id, barite_key)

    it "works" do
      b2
    end

    it "has a correct environment" do
      barite_bucket.empty?.should be_false
      barite_key.empty?.should be_false
      barite_key_id.empty?.should be_false
    end

    it "initialises key" do
      b2.key.should eq barite_key
      b2.key_id.should eq barite_key_id
    end
  end


  describe "authorize_account" do
    b2 = Barite::B2::API.new(barite_key_id, barite_key)
    b2.authorize_account

    it "initialises account_id" do
      b2.account_id.should_not be_nil
      b2.api_url.should_not be_nil
      b2.api_token.should_not be_nil
    end
  end

  describe "account_id" do
    b2 = Barite::B2::API.new(barite_key_id, barite_key)
    it "is automatically initialised" do
      b2.account_id.should_not be_nil
    end
  end

  describe "api_token" do
    b2 = Barite::B2::API.new(barite_key_id, barite_key)
    it "is automatically initialised" do
      b2.api_token.should_not be_nil
    end
  end

  describe "api_url" do
    b2 = Barite::B2::API.new(barite_key_id, barite_key)
    it "is automatically initialised" do
      b2.api_url.should_not be_nil
    end
  end

  describe "get_bucket_id" do
    b2 = Barite::B2::API.new(barite_key_id, barite_key)

    it "retrieves test bucket id" do
      b2.get_bucket_id(barite_bucket).should_not be_nil
    end

    it "fails on non-existent bucket" do
      expect_raises(Barite::NotAuthorisedException) do
        b2.get_bucket_id("thisdoesntexistsurely")
      end
    end
  end
  describe "get_upload_url" do
    b2 = Barite::B2::API.new(barite_key_id, barite_key)
    bucket_id = b2.get_bucket_id(barite_bucket)

    it "works on a genuine bucket id" do
      upload_url = b2.get_upload_url(bucket_id)
      upload_url.should_not be_nil
    end

    it "fails on a bad bucket id" do
      expect_raises(Barite::NotFoundException) do
        b2.get_upload_url("a bad bucket id")
      end
    end
  end
end

