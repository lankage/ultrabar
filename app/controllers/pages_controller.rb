class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:welcome, :home, :about, :help]
end
