#
#

require "../spec_helper"

describe Barite::B2::Bucket do
  barite_key_id = "fake_key_id"
  barite_key = "fake_key"
  bucket_name = "a bucket"
  bucket_id = "an id"

  req = Crest::Request.new(:get, "http://something/")
  data = {
    "buckets": [
      {
        "bucketId" => bucket_id,
        "bucketName" => bucket_name
      }
    ]
  }.to_json

  b2 = Barite::B2::API.new(barite_key_id, barite_key)
  headers = HTTP::Headers.new
  headers.add("Content-Type", "application/json")
  resp = HTTP::Client::Response.new(200, headers: headers, body: data)
  b2.test_response = Crest::Response.new(resp, req)

  bucket = b2.bucket(bucket_name)

  describe "initialisation" do
    it "works" do
      bucket
    end
  end

  describe "bucket_id" do
    it "tries backblaze if not initialised" do
      # just make sure that this exception is raised if it tries to call backblaze
      b2.test_exception = ::Exception.new("Try Backblaze")

      bucket.bucket_id = nil
      expect_raises(::Exception, "Try Backblaze") do
        bucket.bucket_id()
      end
    end

    it "honours cache" do
      # if it's set (to anything), just use it
      the_id = "theid"
      bucket.bucket_id = the_id

      bucket.bucket_id().should eq the_id
    end
  end

  describe "update" do
    # not really testing anything at this point

    # fake the account id
    b2.account_id = "an id"

    b2.test_exception = ::Exception.new("Try Backblaze")

    expect_raises(::Exception, "Try Backblaze") do
      bucket.update([] of Barite::B2::LifecycleRule)
    end
  end
end

