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
Consider only the gems installed on your system are scanned for their own dependencies, no remote fetching is performed.

### Output
The output of the library mimics the `tree` utility to list file system nested entries.  
Although all of the nested runtime dependencies are included in the output, just the unique ones are counted:
```
$ lapidarius --gem=grape
grape (1.0.1) - 16
├── activesupport (>= 0)
│   ├── i18n (~> 0.7)
│   ├── minitest (~> 5.1)
│   ├── thread_safe (>= 0.3.4, ~> 0.3)
│   └── tzinfo (~> 1.1)
│       └── thread_safe (~> 0.1)
├── builder (>= 0)
├── mustermann-grape (~> 1.0.0)
│   └── mustermann (~> 1.0.0)
├── rack (>= 1.3.0)
├── rack-accept (>= 0)
│   └── rack (>= 0.4)
├── virtus (>= 1.0.0)
│   ├── axiom-types (~> 0.1)
│   │   ├── descendants_tracker (~> 0.0.4)
│   │   │   └── thread_safe (>= 0.3.1, ~> 0.3)
│   │   ├── ice_nine (~> 0.11.0)
│   │   └── thread_safe (>= 0.3.1, ~> 0.3)
│   ├── coercible (~> 1.0)
│   │   ├── descendants_tracker (~> 0.0.1)
│   │   │   └── thread_safe (>= 0.3.1, ~> 0.3)
│   │   └── thread_safe (>= 0.3.1, ~> 0.3)
│   ├── descendants_tracker (>= 0.0.3, ~> 0.0)
│   │   └── thread_safe (>= 0.3.1, ~> 0.3)
│   ├── equalizer (>= 0.0.9, ~> 0.0)
│   ├── ice_nine (~> 0.11.0)
│   └── thread_safe (>= 0.3.1, ~> 0.3)
├── i18n (~> 0.7)
├── minitest (~> 5.1)
├── thread_safe (>= 0.3.4, ~> 0.3)
├── tzinfo (~> 1.1)
│   └── thread_safe (~> 0.1)
├── mustermann (~> 1.0.0)
├── axiom-types (~> 0.1)
│   ├── descendants_tracker (~> 0.0.4)
│   │   └── thread_safe (>= 0.3.1, ~> 0.3)
│   ├── ice_nine (~> 0.11.0)
│   └── thread_safe (>= 0.3.1, ~> 0.3)
├── coercible (~> 1.0)
│   ├── descendants_tracker (~> 0.0.1)
│   │   └── thread_safe (>= 0.3.1, ~> 0.3)
│   └── thread_safe (>= 0.3.1, ~> 0.3)
├── descendants_tracker (>= 0.0.3, ~> 0.0)
│   └── thread_safe (>= 0.3.1, ~> 0.3)
├── equalizer (>= 0.0.9, ~> 0.0)
└── ice_nine (~> 0.11.0)
```
