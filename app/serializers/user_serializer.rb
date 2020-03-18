class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :email, :cash, :portfolio_cost, :portfolio_current_value

  has_many :stocks

  def portfolio_cost
    # sum up the original cost of the portfolio's stocks
    total = 0
    self.object.stocks.each do |stock|
      total += stock.price * stock.shares
    end 
    return total
  end 

  def portfolio_current_value
    # sum up value of entire portfolio
    total = 0;

    #   live server:
    #   publishable_token: 'pk_9b7b0939edbc416e8ecee6a94c193697',
    #   endpoint: 'https://cloud.iexapis.com/v1'

    client = IEX::Api::Client.new(
      publishable_token: 'Tpk_f60d00f3b3774527b14ddc2510d54b18',
      endpoint: 'https://sandbox.iexapis.com/v1'
      ) 
      
    self.object.stocks.each do |stock|
      quote = client.quote(stock.symbol)
      total += quote.latest_price * stock.shares
    end

    return total
  end


end
