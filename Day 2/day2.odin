package main

import "core:fmt"
import "core:os"
import "core:strings"
import "core:c/libc"
import "core:mem"

check_report_part1 :: proc(filepath: string) {
    safe_reports: int = 0
    levels : [dynamic]int
    defer delete(levels)

    data, ok := os.read_entire_file(filepath, context.allocator)
	if !ok {
		// could not read file
		return 
	}
	defer delete(data, context.allocator)

	it := string(data)

    for report in strings.split_lines_iterator(&it){

        //gets each level into a dynamic array
        level := strings.split(report, " ")
        for l in level{
            append(&levels, int(libc.atoi(strings.clone_to_cstring(l))))
        }
        //if safe add one to total
        if check_if_safe(levels){
            safe_reports += 1
        }

        //reset values
        clear_dynamic_array(&levels)

    }


    fmt.printf("Number of Safe Reports: %d", safe_reports)
}


part1 :: proc(){
    filepath := "C:\\Users\\josep\\Documents\\Coding Projects\\AoC-2024\\Day 2\\input.txt"
    check_report_part1(filepath)
}



check_if_safe :: proc(levels: [dynamic]int) -> bool {
    res: bool = true
    inc: bool = true
    for i in 1..<len(levels){
        if res == false{
            return res
        }

        prev := levels[i-1]
        new  := levels[i]

        //gets if its increasing or decreasing
        if i == 1{
            if prev < new && new - prev <= 3{
                inc = true
            }
            else if prev > new && prev - new <= 3{
                inc = false
            }
            else{
                res = false
            }
        }
        else{
            //checks if still increasing or decreasing and within range
            if inc {
                if prev < new && new - prev <= 3{
                    continue
                }
                else {
                    res = false
                }
            }
            else{
                if prev > new && prev - new <= 3{
                    continue
                }
                else{
                    res = false
                }
            }
        }
    }
    return res
}

check_report_part2 :: proc(filepath: string) {
    safe_reports: int = 0
    levels : [dynamic]int
    defer delete(levels)

    data, ok := os.read_entire_file(filepath, context.allocator)
	if !ok {
		// could not read file
		return 
	}
	defer delete(data, context.allocator)

	it := string(data)

    for report in strings.split_lines_iterator(&it){

        //gets each level into a dynamic array
        level := strings.split(report, " ")
        for l in level{
            append(&levels, int(libc.atoi(strings.clone_to_cstring(l))))
        }

        if check_if_safe(levels){
            safe_reports += 1
        }
        else{
            dyn := make([dynamic]int, len(levels), cap(levels))
            defer delete(dyn)
            //go 1 by 1 and remove an element
            for i in 0..<len(levels){
                copy(dyn[:], levels[:])
                ordered_remove(&dyn, i)
                //fmt.print("Dyn: ", dyn, "Levels: ", levels, "\n")
                if check_if_safe(dyn){
                    safe_reports += 1
                    clear_dynamic_array(&dyn)
                    break
                }
                //resize to be able to copy full report
                resize(&dyn,len(levels))
            }
            clear_dynamic_array(&dyn)
        }
        //reset values
        clear_dynamic_array(&levels)
    }
    fmt.printf("Number of Safe Reports: %d", safe_reports)
 }


part2 :: proc(){
    filepath := "C:\\Users\\josep\\Documents\\Coding Projects\\AoC-2024\\Day 2\\input.txt"
    check_report_part2(filepath)
}

main :: proc() {
    fmt.print("Part 1:\n")
    part1()
    fmt.print("\nPart 2:\n")
    part2()
}