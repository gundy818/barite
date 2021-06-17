#
#

module Barite
  module B2
    # A single lifecycle rule.
    # These have three variables. The name is mandatory, the
    # @days_from_hiding_to_deleting=nil and @days_from_uploading_to_hiding=nil values
    # are optional. See https://www.backblaze.com/b2/docs/lifecycle_rules.html for a
    # full explanation of the components of these rules.
    class LifecycleRule
      getter days_from_hiding_to_deleting : Int32?;
      getter days_from_uploading_to_hiding : Int32?;
      getter file_name_prefix : String;

      # Initialise from variables.
      # file_name_prefix can be any name. A single lifecycle rule matches the start of
      # any filename stored in B2.
      def initialize(@file_name_prefix, @days_from_hiding_to_deleting=nil, @days_from_uploading_to_hiding=nil)
      end

      # Initialise from a hash.
      # The keys of the hash are exactly as speficified in the Backblaze API docs.
      # Extra fields are allowed, but will be ignored.
      def initialize(rule : Hash(String, (String|Int32)?))
        @file_name_prefix = rule["fileNamePrefix"].as(String)
        @days_from_hiding_to_deleting = rule.fetch("daysFromHidingToDeleting", nil).as(Int32?)
        @days_from_uploading_to_hiding = rule.fetch("daysFromUploadingToHiding", nil).as(Int32?)
      end

      # Return a hash.
      # The hash is compatible with the Backblaze API. The 'daysFrom*' keys are omitted
      # if their values are nil.
      def to_hash()
        return {
          "fileNamePrefix" => @file_name_prefix,
          "daysFromHidingToDeleting" => @days_from_hiding_to_deleting,
          "daysFromUploadingToHiding" => @days_from_uploading_to_hiding
        }.compact
      end
    end
  end
end

