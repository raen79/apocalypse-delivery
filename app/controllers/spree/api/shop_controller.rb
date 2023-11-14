module Spree
  module Api
    class ShopController < Spree::Api::BaseController
      before_action :find_shop, only: [:update]
      before_action :authorize_shop, only: [:update]
      def update
        validator = Spree::Api::ShopValidator.new(@shop, shop_params)
        unless validator.valid?
          return render json: { errors: validator.errors }, status: :bad_request
        end
        if Spree::Api::ShopUpdateService.new(@shop).update(shop_params)
          render json: { status: 200, shop: @shop }, status: :ok
        else
          render json: { errors: 'Internal server error' }, status: :internal_server_error
        end
      end
      private
      def find_shop
        @shop = Spree::Store.find(params[:id])
      end
      def authorize_shop
        unless Spree::Api::ShopPolicy.new(current_api_user, @shop).update?
          if current_api_user.nil?
            return render json: { errors: 'Unauthorized' }, status: :unauthorized
          else
            return render json: { errors: 'Forbidden' }, status: :forbidden
          end
        end
      end
      def shop_params
        params.require(:shop).permit(:shop_name, :shop_description)
      end
    end
  end
end
