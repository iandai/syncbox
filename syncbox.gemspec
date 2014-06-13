Gem::Specification.new do |s|
  s.name        = 'syncbox'
  s.version     = '0.0.1'
  s.date        = '2014-02-01'
  s.summary     = "syncbox"
  s.description = "A gem that automatically sync files to S3."
  s.authors     = ["Ian Dai"]
  s.email       = 'iandaicsu@gmail.com'
  s.files       = ["lib/syncbox.rb", "lib/synctool.rb", "lib/cli.rb", "lib/syncbox/store.rb", "lib/syncbox/store/s3_bucket.rb", "lib/syncbox/syncer.rb"]
  s.executables << 'syncbox'
  s.homepage    =
    'http://iandai.cc'
  s.license       = 'MIT'
end