class PageViewsController < ApplicationController
  respond_to :json

  def recent
    @data = PageView.recent.limit(10)
    render :list, :layout => false
  end

  def since
    last_page_view = PageView.find(params[:id])
    @data = PageView.recent.limit(10).since last_page_view
    render :list, :layout => false
  end
end
