module Protobuf
  module Rpc
    class Service
      def self.rpc(method, request_type, response_type)
        # Not implemented by protobuf-core
      end
    end

    ActiveSupport.run_load_hooks(:protobuf_rpc_service, Service)
  end
end
