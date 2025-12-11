package main

import "core:os"
import "core:fmt"
import "core:slice"
import "core:strings"
import "core:strconv"

main :: proc() {
    lines := read_file_line_by_line( os.args[ 1 ] )
    line :string= lines[ 0 ]
    fmt.println( line )
    ranges := strings.split( line, "," )

    sum :i64= 0
    for range in ranges {
        fmt.println( range )
        ends := strings.split( range, "-" )
        start, _ := strconv.parse_i64( ends[ 0 ] )
        end,   _ := strconv.parse_i64( ends[ 1 ] )

        for id := start ; id <= end ; id += 1 {
            digits := digit_count( id )
            if ( digits % 2 == 1 ) { continue; }

            base := power_10( digits/2 )
            lnum := id / base
            rnum := id % base
            if lnum == rnum {
                sum += id
            }
        }
    }
    fmt.println( sum )
}

power_10 :: proc( power: int ) -> i64 {
    switch power {
        case 1: return            10
        case 2: return           100
        case 3: return         1_000
        case 4: return        10_000
        case 5: return       100_000
        case 6: return     1_000_000
        case 7: return    10_000_000
        case 8: return   100_000_000
        case 9: return 1_000_000_000
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
