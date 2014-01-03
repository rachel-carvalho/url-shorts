class Url
  include Mongoid::Document
  field :original, type: String
  field :short, type: String
end
