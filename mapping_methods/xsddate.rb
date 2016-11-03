require 'rdf'

module MappingMethods
  module XSDDate
    def xsd_date(subject, predicate, data)
      if /^\d{4}(-\d{2})*$/.match(data)
        puts RDF::Statement.new(subject, predicate, RDF::Literal(data, :datatype => RDF::XSD.date))
        RDF::Statement.new(subject, predicate, RDF::Literal(data, :datatype => RDF::XSD.date))
      else
        string_date(subject, predicate, data)
      end
    end

    def xsd_datetime(subject, predicate, data)
      RDF::Statement.new(subject, predicate, RDF::Literal(data, :datatype => RDF::XSD.datetime))
    end

    def string_date(subject, predicate, data)
      RDF::Statement.new(subject, predicate, RDF::Literal(data))
    end

    def dc_date(subject, data)
      string_date(subject, RDF::DC.date, data)
    end

    def dc_created(subject, data)
      string_date(subject, RDF::DC.created, data)
    end

    def dc_modified(subject, data)
      string_date(subject, RDF::DC.modified, data)
    end
    
    def unsure_date(subject,data)
    graph = RDF::Graph.new
    
      return graph if data.empty?
      
      Array(data.split(';')).each do |date|
      if date.include? "?"
        date.gsub!("?","0")
        graph << RDF::Statement(subject, RDF::URI("http://www.loc.gov/standards/mods/modsrdf/v1/note"), "Date is uncertain.")
      end
      if date.include? "or"
        date.gsub("or", "-")
        date.gsub(" ", "")
        graph << RDF::Statement(subject, RDF::URI("http://www.loc.gov/standards/mods/modsrdf/v1/note"), "Date is uncertain.")
      end
        graph << string_date(subject, RDF::DC.date, date)
        
        end
        graph
    end
    
    def dc_issued(subject,data)
      string_date(subject, RDF::DC.issued, data)
    end
        
    def dc_digitized(subject, data)
    graph = RDF::Graph.new
    
      return graph if data.empty?
      
      Array(data.split(';')).each do |date|
        if date.include? "/"
        graph << reformat_date(subject,RDF::URI('http://opaquenamespace.org/ns/dateDigitized'), date)
        
        else 
          graph << string_date(subject, RDF::URI('http://opaquenamespace.org/ns/dateDigitized'), date)
        end
        end
        graph
        end
    
    def reformat_date(subject,predicate, data)
      
      parts = data.split('/')
        parts[0].strip!
        if parts[0].length < 2
          parts[0] = "0" + parts[0]
        end
        parts[1].strip!
        if parts[1].length < 2
          parts[1] = "0" + parts[1]
        end
        parts[2].strip!
        if parts[2].length < 4
        parts[2] = "20" + parts[2]
        end
      return RDF::Statement(subject, predicate, "#{parts[2]}-#{parts[1]}-#{parts[0]}")
    end
    
    def artcolls_date(subject, data)
    graph = RDF::Graph.new
    parts = data.split(";").each do |part|
      if part.include? "("
        date = part.split("(")
        if date[1].include? "creation"
          graph << RDF::Statement.new(subject, RDF::DC.date, date[0].strip!)
        else graph << RDF::Statement.new(subject, RDF::DC.temporal, part.strip!)
        end
      else
        graph << RDF::Statement.new(subject, RDF::DC.date, part.strip!)
      end
    end
    graph
    end
    
  end
end
