require 'term/ansicolor'

class Tokenize
    PERMITTED_FILE_TYPES = %w'config tt cmd js'

    def description()
      "Tokenizing configuration files"
    end

    def initialize(env)
      @env = env
    end

    def execute()
      path = @env.root
      environment = @env.environment
      
      @globals = {}

      #readtokens(readlines(@globals_path), environment, @globals)

      find_master_files(path).each do |file|
          begin
              @env.log("#{file.gsub(path, '')}", :info) unless @env.environment == 'local'
              @values = {}
              readtokens(readlines(file.gsub('.master', '.tokens')), environment, @values) if has_a_tokens_file(file)
              tokenise_file(file, @globals, @values)
          rescue InvalidTokenFile
              @env.log("Ignoring #{file.gsub(path, '')} as it uses NAnt xml", :warn) unless @env.environment == 'local'
          end
      end
    end

    # Private Methods
    # Been a bit naughty and exposed some methods for testing
    
    def find_master_files(path)
      path_as_dos = path.gsub('\\', '/')
      permitted_extensions = PERMITTED_FILE_TYPES.join(',')
      return Dir["#{path_as_dos}/**/*.master.{#{permitted_extensions}}"]
    end    
    
    def readlines(file)
        lines = []
        File.open(file, "r").each {|line| sanitise_line(line, lines) }
        return lines
    end

    def sanitise_line line, lines
      line = line.chomp.strip
      raise InvalidTokenFile if(line.include? '<target name=')
      lines.push(line) unless (line.empty? or line.include? '--')
    end

    def readtokens(lines, environment, collection)      
        lines.reverse!
        
        until (line = lines.pop) == nil do
            add_entries(lines, collection) if contains_environment(line, environment)
        end
    end
    
    def tokenise_file(file, globals, values)       
        text = File.read(file)
        replace_tokens(file, text, globals, values)       
        File.open(get_output_path(file.gsub('.master', '')), 'w') { |f| f.write(text) }        
        
        matches = text.scan(/(\$[a-zA-Z0-9\-_]+\$)/)
        
        raise_missing_tokens_error(matches, file) if matches.length > 0
    end

    def raise_missing_tokens_error matches, file
      raise "There are untokenised values, #{matches.join(', ')} still in #{get_output_path(file)}!"
    end

    def replace_tokens(file, text, globals, values)
        values.each do |key, value|
            key = "$#{key}$"
            puts "#{key} token is not used in file #{file}" unless text.include? key
            text.gsub!("#{key}", value)
        end

        globals.each {|key, value| text.gsub!("$#{key}$", value) }
        
        return text       
    end
    
    def add_entries(lines, collection)
        while (line = lines.pop) != nil do
            if line =~ /^#/
                lines.push(line) # Put the entry back in as we're not using it yet
                break
            else
                add_entry(get_key(line), get_value(line), collection)
            end
        end
    end
    
    def add_entry(key, value, collection)
        raise "Config already contains an entry for #{key}, duplicates are not allowed!" if collection.key?(key)
        collection.merge!({key, value})
    end
    
    def get_key(line)
        raise "Missing separator => on #{line}" unless line.include? '=>'       
        return line.split(/\s*=>\s*/)[0].strip
    end
    
    def get_value(line)
        line = line.split(/\s*=>\s*/)[1].strip
        
        if line =~ /^\$/
            variable = eval(line)          
            return variable unless variable.nil?
            puts "#{line} was treated as a Global Variable, but returned null"
        end
        
         if line =~ /^%/
            variable = eval(line[1..-1])          
            return variable unless variable.nil?
            puts "#{line} was treated as a Constant, but returned null"
        end
        
        matches = line.scan(/\#\{(.*)\}/)
        matches.each do |match|
            value = eval("#{match}")
            line.gsub!('#{' + "#{match}" + '}', value) unless value.nil?
        end
        
        # If a token starts AND ends with a quote, strip them out
        line = line.chop.slice(1..line.length-1) if line =~ /^".*"/
        
        return line
    end
    
    def get_output_path(path)
        return "#{File.dirname(path)}/../#{File.basename(path).gsub('.tokens', '')}"   
    end
    
    def contains_environment(line, environment)
        return (line.include? "##{environment.downcase}" or (environment != 'local' and line.include? "#non-local"))
    end

    def has_a_tokens_file master_file
      File.exist?(master_file.gsub('.master', '.tokens'))
    end
end

class InvalidTokenFile < StandardError  
end