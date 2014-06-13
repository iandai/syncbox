# Syncbox

The Syncbox gem sync files from local directory to aws S3.

## Features

* Supports sync single local directory to one S3 bucket.
* Updated new file will replace old file.

## Pending features

* Two process run together confilict.
* Sync multipul directories to S3 bucket.

## Install

```
  gem install syncbox
```

## Usage

* Use in ruby project
	
```ruby
require 'syncbox'

store = "S3"
store_config = { "access_key_id" => "XXXXXXXXXXXXXXXXXXXX", 
                 "secret_access_key" => "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX",
                 "bucket_name" => "your-bucket-name"
               }
local_directory = "path_to_file"
Syncbox::Syncbox.start(store, store_config, local_directory)

```

```ruby
# use bundle exec to avoid using different gem
bundle exec ruby your-project-file.rb
```

* Use in command line and run in background

1.set up config.yml file
```
store: "S3"
store_config:
  access_key_id: "XXXXXXXXXXXXXXXXXXXX"
  secret_access_key: "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
  bucket_name: "your-bucket-name"
local_directory: "path_to_file"  
```

2.run commands
```ruby
syncbox diff -c config.yml     # show difference of local direcotry and s3 bucket.
syncbox sync -c config.yml
```

3.add command `syncbox sync -c config.yml` to crontab. 

