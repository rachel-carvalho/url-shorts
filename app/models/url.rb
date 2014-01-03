class Url
  include Mongoid::Document
  field :original, type: String
  field :clicks, type: Integer, default: 0

  def short
    id.to_s
  end

  def self.id_from_short(s)
    s
  end
end
