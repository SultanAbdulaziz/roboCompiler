# roboCompiler

# run commands in order
bison -d robo.y
flex robo.l
gcc -o robo robo.tab.c lex.yy.c
./robo testfile.rs