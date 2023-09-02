generate_stage_instruction_fixtures:
	bundle exec ruby scripts/generate_stage_instruction_fixtures.rb

run_stage_1:
	bundle exec ruby main.rb fixtures/redis/stage_instructions/1.md code_file_path