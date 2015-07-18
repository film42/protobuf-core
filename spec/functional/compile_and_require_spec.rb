require 'spec_helper'
require 'thread'
require 'protobuf/compiler/code_generator'
require 'protobuf/compiler/protoc_channel'

RSpec.describe 'can compile and load a class' do
  before(:context) do
    proto_path = File.expand_path('../../support/test/bacon.proto', __FILE__)
    plugin_binary = File.expand_path('./bin/protoc-gen-ruby')
    ruby_path = proto_path.sub('.proto','.pb.rb')
    ::File.delete(ruby_path) if ::File.exist?(ruby_path)
    proto_load_path = File.dirname(proto_path)

    compiler = Thread.new do
      `protoc --plugin=protoc-gen-ruby=#{plugin_binary} --ruby_out=#{proto_load_path} -I #{proto_load_path} #{proto_path}`
    end

    request_bytes = ::Protobuf::Compiler::ProtocChannel.receive
    code_generator = ::Protobuf::Compiler::CodeGenerator.new(request_bytes)
    response_bytes = code_generator.response_bytes
    ::Protobuf::Compiler::ProtocChannel.send(response_bytes)

    compiler.join
    require(ruby_path)
  end

  after(:context) do
    Object.send(:remove_const, :Bacon) if defined?(Bacon)
  end

  it 'compiles a Bacon class' do
    expect(defined?(Bacon)).to eq 'constant'
  end

  it 'has getters and setters' do
    bacon = Bacon.new
    bacon.deliciousness = 10
    bacon.texture = Texture::CRUNCHY

    expect(bacon.deliciousness).to eq 10
    expect(bacon.texture).to eq Texture::CRUNCHY
  end
end
