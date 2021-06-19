
require "../spec_helper"

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
      the_token = "a token";
      b2.api_token = the_token;
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
end

