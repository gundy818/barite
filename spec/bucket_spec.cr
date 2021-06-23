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

describe Barite::B2::Bucket do
  barite_bucket = ENV["BARITE_TEST_BUCKET"]
  barite_key = ENV["BARITE_TEST_KEY"]
  barite_key_id = ENV["BARITE_TEST_KEY_ID"]

  b2 = Barite::B2::API.new(barite_key_id, barite_key)
  bucket = b2.bucket(barite_bucket)

  describe "initialisation" do
    it "works" do
      bucket
    end

    it "has a correct environment" do
      barite_bucket.empty?.should be_false
      barite_key.empty?.should be_false
      barite_key_id.empty?.should be_false
    end

    it "initialises bucket_id" do
      bucket.bucket_id.should_not be_nil
    end
  end

  describe "update" do

    # these tests are crippled at the moment, because the test key requires the 'writeBuckets' capability,
    # which isn't available to keys which are limited to a single bucket. will need to implement a second
    # trest key which does have this access. So both these tests return 'Not Authorised' for now.
    it "handles empty lifecycle rules" do
      expect_raises(Barite::NotAuthorisedException) do
        bucket.update([] of Barite::B2::LifecycleRule)
      end
    end

    it "handles lifecycle rule set" do
      rules = [
        Barite::B2::LifecycleRule.new({
          "fileNamePrefix" => "testing/",
          "daysFromHidingToDeleting" => 11}),
        Barite::B2::LifecycleRule.new({
          "fileNamePrefix" => "other/",
          "daysFromUploadingToHiding" => 33})
        ]
        expect_raises(Barite::NotAuthorisedException) do
          bucket.update(rules)
        end
    end
  end
end

