# frozen_string_literal: true

# Placeholder admin policy — a full admin namespace will be added in Phase 2.
# Until then this protects the stub /admin page used to verify authorization is wired up.
class AdminPolicy < ApplicationPolicy
  def index? = admin?
end
