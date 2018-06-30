PWD=$(shell pwd)

# make dependency -s
# description: check dependencies.
dependency:
	# check dependency jsonnet
	jsonnet_command="jsonnet"; \
	jsonnet_version="v0.10.0"; \
		if ! which $${jsonnet_command} >/dev/null 2>&1 ; then \
			echo $$'\e[31m\xe2\x9c\x96\e[0m' $${jsonnet_command} $${jsonnet_version}; 1>&2; \
			exit 1; \
		elif ! $${jsonnet_command} --version | grep $${jsonnet_version} >/dev/null; then \
			echo $$'\e[31m\xe2\x9c\x96\e[0m' $${jsonnet_command} $${jsonnet_version}; 1>&2; \
			exit 1; \
		else \
			echo $$'\e[32m\xe2\x9c\x94\e[0m' $${jsonnet_command} $${jsonnet_version}; \
		fi

# make build -s
# description: generate variant configuration file.
build:
	mkdir -p $${PWD}/dist;

	echo "#!/usr/bin/env var" > $${PWD}/dist/oz;
	jsonnet oz.jsonnet -S >> $${PWD}/dist/oz;
	chmod +x $${PWD}/dist/oz;

	echo "dev" > $${PWD}/dist/.ozenv
	cp $${PWD}/libs/var.definition.yaml $${PWD}/dist/oz.yaml;

# make clean -s
# description: clean distribution directory.
clean:
	rm -rf $${PWD}/dist;

# make run -s -e CMD="s3 create --aws-profile default"
# description: run oz command.
run:
	make build;

	cd $${PWD}/dist && \
		./oz $${CMD};

# make test -s
# description: test oz command.
test:
	# prepare for the test
	make build -s;
	# test ./oz init
	if ! $${PWD}/dist/oz init | grep -E '^Hello OZ!!$$' >/dev/null; then \
		echo $$'\e[31m\xe2\x9c\x96\e[0m ./oz init: Hello OZ' 1>&2; \
	else \
		echo $$'\e[32m\xe2\x9c\x94\e[0m ./oz init: Hello OZ'; \
	fi
