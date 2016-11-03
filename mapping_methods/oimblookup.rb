require 'rdf'
require 'rdf/raptor'

module MappingMethods
	module OIMBLookup

    def oimb_Lookup(subject, data, file, predicate)
    graph = RDF::Graph.new
			data.split(';').each do |part|
        		part.strip!
        		test = false
				File.readlines(TERMDIR + file).each do |line|
					arr = line.split("\t")
					if(part == arr[0].strip)#first col is term
						test = true
						if (!arr[2].strip.empty?)#third col is the uri
							graph << RDF::Statement.new(subject, predicate, RDF::URI.new(arr[2].strip))
							#graph << RDF::Statement.new(RDF::URI.new(arr[2].strip), RDF::URI.new(SOURCES[arr[1].strip]), RDF::Literal.new(part, :language => :en)) 
						
						else #self publish
							graph << RDF::Statement.new(subject, predicate, RDF::Literal.new(part))
						end
					end
				end #do line
				if (!test)
					 #self publish
					graph << RDF::Statement.new(subject, predicate, RDF::Literal.new(part))
				end
				
			end #do part
			graph
		end
		
		def oimb_subject
			graph = oimb_Lookup(subject, data, oimb_topic.txt, RDF::DC.subject)
			graph
		end
		
		def oimb_subject1
		  graph = oimb_Lookup(subject, data, oimb_subtopic.txt, RDF::DC.subject)
		  graph
		end
		
		def oimb_subject2
		  graph = oimb_Lookup(subject, data, oimb_phylum.txt, RDF::URI("http://rs.tdwg.org/dwc/terms/phylum"))
		  graph
		end
		
		def oimb_subject3
		  graph = oimb_Lookup(subject, data, oimb_class.txt, RDF::URI("http://rs.tdwg.org/dwc/terms/class"))
		  graph
		end
		
		def oimb_subject4
		  graph = oimb_Lookup(subject, data, oimb_genus.txt, RDF::URI("http://rs.tdwg.org/dwc/terms/genus"))
		  graph
		end
    
        def oimb_subject5
		  graph = oimb_Lookup(subject, data, oimb_common.txt, RDF::URI("http://rs.tdwg.org/dwc/terms/vernacularName"))
		  graph
		end
    
    end
    end