module Lapidarius
  module Env
    %i[development runtime].each do |env|
      const_set(env.to_s.upcase, env)
    end
  end
end
