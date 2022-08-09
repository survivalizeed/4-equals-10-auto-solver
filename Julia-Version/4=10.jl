errMessage() = println("Invalid Number! Try a number between -9 and 9 incl.")
clear() = run(`cmd /c cls`)
decide(index) = (index == 0 && return "+"; index == 1 && return "-"; index == 2 && return "*"; index == 3 && return "/")
function input(index::Int8)
    while true
        println("Input number: ", index)
        input = readline()
        message = false
        try
            -9 <= parse(Int8, input) <= 9 && return parse(Int8, input)
        catch
            errMessage()
            message = true
        end
        !message && errMessage()
        message = false
    end
end
function swapper(nums::Matrix{Int8})
    indices[2] > 4 && return nothing
    if indices[1] <= 4
        tmp = nums[indices[1]]
        nums[indices[1]] = nums[indices[2]]
        nums[indices[2]] = tmp
    else
        indices[1] = 0
        indices[2] += 1
    end
    indices[1] += 1
    nums
end
function bracket(index, id, lb)
    if index == id && lb 
        return "("      
    end
    if index == id && !lb
        return ")"
    end
    return ""
end
function procedure()    
    global indices = [1, 1]
    resultCounter = 0
    origNums = zeros(Int8, 1, 4)
    for i::Int8 in 1:4
        origNums[i] = input(i)
    end
    while true
        nums = swapper(copy(origNums))
        if isnothing(nums)
            println("Result: No solution found!")
            return
        end
        for ac in 0:3, bc in 0:3, cc in 0:3, lb in 0:2, rb in 1:3     
            lb == 2 && (rb += 1)
            rb > 3 && (rb = 3)
            expr = string(bracket(lb, 0, true), convert(Float64, nums[1]), " ", 
            decide(ac), " ", bracket(lb, 1, true), convert(Float64, nums[2]), bracket(rb, 1, false), " ", decide(bc), " ",  bracket(lb, 2, true), 
            convert(Float64, nums[3]), bracket(rb, 2, false), " ", decide(cc), " ", convert(Float64, nums[4]), bracket(rb, 3, false))
            if eval(Meta.parse(expr)) == 10.0
                resultCounter += 1
                println("Result ", resultCounter, ": ", replace(expr, ".0" => ""))
                println("Next Solution? Y/N")
                while true
                    local input = readline()
                    if input == "y" || input == "Y" 
                        break;
                    elseif input == "n" || input "N"
                        return;
                    end
                end
            end
        end
    end
end
function main()
    while true
        procedure()
        clear()
    end
end
main()
