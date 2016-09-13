module Lapidarius
  module Env
    %w[development runtime].each do |env|
      const_set(env.upcase, env)
    end

    module Affected
      attr_reader :env

      def runtime?
        @env == Env::RUNTIME
      end

      def development?
        @env == Env::DEVELOPMENT
      end
    end
  end
end
