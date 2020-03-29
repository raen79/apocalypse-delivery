# frozen_string_literal: true

class Store < ApplicationRecord
  PERMALINK_PREFIX = 'store'
  TAXONOMY_NAME = 'Store'

  attr_writer :taxonomy, :root_taxon

  belongs_to :spree_taxon, class_name: 'Spree::Taxon', dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :email, presence: true
  validates :postcode, presence: true
  validates :street, presence: true
  validates :street_number, presence: true
  validates :city, presence: true
  validates :country, presence: true
  validates :phone_number, presence: true

  before_validation :create_taxon, on: :create
  before_commit :persist_taxon, on: :create

  before_update :update_taxon_name

  def taxonomy
    @taxonomy ||= Spree::Taxonomy.find_by(name: TAXONOMY_NAME)
  end

  def root_taxon
    @root_taxon ||= Spree::Taxon.find_by(name: TAXONOMY_NAME)
  end

  private

  def create_taxon
    self.spree_taxon = Spree::Taxon.create(name: name, taxonomy: taxonomy)
    spree_taxon.move_to_child_of(root_taxon) if spree_taxon&.valid?
  end

  def persist_taxon
    spree_taxon.parent = root_taxon
    spree_taxon.save
  end

  def update_taxon_name
    spree_taxon.update(name: name)
  end
end
