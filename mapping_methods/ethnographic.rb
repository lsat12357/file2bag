require 'rdf'
require 'rdf/ntriples'

module MappingMethods
  module Ethnographic
    def ethnographic(subject, data)
    graph = RDF::Graph.new
      data.split(';').each do |part|
      part.strip!
      term = slug(part)
      graph << RDF::Statement(subject, RDF::URI('http://opaquenamespace.org/ns/ethnographic'), RDF::URI("http://opaquenamespace.org/ns/et/#{term}"))
    end
    graph
    end

    def slug(str)
      str.downcase.split.each_with_index.map { |v,i|  i == 0 ? v : v.capitalize }.join.gsub(/[^a-zA-Z]/, '').to_sym
    end
  end
end
