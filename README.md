## Table of Contents

* [Scope](#scope)
  * [Alternatives](#alternatives)
    * [gem dep](#gem-dep)
    * [bundle viz](#bundle-viz)
* [Installation](#installation)
* [Usage](#usage)
    * [Version](#version)
    * [Remote](#remote)
    * [Quiet](#quiet)

## Scope
This gem is aimed to recursively collect the `runtime dependencies` footprint of the specified gem.  
The output of the library mimics the `tree` shell utility, highlighting the nested dependencies via ASCII characters.

### Alternatives
Some alternatives exists: 

#### gem dep
The standard `gem dep` command just unearth one level of dependencies.

#### bundle viz
The `bundle viz` command relies on the Gemfile and the [graphviz](http://www.graphviz.org/) library to generate a visual representation of the gem inter-dependencies.  
While it is great to visualize inter-dependencies, i have hard times figuring out gem's  runtime footprint.

## Installation
Install the gem from your shell:
```shell
gem install lapidarius
```

## Usage
This library invokes the [Gem::Commands::DependencyCommand](https://github.com/rubygems/rubygems/blob/master/lib/rubygems/commands/dependency_command.rb) class recursively to collect all the levels of dependency.  
Both runtime and development dependencies are counted (identical dependencies are counted once), but just the former are printed on screen:

```shell
lapidarius sinatra
sinatra (2.0.0)
├── mustermann (~> 1.0)
├── rack (~> 2.0)
├── rack-protection (= 2.0.0)
│   └── rack (>= 0)
└── tilt (~> 2.0)

4 runtime, 5 development
```

### Version
By default this library scans for the latest available version `>= 0` found at [rubygems.org](https://rubygems.org/).  
In case you are interested on a specific version just specify the `-v` option:
```shell
lapidarius sinatra -v 1.4.7
sinatra (1.4.7)
├── rack (~> 1.5)
├── rack-protection (~> 1.4)
│   └── rack (>= 0)
└── tilt (< 3, >= 1.3)

3 runtime, 4 development
```

### Remote
By default this library scan for local gems, warning if the gem is not found:
```shell
lapidarius rails -v 1.2.6
No gems found matching rails (= 1.2.6)
```

If you want to scan for remote gems specify the `-r` option (be aware of slowness):
```shell
lapidarius rails -v 1.2.6 -r
rails (1.2.6)
├── actionmailer (= 1.3.6)
│   └── actionpack (= 1.13.6)
│       └── activesupport (= 1.4.4)
├── actionpack (= 1.13.6)
│   └── activesupport (= 1.4.4)
├── actionwebservice (= 1.2.6)
│   ├── actionpack (= 1.13.6)
│   │   └── activesupport (= 1.4.4)
│   └── activerecord (= 1.15.6)
│       └── activesupport (= 1.4.4)
├── activerecord (= 1.15.6)
│   └── activesupport (= 1.4.4)
├── activesupport (= 1.4.4)
└── rake (>= 0.7.2)

6 runtime, 5 development
```

### Quiet
Some gems have several interdependencies that results in a multitude of tree branches.  
In case you just dare to count dependencies without the visual noise, you can pass the `-q` option:
```shell
lapidarius rails -v 5.1.5 -r -q
37 runtime, 48 development
```
