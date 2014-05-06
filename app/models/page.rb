# /app/models/page.rb
class Page < ActiveRecord::Base
  validates_uniqueness_of :permalink
  PAGES_TYPE = %w(Company Started)

  class << self
    def company_pages
      where('pages_type = ?', 'Company')
    end

    def started_pages
      where('pages_type = ?', 'Started')
    end
  end

  def to_param
    permalink
  end
end
