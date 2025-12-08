
WC=${WC-33}
EC=${EC-31}
HC=${HC-36}
SC=${SC-33}
MC=${MC-39}
OC=${OC-32}

HI="\e[${HC}m"
OK="\e[${OC}m"
ERR="\e[${EC}m"
SRC="\e[${SC}m"
OFF="\e[0m"

[ $# -lt 1 ] && echo -e "Usage: $0 ${SRC}<source file>$OFF" && exit 1
[ ! -f $1 ] && echo -e "${ERR}Error$OFF: file ${SRC}$1$OFF does not exist" && exit 1

EX=${EX-ex/default}
[[ "`realpath $1`" == */ex/* ]] && EX=$(echo "$1" | sed -E 's#.*(/?ex/[^/]+).*#\1#')
EXBASE=`basename $EX`

echo -e "Using exercise ${SRC}$EX$OFF"

CC=${CC-gcc}
PRG=$1
PRGNAME=`basename $1`
PRGNAME=${PRGNAME%.*}
CODEDIR=compiler-${EXBASE}/asm
EXECDIR=compiler-${EXBASE}
mkdir -p $CODEDIR
mkdir -p $EXECDIR

make EX=$EX
[ $? -ne 0 ] && echo -e "Making the compiler for ${ERR}$PRGNAME$OFF failed, exiting" && exit $?

echo -e "Compiler is created"

echo -e "${HI}./compiler/while $PRG > $CODEDIR/$PRGNAME.asm$OFF"
./compiler/while $PRG > $CODEDIR/$PRGNAME.asm
[ $? -ne 0 ] && echo -e "Compiling ${ERR}$PRG$OFF failed, exiting" && exit $?

echo -e "${HI}nasm -felf $CODEDIR/$PRGNAME.asm -o $CODEDIR/$PRGNAME.o$OFF"
nasm -felf $CODEDIR/$PRGNAME.asm -o $CODEDIR/$PRGNAME.o
[ $? -ne 0 ] && echo -e "Assembling ${ERR}$PRG$OFF failed, exiting" && exit $?

echo -e "${HI}$CC src/io.c $CODEDIR/$PRGNAME.o -m32 -no-pie -o\"$EXECDIR/$PRGNAME\"$OFF"
$CC src/io.c $CODEDIR/$PRGNAME.o -m32 -no-pie -o"$EXECDIR/$PRGNAME"
[ $? -ne 0 ] && echo -e "Linking ${ERR}$PRG$OFF failed, exiting" && exit $?

TITLE=`grep -m 1 "^program" $PRG`
echo -e "Program ${OK}$PRG$OFF (${HI}$TITLE$OFF) is compiled and linked, ${SRC}executing it$OFF now"

echo -e "${HI}$EXECDIR/$PRGNAME$OFF"
$EXECDIR/$PRGNAME

echo -e "Finished executing ${OK}$PRG$OFF"
