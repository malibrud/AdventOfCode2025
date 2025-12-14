package main

import "core:os"
import "core:fmt"
import "core:strings"
import "core:slice"
import "core:strconv"

main :: proc() {
    lines := read_file_line_by_line( os.args[ 1 ] )
    L := len( lines )

    // Parse the input data
    line_no := 0

    ranges : [dynamic]Range
    for {
        if len( lines[ line_no ] ) == 0 do break
        bounds := strings.split( lines[ line_no ], "-")
        lb, _ := strconv.parse_i64( bounds[ 0 ] )
        ub, _ := strconv.parse_i64( bounds[ 1 ] )
        append( &ranges, Range{ lb, ub } )
        line_no += 1
    }
    R := len( ranges )
    slice.sort_by( ranges[:], range_compare_lb )

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

    fmt.println( count )
}

Range :: struct {
    lb: i64,
    ub: i64,
}

range_compare_lb :: proc( lhs, rhs : Range ) -> bool {
    return lhs.lb < rhs.lb
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
