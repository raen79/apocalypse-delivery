# frozen_string_literal: true

# This migration comes from spree (originally 20190220093635)

class DropSpreeStoreCreditUpdateReasons < ActiveRecord::Migration[5.1] # it handles itself the add/remove of this table and column.
  def up
    if table_exists? :spree_store_credit_update_reasons
      drop_table :spree_store_credit_update_reasons
    end

    if column_exists? :spree_store_credit_events, :update_reason_id
      remove_column :spree_store_credit_events, :update_reason_id
    end
  end
end
