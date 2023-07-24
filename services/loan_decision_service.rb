class LoanDecisionService
  MIN_AMOUNT = 2_000
  MAX_AMOUNT = 10_000
  MIN_PERIOD = 12
  MAX_PERIOD = 60
  attr_accessor :amount, :period

  def initialize(amount, period)
    @amount = amount
    @period = period
  end

  def self.call(amount, period)
    raise RangeError, 'Amount out of range' unless (MIN_AMOUNT..MAX_AMOUNT).include?(amount)
    raise RangeError, 'Period out of range' unless (MIN_PERIOD..MAX_PERIOD).include?(period)

    new(amount, period).calculate
  end

  def calculate
    return { decision: 'rejected' } if credit_score.zero?

    new_amount = [amount * credit_score, MAX_AMOUNT].min
    return { decision: 'accepted', period: period, amount: new_amount.to_i } if credit_score >= 1 || new_amount > MIN_AMOUNT

    # if new lower amount is out of range, calculate new period
    new_period = period / credit_score
    if new_period > MAX_PERIOD
      { decision: 'rejected' }
    else
      { decision: 'accepted', period: new_period, amount: amount }
    end
  end

  private

  def credit_score
    @credit_score ||= @period * credit_modifier.to_f / @amount
  end

  def personal_code
    %w[49002010965 49002010976 49002010987 49002010998][rand 0..3]
  end

  def credit_modifier
    case personal_code
    when '49002010976' then 100
    when '49002010987' then 300
    when '49002010998' then 1000
    else 0
    end
  end
end

class RangeError < StandardError; end

LoanDecisionService.call(2000, 24)



# def calcuate1
#     return { decision: 'rejected' } if credit_score.zero?

#     new_amount = amount * credit_score
#     if credit_score < 1
#       if new_amount < MIN_AMOUNT          # if new lower amount is out of range, calculate new period
#         new_period = period / credit_score
#         if new_period > MAX_PERIOD
#           { decision: 'rejected' }
#         else
#           { decision: 'accepted', period: new_period, amount: amount }
#         end
#       else
#         { decision: 'accepted', period: period, amount: new_amount }
#       end
#     else # find larger amount
#       { decision: 'accepted', period: period, amount: new_amount }
#     end
#   end
