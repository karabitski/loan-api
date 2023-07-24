module Loan
  class API < Grape::API
    prefix 'api'
    format :json
    mount ::Loan::Base
  end
end
