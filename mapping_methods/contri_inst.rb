require 'rdf'

module MappingMethods
  module ContributingInst
  
  def contri_inst_UO(subject, data)
  
  return RDF::Statement(subject, RDF::URI('http://opaquenamespace.org/ns/contributingInstitution'), RDF::URI('http://dbpedia.org/resource/University_of_Oregon'))
  
  end
  
  def contri_inst_percent(subject, data)
    graph = RDF::Graph.new
    graph << RDF::Statement(subject, RDF::URI('http://opaquenamespace.org/ns/contributingInstitution'), RDF::URI('http://dbpedia.org/resource/University_of_Oregon'))
    graph << RDF::Statement(subject, RDF::URI('http://opaquenamespace.org/ns/contributingInstitution'), RDF::URI("http://dbpedia.org/resource/Oregon_Arts_Commission"))
    graph
    end
end
end