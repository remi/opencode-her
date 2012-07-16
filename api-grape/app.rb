module BluthCompany
  class API < Grape::API
    format :json

    # Filters and helpers
    # -------------------------------------------------------------
    before do
      logger = Logger.new(STDOUT)
      logger.formatter = lambda { |severity, datetime, progname, msg| "#{msg}\n" }
      loggable_params = params.to_hash.not(:route_info)

      logger.info "\n#{request.env["REQUEST_METHOD"]} #{request.path} at #{Time.now}"
      logger.info "  Authorization: #{request.env["HTTP_AUTHORIZATION"]}" if request.env["HTTP_AUTHORIZATION"]
      logger.info "  Parameters: #{loggable_params}" if loggable_params.any?
    end

    rescue_from NoMethodError do |e|
      rack_response MultiJson.dump(:errors => ["Oops, something wrong happened."], :exception => e)
    end

    helpers do
      def render(object, template)
        Rabl.render(object, template, :view_path => 'views', :format => :json)
      end
    end

    # Users
    # -------------------------------------------------------------
    resource :users do
      # GET /users
      get do
        render User.all, "user"
      end

      # GET /users/popular
      get "popular" do
        render User.all, "user"
      end

      # POST /users
      post do
        @user = User.create(params.to_hash.only(:email, :username, :organization_id))
        render @user, "user"
      end

      # GET /users/:id
      get ":id" do
        render User[params.id], "user"
      end

      # PUT /users/:id
      put ":id" do
        @user = User[params.id].set(params.to_hash.only(:email, :username, :organization_id)).save
        render @user, "user"
      end

      # DELETE /users/:id
      delete ":id" do
        User[params.id].destroy and {}
      end
    end

    # Organizations
    # -------------------------------------------------------------
    resource :organizations do
      # GET /organizations/:id
      get ":id" do
        render Organization[params.id], "organization"
      end

      # POST /organizations
      post do
        @org = Organization.create(params.to_hash.only(:name))
        render :org, "organization"
      end
    end

    # 404 error handling
    # -------------------------------------------------------------
    get('/(*:url)', :anchor => false) { status 404; { :errors => ["Not found"] } }
    post('/(*:url)', :anchor => false) { status 404; { :errors => ["Not found"] } }
    put('/(*:url)', :anchor => false) { status 404; { :errors => ["Not found"] } }
    delete('/(*:url)', :anchor => false) { status 404; { :errors => ["Not found"] } }
  end
end
