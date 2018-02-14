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
This library invokes the `Gem::Commands::DependencyCommand` class recursively to collect all the levels of dependency.  
Both runtime and development dependencies are counted (identical dependencies are counted once), but just the former are printed on screen:

```shell
lapidarius sinatra
sinatra (2.0.0)
├── mustermann (~> 1.0)
├── rack (~> 2.0)
├── rack-protection (= 2.0.0)
│   └── rack (>= 0)
└── tilt (~> 2.0)

4 runtime, 4 development
```

### Version
By default this library scans for the first version `>= 0` found at [rubygems.org](https://rubygems.org/).  
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
lapidarius roda -v 3.3.0
No gems found matching roda (= 3.0.0)
```

If you want to scan for remote gems specify the `-r` option (be aware of slowness):
```shell
lapidarius roda -v 3.3.0 -r
roda (3.3.0)
└── rack (>= 0)

1 runtime, 10 development
```

### Quiet
Some gems has several interdependencies that results in a multitude of tree branches.  
In case you just dare to count dependencies without the visual noise, you can pass the `-q` option:
```shell
lapidarius rails -v 5.1.4 -r -q
37 runtime, 49 development
```
