if [ $# -eq 0 ]
then
	echo "please enter the source file to compile"
else
	if [ -f $1 ]
	then
		gcc -c SEAL_Lock.c
		gcc -c SEAL_Thread.c
		gcc -D_REENTRANT $1 SEAL_Lock.o SEAL_Thread.o -lpthread
		./a.out
	else
		echo $1 "does not exist.  Please try again."
	fi
fi