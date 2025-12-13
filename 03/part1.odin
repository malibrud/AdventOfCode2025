package main

import "core:os"
import "core:fmt"
import "core:slice"
import "core:strings"
import "core:strconv"

main :: proc() {
    banks := read_file_line_by_line( os.args[ 1 ] )
    sum := 0

    // Iterate through each "bank".
    for bank in banks {
        n_cells := len( bank )
        max_val := 0
        for i := 0 ; i < n_cells-1 ; i += 1 {
            tens_val :int= cast(int) bank[ i ] - '0'
            for j := i+1 ; j < n_cells ; j += 1 {
                ones_val :int= cast(int) bank[ j ] - '0'
                val := tens_val * 10 + ones_val
                max_val = max( max_val, val )
            }
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
