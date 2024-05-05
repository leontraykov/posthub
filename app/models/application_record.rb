# frozen_string_literal: true

# Base class for all models in the application. Provides shared behavior across all models.
class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
end
