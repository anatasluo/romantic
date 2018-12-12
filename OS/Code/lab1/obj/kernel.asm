
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
  100027:	e8 74 2d 00 00       	call   102da0 <memset>

    cons_init();                // init the console
  10002c:	e8 55 15 00 00       	call   101586 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100031:	c7 45 f4 c0 35 10 00 	movl   $0x1035c0,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10003b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10003f:	c7 04 24 dc 35 10 00 	movl   $0x1035dc,(%esp)
  100046:	e8 21 02 00 00       	call   10026c <cprintf>

    print_kerninfo();
  10004b:	e8 d3 08 00 00       	call   100923 <print_kerninfo>

    grade_backtrace();
  100050:	e8 8b 00 00 00       	call   1000e0 <grade_backtrace>

    pmm_init();                 // init physical memory management
  100055:	e8 0d 2a 00 00       	call   102a67 <pmm_init>

    pic_init();                 // init interrupt controller
  10005a:	e8 5e 16 00 00       	call   1016bd <pic_init>
    idt_init();                 // init interrupt descriptor table
  10005f:	e8 e2 17 00 00       	call   101846 <idt_init>

    clock_init();               // init clock interrupt
  100064:	e8 10 0d 00 00       	call   100d79 <clock_init>
    intr_enable();              // enable irq interrupt
  100069:	e8 8a 17 00 00       	call   1017f8 <intr_enable>

    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    lab1_switch_test();
  10006e:	e8 6d 01 00 00       	call   1001e0 <lab1_switch_test>

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
  100092:	e8 d0 0c 00 00       	call   100d67 <mon_backtrace>
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
  100137:	e8 30 01 00 00       	call   10026c <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  10013c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100140:	0f b7 d0             	movzwl %ax,%edx
  100143:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100148:	89 54 24 08          	mov    %edx,0x8(%esp)
  10014c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100150:	c7 04 24 ef 35 10 00 	movl   $0x1035ef,(%esp)
  100157:	e8 10 01 00 00       	call   10026c <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  10015c:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100160:	0f b7 d0             	movzwl %ax,%edx
  100163:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100168:	89 54 24 08          	mov    %edx,0x8(%esp)
  10016c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100170:	c7 04 24 fd 35 10 00 	movl   $0x1035fd,(%esp)
  100177:	e8 f0 00 00 00       	call   10026c <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  10017c:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100180:	0f b7 d0             	movzwl %ax,%edx
  100183:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100188:	89 54 24 08          	mov    %edx,0x8(%esp)
  10018c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100190:	c7 04 24 0b 36 10 00 	movl   $0x10360b,(%esp)
  100197:	e8 d0 00 00 00       	call   10026c <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  10019c:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001a0:	0f b7 d0             	movzwl %ax,%edx
  1001a3:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  1001a8:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001b0:	c7 04 24 19 36 10 00 	movl   $0x103619,(%esp)
  1001b7:	e8 b0 00 00 00       	call   10026c <cprintf>
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
    //LAB1 CHALLENGE 1 :  TODO
	asm volatile (
  1001da:	cd 79                	int    $0x79
  1001dc:	89 ec                	mov    %ebp,%esp
		"movl %%ebp, %%esp \n"  // 此处的作用，是为了跟后面的汇编一起发挥leave作用
		:
		: "i"(T_SWITCH_TOK)
	);

}
  1001de:	5d                   	pop    %ebp
  1001df:	c3                   	ret    

001001e0 <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001e0:	55                   	push   %ebp
  1001e1:	89 e5                	mov    %esp,%ebp
  1001e3:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  1001e6:	e8 1a ff ff ff       	call   100105 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  1001eb:	c7 04 24 28 36 10 00 	movl   $0x103628,(%esp)
  1001f2:	e8 75 00 00 00       	call   10026c <cprintf>
    lab1_switch_to_user();
  1001f7:	e8 cf ff ff ff       	call   1001cb <lab1_switch_to_user>
    lab1_print_cur_status();
  1001fc:	e8 04 ff ff ff       	call   100105 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  100201:	c7 04 24 48 36 10 00 	movl   $0x103648,(%esp)
  100208:	e8 5f 00 00 00       	call   10026c <cprintf>
    lab1_switch_to_kernel();
  10020d:	e8 c5 ff ff ff       	call   1001d7 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100212:	e8 ee fe ff ff       	call   100105 <lab1_print_cur_status>
}
  100217:	c9                   	leave  
  100218:	c3                   	ret    

00100219 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  100219:	55                   	push   %ebp
  10021a:	89 e5                	mov    %esp,%ebp
  10021c:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  10021f:	8b 45 08             	mov    0x8(%ebp),%eax
  100222:	89 04 24             	mov    %eax,(%esp)
  100225:	e8 88 13 00 00       	call   1015b2 <cons_putc>
    (*cnt) ++;
  10022a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10022d:	8b 00                	mov    (%eax),%eax
  10022f:	8d 50 01             	lea    0x1(%eax),%edx
  100232:	8b 45 0c             	mov    0xc(%ebp),%eax
  100235:	89 10                	mov    %edx,(%eax)
}
  100237:	c9                   	leave  
  100238:	c3                   	ret    

00100239 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  100239:	55                   	push   %ebp
  10023a:	89 e5                	mov    %esp,%ebp
  10023c:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  10023f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  100246:	8b 45 0c             	mov    0xc(%ebp),%eax
  100249:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10024d:	8b 45 08             	mov    0x8(%ebp),%eax
  100250:	89 44 24 08          	mov    %eax,0x8(%esp)
  100254:	8d 45 f4             	lea    -0xc(%ebp),%eax
  100257:	89 44 24 04          	mov    %eax,0x4(%esp)
  10025b:	c7 04 24 19 02 10 00 	movl   $0x100219,(%esp)
  100262:	e8 8b 2e 00 00       	call   1030f2 <vprintfmt>
    return cnt;
  100267:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10026a:	c9                   	leave  
  10026b:	c3                   	ret    

0010026c <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  10026c:	55                   	push   %ebp
  10026d:	89 e5                	mov    %esp,%ebp
  10026f:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100272:	8d 45 0c             	lea    0xc(%ebp),%eax
  100275:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  100278:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10027b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10027f:	8b 45 08             	mov    0x8(%ebp),%eax
  100282:	89 04 24             	mov    %eax,(%esp)
  100285:	e8 af ff ff ff       	call   100239 <vcprintf>
  10028a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  10028d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100290:	c9                   	leave  
  100291:	c3                   	ret    

00100292 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  100292:	55                   	push   %ebp
  100293:	89 e5                	mov    %esp,%ebp
  100295:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  100298:	8b 45 08             	mov    0x8(%ebp),%eax
  10029b:	89 04 24             	mov    %eax,(%esp)
  10029e:	e8 0f 13 00 00       	call   1015b2 <cons_putc>
}
  1002a3:	c9                   	leave  
  1002a4:	c3                   	ret    

001002a5 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  1002a5:	55                   	push   %ebp
  1002a6:	89 e5                	mov    %esp,%ebp
  1002a8:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  1002ab:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  1002b2:	eb 13                	jmp    1002c7 <cputs+0x22>
        cputch(c, &cnt);
  1002b4:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  1002b8:	8d 55 f0             	lea    -0x10(%ebp),%edx
  1002bb:	89 54 24 04          	mov    %edx,0x4(%esp)
  1002bf:	89 04 24             	mov    %eax,(%esp)
  1002c2:	e8 52 ff ff ff       	call   100219 <cputch>
    while ((c = *str ++) != '\0') {
  1002c7:	8b 45 08             	mov    0x8(%ebp),%eax
  1002ca:	8d 50 01             	lea    0x1(%eax),%edx
  1002cd:	89 55 08             	mov    %edx,0x8(%ebp)
  1002d0:	0f b6 00             	movzbl (%eax),%eax
  1002d3:	88 45 f7             	mov    %al,-0x9(%ebp)
  1002d6:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1002da:	75 d8                	jne    1002b4 <cputs+0xf>
    }
    cputch('\n', &cnt);
  1002dc:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1002df:	89 44 24 04          	mov    %eax,0x4(%esp)
  1002e3:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  1002ea:	e8 2a ff ff ff       	call   100219 <cputch>
    return cnt;
  1002ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1002f2:	c9                   	leave  
  1002f3:	c3                   	ret    

001002f4 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1002f4:	55                   	push   %ebp
  1002f5:	89 e5                	mov    %esp,%ebp
  1002f7:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1002fa:	e8 dc 12 00 00       	call   1015db <cons_getc>
  1002ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100302:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100306:	74 f2                	je     1002fa <getchar+0x6>
        /* do nothing */;
    return c;
  100308:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10030b:	c9                   	leave  
  10030c:	c3                   	ret    

0010030d <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  10030d:	55                   	push   %ebp
  10030e:	89 e5                	mov    %esp,%ebp
  100310:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  100313:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100317:	74 13                	je     10032c <readline+0x1f>
        cprintf("%s", prompt);
  100319:	8b 45 08             	mov    0x8(%ebp),%eax
  10031c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100320:	c7 04 24 67 36 10 00 	movl   $0x103667,(%esp)
  100327:	e8 40 ff ff ff       	call   10026c <cprintf>
    }
    int i = 0, c;
  10032c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100333:	e8 bc ff ff ff       	call   1002f4 <getchar>
  100338:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  10033b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10033f:	79 07                	jns    100348 <readline+0x3b>
            return NULL;
  100341:	b8 00 00 00 00       	mov    $0x0,%eax
  100346:	eb 79                	jmp    1003c1 <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  100348:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  10034c:	7e 28                	jle    100376 <readline+0x69>
  10034e:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  100355:	7f 1f                	jg     100376 <readline+0x69>
            cputchar(c);
  100357:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10035a:	89 04 24             	mov    %eax,(%esp)
  10035d:	e8 30 ff ff ff       	call   100292 <cputchar>
            buf[i ++] = c;
  100362:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100365:	8d 50 01             	lea    0x1(%eax),%edx
  100368:	89 55 f4             	mov    %edx,-0xc(%ebp)
  10036b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10036e:	88 90 40 ea 10 00    	mov    %dl,0x10ea40(%eax)
  100374:	eb 46                	jmp    1003bc <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
  100376:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  10037a:	75 17                	jne    100393 <readline+0x86>
  10037c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100380:	7e 11                	jle    100393 <readline+0x86>
            cputchar(c);
  100382:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100385:	89 04 24             	mov    %eax,(%esp)
  100388:	e8 05 ff ff ff       	call   100292 <cputchar>
            i --;
  10038d:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  100391:	eb 29                	jmp    1003bc <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
  100393:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  100397:	74 06                	je     10039f <readline+0x92>
  100399:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  10039d:	75 1d                	jne    1003bc <readline+0xaf>
            cputchar(c);
  10039f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003a2:	89 04 24             	mov    %eax,(%esp)
  1003a5:	e8 e8 fe ff ff       	call   100292 <cputchar>
            buf[i] = '\0';
  1003aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1003ad:	05 40 ea 10 00       	add    $0x10ea40,%eax
  1003b2:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1003b5:	b8 40 ea 10 00       	mov    $0x10ea40,%eax
  1003ba:	eb 05                	jmp    1003c1 <readline+0xb4>
        }
    }
  1003bc:	e9 72 ff ff ff       	jmp    100333 <readline+0x26>
}
  1003c1:	c9                   	leave  
  1003c2:	c3                   	ret    

001003c3 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  1003c3:	55                   	push   %ebp
  1003c4:	89 e5                	mov    %esp,%ebp
  1003c6:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  1003c9:	a1 40 ee 10 00       	mov    0x10ee40,%eax
  1003ce:	85 c0                	test   %eax,%eax
  1003d0:	74 02                	je     1003d4 <__panic+0x11>
        goto panic_dead;
  1003d2:	eb 59                	jmp    10042d <__panic+0x6a>
    }
    is_panic = 1;
  1003d4:	c7 05 40 ee 10 00 01 	movl   $0x1,0x10ee40
  1003db:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  1003de:	8d 45 14             	lea    0x14(%ebp),%eax
  1003e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  1003e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1003e7:	89 44 24 08          	mov    %eax,0x8(%esp)
  1003eb:	8b 45 08             	mov    0x8(%ebp),%eax
  1003ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  1003f2:	c7 04 24 6a 36 10 00 	movl   $0x10366a,(%esp)
  1003f9:	e8 6e fe ff ff       	call   10026c <cprintf>
    vcprintf(fmt, ap);
  1003fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100401:	89 44 24 04          	mov    %eax,0x4(%esp)
  100405:	8b 45 10             	mov    0x10(%ebp),%eax
  100408:	89 04 24             	mov    %eax,(%esp)
  10040b:	e8 29 fe ff ff       	call   100239 <vcprintf>
    cprintf("\n");
  100410:	c7 04 24 86 36 10 00 	movl   $0x103686,(%esp)
  100417:	e8 50 fe ff ff       	call   10026c <cprintf>
    
    cprintf("stack trackback:\n");
  10041c:	c7 04 24 88 36 10 00 	movl   $0x103688,(%esp)
  100423:	e8 44 fe ff ff       	call   10026c <cprintf>
    print_stackframe();
  100428:	e8 40 06 00 00       	call   100a6d <print_stackframe>
    
    va_end(ap);

panic_dead:
    intr_disable();
  10042d:	e8 cc 13 00 00       	call   1017fe <intr_disable>
    while (1) {
        kmonitor(NULL);
  100432:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100439:	e8 5a 08 00 00       	call   100c98 <kmonitor>
    }
  10043e:	eb f2                	jmp    100432 <__panic+0x6f>

00100440 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100440:	55                   	push   %ebp
  100441:	89 e5                	mov    %esp,%ebp
  100443:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100446:	8d 45 14             	lea    0x14(%ebp),%eax
  100449:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  10044c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10044f:	89 44 24 08          	mov    %eax,0x8(%esp)
  100453:	8b 45 08             	mov    0x8(%ebp),%eax
  100456:	89 44 24 04          	mov    %eax,0x4(%esp)
  10045a:	c7 04 24 9a 36 10 00 	movl   $0x10369a,(%esp)
  100461:	e8 06 fe ff ff       	call   10026c <cprintf>
    vcprintf(fmt, ap);
  100466:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100469:	89 44 24 04          	mov    %eax,0x4(%esp)
  10046d:	8b 45 10             	mov    0x10(%ebp),%eax
  100470:	89 04 24             	mov    %eax,(%esp)
  100473:	e8 c1 fd ff ff       	call   100239 <vcprintf>
    cprintf("\n");
  100478:	c7 04 24 86 36 10 00 	movl   $0x103686,(%esp)
  10047f:	e8 e8 fd ff ff       	call   10026c <cprintf>
    va_end(ap);
}
  100484:	c9                   	leave  
  100485:	c3                   	ret    

00100486 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100486:	55                   	push   %ebp
  100487:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100489:	a1 40 ee 10 00       	mov    0x10ee40,%eax
}
  10048e:	5d                   	pop    %ebp
  10048f:	c3                   	ret    

00100490 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  100490:	55                   	push   %ebp
  100491:	89 e5                	mov    %esp,%ebp
  100493:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  100496:	8b 45 0c             	mov    0xc(%ebp),%eax
  100499:	8b 00                	mov    (%eax),%eax
  10049b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  10049e:	8b 45 10             	mov    0x10(%ebp),%eax
  1004a1:	8b 00                	mov    (%eax),%eax
  1004a3:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004a6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1004ad:	e9 d2 00 00 00       	jmp    100584 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
  1004b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1004b5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1004b8:	01 d0                	add    %edx,%eax
  1004ba:	89 c2                	mov    %eax,%edx
  1004bc:	c1 ea 1f             	shr    $0x1f,%edx
  1004bf:	01 d0                	add    %edx,%eax
  1004c1:	d1 f8                	sar    %eax
  1004c3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1004c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1004c9:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1004cc:	eb 04                	jmp    1004d2 <stab_binsearch+0x42>
            m --;
  1004ce:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
  1004d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004d5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004d8:	7c 1f                	jl     1004f9 <stab_binsearch+0x69>
  1004da:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004dd:	89 d0                	mov    %edx,%eax
  1004df:	01 c0                	add    %eax,%eax
  1004e1:	01 d0                	add    %edx,%eax
  1004e3:	c1 e0 02             	shl    $0x2,%eax
  1004e6:	89 c2                	mov    %eax,%edx
  1004e8:	8b 45 08             	mov    0x8(%ebp),%eax
  1004eb:	01 d0                	add    %edx,%eax
  1004ed:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1004f1:	0f b6 c0             	movzbl %al,%eax
  1004f4:	3b 45 14             	cmp    0x14(%ebp),%eax
  1004f7:	75 d5                	jne    1004ce <stab_binsearch+0x3e>
        }
        if (m < l) {    // no match in [l, m]
  1004f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004fc:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004ff:	7d 0b                	jge    10050c <stab_binsearch+0x7c>
            l = true_m + 1;
  100501:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100504:	83 c0 01             	add    $0x1,%eax
  100507:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  10050a:	eb 78                	jmp    100584 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
  10050c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100513:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100516:	89 d0                	mov    %edx,%eax
  100518:	01 c0                	add    %eax,%eax
  10051a:	01 d0                	add    %edx,%eax
  10051c:	c1 e0 02             	shl    $0x2,%eax
  10051f:	89 c2                	mov    %eax,%edx
  100521:	8b 45 08             	mov    0x8(%ebp),%eax
  100524:	01 d0                	add    %edx,%eax
  100526:	8b 40 08             	mov    0x8(%eax),%eax
  100529:	3b 45 18             	cmp    0x18(%ebp),%eax
  10052c:	73 13                	jae    100541 <stab_binsearch+0xb1>
            *region_left = m;
  10052e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100531:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100534:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100536:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100539:	83 c0 01             	add    $0x1,%eax
  10053c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  10053f:	eb 43                	jmp    100584 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
  100541:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100544:	89 d0                	mov    %edx,%eax
  100546:	01 c0                	add    %eax,%eax
  100548:	01 d0                	add    %edx,%eax
  10054a:	c1 e0 02             	shl    $0x2,%eax
  10054d:	89 c2                	mov    %eax,%edx
  10054f:	8b 45 08             	mov    0x8(%ebp),%eax
  100552:	01 d0                	add    %edx,%eax
  100554:	8b 40 08             	mov    0x8(%eax),%eax
  100557:	3b 45 18             	cmp    0x18(%ebp),%eax
  10055a:	76 16                	jbe    100572 <stab_binsearch+0xe2>
            *region_right = m - 1;
  10055c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10055f:	8d 50 ff             	lea    -0x1(%eax),%edx
  100562:	8b 45 10             	mov    0x10(%ebp),%eax
  100565:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  100567:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10056a:	83 e8 01             	sub    $0x1,%eax
  10056d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  100570:	eb 12                	jmp    100584 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  100572:	8b 45 0c             	mov    0xc(%ebp),%eax
  100575:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100578:	89 10                	mov    %edx,(%eax)
            l = m;
  10057a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10057d:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  100580:	83 45 18 01          	addl   $0x1,0x18(%ebp)
    while (l <= r) {
  100584:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100587:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  10058a:	0f 8e 22 ff ff ff    	jle    1004b2 <stab_binsearch+0x22>
        }
    }

    if (!any_matches) {
  100590:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100594:	75 0f                	jne    1005a5 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
  100596:	8b 45 0c             	mov    0xc(%ebp),%eax
  100599:	8b 00                	mov    (%eax),%eax
  10059b:	8d 50 ff             	lea    -0x1(%eax),%edx
  10059e:	8b 45 10             	mov    0x10(%ebp),%eax
  1005a1:	89 10                	mov    %edx,(%eax)
  1005a3:	eb 3f                	jmp    1005e4 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
  1005a5:	8b 45 10             	mov    0x10(%ebp),%eax
  1005a8:	8b 00                	mov    (%eax),%eax
  1005aa:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1005ad:	eb 04                	jmp    1005b3 <stab_binsearch+0x123>
  1005af:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  1005b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005b6:	8b 00                	mov    (%eax),%eax
  1005b8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1005bb:	7d 1f                	jge    1005dc <stab_binsearch+0x14c>
  1005bd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1005c0:	89 d0                	mov    %edx,%eax
  1005c2:	01 c0                	add    %eax,%eax
  1005c4:	01 d0                	add    %edx,%eax
  1005c6:	c1 e0 02             	shl    $0x2,%eax
  1005c9:	89 c2                	mov    %eax,%edx
  1005cb:	8b 45 08             	mov    0x8(%ebp),%eax
  1005ce:	01 d0                	add    %edx,%eax
  1005d0:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1005d4:	0f b6 c0             	movzbl %al,%eax
  1005d7:	3b 45 14             	cmp    0x14(%ebp),%eax
  1005da:	75 d3                	jne    1005af <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
  1005dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005df:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1005e2:	89 10                	mov    %edx,(%eax)
    }
}
  1005e4:	c9                   	leave  
  1005e5:	c3                   	ret    

001005e6 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  1005e6:	55                   	push   %ebp
  1005e7:	89 e5                	mov    %esp,%ebp
  1005e9:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  1005ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005ef:	c7 00 b8 36 10 00    	movl   $0x1036b8,(%eax)
    info->eip_line = 0;
  1005f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005f8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  1005ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  100602:	c7 40 08 b8 36 10 00 	movl   $0x1036b8,0x8(%eax)
    info->eip_fn_namelen = 9;
  100609:	8b 45 0c             	mov    0xc(%ebp),%eax
  10060c:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100613:	8b 45 0c             	mov    0xc(%ebp),%eax
  100616:	8b 55 08             	mov    0x8(%ebp),%edx
  100619:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  10061c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10061f:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100626:	c7 45 f4 ec 3e 10 00 	movl   $0x103eec,-0xc(%ebp)
    stab_end = __STAB_END__;
  10062d:	c7 45 f0 58 b7 10 00 	movl   $0x10b758,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100634:	c7 45 ec 59 b7 10 00 	movl   $0x10b759,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  10063b:	c7 45 e8 99 d7 10 00 	movl   $0x10d799,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  100642:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100645:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  100648:	76 0d                	jbe    100657 <debuginfo_eip+0x71>
  10064a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10064d:	83 e8 01             	sub    $0x1,%eax
  100650:	0f b6 00             	movzbl (%eax),%eax
  100653:	84 c0                	test   %al,%al
  100655:	74 0a                	je     100661 <debuginfo_eip+0x7b>
        return -1;
  100657:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10065c:	e9 c0 02 00 00       	jmp    100921 <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  100661:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  100668:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10066b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10066e:	29 c2                	sub    %eax,%edx
  100670:	89 d0                	mov    %edx,%eax
  100672:	c1 f8 02             	sar    $0x2,%eax
  100675:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  10067b:	83 e8 01             	sub    $0x1,%eax
  10067e:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  100681:	8b 45 08             	mov    0x8(%ebp),%eax
  100684:	89 44 24 10          	mov    %eax,0x10(%esp)
  100688:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  10068f:	00 
  100690:	8d 45 e0             	lea    -0x20(%ebp),%eax
  100693:	89 44 24 08          	mov    %eax,0x8(%esp)
  100697:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  10069a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10069e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006a1:	89 04 24             	mov    %eax,(%esp)
  1006a4:	e8 e7 fd ff ff       	call   100490 <stab_binsearch>
    if (lfile == 0)
  1006a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006ac:	85 c0                	test   %eax,%eax
  1006ae:	75 0a                	jne    1006ba <debuginfo_eip+0xd4>
        return -1;
  1006b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1006b5:	e9 67 02 00 00       	jmp    100921 <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  1006ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006bd:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1006c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006c3:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  1006c6:	8b 45 08             	mov    0x8(%ebp),%eax
  1006c9:	89 44 24 10          	mov    %eax,0x10(%esp)
  1006cd:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  1006d4:	00 
  1006d5:	8d 45 d8             	lea    -0x28(%ebp),%eax
  1006d8:	89 44 24 08          	mov    %eax,0x8(%esp)
  1006dc:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1006df:	89 44 24 04          	mov    %eax,0x4(%esp)
  1006e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006e6:	89 04 24             	mov    %eax,(%esp)
  1006e9:	e8 a2 fd ff ff       	call   100490 <stab_binsearch>

    if (lfun <= rfun) {
  1006ee:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1006f1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1006f4:	39 c2                	cmp    %eax,%edx
  1006f6:	7f 7c                	jg     100774 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  1006f8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006fb:	89 c2                	mov    %eax,%edx
  1006fd:	89 d0                	mov    %edx,%eax
  1006ff:	01 c0                	add    %eax,%eax
  100701:	01 d0                	add    %edx,%eax
  100703:	c1 e0 02             	shl    $0x2,%eax
  100706:	89 c2                	mov    %eax,%edx
  100708:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10070b:	01 d0                	add    %edx,%eax
  10070d:	8b 10                	mov    (%eax),%edx
  10070f:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  100712:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100715:	29 c1                	sub    %eax,%ecx
  100717:	89 c8                	mov    %ecx,%eax
  100719:	39 c2                	cmp    %eax,%edx
  10071b:	73 22                	jae    10073f <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  10071d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100720:	89 c2                	mov    %eax,%edx
  100722:	89 d0                	mov    %edx,%eax
  100724:	01 c0                	add    %eax,%eax
  100726:	01 d0                	add    %edx,%eax
  100728:	c1 e0 02             	shl    $0x2,%eax
  10072b:	89 c2                	mov    %eax,%edx
  10072d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100730:	01 d0                	add    %edx,%eax
  100732:	8b 10                	mov    (%eax),%edx
  100734:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100737:	01 c2                	add    %eax,%edx
  100739:	8b 45 0c             	mov    0xc(%ebp),%eax
  10073c:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  10073f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100742:	89 c2                	mov    %eax,%edx
  100744:	89 d0                	mov    %edx,%eax
  100746:	01 c0                	add    %eax,%eax
  100748:	01 d0                	add    %edx,%eax
  10074a:	c1 e0 02             	shl    $0x2,%eax
  10074d:	89 c2                	mov    %eax,%edx
  10074f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100752:	01 d0                	add    %edx,%eax
  100754:	8b 50 08             	mov    0x8(%eax),%edx
  100757:	8b 45 0c             	mov    0xc(%ebp),%eax
  10075a:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  10075d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100760:	8b 40 10             	mov    0x10(%eax),%eax
  100763:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  100766:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100769:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  10076c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10076f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  100772:	eb 15                	jmp    100789 <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  100774:	8b 45 0c             	mov    0xc(%ebp),%eax
  100777:	8b 55 08             	mov    0x8(%ebp),%edx
  10077a:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  10077d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100780:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  100783:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100786:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  100789:	8b 45 0c             	mov    0xc(%ebp),%eax
  10078c:	8b 40 08             	mov    0x8(%eax),%eax
  10078f:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  100796:	00 
  100797:	89 04 24             	mov    %eax,(%esp)
  10079a:	e8 75 24 00 00       	call   102c14 <strfind>
  10079f:	89 c2                	mov    %eax,%edx
  1007a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007a4:	8b 40 08             	mov    0x8(%eax),%eax
  1007a7:	29 c2                	sub    %eax,%edx
  1007a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007ac:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1007af:	8b 45 08             	mov    0x8(%ebp),%eax
  1007b2:	89 44 24 10          	mov    %eax,0x10(%esp)
  1007b6:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  1007bd:	00 
  1007be:	8d 45 d0             	lea    -0x30(%ebp),%eax
  1007c1:	89 44 24 08          	mov    %eax,0x8(%esp)
  1007c5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  1007c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1007cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007cf:	89 04 24             	mov    %eax,(%esp)
  1007d2:	e8 b9 fc ff ff       	call   100490 <stab_binsearch>
    if (lline <= rline) {
  1007d7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007da:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1007dd:	39 c2                	cmp    %eax,%edx
  1007df:	7f 24                	jg     100805 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
  1007e1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1007e4:	89 c2                	mov    %eax,%edx
  1007e6:	89 d0                	mov    %edx,%eax
  1007e8:	01 c0                	add    %eax,%eax
  1007ea:	01 d0                	add    %edx,%eax
  1007ec:	c1 e0 02             	shl    $0x2,%eax
  1007ef:	89 c2                	mov    %eax,%edx
  1007f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007f4:	01 d0                	add    %edx,%eax
  1007f6:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  1007fa:	0f b7 d0             	movzwl %ax,%edx
  1007fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  100800:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100803:	eb 13                	jmp    100818 <debuginfo_eip+0x232>
        return -1;
  100805:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10080a:	e9 12 01 00 00       	jmp    100921 <debuginfo_eip+0x33b>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  10080f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100812:	83 e8 01             	sub    $0x1,%eax
  100815:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
  100818:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10081b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10081e:	39 c2                	cmp    %eax,%edx
  100820:	7c 56                	jl     100878 <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
  100822:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100825:	89 c2                	mov    %eax,%edx
  100827:	89 d0                	mov    %edx,%eax
  100829:	01 c0                	add    %eax,%eax
  10082b:	01 d0                	add    %edx,%eax
  10082d:	c1 e0 02             	shl    $0x2,%eax
  100830:	89 c2                	mov    %eax,%edx
  100832:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100835:	01 d0                	add    %edx,%eax
  100837:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10083b:	3c 84                	cmp    $0x84,%al
  10083d:	74 39                	je     100878 <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  10083f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100842:	89 c2                	mov    %eax,%edx
  100844:	89 d0                	mov    %edx,%eax
  100846:	01 c0                	add    %eax,%eax
  100848:	01 d0                	add    %edx,%eax
  10084a:	c1 e0 02             	shl    $0x2,%eax
  10084d:	89 c2                	mov    %eax,%edx
  10084f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100852:	01 d0                	add    %edx,%eax
  100854:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100858:	3c 64                	cmp    $0x64,%al
  10085a:	75 b3                	jne    10080f <debuginfo_eip+0x229>
  10085c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10085f:	89 c2                	mov    %eax,%edx
  100861:	89 d0                	mov    %edx,%eax
  100863:	01 c0                	add    %eax,%eax
  100865:	01 d0                	add    %edx,%eax
  100867:	c1 e0 02             	shl    $0x2,%eax
  10086a:	89 c2                	mov    %eax,%edx
  10086c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10086f:	01 d0                	add    %edx,%eax
  100871:	8b 40 08             	mov    0x8(%eax),%eax
  100874:	85 c0                	test   %eax,%eax
  100876:	74 97                	je     10080f <debuginfo_eip+0x229>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  100878:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10087b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10087e:	39 c2                	cmp    %eax,%edx
  100880:	7c 46                	jl     1008c8 <debuginfo_eip+0x2e2>
  100882:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100885:	89 c2                	mov    %eax,%edx
  100887:	89 d0                	mov    %edx,%eax
  100889:	01 c0                	add    %eax,%eax
  10088b:	01 d0                	add    %edx,%eax
  10088d:	c1 e0 02             	shl    $0x2,%eax
  100890:	89 c2                	mov    %eax,%edx
  100892:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100895:	01 d0                	add    %edx,%eax
  100897:	8b 10                	mov    (%eax),%edx
  100899:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  10089c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10089f:	29 c1                	sub    %eax,%ecx
  1008a1:	89 c8                	mov    %ecx,%eax
  1008a3:	39 c2                	cmp    %eax,%edx
  1008a5:	73 21                	jae    1008c8 <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1008a7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008aa:	89 c2                	mov    %eax,%edx
  1008ac:	89 d0                	mov    %edx,%eax
  1008ae:	01 c0                	add    %eax,%eax
  1008b0:	01 d0                	add    %edx,%eax
  1008b2:	c1 e0 02             	shl    $0x2,%eax
  1008b5:	89 c2                	mov    %eax,%edx
  1008b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008ba:	01 d0                	add    %edx,%eax
  1008bc:	8b 10                	mov    (%eax),%edx
  1008be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1008c1:	01 c2                	add    %eax,%edx
  1008c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008c6:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  1008c8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1008cb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1008ce:	39 c2                	cmp    %eax,%edx
  1008d0:	7d 4a                	jge    10091c <debuginfo_eip+0x336>
        for (lline = lfun + 1;
  1008d2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1008d5:	83 c0 01             	add    $0x1,%eax
  1008d8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  1008db:	eb 18                	jmp    1008f5 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  1008dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008e0:	8b 40 14             	mov    0x14(%eax),%eax
  1008e3:	8d 50 01             	lea    0x1(%eax),%edx
  1008e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008e9:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
  1008ec:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008ef:	83 c0 01             	add    $0x1,%eax
  1008f2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
  1008f5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1008f8:	8b 45 d8             	mov    -0x28(%ebp),%eax
        for (lline = lfun + 1;
  1008fb:	39 c2                	cmp    %eax,%edx
  1008fd:	7d 1d                	jge    10091c <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  1008ff:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100902:	89 c2                	mov    %eax,%edx
  100904:	89 d0                	mov    %edx,%eax
  100906:	01 c0                	add    %eax,%eax
  100908:	01 d0                	add    %edx,%eax
  10090a:	c1 e0 02             	shl    $0x2,%eax
  10090d:	89 c2                	mov    %eax,%edx
  10090f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100912:	01 d0                	add    %edx,%eax
  100914:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100918:	3c a0                	cmp    $0xa0,%al
  10091a:	74 c1                	je     1008dd <debuginfo_eip+0x2f7>
        }
    }
    return 0;
  10091c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100921:	c9                   	leave  
  100922:	c3                   	ret    

00100923 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100923:	55                   	push   %ebp
  100924:	89 e5                	mov    %esp,%ebp
  100926:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  100929:	c7 04 24 c2 36 10 00 	movl   $0x1036c2,(%esp)
  100930:	e8 37 f9 ff ff       	call   10026c <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100935:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  10093c:	00 
  10093d:	c7 04 24 db 36 10 00 	movl   $0x1036db,(%esp)
  100944:	e8 23 f9 ff ff       	call   10026c <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  100949:	c7 44 24 04 aa 35 10 	movl   $0x1035aa,0x4(%esp)
  100950:	00 
  100951:	c7 04 24 f3 36 10 00 	movl   $0x1036f3,(%esp)
  100958:	e8 0f f9 ff ff       	call   10026c <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  10095d:	c7 44 24 04 16 ea 10 	movl   $0x10ea16,0x4(%esp)
  100964:	00 
  100965:	c7 04 24 0b 37 10 00 	movl   $0x10370b,(%esp)
  10096c:	e8 fb f8 ff ff       	call   10026c <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  100971:	c7 44 24 04 80 fd 10 	movl   $0x10fd80,0x4(%esp)
  100978:	00 
  100979:	c7 04 24 23 37 10 00 	movl   $0x103723,(%esp)
  100980:	e8 e7 f8 ff ff       	call   10026c <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  100985:	b8 80 fd 10 00       	mov    $0x10fd80,%eax
  10098a:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  100990:	b8 00 00 10 00       	mov    $0x100000,%eax
  100995:	29 c2                	sub    %eax,%edx
  100997:	89 d0                	mov    %edx,%eax
  100999:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  10099f:	85 c0                	test   %eax,%eax
  1009a1:	0f 48 c2             	cmovs  %edx,%eax
  1009a4:	c1 f8 0a             	sar    $0xa,%eax
  1009a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009ab:	c7 04 24 3c 37 10 00 	movl   $0x10373c,(%esp)
  1009b2:	e8 b5 f8 ff ff       	call   10026c <cprintf>
}
  1009b7:	c9                   	leave  
  1009b8:	c3                   	ret    

001009b9 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  1009b9:	55                   	push   %ebp
  1009ba:	89 e5                	mov    %esp,%ebp
  1009bc:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  1009c2:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1009c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009c9:	8b 45 08             	mov    0x8(%ebp),%eax
  1009cc:	89 04 24             	mov    %eax,(%esp)
  1009cf:	e8 12 fc ff ff       	call   1005e6 <debuginfo_eip>
  1009d4:	85 c0                	test   %eax,%eax
  1009d6:	74 15                	je     1009ed <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  1009d8:	8b 45 08             	mov    0x8(%ebp),%eax
  1009db:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009df:	c7 04 24 66 37 10 00 	movl   $0x103766,(%esp)
  1009e6:	e8 81 f8 ff ff       	call   10026c <cprintf>
  1009eb:	eb 6d                	jmp    100a5a <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  1009ed:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1009f4:	eb 1c                	jmp    100a12 <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
  1009f6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1009f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009fc:	01 d0                	add    %edx,%eax
  1009fe:	0f b6 00             	movzbl (%eax),%eax
  100a01:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100a07:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100a0a:	01 ca                	add    %ecx,%edx
  100a0c:	88 02                	mov    %al,(%edx)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100a0e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100a12:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a15:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  100a18:	7f dc                	jg     1009f6 <print_debuginfo+0x3d>
        }
        fnname[j] = '\0';
  100a1a:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  100a20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a23:	01 d0                	add    %edx,%eax
  100a25:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
  100a28:	8b 45 ec             	mov    -0x14(%ebp),%eax
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100a2b:	8b 55 08             	mov    0x8(%ebp),%edx
  100a2e:	89 d1                	mov    %edx,%ecx
  100a30:	29 c1                	sub    %eax,%ecx
  100a32:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100a35:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100a38:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  100a3c:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100a42:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100a46:	89 54 24 08          	mov    %edx,0x8(%esp)
  100a4a:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a4e:	c7 04 24 82 37 10 00 	movl   $0x103782,(%esp)
  100a55:	e8 12 f8 ff ff       	call   10026c <cprintf>
    }
}
  100a5a:	c9                   	leave  
  100a5b:	c3                   	ret    

00100a5c <read_eip>:

static __noinline uint32_t
read_eip(void) {
  100a5c:	55                   	push   %ebp
  100a5d:	89 e5                	mov    %esp,%ebp
  100a5f:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100a62:	8b 45 04             	mov    0x4(%ebp),%eax
  100a65:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  100a68:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  100a6b:	c9                   	leave  
  100a6c:	c3                   	ret    

00100a6d <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100a6d:	55                   	push   %ebp
  100a6e:	89 e5                	mov    %esp,%ebp
  100a70:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100a73:	89 e8                	mov    %ebp,%eax
  100a75:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
  100a78:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */

	uint32_t ebp_v = read_ebp(), eip_v = read_eip();
  100a7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100a7e:	e8 d9 ff ff ff       	call   100a5c <read_eip>
  100a83:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32_t i, j;
	for (i = 0; ebp_v != 0 && i< STACKFRAME_DEPTH; i ++)
  100a86:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  100a8d:	e9 88 00 00 00       	jmp    100b1a <print_stackframe+0xad>
	{
		cprintf("ebp:0x%08x eip:0x%08x args:", ebp_v, eip_v);
  100a92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a95:	89 44 24 08          	mov    %eax,0x8(%esp)
  100a99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a9c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100aa0:	c7 04 24 94 37 10 00 	movl   $0x103794,(%esp)
  100aa7:	e8 c0 f7 ff ff       	call   10026c <cprintf>
		uint32_t *args = (uint32_t *)ebp_v + 0x2;
  100aac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100aaf:	83 c0 08             	add    $0x8,%eax
  100ab2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		for (j = 0; j < 4; j ++)
  100ab5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  100abc:	eb 25                	jmp    100ae3 <print_stackframe+0x76>
		{
			cprintf(" 0x%08x ", args[j]);
  100abe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100ac1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100ac8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100acb:	01 d0                	add    %edx,%eax
  100acd:	8b 00                	mov    (%eax),%eax
  100acf:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ad3:	c7 04 24 b0 37 10 00 	movl   $0x1037b0,(%esp)
  100ada:	e8 8d f7 ff ff       	call   10026c <cprintf>
		for (j = 0; j < 4; j ++)
  100adf:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
  100ae3:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100ae7:	76 d5                	jbe    100abe <print_stackframe+0x51>
		}
		cprintf("\n");
  100ae9:	c7 04 24 b9 37 10 00 	movl   $0x1037b9,(%esp)
  100af0:	e8 77 f7 ff ff       	call   10026c <cprintf>
		print_debuginfo(eip_v-0x1);
  100af5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100af8:	83 e8 01             	sub    $0x1,%eax
  100afb:	89 04 24             	mov    %eax,(%esp)
  100afe:	e8 b6 fe ff ff       	call   1009b9 <print_debuginfo>
		eip_v = ((uint32_t*)ebp_v)[1];
  100b03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b06:	83 c0 04             	add    $0x4,%eax
  100b09:	8b 00                	mov    (%eax),%eax
  100b0b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		ebp_v = ((uint32_t*)ebp_v)[0];
  100b0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b11:	8b 00                	mov    (%eax),%eax
  100b13:	89 45 f4             	mov    %eax,-0xc(%ebp)
	for (i = 0; ebp_v != 0 && i< STACKFRAME_DEPTH; i ++)
  100b16:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100b1a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100b1e:	74 0a                	je     100b2a <print_stackframe+0xbd>
  100b20:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100b24:	0f 86 68 ff ff ff    	jbe    100a92 <print_stackframe+0x25>
	}

}
  100b2a:	c9                   	leave  
  100b2b:	c3                   	ret    

00100b2c <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100b2c:	55                   	push   %ebp
  100b2d:	89 e5                	mov    %esp,%ebp
  100b2f:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100b32:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b39:	eb 0c                	jmp    100b47 <parse+0x1b>
            *buf ++ = '\0';
  100b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  100b3e:	8d 50 01             	lea    0x1(%eax),%edx
  100b41:	89 55 08             	mov    %edx,0x8(%ebp)
  100b44:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b47:	8b 45 08             	mov    0x8(%ebp),%eax
  100b4a:	0f b6 00             	movzbl (%eax),%eax
  100b4d:	84 c0                	test   %al,%al
  100b4f:	74 1d                	je     100b6e <parse+0x42>
  100b51:	8b 45 08             	mov    0x8(%ebp),%eax
  100b54:	0f b6 00             	movzbl (%eax),%eax
  100b57:	0f be c0             	movsbl %al,%eax
  100b5a:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b5e:	c7 04 24 3c 38 10 00 	movl   $0x10383c,(%esp)
  100b65:	e8 77 20 00 00       	call   102be1 <strchr>
  100b6a:	85 c0                	test   %eax,%eax
  100b6c:	75 cd                	jne    100b3b <parse+0xf>
        }
        if (*buf == '\0') {
  100b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  100b71:	0f b6 00             	movzbl (%eax),%eax
  100b74:	84 c0                	test   %al,%al
  100b76:	75 02                	jne    100b7a <parse+0x4e>
            break;
  100b78:	eb 67                	jmp    100be1 <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100b7a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100b7e:	75 14                	jne    100b94 <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100b80:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100b87:	00 
  100b88:	c7 04 24 41 38 10 00 	movl   $0x103841,(%esp)
  100b8f:	e8 d8 f6 ff ff       	call   10026c <cprintf>
        }
        argv[argc ++] = buf;
  100b94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b97:	8d 50 01             	lea    0x1(%eax),%edx
  100b9a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100b9d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100ba4:	8b 45 0c             	mov    0xc(%ebp),%eax
  100ba7:	01 c2                	add    %eax,%edx
  100ba9:	8b 45 08             	mov    0x8(%ebp),%eax
  100bac:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100bae:	eb 04                	jmp    100bb4 <parse+0x88>
            buf ++;
  100bb0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  100bb7:	0f b6 00             	movzbl (%eax),%eax
  100bba:	84 c0                	test   %al,%al
  100bbc:	74 1d                	je     100bdb <parse+0xaf>
  100bbe:	8b 45 08             	mov    0x8(%ebp),%eax
  100bc1:	0f b6 00             	movzbl (%eax),%eax
  100bc4:	0f be c0             	movsbl %al,%eax
  100bc7:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bcb:	c7 04 24 3c 38 10 00 	movl   $0x10383c,(%esp)
  100bd2:	e8 0a 20 00 00       	call   102be1 <strchr>
  100bd7:	85 c0                	test   %eax,%eax
  100bd9:	74 d5                	je     100bb0 <parse+0x84>
        }
    }
  100bdb:	90                   	nop
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100bdc:	e9 66 ff ff ff       	jmp    100b47 <parse+0x1b>
    return argc;
  100be1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100be4:	c9                   	leave  
  100be5:	c3                   	ret    

00100be6 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100be6:	55                   	push   %ebp
  100be7:	89 e5                	mov    %esp,%ebp
  100be9:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100bec:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100bef:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bf3:	8b 45 08             	mov    0x8(%ebp),%eax
  100bf6:	89 04 24             	mov    %eax,(%esp)
  100bf9:	e8 2e ff ff ff       	call   100b2c <parse>
  100bfe:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100c01:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100c05:	75 0a                	jne    100c11 <runcmd+0x2b>
        return 0;
  100c07:	b8 00 00 00 00       	mov    $0x0,%eax
  100c0c:	e9 85 00 00 00       	jmp    100c96 <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c11:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c18:	eb 5c                	jmp    100c76 <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100c1a:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100c1d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c20:	89 d0                	mov    %edx,%eax
  100c22:	01 c0                	add    %eax,%eax
  100c24:	01 d0                	add    %edx,%eax
  100c26:	c1 e0 02             	shl    $0x2,%eax
  100c29:	05 00 e0 10 00       	add    $0x10e000,%eax
  100c2e:	8b 00                	mov    (%eax),%eax
  100c30:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100c34:	89 04 24             	mov    %eax,(%esp)
  100c37:	e8 06 1f 00 00       	call   102b42 <strcmp>
  100c3c:	85 c0                	test   %eax,%eax
  100c3e:	75 32                	jne    100c72 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100c40:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c43:	89 d0                	mov    %edx,%eax
  100c45:	01 c0                	add    %eax,%eax
  100c47:	01 d0                	add    %edx,%eax
  100c49:	c1 e0 02             	shl    $0x2,%eax
  100c4c:	05 00 e0 10 00       	add    $0x10e000,%eax
  100c51:	8b 40 08             	mov    0x8(%eax),%eax
  100c54:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100c57:	8d 4a ff             	lea    -0x1(%edx),%ecx
  100c5a:	8b 55 0c             	mov    0xc(%ebp),%edx
  100c5d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100c61:	8d 55 b0             	lea    -0x50(%ebp),%edx
  100c64:	83 c2 04             	add    $0x4,%edx
  100c67:	89 54 24 04          	mov    %edx,0x4(%esp)
  100c6b:	89 0c 24             	mov    %ecx,(%esp)
  100c6e:	ff d0                	call   *%eax
  100c70:	eb 24                	jmp    100c96 <runcmd+0xb0>
    for (i = 0; i < NCOMMANDS; i ++) {
  100c72:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100c76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c79:	83 f8 02             	cmp    $0x2,%eax
  100c7c:	76 9c                	jbe    100c1a <runcmd+0x34>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100c7e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100c81:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c85:	c7 04 24 5f 38 10 00 	movl   $0x10385f,(%esp)
  100c8c:	e8 db f5 ff ff       	call   10026c <cprintf>
    return 0;
  100c91:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c96:	c9                   	leave  
  100c97:	c3                   	ret    

00100c98 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100c98:	55                   	push   %ebp
  100c99:	89 e5                	mov    %esp,%ebp
  100c9b:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100c9e:	c7 04 24 78 38 10 00 	movl   $0x103878,(%esp)
  100ca5:	e8 c2 f5 ff ff       	call   10026c <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100caa:	c7 04 24 a0 38 10 00 	movl   $0x1038a0,(%esp)
  100cb1:	e8 b6 f5 ff ff       	call   10026c <cprintf>

    if (tf != NULL) {
  100cb6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100cba:	74 0b                	je     100cc7 <kmonitor+0x2f>
        print_trapframe(tf);
  100cbc:	8b 45 08             	mov    0x8(%ebp),%eax
  100cbf:	89 04 24             	mov    %eax,(%esp)
  100cc2:	e8 36 0d 00 00       	call   1019fd <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100cc7:	c7 04 24 c5 38 10 00 	movl   $0x1038c5,(%esp)
  100cce:	e8 3a f6 ff ff       	call   10030d <readline>
  100cd3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100cd6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100cda:	74 18                	je     100cf4 <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
  100cdc:	8b 45 08             	mov    0x8(%ebp),%eax
  100cdf:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ce3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ce6:	89 04 24             	mov    %eax,(%esp)
  100ce9:	e8 f8 fe ff ff       	call   100be6 <runcmd>
  100cee:	85 c0                	test   %eax,%eax
  100cf0:	79 02                	jns    100cf4 <kmonitor+0x5c>
                break;
  100cf2:	eb 02                	jmp    100cf6 <kmonitor+0x5e>
            }
        }
    }
  100cf4:	eb d1                	jmp    100cc7 <kmonitor+0x2f>
}
  100cf6:	c9                   	leave  
  100cf7:	c3                   	ret    

00100cf8 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100cf8:	55                   	push   %ebp
  100cf9:	89 e5                	mov    %esp,%ebp
  100cfb:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100cfe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100d05:	eb 3f                	jmp    100d46 <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100d07:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100d0a:	89 d0                	mov    %edx,%eax
  100d0c:	01 c0                	add    %eax,%eax
  100d0e:	01 d0                	add    %edx,%eax
  100d10:	c1 e0 02             	shl    $0x2,%eax
  100d13:	05 00 e0 10 00       	add    $0x10e000,%eax
  100d18:	8b 48 04             	mov    0x4(%eax),%ecx
  100d1b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100d1e:	89 d0                	mov    %edx,%eax
  100d20:	01 c0                	add    %eax,%eax
  100d22:	01 d0                	add    %edx,%eax
  100d24:	c1 e0 02             	shl    $0x2,%eax
  100d27:	05 00 e0 10 00       	add    $0x10e000,%eax
  100d2c:	8b 00                	mov    (%eax),%eax
  100d2e:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100d32:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d36:	c7 04 24 c9 38 10 00 	movl   $0x1038c9,(%esp)
  100d3d:	e8 2a f5 ff ff       	call   10026c <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
  100d42:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100d46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d49:	83 f8 02             	cmp    $0x2,%eax
  100d4c:	76 b9                	jbe    100d07 <mon_help+0xf>
    }
    return 0;
  100d4e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d53:	c9                   	leave  
  100d54:	c3                   	ret    

00100d55 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100d55:	55                   	push   %ebp
  100d56:	89 e5                	mov    %esp,%ebp
  100d58:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100d5b:	e8 c3 fb ff ff       	call   100923 <print_kerninfo>
    return 0;
  100d60:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d65:	c9                   	leave  
  100d66:	c3                   	ret    

00100d67 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100d67:	55                   	push   %ebp
  100d68:	89 e5                	mov    %esp,%ebp
  100d6a:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100d6d:	e8 fb fc ff ff       	call   100a6d <print_stackframe>
    return 0;
  100d72:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d77:	c9                   	leave  
  100d78:	c3                   	ret    

00100d79 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d79:	55                   	push   %ebp
  100d7a:	89 e5                	mov    %esp,%ebp
  100d7c:	83 ec 28             	sub    $0x28,%esp
  100d7f:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100d85:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100d89:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100d8d:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100d91:	ee                   	out    %al,(%dx)
  100d92:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100d98:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100d9c:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100da0:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100da4:	ee                   	out    %al,(%dx)
  100da5:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
  100dab:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
  100daf:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100db3:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100db7:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100db8:	c7 05 08 f9 10 00 00 	movl   $0x0,0x10f908
  100dbf:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100dc2:	c7 04 24 d2 38 10 00 	movl   $0x1038d2,(%esp)
  100dc9:	e8 9e f4 ff ff       	call   10026c <cprintf>
    pic_enable(IRQ_TIMER);
  100dce:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100dd5:	e8 b5 08 00 00       	call   10168f <pic_enable>
}
  100dda:	c9                   	leave  
  100ddb:	c3                   	ret    

00100ddc <delay>:
#include <picirq.h>
#include <trap.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100ddc:	55                   	push   %ebp
  100ddd:	89 e5                	mov    %esp,%ebp
  100ddf:	83 ec 10             	sub    $0x10,%esp
  100de2:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100de8:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100dec:	89 c2                	mov    %eax,%edx
  100dee:	ec                   	in     (%dx),%al
  100def:	88 45 fd             	mov    %al,-0x3(%ebp)
  100df2:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100df8:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100dfc:	89 c2                	mov    %eax,%edx
  100dfe:	ec                   	in     (%dx),%al
  100dff:	88 45 f9             	mov    %al,-0x7(%ebp)
  100e02:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100e08:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100e0c:	89 c2                	mov    %eax,%edx
  100e0e:	ec                   	in     (%dx),%al
  100e0f:	88 45 f5             	mov    %al,-0xb(%ebp)
  100e12:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
  100e18:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e1c:	89 c2                	mov    %eax,%edx
  100e1e:	ec                   	in     (%dx),%al
  100e1f:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e22:	c9                   	leave  
  100e23:	c3                   	ret    

00100e24 <cga_init>:
//    -- 数据寄存器 映射 到 端口 0x3D5或0x3B5 
//    -- 索引寄存器 0x3D4或0x3B4,决定在数据寄存器中的数据表示什么。

/* TEXT-mode CGA/VGA display output */
static void
cga_init(void) {
  100e24:	55                   	push   %ebp
  100e25:	89 e5                	mov    %esp,%ebp
  100e27:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;   //CGA_BUF: 0xB8000 (彩色显示的显存物理基址)
  100e2a:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;                                            //保存当前显存0xB8000处的值
  100e31:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e34:	0f b7 00             	movzwl (%eax),%eax
  100e37:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;                                   // 给这个地址随便写个值，看看能否再读出同样的值
  100e3b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e3e:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {                                            // 如果读不出来，说明没有这块显存，即是单显配置
  100e43:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e46:	0f b7 00             	movzwl (%eax),%eax
  100e49:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100e4d:	74 12                	je     100e61 <cga_init+0x3d>
        cp = (uint16_t*)MONO_BUF;                         //设置为单显的显存基址 MONO_BUF： 0xB0000
  100e4f:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;                           //设置为单显控制的IO地址，MONO_BASE: 0x3B4
  100e56:	66 c7 05 66 ee 10 00 	movw   $0x3b4,0x10ee66
  100e5d:	b4 03 
  100e5f:	eb 13                	jmp    100e74 <cga_init+0x50>
    } else {                                                                // 如果读出来了，有这块显存，即是彩显配置
        *cp = was;                                                      //还原原来显存位置的值
  100e61:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e64:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100e68:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;                               // 设置为彩显控制的IO地址，CGA_BASE: 0x3D4 
  100e6b:	66 c7 05 66 ee 10 00 	movw   $0x3d4,0x10ee66
  100e72:	d4 03 
    // Extract cursor location
    // 6845索引寄存器的index 0x0E（及十进制的14）== 光标位置(高位)
    // 6845索引寄存器的index 0x0F（及十进制的15）== 光标位置(低位)
    // 6845 reg 15 : Cursor Address (Low Byte)
    uint32_t pos;
    outb(addr_6845, 14);                                        
  100e74:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e7b:	0f b7 c0             	movzwl %ax,%eax
  100e7e:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  100e82:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e86:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100e8a:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100e8e:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;                       //读出了光标位置(高位)
  100e8f:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e96:	83 c0 01             	add    $0x1,%eax
  100e99:	0f b7 c0             	movzwl %ax,%eax
  100e9c:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100ea0:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100ea4:	89 c2                	mov    %eax,%edx
  100ea6:	ec                   	in     (%dx),%al
  100ea7:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100eaa:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100eae:	0f b6 c0             	movzbl %al,%eax
  100eb1:	c1 e0 08             	shl    $0x8,%eax
  100eb4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100eb7:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100ebe:	0f b7 c0             	movzwl %ax,%eax
  100ec1:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  100ec5:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100ec9:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100ecd:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100ed1:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);                             //读出了光标位置(低位)
  100ed2:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100ed9:	83 c0 01             	add    $0x1,%eax
  100edc:	0f b7 c0             	movzwl %ax,%eax
  100edf:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100ee3:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  100ee7:	89 c2                	mov    %eax,%edx
  100ee9:	ec                   	in     (%dx),%al
  100eea:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
  100eed:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100ef1:	0f b6 c0             	movzbl %al,%eax
  100ef4:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;                                  //crt_buf是CGA显存起始地址
  100ef7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100efa:	a3 60 ee 10 00       	mov    %eax,0x10ee60
    crt_pos = pos;                                                  //crt_pos是CGA当前光标位置
  100eff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100f02:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
}
  100f08:	c9                   	leave  
  100f09:	c3                   	ret    

00100f0a <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100f0a:	55                   	push   %ebp
  100f0b:	89 e5                	mov    %esp,%ebp
  100f0d:	83 ec 48             	sub    $0x48,%esp
  100f10:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100f16:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f1a:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100f1e:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100f22:	ee                   	out    %al,(%dx)
  100f23:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
  100f29:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
  100f2d:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f31:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100f35:	ee                   	out    %al,(%dx)
  100f36:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
  100f3c:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
  100f40:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f44:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f48:	ee                   	out    %al,(%dx)
  100f49:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100f4f:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
  100f53:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f57:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f5b:	ee                   	out    %al,(%dx)
  100f5c:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
  100f62:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
  100f66:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f6a:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100f6e:	ee                   	out    %al,(%dx)
  100f6f:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
  100f75:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
  100f79:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100f7d:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100f81:	ee                   	out    %al,(%dx)
  100f82:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100f88:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
  100f8c:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100f90:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100f94:	ee                   	out    %al,(%dx)
  100f95:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f9b:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
  100f9f:	89 c2                	mov    %eax,%edx
  100fa1:	ec                   	in     (%dx),%al
  100fa2:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
  100fa5:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100fa9:	3c ff                	cmp    $0xff,%al
  100fab:	0f 95 c0             	setne  %al
  100fae:	0f b6 c0             	movzbl %al,%eax
  100fb1:	a3 68 ee 10 00       	mov    %eax,0x10ee68
  100fb6:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100fbc:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
  100fc0:	89 c2                	mov    %eax,%edx
  100fc2:	ec                   	in     (%dx),%al
  100fc3:	88 45 d5             	mov    %al,-0x2b(%ebp)
  100fc6:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
  100fcc:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
  100fd0:	89 c2                	mov    %eax,%edx
  100fd2:	ec                   	in     (%dx),%al
  100fd3:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  100fd6:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  100fdb:	85 c0                	test   %eax,%eax
  100fdd:	74 0c                	je     100feb <serial_init+0xe1>
        pic_enable(IRQ_COM1);
  100fdf:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  100fe6:	e8 a4 06 00 00       	call   10168f <pic_enable>
    }
}
  100feb:	c9                   	leave  
  100fec:	c3                   	ret    

00100fed <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  100fed:	55                   	push   %ebp
  100fee:	89 e5                	mov    %esp,%ebp
  100ff0:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100ff3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  100ffa:	eb 09                	jmp    101005 <lpt_putc_sub+0x18>
        delay();
  100ffc:	e8 db fd ff ff       	call   100ddc <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101001:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101005:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  10100b:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10100f:	89 c2                	mov    %eax,%edx
  101011:	ec                   	in     (%dx),%al
  101012:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101015:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101019:	84 c0                	test   %al,%al
  10101b:	78 09                	js     101026 <lpt_putc_sub+0x39>
  10101d:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101024:	7e d6                	jle    100ffc <lpt_putc_sub+0xf>
    }
    outb(LPTPORT + 0, c);
  101026:	8b 45 08             	mov    0x8(%ebp),%eax
  101029:	0f b6 c0             	movzbl %al,%eax
  10102c:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
  101032:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101035:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101039:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10103d:	ee                   	out    %al,(%dx)
  10103e:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  101044:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  101048:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10104c:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101050:	ee                   	out    %al,(%dx)
  101051:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
  101057:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
  10105b:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10105f:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101063:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  101064:	c9                   	leave  
  101065:	c3                   	ret    

00101066 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  101066:	55                   	push   %ebp
  101067:	89 e5                	mov    %esp,%ebp
  101069:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  10106c:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101070:	74 0d                	je     10107f <lpt_putc+0x19>
        lpt_putc_sub(c);
  101072:	8b 45 08             	mov    0x8(%ebp),%eax
  101075:	89 04 24             	mov    %eax,(%esp)
  101078:	e8 70 ff ff ff       	call   100fed <lpt_putc_sub>
  10107d:	eb 24                	jmp    1010a3 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
  10107f:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101086:	e8 62 ff ff ff       	call   100fed <lpt_putc_sub>
        lpt_putc_sub(' ');
  10108b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  101092:	e8 56 ff ff ff       	call   100fed <lpt_putc_sub>
        lpt_putc_sub('\b');
  101097:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10109e:	e8 4a ff ff ff       	call   100fed <lpt_putc_sub>
    }
}
  1010a3:	c9                   	leave  
  1010a4:	c3                   	ret    

001010a5 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  1010a5:	55                   	push   %ebp
  1010a6:	89 e5                	mov    %esp,%ebp
  1010a8:	53                   	push   %ebx
  1010a9:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  1010ac:	8b 45 08             	mov    0x8(%ebp),%eax
  1010af:	b0 00                	mov    $0x0,%al
  1010b1:	85 c0                	test   %eax,%eax
  1010b3:	75 07                	jne    1010bc <cga_putc+0x17>
        c |= 0x0700;
  1010b5:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  1010bc:	8b 45 08             	mov    0x8(%ebp),%eax
  1010bf:	0f b6 c0             	movzbl %al,%eax
  1010c2:	83 f8 0a             	cmp    $0xa,%eax
  1010c5:	74 4c                	je     101113 <cga_putc+0x6e>
  1010c7:	83 f8 0d             	cmp    $0xd,%eax
  1010ca:	74 57                	je     101123 <cga_putc+0x7e>
  1010cc:	83 f8 08             	cmp    $0x8,%eax
  1010cf:	0f 85 88 00 00 00    	jne    10115d <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
  1010d5:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010dc:	66 85 c0             	test   %ax,%ax
  1010df:	74 30                	je     101111 <cga_putc+0x6c>
            crt_pos --;
  1010e1:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010e8:	83 e8 01             	sub    $0x1,%eax
  1010eb:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  1010f1:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  1010f6:	0f b7 15 64 ee 10 00 	movzwl 0x10ee64,%edx
  1010fd:	0f b7 d2             	movzwl %dx,%edx
  101100:	01 d2                	add    %edx,%edx
  101102:	01 c2                	add    %eax,%edx
  101104:	8b 45 08             	mov    0x8(%ebp),%eax
  101107:	b0 00                	mov    $0x0,%al
  101109:	83 c8 20             	or     $0x20,%eax
  10110c:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  10110f:	eb 72                	jmp    101183 <cga_putc+0xde>
  101111:	eb 70                	jmp    101183 <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
  101113:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  10111a:	83 c0 50             	add    $0x50,%eax
  10111d:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  101123:	0f b7 1d 64 ee 10 00 	movzwl 0x10ee64,%ebx
  10112a:	0f b7 0d 64 ee 10 00 	movzwl 0x10ee64,%ecx
  101131:	0f b7 c1             	movzwl %cx,%eax
  101134:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  10113a:	c1 e8 10             	shr    $0x10,%eax
  10113d:	89 c2                	mov    %eax,%edx
  10113f:	66 c1 ea 06          	shr    $0x6,%dx
  101143:	89 d0                	mov    %edx,%eax
  101145:	c1 e0 02             	shl    $0x2,%eax
  101148:	01 d0                	add    %edx,%eax
  10114a:	c1 e0 04             	shl    $0x4,%eax
  10114d:	29 c1                	sub    %eax,%ecx
  10114f:	89 ca                	mov    %ecx,%edx
  101151:	89 d8                	mov    %ebx,%eax
  101153:	29 d0                	sub    %edx,%eax
  101155:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
        break;
  10115b:	eb 26                	jmp    101183 <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  10115d:	8b 0d 60 ee 10 00    	mov    0x10ee60,%ecx
  101163:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  10116a:	8d 50 01             	lea    0x1(%eax),%edx
  10116d:	66 89 15 64 ee 10 00 	mov    %dx,0x10ee64
  101174:	0f b7 c0             	movzwl %ax,%eax
  101177:	01 c0                	add    %eax,%eax
  101179:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  10117c:	8b 45 08             	mov    0x8(%ebp),%eax
  10117f:	66 89 02             	mov    %ax,(%edx)
        break;
  101182:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  101183:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  10118a:	66 3d cf 07          	cmp    $0x7cf,%ax
  10118e:	76 5b                	jbe    1011eb <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  101190:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  101195:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  10119b:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  1011a0:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  1011a7:	00 
  1011a8:	89 54 24 04          	mov    %edx,0x4(%esp)
  1011ac:	89 04 24             	mov    %eax,(%esp)
  1011af:	e8 2b 1c 00 00       	call   102ddf <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011b4:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  1011bb:	eb 15                	jmp    1011d2 <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
  1011bd:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  1011c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1011c5:	01 d2                	add    %edx,%edx
  1011c7:	01 d0                	add    %edx,%eax
  1011c9:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011ce:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1011d2:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  1011d9:	7e e2                	jle    1011bd <cga_putc+0x118>
        }
        crt_pos -= CRT_COLS;
  1011db:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1011e2:	83 e8 50             	sub    $0x50,%eax
  1011e5:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  1011eb:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  1011f2:	0f b7 c0             	movzwl %ax,%eax
  1011f5:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  1011f9:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
  1011fd:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101201:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101205:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  101206:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  10120d:	66 c1 e8 08          	shr    $0x8,%ax
  101211:	0f b6 c0             	movzbl %al,%eax
  101214:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  10121b:	83 c2 01             	add    $0x1,%edx
  10121e:	0f b7 d2             	movzwl %dx,%edx
  101221:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
  101225:	88 45 ed             	mov    %al,-0x13(%ebp)
  101228:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10122c:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101230:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  101231:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  101238:	0f b7 c0             	movzwl %ax,%eax
  10123b:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  10123f:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
  101243:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101247:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10124b:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  10124c:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101253:	0f b6 c0             	movzbl %al,%eax
  101256:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  10125d:	83 c2 01             	add    $0x1,%edx
  101260:	0f b7 d2             	movzwl %dx,%edx
  101263:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
  101267:	88 45 e5             	mov    %al,-0x1b(%ebp)
  10126a:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  10126e:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101272:	ee                   	out    %al,(%dx)
}
  101273:	83 c4 34             	add    $0x34,%esp
  101276:	5b                   	pop    %ebx
  101277:	5d                   	pop    %ebp
  101278:	c3                   	ret    

00101279 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  101279:	55                   	push   %ebp
  10127a:	89 e5                	mov    %esp,%ebp
  10127c:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  10127f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101286:	eb 09                	jmp    101291 <serial_putc_sub+0x18>
        delay();
  101288:	e8 4f fb ff ff       	call   100ddc <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  10128d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101291:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101297:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10129b:	89 c2                	mov    %eax,%edx
  10129d:	ec                   	in     (%dx),%al
  10129e:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1012a1:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1012a5:	0f b6 c0             	movzbl %al,%eax
  1012a8:	83 e0 20             	and    $0x20,%eax
  1012ab:	85 c0                	test   %eax,%eax
  1012ad:	75 09                	jne    1012b8 <serial_putc_sub+0x3f>
  1012af:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  1012b6:	7e d0                	jle    101288 <serial_putc_sub+0xf>
    }
    outb(COM1 + COM_TX, c);
  1012b8:	8b 45 08             	mov    0x8(%ebp),%eax
  1012bb:	0f b6 c0             	movzbl %al,%eax
  1012be:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  1012c4:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1012c7:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1012cb:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1012cf:	ee                   	out    %al,(%dx)
}
  1012d0:	c9                   	leave  
  1012d1:	c3                   	ret    

001012d2 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  1012d2:	55                   	push   %ebp
  1012d3:	89 e5                	mov    %esp,%ebp
  1012d5:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1012d8:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1012dc:	74 0d                	je     1012eb <serial_putc+0x19>
        serial_putc_sub(c);
  1012de:	8b 45 08             	mov    0x8(%ebp),%eax
  1012e1:	89 04 24             	mov    %eax,(%esp)
  1012e4:	e8 90 ff ff ff       	call   101279 <serial_putc_sub>
  1012e9:	eb 24                	jmp    10130f <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
  1012eb:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1012f2:	e8 82 ff ff ff       	call   101279 <serial_putc_sub>
        serial_putc_sub(' ');
  1012f7:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1012fe:	e8 76 ff ff ff       	call   101279 <serial_putc_sub>
        serial_putc_sub('\b');
  101303:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10130a:	e8 6a ff ff ff       	call   101279 <serial_putc_sub>
    }
}
  10130f:	c9                   	leave  
  101310:	c3                   	ret    

00101311 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  101311:	55                   	push   %ebp
  101312:	89 e5                	mov    %esp,%ebp
  101314:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  101317:	eb 33                	jmp    10134c <cons_intr+0x3b>
        if (c != 0) {
  101319:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10131d:	74 2d                	je     10134c <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  10131f:	a1 84 f0 10 00       	mov    0x10f084,%eax
  101324:	8d 50 01             	lea    0x1(%eax),%edx
  101327:	89 15 84 f0 10 00    	mov    %edx,0x10f084
  10132d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101330:	88 90 80 ee 10 00    	mov    %dl,0x10ee80(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  101336:	a1 84 f0 10 00       	mov    0x10f084,%eax
  10133b:	3d 00 02 00 00       	cmp    $0x200,%eax
  101340:	75 0a                	jne    10134c <cons_intr+0x3b>
                cons.wpos = 0;
  101342:	c7 05 84 f0 10 00 00 	movl   $0x0,0x10f084
  101349:	00 00 00 
    while ((c = (*proc)()) != -1) {
  10134c:	8b 45 08             	mov    0x8(%ebp),%eax
  10134f:	ff d0                	call   *%eax
  101351:	89 45 f4             	mov    %eax,-0xc(%ebp)
  101354:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  101358:	75 bf                	jne    101319 <cons_intr+0x8>
            }
        }
    }
}
  10135a:	c9                   	leave  
  10135b:	c3                   	ret    

0010135c <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  10135c:	55                   	push   %ebp
  10135d:	89 e5                	mov    %esp,%ebp
  10135f:	83 ec 10             	sub    $0x10,%esp
  101362:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101368:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10136c:	89 c2                	mov    %eax,%edx
  10136e:	ec                   	in     (%dx),%al
  10136f:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101372:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  101376:	0f b6 c0             	movzbl %al,%eax
  101379:	83 e0 01             	and    $0x1,%eax
  10137c:	85 c0                	test   %eax,%eax
  10137e:	75 07                	jne    101387 <serial_proc_data+0x2b>
        return -1;
  101380:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101385:	eb 2a                	jmp    1013b1 <serial_proc_data+0x55>
  101387:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10138d:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  101391:	89 c2                	mov    %eax,%edx
  101393:	ec                   	in     (%dx),%al
  101394:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  101397:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  10139b:	0f b6 c0             	movzbl %al,%eax
  10139e:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  1013a1:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  1013a5:	75 07                	jne    1013ae <serial_proc_data+0x52>
        c = '\b';
  1013a7:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  1013ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1013b1:	c9                   	leave  
  1013b2:	c3                   	ret    

001013b3 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  1013b3:	55                   	push   %ebp
  1013b4:	89 e5                	mov    %esp,%ebp
  1013b6:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  1013b9:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  1013be:	85 c0                	test   %eax,%eax
  1013c0:	74 0c                	je     1013ce <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  1013c2:	c7 04 24 5c 13 10 00 	movl   $0x10135c,(%esp)
  1013c9:	e8 43 ff ff ff       	call   101311 <cons_intr>
    }
}
  1013ce:	c9                   	leave  
  1013cf:	c3                   	ret    

001013d0 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  1013d0:	55                   	push   %ebp
  1013d1:	89 e5                	mov    %esp,%ebp
  1013d3:	83 ec 38             	sub    $0x38,%esp
  1013d6:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013dc:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1013e0:	89 c2                	mov    %eax,%edx
  1013e2:	ec                   	in     (%dx),%al
  1013e3:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  1013e6:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  1013ea:	0f b6 c0             	movzbl %al,%eax
  1013ed:	83 e0 01             	and    $0x1,%eax
  1013f0:	85 c0                	test   %eax,%eax
  1013f2:	75 0a                	jne    1013fe <kbd_proc_data+0x2e>
        return -1;
  1013f4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013f9:	e9 59 01 00 00       	jmp    101557 <kbd_proc_data+0x187>
  1013fe:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101404:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101408:	89 c2                	mov    %eax,%edx
  10140a:	ec                   	in     (%dx),%al
  10140b:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  10140e:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  101412:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  101415:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  101419:	75 17                	jne    101432 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  10141b:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101420:	83 c8 40             	or     $0x40,%eax
  101423:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  101428:	b8 00 00 00 00       	mov    $0x0,%eax
  10142d:	e9 25 01 00 00       	jmp    101557 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
  101432:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101436:	84 c0                	test   %al,%al
  101438:	79 47                	jns    101481 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  10143a:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10143f:	83 e0 40             	and    $0x40,%eax
  101442:	85 c0                	test   %eax,%eax
  101444:	75 09                	jne    10144f <kbd_proc_data+0x7f>
  101446:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10144a:	83 e0 7f             	and    $0x7f,%eax
  10144d:	eb 04                	jmp    101453 <kbd_proc_data+0x83>
  10144f:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101453:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  101456:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10145a:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  101461:	83 c8 40             	or     $0x40,%eax
  101464:	0f b6 c0             	movzbl %al,%eax
  101467:	f7 d0                	not    %eax
  101469:	89 c2                	mov    %eax,%edx
  10146b:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101470:	21 d0                	and    %edx,%eax
  101472:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  101477:	b8 00 00 00 00       	mov    $0x0,%eax
  10147c:	e9 d6 00 00 00       	jmp    101557 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
  101481:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101486:	83 e0 40             	and    $0x40,%eax
  101489:	85 c0                	test   %eax,%eax
  10148b:	74 11                	je     10149e <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  10148d:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  101491:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101496:	83 e0 bf             	and    $0xffffffbf,%eax
  101499:	a3 88 f0 10 00       	mov    %eax,0x10f088
    }

    shift |= shiftcode[data];
  10149e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014a2:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  1014a9:	0f b6 d0             	movzbl %al,%edx
  1014ac:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014b1:	09 d0                	or     %edx,%eax
  1014b3:	a3 88 f0 10 00       	mov    %eax,0x10f088
    shift ^= togglecode[data];
  1014b8:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014bc:	0f b6 80 40 e1 10 00 	movzbl 0x10e140(%eax),%eax
  1014c3:	0f b6 d0             	movzbl %al,%edx
  1014c6:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014cb:	31 d0                	xor    %edx,%eax
  1014cd:	a3 88 f0 10 00       	mov    %eax,0x10f088

    c = charcode[shift & (CTL | SHIFT)][data];
  1014d2:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014d7:	83 e0 03             	and    $0x3,%eax
  1014da:	8b 14 85 40 e5 10 00 	mov    0x10e540(,%eax,4),%edx
  1014e1:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014e5:	01 d0                	add    %edx,%eax
  1014e7:	0f b6 00             	movzbl (%eax),%eax
  1014ea:	0f b6 c0             	movzbl %al,%eax
  1014ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  1014f0:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014f5:	83 e0 08             	and    $0x8,%eax
  1014f8:	85 c0                	test   %eax,%eax
  1014fa:	74 22                	je     10151e <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  1014fc:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  101500:	7e 0c                	jle    10150e <kbd_proc_data+0x13e>
  101502:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  101506:	7f 06                	jg     10150e <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  101508:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  10150c:	eb 10                	jmp    10151e <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  10150e:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  101512:	7e 0a                	jle    10151e <kbd_proc_data+0x14e>
  101514:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  101518:	7f 04                	jg     10151e <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  10151a:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  10151e:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101523:	f7 d0                	not    %eax
  101525:	83 e0 06             	and    $0x6,%eax
  101528:	85 c0                	test   %eax,%eax
  10152a:	75 28                	jne    101554 <kbd_proc_data+0x184>
  10152c:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  101533:	75 1f                	jne    101554 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
  101535:	c7 04 24 ed 38 10 00 	movl   $0x1038ed,(%esp)
  10153c:	e8 2b ed ff ff       	call   10026c <cprintf>
  101541:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  101547:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10154b:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  10154f:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  101553:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  101554:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  101557:	c9                   	leave  
  101558:	c3                   	ret    

00101559 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  101559:	55                   	push   %ebp
  10155a:	89 e5                	mov    %esp,%ebp
  10155c:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  10155f:	c7 04 24 d0 13 10 00 	movl   $0x1013d0,(%esp)
  101566:	e8 a6 fd ff ff       	call   101311 <cons_intr>
}
  10156b:	c9                   	leave  
  10156c:	c3                   	ret    

0010156d <kbd_init>:

static void
kbd_init(void) {
  10156d:	55                   	push   %ebp
  10156e:	89 e5                	mov    %esp,%ebp
  101570:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  101573:	e8 e1 ff ff ff       	call   101559 <kbd_intr>
    pic_enable(IRQ_KBD);
  101578:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10157f:	e8 0b 01 00 00       	call   10168f <pic_enable>
}
  101584:	c9                   	leave  
  101585:	c3                   	ret    

00101586 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  101586:	55                   	push   %ebp
  101587:	89 e5                	mov    %esp,%ebp
  101589:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  10158c:	e8 93 f8 ff ff       	call   100e24 <cga_init>
    serial_init();
  101591:	e8 74 f9 ff ff       	call   100f0a <serial_init>
    kbd_init();
  101596:	e8 d2 ff ff ff       	call   10156d <kbd_init>
    if (!serial_exists) {
  10159b:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  1015a0:	85 c0                	test   %eax,%eax
  1015a2:	75 0c                	jne    1015b0 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  1015a4:	c7 04 24 f9 38 10 00 	movl   $0x1038f9,(%esp)
  1015ab:	e8 bc ec ff ff       	call   10026c <cprintf>
    }
}
  1015b0:	c9                   	leave  
  1015b1:	c3                   	ret    

001015b2 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  1015b2:	55                   	push   %ebp
  1015b3:	89 e5                	mov    %esp,%ebp
  1015b5:	83 ec 18             	sub    $0x18,%esp
    lpt_putc(c);
  1015b8:	8b 45 08             	mov    0x8(%ebp),%eax
  1015bb:	89 04 24             	mov    %eax,(%esp)
  1015be:	e8 a3 fa ff ff       	call   101066 <lpt_putc>
    cga_putc(c);
  1015c3:	8b 45 08             	mov    0x8(%ebp),%eax
  1015c6:	89 04 24             	mov    %eax,(%esp)
  1015c9:	e8 d7 fa ff ff       	call   1010a5 <cga_putc>
    serial_putc(c);
  1015ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1015d1:	89 04 24             	mov    %eax,(%esp)
  1015d4:	e8 f9 fc ff ff       	call   1012d2 <serial_putc>
}
  1015d9:	c9                   	leave  
  1015da:	c3                   	ret    

001015db <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  1015db:	55                   	push   %ebp
  1015dc:	89 e5                	mov    %esp,%ebp
  1015de:	83 ec 18             	sub    $0x18,%esp
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  1015e1:	e8 cd fd ff ff       	call   1013b3 <serial_intr>
    kbd_intr();
  1015e6:	e8 6e ff ff ff       	call   101559 <kbd_intr>

    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  1015eb:	8b 15 80 f0 10 00    	mov    0x10f080,%edx
  1015f1:	a1 84 f0 10 00       	mov    0x10f084,%eax
  1015f6:	39 c2                	cmp    %eax,%edx
  1015f8:	74 36                	je     101630 <cons_getc+0x55>
        c = cons.buf[cons.rpos ++];
  1015fa:	a1 80 f0 10 00       	mov    0x10f080,%eax
  1015ff:	8d 50 01             	lea    0x1(%eax),%edx
  101602:	89 15 80 f0 10 00    	mov    %edx,0x10f080
  101608:	0f b6 80 80 ee 10 00 	movzbl 0x10ee80(%eax),%eax
  10160f:	0f b6 c0             	movzbl %al,%eax
  101612:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (cons.rpos == CONSBUFSIZE) {
  101615:	a1 80 f0 10 00       	mov    0x10f080,%eax
  10161a:	3d 00 02 00 00       	cmp    $0x200,%eax
  10161f:	75 0a                	jne    10162b <cons_getc+0x50>
            cons.rpos = 0;
  101621:	c7 05 80 f0 10 00 00 	movl   $0x0,0x10f080
  101628:	00 00 00 
        }
        return c;
  10162b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10162e:	eb 05                	jmp    101635 <cons_getc+0x5a>
    }
    return 0;
  101630:	b8 00 00 00 00       	mov    $0x0,%eax
}
  101635:	c9                   	leave  
  101636:	c3                   	ret    

00101637 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  101637:	55                   	push   %ebp
  101638:	89 e5                	mov    %esp,%ebp
  10163a:	83 ec 14             	sub    $0x14,%esp
  10163d:	8b 45 08             	mov    0x8(%ebp),%eax
  101640:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  101644:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101648:	66 a3 50 e5 10 00    	mov    %ax,0x10e550
    if (did_init) {
  10164e:	a1 8c f0 10 00       	mov    0x10f08c,%eax
  101653:	85 c0                	test   %eax,%eax
  101655:	74 36                	je     10168d <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  101657:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10165b:	0f b6 c0             	movzbl %al,%eax
  10165e:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  101664:	88 45 fd             	mov    %al,-0x3(%ebp)
  101667:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  10166b:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  10166f:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  101670:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101674:	66 c1 e8 08          	shr    $0x8,%ax
  101678:	0f b6 c0             	movzbl %al,%eax
  10167b:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  101681:	88 45 f9             	mov    %al,-0x7(%ebp)
  101684:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101688:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10168c:	ee                   	out    %al,(%dx)
    }
}
  10168d:	c9                   	leave  
  10168e:	c3                   	ret    

0010168f <pic_enable>:

void
pic_enable(unsigned int irq) {
  10168f:	55                   	push   %ebp
  101690:	89 e5                	mov    %esp,%ebp
  101692:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  101695:	8b 45 08             	mov    0x8(%ebp),%eax
  101698:	ba 01 00 00 00       	mov    $0x1,%edx
  10169d:	89 c1                	mov    %eax,%ecx
  10169f:	d3 e2                	shl    %cl,%edx
  1016a1:	89 d0                	mov    %edx,%eax
  1016a3:	f7 d0                	not    %eax
  1016a5:	89 c2                	mov    %eax,%edx
  1016a7:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1016ae:	21 d0                	and    %edx,%eax
  1016b0:	0f b7 c0             	movzwl %ax,%eax
  1016b3:	89 04 24             	mov    %eax,(%esp)
  1016b6:	e8 7c ff ff ff       	call   101637 <pic_setmask>
}
  1016bb:	c9                   	leave  
  1016bc:	c3                   	ret    

001016bd <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  1016bd:	55                   	push   %ebp
  1016be:	89 e5                	mov    %esp,%ebp
  1016c0:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  1016c3:	c7 05 8c f0 10 00 01 	movl   $0x1,0x10f08c
  1016ca:	00 00 00 
  1016cd:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  1016d3:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
  1016d7:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1016db:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1016df:	ee                   	out    %al,(%dx)
  1016e0:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  1016e6:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
  1016ea:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1016ee:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1016f2:	ee                   	out    %al,(%dx)
  1016f3:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  1016f9:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
  1016fd:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101701:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101705:	ee                   	out    %al,(%dx)
  101706:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
  10170c:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
  101710:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101714:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101718:	ee                   	out    %al,(%dx)
  101719:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
  10171f:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
  101723:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101727:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10172b:	ee                   	out    %al,(%dx)
  10172c:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
  101732:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
  101736:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10173a:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10173e:	ee                   	out    %al,(%dx)
  10173f:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  101745:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
  101749:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  10174d:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101751:	ee                   	out    %al,(%dx)
  101752:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
  101758:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
  10175c:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  101760:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  101764:	ee                   	out    %al,(%dx)
  101765:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
  10176b:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
  10176f:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  101773:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  101777:	ee                   	out    %al,(%dx)
  101778:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
  10177e:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
  101782:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  101786:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  10178a:	ee                   	out    %al,(%dx)
  10178b:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
  101791:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
  101795:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  101799:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  10179d:	ee                   	out    %al,(%dx)
  10179e:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  1017a4:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
  1017a8:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  1017ac:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  1017b0:	ee                   	out    %al,(%dx)
  1017b1:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
  1017b7:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
  1017bb:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  1017bf:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  1017c3:	ee                   	out    %al,(%dx)
  1017c4:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
  1017ca:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
  1017ce:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  1017d2:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  1017d6:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  1017d7:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017de:	66 83 f8 ff          	cmp    $0xffff,%ax
  1017e2:	74 12                	je     1017f6 <pic_init+0x139>
        pic_setmask(irq_mask);
  1017e4:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017eb:	0f b7 c0             	movzwl %ax,%eax
  1017ee:	89 04 24             	mov    %eax,(%esp)
  1017f1:	e8 41 fe ff ff       	call   101637 <pic_setmask>
    }
}
  1017f6:	c9                   	leave  
  1017f7:	c3                   	ret    

001017f8 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  1017f8:	55                   	push   %ebp
  1017f9:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd));
}

static inline void
sti(void) {
    asm volatile ("sti");
  1017fb:	fb                   	sti    
    sti();
}
  1017fc:	5d                   	pop    %ebp
  1017fd:	c3                   	ret    

001017fe <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  1017fe:	55                   	push   %ebp
  1017ff:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli");
  101801:	fa                   	cli    
    cli();
}
  101802:	5d                   	pop    %ebp
  101803:	c3                   	ret    

00101804 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  101804:	55                   	push   %ebp
  101805:	89 e5                	mov    %esp,%ebp
  101807:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  10180a:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  101811:	00 
  101812:	c7 04 24 20 39 10 00 	movl   $0x103920,(%esp)
  101819:	e8 4e ea ff ff       	call   10026c <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
  10181e:	c7 04 24 2a 39 10 00 	movl   $0x10392a,(%esp)
  101825:	e8 42 ea ff ff       	call   10026c <cprintf>
    panic("EOT: kernel seems ok.");
  10182a:	c7 44 24 08 38 39 10 	movl   $0x103938,0x8(%esp)
  101831:	00 
  101832:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
  101839:	00 
  10183a:	c7 04 24 4e 39 10 00 	movl   $0x10394e,(%esp)
  101841:	e8 7d eb ff ff       	call   1003c3 <__panic>

00101846 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  101846:	55                   	push   %ebp
  101847:	89 e5                	mov    %esp,%ebp
  101849:	83 ec 10             	sub    $0x10,%esp
      */

	extern uintptr_t __vectors[];

	uint32_t i;
	for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++)
  10184c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101853:	e9 c3 00 00 00       	jmp    10191b <idt_init+0xd5>
	{
		SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  101858:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10185b:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  101862:	89 c2                	mov    %eax,%edx
  101864:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101867:	66 89 14 c5 a0 f0 10 	mov    %dx,0x10f0a0(,%eax,8)
  10186e:	00 
  10186f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101872:	66 c7 04 c5 a2 f0 10 	movw   $0x8,0x10f0a2(,%eax,8)
  101879:	00 08 00 
  10187c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10187f:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  101886:	00 
  101887:	83 e2 e0             	and    $0xffffffe0,%edx
  10188a:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  101891:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101894:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  10189b:	00 
  10189c:	83 e2 1f             	and    $0x1f,%edx
  10189f:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  1018a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018a9:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018b0:	00 
  1018b1:	83 e2 f0             	and    $0xfffffff0,%edx
  1018b4:	83 ca 0e             	or     $0xe,%edx
  1018b7:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018be:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018c1:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018c8:	00 
  1018c9:	83 e2 ef             	and    $0xffffffef,%edx
  1018cc:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018d6:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018dd:	00 
  1018de:	83 e2 9f             	and    $0xffffff9f,%edx
  1018e1:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018eb:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018f2:	00 
  1018f3:	83 ca 80             	or     $0xffffff80,%edx
  1018f6:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101900:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  101907:	c1 e8 10             	shr    $0x10,%eax
  10190a:	89 c2                	mov    %eax,%edx
  10190c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10190f:	66 89 14 c5 a6 f0 10 	mov    %dx,0x10f0a6(,%eax,8)
  101916:	00 
	for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++)
  101917:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10191b:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
  101922:	0f 86 30 ff ff ff    	jbe    101858 <idt_init+0x12>
	}

	// set for switch from user to kernel
	SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
  101928:	a1 c4 e7 10 00       	mov    0x10e7c4,%eax
  10192d:	66 a3 68 f4 10 00    	mov    %ax,0x10f468
  101933:	66 c7 05 6a f4 10 00 	movw   $0x8,0x10f46a
  10193a:	08 00 
  10193c:	0f b6 05 6c f4 10 00 	movzbl 0x10f46c,%eax
  101943:	83 e0 e0             	and    $0xffffffe0,%eax
  101946:	a2 6c f4 10 00       	mov    %al,0x10f46c
  10194b:	0f b6 05 6c f4 10 00 	movzbl 0x10f46c,%eax
  101952:	83 e0 1f             	and    $0x1f,%eax
  101955:	a2 6c f4 10 00       	mov    %al,0x10f46c
  10195a:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  101961:	83 e0 f0             	and    $0xfffffff0,%eax
  101964:	83 c8 0e             	or     $0xe,%eax
  101967:	a2 6d f4 10 00       	mov    %al,0x10f46d
  10196c:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  101973:	83 e0 ef             	and    $0xffffffef,%eax
  101976:	a2 6d f4 10 00       	mov    %al,0x10f46d
  10197b:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  101982:	83 c8 60             	or     $0x60,%eax
  101985:	a2 6d f4 10 00       	mov    %al,0x10f46d
  10198a:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  101991:	83 c8 80             	or     $0xffffff80,%eax
  101994:	a2 6d f4 10 00       	mov    %al,0x10f46d
  101999:	a1 c4 e7 10 00       	mov    0x10e7c4,%eax
  10199e:	c1 e8 10             	shr    $0x10,%eax
  1019a1:	66 a3 6e f4 10 00    	mov    %ax,0x10f46e
  1019a7:	c7 45 f8 60 e5 10 00 	movl   $0x10e560,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd));
  1019ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1019b1:	0f 01 18             	lidtl  (%eax)

	// idt 存储了具体的信息， idtpd，作为一个结构体，将idt进行了进一步封装，这种写法很常见
	lidt(&idt_pd);


}
  1019b4:	c9                   	leave  
  1019b5:	c3                   	ret    

001019b6 <trapname>:

static const char *
trapname(int trapno) {
  1019b6:	55                   	push   %ebp
  1019b7:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  1019b9:	8b 45 08             	mov    0x8(%ebp),%eax
  1019bc:	83 f8 13             	cmp    $0x13,%eax
  1019bf:	77 0c                	ja     1019cd <trapname+0x17>
        return excnames[trapno];
  1019c1:	8b 45 08             	mov    0x8(%ebp),%eax
  1019c4:	8b 04 85 a0 3c 10 00 	mov    0x103ca0(,%eax,4),%eax
  1019cb:	eb 18                	jmp    1019e5 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  1019cd:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  1019d1:	7e 0d                	jle    1019e0 <trapname+0x2a>
  1019d3:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  1019d7:	7f 07                	jg     1019e0 <trapname+0x2a>
        return "Hardware Interrupt";
  1019d9:	b8 5f 39 10 00       	mov    $0x10395f,%eax
  1019de:	eb 05                	jmp    1019e5 <trapname+0x2f>
    }
    return "(unknown trap)";
  1019e0:	b8 72 39 10 00       	mov    $0x103972,%eax
}
  1019e5:	5d                   	pop    %ebp
  1019e6:	c3                   	ret    

001019e7 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  1019e7:	55                   	push   %ebp
  1019e8:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  1019ea:	8b 45 08             	mov    0x8(%ebp),%eax
  1019ed:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  1019f1:	66 83 f8 08          	cmp    $0x8,%ax
  1019f5:	0f 94 c0             	sete   %al
  1019f8:	0f b6 c0             	movzbl %al,%eax
}
  1019fb:	5d                   	pop    %ebp
  1019fc:	c3                   	ret    

001019fd <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  1019fd:	55                   	push   %ebp
  1019fe:	89 e5                	mov    %esp,%ebp
  101a00:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101a03:	8b 45 08             	mov    0x8(%ebp),%eax
  101a06:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a0a:	c7 04 24 b3 39 10 00 	movl   $0x1039b3,(%esp)
  101a11:	e8 56 e8 ff ff       	call   10026c <cprintf>
    print_regs(&tf->tf_regs);
  101a16:	8b 45 08             	mov    0x8(%ebp),%eax
  101a19:	89 04 24             	mov    %eax,(%esp)
  101a1c:	e8 a1 01 00 00       	call   101bc2 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101a21:	8b 45 08             	mov    0x8(%ebp),%eax
  101a24:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101a28:	0f b7 c0             	movzwl %ax,%eax
  101a2b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a2f:	c7 04 24 c4 39 10 00 	movl   $0x1039c4,(%esp)
  101a36:	e8 31 e8 ff ff       	call   10026c <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101a3b:	8b 45 08             	mov    0x8(%ebp),%eax
  101a3e:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101a42:	0f b7 c0             	movzwl %ax,%eax
  101a45:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a49:	c7 04 24 d7 39 10 00 	movl   $0x1039d7,(%esp)
  101a50:	e8 17 e8 ff ff       	call   10026c <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101a55:	8b 45 08             	mov    0x8(%ebp),%eax
  101a58:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101a5c:	0f b7 c0             	movzwl %ax,%eax
  101a5f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a63:	c7 04 24 ea 39 10 00 	movl   $0x1039ea,(%esp)
  101a6a:	e8 fd e7 ff ff       	call   10026c <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  101a72:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101a76:	0f b7 c0             	movzwl %ax,%eax
  101a79:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a7d:	c7 04 24 fd 39 10 00 	movl   $0x1039fd,(%esp)
  101a84:	e8 e3 e7 ff ff       	call   10026c <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101a89:	8b 45 08             	mov    0x8(%ebp),%eax
  101a8c:	8b 40 30             	mov    0x30(%eax),%eax
  101a8f:	89 04 24             	mov    %eax,(%esp)
  101a92:	e8 1f ff ff ff       	call   1019b6 <trapname>
  101a97:	8b 55 08             	mov    0x8(%ebp),%edx
  101a9a:	8b 52 30             	mov    0x30(%edx),%edx
  101a9d:	89 44 24 08          	mov    %eax,0x8(%esp)
  101aa1:	89 54 24 04          	mov    %edx,0x4(%esp)
  101aa5:	c7 04 24 10 3a 10 00 	movl   $0x103a10,(%esp)
  101aac:	e8 bb e7 ff ff       	call   10026c <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101ab1:	8b 45 08             	mov    0x8(%ebp),%eax
  101ab4:	8b 40 34             	mov    0x34(%eax),%eax
  101ab7:	89 44 24 04          	mov    %eax,0x4(%esp)
  101abb:	c7 04 24 22 3a 10 00 	movl   $0x103a22,(%esp)
  101ac2:	e8 a5 e7 ff ff       	call   10026c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101ac7:	8b 45 08             	mov    0x8(%ebp),%eax
  101aca:	8b 40 38             	mov    0x38(%eax),%eax
  101acd:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ad1:	c7 04 24 31 3a 10 00 	movl   $0x103a31,(%esp)
  101ad8:	e8 8f e7 ff ff       	call   10026c <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101add:	8b 45 08             	mov    0x8(%ebp),%eax
  101ae0:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101ae4:	0f b7 c0             	movzwl %ax,%eax
  101ae7:	89 44 24 04          	mov    %eax,0x4(%esp)
  101aeb:	c7 04 24 40 3a 10 00 	movl   $0x103a40,(%esp)
  101af2:	e8 75 e7 ff ff       	call   10026c <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101af7:	8b 45 08             	mov    0x8(%ebp),%eax
  101afa:	8b 40 40             	mov    0x40(%eax),%eax
  101afd:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b01:	c7 04 24 53 3a 10 00 	movl   $0x103a53,(%esp)
  101b08:	e8 5f e7 ff ff       	call   10026c <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b0d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101b14:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101b1b:	eb 3e                	jmp    101b5b <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  101b20:	8b 50 40             	mov    0x40(%eax),%edx
  101b23:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101b26:	21 d0                	and    %edx,%eax
  101b28:	85 c0                	test   %eax,%eax
  101b2a:	74 28                	je     101b54 <print_trapframe+0x157>
  101b2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b2f:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101b36:	85 c0                	test   %eax,%eax
  101b38:	74 1a                	je     101b54 <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
  101b3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b3d:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101b44:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b48:	c7 04 24 62 3a 10 00 	movl   $0x103a62,(%esp)
  101b4f:	e8 18 e7 ff ff       	call   10026c <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b54:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101b58:	d1 65 f0             	shll   -0x10(%ebp)
  101b5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b5e:	83 f8 17             	cmp    $0x17,%eax
  101b61:	76 ba                	jbe    101b1d <print_trapframe+0x120>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101b63:	8b 45 08             	mov    0x8(%ebp),%eax
  101b66:	8b 40 40             	mov    0x40(%eax),%eax
  101b69:	25 00 30 00 00       	and    $0x3000,%eax
  101b6e:	c1 e8 0c             	shr    $0xc,%eax
  101b71:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b75:	c7 04 24 66 3a 10 00 	movl   $0x103a66,(%esp)
  101b7c:	e8 eb e6 ff ff       	call   10026c <cprintf>

    if (!trap_in_kernel(tf)) {
  101b81:	8b 45 08             	mov    0x8(%ebp),%eax
  101b84:	89 04 24             	mov    %eax,(%esp)
  101b87:	e8 5b fe ff ff       	call   1019e7 <trap_in_kernel>
  101b8c:	85 c0                	test   %eax,%eax
  101b8e:	75 30                	jne    101bc0 <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101b90:	8b 45 08             	mov    0x8(%ebp),%eax
  101b93:	8b 40 44             	mov    0x44(%eax),%eax
  101b96:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b9a:	c7 04 24 6f 3a 10 00 	movl   $0x103a6f,(%esp)
  101ba1:	e8 c6 e6 ff ff       	call   10026c <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101ba6:	8b 45 08             	mov    0x8(%ebp),%eax
  101ba9:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101bad:	0f b7 c0             	movzwl %ax,%eax
  101bb0:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bb4:	c7 04 24 7e 3a 10 00 	movl   $0x103a7e,(%esp)
  101bbb:	e8 ac e6 ff ff       	call   10026c <cprintf>
    }
}
  101bc0:	c9                   	leave  
  101bc1:	c3                   	ret    

00101bc2 <print_regs>:

void
print_regs(struct pushregs *regs) {
  101bc2:	55                   	push   %ebp
  101bc3:	89 e5                	mov    %esp,%ebp
  101bc5:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101bc8:	8b 45 08             	mov    0x8(%ebp),%eax
  101bcb:	8b 00                	mov    (%eax),%eax
  101bcd:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bd1:	c7 04 24 91 3a 10 00 	movl   $0x103a91,(%esp)
  101bd8:	e8 8f e6 ff ff       	call   10026c <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101bdd:	8b 45 08             	mov    0x8(%ebp),%eax
  101be0:	8b 40 04             	mov    0x4(%eax),%eax
  101be3:	89 44 24 04          	mov    %eax,0x4(%esp)
  101be7:	c7 04 24 a0 3a 10 00 	movl   $0x103aa0,(%esp)
  101bee:	e8 79 e6 ff ff       	call   10026c <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101bf3:	8b 45 08             	mov    0x8(%ebp),%eax
  101bf6:	8b 40 08             	mov    0x8(%eax),%eax
  101bf9:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bfd:	c7 04 24 af 3a 10 00 	movl   $0x103aaf,(%esp)
  101c04:	e8 63 e6 ff ff       	call   10026c <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101c09:	8b 45 08             	mov    0x8(%ebp),%eax
  101c0c:	8b 40 0c             	mov    0xc(%eax),%eax
  101c0f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c13:	c7 04 24 be 3a 10 00 	movl   $0x103abe,(%esp)
  101c1a:	e8 4d e6 ff ff       	call   10026c <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101c1f:	8b 45 08             	mov    0x8(%ebp),%eax
  101c22:	8b 40 10             	mov    0x10(%eax),%eax
  101c25:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c29:	c7 04 24 cd 3a 10 00 	movl   $0x103acd,(%esp)
  101c30:	e8 37 e6 ff ff       	call   10026c <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101c35:	8b 45 08             	mov    0x8(%ebp),%eax
  101c38:	8b 40 14             	mov    0x14(%eax),%eax
  101c3b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c3f:	c7 04 24 dc 3a 10 00 	movl   $0x103adc,(%esp)
  101c46:	e8 21 e6 ff ff       	call   10026c <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  101c4e:	8b 40 18             	mov    0x18(%eax),%eax
  101c51:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c55:	c7 04 24 eb 3a 10 00 	movl   $0x103aeb,(%esp)
  101c5c:	e8 0b e6 ff ff       	call   10026c <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101c61:	8b 45 08             	mov    0x8(%ebp),%eax
  101c64:	8b 40 1c             	mov    0x1c(%eax),%eax
  101c67:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c6b:	c7 04 24 fa 3a 10 00 	movl   $0x103afa,(%esp)
  101c72:	e8 f5 e5 ff ff       	call   10026c <cprintf>
}
  101c77:	c9                   	leave  
  101c78:	c3                   	ret    

00101c79 <trap_dispatch>:
/* temporary trapframe or pointer to trapframe */
struct trapframe switchk2u, *switchu2k;

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101c79:	55                   	push   %ebp
  101c7a:	89 e5                	mov    %esp,%ebp
  101c7c:	57                   	push   %edi
  101c7d:	56                   	push   %esi
  101c7e:	53                   	push   %ebx
  101c7f:	83 ec 2c             	sub    $0x2c,%esp
    char c;

    switch (tf->tf_trapno) {
  101c82:	8b 45 08             	mov    0x8(%ebp),%eax
  101c85:	8b 40 30             	mov    0x30(%eax),%eax
  101c88:	83 f8 2f             	cmp    $0x2f,%eax
  101c8b:	77 21                	ja     101cae <trap_dispatch+0x35>
  101c8d:	83 f8 2e             	cmp    $0x2e,%eax
  101c90:	0f 83 ec 01 00 00    	jae    101e82 <trap_dispatch+0x209>
  101c96:	83 f8 21             	cmp    $0x21,%eax
  101c99:	0f 84 8a 00 00 00    	je     101d29 <trap_dispatch+0xb0>
  101c9f:	83 f8 24             	cmp    $0x24,%eax
  101ca2:	74 5c                	je     101d00 <trap_dispatch+0x87>
  101ca4:	83 f8 20             	cmp    $0x20,%eax
  101ca7:	74 1c                	je     101cc5 <trap_dispatch+0x4c>
  101ca9:	e9 9c 01 00 00       	jmp    101e4a <trap_dispatch+0x1d1>
  101cae:	83 f8 78             	cmp    $0x78,%eax
  101cb1:	0f 84 9b 00 00 00    	je     101d52 <trap_dispatch+0xd9>
  101cb7:	83 f8 79             	cmp    $0x79,%eax
  101cba:	0f 84 11 01 00 00    	je     101dd1 <trap_dispatch+0x158>
  101cc0:	e9 85 01 00 00       	jmp    101e4a <trap_dispatch+0x1d1>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
    	ticks ++;
  101cc5:	a1 08 f9 10 00       	mov    0x10f908,%eax
  101cca:	83 c0 01             	add    $0x1,%eax
  101ccd:	a3 08 f9 10 00       	mov    %eax,0x10f908
    	if (ticks % TICK_NUM == 0)
  101cd2:	8b 0d 08 f9 10 00    	mov    0x10f908,%ecx
  101cd8:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101cdd:	89 c8                	mov    %ecx,%eax
  101cdf:	f7 e2                	mul    %edx
  101ce1:	89 d0                	mov    %edx,%eax
  101ce3:	c1 e8 05             	shr    $0x5,%eax
  101ce6:	6b c0 64             	imul   $0x64,%eax,%eax
  101ce9:	29 c1                	sub    %eax,%ecx
  101ceb:	89 c8                	mov    %ecx,%eax
  101ced:	85 c0                	test   %eax,%eax
  101cef:	75 0a                	jne    101cfb <trap_dispatch+0x82>
    	{
    		print_ticks();
  101cf1:	e8 0e fb ff ff       	call   101804 <print_ticks>
    	}
        break;
  101cf6:	e9 88 01 00 00       	jmp    101e83 <trap_dispatch+0x20a>
  101cfb:	e9 83 01 00 00       	jmp    101e83 <trap_dispatch+0x20a>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101d00:	e8 d6 f8 ff ff       	call   1015db <cons_getc>
  101d05:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101d08:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101d0c:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101d10:	89 54 24 08          	mov    %edx,0x8(%esp)
  101d14:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d18:	c7 04 24 09 3b 10 00 	movl   $0x103b09,(%esp)
  101d1f:	e8 48 e5 ff ff       	call   10026c <cprintf>
        break;
  101d24:	e9 5a 01 00 00       	jmp    101e83 <trap_dispatch+0x20a>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101d29:	e8 ad f8 ff ff       	call   1015db <cons_getc>
  101d2e:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101d31:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101d35:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101d39:	89 54 24 08          	mov    %edx,0x8(%esp)
  101d3d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d41:	c7 04 24 1b 3b 10 00 	movl   $0x103b1b,(%esp)
  101d48:	e8 1f e5 ff ff       	call   10026c <cprintf>
        break;
  101d4d:	e9 31 01 00 00       	jmp    101e83 <trap_dispatch+0x20a>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    	if(tf->tf_cs !=  USER_CS)
  101d52:	8b 45 08             	mov    0x8(%ebp),%eax
  101d55:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101d59:	66 83 f8 1b          	cmp    $0x1b,%ax
  101d5d:	74 6d                	je     101dcc <trap_dispatch+0x153>
    	{
    		switchk2u = *tf;
  101d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  101d62:	ba 20 f9 10 00       	mov    $0x10f920,%edx
  101d67:	89 c3                	mov    %eax,%ebx
  101d69:	b8 13 00 00 00       	mov    $0x13,%eax
  101d6e:	89 d7                	mov    %edx,%edi
  101d70:	89 de                	mov    %ebx,%esi
  101d72:	89 c1                	mov    %eax,%ecx
  101d74:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    		switchk2u.tf_cs =  USER_CS;
  101d76:	66 c7 05 5c f9 10 00 	movw   $0x1b,0x10f95c
  101d7d:	1b 00 
    		switchk2u.tf_ds = switchk2u.tf_es = switchk2u.tf_ss = USER_DS;
  101d7f:	66 c7 05 68 f9 10 00 	movw   $0x23,0x10f968
  101d86:	23 00 
  101d88:	0f b7 05 68 f9 10 00 	movzwl 0x10f968,%eax
  101d8f:	66 a3 48 f9 10 00    	mov    %ax,0x10f948
  101d95:	0f b7 05 48 f9 10 00 	movzwl 0x10f948,%eax
  101d9c:	66 a3 4c f9 10 00    	mov    %ax,0x10f94c
    		switchk2u.tf_eflags |= FL_IOPL_MASK;
  101da2:	a1 60 f9 10 00       	mov    0x10f960,%eax
  101da7:	80 cc 30             	or     $0x30,%ah
  101daa:	a3 60 f9 10 00       	mov    %eax,0x10f960
    	    switchk2u.tf_esp = (uint32_t)tf + sizeof(struct trapframe) - 8;
  101daf:	8b 45 08             	mov    0x8(%ebp),%eax
  101db2:	83 c0 44             	add    $0x44,%eax
  101db5:	a3 64 f9 10 00       	mov    %eax,0x10f964

    	    *((uint32_t *) tf - 1) = (uint32_t) &switchk2u;
  101dba:	8b 45 08             	mov    0x8(%ebp),%eax
  101dbd:	8d 50 fc             	lea    -0x4(%eax),%edx
  101dc0:	b8 20 f9 10 00       	mov    $0x10f920,%eax
  101dc5:	89 02                	mov    %eax,(%edx)
    	}
    	break;
  101dc7:	e9 b7 00 00 00       	jmp    101e83 <trap_dispatch+0x20a>
  101dcc:	e9 b2 00 00 00       	jmp    101e83 <trap_dispatch+0x20a>
    case T_SWITCH_TOK:
    	if(tf->tf_cs != KERNEL_CS)
  101dd1:	8b 45 08             	mov    0x8(%ebp),%eax
  101dd4:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101dd8:	66 83 f8 08          	cmp    $0x8,%ax
  101ddc:	74 6a                	je     101e48 <trap_dispatch+0x1cf>
    	{
    		tf->tf_cs = KERNEL_CS;
  101dde:	8b 45 08             	mov    0x8(%ebp),%eax
  101de1:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
    		tf->tf_ds = tf->tf_es = KERNEL_DS;
  101de7:	8b 45 08             	mov    0x8(%ebp),%eax
  101dea:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
  101df0:	8b 45 08             	mov    0x8(%ebp),%eax
  101df3:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101df7:	8b 45 08             	mov    0x8(%ebp),%eax
  101dfa:	66 89 50 2c          	mov    %dx,0x2c(%eax)
    		tf->tf_eflags &= ~FL_IOPL_MASK;
  101dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  101e01:	8b 40 40             	mov    0x40(%eax),%eax
  101e04:	80 e4 cf             	and    $0xcf,%ah
  101e07:	89 c2                	mov    %eax,%edx
  101e09:	8b 45 08             	mov    0x8(%ebp),%eax
  101e0c:	89 50 40             	mov    %edx,0x40(%eax)
    		switchu2k = (struct trapframe *)(tf->tf_esp - (sizeof(struct trapframe) - 8));
  101e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  101e12:	8b 40 44             	mov    0x44(%eax),%eax
  101e15:	83 e8 44             	sub    $0x44,%eax
  101e18:	a3 6c f9 10 00       	mov    %eax,0x10f96c
    		memmove(switchu2k, tf, sizeof(struct trapframe) - 8);
  101e1d:	a1 6c f9 10 00       	mov    0x10f96c,%eax
  101e22:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  101e29:	00 
  101e2a:	8b 55 08             	mov    0x8(%ebp),%edx
  101e2d:	89 54 24 04          	mov    %edx,0x4(%esp)
  101e31:	89 04 24             	mov    %eax,(%esp)
  101e34:	e8 a6 0f 00 00       	call   102ddf <memmove>
    		*((uint32_t *) tf - 1) = (uint32_t) switchu2k;
  101e39:	8b 45 08             	mov    0x8(%ebp),%eax
  101e3c:	8d 50 fc             	lea    -0x4(%eax),%edx
  101e3f:	a1 6c f9 10 00       	mov    0x10f96c,%eax
  101e44:	89 02                	mov    %eax,(%edx)
    	}
        break;
  101e46:	eb 3b                	jmp    101e83 <trap_dispatch+0x20a>
  101e48:	eb 39                	jmp    101e83 <trap_dispatch+0x20a>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101e4a:	8b 45 08             	mov    0x8(%ebp),%eax
  101e4d:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101e51:	0f b7 c0             	movzwl %ax,%eax
  101e54:	83 e0 03             	and    $0x3,%eax
  101e57:	85 c0                	test   %eax,%eax
  101e59:	75 28                	jne    101e83 <trap_dispatch+0x20a>
            print_trapframe(tf);
  101e5b:	8b 45 08             	mov    0x8(%ebp),%eax
  101e5e:	89 04 24             	mov    %eax,(%esp)
  101e61:	e8 97 fb ff ff       	call   1019fd <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101e66:	c7 44 24 08 2a 3b 10 	movl   $0x103b2a,0x8(%esp)
  101e6d:	00 
  101e6e:	c7 44 24 04 d7 00 00 	movl   $0xd7,0x4(%esp)
  101e75:	00 
  101e76:	c7 04 24 4e 39 10 00 	movl   $0x10394e,(%esp)
  101e7d:	e8 41 e5 ff ff       	call   1003c3 <__panic>
        break;
  101e82:	90                   	nop
        }
    }
}
  101e83:	83 c4 2c             	add    $0x2c,%esp
  101e86:	5b                   	pop    %ebx
  101e87:	5e                   	pop    %esi
  101e88:	5f                   	pop    %edi
  101e89:	5d                   	pop    %ebp
  101e8a:	c3                   	ret    

00101e8b <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101e8b:	55                   	push   %ebp
  101e8c:	89 e5                	mov    %esp,%ebp
  101e8e:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101e91:	8b 45 08             	mov    0x8(%ebp),%eax
  101e94:	89 04 24             	mov    %eax,(%esp)
  101e97:	e8 dd fd ff ff       	call   101c79 <trap_dispatch>
}
  101e9c:	c9                   	leave  
  101e9d:	c3                   	ret    

00101e9e <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101e9e:	6a 00                	push   $0x0
  pushl $0
  101ea0:	6a 00                	push   $0x0
  jmp __alltraps
  101ea2:	e9 69 0a 00 00       	jmp    102910 <__alltraps>

00101ea7 <vector1>:
.globl vector1
vector1:
  pushl $0
  101ea7:	6a 00                	push   $0x0
  pushl $1
  101ea9:	6a 01                	push   $0x1
  jmp __alltraps
  101eab:	e9 60 0a 00 00       	jmp    102910 <__alltraps>

00101eb0 <vector2>:
.globl vector2
vector2:
  pushl $0
  101eb0:	6a 00                	push   $0x0
  pushl $2
  101eb2:	6a 02                	push   $0x2
  jmp __alltraps
  101eb4:	e9 57 0a 00 00       	jmp    102910 <__alltraps>

00101eb9 <vector3>:
.globl vector3
vector3:
  pushl $0
  101eb9:	6a 00                	push   $0x0
  pushl $3
  101ebb:	6a 03                	push   $0x3
  jmp __alltraps
  101ebd:	e9 4e 0a 00 00       	jmp    102910 <__alltraps>

00101ec2 <vector4>:
.globl vector4
vector4:
  pushl $0
  101ec2:	6a 00                	push   $0x0
  pushl $4
  101ec4:	6a 04                	push   $0x4
  jmp __alltraps
  101ec6:	e9 45 0a 00 00       	jmp    102910 <__alltraps>

00101ecb <vector5>:
.globl vector5
vector5:
  pushl $0
  101ecb:	6a 00                	push   $0x0
  pushl $5
  101ecd:	6a 05                	push   $0x5
  jmp __alltraps
  101ecf:	e9 3c 0a 00 00       	jmp    102910 <__alltraps>

00101ed4 <vector6>:
.globl vector6
vector6:
  pushl $0
  101ed4:	6a 00                	push   $0x0
  pushl $6
  101ed6:	6a 06                	push   $0x6
  jmp __alltraps
  101ed8:	e9 33 0a 00 00       	jmp    102910 <__alltraps>

00101edd <vector7>:
.globl vector7
vector7:
  pushl $0
  101edd:	6a 00                	push   $0x0
  pushl $7
  101edf:	6a 07                	push   $0x7
  jmp __alltraps
  101ee1:	e9 2a 0a 00 00       	jmp    102910 <__alltraps>

00101ee6 <vector8>:
.globl vector8
vector8:
  pushl $8
  101ee6:	6a 08                	push   $0x8
  jmp __alltraps
  101ee8:	e9 23 0a 00 00       	jmp    102910 <__alltraps>

00101eed <vector9>:
.globl vector9
vector9:
  pushl $0
  101eed:	6a 00                	push   $0x0
  pushl $9
  101eef:	6a 09                	push   $0x9
  jmp __alltraps
  101ef1:	e9 1a 0a 00 00       	jmp    102910 <__alltraps>

00101ef6 <vector10>:
.globl vector10
vector10:
  pushl $10
  101ef6:	6a 0a                	push   $0xa
  jmp __alltraps
  101ef8:	e9 13 0a 00 00       	jmp    102910 <__alltraps>

00101efd <vector11>:
.globl vector11
vector11:
  pushl $11
  101efd:	6a 0b                	push   $0xb
  jmp __alltraps
  101eff:	e9 0c 0a 00 00       	jmp    102910 <__alltraps>

00101f04 <vector12>:
.globl vector12
vector12:
  pushl $12
  101f04:	6a 0c                	push   $0xc
  jmp __alltraps
  101f06:	e9 05 0a 00 00       	jmp    102910 <__alltraps>

00101f0b <vector13>:
.globl vector13
vector13:
  pushl $13
  101f0b:	6a 0d                	push   $0xd
  jmp __alltraps
  101f0d:	e9 fe 09 00 00       	jmp    102910 <__alltraps>

00101f12 <vector14>:
.globl vector14
vector14:
  pushl $14
  101f12:	6a 0e                	push   $0xe
  jmp __alltraps
  101f14:	e9 f7 09 00 00       	jmp    102910 <__alltraps>

00101f19 <vector15>:
.globl vector15
vector15:
  pushl $0
  101f19:	6a 00                	push   $0x0
  pushl $15
  101f1b:	6a 0f                	push   $0xf
  jmp __alltraps
  101f1d:	e9 ee 09 00 00       	jmp    102910 <__alltraps>

00101f22 <vector16>:
.globl vector16
vector16:
  pushl $0
  101f22:	6a 00                	push   $0x0
  pushl $16
  101f24:	6a 10                	push   $0x10
  jmp __alltraps
  101f26:	e9 e5 09 00 00       	jmp    102910 <__alltraps>

00101f2b <vector17>:
.globl vector17
vector17:
  pushl $17
  101f2b:	6a 11                	push   $0x11
  jmp __alltraps
  101f2d:	e9 de 09 00 00       	jmp    102910 <__alltraps>

00101f32 <vector18>:
.globl vector18
vector18:
  pushl $0
  101f32:	6a 00                	push   $0x0
  pushl $18
  101f34:	6a 12                	push   $0x12
  jmp __alltraps
  101f36:	e9 d5 09 00 00       	jmp    102910 <__alltraps>

00101f3b <vector19>:
.globl vector19
vector19:
  pushl $0
  101f3b:	6a 00                	push   $0x0
  pushl $19
  101f3d:	6a 13                	push   $0x13
  jmp __alltraps
  101f3f:	e9 cc 09 00 00       	jmp    102910 <__alltraps>

00101f44 <vector20>:
.globl vector20
vector20:
  pushl $0
  101f44:	6a 00                	push   $0x0
  pushl $20
  101f46:	6a 14                	push   $0x14
  jmp __alltraps
  101f48:	e9 c3 09 00 00       	jmp    102910 <__alltraps>

00101f4d <vector21>:
.globl vector21
vector21:
  pushl $0
  101f4d:	6a 00                	push   $0x0
  pushl $21
  101f4f:	6a 15                	push   $0x15
  jmp __alltraps
  101f51:	e9 ba 09 00 00       	jmp    102910 <__alltraps>

00101f56 <vector22>:
.globl vector22
vector22:
  pushl $0
  101f56:	6a 00                	push   $0x0
  pushl $22
  101f58:	6a 16                	push   $0x16
  jmp __alltraps
  101f5a:	e9 b1 09 00 00       	jmp    102910 <__alltraps>

00101f5f <vector23>:
.globl vector23
vector23:
  pushl $0
  101f5f:	6a 00                	push   $0x0
  pushl $23
  101f61:	6a 17                	push   $0x17
  jmp __alltraps
  101f63:	e9 a8 09 00 00       	jmp    102910 <__alltraps>

00101f68 <vector24>:
.globl vector24
vector24:
  pushl $0
  101f68:	6a 00                	push   $0x0
  pushl $24
  101f6a:	6a 18                	push   $0x18
  jmp __alltraps
  101f6c:	e9 9f 09 00 00       	jmp    102910 <__alltraps>

00101f71 <vector25>:
.globl vector25
vector25:
  pushl $0
  101f71:	6a 00                	push   $0x0
  pushl $25
  101f73:	6a 19                	push   $0x19
  jmp __alltraps
  101f75:	e9 96 09 00 00       	jmp    102910 <__alltraps>

00101f7a <vector26>:
.globl vector26
vector26:
  pushl $0
  101f7a:	6a 00                	push   $0x0
  pushl $26
  101f7c:	6a 1a                	push   $0x1a
  jmp __alltraps
  101f7e:	e9 8d 09 00 00       	jmp    102910 <__alltraps>

00101f83 <vector27>:
.globl vector27
vector27:
  pushl $0
  101f83:	6a 00                	push   $0x0
  pushl $27
  101f85:	6a 1b                	push   $0x1b
  jmp __alltraps
  101f87:	e9 84 09 00 00       	jmp    102910 <__alltraps>

00101f8c <vector28>:
.globl vector28
vector28:
  pushl $0
  101f8c:	6a 00                	push   $0x0
  pushl $28
  101f8e:	6a 1c                	push   $0x1c
  jmp __alltraps
  101f90:	e9 7b 09 00 00       	jmp    102910 <__alltraps>

00101f95 <vector29>:
.globl vector29
vector29:
  pushl $0
  101f95:	6a 00                	push   $0x0
  pushl $29
  101f97:	6a 1d                	push   $0x1d
  jmp __alltraps
  101f99:	e9 72 09 00 00       	jmp    102910 <__alltraps>

00101f9e <vector30>:
.globl vector30
vector30:
  pushl $0
  101f9e:	6a 00                	push   $0x0
  pushl $30
  101fa0:	6a 1e                	push   $0x1e
  jmp __alltraps
  101fa2:	e9 69 09 00 00       	jmp    102910 <__alltraps>

00101fa7 <vector31>:
.globl vector31
vector31:
  pushl $0
  101fa7:	6a 00                	push   $0x0
  pushl $31
  101fa9:	6a 1f                	push   $0x1f
  jmp __alltraps
  101fab:	e9 60 09 00 00       	jmp    102910 <__alltraps>

00101fb0 <vector32>:
.globl vector32
vector32:
  pushl $0
  101fb0:	6a 00                	push   $0x0
  pushl $32
  101fb2:	6a 20                	push   $0x20
  jmp __alltraps
  101fb4:	e9 57 09 00 00       	jmp    102910 <__alltraps>

00101fb9 <vector33>:
.globl vector33
vector33:
  pushl $0
  101fb9:	6a 00                	push   $0x0
  pushl $33
  101fbb:	6a 21                	push   $0x21
  jmp __alltraps
  101fbd:	e9 4e 09 00 00       	jmp    102910 <__alltraps>

00101fc2 <vector34>:
.globl vector34
vector34:
  pushl $0
  101fc2:	6a 00                	push   $0x0
  pushl $34
  101fc4:	6a 22                	push   $0x22
  jmp __alltraps
  101fc6:	e9 45 09 00 00       	jmp    102910 <__alltraps>

00101fcb <vector35>:
.globl vector35
vector35:
  pushl $0
  101fcb:	6a 00                	push   $0x0
  pushl $35
  101fcd:	6a 23                	push   $0x23
  jmp __alltraps
  101fcf:	e9 3c 09 00 00       	jmp    102910 <__alltraps>

00101fd4 <vector36>:
.globl vector36
vector36:
  pushl $0
  101fd4:	6a 00                	push   $0x0
  pushl $36
  101fd6:	6a 24                	push   $0x24
  jmp __alltraps
  101fd8:	e9 33 09 00 00       	jmp    102910 <__alltraps>

00101fdd <vector37>:
.globl vector37
vector37:
  pushl $0
  101fdd:	6a 00                	push   $0x0
  pushl $37
  101fdf:	6a 25                	push   $0x25
  jmp __alltraps
  101fe1:	e9 2a 09 00 00       	jmp    102910 <__alltraps>

00101fe6 <vector38>:
.globl vector38
vector38:
  pushl $0
  101fe6:	6a 00                	push   $0x0
  pushl $38
  101fe8:	6a 26                	push   $0x26
  jmp __alltraps
  101fea:	e9 21 09 00 00       	jmp    102910 <__alltraps>

00101fef <vector39>:
.globl vector39
vector39:
  pushl $0
  101fef:	6a 00                	push   $0x0
  pushl $39
  101ff1:	6a 27                	push   $0x27
  jmp __alltraps
  101ff3:	e9 18 09 00 00       	jmp    102910 <__alltraps>

00101ff8 <vector40>:
.globl vector40
vector40:
  pushl $0
  101ff8:	6a 00                	push   $0x0
  pushl $40
  101ffa:	6a 28                	push   $0x28
  jmp __alltraps
  101ffc:	e9 0f 09 00 00       	jmp    102910 <__alltraps>

00102001 <vector41>:
.globl vector41
vector41:
  pushl $0
  102001:	6a 00                	push   $0x0
  pushl $41
  102003:	6a 29                	push   $0x29
  jmp __alltraps
  102005:	e9 06 09 00 00       	jmp    102910 <__alltraps>

0010200a <vector42>:
.globl vector42
vector42:
  pushl $0
  10200a:	6a 00                	push   $0x0
  pushl $42
  10200c:	6a 2a                	push   $0x2a
  jmp __alltraps
  10200e:	e9 fd 08 00 00       	jmp    102910 <__alltraps>

00102013 <vector43>:
.globl vector43
vector43:
  pushl $0
  102013:	6a 00                	push   $0x0
  pushl $43
  102015:	6a 2b                	push   $0x2b
  jmp __alltraps
  102017:	e9 f4 08 00 00       	jmp    102910 <__alltraps>

0010201c <vector44>:
.globl vector44
vector44:
  pushl $0
  10201c:	6a 00                	push   $0x0
  pushl $44
  10201e:	6a 2c                	push   $0x2c
  jmp __alltraps
  102020:	e9 eb 08 00 00       	jmp    102910 <__alltraps>

00102025 <vector45>:
.globl vector45
vector45:
  pushl $0
  102025:	6a 00                	push   $0x0
  pushl $45
  102027:	6a 2d                	push   $0x2d
  jmp __alltraps
  102029:	e9 e2 08 00 00       	jmp    102910 <__alltraps>

0010202e <vector46>:
.globl vector46
vector46:
  pushl $0
  10202e:	6a 00                	push   $0x0
  pushl $46
  102030:	6a 2e                	push   $0x2e
  jmp __alltraps
  102032:	e9 d9 08 00 00       	jmp    102910 <__alltraps>

00102037 <vector47>:
.globl vector47
vector47:
  pushl $0
  102037:	6a 00                	push   $0x0
  pushl $47
  102039:	6a 2f                	push   $0x2f
  jmp __alltraps
  10203b:	e9 d0 08 00 00       	jmp    102910 <__alltraps>

00102040 <vector48>:
.globl vector48
vector48:
  pushl $0
  102040:	6a 00                	push   $0x0
  pushl $48
  102042:	6a 30                	push   $0x30
  jmp __alltraps
  102044:	e9 c7 08 00 00       	jmp    102910 <__alltraps>

00102049 <vector49>:
.globl vector49
vector49:
  pushl $0
  102049:	6a 00                	push   $0x0
  pushl $49
  10204b:	6a 31                	push   $0x31
  jmp __alltraps
  10204d:	e9 be 08 00 00       	jmp    102910 <__alltraps>

00102052 <vector50>:
.globl vector50
vector50:
  pushl $0
  102052:	6a 00                	push   $0x0
  pushl $50
  102054:	6a 32                	push   $0x32
  jmp __alltraps
  102056:	e9 b5 08 00 00       	jmp    102910 <__alltraps>

0010205b <vector51>:
.globl vector51
vector51:
  pushl $0
  10205b:	6a 00                	push   $0x0
  pushl $51
  10205d:	6a 33                	push   $0x33
  jmp __alltraps
  10205f:	e9 ac 08 00 00       	jmp    102910 <__alltraps>

00102064 <vector52>:
.globl vector52
vector52:
  pushl $0
  102064:	6a 00                	push   $0x0
  pushl $52
  102066:	6a 34                	push   $0x34
  jmp __alltraps
  102068:	e9 a3 08 00 00       	jmp    102910 <__alltraps>

0010206d <vector53>:
.globl vector53
vector53:
  pushl $0
  10206d:	6a 00                	push   $0x0
  pushl $53
  10206f:	6a 35                	push   $0x35
  jmp __alltraps
  102071:	e9 9a 08 00 00       	jmp    102910 <__alltraps>

00102076 <vector54>:
.globl vector54
vector54:
  pushl $0
  102076:	6a 00                	push   $0x0
  pushl $54
  102078:	6a 36                	push   $0x36
  jmp __alltraps
  10207a:	e9 91 08 00 00       	jmp    102910 <__alltraps>

0010207f <vector55>:
.globl vector55
vector55:
  pushl $0
  10207f:	6a 00                	push   $0x0
  pushl $55
  102081:	6a 37                	push   $0x37
  jmp __alltraps
  102083:	e9 88 08 00 00       	jmp    102910 <__alltraps>

00102088 <vector56>:
.globl vector56
vector56:
  pushl $0
  102088:	6a 00                	push   $0x0
  pushl $56
  10208a:	6a 38                	push   $0x38
  jmp __alltraps
  10208c:	e9 7f 08 00 00       	jmp    102910 <__alltraps>

00102091 <vector57>:
.globl vector57
vector57:
  pushl $0
  102091:	6a 00                	push   $0x0
  pushl $57
  102093:	6a 39                	push   $0x39
  jmp __alltraps
  102095:	e9 76 08 00 00       	jmp    102910 <__alltraps>

0010209a <vector58>:
.globl vector58
vector58:
  pushl $0
  10209a:	6a 00                	push   $0x0
  pushl $58
  10209c:	6a 3a                	push   $0x3a
  jmp __alltraps
  10209e:	e9 6d 08 00 00       	jmp    102910 <__alltraps>

001020a3 <vector59>:
.globl vector59
vector59:
  pushl $0
  1020a3:	6a 00                	push   $0x0
  pushl $59
  1020a5:	6a 3b                	push   $0x3b
  jmp __alltraps
  1020a7:	e9 64 08 00 00       	jmp    102910 <__alltraps>

001020ac <vector60>:
.globl vector60
vector60:
  pushl $0
  1020ac:	6a 00                	push   $0x0
  pushl $60
  1020ae:	6a 3c                	push   $0x3c
  jmp __alltraps
  1020b0:	e9 5b 08 00 00       	jmp    102910 <__alltraps>

001020b5 <vector61>:
.globl vector61
vector61:
  pushl $0
  1020b5:	6a 00                	push   $0x0
  pushl $61
  1020b7:	6a 3d                	push   $0x3d
  jmp __alltraps
  1020b9:	e9 52 08 00 00       	jmp    102910 <__alltraps>

001020be <vector62>:
.globl vector62
vector62:
  pushl $0
  1020be:	6a 00                	push   $0x0
  pushl $62
  1020c0:	6a 3e                	push   $0x3e
  jmp __alltraps
  1020c2:	e9 49 08 00 00       	jmp    102910 <__alltraps>

001020c7 <vector63>:
.globl vector63
vector63:
  pushl $0
  1020c7:	6a 00                	push   $0x0
  pushl $63
  1020c9:	6a 3f                	push   $0x3f
  jmp __alltraps
  1020cb:	e9 40 08 00 00       	jmp    102910 <__alltraps>

001020d0 <vector64>:
.globl vector64
vector64:
  pushl $0
  1020d0:	6a 00                	push   $0x0
  pushl $64
  1020d2:	6a 40                	push   $0x40
  jmp __alltraps
  1020d4:	e9 37 08 00 00       	jmp    102910 <__alltraps>

001020d9 <vector65>:
.globl vector65
vector65:
  pushl $0
  1020d9:	6a 00                	push   $0x0
  pushl $65
  1020db:	6a 41                	push   $0x41
  jmp __alltraps
  1020dd:	e9 2e 08 00 00       	jmp    102910 <__alltraps>

001020e2 <vector66>:
.globl vector66
vector66:
  pushl $0
  1020e2:	6a 00                	push   $0x0
  pushl $66
  1020e4:	6a 42                	push   $0x42
  jmp __alltraps
  1020e6:	e9 25 08 00 00       	jmp    102910 <__alltraps>

001020eb <vector67>:
.globl vector67
vector67:
  pushl $0
  1020eb:	6a 00                	push   $0x0
  pushl $67
  1020ed:	6a 43                	push   $0x43
  jmp __alltraps
  1020ef:	e9 1c 08 00 00       	jmp    102910 <__alltraps>

001020f4 <vector68>:
.globl vector68
vector68:
  pushl $0
  1020f4:	6a 00                	push   $0x0
  pushl $68
  1020f6:	6a 44                	push   $0x44
  jmp __alltraps
  1020f8:	e9 13 08 00 00       	jmp    102910 <__alltraps>

001020fd <vector69>:
.globl vector69
vector69:
  pushl $0
  1020fd:	6a 00                	push   $0x0
  pushl $69
  1020ff:	6a 45                	push   $0x45
  jmp __alltraps
  102101:	e9 0a 08 00 00       	jmp    102910 <__alltraps>

00102106 <vector70>:
.globl vector70
vector70:
  pushl $0
  102106:	6a 00                	push   $0x0
  pushl $70
  102108:	6a 46                	push   $0x46
  jmp __alltraps
  10210a:	e9 01 08 00 00       	jmp    102910 <__alltraps>

0010210f <vector71>:
.globl vector71
vector71:
  pushl $0
  10210f:	6a 00                	push   $0x0
  pushl $71
  102111:	6a 47                	push   $0x47
  jmp __alltraps
  102113:	e9 f8 07 00 00       	jmp    102910 <__alltraps>

00102118 <vector72>:
.globl vector72
vector72:
  pushl $0
  102118:	6a 00                	push   $0x0
  pushl $72
  10211a:	6a 48                	push   $0x48
  jmp __alltraps
  10211c:	e9 ef 07 00 00       	jmp    102910 <__alltraps>

00102121 <vector73>:
.globl vector73
vector73:
  pushl $0
  102121:	6a 00                	push   $0x0
  pushl $73
  102123:	6a 49                	push   $0x49
  jmp __alltraps
  102125:	e9 e6 07 00 00       	jmp    102910 <__alltraps>

0010212a <vector74>:
.globl vector74
vector74:
  pushl $0
  10212a:	6a 00                	push   $0x0
  pushl $74
  10212c:	6a 4a                	push   $0x4a
  jmp __alltraps
  10212e:	e9 dd 07 00 00       	jmp    102910 <__alltraps>

00102133 <vector75>:
.globl vector75
vector75:
  pushl $0
  102133:	6a 00                	push   $0x0
  pushl $75
  102135:	6a 4b                	push   $0x4b
  jmp __alltraps
  102137:	e9 d4 07 00 00       	jmp    102910 <__alltraps>

0010213c <vector76>:
.globl vector76
vector76:
  pushl $0
  10213c:	6a 00                	push   $0x0
  pushl $76
  10213e:	6a 4c                	push   $0x4c
  jmp __alltraps
  102140:	e9 cb 07 00 00       	jmp    102910 <__alltraps>

00102145 <vector77>:
.globl vector77
vector77:
  pushl $0
  102145:	6a 00                	push   $0x0
  pushl $77
  102147:	6a 4d                	push   $0x4d
  jmp __alltraps
  102149:	e9 c2 07 00 00       	jmp    102910 <__alltraps>

0010214e <vector78>:
.globl vector78
vector78:
  pushl $0
  10214e:	6a 00                	push   $0x0
  pushl $78
  102150:	6a 4e                	push   $0x4e
  jmp __alltraps
  102152:	e9 b9 07 00 00       	jmp    102910 <__alltraps>

00102157 <vector79>:
.globl vector79
vector79:
  pushl $0
  102157:	6a 00                	push   $0x0
  pushl $79
  102159:	6a 4f                	push   $0x4f
  jmp __alltraps
  10215b:	e9 b0 07 00 00       	jmp    102910 <__alltraps>

00102160 <vector80>:
.globl vector80
vector80:
  pushl $0
  102160:	6a 00                	push   $0x0
  pushl $80
  102162:	6a 50                	push   $0x50
  jmp __alltraps
  102164:	e9 a7 07 00 00       	jmp    102910 <__alltraps>

00102169 <vector81>:
.globl vector81
vector81:
  pushl $0
  102169:	6a 00                	push   $0x0
  pushl $81
  10216b:	6a 51                	push   $0x51
  jmp __alltraps
  10216d:	e9 9e 07 00 00       	jmp    102910 <__alltraps>

00102172 <vector82>:
.globl vector82
vector82:
  pushl $0
  102172:	6a 00                	push   $0x0
  pushl $82
  102174:	6a 52                	push   $0x52
  jmp __alltraps
  102176:	e9 95 07 00 00       	jmp    102910 <__alltraps>

0010217b <vector83>:
.globl vector83
vector83:
  pushl $0
  10217b:	6a 00                	push   $0x0
  pushl $83
  10217d:	6a 53                	push   $0x53
  jmp __alltraps
  10217f:	e9 8c 07 00 00       	jmp    102910 <__alltraps>

00102184 <vector84>:
.globl vector84
vector84:
  pushl $0
  102184:	6a 00                	push   $0x0
  pushl $84
  102186:	6a 54                	push   $0x54
  jmp __alltraps
  102188:	e9 83 07 00 00       	jmp    102910 <__alltraps>

0010218d <vector85>:
.globl vector85
vector85:
  pushl $0
  10218d:	6a 00                	push   $0x0
  pushl $85
  10218f:	6a 55                	push   $0x55
  jmp __alltraps
  102191:	e9 7a 07 00 00       	jmp    102910 <__alltraps>

00102196 <vector86>:
.globl vector86
vector86:
  pushl $0
  102196:	6a 00                	push   $0x0
  pushl $86
  102198:	6a 56                	push   $0x56
  jmp __alltraps
  10219a:	e9 71 07 00 00       	jmp    102910 <__alltraps>

0010219f <vector87>:
.globl vector87
vector87:
  pushl $0
  10219f:	6a 00                	push   $0x0
  pushl $87
  1021a1:	6a 57                	push   $0x57
  jmp __alltraps
  1021a3:	e9 68 07 00 00       	jmp    102910 <__alltraps>

001021a8 <vector88>:
.globl vector88
vector88:
  pushl $0
  1021a8:	6a 00                	push   $0x0
  pushl $88
  1021aa:	6a 58                	push   $0x58
  jmp __alltraps
  1021ac:	e9 5f 07 00 00       	jmp    102910 <__alltraps>

001021b1 <vector89>:
.globl vector89
vector89:
  pushl $0
  1021b1:	6a 00                	push   $0x0
  pushl $89
  1021b3:	6a 59                	push   $0x59
  jmp __alltraps
  1021b5:	e9 56 07 00 00       	jmp    102910 <__alltraps>

001021ba <vector90>:
.globl vector90
vector90:
  pushl $0
  1021ba:	6a 00                	push   $0x0
  pushl $90
  1021bc:	6a 5a                	push   $0x5a
  jmp __alltraps
  1021be:	e9 4d 07 00 00       	jmp    102910 <__alltraps>

001021c3 <vector91>:
.globl vector91
vector91:
  pushl $0
  1021c3:	6a 00                	push   $0x0
  pushl $91
  1021c5:	6a 5b                	push   $0x5b
  jmp __alltraps
  1021c7:	e9 44 07 00 00       	jmp    102910 <__alltraps>

001021cc <vector92>:
.globl vector92
vector92:
  pushl $0
  1021cc:	6a 00                	push   $0x0
  pushl $92
  1021ce:	6a 5c                	push   $0x5c
  jmp __alltraps
  1021d0:	e9 3b 07 00 00       	jmp    102910 <__alltraps>

001021d5 <vector93>:
.globl vector93
vector93:
  pushl $0
  1021d5:	6a 00                	push   $0x0
  pushl $93
  1021d7:	6a 5d                	push   $0x5d
  jmp __alltraps
  1021d9:	e9 32 07 00 00       	jmp    102910 <__alltraps>

001021de <vector94>:
.globl vector94
vector94:
  pushl $0
  1021de:	6a 00                	push   $0x0
  pushl $94
  1021e0:	6a 5e                	push   $0x5e
  jmp __alltraps
  1021e2:	e9 29 07 00 00       	jmp    102910 <__alltraps>

001021e7 <vector95>:
.globl vector95
vector95:
  pushl $0
  1021e7:	6a 00                	push   $0x0
  pushl $95
  1021e9:	6a 5f                	push   $0x5f
  jmp __alltraps
  1021eb:	e9 20 07 00 00       	jmp    102910 <__alltraps>

001021f0 <vector96>:
.globl vector96
vector96:
  pushl $0
  1021f0:	6a 00                	push   $0x0
  pushl $96
  1021f2:	6a 60                	push   $0x60
  jmp __alltraps
  1021f4:	e9 17 07 00 00       	jmp    102910 <__alltraps>

001021f9 <vector97>:
.globl vector97
vector97:
  pushl $0
  1021f9:	6a 00                	push   $0x0
  pushl $97
  1021fb:	6a 61                	push   $0x61
  jmp __alltraps
  1021fd:	e9 0e 07 00 00       	jmp    102910 <__alltraps>

00102202 <vector98>:
.globl vector98
vector98:
  pushl $0
  102202:	6a 00                	push   $0x0
  pushl $98
  102204:	6a 62                	push   $0x62
  jmp __alltraps
  102206:	e9 05 07 00 00       	jmp    102910 <__alltraps>

0010220b <vector99>:
.globl vector99
vector99:
  pushl $0
  10220b:	6a 00                	push   $0x0
  pushl $99
  10220d:	6a 63                	push   $0x63
  jmp __alltraps
  10220f:	e9 fc 06 00 00       	jmp    102910 <__alltraps>

00102214 <vector100>:
.globl vector100
vector100:
  pushl $0
  102214:	6a 00                	push   $0x0
  pushl $100
  102216:	6a 64                	push   $0x64
  jmp __alltraps
  102218:	e9 f3 06 00 00       	jmp    102910 <__alltraps>

0010221d <vector101>:
.globl vector101
vector101:
  pushl $0
  10221d:	6a 00                	push   $0x0
  pushl $101
  10221f:	6a 65                	push   $0x65
  jmp __alltraps
  102221:	e9 ea 06 00 00       	jmp    102910 <__alltraps>

00102226 <vector102>:
.globl vector102
vector102:
  pushl $0
  102226:	6a 00                	push   $0x0
  pushl $102
  102228:	6a 66                	push   $0x66
  jmp __alltraps
  10222a:	e9 e1 06 00 00       	jmp    102910 <__alltraps>

0010222f <vector103>:
.globl vector103
vector103:
  pushl $0
  10222f:	6a 00                	push   $0x0
  pushl $103
  102231:	6a 67                	push   $0x67
  jmp __alltraps
  102233:	e9 d8 06 00 00       	jmp    102910 <__alltraps>

00102238 <vector104>:
.globl vector104
vector104:
  pushl $0
  102238:	6a 00                	push   $0x0
  pushl $104
  10223a:	6a 68                	push   $0x68
  jmp __alltraps
  10223c:	e9 cf 06 00 00       	jmp    102910 <__alltraps>

00102241 <vector105>:
.globl vector105
vector105:
  pushl $0
  102241:	6a 00                	push   $0x0
  pushl $105
  102243:	6a 69                	push   $0x69
  jmp __alltraps
  102245:	e9 c6 06 00 00       	jmp    102910 <__alltraps>

0010224a <vector106>:
.globl vector106
vector106:
  pushl $0
  10224a:	6a 00                	push   $0x0
  pushl $106
  10224c:	6a 6a                	push   $0x6a
  jmp __alltraps
  10224e:	e9 bd 06 00 00       	jmp    102910 <__alltraps>

00102253 <vector107>:
.globl vector107
vector107:
  pushl $0
  102253:	6a 00                	push   $0x0
  pushl $107
  102255:	6a 6b                	push   $0x6b
  jmp __alltraps
  102257:	e9 b4 06 00 00       	jmp    102910 <__alltraps>

0010225c <vector108>:
.globl vector108
vector108:
  pushl $0
  10225c:	6a 00                	push   $0x0
  pushl $108
  10225e:	6a 6c                	push   $0x6c
  jmp __alltraps
  102260:	e9 ab 06 00 00       	jmp    102910 <__alltraps>

00102265 <vector109>:
.globl vector109
vector109:
  pushl $0
  102265:	6a 00                	push   $0x0
  pushl $109
  102267:	6a 6d                	push   $0x6d
  jmp __alltraps
  102269:	e9 a2 06 00 00       	jmp    102910 <__alltraps>

0010226e <vector110>:
.globl vector110
vector110:
  pushl $0
  10226e:	6a 00                	push   $0x0
  pushl $110
  102270:	6a 6e                	push   $0x6e
  jmp __alltraps
  102272:	e9 99 06 00 00       	jmp    102910 <__alltraps>

00102277 <vector111>:
.globl vector111
vector111:
  pushl $0
  102277:	6a 00                	push   $0x0
  pushl $111
  102279:	6a 6f                	push   $0x6f
  jmp __alltraps
  10227b:	e9 90 06 00 00       	jmp    102910 <__alltraps>

00102280 <vector112>:
.globl vector112
vector112:
  pushl $0
  102280:	6a 00                	push   $0x0
  pushl $112
  102282:	6a 70                	push   $0x70
  jmp __alltraps
  102284:	e9 87 06 00 00       	jmp    102910 <__alltraps>

00102289 <vector113>:
.globl vector113
vector113:
  pushl $0
  102289:	6a 00                	push   $0x0
  pushl $113
  10228b:	6a 71                	push   $0x71
  jmp __alltraps
  10228d:	e9 7e 06 00 00       	jmp    102910 <__alltraps>

00102292 <vector114>:
.globl vector114
vector114:
  pushl $0
  102292:	6a 00                	push   $0x0
  pushl $114
  102294:	6a 72                	push   $0x72
  jmp __alltraps
  102296:	e9 75 06 00 00       	jmp    102910 <__alltraps>

0010229b <vector115>:
.globl vector115
vector115:
  pushl $0
  10229b:	6a 00                	push   $0x0
  pushl $115
  10229d:	6a 73                	push   $0x73
  jmp __alltraps
  10229f:	e9 6c 06 00 00       	jmp    102910 <__alltraps>

001022a4 <vector116>:
.globl vector116
vector116:
  pushl $0
  1022a4:	6a 00                	push   $0x0
  pushl $116
  1022a6:	6a 74                	push   $0x74
  jmp __alltraps
  1022a8:	e9 63 06 00 00       	jmp    102910 <__alltraps>

001022ad <vector117>:
.globl vector117
vector117:
  pushl $0
  1022ad:	6a 00                	push   $0x0
  pushl $117
  1022af:	6a 75                	push   $0x75
  jmp __alltraps
  1022b1:	e9 5a 06 00 00       	jmp    102910 <__alltraps>

001022b6 <vector118>:
.globl vector118
vector118:
  pushl $0
  1022b6:	6a 00                	push   $0x0
  pushl $118
  1022b8:	6a 76                	push   $0x76
  jmp __alltraps
  1022ba:	e9 51 06 00 00       	jmp    102910 <__alltraps>

001022bf <vector119>:
.globl vector119
vector119:
  pushl $0
  1022bf:	6a 00                	push   $0x0
  pushl $119
  1022c1:	6a 77                	push   $0x77
  jmp __alltraps
  1022c3:	e9 48 06 00 00       	jmp    102910 <__alltraps>

001022c8 <vector120>:
.globl vector120
vector120:
  pushl $0
  1022c8:	6a 00                	push   $0x0
  pushl $120
  1022ca:	6a 78                	push   $0x78
  jmp __alltraps
  1022cc:	e9 3f 06 00 00       	jmp    102910 <__alltraps>

001022d1 <vector121>:
.globl vector121
vector121:
  pushl $0
  1022d1:	6a 00                	push   $0x0
  pushl $121
  1022d3:	6a 79                	push   $0x79
  jmp __alltraps
  1022d5:	e9 36 06 00 00       	jmp    102910 <__alltraps>

001022da <vector122>:
.globl vector122
vector122:
  pushl $0
  1022da:	6a 00                	push   $0x0
  pushl $122
  1022dc:	6a 7a                	push   $0x7a
  jmp __alltraps
  1022de:	e9 2d 06 00 00       	jmp    102910 <__alltraps>

001022e3 <vector123>:
.globl vector123
vector123:
  pushl $0
  1022e3:	6a 00                	push   $0x0
  pushl $123
  1022e5:	6a 7b                	push   $0x7b
  jmp __alltraps
  1022e7:	e9 24 06 00 00       	jmp    102910 <__alltraps>

001022ec <vector124>:
.globl vector124
vector124:
  pushl $0
  1022ec:	6a 00                	push   $0x0
  pushl $124
  1022ee:	6a 7c                	push   $0x7c
  jmp __alltraps
  1022f0:	e9 1b 06 00 00       	jmp    102910 <__alltraps>

001022f5 <vector125>:
.globl vector125
vector125:
  pushl $0
  1022f5:	6a 00                	push   $0x0
  pushl $125
  1022f7:	6a 7d                	push   $0x7d
  jmp __alltraps
  1022f9:	e9 12 06 00 00       	jmp    102910 <__alltraps>

001022fe <vector126>:
.globl vector126
vector126:
  pushl $0
  1022fe:	6a 00                	push   $0x0
  pushl $126
  102300:	6a 7e                	push   $0x7e
  jmp __alltraps
  102302:	e9 09 06 00 00       	jmp    102910 <__alltraps>

00102307 <vector127>:
.globl vector127
vector127:
  pushl $0
  102307:	6a 00                	push   $0x0
  pushl $127
  102309:	6a 7f                	push   $0x7f
  jmp __alltraps
  10230b:	e9 00 06 00 00       	jmp    102910 <__alltraps>

00102310 <vector128>:
.globl vector128
vector128:
  pushl $0
  102310:	6a 00                	push   $0x0
  pushl $128
  102312:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  102317:	e9 f4 05 00 00       	jmp    102910 <__alltraps>

0010231c <vector129>:
.globl vector129
vector129:
  pushl $0
  10231c:	6a 00                	push   $0x0
  pushl $129
  10231e:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  102323:	e9 e8 05 00 00       	jmp    102910 <__alltraps>

00102328 <vector130>:
.globl vector130
vector130:
  pushl $0
  102328:	6a 00                	push   $0x0
  pushl $130
  10232a:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  10232f:	e9 dc 05 00 00       	jmp    102910 <__alltraps>

00102334 <vector131>:
.globl vector131
vector131:
  pushl $0
  102334:	6a 00                	push   $0x0
  pushl $131
  102336:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  10233b:	e9 d0 05 00 00       	jmp    102910 <__alltraps>

00102340 <vector132>:
.globl vector132
vector132:
  pushl $0
  102340:	6a 00                	push   $0x0
  pushl $132
  102342:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  102347:	e9 c4 05 00 00       	jmp    102910 <__alltraps>

0010234c <vector133>:
.globl vector133
vector133:
  pushl $0
  10234c:	6a 00                	push   $0x0
  pushl $133
  10234e:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  102353:	e9 b8 05 00 00       	jmp    102910 <__alltraps>

00102358 <vector134>:
.globl vector134
vector134:
  pushl $0
  102358:	6a 00                	push   $0x0
  pushl $134
  10235a:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  10235f:	e9 ac 05 00 00       	jmp    102910 <__alltraps>

00102364 <vector135>:
.globl vector135
vector135:
  pushl $0
  102364:	6a 00                	push   $0x0
  pushl $135
  102366:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  10236b:	e9 a0 05 00 00       	jmp    102910 <__alltraps>

00102370 <vector136>:
.globl vector136
vector136:
  pushl $0
  102370:	6a 00                	push   $0x0
  pushl $136
  102372:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  102377:	e9 94 05 00 00       	jmp    102910 <__alltraps>

0010237c <vector137>:
.globl vector137
vector137:
  pushl $0
  10237c:	6a 00                	push   $0x0
  pushl $137
  10237e:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  102383:	e9 88 05 00 00       	jmp    102910 <__alltraps>

00102388 <vector138>:
.globl vector138
vector138:
  pushl $0
  102388:	6a 00                	push   $0x0
  pushl $138
  10238a:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  10238f:	e9 7c 05 00 00       	jmp    102910 <__alltraps>

00102394 <vector139>:
.globl vector139
vector139:
  pushl $0
  102394:	6a 00                	push   $0x0
  pushl $139
  102396:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  10239b:	e9 70 05 00 00       	jmp    102910 <__alltraps>

001023a0 <vector140>:
.globl vector140
vector140:
  pushl $0
  1023a0:	6a 00                	push   $0x0
  pushl $140
  1023a2:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  1023a7:	e9 64 05 00 00       	jmp    102910 <__alltraps>

001023ac <vector141>:
.globl vector141
vector141:
  pushl $0
  1023ac:	6a 00                	push   $0x0
  pushl $141
  1023ae:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  1023b3:	e9 58 05 00 00       	jmp    102910 <__alltraps>

001023b8 <vector142>:
.globl vector142
vector142:
  pushl $0
  1023b8:	6a 00                	push   $0x0
  pushl $142
  1023ba:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  1023bf:	e9 4c 05 00 00       	jmp    102910 <__alltraps>

001023c4 <vector143>:
.globl vector143
vector143:
  pushl $0
  1023c4:	6a 00                	push   $0x0
  pushl $143
  1023c6:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  1023cb:	e9 40 05 00 00       	jmp    102910 <__alltraps>

001023d0 <vector144>:
.globl vector144
vector144:
  pushl $0
  1023d0:	6a 00                	push   $0x0
  pushl $144
  1023d2:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  1023d7:	e9 34 05 00 00       	jmp    102910 <__alltraps>

001023dc <vector145>:
.globl vector145
vector145:
  pushl $0
  1023dc:	6a 00                	push   $0x0
  pushl $145
  1023de:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  1023e3:	e9 28 05 00 00       	jmp    102910 <__alltraps>

001023e8 <vector146>:
.globl vector146
vector146:
  pushl $0
  1023e8:	6a 00                	push   $0x0
  pushl $146
  1023ea:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  1023ef:	e9 1c 05 00 00       	jmp    102910 <__alltraps>

001023f4 <vector147>:
.globl vector147
vector147:
  pushl $0
  1023f4:	6a 00                	push   $0x0
  pushl $147
  1023f6:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  1023fb:	e9 10 05 00 00       	jmp    102910 <__alltraps>

00102400 <vector148>:
.globl vector148
vector148:
  pushl $0
  102400:	6a 00                	push   $0x0
  pushl $148
  102402:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  102407:	e9 04 05 00 00       	jmp    102910 <__alltraps>

0010240c <vector149>:
.globl vector149
vector149:
  pushl $0
  10240c:	6a 00                	push   $0x0
  pushl $149
  10240e:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  102413:	e9 f8 04 00 00       	jmp    102910 <__alltraps>

00102418 <vector150>:
.globl vector150
vector150:
  pushl $0
  102418:	6a 00                	push   $0x0
  pushl $150
  10241a:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  10241f:	e9 ec 04 00 00       	jmp    102910 <__alltraps>

00102424 <vector151>:
.globl vector151
vector151:
  pushl $0
  102424:	6a 00                	push   $0x0
  pushl $151
  102426:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  10242b:	e9 e0 04 00 00       	jmp    102910 <__alltraps>

00102430 <vector152>:
.globl vector152
vector152:
  pushl $0
  102430:	6a 00                	push   $0x0
  pushl $152
  102432:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  102437:	e9 d4 04 00 00       	jmp    102910 <__alltraps>

0010243c <vector153>:
.globl vector153
vector153:
  pushl $0
  10243c:	6a 00                	push   $0x0
  pushl $153
  10243e:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  102443:	e9 c8 04 00 00       	jmp    102910 <__alltraps>

00102448 <vector154>:
.globl vector154
vector154:
  pushl $0
  102448:	6a 00                	push   $0x0
  pushl $154
  10244a:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  10244f:	e9 bc 04 00 00       	jmp    102910 <__alltraps>

00102454 <vector155>:
.globl vector155
vector155:
  pushl $0
  102454:	6a 00                	push   $0x0
  pushl $155
  102456:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  10245b:	e9 b0 04 00 00       	jmp    102910 <__alltraps>

00102460 <vector156>:
.globl vector156
vector156:
  pushl $0
  102460:	6a 00                	push   $0x0
  pushl $156
  102462:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  102467:	e9 a4 04 00 00       	jmp    102910 <__alltraps>

0010246c <vector157>:
.globl vector157
vector157:
  pushl $0
  10246c:	6a 00                	push   $0x0
  pushl $157
  10246e:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  102473:	e9 98 04 00 00       	jmp    102910 <__alltraps>

00102478 <vector158>:
.globl vector158
vector158:
  pushl $0
  102478:	6a 00                	push   $0x0
  pushl $158
  10247a:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  10247f:	e9 8c 04 00 00       	jmp    102910 <__alltraps>

00102484 <vector159>:
.globl vector159
vector159:
  pushl $0
  102484:	6a 00                	push   $0x0
  pushl $159
  102486:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  10248b:	e9 80 04 00 00       	jmp    102910 <__alltraps>

00102490 <vector160>:
.globl vector160
vector160:
  pushl $0
  102490:	6a 00                	push   $0x0
  pushl $160
  102492:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  102497:	e9 74 04 00 00       	jmp    102910 <__alltraps>

0010249c <vector161>:
.globl vector161
vector161:
  pushl $0
  10249c:	6a 00                	push   $0x0
  pushl $161
  10249e:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  1024a3:	e9 68 04 00 00       	jmp    102910 <__alltraps>

001024a8 <vector162>:
.globl vector162
vector162:
  pushl $0
  1024a8:	6a 00                	push   $0x0
  pushl $162
  1024aa:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  1024af:	e9 5c 04 00 00       	jmp    102910 <__alltraps>

001024b4 <vector163>:
.globl vector163
vector163:
  pushl $0
  1024b4:	6a 00                	push   $0x0
  pushl $163
  1024b6:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  1024bb:	e9 50 04 00 00       	jmp    102910 <__alltraps>

001024c0 <vector164>:
.globl vector164
vector164:
  pushl $0
  1024c0:	6a 00                	push   $0x0
  pushl $164
  1024c2:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  1024c7:	e9 44 04 00 00       	jmp    102910 <__alltraps>

001024cc <vector165>:
.globl vector165
vector165:
  pushl $0
  1024cc:	6a 00                	push   $0x0
  pushl $165
  1024ce:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  1024d3:	e9 38 04 00 00       	jmp    102910 <__alltraps>

001024d8 <vector166>:
.globl vector166
vector166:
  pushl $0
  1024d8:	6a 00                	push   $0x0
  pushl $166
  1024da:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  1024df:	e9 2c 04 00 00       	jmp    102910 <__alltraps>

001024e4 <vector167>:
.globl vector167
vector167:
  pushl $0
  1024e4:	6a 00                	push   $0x0
  pushl $167
  1024e6:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  1024eb:	e9 20 04 00 00       	jmp    102910 <__alltraps>

001024f0 <vector168>:
.globl vector168
vector168:
  pushl $0
  1024f0:	6a 00                	push   $0x0
  pushl $168
  1024f2:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  1024f7:	e9 14 04 00 00       	jmp    102910 <__alltraps>

001024fc <vector169>:
.globl vector169
vector169:
  pushl $0
  1024fc:	6a 00                	push   $0x0
  pushl $169
  1024fe:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  102503:	e9 08 04 00 00       	jmp    102910 <__alltraps>

00102508 <vector170>:
.globl vector170
vector170:
  pushl $0
  102508:	6a 00                	push   $0x0
  pushl $170
  10250a:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  10250f:	e9 fc 03 00 00       	jmp    102910 <__alltraps>

00102514 <vector171>:
.globl vector171
vector171:
  pushl $0
  102514:	6a 00                	push   $0x0
  pushl $171
  102516:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  10251b:	e9 f0 03 00 00       	jmp    102910 <__alltraps>

00102520 <vector172>:
.globl vector172
vector172:
  pushl $0
  102520:	6a 00                	push   $0x0
  pushl $172
  102522:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  102527:	e9 e4 03 00 00       	jmp    102910 <__alltraps>

0010252c <vector173>:
.globl vector173
vector173:
  pushl $0
  10252c:	6a 00                	push   $0x0
  pushl $173
  10252e:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  102533:	e9 d8 03 00 00       	jmp    102910 <__alltraps>

00102538 <vector174>:
.globl vector174
vector174:
  pushl $0
  102538:	6a 00                	push   $0x0
  pushl $174
  10253a:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  10253f:	e9 cc 03 00 00       	jmp    102910 <__alltraps>

00102544 <vector175>:
.globl vector175
vector175:
  pushl $0
  102544:	6a 00                	push   $0x0
  pushl $175
  102546:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  10254b:	e9 c0 03 00 00       	jmp    102910 <__alltraps>

00102550 <vector176>:
.globl vector176
vector176:
  pushl $0
  102550:	6a 00                	push   $0x0
  pushl $176
  102552:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  102557:	e9 b4 03 00 00       	jmp    102910 <__alltraps>

0010255c <vector177>:
.globl vector177
vector177:
  pushl $0
  10255c:	6a 00                	push   $0x0
  pushl $177
  10255e:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  102563:	e9 a8 03 00 00       	jmp    102910 <__alltraps>

00102568 <vector178>:
.globl vector178
vector178:
  pushl $0
  102568:	6a 00                	push   $0x0
  pushl $178
  10256a:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  10256f:	e9 9c 03 00 00       	jmp    102910 <__alltraps>

00102574 <vector179>:
.globl vector179
vector179:
  pushl $0
  102574:	6a 00                	push   $0x0
  pushl $179
  102576:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  10257b:	e9 90 03 00 00       	jmp    102910 <__alltraps>

00102580 <vector180>:
.globl vector180
vector180:
  pushl $0
  102580:	6a 00                	push   $0x0
  pushl $180
  102582:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  102587:	e9 84 03 00 00       	jmp    102910 <__alltraps>

0010258c <vector181>:
.globl vector181
vector181:
  pushl $0
  10258c:	6a 00                	push   $0x0
  pushl $181
  10258e:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  102593:	e9 78 03 00 00       	jmp    102910 <__alltraps>

00102598 <vector182>:
.globl vector182
vector182:
  pushl $0
  102598:	6a 00                	push   $0x0
  pushl $182
  10259a:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  10259f:	e9 6c 03 00 00       	jmp    102910 <__alltraps>

001025a4 <vector183>:
.globl vector183
vector183:
  pushl $0
  1025a4:	6a 00                	push   $0x0
  pushl $183
  1025a6:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  1025ab:	e9 60 03 00 00       	jmp    102910 <__alltraps>

001025b0 <vector184>:
.globl vector184
vector184:
  pushl $0
  1025b0:	6a 00                	push   $0x0
  pushl $184
  1025b2:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  1025b7:	e9 54 03 00 00       	jmp    102910 <__alltraps>

001025bc <vector185>:
.globl vector185
vector185:
  pushl $0
  1025bc:	6a 00                	push   $0x0
  pushl $185
  1025be:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  1025c3:	e9 48 03 00 00       	jmp    102910 <__alltraps>

001025c8 <vector186>:
.globl vector186
vector186:
  pushl $0
  1025c8:	6a 00                	push   $0x0
  pushl $186
  1025ca:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  1025cf:	e9 3c 03 00 00       	jmp    102910 <__alltraps>

001025d4 <vector187>:
.globl vector187
vector187:
  pushl $0
  1025d4:	6a 00                	push   $0x0
  pushl $187
  1025d6:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  1025db:	e9 30 03 00 00       	jmp    102910 <__alltraps>

001025e0 <vector188>:
.globl vector188
vector188:
  pushl $0
  1025e0:	6a 00                	push   $0x0
  pushl $188
  1025e2:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  1025e7:	e9 24 03 00 00       	jmp    102910 <__alltraps>

001025ec <vector189>:
.globl vector189
vector189:
  pushl $0
  1025ec:	6a 00                	push   $0x0
  pushl $189
  1025ee:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  1025f3:	e9 18 03 00 00       	jmp    102910 <__alltraps>

001025f8 <vector190>:
.globl vector190
vector190:
  pushl $0
  1025f8:	6a 00                	push   $0x0
  pushl $190
  1025fa:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  1025ff:	e9 0c 03 00 00       	jmp    102910 <__alltraps>

00102604 <vector191>:
.globl vector191
vector191:
  pushl $0
  102604:	6a 00                	push   $0x0
  pushl $191
  102606:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  10260b:	e9 00 03 00 00       	jmp    102910 <__alltraps>

00102610 <vector192>:
.globl vector192
vector192:
  pushl $0
  102610:	6a 00                	push   $0x0
  pushl $192
  102612:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  102617:	e9 f4 02 00 00       	jmp    102910 <__alltraps>

0010261c <vector193>:
.globl vector193
vector193:
  pushl $0
  10261c:	6a 00                	push   $0x0
  pushl $193
  10261e:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  102623:	e9 e8 02 00 00       	jmp    102910 <__alltraps>

00102628 <vector194>:
.globl vector194
vector194:
  pushl $0
  102628:	6a 00                	push   $0x0
  pushl $194
  10262a:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  10262f:	e9 dc 02 00 00       	jmp    102910 <__alltraps>

00102634 <vector195>:
.globl vector195
vector195:
  pushl $0
  102634:	6a 00                	push   $0x0
  pushl $195
  102636:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  10263b:	e9 d0 02 00 00       	jmp    102910 <__alltraps>

00102640 <vector196>:
.globl vector196
vector196:
  pushl $0
  102640:	6a 00                	push   $0x0
  pushl $196
  102642:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  102647:	e9 c4 02 00 00       	jmp    102910 <__alltraps>

0010264c <vector197>:
.globl vector197
vector197:
  pushl $0
  10264c:	6a 00                	push   $0x0
  pushl $197
  10264e:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  102653:	e9 b8 02 00 00       	jmp    102910 <__alltraps>

00102658 <vector198>:
.globl vector198
vector198:
  pushl $0
  102658:	6a 00                	push   $0x0
  pushl $198
  10265a:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  10265f:	e9 ac 02 00 00       	jmp    102910 <__alltraps>

00102664 <vector199>:
.globl vector199
vector199:
  pushl $0
  102664:	6a 00                	push   $0x0
  pushl $199
  102666:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  10266b:	e9 a0 02 00 00       	jmp    102910 <__alltraps>

00102670 <vector200>:
.globl vector200
vector200:
  pushl $0
  102670:	6a 00                	push   $0x0
  pushl $200
  102672:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  102677:	e9 94 02 00 00       	jmp    102910 <__alltraps>

0010267c <vector201>:
.globl vector201
vector201:
  pushl $0
  10267c:	6a 00                	push   $0x0
  pushl $201
  10267e:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  102683:	e9 88 02 00 00       	jmp    102910 <__alltraps>

00102688 <vector202>:
.globl vector202
vector202:
  pushl $0
  102688:	6a 00                	push   $0x0
  pushl $202
  10268a:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  10268f:	e9 7c 02 00 00       	jmp    102910 <__alltraps>

00102694 <vector203>:
.globl vector203
vector203:
  pushl $0
  102694:	6a 00                	push   $0x0
  pushl $203
  102696:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  10269b:	e9 70 02 00 00       	jmp    102910 <__alltraps>

001026a0 <vector204>:
.globl vector204
vector204:
  pushl $0
  1026a0:	6a 00                	push   $0x0
  pushl $204
  1026a2:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  1026a7:	e9 64 02 00 00       	jmp    102910 <__alltraps>

001026ac <vector205>:
.globl vector205
vector205:
  pushl $0
  1026ac:	6a 00                	push   $0x0
  pushl $205
  1026ae:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  1026b3:	e9 58 02 00 00       	jmp    102910 <__alltraps>

001026b8 <vector206>:
.globl vector206
vector206:
  pushl $0
  1026b8:	6a 00                	push   $0x0
  pushl $206
  1026ba:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  1026bf:	e9 4c 02 00 00       	jmp    102910 <__alltraps>

001026c4 <vector207>:
.globl vector207
vector207:
  pushl $0
  1026c4:	6a 00                	push   $0x0
  pushl $207
  1026c6:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  1026cb:	e9 40 02 00 00       	jmp    102910 <__alltraps>

001026d0 <vector208>:
.globl vector208
vector208:
  pushl $0
  1026d0:	6a 00                	push   $0x0
  pushl $208
  1026d2:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  1026d7:	e9 34 02 00 00       	jmp    102910 <__alltraps>

001026dc <vector209>:
.globl vector209
vector209:
  pushl $0
  1026dc:	6a 00                	push   $0x0
  pushl $209
  1026de:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  1026e3:	e9 28 02 00 00       	jmp    102910 <__alltraps>

001026e8 <vector210>:
.globl vector210
vector210:
  pushl $0
  1026e8:	6a 00                	push   $0x0
  pushl $210
  1026ea:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  1026ef:	e9 1c 02 00 00       	jmp    102910 <__alltraps>

001026f4 <vector211>:
.globl vector211
vector211:
  pushl $0
  1026f4:	6a 00                	push   $0x0
  pushl $211
  1026f6:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  1026fb:	e9 10 02 00 00       	jmp    102910 <__alltraps>

00102700 <vector212>:
.globl vector212
vector212:
  pushl $0
  102700:	6a 00                	push   $0x0
  pushl $212
  102702:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  102707:	e9 04 02 00 00       	jmp    102910 <__alltraps>

0010270c <vector213>:
.globl vector213
vector213:
  pushl $0
  10270c:	6a 00                	push   $0x0
  pushl $213
  10270e:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  102713:	e9 f8 01 00 00       	jmp    102910 <__alltraps>

00102718 <vector214>:
.globl vector214
vector214:
  pushl $0
  102718:	6a 00                	push   $0x0
  pushl $214
  10271a:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  10271f:	e9 ec 01 00 00       	jmp    102910 <__alltraps>

00102724 <vector215>:
.globl vector215
vector215:
  pushl $0
  102724:	6a 00                	push   $0x0
  pushl $215
  102726:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  10272b:	e9 e0 01 00 00       	jmp    102910 <__alltraps>

00102730 <vector216>:
.globl vector216
vector216:
  pushl $0
  102730:	6a 00                	push   $0x0
  pushl $216
  102732:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  102737:	e9 d4 01 00 00       	jmp    102910 <__alltraps>

0010273c <vector217>:
.globl vector217
vector217:
  pushl $0
  10273c:	6a 00                	push   $0x0
  pushl $217
  10273e:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  102743:	e9 c8 01 00 00       	jmp    102910 <__alltraps>

00102748 <vector218>:
.globl vector218
vector218:
  pushl $0
  102748:	6a 00                	push   $0x0
  pushl $218
  10274a:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  10274f:	e9 bc 01 00 00       	jmp    102910 <__alltraps>

00102754 <vector219>:
.globl vector219
vector219:
  pushl $0
  102754:	6a 00                	push   $0x0
  pushl $219
  102756:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  10275b:	e9 b0 01 00 00       	jmp    102910 <__alltraps>

00102760 <vector220>:
.globl vector220
vector220:
  pushl $0
  102760:	6a 00                	push   $0x0
  pushl $220
  102762:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  102767:	e9 a4 01 00 00       	jmp    102910 <__alltraps>

0010276c <vector221>:
.globl vector221
vector221:
  pushl $0
  10276c:	6a 00                	push   $0x0
  pushl $221
  10276e:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  102773:	e9 98 01 00 00       	jmp    102910 <__alltraps>

00102778 <vector222>:
.globl vector222
vector222:
  pushl $0
  102778:	6a 00                	push   $0x0
  pushl $222
  10277a:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  10277f:	e9 8c 01 00 00       	jmp    102910 <__alltraps>

00102784 <vector223>:
.globl vector223
vector223:
  pushl $0
  102784:	6a 00                	push   $0x0
  pushl $223
  102786:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  10278b:	e9 80 01 00 00       	jmp    102910 <__alltraps>

00102790 <vector224>:
.globl vector224
vector224:
  pushl $0
  102790:	6a 00                	push   $0x0
  pushl $224
  102792:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  102797:	e9 74 01 00 00       	jmp    102910 <__alltraps>

0010279c <vector225>:
.globl vector225
vector225:
  pushl $0
  10279c:	6a 00                	push   $0x0
  pushl $225
  10279e:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  1027a3:	e9 68 01 00 00       	jmp    102910 <__alltraps>

001027a8 <vector226>:
.globl vector226
vector226:
  pushl $0
  1027a8:	6a 00                	push   $0x0
  pushl $226
  1027aa:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  1027af:	e9 5c 01 00 00       	jmp    102910 <__alltraps>

001027b4 <vector227>:
.globl vector227
vector227:
  pushl $0
  1027b4:	6a 00                	push   $0x0
  pushl $227
  1027b6:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  1027bb:	e9 50 01 00 00       	jmp    102910 <__alltraps>

001027c0 <vector228>:
.globl vector228
vector228:
  pushl $0
  1027c0:	6a 00                	push   $0x0
  pushl $228
  1027c2:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  1027c7:	e9 44 01 00 00       	jmp    102910 <__alltraps>

001027cc <vector229>:
.globl vector229
vector229:
  pushl $0
  1027cc:	6a 00                	push   $0x0
  pushl $229
  1027ce:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  1027d3:	e9 38 01 00 00       	jmp    102910 <__alltraps>

001027d8 <vector230>:
.globl vector230
vector230:
  pushl $0
  1027d8:	6a 00                	push   $0x0
  pushl $230
  1027da:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  1027df:	e9 2c 01 00 00       	jmp    102910 <__alltraps>

001027e4 <vector231>:
.globl vector231
vector231:
  pushl $0
  1027e4:	6a 00                	push   $0x0
  pushl $231
  1027e6:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  1027eb:	e9 20 01 00 00       	jmp    102910 <__alltraps>

001027f0 <vector232>:
.globl vector232
vector232:
  pushl $0
  1027f0:	6a 00                	push   $0x0
  pushl $232
  1027f2:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  1027f7:	e9 14 01 00 00       	jmp    102910 <__alltraps>

001027fc <vector233>:
.globl vector233
vector233:
  pushl $0
  1027fc:	6a 00                	push   $0x0
  pushl $233
  1027fe:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  102803:	e9 08 01 00 00       	jmp    102910 <__alltraps>

00102808 <vector234>:
.globl vector234
vector234:
  pushl $0
  102808:	6a 00                	push   $0x0
  pushl $234
  10280a:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  10280f:	e9 fc 00 00 00       	jmp    102910 <__alltraps>

00102814 <vector235>:
.globl vector235
vector235:
  pushl $0
  102814:	6a 00                	push   $0x0
  pushl $235
  102816:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  10281b:	e9 f0 00 00 00       	jmp    102910 <__alltraps>

00102820 <vector236>:
.globl vector236
vector236:
  pushl $0
  102820:	6a 00                	push   $0x0
  pushl $236
  102822:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  102827:	e9 e4 00 00 00       	jmp    102910 <__alltraps>

0010282c <vector237>:
.globl vector237
vector237:
  pushl $0
  10282c:	6a 00                	push   $0x0
  pushl $237
  10282e:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  102833:	e9 d8 00 00 00       	jmp    102910 <__alltraps>

00102838 <vector238>:
.globl vector238
vector238:
  pushl $0
  102838:	6a 00                	push   $0x0
  pushl $238
  10283a:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  10283f:	e9 cc 00 00 00       	jmp    102910 <__alltraps>

00102844 <vector239>:
.globl vector239
vector239:
  pushl $0
  102844:	6a 00                	push   $0x0
  pushl $239
  102846:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  10284b:	e9 c0 00 00 00       	jmp    102910 <__alltraps>

00102850 <vector240>:
.globl vector240
vector240:
  pushl $0
  102850:	6a 00                	push   $0x0
  pushl $240
  102852:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  102857:	e9 b4 00 00 00       	jmp    102910 <__alltraps>

0010285c <vector241>:
.globl vector241
vector241:
  pushl $0
  10285c:	6a 00                	push   $0x0
  pushl $241
  10285e:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  102863:	e9 a8 00 00 00       	jmp    102910 <__alltraps>

00102868 <vector242>:
.globl vector242
vector242:
  pushl $0
  102868:	6a 00                	push   $0x0
  pushl $242
  10286a:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  10286f:	e9 9c 00 00 00       	jmp    102910 <__alltraps>

00102874 <vector243>:
.globl vector243
vector243:
  pushl $0
  102874:	6a 00                	push   $0x0
  pushl $243
  102876:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  10287b:	e9 90 00 00 00       	jmp    102910 <__alltraps>

00102880 <vector244>:
.globl vector244
vector244:
  pushl $0
  102880:	6a 00                	push   $0x0
  pushl $244
  102882:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  102887:	e9 84 00 00 00       	jmp    102910 <__alltraps>

0010288c <vector245>:
.globl vector245
vector245:
  pushl $0
  10288c:	6a 00                	push   $0x0
  pushl $245
  10288e:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  102893:	e9 78 00 00 00       	jmp    102910 <__alltraps>

00102898 <vector246>:
.globl vector246
vector246:
  pushl $0
  102898:	6a 00                	push   $0x0
  pushl $246
  10289a:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  10289f:	e9 6c 00 00 00       	jmp    102910 <__alltraps>

001028a4 <vector247>:
.globl vector247
vector247:
  pushl $0
  1028a4:	6a 00                	push   $0x0
  pushl $247
  1028a6:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  1028ab:	e9 60 00 00 00       	jmp    102910 <__alltraps>

001028b0 <vector248>:
.globl vector248
vector248:
  pushl $0
  1028b0:	6a 00                	push   $0x0
  pushl $248
  1028b2:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  1028b7:	e9 54 00 00 00       	jmp    102910 <__alltraps>

001028bc <vector249>:
.globl vector249
vector249:
  pushl $0
  1028bc:	6a 00                	push   $0x0
  pushl $249
  1028be:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  1028c3:	e9 48 00 00 00       	jmp    102910 <__alltraps>

001028c8 <vector250>:
.globl vector250
vector250:
  pushl $0
  1028c8:	6a 00                	push   $0x0
  pushl $250
  1028ca:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  1028cf:	e9 3c 00 00 00       	jmp    102910 <__alltraps>

001028d4 <vector251>:
.globl vector251
vector251:
  pushl $0
  1028d4:	6a 00                	push   $0x0
  pushl $251
  1028d6:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  1028db:	e9 30 00 00 00       	jmp    102910 <__alltraps>

001028e0 <vector252>:
.globl vector252
vector252:
  pushl $0
  1028e0:	6a 00                	push   $0x0
  pushl $252
  1028e2:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  1028e7:	e9 24 00 00 00       	jmp    102910 <__alltraps>

001028ec <vector253>:
.globl vector253
vector253:
  pushl $0
  1028ec:	6a 00                	push   $0x0
  pushl $253
  1028ee:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  1028f3:	e9 18 00 00 00       	jmp    102910 <__alltraps>

001028f8 <vector254>:
.globl vector254
vector254:
  pushl $0
  1028f8:	6a 00                	push   $0x0
  pushl $254
  1028fa:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  1028ff:	e9 0c 00 00 00       	jmp    102910 <__alltraps>

00102904 <vector255>:
.globl vector255
vector255:
  pushl $0
  102904:	6a 00                	push   $0x0
  pushl $255
  102906:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  10290b:	e9 00 00 00 00       	jmp    102910 <__alltraps>

00102910 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  102910:	1e                   	push   %ds
    pushl %es
  102911:	06                   	push   %es
    pushl %fs
  102912:	0f a0                	push   %fs
    pushl %gs
  102914:	0f a8                	push   %gs
    pushal
  102916:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  102917:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  10291c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  10291e:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  102920:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  102921:	e8 65 f5 ff ff       	call   101e8b <trap>

    # pop the pushed stack pointer
    popl %esp
  102926:	5c                   	pop    %esp

00102927 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  102927:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  102928:	0f a9                	pop    %gs
    popl %fs
  10292a:	0f a1                	pop    %fs
    popl %es
  10292c:	07                   	pop    %es
    popl %ds
  10292d:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  10292e:	83 c4 08             	add    $0x8,%esp
    iret
  102931:	cf                   	iret   

00102932 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  102932:	55                   	push   %ebp
  102933:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  102935:	8b 45 08             	mov    0x8(%ebp),%eax
  102938:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  10293b:	b8 23 00 00 00       	mov    $0x23,%eax
  102940:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  102942:	b8 23 00 00 00       	mov    $0x23,%eax
  102947:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  102949:	b8 10 00 00 00       	mov    $0x10,%eax
  10294e:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  102950:	b8 10 00 00 00       	mov    $0x10,%eax
  102955:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  102957:	b8 10 00 00 00       	mov    $0x10,%eax
  10295c:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  10295e:	ea 65 29 10 00 08 00 	ljmp   $0x8,$0x102965
}
  102965:	5d                   	pop    %ebp
  102966:	c3                   	ret    

00102967 <gdt_init>:
/* temporary kernel stack */
uint8_t stack0[1024];

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  102967:	55                   	push   %ebp
  102968:	89 e5                	mov    %esp,%ebp
  10296a:	83 ec 14             	sub    $0x14,%esp
    // Setup a TSS so that we can get the right stack when we trap from
    // user to the kernel. But not safe here, it's only a temporary value,
    // it will be set to KSTACKTOP in lab2.
    ts.ts_esp0 = (uint32_t)&stack0 + sizeof(stack0);
  10296d:	b8 80 f9 10 00       	mov    $0x10f980,%eax
  102972:	05 00 04 00 00       	add    $0x400,%eax
  102977:	a3 a4 f8 10 00       	mov    %eax,0x10f8a4
    ts.ts_ss0 = KERNEL_DS;
  10297c:	66 c7 05 a8 f8 10 00 	movw   $0x10,0x10f8a8
  102983:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEG16(STS_T32A, (uint32_t)&ts, sizeof(ts), DPL_KERNEL);
  102985:	66 c7 05 08 ea 10 00 	movw   $0x68,0x10ea08
  10298c:	68 00 
  10298e:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  102993:	66 a3 0a ea 10 00    	mov    %ax,0x10ea0a
  102999:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  10299e:	c1 e8 10             	shr    $0x10,%eax
  1029a1:	a2 0c ea 10 00       	mov    %al,0x10ea0c
  1029a6:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1029ad:	83 e0 f0             	and    $0xfffffff0,%eax
  1029b0:	83 c8 09             	or     $0x9,%eax
  1029b3:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  1029b8:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1029bf:	83 c8 10             	or     $0x10,%eax
  1029c2:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  1029c7:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1029ce:	83 e0 9f             	and    $0xffffff9f,%eax
  1029d1:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  1029d6:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1029dd:	83 c8 80             	or     $0xffffff80,%eax
  1029e0:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  1029e5:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  1029ec:	83 e0 f0             	and    $0xfffffff0,%eax
  1029ef:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  1029f4:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  1029fb:	83 e0 ef             	and    $0xffffffef,%eax
  1029fe:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102a03:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102a0a:	83 e0 df             	and    $0xffffffdf,%eax
  102a0d:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102a12:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102a19:	83 c8 40             	or     $0x40,%eax
  102a1c:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102a21:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102a28:	83 e0 7f             	and    $0x7f,%eax
  102a2b:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102a30:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  102a35:	c1 e8 18             	shr    $0x18,%eax
  102a38:	a2 0f ea 10 00       	mov    %al,0x10ea0f
    gdt[SEG_TSS].sd_s = 0;
  102a3d:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102a44:	83 e0 ef             	and    $0xffffffef,%eax
  102a47:	a2 0d ea 10 00       	mov    %al,0x10ea0d

    // reload all segment registers
    lgdt(&gdt_pd);
  102a4c:	c7 04 24 10 ea 10 00 	movl   $0x10ea10,(%esp)
  102a53:	e8 da fe ff ff       	call   102932 <lgdt>
  102a58:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel));
  102a5e:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  102a62:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  102a65:	c9                   	leave  
  102a66:	c3                   	ret    

00102a67 <pmm_init>:

/* pmm_init - initialize the physical memory management */
void
pmm_init(void) {
  102a67:	55                   	push   %ebp
  102a68:	89 e5                	mov    %esp,%ebp
    gdt_init();
  102a6a:	e8 f8 fe ff ff       	call   102967 <gdt_init>
}
  102a6f:	5d                   	pop    %ebp
  102a70:	c3                   	ret    

00102a71 <strlen>:
 * @s:        the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  102a71:	55                   	push   %ebp
  102a72:	89 e5                	mov    %esp,%ebp
  102a74:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102a77:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  102a7e:	eb 04                	jmp    102a84 <strlen+0x13>
        cnt ++;
  102a80:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    while (*s ++ != '\0') {
  102a84:	8b 45 08             	mov    0x8(%ebp),%eax
  102a87:	8d 50 01             	lea    0x1(%eax),%edx
  102a8a:	89 55 08             	mov    %edx,0x8(%ebp)
  102a8d:	0f b6 00             	movzbl (%eax),%eax
  102a90:	84 c0                	test   %al,%al
  102a92:	75 ec                	jne    102a80 <strlen+0xf>
    }
    return cnt;
  102a94:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102a97:	c9                   	leave  
  102a98:	c3                   	ret    

00102a99 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  102a99:	55                   	push   %ebp
  102a9a:	89 e5                	mov    %esp,%ebp
  102a9c:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102a9f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  102aa6:	eb 04                	jmp    102aac <strnlen+0x13>
        cnt ++;
  102aa8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  102aac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102aaf:	3b 45 0c             	cmp    0xc(%ebp),%eax
  102ab2:	73 10                	jae    102ac4 <strnlen+0x2b>
  102ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  102ab7:	8d 50 01             	lea    0x1(%eax),%edx
  102aba:	89 55 08             	mov    %edx,0x8(%ebp)
  102abd:	0f b6 00             	movzbl (%eax),%eax
  102ac0:	84 c0                	test   %al,%al
  102ac2:	75 e4                	jne    102aa8 <strnlen+0xf>
    }
    return cnt;
  102ac4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102ac7:	c9                   	leave  
  102ac8:	c3                   	ret    

00102ac9 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  102ac9:	55                   	push   %ebp
  102aca:	89 e5                	mov    %esp,%ebp
  102acc:	57                   	push   %edi
  102acd:	56                   	push   %esi
  102ace:	83 ec 20             	sub    $0x20,%esp
  102ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  102ad4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102ad7:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ada:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  102add:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102ae0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ae3:	89 d1                	mov    %edx,%ecx
  102ae5:	89 c2                	mov    %eax,%edx
  102ae7:	89 ce                	mov    %ecx,%esi
  102ae9:	89 d7                	mov    %edx,%edi
  102aeb:	ac                   	lods   %ds:(%esi),%al
  102aec:	aa                   	stos   %al,%es:(%edi)
  102aed:	84 c0                	test   %al,%al
  102aef:	75 fa                	jne    102aeb <strcpy+0x22>
  102af1:	89 fa                	mov    %edi,%edx
  102af3:	89 f1                	mov    %esi,%ecx
  102af5:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  102af8:	89 55 e8             	mov    %edx,-0x18(%ebp)
  102afb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "stosb;"
            "testb %%al, %%al;"
            "jne 1b;"
            : "=&S" (d0), "=&D" (d1), "=&a" (d2)
            : "0" (src), "1" (dst) : "memory");
    return dst;
  102afe:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  102b01:	83 c4 20             	add    $0x20,%esp
  102b04:	5e                   	pop    %esi
  102b05:	5f                   	pop    %edi
  102b06:	5d                   	pop    %ebp
  102b07:	c3                   	ret    

00102b08 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  102b08:	55                   	push   %ebp
  102b09:	89 e5                	mov    %esp,%ebp
  102b0b:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  102b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  102b11:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  102b14:	eb 21                	jmp    102b37 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  102b16:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b19:	0f b6 10             	movzbl (%eax),%edx
  102b1c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102b1f:	88 10                	mov    %dl,(%eax)
  102b21:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102b24:	0f b6 00             	movzbl (%eax),%eax
  102b27:	84 c0                	test   %al,%al
  102b29:	74 04                	je     102b2f <strncpy+0x27>
            src ++;
  102b2b:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  102b2f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  102b33:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    while (len > 0) {
  102b37:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102b3b:	75 d9                	jne    102b16 <strncpy+0xe>
    }
    return dst;
  102b3d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102b40:	c9                   	leave  
  102b41:	c3                   	ret    

00102b42 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  102b42:	55                   	push   %ebp
  102b43:	89 e5                	mov    %esp,%ebp
  102b45:	57                   	push   %edi
  102b46:	56                   	push   %esi
  102b47:	83 ec 20             	sub    $0x20,%esp
  102b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  102b4d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102b50:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b53:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
  102b56:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102b59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102b5c:	89 d1                	mov    %edx,%ecx
  102b5e:	89 c2                	mov    %eax,%edx
  102b60:	89 ce                	mov    %ecx,%esi
  102b62:	89 d7                	mov    %edx,%edi
  102b64:	ac                   	lods   %ds:(%esi),%al
  102b65:	ae                   	scas   %es:(%edi),%al
  102b66:	75 08                	jne    102b70 <strcmp+0x2e>
  102b68:	84 c0                	test   %al,%al
  102b6a:	75 f8                	jne    102b64 <strcmp+0x22>
  102b6c:	31 c0                	xor    %eax,%eax
  102b6e:	eb 04                	jmp    102b74 <strcmp+0x32>
  102b70:	19 c0                	sbb    %eax,%eax
  102b72:	0c 01                	or     $0x1,%al
  102b74:	89 fa                	mov    %edi,%edx
  102b76:	89 f1                	mov    %esi,%ecx
  102b78:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102b7b:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  102b7e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
  102b81:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  102b84:	83 c4 20             	add    $0x20,%esp
  102b87:	5e                   	pop    %esi
  102b88:	5f                   	pop    %edi
  102b89:	5d                   	pop    %ebp
  102b8a:	c3                   	ret    

00102b8b <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  102b8b:	55                   	push   %ebp
  102b8c:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102b8e:	eb 0c                	jmp    102b9c <strncmp+0x11>
        n --, s1 ++, s2 ++;
  102b90:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  102b94:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102b98:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102b9c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102ba0:	74 1a                	je     102bbc <strncmp+0x31>
  102ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  102ba5:	0f b6 00             	movzbl (%eax),%eax
  102ba8:	84 c0                	test   %al,%al
  102baa:	74 10                	je     102bbc <strncmp+0x31>
  102bac:	8b 45 08             	mov    0x8(%ebp),%eax
  102baf:	0f b6 10             	movzbl (%eax),%edx
  102bb2:	8b 45 0c             	mov    0xc(%ebp),%eax
  102bb5:	0f b6 00             	movzbl (%eax),%eax
  102bb8:	38 c2                	cmp    %al,%dl
  102bba:	74 d4                	je     102b90 <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  102bbc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102bc0:	74 18                	je     102bda <strncmp+0x4f>
  102bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  102bc5:	0f b6 00             	movzbl (%eax),%eax
  102bc8:	0f b6 d0             	movzbl %al,%edx
  102bcb:	8b 45 0c             	mov    0xc(%ebp),%eax
  102bce:	0f b6 00             	movzbl (%eax),%eax
  102bd1:	0f b6 c0             	movzbl %al,%eax
  102bd4:	29 c2                	sub    %eax,%edx
  102bd6:	89 d0                	mov    %edx,%eax
  102bd8:	eb 05                	jmp    102bdf <strncmp+0x54>
  102bda:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102bdf:	5d                   	pop    %ebp
  102be0:	c3                   	ret    

00102be1 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  102be1:	55                   	push   %ebp
  102be2:	89 e5                	mov    %esp,%ebp
  102be4:	83 ec 04             	sub    $0x4,%esp
  102be7:	8b 45 0c             	mov    0xc(%ebp),%eax
  102bea:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102bed:	eb 14                	jmp    102c03 <strchr+0x22>
        if (*s == c) {
  102bef:	8b 45 08             	mov    0x8(%ebp),%eax
  102bf2:	0f b6 00             	movzbl (%eax),%eax
  102bf5:	3a 45 fc             	cmp    -0x4(%ebp),%al
  102bf8:	75 05                	jne    102bff <strchr+0x1e>
            return (char *)s;
  102bfa:	8b 45 08             	mov    0x8(%ebp),%eax
  102bfd:	eb 13                	jmp    102c12 <strchr+0x31>
        }
        s ++;
  102bff:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s != '\0') {
  102c03:	8b 45 08             	mov    0x8(%ebp),%eax
  102c06:	0f b6 00             	movzbl (%eax),%eax
  102c09:	84 c0                	test   %al,%al
  102c0b:	75 e2                	jne    102bef <strchr+0xe>
    }
    return NULL;
  102c0d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102c12:	c9                   	leave  
  102c13:	c3                   	ret    

00102c14 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  102c14:	55                   	push   %ebp
  102c15:	89 e5                	mov    %esp,%ebp
  102c17:	83 ec 04             	sub    $0x4,%esp
  102c1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c1d:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102c20:	eb 11                	jmp    102c33 <strfind+0x1f>
        if (*s == c) {
  102c22:	8b 45 08             	mov    0x8(%ebp),%eax
  102c25:	0f b6 00             	movzbl (%eax),%eax
  102c28:	3a 45 fc             	cmp    -0x4(%ebp),%al
  102c2b:	75 02                	jne    102c2f <strfind+0x1b>
            break;
  102c2d:	eb 0e                	jmp    102c3d <strfind+0x29>
        }
        s ++;
  102c2f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s != '\0') {
  102c33:	8b 45 08             	mov    0x8(%ebp),%eax
  102c36:	0f b6 00             	movzbl (%eax),%eax
  102c39:	84 c0                	test   %al,%al
  102c3b:	75 e5                	jne    102c22 <strfind+0xe>
    }
    return (char *)s;
  102c3d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102c40:	c9                   	leave  
  102c41:	c3                   	ret    

00102c42 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  102c42:	55                   	push   %ebp
  102c43:	89 e5                	mov    %esp,%ebp
  102c45:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  102c48:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  102c4f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  102c56:	eb 04                	jmp    102c5c <strtol+0x1a>
        s ++;
  102c58:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
  102c5c:	8b 45 08             	mov    0x8(%ebp),%eax
  102c5f:	0f b6 00             	movzbl (%eax),%eax
  102c62:	3c 20                	cmp    $0x20,%al
  102c64:	74 f2                	je     102c58 <strtol+0x16>
  102c66:	8b 45 08             	mov    0x8(%ebp),%eax
  102c69:	0f b6 00             	movzbl (%eax),%eax
  102c6c:	3c 09                	cmp    $0x9,%al
  102c6e:	74 e8                	je     102c58 <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+') {
  102c70:	8b 45 08             	mov    0x8(%ebp),%eax
  102c73:	0f b6 00             	movzbl (%eax),%eax
  102c76:	3c 2b                	cmp    $0x2b,%al
  102c78:	75 06                	jne    102c80 <strtol+0x3e>
        s ++;
  102c7a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102c7e:	eb 15                	jmp    102c95 <strtol+0x53>
    }
    else if (*s == '-') {
  102c80:	8b 45 08             	mov    0x8(%ebp),%eax
  102c83:	0f b6 00             	movzbl (%eax),%eax
  102c86:	3c 2d                	cmp    $0x2d,%al
  102c88:	75 0b                	jne    102c95 <strtol+0x53>
        s ++, neg = 1;
  102c8a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102c8e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  102c95:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102c99:	74 06                	je     102ca1 <strtol+0x5f>
  102c9b:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  102c9f:	75 24                	jne    102cc5 <strtol+0x83>
  102ca1:	8b 45 08             	mov    0x8(%ebp),%eax
  102ca4:	0f b6 00             	movzbl (%eax),%eax
  102ca7:	3c 30                	cmp    $0x30,%al
  102ca9:	75 1a                	jne    102cc5 <strtol+0x83>
  102cab:	8b 45 08             	mov    0x8(%ebp),%eax
  102cae:	83 c0 01             	add    $0x1,%eax
  102cb1:	0f b6 00             	movzbl (%eax),%eax
  102cb4:	3c 78                	cmp    $0x78,%al
  102cb6:	75 0d                	jne    102cc5 <strtol+0x83>
        s += 2, base = 16;
  102cb8:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  102cbc:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  102cc3:	eb 2a                	jmp    102cef <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  102cc5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102cc9:	75 17                	jne    102ce2 <strtol+0xa0>
  102ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  102cce:	0f b6 00             	movzbl (%eax),%eax
  102cd1:	3c 30                	cmp    $0x30,%al
  102cd3:	75 0d                	jne    102ce2 <strtol+0xa0>
        s ++, base = 8;
  102cd5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102cd9:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  102ce0:	eb 0d                	jmp    102cef <strtol+0xad>
    }
    else if (base == 0) {
  102ce2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102ce6:	75 07                	jne    102cef <strtol+0xad>
        base = 10;
  102ce8:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  102cef:	8b 45 08             	mov    0x8(%ebp),%eax
  102cf2:	0f b6 00             	movzbl (%eax),%eax
  102cf5:	3c 2f                	cmp    $0x2f,%al
  102cf7:	7e 1b                	jle    102d14 <strtol+0xd2>
  102cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  102cfc:	0f b6 00             	movzbl (%eax),%eax
  102cff:	3c 39                	cmp    $0x39,%al
  102d01:	7f 11                	jg     102d14 <strtol+0xd2>
            dig = *s - '0';
  102d03:	8b 45 08             	mov    0x8(%ebp),%eax
  102d06:	0f b6 00             	movzbl (%eax),%eax
  102d09:	0f be c0             	movsbl %al,%eax
  102d0c:	83 e8 30             	sub    $0x30,%eax
  102d0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102d12:	eb 48                	jmp    102d5c <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  102d14:	8b 45 08             	mov    0x8(%ebp),%eax
  102d17:	0f b6 00             	movzbl (%eax),%eax
  102d1a:	3c 60                	cmp    $0x60,%al
  102d1c:	7e 1b                	jle    102d39 <strtol+0xf7>
  102d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  102d21:	0f b6 00             	movzbl (%eax),%eax
  102d24:	3c 7a                	cmp    $0x7a,%al
  102d26:	7f 11                	jg     102d39 <strtol+0xf7>
            dig = *s - 'a' + 10;
  102d28:	8b 45 08             	mov    0x8(%ebp),%eax
  102d2b:	0f b6 00             	movzbl (%eax),%eax
  102d2e:	0f be c0             	movsbl %al,%eax
  102d31:	83 e8 57             	sub    $0x57,%eax
  102d34:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102d37:	eb 23                	jmp    102d5c <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  102d39:	8b 45 08             	mov    0x8(%ebp),%eax
  102d3c:	0f b6 00             	movzbl (%eax),%eax
  102d3f:	3c 40                	cmp    $0x40,%al
  102d41:	7e 3d                	jle    102d80 <strtol+0x13e>
  102d43:	8b 45 08             	mov    0x8(%ebp),%eax
  102d46:	0f b6 00             	movzbl (%eax),%eax
  102d49:	3c 5a                	cmp    $0x5a,%al
  102d4b:	7f 33                	jg     102d80 <strtol+0x13e>
            dig = *s - 'A' + 10;
  102d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  102d50:	0f b6 00             	movzbl (%eax),%eax
  102d53:	0f be c0             	movsbl %al,%eax
  102d56:	83 e8 37             	sub    $0x37,%eax
  102d59:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  102d5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d5f:	3b 45 10             	cmp    0x10(%ebp),%eax
  102d62:	7c 02                	jl     102d66 <strtol+0x124>
            break;
  102d64:	eb 1a                	jmp    102d80 <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
  102d66:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102d6a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102d6d:	0f af 45 10          	imul   0x10(%ebp),%eax
  102d71:	89 c2                	mov    %eax,%edx
  102d73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d76:	01 d0                	add    %edx,%eax
  102d78:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  102d7b:	e9 6f ff ff ff       	jmp    102cef <strtol+0xad>

    if (endptr) {
  102d80:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102d84:	74 08                	je     102d8e <strtol+0x14c>
        *endptr = (char *) s;
  102d86:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d89:	8b 55 08             	mov    0x8(%ebp),%edx
  102d8c:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  102d8e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  102d92:	74 07                	je     102d9b <strtol+0x159>
  102d94:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102d97:	f7 d8                	neg    %eax
  102d99:	eb 03                	jmp    102d9e <strtol+0x15c>
  102d9b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  102d9e:	c9                   	leave  
  102d9f:	c3                   	ret    

00102da0 <memset>:
 * @n:        number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  102da0:	55                   	push   %ebp
  102da1:	89 e5                	mov    %esp,%ebp
  102da3:	57                   	push   %edi
  102da4:	83 ec 24             	sub    $0x24,%esp
  102da7:	8b 45 0c             	mov    0xc(%ebp),%eax
  102daa:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  102dad:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  102db1:	8b 55 08             	mov    0x8(%ebp),%edx
  102db4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  102db7:	88 45 f7             	mov    %al,-0x9(%ebp)
  102dba:	8b 45 10             	mov    0x10(%ebp),%eax
  102dbd:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  102dc0:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  102dc3:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  102dc7:	8b 55 f8             	mov    -0x8(%ebp),%edx
  102dca:	89 d7                	mov    %edx,%edi
  102dcc:	f3 aa                	rep stos %al,%es:(%edi)
  102dce:	89 fa                	mov    %edi,%edx
  102dd0:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  102dd3:	89 55 e8             	mov    %edx,-0x18(%ebp)
            "rep; stosb;"
            : "=&c" (d0), "=&D" (d1)
            : "0" (n), "a" (c), "1" (s)
            : "memory");
    return s;
  102dd6:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  102dd9:	83 c4 24             	add    $0x24,%esp
  102ddc:	5f                   	pop    %edi
  102ddd:	5d                   	pop    %ebp
  102dde:	c3                   	ret    

00102ddf <memmove>:
 * @n:        number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  102ddf:	55                   	push   %ebp
  102de0:	89 e5                	mov    %esp,%ebp
  102de2:	57                   	push   %edi
  102de3:	56                   	push   %esi
  102de4:	53                   	push   %ebx
  102de5:	83 ec 30             	sub    $0x30,%esp
  102de8:	8b 45 08             	mov    0x8(%ebp),%eax
  102deb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102dee:	8b 45 0c             	mov    0xc(%ebp),%eax
  102df1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102df4:	8b 45 10             	mov    0x10(%ebp),%eax
  102df7:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  102dfa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102dfd:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  102e00:	73 42                	jae    102e44 <memmove+0x65>
  102e02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e05:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102e08:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102e0b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102e0e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102e11:	89 45 dc             	mov    %eax,-0x24(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  102e14:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102e17:	c1 e8 02             	shr    $0x2,%eax
  102e1a:	89 c1                	mov    %eax,%ecx
    asm volatile (
  102e1c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102e1f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102e22:	89 d7                	mov    %edx,%edi
  102e24:	89 c6                	mov    %eax,%esi
  102e26:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  102e28:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  102e2b:	83 e1 03             	and    $0x3,%ecx
  102e2e:	74 02                	je     102e32 <memmove+0x53>
  102e30:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102e32:	89 f0                	mov    %esi,%eax
  102e34:	89 fa                	mov    %edi,%edx
  102e36:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  102e39:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102e3c:	89 45 d0             	mov    %eax,-0x30(%ebp)
            : "memory");
    return dst;
  102e3f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102e42:	eb 36                	jmp    102e7a <memmove+0x9b>
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  102e44:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102e47:	8d 50 ff             	lea    -0x1(%eax),%edx
  102e4a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102e4d:	01 c2                	add    %eax,%edx
  102e4f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102e52:	8d 48 ff             	lea    -0x1(%eax),%ecx
  102e55:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e58:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
  102e5b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102e5e:	89 c1                	mov    %eax,%ecx
  102e60:	89 d8                	mov    %ebx,%eax
  102e62:	89 d6                	mov    %edx,%esi
  102e64:	89 c7                	mov    %eax,%edi
  102e66:	fd                   	std    
  102e67:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102e69:	fc                   	cld    
  102e6a:	89 f8                	mov    %edi,%eax
  102e6c:	89 f2                	mov    %esi,%edx
  102e6e:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  102e71:	89 55 c8             	mov    %edx,-0x38(%ebp)
  102e74:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
  102e77:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  102e7a:	83 c4 30             	add    $0x30,%esp
  102e7d:	5b                   	pop    %ebx
  102e7e:	5e                   	pop    %esi
  102e7f:	5f                   	pop    %edi
  102e80:	5d                   	pop    %ebp
  102e81:	c3                   	ret    

00102e82 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  102e82:	55                   	push   %ebp
  102e83:	89 e5                	mov    %esp,%ebp
  102e85:	57                   	push   %edi
  102e86:	56                   	push   %esi
  102e87:	83 ec 20             	sub    $0x20,%esp
  102e8a:	8b 45 08             	mov    0x8(%ebp),%eax
  102e8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102e90:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e93:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102e96:	8b 45 10             	mov    0x10(%ebp),%eax
  102e99:	89 45 ec             	mov    %eax,-0x14(%ebp)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  102e9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102e9f:	c1 e8 02             	shr    $0x2,%eax
  102ea2:	89 c1                	mov    %eax,%ecx
    asm volatile (
  102ea4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102ea7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102eaa:	89 d7                	mov    %edx,%edi
  102eac:	89 c6                	mov    %eax,%esi
  102eae:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  102eb0:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  102eb3:	83 e1 03             	and    $0x3,%ecx
  102eb6:	74 02                	je     102eba <memcpy+0x38>
  102eb8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102eba:	89 f0                	mov    %esi,%eax
  102ebc:	89 fa                	mov    %edi,%edx
  102ebe:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  102ec1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  102ec4:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
  102ec7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  102eca:	83 c4 20             	add    $0x20,%esp
  102ecd:	5e                   	pop    %esi
  102ece:	5f                   	pop    %edi
  102ecf:	5d                   	pop    %ebp
  102ed0:	c3                   	ret    

00102ed1 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  102ed1:	55                   	push   %ebp
  102ed2:	89 e5                	mov    %esp,%ebp
  102ed4:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  102ed7:	8b 45 08             	mov    0x8(%ebp),%eax
  102eda:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  102edd:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ee0:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  102ee3:	eb 30                	jmp    102f15 <memcmp+0x44>
        if (*s1 != *s2) {
  102ee5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102ee8:	0f b6 10             	movzbl (%eax),%edx
  102eeb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102eee:	0f b6 00             	movzbl (%eax),%eax
  102ef1:	38 c2                	cmp    %al,%dl
  102ef3:	74 18                	je     102f0d <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  102ef5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102ef8:	0f b6 00             	movzbl (%eax),%eax
  102efb:	0f b6 d0             	movzbl %al,%edx
  102efe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102f01:	0f b6 00             	movzbl (%eax),%eax
  102f04:	0f b6 c0             	movzbl %al,%eax
  102f07:	29 c2                	sub    %eax,%edx
  102f09:	89 d0                	mov    %edx,%eax
  102f0b:	eb 1a                	jmp    102f27 <memcmp+0x56>
        }
        s1 ++, s2 ++;
  102f0d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  102f11:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
    while (n -- > 0) {
  102f15:	8b 45 10             	mov    0x10(%ebp),%eax
  102f18:	8d 50 ff             	lea    -0x1(%eax),%edx
  102f1b:	89 55 10             	mov    %edx,0x10(%ebp)
  102f1e:	85 c0                	test   %eax,%eax
  102f20:	75 c3                	jne    102ee5 <memcmp+0x14>
    }
    return 0;
  102f22:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102f27:	c9                   	leave  
  102f28:	c3                   	ret    

00102f29 <printnum>:
 * @width:         maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:        character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  102f29:	55                   	push   %ebp
  102f2a:	89 e5                	mov    %esp,%ebp
  102f2c:	83 ec 58             	sub    $0x58,%esp
  102f2f:	8b 45 10             	mov    0x10(%ebp),%eax
  102f32:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102f35:	8b 45 14             	mov    0x14(%ebp),%eax
  102f38:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  102f3b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102f3e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102f41:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102f44:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  102f47:	8b 45 18             	mov    0x18(%ebp),%eax
  102f4a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102f4d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102f50:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102f53:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102f56:	89 55 f0             	mov    %edx,-0x10(%ebp)
  102f59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f5c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102f5f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102f63:	74 1c                	je     102f81 <printnum+0x58>
  102f65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f68:	ba 00 00 00 00       	mov    $0x0,%edx
  102f6d:	f7 75 e4             	divl   -0x1c(%ebp)
  102f70:	89 55 f4             	mov    %edx,-0xc(%ebp)
  102f73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f76:	ba 00 00 00 00       	mov    $0x0,%edx
  102f7b:	f7 75 e4             	divl   -0x1c(%ebp)
  102f7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f81:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102f84:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102f87:	f7 75 e4             	divl   -0x1c(%ebp)
  102f8a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102f8d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  102f90:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102f93:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102f96:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102f99:	89 55 ec             	mov    %edx,-0x14(%ebp)
  102f9c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102f9f:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  102fa2:	8b 45 18             	mov    0x18(%ebp),%eax
  102fa5:	ba 00 00 00 00       	mov    $0x0,%edx
  102faa:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  102fad:	77 56                	ja     103005 <printnum+0xdc>
  102faf:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  102fb2:	72 05                	jb     102fb9 <printnum+0x90>
  102fb4:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  102fb7:	77 4c                	ja     103005 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
  102fb9:	8b 45 1c             	mov    0x1c(%ebp),%eax
  102fbc:	8d 50 ff             	lea    -0x1(%eax),%edx
  102fbf:	8b 45 20             	mov    0x20(%ebp),%eax
  102fc2:	89 44 24 18          	mov    %eax,0x18(%esp)
  102fc6:	89 54 24 14          	mov    %edx,0x14(%esp)
  102fca:	8b 45 18             	mov    0x18(%ebp),%eax
  102fcd:	89 44 24 10          	mov    %eax,0x10(%esp)
  102fd1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102fd4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102fd7:	89 44 24 08          	mov    %eax,0x8(%esp)
  102fdb:	89 54 24 0c          	mov    %edx,0xc(%esp)
  102fdf:	8b 45 0c             	mov    0xc(%ebp),%eax
  102fe2:	89 44 24 04          	mov    %eax,0x4(%esp)
  102fe6:	8b 45 08             	mov    0x8(%ebp),%eax
  102fe9:	89 04 24             	mov    %eax,(%esp)
  102fec:	e8 38 ff ff ff       	call   102f29 <printnum>
  102ff1:	eb 1c                	jmp    10300f <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  102ff3:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ff6:	89 44 24 04          	mov    %eax,0x4(%esp)
  102ffa:	8b 45 20             	mov    0x20(%ebp),%eax
  102ffd:	89 04 24             	mov    %eax,(%esp)
  103000:	8b 45 08             	mov    0x8(%ebp),%eax
  103003:	ff d0                	call   *%eax
        while (-- width > 0)
  103005:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  103009:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  10300d:	7f e4                	jg     102ff3 <printnum+0xca>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  10300f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103012:	05 70 3d 10 00       	add    $0x103d70,%eax
  103017:	0f b6 00             	movzbl (%eax),%eax
  10301a:	0f be c0             	movsbl %al,%eax
  10301d:	8b 55 0c             	mov    0xc(%ebp),%edx
  103020:	89 54 24 04          	mov    %edx,0x4(%esp)
  103024:	89 04 24             	mov    %eax,(%esp)
  103027:	8b 45 08             	mov    0x8(%ebp),%eax
  10302a:	ff d0                	call   *%eax
}
  10302c:	c9                   	leave  
  10302d:	c3                   	ret    

0010302e <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  10302e:	55                   	push   %ebp
  10302f:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  103031:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  103035:	7e 14                	jle    10304b <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  103037:	8b 45 08             	mov    0x8(%ebp),%eax
  10303a:	8b 00                	mov    (%eax),%eax
  10303c:	8d 48 08             	lea    0x8(%eax),%ecx
  10303f:	8b 55 08             	mov    0x8(%ebp),%edx
  103042:	89 0a                	mov    %ecx,(%edx)
  103044:	8b 50 04             	mov    0x4(%eax),%edx
  103047:	8b 00                	mov    (%eax),%eax
  103049:	eb 30                	jmp    10307b <getuint+0x4d>
    }
    else if (lflag) {
  10304b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  10304f:	74 16                	je     103067 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  103051:	8b 45 08             	mov    0x8(%ebp),%eax
  103054:	8b 00                	mov    (%eax),%eax
  103056:	8d 48 04             	lea    0x4(%eax),%ecx
  103059:	8b 55 08             	mov    0x8(%ebp),%edx
  10305c:	89 0a                	mov    %ecx,(%edx)
  10305e:	8b 00                	mov    (%eax),%eax
  103060:	ba 00 00 00 00       	mov    $0x0,%edx
  103065:	eb 14                	jmp    10307b <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  103067:	8b 45 08             	mov    0x8(%ebp),%eax
  10306a:	8b 00                	mov    (%eax),%eax
  10306c:	8d 48 04             	lea    0x4(%eax),%ecx
  10306f:	8b 55 08             	mov    0x8(%ebp),%edx
  103072:	89 0a                	mov    %ecx,(%edx)
  103074:	8b 00                	mov    (%eax),%eax
  103076:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  10307b:	5d                   	pop    %ebp
  10307c:	c3                   	ret    

0010307d <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  10307d:	55                   	push   %ebp
  10307e:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  103080:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  103084:	7e 14                	jle    10309a <getint+0x1d>
        return va_arg(*ap, long long);
  103086:	8b 45 08             	mov    0x8(%ebp),%eax
  103089:	8b 00                	mov    (%eax),%eax
  10308b:	8d 48 08             	lea    0x8(%eax),%ecx
  10308e:	8b 55 08             	mov    0x8(%ebp),%edx
  103091:	89 0a                	mov    %ecx,(%edx)
  103093:	8b 50 04             	mov    0x4(%eax),%edx
  103096:	8b 00                	mov    (%eax),%eax
  103098:	eb 28                	jmp    1030c2 <getint+0x45>
    }
    else if (lflag) {
  10309a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  10309e:	74 12                	je     1030b2 <getint+0x35>
        return va_arg(*ap, long);
  1030a0:	8b 45 08             	mov    0x8(%ebp),%eax
  1030a3:	8b 00                	mov    (%eax),%eax
  1030a5:	8d 48 04             	lea    0x4(%eax),%ecx
  1030a8:	8b 55 08             	mov    0x8(%ebp),%edx
  1030ab:	89 0a                	mov    %ecx,(%edx)
  1030ad:	8b 00                	mov    (%eax),%eax
  1030af:	99                   	cltd   
  1030b0:	eb 10                	jmp    1030c2 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  1030b2:	8b 45 08             	mov    0x8(%ebp),%eax
  1030b5:	8b 00                	mov    (%eax),%eax
  1030b7:	8d 48 04             	lea    0x4(%eax),%ecx
  1030ba:	8b 55 08             	mov    0x8(%ebp),%edx
  1030bd:	89 0a                	mov    %ecx,(%edx)
  1030bf:	8b 00                	mov    (%eax),%eax
  1030c1:	99                   	cltd   
    }
}
  1030c2:	5d                   	pop    %ebp
  1030c3:	c3                   	ret    

001030c4 <printfmt>:
 * @putch:        specified putch function, print a single character
 * @putdat:        used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  1030c4:	55                   	push   %ebp
  1030c5:	89 e5                	mov    %esp,%ebp
  1030c7:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  1030ca:	8d 45 14             	lea    0x14(%ebp),%eax
  1030cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  1030d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1030d3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1030d7:	8b 45 10             	mov    0x10(%ebp),%eax
  1030da:	89 44 24 08          	mov    %eax,0x8(%esp)
  1030de:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030e1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1030e5:	8b 45 08             	mov    0x8(%ebp),%eax
  1030e8:	89 04 24             	mov    %eax,(%esp)
  1030eb:	e8 02 00 00 00       	call   1030f2 <vprintfmt>
    va_end(ap);
}
  1030f0:	c9                   	leave  
  1030f1:	c3                   	ret    

001030f2 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  1030f2:	55                   	push   %ebp
  1030f3:	89 e5                	mov    %esp,%ebp
  1030f5:	56                   	push   %esi
  1030f6:	53                   	push   %ebx
  1030f7:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1030fa:	eb 18                	jmp    103114 <vprintfmt+0x22>
            if (ch == '\0') {
  1030fc:	85 db                	test   %ebx,%ebx
  1030fe:	75 05                	jne    103105 <vprintfmt+0x13>
                return;
  103100:	e9 d1 03 00 00       	jmp    1034d6 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
  103105:	8b 45 0c             	mov    0xc(%ebp),%eax
  103108:	89 44 24 04          	mov    %eax,0x4(%esp)
  10310c:	89 1c 24             	mov    %ebx,(%esp)
  10310f:	8b 45 08             	mov    0x8(%ebp),%eax
  103112:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  103114:	8b 45 10             	mov    0x10(%ebp),%eax
  103117:	8d 50 01             	lea    0x1(%eax),%edx
  10311a:	89 55 10             	mov    %edx,0x10(%ebp)
  10311d:	0f b6 00             	movzbl (%eax),%eax
  103120:	0f b6 d8             	movzbl %al,%ebx
  103123:	83 fb 25             	cmp    $0x25,%ebx
  103126:	75 d4                	jne    1030fc <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
  103128:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  10312c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  103133:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103136:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  103139:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103140:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103143:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  103146:	8b 45 10             	mov    0x10(%ebp),%eax
  103149:	8d 50 01             	lea    0x1(%eax),%edx
  10314c:	89 55 10             	mov    %edx,0x10(%ebp)
  10314f:	0f b6 00             	movzbl (%eax),%eax
  103152:	0f b6 d8             	movzbl %al,%ebx
  103155:	8d 43 dd             	lea    -0x23(%ebx),%eax
  103158:	83 f8 55             	cmp    $0x55,%eax
  10315b:	0f 87 44 03 00 00    	ja     1034a5 <vprintfmt+0x3b3>
  103161:	8b 04 85 94 3d 10 00 	mov    0x103d94(,%eax,4),%eax
  103168:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  10316a:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  10316e:	eb d6                	jmp    103146 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  103170:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  103174:	eb d0                	jmp    103146 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  103176:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  10317d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103180:	89 d0                	mov    %edx,%eax
  103182:	c1 e0 02             	shl    $0x2,%eax
  103185:	01 d0                	add    %edx,%eax
  103187:	01 c0                	add    %eax,%eax
  103189:	01 d8                	add    %ebx,%eax
  10318b:	83 e8 30             	sub    $0x30,%eax
  10318e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  103191:	8b 45 10             	mov    0x10(%ebp),%eax
  103194:	0f b6 00             	movzbl (%eax),%eax
  103197:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  10319a:	83 fb 2f             	cmp    $0x2f,%ebx
  10319d:	7e 0b                	jle    1031aa <vprintfmt+0xb8>
  10319f:	83 fb 39             	cmp    $0x39,%ebx
  1031a2:	7f 06                	jg     1031aa <vprintfmt+0xb8>
            for (precision = 0; ; ++ fmt) {
  1031a4:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                    break;
                }
            }
  1031a8:	eb d3                	jmp    10317d <vprintfmt+0x8b>
            goto process_precision;
  1031aa:	eb 33                	jmp    1031df <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
  1031ac:	8b 45 14             	mov    0x14(%ebp),%eax
  1031af:	8d 50 04             	lea    0x4(%eax),%edx
  1031b2:	89 55 14             	mov    %edx,0x14(%ebp)
  1031b5:	8b 00                	mov    (%eax),%eax
  1031b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  1031ba:	eb 23                	jmp    1031df <vprintfmt+0xed>

        case '.':
            if (width < 0)
  1031bc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1031c0:	79 0c                	jns    1031ce <vprintfmt+0xdc>
                width = 0;
  1031c2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  1031c9:	e9 78 ff ff ff       	jmp    103146 <vprintfmt+0x54>
  1031ce:	e9 73 ff ff ff       	jmp    103146 <vprintfmt+0x54>

        case '#':
            altflag = 1;
  1031d3:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  1031da:	e9 67 ff ff ff       	jmp    103146 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
  1031df:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1031e3:	79 12                	jns    1031f7 <vprintfmt+0x105>
                width = precision, precision = -1;
  1031e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1031e8:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1031eb:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  1031f2:	e9 4f ff ff ff       	jmp    103146 <vprintfmt+0x54>
  1031f7:	e9 4a ff ff ff       	jmp    103146 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  1031fc:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  103200:	e9 41 ff ff ff       	jmp    103146 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  103205:	8b 45 14             	mov    0x14(%ebp),%eax
  103208:	8d 50 04             	lea    0x4(%eax),%edx
  10320b:	89 55 14             	mov    %edx,0x14(%ebp)
  10320e:	8b 00                	mov    (%eax),%eax
  103210:	8b 55 0c             	mov    0xc(%ebp),%edx
  103213:	89 54 24 04          	mov    %edx,0x4(%esp)
  103217:	89 04 24             	mov    %eax,(%esp)
  10321a:	8b 45 08             	mov    0x8(%ebp),%eax
  10321d:	ff d0                	call   *%eax
            break;
  10321f:	e9 ac 02 00 00       	jmp    1034d0 <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
  103224:	8b 45 14             	mov    0x14(%ebp),%eax
  103227:	8d 50 04             	lea    0x4(%eax),%edx
  10322a:	89 55 14             	mov    %edx,0x14(%ebp)
  10322d:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  10322f:	85 db                	test   %ebx,%ebx
  103231:	79 02                	jns    103235 <vprintfmt+0x143>
                err = -err;
  103233:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  103235:	83 fb 06             	cmp    $0x6,%ebx
  103238:	7f 0b                	jg     103245 <vprintfmt+0x153>
  10323a:	8b 34 9d 54 3d 10 00 	mov    0x103d54(,%ebx,4),%esi
  103241:	85 f6                	test   %esi,%esi
  103243:	75 23                	jne    103268 <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
  103245:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  103249:	c7 44 24 08 81 3d 10 	movl   $0x103d81,0x8(%esp)
  103250:	00 
  103251:	8b 45 0c             	mov    0xc(%ebp),%eax
  103254:	89 44 24 04          	mov    %eax,0x4(%esp)
  103258:	8b 45 08             	mov    0x8(%ebp),%eax
  10325b:	89 04 24             	mov    %eax,(%esp)
  10325e:	e8 61 fe ff ff       	call   1030c4 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  103263:	e9 68 02 00 00       	jmp    1034d0 <vprintfmt+0x3de>
                printfmt(putch, putdat, "%s", p);
  103268:	89 74 24 0c          	mov    %esi,0xc(%esp)
  10326c:	c7 44 24 08 8a 3d 10 	movl   $0x103d8a,0x8(%esp)
  103273:	00 
  103274:	8b 45 0c             	mov    0xc(%ebp),%eax
  103277:	89 44 24 04          	mov    %eax,0x4(%esp)
  10327b:	8b 45 08             	mov    0x8(%ebp),%eax
  10327e:	89 04 24             	mov    %eax,(%esp)
  103281:	e8 3e fe ff ff       	call   1030c4 <printfmt>
            break;
  103286:	e9 45 02 00 00       	jmp    1034d0 <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  10328b:	8b 45 14             	mov    0x14(%ebp),%eax
  10328e:	8d 50 04             	lea    0x4(%eax),%edx
  103291:	89 55 14             	mov    %edx,0x14(%ebp)
  103294:	8b 30                	mov    (%eax),%esi
  103296:	85 f6                	test   %esi,%esi
  103298:	75 05                	jne    10329f <vprintfmt+0x1ad>
                p = "(null)";
  10329a:	be 8d 3d 10 00       	mov    $0x103d8d,%esi
            }
            if (width > 0 && padc != '-') {
  10329f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1032a3:	7e 3e                	jle    1032e3 <vprintfmt+0x1f1>
  1032a5:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  1032a9:	74 38                	je     1032e3 <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
  1032ab:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  1032ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1032b1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1032b5:	89 34 24             	mov    %esi,(%esp)
  1032b8:	e8 dc f7 ff ff       	call   102a99 <strnlen>
  1032bd:	29 c3                	sub    %eax,%ebx
  1032bf:	89 d8                	mov    %ebx,%eax
  1032c1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1032c4:	eb 17                	jmp    1032dd <vprintfmt+0x1eb>
                    putch(padc, putdat);
  1032c6:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  1032ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  1032cd:	89 54 24 04          	mov    %edx,0x4(%esp)
  1032d1:	89 04 24             	mov    %eax,(%esp)
  1032d4:	8b 45 08             	mov    0x8(%ebp),%eax
  1032d7:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
  1032d9:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  1032dd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1032e1:	7f e3                	jg     1032c6 <vprintfmt+0x1d4>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  1032e3:	eb 38                	jmp    10331d <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
  1032e5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  1032e9:	74 1f                	je     10330a <vprintfmt+0x218>
  1032eb:	83 fb 1f             	cmp    $0x1f,%ebx
  1032ee:	7e 05                	jle    1032f5 <vprintfmt+0x203>
  1032f0:	83 fb 7e             	cmp    $0x7e,%ebx
  1032f3:	7e 15                	jle    10330a <vprintfmt+0x218>
                    putch('?', putdat);
  1032f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1032f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1032fc:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  103303:	8b 45 08             	mov    0x8(%ebp),%eax
  103306:	ff d0                	call   *%eax
  103308:	eb 0f                	jmp    103319 <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
  10330a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10330d:	89 44 24 04          	mov    %eax,0x4(%esp)
  103311:	89 1c 24             	mov    %ebx,(%esp)
  103314:	8b 45 08             	mov    0x8(%ebp),%eax
  103317:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  103319:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  10331d:	89 f0                	mov    %esi,%eax
  10331f:	8d 70 01             	lea    0x1(%eax),%esi
  103322:	0f b6 00             	movzbl (%eax),%eax
  103325:	0f be d8             	movsbl %al,%ebx
  103328:	85 db                	test   %ebx,%ebx
  10332a:	74 10                	je     10333c <vprintfmt+0x24a>
  10332c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103330:	78 b3                	js     1032e5 <vprintfmt+0x1f3>
  103332:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  103336:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10333a:	79 a9                	jns    1032e5 <vprintfmt+0x1f3>
                }
            }
            for (; width > 0; width --) {
  10333c:	eb 17                	jmp    103355 <vprintfmt+0x263>
                putch(' ', putdat);
  10333e:	8b 45 0c             	mov    0xc(%ebp),%eax
  103341:	89 44 24 04          	mov    %eax,0x4(%esp)
  103345:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  10334c:	8b 45 08             	mov    0x8(%ebp),%eax
  10334f:	ff d0                	call   *%eax
            for (; width > 0; width --) {
  103351:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  103355:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103359:	7f e3                	jg     10333e <vprintfmt+0x24c>
            }
            break;
  10335b:	e9 70 01 00 00       	jmp    1034d0 <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  103360:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103363:	89 44 24 04          	mov    %eax,0x4(%esp)
  103367:	8d 45 14             	lea    0x14(%ebp),%eax
  10336a:	89 04 24             	mov    %eax,(%esp)
  10336d:	e8 0b fd ff ff       	call   10307d <getint>
  103372:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103375:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  103378:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10337b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10337e:	85 d2                	test   %edx,%edx
  103380:	79 26                	jns    1033a8 <vprintfmt+0x2b6>
                putch('-', putdat);
  103382:	8b 45 0c             	mov    0xc(%ebp),%eax
  103385:	89 44 24 04          	mov    %eax,0x4(%esp)
  103389:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  103390:	8b 45 08             	mov    0x8(%ebp),%eax
  103393:	ff d0                	call   *%eax
                num = -(long long)num;
  103395:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103398:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10339b:	f7 d8                	neg    %eax
  10339d:	83 d2 00             	adc    $0x0,%edx
  1033a0:	f7 da                	neg    %edx
  1033a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1033a5:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  1033a8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1033af:	e9 a8 00 00 00       	jmp    10345c <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  1033b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1033b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1033bb:	8d 45 14             	lea    0x14(%ebp),%eax
  1033be:	89 04 24             	mov    %eax,(%esp)
  1033c1:	e8 68 fc ff ff       	call   10302e <getuint>
  1033c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1033c9:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  1033cc:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1033d3:	e9 84 00 00 00       	jmp    10345c <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  1033d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1033db:	89 44 24 04          	mov    %eax,0x4(%esp)
  1033df:	8d 45 14             	lea    0x14(%ebp),%eax
  1033e2:	89 04 24             	mov    %eax,(%esp)
  1033e5:	e8 44 fc ff ff       	call   10302e <getuint>
  1033ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1033ed:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  1033f0:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  1033f7:	eb 63                	jmp    10345c <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
  1033f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1033fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  103400:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  103407:	8b 45 08             	mov    0x8(%ebp),%eax
  10340a:	ff d0                	call   *%eax
            putch('x', putdat);
  10340c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10340f:	89 44 24 04          	mov    %eax,0x4(%esp)
  103413:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  10341a:	8b 45 08             	mov    0x8(%ebp),%eax
  10341d:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  10341f:	8b 45 14             	mov    0x14(%ebp),%eax
  103422:	8d 50 04             	lea    0x4(%eax),%edx
  103425:	89 55 14             	mov    %edx,0x14(%ebp)
  103428:	8b 00                	mov    (%eax),%eax
  10342a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10342d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  103434:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  10343b:	eb 1f                	jmp    10345c <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  10343d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103440:	89 44 24 04          	mov    %eax,0x4(%esp)
  103444:	8d 45 14             	lea    0x14(%ebp),%eax
  103447:	89 04 24             	mov    %eax,(%esp)
  10344a:	e8 df fb ff ff       	call   10302e <getuint>
  10344f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103452:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  103455:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  10345c:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  103460:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103463:	89 54 24 18          	mov    %edx,0x18(%esp)
  103467:	8b 55 e8             	mov    -0x18(%ebp),%edx
  10346a:	89 54 24 14          	mov    %edx,0x14(%esp)
  10346e:	89 44 24 10          	mov    %eax,0x10(%esp)
  103472:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103475:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103478:	89 44 24 08          	mov    %eax,0x8(%esp)
  10347c:	89 54 24 0c          	mov    %edx,0xc(%esp)
  103480:	8b 45 0c             	mov    0xc(%ebp),%eax
  103483:	89 44 24 04          	mov    %eax,0x4(%esp)
  103487:	8b 45 08             	mov    0x8(%ebp),%eax
  10348a:	89 04 24             	mov    %eax,(%esp)
  10348d:	e8 97 fa ff ff       	call   102f29 <printnum>
            break;
  103492:	eb 3c                	jmp    1034d0 <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  103494:	8b 45 0c             	mov    0xc(%ebp),%eax
  103497:	89 44 24 04          	mov    %eax,0x4(%esp)
  10349b:	89 1c 24             	mov    %ebx,(%esp)
  10349e:	8b 45 08             	mov    0x8(%ebp),%eax
  1034a1:	ff d0                	call   *%eax
            break;
  1034a3:	eb 2b                	jmp    1034d0 <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  1034a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1034ac:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  1034b3:	8b 45 08             	mov    0x8(%ebp),%eax
  1034b6:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  1034b8:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  1034bc:	eb 04                	jmp    1034c2 <vprintfmt+0x3d0>
  1034be:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  1034c2:	8b 45 10             	mov    0x10(%ebp),%eax
  1034c5:	83 e8 01             	sub    $0x1,%eax
  1034c8:	0f b6 00             	movzbl (%eax),%eax
  1034cb:	3c 25                	cmp    $0x25,%al
  1034cd:	75 ef                	jne    1034be <vprintfmt+0x3cc>
                /* do nothing */;
            break;
  1034cf:	90                   	nop
        }
    }
  1034d0:	90                   	nop
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1034d1:	e9 3e fc ff ff       	jmp    103114 <vprintfmt+0x22>
}
  1034d6:	83 c4 40             	add    $0x40,%esp
  1034d9:	5b                   	pop    %ebx
  1034da:	5e                   	pop    %esi
  1034db:	5d                   	pop    %ebp
  1034dc:	c3                   	ret    

001034dd <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:            the character will be printed
 * @b:            the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  1034dd:	55                   	push   %ebp
  1034de:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  1034e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034e3:	8b 40 08             	mov    0x8(%eax),%eax
  1034e6:	8d 50 01             	lea    0x1(%eax),%edx
  1034e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034ec:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  1034ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034f2:	8b 10                	mov    (%eax),%edx
  1034f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034f7:	8b 40 04             	mov    0x4(%eax),%eax
  1034fa:	39 c2                	cmp    %eax,%edx
  1034fc:	73 12                	jae    103510 <sprintputch+0x33>
        *b->buf ++ = ch;
  1034fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  103501:	8b 00                	mov    (%eax),%eax
  103503:	8d 48 01             	lea    0x1(%eax),%ecx
  103506:	8b 55 0c             	mov    0xc(%ebp),%edx
  103509:	89 0a                	mov    %ecx,(%edx)
  10350b:	8b 55 08             	mov    0x8(%ebp),%edx
  10350e:	88 10                	mov    %dl,(%eax)
    }
}
  103510:	5d                   	pop    %ebp
  103511:	c3                   	ret    

00103512 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:        the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  103512:	55                   	push   %ebp
  103513:	89 e5                	mov    %esp,%ebp
  103515:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  103518:	8d 45 14             	lea    0x14(%ebp),%eax
  10351b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  10351e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103521:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103525:	8b 45 10             	mov    0x10(%ebp),%eax
  103528:	89 44 24 08          	mov    %eax,0x8(%esp)
  10352c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10352f:	89 44 24 04          	mov    %eax,0x4(%esp)
  103533:	8b 45 08             	mov    0x8(%ebp),%eax
  103536:	89 04 24             	mov    %eax,(%esp)
  103539:	e8 08 00 00 00       	call   103546 <vsnprintf>
  10353e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  103541:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103544:	c9                   	leave  
  103545:	c3                   	ret    

00103546 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  103546:	55                   	push   %ebp
  103547:	89 e5                	mov    %esp,%ebp
  103549:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  10354c:	8b 45 08             	mov    0x8(%ebp),%eax
  10354f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103552:	8b 45 0c             	mov    0xc(%ebp),%eax
  103555:	8d 50 ff             	lea    -0x1(%eax),%edx
  103558:	8b 45 08             	mov    0x8(%ebp),%eax
  10355b:	01 d0                	add    %edx,%eax
  10355d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103560:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  103567:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  10356b:	74 0a                	je     103577 <vsnprintf+0x31>
  10356d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  103570:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103573:	39 c2                	cmp    %eax,%edx
  103575:	76 07                	jbe    10357e <vsnprintf+0x38>
        return -E_INVAL;
  103577:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  10357c:	eb 2a                	jmp    1035a8 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  10357e:	8b 45 14             	mov    0x14(%ebp),%eax
  103581:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103585:	8b 45 10             	mov    0x10(%ebp),%eax
  103588:	89 44 24 08          	mov    %eax,0x8(%esp)
  10358c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  10358f:	89 44 24 04          	mov    %eax,0x4(%esp)
  103593:	c7 04 24 dd 34 10 00 	movl   $0x1034dd,(%esp)
  10359a:	e8 53 fb ff ff       	call   1030f2 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  10359f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1035a2:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  1035a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1035a8:	c9                   	leave  
  1035a9:	c3                   	ret    
