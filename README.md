## Table of Contents

* [Scope](#scope)
  * [Alternatives](#alternatives)
    * [gem dep](#gem-dep)
    * [bundle viz](#bundle-viz)
* [Usage](#usage)
  * [Runtime dependencies](#runtime-dependencies)
  * [Include development dependencies](#include-development-dependencies)
  * [Recursive print](#recursive-print)

## Scope
This gem is aimed to list in a straightforward way the dependencies tree if the specified gem.

### Alternatives
Some alternatives exists: 

#### gem dep
The standard *gem dep* command just unearth one level of dependencies.

#### bundle viz
The *bundle viz* command relies on the Gemfile and the [graphviz](http://www.graphviz.org/) library to generate a visual representation of the gem inter-dependencies.  
I found difficult to count the number of unique dependencies.

## Usage
This gem relies on the *Gem::Commands::DependencyCommand* class, invoking it multiple times to deeply fetch dependencies.

### Runtime dependencies
Just specify the name of the gem you want to scan:
```
$ ./bin/lapidarius --gem=sinatra

sinatra (1.4.7):

runtime gems                      3
-----------------------------------
rack (~> 1.5, runtime)
rack-protection (~> 1.4, runtime)
tilt (< 3, >= 1.3, runtime)

```

### Include development dependencies
In case you need to list also the gems dependencies for development, you have to specify the DEV flag:
```
```

### Recursive print
To print the gem dependencies recursively, privide the RECURSIVE flag:
```
```

Consider only the gems installed on your system are scanned for their own dependencies, no remote fetching is performed.
