module Lapidarius
  class Tree
    CURVED = "└── "
    EMPTY = "    "
    NESTED = "├── "
    STRAIGHT = "│   "

    def initialize(gem, quiet = false)
      @gem = gem
      @quiet = quiet
      @out = []
    end

    def out
      return @out unless @out.empty?
      return count if @quiet
      @out.tap do |out|
        out << @gem
        recurse
        out << ""
        out << count
      end
    end

    def count
      "#{@gem.count} runtime, #{@gem.dev_count} development"
    end

    private def recurse(gem = @gem, prefix = "")
      last_index = gem.size - 1
      gem.each_with_index do |dep, i|
        pointer, preadd = branches(i == last_index)
        @out << "#{prefix}#{pointer}#{dep}"
        recurse(dep, "#{prefix}#{preadd}") if dep.size > 0
      end
    end
    
    private def branches(last)
      return [CURVED, EMPTY] if last
      [NESTED, STRAIGHT]
    end
  end
end
