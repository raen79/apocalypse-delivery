# frozen_string_literal: true

# This migration comes from solidus_auth (originally 20190125170630)

class AddResetPasswordTokenIndexToSpreeUsers < SolidusSupport::Migration[4.2] # still OK for Sqlite, mySQL and Postgres.
  def custom_index_name
    'index_spree_users_on_reset_password_token_solidus_auth_devise'
  end

  def default_index_exists?
    index_exists?(:spree_users, :reset_password_token)
  end

  def custom_index_exists?
    index_exists?(:spree_users, :reset_password_token, name: custom_index_name)
  end

  def up
    Spree::User.reset_column_information
    if Spree::User.column_names.include?('reset_password_token') &&
         !default_index_exists? &&
         !custom_index_exists?
      add_index :spree_users,
                :reset_password_token,
                unique: true, name: custom_index_name
    end
  end

  def down
    remove_index :spree_users, name: custom_index_name if custom_index_exists?
  end
end
