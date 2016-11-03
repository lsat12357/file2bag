require 'rdf'
require 'rdf/raptor'

module MappingMethods
  module Formats
    DCMEDIATYPE_NS = RDF::Vocabulary.new('http://purl.org/NET/mediatypes/')
    DCMEDIATYPES = ["application_pdf", "image_jpeg", "image_tiff", "image_jp2"
                 ] #can add more media types
            #make sure to edit the desc.all if there are files with .jpg or .tif
	
    def dcmitype_cache
      @dcmitype_cache ||= {}
    end

    def dcmiformat(subject, data)
    
      parts = data.split("/")
      
      nice = parts[0].strip+ "_" + parts[1].strip
      
      return nil unless DCMEDIATYPES.include? nice
      	
      graph = RDF::Graph.new
      graph << RDF::Statement.new(subject, RDF::DC.format, DCMEDIATYPE_NS[data])
      
      #unless dcmitype_cache.include? nice
        
        #format_graph = RDF::Graph.load(DCMEDIATYPE_NS[data])
       
      #  q = RDF::Query.new do
         # pattern [DCMEDIATYPE_NS[data], RDF::RDFS.label, :label]
          
      #  end
       
        #q.execute(format_graph).each do |solution|
        #  dcmitype_cache[nice] = RDF::Graph.new
        #  dcmitype_cache[nice] << RDF::Statement.new(DCMEDIATYPE_NS[data], RDF::RDFS.label, solution[:label])
      #  end
       
      #end
      #graph << dcmitype_cache[nice]
      graph
    end
    
    def uoath_formats(subject, data)
      graph = RDF::Graph.new
      graph << RDF::Statement(subject, RDF::DC.format, RDF::URI("http://purl.org/NET/mediatypes/image/tiff"))
      graph
      end
      
    def formats_tiff(subject, data)
      graph = RDF::Graph.new
      graph << RDF::Statement.new(subject, RDF::DC.format, RDF::URI("http://purl.org/NET/mediatypes/image/tiff"))
      graph
      
    end
    def formats_jpeg(subject, data)
    graph = RDF::Graph.new
      graph << RDF::Statement.new(subject, RDF::DC.format, RDF::URI("http://purl.org/NET/mediatypes/image/jpeg"))
      graph
    end
    def formats(subject, data)
    	 
      graph = RDF::Graph.new
      #added next line for error handling
      return graph if data.empty?
      
      data.split(';').each do |part|
        part.strip!
        formatgr = dcmiformat(subject, part)
        formatgr ||= RDF::Statement.new(subject, DC_ELEM[:format], RDF::Literal.new(part))
        graph << formatgr
       
      end
      graph
    end
    
    def uopres_find(subject, data)
	  graph = RDF::Graph.new
	  graph << RDF::Statement.new(subject, RDF::URI("http://opaquenamespace.org/ns/full"), data)
	  graph << RDF::Statement.new(subject, RDF::DC.type, RDF::URI("http://purl.org/dc/dcmitype/Text"))
	  if data.include? 'jpg'
      graph << RDF::Statement.new(subject, RDF::DC.format, RDF::URI("http://purl.org/NET/mediatypes/image/jpeg"))
      else
       graph << RDF::Statement.new(subject, RDF::DC.format, RDF::URI("http://purl.org/NET/mediatypes/application/pdf"))
      end
      graph  
      end
      
      def ulmann_formats(subject,data)
      graph = RDF::Graph.new
      graph << RDF::Statement.new(subject, RDF::DC.format, RDF::URI("http://purl.org/NET/mediatypes/image/jpeg"))
      graph
      end
end
end
