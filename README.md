## Table of Contents

* [Scope](#scope)
  * [Alternatives](#alternatives)
    * [gem dep](#gem-dep)
    * [bundle viz](#bundle-viz)
* [Usage](#usage)
  * [First level dependencies](#first-level-dependencies)
  * [Recursive print](#recursive-print)

## Scope
This gem is aimed to list recursively the **runtime dependencies** footprint of the specified gem.

### Alternatives
Some alternatives exists: 

#### gem dep
The standard *gem dep* command just unearth one level of dependencies.

#### bundle viz
The *bundle viz* command relies on the Gemfile and the [graphviz](http://www.graphviz.org/) library to generate a visual representation of the gem inter-dependencies.  
I found difficult to count the number of unique dependencies.

## Usage
This gem relies on the *Gem::Commands::DependencyCommand* class, invoking it recursively to deeply fetch dependencies.

### First level dependencies
Just specify the name of the gem you want to scan:
```
$ ./bin/lapidarius --gem=sinatra

sinatra (1.4.7)         3
-------------------------
rack (~> 1.5)
rack-protection (~> 1.4)
tilt (< 3, >= 1.3)

```

### Recursive print
To print the gem runtime dependencies recursively, provide a flag:
```
$ ./bin/lapidarius --gem=sinatra --recursive

sinatra (1.4.7)         3
-------------------------
rack (~> 1.5)
rack-protection (~> 1.4)
  rack (>= 0)
tilt (< 3, >= 1.3)

```

Consider only the gems installed on your system are scanned for their own dependencies, no remote fetching is performed.
