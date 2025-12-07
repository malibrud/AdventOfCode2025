# Advent of Code 2025

## Day 01

Implemented the solution in [Odin](https://odin-lang.org/).  Given that
the provlem invited solutions with modular arithmetic, part 2 took advantage
of the modular floor operator `%%`.  Below is a snippet as to how it
was used in the solution:

```odin
    for line in lines {
	rotation, ok := strconv.parse_int( line[ 1: ] )
	turns := rotation / 100
	count += turns
	rotation %= 100

	if line[ 0 ] == 'L' { 
	    rotation = -rotation
	}
	newpos := pos + rotation

	if pos != 0 && newpos < 0 {
	    count += 1
	} else
	if pos != 0 && newpos > 100 {
	    count += 1
	}

	pos = newpos %% 100

	if  pos == 0 {
	    count += 1
	}
    } 
```

Since the `%%` always returns non-negative values for a positive divisor,
I didn't have to do the calculation with the operator in C the based laguages,
which would be:

```c
	pos = ( newpos + 100 ) % 100;
```
