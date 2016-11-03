module MappingMethods

module Utils

def reformat_name(name)
  	name.gsub!(" ", "")
    name.gsub!(".", "")
    name.gsub!(",","")
    name.gsub!("(","")
    name.gsub!(")","")
    name.gsub!("-","")
    name.gsub!("&","and")
    name.gsub!("'","")
    name.gsub!("\"","")
    name.gsub!(":","")
    return name

end

def clean_fulltext(subject, data)
  graph = RDF::Graph.new
  if data.empty?
  return graph
  end
  # Converting ASCII-8BIT to UTF-8 based domain-specific guesses
  if data.is_a? String
    begin
      # Try it as UTF-8 directly
      cleaned = data.dup.force_encoding('UTF-8')
      unless cleaned.valid_encoding?
        
        cleaned = data.encode( 'UTF-8' )
      end
      data = cleaned
    rescue EncodingError
      # Force it to UTF-8, throwing out invalid bits
      data.encode!( 'UTF-8', invalid: :replace, undef: :replace )
    end
  end
  
  graph = RDF::Statement(subject, RDF::URI("http://opaquenamespace.org/ns/fullText"), data)
  graph
  end
  
#https://github.com/sunspot/sunspot/issues/570
def clean_fulltext2(subject, data)
  graph = RDF::Graph.new
  if data.empty?
  return graph
  end
  data.encode!( 'UTF-16', invalid: :replace, undef: :replace )
  data.encode!( 'UTF-8', invalid: :replace, undef: :replace )
  cleaned = strip_control_chars(data)
 
  
  graph = RDF::Statement(subject, RDF::URI("http://opaquenamespace.org/ns/fullText"), cleaned)
  graph
  end
  
  def strip_control_chars(value)
        return value unless value.is_a? String

        value.chars.inject("") do |str, char|
          unless char.ascii_only? && (char.ord < 32 || char.ord == 127)
            str << char
          end
          str
        end

      end

end
end