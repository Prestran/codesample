module ApplicationHelper
  def user_book_of_user book
      current_user.find_user_book book unless current_user.nil?
  end

  def get_image_most_popular_book id
    book = Book.find id
    image_tag book.cover.url, { class: 'bz-popular-image', alt: book.title }
  end
end
