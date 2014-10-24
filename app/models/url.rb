class URL
  include Mongoid::Document
  include Mongoid::Timestamps

  field :href,    type: String
  field :status,  type: Boolean
  field :kind,    type: String

  has_one :book, -> { where(kind: :book) }
end
