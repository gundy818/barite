# Exception definitions for the Barite module.
#
# In general, Barite will return these in preference to generic exceptions in places
# where it can add some context and make the errors easier to interpret.
#
# If you want to trap all barite exceptions, you can:
#
#     begin
#       something
#     rescue BariteException
#       ...
#     end
#


module Barite
  # Base exception.
  class Exception < Exception
  end

  # Badly formatted request.
  class BadRequestException < Barite::Exception
  end

  # Aomething went wrong with authentication.
  # The specific message will tell you more. It could be a problem with credentials, or
  # an error communicating with Backblazw.
  class AuthenticationException < Barite::Exception
  end

  # You are not authorised for this action
  class NotAuthorisedException < Barite::Exception
  end

  # Something was not found.
  # You should get this if you try to retrieve or access something and there's a
  # problem. Either the resource doesn't exist, or you don't have permissions, or there
  # may have been a comms error.
  class NotFoundException < Barite::Exception
  end
end

