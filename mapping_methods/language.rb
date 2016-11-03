require 'rdf'
require 'rdf/ntriples'
require 'iso-639'

module MappingMethods
  module Language
    def language_cache
      @language_cache ||= {}
    end

	LANGCODES = { :Arabic => "ara", :Chinese => "chi", :Czech => "cze", :Danish => "dan", :Dutch => "dut",
					:English => "eng", :French => "fre", :German => "ger", :Hindi => "hin", 
					:Indonesian => "ind", :Italian => "ita",  :Japanese => "jpn",
					 :Maori => "mao", :Russian => "rus", :Spanish => "spa" }
    def english(subject, data)
      graph = RDF::Graph.new
      return graph if data.empty?
      if (data.strip == "English")
        graph << RDF::Statement.new(subject, RDF::URI("http://purl.org/dc/terms/language"), RDF::URI("http://id.loc.gov/vocabulary/iso639-1/en"))
        #graph << RDF::Statement.new(subject, RDF::URI("http://purl.org/dc/terms/language"), RDF::URI("http://id.loc.gov/vocabulary/iso639-2/en"))
        #graph << RDF::Statement.new(subject, RDF::URI("http://purl.org/dc/terms/language"), RDF::URI("http://id.loc.gov/vocabulary/languages/en"))
        graph
      else 
        puts "problem with language"
      end
      
    end

    def iso_language(subject, data)
      graph = RDF::Graph.new
      data.split(';').each do |lang|
        if lang.strip.size == 3
          iso_lang = ISO_639.find(lang.strip)
        else
          langcode = LANGCODES[lang.strip.to_sym]
          if langcode.size == 3
            iso_lang = ISO_639.find(langcode)
          else 
        	iso_lang = false
          end
        end 

        if iso_lang
          unless language_cache.include? iso_lang.first
            language_cache[iso_lang.first] = RDF::Graph.load("http://id.loc.gov/vocabulary/iso639-1/#{iso_lang[2]}.nt") unless iso_lang[2].empty?
            language_cache[iso_lang.first] ||= RDF::Graph.load("http://id.loc.gov/vocabulary/iso639-2/#{iso_lang[0]}.nt")
            language_cache[iso_lang.first] ||= RDF::Graph.load("http://id.loc.gov/vocabulary/languages/#{iso_lang[0]}.nt")
          end
          lang_uri = language_cache[iso_lang.first].subjects.first
          q = RDF::Query.new do
            pattern [lang_uri, RDF.type, RDF::URI('http://www.loc.gov/mads/rdf/v1#Language')]
            pattern [:lang, RDF::SKOS.prefLabel, :prefLabel]
          end

          q.execute(language_cache[iso_lang.first]).each do |solution|
            if solution[:prefLabel].language == :en
              #graph << RDF::Statement.new(solution[:lang], RDF::SKOS.prefLabel, solution[:prefLabel])
              graph << RDF::Statement.new(subject, RDF::DC.language, solution[:lang])
              break
            end
          end
        else
          graph << RDF::Statement.new(subject, RDF::URI.new('http://purl.org/dc/elements/1.1/language'), RDF::Literal.new(data))
        end
      end
      graph
    end

  end
end
