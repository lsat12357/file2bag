
Dir["./mapping_methods/*.rb"].each { |f| require f }

module MappingMethods
  include MappingMethods::Geographic
  include MappingMethods::Rights
  include MappingMethods::MediaType
  include MappingMethods::XSDDate
  include MappingMethods::Language
  include MappingMethods::Types
  include MappingMethods::AAT
  include MappingMethods::Replace
  include MappingMethods::Ethnographic
  include MappingMethods::Lookup
  include MappingMethods::Formats
  include MappingMethods::Identi
  include MappingMethods::Subjects
  include MappingMethods::Lcsh
  include MappingMethods::Collection
  include MappingMethods::Set
  include MappingMethods::ContributingInst
  include MappingMethods::Ethno
  include MappingMethods::Maic
  include MappingMethods::Splitter
  include MappingMethods::FixFullText
  include MappingMethods::Repos
  include MappingMethods::UO_Rights
  include MappingMethods::Utils
  include MappingMethods::OPNS
  include MappingMethods::Encode
  include MappingMethods::Misc
  include MappingMethods::Cleanup

  DC_ELEM = RDF::Vocabulary.new('http://purl.org/dc/elements/1.1/')
end
