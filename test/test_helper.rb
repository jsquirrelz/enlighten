require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/mock'
require_relative '../lib/enlighten'
FIXTURE_DIR = File.expand_path('../fixtures', __FILE__).freeze

def load_fixture(method_name)
  File.read(FIXTURE_DIR + '/' + method_name.to_s + '.json')
end
