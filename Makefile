generate_fixtures:
	bundle exec ruby scripts/generate_fixtures.rb

run_stage_1_bittorrent:
	git -C test_repositories/bittorrent reset --hard
	git -C test_repositories/bittorrent clean -fd
	bundle exec ruby main.rb bittorrent 1 test_repositories/bittorrent