class User < ApplicationRecord
  rolify
  has_many :comments
  has_many :books
  has_many :reviews
  has_many :user_books

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_attached_file :avatar, styles: { large: "500x500>", medium: "300x300>", thumb: "100x100>" }, default_url: "/images/missing.jpg"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\z/
  validates :password, presence: true, length: { minimum: 6 }
  validates :email, :password_confirmation, presence: true
  validates :name, presence: true, length: { minimum: 6, maximum: 20 }

  after_create :assign_default_role

  def find_user_book book
    user_books.find_by(book: book)
  end

  private
  def assign_default_role
    self.add_role(:user) if self.roles.blank?
  end

end
