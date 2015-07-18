module Protobuf
  module Compiler
    class ProtocChannel
      FIFO_QUEUE = '/tmp/protobuf_compiler_protoc_channel.fifo'

      def self.ensure_setup!
        unless ::File.exist?(FIFO_QUEUE)
          # TODO: Get a more native system call in place
          # NOTE: https://github.com/shurizzle/ruby-fifo/blob/master/Gemfile
          `mkfifo #{FIFO_QUEUE}`
        end
      end

      def self.receive
        ensure_setup!
        ::File.read(FIFO_QUEUE)
      end

      def self.send(data)
        ensure_setup!
        ::File.write(FIFO_QUEUE, data)
      end
    end
  end
end
