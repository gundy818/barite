
Barite is a library to access the Backblaze B2 API.

It is far from complete, but will have functions added as I need them.
Contributions are welcome if you need a feature that isn't covered.

It currently supports enough to be able to transfer individual files to
and from B2 buckets.


## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     barite:
       github: gundy818/barite
   ```

2. Run `shards install`


## Usage

```crystal
require "barite"

# Initialise the API.
b2 = Barite::B2::API.new("my key id", "my key")

# Define a file in a specific bucket.
b2file = b2.file("bucket_name", "the/file.txt")

# Upload the file from a local copy.
b2file.upload("/path/to/local/file.txt")

# Download the file to a local copy.
b2file.download("/where/to/put/the/download/file.txt")
```

If there are exceptions, they'll probably be
'Barite::Exception' subclasses. The most likely ones are
'Barite::Exception::AuthenticationException' if there is a problem with
your key, or a 'Barite::Exception::NotFoundException' if something you
were trying to access couldn't be found. Hopefully the accompanying
message will help you understand the problem.


## Development

There are no special requirements. There are no real tests at the
moment, as I'm figuring out the best way to do this against the actual
API, or by mocking it somehow. Suggestions are welcome!

If you have 'make' available, the tests can be run locally with 'make check'.

I will be adding functionality to be able to remove files and work with
file versions, and also to set life cycle rules to automatically remove
old versions.


## Contributing

1. Fork it (<https://github.com/gundy818/barite/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request


## Contributors

- [darryl](https://github.com/gundy818) - creator and maintainer


<!--- vim: textwidth=88
 -->

