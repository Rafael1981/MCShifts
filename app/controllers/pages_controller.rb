class PagesController < ApplicationController
  def about
  end

  def contact
  end

  def usersindex
  	@users = User.all
  end
end
