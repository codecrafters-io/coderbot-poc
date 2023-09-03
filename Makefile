generate_fixtures:
	bundle exec ruby scripts/generate_fixtures.rb
	mkdir -p fixtures/courses
	git clone https://github.com/codecrafters-io/build-your-own-redis fixtures/courses/redis
	git clone https://github.com/codecrafters-io/build-your-own-docker fixtures/courses/docker
	git clone https://github.com/codecrafters-io/build-your-own-git fixtures/courses/git
	git clone https://github.com/codecrafters-io/build-your-own-sqlite fixtures/courses/sqlite
	git clone https://github.com/codecrafters-io/build-your-own-grep fixtures/courses/grep
	git clone https://github.com/codecrafters-io/build-your-own-bittorrent fixtures/courses/bittorrent

# run_stage_1_redis:
# 	git -C test_repositories/redis reset --hard
# 	git -C test_repositories/redis clean -fd
# 	bundle exec ruby main.rb redis 1 test_repositories/redis

# run_stage_1_bittorrent:
# 	git -C test_repositories/bittorrent reset --hard
# 	git -C test_repositories/bittorrent clean -fd
# 	bundle exec ruby main.rb bittorrent 1 test_repositories/bittorrent

# run_stage_1_git:
# 	git -C test_repositories/git reset --hard
# 	git -C test_repositories/git clean -fd
# 	bundle exec ruby main.rb git 1 test_repositories/git

# run_stage_2_redis:
# 	git -C test_repositories/redis reset --hard
# 	git -C test_repositories/redis clean -fd
# 	bundle exec ruby main.rb redis 2 test_repositories/redis

# run_stage_2_bittorrent:
# 	git -C test_repositories/bittorrent reset --hard
# 	git -C test_repositories/bittorrent clean -fd
# 	bundle exec ruby main.rb bittorrent 2 test_repositories/bittorrent

# run_stage_2_git:
# 	git -C test_repositories/git reset --hard
# 	git -C test_repositories/git clean -fd
# 	bundle exec ruby main.rb git 2 test_repositories/git

run_stage_3_redis:
	git -C test_repositories/redis reset --hard
	git -C test_repositories/redis clean -fd
	bundle exec ruby main.rb redis 3 test_repositories/redis

run_stage_3_bittorrent:
	git -C test_repositories/bittorrent reset --hard
	git -C test_repositories/bittorrent clean -fd
	bundle exec ruby main.rb bittorrent 3 test_repositories/bittorrent

run_stage_3_git:
	git -C test_repositories/git reset --hard
	git -C test_repositories/git clean -fd
	bundle exec ruby main.rb git 3 test_repositories/git

git_reset:
	ls test_repositories | xargs -n1 -I {} git --no-pager -C test_repositories/{} reset --hard

git_diff:
	ls test_repositories | xargs -n1 -I {} git --no-pager -C test_repositories/{} diff

git_status:
	ls test_repositories | xargs -n1 -I {} git -C test_repositories/{} status

git_push:
	ls test_repositories | xargs -n1 -I {} git -C test_repositories/{} commit -am "test"
	ls test_repositories | xargs -n1 -I {} git -C test_repositories/{} push origin master