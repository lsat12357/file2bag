require 'rdf'

module MappingMethods
module Repos

def repos_UO(subject, data)
  graph = RDF::Graph.new
  if data.include? "Special Collections"
  graph << RDF::Statement(subject, RDF::URI("http://id.loc.gov/vocabulary/relators/rps"), RDF::URI("http://id.loc.gov/authorities/names/no2003116678"))#this is speccoll
  else name = reformat_name(data)
  graph << RDF::Statement(subject, RDF::URI("http://id.loc.gov/vocabulary/relators/rps"), RDF::URI("http://opaquenamespace.org/ns/repository/#{name}"))
  end
  graph
end

def bookarts_repository(subject, data)
  graph = RDF::Graph.new
    if data.include? "Special Collections"
    	  graph << RDF::Statement(subject, RDF::URI("http://id.loc.gov/vocabulary/relators/rps"), RDF::URI("http://id.loc.gov/authorities/names/no2003116678"))#this is speccoll
	else graph << RDF::Statement(subject, RDF::URI("http://id.loc.gov/vocabulary/relators/rps"), RDF::URI("http://opaquenamespace.org/ns/repository/UniversityofOregonArchitectureandAlliedArtsLibrary"))
	end
  graph
end
end
end