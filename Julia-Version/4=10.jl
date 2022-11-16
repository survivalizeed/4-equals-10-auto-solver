errMessage() = println("Invalid Number! Try a number between -9 and 9 incl.")
clear() = run(`cmd /c cls`)
function decide(index) 
    c = 0
    # if a symbol is excluded, find one that isn't
    while c < 4
        if index == 0 
            if exclude["+"]
                index += 1
                c += 1
            else break end
        end
        if index == 1 
            if exclude["-"]
                index += 1
                c += 1
            else break end
        end
        if index == 2 
            if exclude["*"]
                index += 1
                c += 1
            else break end
        end
        if index == 3
            if exclude["/"]
                index += 1
                c += 1
            else break end
        end
    end
    c == 4 && (println("Too much symbols excluded"); exit();)
    (index == 0 && return "+"; index == 1 && return "-"; index == 2 && return "*"; index == 3 && return "/")
end

function input(index::Int8)
    while true
        println("Input number: ", index)
        input = readline()
        # message variable to prevent double error message
        message = false
        try
            -9 <= parse(Int8, input) <= 9 && return parse(Int8, input)
        catch
            errMessage()
            message = true
        end
        # valid runtime but number is out of range 
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
    return nums
end
function bracket(index, id, lb)
    exclude["b"] && return ""
    if index == id && lb 
        return "("      
    end
    if index == id && !lb
        return ")"
    end
    return ""
end
function procedure()   
    # indices to identify current swap state of the input numbers
    global indices = [1, 1]
    resultCounter = 0
    origNums = zeros(Int8, 1, 4)
    for i::Int8 in 1:4
        origNums[i] = input(i)
    end
    println("Excluded symbols: b = bracket | + = + | - = - | * = * | / = /\nExample: b+-")
    excludeStr = readline()
    # dict which contains if a certain symbol is excluded
    global exclude = Dict("b" => occursin("b", excludeStr), "+" => occursin("+", excludeStr), "-" => occursin("-", excludeStr), 
        "*" => occursin("*", excludeStr), "/" => occursin("/", excludeStr))
    while true
        nums = swapper(copy(origNums))
        if isnothing(nums)
            println("Result: No solution found!")
            sleep(3)
            return
        end
        for ac in 0:3, bc in 0:3, cc in 0:3, lb in 0:2, rb in 1:3     
            lb == 2 && (rb += 1)    # lb == left bracket
            rb > 3 && (rb = 3)      # rb == right bracket 
            expr = string(bracket(lb, 0, true), convert(Float64, nums[1]), " ", 
            decide(ac), " ", bracket(lb, 1, true), convert(Float64, nums[2]), bracket(rb, 1, false), " ", decide(bc), " ",  bracket(lb, 2, true), 
            convert(Float64, nums[3]), bracket(rb, 2, false), " ", decide(cc), " ", convert(Float64, nums[4]), bracket(rb, 3, false))
            if eval(Meta.parse(expr)) == 10.0
                resultCounter += 1
                println("Result ", resultCounter, ": ", replace(expr, ".0" => ""))
                println("Next Solution? Y/N (Brute Forced)")
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
