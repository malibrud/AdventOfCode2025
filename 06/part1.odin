package main

import "core:os"
import "core:fmt"
import "core:strings"
import "core:strconv"

main :: proc() {
    lines := read_file_line_by_line( os.args[ 1 ] )
    L := len( lines )
    N := L-1

    numbers : [dynamic][dynamic]int
    for &line in lines[ :N ]{
        vals : [dynamic]int
        for v in strings.fields_iterator( &line ) {
            num, _ := strconv.parse_int( v )
            append( &vals, num )
        }
        append( &numbers, vals )
    }

    ops := strings.fields( lines[ N ] )
    P := len( ops )

    sum :i64= 0
    for i in 0 ..< P {
        ans :i64= cast(i64)numbers[ 0 ][ i ]
        switch ops[ i ] {
        case "+":
            for j in 1 ..< N {
                ans += cast(i64)numbers[ j ][ i ]
            }
        case "*":
            for j in 1 ..< N {
                ans *= cast(i64)numbers[ j ][ i ]
            }
        }
        sum += ans
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
