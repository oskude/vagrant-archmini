default: build

build:
	packer-io build packer.json

test:
	vagrant box add archmini-test archmini.box
	vagrant up --debug || true
	vagrant ssh || true
	vagrant halt || true
	vagrant destroy --force || true
	vagrant box remove archmini-test

clean:
	rm archmini.box
	rm -rf packer_cache
	rm -rf .vagrant
