
require 'rdf'

module MappingMethods
  module Misc
  
    def uostock_people(subject,data)
    graph = RDF::Graph.new
    graph << RDF::Statement.new(subject, RDF::URI("http://www.loc.gov/standards/mods/modsrdf/v1/#note"), "People in image: " + data)
    graph
    end
    
    def artcolls_large(subject, data)
    
    graph = RDF::Graph.new
    parts = data.split("(")
    graph << RDF::Statement.new(subject, RDF::DC.isPartOf, parts[0].strip)
    graph
    end
  
end
end