module JSONReadWrite
  
  # Custom error class used when trying to access a json file that doesn't exist.
  class NoFileError < StandardError; end

  # Check if a json file exists in either the main bundle or the documents dir.
  #
  # fileName - The name of the json file to return, minus the .json extension
  # directory - A Symbol named either :documentsDir or :mainBundle depending on where you'd like 
  #             to search (defaults: :documentsDir)
  #
  # Returns either True or False
  def self.exist?(fileName, directory = :documentsDir)
    case directory.to_sym
    when :documentsDir
      File.exist?(jsonPath(fileName))
    when :mainBundle
      NSBundle.mainBundle.pathForResource(fileName, ofType: "json")
    else
      raise ArgumentError, "directory must be one of :documentsDir or :mainBundle (was #{directory})"
    end
  end

  # Returns the path to the json file named fileName as a String
  # 
  # fileName - The name of the json file to return, minus the .json extension
  # 
  # Examples
  # 
  #   JSONRW.jsonPath('awesome')
  #   # => "/Users/Bodacious/Library/Application Support/iPhone Simulator/6.0/Applications/5A54505B-495E-4744-B8F4-DB0727FD161D/Documents/awesome.json"
  def self.jsonPath(fileName)
    File.join(documentsDir, "#{fileName}.json")
  end

  # Update the json file with the contents of the object passed
  # 
  # fileName - The name of the json file to return, minus the .json extension
  # object - A Hash or Array with the contents of the JSON file
  # 
  # Examples
  #   
  #   @array = [{id: 1, name: "one"}, {id: 2, name: "two"}]
  #   JSONRW.updateJSONFileWithObject('awesome', @array)
  #
  #   @hash = {1 => "one", 2 => "two"}
  #   JSONRW.updateJSONFileWithObject('awesome', @hash)
  # 
  # Raises NoFileError if the json file doesn't exist
  def self.updateJSONFileWithObject(fileName, object)
    ap "UPDATING JSON"
    raise ArgumentError, "Expected object to be an instance of Array or Hash, was #{object.class}" unless object.is_a?(Array) || object.is_a?(Hash)
    raise NoFileError, "Cannot find json file: #{fileName}.json in documents directory" unless exist?(fileName)
    # object.writeToFile(jsonPath(fileName), atomically: true)
    ap "THIS IS A TEST"
    object.to_s.writeToFile(jsonPath(fileName), atomically:true, encoding:NSASCIIStringEncoding, error:nil)
  end

  # The object containing the data stored in the json
  #
  # fileName - The name of the json file to return, minus the .json extension
  # klass    - The name of the Class which is being stored in the json. Must be either a Hash or Array (defaults: Hash)
  #
  # Returns an Array or Hash with the file content
  def self.jsonData(fileName)
    raise NoFileError, "Cannot find json file: #{fileName}.json in documents directory" unless exist?(fileName)
    path   = jsonPath(fileName)
    string = String.new(NSString.stringWithContentsOfFile(path, encoding:NSUTF8StringEncoding, error:nil))
    string.nsdata
  end

  # Copy the template <fileName>.json file from the resources dir to the application's documents directory
  # fileName - The name of the json file to return, minus the .json extension
  def self.copyJSONFileFromBundle(fileName)
    templatePath = NSBundle.mainBundle.pathForResource(fileName, ofType: 'json')
    toPath       = jsonPath(fileName)
    NSFileManager.defaultManager.copyItemAtPath(templatePath, toPath: toPath, error: nil)
  end
  
  private
  
  # Private: Helper method to access the application's documents directory
  def self.documentsDir
    @@documentsDir ||= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true).first
  end
  
end