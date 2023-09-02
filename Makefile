generate_fixtures:
	bundle exec ruby scripts/generate_fixtures.rb

run_stage_1_redis:
	git -C test_repositories/redis reset --hard
	git -C test_repositories/redis clean -fd
	bundle exec ruby main.rb redis 1 test_repositories/redis

run_stage_1_bittorrent:
	git -C test_repositories/bittorrent reset --hard
	git -C test_repositories/bittorrent clean -fd
	bundle exec ruby main.rb bittorrent 1 test_repositories/bittorrent

run_stage_1_git:
	git -C test_repositories/git reset --hard
	git -C test_repositories/git clean -fd
	bundle exec ruby main.rb git 1 test_repositories/git