#
# TODO:
# - Provide a way to set lifecycle rules to automatically delete old file versions.
#
require "../exception"
require "crest"
require "digest/sha1"
require "json"


module Barite
  module B2

    # The main API interface.
    #
    # This object is lazy, in that it will only access Backblaze when it needs to. If you
    # just create the object then destroy it, no connections will be made to Backblaze.
    #
    # This also means that you wont know that your authentication is correct until you
    # make an access.
    class API
      getter key : String
      getter key_id : String

      @account_id : String?
      @api_token : String?
      @api_url : String?

      # The text_exception is for testing.
      # If it is set, then any method that calls
      # Backblaze will just raise this exception, rather than actually making the call.
      property test_exception : ::Exception?

      # The test_response is for debugging.
      # If it is set, then and method that calls
      # Backblaze will just return this response, rather than actually making the call.
      property test_response : Crest::Response?

      # Initialise with authentication keys.
      # The key_id and key are created from your Backblaze login. Ensure that this key has
      # the capabilities that you will need. For example the ability to read and/or write
      # files is the buckets that you'll be using.
      def initialize(@key_id : String, @key : String)
        @account_id = nil
        @api_token = nil
        @api_url = nil
        @test_exception = nil
        @test_exception = nil
        @test_response = nil
      end

      # This does the raw API calls to Backblaze.
      # It has a couple of features to aid testing. See the description of the
      # '@test_exception' and @test_response' variables.
      # Returns a Crest::Response object.
      def api_get(call : String) : Crest::Response?
        @test_exception.try do |exc|
          @test_exception = nil
          raise exc
        end

        if @test_response.nil?
          result = Crest::Request.get(
            "https://api.backblazeb2.com/b2api/v2/#{call}",
            user: @key_id,
            password: @key
          )
          else
            result = @test_response
            @test_response = nil
        end

        return result
      end

      def api_post(call : String, headers, body) Crest::Response?
        @test_exception.try do |exc|
          @test_exception = nil
          raise exc
        end

        @test_response.try do |resp|
          @test_response = nil
          return resp
        end

        request = Crest::Request.new(:post,
                                     "#{api_url()}/b2api/v2/#{call}",
                                     headers: headers,
                                     form: body)
        return request.execute
      end

      # Access backblaze to authenticate.
      # Initialises @account_id, @api_url and @api_token on success.
      def authorize_account()
        begin
          result = api_get("b2_authorize_account")

          # make sure it's not 'nil'
          result = result.as(Crest::Response)
        rescue ex : Socket::Addrinfo::Error
          raise Barite::AuthenticationException.new("Error resolving name: #{ex.message}")
        end

        data = JSON.parse(result.body)

        @account_id = data["accountId"].to_s
        @api_url = data["apiUrl"].to_s
        @api_token = data["authorizationToken"].to_s
      end

      # Retrieve the account_id.
      # Caches result on first access.
      def account_id() : String
        @account_id.try { |id|  return id }

        authorize_account()

        return @account_id.as(String)
      end

      def account_id=(@account_id)
      end

      # Retrieve the API token.
      # Caches the result on first access.
      def api_token() : String
        @api_token.try { |tkn| return tkn }

        authorize_account()

        return @api_token.as(String)
      end

      # getter for @api_token.
      def api_token=(@api_token)
      end

      # Retrieve the API URL.
      # Caches result on first access.
      def api_url() : String
        @api_url.try { |url|  return url }

        authorize_account()

        return @api_url.as(String)
      end

      # getter for @api_url.
      def api_url=(@api_url)
      end

      # Return a B2::Bucket object referencing the named bucket.
      def bucket(bucket_name : String) : Barite::B2::Bucket
        return Barite::B2::Bucket.new(self, bucket_name)
      end

      # Return a File object referencing the selected file in the named bucket.
      def file(bucket_name : String, file_name : String) : Barite::B2::File
        return Barite::B2::File.new(self, bucket_name, file_name)
      end

      # Retrieve the bucket ID for a bucket name.
      def get_bucket_id(bucket_name) : String?
        begin
          response = api_post("b2_list_buckets",
                              headers: {
                                "Authorization" => api_token(),
                                 "Content-Type" => "application/json"
                               },
                               body: {
                                 "accountId" => account_id(),
                                 "bucketName" => bucket_name
                               }.to_json)
        rescue ex : Crest::BadRequest
          raise Barite::BadRequestException.new("Error listing buckets: #{ex.response}")
        rescue ex : Crest::Unauthorized
          raise Barite::NotAuthorisedException.new("Not authorised for bucket #{bucket_name}: #{ex.response}")
        end

        data = JSON.parse(response.body)

        case response.status_code
        when 200
          buckets = data["buckets"]
          return nil if buckets.size < 1

          bucket = buckets[0]
          return bucket["bucketId"].to_s
        when 400
          code = data["code"]
          message = data["message"]
          raise Barite::BadRequestException.new("Bad request #{code}: #{message}")
        when 401, 403
          code = data["code"]
          message = data["message"]
          raise Barite::NotAuthorisedException.new("Not authorised #{code}: #{message}")
        end

        return nil
      end

      # Retrieve an upload URL for a specific bucket.
      # Raises a Barite::NotFoundException on error.
      def get_upload_url(bucket_id)
        begin
          response = api_post("b2_get_upload_url",
            headers: {
              "Authorization" => api_token(),
              "Content-Type" => "application/json"
            },
            body: {
              "bucketId" => bucket_id
            }.to_json
          )
        rescue ex : Crest::BadRequest
          raise Barite::NotFoundException.new("Error getting upload URL: #{ex.response}")
        rescue ex : Crest::Unauthorized
          raise Barite::NotAuthorisedException.new("Not authorised for bucket #{bucket_id}: #{ex.response}")
        end

        data = JSON.parse(response.body)

        case response.status_code
        when 200
          return data["uploadUrl"].to_s, data["authorizationToken"].to_s
        when 400
          code = data["code"]
          message = data["message"]
          raise Barite::BadRequestException.new("Bad request #{code}: #{message}")
        when 401, 403
          code = data["code"]
          message = data["message"]
          raise Barite::NotAuthorisedException.new("Not authorised #{code}: #{message}")
        else
          puts("XXX status code: #{response.status_code}")
        end
      end
    end
  end
end

