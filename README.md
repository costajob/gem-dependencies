## Table of Contents

* [Scope](#scope)
  * [Alternatives](#alternatives)
    * [gem dep](#gem-dep)
    * [bundle viz](#bundle-viz)
* [Usage](#usage)
  * [Include development gems](#include-development-gems)

## Scope
This gem is aimed to list in a straightforward way the dependencies tree if the specified gem.

### Alternatives
Some alternatives exists: 

#### gem dep
The standard *gem dep* command just unearth one level of dependencies, while often i neet to get the whole footprint.  

#### bundle viz
The *bundle viz* command relies on the Gemfile and the [graphviz](http://www.graphviz.org/) library to generate a visual representation of the gem inter-dependencies.  
It's a useful tool, but it's heavyweight, considering i mostly just need to count the number of dependencies.

## Usage
This gem relies on the *gem dep* command, calling it multiple times for recursiveness.
```
$ ./bin/lapidarius sinatra

sinatra (1.4.7)
-------------------------
  runtime gems (installed): 3
  development gems (found): 0

runtime gems:
-------------------------
rack (~> 1.5)

rack-protection (~> 1.4)
  rack (>= 0, runtime)

tilt (< 3, >= 1.3)


```

### Include development gems
In case you need to list also the gems dependencies for development, you have to specify a second argument:
```

sinatra (1.4.7)
-------------------------
  runtime gems (installed): 3
  development gems (found): 7

runtime gems:
-------------------------
rack (~> 1.5)
  bacon (>= 0, development)
  rake (>= 0, development)

rack-protection (~> 1.4)
  rack (>= 0, runtime)
  rack-test (>= 0, development)
  rspec (~> 2.0, development)

tilt (< 3, >= 1.3)

development gems:
-------------------------
bacon (>= 0)

rake (>= 0)
  hoe (~> 3.13, development)
  minitest (~> 5.4, development)
  rdoc (~> 4.0, development)

hoe (~> 3.13)

minitest (~> 5.4)
  hoe (~> 3.14, development)
  rdoc (~> 4.0, development)

rdoc (~> 4.0)

rack-test (>= 0)

rspec (~> 2.0)


```
Consider only the development gem installed on your system are scanned for dependencies.
