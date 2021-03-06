require 'json'
require 'linkeddata'
module Qa; end
require 'qa/authorities/web_service_base'
require 'qa/authorities/loc'


module MappingMethods
  module Ethno
    def ethno(subject, data)
      authority = Qa::Authorities::Loc.new
      graph = RDF::Graph.new
      @lcsubject_cache ||= {}
      Array(data.split(';')).each do |subject_name|
        subject_name.strip!
        subject_name.gsub!('"', "")
        next if subject_name.gsub("-","") == ""
        begin
          uri = @lcsubject_cache[subject_name.downcase] || authority.search("#{subject_name}", "ethnographicTerms").find{|x| x["label"].strip.downcase == subject_name.downcase}
        rescue StandardError => e
          puts e
        end
        uri ||= ""
        if !uri.nil? && uri != "" 
          parsed_uri = uri["id"].gsub("info:lc", "http://id.loc.gov")
          graph << RDF::Statement.new(subject, RDF::URI('http://opaquenamespace.org/ns/ethnographic'), RDF::URI(parsed_uri))
        else
          puts "No subject heading found for #{subject_name}" unless @lcsubject_cache.include?(subject_name.downcase)
          #graph << RDF::Statement.new(subject, RDF::URI('http://opaquenamespace.org/ns/ethnographic'), subject_name)
          #graph << RDF::Statement.new(subject, predicate, subject_name)
        end
        @lcsubject_cache[subject_name.downcase] ||= uri
      end
      graph
    end

	
  end
end