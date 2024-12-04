package main

import "core:fmt"
import "core:os"
import "core:strings"
import "core:c/libc"

check_report :: proc(filepath: string) {
    safe_reports: int = 0
    res: bool = true
    inc: bool = true
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

        for i in 1..<len(levels){
            if res == false{
                continue
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

        //if safe add one to total
        if res{
            safe_reports += 1
        }

        //reset values
        res = true
        clear_dynamic_array(&levels)

    }


    fmt.printf("Number of Safe Reports: %d", safe_reports)
}


part1 :: proc(){
    filepath := "C:\\Users\\josep\\Documents\\Coding Projects\\AoC-2024\\Day 2\\input.txt"
    check_report(filepath)

}

main :: proc() {
    fmt.print("Part 1:\n")
    part1()
}