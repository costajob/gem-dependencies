## Table of Contents

* [Scope](#scope)
  * [Alternatives](#alternatives)
    * [gem dep](#gem-dep)
    * [bundle viz](#bundle-viz)
* [Usage](#usage)
  * [Warning](#warning)
  * [Output](#output)

## Scope
This gem is aimed to list recursively the **runtime dependencies** footprint of the specified gem.

### Alternatives
Some alternatives exists: 

#### gem dep
The standard *gem dep* command just unearth one level of dependencies.

#### bundle viz
The *bundle viz* command relies on the Gemfile and the [graphviz](http://www.graphviz.org/) library to generate a visual representation of the gem inter-dependencies.  
While it is great to visualize inter-dependencies, i have hard times figuring out gem's  runtime footprint.

## Usage
The library relies on the *Gem::Commands::DependencyCommand* class (the one invoked by the *gem dep* command line), invoking it recursively to deeply fetch dependencies.

### Warning
Consider only the gems installed on your system are scanned.  
No remote fetching is performed.

### Output
The output of the library mimics the `tree` shell utility that lists file system nested entries.  
Although all of the nested runtime dependencies are included in the output, just the unique ones are counted:
```
$ lapidarius --gem=sinatra
sinatra (2.0.0)
├── mustermann (~> 1.0)
├── rack (~> 2.0)
├── rack-protection (= 2.0.0)
│   └── rack (>= 0)
└── tilt (~> 2.0)

4 runtime dependencies
```
