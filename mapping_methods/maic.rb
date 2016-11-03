require 'rdf'

module MappingMethods
  module Maic
  
  def maic_split(subject, data)
      graph = RDF::Graph.new
      data.split(';').each do |part|
        part.strip!
        graph << RDF::Statement(subject, RDF::URI("http://www.loc.gov/standards/vracore/vocab/workType"), part)
        end
        graph
   end
   
end
end
