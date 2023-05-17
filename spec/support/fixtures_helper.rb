# frozen_string_literal: true

module FixturesHelper
  def fixtures_path(file_name)
    File.join("spec", "studio", "jwt_token", "fixtures", file_name)
  end
end
