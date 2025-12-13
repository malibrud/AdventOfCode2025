package main

import "core:os"
import "core:fmt"
import "core:slice"
import "core:strings"
import "core:strconv"

main :: proc() {
    banks := read_file_line_by_line( os.args[ 1 ] )
    sum :i64= 0

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
