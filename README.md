# Twitter client using em-http and em-synchrony

Yet another Twitter client using em-http and em-synchrony

## Example

```ruby
require 'em-twitter'
EM.synchrony do
  config = {consumer_key: 'key', consumer_secret: 'secret1', access_token: 'token', access_token_secret: 'secret2'}
  client = EM::Twitter.new(config)

  client.stream(follow: '12345,12346') do |tweet|
    puts JSON.generate(tweet)
  end
end
```

## TODO

Implement the full API :)

## License

BSD
