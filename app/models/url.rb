class Url
  include Mongoid::Document
  include Mongoid::Timestamps

  field :href,      type: String
  field :fetchable, type: Boolean
end
