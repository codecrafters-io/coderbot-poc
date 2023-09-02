generate_fixtures:
	bundle exec ruby scripts/generate_fixtures.rb

run_stage_1:
	bundle exec ruby main.rb fixtures/redis/stage_instructions/1.md code_file_path