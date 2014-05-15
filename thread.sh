if [ $# -eq 0 ]
then
	echo "please enter the source file to compile"
else
	if [ -f $1 ]
	then
		gcc -c SEAL_Lock.c
		gcc -c SEAL_Thread.c
		gcc -c SEAL_Util.c
		gcc -c SEAL_Signal.c
		gcc -c SEAL_Array.c
		gcc -D_REENTRANT $1 SEAL_Lock.o SEAL_Thread.o SEAL_Util.o SEAL_Signal.o SEAL_Array.o -lpthread
		./a.out
	else
		echo $1 "does not exist.  Please try again."
	fi
fi