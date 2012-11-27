class User < ActiveRecord::Base
  before_save :generate_color

  has_many :page_views

  def add_page_view article
    page_view = PageView.create :wiki_record => article, :user => self
    self.page_views << page_view
    save!
  end

  private

  def generate_color
    self.color ||= Color::HSL.new(rand(360), 60, 60).to_rgb.html
  end
end
