default: build

build:
	packer build src/packer.json

test:
	vagrant box add miniarch-test miniarch.box
	VAGRANT_CWD=src vagrant up --debug || true
	VAGRANT_CWD=src vagrant ssh || true
	VAGRANT_CWD=src vagrant halt || true
	VAGRANT_CWD=src vagrant destroy --force || true
	vagrant box remove miniarch-test
	rm -rf src/.vagrant

clean:
	rm miniarch.box
	rm -rf packer_cache
	rm -rf src/.vagrant
