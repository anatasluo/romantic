
bin/kernel:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  100000:	55                   	push   %ebp
  100001:	89 e5                	mov    %esp,%ebp
  100003:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100006:	ba 80 fd 10 00       	mov    $0x10fd80,%edx
  10000b:	b8 16 ea 10 00       	mov    $0x10ea16,%eax
  100010:	29 c2                	sub    %eax,%edx
  100012:	89 d0                	mov    %edx,%eax
  100014:	89 44 24 08          	mov    %eax,0x8(%esp)
  100018:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10001f:	00 
  100020:	c7 04 24 16 ea 10 00 	movl   $0x10ea16,(%esp)
  100027:	e8 83 2d 00 00       	call   102daf <memset>

    cons_init();                // init the console
  10002c:	e8 64 15 00 00       	call   101595 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100031:	c7 45 f4 c0 35 10 00 	movl   $0x1035c0,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10003b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10003f:	c7 04 24 dc 35 10 00 	movl   $0x1035dc,(%esp)
  100046:	e8 30 02 00 00       	call   10027b <cprintf>

    print_kerninfo();
  10004b:	e8 e2 08 00 00       	call   100932 <print_kerninfo>

    grade_backtrace();
  100050:	e8 8b 00 00 00       	call   1000e0 <grade_backtrace>

    pmm_init();                 // init physical memory management
  100055:	e8 1c 2a 00 00       	call   102a76 <pmm_init>

    pic_init();                 // init interrupt controller
  10005a:	e8 6d 16 00 00       	call   1016cc <pic_init>
    idt_init();                 // init interrupt descriptor table
  10005f:	e8 f1 17 00 00       	call   101855 <idt_init>

    clock_init();               // init clock interrupt
  100064:	e8 1f 0d 00 00       	call   100d88 <clock_init>
    intr_enable();              // enable irq interrupt
  100069:	e8 99 17 00 00       	call   101807 <intr_enable>

    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    lab1_switch_test();
  10006e:	e8 7c 01 00 00       	call   1001ef <lab1_switch_test>

    /* do nothing */
    while (1);
  100073:	eb fe                	jmp    100073 <kern_init+0x73>

00100075 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  100075:	55                   	push   %ebp
  100076:	89 e5                	mov    %esp,%ebp
  100078:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  10007b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  100082:	00 
  100083:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10008a:	00 
  10008b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100092:	e8 df 0c 00 00       	call   100d76 <mon_backtrace>
}
  100097:	c9                   	leave  
  100098:	c3                   	ret    

00100099 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  100099:	55                   	push   %ebp
  10009a:	89 e5                	mov    %esp,%ebp
  10009c:	53                   	push   %ebx
  10009d:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000a0:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  1000a3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  1000a6:	8d 55 08             	lea    0x8(%ebp),%edx
  1000a9:	8b 45 08             	mov    0x8(%ebp),%eax
  1000ac:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1000b0:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1000b4:	89 54 24 04          	mov    %edx,0x4(%esp)
  1000b8:	89 04 24             	mov    %eax,(%esp)
  1000bb:	e8 b5 ff ff ff       	call   100075 <grade_backtrace2>
}
  1000c0:	83 c4 14             	add    $0x14,%esp
  1000c3:	5b                   	pop    %ebx
  1000c4:	5d                   	pop    %ebp
  1000c5:	c3                   	ret    

001000c6 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000c6:	55                   	push   %ebp
  1000c7:	89 e5                	mov    %esp,%ebp
  1000c9:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000cc:	8b 45 10             	mov    0x10(%ebp),%eax
  1000cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000d3:	8b 45 08             	mov    0x8(%ebp),%eax
  1000d6:	89 04 24             	mov    %eax,(%esp)
  1000d9:	e8 bb ff ff ff       	call   100099 <grade_backtrace1>
}
  1000de:	c9                   	leave  
  1000df:	c3                   	ret    

001000e0 <grade_backtrace>:

void
grade_backtrace(void) {
  1000e0:	55                   	push   %ebp
  1000e1:	89 e5                	mov    %esp,%ebp
  1000e3:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  1000e6:	b8 00 00 10 00       	mov    $0x100000,%eax
  1000eb:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  1000f2:	ff 
  1000f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000f7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000fe:	e8 c3 ff ff ff       	call   1000c6 <grade_backtrace0>
}
  100103:	c9                   	leave  
  100104:	c3                   	ret    

00100105 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  100105:	55                   	push   %ebp
  100106:	89 e5                	mov    %esp,%ebp
  100108:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  10010b:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  10010e:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  100111:	8c 45 f2             	mov    %es,-0xe(%ebp)
  100114:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  100117:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10011b:	0f b7 c0             	movzwl %ax,%eax
  10011e:	83 e0 03             	and    $0x3,%eax
  100121:	89 c2                	mov    %eax,%edx
  100123:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100128:	89 54 24 08          	mov    %edx,0x8(%esp)
  10012c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100130:	c7 04 24 e1 35 10 00 	movl   $0x1035e1,(%esp)
  100137:	e8 3f 01 00 00       	call   10027b <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  10013c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100140:	0f b7 d0             	movzwl %ax,%edx
  100143:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100148:	89 54 24 08          	mov    %edx,0x8(%esp)
  10014c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100150:	c7 04 24 ef 35 10 00 	movl   $0x1035ef,(%esp)
  100157:	e8 1f 01 00 00       	call   10027b <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  10015c:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100160:	0f b7 d0             	movzwl %ax,%edx
  100163:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100168:	89 54 24 08          	mov    %edx,0x8(%esp)
  10016c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100170:	c7 04 24 fd 35 10 00 	movl   $0x1035fd,(%esp)
  100177:	e8 ff 00 00 00       	call   10027b <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  10017c:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100180:	0f b7 d0             	movzwl %ax,%edx
  100183:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100188:	89 54 24 08          	mov    %edx,0x8(%esp)
  10018c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100190:	c7 04 24 0b 36 10 00 	movl   $0x10360b,(%esp)
  100197:	e8 df 00 00 00       	call   10027b <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  10019c:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001a0:	0f b7 d0             	movzwl %ax,%edx
  1001a3:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  1001a8:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001b0:	c7 04 24 19 36 10 00 	movl   $0x103619,(%esp)
  1001b7:	e8 bf 00 00 00       	call   10027b <cprintf>
    round ++;
  1001bc:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  1001c1:	83 c0 01             	add    $0x1,%eax
  1001c4:	a3 20 ea 10 00       	mov    %eax,0x10ea20
}
  1001c9:	c9                   	leave  
  1001ca:	c3                   	ret    

001001cb <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001cb:	55                   	push   %ebp
  1001cc:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
	asm volatile (
  1001ce:	83 ec 08             	sub    $0x8,%esp
  1001d1:	cd 78                	int    $0x78
  1001d3:	89 ec                	mov    %ebp,%esp
		"int %0 \n"
		"movl %%ebp, %%esp \n"  // 此处的作用，是为了跟后面的汇编一起发挥leave作用
		:
		: "i"(T_SWITCH_TOU)
	);
}
  1001d5:	5d                   	pop    %ebp
  1001d6:	c3                   	ret    

001001d7 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001d7:	55                   	push   %ebp
  1001d8:	89 e5                	mov    %esp,%ebp
  1001da:	83 ec 18             	sub    $0x18,%esp
    //LAB1 CHALLENGE 1 :  TODO
	asm volatile (
  1001dd:	cd 79                	int    $0x79
  1001df:	89 ec                	mov    %ebp,%esp
		"int %0 \n"
		"movl %%ebp, %%esp \n"  // 此处的作用，是为了跟后面的汇编一起发挥leave作用
		:
		: "i"(T_SWITCH_TOK)
	);
	cprintf("+++ switch to  user  mode +++\n");
  1001e1:	c7 04 24 28 36 10 00 	movl   $0x103628,(%esp)
  1001e8:	e8 8e 00 00 00       	call   10027b <cprintf>

}
  1001ed:	c9                   	leave  
  1001ee:	c3                   	ret    

001001ef <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001ef:	55                   	push   %ebp
  1001f0:	89 e5                	mov    %esp,%ebp
  1001f2:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  1001f5:	e8 0b ff ff ff       	call   100105 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  1001fa:	c7 04 24 28 36 10 00 	movl   $0x103628,(%esp)
  100201:	e8 75 00 00 00       	call   10027b <cprintf>
    lab1_switch_to_user();
  100206:	e8 c0 ff ff ff       	call   1001cb <lab1_switch_to_user>
    lab1_print_cur_status();
  10020b:	e8 f5 fe ff ff       	call   100105 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  100210:	c7 04 24 48 36 10 00 	movl   $0x103648,(%esp)
  100217:	e8 5f 00 00 00       	call   10027b <cprintf>
    lab1_switch_to_kernel();
  10021c:	e8 b6 ff ff ff       	call   1001d7 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100221:	e8 df fe ff ff       	call   100105 <lab1_print_cur_status>
}
  100226:	c9                   	leave  
  100227:	c3                   	ret    

00100228 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  100228:	55                   	push   %ebp
  100229:	89 e5                	mov    %esp,%ebp
  10022b:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  10022e:	8b 45 08             	mov    0x8(%ebp),%eax
  100231:	89 04 24             	mov    %eax,(%esp)
  100234:	e8 88 13 00 00       	call   1015c1 <cons_putc>
    (*cnt) ++;
  100239:	8b 45 0c             	mov    0xc(%ebp),%eax
  10023c:	8b 00                	mov    (%eax),%eax
  10023e:	8d 50 01             	lea    0x1(%eax),%edx
  100241:	8b 45 0c             	mov    0xc(%ebp),%eax
  100244:	89 10                	mov    %edx,(%eax)
}
  100246:	c9                   	leave  
  100247:	c3                   	ret    

00100248 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  100248:	55                   	push   %ebp
  100249:	89 e5                	mov    %esp,%ebp
  10024b:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  10024e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  100255:	8b 45 0c             	mov    0xc(%ebp),%eax
  100258:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10025c:	8b 45 08             	mov    0x8(%ebp),%eax
  10025f:	89 44 24 08          	mov    %eax,0x8(%esp)
  100263:	8d 45 f4             	lea    -0xc(%ebp),%eax
  100266:	89 44 24 04          	mov    %eax,0x4(%esp)
  10026a:	c7 04 24 28 02 10 00 	movl   $0x100228,(%esp)
  100271:	e8 8b 2e 00 00       	call   103101 <vprintfmt>
    return cnt;
  100276:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100279:	c9                   	leave  
  10027a:	c3                   	ret    

0010027b <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  10027b:	55                   	push   %ebp
  10027c:	89 e5                	mov    %esp,%ebp
  10027e:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100281:	8d 45 0c             	lea    0xc(%ebp),%eax
  100284:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  100287:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10028a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10028e:	8b 45 08             	mov    0x8(%ebp),%eax
  100291:	89 04 24             	mov    %eax,(%esp)
  100294:	e8 af ff ff ff       	call   100248 <vcprintf>
  100299:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  10029c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10029f:	c9                   	leave  
  1002a0:	c3                   	ret    

001002a1 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  1002a1:	55                   	push   %ebp
  1002a2:	89 e5                	mov    %esp,%ebp
  1002a4:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002a7:	8b 45 08             	mov    0x8(%ebp),%eax
  1002aa:	89 04 24             	mov    %eax,(%esp)
  1002ad:	e8 0f 13 00 00       	call   1015c1 <cons_putc>
}
  1002b2:	c9                   	leave  
  1002b3:	c3                   	ret    

001002b4 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  1002b4:	55                   	push   %ebp
  1002b5:	89 e5                	mov    %esp,%ebp
  1002b7:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  1002ba:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  1002c1:	eb 13                	jmp    1002d6 <cputs+0x22>
        cputch(c, &cnt);
  1002c3:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  1002c7:	8d 55 f0             	lea    -0x10(%ebp),%edx
  1002ca:	89 54 24 04          	mov    %edx,0x4(%esp)
  1002ce:	89 04 24             	mov    %eax,(%esp)
  1002d1:	e8 52 ff ff ff       	call   100228 <cputch>
    while ((c = *str ++) != '\0') {
  1002d6:	8b 45 08             	mov    0x8(%ebp),%eax
  1002d9:	8d 50 01             	lea    0x1(%eax),%edx
  1002dc:	89 55 08             	mov    %edx,0x8(%ebp)
  1002df:	0f b6 00             	movzbl (%eax),%eax
  1002e2:	88 45 f7             	mov    %al,-0x9(%ebp)
  1002e5:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1002e9:	75 d8                	jne    1002c3 <cputs+0xf>
    }
    cputch('\n', &cnt);
  1002eb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1002ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  1002f2:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  1002f9:	e8 2a ff ff ff       	call   100228 <cputch>
    return cnt;
  1002fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  100301:	c9                   	leave  
  100302:	c3                   	ret    

00100303 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  100303:	55                   	push   %ebp
  100304:	89 e5                	mov    %esp,%ebp
  100306:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  100309:	e8 dc 12 00 00       	call   1015ea <cons_getc>
  10030e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100311:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100315:	74 f2                	je     100309 <getchar+0x6>
        /* do nothing */;
    return c;
  100317:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10031a:	c9                   	leave  
  10031b:	c3                   	ret    

0010031c <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  10031c:	55                   	push   %ebp
  10031d:	89 e5                	mov    %esp,%ebp
  10031f:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  100322:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100326:	74 13                	je     10033b <readline+0x1f>
        cprintf("%s", prompt);
  100328:	8b 45 08             	mov    0x8(%ebp),%eax
  10032b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10032f:	c7 04 24 67 36 10 00 	movl   $0x103667,(%esp)
  100336:	e8 40 ff ff ff       	call   10027b <cprintf>
    }
    int i = 0, c;
  10033b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100342:	e8 bc ff ff ff       	call   100303 <getchar>
  100347:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  10034a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10034e:	79 07                	jns    100357 <readline+0x3b>
            return NULL;
  100350:	b8 00 00 00 00       	mov    $0x0,%eax
  100355:	eb 79                	jmp    1003d0 <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  100357:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  10035b:	7e 28                	jle    100385 <readline+0x69>
  10035d:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  100364:	7f 1f                	jg     100385 <readline+0x69>
            cputchar(c);
  100366:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100369:	89 04 24             	mov    %eax,(%esp)
  10036c:	e8 30 ff ff ff       	call   1002a1 <cputchar>
            buf[i ++] = c;
  100371:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100374:	8d 50 01             	lea    0x1(%eax),%edx
  100377:	89 55 f4             	mov    %edx,-0xc(%ebp)
  10037a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10037d:	88 90 40 ea 10 00    	mov    %dl,0x10ea40(%eax)
  100383:	eb 46                	jmp    1003cb <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
  100385:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  100389:	75 17                	jne    1003a2 <readline+0x86>
  10038b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10038f:	7e 11                	jle    1003a2 <readline+0x86>
            cputchar(c);
  100391:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100394:	89 04 24             	mov    %eax,(%esp)
  100397:	e8 05 ff ff ff       	call   1002a1 <cputchar>
            i --;
  10039c:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  1003a0:	eb 29                	jmp    1003cb <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
  1003a2:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  1003a6:	74 06                	je     1003ae <readline+0x92>
  1003a8:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1003ac:	75 1d                	jne    1003cb <readline+0xaf>
            cputchar(c);
  1003ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003b1:	89 04 24             	mov    %eax,(%esp)
  1003b4:	e8 e8 fe ff ff       	call   1002a1 <cputchar>
            buf[i] = '\0';
  1003b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1003bc:	05 40 ea 10 00       	add    $0x10ea40,%eax
  1003c1:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1003c4:	b8 40 ea 10 00       	mov    $0x10ea40,%eax
  1003c9:	eb 05                	jmp    1003d0 <readline+0xb4>
        }
    }
  1003cb:	e9 72 ff ff ff       	jmp    100342 <readline+0x26>
}
  1003d0:	c9                   	leave  
  1003d1:	c3                   	ret    

001003d2 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  1003d2:	55                   	push   %ebp
  1003d3:	89 e5                	mov    %esp,%ebp
  1003d5:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  1003d8:	a1 40 ee 10 00       	mov    0x10ee40,%eax
  1003dd:	85 c0                	test   %eax,%eax
  1003df:	74 02                	je     1003e3 <__panic+0x11>
        goto panic_dead;
  1003e1:	eb 59                	jmp    10043c <__panic+0x6a>
    }
    is_panic = 1;
  1003e3:	c7 05 40 ee 10 00 01 	movl   $0x1,0x10ee40
  1003ea:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  1003ed:	8d 45 14             	lea    0x14(%ebp),%eax
  1003f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  1003f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1003f6:	89 44 24 08          	mov    %eax,0x8(%esp)
  1003fa:	8b 45 08             	mov    0x8(%ebp),%eax
  1003fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  100401:	c7 04 24 6a 36 10 00 	movl   $0x10366a,(%esp)
  100408:	e8 6e fe ff ff       	call   10027b <cprintf>
    vcprintf(fmt, ap);
  10040d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100410:	89 44 24 04          	mov    %eax,0x4(%esp)
  100414:	8b 45 10             	mov    0x10(%ebp),%eax
  100417:	89 04 24             	mov    %eax,(%esp)
  10041a:	e8 29 fe ff ff       	call   100248 <vcprintf>
    cprintf("\n");
  10041f:	c7 04 24 86 36 10 00 	movl   $0x103686,(%esp)
  100426:	e8 50 fe ff ff       	call   10027b <cprintf>
    
    cprintf("stack trackback:\n");
  10042b:	c7 04 24 88 36 10 00 	movl   $0x103688,(%esp)
  100432:	e8 44 fe ff ff       	call   10027b <cprintf>
    print_stackframe();
  100437:	e8 40 06 00 00       	call   100a7c <print_stackframe>
    
    va_end(ap);

panic_dead:
    intr_disable();
  10043c:	e8 cc 13 00 00       	call   10180d <intr_disable>
    while (1) {
        kmonitor(NULL);
  100441:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100448:	e8 5a 08 00 00       	call   100ca7 <kmonitor>
    }
  10044d:	eb f2                	jmp    100441 <__panic+0x6f>

0010044f <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  10044f:	55                   	push   %ebp
  100450:	89 e5                	mov    %esp,%ebp
  100452:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100455:	8d 45 14             	lea    0x14(%ebp),%eax
  100458:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  10045b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10045e:	89 44 24 08          	mov    %eax,0x8(%esp)
  100462:	8b 45 08             	mov    0x8(%ebp),%eax
  100465:	89 44 24 04          	mov    %eax,0x4(%esp)
  100469:	c7 04 24 9a 36 10 00 	movl   $0x10369a,(%esp)
  100470:	e8 06 fe ff ff       	call   10027b <cprintf>
    vcprintf(fmt, ap);
  100475:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100478:	89 44 24 04          	mov    %eax,0x4(%esp)
  10047c:	8b 45 10             	mov    0x10(%ebp),%eax
  10047f:	89 04 24             	mov    %eax,(%esp)
  100482:	e8 c1 fd ff ff       	call   100248 <vcprintf>
    cprintf("\n");
  100487:	c7 04 24 86 36 10 00 	movl   $0x103686,(%esp)
  10048e:	e8 e8 fd ff ff       	call   10027b <cprintf>
    va_end(ap);
}
  100493:	c9                   	leave  
  100494:	c3                   	ret    

00100495 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100495:	55                   	push   %ebp
  100496:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100498:	a1 40 ee 10 00       	mov    0x10ee40,%eax
}
  10049d:	5d                   	pop    %ebp
  10049e:	c3                   	ret    

0010049f <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  10049f:	55                   	push   %ebp
  1004a0:	89 e5                	mov    %esp,%ebp
  1004a2:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1004a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004a8:	8b 00                	mov    (%eax),%eax
  1004aa:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1004ad:	8b 45 10             	mov    0x10(%ebp),%eax
  1004b0:	8b 00                	mov    (%eax),%eax
  1004b2:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004b5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1004bc:	e9 d2 00 00 00       	jmp    100593 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
  1004c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1004c4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1004c7:	01 d0                	add    %edx,%eax
  1004c9:	89 c2                	mov    %eax,%edx
  1004cb:	c1 ea 1f             	shr    $0x1f,%edx
  1004ce:	01 d0                	add    %edx,%eax
  1004d0:	d1 f8                	sar    %eax
  1004d2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1004d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1004d8:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1004db:	eb 04                	jmp    1004e1 <stab_binsearch+0x42>
            m --;
  1004dd:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
  1004e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004e4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004e7:	7c 1f                	jl     100508 <stab_binsearch+0x69>
  1004e9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004ec:	89 d0                	mov    %edx,%eax
  1004ee:	01 c0                	add    %eax,%eax
  1004f0:	01 d0                	add    %edx,%eax
  1004f2:	c1 e0 02             	shl    $0x2,%eax
  1004f5:	89 c2                	mov    %eax,%edx
  1004f7:	8b 45 08             	mov    0x8(%ebp),%eax
  1004fa:	01 d0                	add    %edx,%eax
  1004fc:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100500:	0f b6 c0             	movzbl %al,%eax
  100503:	3b 45 14             	cmp    0x14(%ebp),%eax
  100506:	75 d5                	jne    1004dd <stab_binsearch+0x3e>
        }
        if (m < l) {    // no match in [l, m]
  100508:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10050b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  10050e:	7d 0b                	jge    10051b <stab_binsearch+0x7c>
            l = true_m + 1;
  100510:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100513:	83 c0 01             	add    $0x1,%eax
  100516:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  100519:	eb 78                	jmp    100593 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
  10051b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100522:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100525:	89 d0                	mov    %edx,%eax
  100527:	01 c0                	add    %eax,%eax
  100529:	01 d0                	add    %edx,%eax
  10052b:	c1 e0 02             	shl    $0x2,%eax
  10052e:	89 c2                	mov    %eax,%edx
  100530:	8b 45 08             	mov    0x8(%ebp),%eax
  100533:	01 d0                	add    %edx,%eax
  100535:	8b 40 08             	mov    0x8(%eax),%eax
  100538:	3b 45 18             	cmp    0x18(%ebp),%eax
  10053b:	73 13                	jae    100550 <stab_binsearch+0xb1>
            *region_left = m;
  10053d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100540:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100543:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100545:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100548:	83 c0 01             	add    $0x1,%eax
  10054b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  10054e:	eb 43                	jmp    100593 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
  100550:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100553:	89 d0                	mov    %edx,%eax
  100555:	01 c0                	add    %eax,%eax
  100557:	01 d0                	add    %edx,%eax
  100559:	c1 e0 02             	shl    $0x2,%eax
  10055c:	89 c2                	mov    %eax,%edx
  10055e:	8b 45 08             	mov    0x8(%ebp),%eax
  100561:	01 d0                	add    %edx,%eax
  100563:	8b 40 08             	mov    0x8(%eax),%eax
  100566:	3b 45 18             	cmp    0x18(%ebp),%eax
  100569:	76 16                	jbe    100581 <stab_binsearch+0xe2>
            *region_right = m - 1;
  10056b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10056e:	8d 50 ff             	lea    -0x1(%eax),%edx
  100571:	8b 45 10             	mov    0x10(%ebp),%eax
  100574:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  100576:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100579:	83 e8 01             	sub    $0x1,%eax
  10057c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  10057f:	eb 12                	jmp    100593 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  100581:	8b 45 0c             	mov    0xc(%ebp),%eax
  100584:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100587:	89 10                	mov    %edx,(%eax)
            l = m;
  100589:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10058c:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  10058f:	83 45 18 01          	addl   $0x1,0x18(%ebp)
    while (l <= r) {
  100593:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100596:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  100599:	0f 8e 22 ff ff ff    	jle    1004c1 <stab_binsearch+0x22>
        }
    }

    if (!any_matches) {
  10059f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1005a3:	75 0f                	jne    1005b4 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
  1005a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005a8:	8b 00                	mov    (%eax),%eax
  1005aa:	8d 50 ff             	lea    -0x1(%eax),%edx
  1005ad:	8b 45 10             	mov    0x10(%ebp),%eax
  1005b0:	89 10                	mov    %edx,(%eax)
  1005b2:	eb 3f                	jmp    1005f3 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
  1005b4:	8b 45 10             	mov    0x10(%ebp),%eax
  1005b7:	8b 00                	mov    (%eax),%eax
  1005b9:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1005bc:	eb 04                	jmp    1005c2 <stab_binsearch+0x123>
  1005be:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  1005c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005c5:	8b 00                	mov    (%eax),%eax
  1005c7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1005ca:	7d 1f                	jge    1005eb <stab_binsearch+0x14c>
  1005cc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1005cf:	89 d0                	mov    %edx,%eax
  1005d1:	01 c0                	add    %eax,%eax
  1005d3:	01 d0                	add    %edx,%eax
  1005d5:	c1 e0 02             	shl    $0x2,%eax
  1005d8:	89 c2                	mov    %eax,%edx
  1005da:	8b 45 08             	mov    0x8(%ebp),%eax
  1005dd:	01 d0                	add    %edx,%eax
  1005df:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1005e3:	0f b6 c0             	movzbl %al,%eax
  1005e6:	3b 45 14             	cmp    0x14(%ebp),%eax
  1005e9:	75 d3                	jne    1005be <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
  1005eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005ee:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1005f1:	89 10                	mov    %edx,(%eax)
    }
}
  1005f3:	c9                   	leave  
  1005f4:	c3                   	ret    

001005f5 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  1005f5:	55                   	push   %ebp
  1005f6:	89 e5                	mov    %esp,%ebp
  1005f8:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  1005fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005fe:	c7 00 b8 36 10 00    	movl   $0x1036b8,(%eax)
    info->eip_line = 0;
  100604:	8b 45 0c             	mov    0xc(%ebp),%eax
  100607:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  10060e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100611:	c7 40 08 b8 36 10 00 	movl   $0x1036b8,0x8(%eax)
    info->eip_fn_namelen = 9;
  100618:	8b 45 0c             	mov    0xc(%ebp),%eax
  10061b:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100622:	8b 45 0c             	mov    0xc(%ebp),%eax
  100625:	8b 55 08             	mov    0x8(%ebp),%edx
  100628:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  10062b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10062e:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100635:	c7 45 f4 ec 3e 10 00 	movl   $0x103eec,-0xc(%ebp)
    stab_end = __STAB_END__;
  10063c:	c7 45 f0 34 b7 10 00 	movl   $0x10b734,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100643:	c7 45 ec 35 b7 10 00 	movl   $0x10b735,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  10064a:	c7 45 e8 61 d7 10 00 	movl   $0x10d761,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  100651:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100654:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  100657:	76 0d                	jbe    100666 <debuginfo_eip+0x71>
  100659:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10065c:	83 e8 01             	sub    $0x1,%eax
  10065f:	0f b6 00             	movzbl (%eax),%eax
  100662:	84 c0                	test   %al,%al
  100664:	74 0a                	je     100670 <debuginfo_eip+0x7b>
        return -1;
  100666:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10066b:	e9 c0 02 00 00       	jmp    100930 <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  100670:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  100677:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10067a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10067d:	29 c2                	sub    %eax,%edx
  10067f:	89 d0                	mov    %edx,%eax
  100681:	c1 f8 02             	sar    $0x2,%eax
  100684:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  10068a:	83 e8 01             	sub    $0x1,%eax
  10068d:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  100690:	8b 45 08             	mov    0x8(%ebp),%eax
  100693:	89 44 24 10          	mov    %eax,0x10(%esp)
  100697:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  10069e:	00 
  10069f:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1006a2:	89 44 24 08          	mov    %eax,0x8(%esp)
  1006a6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1006a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1006ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006b0:	89 04 24             	mov    %eax,(%esp)
  1006b3:	e8 e7 fd ff ff       	call   10049f <stab_binsearch>
    if (lfile == 0)
  1006b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006bb:	85 c0                	test   %eax,%eax
  1006bd:	75 0a                	jne    1006c9 <debuginfo_eip+0xd4>
        return -1;
  1006bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1006c4:	e9 67 02 00 00       	jmp    100930 <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  1006c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006cc:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1006cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006d2:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  1006d5:	8b 45 08             	mov    0x8(%ebp),%eax
  1006d8:	89 44 24 10          	mov    %eax,0x10(%esp)
  1006dc:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  1006e3:	00 
  1006e4:	8d 45 d8             	lea    -0x28(%ebp),%eax
  1006e7:	89 44 24 08          	mov    %eax,0x8(%esp)
  1006eb:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1006ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  1006f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006f5:	89 04 24             	mov    %eax,(%esp)
  1006f8:	e8 a2 fd ff ff       	call   10049f <stab_binsearch>

    if (lfun <= rfun) {
  1006fd:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100700:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100703:	39 c2                	cmp    %eax,%edx
  100705:	7f 7c                	jg     100783 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  100707:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10070a:	89 c2                	mov    %eax,%edx
  10070c:	89 d0                	mov    %edx,%eax
  10070e:	01 c0                	add    %eax,%eax
  100710:	01 d0                	add    %edx,%eax
  100712:	c1 e0 02             	shl    $0x2,%eax
  100715:	89 c2                	mov    %eax,%edx
  100717:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10071a:	01 d0                	add    %edx,%eax
  10071c:	8b 10                	mov    (%eax),%edx
  10071e:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  100721:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100724:	29 c1                	sub    %eax,%ecx
  100726:	89 c8                	mov    %ecx,%eax
  100728:	39 c2                	cmp    %eax,%edx
  10072a:	73 22                	jae    10074e <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  10072c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10072f:	89 c2                	mov    %eax,%edx
  100731:	89 d0                	mov    %edx,%eax
  100733:	01 c0                	add    %eax,%eax
  100735:	01 d0                	add    %edx,%eax
  100737:	c1 e0 02             	shl    $0x2,%eax
  10073a:	89 c2                	mov    %eax,%edx
  10073c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10073f:	01 d0                	add    %edx,%eax
  100741:	8b 10                	mov    (%eax),%edx
  100743:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100746:	01 c2                	add    %eax,%edx
  100748:	8b 45 0c             	mov    0xc(%ebp),%eax
  10074b:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  10074e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100751:	89 c2                	mov    %eax,%edx
  100753:	89 d0                	mov    %edx,%eax
  100755:	01 c0                	add    %eax,%eax
  100757:	01 d0                	add    %edx,%eax
  100759:	c1 e0 02             	shl    $0x2,%eax
  10075c:	89 c2                	mov    %eax,%edx
  10075e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100761:	01 d0                	add    %edx,%eax
  100763:	8b 50 08             	mov    0x8(%eax),%edx
  100766:	8b 45 0c             	mov    0xc(%ebp),%eax
  100769:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  10076c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10076f:	8b 40 10             	mov    0x10(%eax),%eax
  100772:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  100775:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100778:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  10077b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10077e:	89 45 d0             	mov    %eax,-0x30(%ebp)
  100781:	eb 15                	jmp    100798 <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  100783:	8b 45 0c             	mov    0xc(%ebp),%eax
  100786:	8b 55 08             	mov    0x8(%ebp),%edx
  100789:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  10078c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10078f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  100792:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100795:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  100798:	8b 45 0c             	mov    0xc(%ebp),%eax
  10079b:	8b 40 08             	mov    0x8(%eax),%eax
  10079e:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1007a5:	00 
  1007a6:	89 04 24             	mov    %eax,(%esp)
  1007a9:	e8 75 24 00 00       	call   102c23 <strfind>
  1007ae:	89 c2                	mov    %eax,%edx
  1007b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007b3:	8b 40 08             	mov    0x8(%eax),%eax
  1007b6:	29 c2                	sub    %eax,%edx
  1007b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007bb:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1007be:	8b 45 08             	mov    0x8(%ebp),%eax
  1007c1:	89 44 24 10          	mov    %eax,0x10(%esp)
  1007c5:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  1007cc:	00 
  1007cd:	8d 45 d0             	lea    -0x30(%ebp),%eax
  1007d0:	89 44 24 08          	mov    %eax,0x8(%esp)
  1007d4:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  1007d7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1007db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007de:	89 04 24             	mov    %eax,(%esp)
  1007e1:	e8 b9 fc ff ff       	call   10049f <stab_binsearch>
    if (lline <= rline) {
  1007e6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007e9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1007ec:	39 c2                	cmp    %eax,%edx
  1007ee:	7f 24                	jg     100814 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
  1007f0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1007f3:	89 c2                	mov    %eax,%edx
  1007f5:	89 d0                	mov    %edx,%eax
  1007f7:	01 c0                	add    %eax,%eax
  1007f9:	01 d0                	add    %edx,%eax
  1007fb:	c1 e0 02             	shl    $0x2,%eax
  1007fe:	89 c2                	mov    %eax,%edx
  100800:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100803:	01 d0                	add    %edx,%eax
  100805:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  100809:	0f b7 d0             	movzwl %ax,%edx
  10080c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10080f:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100812:	eb 13                	jmp    100827 <debuginfo_eip+0x232>
        return -1;
  100814:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100819:	e9 12 01 00 00       	jmp    100930 <debuginfo_eip+0x33b>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  10081e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100821:	83 e8 01             	sub    $0x1,%eax
  100824:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
  100827:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10082a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10082d:	39 c2                	cmp    %eax,%edx
  10082f:	7c 56                	jl     100887 <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
  100831:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100834:	89 c2                	mov    %eax,%edx
  100836:	89 d0                	mov    %edx,%eax
  100838:	01 c0                	add    %eax,%eax
  10083a:	01 d0                	add    %edx,%eax
  10083c:	c1 e0 02             	shl    $0x2,%eax
  10083f:	89 c2                	mov    %eax,%edx
  100841:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100844:	01 d0                	add    %edx,%eax
  100846:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10084a:	3c 84                	cmp    $0x84,%al
  10084c:	74 39                	je     100887 <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  10084e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100851:	89 c2                	mov    %eax,%edx
  100853:	89 d0                	mov    %edx,%eax
  100855:	01 c0                	add    %eax,%eax
  100857:	01 d0                	add    %edx,%eax
  100859:	c1 e0 02             	shl    $0x2,%eax
  10085c:	89 c2                	mov    %eax,%edx
  10085e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100861:	01 d0                	add    %edx,%eax
  100863:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100867:	3c 64                	cmp    $0x64,%al
  100869:	75 b3                	jne    10081e <debuginfo_eip+0x229>
  10086b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10086e:	89 c2                	mov    %eax,%edx
  100870:	89 d0                	mov    %edx,%eax
  100872:	01 c0                	add    %eax,%eax
  100874:	01 d0                	add    %edx,%eax
  100876:	c1 e0 02             	shl    $0x2,%eax
  100879:	89 c2                	mov    %eax,%edx
  10087b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10087e:	01 d0                	add    %edx,%eax
  100880:	8b 40 08             	mov    0x8(%eax),%eax
  100883:	85 c0                	test   %eax,%eax
  100885:	74 97                	je     10081e <debuginfo_eip+0x229>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  100887:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10088a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10088d:	39 c2                	cmp    %eax,%edx
  10088f:	7c 46                	jl     1008d7 <debuginfo_eip+0x2e2>
  100891:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100894:	89 c2                	mov    %eax,%edx
  100896:	89 d0                	mov    %edx,%eax
  100898:	01 c0                	add    %eax,%eax
  10089a:	01 d0                	add    %edx,%eax
  10089c:	c1 e0 02             	shl    $0x2,%eax
  10089f:	89 c2                	mov    %eax,%edx
  1008a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008a4:	01 d0                	add    %edx,%eax
  1008a6:	8b 10                	mov    (%eax),%edx
  1008a8:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1008ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1008ae:	29 c1                	sub    %eax,%ecx
  1008b0:	89 c8                	mov    %ecx,%eax
  1008b2:	39 c2                	cmp    %eax,%edx
  1008b4:	73 21                	jae    1008d7 <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1008b6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008b9:	89 c2                	mov    %eax,%edx
  1008bb:	89 d0                	mov    %edx,%eax
  1008bd:	01 c0                	add    %eax,%eax
  1008bf:	01 d0                	add    %edx,%eax
  1008c1:	c1 e0 02             	shl    $0x2,%eax
  1008c4:	89 c2                	mov    %eax,%edx
  1008c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008c9:	01 d0                	add    %edx,%eax
  1008cb:	8b 10                	mov    (%eax),%edx
  1008cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1008d0:	01 c2                	add    %eax,%edx
  1008d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008d5:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  1008d7:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1008da:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1008dd:	39 c2                	cmp    %eax,%edx
  1008df:	7d 4a                	jge    10092b <debuginfo_eip+0x336>
        for (lline = lfun + 1;
  1008e1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1008e4:	83 c0 01             	add    $0x1,%eax
  1008e7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  1008ea:	eb 18                	jmp    100904 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  1008ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008ef:	8b 40 14             	mov    0x14(%eax),%eax
  1008f2:	8d 50 01             	lea    0x1(%eax),%edx
  1008f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008f8:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
  1008fb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008fe:	83 c0 01             	add    $0x1,%eax
  100901:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100904:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100907:	8b 45 d8             	mov    -0x28(%ebp),%eax
        for (lline = lfun + 1;
  10090a:	39 c2                	cmp    %eax,%edx
  10090c:	7d 1d                	jge    10092b <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  10090e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100911:	89 c2                	mov    %eax,%edx
  100913:	89 d0                	mov    %edx,%eax
  100915:	01 c0                	add    %eax,%eax
  100917:	01 d0                	add    %edx,%eax
  100919:	c1 e0 02             	shl    $0x2,%eax
  10091c:	89 c2                	mov    %eax,%edx
  10091e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100921:	01 d0                	add    %edx,%eax
  100923:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100927:	3c a0                	cmp    $0xa0,%al
  100929:	74 c1                	je     1008ec <debuginfo_eip+0x2f7>
        }
    }
    return 0;
  10092b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100930:	c9                   	leave  
  100931:	c3                   	ret    

00100932 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100932:	55                   	push   %ebp
  100933:	89 e5                	mov    %esp,%ebp
  100935:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  100938:	c7 04 24 c2 36 10 00 	movl   $0x1036c2,(%esp)
  10093f:	e8 37 f9 ff ff       	call   10027b <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100944:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  10094b:	00 
  10094c:	c7 04 24 db 36 10 00 	movl   $0x1036db,(%esp)
  100953:	e8 23 f9 ff ff       	call   10027b <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  100958:	c7 44 24 04 b9 35 10 	movl   $0x1035b9,0x4(%esp)
  10095f:	00 
  100960:	c7 04 24 f3 36 10 00 	movl   $0x1036f3,(%esp)
  100967:	e8 0f f9 ff ff       	call   10027b <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  10096c:	c7 44 24 04 16 ea 10 	movl   $0x10ea16,0x4(%esp)
  100973:	00 
  100974:	c7 04 24 0b 37 10 00 	movl   $0x10370b,(%esp)
  10097b:	e8 fb f8 ff ff       	call   10027b <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  100980:	c7 44 24 04 80 fd 10 	movl   $0x10fd80,0x4(%esp)
  100987:	00 
  100988:	c7 04 24 23 37 10 00 	movl   $0x103723,(%esp)
  10098f:	e8 e7 f8 ff ff       	call   10027b <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  100994:	b8 80 fd 10 00       	mov    $0x10fd80,%eax
  100999:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  10099f:	b8 00 00 10 00       	mov    $0x100000,%eax
  1009a4:	29 c2                	sub    %eax,%edx
  1009a6:	89 d0                	mov    %edx,%eax
  1009a8:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1009ae:	85 c0                	test   %eax,%eax
  1009b0:	0f 48 c2             	cmovs  %edx,%eax
  1009b3:	c1 f8 0a             	sar    $0xa,%eax
  1009b6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009ba:	c7 04 24 3c 37 10 00 	movl   $0x10373c,(%esp)
  1009c1:	e8 b5 f8 ff ff       	call   10027b <cprintf>
}
  1009c6:	c9                   	leave  
  1009c7:	c3                   	ret    

001009c8 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  1009c8:	55                   	push   %ebp
  1009c9:	89 e5                	mov    %esp,%ebp
  1009cb:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  1009d1:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1009d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009d8:	8b 45 08             	mov    0x8(%ebp),%eax
  1009db:	89 04 24             	mov    %eax,(%esp)
  1009de:	e8 12 fc ff ff       	call   1005f5 <debuginfo_eip>
  1009e3:	85 c0                	test   %eax,%eax
  1009e5:	74 15                	je     1009fc <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  1009e7:	8b 45 08             	mov    0x8(%ebp),%eax
  1009ea:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009ee:	c7 04 24 66 37 10 00 	movl   $0x103766,(%esp)
  1009f5:	e8 81 f8 ff ff       	call   10027b <cprintf>
  1009fa:	eb 6d                	jmp    100a69 <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  1009fc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100a03:	eb 1c                	jmp    100a21 <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
  100a05:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  100a08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a0b:	01 d0                	add    %edx,%eax
  100a0d:	0f b6 00             	movzbl (%eax),%eax
  100a10:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100a16:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100a19:	01 ca                	add    %ecx,%edx
  100a1b:	88 02                	mov    %al,(%edx)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100a1d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100a21:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a24:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  100a27:	7f dc                	jg     100a05 <print_debuginfo+0x3d>
        }
        fnname[j] = '\0';
  100a29:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  100a2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a32:	01 d0                	add    %edx,%eax
  100a34:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
  100a37:	8b 45 ec             	mov    -0x14(%ebp),%eax
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100a3a:	8b 55 08             	mov    0x8(%ebp),%edx
  100a3d:	89 d1                	mov    %edx,%ecx
  100a3f:	29 c1                	sub    %eax,%ecx
  100a41:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100a44:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100a47:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  100a4b:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100a51:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100a55:	89 54 24 08          	mov    %edx,0x8(%esp)
  100a59:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a5d:	c7 04 24 82 37 10 00 	movl   $0x103782,(%esp)
  100a64:	e8 12 f8 ff ff       	call   10027b <cprintf>
    }
}
  100a69:	c9                   	leave  
  100a6a:	c3                   	ret    

00100a6b <read_eip>:

static __noinline uint32_t
read_eip(void) {
  100a6b:	55                   	push   %ebp
  100a6c:	89 e5                	mov    %esp,%ebp
  100a6e:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100a71:	8b 45 04             	mov    0x4(%ebp),%eax
  100a74:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  100a77:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  100a7a:	c9                   	leave  
  100a7b:	c3                   	ret    

00100a7c <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100a7c:	55                   	push   %ebp
  100a7d:	89 e5                	mov    %esp,%ebp
  100a7f:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100a82:	89 e8                	mov    %ebp,%eax
  100a84:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
  100a87:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */

	uint32_t ebp_v = read_ebp(), eip_v = read_eip();
  100a8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100a8d:	e8 d9 ff ff ff       	call   100a6b <read_eip>
  100a92:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32_t i, j;
	for (i = 0; ebp_v != 0 && i< STACKFRAME_DEPTH; i ++)
  100a95:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  100a9c:	e9 88 00 00 00       	jmp    100b29 <print_stackframe+0xad>
	{
		cprintf("ebp:0x%08x eip:0x%08x args:", ebp_v, eip_v);
  100aa1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100aa4:	89 44 24 08          	mov    %eax,0x8(%esp)
  100aa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100aab:	89 44 24 04          	mov    %eax,0x4(%esp)
  100aaf:	c7 04 24 94 37 10 00 	movl   $0x103794,(%esp)
  100ab6:	e8 c0 f7 ff ff       	call   10027b <cprintf>
		uint32_t *args = (uint32_t *)ebp_v + 0x2;
  100abb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100abe:	83 c0 08             	add    $0x8,%eax
  100ac1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		for (j = 0; j < 4; j ++)
  100ac4:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  100acb:	eb 25                	jmp    100af2 <print_stackframe+0x76>
		{
			cprintf(" 0x%08x ", args[j]);
  100acd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100ad0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100ad7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100ada:	01 d0                	add    %edx,%eax
  100adc:	8b 00                	mov    (%eax),%eax
  100ade:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ae2:	c7 04 24 b0 37 10 00 	movl   $0x1037b0,(%esp)
  100ae9:	e8 8d f7 ff ff       	call   10027b <cprintf>
		for (j = 0; j < 4; j ++)
  100aee:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
  100af2:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100af6:	76 d5                	jbe    100acd <print_stackframe+0x51>
		}
		cprintf("\n");
  100af8:	c7 04 24 b9 37 10 00 	movl   $0x1037b9,(%esp)
  100aff:	e8 77 f7 ff ff       	call   10027b <cprintf>
		print_debuginfo(eip_v-0x1);
  100b04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100b07:	83 e8 01             	sub    $0x1,%eax
  100b0a:	89 04 24             	mov    %eax,(%esp)
  100b0d:	e8 b6 fe ff ff       	call   1009c8 <print_debuginfo>
		eip_v = ((uint32_t*)ebp_v)[1];
  100b12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b15:	83 c0 04             	add    $0x4,%eax
  100b18:	8b 00                	mov    (%eax),%eax
  100b1a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		ebp_v = ((uint32_t*)ebp_v)[0];
  100b1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b20:	8b 00                	mov    (%eax),%eax
  100b22:	89 45 f4             	mov    %eax,-0xc(%ebp)
	for (i = 0; ebp_v != 0 && i< STACKFRAME_DEPTH; i ++)
  100b25:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100b29:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100b2d:	74 0a                	je     100b39 <print_stackframe+0xbd>
  100b2f:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100b33:	0f 86 68 ff ff ff    	jbe    100aa1 <print_stackframe+0x25>
	}

}
  100b39:	c9                   	leave  
  100b3a:	c3                   	ret    

00100b3b <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100b3b:	55                   	push   %ebp
  100b3c:	89 e5                	mov    %esp,%ebp
  100b3e:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100b41:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b48:	eb 0c                	jmp    100b56 <parse+0x1b>
            *buf ++ = '\0';
  100b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  100b4d:	8d 50 01             	lea    0x1(%eax),%edx
  100b50:	89 55 08             	mov    %edx,0x8(%ebp)
  100b53:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b56:	8b 45 08             	mov    0x8(%ebp),%eax
  100b59:	0f b6 00             	movzbl (%eax),%eax
  100b5c:	84 c0                	test   %al,%al
  100b5e:	74 1d                	je     100b7d <parse+0x42>
  100b60:	8b 45 08             	mov    0x8(%ebp),%eax
  100b63:	0f b6 00             	movzbl (%eax),%eax
  100b66:	0f be c0             	movsbl %al,%eax
  100b69:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b6d:	c7 04 24 3c 38 10 00 	movl   $0x10383c,(%esp)
  100b74:	e8 77 20 00 00       	call   102bf0 <strchr>
  100b79:	85 c0                	test   %eax,%eax
  100b7b:	75 cd                	jne    100b4a <parse+0xf>
        }
        if (*buf == '\0') {
  100b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  100b80:	0f b6 00             	movzbl (%eax),%eax
  100b83:	84 c0                	test   %al,%al
  100b85:	75 02                	jne    100b89 <parse+0x4e>
            break;
  100b87:	eb 67                	jmp    100bf0 <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100b89:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100b8d:	75 14                	jne    100ba3 <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100b8f:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100b96:	00 
  100b97:	c7 04 24 41 38 10 00 	movl   $0x103841,(%esp)
  100b9e:	e8 d8 f6 ff ff       	call   10027b <cprintf>
        }
        argv[argc ++] = buf;
  100ba3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ba6:	8d 50 01             	lea    0x1(%eax),%edx
  100ba9:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100bac:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100bb3:	8b 45 0c             	mov    0xc(%ebp),%eax
  100bb6:	01 c2                	add    %eax,%edx
  100bb8:	8b 45 08             	mov    0x8(%ebp),%eax
  100bbb:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100bbd:	eb 04                	jmp    100bc3 <parse+0x88>
            buf ++;
  100bbf:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100bc3:	8b 45 08             	mov    0x8(%ebp),%eax
  100bc6:	0f b6 00             	movzbl (%eax),%eax
  100bc9:	84 c0                	test   %al,%al
  100bcb:	74 1d                	je     100bea <parse+0xaf>
  100bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  100bd0:	0f b6 00             	movzbl (%eax),%eax
  100bd3:	0f be c0             	movsbl %al,%eax
  100bd6:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bda:	c7 04 24 3c 38 10 00 	movl   $0x10383c,(%esp)
  100be1:	e8 0a 20 00 00       	call   102bf0 <strchr>
  100be6:	85 c0                	test   %eax,%eax
  100be8:	74 d5                	je     100bbf <parse+0x84>
        }
    }
  100bea:	90                   	nop
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100beb:	e9 66 ff ff ff       	jmp    100b56 <parse+0x1b>
    return argc;
  100bf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100bf3:	c9                   	leave  
  100bf4:	c3                   	ret    

00100bf5 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100bf5:	55                   	push   %ebp
  100bf6:	89 e5                	mov    %esp,%ebp
  100bf8:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100bfb:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100bfe:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c02:	8b 45 08             	mov    0x8(%ebp),%eax
  100c05:	89 04 24             	mov    %eax,(%esp)
  100c08:	e8 2e ff ff ff       	call   100b3b <parse>
  100c0d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100c10:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100c14:	75 0a                	jne    100c20 <runcmd+0x2b>
        return 0;
  100c16:	b8 00 00 00 00       	mov    $0x0,%eax
  100c1b:	e9 85 00 00 00       	jmp    100ca5 <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c20:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c27:	eb 5c                	jmp    100c85 <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100c29:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100c2c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c2f:	89 d0                	mov    %edx,%eax
  100c31:	01 c0                	add    %eax,%eax
  100c33:	01 d0                	add    %edx,%eax
  100c35:	c1 e0 02             	shl    $0x2,%eax
  100c38:	05 00 e0 10 00       	add    $0x10e000,%eax
  100c3d:	8b 00                	mov    (%eax),%eax
  100c3f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100c43:	89 04 24             	mov    %eax,(%esp)
  100c46:	e8 06 1f 00 00       	call   102b51 <strcmp>
  100c4b:	85 c0                	test   %eax,%eax
  100c4d:	75 32                	jne    100c81 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100c4f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c52:	89 d0                	mov    %edx,%eax
  100c54:	01 c0                	add    %eax,%eax
  100c56:	01 d0                	add    %edx,%eax
  100c58:	c1 e0 02             	shl    $0x2,%eax
  100c5b:	05 00 e0 10 00       	add    $0x10e000,%eax
  100c60:	8b 40 08             	mov    0x8(%eax),%eax
  100c63:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100c66:	8d 4a ff             	lea    -0x1(%edx),%ecx
  100c69:	8b 55 0c             	mov    0xc(%ebp),%edx
  100c6c:	89 54 24 08          	mov    %edx,0x8(%esp)
  100c70:	8d 55 b0             	lea    -0x50(%ebp),%edx
  100c73:	83 c2 04             	add    $0x4,%edx
  100c76:	89 54 24 04          	mov    %edx,0x4(%esp)
  100c7a:	89 0c 24             	mov    %ecx,(%esp)
  100c7d:	ff d0                	call   *%eax
  100c7f:	eb 24                	jmp    100ca5 <runcmd+0xb0>
    for (i = 0; i < NCOMMANDS; i ++) {
  100c81:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100c85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c88:	83 f8 02             	cmp    $0x2,%eax
  100c8b:	76 9c                	jbe    100c29 <runcmd+0x34>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100c8d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100c90:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c94:	c7 04 24 5f 38 10 00 	movl   $0x10385f,(%esp)
  100c9b:	e8 db f5 ff ff       	call   10027b <cprintf>
    return 0;
  100ca0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100ca5:	c9                   	leave  
  100ca6:	c3                   	ret    

00100ca7 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100ca7:	55                   	push   %ebp
  100ca8:	89 e5                	mov    %esp,%ebp
  100caa:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100cad:	c7 04 24 78 38 10 00 	movl   $0x103878,(%esp)
  100cb4:	e8 c2 f5 ff ff       	call   10027b <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100cb9:	c7 04 24 a0 38 10 00 	movl   $0x1038a0,(%esp)
  100cc0:	e8 b6 f5 ff ff       	call   10027b <cprintf>

    if (tf != NULL) {
  100cc5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100cc9:	74 0b                	je     100cd6 <kmonitor+0x2f>
        print_trapframe(tf);
  100ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  100cce:	89 04 24             	mov    %eax,(%esp)
  100cd1:	e8 36 0d 00 00       	call   101a0c <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100cd6:	c7 04 24 c5 38 10 00 	movl   $0x1038c5,(%esp)
  100cdd:	e8 3a f6 ff ff       	call   10031c <readline>
  100ce2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100ce5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100ce9:	74 18                	je     100d03 <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
  100ceb:	8b 45 08             	mov    0x8(%ebp),%eax
  100cee:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100cf5:	89 04 24             	mov    %eax,(%esp)
  100cf8:	e8 f8 fe ff ff       	call   100bf5 <runcmd>
  100cfd:	85 c0                	test   %eax,%eax
  100cff:	79 02                	jns    100d03 <kmonitor+0x5c>
                break;
  100d01:	eb 02                	jmp    100d05 <kmonitor+0x5e>
            }
        }
    }
  100d03:	eb d1                	jmp    100cd6 <kmonitor+0x2f>
}
  100d05:	c9                   	leave  
  100d06:	c3                   	ret    

00100d07 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100d07:	55                   	push   %ebp
  100d08:	89 e5                	mov    %esp,%ebp
  100d0a:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100d0d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100d14:	eb 3f                	jmp    100d55 <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100d16:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100d19:	89 d0                	mov    %edx,%eax
  100d1b:	01 c0                	add    %eax,%eax
  100d1d:	01 d0                	add    %edx,%eax
  100d1f:	c1 e0 02             	shl    $0x2,%eax
  100d22:	05 00 e0 10 00       	add    $0x10e000,%eax
  100d27:	8b 48 04             	mov    0x4(%eax),%ecx
  100d2a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100d2d:	89 d0                	mov    %edx,%eax
  100d2f:	01 c0                	add    %eax,%eax
  100d31:	01 d0                	add    %edx,%eax
  100d33:	c1 e0 02             	shl    $0x2,%eax
  100d36:	05 00 e0 10 00       	add    $0x10e000,%eax
  100d3b:	8b 00                	mov    (%eax),%eax
  100d3d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100d41:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d45:	c7 04 24 c9 38 10 00 	movl   $0x1038c9,(%esp)
  100d4c:	e8 2a f5 ff ff       	call   10027b <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
  100d51:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100d55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d58:	83 f8 02             	cmp    $0x2,%eax
  100d5b:	76 b9                	jbe    100d16 <mon_help+0xf>
    }
    return 0;
  100d5d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d62:	c9                   	leave  
  100d63:	c3                   	ret    

00100d64 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100d64:	55                   	push   %ebp
  100d65:	89 e5                	mov    %esp,%ebp
  100d67:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100d6a:	e8 c3 fb ff ff       	call   100932 <print_kerninfo>
    return 0;
  100d6f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d74:	c9                   	leave  
  100d75:	c3                   	ret    

00100d76 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100d76:	55                   	push   %ebp
  100d77:	89 e5                	mov    %esp,%ebp
  100d79:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100d7c:	e8 fb fc ff ff       	call   100a7c <print_stackframe>
    return 0;
  100d81:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d86:	c9                   	leave  
  100d87:	c3                   	ret    

00100d88 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d88:	55                   	push   %ebp
  100d89:	89 e5                	mov    %esp,%ebp
  100d8b:	83 ec 28             	sub    $0x28,%esp
  100d8e:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100d94:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100d98:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100d9c:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100da0:	ee                   	out    %al,(%dx)
  100da1:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100da7:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100dab:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100daf:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100db3:	ee                   	out    %al,(%dx)
  100db4:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
  100dba:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
  100dbe:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100dc2:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100dc6:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100dc7:	c7 05 08 f9 10 00 00 	movl   $0x0,0x10f908
  100dce:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100dd1:	c7 04 24 d2 38 10 00 	movl   $0x1038d2,(%esp)
  100dd8:	e8 9e f4 ff ff       	call   10027b <cprintf>
    pic_enable(IRQ_TIMER);
  100ddd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100de4:	e8 b5 08 00 00       	call   10169e <pic_enable>
}
  100de9:	c9                   	leave  
  100dea:	c3                   	ret    

00100deb <delay>:
#include <picirq.h>
#include <trap.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100deb:	55                   	push   %ebp
  100dec:	89 e5                	mov    %esp,%ebp
  100dee:	83 ec 10             	sub    $0x10,%esp
  100df1:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100df7:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100dfb:	89 c2                	mov    %eax,%edx
  100dfd:	ec                   	in     (%dx),%al
  100dfe:	88 45 fd             	mov    %al,-0x3(%ebp)
  100e01:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100e07:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100e0b:	89 c2                	mov    %eax,%edx
  100e0d:	ec                   	in     (%dx),%al
  100e0e:	88 45 f9             	mov    %al,-0x7(%ebp)
  100e11:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100e17:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100e1b:	89 c2                	mov    %eax,%edx
  100e1d:	ec                   	in     (%dx),%al
  100e1e:	88 45 f5             	mov    %al,-0xb(%ebp)
  100e21:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
  100e27:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e2b:	89 c2                	mov    %eax,%edx
  100e2d:	ec                   	in     (%dx),%al
  100e2e:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e31:	c9                   	leave  
  100e32:	c3                   	ret    

00100e33 <cga_init>:
//    -- 数据寄存器 映射 到 端口 0x3D5或0x3B5 
//    -- 索引寄存器 0x3D4或0x3B4,决定在数据寄存器中的数据表示什么。

/* TEXT-mode CGA/VGA display output */
static void
cga_init(void) {
  100e33:	55                   	push   %ebp
  100e34:	89 e5                	mov    %esp,%ebp
  100e36:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;   //CGA_BUF: 0xB8000 (彩色显示的显存物理基址)
  100e39:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;                                            //保存当前显存0xB8000处的值
  100e40:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e43:	0f b7 00             	movzwl (%eax),%eax
  100e46:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;                                   // 给这个地址随便写个值，看看能否再读出同样的值
  100e4a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e4d:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {                                            // 如果读不出来，说明没有这块显存，即是单显配置
  100e52:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e55:	0f b7 00             	movzwl (%eax),%eax
  100e58:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100e5c:	74 12                	je     100e70 <cga_init+0x3d>
        cp = (uint16_t*)MONO_BUF;                         //设置为单显的显存基址 MONO_BUF： 0xB0000
  100e5e:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;                           //设置为单显控制的IO地址，MONO_BASE: 0x3B4
  100e65:	66 c7 05 66 ee 10 00 	movw   $0x3b4,0x10ee66
  100e6c:	b4 03 
  100e6e:	eb 13                	jmp    100e83 <cga_init+0x50>
    } else {                                                                // 如果读出来了，有这块显存，即是彩显配置
        *cp = was;                                                      //还原原来显存位置的值
  100e70:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e73:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100e77:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;                               // 设置为彩显控制的IO地址，CGA_BASE: 0x3D4 
  100e7a:	66 c7 05 66 ee 10 00 	movw   $0x3d4,0x10ee66
  100e81:	d4 03 
    // Extract cursor location
    // 6845索引寄存器的index 0x0E（及十进制的14）== 光标位置(高位)
    // 6845索引寄存器的index 0x0F（及十进制的15）== 光标位置(低位)
    // 6845 reg 15 : Cursor Address (Low Byte)
    uint32_t pos;
    outb(addr_6845, 14);                                        
  100e83:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e8a:	0f b7 c0             	movzwl %ax,%eax
  100e8d:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  100e91:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e95:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100e99:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100e9d:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;                       //读出了光标位置(高位)
  100e9e:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100ea5:	83 c0 01             	add    $0x1,%eax
  100ea8:	0f b7 c0             	movzwl %ax,%eax
  100eab:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100eaf:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100eb3:	89 c2                	mov    %eax,%edx
  100eb5:	ec                   	in     (%dx),%al
  100eb6:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100eb9:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100ebd:	0f b6 c0             	movzbl %al,%eax
  100ec0:	c1 e0 08             	shl    $0x8,%eax
  100ec3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100ec6:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100ecd:	0f b7 c0             	movzwl %ax,%eax
  100ed0:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  100ed4:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100ed8:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100edc:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100ee0:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);                             //读出了光标位置(低位)
  100ee1:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100ee8:	83 c0 01             	add    $0x1,%eax
  100eeb:	0f b7 c0             	movzwl %ax,%eax
  100eee:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100ef2:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  100ef6:	89 c2                	mov    %eax,%edx
  100ef8:	ec                   	in     (%dx),%al
  100ef9:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
  100efc:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f00:	0f b6 c0             	movzbl %al,%eax
  100f03:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;                                  //crt_buf是CGA显存起始地址
  100f06:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f09:	a3 60 ee 10 00       	mov    %eax,0x10ee60
    crt_pos = pos;                                                  //crt_pos是CGA当前光标位置
  100f0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100f11:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
}
  100f17:	c9                   	leave  
  100f18:	c3                   	ret    

00100f19 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100f19:	55                   	push   %ebp
  100f1a:	89 e5                	mov    %esp,%ebp
  100f1c:	83 ec 48             	sub    $0x48,%esp
  100f1f:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100f25:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f29:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100f2d:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100f31:	ee                   	out    %al,(%dx)
  100f32:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
  100f38:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
  100f3c:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f40:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100f44:	ee                   	out    %al,(%dx)
  100f45:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
  100f4b:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
  100f4f:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f53:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f57:	ee                   	out    %al,(%dx)
  100f58:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100f5e:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
  100f62:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f66:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f6a:	ee                   	out    %al,(%dx)
  100f6b:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
  100f71:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
  100f75:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f79:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100f7d:	ee                   	out    %al,(%dx)
  100f7e:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
  100f84:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
  100f88:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100f8c:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100f90:	ee                   	out    %al,(%dx)
  100f91:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100f97:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
  100f9b:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100f9f:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100fa3:	ee                   	out    %al,(%dx)
  100fa4:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100faa:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
  100fae:	89 c2                	mov    %eax,%edx
  100fb0:	ec                   	in     (%dx),%al
  100fb1:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
  100fb4:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100fb8:	3c ff                	cmp    $0xff,%al
  100fba:	0f 95 c0             	setne  %al
  100fbd:	0f b6 c0             	movzbl %al,%eax
  100fc0:	a3 68 ee 10 00       	mov    %eax,0x10ee68
  100fc5:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100fcb:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
  100fcf:	89 c2                	mov    %eax,%edx
  100fd1:	ec                   	in     (%dx),%al
  100fd2:	88 45 d5             	mov    %al,-0x2b(%ebp)
  100fd5:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
  100fdb:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
  100fdf:	89 c2                	mov    %eax,%edx
  100fe1:	ec                   	in     (%dx),%al
  100fe2:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  100fe5:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  100fea:	85 c0                	test   %eax,%eax
  100fec:	74 0c                	je     100ffa <serial_init+0xe1>
        pic_enable(IRQ_COM1);
  100fee:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  100ff5:	e8 a4 06 00 00       	call   10169e <pic_enable>
    }
}
  100ffa:	c9                   	leave  
  100ffb:	c3                   	ret    

00100ffc <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  100ffc:	55                   	push   %ebp
  100ffd:	89 e5                	mov    %esp,%ebp
  100fff:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101002:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101009:	eb 09                	jmp    101014 <lpt_putc_sub+0x18>
        delay();
  10100b:	e8 db fd ff ff       	call   100deb <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101010:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101014:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  10101a:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10101e:	89 c2                	mov    %eax,%edx
  101020:	ec                   	in     (%dx),%al
  101021:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101024:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101028:	84 c0                	test   %al,%al
  10102a:	78 09                	js     101035 <lpt_putc_sub+0x39>
  10102c:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101033:	7e d6                	jle    10100b <lpt_putc_sub+0xf>
    }
    outb(LPTPORT + 0, c);
  101035:	8b 45 08             	mov    0x8(%ebp),%eax
  101038:	0f b6 c0             	movzbl %al,%eax
  10103b:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
  101041:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101044:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101048:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10104c:	ee                   	out    %al,(%dx)
  10104d:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  101053:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  101057:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10105b:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10105f:	ee                   	out    %al,(%dx)
  101060:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
  101066:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
  10106a:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10106e:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101072:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  101073:	c9                   	leave  
  101074:	c3                   	ret    

00101075 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  101075:	55                   	push   %ebp
  101076:	89 e5                	mov    %esp,%ebp
  101078:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  10107b:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  10107f:	74 0d                	je     10108e <lpt_putc+0x19>
        lpt_putc_sub(c);
  101081:	8b 45 08             	mov    0x8(%ebp),%eax
  101084:	89 04 24             	mov    %eax,(%esp)
  101087:	e8 70 ff ff ff       	call   100ffc <lpt_putc_sub>
  10108c:	eb 24                	jmp    1010b2 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
  10108e:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101095:	e8 62 ff ff ff       	call   100ffc <lpt_putc_sub>
        lpt_putc_sub(' ');
  10109a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1010a1:	e8 56 ff ff ff       	call   100ffc <lpt_putc_sub>
        lpt_putc_sub('\b');
  1010a6:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010ad:	e8 4a ff ff ff       	call   100ffc <lpt_putc_sub>
    }
}
  1010b2:	c9                   	leave  
  1010b3:	c3                   	ret    

001010b4 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  1010b4:	55                   	push   %ebp
  1010b5:	89 e5                	mov    %esp,%ebp
  1010b7:	53                   	push   %ebx
  1010b8:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  1010bb:	8b 45 08             	mov    0x8(%ebp),%eax
  1010be:	b0 00                	mov    $0x0,%al
  1010c0:	85 c0                	test   %eax,%eax
  1010c2:	75 07                	jne    1010cb <cga_putc+0x17>
        c |= 0x0700;
  1010c4:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  1010cb:	8b 45 08             	mov    0x8(%ebp),%eax
  1010ce:	0f b6 c0             	movzbl %al,%eax
  1010d1:	83 f8 0a             	cmp    $0xa,%eax
  1010d4:	74 4c                	je     101122 <cga_putc+0x6e>
  1010d6:	83 f8 0d             	cmp    $0xd,%eax
  1010d9:	74 57                	je     101132 <cga_putc+0x7e>
  1010db:	83 f8 08             	cmp    $0x8,%eax
  1010de:	0f 85 88 00 00 00    	jne    10116c <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
  1010e4:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010eb:	66 85 c0             	test   %ax,%ax
  1010ee:	74 30                	je     101120 <cga_putc+0x6c>
            crt_pos --;
  1010f0:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010f7:	83 e8 01             	sub    $0x1,%eax
  1010fa:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  101100:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  101105:	0f b7 15 64 ee 10 00 	movzwl 0x10ee64,%edx
  10110c:	0f b7 d2             	movzwl %dx,%edx
  10110f:	01 d2                	add    %edx,%edx
  101111:	01 c2                	add    %eax,%edx
  101113:	8b 45 08             	mov    0x8(%ebp),%eax
  101116:	b0 00                	mov    $0x0,%al
  101118:	83 c8 20             	or     $0x20,%eax
  10111b:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  10111e:	eb 72                	jmp    101192 <cga_putc+0xde>
  101120:	eb 70                	jmp    101192 <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
  101122:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101129:	83 c0 50             	add    $0x50,%eax
  10112c:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  101132:	0f b7 1d 64 ee 10 00 	movzwl 0x10ee64,%ebx
  101139:	0f b7 0d 64 ee 10 00 	movzwl 0x10ee64,%ecx
  101140:	0f b7 c1             	movzwl %cx,%eax
  101143:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  101149:	c1 e8 10             	shr    $0x10,%eax
  10114c:	89 c2                	mov    %eax,%edx
  10114e:	66 c1 ea 06          	shr    $0x6,%dx
  101152:	89 d0                	mov    %edx,%eax
  101154:	c1 e0 02             	shl    $0x2,%eax
  101157:	01 d0                	add    %edx,%eax
  101159:	c1 e0 04             	shl    $0x4,%eax
  10115c:	29 c1                	sub    %eax,%ecx
  10115e:	89 ca                	mov    %ecx,%edx
  101160:	89 d8                	mov    %ebx,%eax
  101162:	29 d0                	sub    %edx,%eax
  101164:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
        break;
  10116a:	eb 26                	jmp    101192 <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  10116c:	8b 0d 60 ee 10 00    	mov    0x10ee60,%ecx
  101172:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101179:	8d 50 01             	lea    0x1(%eax),%edx
  10117c:	66 89 15 64 ee 10 00 	mov    %dx,0x10ee64
  101183:	0f b7 c0             	movzwl %ax,%eax
  101186:	01 c0                	add    %eax,%eax
  101188:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  10118b:	8b 45 08             	mov    0x8(%ebp),%eax
  10118e:	66 89 02             	mov    %ax,(%edx)
        break;
  101191:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  101192:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101199:	66 3d cf 07          	cmp    $0x7cf,%ax
  10119d:	76 5b                	jbe    1011fa <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  10119f:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  1011a4:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  1011aa:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  1011af:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  1011b6:	00 
  1011b7:	89 54 24 04          	mov    %edx,0x4(%esp)
  1011bb:	89 04 24             	mov    %eax,(%esp)
  1011be:	e8 2b 1c 00 00       	call   102dee <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011c3:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  1011ca:	eb 15                	jmp    1011e1 <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
  1011cc:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  1011d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1011d4:	01 d2                	add    %edx,%edx
  1011d6:	01 d0                	add    %edx,%eax
  1011d8:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011dd:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1011e1:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  1011e8:	7e e2                	jle    1011cc <cga_putc+0x118>
        }
        crt_pos -= CRT_COLS;
  1011ea:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1011f1:	83 e8 50             	sub    $0x50,%eax
  1011f4:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  1011fa:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  101201:	0f b7 c0             	movzwl %ax,%eax
  101204:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  101208:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
  10120c:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101210:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101214:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  101215:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  10121c:	66 c1 e8 08          	shr    $0x8,%ax
  101220:	0f b6 c0             	movzbl %al,%eax
  101223:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  10122a:	83 c2 01             	add    $0x1,%edx
  10122d:	0f b7 d2             	movzwl %dx,%edx
  101230:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
  101234:	88 45 ed             	mov    %al,-0x13(%ebp)
  101237:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10123b:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10123f:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  101240:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  101247:	0f b7 c0             	movzwl %ax,%eax
  10124a:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  10124e:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
  101252:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101256:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10125a:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  10125b:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101262:	0f b6 c0             	movzbl %al,%eax
  101265:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  10126c:	83 c2 01             	add    $0x1,%edx
  10126f:	0f b7 d2             	movzwl %dx,%edx
  101272:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
  101276:	88 45 e5             	mov    %al,-0x1b(%ebp)
  101279:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  10127d:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101281:	ee                   	out    %al,(%dx)
}
  101282:	83 c4 34             	add    $0x34,%esp
  101285:	5b                   	pop    %ebx
  101286:	5d                   	pop    %ebp
  101287:	c3                   	ret    

00101288 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  101288:	55                   	push   %ebp
  101289:	89 e5                	mov    %esp,%ebp
  10128b:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  10128e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101295:	eb 09                	jmp    1012a0 <serial_putc_sub+0x18>
        delay();
  101297:	e8 4f fb ff ff       	call   100deb <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  10129c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1012a0:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1012a6:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1012aa:	89 c2                	mov    %eax,%edx
  1012ac:	ec                   	in     (%dx),%al
  1012ad:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1012b0:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1012b4:	0f b6 c0             	movzbl %al,%eax
  1012b7:	83 e0 20             	and    $0x20,%eax
  1012ba:	85 c0                	test   %eax,%eax
  1012bc:	75 09                	jne    1012c7 <serial_putc_sub+0x3f>
  1012be:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  1012c5:	7e d0                	jle    101297 <serial_putc_sub+0xf>
    }
    outb(COM1 + COM_TX, c);
  1012c7:	8b 45 08             	mov    0x8(%ebp),%eax
  1012ca:	0f b6 c0             	movzbl %al,%eax
  1012cd:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  1012d3:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1012d6:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1012da:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1012de:	ee                   	out    %al,(%dx)
}
  1012df:	c9                   	leave  
  1012e0:	c3                   	ret    

001012e1 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  1012e1:	55                   	push   %ebp
  1012e2:	89 e5                	mov    %esp,%ebp
  1012e4:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1012e7:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1012eb:	74 0d                	je     1012fa <serial_putc+0x19>
        serial_putc_sub(c);
  1012ed:	8b 45 08             	mov    0x8(%ebp),%eax
  1012f0:	89 04 24             	mov    %eax,(%esp)
  1012f3:	e8 90 ff ff ff       	call   101288 <serial_putc_sub>
  1012f8:	eb 24                	jmp    10131e <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
  1012fa:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101301:	e8 82 ff ff ff       	call   101288 <serial_putc_sub>
        serial_putc_sub(' ');
  101306:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  10130d:	e8 76 ff ff ff       	call   101288 <serial_putc_sub>
        serial_putc_sub('\b');
  101312:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101319:	e8 6a ff ff ff       	call   101288 <serial_putc_sub>
    }
}
  10131e:	c9                   	leave  
  10131f:	c3                   	ret    

00101320 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  101320:	55                   	push   %ebp
  101321:	89 e5                	mov    %esp,%ebp
  101323:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  101326:	eb 33                	jmp    10135b <cons_intr+0x3b>
        if (c != 0) {
  101328:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10132c:	74 2d                	je     10135b <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  10132e:	a1 84 f0 10 00       	mov    0x10f084,%eax
  101333:	8d 50 01             	lea    0x1(%eax),%edx
  101336:	89 15 84 f0 10 00    	mov    %edx,0x10f084
  10133c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10133f:	88 90 80 ee 10 00    	mov    %dl,0x10ee80(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  101345:	a1 84 f0 10 00       	mov    0x10f084,%eax
  10134a:	3d 00 02 00 00       	cmp    $0x200,%eax
  10134f:	75 0a                	jne    10135b <cons_intr+0x3b>
                cons.wpos = 0;
  101351:	c7 05 84 f0 10 00 00 	movl   $0x0,0x10f084
  101358:	00 00 00 
    while ((c = (*proc)()) != -1) {
  10135b:	8b 45 08             	mov    0x8(%ebp),%eax
  10135e:	ff d0                	call   *%eax
  101360:	89 45 f4             	mov    %eax,-0xc(%ebp)
  101363:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  101367:	75 bf                	jne    101328 <cons_intr+0x8>
            }
        }
    }
}
  101369:	c9                   	leave  
  10136a:	c3                   	ret    

0010136b <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  10136b:	55                   	push   %ebp
  10136c:	89 e5                	mov    %esp,%ebp
  10136e:	83 ec 10             	sub    $0x10,%esp
  101371:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101377:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10137b:	89 c2                	mov    %eax,%edx
  10137d:	ec                   	in     (%dx),%al
  10137e:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101381:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  101385:	0f b6 c0             	movzbl %al,%eax
  101388:	83 e0 01             	and    $0x1,%eax
  10138b:	85 c0                	test   %eax,%eax
  10138d:	75 07                	jne    101396 <serial_proc_data+0x2b>
        return -1;
  10138f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101394:	eb 2a                	jmp    1013c0 <serial_proc_data+0x55>
  101396:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10139c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  1013a0:	89 c2                	mov    %eax,%edx
  1013a2:	ec                   	in     (%dx),%al
  1013a3:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  1013a6:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  1013aa:	0f b6 c0             	movzbl %al,%eax
  1013ad:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  1013b0:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  1013b4:	75 07                	jne    1013bd <serial_proc_data+0x52>
        c = '\b';
  1013b6:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  1013bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1013c0:	c9                   	leave  
  1013c1:	c3                   	ret    

001013c2 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  1013c2:	55                   	push   %ebp
  1013c3:	89 e5                	mov    %esp,%ebp
  1013c5:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  1013c8:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  1013cd:	85 c0                	test   %eax,%eax
  1013cf:	74 0c                	je     1013dd <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  1013d1:	c7 04 24 6b 13 10 00 	movl   $0x10136b,(%esp)
  1013d8:	e8 43 ff ff ff       	call   101320 <cons_intr>
    }
}
  1013dd:	c9                   	leave  
  1013de:	c3                   	ret    

001013df <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  1013df:	55                   	push   %ebp
  1013e0:	89 e5                	mov    %esp,%ebp
  1013e2:	83 ec 38             	sub    $0x38,%esp
  1013e5:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013eb:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1013ef:	89 c2                	mov    %eax,%edx
  1013f1:	ec                   	in     (%dx),%al
  1013f2:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  1013f5:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  1013f9:	0f b6 c0             	movzbl %al,%eax
  1013fc:	83 e0 01             	and    $0x1,%eax
  1013ff:	85 c0                	test   %eax,%eax
  101401:	75 0a                	jne    10140d <kbd_proc_data+0x2e>
        return -1;
  101403:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101408:	e9 59 01 00 00       	jmp    101566 <kbd_proc_data+0x187>
  10140d:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101413:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101417:	89 c2                	mov    %eax,%edx
  101419:	ec                   	in     (%dx),%al
  10141a:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  10141d:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  101421:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  101424:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  101428:	75 17                	jne    101441 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  10142a:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10142f:	83 c8 40             	or     $0x40,%eax
  101432:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  101437:	b8 00 00 00 00       	mov    $0x0,%eax
  10143c:	e9 25 01 00 00       	jmp    101566 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
  101441:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101445:	84 c0                	test   %al,%al
  101447:	79 47                	jns    101490 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  101449:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10144e:	83 e0 40             	and    $0x40,%eax
  101451:	85 c0                	test   %eax,%eax
  101453:	75 09                	jne    10145e <kbd_proc_data+0x7f>
  101455:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101459:	83 e0 7f             	and    $0x7f,%eax
  10145c:	eb 04                	jmp    101462 <kbd_proc_data+0x83>
  10145e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101462:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  101465:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101469:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  101470:	83 c8 40             	or     $0x40,%eax
  101473:	0f b6 c0             	movzbl %al,%eax
  101476:	f7 d0                	not    %eax
  101478:	89 c2                	mov    %eax,%edx
  10147a:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10147f:	21 d0                	and    %edx,%eax
  101481:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  101486:	b8 00 00 00 00       	mov    $0x0,%eax
  10148b:	e9 d6 00 00 00       	jmp    101566 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
  101490:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101495:	83 e0 40             	and    $0x40,%eax
  101498:	85 c0                	test   %eax,%eax
  10149a:	74 11                	je     1014ad <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  10149c:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  1014a0:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014a5:	83 e0 bf             	and    $0xffffffbf,%eax
  1014a8:	a3 88 f0 10 00       	mov    %eax,0x10f088
    }

    shift |= shiftcode[data];
  1014ad:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014b1:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  1014b8:	0f b6 d0             	movzbl %al,%edx
  1014bb:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014c0:	09 d0                	or     %edx,%eax
  1014c2:	a3 88 f0 10 00       	mov    %eax,0x10f088
    shift ^= togglecode[data];
  1014c7:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014cb:	0f b6 80 40 e1 10 00 	movzbl 0x10e140(%eax),%eax
  1014d2:	0f b6 d0             	movzbl %al,%edx
  1014d5:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014da:	31 d0                	xor    %edx,%eax
  1014dc:	a3 88 f0 10 00       	mov    %eax,0x10f088

    c = charcode[shift & (CTL | SHIFT)][data];
  1014e1:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014e6:	83 e0 03             	and    $0x3,%eax
  1014e9:	8b 14 85 40 e5 10 00 	mov    0x10e540(,%eax,4),%edx
  1014f0:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014f4:	01 d0                	add    %edx,%eax
  1014f6:	0f b6 00             	movzbl (%eax),%eax
  1014f9:	0f b6 c0             	movzbl %al,%eax
  1014fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  1014ff:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101504:	83 e0 08             	and    $0x8,%eax
  101507:	85 c0                	test   %eax,%eax
  101509:	74 22                	je     10152d <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  10150b:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  10150f:	7e 0c                	jle    10151d <kbd_proc_data+0x13e>
  101511:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  101515:	7f 06                	jg     10151d <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  101517:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  10151b:	eb 10                	jmp    10152d <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  10151d:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  101521:	7e 0a                	jle    10152d <kbd_proc_data+0x14e>
  101523:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  101527:	7f 04                	jg     10152d <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  101529:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  10152d:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101532:	f7 d0                	not    %eax
  101534:	83 e0 06             	and    $0x6,%eax
  101537:	85 c0                	test   %eax,%eax
  101539:	75 28                	jne    101563 <kbd_proc_data+0x184>
  10153b:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  101542:	75 1f                	jne    101563 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
  101544:	c7 04 24 ed 38 10 00 	movl   $0x1038ed,(%esp)
  10154b:	e8 2b ed ff ff       	call   10027b <cprintf>
  101550:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  101556:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10155a:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  10155e:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  101562:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  101563:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  101566:	c9                   	leave  
  101567:	c3                   	ret    

00101568 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  101568:	55                   	push   %ebp
  101569:	89 e5                	mov    %esp,%ebp
  10156b:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  10156e:	c7 04 24 df 13 10 00 	movl   $0x1013df,(%esp)
  101575:	e8 a6 fd ff ff       	call   101320 <cons_intr>
}
  10157a:	c9                   	leave  
  10157b:	c3                   	ret    

0010157c <kbd_init>:

static void
kbd_init(void) {
  10157c:	55                   	push   %ebp
  10157d:	89 e5                	mov    %esp,%ebp
  10157f:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  101582:	e8 e1 ff ff ff       	call   101568 <kbd_intr>
    pic_enable(IRQ_KBD);
  101587:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10158e:	e8 0b 01 00 00       	call   10169e <pic_enable>
}
  101593:	c9                   	leave  
  101594:	c3                   	ret    

00101595 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  101595:	55                   	push   %ebp
  101596:	89 e5                	mov    %esp,%ebp
  101598:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  10159b:	e8 93 f8 ff ff       	call   100e33 <cga_init>
    serial_init();
  1015a0:	e8 74 f9 ff ff       	call   100f19 <serial_init>
    kbd_init();
  1015a5:	e8 d2 ff ff ff       	call   10157c <kbd_init>
    if (!serial_exists) {
  1015aa:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  1015af:	85 c0                	test   %eax,%eax
  1015b1:	75 0c                	jne    1015bf <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  1015b3:	c7 04 24 f9 38 10 00 	movl   $0x1038f9,(%esp)
  1015ba:	e8 bc ec ff ff       	call   10027b <cprintf>
    }
}
  1015bf:	c9                   	leave  
  1015c0:	c3                   	ret    

001015c1 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  1015c1:	55                   	push   %ebp
  1015c2:	89 e5                	mov    %esp,%ebp
  1015c4:	83 ec 18             	sub    $0x18,%esp
    lpt_putc(c);
  1015c7:	8b 45 08             	mov    0x8(%ebp),%eax
  1015ca:	89 04 24             	mov    %eax,(%esp)
  1015cd:	e8 a3 fa ff ff       	call   101075 <lpt_putc>
    cga_putc(c);
  1015d2:	8b 45 08             	mov    0x8(%ebp),%eax
  1015d5:	89 04 24             	mov    %eax,(%esp)
  1015d8:	e8 d7 fa ff ff       	call   1010b4 <cga_putc>
    serial_putc(c);
  1015dd:	8b 45 08             	mov    0x8(%ebp),%eax
  1015e0:	89 04 24             	mov    %eax,(%esp)
  1015e3:	e8 f9 fc ff ff       	call   1012e1 <serial_putc>
}
  1015e8:	c9                   	leave  
  1015e9:	c3                   	ret    

001015ea <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  1015ea:	55                   	push   %ebp
  1015eb:	89 e5                	mov    %esp,%ebp
  1015ed:	83 ec 18             	sub    $0x18,%esp
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  1015f0:	e8 cd fd ff ff       	call   1013c2 <serial_intr>
    kbd_intr();
  1015f5:	e8 6e ff ff ff       	call   101568 <kbd_intr>

    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  1015fa:	8b 15 80 f0 10 00    	mov    0x10f080,%edx
  101600:	a1 84 f0 10 00       	mov    0x10f084,%eax
  101605:	39 c2                	cmp    %eax,%edx
  101607:	74 36                	je     10163f <cons_getc+0x55>
        c = cons.buf[cons.rpos ++];
  101609:	a1 80 f0 10 00       	mov    0x10f080,%eax
  10160e:	8d 50 01             	lea    0x1(%eax),%edx
  101611:	89 15 80 f0 10 00    	mov    %edx,0x10f080
  101617:	0f b6 80 80 ee 10 00 	movzbl 0x10ee80(%eax),%eax
  10161e:	0f b6 c0             	movzbl %al,%eax
  101621:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (cons.rpos == CONSBUFSIZE) {
  101624:	a1 80 f0 10 00       	mov    0x10f080,%eax
  101629:	3d 00 02 00 00       	cmp    $0x200,%eax
  10162e:	75 0a                	jne    10163a <cons_getc+0x50>
            cons.rpos = 0;
  101630:	c7 05 80 f0 10 00 00 	movl   $0x0,0x10f080
  101637:	00 00 00 
        }
        return c;
  10163a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10163d:	eb 05                	jmp    101644 <cons_getc+0x5a>
    }
    return 0;
  10163f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  101644:	c9                   	leave  
  101645:	c3                   	ret    

00101646 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  101646:	55                   	push   %ebp
  101647:	89 e5                	mov    %esp,%ebp
  101649:	83 ec 14             	sub    $0x14,%esp
  10164c:	8b 45 08             	mov    0x8(%ebp),%eax
  10164f:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  101653:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101657:	66 a3 50 e5 10 00    	mov    %ax,0x10e550
    if (did_init) {
  10165d:	a1 8c f0 10 00       	mov    0x10f08c,%eax
  101662:	85 c0                	test   %eax,%eax
  101664:	74 36                	je     10169c <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  101666:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10166a:	0f b6 c0             	movzbl %al,%eax
  10166d:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  101673:	88 45 fd             	mov    %al,-0x3(%ebp)
  101676:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  10167a:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  10167e:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  10167f:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101683:	66 c1 e8 08          	shr    $0x8,%ax
  101687:	0f b6 c0             	movzbl %al,%eax
  10168a:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  101690:	88 45 f9             	mov    %al,-0x7(%ebp)
  101693:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101697:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10169b:	ee                   	out    %al,(%dx)
    }
}
  10169c:	c9                   	leave  
  10169d:	c3                   	ret    

0010169e <pic_enable>:

void
pic_enable(unsigned int irq) {
  10169e:	55                   	push   %ebp
  10169f:	89 e5                	mov    %esp,%ebp
  1016a1:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  1016a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1016a7:	ba 01 00 00 00       	mov    $0x1,%edx
  1016ac:	89 c1                	mov    %eax,%ecx
  1016ae:	d3 e2                	shl    %cl,%edx
  1016b0:	89 d0                	mov    %edx,%eax
  1016b2:	f7 d0                	not    %eax
  1016b4:	89 c2                	mov    %eax,%edx
  1016b6:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1016bd:	21 d0                	and    %edx,%eax
  1016bf:	0f b7 c0             	movzwl %ax,%eax
  1016c2:	89 04 24             	mov    %eax,(%esp)
  1016c5:	e8 7c ff ff ff       	call   101646 <pic_setmask>
}
  1016ca:	c9                   	leave  
  1016cb:	c3                   	ret    

001016cc <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  1016cc:	55                   	push   %ebp
  1016cd:	89 e5                	mov    %esp,%ebp
  1016cf:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  1016d2:	c7 05 8c f0 10 00 01 	movl   $0x1,0x10f08c
  1016d9:	00 00 00 
  1016dc:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  1016e2:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
  1016e6:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1016ea:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1016ee:	ee                   	out    %al,(%dx)
  1016ef:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  1016f5:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
  1016f9:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1016fd:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101701:	ee                   	out    %al,(%dx)
  101702:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  101708:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
  10170c:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101710:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101714:	ee                   	out    %al,(%dx)
  101715:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
  10171b:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
  10171f:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101723:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101727:	ee                   	out    %al,(%dx)
  101728:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
  10172e:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
  101732:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101736:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10173a:	ee                   	out    %al,(%dx)
  10173b:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
  101741:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
  101745:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101749:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10174d:	ee                   	out    %al,(%dx)
  10174e:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  101754:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
  101758:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  10175c:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101760:	ee                   	out    %al,(%dx)
  101761:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
  101767:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
  10176b:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  10176f:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  101773:	ee                   	out    %al,(%dx)
  101774:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
  10177a:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
  10177e:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  101782:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  101786:	ee                   	out    %al,(%dx)
  101787:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
  10178d:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
  101791:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  101795:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  101799:	ee                   	out    %al,(%dx)
  10179a:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
  1017a0:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
  1017a4:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  1017a8:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  1017ac:	ee                   	out    %al,(%dx)
  1017ad:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  1017b3:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
  1017b7:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  1017bb:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  1017bf:	ee                   	out    %al,(%dx)
  1017c0:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
  1017c6:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
  1017ca:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  1017ce:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  1017d2:	ee                   	out    %al,(%dx)
  1017d3:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
  1017d9:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
  1017dd:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  1017e1:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  1017e5:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  1017e6:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017ed:	66 83 f8 ff          	cmp    $0xffff,%ax
  1017f1:	74 12                	je     101805 <pic_init+0x139>
        pic_setmask(irq_mask);
  1017f3:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017fa:	0f b7 c0             	movzwl %ax,%eax
  1017fd:	89 04 24             	mov    %eax,(%esp)
  101800:	e8 41 fe ff ff       	call   101646 <pic_setmask>
    }
}
  101805:	c9                   	leave  
  101806:	c3                   	ret    

00101807 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  101807:	55                   	push   %ebp
  101808:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd));
}

static inline void
sti(void) {
    asm volatile ("sti");
  10180a:	fb                   	sti    
    sti();
}
  10180b:	5d                   	pop    %ebp
  10180c:	c3                   	ret    

0010180d <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  10180d:	55                   	push   %ebp
  10180e:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli");
  101810:	fa                   	cli    
    cli();
}
  101811:	5d                   	pop    %ebp
  101812:	c3                   	ret    

00101813 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  101813:	55                   	push   %ebp
  101814:	89 e5                	mov    %esp,%ebp
  101816:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  101819:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  101820:	00 
  101821:	c7 04 24 20 39 10 00 	movl   $0x103920,(%esp)
  101828:	e8 4e ea ff ff       	call   10027b <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
  10182d:	c7 04 24 2a 39 10 00 	movl   $0x10392a,(%esp)
  101834:	e8 42 ea ff ff       	call   10027b <cprintf>
    panic("EOT: kernel seems ok.");
  101839:	c7 44 24 08 38 39 10 	movl   $0x103938,0x8(%esp)
  101840:	00 
  101841:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
  101848:	00 
  101849:	c7 04 24 4e 39 10 00 	movl   $0x10394e,(%esp)
  101850:	e8 7d eb ff ff       	call   1003d2 <__panic>

00101855 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  101855:	55                   	push   %ebp
  101856:	89 e5                	mov    %esp,%ebp
  101858:	83 ec 10             	sub    $0x10,%esp
      */

	extern uintptr_t __vectors[];

	uint32_t i;
	for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++)
  10185b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101862:	e9 c3 00 00 00       	jmp    10192a <idt_init+0xd5>
	{
		SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  101867:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10186a:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  101871:	89 c2                	mov    %eax,%edx
  101873:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101876:	66 89 14 c5 a0 f0 10 	mov    %dx,0x10f0a0(,%eax,8)
  10187d:	00 
  10187e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101881:	66 c7 04 c5 a2 f0 10 	movw   $0x8,0x10f0a2(,%eax,8)
  101888:	00 08 00 
  10188b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10188e:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  101895:	00 
  101896:	83 e2 e0             	and    $0xffffffe0,%edx
  101899:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  1018a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018a3:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  1018aa:	00 
  1018ab:	83 e2 1f             	and    $0x1f,%edx
  1018ae:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  1018b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018b8:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018bf:	00 
  1018c0:	83 e2 f0             	and    $0xfffffff0,%edx
  1018c3:	83 ca 0e             	or     $0xe,%edx
  1018c6:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018d0:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018d7:	00 
  1018d8:	83 e2 ef             	and    $0xffffffef,%edx
  1018db:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018e5:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018ec:	00 
  1018ed:	83 e2 9f             	and    $0xffffff9f,%edx
  1018f0:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018fa:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  101901:	00 
  101902:	83 ca 80             	or     $0xffffff80,%edx
  101905:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  10190c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10190f:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  101916:	c1 e8 10             	shr    $0x10,%eax
  101919:	89 c2                	mov    %eax,%edx
  10191b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10191e:	66 89 14 c5 a6 f0 10 	mov    %dx,0x10f0a6(,%eax,8)
  101925:	00 
	for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++)
  101926:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10192a:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
  101931:	0f 86 30 ff ff ff    	jbe    101867 <idt_init+0x12>
	}

	// set for switch from user to kernel
	SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
  101937:	a1 c4 e7 10 00       	mov    0x10e7c4,%eax
  10193c:	66 a3 68 f4 10 00    	mov    %ax,0x10f468
  101942:	66 c7 05 6a f4 10 00 	movw   $0x8,0x10f46a
  101949:	08 00 
  10194b:	0f b6 05 6c f4 10 00 	movzbl 0x10f46c,%eax
  101952:	83 e0 e0             	and    $0xffffffe0,%eax
  101955:	a2 6c f4 10 00       	mov    %al,0x10f46c
  10195a:	0f b6 05 6c f4 10 00 	movzbl 0x10f46c,%eax
  101961:	83 e0 1f             	and    $0x1f,%eax
  101964:	a2 6c f4 10 00       	mov    %al,0x10f46c
  101969:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  101970:	83 e0 f0             	and    $0xfffffff0,%eax
  101973:	83 c8 0e             	or     $0xe,%eax
  101976:	a2 6d f4 10 00       	mov    %al,0x10f46d
  10197b:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  101982:	83 e0 ef             	and    $0xffffffef,%eax
  101985:	a2 6d f4 10 00       	mov    %al,0x10f46d
  10198a:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  101991:	83 c8 60             	or     $0x60,%eax
  101994:	a2 6d f4 10 00       	mov    %al,0x10f46d
  101999:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  1019a0:	83 c8 80             	or     $0xffffff80,%eax
  1019a3:	a2 6d f4 10 00       	mov    %al,0x10f46d
  1019a8:	a1 c4 e7 10 00       	mov    0x10e7c4,%eax
  1019ad:	c1 e8 10             	shr    $0x10,%eax
  1019b0:	66 a3 6e f4 10 00    	mov    %ax,0x10f46e
  1019b6:	c7 45 f8 60 e5 10 00 	movl   $0x10e560,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd));
  1019bd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1019c0:	0f 01 18             	lidtl  (%eax)

	// idt 存储了具体的信息， idtpd，作为一个结构体，将idt进行了进一步封装，这种写法很常见
	lidt(&idt_pd);


}
  1019c3:	c9                   	leave  
  1019c4:	c3                   	ret    

001019c5 <trapname>:

static const char *
trapname(int trapno) {
  1019c5:	55                   	push   %ebp
  1019c6:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  1019c8:	8b 45 08             	mov    0x8(%ebp),%eax
  1019cb:	83 f8 13             	cmp    $0x13,%eax
  1019ce:	77 0c                	ja     1019dc <trapname+0x17>
        return excnames[trapno];
  1019d0:	8b 45 08             	mov    0x8(%ebp),%eax
  1019d3:	8b 04 85 a0 3c 10 00 	mov    0x103ca0(,%eax,4),%eax
  1019da:	eb 18                	jmp    1019f4 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  1019dc:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  1019e0:	7e 0d                	jle    1019ef <trapname+0x2a>
  1019e2:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  1019e6:	7f 07                	jg     1019ef <trapname+0x2a>
        return "Hardware Interrupt";
  1019e8:	b8 5f 39 10 00       	mov    $0x10395f,%eax
  1019ed:	eb 05                	jmp    1019f4 <trapname+0x2f>
    }
    return "(unknown trap)";
  1019ef:	b8 72 39 10 00       	mov    $0x103972,%eax
}
  1019f4:	5d                   	pop    %ebp
  1019f5:	c3                   	ret    

001019f6 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  1019f6:	55                   	push   %ebp
  1019f7:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  1019f9:	8b 45 08             	mov    0x8(%ebp),%eax
  1019fc:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101a00:	66 83 f8 08          	cmp    $0x8,%ax
  101a04:	0f 94 c0             	sete   %al
  101a07:	0f b6 c0             	movzbl %al,%eax
}
  101a0a:	5d                   	pop    %ebp
  101a0b:	c3                   	ret    

00101a0c <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101a0c:	55                   	push   %ebp
  101a0d:	89 e5                	mov    %esp,%ebp
  101a0f:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101a12:	8b 45 08             	mov    0x8(%ebp),%eax
  101a15:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a19:	c7 04 24 b3 39 10 00 	movl   $0x1039b3,(%esp)
  101a20:	e8 56 e8 ff ff       	call   10027b <cprintf>
    print_regs(&tf->tf_regs);
  101a25:	8b 45 08             	mov    0x8(%ebp),%eax
  101a28:	89 04 24             	mov    %eax,(%esp)
  101a2b:	e8 a1 01 00 00       	call   101bd1 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101a30:	8b 45 08             	mov    0x8(%ebp),%eax
  101a33:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101a37:	0f b7 c0             	movzwl %ax,%eax
  101a3a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a3e:	c7 04 24 c4 39 10 00 	movl   $0x1039c4,(%esp)
  101a45:	e8 31 e8 ff ff       	call   10027b <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  101a4d:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101a51:	0f b7 c0             	movzwl %ax,%eax
  101a54:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a58:	c7 04 24 d7 39 10 00 	movl   $0x1039d7,(%esp)
  101a5f:	e8 17 e8 ff ff       	call   10027b <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101a64:	8b 45 08             	mov    0x8(%ebp),%eax
  101a67:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101a6b:	0f b7 c0             	movzwl %ax,%eax
  101a6e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a72:	c7 04 24 ea 39 10 00 	movl   $0x1039ea,(%esp)
  101a79:	e8 fd e7 ff ff       	call   10027b <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101a7e:	8b 45 08             	mov    0x8(%ebp),%eax
  101a81:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101a85:	0f b7 c0             	movzwl %ax,%eax
  101a88:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a8c:	c7 04 24 fd 39 10 00 	movl   $0x1039fd,(%esp)
  101a93:	e8 e3 e7 ff ff       	call   10027b <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101a98:	8b 45 08             	mov    0x8(%ebp),%eax
  101a9b:	8b 40 30             	mov    0x30(%eax),%eax
  101a9e:	89 04 24             	mov    %eax,(%esp)
  101aa1:	e8 1f ff ff ff       	call   1019c5 <trapname>
  101aa6:	8b 55 08             	mov    0x8(%ebp),%edx
  101aa9:	8b 52 30             	mov    0x30(%edx),%edx
  101aac:	89 44 24 08          	mov    %eax,0x8(%esp)
  101ab0:	89 54 24 04          	mov    %edx,0x4(%esp)
  101ab4:	c7 04 24 10 3a 10 00 	movl   $0x103a10,(%esp)
  101abb:	e8 bb e7 ff ff       	call   10027b <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101ac0:	8b 45 08             	mov    0x8(%ebp),%eax
  101ac3:	8b 40 34             	mov    0x34(%eax),%eax
  101ac6:	89 44 24 04          	mov    %eax,0x4(%esp)
  101aca:	c7 04 24 22 3a 10 00 	movl   $0x103a22,(%esp)
  101ad1:	e8 a5 e7 ff ff       	call   10027b <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101ad6:	8b 45 08             	mov    0x8(%ebp),%eax
  101ad9:	8b 40 38             	mov    0x38(%eax),%eax
  101adc:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ae0:	c7 04 24 31 3a 10 00 	movl   $0x103a31,(%esp)
  101ae7:	e8 8f e7 ff ff       	call   10027b <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101aec:	8b 45 08             	mov    0x8(%ebp),%eax
  101aef:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101af3:	0f b7 c0             	movzwl %ax,%eax
  101af6:	89 44 24 04          	mov    %eax,0x4(%esp)
  101afa:	c7 04 24 40 3a 10 00 	movl   $0x103a40,(%esp)
  101b01:	e8 75 e7 ff ff       	call   10027b <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101b06:	8b 45 08             	mov    0x8(%ebp),%eax
  101b09:	8b 40 40             	mov    0x40(%eax),%eax
  101b0c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b10:	c7 04 24 53 3a 10 00 	movl   $0x103a53,(%esp)
  101b17:	e8 5f e7 ff ff       	call   10027b <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b1c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101b23:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101b2a:	eb 3e                	jmp    101b6a <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  101b2f:	8b 50 40             	mov    0x40(%eax),%edx
  101b32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101b35:	21 d0                	and    %edx,%eax
  101b37:	85 c0                	test   %eax,%eax
  101b39:	74 28                	je     101b63 <print_trapframe+0x157>
  101b3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b3e:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101b45:	85 c0                	test   %eax,%eax
  101b47:	74 1a                	je     101b63 <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
  101b49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b4c:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101b53:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b57:	c7 04 24 62 3a 10 00 	movl   $0x103a62,(%esp)
  101b5e:	e8 18 e7 ff ff       	call   10027b <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b63:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101b67:	d1 65 f0             	shll   -0x10(%ebp)
  101b6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b6d:	83 f8 17             	cmp    $0x17,%eax
  101b70:	76 ba                	jbe    101b2c <print_trapframe+0x120>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101b72:	8b 45 08             	mov    0x8(%ebp),%eax
  101b75:	8b 40 40             	mov    0x40(%eax),%eax
  101b78:	25 00 30 00 00       	and    $0x3000,%eax
  101b7d:	c1 e8 0c             	shr    $0xc,%eax
  101b80:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b84:	c7 04 24 66 3a 10 00 	movl   $0x103a66,(%esp)
  101b8b:	e8 eb e6 ff ff       	call   10027b <cprintf>

    if (!trap_in_kernel(tf)) {
  101b90:	8b 45 08             	mov    0x8(%ebp),%eax
  101b93:	89 04 24             	mov    %eax,(%esp)
  101b96:	e8 5b fe ff ff       	call   1019f6 <trap_in_kernel>
  101b9b:	85 c0                	test   %eax,%eax
  101b9d:	75 30                	jne    101bcf <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  101ba2:	8b 40 44             	mov    0x44(%eax),%eax
  101ba5:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ba9:	c7 04 24 6f 3a 10 00 	movl   $0x103a6f,(%esp)
  101bb0:	e8 c6 e6 ff ff       	call   10027b <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  101bb8:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101bbc:	0f b7 c0             	movzwl %ax,%eax
  101bbf:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bc3:	c7 04 24 7e 3a 10 00 	movl   $0x103a7e,(%esp)
  101bca:	e8 ac e6 ff ff       	call   10027b <cprintf>
    }
}
  101bcf:	c9                   	leave  
  101bd0:	c3                   	ret    

00101bd1 <print_regs>:

void
print_regs(struct pushregs *regs) {
  101bd1:	55                   	push   %ebp
  101bd2:	89 e5                	mov    %esp,%ebp
  101bd4:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101bd7:	8b 45 08             	mov    0x8(%ebp),%eax
  101bda:	8b 00                	mov    (%eax),%eax
  101bdc:	89 44 24 04          	mov    %eax,0x4(%esp)
  101be0:	c7 04 24 91 3a 10 00 	movl   $0x103a91,(%esp)
  101be7:	e8 8f e6 ff ff       	call   10027b <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101bec:	8b 45 08             	mov    0x8(%ebp),%eax
  101bef:	8b 40 04             	mov    0x4(%eax),%eax
  101bf2:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bf6:	c7 04 24 a0 3a 10 00 	movl   $0x103aa0,(%esp)
  101bfd:	e8 79 e6 ff ff       	call   10027b <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101c02:	8b 45 08             	mov    0x8(%ebp),%eax
  101c05:	8b 40 08             	mov    0x8(%eax),%eax
  101c08:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c0c:	c7 04 24 af 3a 10 00 	movl   $0x103aaf,(%esp)
  101c13:	e8 63 e6 ff ff       	call   10027b <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101c18:	8b 45 08             	mov    0x8(%ebp),%eax
  101c1b:	8b 40 0c             	mov    0xc(%eax),%eax
  101c1e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c22:	c7 04 24 be 3a 10 00 	movl   $0x103abe,(%esp)
  101c29:	e8 4d e6 ff ff       	call   10027b <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101c2e:	8b 45 08             	mov    0x8(%ebp),%eax
  101c31:	8b 40 10             	mov    0x10(%eax),%eax
  101c34:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c38:	c7 04 24 cd 3a 10 00 	movl   $0x103acd,(%esp)
  101c3f:	e8 37 e6 ff ff       	call   10027b <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101c44:	8b 45 08             	mov    0x8(%ebp),%eax
  101c47:	8b 40 14             	mov    0x14(%eax),%eax
  101c4a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c4e:	c7 04 24 dc 3a 10 00 	movl   $0x103adc,(%esp)
  101c55:	e8 21 e6 ff ff       	call   10027b <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101c5a:	8b 45 08             	mov    0x8(%ebp),%eax
  101c5d:	8b 40 18             	mov    0x18(%eax),%eax
  101c60:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c64:	c7 04 24 eb 3a 10 00 	movl   $0x103aeb,(%esp)
  101c6b:	e8 0b e6 ff ff       	call   10027b <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101c70:	8b 45 08             	mov    0x8(%ebp),%eax
  101c73:	8b 40 1c             	mov    0x1c(%eax),%eax
  101c76:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c7a:	c7 04 24 fa 3a 10 00 	movl   $0x103afa,(%esp)
  101c81:	e8 f5 e5 ff ff       	call   10027b <cprintf>
}
  101c86:	c9                   	leave  
  101c87:	c3                   	ret    

00101c88 <trap_dispatch>:
/* temporary trapframe or pointer to trapframe */
struct trapframe switchk2u, *switchu2k;

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101c88:	55                   	push   %ebp
  101c89:	89 e5                	mov    %esp,%ebp
  101c8b:	57                   	push   %edi
  101c8c:	56                   	push   %esi
  101c8d:	53                   	push   %ebx
  101c8e:	83 ec 2c             	sub    $0x2c,%esp
    char c;

    switch (tf->tf_trapno) {
  101c91:	8b 45 08             	mov    0x8(%ebp),%eax
  101c94:	8b 40 30             	mov    0x30(%eax),%eax
  101c97:	83 f8 2f             	cmp    $0x2f,%eax
  101c9a:	77 21                	ja     101cbd <trap_dispatch+0x35>
  101c9c:	83 f8 2e             	cmp    $0x2e,%eax
  101c9f:	0f 83 ec 01 00 00    	jae    101e91 <trap_dispatch+0x209>
  101ca5:	83 f8 21             	cmp    $0x21,%eax
  101ca8:	0f 84 8a 00 00 00    	je     101d38 <trap_dispatch+0xb0>
  101cae:	83 f8 24             	cmp    $0x24,%eax
  101cb1:	74 5c                	je     101d0f <trap_dispatch+0x87>
  101cb3:	83 f8 20             	cmp    $0x20,%eax
  101cb6:	74 1c                	je     101cd4 <trap_dispatch+0x4c>
  101cb8:	e9 9c 01 00 00       	jmp    101e59 <trap_dispatch+0x1d1>
  101cbd:	83 f8 78             	cmp    $0x78,%eax
  101cc0:	0f 84 9b 00 00 00    	je     101d61 <trap_dispatch+0xd9>
  101cc6:	83 f8 79             	cmp    $0x79,%eax
  101cc9:	0f 84 11 01 00 00    	je     101de0 <trap_dispatch+0x158>
  101ccf:	e9 85 01 00 00       	jmp    101e59 <trap_dispatch+0x1d1>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
    	ticks ++;
  101cd4:	a1 08 f9 10 00       	mov    0x10f908,%eax
  101cd9:	83 c0 01             	add    $0x1,%eax
  101cdc:	a3 08 f9 10 00       	mov    %eax,0x10f908
    	if (ticks % TICK_NUM == 0)
  101ce1:	8b 0d 08 f9 10 00    	mov    0x10f908,%ecx
  101ce7:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101cec:	89 c8                	mov    %ecx,%eax
  101cee:	f7 e2                	mul    %edx
  101cf0:	89 d0                	mov    %edx,%eax
  101cf2:	c1 e8 05             	shr    $0x5,%eax
  101cf5:	6b c0 64             	imul   $0x64,%eax,%eax
  101cf8:	29 c1                	sub    %eax,%ecx
  101cfa:	89 c8                	mov    %ecx,%eax
  101cfc:	85 c0                	test   %eax,%eax
  101cfe:	75 0a                	jne    101d0a <trap_dispatch+0x82>
    	{
    		print_ticks();
  101d00:	e8 0e fb ff ff       	call   101813 <print_ticks>
    	}
        break;
  101d05:	e9 88 01 00 00       	jmp    101e92 <trap_dispatch+0x20a>
  101d0a:	e9 83 01 00 00       	jmp    101e92 <trap_dispatch+0x20a>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101d0f:	e8 d6 f8 ff ff       	call   1015ea <cons_getc>
  101d14:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101d17:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101d1b:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101d1f:	89 54 24 08          	mov    %edx,0x8(%esp)
  101d23:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d27:	c7 04 24 09 3b 10 00 	movl   $0x103b09,(%esp)
  101d2e:	e8 48 e5 ff ff       	call   10027b <cprintf>
        break;
  101d33:	e9 5a 01 00 00       	jmp    101e92 <trap_dispatch+0x20a>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101d38:	e8 ad f8 ff ff       	call   1015ea <cons_getc>
  101d3d:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101d40:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101d44:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101d48:	89 54 24 08          	mov    %edx,0x8(%esp)
  101d4c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d50:	c7 04 24 1b 3b 10 00 	movl   $0x103b1b,(%esp)
  101d57:	e8 1f e5 ff ff       	call   10027b <cprintf>
        break;
  101d5c:	e9 31 01 00 00       	jmp    101e92 <trap_dispatch+0x20a>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    	if(tf->tf_cs !=  USER_CS)
  101d61:	8b 45 08             	mov    0x8(%ebp),%eax
  101d64:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101d68:	66 83 f8 1b          	cmp    $0x1b,%ax
  101d6c:	74 6d                	je     101ddb <trap_dispatch+0x153>
    	{
    		switchk2u = *tf;
  101d6e:	8b 45 08             	mov    0x8(%ebp),%eax
  101d71:	ba 20 f9 10 00       	mov    $0x10f920,%edx
  101d76:	89 c3                	mov    %eax,%ebx
  101d78:	b8 13 00 00 00       	mov    $0x13,%eax
  101d7d:	89 d7                	mov    %edx,%edi
  101d7f:	89 de                	mov    %ebx,%esi
  101d81:	89 c1                	mov    %eax,%ecx
  101d83:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    		switchk2u.tf_cs =  USER_CS;
  101d85:	66 c7 05 5c f9 10 00 	movw   $0x1b,0x10f95c
  101d8c:	1b 00 
    		switchk2u.tf_ds = switchk2u.tf_es = switchk2u.tf_ss = USER_DS;
  101d8e:	66 c7 05 68 f9 10 00 	movw   $0x23,0x10f968
  101d95:	23 00 
  101d97:	0f b7 05 68 f9 10 00 	movzwl 0x10f968,%eax
  101d9e:	66 a3 48 f9 10 00    	mov    %ax,0x10f948
  101da4:	0f b7 05 48 f9 10 00 	movzwl 0x10f948,%eax
  101dab:	66 a3 4c f9 10 00    	mov    %ax,0x10f94c
    		switchk2u.tf_eflags |= FL_IOPL_MASK;
  101db1:	a1 60 f9 10 00       	mov    0x10f960,%eax
  101db6:	80 cc 30             	or     $0x30,%ah
  101db9:	a3 60 f9 10 00       	mov    %eax,0x10f960
    	    switchk2u.tf_esp = (uint32_t)tf + sizeof(struct trapframe) - 8;
  101dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  101dc1:	83 c0 44             	add    $0x44,%eax
  101dc4:	a3 64 f9 10 00       	mov    %eax,0x10f964

    	    *((uint32_t *) tf - 1) = (uint32_t) &switchk2u;
  101dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  101dcc:	8d 50 fc             	lea    -0x4(%eax),%edx
  101dcf:	b8 20 f9 10 00       	mov    $0x10f920,%eax
  101dd4:	89 02                	mov    %eax,(%edx)
    	}
    	break;
  101dd6:	e9 b7 00 00 00       	jmp    101e92 <trap_dispatch+0x20a>
  101ddb:	e9 b2 00 00 00       	jmp    101e92 <trap_dispatch+0x20a>
    case T_SWITCH_TOK:
    	if(tf->tf_cs != KERNEL_CS)
  101de0:	8b 45 08             	mov    0x8(%ebp),%eax
  101de3:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101de7:	66 83 f8 08          	cmp    $0x8,%ax
  101deb:	74 6a                	je     101e57 <trap_dispatch+0x1cf>
    	{
    		tf->tf_cs = KERNEL_CS;
  101ded:	8b 45 08             	mov    0x8(%ebp),%eax
  101df0:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
    		tf->tf_ds = tf->tf_es = KERNEL_DS;
  101df6:	8b 45 08             	mov    0x8(%ebp),%eax
  101df9:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
  101dff:	8b 45 08             	mov    0x8(%ebp),%eax
  101e02:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101e06:	8b 45 08             	mov    0x8(%ebp),%eax
  101e09:	66 89 50 2c          	mov    %dx,0x2c(%eax)
    		tf->tf_eflags &= ~FL_IOPL_MASK;
  101e0d:	8b 45 08             	mov    0x8(%ebp),%eax
  101e10:	8b 40 40             	mov    0x40(%eax),%eax
  101e13:	80 e4 cf             	and    $0xcf,%ah
  101e16:	89 c2                	mov    %eax,%edx
  101e18:	8b 45 08             	mov    0x8(%ebp),%eax
  101e1b:	89 50 40             	mov    %edx,0x40(%eax)
    		switchu2k = (struct trapframe *)(tf->tf_esp - (sizeof(struct trapframe) - 8));
  101e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  101e21:	8b 40 44             	mov    0x44(%eax),%eax
  101e24:	83 e8 44             	sub    $0x44,%eax
  101e27:	a3 6c f9 10 00       	mov    %eax,0x10f96c
    		memmove(switchu2k, tf, sizeof(struct trapframe) - 8);
  101e2c:	a1 6c f9 10 00       	mov    0x10f96c,%eax
  101e31:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  101e38:	00 
  101e39:	8b 55 08             	mov    0x8(%ebp),%edx
  101e3c:	89 54 24 04          	mov    %edx,0x4(%esp)
  101e40:	89 04 24             	mov    %eax,(%esp)
  101e43:	e8 a6 0f 00 00       	call   102dee <memmove>
    		*((uint32_t *) tf - 1) = (uint32_t) switchu2k;
  101e48:	8b 45 08             	mov    0x8(%ebp),%eax
  101e4b:	8d 50 fc             	lea    -0x4(%eax),%edx
  101e4e:	a1 6c f9 10 00       	mov    0x10f96c,%eax
  101e53:	89 02                	mov    %eax,(%edx)
    	}
        break;
  101e55:	eb 3b                	jmp    101e92 <trap_dispatch+0x20a>
  101e57:	eb 39                	jmp    101e92 <trap_dispatch+0x20a>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101e59:	8b 45 08             	mov    0x8(%ebp),%eax
  101e5c:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101e60:	0f b7 c0             	movzwl %ax,%eax
  101e63:	83 e0 03             	and    $0x3,%eax
  101e66:	85 c0                	test   %eax,%eax
  101e68:	75 28                	jne    101e92 <trap_dispatch+0x20a>
            print_trapframe(tf);
  101e6a:	8b 45 08             	mov    0x8(%ebp),%eax
  101e6d:	89 04 24             	mov    %eax,(%esp)
  101e70:	e8 97 fb ff ff       	call   101a0c <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101e75:	c7 44 24 08 2a 3b 10 	movl   $0x103b2a,0x8(%esp)
  101e7c:	00 
  101e7d:	c7 44 24 04 d7 00 00 	movl   $0xd7,0x4(%esp)
  101e84:	00 
  101e85:	c7 04 24 4e 39 10 00 	movl   $0x10394e,(%esp)
  101e8c:	e8 41 e5 ff ff       	call   1003d2 <__panic>
        break;
  101e91:	90                   	nop
        }
    }
}
  101e92:	83 c4 2c             	add    $0x2c,%esp
  101e95:	5b                   	pop    %ebx
  101e96:	5e                   	pop    %esi
  101e97:	5f                   	pop    %edi
  101e98:	5d                   	pop    %ebp
  101e99:	c3                   	ret    

00101e9a <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101e9a:	55                   	push   %ebp
  101e9b:	89 e5                	mov    %esp,%ebp
  101e9d:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101ea0:	8b 45 08             	mov    0x8(%ebp),%eax
  101ea3:	89 04 24             	mov    %eax,(%esp)
  101ea6:	e8 dd fd ff ff       	call   101c88 <trap_dispatch>
}
  101eab:	c9                   	leave  
  101eac:	c3                   	ret    

00101ead <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101ead:	6a 00                	push   $0x0
  pushl $0
  101eaf:	6a 00                	push   $0x0
  jmp __alltraps
  101eb1:	e9 69 0a 00 00       	jmp    10291f <__alltraps>

00101eb6 <vector1>:
.globl vector1
vector1:
  pushl $0
  101eb6:	6a 00                	push   $0x0
  pushl $1
  101eb8:	6a 01                	push   $0x1
  jmp __alltraps
  101eba:	e9 60 0a 00 00       	jmp    10291f <__alltraps>

00101ebf <vector2>:
.globl vector2
vector2:
  pushl $0
  101ebf:	6a 00                	push   $0x0
  pushl $2
  101ec1:	6a 02                	push   $0x2
  jmp __alltraps
  101ec3:	e9 57 0a 00 00       	jmp    10291f <__alltraps>

00101ec8 <vector3>:
.globl vector3
vector3:
  pushl $0
  101ec8:	6a 00                	push   $0x0
  pushl $3
  101eca:	6a 03                	push   $0x3
  jmp __alltraps
  101ecc:	e9 4e 0a 00 00       	jmp    10291f <__alltraps>

00101ed1 <vector4>:
.globl vector4
vector4:
  pushl $0
  101ed1:	6a 00                	push   $0x0
  pushl $4
  101ed3:	6a 04                	push   $0x4
  jmp __alltraps
  101ed5:	e9 45 0a 00 00       	jmp    10291f <__alltraps>

00101eda <vector5>:
.globl vector5
vector5:
  pushl $0
  101eda:	6a 00                	push   $0x0
  pushl $5
  101edc:	6a 05                	push   $0x5
  jmp __alltraps
  101ede:	e9 3c 0a 00 00       	jmp    10291f <__alltraps>

00101ee3 <vector6>:
.globl vector6
vector6:
  pushl $0
  101ee3:	6a 00                	push   $0x0
  pushl $6
  101ee5:	6a 06                	push   $0x6
  jmp __alltraps
  101ee7:	e9 33 0a 00 00       	jmp    10291f <__alltraps>

00101eec <vector7>:
.globl vector7
vector7:
  pushl $0
  101eec:	6a 00                	push   $0x0
  pushl $7
  101eee:	6a 07                	push   $0x7
  jmp __alltraps
  101ef0:	e9 2a 0a 00 00       	jmp    10291f <__alltraps>

00101ef5 <vector8>:
.globl vector8
vector8:
  pushl $8
  101ef5:	6a 08                	push   $0x8
  jmp __alltraps
  101ef7:	e9 23 0a 00 00       	jmp    10291f <__alltraps>

00101efc <vector9>:
.globl vector9
vector9:
  pushl $0
  101efc:	6a 00                	push   $0x0
  pushl $9
  101efe:	6a 09                	push   $0x9
  jmp __alltraps
  101f00:	e9 1a 0a 00 00       	jmp    10291f <__alltraps>

00101f05 <vector10>:
.globl vector10
vector10:
  pushl $10
  101f05:	6a 0a                	push   $0xa
  jmp __alltraps
  101f07:	e9 13 0a 00 00       	jmp    10291f <__alltraps>

00101f0c <vector11>:
.globl vector11
vector11:
  pushl $11
  101f0c:	6a 0b                	push   $0xb
  jmp __alltraps
  101f0e:	e9 0c 0a 00 00       	jmp    10291f <__alltraps>

00101f13 <vector12>:
.globl vector12
vector12:
  pushl $12
  101f13:	6a 0c                	push   $0xc
  jmp __alltraps
  101f15:	e9 05 0a 00 00       	jmp    10291f <__alltraps>

00101f1a <vector13>:
.globl vector13
vector13:
  pushl $13
  101f1a:	6a 0d                	push   $0xd
  jmp __alltraps
  101f1c:	e9 fe 09 00 00       	jmp    10291f <__alltraps>

00101f21 <vector14>:
.globl vector14
vector14:
  pushl $14
  101f21:	6a 0e                	push   $0xe
  jmp __alltraps
  101f23:	e9 f7 09 00 00       	jmp    10291f <__alltraps>

00101f28 <vector15>:
.globl vector15
vector15:
  pushl $0
  101f28:	6a 00                	push   $0x0
  pushl $15
  101f2a:	6a 0f                	push   $0xf
  jmp __alltraps
  101f2c:	e9 ee 09 00 00       	jmp    10291f <__alltraps>

00101f31 <vector16>:
.globl vector16
vector16:
  pushl $0
  101f31:	6a 00                	push   $0x0
  pushl $16
  101f33:	6a 10                	push   $0x10
  jmp __alltraps
  101f35:	e9 e5 09 00 00       	jmp    10291f <__alltraps>

00101f3a <vector17>:
.globl vector17
vector17:
  pushl $17
  101f3a:	6a 11                	push   $0x11
  jmp __alltraps
  101f3c:	e9 de 09 00 00       	jmp    10291f <__alltraps>

00101f41 <vector18>:
.globl vector18
vector18:
  pushl $0
  101f41:	6a 00                	push   $0x0
  pushl $18
  101f43:	6a 12                	push   $0x12
  jmp __alltraps
  101f45:	e9 d5 09 00 00       	jmp    10291f <__alltraps>

00101f4a <vector19>:
.globl vector19
vector19:
  pushl $0
  101f4a:	6a 00                	push   $0x0
  pushl $19
  101f4c:	6a 13                	push   $0x13
  jmp __alltraps
  101f4e:	e9 cc 09 00 00       	jmp    10291f <__alltraps>

00101f53 <vector20>:
.globl vector20
vector20:
  pushl $0
  101f53:	6a 00                	push   $0x0
  pushl $20
  101f55:	6a 14                	push   $0x14
  jmp __alltraps
  101f57:	e9 c3 09 00 00       	jmp    10291f <__alltraps>

00101f5c <vector21>:
.globl vector21
vector21:
  pushl $0
  101f5c:	6a 00                	push   $0x0
  pushl $21
  101f5e:	6a 15                	push   $0x15
  jmp __alltraps
  101f60:	e9 ba 09 00 00       	jmp    10291f <__alltraps>

00101f65 <vector22>:
.globl vector22
vector22:
  pushl $0
  101f65:	6a 00                	push   $0x0
  pushl $22
  101f67:	6a 16                	push   $0x16
  jmp __alltraps
  101f69:	e9 b1 09 00 00       	jmp    10291f <__alltraps>

00101f6e <vector23>:
.globl vector23
vector23:
  pushl $0
  101f6e:	6a 00                	push   $0x0
  pushl $23
  101f70:	6a 17                	push   $0x17
  jmp __alltraps
  101f72:	e9 a8 09 00 00       	jmp    10291f <__alltraps>

00101f77 <vector24>:
.globl vector24
vector24:
  pushl $0
  101f77:	6a 00                	push   $0x0
  pushl $24
  101f79:	6a 18                	push   $0x18
  jmp __alltraps
  101f7b:	e9 9f 09 00 00       	jmp    10291f <__alltraps>

00101f80 <vector25>:
.globl vector25
vector25:
  pushl $0
  101f80:	6a 00                	push   $0x0
  pushl $25
  101f82:	6a 19                	push   $0x19
  jmp __alltraps
  101f84:	e9 96 09 00 00       	jmp    10291f <__alltraps>

00101f89 <vector26>:
.globl vector26
vector26:
  pushl $0
  101f89:	6a 00                	push   $0x0
  pushl $26
  101f8b:	6a 1a                	push   $0x1a
  jmp __alltraps
  101f8d:	e9 8d 09 00 00       	jmp    10291f <__alltraps>

00101f92 <vector27>:
.globl vector27
vector27:
  pushl $0
  101f92:	6a 00                	push   $0x0
  pushl $27
  101f94:	6a 1b                	push   $0x1b
  jmp __alltraps
  101f96:	e9 84 09 00 00       	jmp    10291f <__alltraps>

00101f9b <vector28>:
.globl vector28
vector28:
  pushl $0
  101f9b:	6a 00                	push   $0x0
  pushl $28
  101f9d:	6a 1c                	push   $0x1c
  jmp __alltraps
  101f9f:	e9 7b 09 00 00       	jmp    10291f <__alltraps>

00101fa4 <vector29>:
.globl vector29
vector29:
  pushl $0
  101fa4:	6a 00                	push   $0x0
  pushl $29
  101fa6:	6a 1d                	push   $0x1d
  jmp __alltraps
  101fa8:	e9 72 09 00 00       	jmp    10291f <__alltraps>

00101fad <vector30>:
.globl vector30
vector30:
  pushl $0
  101fad:	6a 00                	push   $0x0
  pushl $30
  101faf:	6a 1e                	push   $0x1e
  jmp __alltraps
  101fb1:	e9 69 09 00 00       	jmp    10291f <__alltraps>

00101fb6 <vector31>:
.globl vector31
vector31:
  pushl $0
  101fb6:	6a 00                	push   $0x0
  pushl $31
  101fb8:	6a 1f                	push   $0x1f
  jmp __alltraps
  101fba:	e9 60 09 00 00       	jmp    10291f <__alltraps>

00101fbf <vector32>:
.globl vector32
vector32:
  pushl $0
  101fbf:	6a 00                	push   $0x0
  pushl $32
  101fc1:	6a 20                	push   $0x20
  jmp __alltraps
  101fc3:	e9 57 09 00 00       	jmp    10291f <__alltraps>

00101fc8 <vector33>:
.globl vector33
vector33:
  pushl $0
  101fc8:	6a 00                	push   $0x0
  pushl $33
  101fca:	6a 21                	push   $0x21
  jmp __alltraps
  101fcc:	e9 4e 09 00 00       	jmp    10291f <__alltraps>

00101fd1 <vector34>:
.globl vector34
vector34:
  pushl $0
  101fd1:	6a 00                	push   $0x0
  pushl $34
  101fd3:	6a 22                	push   $0x22
  jmp __alltraps
  101fd5:	e9 45 09 00 00       	jmp    10291f <__alltraps>

00101fda <vector35>:
.globl vector35
vector35:
  pushl $0
  101fda:	6a 00                	push   $0x0
  pushl $35
  101fdc:	6a 23                	push   $0x23
  jmp __alltraps
  101fde:	e9 3c 09 00 00       	jmp    10291f <__alltraps>

00101fe3 <vector36>:
.globl vector36
vector36:
  pushl $0
  101fe3:	6a 00                	push   $0x0
  pushl $36
  101fe5:	6a 24                	push   $0x24
  jmp __alltraps
  101fe7:	e9 33 09 00 00       	jmp    10291f <__alltraps>

00101fec <vector37>:
.globl vector37
vector37:
  pushl $0
  101fec:	6a 00                	push   $0x0
  pushl $37
  101fee:	6a 25                	push   $0x25
  jmp __alltraps
  101ff0:	e9 2a 09 00 00       	jmp    10291f <__alltraps>

00101ff5 <vector38>:
.globl vector38
vector38:
  pushl $0
  101ff5:	6a 00                	push   $0x0
  pushl $38
  101ff7:	6a 26                	push   $0x26
  jmp __alltraps
  101ff9:	e9 21 09 00 00       	jmp    10291f <__alltraps>

00101ffe <vector39>:
.globl vector39
vector39:
  pushl $0
  101ffe:	6a 00                	push   $0x0
  pushl $39
  102000:	6a 27                	push   $0x27
  jmp __alltraps
  102002:	e9 18 09 00 00       	jmp    10291f <__alltraps>

00102007 <vector40>:
.globl vector40
vector40:
  pushl $0
  102007:	6a 00                	push   $0x0
  pushl $40
  102009:	6a 28                	push   $0x28
  jmp __alltraps
  10200b:	e9 0f 09 00 00       	jmp    10291f <__alltraps>

00102010 <vector41>:
.globl vector41
vector41:
  pushl $0
  102010:	6a 00                	push   $0x0
  pushl $41
  102012:	6a 29                	push   $0x29
  jmp __alltraps
  102014:	e9 06 09 00 00       	jmp    10291f <__alltraps>

00102019 <vector42>:
.globl vector42
vector42:
  pushl $0
  102019:	6a 00                	push   $0x0
  pushl $42
  10201b:	6a 2a                	push   $0x2a
  jmp __alltraps
  10201d:	e9 fd 08 00 00       	jmp    10291f <__alltraps>

00102022 <vector43>:
.globl vector43
vector43:
  pushl $0
  102022:	6a 00                	push   $0x0
  pushl $43
  102024:	6a 2b                	push   $0x2b
  jmp __alltraps
  102026:	e9 f4 08 00 00       	jmp    10291f <__alltraps>

0010202b <vector44>:
.globl vector44
vector44:
  pushl $0
  10202b:	6a 00                	push   $0x0
  pushl $44
  10202d:	6a 2c                	push   $0x2c
  jmp __alltraps
  10202f:	e9 eb 08 00 00       	jmp    10291f <__alltraps>

00102034 <vector45>:
.globl vector45
vector45:
  pushl $0
  102034:	6a 00                	push   $0x0
  pushl $45
  102036:	6a 2d                	push   $0x2d
  jmp __alltraps
  102038:	e9 e2 08 00 00       	jmp    10291f <__alltraps>

0010203d <vector46>:
.globl vector46
vector46:
  pushl $0
  10203d:	6a 00                	push   $0x0
  pushl $46
  10203f:	6a 2e                	push   $0x2e
  jmp __alltraps
  102041:	e9 d9 08 00 00       	jmp    10291f <__alltraps>

00102046 <vector47>:
.globl vector47
vector47:
  pushl $0
  102046:	6a 00                	push   $0x0
  pushl $47
  102048:	6a 2f                	push   $0x2f
  jmp __alltraps
  10204a:	e9 d0 08 00 00       	jmp    10291f <__alltraps>

0010204f <vector48>:
.globl vector48
vector48:
  pushl $0
  10204f:	6a 00                	push   $0x0
  pushl $48
  102051:	6a 30                	push   $0x30
  jmp __alltraps
  102053:	e9 c7 08 00 00       	jmp    10291f <__alltraps>

00102058 <vector49>:
.globl vector49
vector49:
  pushl $0
  102058:	6a 00                	push   $0x0
  pushl $49
  10205a:	6a 31                	push   $0x31
  jmp __alltraps
  10205c:	e9 be 08 00 00       	jmp    10291f <__alltraps>

00102061 <vector50>:
.globl vector50
vector50:
  pushl $0
  102061:	6a 00                	push   $0x0
  pushl $50
  102063:	6a 32                	push   $0x32
  jmp __alltraps
  102065:	e9 b5 08 00 00       	jmp    10291f <__alltraps>

0010206a <vector51>:
.globl vector51
vector51:
  pushl $0
  10206a:	6a 00                	push   $0x0
  pushl $51
  10206c:	6a 33                	push   $0x33
  jmp __alltraps
  10206e:	e9 ac 08 00 00       	jmp    10291f <__alltraps>

00102073 <vector52>:
.globl vector52
vector52:
  pushl $0
  102073:	6a 00                	push   $0x0
  pushl $52
  102075:	6a 34                	push   $0x34
  jmp __alltraps
  102077:	e9 a3 08 00 00       	jmp    10291f <__alltraps>

0010207c <vector53>:
.globl vector53
vector53:
  pushl $0
  10207c:	6a 00                	push   $0x0
  pushl $53
  10207e:	6a 35                	push   $0x35
  jmp __alltraps
  102080:	e9 9a 08 00 00       	jmp    10291f <__alltraps>

00102085 <vector54>:
.globl vector54
vector54:
  pushl $0
  102085:	6a 00                	push   $0x0
  pushl $54
  102087:	6a 36                	push   $0x36
  jmp __alltraps
  102089:	e9 91 08 00 00       	jmp    10291f <__alltraps>

0010208e <vector55>:
.globl vector55
vector55:
  pushl $0
  10208e:	6a 00                	push   $0x0
  pushl $55
  102090:	6a 37                	push   $0x37
  jmp __alltraps
  102092:	e9 88 08 00 00       	jmp    10291f <__alltraps>

00102097 <vector56>:
.globl vector56
vector56:
  pushl $0
  102097:	6a 00                	push   $0x0
  pushl $56
  102099:	6a 38                	push   $0x38
  jmp __alltraps
  10209b:	e9 7f 08 00 00       	jmp    10291f <__alltraps>

001020a0 <vector57>:
.globl vector57
vector57:
  pushl $0
  1020a0:	6a 00                	push   $0x0
  pushl $57
  1020a2:	6a 39                	push   $0x39
  jmp __alltraps
  1020a4:	e9 76 08 00 00       	jmp    10291f <__alltraps>

001020a9 <vector58>:
.globl vector58
vector58:
  pushl $0
  1020a9:	6a 00                	push   $0x0
  pushl $58
  1020ab:	6a 3a                	push   $0x3a
  jmp __alltraps
  1020ad:	e9 6d 08 00 00       	jmp    10291f <__alltraps>

001020b2 <vector59>:
.globl vector59
vector59:
  pushl $0
  1020b2:	6a 00                	push   $0x0
  pushl $59
  1020b4:	6a 3b                	push   $0x3b
  jmp __alltraps
  1020b6:	e9 64 08 00 00       	jmp    10291f <__alltraps>

001020bb <vector60>:
.globl vector60
vector60:
  pushl $0
  1020bb:	6a 00                	push   $0x0
  pushl $60
  1020bd:	6a 3c                	push   $0x3c
  jmp __alltraps
  1020bf:	e9 5b 08 00 00       	jmp    10291f <__alltraps>

001020c4 <vector61>:
.globl vector61
vector61:
  pushl $0
  1020c4:	6a 00                	push   $0x0
  pushl $61
  1020c6:	6a 3d                	push   $0x3d
  jmp __alltraps
  1020c8:	e9 52 08 00 00       	jmp    10291f <__alltraps>

001020cd <vector62>:
.globl vector62
vector62:
  pushl $0
  1020cd:	6a 00                	push   $0x0
  pushl $62
  1020cf:	6a 3e                	push   $0x3e
  jmp __alltraps
  1020d1:	e9 49 08 00 00       	jmp    10291f <__alltraps>

001020d6 <vector63>:
.globl vector63
vector63:
  pushl $0
  1020d6:	6a 00                	push   $0x0
  pushl $63
  1020d8:	6a 3f                	push   $0x3f
  jmp __alltraps
  1020da:	e9 40 08 00 00       	jmp    10291f <__alltraps>

001020df <vector64>:
.globl vector64
vector64:
  pushl $0
  1020df:	6a 00                	push   $0x0
  pushl $64
  1020e1:	6a 40                	push   $0x40
  jmp __alltraps
  1020e3:	e9 37 08 00 00       	jmp    10291f <__alltraps>

001020e8 <vector65>:
.globl vector65
vector65:
  pushl $0
  1020e8:	6a 00                	push   $0x0
  pushl $65
  1020ea:	6a 41                	push   $0x41
  jmp __alltraps
  1020ec:	e9 2e 08 00 00       	jmp    10291f <__alltraps>

001020f1 <vector66>:
.globl vector66
vector66:
  pushl $0
  1020f1:	6a 00                	push   $0x0
  pushl $66
  1020f3:	6a 42                	push   $0x42
  jmp __alltraps
  1020f5:	e9 25 08 00 00       	jmp    10291f <__alltraps>

001020fa <vector67>:
.globl vector67
vector67:
  pushl $0
  1020fa:	6a 00                	push   $0x0
  pushl $67
  1020fc:	6a 43                	push   $0x43
  jmp __alltraps
  1020fe:	e9 1c 08 00 00       	jmp    10291f <__alltraps>

00102103 <vector68>:
.globl vector68
vector68:
  pushl $0
  102103:	6a 00                	push   $0x0
  pushl $68
  102105:	6a 44                	push   $0x44
  jmp __alltraps
  102107:	e9 13 08 00 00       	jmp    10291f <__alltraps>

0010210c <vector69>:
.globl vector69
vector69:
  pushl $0
  10210c:	6a 00                	push   $0x0
  pushl $69
  10210e:	6a 45                	push   $0x45
  jmp __alltraps
  102110:	e9 0a 08 00 00       	jmp    10291f <__alltraps>

00102115 <vector70>:
.globl vector70
vector70:
  pushl $0
  102115:	6a 00                	push   $0x0
  pushl $70
  102117:	6a 46                	push   $0x46
  jmp __alltraps
  102119:	e9 01 08 00 00       	jmp    10291f <__alltraps>

0010211e <vector71>:
.globl vector71
vector71:
  pushl $0
  10211e:	6a 00                	push   $0x0
  pushl $71
  102120:	6a 47                	push   $0x47
  jmp __alltraps
  102122:	e9 f8 07 00 00       	jmp    10291f <__alltraps>

00102127 <vector72>:
.globl vector72
vector72:
  pushl $0
  102127:	6a 00                	push   $0x0
  pushl $72
  102129:	6a 48                	push   $0x48
  jmp __alltraps
  10212b:	e9 ef 07 00 00       	jmp    10291f <__alltraps>

00102130 <vector73>:
.globl vector73
vector73:
  pushl $0
  102130:	6a 00                	push   $0x0
  pushl $73
  102132:	6a 49                	push   $0x49
  jmp __alltraps
  102134:	e9 e6 07 00 00       	jmp    10291f <__alltraps>

00102139 <vector74>:
.globl vector74
vector74:
  pushl $0
  102139:	6a 00                	push   $0x0
  pushl $74
  10213b:	6a 4a                	push   $0x4a
  jmp __alltraps
  10213d:	e9 dd 07 00 00       	jmp    10291f <__alltraps>

00102142 <vector75>:
.globl vector75
vector75:
  pushl $0
  102142:	6a 00                	push   $0x0
  pushl $75
  102144:	6a 4b                	push   $0x4b
  jmp __alltraps
  102146:	e9 d4 07 00 00       	jmp    10291f <__alltraps>

0010214b <vector76>:
.globl vector76
vector76:
  pushl $0
  10214b:	6a 00                	push   $0x0
  pushl $76
  10214d:	6a 4c                	push   $0x4c
  jmp __alltraps
  10214f:	e9 cb 07 00 00       	jmp    10291f <__alltraps>

00102154 <vector77>:
.globl vector77
vector77:
  pushl $0
  102154:	6a 00                	push   $0x0
  pushl $77
  102156:	6a 4d                	push   $0x4d
  jmp __alltraps
  102158:	e9 c2 07 00 00       	jmp    10291f <__alltraps>

0010215d <vector78>:
.globl vector78
vector78:
  pushl $0
  10215d:	6a 00                	push   $0x0
  pushl $78
  10215f:	6a 4e                	push   $0x4e
  jmp __alltraps
  102161:	e9 b9 07 00 00       	jmp    10291f <__alltraps>

00102166 <vector79>:
.globl vector79
vector79:
  pushl $0
  102166:	6a 00                	push   $0x0
  pushl $79
  102168:	6a 4f                	push   $0x4f
  jmp __alltraps
  10216a:	e9 b0 07 00 00       	jmp    10291f <__alltraps>

0010216f <vector80>:
.globl vector80
vector80:
  pushl $0
  10216f:	6a 00                	push   $0x0
  pushl $80
  102171:	6a 50                	push   $0x50
  jmp __alltraps
  102173:	e9 a7 07 00 00       	jmp    10291f <__alltraps>

00102178 <vector81>:
.globl vector81
vector81:
  pushl $0
  102178:	6a 00                	push   $0x0
  pushl $81
  10217a:	6a 51                	push   $0x51
  jmp __alltraps
  10217c:	e9 9e 07 00 00       	jmp    10291f <__alltraps>

00102181 <vector82>:
.globl vector82
vector82:
  pushl $0
  102181:	6a 00                	push   $0x0
  pushl $82
  102183:	6a 52                	push   $0x52
  jmp __alltraps
  102185:	e9 95 07 00 00       	jmp    10291f <__alltraps>

0010218a <vector83>:
.globl vector83
vector83:
  pushl $0
  10218a:	6a 00                	push   $0x0
  pushl $83
  10218c:	6a 53                	push   $0x53
  jmp __alltraps
  10218e:	e9 8c 07 00 00       	jmp    10291f <__alltraps>

00102193 <vector84>:
.globl vector84
vector84:
  pushl $0
  102193:	6a 00                	push   $0x0
  pushl $84
  102195:	6a 54                	push   $0x54
  jmp __alltraps
  102197:	e9 83 07 00 00       	jmp    10291f <__alltraps>

0010219c <vector85>:
.globl vector85
vector85:
  pushl $0
  10219c:	6a 00                	push   $0x0
  pushl $85
  10219e:	6a 55                	push   $0x55
  jmp __alltraps
  1021a0:	e9 7a 07 00 00       	jmp    10291f <__alltraps>

001021a5 <vector86>:
.globl vector86
vector86:
  pushl $0
  1021a5:	6a 00                	push   $0x0
  pushl $86
  1021a7:	6a 56                	push   $0x56
  jmp __alltraps
  1021a9:	e9 71 07 00 00       	jmp    10291f <__alltraps>

001021ae <vector87>:
.globl vector87
vector87:
  pushl $0
  1021ae:	6a 00                	push   $0x0
  pushl $87
  1021b0:	6a 57                	push   $0x57
  jmp __alltraps
  1021b2:	e9 68 07 00 00       	jmp    10291f <__alltraps>

001021b7 <vector88>:
.globl vector88
vector88:
  pushl $0
  1021b7:	6a 00                	push   $0x0
  pushl $88
  1021b9:	6a 58                	push   $0x58
  jmp __alltraps
  1021bb:	e9 5f 07 00 00       	jmp    10291f <__alltraps>

001021c0 <vector89>:
.globl vector89
vector89:
  pushl $0
  1021c0:	6a 00                	push   $0x0
  pushl $89
  1021c2:	6a 59                	push   $0x59
  jmp __alltraps
  1021c4:	e9 56 07 00 00       	jmp    10291f <__alltraps>

001021c9 <vector90>:
.globl vector90
vector90:
  pushl $0
  1021c9:	6a 00                	push   $0x0
  pushl $90
  1021cb:	6a 5a                	push   $0x5a
  jmp __alltraps
  1021cd:	e9 4d 07 00 00       	jmp    10291f <__alltraps>

001021d2 <vector91>:
.globl vector91
vector91:
  pushl $0
  1021d2:	6a 00                	push   $0x0
  pushl $91
  1021d4:	6a 5b                	push   $0x5b
  jmp __alltraps
  1021d6:	e9 44 07 00 00       	jmp    10291f <__alltraps>

001021db <vector92>:
.globl vector92
vector92:
  pushl $0
  1021db:	6a 00                	push   $0x0
  pushl $92
  1021dd:	6a 5c                	push   $0x5c
  jmp __alltraps
  1021df:	e9 3b 07 00 00       	jmp    10291f <__alltraps>

001021e4 <vector93>:
.globl vector93
vector93:
  pushl $0
  1021e4:	6a 00                	push   $0x0
  pushl $93
  1021e6:	6a 5d                	push   $0x5d
  jmp __alltraps
  1021e8:	e9 32 07 00 00       	jmp    10291f <__alltraps>

001021ed <vector94>:
.globl vector94
vector94:
  pushl $0
  1021ed:	6a 00                	push   $0x0
  pushl $94
  1021ef:	6a 5e                	push   $0x5e
  jmp __alltraps
  1021f1:	e9 29 07 00 00       	jmp    10291f <__alltraps>

001021f6 <vector95>:
.globl vector95
vector95:
  pushl $0
  1021f6:	6a 00                	push   $0x0
  pushl $95
  1021f8:	6a 5f                	push   $0x5f
  jmp __alltraps
  1021fa:	e9 20 07 00 00       	jmp    10291f <__alltraps>

001021ff <vector96>:
.globl vector96
vector96:
  pushl $0
  1021ff:	6a 00                	push   $0x0
  pushl $96
  102201:	6a 60                	push   $0x60
  jmp __alltraps
  102203:	e9 17 07 00 00       	jmp    10291f <__alltraps>

00102208 <vector97>:
.globl vector97
vector97:
  pushl $0
  102208:	6a 00                	push   $0x0
  pushl $97
  10220a:	6a 61                	push   $0x61
  jmp __alltraps
  10220c:	e9 0e 07 00 00       	jmp    10291f <__alltraps>

00102211 <vector98>:
.globl vector98
vector98:
  pushl $0
  102211:	6a 00                	push   $0x0
  pushl $98
  102213:	6a 62                	push   $0x62
  jmp __alltraps
  102215:	e9 05 07 00 00       	jmp    10291f <__alltraps>

0010221a <vector99>:
.globl vector99
vector99:
  pushl $0
  10221a:	6a 00                	push   $0x0
  pushl $99
  10221c:	6a 63                	push   $0x63
  jmp __alltraps
  10221e:	e9 fc 06 00 00       	jmp    10291f <__alltraps>

00102223 <vector100>:
.globl vector100
vector100:
  pushl $0
  102223:	6a 00                	push   $0x0
  pushl $100
  102225:	6a 64                	push   $0x64
  jmp __alltraps
  102227:	e9 f3 06 00 00       	jmp    10291f <__alltraps>

0010222c <vector101>:
.globl vector101
vector101:
  pushl $0
  10222c:	6a 00                	push   $0x0
  pushl $101
  10222e:	6a 65                	push   $0x65
  jmp __alltraps
  102230:	e9 ea 06 00 00       	jmp    10291f <__alltraps>

00102235 <vector102>:
.globl vector102
vector102:
  pushl $0
  102235:	6a 00                	push   $0x0
  pushl $102
  102237:	6a 66                	push   $0x66
  jmp __alltraps
  102239:	e9 e1 06 00 00       	jmp    10291f <__alltraps>

0010223e <vector103>:
.globl vector103
vector103:
  pushl $0
  10223e:	6a 00                	push   $0x0
  pushl $103
  102240:	6a 67                	push   $0x67
  jmp __alltraps
  102242:	e9 d8 06 00 00       	jmp    10291f <__alltraps>

00102247 <vector104>:
.globl vector104
vector104:
  pushl $0
  102247:	6a 00                	push   $0x0
  pushl $104
  102249:	6a 68                	push   $0x68
  jmp __alltraps
  10224b:	e9 cf 06 00 00       	jmp    10291f <__alltraps>

00102250 <vector105>:
.globl vector105
vector105:
  pushl $0
  102250:	6a 00                	push   $0x0
  pushl $105
  102252:	6a 69                	push   $0x69
  jmp __alltraps
  102254:	e9 c6 06 00 00       	jmp    10291f <__alltraps>

00102259 <vector106>:
.globl vector106
vector106:
  pushl $0
  102259:	6a 00                	push   $0x0
  pushl $106
  10225b:	6a 6a                	push   $0x6a
  jmp __alltraps
  10225d:	e9 bd 06 00 00       	jmp    10291f <__alltraps>

00102262 <vector107>:
.globl vector107
vector107:
  pushl $0
  102262:	6a 00                	push   $0x0
  pushl $107
  102264:	6a 6b                	push   $0x6b
  jmp __alltraps
  102266:	e9 b4 06 00 00       	jmp    10291f <__alltraps>

0010226b <vector108>:
.globl vector108
vector108:
  pushl $0
  10226b:	6a 00                	push   $0x0
  pushl $108
  10226d:	6a 6c                	push   $0x6c
  jmp __alltraps
  10226f:	e9 ab 06 00 00       	jmp    10291f <__alltraps>

00102274 <vector109>:
.globl vector109
vector109:
  pushl $0
  102274:	6a 00                	push   $0x0
  pushl $109
  102276:	6a 6d                	push   $0x6d
  jmp __alltraps
  102278:	e9 a2 06 00 00       	jmp    10291f <__alltraps>

0010227d <vector110>:
.globl vector110
vector110:
  pushl $0
  10227d:	6a 00                	push   $0x0
  pushl $110
  10227f:	6a 6e                	push   $0x6e
  jmp __alltraps
  102281:	e9 99 06 00 00       	jmp    10291f <__alltraps>

00102286 <vector111>:
.globl vector111
vector111:
  pushl $0
  102286:	6a 00                	push   $0x0
  pushl $111
  102288:	6a 6f                	push   $0x6f
  jmp __alltraps
  10228a:	e9 90 06 00 00       	jmp    10291f <__alltraps>

0010228f <vector112>:
.globl vector112
vector112:
  pushl $0
  10228f:	6a 00                	push   $0x0
  pushl $112
  102291:	6a 70                	push   $0x70
  jmp __alltraps
  102293:	e9 87 06 00 00       	jmp    10291f <__alltraps>

00102298 <vector113>:
.globl vector113
vector113:
  pushl $0
  102298:	6a 00                	push   $0x0
  pushl $113
  10229a:	6a 71                	push   $0x71
  jmp __alltraps
  10229c:	e9 7e 06 00 00       	jmp    10291f <__alltraps>

001022a1 <vector114>:
.globl vector114
vector114:
  pushl $0
  1022a1:	6a 00                	push   $0x0
  pushl $114
  1022a3:	6a 72                	push   $0x72
  jmp __alltraps
  1022a5:	e9 75 06 00 00       	jmp    10291f <__alltraps>

001022aa <vector115>:
.globl vector115
vector115:
  pushl $0
  1022aa:	6a 00                	push   $0x0
  pushl $115
  1022ac:	6a 73                	push   $0x73
  jmp __alltraps
  1022ae:	e9 6c 06 00 00       	jmp    10291f <__alltraps>

001022b3 <vector116>:
.globl vector116
vector116:
  pushl $0
  1022b3:	6a 00                	push   $0x0
  pushl $116
  1022b5:	6a 74                	push   $0x74
  jmp __alltraps
  1022b7:	e9 63 06 00 00       	jmp    10291f <__alltraps>

001022bc <vector117>:
.globl vector117
vector117:
  pushl $0
  1022bc:	6a 00                	push   $0x0
  pushl $117
  1022be:	6a 75                	push   $0x75
  jmp __alltraps
  1022c0:	e9 5a 06 00 00       	jmp    10291f <__alltraps>

001022c5 <vector118>:
.globl vector118
vector118:
  pushl $0
  1022c5:	6a 00                	push   $0x0
  pushl $118
  1022c7:	6a 76                	push   $0x76
  jmp __alltraps
  1022c9:	e9 51 06 00 00       	jmp    10291f <__alltraps>

001022ce <vector119>:
.globl vector119
vector119:
  pushl $0
  1022ce:	6a 00                	push   $0x0
  pushl $119
  1022d0:	6a 77                	push   $0x77
  jmp __alltraps
  1022d2:	e9 48 06 00 00       	jmp    10291f <__alltraps>

001022d7 <vector120>:
.globl vector120
vector120:
  pushl $0
  1022d7:	6a 00                	push   $0x0
  pushl $120
  1022d9:	6a 78                	push   $0x78
  jmp __alltraps
  1022db:	e9 3f 06 00 00       	jmp    10291f <__alltraps>

001022e0 <vector121>:
.globl vector121
vector121:
  pushl $0
  1022e0:	6a 00                	push   $0x0
  pushl $121
  1022e2:	6a 79                	push   $0x79
  jmp __alltraps
  1022e4:	e9 36 06 00 00       	jmp    10291f <__alltraps>

001022e9 <vector122>:
.globl vector122
vector122:
  pushl $0
  1022e9:	6a 00                	push   $0x0
  pushl $122
  1022eb:	6a 7a                	push   $0x7a
  jmp __alltraps
  1022ed:	e9 2d 06 00 00       	jmp    10291f <__alltraps>

001022f2 <vector123>:
.globl vector123
vector123:
  pushl $0
  1022f2:	6a 00                	push   $0x0
  pushl $123
  1022f4:	6a 7b                	push   $0x7b
  jmp __alltraps
  1022f6:	e9 24 06 00 00       	jmp    10291f <__alltraps>

001022fb <vector124>:
.globl vector124
vector124:
  pushl $0
  1022fb:	6a 00                	push   $0x0
  pushl $124
  1022fd:	6a 7c                	push   $0x7c
  jmp __alltraps
  1022ff:	e9 1b 06 00 00       	jmp    10291f <__alltraps>

00102304 <vector125>:
.globl vector125
vector125:
  pushl $0
  102304:	6a 00                	push   $0x0
  pushl $125
  102306:	6a 7d                	push   $0x7d
  jmp __alltraps
  102308:	e9 12 06 00 00       	jmp    10291f <__alltraps>

0010230d <vector126>:
.globl vector126
vector126:
  pushl $0
  10230d:	6a 00                	push   $0x0
  pushl $126
  10230f:	6a 7e                	push   $0x7e
  jmp __alltraps
  102311:	e9 09 06 00 00       	jmp    10291f <__alltraps>

00102316 <vector127>:
.globl vector127
vector127:
  pushl $0
  102316:	6a 00                	push   $0x0
  pushl $127
  102318:	6a 7f                	push   $0x7f
  jmp __alltraps
  10231a:	e9 00 06 00 00       	jmp    10291f <__alltraps>

0010231f <vector128>:
.globl vector128
vector128:
  pushl $0
  10231f:	6a 00                	push   $0x0
  pushl $128
  102321:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  102326:	e9 f4 05 00 00       	jmp    10291f <__alltraps>

0010232b <vector129>:
.globl vector129
vector129:
  pushl $0
  10232b:	6a 00                	push   $0x0
  pushl $129
  10232d:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  102332:	e9 e8 05 00 00       	jmp    10291f <__alltraps>

00102337 <vector130>:
.globl vector130
vector130:
  pushl $0
  102337:	6a 00                	push   $0x0
  pushl $130
  102339:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  10233e:	e9 dc 05 00 00       	jmp    10291f <__alltraps>

00102343 <vector131>:
.globl vector131
vector131:
  pushl $0
  102343:	6a 00                	push   $0x0
  pushl $131
  102345:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  10234a:	e9 d0 05 00 00       	jmp    10291f <__alltraps>

0010234f <vector132>:
.globl vector132
vector132:
  pushl $0
  10234f:	6a 00                	push   $0x0
  pushl $132
  102351:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  102356:	e9 c4 05 00 00       	jmp    10291f <__alltraps>

0010235b <vector133>:
.globl vector133
vector133:
  pushl $0
  10235b:	6a 00                	push   $0x0
  pushl $133
  10235d:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  102362:	e9 b8 05 00 00       	jmp    10291f <__alltraps>

00102367 <vector134>:
.globl vector134
vector134:
  pushl $0
  102367:	6a 00                	push   $0x0
  pushl $134
  102369:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  10236e:	e9 ac 05 00 00       	jmp    10291f <__alltraps>

00102373 <vector135>:
.globl vector135
vector135:
  pushl $0
  102373:	6a 00                	push   $0x0
  pushl $135
  102375:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  10237a:	e9 a0 05 00 00       	jmp    10291f <__alltraps>

0010237f <vector136>:
.globl vector136
vector136:
  pushl $0
  10237f:	6a 00                	push   $0x0
  pushl $136
  102381:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  102386:	e9 94 05 00 00       	jmp    10291f <__alltraps>

0010238b <vector137>:
.globl vector137
vector137:
  pushl $0
  10238b:	6a 00                	push   $0x0
  pushl $137
  10238d:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  102392:	e9 88 05 00 00       	jmp    10291f <__alltraps>

00102397 <vector138>:
.globl vector138
vector138:
  pushl $0
  102397:	6a 00                	push   $0x0
  pushl $138
  102399:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  10239e:	e9 7c 05 00 00       	jmp    10291f <__alltraps>

001023a3 <vector139>:
.globl vector139
vector139:
  pushl $0
  1023a3:	6a 00                	push   $0x0
  pushl $139
  1023a5:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  1023aa:	e9 70 05 00 00       	jmp    10291f <__alltraps>

001023af <vector140>:
.globl vector140
vector140:
  pushl $0
  1023af:	6a 00                	push   $0x0
  pushl $140
  1023b1:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  1023b6:	e9 64 05 00 00       	jmp    10291f <__alltraps>

001023bb <vector141>:
.globl vector141
vector141:
  pushl $0
  1023bb:	6a 00                	push   $0x0
  pushl $141
  1023bd:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  1023c2:	e9 58 05 00 00       	jmp    10291f <__alltraps>

001023c7 <vector142>:
.globl vector142
vector142:
  pushl $0
  1023c7:	6a 00                	push   $0x0
  pushl $142
  1023c9:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  1023ce:	e9 4c 05 00 00       	jmp    10291f <__alltraps>

001023d3 <vector143>:
.globl vector143
vector143:
  pushl $0
  1023d3:	6a 00                	push   $0x0
  pushl $143
  1023d5:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  1023da:	e9 40 05 00 00       	jmp    10291f <__alltraps>

001023df <vector144>:
.globl vector144
vector144:
  pushl $0
  1023df:	6a 00                	push   $0x0
  pushl $144
  1023e1:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  1023e6:	e9 34 05 00 00       	jmp    10291f <__alltraps>

001023eb <vector145>:
.globl vector145
vector145:
  pushl $0
  1023eb:	6a 00                	push   $0x0
  pushl $145
  1023ed:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  1023f2:	e9 28 05 00 00       	jmp    10291f <__alltraps>

001023f7 <vector146>:
.globl vector146
vector146:
  pushl $0
  1023f7:	6a 00                	push   $0x0
  pushl $146
  1023f9:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  1023fe:	e9 1c 05 00 00       	jmp    10291f <__alltraps>

00102403 <vector147>:
.globl vector147
vector147:
  pushl $0
  102403:	6a 00                	push   $0x0
  pushl $147
  102405:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  10240a:	e9 10 05 00 00       	jmp    10291f <__alltraps>

0010240f <vector148>:
.globl vector148
vector148:
  pushl $0
  10240f:	6a 00                	push   $0x0
  pushl $148
  102411:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  102416:	e9 04 05 00 00       	jmp    10291f <__alltraps>

0010241b <vector149>:
.globl vector149
vector149:
  pushl $0
  10241b:	6a 00                	push   $0x0
  pushl $149
  10241d:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  102422:	e9 f8 04 00 00       	jmp    10291f <__alltraps>

00102427 <vector150>:
.globl vector150
vector150:
  pushl $0
  102427:	6a 00                	push   $0x0
  pushl $150
  102429:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  10242e:	e9 ec 04 00 00       	jmp    10291f <__alltraps>

00102433 <vector151>:
.globl vector151
vector151:
  pushl $0
  102433:	6a 00                	push   $0x0
  pushl $151
  102435:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  10243a:	e9 e0 04 00 00       	jmp    10291f <__alltraps>

0010243f <vector152>:
.globl vector152
vector152:
  pushl $0
  10243f:	6a 00                	push   $0x0
  pushl $152
  102441:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  102446:	e9 d4 04 00 00       	jmp    10291f <__alltraps>

0010244b <vector153>:
.globl vector153
vector153:
  pushl $0
  10244b:	6a 00                	push   $0x0
  pushl $153
  10244d:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  102452:	e9 c8 04 00 00       	jmp    10291f <__alltraps>

00102457 <vector154>:
.globl vector154
vector154:
  pushl $0
  102457:	6a 00                	push   $0x0
  pushl $154
  102459:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  10245e:	e9 bc 04 00 00       	jmp    10291f <__alltraps>

00102463 <vector155>:
.globl vector155
vector155:
  pushl $0
  102463:	6a 00                	push   $0x0
  pushl $155
  102465:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  10246a:	e9 b0 04 00 00       	jmp    10291f <__alltraps>

0010246f <vector156>:
.globl vector156
vector156:
  pushl $0
  10246f:	6a 00                	push   $0x0
  pushl $156
  102471:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  102476:	e9 a4 04 00 00       	jmp    10291f <__alltraps>

0010247b <vector157>:
.globl vector157
vector157:
  pushl $0
  10247b:	6a 00                	push   $0x0
  pushl $157
  10247d:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  102482:	e9 98 04 00 00       	jmp    10291f <__alltraps>

00102487 <vector158>:
.globl vector158
vector158:
  pushl $0
  102487:	6a 00                	push   $0x0
  pushl $158
  102489:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  10248e:	e9 8c 04 00 00       	jmp    10291f <__alltraps>

00102493 <vector159>:
.globl vector159
vector159:
  pushl $0
  102493:	6a 00                	push   $0x0
  pushl $159
  102495:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  10249a:	e9 80 04 00 00       	jmp    10291f <__alltraps>

0010249f <vector160>:
.globl vector160
vector160:
  pushl $0
  10249f:	6a 00                	push   $0x0
  pushl $160
  1024a1:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  1024a6:	e9 74 04 00 00       	jmp    10291f <__alltraps>

001024ab <vector161>:
.globl vector161
vector161:
  pushl $0
  1024ab:	6a 00                	push   $0x0
  pushl $161
  1024ad:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  1024b2:	e9 68 04 00 00       	jmp    10291f <__alltraps>

001024b7 <vector162>:
.globl vector162
vector162:
  pushl $0
  1024b7:	6a 00                	push   $0x0
  pushl $162
  1024b9:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  1024be:	e9 5c 04 00 00       	jmp    10291f <__alltraps>

001024c3 <vector163>:
.globl vector163
vector163:
  pushl $0
  1024c3:	6a 00                	push   $0x0
  pushl $163
  1024c5:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  1024ca:	e9 50 04 00 00       	jmp    10291f <__alltraps>

001024cf <vector164>:
.globl vector164
vector164:
  pushl $0
  1024cf:	6a 00                	push   $0x0
  pushl $164
  1024d1:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  1024d6:	e9 44 04 00 00       	jmp    10291f <__alltraps>

001024db <vector165>:
.globl vector165
vector165:
  pushl $0
  1024db:	6a 00                	push   $0x0
  pushl $165
  1024dd:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  1024e2:	e9 38 04 00 00       	jmp    10291f <__alltraps>

001024e7 <vector166>:
.globl vector166
vector166:
  pushl $0
  1024e7:	6a 00                	push   $0x0
  pushl $166
  1024e9:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  1024ee:	e9 2c 04 00 00       	jmp    10291f <__alltraps>

001024f3 <vector167>:
.globl vector167
vector167:
  pushl $0
  1024f3:	6a 00                	push   $0x0
  pushl $167
  1024f5:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  1024fa:	e9 20 04 00 00       	jmp    10291f <__alltraps>

001024ff <vector168>:
.globl vector168
vector168:
  pushl $0
  1024ff:	6a 00                	push   $0x0
  pushl $168
  102501:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  102506:	e9 14 04 00 00       	jmp    10291f <__alltraps>

0010250b <vector169>:
.globl vector169
vector169:
  pushl $0
  10250b:	6a 00                	push   $0x0
  pushl $169
  10250d:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  102512:	e9 08 04 00 00       	jmp    10291f <__alltraps>

00102517 <vector170>:
.globl vector170
vector170:
  pushl $0
  102517:	6a 00                	push   $0x0
  pushl $170
  102519:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  10251e:	e9 fc 03 00 00       	jmp    10291f <__alltraps>

00102523 <vector171>:
.globl vector171
vector171:
  pushl $0
  102523:	6a 00                	push   $0x0
  pushl $171
  102525:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  10252a:	e9 f0 03 00 00       	jmp    10291f <__alltraps>

0010252f <vector172>:
.globl vector172
vector172:
  pushl $0
  10252f:	6a 00                	push   $0x0
  pushl $172
  102531:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  102536:	e9 e4 03 00 00       	jmp    10291f <__alltraps>

0010253b <vector173>:
.globl vector173
vector173:
  pushl $0
  10253b:	6a 00                	push   $0x0
  pushl $173
  10253d:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  102542:	e9 d8 03 00 00       	jmp    10291f <__alltraps>

00102547 <vector174>:
.globl vector174
vector174:
  pushl $0
  102547:	6a 00                	push   $0x0
  pushl $174
  102549:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  10254e:	e9 cc 03 00 00       	jmp    10291f <__alltraps>

00102553 <vector175>:
.globl vector175
vector175:
  pushl $0
  102553:	6a 00                	push   $0x0
  pushl $175
  102555:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  10255a:	e9 c0 03 00 00       	jmp    10291f <__alltraps>

0010255f <vector176>:
.globl vector176
vector176:
  pushl $0
  10255f:	6a 00                	push   $0x0
  pushl $176
  102561:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  102566:	e9 b4 03 00 00       	jmp    10291f <__alltraps>

0010256b <vector177>:
.globl vector177
vector177:
  pushl $0
  10256b:	6a 00                	push   $0x0
  pushl $177
  10256d:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  102572:	e9 a8 03 00 00       	jmp    10291f <__alltraps>

00102577 <vector178>:
.globl vector178
vector178:
  pushl $0
  102577:	6a 00                	push   $0x0
  pushl $178
  102579:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  10257e:	e9 9c 03 00 00       	jmp    10291f <__alltraps>

00102583 <vector179>:
.globl vector179
vector179:
  pushl $0
  102583:	6a 00                	push   $0x0
  pushl $179
  102585:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  10258a:	e9 90 03 00 00       	jmp    10291f <__alltraps>

0010258f <vector180>:
.globl vector180
vector180:
  pushl $0
  10258f:	6a 00                	push   $0x0
  pushl $180
  102591:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  102596:	e9 84 03 00 00       	jmp    10291f <__alltraps>

0010259b <vector181>:
.globl vector181
vector181:
  pushl $0
  10259b:	6a 00                	push   $0x0
  pushl $181
  10259d:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  1025a2:	e9 78 03 00 00       	jmp    10291f <__alltraps>

001025a7 <vector182>:
.globl vector182
vector182:
  pushl $0
  1025a7:	6a 00                	push   $0x0
  pushl $182
  1025a9:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  1025ae:	e9 6c 03 00 00       	jmp    10291f <__alltraps>

001025b3 <vector183>:
.globl vector183
vector183:
  pushl $0
  1025b3:	6a 00                	push   $0x0
  pushl $183
  1025b5:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  1025ba:	e9 60 03 00 00       	jmp    10291f <__alltraps>

001025bf <vector184>:
.globl vector184
vector184:
  pushl $0
  1025bf:	6a 00                	push   $0x0
  pushl $184
  1025c1:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  1025c6:	e9 54 03 00 00       	jmp    10291f <__alltraps>

001025cb <vector185>:
.globl vector185
vector185:
  pushl $0
  1025cb:	6a 00                	push   $0x0
  pushl $185
  1025cd:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  1025d2:	e9 48 03 00 00       	jmp    10291f <__alltraps>

001025d7 <vector186>:
.globl vector186
vector186:
  pushl $0
  1025d7:	6a 00                	push   $0x0
  pushl $186
  1025d9:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  1025de:	e9 3c 03 00 00       	jmp    10291f <__alltraps>

001025e3 <vector187>:
.globl vector187
vector187:
  pushl $0
  1025e3:	6a 00                	push   $0x0
  pushl $187
  1025e5:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  1025ea:	e9 30 03 00 00       	jmp    10291f <__alltraps>

001025ef <vector188>:
.globl vector188
vector188:
  pushl $0
  1025ef:	6a 00                	push   $0x0
  pushl $188
  1025f1:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  1025f6:	e9 24 03 00 00       	jmp    10291f <__alltraps>

001025fb <vector189>:
.globl vector189
vector189:
  pushl $0
  1025fb:	6a 00                	push   $0x0
  pushl $189
  1025fd:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  102602:	e9 18 03 00 00       	jmp    10291f <__alltraps>

00102607 <vector190>:
.globl vector190
vector190:
  pushl $0
  102607:	6a 00                	push   $0x0
  pushl $190
  102609:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  10260e:	e9 0c 03 00 00       	jmp    10291f <__alltraps>

00102613 <vector191>:
.globl vector191
vector191:
  pushl $0
  102613:	6a 00                	push   $0x0
  pushl $191
  102615:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  10261a:	e9 00 03 00 00       	jmp    10291f <__alltraps>

0010261f <vector192>:
.globl vector192
vector192:
  pushl $0
  10261f:	6a 00                	push   $0x0
  pushl $192
  102621:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  102626:	e9 f4 02 00 00       	jmp    10291f <__alltraps>

0010262b <vector193>:
.globl vector193
vector193:
  pushl $0
  10262b:	6a 00                	push   $0x0
  pushl $193
  10262d:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  102632:	e9 e8 02 00 00       	jmp    10291f <__alltraps>

00102637 <vector194>:
.globl vector194
vector194:
  pushl $0
  102637:	6a 00                	push   $0x0
  pushl $194
  102639:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  10263e:	e9 dc 02 00 00       	jmp    10291f <__alltraps>

00102643 <vector195>:
.globl vector195
vector195:
  pushl $0
  102643:	6a 00                	push   $0x0
  pushl $195
  102645:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  10264a:	e9 d0 02 00 00       	jmp    10291f <__alltraps>

0010264f <vector196>:
.globl vector196
vector196:
  pushl $0
  10264f:	6a 00                	push   $0x0
  pushl $196
  102651:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  102656:	e9 c4 02 00 00       	jmp    10291f <__alltraps>

0010265b <vector197>:
.globl vector197
vector197:
  pushl $0
  10265b:	6a 00                	push   $0x0
  pushl $197
  10265d:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  102662:	e9 b8 02 00 00       	jmp    10291f <__alltraps>

00102667 <vector198>:
.globl vector198
vector198:
  pushl $0
  102667:	6a 00                	push   $0x0
  pushl $198
  102669:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  10266e:	e9 ac 02 00 00       	jmp    10291f <__alltraps>

00102673 <vector199>:
.globl vector199
vector199:
  pushl $0
  102673:	6a 00                	push   $0x0
  pushl $199
  102675:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  10267a:	e9 a0 02 00 00       	jmp    10291f <__alltraps>

0010267f <vector200>:
.globl vector200
vector200:
  pushl $0
  10267f:	6a 00                	push   $0x0
  pushl $200
  102681:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  102686:	e9 94 02 00 00       	jmp    10291f <__alltraps>

0010268b <vector201>:
.globl vector201
vector201:
  pushl $0
  10268b:	6a 00                	push   $0x0
  pushl $201
  10268d:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  102692:	e9 88 02 00 00       	jmp    10291f <__alltraps>

00102697 <vector202>:
.globl vector202
vector202:
  pushl $0
  102697:	6a 00                	push   $0x0
  pushl $202
  102699:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  10269e:	e9 7c 02 00 00       	jmp    10291f <__alltraps>

001026a3 <vector203>:
.globl vector203
vector203:
  pushl $0
  1026a3:	6a 00                	push   $0x0
  pushl $203
  1026a5:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  1026aa:	e9 70 02 00 00       	jmp    10291f <__alltraps>

001026af <vector204>:
.globl vector204
vector204:
  pushl $0
  1026af:	6a 00                	push   $0x0
  pushl $204
  1026b1:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  1026b6:	e9 64 02 00 00       	jmp    10291f <__alltraps>

001026bb <vector205>:
.globl vector205
vector205:
  pushl $0
  1026bb:	6a 00                	push   $0x0
  pushl $205
  1026bd:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  1026c2:	e9 58 02 00 00       	jmp    10291f <__alltraps>

001026c7 <vector206>:
.globl vector206
vector206:
  pushl $0
  1026c7:	6a 00                	push   $0x0
  pushl $206
  1026c9:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  1026ce:	e9 4c 02 00 00       	jmp    10291f <__alltraps>

001026d3 <vector207>:
.globl vector207
vector207:
  pushl $0
  1026d3:	6a 00                	push   $0x0
  pushl $207
  1026d5:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  1026da:	e9 40 02 00 00       	jmp    10291f <__alltraps>

001026df <vector208>:
.globl vector208
vector208:
  pushl $0
  1026df:	6a 00                	push   $0x0
  pushl $208
  1026e1:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  1026e6:	e9 34 02 00 00       	jmp    10291f <__alltraps>

001026eb <vector209>:
.globl vector209
vector209:
  pushl $0
  1026eb:	6a 00                	push   $0x0
  pushl $209
  1026ed:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  1026f2:	e9 28 02 00 00       	jmp    10291f <__alltraps>

001026f7 <vector210>:
.globl vector210
vector210:
  pushl $0
  1026f7:	6a 00                	push   $0x0
  pushl $210
  1026f9:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  1026fe:	e9 1c 02 00 00       	jmp    10291f <__alltraps>

00102703 <vector211>:
.globl vector211
vector211:
  pushl $0
  102703:	6a 00                	push   $0x0
  pushl $211
  102705:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  10270a:	e9 10 02 00 00       	jmp    10291f <__alltraps>

0010270f <vector212>:
.globl vector212
vector212:
  pushl $0
  10270f:	6a 00                	push   $0x0
  pushl $212
  102711:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  102716:	e9 04 02 00 00       	jmp    10291f <__alltraps>

0010271b <vector213>:
.globl vector213
vector213:
  pushl $0
  10271b:	6a 00                	push   $0x0
  pushl $213
  10271d:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  102722:	e9 f8 01 00 00       	jmp    10291f <__alltraps>

00102727 <vector214>:
.globl vector214
vector214:
  pushl $0
  102727:	6a 00                	push   $0x0
  pushl $214
  102729:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  10272e:	e9 ec 01 00 00       	jmp    10291f <__alltraps>

00102733 <vector215>:
.globl vector215
vector215:
  pushl $0
  102733:	6a 00                	push   $0x0
  pushl $215
  102735:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  10273a:	e9 e0 01 00 00       	jmp    10291f <__alltraps>

0010273f <vector216>:
.globl vector216
vector216:
  pushl $0
  10273f:	6a 00                	push   $0x0
  pushl $216
  102741:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  102746:	e9 d4 01 00 00       	jmp    10291f <__alltraps>

0010274b <vector217>:
.globl vector217
vector217:
  pushl $0
  10274b:	6a 00                	push   $0x0
  pushl $217
  10274d:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  102752:	e9 c8 01 00 00       	jmp    10291f <__alltraps>

00102757 <vector218>:
.globl vector218
vector218:
  pushl $0
  102757:	6a 00                	push   $0x0
  pushl $218
  102759:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  10275e:	e9 bc 01 00 00       	jmp    10291f <__alltraps>

00102763 <vector219>:
.globl vector219
vector219:
  pushl $0
  102763:	6a 00                	push   $0x0
  pushl $219
  102765:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  10276a:	e9 b0 01 00 00       	jmp    10291f <__alltraps>

0010276f <vector220>:
.globl vector220
vector220:
  pushl $0
  10276f:	6a 00                	push   $0x0
  pushl $220
  102771:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  102776:	e9 a4 01 00 00       	jmp    10291f <__alltraps>

0010277b <vector221>:
.globl vector221
vector221:
  pushl $0
  10277b:	6a 00                	push   $0x0
  pushl $221
  10277d:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  102782:	e9 98 01 00 00       	jmp    10291f <__alltraps>

00102787 <vector222>:
.globl vector222
vector222:
  pushl $0
  102787:	6a 00                	push   $0x0
  pushl $222
  102789:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  10278e:	e9 8c 01 00 00       	jmp    10291f <__alltraps>

00102793 <vector223>:
.globl vector223
vector223:
  pushl $0
  102793:	6a 00                	push   $0x0
  pushl $223
  102795:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  10279a:	e9 80 01 00 00       	jmp    10291f <__alltraps>

0010279f <vector224>:
.globl vector224
vector224:
  pushl $0
  10279f:	6a 00                	push   $0x0
  pushl $224
  1027a1:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  1027a6:	e9 74 01 00 00       	jmp    10291f <__alltraps>

001027ab <vector225>:
.globl vector225
vector225:
  pushl $0
  1027ab:	6a 00                	push   $0x0
  pushl $225
  1027ad:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  1027b2:	e9 68 01 00 00       	jmp    10291f <__alltraps>

001027b7 <vector226>:
.globl vector226
vector226:
  pushl $0
  1027b7:	6a 00                	push   $0x0
  pushl $226
  1027b9:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  1027be:	e9 5c 01 00 00       	jmp    10291f <__alltraps>

001027c3 <vector227>:
.globl vector227
vector227:
  pushl $0
  1027c3:	6a 00                	push   $0x0
  pushl $227
  1027c5:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  1027ca:	e9 50 01 00 00       	jmp    10291f <__alltraps>

001027cf <vector228>:
.globl vector228
vector228:
  pushl $0
  1027cf:	6a 00                	push   $0x0
  pushl $228
  1027d1:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  1027d6:	e9 44 01 00 00       	jmp    10291f <__alltraps>

001027db <vector229>:
.globl vector229
vector229:
  pushl $0
  1027db:	6a 00                	push   $0x0
  pushl $229
  1027dd:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  1027e2:	e9 38 01 00 00       	jmp    10291f <__alltraps>

001027e7 <vector230>:
.globl vector230
vector230:
  pushl $0
  1027e7:	6a 00                	push   $0x0
  pushl $230
  1027e9:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  1027ee:	e9 2c 01 00 00       	jmp    10291f <__alltraps>

001027f3 <vector231>:
.globl vector231
vector231:
  pushl $0
  1027f3:	6a 00                	push   $0x0
  pushl $231
  1027f5:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  1027fa:	e9 20 01 00 00       	jmp    10291f <__alltraps>

001027ff <vector232>:
.globl vector232
vector232:
  pushl $0
  1027ff:	6a 00                	push   $0x0
  pushl $232
  102801:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  102806:	e9 14 01 00 00       	jmp    10291f <__alltraps>

0010280b <vector233>:
.globl vector233
vector233:
  pushl $0
  10280b:	6a 00                	push   $0x0
  pushl $233
  10280d:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  102812:	e9 08 01 00 00       	jmp    10291f <__alltraps>

00102817 <vector234>:
.globl vector234
vector234:
  pushl $0
  102817:	6a 00                	push   $0x0
  pushl $234
  102819:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  10281e:	e9 fc 00 00 00       	jmp    10291f <__alltraps>

00102823 <vector235>:
.globl vector235
vector235:
  pushl $0
  102823:	6a 00                	push   $0x0
  pushl $235
  102825:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  10282a:	e9 f0 00 00 00       	jmp    10291f <__alltraps>

0010282f <vector236>:
.globl vector236
vector236:
  pushl $0
  10282f:	6a 00                	push   $0x0
  pushl $236
  102831:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  102836:	e9 e4 00 00 00       	jmp    10291f <__alltraps>

0010283b <vector237>:
.globl vector237
vector237:
  pushl $0
  10283b:	6a 00                	push   $0x0
  pushl $237
  10283d:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  102842:	e9 d8 00 00 00       	jmp    10291f <__alltraps>

00102847 <vector238>:
.globl vector238
vector238:
  pushl $0
  102847:	6a 00                	push   $0x0
  pushl $238
  102849:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  10284e:	e9 cc 00 00 00       	jmp    10291f <__alltraps>

00102853 <vector239>:
.globl vector239
vector239:
  pushl $0
  102853:	6a 00                	push   $0x0
  pushl $239
  102855:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  10285a:	e9 c0 00 00 00       	jmp    10291f <__alltraps>

0010285f <vector240>:
.globl vector240
vector240:
  pushl $0
  10285f:	6a 00                	push   $0x0
  pushl $240
  102861:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  102866:	e9 b4 00 00 00       	jmp    10291f <__alltraps>

0010286b <vector241>:
.globl vector241
vector241:
  pushl $0
  10286b:	6a 00                	push   $0x0
  pushl $241
  10286d:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  102872:	e9 a8 00 00 00       	jmp    10291f <__alltraps>

00102877 <vector242>:
.globl vector242
vector242:
  pushl $0
  102877:	6a 00                	push   $0x0
  pushl $242
  102879:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  10287e:	e9 9c 00 00 00       	jmp    10291f <__alltraps>

00102883 <vector243>:
.globl vector243
vector243:
  pushl $0
  102883:	6a 00                	push   $0x0
  pushl $243
  102885:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  10288a:	e9 90 00 00 00       	jmp    10291f <__alltraps>

0010288f <vector244>:
.globl vector244
vector244:
  pushl $0
  10288f:	6a 00                	push   $0x0
  pushl $244
  102891:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  102896:	e9 84 00 00 00       	jmp    10291f <__alltraps>

0010289b <vector245>:
.globl vector245
vector245:
  pushl $0
  10289b:	6a 00                	push   $0x0
  pushl $245
  10289d:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  1028a2:	e9 78 00 00 00       	jmp    10291f <__alltraps>

001028a7 <vector246>:
.globl vector246
vector246:
  pushl $0
  1028a7:	6a 00                	push   $0x0
  pushl $246
  1028a9:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  1028ae:	e9 6c 00 00 00       	jmp    10291f <__alltraps>

001028b3 <vector247>:
.globl vector247
vector247:
  pushl $0
  1028b3:	6a 00                	push   $0x0
  pushl $247
  1028b5:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  1028ba:	e9 60 00 00 00       	jmp    10291f <__alltraps>

001028bf <vector248>:
.globl vector248
vector248:
  pushl $0
  1028bf:	6a 00                	push   $0x0
  pushl $248
  1028c1:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  1028c6:	e9 54 00 00 00       	jmp    10291f <__alltraps>

001028cb <vector249>:
.globl vector249
vector249:
  pushl $0
  1028cb:	6a 00                	push   $0x0
  pushl $249
  1028cd:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  1028d2:	e9 48 00 00 00       	jmp    10291f <__alltraps>

001028d7 <vector250>:
.globl vector250
vector250:
  pushl $0
  1028d7:	6a 00                	push   $0x0
  pushl $250
  1028d9:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  1028de:	e9 3c 00 00 00       	jmp    10291f <__alltraps>

001028e3 <vector251>:
.globl vector251
vector251:
  pushl $0
  1028e3:	6a 00                	push   $0x0
  pushl $251
  1028e5:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  1028ea:	e9 30 00 00 00       	jmp    10291f <__alltraps>

001028ef <vector252>:
.globl vector252
vector252:
  pushl $0
  1028ef:	6a 00                	push   $0x0
  pushl $252
  1028f1:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  1028f6:	e9 24 00 00 00       	jmp    10291f <__alltraps>

001028fb <vector253>:
.globl vector253
vector253:
  pushl $0
  1028fb:	6a 00                	push   $0x0
  pushl $253
  1028fd:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102902:	e9 18 00 00 00       	jmp    10291f <__alltraps>

00102907 <vector254>:
.globl vector254
vector254:
  pushl $0
  102907:	6a 00                	push   $0x0
  pushl $254
  102909:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  10290e:	e9 0c 00 00 00       	jmp    10291f <__alltraps>

00102913 <vector255>:
.globl vector255
vector255:
  pushl $0
  102913:	6a 00                	push   $0x0
  pushl $255
  102915:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  10291a:	e9 00 00 00 00       	jmp    10291f <__alltraps>

0010291f <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  10291f:	1e                   	push   %ds
    pushl %es
  102920:	06                   	push   %es
    pushl %fs
  102921:	0f a0                	push   %fs
    pushl %gs
  102923:	0f a8                	push   %gs
    pushal
  102925:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  102926:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  10292b:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  10292d:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  10292f:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  102930:	e8 65 f5 ff ff       	call   101e9a <trap>

    # pop the pushed stack pointer
    popl %esp
  102935:	5c                   	pop    %esp

00102936 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  102936:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  102937:	0f a9                	pop    %gs
    popl %fs
  102939:	0f a1                	pop    %fs
    popl %es
  10293b:	07                   	pop    %es
    popl %ds
  10293c:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  10293d:	83 c4 08             	add    $0x8,%esp
    iret
  102940:	cf                   	iret   

00102941 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  102941:	55                   	push   %ebp
  102942:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  102944:	8b 45 08             	mov    0x8(%ebp),%eax
  102947:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  10294a:	b8 23 00 00 00       	mov    $0x23,%eax
  10294f:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  102951:	b8 23 00 00 00       	mov    $0x23,%eax
  102956:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  102958:	b8 10 00 00 00       	mov    $0x10,%eax
  10295d:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  10295f:	b8 10 00 00 00       	mov    $0x10,%eax
  102964:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  102966:	b8 10 00 00 00       	mov    $0x10,%eax
  10296b:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  10296d:	ea 74 29 10 00 08 00 	ljmp   $0x8,$0x102974
}
  102974:	5d                   	pop    %ebp
  102975:	c3                   	ret    

00102976 <gdt_init>:
/* temporary kernel stack */
uint8_t stack0[1024];

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  102976:	55                   	push   %ebp
  102977:	89 e5                	mov    %esp,%ebp
  102979:	83 ec 14             	sub    $0x14,%esp
    // Setup a TSS so that we can get the right stack when we trap from
    // user to the kernel. But not safe here, it's only a temporary value,
    // it will be set to KSTACKTOP in lab2.
    ts.ts_esp0 = (uint32_t)&stack0 + sizeof(stack0);
  10297c:	b8 80 f9 10 00       	mov    $0x10f980,%eax
  102981:	05 00 04 00 00       	add    $0x400,%eax
  102986:	a3 a4 f8 10 00       	mov    %eax,0x10f8a4
    ts.ts_ss0 = KERNEL_DS;
  10298b:	66 c7 05 a8 f8 10 00 	movw   $0x10,0x10f8a8
  102992:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEG16(STS_T32A, (uint32_t)&ts, sizeof(ts), DPL_KERNEL);
  102994:	66 c7 05 08 ea 10 00 	movw   $0x68,0x10ea08
  10299b:	68 00 
  10299d:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  1029a2:	66 a3 0a ea 10 00    	mov    %ax,0x10ea0a
  1029a8:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  1029ad:	c1 e8 10             	shr    $0x10,%eax
  1029b0:	a2 0c ea 10 00       	mov    %al,0x10ea0c
  1029b5:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1029bc:	83 e0 f0             	and    $0xfffffff0,%eax
  1029bf:	83 c8 09             	or     $0x9,%eax
  1029c2:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  1029c7:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1029ce:	83 c8 10             	or     $0x10,%eax
  1029d1:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  1029d6:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1029dd:	83 e0 9f             	and    $0xffffff9f,%eax
  1029e0:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  1029e5:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1029ec:	83 c8 80             	or     $0xffffff80,%eax
  1029ef:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  1029f4:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  1029fb:	83 e0 f0             	and    $0xfffffff0,%eax
  1029fe:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102a03:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102a0a:	83 e0 ef             	and    $0xffffffef,%eax
  102a0d:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102a12:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102a19:	83 e0 df             	and    $0xffffffdf,%eax
  102a1c:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102a21:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102a28:	83 c8 40             	or     $0x40,%eax
  102a2b:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102a30:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102a37:	83 e0 7f             	and    $0x7f,%eax
  102a3a:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102a3f:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  102a44:	c1 e8 18             	shr    $0x18,%eax
  102a47:	a2 0f ea 10 00       	mov    %al,0x10ea0f
    gdt[SEG_TSS].sd_s = 0;
  102a4c:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102a53:	83 e0 ef             	and    $0xffffffef,%eax
  102a56:	a2 0d ea 10 00       	mov    %al,0x10ea0d

    // reload all segment registers
    lgdt(&gdt_pd);
  102a5b:	c7 04 24 10 ea 10 00 	movl   $0x10ea10,(%esp)
  102a62:	e8 da fe ff ff       	call   102941 <lgdt>
  102a67:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel));
  102a6d:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  102a71:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  102a74:	c9                   	leave  
  102a75:	c3                   	ret    

00102a76 <pmm_init>:

/* pmm_init - initialize the physical memory management */
void
pmm_init(void) {
  102a76:	55                   	push   %ebp
  102a77:	89 e5                	mov    %esp,%ebp
    gdt_init();
  102a79:	e8 f8 fe ff ff       	call   102976 <gdt_init>
}
  102a7e:	5d                   	pop    %ebp
  102a7f:	c3                   	ret    

00102a80 <strlen>:
 * @s:        the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  102a80:	55                   	push   %ebp
  102a81:	89 e5                	mov    %esp,%ebp
  102a83:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102a86:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  102a8d:	eb 04                	jmp    102a93 <strlen+0x13>
        cnt ++;
  102a8f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    while (*s ++ != '\0') {
  102a93:	8b 45 08             	mov    0x8(%ebp),%eax
  102a96:	8d 50 01             	lea    0x1(%eax),%edx
  102a99:	89 55 08             	mov    %edx,0x8(%ebp)
  102a9c:	0f b6 00             	movzbl (%eax),%eax
  102a9f:	84 c0                	test   %al,%al
  102aa1:	75 ec                	jne    102a8f <strlen+0xf>
    }
    return cnt;
  102aa3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102aa6:	c9                   	leave  
  102aa7:	c3                   	ret    

00102aa8 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  102aa8:	55                   	push   %ebp
  102aa9:	89 e5                	mov    %esp,%ebp
  102aab:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102aae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  102ab5:	eb 04                	jmp    102abb <strnlen+0x13>
        cnt ++;
  102ab7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  102abb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102abe:	3b 45 0c             	cmp    0xc(%ebp),%eax
  102ac1:	73 10                	jae    102ad3 <strnlen+0x2b>
  102ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  102ac6:	8d 50 01             	lea    0x1(%eax),%edx
  102ac9:	89 55 08             	mov    %edx,0x8(%ebp)
  102acc:	0f b6 00             	movzbl (%eax),%eax
  102acf:	84 c0                	test   %al,%al
  102ad1:	75 e4                	jne    102ab7 <strnlen+0xf>
    }
    return cnt;
  102ad3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102ad6:	c9                   	leave  
  102ad7:	c3                   	ret    

00102ad8 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  102ad8:	55                   	push   %ebp
  102ad9:	89 e5                	mov    %esp,%ebp
  102adb:	57                   	push   %edi
  102adc:	56                   	push   %esi
  102add:	83 ec 20             	sub    $0x20,%esp
  102ae0:	8b 45 08             	mov    0x8(%ebp),%eax
  102ae3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102ae6:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ae9:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  102aec:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102aef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102af2:	89 d1                	mov    %edx,%ecx
  102af4:	89 c2                	mov    %eax,%edx
  102af6:	89 ce                	mov    %ecx,%esi
  102af8:	89 d7                	mov    %edx,%edi
  102afa:	ac                   	lods   %ds:(%esi),%al
  102afb:	aa                   	stos   %al,%es:(%edi)
  102afc:	84 c0                	test   %al,%al
  102afe:	75 fa                	jne    102afa <strcpy+0x22>
  102b00:	89 fa                	mov    %edi,%edx
  102b02:	89 f1                	mov    %esi,%ecx
  102b04:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  102b07:	89 55 e8             	mov    %edx,-0x18(%ebp)
  102b0a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "stosb;"
            "testb %%al, %%al;"
            "jne 1b;"
            : "=&S" (d0), "=&D" (d1), "=&a" (d2)
            : "0" (src), "1" (dst) : "memory");
    return dst;
  102b0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  102b10:	83 c4 20             	add    $0x20,%esp
  102b13:	5e                   	pop    %esi
  102b14:	5f                   	pop    %edi
  102b15:	5d                   	pop    %ebp
  102b16:	c3                   	ret    

00102b17 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  102b17:	55                   	push   %ebp
  102b18:	89 e5                	mov    %esp,%ebp
  102b1a:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  102b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  102b20:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  102b23:	eb 21                	jmp    102b46 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  102b25:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b28:	0f b6 10             	movzbl (%eax),%edx
  102b2b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102b2e:	88 10                	mov    %dl,(%eax)
  102b30:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102b33:	0f b6 00             	movzbl (%eax),%eax
  102b36:	84 c0                	test   %al,%al
  102b38:	74 04                	je     102b3e <strncpy+0x27>
            src ++;
  102b3a:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  102b3e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  102b42:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    while (len > 0) {
  102b46:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102b4a:	75 d9                	jne    102b25 <strncpy+0xe>
    }
    return dst;
  102b4c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102b4f:	c9                   	leave  
  102b50:	c3                   	ret    

00102b51 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  102b51:	55                   	push   %ebp
  102b52:	89 e5                	mov    %esp,%ebp
  102b54:	57                   	push   %edi
  102b55:	56                   	push   %esi
  102b56:	83 ec 20             	sub    $0x20,%esp
  102b59:	8b 45 08             	mov    0x8(%ebp),%eax
  102b5c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102b5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b62:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
  102b65:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102b68:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102b6b:	89 d1                	mov    %edx,%ecx
  102b6d:	89 c2                	mov    %eax,%edx
  102b6f:	89 ce                	mov    %ecx,%esi
  102b71:	89 d7                	mov    %edx,%edi
  102b73:	ac                   	lods   %ds:(%esi),%al
  102b74:	ae                   	scas   %es:(%edi),%al
  102b75:	75 08                	jne    102b7f <strcmp+0x2e>
  102b77:	84 c0                	test   %al,%al
  102b79:	75 f8                	jne    102b73 <strcmp+0x22>
  102b7b:	31 c0                	xor    %eax,%eax
  102b7d:	eb 04                	jmp    102b83 <strcmp+0x32>
  102b7f:	19 c0                	sbb    %eax,%eax
  102b81:	0c 01                	or     $0x1,%al
  102b83:	89 fa                	mov    %edi,%edx
  102b85:	89 f1                	mov    %esi,%ecx
  102b87:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102b8a:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  102b8d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
  102b90:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  102b93:	83 c4 20             	add    $0x20,%esp
  102b96:	5e                   	pop    %esi
  102b97:	5f                   	pop    %edi
  102b98:	5d                   	pop    %ebp
  102b99:	c3                   	ret    

00102b9a <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  102b9a:	55                   	push   %ebp
  102b9b:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102b9d:	eb 0c                	jmp    102bab <strncmp+0x11>
        n --, s1 ++, s2 ++;
  102b9f:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  102ba3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102ba7:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102bab:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102baf:	74 1a                	je     102bcb <strncmp+0x31>
  102bb1:	8b 45 08             	mov    0x8(%ebp),%eax
  102bb4:	0f b6 00             	movzbl (%eax),%eax
  102bb7:	84 c0                	test   %al,%al
  102bb9:	74 10                	je     102bcb <strncmp+0x31>
  102bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  102bbe:	0f b6 10             	movzbl (%eax),%edx
  102bc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  102bc4:	0f b6 00             	movzbl (%eax),%eax
  102bc7:	38 c2                	cmp    %al,%dl
  102bc9:	74 d4                	je     102b9f <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  102bcb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102bcf:	74 18                	je     102be9 <strncmp+0x4f>
  102bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  102bd4:	0f b6 00             	movzbl (%eax),%eax
  102bd7:	0f b6 d0             	movzbl %al,%edx
  102bda:	8b 45 0c             	mov    0xc(%ebp),%eax
  102bdd:	0f b6 00             	movzbl (%eax),%eax
  102be0:	0f b6 c0             	movzbl %al,%eax
  102be3:	29 c2                	sub    %eax,%edx
  102be5:	89 d0                	mov    %edx,%eax
  102be7:	eb 05                	jmp    102bee <strncmp+0x54>
  102be9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102bee:	5d                   	pop    %ebp
  102bef:	c3                   	ret    

00102bf0 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  102bf0:	55                   	push   %ebp
  102bf1:	89 e5                	mov    %esp,%ebp
  102bf3:	83 ec 04             	sub    $0x4,%esp
  102bf6:	8b 45 0c             	mov    0xc(%ebp),%eax
  102bf9:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102bfc:	eb 14                	jmp    102c12 <strchr+0x22>
        if (*s == c) {
  102bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  102c01:	0f b6 00             	movzbl (%eax),%eax
  102c04:	3a 45 fc             	cmp    -0x4(%ebp),%al
  102c07:	75 05                	jne    102c0e <strchr+0x1e>
            return (char *)s;
  102c09:	8b 45 08             	mov    0x8(%ebp),%eax
  102c0c:	eb 13                	jmp    102c21 <strchr+0x31>
        }
        s ++;
  102c0e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s != '\0') {
  102c12:	8b 45 08             	mov    0x8(%ebp),%eax
  102c15:	0f b6 00             	movzbl (%eax),%eax
  102c18:	84 c0                	test   %al,%al
  102c1a:	75 e2                	jne    102bfe <strchr+0xe>
    }
    return NULL;
  102c1c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102c21:	c9                   	leave  
  102c22:	c3                   	ret    

00102c23 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  102c23:	55                   	push   %ebp
  102c24:	89 e5                	mov    %esp,%ebp
  102c26:	83 ec 04             	sub    $0x4,%esp
  102c29:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c2c:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102c2f:	eb 11                	jmp    102c42 <strfind+0x1f>
        if (*s == c) {
  102c31:	8b 45 08             	mov    0x8(%ebp),%eax
  102c34:	0f b6 00             	movzbl (%eax),%eax
  102c37:	3a 45 fc             	cmp    -0x4(%ebp),%al
  102c3a:	75 02                	jne    102c3e <strfind+0x1b>
            break;
  102c3c:	eb 0e                	jmp    102c4c <strfind+0x29>
        }
        s ++;
  102c3e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s != '\0') {
  102c42:	8b 45 08             	mov    0x8(%ebp),%eax
  102c45:	0f b6 00             	movzbl (%eax),%eax
  102c48:	84 c0                	test   %al,%al
  102c4a:	75 e5                	jne    102c31 <strfind+0xe>
    }
    return (char *)s;
  102c4c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102c4f:	c9                   	leave  
  102c50:	c3                   	ret    

00102c51 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  102c51:	55                   	push   %ebp
  102c52:	89 e5                	mov    %esp,%ebp
  102c54:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  102c57:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  102c5e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  102c65:	eb 04                	jmp    102c6b <strtol+0x1a>
        s ++;
  102c67:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
  102c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  102c6e:	0f b6 00             	movzbl (%eax),%eax
  102c71:	3c 20                	cmp    $0x20,%al
  102c73:	74 f2                	je     102c67 <strtol+0x16>
  102c75:	8b 45 08             	mov    0x8(%ebp),%eax
  102c78:	0f b6 00             	movzbl (%eax),%eax
  102c7b:	3c 09                	cmp    $0x9,%al
  102c7d:	74 e8                	je     102c67 <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+') {
  102c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  102c82:	0f b6 00             	movzbl (%eax),%eax
  102c85:	3c 2b                	cmp    $0x2b,%al
  102c87:	75 06                	jne    102c8f <strtol+0x3e>
        s ++;
  102c89:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102c8d:	eb 15                	jmp    102ca4 <strtol+0x53>
    }
    else if (*s == '-') {
  102c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  102c92:	0f b6 00             	movzbl (%eax),%eax
  102c95:	3c 2d                	cmp    $0x2d,%al
  102c97:	75 0b                	jne    102ca4 <strtol+0x53>
        s ++, neg = 1;
  102c99:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102c9d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  102ca4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102ca8:	74 06                	je     102cb0 <strtol+0x5f>
  102caa:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  102cae:	75 24                	jne    102cd4 <strtol+0x83>
  102cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  102cb3:	0f b6 00             	movzbl (%eax),%eax
  102cb6:	3c 30                	cmp    $0x30,%al
  102cb8:	75 1a                	jne    102cd4 <strtol+0x83>
  102cba:	8b 45 08             	mov    0x8(%ebp),%eax
  102cbd:	83 c0 01             	add    $0x1,%eax
  102cc0:	0f b6 00             	movzbl (%eax),%eax
  102cc3:	3c 78                	cmp    $0x78,%al
  102cc5:	75 0d                	jne    102cd4 <strtol+0x83>
        s += 2, base = 16;
  102cc7:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  102ccb:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  102cd2:	eb 2a                	jmp    102cfe <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  102cd4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102cd8:	75 17                	jne    102cf1 <strtol+0xa0>
  102cda:	8b 45 08             	mov    0x8(%ebp),%eax
  102cdd:	0f b6 00             	movzbl (%eax),%eax
  102ce0:	3c 30                	cmp    $0x30,%al
  102ce2:	75 0d                	jne    102cf1 <strtol+0xa0>
        s ++, base = 8;
  102ce4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102ce8:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  102cef:	eb 0d                	jmp    102cfe <strtol+0xad>
    }
    else if (base == 0) {
  102cf1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102cf5:	75 07                	jne    102cfe <strtol+0xad>
        base = 10;
  102cf7:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  102cfe:	8b 45 08             	mov    0x8(%ebp),%eax
  102d01:	0f b6 00             	movzbl (%eax),%eax
  102d04:	3c 2f                	cmp    $0x2f,%al
  102d06:	7e 1b                	jle    102d23 <strtol+0xd2>
  102d08:	8b 45 08             	mov    0x8(%ebp),%eax
  102d0b:	0f b6 00             	movzbl (%eax),%eax
  102d0e:	3c 39                	cmp    $0x39,%al
  102d10:	7f 11                	jg     102d23 <strtol+0xd2>
            dig = *s - '0';
  102d12:	8b 45 08             	mov    0x8(%ebp),%eax
  102d15:	0f b6 00             	movzbl (%eax),%eax
  102d18:	0f be c0             	movsbl %al,%eax
  102d1b:	83 e8 30             	sub    $0x30,%eax
  102d1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102d21:	eb 48                	jmp    102d6b <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  102d23:	8b 45 08             	mov    0x8(%ebp),%eax
  102d26:	0f b6 00             	movzbl (%eax),%eax
  102d29:	3c 60                	cmp    $0x60,%al
  102d2b:	7e 1b                	jle    102d48 <strtol+0xf7>
  102d2d:	8b 45 08             	mov    0x8(%ebp),%eax
  102d30:	0f b6 00             	movzbl (%eax),%eax
  102d33:	3c 7a                	cmp    $0x7a,%al
  102d35:	7f 11                	jg     102d48 <strtol+0xf7>
            dig = *s - 'a' + 10;
  102d37:	8b 45 08             	mov    0x8(%ebp),%eax
  102d3a:	0f b6 00             	movzbl (%eax),%eax
  102d3d:	0f be c0             	movsbl %al,%eax
  102d40:	83 e8 57             	sub    $0x57,%eax
  102d43:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102d46:	eb 23                	jmp    102d6b <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  102d48:	8b 45 08             	mov    0x8(%ebp),%eax
  102d4b:	0f b6 00             	movzbl (%eax),%eax
  102d4e:	3c 40                	cmp    $0x40,%al
  102d50:	7e 3d                	jle    102d8f <strtol+0x13e>
  102d52:	8b 45 08             	mov    0x8(%ebp),%eax
  102d55:	0f b6 00             	movzbl (%eax),%eax
  102d58:	3c 5a                	cmp    $0x5a,%al
  102d5a:	7f 33                	jg     102d8f <strtol+0x13e>
            dig = *s - 'A' + 10;
  102d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  102d5f:	0f b6 00             	movzbl (%eax),%eax
  102d62:	0f be c0             	movsbl %al,%eax
  102d65:	83 e8 37             	sub    $0x37,%eax
  102d68:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  102d6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d6e:	3b 45 10             	cmp    0x10(%ebp),%eax
  102d71:	7c 02                	jl     102d75 <strtol+0x124>
            break;
  102d73:	eb 1a                	jmp    102d8f <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
  102d75:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102d79:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102d7c:	0f af 45 10          	imul   0x10(%ebp),%eax
  102d80:	89 c2                	mov    %eax,%edx
  102d82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d85:	01 d0                	add    %edx,%eax
  102d87:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  102d8a:	e9 6f ff ff ff       	jmp    102cfe <strtol+0xad>

    if (endptr) {
  102d8f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102d93:	74 08                	je     102d9d <strtol+0x14c>
        *endptr = (char *) s;
  102d95:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d98:	8b 55 08             	mov    0x8(%ebp),%edx
  102d9b:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  102d9d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  102da1:	74 07                	je     102daa <strtol+0x159>
  102da3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102da6:	f7 d8                	neg    %eax
  102da8:	eb 03                	jmp    102dad <strtol+0x15c>
  102daa:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  102dad:	c9                   	leave  
  102dae:	c3                   	ret    

00102daf <memset>:
 * @n:        number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  102daf:	55                   	push   %ebp
  102db0:	89 e5                	mov    %esp,%ebp
  102db2:	57                   	push   %edi
  102db3:	83 ec 24             	sub    $0x24,%esp
  102db6:	8b 45 0c             	mov    0xc(%ebp),%eax
  102db9:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  102dbc:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  102dc0:	8b 55 08             	mov    0x8(%ebp),%edx
  102dc3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  102dc6:	88 45 f7             	mov    %al,-0x9(%ebp)
  102dc9:	8b 45 10             	mov    0x10(%ebp),%eax
  102dcc:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  102dcf:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  102dd2:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  102dd6:	8b 55 f8             	mov    -0x8(%ebp),%edx
  102dd9:	89 d7                	mov    %edx,%edi
  102ddb:	f3 aa                	rep stos %al,%es:(%edi)
  102ddd:	89 fa                	mov    %edi,%edx
  102ddf:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  102de2:	89 55 e8             	mov    %edx,-0x18(%ebp)
            "rep; stosb;"
            : "=&c" (d0), "=&D" (d1)
            : "0" (n), "a" (c), "1" (s)
            : "memory");
    return s;
  102de5:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  102de8:	83 c4 24             	add    $0x24,%esp
  102deb:	5f                   	pop    %edi
  102dec:	5d                   	pop    %ebp
  102ded:	c3                   	ret    

00102dee <memmove>:
 * @n:        number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  102dee:	55                   	push   %ebp
  102def:	89 e5                	mov    %esp,%ebp
  102df1:	57                   	push   %edi
  102df2:	56                   	push   %esi
  102df3:	53                   	push   %ebx
  102df4:	83 ec 30             	sub    $0x30,%esp
  102df7:	8b 45 08             	mov    0x8(%ebp),%eax
  102dfa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102dfd:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e00:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102e03:	8b 45 10             	mov    0x10(%ebp),%eax
  102e06:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  102e09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e0c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  102e0f:	73 42                	jae    102e53 <memmove+0x65>
  102e11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e14:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102e17:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102e1a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102e1d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102e20:	89 45 dc             	mov    %eax,-0x24(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  102e23:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102e26:	c1 e8 02             	shr    $0x2,%eax
  102e29:	89 c1                	mov    %eax,%ecx
    asm volatile (
  102e2b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102e2e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102e31:	89 d7                	mov    %edx,%edi
  102e33:	89 c6                	mov    %eax,%esi
  102e35:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  102e37:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  102e3a:	83 e1 03             	and    $0x3,%ecx
  102e3d:	74 02                	je     102e41 <memmove+0x53>
  102e3f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102e41:	89 f0                	mov    %esi,%eax
  102e43:	89 fa                	mov    %edi,%edx
  102e45:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  102e48:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102e4b:	89 45 d0             	mov    %eax,-0x30(%ebp)
            : "memory");
    return dst;
  102e4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102e51:	eb 36                	jmp    102e89 <memmove+0x9b>
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  102e53:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102e56:	8d 50 ff             	lea    -0x1(%eax),%edx
  102e59:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102e5c:	01 c2                	add    %eax,%edx
  102e5e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102e61:	8d 48 ff             	lea    -0x1(%eax),%ecx
  102e64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e67:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
  102e6a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102e6d:	89 c1                	mov    %eax,%ecx
  102e6f:	89 d8                	mov    %ebx,%eax
  102e71:	89 d6                	mov    %edx,%esi
  102e73:	89 c7                	mov    %eax,%edi
  102e75:	fd                   	std    
  102e76:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102e78:	fc                   	cld    
  102e79:	89 f8                	mov    %edi,%eax
  102e7b:	89 f2                	mov    %esi,%edx
  102e7d:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  102e80:	89 55 c8             	mov    %edx,-0x38(%ebp)
  102e83:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
  102e86:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  102e89:	83 c4 30             	add    $0x30,%esp
  102e8c:	5b                   	pop    %ebx
  102e8d:	5e                   	pop    %esi
  102e8e:	5f                   	pop    %edi
  102e8f:	5d                   	pop    %ebp
  102e90:	c3                   	ret    

00102e91 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  102e91:	55                   	push   %ebp
  102e92:	89 e5                	mov    %esp,%ebp
  102e94:	57                   	push   %edi
  102e95:	56                   	push   %esi
  102e96:	83 ec 20             	sub    $0x20,%esp
  102e99:	8b 45 08             	mov    0x8(%ebp),%eax
  102e9c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102e9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ea2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102ea5:	8b 45 10             	mov    0x10(%ebp),%eax
  102ea8:	89 45 ec             	mov    %eax,-0x14(%ebp)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  102eab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102eae:	c1 e8 02             	shr    $0x2,%eax
  102eb1:	89 c1                	mov    %eax,%ecx
    asm volatile (
  102eb3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102eb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102eb9:	89 d7                	mov    %edx,%edi
  102ebb:	89 c6                	mov    %eax,%esi
  102ebd:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  102ebf:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  102ec2:	83 e1 03             	and    $0x3,%ecx
  102ec5:	74 02                	je     102ec9 <memcpy+0x38>
  102ec7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102ec9:	89 f0                	mov    %esi,%eax
  102ecb:	89 fa                	mov    %edi,%edx
  102ecd:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  102ed0:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  102ed3:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
  102ed6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  102ed9:	83 c4 20             	add    $0x20,%esp
  102edc:	5e                   	pop    %esi
  102edd:	5f                   	pop    %edi
  102ede:	5d                   	pop    %ebp
  102edf:	c3                   	ret    

00102ee0 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  102ee0:	55                   	push   %ebp
  102ee1:	89 e5                	mov    %esp,%ebp
  102ee3:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  102ee6:	8b 45 08             	mov    0x8(%ebp),%eax
  102ee9:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  102eec:	8b 45 0c             	mov    0xc(%ebp),%eax
  102eef:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  102ef2:	eb 30                	jmp    102f24 <memcmp+0x44>
        if (*s1 != *s2) {
  102ef4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102ef7:	0f b6 10             	movzbl (%eax),%edx
  102efa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102efd:	0f b6 00             	movzbl (%eax),%eax
  102f00:	38 c2                	cmp    %al,%dl
  102f02:	74 18                	je     102f1c <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  102f04:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102f07:	0f b6 00             	movzbl (%eax),%eax
  102f0a:	0f b6 d0             	movzbl %al,%edx
  102f0d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102f10:	0f b6 00             	movzbl (%eax),%eax
  102f13:	0f b6 c0             	movzbl %al,%eax
  102f16:	29 c2                	sub    %eax,%edx
  102f18:	89 d0                	mov    %edx,%eax
  102f1a:	eb 1a                	jmp    102f36 <memcmp+0x56>
        }
        s1 ++, s2 ++;
  102f1c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  102f20:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
    while (n -- > 0) {
  102f24:	8b 45 10             	mov    0x10(%ebp),%eax
  102f27:	8d 50 ff             	lea    -0x1(%eax),%edx
  102f2a:	89 55 10             	mov    %edx,0x10(%ebp)
  102f2d:	85 c0                	test   %eax,%eax
  102f2f:	75 c3                	jne    102ef4 <memcmp+0x14>
    }
    return 0;
  102f31:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102f36:	c9                   	leave  
  102f37:	c3                   	ret    

00102f38 <printnum>:
 * @width:         maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:        character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  102f38:	55                   	push   %ebp
  102f39:	89 e5                	mov    %esp,%ebp
  102f3b:	83 ec 58             	sub    $0x58,%esp
  102f3e:	8b 45 10             	mov    0x10(%ebp),%eax
  102f41:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102f44:	8b 45 14             	mov    0x14(%ebp),%eax
  102f47:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  102f4a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102f4d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102f50:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102f53:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  102f56:	8b 45 18             	mov    0x18(%ebp),%eax
  102f59:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102f5c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102f5f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102f62:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102f65:	89 55 f0             	mov    %edx,-0x10(%ebp)
  102f68:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102f6e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102f72:	74 1c                	je     102f90 <printnum+0x58>
  102f74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f77:	ba 00 00 00 00       	mov    $0x0,%edx
  102f7c:	f7 75 e4             	divl   -0x1c(%ebp)
  102f7f:	89 55 f4             	mov    %edx,-0xc(%ebp)
  102f82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f85:	ba 00 00 00 00       	mov    $0x0,%edx
  102f8a:	f7 75 e4             	divl   -0x1c(%ebp)
  102f8d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f90:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102f93:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102f96:	f7 75 e4             	divl   -0x1c(%ebp)
  102f99:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102f9c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  102f9f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102fa2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102fa5:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102fa8:	89 55 ec             	mov    %edx,-0x14(%ebp)
  102fab:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102fae:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  102fb1:	8b 45 18             	mov    0x18(%ebp),%eax
  102fb4:	ba 00 00 00 00       	mov    $0x0,%edx
  102fb9:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  102fbc:	77 56                	ja     103014 <printnum+0xdc>
  102fbe:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  102fc1:	72 05                	jb     102fc8 <printnum+0x90>
  102fc3:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  102fc6:	77 4c                	ja     103014 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
  102fc8:	8b 45 1c             	mov    0x1c(%ebp),%eax
  102fcb:	8d 50 ff             	lea    -0x1(%eax),%edx
  102fce:	8b 45 20             	mov    0x20(%ebp),%eax
  102fd1:	89 44 24 18          	mov    %eax,0x18(%esp)
  102fd5:	89 54 24 14          	mov    %edx,0x14(%esp)
  102fd9:	8b 45 18             	mov    0x18(%ebp),%eax
  102fdc:	89 44 24 10          	mov    %eax,0x10(%esp)
  102fe0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102fe3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102fe6:	89 44 24 08          	mov    %eax,0x8(%esp)
  102fea:	89 54 24 0c          	mov    %edx,0xc(%esp)
  102fee:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ff1:	89 44 24 04          	mov    %eax,0x4(%esp)
  102ff5:	8b 45 08             	mov    0x8(%ebp),%eax
  102ff8:	89 04 24             	mov    %eax,(%esp)
  102ffb:	e8 38 ff ff ff       	call   102f38 <printnum>
  103000:	eb 1c                	jmp    10301e <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  103002:	8b 45 0c             	mov    0xc(%ebp),%eax
  103005:	89 44 24 04          	mov    %eax,0x4(%esp)
  103009:	8b 45 20             	mov    0x20(%ebp),%eax
  10300c:	89 04 24             	mov    %eax,(%esp)
  10300f:	8b 45 08             	mov    0x8(%ebp),%eax
  103012:	ff d0                	call   *%eax
        while (-- width > 0)
  103014:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  103018:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  10301c:	7f e4                	jg     103002 <printnum+0xca>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  10301e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103021:	05 70 3d 10 00       	add    $0x103d70,%eax
  103026:	0f b6 00             	movzbl (%eax),%eax
  103029:	0f be c0             	movsbl %al,%eax
  10302c:	8b 55 0c             	mov    0xc(%ebp),%edx
  10302f:	89 54 24 04          	mov    %edx,0x4(%esp)
  103033:	89 04 24             	mov    %eax,(%esp)
  103036:	8b 45 08             	mov    0x8(%ebp),%eax
  103039:	ff d0                	call   *%eax
}
  10303b:	c9                   	leave  
  10303c:	c3                   	ret    

0010303d <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  10303d:	55                   	push   %ebp
  10303e:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  103040:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  103044:	7e 14                	jle    10305a <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  103046:	8b 45 08             	mov    0x8(%ebp),%eax
  103049:	8b 00                	mov    (%eax),%eax
  10304b:	8d 48 08             	lea    0x8(%eax),%ecx
  10304e:	8b 55 08             	mov    0x8(%ebp),%edx
  103051:	89 0a                	mov    %ecx,(%edx)
  103053:	8b 50 04             	mov    0x4(%eax),%edx
  103056:	8b 00                	mov    (%eax),%eax
  103058:	eb 30                	jmp    10308a <getuint+0x4d>
    }
    else if (lflag) {
  10305a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  10305e:	74 16                	je     103076 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  103060:	8b 45 08             	mov    0x8(%ebp),%eax
  103063:	8b 00                	mov    (%eax),%eax
  103065:	8d 48 04             	lea    0x4(%eax),%ecx
  103068:	8b 55 08             	mov    0x8(%ebp),%edx
  10306b:	89 0a                	mov    %ecx,(%edx)
  10306d:	8b 00                	mov    (%eax),%eax
  10306f:	ba 00 00 00 00       	mov    $0x0,%edx
  103074:	eb 14                	jmp    10308a <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  103076:	8b 45 08             	mov    0x8(%ebp),%eax
  103079:	8b 00                	mov    (%eax),%eax
  10307b:	8d 48 04             	lea    0x4(%eax),%ecx
  10307e:	8b 55 08             	mov    0x8(%ebp),%edx
  103081:	89 0a                	mov    %ecx,(%edx)
  103083:	8b 00                	mov    (%eax),%eax
  103085:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  10308a:	5d                   	pop    %ebp
  10308b:	c3                   	ret    

0010308c <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  10308c:	55                   	push   %ebp
  10308d:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  10308f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  103093:	7e 14                	jle    1030a9 <getint+0x1d>
        return va_arg(*ap, long long);
  103095:	8b 45 08             	mov    0x8(%ebp),%eax
  103098:	8b 00                	mov    (%eax),%eax
  10309a:	8d 48 08             	lea    0x8(%eax),%ecx
  10309d:	8b 55 08             	mov    0x8(%ebp),%edx
  1030a0:	89 0a                	mov    %ecx,(%edx)
  1030a2:	8b 50 04             	mov    0x4(%eax),%edx
  1030a5:	8b 00                	mov    (%eax),%eax
  1030a7:	eb 28                	jmp    1030d1 <getint+0x45>
    }
    else if (lflag) {
  1030a9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1030ad:	74 12                	je     1030c1 <getint+0x35>
        return va_arg(*ap, long);
  1030af:	8b 45 08             	mov    0x8(%ebp),%eax
  1030b2:	8b 00                	mov    (%eax),%eax
  1030b4:	8d 48 04             	lea    0x4(%eax),%ecx
  1030b7:	8b 55 08             	mov    0x8(%ebp),%edx
  1030ba:	89 0a                	mov    %ecx,(%edx)
  1030bc:	8b 00                	mov    (%eax),%eax
  1030be:	99                   	cltd   
  1030bf:	eb 10                	jmp    1030d1 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  1030c1:	8b 45 08             	mov    0x8(%ebp),%eax
  1030c4:	8b 00                	mov    (%eax),%eax
  1030c6:	8d 48 04             	lea    0x4(%eax),%ecx
  1030c9:	8b 55 08             	mov    0x8(%ebp),%edx
  1030cc:	89 0a                	mov    %ecx,(%edx)
  1030ce:	8b 00                	mov    (%eax),%eax
  1030d0:	99                   	cltd   
    }
}
  1030d1:	5d                   	pop    %ebp
  1030d2:	c3                   	ret    

001030d3 <printfmt>:
 * @putch:        specified putch function, print a single character
 * @putdat:        used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  1030d3:	55                   	push   %ebp
  1030d4:	89 e5                	mov    %esp,%ebp
  1030d6:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  1030d9:	8d 45 14             	lea    0x14(%ebp),%eax
  1030dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  1030df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1030e2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1030e6:	8b 45 10             	mov    0x10(%ebp),%eax
  1030e9:	89 44 24 08          	mov    %eax,0x8(%esp)
  1030ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1030f4:	8b 45 08             	mov    0x8(%ebp),%eax
  1030f7:	89 04 24             	mov    %eax,(%esp)
  1030fa:	e8 02 00 00 00       	call   103101 <vprintfmt>
    va_end(ap);
}
  1030ff:	c9                   	leave  
  103100:	c3                   	ret    

00103101 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  103101:	55                   	push   %ebp
  103102:	89 e5                	mov    %esp,%ebp
  103104:	56                   	push   %esi
  103105:	53                   	push   %ebx
  103106:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  103109:	eb 18                	jmp    103123 <vprintfmt+0x22>
            if (ch == '\0') {
  10310b:	85 db                	test   %ebx,%ebx
  10310d:	75 05                	jne    103114 <vprintfmt+0x13>
                return;
  10310f:	e9 d1 03 00 00       	jmp    1034e5 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
  103114:	8b 45 0c             	mov    0xc(%ebp),%eax
  103117:	89 44 24 04          	mov    %eax,0x4(%esp)
  10311b:	89 1c 24             	mov    %ebx,(%esp)
  10311e:	8b 45 08             	mov    0x8(%ebp),%eax
  103121:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  103123:	8b 45 10             	mov    0x10(%ebp),%eax
  103126:	8d 50 01             	lea    0x1(%eax),%edx
  103129:	89 55 10             	mov    %edx,0x10(%ebp)
  10312c:	0f b6 00             	movzbl (%eax),%eax
  10312f:	0f b6 d8             	movzbl %al,%ebx
  103132:	83 fb 25             	cmp    $0x25,%ebx
  103135:	75 d4                	jne    10310b <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
  103137:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  10313b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  103142:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103145:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  103148:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  10314f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103152:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  103155:	8b 45 10             	mov    0x10(%ebp),%eax
  103158:	8d 50 01             	lea    0x1(%eax),%edx
  10315b:	89 55 10             	mov    %edx,0x10(%ebp)
  10315e:	0f b6 00             	movzbl (%eax),%eax
  103161:	0f b6 d8             	movzbl %al,%ebx
  103164:	8d 43 dd             	lea    -0x23(%ebx),%eax
  103167:	83 f8 55             	cmp    $0x55,%eax
  10316a:	0f 87 44 03 00 00    	ja     1034b4 <vprintfmt+0x3b3>
  103170:	8b 04 85 94 3d 10 00 	mov    0x103d94(,%eax,4),%eax
  103177:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  103179:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  10317d:	eb d6                	jmp    103155 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  10317f:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  103183:	eb d0                	jmp    103155 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  103185:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  10318c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10318f:	89 d0                	mov    %edx,%eax
  103191:	c1 e0 02             	shl    $0x2,%eax
  103194:	01 d0                	add    %edx,%eax
  103196:	01 c0                	add    %eax,%eax
  103198:	01 d8                	add    %ebx,%eax
  10319a:	83 e8 30             	sub    $0x30,%eax
  10319d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  1031a0:	8b 45 10             	mov    0x10(%ebp),%eax
  1031a3:	0f b6 00             	movzbl (%eax),%eax
  1031a6:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  1031a9:	83 fb 2f             	cmp    $0x2f,%ebx
  1031ac:	7e 0b                	jle    1031b9 <vprintfmt+0xb8>
  1031ae:	83 fb 39             	cmp    $0x39,%ebx
  1031b1:	7f 06                	jg     1031b9 <vprintfmt+0xb8>
            for (precision = 0; ; ++ fmt) {
  1031b3:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                    break;
                }
            }
  1031b7:	eb d3                	jmp    10318c <vprintfmt+0x8b>
            goto process_precision;
  1031b9:	eb 33                	jmp    1031ee <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
  1031bb:	8b 45 14             	mov    0x14(%ebp),%eax
  1031be:	8d 50 04             	lea    0x4(%eax),%edx
  1031c1:	89 55 14             	mov    %edx,0x14(%ebp)
  1031c4:	8b 00                	mov    (%eax),%eax
  1031c6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  1031c9:	eb 23                	jmp    1031ee <vprintfmt+0xed>

        case '.':
            if (width < 0)
  1031cb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1031cf:	79 0c                	jns    1031dd <vprintfmt+0xdc>
                width = 0;
  1031d1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  1031d8:	e9 78 ff ff ff       	jmp    103155 <vprintfmt+0x54>
  1031dd:	e9 73 ff ff ff       	jmp    103155 <vprintfmt+0x54>

        case '#':
            altflag = 1;
  1031e2:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  1031e9:	e9 67 ff ff ff       	jmp    103155 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
  1031ee:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1031f2:	79 12                	jns    103206 <vprintfmt+0x105>
                width = precision, precision = -1;
  1031f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1031f7:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1031fa:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  103201:	e9 4f ff ff ff       	jmp    103155 <vprintfmt+0x54>
  103206:	e9 4a ff ff ff       	jmp    103155 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  10320b:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  10320f:	e9 41 ff ff ff       	jmp    103155 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  103214:	8b 45 14             	mov    0x14(%ebp),%eax
  103217:	8d 50 04             	lea    0x4(%eax),%edx
  10321a:	89 55 14             	mov    %edx,0x14(%ebp)
  10321d:	8b 00                	mov    (%eax),%eax
  10321f:	8b 55 0c             	mov    0xc(%ebp),%edx
  103222:	89 54 24 04          	mov    %edx,0x4(%esp)
  103226:	89 04 24             	mov    %eax,(%esp)
  103229:	8b 45 08             	mov    0x8(%ebp),%eax
  10322c:	ff d0                	call   *%eax
            break;
  10322e:	e9 ac 02 00 00       	jmp    1034df <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
  103233:	8b 45 14             	mov    0x14(%ebp),%eax
  103236:	8d 50 04             	lea    0x4(%eax),%edx
  103239:	89 55 14             	mov    %edx,0x14(%ebp)
  10323c:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  10323e:	85 db                	test   %ebx,%ebx
  103240:	79 02                	jns    103244 <vprintfmt+0x143>
                err = -err;
  103242:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  103244:	83 fb 06             	cmp    $0x6,%ebx
  103247:	7f 0b                	jg     103254 <vprintfmt+0x153>
  103249:	8b 34 9d 54 3d 10 00 	mov    0x103d54(,%ebx,4),%esi
  103250:	85 f6                	test   %esi,%esi
  103252:	75 23                	jne    103277 <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
  103254:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  103258:	c7 44 24 08 81 3d 10 	movl   $0x103d81,0x8(%esp)
  10325f:	00 
  103260:	8b 45 0c             	mov    0xc(%ebp),%eax
  103263:	89 44 24 04          	mov    %eax,0x4(%esp)
  103267:	8b 45 08             	mov    0x8(%ebp),%eax
  10326a:	89 04 24             	mov    %eax,(%esp)
  10326d:	e8 61 fe ff ff       	call   1030d3 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  103272:	e9 68 02 00 00       	jmp    1034df <vprintfmt+0x3de>
                printfmt(putch, putdat, "%s", p);
  103277:	89 74 24 0c          	mov    %esi,0xc(%esp)
  10327b:	c7 44 24 08 8a 3d 10 	movl   $0x103d8a,0x8(%esp)
  103282:	00 
  103283:	8b 45 0c             	mov    0xc(%ebp),%eax
  103286:	89 44 24 04          	mov    %eax,0x4(%esp)
  10328a:	8b 45 08             	mov    0x8(%ebp),%eax
  10328d:	89 04 24             	mov    %eax,(%esp)
  103290:	e8 3e fe ff ff       	call   1030d3 <printfmt>
            break;
  103295:	e9 45 02 00 00       	jmp    1034df <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  10329a:	8b 45 14             	mov    0x14(%ebp),%eax
  10329d:	8d 50 04             	lea    0x4(%eax),%edx
  1032a0:	89 55 14             	mov    %edx,0x14(%ebp)
  1032a3:	8b 30                	mov    (%eax),%esi
  1032a5:	85 f6                	test   %esi,%esi
  1032a7:	75 05                	jne    1032ae <vprintfmt+0x1ad>
                p = "(null)";
  1032a9:	be 8d 3d 10 00       	mov    $0x103d8d,%esi
            }
            if (width > 0 && padc != '-') {
  1032ae:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1032b2:	7e 3e                	jle    1032f2 <vprintfmt+0x1f1>
  1032b4:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  1032b8:	74 38                	je     1032f2 <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
  1032ba:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  1032bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1032c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1032c4:	89 34 24             	mov    %esi,(%esp)
  1032c7:	e8 dc f7 ff ff       	call   102aa8 <strnlen>
  1032cc:	29 c3                	sub    %eax,%ebx
  1032ce:	89 d8                	mov    %ebx,%eax
  1032d0:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1032d3:	eb 17                	jmp    1032ec <vprintfmt+0x1eb>
                    putch(padc, putdat);
  1032d5:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  1032d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  1032dc:	89 54 24 04          	mov    %edx,0x4(%esp)
  1032e0:	89 04 24             	mov    %eax,(%esp)
  1032e3:	8b 45 08             	mov    0x8(%ebp),%eax
  1032e6:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
  1032e8:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  1032ec:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1032f0:	7f e3                	jg     1032d5 <vprintfmt+0x1d4>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  1032f2:	eb 38                	jmp    10332c <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
  1032f4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  1032f8:	74 1f                	je     103319 <vprintfmt+0x218>
  1032fa:	83 fb 1f             	cmp    $0x1f,%ebx
  1032fd:	7e 05                	jle    103304 <vprintfmt+0x203>
  1032ff:	83 fb 7e             	cmp    $0x7e,%ebx
  103302:	7e 15                	jle    103319 <vprintfmt+0x218>
                    putch('?', putdat);
  103304:	8b 45 0c             	mov    0xc(%ebp),%eax
  103307:	89 44 24 04          	mov    %eax,0x4(%esp)
  10330b:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  103312:	8b 45 08             	mov    0x8(%ebp),%eax
  103315:	ff d0                	call   *%eax
  103317:	eb 0f                	jmp    103328 <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
  103319:	8b 45 0c             	mov    0xc(%ebp),%eax
  10331c:	89 44 24 04          	mov    %eax,0x4(%esp)
  103320:	89 1c 24             	mov    %ebx,(%esp)
  103323:	8b 45 08             	mov    0x8(%ebp),%eax
  103326:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  103328:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  10332c:	89 f0                	mov    %esi,%eax
  10332e:	8d 70 01             	lea    0x1(%eax),%esi
  103331:	0f b6 00             	movzbl (%eax),%eax
  103334:	0f be d8             	movsbl %al,%ebx
  103337:	85 db                	test   %ebx,%ebx
  103339:	74 10                	je     10334b <vprintfmt+0x24a>
  10333b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10333f:	78 b3                	js     1032f4 <vprintfmt+0x1f3>
  103341:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  103345:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103349:	79 a9                	jns    1032f4 <vprintfmt+0x1f3>
                }
            }
            for (; width > 0; width --) {
  10334b:	eb 17                	jmp    103364 <vprintfmt+0x263>
                putch(' ', putdat);
  10334d:	8b 45 0c             	mov    0xc(%ebp),%eax
  103350:	89 44 24 04          	mov    %eax,0x4(%esp)
  103354:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  10335b:	8b 45 08             	mov    0x8(%ebp),%eax
  10335e:	ff d0                	call   *%eax
            for (; width > 0; width --) {
  103360:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  103364:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103368:	7f e3                	jg     10334d <vprintfmt+0x24c>
            }
            break;
  10336a:	e9 70 01 00 00       	jmp    1034df <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  10336f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103372:	89 44 24 04          	mov    %eax,0x4(%esp)
  103376:	8d 45 14             	lea    0x14(%ebp),%eax
  103379:	89 04 24             	mov    %eax,(%esp)
  10337c:	e8 0b fd ff ff       	call   10308c <getint>
  103381:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103384:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  103387:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10338a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10338d:	85 d2                	test   %edx,%edx
  10338f:	79 26                	jns    1033b7 <vprintfmt+0x2b6>
                putch('-', putdat);
  103391:	8b 45 0c             	mov    0xc(%ebp),%eax
  103394:	89 44 24 04          	mov    %eax,0x4(%esp)
  103398:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  10339f:	8b 45 08             	mov    0x8(%ebp),%eax
  1033a2:	ff d0                	call   *%eax
                num = -(long long)num;
  1033a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1033a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1033aa:	f7 d8                	neg    %eax
  1033ac:	83 d2 00             	adc    $0x0,%edx
  1033af:	f7 da                	neg    %edx
  1033b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1033b4:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  1033b7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1033be:	e9 a8 00 00 00       	jmp    10346b <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  1033c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1033c6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1033ca:	8d 45 14             	lea    0x14(%ebp),%eax
  1033cd:	89 04 24             	mov    %eax,(%esp)
  1033d0:	e8 68 fc ff ff       	call   10303d <getuint>
  1033d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1033d8:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  1033db:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1033e2:	e9 84 00 00 00       	jmp    10346b <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  1033e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1033ea:	89 44 24 04          	mov    %eax,0x4(%esp)
  1033ee:	8d 45 14             	lea    0x14(%ebp),%eax
  1033f1:	89 04 24             	mov    %eax,(%esp)
  1033f4:	e8 44 fc ff ff       	call   10303d <getuint>
  1033f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1033fc:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  1033ff:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  103406:	eb 63                	jmp    10346b <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
  103408:	8b 45 0c             	mov    0xc(%ebp),%eax
  10340b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10340f:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  103416:	8b 45 08             	mov    0x8(%ebp),%eax
  103419:	ff d0                	call   *%eax
            putch('x', putdat);
  10341b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10341e:	89 44 24 04          	mov    %eax,0x4(%esp)
  103422:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  103429:	8b 45 08             	mov    0x8(%ebp),%eax
  10342c:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  10342e:	8b 45 14             	mov    0x14(%ebp),%eax
  103431:	8d 50 04             	lea    0x4(%eax),%edx
  103434:	89 55 14             	mov    %edx,0x14(%ebp)
  103437:	8b 00                	mov    (%eax),%eax
  103439:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10343c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  103443:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  10344a:	eb 1f                	jmp    10346b <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  10344c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10344f:	89 44 24 04          	mov    %eax,0x4(%esp)
  103453:	8d 45 14             	lea    0x14(%ebp),%eax
  103456:	89 04 24             	mov    %eax,(%esp)
  103459:	e8 df fb ff ff       	call   10303d <getuint>
  10345e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103461:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  103464:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  10346b:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  10346f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103472:	89 54 24 18          	mov    %edx,0x18(%esp)
  103476:	8b 55 e8             	mov    -0x18(%ebp),%edx
  103479:	89 54 24 14          	mov    %edx,0x14(%esp)
  10347d:	89 44 24 10          	mov    %eax,0x10(%esp)
  103481:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103484:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103487:	89 44 24 08          	mov    %eax,0x8(%esp)
  10348b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  10348f:	8b 45 0c             	mov    0xc(%ebp),%eax
  103492:	89 44 24 04          	mov    %eax,0x4(%esp)
  103496:	8b 45 08             	mov    0x8(%ebp),%eax
  103499:	89 04 24             	mov    %eax,(%esp)
  10349c:	e8 97 fa ff ff       	call   102f38 <printnum>
            break;
  1034a1:	eb 3c                	jmp    1034df <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  1034a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034a6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1034aa:	89 1c 24             	mov    %ebx,(%esp)
  1034ad:	8b 45 08             	mov    0x8(%ebp),%eax
  1034b0:	ff d0                	call   *%eax
            break;
  1034b2:	eb 2b                	jmp    1034df <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  1034b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1034bb:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  1034c2:	8b 45 08             	mov    0x8(%ebp),%eax
  1034c5:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  1034c7:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  1034cb:	eb 04                	jmp    1034d1 <vprintfmt+0x3d0>
  1034cd:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  1034d1:	8b 45 10             	mov    0x10(%ebp),%eax
  1034d4:	83 e8 01             	sub    $0x1,%eax
  1034d7:	0f b6 00             	movzbl (%eax),%eax
  1034da:	3c 25                	cmp    $0x25,%al
  1034dc:	75 ef                	jne    1034cd <vprintfmt+0x3cc>
                /* do nothing */;
            break;
  1034de:	90                   	nop
        }
    }
  1034df:	90                   	nop
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1034e0:	e9 3e fc ff ff       	jmp    103123 <vprintfmt+0x22>
}
  1034e5:	83 c4 40             	add    $0x40,%esp
  1034e8:	5b                   	pop    %ebx
  1034e9:	5e                   	pop    %esi
  1034ea:	5d                   	pop    %ebp
  1034eb:	c3                   	ret    

001034ec <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:            the character will be printed
 * @b:            the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  1034ec:	55                   	push   %ebp
  1034ed:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  1034ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034f2:	8b 40 08             	mov    0x8(%eax),%eax
  1034f5:	8d 50 01             	lea    0x1(%eax),%edx
  1034f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034fb:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  1034fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  103501:	8b 10                	mov    (%eax),%edx
  103503:	8b 45 0c             	mov    0xc(%ebp),%eax
  103506:	8b 40 04             	mov    0x4(%eax),%eax
  103509:	39 c2                	cmp    %eax,%edx
  10350b:	73 12                	jae    10351f <sprintputch+0x33>
        *b->buf ++ = ch;
  10350d:	8b 45 0c             	mov    0xc(%ebp),%eax
  103510:	8b 00                	mov    (%eax),%eax
  103512:	8d 48 01             	lea    0x1(%eax),%ecx
  103515:	8b 55 0c             	mov    0xc(%ebp),%edx
  103518:	89 0a                	mov    %ecx,(%edx)
  10351a:	8b 55 08             	mov    0x8(%ebp),%edx
  10351d:	88 10                	mov    %dl,(%eax)
    }
}
  10351f:	5d                   	pop    %ebp
  103520:	c3                   	ret    

00103521 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:        the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  103521:	55                   	push   %ebp
  103522:	89 e5                	mov    %esp,%ebp
  103524:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  103527:	8d 45 14             	lea    0x14(%ebp),%eax
  10352a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  10352d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103530:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103534:	8b 45 10             	mov    0x10(%ebp),%eax
  103537:	89 44 24 08          	mov    %eax,0x8(%esp)
  10353b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10353e:	89 44 24 04          	mov    %eax,0x4(%esp)
  103542:	8b 45 08             	mov    0x8(%ebp),%eax
  103545:	89 04 24             	mov    %eax,(%esp)
  103548:	e8 08 00 00 00       	call   103555 <vsnprintf>
  10354d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  103550:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103553:	c9                   	leave  
  103554:	c3                   	ret    

00103555 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  103555:	55                   	push   %ebp
  103556:	89 e5                	mov    %esp,%ebp
  103558:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  10355b:	8b 45 08             	mov    0x8(%ebp),%eax
  10355e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103561:	8b 45 0c             	mov    0xc(%ebp),%eax
  103564:	8d 50 ff             	lea    -0x1(%eax),%edx
  103567:	8b 45 08             	mov    0x8(%ebp),%eax
  10356a:	01 d0                	add    %edx,%eax
  10356c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10356f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  103576:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  10357a:	74 0a                	je     103586 <vsnprintf+0x31>
  10357c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10357f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103582:	39 c2                	cmp    %eax,%edx
  103584:	76 07                	jbe    10358d <vsnprintf+0x38>
        return -E_INVAL;
  103586:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  10358b:	eb 2a                	jmp    1035b7 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  10358d:	8b 45 14             	mov    0x14(%ebp),%eax
  103590:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103594:	8b 45 10             	mov    0x10(%ebp),%eax
  103597:	89 44 24 08          	mov    %eax,0x8(%esp)
  10359b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  10359e:	89 44 24 04          	mov    %eax,0x4(%esp)
  1035a2:	c7 04 24 ec 34 10 00 	movl   $0x1034ec,(%esp)
  1035a9:	e8 53 fb ff ff       	call   103101 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  1035ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1035b1:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  1035b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1035b7:	c9                   	leave  
  1035b8:	c3                   	ret    
