module API
  module V1
    module Defaults
      extend Grape::API::Helpers

      MSG_SUCCESS = "Success"
      MSG_ERROR = "Error"
      BASE_URL = "https://couponstudio.app"
      SIGN_IN_BONUS = "0.5"

      def self.included(base)
        base.prefix :api
        base.version :v1
        base.format :json

        base.helpers do
          params :common_params do
            requires :userId, type: String, allow_blank: false
            requires :securityToken, type: String, allow_blank: false
            requires :versionName, type: String, allow_blank: false
            requires :versionCode, type: String, allow_blank: false
          end

          def api_params
            Rails.logger.info "API Params:#{params.inspect}"
          end

          def valid_user(userId, securityToken)
            User.find_by(id: userId, security_token: securityToken)
          end
        end
      end
    end
  end
end
