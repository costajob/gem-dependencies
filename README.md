## Table of Contents

* [Scope](#scope)
  * [Alternatives](#alternatives)

## Scope
This gem is aimed to list in a straightforward way the dependencies tree if the specified gem.

### Alternatives
Some alternatives exists, such as the standard *gem dep* tool and the more sophisticated *bundle viz* one.  
The problem with *gem dep* is that it only provides one level of dependencies depth.  
I found *bundle viz* too heavyweight, depending on the [graphviz](http://www.graphviz.org/) library, and sometimes i just need to count the number of dependencies instead of having a bold graphical representation.

