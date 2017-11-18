default: build

build:
	packer build src/packer.json

test:
	vagrant box add archmini-test archmini.box
	VAGRANT_CWD=src vagrant up --debug || true
	VAGRANT_CWD=src vagrant ssh || true
	VAGRANT_CWD=src vagrant halt || true
	VAGRANT_CWD=src vagrant destroy --force || true
	vagrant box remove archmini-test
	rm -rf src/.vagrant

clean:
	rm archmini.box
	rm -rf packer_cache
	rm -rf src/.vagrant
