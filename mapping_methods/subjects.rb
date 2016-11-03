require 'rdf'
require 'rdf/raptor'
require 'rdf/ntriples'

module MappingMethods
  module Subjects
  
  def lcsubj_cache
      @lcsubj_cache ||= {}
    end
 
 def lcsubj(subject, data)
    
      graph = RDF::Graph.new
      graph << RDF::Statement.new(subject, RDF::DC.subject, data)
      data2 = data.gsub(" ","%20")
     	
      unless lcsubj_cache.include? data
     	lcsubj_cache[data] = RDF::Graph.new
     	
     	puts "looking up #{data2}"
       # subj_graph = RDF::Graph.load("http://id.loc.gov/authorities/label/#{data2}.nt")
       subj_graph = RDF::Util::File.open_file("http://id.loc.gov/authorities/label/#{data2}.nt") do |reader|
        reader.each_statement do |statement|
        puts statement.inspect
        end
        end
        puts "after load"
        #rescue IOError => e
        #	puts "no results for this subject #{data2}"
        #	return lcsubj_cache[data]
        # end
        puts "graph count:"
		puts subj_graph.count
        q = RDF::Query.new do
          pattern [:uri, RDF::URI("http://www.loc.gov/mads/rdf/v1#authoritativeLabel"), :label]
        end
        q.execute(subj_graph).each do |solution|
          #lcsubj_cache[data] = RDF::Graph.new
          puts "after filter executes"
          #lcsubj_cache[data] << RDF::Statement.new(solution[:uri], RDF.label, solution[:label])
          puts solution.inspect
          unless solution[:uri].include? "_:b"
            puts solution[:uri]
            lcsubj_cache[data] << RDF::Statement.new(solution[:uri], RDF.label,:label)
            #lcsubj_cache[data] << RDF::Statement.new(subject, DC_ELEM[:subject], RDF::Literal.new("Japanese American college students"))
          end #unless
        end #do
      end #unless
      
      graph << lcsubj_cache[data]
      puts "graph"
      puts graph.count
      graph
    end

  
  def LCsubjects(subject, data)
   graph = RDF::Graph.new
      #added next line for error handling
      return graph if data.empty?
      
      data.split(';').each do |part|
        part.strip!
        #subj = RDF::Graph.new
        subj = lcsubj(subject, part)
        graph.each_statement do |statement|
          puts statement.inspect
          end
        
        subj ||= RDF::Statement.new(subject, DC_ELEM[:subject], RDF::Literal.new(part))
        graph << subj
       
      end
      graph
    end
  
  end
  end