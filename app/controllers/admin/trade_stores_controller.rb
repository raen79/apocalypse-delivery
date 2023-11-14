# frozen_string_literal: true
module Admin
  class TradeStoresController < Spree::Admin::ResourceController
    def index
      @stores =
        ::Store.page(params[:page]).per(params[:per_page] || Spree::Config[:orders_per_page])
    end
    def new
      @store = ::Store.new
    end
    def create
      @store = ::Store.new(store_params)
      if @store.save
        redirect_to admin_trade_stores_url, notice: t('.created_successfully')
      else
        flash.now[:error] = @store.errors.full_messages.join(', ')
        render :new, status: :unprocessable_entity
      end
    end
    def edit
      @store = ::Store.find(params[:id])
    end
    def update
      @store = ::Store.find(params[:id])
      if @store.update(store_params)
        redirect_to edit_admin_trade_store_url(@store), notice: t('.updated')
      else
        flash.now[:error] = @store.errors.full_messages.join(', ')
        render :edit, status: :unprocessable_entity
      end
    end
    def update_store
      @store = ::Store.find_by(id: params[:id])
      if @store.nil?
        render json: { error: 'Store not found' }, status: :not_found
      else
        if @store.update(name: params[:name], address: params[:address])
          render json: { message: 'Store updated successfully' }, status: :ok
        else
          render json: { error: @store.errors.full_messages.join(', ') }, status: :unprocessable_entity
        end
      end
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end
    private
    def model_class
      ::Store
    end
    # rubocop:disable Metrics/MethodLength
    def store_params
      params.require(:store).permit(
        :name,
        :email,
        :postcode,
        :street,
        :street_number,
        :city,
        :country,
        :phone_number,
        :is_hub
      )
    end
    # rubocop:enable Metrics/MethodLength
  end
end
