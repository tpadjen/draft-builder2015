json.array!(@leagues) do |league|
  json.extract! league, :id, :name, :size
  json.url league_url(league, format: :json)
end
