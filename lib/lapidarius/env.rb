module Lapidarius
  module Env
    %w[development runtime].each do |env|
      const_set(env.upcase, env)
    end
  end
end
