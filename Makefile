all: bigass.bin

bigass.bin: *.asm Makefile FORCE
#	number=1 ; while [[ $$number -le 1000 ]] ; do \
#        echo $$number ; \
#        ((number = number + 1)) ;
		tools/dasm ./bigass.asm -l./bigass.lst -f3 -s./bigass.sym -o./bigass.bin
#    done
	-killall Stella
	chmod 777 ./bigass.bin
	tools/stella -rd A ./bigass.bin
	open -a tools/stella ./bigass.bin
	exit 0

FORCE:
