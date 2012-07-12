class User < Sequel::Model
  def as_json
    {
      :id => self.id,
      :username => self.username,
      :email => self.email,
    }
  end
end

class Hash
  def only(*args)
    self.reject { |key, value| !args.include?(key.to_sym) }
  end
end

module BluthCompany
  class API < Grape::API
    format :json

    before do
      loggable_params = params.to_hash.reject { |k,v| k == "route_info" }
      puts "\n#{request.env["REQUEST_METHOD"]} #{request.path} at #{Time.now}"
      puts "  Authorization: #{request.env["HTTP_AUTHORIZATION"]}" if request.env["HTTP_AUTHORIZATION"]
      puts "  Parameters: #{loggable_params}" if loggable_params.any?
    end

    rescue_from NoMethodError do |e|
      rack_response(MultiJson.dump({ :errors => "Oops, something wrong happened." }))
    end

    resource :users do
      # GET /users
      get do
        User.all.map(&:as_json)
      end

      # POST /users
      post do
        User.create(params.select { |k| %w|username email|.include?(k) }).as_json
      end

      # GET /users/:id
      get ":id" do
        User[params.id].as_json
      end

      # PUT /users/:id
      put ":id" do
        User[params.id].set(params.to_hash.only(:email, :username)).save.as_json
      end

      # DELETE /users/:id
      delete ":id" do
        User[params.id].destroy and {}
      end
    end
  end
end
