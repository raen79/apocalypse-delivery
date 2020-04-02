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
        redirect_to edit_admin_trade_store_url(@store), notice: t('.created_successfully')
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

    private

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
