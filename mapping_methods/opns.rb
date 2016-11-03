require 'rdf'

module MappingMethods

module OPNS


def opnsDonor(subject, data)
  name = reformat_name(data)
  graph = RDF::Graph.new
  graph << RDF::Statement(subject, RDF::URI("http://id.loc.gov/vocabulary/relators/dnr"), RDF::URI("http://opaquenamespace.org/ns/people/#{name}"))
  graph
  
  end
  
  end
  end