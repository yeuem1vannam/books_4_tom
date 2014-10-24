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
end
