class Ruhoh
  
  module Utils
    
    FMregex = /^(---\s*\n.*?\n?)^(---\s*$\n?)/m
    ContentRegex = /\{\{\s*content\s*\}\}/i
    
    def self.parse_file_as_yaml(*args)
      filepath = File.__send__ :join, args
      return nil unless File.exist? filepath

      file = File.open(filepath)
      yaml = YAML.load(file) || {}
      file.close  
      
      yaml
    end
    
    def self.parse_file(*args)
      path = File.__send__(:join, args)
      path = File.join(Ruhoh.paths.site_source, path) unless path[0] == '/'
      
      raise "File not found: #{path}" unless File.exist?(path)

      page = File.open(path).read
      front_matter = page.match(FMregex)

      return {} unless front_matter

      data = YAML.load(front_matter[0].gsub(/---\n/, "")) || {}

      { 
        "data" => data, 
        "content" => page.gsub(FMregex, '')
      }
    end
  
  end
  
end #Ruhoh