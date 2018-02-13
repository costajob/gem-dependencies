require "helper"

describe Lapidarius::CLI do
  let(:io) { StringIO.new }
  let(:spinner) { ->(&b) { b.call } }

  it "must print nothing if no gem is specified" do
    Lapidarius::CLI.new(io: io, spinner: spinner).call
    io.string.strip.must_be_empty
  end

  it "must parse args" do
    cli = Lapidarius::CLI.new(args: %w[sinatra --version=1.4.7 --remote])
    cli.name.must_equal "sinatra"
    cli.version.must_equal "1.4.7"
    cli.remote.must_equal true
  end

  it "must print runtime dependencies" do
    Lapidarius::CLI.new(args: ["sinatra"], io: io, spinner: spinner, command: Stubs::Command).call
    io.string.must_equal "sinatra (1.4.7)\n├── rack (~> 1.5)\n├── rack-protection (~> 1.4)\n│   └── rack (>= 0)\n└── tilt (< 3, >= 1.3)\n\n3 runtime, 5 development\n"
  end

  it "must warn about missing gems" do
    Lapidarius::CLI.new(args: ["noent"], io: io, spinner: spinner, command: Stubs::Command).call
    io.string.must_equal %Q{No gems found matching noent (>= 0)\n}
  end

  it "must print the help" do
    begin
      Lapidarius::CLI.new(args: ["--help"], io: io)
    rescue SystemExit
      io.string.must_equal "Usage: lapidarius sinatra --version=1.4.7 --remote\n    -v, --version=VERSION            Specify the gem version to cut\n    -r, --remote                     Fetch gem remotely\n    -h, --help                       Prints this help\n"
    end
  end
end
