#
#
require "../exception"
require "./lifecycle_rule"
require "crest"
require "digest/sha1"
require "json"


module Barite
  module B2
    # Represents a bucket on Backblaze.
    # This is normally generated by calling B2#bucket.
    # Once you have this object you can set lifecycle rules, etc.
    class Bucket
      # The linked B2 object.
      getter b2

      @lifecycle_rules : Array(Barite::B2::LifecycleRule)?

      # The bucket name.
      getter bucket_name

      @bucket_id : String?

      # Create a reference for the named bucket.
      def initialize(@b2 : Barite::B2, @bucket_name : String)
      end

      # Retrieve the bucket ID.
      # Caches the result on first use.
      def bucket_id() : String
        @bucket_id ||= @b2.get_bucket_id(@bucket_name)

        return @bucket_id.as(String)
      end

      # Updates the bucket properties passed.
      # Updates the local cached version of @lifecycls_rules.
      def update(lifecycle_rules : Array(Barite::B2::LifecycleRule))
        content = {
          "accountId" => @b2.account_id(),
          "bucketId" => bucket_id(),
          "lifecycleRules" => lifecycle_rules.map {|r| r.to_hash()}
        }

        response = Crest.post(
          @b2.api_url(),
          headers: {
            "Authorization" => @b2.api_token(),
          },
          form: content.to_json
        )

        data = JSON.parse(response.body)
        data["lifecycleRules"].each do |r|
          puts "XXX rule: #{r}"
        end
      end
    end
  end
end
