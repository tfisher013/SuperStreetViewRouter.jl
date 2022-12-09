abstract type AbstractPenaltyFunction end

struct NoPenalty <: AbstractPenaltyFunction end

struct ConstantPenalty{T<:Real} <: AbstractPenaltyFunction
    penalty::T
end

struct LinearPenalty{T<:Real} <: AbstractPenaltyFunction
    penalty::T
end

struct ExponentialPenalty{T<:Real} <: AbstractPenaltyFunction
    penalty::T
    ExponentialPenalty() = new{Float64}(0.11)
end

function apply_penalty(pre_penalty_value, num_traversals, penalty_function::NoPenalty)
    return pre_penalty_value
end

function apply_penalty(pre_penalty_value, num_traversals, penalty_function::ConstantPenalty)
    if num_traversals == 0
        return pre_penalty_value
    else
        return pre_penalty_value - penalty_function.penalty
    end
end

function apply_penalty(pre_penalty_value, num_traversals, penalty_function::LinearPenalty)
    return pre_penalty_value - penalty_function.penalty * num_traversals
end

function apply_penalty(
    pre_penalty_value, num_traversals, penalty_function::ExponentialPenalty
)
    return pre_penalty_value * penalty_function.penalty^num_traversals
end
