require 'rdf'

module MappingMethods
  module MakeMeAString

  def hasFinding(subject, data)
    graph = RDF::Graph.new
    graph << RDF::Statement.new(subject, RDF::URI("http://lod.xdams.org/reload/oad/has_findingAid"), data)
    graph
    end
end
end