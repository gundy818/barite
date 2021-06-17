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

describe Barite::B2::LifecycleRule do
  describe "default initialisation" do
    file_name_prefix = "file/prefix/";
    lr = Barite::B2::LifecycleRule.new(file_name_prefix)

    it "initialises name" do
      lr.file_name_prefix.should be(file_name_prefix)
      lr.days_from_hiding_to_deleting.should be_nil;
      lr.days_from_uploading_to_hiding.should be_nil;
    end
  end
  describe "value initialisation" do
    file_name_prefix = "file/prefix/";
    dfhtd = 99;
    dfuth = 55;
    lr = Barite::B2::LifecycleRule.new(file_name_prefix, dfhtd, dfuth)

    it "initialises values" do
      lr.file_name_prefix.should be(file_name_prefix)
      lr.days_from_hiding_to_deleting.should eq dfhtd;
      lr.days_from_uploading_to_hiding.should eq dfuth;
    end
  end
  describe "default initialisation from hash" do
    file_name_prefix = "file/prefix/"
    hash = {
      "fileNamePrefix" => file_name_prefix
    } of String => String | Int32;

    lr = Barite::B2::LifecycleRule.new(hash)

    it "initialises name" do
      lr.file_name_prefix.should be(file_name_prefix)
      lr.days_from_hiding_to_deleting.should be_nil;
      lr.days_from_uploading_to_hiding.should be_nil;
    end
  end
  describe "value initialisation from hash" do
    dfhtd = 99;
    dfuth = 55;
    file_name_prefix = "file/prefix/";
    hash = {
      "fileNamePrefix" => file_name_prefix,
      "daysFromHidingToDeleting" => dfhtd,
      "daysFromUploadingToHiding" => dfuth
    }

    lr = Barite::B2::LifecycleRule.new(hash)

    it "initialises values" do
      lr.file_name_prefix.should be(file_name_prefix)
      lr.days_from_hiding_to_deleting.should eq dfhtd;
      lr.days_from_uploading_to_hiding.should eq dfuth;
    end
  end

  describe "to_hash from default" do
    file_name_prefix = "file/prefix/";
    hash = {
      "fileNamePrefix" => file_name_prefix
    } of String => (String | Int32)?;

    lr = Barite::B2::LifecycleRule.new(hash)

    it "matches input" do
      lr.to_hash.should eq hash;
    end
  end

  describe "to_hash" do
    dfhtd = 99;
    dfuth = 55;
    file_name_prefix = "file/prefix/";
    hash = {
      "fileNamePrefix" => file_name_prefix,
      "daysFromHidingToDeleting" => dfhtd,
      "daysFromUploadingToHiding" => dfuth
    }

    lr = Barite::B2::LifecycleRule.new(hash)

    it "matches input" do
      lr.to_hash.should eq hash
    end
  end
end

