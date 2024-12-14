class DashboardPolicy < ApplicationPolicy

  def show?
    user == record
  end

  class Scope < ApplicationPolicy::Scope

    # def resolve
    #   if user?
    #     scope.all
    #   else
    #     scope.none
    #   end
    # end
  end
end