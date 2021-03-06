require 'rdf'
require 'sparql/client'

module MappingMethods
  module AAT

       def aat_search(str)
      str = str.downcase
      @type_cache ||= {}
      return @type_cache[str] if @type_cache.include?(str)
      sparql = SPARQL::Client.new("http://vocab.getty.edu/sparql")

      q = "select distinct ?subj {?subj skos:prefLabel|skos:altLabel ?label. filter(str(?label)=\"#{str}\")}"
      @type_cache[str] = sparql.query(q, :content_type => "application/sparql-results+json")
    end

    def aat_from_search(subject, data)
      r = RDF::Graph.new
      data = data.split(";")
      Array(data).each do |type|
        filtered_type = type.downcase.strip.gsub("film ","")
        filtered_type = type_match[filtered_type] if type_match.include?(filtered_type)
        uri = aat_search(filtered_type).first
        unless uri
          r << RDF::Statement.new(subject, RDF.type, type)
          puts "No result for #{type}"
          next
        end
        uri = uri.to_hash[:subj] if uri
        r << RDF::Statement.new(subject, RDF.type, uri)
      end
      r
    end

    def type_match
      {
        "slides" => "slides (photographs)",
        "negatives" => "negatives (photographic)",
        "book illustrations" => "illustrations (layout features)",
        "programs" => "programs (documents)",
        "letters" => "letters (correspondence)",
        "cyanotypes" => "cyanotypes (photographic prints)",
        "fillms" => "films"
      }
    end

    def aat_sheetmusic(subject, data)
      RDF::Graph.new << RDF::Statement.new(subject, RDF.type, RDF::URI('http://vocab.getty.edu/resource/aat/300026430'))
    end
    
  end
end
