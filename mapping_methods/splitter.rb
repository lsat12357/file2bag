require 'rdf'

module MappingMethods

module Splitter


def split_title (subject, data)
  graph = RDF::Graph.new
  parts = data.split(';')
  parts[0].strip!
  graph << RDF::Statement(subject, RDF::URI("http://purl.org/dc/terms/title"), parts[0])
  i = 1
  while i < parts.length do
  	parts[i].strip!
    graph << RDF::Statement(subject, RDF::URI("http://purl.org/dc/terms/alternative"), parts[i]) 
    i += 1
    end
  graph
  end
  
def split_vra_stylePeriod (subject, data)
  graph = makeGraph(subject, data, RDF::URI("http://opaquenamespace.org/ns/vra/hasStylePeriod"))
  graph 
end

def split_dct_temporal (subject, data)
  graph = makeGraph(subject, data,  RDF::DC.temporal)
  graph
end

def split_dct_date (subject, data)
  graph = makeGraph(subject, data, RDF::DC.date)
  graph
end

def split_schema_citation (subject, data)
  graph = makeGraph(subject, data, RDF::URI("http://schema.org/citation"))
  graph
end

def split_oregon_cco_creatorDisplay (subject, data)
  graph = makeGraph(subject, data, RDF::URI("http://opaquenamespace.org/ns/cco/creatorDisplay"))
  graph
end

def split_dct_alternative (subject, data)
  graph = makeGraph(subject, data, RDF::DC.alternative)
  graph
end

def split_rdf_type (subject, data)
graph = makeGraph(subject, data, RDF::URI("http://www.w3.org/1999/02/22-rdf-syntax-ns#type"))
graph
end



end
end