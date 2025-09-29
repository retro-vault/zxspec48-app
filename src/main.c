extern void cinit();
extern void cputc(char ch);
extern void cputs(char *text);
extern void cclear();

void main() {
    cinit();
    cclear();
    cputs("Hello world,\nagain!");
}