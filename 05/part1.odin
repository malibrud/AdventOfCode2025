package main

import "core:os"
import "core:fmt"
import "core:strings"
import "core:strconv"

main :: proc() {
    lines := read_file_line_by_line( os.args[ 1 ] )
    L := len( lines )

    // Parse the input data
    line_no := 0

    Range :: struct {
        lb: i64,
        ub: i64,
    }

    ranges : [dynamic]Range
    for {
        if len( lines[ line_no ] ) == 0 do break
        bounds := strings.split( lines[ line_no ], "-")
        lb, _ := strconv.parse_i64( bounds[ 0 ] )
        ub, _ := strconv.parse_i64( bounds[ 1 ] )
        append( &ranges, Range{ lb, ub } )
        line_no += 1
    }
    line_no += 1

    vals : [dynamic]i64
    for i in line_no ..< L {
        val, _ := strconv.parse_i64( lines[ i ] )
        append( &vals, val )
    }

    // Count the number of ingredients which are fresh
    count := 0
    for v in vals {
        for r in ranges {
            if v >= r.lb && v <= r.ub {
                count += 1
                break
            }
        }
    }
    fmt.println( count )
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
