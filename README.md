 Advent of Code 2025

## [Day 01](https://adventofcode.com/2025/day/1) [Solutions](01/)

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

## [Day 02](https://adventofcode.com/2025/day/2) [Solutions](02/)

Problem required chopping up a decimal number into even groups of digits.
For part 1 this was always two groups, a high order group and a low order group.
Part 2 extended this idea into any evenly divided number of digits.  This forced
the solution to reduce the number into different bases which are factors of 10, 
i.e. 10, 100, 1000, 10000, etc.  

In this solution I found use for the `&&=` operator in Odin which is useful for accumulating
logical values and is not available in C/C++.

The solution for part 2 is below:

```odin
    // Iterate through each range.
    for range in ranges {
        ends := strings.split( range, "-" )
        start, _ := strconv.parse_i64( ends[ 0 ] )
        end,   _ := strconv.parse_i64( ends[ 1 ] )

        // Iterate though all values in a range.
        for id := start ; id <= end ; id += 1 {
            digits := digit_count( id )

            // Try to divide the number of digits into even groups
            // by finding whole divisors of the digit count
            // e.g. a number with 6 digits can be broken into
            //    1-digit numbers, e.g. 111111
            //    2 digit numbers, e.g. 121212
            //    3-digit numbers, e.g. 123123
            for factor := 1 ; factor <= digits/2 ; factor += 1 {
                if ( digits % factor != 0 ) { continue }

                // The base by which to chop up the number
                //    1-digit -> base: 10
                //    2-digit -> base: 100
                base := power_10( factor )

                // The lower repeated value that each group should equal
                repeated_val := id % base

                unit :i64= 1
                all_groups_equal := true
                // Loop through the groups
                for i :=0 ; i < digits/factor ; i += 1 {
                    num :i64= ( id / unit ) % base
                    unit *= base
                    all_groups_equal &&= num == repeated_val
                }
                if all_groups_equal {
                    //fmt.printf( "Invalid id = %d\n", id )
                    sum += id
                    break
                }
            }
        }
    }

```

## [Day 03](https://adventofcode.com/2025/day/3) [Solutions](03/)

Problem was to find the maximum number (2 digit or 12 digit) from 
the ordered permutations of the digits of a string (i.e. bank).
Brute force worked well enough for part 1, but part 2 required 
another approach to avoid 12 nested loops.

The chosen approach was to search from left to right starting
with the most significant digit and to find the index of the
left most maximum value what was right of the next higher order
digit.... leaving enough room for the higher order and lower order
digits.  The code that I used to solve this only required 12 scans
over the string, one for each digit.  The essentials are below.

```odin
    // Iterate through each "bank".
    for bank in banks {
        n_cells := len( bank )

        NDIG :: 12
        max_idxs : [NDIG]int
        pos := 0

        // Iterate through each place starting with the most significant digit 
        // and scan from left to right for the max value.
        for d := 0 ; d < NDIG ; d += 1 {
            max_idxs[ d ] = pos 
            for i := pos ; i < n_cells - ( NDIG - d - 1 ) ; i += 1 {
                if bank[ i ] > bank[ max_idxs[ d ] ] {
                    max_idxs[ d ] = i
                }
                if bank[ max_idxs[ d ] ] == '9' {
                    break
                }
            }
            pos = max_idxs[ d ] + 1
        }

        max_val :i64= 0
        for d := 0 ; d < NDIG ; d += 1 {
            digit := cast(i64) ( bank[ max_idxs[ d ] ] - '0')
            max_val = 10*max_val + digit
        }
        
        sum += max_val
    }
    fmt.println( sum )
```

## [Day 04](https://adventofcode.com/2025/day/4) [Solutions](04/)

This was a traditional _game of life_ style problem.  The second part required that
I change my file read function to return a 2-D array of runes instead of an array of 
strings.  This was necessary because I needed to keep track of which rolls were 
removed.  The new file read funcion looks like the following:

```odin
read_file_line_by_line :: proc(filepath: string ) -> [dynamic]string {
    data, ok := os.read_entire_file(filepath, context.allocator)

    it := string(data)
    lines : [dynamic]string
    for line in strings.split_lines_iterator(&it) {
        append( &lines, line )
    }
    return lines
}
```

Furthermore, I started writing index based for loops in the odin way.  i.e. 

```odin
for r in 0 ..< R {
    // body
}

for dr in -1 ..= +1 {
    // body
}
}

```

Finally, I used the `do` for single line conditions after an if...

```odin
if grid[ r ][ c ] != '@' do continue
```

## [Day 05](https://adventofcode.com/2025/day/5) [Solutions](05/)

This challenge was to work with ranges of numbers.  Part 1 was pretty
straight forward, part 2 required reducing the ranges to mutually
exclusive ranges.  The heart of the algorithm in part two is as follows:

```odin
    for i in 0 ..< R {
        for j in i+1 ..< R {
            ra := &ranges[ i ]
            rb := &ranges[ j ]

            if ra.ub < rb.lb do continue // Ranges don't overlap
            if ra.lb == -1 do continue // Range has been eliminated

            if ra.ub < rb.ub { // Back of a overlaps with front of b
                rb.lb = ra.ub + 1
            }
            else { // Range b is entirely inside of a
                rb.lb = -1
                rb.ub = -1
            }
        }
    }

    count :i64= 0
    for &r in ranges {
        if r.lb == -1 do continue
        count += r.ub - r.lb + 1
    }
```

This was the first chance I had to work with Odin's approach to collections
in that the result required that I sort the ranges.  It follows C's
approach in that a collection and a comparison function is passed to 
a sort algorithm.  i.e. 

```odin
Range :: struct {
    lb: i64,
    ub: i64,
}

range_compare_lb :: proc( lhs, rhs : Range ) -> bool {
    return lhs.lb < rhs.lb
}

ranges : [dynamic]Range

slice.sort_by( ranges[:], range_compare_lb )
```

Second this is that I began working with items by reference.  In my
loops I obtained the range by reference rather than by copy so that I
could edit them to assure the mutual exclusivity of the ranges.
