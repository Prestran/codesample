require 'elasticsearch/model'

class Book < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  has_many :comments, dependent: :destroy
  has_many :reviews
  has_many :user_books

  has_attached_file :cover, styles: { large: "540x500>", medium: "325x300>", thumb: "110x100>" }, default_url: "/images/missing.jpg"
  validates_attachment_content_type :cover ,content_type: /\Aimage\/.*\z/

  validates :author, :description, :publishing_house, :title, :text, presence: true
  validates :text, presence: true, length: {minimum: 50, maximum: 500}

  resourcify

  scope :most_popular_books, -> {
    Book.select('books.id, books.title, books.author, avg(user_books.rating)')
          .joins(:user_books)
          .group('books.id')
          .order('avg(user_books.rating) desc')
          .limit(3)
  }

  settings index: { number_of_shards: 1 } do
    mappings dynamic: true do
      indexes :author, type: :text
      indexes :title, type: :text
    end
  end

  def as_indexed_json(options = {})
    self.as_json(
        only: [:title, :author],
    )
  end

  def self.search(query)
    __elasticsearch__.search(
        {
            query: {
                multi_match: {
                    query: query,
                    fields: ['title', 'author']
                }
            },
        })
  end
end

