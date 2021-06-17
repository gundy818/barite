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

      property account_id : String?
      property api_token : String?
      property api_url : String?

      # Initialise with authentication keys.
      # The key_id and key are created from your Backblaze login. Ensure that this key has
      # the capabilities that you will need. For example the ability to read and/or write
      # files is the buckets that you'll be using.
      def initialize(@key_id : String, @key : String)
      end

      # Access backblaze to authenticate.
      # Initialises @account_id, @api_url and @api_token on success.
      def authorize_account()
        begin
          result = Crest::Request.get(
            "https://api.backblazeb2.com/b2api/v2/b2_authorize_account",
            user: @key_id,
            password: @key
          )
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
        authorize_account() if @account_id.nil?

        return @account_id.as(String)
      end

      # Retrieve the API token.
      # Caches the result on first access.
      def api_token() : String
        authorize_account() if @api_token.nil?

        return @api_token.as(String)
      end

      # Retrieve the API URL.
      # Caches result on first access.
      def api_url() : String
        authorize_account() if @api_url.nil?

        return @api_url.as(String)
      end

      # Return a B2Bucket object referencing the named bucket.
      def file(bucket_name : String) : Barite::B2Bucket
        return Barite::B2Bucket.new(self, bucket_name)
      end

      # Return a File object referencing the selected file in the named bucket.
      def file(bucket_name : String, file_name : String) : Barite::B2::File
        return Barite::B2::File.new(self, bucket_name, file_name)
      end

      # Retrieve the bucket ID for a bucket name.
      def get_bucket_id(bucket_name)
        begin
          request = Crest::Request.new(:post,
            "#{api_url()}/b2api/v2/b2_list_buckets",
            headers: {
              "Authorization" => api_token(),
              "Content-Type" => "application/json"
            },
            form: {
              "accountId" => account_id(),
              "bucketName" => bucket_name
            }.to_json
          )
          response = request.execute
        rescue ex : Crest::BadRequest
          raise Barite::BadRequestException.new("Error listing buckets: #{ex.response}")
        rescue ex : Crest::Unauthorized
          raise Barite::NotAuthorisedException.new("Not authorised for bucket #{bucket_name}: #{ex.response}")
        end

        data = JSON.parse(response.body)
        bucket = data["buckets"][0]

        return bucket["bucketId"].to_s
      end

      # Retrieve an upload URL for a specific bucket.
      # Raises a Barite::NotFoundException on error.
      def get_upload_url(bucket_id)
        begin
          request = Crest::Request.new(:post,
            "#{api_url}/b2api/v2/b2_get_upload_url",
            headers: {
              "Authorization" => api_token(),
              "Content-Type" => "application/json"
            },
            form: {
              "bucketId" => bucket_id
            }.to_json
          )
          response = request.execute
        rescue ex : Crest::BadRequest
          raise Barite::NotFoundException.new("Error getting upload URL: #{ex.response}")
        end

        data = JSON.parse(response.body)
        # puts("Upload is authorised.")

        return data["uploadUrl"].to_s, data["authorizationToken"].to_s
      end
    end
  end
end

