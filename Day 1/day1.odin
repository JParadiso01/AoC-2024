package main

import "core:fmt"
import "core:os"
import "core:strings"
import "core:c/libc"
import "core:slice"


part1_read_file_by_lines_in_whole :: proc(filepath: string) -> (x, y: [1000]int) {
	data, ok := os.read_entire_file(filepath, context.allocator)
	if !ok {
		// could not read file
		return
	}
	defer delete(data, context.allocator)

	it := string(data)
    list1 : [1000]int
    list2 : [1000]int
    index := 0
	for line in strings.split_lines_iterator(&it) {
        res := strings.split(line, "   ")
        list1[index] = int(libc.atoi(strings.clone_to_cstring(res[0])))
        list2[index] = int(libc.atoi(strings.clone_to_cstring(res[1])))
        index += 1
    }
    return list1, list2
}

part1 :: proc() {
    list1 : [1000]int
    list2 : [1000]int
    filepath: string = "C:\\Users\\josep\\Documents\\Coding Projects\\AoC-2024\\Day 1\\input.txt"
    list1, list2 = part1_read_file_by_lines_in_whole(filepath)

    slice.sort(list1[:])
    slice.sort(list2[:])

    sum: int = 0
    for i in 0..<1000{
        sum += abs(list1[i] - list2[i])
    }    
    fmt.printf("Sum: %d\n", sum);
}

part2 :: proc() {
    list1 : [1000]int
    list2 : [1000]int
    filepath: string = "C:\\Users\\josep\\Documents\\Coding Projects\\AoC-2024\\Day 1\\input.txt"
    list1, list2 = part1_read_file_by_lines_in_whole(filepath)

    frequency := make(map[int]int)
    defer delete(frequency)

    for num in list1{
        frequency[num] = 0
    }

    for num in list2{
        ok := num in frequency
        if ok {
	       frequency[num] += 1
        }
    }

    sum: int = 0
    for key, value in frequency{
        sum += key * value
    }

    fmt.printf("Sum: %d", sum)

}
main :: proc() {
    fmt.print("Part 1:\n")
    part1()
    fmt.print("\nPart 2:\n")
    part2()
}