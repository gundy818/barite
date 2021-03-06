#
# TODO:
# - Provide a way to set lifecycle rules to automatically delete old file versions.
# 
require "./exception"
require "crest"
require "digest/sha1"
require "json"


module Barite
  VERSION = "0.1.0"

  # The B2 class is the main API interface.
  #
  # This object is lazy, in that it will only access Backblaze whien it needs to. If you
  # just create the object then destroy it, no connections will be made to Backblaze.
  #
  # This also means that you wont know that your authentication is correct until you
  # make an access.
  class B2
    @account_id : String?
    @api_token : String?
    @api_url : String?

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

    # Return a B2File object referencing the selected file in the named bucket.
    def file(bucket_name : String, file_name : String) : Barite::B2File
      return Barite::B2File.new(self, bucket_name, file_name)
    end

    # Retrieve the bucket ID for a bucket name.
    def get_bucket_id(bucket_name)
      begin
        request = Crest::Request.new(:post,
          "#{api_url}/b2api/v2/b2_list_buckets",
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
        raise Barite::Exception.new("Error listing buckets: #{ex.response}")
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

  # Represents a file in a specific bucket on Backblaze.
  # This is normally generated by calling B2#file.
  # Once you have this object you can upload and download the file using B2File#upload,
  # B2File#download.
  class B2File
    # The linked B2 object.
    getter b2

    # The bucket containing this file.
    getter bucket_name

    # The filename as stored in the bucket.
    getter file_name

    @bucket_id : String?
    @upload_token : String?
    @upload_url : String?

    # Create a reference for the named file in the named bucket.
    # Note that the @max_versions parameter is not yet used. Every time you
    # upload the same file name you will create a new version of the same file.
    # Note that B2 filenames are strings but they can include a path, such as "abc/def".
    # Some tools will interpret this as a file called 'def' in a folder 'abc', and it is
    # OK to think of it like this, but the 'abc/' is really just part of the filename.
    def initialize(@b2 : Barite::B2, @bucket_name : String, @file_name : String)
    end

    # Retrieve the bucket ID.
    # Caches the result on first use.
    def bucket_id() : String
      @bucket_id = @b2.get_bucket_id(@bucket_name) if @bucket_id.nil?

      return @bucket_id.as(String)
    end

    # Downloads the referenced file to a local file.
    # local_file_path is the pull path, including filename.
    # If the stored file has a modification time stored in a
    # "X-Bz-Info-src_last_modified_millis" header, the timestamp will be set on the file
    # after a successful download.
    def download(local_file_path : String)
      # this needs to be percent encoded
      x_bz_file_name = @file_name
    
      response = Crest.get(
        "#{@b2.api_url()}/file/#{@bucket_name}/#{x_bz_file_name}",
        headers: {
          "Authorization" => @b2.api_token(),
        },
      )

      File.write(local_file_path, response.body)

      # set the modified time on the file if the header is present
      begin
        modified_time = Time.unix_ms(response.headers["X-Bz-Info-src_last_modified_millis"].as(String).to_i64)
        File.utime(modified_time, modified_time, local_file_path)
      rescue KeyError
        # doesnt matter, dont set the time
      end
    end

    # Retrieve the upload token for the bucket.
    # Caches the result on first use.
    # Upload tokens seem to be re-usable, so you only need to get it once.
    def upload_token() : String
      @upload_url, @upload_token = @b2.get_upload_url(bucket_id()) if @upload_token.nil?

      return @upload_token.as(String)
    end

    # Retrieve the upload URL.
    # Caches the result on first use.
    def upload_url() : String
      @upload_url, @upload_token = @b2.get_upload_url(bucket_id()) if @upload_url.nil?

      return @upload_url.as(String)
    end

    # Upload the file from the local file path.
    # The modification time from the local file is set in the
    # "X-Bz-Info-src_last_modified_millis" header, so it will be returned when the file
    # is downloaded.
    def upload(local_file_path : String)
      # this needs to be percent encoded
      x_bz_file_name = file_name
      begin
        content = File.read(local_file_path)
      rescue ex : File::NotFoundError
        raise Barite::NotFoundException.new("Error opening file: #{local_file_path}")
      end

      content_sha = Digest::SHA1.hexdigest(content)
      content_length = File.size(local_file_path)
      modified_time = File.info(local_file_path).modification_time.to_unix_ms
      x_bz_server_side_encryption = "AES256"

      response = Crest.post(
        upload_url(),
        headers: {
          "Authorization" => upload_token,
          "Content-Length" => content_length.to_s,
          "Content-Type" => "text/plain",
          "X-Bz-Content-Sha1" => content_sha,
          "X-Bz-File-Name" => x_bz_file_name,
          "X-Bz-Info-src_last_modified_millis" => modified_time.to_s,
          "X-Bz-Server-Side-Encryption" => "AES256"
        },
        form: content
      )

      data = JSON.parse(response.body)
      file_id = data["fileId"].to_s

      return file_id
    end
  end
end

