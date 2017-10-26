## Table of Contents

* [Scope](#scope)
  * [Alternatives](#alternatives)
    * [gem dep](#gem-dep)
    * [bundle viz](#bundle-viz)
* [Warning](#warning)
* [Installation](#installation)
* [Usage](#usage)

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

## Warning
Consider only the gems installed on your system are scanned by the library.  
No remote fetching is performed.

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
$ lapidarius --gem=sinatra
sinatra (2.0.0)
├── mustermann (~> 1.0)
├── rack (~> 2.0)
├── rack-protection (= 2.0.0)
│   └── rack (>= 0)
└── tilt (~> 2.0)

4 runtime, 4 development
```
