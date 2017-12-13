all: clean chroot

chroot:chroot.c
	gcc -o $@ $<
	sudo chown root $@
	sudo chmod +s $@

clean:
	rm -f chroot
