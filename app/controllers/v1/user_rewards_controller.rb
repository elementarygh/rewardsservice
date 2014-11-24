module V1
  class UserRewardsController < ApplicationController
    before_action :authenticate, :check_user_elibility, :check_channel_params
    respond_to :json

    # GET /user_rewards/1
    def show
      channels = params[:channels].split(/,/);
      @channel_rewards = ChannelReward.reward_search(channels)
      request.format = :json
      respond_with @channel_rewards
    end

    private
    # Check is the client is using a correct token
    def authenticate
      authenticate_or_request_with_http_token do |token, options|
        authenticate_token || render_error('INVALID_AUTHENTICATION_TOKEN')
      end
    end
      
    def authenticate_token
      authenticate_with_http_token do |token, options|
        Figaro.env.client_tokens.split(',').include? token
      end
    end

    # Check if the user is eligible for any rewards.
    def check_user_elibility
      service = UserEligibility.new(params[:id])
      result = service.check_eligibility
      render_error(result) unless result == 'CUSTOMER_ELIGIBLE'
    end
  
    # Check the validity of the channels.
    def check_channel_params
      channels = params[:channels]
      if channels.empty?
        message = 'You did not specify any channels for this user.'
        render_error('NO_CHANNELS_SPECIFIED')
      end
      #TODO Should we check whether all/any of the specified channels are known 
      # to us?
    end

    def render_error(result)
      case result
      when 'CUSTOMER_INELIGIBLE'
        status = :ok
        message = '{}'
      when 'TECHNICAL_PROBLEM'
        status = :internal_server_error
        message = '{}'
      when 'INVALID_ACCOUNT_NUMBER'
        status = :unprocessable_entity
        message = '{"error":"This user account number is not recognised."}'
      when 'NO_CHANNELS_SPECIFIED'
        status = :unprocessable_entity
        message = '{"error":"No subscribed channels provided."}'
      when 'INVALID_AUTHENTICATION_TOKEN'
        status = :unauthorized
        message = '{"error":"The authentication token was not recognised."}'
      end
      if !status.blank? 
        render json: message, status: status
      end 
    end
  end
end
