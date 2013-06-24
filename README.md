# JSONReadWrite

A Rubymotion module to make light work of writing to and reading from JSON files.

Basically a copy of PlistReadWrite from the guys at Katana Labs - https://github.com/KatanaCode/PListReadWrite.

## Installation

Add the following to your app's Gemfile

    gem 'json_read_write'

Alternatively, it's a small file so you can just copy/paste it directly to your app.

## Example Usage

Lets assume we have this json file in our resources directory...

``` json
{
  "employees": [
    { "firstName":"John" , "lastName":"Doe" }, 
    { "firstName":"Anna" , "lastName":"Smith" }, 
    { "firstName":"Peter" , "lastName":"Jones" }
  ]
}
```

... and we want to copy it over to our app's documents directory so we can update/edit the json.

``` ruby

# Check if the json exists in our documents dir
JSONReadWrite.exist?(:employees, :documentsDir) # => false

# Check if the json exists in our main bundle
JSONReadWrite.exist?(:employees, :mainBundle) # => true

# Copy the json file from the main bundle to the documents dir
JSONReadWrite.copyJSONFileFromBundle(:employees)

# Fetch the data from the json file
@employees = JSONReadWrite.jsonData(:employees) # => A hash containing the User data

# Update the data
@employees[:employees] 
@employees[:employees][0][:firstName] = 'James'

# Store the data back in the json
JSONReadWrite.updateJSONFileWithObject(:employees, @employees)

# Check this worked OK
JSONReadWrite.jsonData(:employees)[0][:firstName] # => "James"
```

## About Katana Code

Katana Code are [iPhone app and Ruby on Rails Developers in Edinburgh, Scotland](http://katanacode.com/ "Katana Code").
