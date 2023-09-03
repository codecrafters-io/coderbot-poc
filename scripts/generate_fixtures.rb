require_relative "../boot"

puts "Fetching courses from API"

Store.instance.fetch_all
Store.instance.persist("fixtures/store.json")

Store.instance.clear
Store.instance.load_from_file("fixtures/store.json")