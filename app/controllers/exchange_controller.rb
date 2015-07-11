## Syncs Data from Crohnology
class ExchangeController < ApplicationController
  before_action :authenticate_user!
  before_action :build_client

  def build_client
    require 'oauth2'

    client_id = "59067a20a1eb53864a7be250af7f03c7845ccf3afd24caf566bc5d09326ecdb0"
    client_secret = "e2306670d7c6b8aaf964d428161438d96d37b54f0492fe86c4b8523c4c3051de"
    @receive_auth_code_url = 'https://localhost:3001/exchange/receive_auth_code/'
    @client = OAuth2::Client.new(client_id, client_secret, :site => 'https://localhost:3000/')
  end

  def request_auth_code
    # if current_user.external_account.crohnology_auth_code
    #   show_data
    # else
    #  render html: "Click here to authorize your Cronhology Data to be used by CCFA Partners:<br/><a href='#{@client.auth_code.authorize_url(redirect_uri: @receive_auth_code_url)}'>Authorize</a>".html_safe
    # end
    redirect_to @client.auth_code.authorize_url(redirect_uri: @receive_auth_code_url)
  end

  def receive_auth_code
    token = @client.auth_code.get_token(params[:code], redirect_uri: @receive_auth_code_url)
    current_user.external_account.crohnology_token = token.to_hash
    current_user.save

    render html: "<a href='https://localhost:3001/exchange/imported'>imported</a>".html_safe

    #current_user.external_account.crohnology_auth_code = params[:code]
    #current_user.external_account.crohnology_auth_code = token.token
    #current_user.external_account.crohnology_refresh_token = token.refresh_token
    #render text: token.get('/api/syncs/stop').parsed
  end


  def imported
    begin
      @token = OAuth2::AccessToken.from_hash(@client, current_user.external_account.crohnology_token)
      @token.get('/api/syncs/go').parsed
   rescue OAuth2::Error => err
      @token.refresh!
      err.error_description
      raise
   end

    #@token = OAuth2::AccessToken.new(@client, current_user.external_account.crohnology_access_token)
    #render text: @token.get('/api/syncs/stop').parsed
  end

  # def show_data
  #   token = @client.auth_code.get_token(current_user.external_account.crohnology_auth_code, redirect_uri: @receive_auth_code_url)
  #   token.get('/api/users').parsed
  #   render text: "Congratulations! We've successfully received your Crohnology Data:\n#{token.get('/api/syncs').parsed}"
  # end


  # def receive_access_token
  #   token = params[:token]
  #   token = client.auth_code.get_token(auth_code, :redirect_uri => 'http://localhost:8080/oauth2/callback')

  #   render text: auth_code
  # end

  # http://www.railway.at/2013/02/12/using-ssl-in-your-local-rails-environment/

end