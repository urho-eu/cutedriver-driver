############################################################################
##
## Copyright (C) 2010 Nokia Corporation and/or its subsidiary(-ies).
## All rights reserved.
## Contact: Nokia Corporation (testabilitydriver@nokia.com)
##
## This file is part of Testability Driver.
##
## If you have questions regarding the use of this file, please contact
## Nokia at testabilitydriver@nokia.com .
##
## This library is free software; you can redistribute it and/or
## modify it under the terms of the GNU Lesser General Public
## License version 2.1 as published by the Free Software Foundation
## and appearing in the file LICENSE.LGPL included in the packaging
## of this file.
##
############################################################################

ENV['TDRIVER_VERSION'] = '2.0.0'

module TDriver
  VERSION = ENV['TDRIVER_VERSION']

  module Version # :nodoc: all
    MAJOR, MINOR, BUILD, *OTHER = TDriver::VERSION.split "."

    NUMBERS = [MAJOR, MINOR, BUILD, *OTHER]
  end
end

#
# version information
#
def read_version
  relmode = "  Release mode: "
  if @__release_mode
    relmode << @__release_mode
  else
    relmode << "unspecified"
  end
  puts relmode

  if(@__release_mode == 'release')
    return TDriver::VERSION
  elsif( @__release_mode == 'cruise' )
    return TDriver::VERSION + "." + Time.now.strftime("pre%Y%m%d")
  else
    return TDriver::VERSION + "." + Time.now.strftime("%Y%m%d%H%M%S")
  end
end
