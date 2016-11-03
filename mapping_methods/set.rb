require 'rdf'

module MappingMethods
  module Set
	
	
	
	def set(subject, data)
	graph = RDF::Graph.new
        data.gsub!(";","");
File.readlines("/Users/lsato/cdm2bag-master/sets.txt").each do |line|
					arr = line.split("\t")
					if(data == arr[1].strip)#sec col is name of coll
					  graph << RDF::Statement.new(subject, RDF::URI("http://opaquenamespace.org/ns/set"), RDF::URI("http://oregondigital.org/resource/oregondigital:#{arr[0]}"))
					  return graph
					end
					end
					puts data + " set not found"
					graph
	end
 def mhouse_set(subject, data)
      graph = RDF::Graph.new
      graph << RDF::Statement.new(subject, RDF::URI("http://opaquenamespace.org/ns/set"), RDF::URI("http://oregondigital.org/resource/oregondigital:lee-moorhouse"))
      graph << RDF::Statement.new(subject, RDF::URI("http://opaquenamespace.org/ns/set"), RDF::URI("http://oregondigital.org/resource/oregondigital:moorhouse"))
      graph
      end
end
end
