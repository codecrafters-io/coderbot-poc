generate_fixtures:
	bundle exec ruby scripts/generate_fixtures.rb
	rm -rf fixtures/courses
	mkdir -p fixtures/courses
	git clone https://github.com/codecrafters-io/build-your-own-redis fixtures/courses/redis
	git clone https://github.com/codecrafters-io/build-your-own-docker fixtures/courses/docker
	git clone https://github.com/codecrafters-io/build-your-own-git fixtures/courses/git
	git clone https://github.com/codecrafters-io/build-your-own-sqlite fixtures/courses/sqlite
	git clone https://github.com/codecrafters-io/build-your-own-grep fixtures/courses/grep
	git clone https://github.com/codecrafters-io/build-your-own-bittorrent fixtures/courses/bittorrent
	git clone http://github.com/codecrafters-io/build-your-own-http-server fixtures/courses/http-server

run_redis_python:
	mkdir -p test_repositories
	rm -rf test_repositories/redis-python
	cp -R fixtures/courses/redis/compiled_starters/python test_repositories/redis-python
	git -C test_repositories/redis-python init
	git -C test_repositories/redis-python add .
	git -C test_repositories/redis-python commit -am "Initial commit"
	bundle exec ruby main.rb redis test_repositories/redis-python

run_bittorrent_python:
	mkdir -p test_repositories
	rm -rf test_repositories/bittorrent-python
	cp -R fixtures/courses/bittorrent/compiled_starters/python test_repositories/bittorrent-python
	git -C test_repositories/bittorrent-python init
	git -C test_repositories/bittorrent-python add .
	git -C test_repositories/bittorrent-python commit -am "Initial commit"
	bundle exec ruby main.rb bittorrent test_repositories/bittorrent-python

run_fix:
	rm -rf test_repositories/fix-test
	git clone <test> test_repositories/fix-test
	rm -rf test_repositories/fix-test/.git
	git -C test_repositories/fix-test init
	git -C test_repositories/fix-test add .
	git -C test_repositories/fix-test commit -am "Initial commit"
	bundle exec ruby fix.rb http-server post-file test_repositories/fix-test


git_reset:
	ls test_repositories | xargs -n1 -I {} git --no-pager -C test_repositories/{} reset --hard

git_diff:
	ls test_repositories | xargs -n1 -I {} git --no-pager -C test_repositories/{} diff

git_status:
	ls test_repositories | xargs -n1 -I {} git -C test_repositories/{} status

git_push:
	ls test_repositories | xargs -n1 -I {} git -C test_repositories/{} commit -am "test"
	ls test_repositories | xargs -n1 -I {} git -C test_repositories/{} push origin master

simulate_github_actions:
	act push --container-architecture linux/amd64