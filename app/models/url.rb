require 'autoinc'

class Url
  include Mongoid::Document
  include Mongoid::Autoinc

  field :num_id, type: Integer
  field :original, type: String
  field :clicks, type: Integer, default: 0

  belongs_to :user

  increments :num_id

  def short
    bijective_encode num_id
  end

  def self.num_id_from_short(s)
    bijective_decode s
  end

  def clicked!
    inc clicks: 1
  end

  protected
    ALPHABET =
    "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".split(//)
    # make your own alphabet using:
    # (('a'..'z').to_a + ('A'..'Z').to_a + (0..9).to_a).shuffle.join
   
    def bijective_encode(i)
      # from http://refactormycode.com/codes/125-base-62-encoding
      # with only minor modification
      return ALPHABET[0] if i == 0
      s = ''
      base = ALPHABET.length
      while i > 0
        s << ALPHABET[i.modulo(base)]
        i /= base
      end
      s.reverse
    end
     
    def self.bijective_decode(s)
      # based on base2dec() in Tcl translation 
      # at http://rosettacode.org/wiki/Non-decimal_radices/Convert#Ruby
      i = 0
      base = ALPHABET.length
      s.each_char { |c| i = i * base + ALPHABET.index(c) }
      i
    end
end
