config = {
  host: "http://localhost:9200/",
  transport_options: {
    request: { timeout: 5 }
  }
}

if File.exists?("config/elasticsearch.yml")
  config.merge!(YAML.load(ERB.new(File.read("#{Rails.root}/config/elasticsearch.yml")).result)[Rails.env].deep_symbolize_keys)
end

Searchkick.client = Elasticsearch::Client.new(config)
