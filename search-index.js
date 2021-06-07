crystal_doc_search_index_callback({"repository_name":"barite","body":"\nBarite is a library to access the Backblaze B2 API.\n\nIt is far from complete, but will have functions added as I need them.\nContributions are welcome if you need a feature that isn't covered.\n\nIt currently supports enough to be able to transfer individual files to\nand from B2 buckets.\n\n\n## Installation\n\n1. Add the dependency to your `shard.yml`:\n\n   ```yaml\n   dependencies:\n     barite:\n       github: gundy818/barite\n   ```\n\n2. Run `shards install`\n\n\n## Usage\n\n```crystal\nrequire \"barite\"\n\n# Initialise the API.\nb2 = Barite::B2.new(\"my key id\", \"my key\")\n\n# Define a file in a specific bucket.\nb2file = b2.file(\"bucket_name\", \"the/file.txt\")\n\n# Upload the file from a local copy.\nb2file.upload(\"/path/to/local/file.txt\")\n\n# Download the file to a local copy.\nb2file.download(\"/where/to/put/the/download/file.txt\")\n```\n\nIf there are exceptions, they'll probably be\n'Barite::Exception' subclasses. The most likely ones are\n'Barite::Exception::AuthenticationException' if there is a problem with\nyour key, or a 'Barite::Exception::NotFoundException' if something you\nwere trying to access couldn't be found. Hopefully the accompanying\nmessage will help you understand the problem.\n\n\n## Development\n\nThere are no special requirements. There are no real tests at the\nmoment, as I'm figuring out the best way to do this against the actual\nAPI, or by mocking it somehow. Suggestions are welcome!\n\nI will be adding functionality to be able to remove files and work with\nfile versions, and also to set life cycle rules to automatically remove\nold versions.\n\n\n## Contributing\n\n1. Fork it (<https://github.com/gundy818/barite/fork>)\n2. Create your feature branch (`git checkout -b my-new-feature`)\n3. Commit your changes (`git commit -am 'Add some feature'`)\n4. Push to the branch (`git push origin my-new-feature`)\n5. Create a new Pull Request\n\n\n## Contributors\n\n- [darryl](https://github.com/gundy818) - creator and maintainer\n\n\n<!--- vim: textwidth=88\n -->\n\n","program":{"html_id":"barite/toplevel","path":"toplevel.html","kind":"module","full_name":"Top Level Namespace","name":"Top Level Namespace","abstract":false,"superclass":null,"ancestors":[],"locations":[],"repository_name":"barite","program":true,"enum":false,"alias":false,"aliased":null,"aliased_html":null,"const":false,"constants":[],"included_modules":[],"extended_modules":[],"subclasses":[],"including_types":[],"namespace":null,"doc":null,"summary":null,"class_methods":[],"constructors":[],"instance_methods":[],"macros":[],"types":[{"html_id":"barite/Barite","path":"Barite.html","kind":"module","full_name":"Barite","name":"Barite","abstract":false,"superclass":null,"ancestors":[],"locations":[{"filename":"src/barite.cr","line_number":11,"url":"https://github.com/gundy818/barite/blob/b2aa03f8e03ec967a2fd9aa0d95f5e5ec29142b4/src/barite.cr#L11"},{"filename":"src/exception.cr","line_number":16,"url":"https://github.com/gundy818/barite/blob/b2aa03f8e03ec967a2fd9aa0d95f5e5ec29142b4/src/exception.cr#L16"}],"repository_name":"barite","program":false,"enum":false,"alias":false,"aliased":null,"aliased_html":null,"const":false,"constants":[{"id":"VERSION","name":"VERSION","value":"\"0.1.0\"","doc":null,"summary":null}],"included_modules":[],"extended_modules":[],"subclasses":[],"including_types":[],"namespace":null,"doc":null,"summary":null,"class_methods":[],"constructors":[],"instance_methods":[],"macros":[],"types":[{"html_id":"barite/Barite/AuthenticationException","path":"Barite/AuthenticationException.html","kind":"class","full_name":"Barite::AuthenticationException","name":"AuthenticationException","abstract":false,"superclass":{"html_id":"barite/Barite/Exception","kind":"class","full_name":"Barite::Exception","name":"Exception"},"ancestors":[{"html_id":"barite/Barite/Exception","kind":"class","full_name":"Barite::Exception","name":"Exception"},{"html_id":"barite/Exception","kind":"class","full_name":"Exception","name":"Exception"},{"html_id":"barite/Reference","kind":"class","full_name":"Reference","name":"Reference"},{"html_id":"barite/Object","kind":"class","full_name":"Object","name":"Object"}],"locations":[{"filename":"src/exception.cr","line_number":24,"url":"https://github.com/gundy818/barite/blob/b2aa03f8e03ec967a2fd9aa0d95f5e5ec29142b4/src/exception.cr#L24"}],"repository_name":"barite","program":false,"enum":false,"alias":false,"aliased":null,"aliased_html":null,"const":false,"constants":[],"included_modules":[],"extended_modules":[],"subclasses":[],"including_types":[],"namespace":{"html_id":"barite/Barite","kind":"module","full_name":"Barite","name":"Barite"},"doc":"Aomething went wrong with authentication.\nThe specific message will tell you more. It could be a problem with credentials, or\nan error communicating with Backblazw.","summary":"<p>Aomething went wrong with authentication.</p>","class_methods":[],"constructors":[],"instance_methods":[],"macros":[],"types":[]},{"html_id":"barite/Barite/B2","path":"Barite/B2.html","kind":"class","full_name":"Barite::B2","name":"B2","abstract":false,"superclass":{"html_id":"barite/Reference","kind":"class","full_name":"Reference","name":"Reference"},"ancestors":[{"html_id":"barite/Reference","kind":"class","full_name":"Reference","name":"Reference"},{"html_id":"barite/Object","kind":"class","full_name":"Object","name":"Object"}],"locations":[{"filename":"src/barite.cr","line_number":21,"url":"https://github.com/gundy818/barite/blob/b2aa03f8e03ec967a2fd9aa0d95f5e5ec29142b4/src/barite.cr#L21"}],"repository_name":"barite","program":false,"enum":false,"alias":false,"aliased":null,"aliased_html":null,"const":false,"constants":[],"included_modules":[],"extended_modules":[],"subclasses":[],"including_types":[],"namespace":{"html_id":"barite/Barite","kind":"module","full_name":"Barite","name":"Barite"},"doc":"The B2 class is the main API interface.\n\nThis object is lazy, in that it will only access Backblaze whien it needs to. If you\njust create the object then destroy it, no connections will be made to Backblaze.\n\nThis also means that you wont know that your authentication is correct until you\nmake an access.","summary":"<p>The B2 class is the main API interface.</p>","class_methods":[],"constructors":[{"id":"new(key_id:String,key:String)-class-method","html_id":"new(key_id:String,key:String)-class-method","name":"new","doc":"Initialise with authentication keys.\nThe key_id and key are created from your Backblaze login. Ensure that this key has\nthe capabilities that you will need. For example the ability to read and/or write\nfiles is the buckets that you'll be using.","summary":"<p>Initialise with authentication keys.</p>","abstract":false,"args":[{"name":"key_id","doc":null,"default_value":"","external_name":"key_id","restriction":"String"},{"name":"key","doc":null,"default_value":"","external_name":"key","restriction":"String"}],"args_string":"(key_id : String, key : String)","args_html":"(key_id : String, key : String)","location":{"filename":"src/barite.cr","line_number":30,"url":"https://github.com/gundy818/barite/blob/b2aa03f8e03ec967a2fd9aa0d95f5e5ec29142b4/src/barite.cr#L30"},"def":{"name":"new","args":[{"name":"key_id","doc":null,"default_value":"","external_name":"key_id","restriction":"String"},{"name":"key","doc":null,"default_value":"","external_name":"key","restriction":"String"}],"double_splat":null,"splat_index":null,"yields":null,"block_arg":null,"return_type":"","visibility":"Public","body":"_ = allocate\n_.initialize(key_id, key)\nif _.responds_to?(:finalize)\n  ::GC.add_finalizer(_)\nend\n_\n"}}],"instance_methods":[{"id":"account_id:String-instance-method","html_id":"account_id:String-instance-method","name":"account_id","doc":"Retrieve the account_id.\nCaches result on first access.","summary":"<p>Retrieve the account_id.</p>","abstract":false,"args":[],"args_string":" : String","args_html":" : String","location":{"filename":"src/barite.cr","line_number":55,"url":"https://github.com/gundy818/barite/blob/b2aa03f8e03ec967a2fd9aa0d95f5e5ec29142b4/src/barite.cr#L55"},"def":{"name":"account_id","args":[],"double_splat":null,"splat_index":null,"yields":null,"block_arg":null,"return_type":"String","visibility":"Public","body":"if @account_id.nil?\n  authorize_account()\nend\nreturn @account_id.as(String)\n"}},{"id":"api_token:String-instance-method","html_id":"api_token:String-instance-method","name":"api_token","doc":"Retrieve the API token.\nCaches the result on first access.","summary":"<p>Retrieve the API token.</p>","abstract":false,"args":[],"args_string":" : String","args_html":" : String","location":{"filename":"src/barite.cr","line_number":63,"url":"https://github.com/gundy818/barite/blob/b2aa03f8e03ec967a2fd9aa0d95f5e5ec29142b4/src/barite.cr#L63"},"def":{"name":"api_token","args":[],"double_splat":null,"splat_index":null,"yields":null,"block_arg":null,"return_type":"String","visibility":"Public","body":"if @api_token.nil?\n  authorize_account()\nend\nreturn @api_token.as(String)\n"}},{"id":"api_url:String-instance-method","html_id":"api_url:String-instance-method","name":"api_url","doc":"Retrieve the API URL.\nCaches result on first access.","summary":"<p>Retrieve the API URL.</p>","abstract":false,"args":[],"args_string":" : String","args_html":" : String","location":{"filename":"src/barite.cr","line_number":71,"url":"https://github.com/gundy818/barite/blob/b2aa03f8e03ec967a2fd9aa0d95f5e5ec29142b4/src/barite.cr#L71"},"def":{"name":"api_url","args":[],"double_splat":null,"splat_index":null,"yields":null,"block_arg":null,"return_type":"String","visibility":"Public","body":"if @api_url.nil?\n  authorize_account()\nend\nreturn @api_url.as(String)\n"}},{"id":"authorize_account-instance-method","html_id":"authorize_account-instance-method","name":"authorize_account","doc":"Access backblaze to authenticate.\nInitialises @account_id, @api_url and @api_token on success.","summary":"<p>Access backblaze to authenticate.</p>","abstract":false,"args":[],"args_string":"","args_html":"","location":{"filename":"src/barite.cr","line_number":35,"url":"https://github.com/gundy818/barite/blob/b2aa03f8e03ec967a2fd9aa0d95f5e5ec29142b4/src/barite.cr#L35"},"def":{"name":"authorize_account","args":[],"double_splat":null,"splat_index":null,"yields":null,"block_arg":null,"return_type":"","visibility":"Public","body":"begin\n  result = Crest::Request.get(\"https://api.backblazeb2.com/b2api/v2/b2_authorize_account\", user: @key_id, password: @key)\nrescue ex : Socket::Addrinfo::Error\n  raise(Barite::AuthenticationException.new(\"Error resolving name: #{ex.message}\"))\nend\ndata = JSON.parse(result.body)\n@account_id = data[\"accountId\"].to_s\n@api_url = data[\"apiUrl\"].to_s\n@api_token = data[\"authorizationToken\"].to_s\n"}},{"id":"file(bucket_name:String,file_name:String):Barite::B2File-instance-method","html_id":"file(bucket_name:String,file_name:String):Barite::B2File-instance-method","name":"file","doc":"Return a B2File object referencing the selected file in the named bucket.","summary":"<p>Return a B2File object referencing the selected file in the named bucket.</p>","abstract":false,"args":[{"name":"bucket_name","doc":null,"default_value":"","external_name":"bucket_name","restriction":"String"},{"name":"file_name","doc":null,"default_value":"","external_name":"file_name","restriction":"String"}],"args_string":"(bucket_name : String, file_name : String) : Barite::B2File","args_html":"(bucket_name : String, file_name : String) : <a href=\"../Barite/B2File.html\">Barite::B2File</a>","location":{"filename":"src/barite.cr","line_number":78,"url":"https://github.com/gundy818/barite/blob/b2aa03f8e03ec967a2fd9aa0d95f5e5ec29142b4/src/barite.cr#L78"},"def":{"name":"file","args":[{"name":"bucket_name","doc":null,"default_value":"","external_name":"bucket_name","restriction":"String"},{"name":"file_name","doc":null,"default_value":"","external_name":"file_name","restriction":"String"}],"double_splat":null,"splat_index":null,"yields":null,"block_arg":null,"return_type":"Barite::B2File","visibility":"Public","body":"return Barite::B2File.new(self, bucket_name, file_name)"}},{"id":"get_bucket_id(bucket_name)-instance-method","html_id":"get_bucket_id(bucket_name)-instance-method","name":"get_bucket_id","doc":"Retrieve the bucket ID for a bucket name.","summary":"<p>Retrieve the bucket ID for a bucket name.</p>","abstract":false,"args":[{"name":"bucket_name","doc":null,"default_value":"","external_name":"bucket_name","restriction":""}],"args_string":"(bucket_name)","args_html":"(bucket_name)","location":{"filename":"src/barite.cr","line_number":83,"url":"https://github.com/gundy818/barite/blob/b2aa03f8e03ec967a2fd9aa0d95f5e5ec29142b4/src/barite.cr#L83"},"def":{"name":"get_bucket_id","args":[{"name":"bucket_name","doc":null,"default_value":"","external_name":"bucket_name","restriction":""}],"double_splat":null,"splat_index":null,"yields":null,"block_arg":null,"return_type":"","visibility":"Public","body":"begin\n  request = Crest::Request.new(:post, \"#{api_url}/b2api/v2/b2_list_buckets\", headers: {\"Authorization\" => api_token(), \"Content-Type\" => \"application/json\"}, form: {\"accountId\" => account_id(), \"bucketName\" => bucket_name}.to_json)\n  response = request.execute\nrescue ex : Crest::BadRequest\n  raise(Barite::Exception.new(\"Error listing buckets: #{ex.response}\"))\nend\ndata = JSON.parse(response.body)\nbucket = data[\"buckets\"][0]\nreturn bucket[\"bucketId\"].to_s\n"}},{"id":"get_upload_url(bucket_id)-instance-method","html_id":"get_upload_url(bucket_id)-instance-method","name":"get_upload_url","doc":"Retrieve an upload URL for a specific bucket.\nRaises a Barite::NotFoundException on error.","summary":"<p>Retrieve an upload URL for a specific bucket.</p>","abstract":false,"args":[{"name":"bucket_id","doc":null,"default_value":"","external_name":"bucket_id","restriction":""}],"args_string":"(bucket_id)","args_html":"(bucket_id)","location":{"filename":"src/barite.cr","line_number":109,"url":"https://github.com/gundy818/barite/blob/b2aa03f8e03ec967a2fd9aa0d95f5e5ec29142b4/src/barite.cr#L109"},"def":{"name":"get_upload_url","args":[{"name":"bucket_id","doc":null,"default_value":"","external_name":"bucket_id","restriction":""}],"double_splat":null,"splat_index":null,"yields":null,"block_arg":null,"return_type":"","visibility":"Public","body":"begin\n  request = Crest::Request.new(:post, \"#{api_url}/b2api/v2/b2_get_upload_url\", headers: {\"Authorization\" => api_token(), \"Content-Type\" => \"application/json\"}, form: {\"bucketId\" => bucket_id}.to_json)\n  response = request.execute\nrescue ex : Crest::BadRequest\n  raise(Barite::NotFoundException.new(\"Error getting upload URL: #{ex.response}\"))\nend\ndata = JSON.parse(response.body)\nreturn {data[\"uploadUrl\"].to_s, data[\"authorizationToken\"].to_s}\n"}}],"macros":[],"types":[]},{"html_id":"barite/Barite/B2File","path":"Barite/B2File.html","kind":"class","full_name":"Barite::B2File","name":"B2File","abstract":false,"superclass":{"html_id":"barite/Reference","kind":"class","full_name":"Reference","name":"Reference"},"ancestors":[{"html_id":"barite/Reference","kind":"class","full_name":"Reference","name":"Reference"},{"html_id":"barite/Object","kind":"class","full_name":"Object","name":"Object"}],"locations":[{"filename":"src/barite.cr","line_number":137,"url":"https://github.com/gundy818/barite/blob/b2aa03f8e03ec967a2fd9aa0d95f5e5ec29142b4/src/barite.cr#L137"}],"repository_name":"barite","program":false,"enum":false,"alias":false,"aliased":null,"aliased_html":null,"const":false,"constants":[],"included_modules":[],"extended_modules":[],"subclasses":[],"including_types":[],"namespace":{"html_id":"barite/Barite","kind":"module","full_name":"Barite","name":"Barite"},"doc":"Represents a file in a specific bucket on Backblaze.\nThis is normally generated by calling B2#file.\nOnce you have this object you can upload and download the file using B2File#upload,\nB2File#download.","summary":"<p>Represents a file in a specific bucket on Backblaze.</p>","class_methods":[],"constructors":[{"id":"new(b2:Barite::B2,bucket_name:String,file_name:String)-class-method","html_id":"new(b2:Barite::B2,bucket_name:String,file_name:String)-class-method","name":"new","doc":"Create a reference for the named file in the named bucket.\nNote that the @max_versions parameter is not yet used. Every time you\nupload the same file name you will create a new version of the same file.\nNote that B2 filenames are strings but they can include a path, such as \"abc/def\".\nSome tools will interpret this as a file called 'def' in a folder 'abc', and it is\nOK to think of it like this, but the 'abc/' is really just part of the filename.","summary":"<p>Create a reference for the named file in the named bucket.</p>","abstract":false,"args":[{"name":"b2","doc":null,"default_value":"","external_name":"b2","restriction":"Barite::B2"},{"name":"bucket_name","doc":null,"default_value":"","external_name":"bucket_name","restriction":"String"},{"name":"file_name","doc":null,"default_value":"","external_name":"file_name","restriction":"String"}],"args_string":"(b2 : Barite::B2, bucket_name : String, file_name : String)","args_html":"(b2 : <a href=\"../Barite/B2.html\">Barite::B2</a>, bucket_name : String, file_name : String)","location":{"filename":"src/barite.cr","line_number":157,"url":"https://github.com/gundy818/barite/blob/b2aa03f8e03ec967a2fd9aa0d95f5e5ec29142b4/src/barite.cr#L157"},"def":{"name":"new","args":[{"name":"b2","doc":null,"default_value":"","external_name":"b2","restriction":"Barite::B2"},{"name":"bucket_name","doc":null,"default_value":"","external_name":"bucket_name","restriction":"String"},{"name":"file_name","doc":null,"default_value":"","external_name":"file_name","restriction":"String"}],"double_splat":null,"splat_index":null,"yields":null,"block_arg":null,"return_type":"","visibility":"Public","body":"_ = allocate\n_.initialize(b2, bucket_name, file_name)\nif _.responds_to?(:finalize)\n  ::GC.add_finalizer(_)\nend\n_\n"}}],"instance_methods":[{"id":"b2:Barite::B2-instance-method","html_id":"b2:Barite::B2-instance-method","name":"b2","doc":"The linked B2 object.","summary":"<p>The linked B2 object.</p>","abstract":false,"args":[],"args_string":" : Barite::B2","args_html":" : <a href=\"../Barite/B2.html\">Barite::B2</a>","location":{"filename":"src/barite.cr","line_number":139,"url":"https://github.com/gundy818/barite/blob/b2aa03f8e03ec967a2fd9aa0d95f5e5ec29142b4/src/barite.cr#L139"},"def":{"name":"b2","args":[],"double_splat":null,"splat_index":null,"yields":null,"block_arg":null,"return_type":"","visibility":"Public","body":"@b2"}},{"id":"bucket_id:String-instance-method","html_id":"bucket_id:String-instance-method","name":"bucket_id","doc":"Retrieve the bucket ID.\nCaches the result on first use.","summary":"<p>Retrieve the bucket ID.</p>","abstract":false,"args":[],"args_string":" : String","args_html":" : String","location":{"filename":"src/barite.cr","line_number":162,"url":"https://github.com/gundy818/barite/blob/b2aa03f8e03ec967a2fd9aa0d95f5e5ec29142b4/src/barite.cr#L162"},"def":{"name":"bucket_id","args":[],"double_splat":null,"splat_index":null,"yields":null,"block_arg":null,"return_type":"String","visibility":"Public","body":"if @bucket_id.nil?\n  @bucket_id = @b2.get_bucket_id(@bucket_name)\nend\nreturn @bucket_id.as(String)\n"}},{"id":"bucket_name:String-instance-method","html_id":"bucket_name:String-instance-method","name":"bucket_name","doc":"The bucket containing this file.","summary":"<p>The bucket containing this file.</p>","abstract":false,"args":[],"args_string":" : String","args_html":" : String","location":{"filename":"src/barite.cr","line_number":142,"url":"https://github.com/gundy818/barite/blob/b2aa03f8e03ec967a2fd9aa0d95f5e5ec29142b4/src/barite.cr#L142"},"def":{"name":"bucket_name","args":[],"double_splat":null,"splat_index":null,"yields":null,"block_arg":null,"return_type":"","visibility":"Public","body":"@bucket_name"}},{"id":"download(local_file_path:String)-instance-method","html_id":"download(local_file_path:String)-instance-method","name":"download","doc":"Downloads the referenced file to a local file.\nlocal_file_path is the pull path, including filename.\nIf the stored file has a modification time stored in a\n\"X-Bz-Info-src_last_modified_millis\" header, the timestamp will be set on the file\nafter a successful download.","summary":"<p>Downloads the referenced file to a local file.</p>","abstract":false,"args":[{"name":"local_file_path","doc":null,"default_value":"","external_name":"local_file_path","restriction":"String"}],"args_string":"(local_file_path : String)","args_html":"(local_file_path : String)","location":{"filename":"src/barite.cr","line_number":173,"url":"https://github.com/gundy818/barite/blob/b2aa03f8e03ec967a2fd9aa0d95f5e5ec29142b4/src/barite.cr#L173"},"def":{"name":"download","args":[{"name":"local_file_path","doc":null,"default_value":"","external_name":"local_file_path","restriction":"String"}],"double_splat":null,"splat_index":null,"yields":null,"block_arg":null,"return_type":"","visibility":"Public","body":"x_bz_file_name = @file_name\nresponse = Crest.get(\"#{@b2.api_url}/file/#{@bucket_name}/#{x_bz_file_name}\", headers: {\"Authorization\" => @b2.api_token})\nFile.write(local_file_path, response.body)\nbegin\n  modified_time = Time.unix_ms((response.headers[\"X-Bz-Info-src_last_modified_millis\"].as(String)).to_i64)\n  File.utime(modified_time, modified_time, local_file_path)\nrescue KeyError\nend\n"}},{"id":"file_name:String-instance-method","html_id":"file_name:String-instance-method","name":"file_name","doc":"The filename as stored in the bucket.","summary":"<p>The filename as stored in the bucket.</p>","abstract":false,"args":[],"args_string":" : String","args_html":" : String","location":{"filename":"src/barite.cr","line_number":145,"url":"https://github.com/gundy818/barite/blob/b2aa03f8e03ec967a2fd9aa0d95f5e5ec29142b4/src/barite.cr#L145"},"def":{"name":"file_name","args":[],"double_splat":null,"splat_index":null,"yields":null,"block_arg":null,"return_type":"","visibility":"Public","body":"@file_name"}},{"id":"upload(local_file_path:String)-instance-method","html_id":"upload(local_file_path:String)-instance-method","name":"upload","doc":"Upload the file from the local file path.\nThe modification time from the local file is set in the\n\"X-Bz-Info-src_last_modified_millis\" header, so it will be returned when the file\nis downloaded.","summary":"<p>Upload the file from the local file path.</p>","abstract":false,"args":[{"name":"local_file_path","doc":null,"default_value":"","external_name":"local_file_path","restriction":"String"}],"args_string":"(local_file_path : String)","args_html":"(local_file_path : String)","location":{"filename":"src/barite.cr","line_number":216,"url":"https://github.com/gundy818/barite/blob/b2aa03f8e03ec967a2fd9aa0d95f5e5ec29142b4/src/barite.cr#L216"},"def":{"name":"upload","args":[{"name":"local_file_path","doc":null,"default_value":"","external_name":"local_file_path","restriction":"String"}],"double_splat":null,"splat_index":null,"yields":null,"block_arg":null,"return_type":"","visibility":"Public","body":"x_bz_file_name = file_name\nbegin\n  content = File.read(local_file_path)\nrescue ex : File::NotFoundError\n  raise(Barite::NotFoundException.new(\"Error opening file: #{local_file_path}\"))\nend\ncontent_sha = Digest::SHA1.hexdigest(content)\ncontent_length = File.size(local_file_path)\nmodified_time = (File.info(local_file_path)).modification_time.to_unix_ms\nx_bz_server_side_encryption = \"AES256\"\nresponse = Crest.post(upload_url(), headers: {\"Authorization\" => upload_token, \"Content-Length\" => content_length.to_s, \"Content-Type\" => \"text/plain\", \"X-Bz-Content-Sha1\" => content_sha, \"X-Bz-File-Name\" => x_bz_file_name, \"X-Bz-Info-src_last_modified_millis\" => modified_time.to_s, \"X-Bz-Server-Side-Encryption\" => \"AES256\"}, form: content)\ndata = JSON.parse(response.body)\nfile_id = data[\"fileId\"].to_s\nreturn file_id\n"}},{"id":"upload_token:String-instance-method","html_id":"upload_token:String-instance-method","name":"upload_token","doc":"Retrieve the upload token for the bucket.\nCaches the result on first use.\nUpload tokens seem to be re-usable, so you only need to get it once.","summary":"<p>Retrieve the upload token for the bucket.</p>","abstract":false,"args":[],"args_string":" : String","args_html":" : String","location":{"filename":"src/barite.cr","line_number":198,"url":"https://github.com/gundy818/barite/blob/b2aa03f8e03ec967a2fd9aa0d95f5e5ec29142b4/src/barite.cr#L198"},"def":{"name":"upload_token","args":[],"double_splat":null,"splat_index":null,"yields":null,"block_arg":null,"return_type":"String","visibility":"Public","body":"if @upload_token.nil?\n  @upload_url, @upload_token = @b2.get_upload_url(bucket_id())\nend\nreturn @upload_token.as(String)\n"}},{"id":"upload_url:String-instance-method","html_id":"upload_url:String-instance-method","name":"upload_url","doc":"Retrieve the upload URL.\nCaches the result on first use.","summary":"<p>Retrieve the upload URL.</p>","abstract":false,"args":[],"args_string":" : String","args_html":" : String","location":{"filename":"src/barite.cr","line_number":206,"url":"https://github.com/gundy818/barite/blob/b2aa03f8e03ec967a2fd9aa0d95f5e5ec29142b4/src/barite.cr#L206"},"def":{"name":"upload_url","args":[],"double_splat":null,"splat_index":null,"yields":null,"block_arg":null,"return_type":"String","visibility":"Public","body":"if @upload_url.nil?\n  @upload_url, @upload_token = @b2.get_upload_url(bucket_id())\nend\nreturn @upload_url.as(String)\n"}}],"macros":[],"types":[]},{"html_id":"barite/Barite/Exception","path":"Barite/Exception.html","kind":"class","full_name":"Barite::Exception","name":"Exception","abstract":false,"superclass":{"html_id":"barite/Exception","kind":"class","full_name":"Exception","name":"Exception"},"ancestors":[{"html_id":"barite/Exception","kind":"class","full_name":"Exception","name":"Exception"},{"html_id":"barite/Reference","kind":"class","full_name":"Reference","name":"Reference"},{"html_id":"barite/Object","kind":"class","full_name":"Object","name":"Object"}],"locations":[{"filename":"src/exception.cr","line_number":18,"url":"https://github.com/gundy818/barite/blob/b2aa03f8e03ec967a2fd9aa0d95f5e5ec29142b4/src/exception.cr#L18"}],"repository_name":"barite","program":false,"enum":false,"alias":false,"aliased":null,"aliased_html":null,"const":false,"constants":[],"included_modules":[],"extended_modules":[],"subclasses":[{"html_id":"barite/Barite/AuthenticationException","kind":"class","full_name":"Barite::AuthenticationException","name":"AuthenticationException"},{"html_id":"barite/Barite/NotFoundException","kind":"class","full_name":"Barite::NotFoundException","name":"NotFoundException"}],"including_types":[],"namespace":{"html_id":"barite/Barite","kind":"module","full_name":"Barite","name":"Barite"},"doc":"Base exception.","summary":"<p>Base exception.</p>","class_methods":[],"constructors":[],"instance_methods":[],"macros":[],"types":[]},{"html_id":"barite/Barite/NotFoundException","path":"Barite/NotFoundException.html","kind":"class","full_name":"Barite::NotFoundException","name":"NotFoundException","abstract":false,"superclass":{"html_id":"barite/Barite/Exception","kind":"class","full_name":"Barite::Exception","name":"Exception"},"ancestors":[{"html_id":"barite/Barite/Exception","kind":"class","full_name":"Barite::Exception","name":"Exception"},{"html_id":"barite/Exception","kind":"class","full_name":"Exception","name":"Exception"},{"html_id":"barite/Reference","kind":"class","full_name":"Reference","name":"Reference"},{"html_id":"barite/Object","kind":"class","full_name":"Object","name":"Object"}],"locations":[{"filename":"src/exception.cr","line_number":31,"url":"https://github.com/gundy818/barite/blob/b2aa03f8e03ec967a2fd9aa0d95f5e5ec29142b4/src/exception.cr#L31"}],"repository_name":"barite","program":false,"enum":false,"alias":false,"aliased":null,"aliased_html":null,"const":false,"constants":[],"included_modules":[],"extended_modules":[],"subclasses":[],"including_types":[],"namespace":{"html_id":"barite/Barite","kind":"module","full_name":"Barite","name":"Barite"},"doc":"Something was not found.\nYou should get this if you try to retrieve or access something and there's a\nproblem. Either the resource doesn't exist, or you don't have permissions, or there\nmay have been a comms error.","summary":"<p>Something was not found.</p>","class_methods":[],"constructors":[],"instance_methods":[],"macros":[],"types":[]}]}]}})