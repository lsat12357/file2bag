require 'yaml'

mapdoc = YAML.load_file(ARGV[0])

mapdoc["mappings"][ARGV[1]].each do |pred|
  arr = pred.split(":")
  next unless arr.size > 1
  unless mapdoc["namespaces"].include? arr[0]
    puts "problem with #{arr[0]}"
  end
end
