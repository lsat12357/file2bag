require 'rdf'

module MappingMethods
module UO_Rights


    def folkrights(subject, data)
    
      graph = RDF::Graph.new
      graph << RDF::Statement(subject, RDF::URI('http://purl.org/dc/terms/rights'), RDF::URI('http://opaquenamespace.org/rights/educational'))
      if data.include? 'Oregon Arts Commission'
      graph << RDF::Statement(subject, RDF::URI('http://opaquenamespace.org/rights/rightsHolder'), 'Oregon Arts Commission') 
      end
      
      graph
    end

    def wwdl_rights(subject, data)
	   graph = RDF::Graph.new << RDF::Statement(subject, RDF::URI('http://purl.org/dc/terms/rights'), RDF::URI('http://creativecommons.org/publicdomain/mark/1.0/'))
      	   graph << RDF::Statement(subject, RDF::URI('http://creativecommons.org/ns#license'), RDF::URI('http://creativecommons.org/publicdomain/mark/1.0/'))

      graph
	end
	
	#percent rights holder is taken care of in the lc lookup method for percent_creato
	def percent_rights(subject, data)
       graph = RDF::Graph.new << RDF::Statement(subject, RDF::URI('http://purl.org/dc/terms/rights'), RDF::URI('http://www.europeana.eu/rights/rr-f/'))
      	   
      graph
	end
	
	def univ_rights(subject, data)
	   graph = RDF::Graph.new << RDF::Statement(subject, RDF::URI('http://purl.org/dc/terms/rights'), RDF::URI('http://creativecommons.org/licenses/by-nc-nd/4.0/'))
       graph << RDF::Statement(subject, RDF::URI('http://opaquenamespace.org/rights/rightsHolder'), "University of Oregon")
       graph
	end
	
	def UO_rights(subject, data)
	graph = RDF::Graph.new
		if data.start_with? ('This item is in the public domain.')
		  graph << RDF::Statement(subject, RDF::URI('http://purl.org/dc/terms/rights'), RDF::URI('http://creativecommons.org/publicdomain/mark/1.0/'))
	    else
	    	graph << RDF::Statement(subject, RDF::URI('http://purl.org/dc/terms/rights'), RDF::URI('http://creativecommons.org/licenses/by-nc-nd/4.0/'))
      	   graph << RDF::Statement(subject, RDF::URI('http://opaquenamespace.org/rights/rightsHolder'), "University of Oregon")
      	   graph << RDF::Statement.new(subject, RDF::URI('http://creativecommons.org/ns#license'), RDF::URI("http://creativecommons.org/licenses/by-nc-nd/4.0/"))
      	end
      graph
	end
	def uoath_rights(subject, data)
	  graph = RDF::Graph.new
	    if data.start_with?('This item is in the public domain.')
	     graph << RDF::Statement(subject, RDF::URI('http://purl.org/dc/terms/rights'), RDF::URI('http://creativecommons.org/publicdomain/mark/1.0/'))

		else
		  if data.start_with? ('Harvey')
		  
	      	graph << RDF::Statement(subject, RDF::URI('http://opaquenamespace.org/rights/rightsHolder'), "Harvey, Paul W. IV")
	      else
      	   graph << RDF::Statement(subject, RDF::URI('http://opaquenamespace.org/rights/rightsHolder'), "University of Oregon")
      	  end #end of rightholder
      	   graph << RDF::Statement(subject, RDF::URI('http://purl.org/dc/terms/rights'), RDF::URI('http://creativecommons.org/licenses/by-nc-nd/4.0/'))
      	   graph << RDF::Statement.new(subject, RDF::URI('http://creativecommons.org/ns#license'), RDF::URI("http://creativecommons.org/licenses/by-nc-nd/4.0/"))
      	end #end of not public domain
      graph
	end
	
    def ode_rights(subject, data)
     graph = RDF::Graph.new << RDF::Statement(subject, RDF::URI('http://purl.org/dc/terms/rights'), RDF::URI('http://www.europeana.eu/rights/rr-f/'))
      	   graph << RDF::Statement(subject, RDF::URI('http://opaquenamespace.org/rights/rightsHolder'), "Oregon Daily Emerald Publishing Co., Inc.")

      graph
	end
	
	def pd_rights(subject, data)
	  graph = RDF::Graph.new
	  graph << RDF::Statement(subject, RDF::URI('http://purl.org/dc/terms/rights'), RDF::URI('http://creativecommons.org/publicdomain/mark/1.0/'))
	  graph
	end
	
	def maic_rights(subject, data)
	  graph = RDF::Graph.new
      graph << RDF::Statement(subject, RDF::URI('http://purl.org/dc/terms/rights'), RDF::URI('http://opaquenamespace.org/rights/educational'))
      
      graph << RDF::Statement(subject, RDF::URI('http://opaquenamespace.org/rights/rightsHolder'), 'Gary Tepfer and the Mongolian Altai Inventory.') 
      end

	
	def arch_rights(subject, data)

      r_arr=[
      "This image was included in the documentation", 
      "\xC2\xA9 City of Eugene", 
      "\xC2\xA9 TBG Architects & Planners.", 
      "\xC2\xA9 University of Oregon.", 
      "Creative Commons Attribution-Share Alike"
      ]

      graph = RDF::Graph.new
data.force_encoding('UTF-8')
if data.start_with?(r_arr[0].force_encoding('UTF-8'))
  graph << RDF::Statement(subject, RDF::URI("http://www.loc.gov/standards/mods/modsrdf/v1/#note"), data)
  graph << RDF::Statement(subject, RDF::URI("http://opaquenamespace.org/rights/rightsHolder"),"Oregon State Historic Preservation Office")
  graph << RDF::Statement(subject, RDF::DC.rights, RDF::URI("http://opaquenamespace.org/rights/educational"))
elsif data.start_with?(r_arr[1].force_encoding('UTF-8'))
  graph << RDF::Statement(subject, RDF::URI("http://opaquenamespace.org/rights/rightsHolder"),"City of Eugene")
  graph << RDF::Statement(subject, RDF::DC.rights, RDF::URI("http://www.europeana.eu/rights/rr-f/"))
elsif data.start_with?(r_arr[2].force_encoding('UTF-8'))
  graph << RDF::Statement(subject, RDF::URI("http://opaquenamespace.org/rights/rightsHolder"),"TBG Architects & Planners")
  graph << RDF::Statement(subject, RDF::DC.rights, RDF::URI("http://opaquenamespace.org/rights/educational"))
elsif data.start_with?(r_arr[3].force_encoding('UTF-8'))
  graph << RDF::Statement(subject, RDF::URI("http://opaquenamespace.org/rights/rightsHolder"),"University of Oregon")
  graph << RDF::Statement(subject, RDF::DC.rights, RDF::URI("http://creativecommons.org/licenses/by-nc-nd/4.0/"))
  graph << RDF::Statement.new(subject, RDF::URI('http://creativecommons.org/ns#license'), RDF::URI("http://creativecommons.org/licenses/by-nc-nd/4.0/"))
      
elsif data.start_with?(r_arr[4.force_encoding('UTF-8')])
  graph << RDF::Statement(subject, RDF::URI("http://opaquenamespace.org/rights/rightsHolder"),"University of Oregon")
  graph << RDF::Statement(subject, RDF::DC.rights, RDF::URI("http://creativecommons.org/licenses/by-sa/4.0/"))
  graph << RDF::Statement.new(subject, RDF::URI('http://creativecommons.org/ns#license'), RDF::URI("http://creativecommons.org/licenses/by-sa/4.0/"))
     
else 
  graph << RDF::Statement(subject, RDF::URI("http://opaquenamespace.org/rights/rightsHolder"),getname(data))
  graph << RDF::Statement(subject, RDF::DC.rights, RDF::URI("http://www.europeana.eu/rights/rr-f/"))
end
graph

end

	def bookarts_rights(subject, data)
	graph = RDF::Graph.new
	graph << RDF::Statement(subject, RDF::URI('http://purl.org/dc/terms/rights'), "Copyright resides with the creator(s) of the image or their assigns and may be subject to copyright restrictions.")
	graph
	end
# *diss_rights- public domain except one with http://www.europeana.eu/rights/rr-f/ in rights and "Goettmann, B. A., Greaves, B. G., and Coons M. P." in rightsHolder
    def diss_rights(subject, data)
	graph = RDF::Graph.new
	graph << RDF::Statement(subject, RDF::URI('http://purl.org/dc/terms/rights'), RDF::URI('http://creativecommons.org/publicdomain/mark/1.0/'))
	graph
	end
	
	def tleg_rights(subject, data)
	graph = RDF::Graph.new
	graph << RDF::Statement(subject, RDF::URI('http://purl.org/dc/terms/rights'), RDF::URI("http://www.europeana.eu/rights/unknown/"))
	graph
	end
	
	def ulmann2_rights(subject, data)
	graph = RDF::Graph.new
	graph << RDF::Statement(subject, RDF::URI('http://purl.org/dc/terms/rights'), RDF::URI('http://creativecommons.org/publicdomain/mark/1.0/'))
	graph
	end
	
	def archivision_rights(subject, data) #this is the only statement for the entire coll
	  graph = RDF::Graph.new
	  graph << RDF::Statement(subject, RDF::URI('http://purl.org/dc/terms/rights'), RDF::URI("http://www.europeana.eu/rights/rr-r/"))
	  graph << RDF::Statement(subject, RDF::URI("http://opaquenamespace.org/rights/rightsHolder"), "Scott Gilchrist, Archivision, Inc.")
	end
	
	def lowen_rights(subject, data)#removed all those nasty copyright symbols from the desc.all
	  graph = RDF::Graph.new
	  
	  
	  if data.include? "Classics"
	    graph << RDF::Statement.new(subject, RDF::URI("http://opaquenamespace.org/rights/rightsHolder"), "University of Oregon, Department of Classics")
		graph << RDF::Statement(subject, RDF::DC.rights, RDF::URI("http://creativecommons.org/licenses/by-nc-nd/4.0/"))
	  elsif
	    data.include? "Oregon"
	    graph << RDF::Statement.new(subject, RDF::URI("http://opaquenamespace.org/rights/rightsHolder"), "University of Oregon")
		graph << RDF::Statement(subject, RDF::DC.rights, RDF::URI("http://creativecommons.org/licenses/by-nc-nd/4.0/"))
	  elsif
	    data.include? "John"
	    graph << RDF::Statement.new(subject, RDF::URI("http://opaquenamespace.org/rights/rightsHolder"), "John Decopolous")
		graph << RDF::Statement(subject, RDF::DC.rights, RDF::URI("http://www.europeana.eu/rights/rr-r/"))
	  elsif
	    data.include? "Emil"
	    graph << RDF::Statement.new(subject, RDF::URI("http://opaquenamespace.org/rights/rightsHolder"), "Emil Muench")
		graph << RDF::Statement(subject, RDF::DC.rights, RDF::URI("http://www.europeana.eu/rights/rr-r/"))
	  elsif
	    data.include? "Tzaferis"
	    graph << RDF::Statement.new(subject, RDF::URI("http://opaquenamespace.org/rights/rightsHolder"), "Tzaferis S.A.")
		graph << RDF::Statement(subject, RDF::DC.rights, RDF::URI("http://www.europeana.eu/rights/rr-r/"))
	  elsif
	    data.include? "resides"
	    graph << RDF::Statement.new(subject, RDF::URI("http://opaquenamespace.org/rights/rightsHolder"), "unknown")
		graph << RDF::Statement(subject, RDF::DC.rights, RDF::URI("http://www.europeana.eu/rights/rr-r/"))
	  else 
	    puts "problem with rights: " + data
	  end
	  
	  graph
	  end
      
	
end
end
