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

module MobyUtil

  module XML    

    # Get current XML parser
    # == params
    # == return
    # Module:: 
    # == raises
    def self.current_parser

      @@parser

    end

    # Set XML parser to be used
    # == params
    # Module:: 
    # == return
    # nil
    # Document:: XML document object
    # == raises
    def self.current_parser=( value )

      #raise RuntimeError, "Parser can be set only once per session" unless defined?( @@parser )

      # set current parser
      @@parser = value

      # apply parser implementation to abstraction modules
      [ 
        MobyUtil::XML::Document, 
        MobyUtil::XML::Element, 
        MobyUtil::XML::Nodeset, 
        MobyUtil::XML::Attribute, 
        MobyUtil::XML::Text, 
        MobyUtil::XML::Builder,
        MobyUtil::XML::Comment ].each do | _module |
          
          _module.module_exec{ 

            # include parser implementation to abstraction modules 
            include MobyUtil::KernelHelper.get_constant( "#{ @@parser }::#{ _module.name.split('::').last }") 

          }
        
      end

      # return current parser as result
      value

    end

    # Create XML Document object by parsing XML from string
    #
    # Usage: MobyUtil::XML.parse_string('<root>value</root>') 
    #  ==> Returns XML document object; default xml parser will be used. 
    #
    # == params
    # xml_string:: String containing XML  
    # == return
    # Document:: XML document object
    # == raises
    def self.parse_string( xml_string )

      begin

        MobyUtil::XML::Document.new( nil ).tap{ | document | 

          # parse given string
          document.xml = document.parse( xml_string ) 

        }

      rescue Exception => exception

        if $TDRIVER_INITIALIZED == true
        
          # string for exception message
          dump_location = ""

          # check if xml parse error logging is enabled
          if $parameters[ :logging_xml_parse_error_dump, 'true' ].to_s.to_boolean

            # construct filename for xml dump
            filename = 'xml_error_dump'

            # add timestamp to filename if not overwriting the existing dump file 
            unless $parameters[ :logging_xml_parse_error_dump_overwrite, 'false' ].to_s.to_boolean

              filename << "_#{ Time.now.to_i }"

            end

            # add file extension
            filename << '.xml'

            # ... join filename with xml dump output path 
            path = File.join( MobyUtil::FileHelper.expand_path( $parameters[ :logging_xml_parse_error_dump_path ] ), filename )

            begin

              # write xml string to file
              File.open( path, "w" ){ | file | file << xml_string }

              dump_location = "Saved to #{ path }"

            rescue

              dump_location = "Error while saving to file #{ path }"

            end

          end

          # raise exception
          #Kernel::raise MobyUtil::XML::ParseError.new( "%s (%s)%s" % [ exception.message.gsub("\n", ''), exception.class, dump_location ] )
          Kernel::raise MobyUtil::XML::ParseError, "#{ exception.message.gsub("\n", '') } (#{ exception.class }). #{ dump_location }"

        else
        
          # raise exception
          #Kernel::raise MobyUtil::XML::ParseError.new( "%s (%s)" % [ exception.message.gsub("\n", ''), exception.class ] )
          Kernel::raise MobyUtil::XML::ParseError, "#{ exception.message.gsub("\n", '') } (#{ exception.class })"
        
        end

      end

    end

    # Create XML Document object by parsing XML from file
    #
    # Usage: MobyUtil::XML.parse_file('xml_dump.xml') 
    #  ==> Returns XML document object; default xml parser will be used. 
    #
    # == params
    # filename:: String containing path and filename of XML file.    
    # == return
    # Document:: XML document object
    # == raises
    # IOError:: File '%s' not found    
    def self.parse_file( filename )    

      # raise exception if file not found
      Kernel::raise IOError, "File #{ filename.inspect } not found" unless File.exist?( filename )

      self.parse_string( IO.read( filename ) )

    end

    # Create XML builder object dynamically
    #
    # Usage:
    #
    #  MobyUtil::XML.build{
    #    root{
    #      element(:name => "element_name", :id => "0") {
    #        child(:name => "1st_child_of_element_0", :value => "123" )        
    #        child(:name => "2nd_child_of_element_0", :value => "456" )
    #      }
    #    }
    #  }.to_xml
    #
    # == params
    # &block:: 
    # == return
    # MobyUtil::XML::Builder
    # == raises
    def self.build( &block )

      begin

        MobyUtil::XML::Builder.new.tap{ | builder | 

          builder.build( &block )

        }

      rescue Exception => exception

        Kernel::raise MobyUtil::XML::BuilderError, "#{ exception.message } (#{ exception.class })"

      end
      
    end

    # enable hooking for performance measurement & debug logging
    TDriver::Hooking.hook_methods( self ) if defined?( TDriver::Hooking )

  end # XML

end # MobyUtil

# set used parser module
MobyUtil::XML.current_parser = MobyUtil::XML::Nokogiri
