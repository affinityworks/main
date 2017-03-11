class Api::Collections::Collection
  attr_accessor :page
  attr_accessor :total_pages
  attr_accessor :total_records

  delegate :first_page?, :last_page?, :prev_page, :next_page, to: :@resources

  def initialize(resources = Kaminari.paginate_array([], total_count: 0).page(0))
    @page = resources.current_page
    @total_pages = resources.total_pages
    @total_records = resources.total_count
    @resources = resources
  end
end
