#


module Barite
  VERSION = {{ `shards version #{__DIR__}`.chomp.stringify }}

end

require "./b2/**"

