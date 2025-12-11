package main

import "core:os"
import "core:fmt"
import "core:slice"
import "core:strings"
import "core:strconv"

main :: proc() {
    lines := read_file_line_by_line( os.args[ 1 ] )
    line :string= lines[ 0 ]
    ranges := strings.split( line, "," )

    sum :i64= 0

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
    fmt.println( sum )
}

power_10 :: proc( power: int ) -> i64 {
    switch power {
        case  1: return                10
        case  2: return               100
        case  3: return             1_000
        case  4: return            10_000
        case  5: return           100_000
        case  6: return         1_000_000
        case  7: return        10_000_000
        case  8: return       100_000_000
        case  9: return     1_000_000_000
        case 10: return    10_000_000_000
        case 11: return   100_000_000_000
        case 12: return 1_000_000_000_000
    }
    return 0
}

digit_count :: proc( num : i64 ) -> int {
    digits := 1
    for val := num ; val > 9 ; val /= 10 do digits += 1 
    return digits
}

read_file_line_by_line :: proc(filepath: string ) -> [dynamic]string {
    data, ok := os.read_entire_file(filepath, context.allocator)

    it := string(data)
    lines : [dynamic]string
    for line in strings.split_lines_iterator(&it) {
        append( &lines, line )
    }
    return lines
}
