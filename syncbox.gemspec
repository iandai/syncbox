Gem::Specification.new do |s|
  s.name        = 'syncbox'
  s.version     = '0.0.1'
  s.date        = '2014-02-01'
  s.summary     = "syncbox"
  s.description = "A gem that automatically sync file to S3 or Glacier."
  s.authors     = ["Ian Dai"]
  s.email       = 'iandai.jp@gmail.com'
  s.files       = ["lib/syncbox.rb", "lib/syncbox/store.rb", "lib/syncbox/store/s3_bucket.rb", "lib/syncbox/syncer.rb"]
  s.executables << 'syncbox'
  s.homepage    =
    'http://iandai.cc'
  s.license       = 'MIT'
end