## Table of Contents

* [Scope](#scope)
  * [Alternatives](#alternatives)
    * [gem dep](#gem-dep)
    * [bundle viz](#bundle-viz)
* [Usage](#usage)
  * [Runtime dependencies](#runtime-dependencies)
  * [Include development dependencies](#include-development-dependencies)

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
$ ./bin/lapidarius sinatra

sinatra (1.4.7):


runtime gems            3
-------------------------

rack (~> 1.5, runtime)

rack-protection (~> 1.4, runtime)
  rack (>= 0, runtime)

tilt (< 3, >= 1.3, runtime)

```

### Include development dependencies
In case you need to list also the gems dependencies for development, you have to specify the DEV flag (*-d*, *-dev* or *--development*)
```
$ ./bin/lapidarius sinatra --development

sinatra (1.4.7):


runtime gems            3
-------------------------

rack (~> 1.5, runtime)
  bacon (>= 0, development)
  rake (>= 0, development)

rack-protection (~> 1.4, runtime)
  rack (>= 0, runtime)
  rack-test (>= 0, development)
  rspec (~> 2.0, development)

tilt (< 3, >= 1.3, runtime)


development gems        7
-------------------------

bacon (>= 0, development)

rake (>= 0, development)
  hoe (~> 3.13, development)
  minitest (~> 5.4, development)
  rdoc (~> 4.0, development)

hoe (~> 3.13, development)

minitest (~> 5.4, development)
  hoe (~> 3.14, development)
  rdoc (~> 4.0, development)

rdoc (~> 4.0, development)

rack-test (>= 0, development)
  rack (>= 1.0, runtime)

rspec (~> 2.0, development)

```

Consider only the gems installed on your system are scanned for their own dependencies, no remote fetching is performed.
