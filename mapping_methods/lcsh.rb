require 'json'
require 'linkeddata'
module Qa; end
require 'qa/authorities/web_service_base'
require 'qa/authorities/loc'
module MappingMethods
  module Lcsh
    def lcsubject(subject, data, db, predicate)
      authority = Qa::Authorities::Loc.new
      graph = RDF::Graph.new
      @lcsubject_cache ||= {}
      Array(data.split(';')).each do |subject_name|
        subject_name.strip!
        subject_name.gsub!('"', "")
        next if subject_name.gsub("-","") == ""
        begin
          uri = @lcsubject_cache[subject_name.downcase] || authority.search("#{subject_name}", db).find{|x| x["label"].strip.downcase == subject_name.downcase}
        rescue StandardError => e
          puts e
        end
        uri ||= ""
        if !uri.nil? && uri != "" 
          parsed_uri = uri["id"].gsub("info:lc", "http://id.loc.gov")
          graph << RDF::Statement.new(subject, predicate, RDF::URI(parsed_uri))
        else
          puts "No subject heading found for #{subject_name}" unless @lcsubject_cache.include?(subject_name.downcase)
          #graph << RDF::Statement.new(subject, RDF::DC11.subject, subject_name)
          graph << RDF::Statement.new(subject, predicate, subject_name)
        end
        @lcsubject_cache[subject_name.downcase] ||= uri
      end
      graph
    end
    
    def lcsubject_no_self(subject, data, db, predicate, alt_uri)
      authority = Qa::Authorities::Loc.new
      graph = RDF::Graph.new
      @lcsubject_cache ||= {}
      Array(data.split(';')).each do |subject_name|
        subject_name.strip!
        subject_name.gsub!('"', "")
        next if subject_name.gsub("-","") == ""
        begin
          uri = @lcsubject_cache[subject_name.downcase] || authority.search("#{subject_name}", db).find{|x| x["label"].strip.downcase == subject_name.downcase}
        rescue StandardError => e
          puts e
        end
        uri ||= ""
        if !uri.nil? && uri != "" 
          parsed_uri = uri["id"].gsub("info:lc", "http://id.loc.gov")
          graph << RDF::Statement.new(subject, predicate, RDF::URI(parsed_uri))
        else
          graph << RDF::Statement.new(subject, predicate, RDF::URI(alt_uri + reformat_name(data)))
        end
        @lcsubject_cache[subject_name.downcase] ||= uri
      end
      graph
    end

	def lclookup_subject(subject, data)
	  lcsubject(subject, data, "subjects", RDF::DC.subject)
	  end
	  
	def lclookup_name(subject, data)
		lcsubject(subject, data, "names", RDF::DC.subject)
		end
	def lclookup_subject_culture(subject, data)
	  lcsubject(subject, data, "subjects", RDF::URI("http://www.loc.gov/standards/vracore/vocab/culture"))
    end
    
    def lclookup_name_contri(subject, data)
      lcsubject(subject, data, "names", RDF::DC.contributor)
      end
    
    def lclookup_name_aatcoll(subject, data)
      lcsubject(subject, data, "names", RDF::URI("http://vocab.getty.edu/resource/aat/collectors"))
      end
      
    def lclookup_subject_tgm(subject, data)
      lcsubject(subject, data,"graphicMaterials", RDF::URI("http://purl.org/dc/elements/1.1/subject"))
    end
    
    def localPhotog(subject, data)
      graph = lcsubject_no_self(subject, data, "names", RDF::URI("http://id.loc.gov/vocabulary/relators/pht"),"http://opaquenamespace.org/ns/people/")
      
      graph
    end
    def localPeople(subject, data)
      graph = lcsubject_no_self(subject, data, "names", RDF::URI("http://opaquenamespace.org/ns/people"),"http://opaquenamespace.org/ns/people/")
      
      graph
    end
    def localAuthor(subject, data)
      graph = lcsubject_no_self(subject, data, "names", RDF::URI("http://id.loc.gov/vocabulary/relators/aut"),"http://opaquenamespace.org/ns/people/")
      
      graph
    end
   
    
    def reformat_name(name)
      name.gsub!(" ", "")
      name.gsub!(".", "")
      name.gsub!(",","")
      return name
    end
    
    def percent_creato(subject, data)
       graph = RDF::Graph.new << RDF::Statement(subject, RDF::URI('http://purl.org/dc/terms/rights'), RDF::URI('http://europeana.eu/rights/rr-f/'))
       graph << RDF::Statement(subject, RDF::URI('http://opaquenamespace.org/rights/rightsHolder'), data)
       #now do the creator statement
       
       graph
       end
    
    def lcsubject_siuslaw(subject, data)
      lcsubject(subject, data.gsub(",",";"))
    end
  end
end