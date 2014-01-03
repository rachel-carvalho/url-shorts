FactoryGirl.define do
  
  factory :url do
    original 'http://gmail.com'
    user
  end

  factory :user do
    email 'rachel.carvalho@gmail.com'
    password '12345678'
    password_confirmation { |u| u.password }

    factory :user_with_url do
      urls 
    end
  end

end