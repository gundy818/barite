
require "../spec_helper"
require "http"

describe Barite do
  barite_key_id = "fake_key_id"
  barite_key = "fake_key"

  b2 = Barite::B2::API.new(barite_key_id, barite_key)

  describe "initialisation" do
    it "works" do
      b2
    end

    it "initialises key" do
      b2.key.should eq barite_key
      b2.key_id.should eq barite_key_id
    end
  end

  describe "authorize_account" do
    it "flags a name resolution error" do
      b2.test_exception = Socket::Addrinfo::Error.new(0, "Hi", "There")

      expect_raises(Barite::AuthenticationException) do
        b2.authorize_account()
      end
    end
  end

  describe "account_id" do
    it "tries backblaze if not initialised" do
      b2.test_exception = ::Exception.new("Try Backblaze")

      b2.account_id = nil
      expect_raises(::Exception, "Try Backblaze") do
        b2.account_id()
      end
    end

    it "honours cache" do
      the_id = "theid"
      b2.account_id = the_id

      b2.account_id().should eq the_id
    end
  end

  describe "api_token" do
    it "tries backblaze if not initialised" do
      b2.test_exception = ::Exception.new("Try Backblaze")

      b2.api_token = nil
      expect_raises(::Exception, "Try Backblaze") do
        b2.api_token()
      end
    end

    it "honours cache" do
      the_token = "a token"
      b2.api_token = the_token
      b2.api_token().should eq the_token
    end
  end

  describe "api_url" do
    it "tries backblaze if not initialised" do
      b2.test_exception = ::Exception.new("Try Backblaze")

      b2.api_url = nil
      expect_raises(::Exception, "Try Backblaze") do
        b2.api_url()
      end
    end

    it "honours cache" do
      the_token = "a token";
      b2.api_url = the_token;
      b2.api_url().should eq the_token
    end
  end

  describe "bucket" do
    it "returns an initialised Bucket" do
      b2.bucket("a_bucket").is_a?(Barite::B2::Bucket)
    end
  end

  describe "file" do
    it "returns an initialised File" do
      b2.file("a bucket", "a file").is_a?(Barite::B2::File)
    end
  end

  describe "get_bucket_id" do
    it "handles Crest::BadRequest" do
      req = Crest::Request.new(:get, "http://something/")
      resp = HTTP::Client::Response.new(402)

      b2.test_exception = Crest::BadRequest.new(Crest::Response.new(resp, req))

      expect_raises(Barite::BadRequestException) do
        b2.get_bucket_id("a bucket")
      end
    end

    it "handles Crest::Unauthorized" do
      req = Crest::Request.new(:get, "http://something/")
      resp = HTTP::Client::Response.new(402)

      b2.test_exception = Crest::Unauthorized.new(Crest::Response.new(resp, req))

      expect_raises(Barite::NotAuthorisedException) do
        b2.get_bucket_id("a bucket")
      end
    end

    it "handles no match" do
      bucket_name = "a bucket"

      req = Crest::Request.new(:get, "http://something/")
      body = { "buckets": [] of Hash(String, String)}.to_json
      headers = HTTP::Headers.new
      headers.add("Content-Type", "application/json")
      resp = HTTP::Client::Response.new(200, headers: headers, body: body)
      b2.test_response = Crest::Response.new(resp, req)
      b2.get_bucket_id(bucket_name).should be_nil
    end

    it "handles a match" do
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

      headers = HTTP::Headers.new
      headers.add("Content-Type", "application/json")
      resp = HTTP::Client::Response.new(200, headers: headers, body: data)
      b2.test_response = Crest::Response.new(resp, req)
      b2.get_bucket_id(bucket_name).should eq(bucket_id)
    end
  end

  describe "get_upload_url" do
    it "handles Crest::BadRequest" do
      req = Crest::Request.new(:get, "http://something/")
      resp = HTTP::Client::Response.new(402)

      b2.test_exception = Crest::BadRequest.new(Crest::Response.new(resp, req))

      expect_raises(Barite::NotFoundException) do
        b2.get_upload_url("an id")
      end
    end

    it "handles Crest::Unauthorized" do
      req = Crest::Request.new(:get, "http://something/")
      resp = HTTP::Client::Response.new(402)

      b2.test_exception = Crest::Unauthorized.new(Crest::Response.new(resp, req))

      expect_raises(Barite::NotAuthorisedException) do
        b2.get_upload_url("a bucket")
      end
    end

    it "succeeds" do
      bucket_id = "an id"
      auth_token = "a token"
      upload_url = "http://a/url"

      req = Crest::Request.new(:get, "http://something/")
      data = {
        "bucketId" => bucket_id,
        "uploadUrl" => upload_url,
        "authorizationToken" => auth_token
      }.to_json

      headers = HTTP::Headers.new
      headers.add("Content-Type", "application/json")
      resp = HTTP::Client::Response.new(200, headers: headers, body: data)

      b2.test_response = Crest::Response.new(resp, req)

      result = b2.get_upload_url("a bucket")
      result.should_not be_nil

      result.try do |res|
        res[0].should eq(upload_url)
        res[1].should eq(auth_token)
      end
    end
  end
end

