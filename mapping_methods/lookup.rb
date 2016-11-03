require 'rdf'
require 'rdf/raptor'

module MappingMethods
	module Lookup
	
		TERMDIR = "/Users/lsato/terms_for_bagging/"
		SOURCES = {
			"LC" => "http://www.loc.gov/mads/rdf/v1#authoritativeLabel",
			"LCSH" => "http://www.loc.gov/mads/rdf/v1#authoritativeLabel",
			"TGM" => "http://www.loc.gov/mads/rdf/v1#authoritativeLabel",
			"LCNAF" => "http://www.loc.gov/mads/rdf/v1#authoritativeLabel",
			"AAT" => "http://www.w3.org/2004/02/skos/core#prefLabel",
			"MeSH" => "http://www.w3.org/2004/02/skos/core#prefLabel",
			"ULAN" => "http://www.w3.org/2004/02/skos/core#prefLabel",
			"GeoNames" => "http://www.w3.org/2004/02/skos/core#prefLabel",
			"TGN" => "http://www.w3.org/2004/02/skos/core#prefLabel",
			"UO" => "http://www.w3.org/2004/02/skos/core#prefLabel"
			}
		NAMESPACES = {
			:skos => "http://www.w3.org/2004/02/skos/core#",
			:dct => "http://purl.org/dc/terms/",
			:dce => "http://purl.org/dc/elements/1.1/",
			:oregon => "http://opaquenamespace.org/ns/",
			:vra => "http://www.loc.gov/standards/vracore/vocab/",
			:marcrel => "http://id.loc.gov/vocabulary/relators/",
			:rdag1 => "http://rdvocab.info/Elements/",
			:rdam => "http://www.rdaregistry.info/Elements/m/#",
  			:rdaw => "http://www.rdaregistry.info/Elements/w/#",
  			:rdae => "http://www.rdaregistry.info/Elements/e/#",
  			:rdai => "http://www.rdaregistry.info/Elements/i/#",
  			:rdaa => "http://www.rdaregistry.info/Elements/a/#",
            :dwc => "http://rs.tdwg.org/dwc/terms/",
            :rdf => "http://www.w3.org/1999/02/22-rdf-syntax-ns#",
            :schema => "http://schema.org/"
		}
		def lookupTerm(subject, data, file, predicate )
			graph = RDF::Graph.new
			data.split(';').each do |part|
        		part.strip!
        		test = false
				File.readlines(TERMDIR + file).each do |line|
					arr = line.split("\t")
					if(part == arr[0].strip)#first col is term
					  
						test = true
						
						if (!arr[2].strip.empty?)#third col is the uri
							graph << RDF::Statement.new(subject, predicate, RDF::URI.new(arr[2].strip))
							#graph << RDF::Statement.new(RDF::URI.new(arr[2].strip), RDF::URI.new(SOURCES[arr[1].strip]), RDF::Literal.new(part, :language => :en)) 
						
						else 
							test = false
						
						end
					end
				end #do line
				if (!test)
					 #self publish
					graph << RDF::Statement.new(subject, predicate, RDF::Literal.new(part))
				end
				
			end #do part
			graph
		end
		
		def lookupSubj(subject, data, file, opns, cat)
			graph = RDF::Graph.new
			data.split(';').each do |part|
        		part.strip!
        		test = false
        		
				File.readlines(TERMDIR + file).each do |line|
					arr = line.split("\t")
					if(part == arr[0].strip)#first col is term
						
						if (!arr[1].strip.empty?)#arr[2] is the uri/uris
						  test = true
						  i=1
						  while i < arr.length do
						  	graph << RDF::Statement.new(subject, RDF::DC.subject, RDF::URI(arr[i].strip!))
						  	i+=1
						  	end
						else
						  test = false
					    end
					end
				end #do each line in list
				if (!test)
					 if opns
					   name = reformat_name(part)
					   graph << RDF::Statement.new(subject, RDF::DC.subject, RDF::URI("http://opaquenamespace.org/ns/#{cat}/#{name}"))
				      else
					    graph << RDF::Statement.new(subject, DC_ELEM[:subject], RDF::Literal.new(part))
					  end
				 end
				
			end #do each part
			#graph.each_statement do |statement|
            #puts statement.inspect
            #end
			graph
		end
		
		def lookupTermOrOpaque(subject, data, file, predicate, cat )
			graph = RDF::Graph.new
			data.split(';').each do |part|
        		part.strip!
        		test = false
				File.readlines(TERMDIR + file).each do |line|
				  
					arr = line.split("\t")
					if(part == arr[0].strip)#first col is term
					  
						test = true
						if (!arr[2].strip.empty?)#third col is the uri
							arr[2].strip.split('|').each do |uri|
							  graph << RDF::Statement.new(subject, predicate, RDF::URI.new(uri))
							  #graph << RDF::Statement.new(RDF::URI.new(arr[2].strip), RDF::URI.new(SOURCES[arr[1].strip]), RDF::Literal.new(part, :language => :en)) 
							end
						else
						  test = false
						end
						
					end
				end #do line
				if (!test)
					 #go with opaquens
					 puts "verify #{part} in opns/#{cat}"
					 name = reformat_name(part)
					graph << RDF::Statement.new(subject, predicate, RDF::URI("http://opaquenamespace.org/ns/#{cat}/#{name}"))
				end
				
			end #do part
			
			graph
		end
		
		def justOpaque(subject,data, predicate, cat)
		  graph = RDF::Graph.new
		  data.split(';').each do |part|
        	part.strip!
        	name = reformat_name(part)
        	graph << RDF::Statement.new(subject, predicate, RDF::URI("http://opaquenamespace.org/ns/#{cat}/#{name}"))
          end
          graph
        end
	
		def jasr_subj(subject, data)
			graph = lookupTerm(subject, data, "jasr_subj.csv",RDF::DC.subject)
			graph
		end
	
		def jasr_corp(subject, data)
			graph = lookupTerm(subject, data, "jasr_corp.csv",RDF::DC.subject)
			graph
		end
	
		def jasr_creator(subject, data)
			graph = lookupTerm(subject, data, "jasr_creator.csv",RDF::DC.creator)
			graph
		end
	
		def pnwa_city(subject, data)
			graph = lookupTerm(subject, data, "pnwa_city.csv",RDF::DC.spatial)
			graph
		end
		
		def pnwa_country(subject, data)
			graph = lookupTerm(subject, data, "pnwa_country.csv",RDF::DC.spatial)
			graph
		end
		
		def pnwa_county(subject, data)
			graph = lookupTerm(subject, data, "pnwa_county.csv",RDF::DC.spatial)
			graph
		end
		
		def pnwa_creator(subject, data)
		
			graph = lookupTermOrOpaque(subject, data, "pnwa_creator.csv",RDF::DC.creator, "creator")
			graph
		end
		
		def pnwa_objtype(subject, data)
			graph = lookupTerm(subject, data, "pnwa_objtype.txt",RDF::URI.new(NAMESPACES[:rdf] + "type"))
			graph
		end
		
		def pnwa_photog(subject, data)
			graph = lookupTermOrOpaque(subject, data, "pnwa_photog.csv",RDF::URI.new(NAMESPACES[:marcrel] + "pht"), "creator")
			graph
		end
		
		def pnwa_style(subject, data)
			graph = lookupTerm(subject, data, "pnwa_style.csv",RDF::URI.new(NAMESPACES[:oregon] + "vra/hasStylePeriod"))
			graph
		end
		
		def pnwa_state(subject, data)
			graph = lookupTerm(subject, data, "pnwa_stateprov.csv",RDF::DC.spatial)
			graph
		end
	
		
		
		def jsma_cat(subject, data)
			graph = lookupTerm(subject, data, "jsma_cat.csv", RDF::URI.new(NAMESPACES[:vra] + "workType"))
			graph
		end
		
		def jsma_creator(subject, data)
			graph = lookupTerm(subject, data, "jsma_creator.csv", RDF::DC.creator)
			graph
		end
	
		def jsma_cult(subject, data)
			graph = lookupTerm(subject, data, "jsma_cult.csv", RDF::URI.new(NAMESPACES[:vra] + "culture"))
			graph
		end

		def jsma_style(subject, data)
			graph = lookupTerm(subject, data, "jsma_style.csv", RDF::URI.new(NAMESPACES[:vra] + "stylePeriod"))
			graph
		end
		
		def tleg_creators(subject, data)
			graph = lookupTermOrOpaque(subject, data, "tleg_creators.txt", RDF::DC.creator, "creator")
			graph
		end
		
		def tleg_cult(subject, data)
			graph = lookupTerm(subject, data, "tleg_cult.csv", RDF::URI.new(NAMESPACES[:vra] + "culture"))
			graph
		end
		
		def tleg_org(subject, data)
			graph = lookupTerm(subject, data, "tleg_org.csv", RDF::DC.description)
			graph
		end
		
		def tleg_geo(subject, data)
			graph = lookupTerm(subject, data, "tleg_geo.csv", RDF::DC.spatial)
			graph
		end
		
		def tleg_subj(subject, data)
			graph = lookupTerm(subject, data, "tleg_subj.csv", RDF::DC.subject)
			graph
		end
		
		def tleg_lcsubj(subject, data)
			graph = lookupTerm(subject, data, "tleg_lcsubj.csv", RDF::DC.subject)
			graph
		end
		
		def tleg_work(subject, data)
			graph = lookupTerm(subject, data, "tleg_work.csv", RDF::URI.new(NAMESPACES[:vra] + "workType"))
			graph
		end
		
		def ulmann2_corp(subject, data)
			graph = lookupTermOrOpaque(subject, data, "ulmann2_corp.csv", RDF::DC.subject, "people") 
			graph
		end
		
		def ulmann2_lcsubj(subject, data)
			graph = lookupTermOrOpaque(subject, data, "ulmann2_lcsubj.csv", RDF::DC.subject, "subject") 
			graph
		end
		
		def ulmann2_people(subject, data)
			graph = lookupTermOrOpaque(subject, data, "ulmann2_people.csv", RDF::URI.new(NAMESPACES[:oregon] + "people"), "people") 
			graph
		end
		
		def ulmann2_photog(subject, data)
			graph = lookupTermOrOpaque(subject, data, "ulmann2_photog.csv", RDF::URI.new(NAMESPACES[:marcrel] + "pht"), "creator")
			graph
		end
		
		def ulmann2_place(subject, data)
			graph = lookupTerm(subject, data, "ulmann2_place.csv", RDF::DC.spatial)
			graph
		end
		
		def ulmann2_subj(subject, data)
			graph = lookupTermOrOpaque(subject, data, "ulmann2_subj.csv", RDF::DC.subject, "subject")
			graph
		end
		
		def ulmann2_theme(subject, data)
			graph = lookupTermOrOpaque(subject, data, "ulmann2_theme.csv", RDF::DC.subject, "subject") 
			graph
		end
		
		def wwdl_corp(subject, data)
			graph = lookupSubj(subject, data, "wwdl_corp.csv", false, nil)
			graph
		end
		
		def wwdl_genre(subject, data)
			graph = lookupTerm(subject, data, "wwdl_genre.csv", RDF::URI.new(NAMESPACES[:rdaw] + "formOfWork.en"))
			graph
		end
		
		def wwdl_lcsub(subject, data)
			graph = lookupSubj(subject, data, "wwdl_lcsub.csv", false, nil)
			graph
		end
		
		def wwdl_people(subject, data)
			graph = lookupSubj(subject, data, "wwdl_people.csv", false, nil) 
			graph
		end
		
		def wwdl_photog(subject, data)
			graph = lookupTerm(subject, data, "wwdl_photog.csv", RDF::URI.new(NAMESPACES[:marcrel] + "pht"))
			graph
		end
		
		def wwdl_place(subject, data)
			graph = lookupTerm(subject, data, "wwdl_place.csv", RDF::DC.spatial)
			graph
		end
		
		def wwdl_tgmsub(subject, data)
			graph = lookupSubj(subject, data, "wwdl_tgmsub.csv", false, nil) 
			graph
		end
		
		
		def artmulticoll_creator(subject, data)
			graph = lookupTermOrOpaque(subject, data, "artcolls_agent.txt", DC_ELEM[:creator],"creator")
			graph
		end
		
		def artmulticoll_cult(subject, data)
			graph = lookupTermOrOpaque(subject, data, "artcolls_culture.txt", RDF::URI.new(NAMESPACES[:oregon] + "vra/culturalContext"), "culture")
			graph
		end
		
		def artmulticoll_repo(subject, data)
			arr = data.split(",") #ls -adding this bc it looks like the terms in the lookup are only the first part
			graph = lookupTermOrOpaque(subject, arr[0], "artcolls_repo.txt", RDF::URI.new(NAMESPACES[:marcrel] + "rps"), "repository")
			graph
		end
		
		def artmulticoll_style(subject, data)
			
			graph = lookupTermOrOpaque(subject, data, "artcolls_style.txt", RDF::URI.new(NAMESPACES[:oregon] + "vra/hasStylePeriod"),"stylePeriod")
			graph
		end
		
		def artmulticoll_subj(subject, data)
			graph = lookupTermOrOpaque(subject, data, "artcolls_subj.txt", RDF::DC.subject, "subject")
			graph
		end
		
		def artmulticoll_work(subject, data)
			
			graph = lookupTermOrOpaque(subject, data, "artcolls_work.txt", RDF::URI.new(NAMESPACES[:oregon] + "vra/workType"),"workType")
			graph
		end
		
		def artmulticoll_source(subject, data)
		  
			graph = lookupTermOrOpaque(subject, data, "artcolls_source.txt", RDF::URI.new(NAMESPACES[:oregon] + "localCollectionName"),"localCollectionName")
			graph
		end
		
		def maic_monu(subject, data)
			graph = lookupTermOrOpaque(subject, data, "maic_monu.csv", RDF::URI.new(NAMESPACES[:rdf] + "type"), "workType/Altai")
			graph
		end
		
		def maic_subj(subject, data)
			graph = lookupSubj(subject, data, "maic_subj.csv", RDF::DC.subject, "subject")
			graph
		end
		
		def maic_proc(subject, data)
			graph = lookupTermOrOpaque(subject, data, "maic_proc.csv", RDF::URI.new(NAMESPACES[:oregon] + "vra/hasTechnique"), "technique")
			graph
		end
		
		def maic_primary(subject, data)
			graph = lookupTerm(subject, data, "maic_primary.csv", RDF::DC.spatial)
			graph
		end
		
		def maic_second(subject, data)
			graph = lookupTerm(subject, data, "maic_second.csv", RDF::DC.spatial)
			graph
		end
		
		def maic_period(subject, data)
			graph = lookupTermOrOpaque(subject, data, "maic_period.csv", RDF::URI.new(NAMESPACES[:oregon] + "vra/hasStylePeriod"), "stylePeriod/Altai")
			graph
		end
		
		def maic_perioqual(subject, data)
			graph = lookupTermOrOpaque(subject, data, "maic_perioqual.csv", RDF::URI.new(NAMESPACES[:oregon] + "vra/hasStylePeriod"), "stylePeriod/Altai")
			graph
		end
		
		def maic_photog(subject, data)
			graph = lookupTermOrOpaque(subject, data, "maic_photog.csv", RDF::URI.new(NAMESPACES[:marcrel] + "pht"), "creator")
			graph
		end
		
		def mhouse_names(subject, data)
			graph = lookupTermOrOpaque(subject, data, "mhouse_names.csv", RDF::URI.new(NAMESPACES[:oregon] + "subject"), "subject")
			graph
		end
		
		def mhouse_subj(subject, data)
			graph = lookupSubj(subject, data, "mhouse_subj.csv", true, "subject")
			graph
		end
		
		def mhouse_photog(subject, data)
			graph = RDF::Graph.new
			graph << RDF::Statement(subject, RDF::URI(NAMESPACES[:marcrel] + "pht"), RDF::URI("http://id.loc.gov/authorities/names/no2010153709"))
			graph
		end
		
		def mhouse_place(subject, data)
			graph = lookupTerm(subject, data, "mhouse_place.csv", RDF::DC.spatial)
			graph
		end
		
		def mhouse_type(subject, data)
			graph = lookupSubj(subject, data, "mhouse_type.csv", true, "subject")
			graph
		end
		
		def bestof_place(subject, data)
			graph = lookupTerm(subject, data, "bestof_place.csv", RDF::DC.spatial)
			graph
		end
		
		def bestof_subj(subject, data)
			graph = lookupTerm(subject, data, "bestof_subj.csv", RDF::DC.subject)
			graph
		end
		
		def bestof_names(subject, data)
			graph = lookupTerm(subject, data, "bestof_names.csv", RDF::DC.subject)
			graph
		end
		
		def bestof_corp(subject, data)
			graph = lookupTerm(subject, data, "bestof_corp.csv", RDF::DC.subject)
			graph
		end
		
		def bestof_genre(subject, data)
			graph = lookupTerm(subject, data, "bestof_genre.csv", RDF::DC.subject)
			graph
		end
		
		def bestof_names(subject, data)
			graph = lookupTerm(subject, data, "bestof_names.csv", RDF::DC.subject)
			graph
		end
		
		def uovets_subj(subject, data)
			graph = lookupTerm(subject, data, "uovets_subj.csv", RDF::DC.subject)
			graph
		end
		
		
		def univ_subj(subject, data)
			graph = lookupSubj(subject, data, "univ_subjU.txt", true, "subject")
			graph
		end
		
		def univ_lcsubj(subject, data)
			graph = lookupSubj(subject, data, "univ_lcsubjU.txt", true, "subject")
			graph
		end
		
		def univ_photog(subject, data)
		graph = RDF::Graph.new
		 name = reformat_name(data)
		graph << RDF::Statement(subject, RDF::URI.new(NAMESPACES[:marcrel] + "pht"), RDF::URI.new("http://opaquenamespace.org/ns/creator/#{name}"))
		  graph
		end
		
		
		def univ_corp(subject, data)
		  graph = lookupSubj(subject, data, "univ_corp.txt", true, "subject")
			graph
		end
		
		def univ_place(subject, data)
		  graph = lookupTerm(subject, data, "univ_place.txt", RDF::DC.spatial)
			graph
		end
		
		def univ_people(subject, data)
		  graph = lookupTermOrOpaque(subject, data, "univ_people.txt", RDF::URI.new(NAMESPACES[:oregon] + "people"), "people")
			graph
		end
		
		def uovets_branch(subject, data)
			graph = lookupTerm(subject, data, "uovets_branch.csv", RDF::URI("http://opaquenamespace.org/ns/militaryBranch"))
			graph
		end
		
		def uoath_photog(subject, data)
			graph = lookupTermOrOpaque(subject, data, "uoath_photog.txt", RDF::URI.new(NAMESPACES[:marcrel] + "pht"), "creator")
			graph
			end
			
		def uoath_author(subject, data)
			graph = lookupTermOrOpaque(subject, data, "uoath_author.txt", RDF::URI.new(NAMESPACES[:marcrel] + "aut"), "creator")
			graph
		end
			
		def uoath_people(subject, data)
		graph = lookupTermOrOpaque(subject, data, "uoath_people.txt", RDF::URI.new(NAMESPACES[:oregon] + "people"), "people")
			graph
		end
		
		def uoath_people(subject, data)
			graph = lookupTermOrOpaque(subject, data, "uoath_people.txt", RDF::URI.new(NAMESPACES[:oregon] + "people"), "people")
			graph
		end
		
		def uoath_corp(subject, data)
		graph = lookupSubj(subject, data, "uoath_corp.txt", true, "subject")
			graph
		end
		
		def uoath_tgm(subject, data)
		graph = lookupSubj(subject, data, "uoath_tgm.txt", true, "subject")#list is all tgm
			graph
		end
		
		def uoath_subj(subject, data)
		graph = lookupSubj(subject, data, "uoath_subj.txt", true, "subject")#list is all LCSH
			graph
		end
		
		def uoath_place(subject, data)
		graph = lookupTerm(subject, data, "uoath_place.txt", RDF::DC.spatial)
			graph
		end
		
		def percent_creator(subject, data)#also add triple for rightsholder here
			graph = lookupTermOrOpaque(subject, data, "percent_creator.csv", RDF::DC.creator, "creator")
			graph << RDF::Statement(subject, RDF::URI('http://opaquenamespace.org/rights/rightsHolder'), data)
		    graph
		end
		
		def percent_people(subject, data)
			graph = lookupSubj(subject, data, "percent_people.csv", true, "subject")
			graph
			end
			
			def percent_medium(subject, data)
			graph = lookupTerm(subject, data, "percent_medium.csv", RDF::URI(NAMESPACES[:oregon] + "vra/material"))
			graph
			end
			
			def percent_county(subject, data)
			graph = lookupTerm(subject, data, "percent_county.csv", RDF::DC.spatial)
			graph
			end
			
			def percent_subject(subject, data)
			graph = lookupSubj(subject, data, "percent_subject.csv", true, "subject")
			graph
			end
			
			def percent_aat(subject, data)
			graph = lookupSubj(subject, data, "percent_aat.csv", true, "subject")
			graph
			end
			
			def percent_place(subject, data)
			graph = lookupTerm(subject, data, "percent_place.csv", RDF::DC.spatial)
			graph
			end
			
			def percent_awsite(subject, data)
			graph = lookupTerm(subject, data, "percent_awsite.csv", RDF::DC.spatial)
			graph
			end
			
			def percent_sourceformat(subject, data)
			graph = lookupTerm(subject, data, "percent_sourceformat.txt", RDF::DC.hasVersion)
			graph
			end
			
			def oimb_class(subject, data)
			graph = lookupTermOrOpaque(subject, data, "oimb_class.csv", RDF::URI(NAMESPACES[:dwc] + "class"),"class")
			graph
			end
			
			def oimb_common(subject, data)
			graph = lookupTermOrOpaque(subject, data, "oimb_common.csv", RDF::URI(NAMESPACES[:dwc] + "vernacularName"),"vernacularName")
			graph
			end
			
			def oimb_genus(subject, data)
			graph = lookupTermOrOpaque(subject, data, "oimb_genus.csv", RDF::URI(NAMESPACES[:dwc] + "genus"),"genus")
			graph
			end
			
			def oimb_loc(subject, data)
			graph = lookupTerm(subject, data, "oimb_loc.csv", RDF::DC.spatial)
			graph
			end
			
			def oimb_phylum(subject, data)
			graph = lookupTermOrOpaque(subject, data, "oimb_phylum.csv", RDF::URI(NAMESPACES[:dwc] + "phylum"),"phylum")
			graph
			end
			
			def oimb_subtopic(subject, data)
			graph = lookupSubj(subject, data, "oimb_subtopic.csv", true, "subject")
			graph
			end
			
			def oimb_topic(subject, data)
			graph = lookupSubj(subject, data, "oimb_topic.csv", true, "subject")
			graph
			end
			
			def oimb_creator(subject, data)
			graph = RDF::Graph.new
			data.split(';').each do |part|
        		part.strip!
        		name = reformat_name(part)
        		graph << RDF::Statement(subject, RDF::DC.creator, RDF::URI("http://opaquenamespace.org/ns/creator/#{name}"))
        	end
        	graph
			end
			
			def uopres_lcsubj(subject, data)
			  graph =lookupSubj(subject, data, "uopres_lcsubjU.txt", true, "subject");
			  graph
			  end
			  
			  def uopres_tgmsubj(subject, data)
			  graph =lookupSubj(subject, data, "uopres_tgmsubjU.txt", true, "subject");
			  graph
			  end
			  
			  def uopres_auth(subject, data)
			  graph =lookupTermOrOpaque(subject, data, "uopres_auth.txt", RDF::DC.creator, "creator");
			  graph
			  end
			  
			  def uopres_contr(subject, data)
			  graph =lookupTermOrOpaque(subject, data, "uopres_contr.txt", RDF::DC.contributor, "contributor");
			  graph
			  end
			  
			  def uopres_people(subject, data)
			  graph =lookupTermOrOpaque(subject, data, "uopres_peopleU.txt", RDF::URI("http://opaquenamespace.org/ns/people"), "people");
			  graph
			  end
			
			def uopres_place(subject, data)
			graph = lookupTerm(subject, data, "uopres_place.txt", RDF::DC.spatial)
			graph
			end
			
			def uopres_corp(subject, data)
			  graph =lookupSubj(subject, data, "uopres_corpU.txt", true, "subject");
			  graph
			  end
			  
			def latino_subj(subject, data)
			 graph = lookupTermOrOpaque(subject, data, "latino_subj.txt", RDF::DC.subject, "subject")
			 graph
			 end
			 
			 def bkarts_pub(subject, data)
			 graph = lookupTermOrOpaque(subject, data, "bkarts_pub.txt", RDF::DC.publisher, "publisher")
			 graph
			 end
			 
			 def bkarts_place(subject, data)
			 graph = lookupTerm(subject, data, "bkarts_place.txt", RDF::URI(NAMESPACES[:rdam] + "placeOfProduction.en"))
			 graph
			 end
			 
			 def bkarts_subj(subject, data)
			 graph = lookupTermOrOpaque(subject, data, "bkarts_sub_final.txt", RDF::DC.subject, "subject")
			 graph
			 end
			 
			 def bkarts_bind(subject, data)
			 graph = lookupTermOrOpaque(subject, data, "bkarts_bind.txt", RDF::URI(NAMESPACES[:oregon] + "vra/technique"), "technique")
			 graph
			 end
			 
			 def bkarts_print(subject, data)
			 graph = lookupTermOrOpaque(subject, data, "bkarts_print.txt", RDF::URI(NAMESPACES[:oregon] + "vra/technique"), "technique")
			 graph
			 end
			 
			 
			 def bkarts_work(subject, data)
			 graph = lookupTermOrOpaque(subject, data, "bkarts_work2.txt", RDF::URI(NAMESPACES[:oregon] + "vra/workType"), "workType")
			 graph
			 end
			 
			 def bkarts_lit(subject, data)
			 graph = lookupTerm(subject, data, "bkarts_lit.txt", RDF::URI(NAMESPACES[:rdaw] + "formOfWork.en") )
			 graph
			 end
			 
			 def bkarts_creato(subject, data)
			 graph = lookupTermOrOpaque(subject, data, "bkarts_creato.txt", RDF::URI(NAMESPACES[:dce] + "creator"), "creator")
			 graph
			 end
			 def bkarts_contrib(subject, data)
			 graph = lookupTermOrOpaque(subject, data, "bkarts_contrib.txt", RDF::DC.contributor, "contributor")
			 graph
			 end
			 def bkarts_auth(subject, data)
			 graph = lookupTermOrOpaque(subject, data, "bkarts_auth.txt", RDF::URI(NAMESPACES[:marcrel] + "aut"), "creator")
			 graph
			 end
			 def comm_creato(subject, data)
			 graph = lookupTermOrOpaque(subject, data, "comm_photog.txt", RDF::DC.creator, "creator")
			 graph
			 end
			 
			 def comm_places(subject, data)
			 graph = lookupTerm(subject, data, "comm_places.txt", RDF::DC.spatial)
			 graph
			 end
			 
			 def comm_subj(subject, data)
			 graph = lookupTermOrOpaque(subject, data, "comm_subj.txt", RDF::DC.subject, "subject")
			 graph
			 end
			 
			 def comm_persons(subject, data)
			 graph = lookupTermOrOpaque(subject, data, "comm_persons.txt", RDF::URI(NAMESPACES[:oregon] + "people"), "subject")
			 graph
			 end
			 
			 def comm_srcFormat(subject, data)
			 graph = lookupTerm(subject, data, "comm_srcFormat.txt", RDF::DC.hasVersion)
			 graph
			 end
			
			def diss_subj(subject, data)
			 graph = lookupTermOrOpaque(subject, data, "diss_subj.csv", RDF::DC.subject, "subject")
			 graph
			 end
			 def diss_creato(subject, data)
			 graph = lookupTermOrOpaque(subject, data, "diss_auth.csv", RDF::DC.creator, "creator")
			 graph
			 end
			 
			 def uostock_creator(subject, data)
			 graph = justOpaque(subject, data, RDF::DC.creator, "creator")
			 graph
			 end
			 def uostock_subject(subject, data)
			 graph = lookupTermOrOpaque(subject, data, "uostock_subjects3.txt", RDF::DC.subject, "subject")
			 graph
			 end
			 def uostock_build(subject, data)
			 graph = lookupTerm(subject, data, "uostock_build.txt", RDF::DC.spatial)
			 graph
			 end
			 def uostock_event(subject,data)
			 graph = justOpaque(subject, data, RDF::URI(NAMESPACES[:schema] + "event"), "subject")
			 graph
			 end
			 def uostock_season(subject,data)
			 graph = lookupTermOrOpaque(subject, data, "uostock_season.txt", RDF::DC.subject, "subject")
			 graph
			 end
			 def uostock_genre(subject,data)
			 graph = lookupTermOrOpaque(subject, data, "uostock_genre.txt", RDF::DC.subject, "subject")
			 graph
			 end
			 
			 def lowen_loc(subject,data)
      			graph = RDF::Graph.new
      			Array(data.split(";")).each do |part|
      			  if part.include?("site")
      			    graph << RDF::Statement.new(subject, RDF::DC.coverage, part.strip)
      			
      			  elsif part.include?("repository")
      			    names = data.split(',')
      			    #names[3].gsub!("(repository)","")
      			    graph << lookupTerm(subject, names[0].strip, "lowen_repo.txt", RDF::URI(NAMESPACES[:marcrel] + "rps"))
      			  end
      			end
      			graph
      		end
      			
      			def lowen_pho(subject, data)
      			graph = RDF::Graph.new
      			graph = lookupTermOrOpaque(subject, data, "lowen_pho.txt", RDF::URI(NAMESPACES[:marcrel] + "pht"), "creator")
      			graph
      			end
      			
      			
      			
	end
end
