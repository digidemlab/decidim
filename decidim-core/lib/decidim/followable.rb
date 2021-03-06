# frozen_string_literal: true

module Decidim
  # This concern contains the logic related to followable resources.
  module Followable
    extend ActiveSupport::Concern

    included do
      has_many :follows,
               as: :followable,
               foreign_key: "decidim_followable_id",
               foreign_type: "decidim_followable_type",
               class_name: "Decidim::Follow",
               counter_cache: :follows_count
      has_many :followers, through: :follows, source: :user
    end

    def followers
      if respond_to?(:participatory_space) && participatory_space.present? && participatory_space.respond_to?(:followers)
        super.or(participatory_space.followers).distinct
      else
        super
      end
    end
  end
end
