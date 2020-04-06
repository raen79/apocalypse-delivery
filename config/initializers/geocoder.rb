# frozen_string_literal: true

geocoder_lookup_provider = Rails.env.test? ? :test : :nominatim

Geocoder.configure(lookup: geocoder_lookup_provider)
