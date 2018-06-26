
require 'yaml'

def validate val

  @urls['vocabularies'].each do |url, obj|
    if val.include? url
      patt = val.gsub("#{obj["before"]}://#{url}","")
      if obj.include? "vocabs"
        obj["vocabs"].each do |v|
          if patt.include? v
            patt.gsub!("/#{v}", "")
            break
          end
        end
      end
      test = check(obj["after"], patt.strip)
      puts val + " syntax error" unless test
      return
    end
  end
  puts val + " not found"
end


def check (patt1, patt2)
  exp = Regexp.new(patt1)
  test = exp.match patt2
  rval = test.to_s != patt2 ? false : true
  rval
end


@urls = YAML.load_file("urls.yml")
File.readlines(ARGV[0]).each do |line|
  arr = line.split(Regexp.new("[|\t]"))
  arr.each do |val|
    validate val unless( (!val.include? "http") && ( !val.include? "\"") )
  end
end
