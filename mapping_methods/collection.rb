require 'json'
module MappingMethods
  module Collection

#not using this, reading in csv
    COLLECTION_URIS = {
      :'John H. Gallagher Photography Collection' => RDF::URI('http://oregondigital.org/collections/gallagher'),
      :'Cronk Collection' => RDF::URI('http://oregondigital.org/collections/cronk'),
      :'Webfoots and Bunchgrassers: Folk Art of the Oregon Country' => RDF::URI('http://oregondigital.org/ns/localCollectionName/WebfootsandBunchgrassersFolkArtoftheOregonCountry')
    }
   

    def collection_old(subject, data)
    #filename = "/Users/lsato/downloads/cdm2bag-master-2/uocollections.jsonld"
    #coll_uris = JSON.parse( IO.read(filename) )
    
    graph = RDF::Graph.new
      #added next line for error handling
      return graph if data.empty?
     # puts "collection: " + data
      #collection = COLLECTION_URIS[data.to_sym]
      #coll_uris["@graph"].each do |thing|
        #if (thing["label"]==data)
       File.readlines("/Users/lsato/cdm2bag-master/colls.txt").each do |line|
		arr = line.split("\t")
		if(data == arr[0].strip)#first col is name of coll
		  collection = arr[1].strip
          #collection = thing["id"]
          graph << RDF::Statement.new(subject, RDF::URI('http://opaquenamespace.org/ns/localCollectionName'), RDF::URI(collection))
          return graph
        end
        
        end #do each
        
       puts data + " not found"
       graph
      
    end
    
    def collection(subject, data)
      graph = RDF::Graph.new
      return graph if data.empty?
      data.split(';').each do |part|
        part.strip!
        name = reformat_name(part)
        graph << RDF::Statement(subject, RDF::URI("http://opaquenamespace.org/ns/localCollectionName"), RDF::URI("http://opaquenamespace.org/ns/localCollectionName/#{name}"))
      end
      graph
      end
      
      def mhouse_collection(subject, data)
      RDF::Graph.new << RDF::Statement(subject, RDF::URI("http://opaquenamespace.org/ns/localCollectionName"), RDF::URI("http://opaquenamespace.org/ns/localCollectionName/MoorhouseMajorLeePhotographs"))
      end
  end
end