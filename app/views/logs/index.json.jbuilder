json.array!(@logs) do |log|
  json.extract! log, :id, :Signin, :Signout
  json.url log_url(log, format: :json)
end
