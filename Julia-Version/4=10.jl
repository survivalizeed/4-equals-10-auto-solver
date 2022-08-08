errMessage() = println("Invalid Number! Try a number between -9 and 9 incl.")
clear() = run(`cmd /c cls`)

function decide(index)
    index == 0 && return "+"
    index == 1 && return "-"
    index == 2 && return "*"
    index == 3 && return "/"
end

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
    if (indices[1] <= 4)
        tmp = nums[indices[1]]
        nums[indices[1]] = nums[indices[2]]
        nums[indices[2]] = tmp
    else
        indices[1] = 0
        indices[2] += 1
    end
    indices[1] += 1
    return nums
end


function procedure()
    global indices = [1, 1]
    origNums = zeros(Int8, 1, 4)
    for i::Int8 in 1:4
        origNums[i] = input(i)
    end
    while true
        nums = swapper(copy(origNums))
        if (isnothing(nums))
            println("Result: No solution found!")
            return;
        end
        for ac in 0:3, bc in 0:3, cc in 0:3
            expr = string(
                convert(Float64, nums[1]), " ", decide(ac), " ", convert(Float64, nums[2]), " ", decide(bc), " ",
                convert(Float64, nums[3]), " ", decide(cc), " ", convert(Float64, nums[4]))
            if (eval(Meta.parse(expr)) == 10.0)
                println("Result: ", replace(expr, ".0" => ""))
                return
            end
        end
    end
end

function main()
    while true
        procedure()
        println("Press Enter...")
        readline()
        clear()
    end
end

main()
