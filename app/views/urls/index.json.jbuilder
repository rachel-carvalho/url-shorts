json.array!(@urls) do |url|
  json.extract! url, :original, :clicks, :short

  json.id url.id.to_s
end
