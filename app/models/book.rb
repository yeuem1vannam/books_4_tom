class Book
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name,          type: String
  field :image,         type: String
  field :timeStamp,     type: String
  field :author,        type: String
  field :description,   type: String
  field :ebook_state,   type: String,   default: "download"
  field :isNewEbooks,   type: Boolean,  default: false
  field :stateLike,     type: Boolean,  default: false
  field :isVip,         type: Boolean,  default: false
  field :urlDownload,   type: String,   default: ""
  field :content,       type: String

  belongs_to :book_url, dependent: :nullify
  after_save :revoke_url

  private
  def revoke_url
    self.book_url.update_attributes(fetchable: false)
  end
end
