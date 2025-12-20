package main

import "core:os"
import "core:fmt"
import "core:strings"
import "core:strconv"

main :: proc() {
    lines := read_file_line_by_line( os.args[ 1 ] )
    L := len( lines )
    N := L-1
    C := len( lines[0] )
    numbers := lines[ :N ]
    ops     := lines[ N ]

    sum :i64= 0
    col := 0
    op : u8
    num_arr : [dynamic]u8
    val_arr : [dynamic]i64
    for i in 0 ..< C {
        // get the operation
        if ( col == 0 ) {
            op = ops[ i ]
            clear( &num_arr )
        }
        col += 1

        for j:= 0 ; j < N ; j+=1 {
            digit := cast(u8)numbers[ j ][ i ]
            append( &num_arr, digit )
        }

        num_str := string( num_arr[:] )
        num, success := strconv.parse_i64( strings.trim( num_str, " " ) )
        clear( &num_arr )

        if success {
            append( &val_arr, num )
        }
        
        // Check to see if we have landed on a column of spaces
        if ( !success || i == C-1 ) {
            ans := val_arr[ 0 ]
            switch op {
            case '+':
                for v in val_arr[ 1: ] do ans += v
            case '*':
                for v in val_arr[ 1: ] do ans *= v
            }
            sum += ans
            col = 0
            clear( &val_arr )
        }
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
