require 'loan_decision_service'

module Loan
  class Base < Grape::API
    format :json
    params do
      requires :amount, type: Integer, values: 2_000..10_000
      requires :period, type: Integer, values: 12..60
    end
    post '/calculate' do
      LoanDecisionService.call(params[:amount], params[:period])
    end
  end
end
