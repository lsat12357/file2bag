require 'rdf'
require 'rdf/raptor'


module MappingMethods
  module Identi
    def identi_tif(subject, data)
      graph = RDF::Graph.new
      graph << RDF::Statement.new(subject, RDF::URI.new("http://purl.org/dc/terms/identifier"), RDF::Literal.new(data))
      graph << RDF::Statement.new(subject, RDF::URI.new("http://opaquenamespace.org/ns/full"), RDF::Literal.new(data + ".tif") )
       
      graph
    end
    
    def identi_pdf(subject, data)
      graph = RDF::Graph.new
      graph << RDF::Statement.new(subject, RDF::URI.new("http://purl.org/dc/terms/identifier"), RDF::Literal.new(data))
      graph << RDF::Statement.new(subject, RDF::URI.new("http://opaquenamespace.org/ns/full"), RDF::Literal.new(data + ".pdf") )
       
      graph
    end
    
     def percent_identi(subject, data)
      graph = RDF::Graph.new
      graph << RDF::Statement.new(subject, RDF::URI.new("http://opaquenamespace.org/ns/cco/accessionNumber"), RDF::Literal.new(data))
      graph << RDF::Statement.new(subject, RDF::URI.new("http://opaquenamespace.org/ns/full"), RDF::Literal.new(data + ".tif") )
       
      graph
    end
    
      def identi_jpg(subject, data)
      graph = RDF::Graph.new
      graph << RDF::Statement.new(subject, RDF::URI.new("http://purl.org/dc/terms/identifier"), RDF::Literal.new(data))
      graph << RDF::Statement.new(subject, RDF::URI.new("http://opaquenamespace.org/ns/full"), RDF::Literal.new(data + ".jpg") )
       
      graph
    end
    
    def wwdl_identi_tif(subject, data)#for the photo part
      graph = RDF::Graph.new
      graph << RDF::Statement.new(subject, RDF::URI.new("http://purl.org/dc/terms/identifier"), RDF::Literal.new(data))
      filename = data.gsub("ORU_", "")
      graph << RDF::Statement.new(subject, RDF::URI.new("http://opaquenamespace.org/ns/full"), RDF::Literal.new(filename + ".tif") )
       
      graph
    end
    
    def uoath_full(subject, data)
    	graph = RDF::Graph.new
    	graph << RDF::Statement.new(subject, RDF::URI("http://purl.org/dc/terms/type"), RDF::URI("http://purl.org/dc/dcmitype/Image"))
    	
    	#get file type
    	parts = data.split("/")
    	graph << RDF::Statement.new(subject, RDF::URI("http://opaquenamespace.org/ns/full"),parts.last)
    	if parts.last.downcase.include? "jpg"
    	  graph << RDF::Statement.new(subject, RDF::URI("http://purl.org/dc/terms/format"), RDF::URI("http://purl.org/NET/mediatypes/image/jpeg")) 
    	elsif parts.last.downcase.include? "tif"
    	  graph << RDF::Statement.new(subject, RDF::URI("http://purl.org/dc/terms/format"), RDF::URI("http://purl.org/NET/mediatypes/image/tiff"))
    	end
    	graph
    end
    
    def identi_univ(subject, data)
        
        graph = RDF::Graph.new
        parts = data.split("\\")
        parts2 = parts.last.split("/")
        puts parts2.last
		graph << RDF::Statement.new(subject, RDF::URI("http://opaquenamespace.org/ns/full"),RDF::Literal.new(parts2.last))
		
    	if parts2.last.downcase.include? "jpg"
    	  graph << RDF::Statement.new(subject, RDF::URI("http://purl.org/dc/terms/format"), RDF::URI("http://purl.org/NET/mediatypes/image/jpeg")) 
    	elsif parts2.last.downcase.include? "tif"
    	  graph << RDF::Statement.new(subject, RDF::URI("http://purl.org/dc/terms/format"), RDF::URI("http://purl.org/NET/mediatypes/image/tiff"))
    	end
    	
    	parts3 = parts2.last.split(".")
    	
    	graph << RDF::Statement.new(subject, RDF::URI("http://purl.org/dc/terms/identifier"),parts3.first)
    	graph	
	end
    	
    	
    	
    
    
  end
end
