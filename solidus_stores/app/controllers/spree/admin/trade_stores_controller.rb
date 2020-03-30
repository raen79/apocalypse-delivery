module Spree
  module Admin
    class TradeStoresController < ResourceController
      skip_before_action :load_resource, only: :index

      def index
        @stores = ::Store.page(params[:page]).per(params[:per_page] || Spree::Config[:orders_per_page])
      end

      def new
        @store = ::Store.new
      end

      def create
        @store = ::Store.new(store_params)
        if @store.save
          flash[:success] = t('.created_successfully')
          redirect_to edit_admin_trade_store_url(@store)
        else
          flash.now[:error] = @store.errors.full_messages.join(", ")
          render :new, status: :unprocessable_entity
        end
      end

      def edit
        @store = ::Store.find(params[:id])
      end

      def update
        @store = ::Store.find(params[:id])
        if @store.update(store_params)
          flash[:success] = t('.updated')
          redirect_to edit_admin_trade_store_url(@store)
        else
          flash.now[:error] = @store.errors.full_messages.join(", ")
          render :edit, status: :unprocessable_entity
        end
      end

      private

      def model_class
        ::Store
      end

      def store_params
        params.require(:store).permit(:name, :email, :postcode, :street, :street_number, :city, :country, :phone_number, :is_hub)
      end
    end
  end
end