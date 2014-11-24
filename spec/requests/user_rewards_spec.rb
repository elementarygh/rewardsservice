require 'rails_helper'

RSpec.describe "UserRewards API" do
  it 'responds with rewards for known eligible user with rewards' do
    EligibilityService.stubs(:is_user_eligible?).with('4').returns('CUSTOMER_ELIGIBLE')

    get '/v1/user_rewards/4?channels=MOVIES,SPORTS', {}, {'Authorization'=> valid_token}

    expect(response.status).to eq(200)
    expect(rewards).to include('PIRATES_OF_THE_CARIBBEAN_COLLECTION')
    expect(rewards).to include('CHAMPIONS_LEAGUE_FINAL_TICKET')
  end

  it 'responds with unauthorized for known eligible user with rewards but invalid token' do
    EligibilityService.stubs(:is_user_eligible?).with('4').returns('CUSTOMER_ELIGIBLE')

    get '/v1/user_rewards/4?channels=MOVIES,SPORTS', {}, {'Authorization'=> invalid_token}

    expect(response.status).to eq(401)
    expect(json['error']).to include('The authentication token was not recognised.')
  end

  it 'responds with no invalid rewards for known eligible user with rewards' do
    EligibilityService.stubs(:is_user_eligible?).with('8').returns('CUSTOMER_ELIGIBLE')

    get '/v1/user_rewards/8?channels=MOVIES,SPORTS,KIDS,MUSIC,NEWS', {}, {'Authorization'=> valid_token}

    expect(response.status).to eq(200)
    expect(rewards).to_not include('NONE')
  end

  it 'responds with no rewards for known eligible user with no rewards' do
    EligibilityService.stubs(:is_user_eligible?).with('4').returns('CUSTOMER_ELIGIBLE')

    get '/v1/user_rewards/4?channels=KIDS', {}, {'Authorization'=> valid_token}

    expect(response.status).to eq(200)
    expect(json.count).to eq(0)
  end

  it 'responds with no rewards for known eligible user with unknown channel' do
    EligibilityService.stubs(:is_user_eligible?).with('12').returns('CUSTOMER_ELIGIBLE')

    get '/v1/user_rewards/12?channels=COMEDY', {}, {'Authorization'=> valid_token}

    expect(response.status).to eq(200)
    expect(json.count).to eq(0)
  end

  it 'responds with no rewards for known ineligible user' do
    EligibilityService.stubs(:is_user_eligible?).with('11').returns('CUSTOMER_INELIGIBLE')

    get '/v1/user_rewards/11?channels=COMEDY', {}, {'Authorization'=> valid_token}

    expect(response.status).to eq(200)
    expect(json.count).to eq(0)
  end

  it 'responds with error for unknown user' do
    EligibilityService.stubs(:is_user_eligible?).with('20').raises(EligibilityService::InvalidAccountNumberException)

    get '/v1/user_rewards/20?channels=COMEDY', {}, {'Authorization'=> valid_token}

    expect(response.status).to eq(422)
    expect(json.count).to eq(1)
    expect(json['error']).to eq('This user account number is not recognised.')
  end

  it 'responds with error when technical failure' do
    EligibilityService.stubs(:is_user_eligible?).with('22').raises(EligibilityService::TechnicalFailureException)

    get '/v1/user_rewards/22?channels=COMEDY', {}, {'Authorization'=> valid_token}

    expect(response.status).to eq(500)
    expect(json.count).to eq(0)
  end

  private

  def valid_token
    ct_array = Figaro.env.client_tokens.split(',')
    token = ct_array.blank? ? "No_valid_token_found" : ct_array[rand(0...ct_array.length)]
    "Token token=#{token}"
  end

  def invalid_token
    "Token token=some_invalid_token"
  end

  def json
    @json ||= JSON.parse(response.body)
  end

  def rewards
    @rewards ||= json.collect { |x| x["reward"] }
  end

end