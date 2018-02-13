## Table of Contents

* [Scope](#scope)
  * [Alternatives](#alternatives)
    * [gem dep](#gem-dep)
    * [bundle viz](#bundle-viz)
* [Installation](#installation)
* [Usage](#usage)
    * [Version](#version)
    * [Remote](#remote)

## Scope
This gem is aimed to recursively collect the `runtime dependencies` footprint of the specified gem.  
The output of the library mimics the `tree` shell utility, highlighting the nested dependencies via ASCII characters.

### Alternatives
Some alternatives exists: 

#### gem dep
The standard *gem dep* command just unearth one level of dependencies.

#### bundle viz
The *bundle viz* command relies on the Gemfile and the [graphviz](http://www.graphviz.org/) library to generate a visual representation of the gem inter-dependencies.  
While it is great to visualize inter-dependencies, i have hard times figuring out gem's  runtime footprint.

## Installation
Install the gem from your shell:
```shell
gem install lapidarius
```

## Usage
This library invokes the `Gem::Commands::DependencyCommand` class recursively to collect all the levels of dependency.  
Both runtime and development dependencies are counted (identical dependencies are counted once).  
Just the runtime dependencies tree is printed to screen:

```shell
sinatra (1.4.7)
├── rack (~> 1.5)
├── rack-protection (~> 1.4)
│   └── rack (>= 0)
└── tilt (< 3, >= 1.3)

3 runtime, 4 development
```

### Version
By default this library scans for the first version `>= 0`.  
In case you have multiple versions of a gem installed, just specify the `-v` option:
```shell
$ lapidarius sinatra -v 2.0.0
sinatra (2.0.0)
├── mustermann (~> 1.0)
├── rack (~> 2.0)
├── rack-protection (= 2.0.0)
│   └── rack (>= 0)
└── tilt (~> 2.0)

4 runtime, 4 development
```

## Remote
By default this library scan for local gems. If you want to scan for remote ones, just
specify the `-r` option as the third argument:
```shell
$ lapidarius grape -r
```
