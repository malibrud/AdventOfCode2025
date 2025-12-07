package main

import "core:os"
import "core:fmt"
import "core:slice"
import "core:strings"
import "core:strconv"

main :: proc() {
    lines := read_file_line_by_line( os.args[ 1 ] )

    count := 0
    pos   := 50
    for line in lines {
	rotation, ok := strconv.parse_int( line[ 1: ] )
	if line[ 0 ] == 'L' { 
	    rotation = 100 - rotation
	}
	pos = ( pos + rotation ) % 100
	if  pos == 0 {
	    count += 1
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
