# Constructibles

The *constructible numbers* are an extension of the rational numbers. They can be defined recursively as follows:
* Integers are constructible.
* The sum, difference, product, and quotient of constructible numbers are constructible (division by zero is forbidden).
* The square root of a nonnegative constructible number is constructible. In this implementation, all constructible numbers are real.

Constructible numbers are exactly the lengths that can be constructed using straightedge and compass (and an initial pair of points unit distance apart). 

The `ConstructibleNumbers` module provides the the `ConstructibleNumber` type for working with constructible numbers.

> We provide the abbreviation `CN` for `ConstructibleNumber` (because it's a lot to type).

## Constructible Numbers

Starting with an `Integer` or a `Rational`, we create a `ConstructibleNumber` like this:
```
julia> a = CN(5)
5

julia> b = CN(2//3)
2/3

julia> typeof(b)
ConstructibleNumber
```

The standard operations of addition, subtraction, multiplication, division, and square root can be applied to these numbers to build more elaborate constructible numbers:

```
julia> sqrt(a-b) + 5/sqrt(CN(7))
5*sqrt(7)/7 + sqrt(39)/3

julia> phi = (1+sqrt(CN(5)))/2
1/2 + sqrt(5)/2

julia> phi^2 - phi - 1
0
```

### Conversion

Use `float` or `Float64` to convert a `ConstructibleNumber` to a `Float64`:
```
julia> float(phi)
1.618033988749895
```

To render a `ConstructibleNumber` in LaTeX form use the `latex` function:
```
julia> latex(phi)
"\\frac{1}{2} + \\frac{\\sqrt{5}}{2}"

julia> println(latex(phi))
\frac{1}{2} + \frac{\sqrt{5}}{2}
```
So `phi` is $\frac{1}{2} + \frac{\sqrt{5}}{2}$.

## Constructible Geometric Objects

We define the abstract type `ConstructibleObject` (or `CO` for short) that has three subtypes:
* `ConstructiblePoint` (or `CP` for short)
* `ConstructibleCircle` (or `CC` for short)
* `ConstructibleLines` (or `CL` for short)

### Points

A *constructible point* is a point in the plane whose $x$ and $y$ coordinates are both constructible. These have type `ConstructiblePoint`, or `CP` for short.

* `CP(x,y)` creates a new point at coordinates `(x,y)`. 

The distance between points `A` and `B` is returned by `dist(A,B)`.

### Circles

A *constructible circle* is a circle in the plane whose center is a constructible point and whose radius is a constructible number. These have type `ConstructibleCircle`, or `CC` for short.

* `CC(P,r)` creates a new circle centered at the point `P` with radius `r`. An error is thrown if the radius is negative. 
* `CC(P,A)` creates a new circle centered at the point `P` that passes through the point `A`.


### Lines

A *constructible line* is a line in the plane whose equation is of the form $ax+by+c=0$ where the coefficients are constructible numbers (not all zero). 
These have type `ConstructibleLine`, or `CL` for short.

* `CL(a,b,c)` creates the line with equation $ax+by+c=0$. An error is thrown if `a`, `b`, and `c` are all zero. 
* `CL(A,B)` creates the line that includes the points `A` and `B`. An error is thrown if `A` and `B` are the same point. 

### Incidence

If `A` is a point and `X` is either a line or a circle, then `in(A,X)` (or `A ∈ X`) returns `true` if `A` lies on `X`. 

### Intersection

The intersection of two lines, two circles, or a line and a circle results in a list of constructible points. That list might have 0, 1, or 2 members.

