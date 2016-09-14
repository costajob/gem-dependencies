require "lapidarius/version"
require "lapidarius/cutter"
require "lapidarius/renderer"

module Lapidarius
  class CLI
    class NoGemError < ArgumentError; end

    DEV_FLAGS = %w[-d -dev --development]

    def initialize
      fetch_args
    end

    def call
      renderer.call
    end

    private def fetch_args
      @gem = ARGV.fetch(0) { fail NoGemError, "plase specify a gem name to be cut"}
      @include_dev = DEV_FLAGS.include?(ARGV[1])
    end

    private def cutter
      @cutter ||= Lapidarius::Cutter.new(gem: @gem, include_dev: @include_dev)
    end

    private def data
      @data ||= cutter.call
    end

    private def renderer
      Lapidarius::Renderer::new(data)
    end
  end
end
