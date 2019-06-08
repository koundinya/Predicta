all: build_depedencies change_permission

build_depedencies:	
	bundle install
change_permission:	predicta.rb
	chmod 755 predicta.rb