class UserEligibility
  class Result
    attr_accessor :status, :message
    def initialize
      @status = ''
      @message = ''
    end
  end

  def initialize(user_id)
    @user_id = user_id
  end

  def check_eligibility        
    begin
      result = EligibilityService.is_user_eligible?(@user_id)
    rescue EligibilityService::TechnicalFailureException
      result = 'TECHNICAL_PROBLEM'
    rescue EligibilityService::InvalidAccountNumberException
      result = 'INVALID_ACCOUNT_NUMBER'
    end
    result
  end  

end
