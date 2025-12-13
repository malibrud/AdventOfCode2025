package main

import "core:os"
import "core:fmt"
import "core:strings"
import "core:strconv"
import "core:unicode/utf8"

main :: proc() {
    grid := read_file_line_by_line( os.args[ 1 ] )
    R := len( grid )
    C := len( grid[ 0 ] )

    // Iterate through each "bank".

    count := 0
    for {
        n_removed := 0
        for r in 0 ..< R {
        for c in 0 ..< C {
            sum := 0
            if grid[ r ][ c ] != '@' do continue
            for dr in -1 ..= +1 {
            for dc in -1 ..= +1 {
                if dr == 0 && dc == 0 do continue
                ir := r + dr
                ic := c + dc
                if ir < 0 || ir >= R do continue
                if ic < 0 || ic >= C do continue
                if grid[ ir ][ ic ] == '@' do sum += 1
            }}
            if sum < 4 {
                grid[ r ][ c ] = 'x'
                n_removed += 1
            }
        }}
        if n_removed == 0 do break
        count += n_removed
    }
    fmt.println( count )
}

read_file_line_by_line :: proc(filepath: string ) -> [dynamic][]rune {
    data, ok := os.read_entire_file(filepath, context.allocator)

    it := string(data)
    lines : [dynamic][]rune
    for line in strings.split_lines_iterator(&it) {
        append( &lines, utf8.string_to_runes( line ) )
    }
    return lines
}
