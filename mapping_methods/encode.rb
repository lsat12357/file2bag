require 'rdf'

module MappingMethods
  module Encode
  
  def encode_en_title(subject, data)
    graph = RDF::Graph.new
    graph << RDF::Statement.new(subject, RDF::DC.title, RDF::Literal(data, :language => :en))
    graph
  end
  
  def encode_en_descr(subject, data)
    graph = RDF::Graph.new
    graph << RDF::Statement.new(subject, RDF::DC.description, RDF::Literal(data, :language => :en))
    graph
  end
  
  def encode_fr_subj(subject, data)
    graph = RDF::Graph.new
    data.split(';').each do |part|
      part.strip!
      graph << RDF::Statement.new(subject, RDF::DC.subject, RDF::Literal(part, :language => :fr))
    end
    graph
  end
  
  def encode_en_swpo(subject, data)
    graph = RDF::Graph.new
    graph << RDF::Statement.new(subject, RDF::URI("http://sw-portal.deri.org/ontologies/swportal#containedInJournal"), RDF::Literal(data, :language => :en))
    graph
  end
  
  def encode_en_schema(subject, data)
    graph = RDF::Graph.new
    graph << RDF::Statement.new(subject, RDF::URI("http://schema.org/citation"), RDF::Literal(data, :language => :en))
    graph
  end
  
	end
end