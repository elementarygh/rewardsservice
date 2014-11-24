class EligibilityService  
  class TechnicalFailureException < StandardError; end
  class InvalidAccountNumberException < StandardError; end

  def self.is_user_eligible?(user_id)        
    Rails.logger.debug "Checking eligibility for #{user_id}"
    result = user_id.to_i % 4
    case result
    when 0
      result = 'CUSTOMER_ELIGIBLE'
    when 1
      result = 'CUSTOMER_INELIGIBLE'
    when 2
      raise TechnicalFailureException
    when 3
      raise InvalidAccountNumberException
    else
      raise TechnicalFailureException
    end
    result
  end  

end
