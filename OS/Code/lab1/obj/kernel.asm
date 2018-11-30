
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
  100006:	ba 20 fd 10 00       	mov    $0x10fd20,%edx
  10000b:	b8 16 ea 10 00       	mov    $0x10ea16,%eax
  100010:	29 c2                	sub    %eax,%edx
  100012:	89 d0                	mov    %edx,%eax
  100014:	89 44 24 08          	mov    %eax,0x8(%esp)
  100018:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10001f:	00 
  100020:	c7 04 24 16 ea 10 00 	movl   $0x10ea16,(%esp)
  100027:	e8 a0 2a 00 00       	call   102acc <memset>

    cons_init();                // init the console
  10002c:	e8 45 15 00 00       	call   101576 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100031:	c7 45 f4 e0 32 10 00 	movl   $0x1032e0,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10003b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10003f:	c7 04 24 fc 32 10 00 	movl   $0x1032fc,(%esp)
  100046:	e8 11 02 00 00       	call   10025c <cprintf>

    print_kerninfo();
  10004b:	e8 c3 08 00 00       	call   100913 <print_kerninfo>

    grade_backtrace();
  100050:	e8 86 00 00 00       	call   1000db <grade_backtrace>

    pmm_init();                 // init physical memory management
  100055:	e8 39 27 00 00       	call   102793 <pmm_init>

    pic_init();                 // init interrupt controller
  10005a:	e8 4e 16 00 00       	call   1016ad <pic_init>
    idt_init();                 // init interrupt descriptor table
  10005f:	e8 ac 17 00 00       	call   101810 <idt_init>

    clock_init();               // init clock interrupt
  100064:	e8 00 0d 00 00       	call   100d69 <clock_init>
    intr_enable();              // enable irq interrupt
  100069:	e8 7a 17 00 00       	call   1017e8 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
  10006e:	eb fe                	jmp    10006e <kern_init+0x6e>

00100070 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  100070:	55                   	push   %ebp
  100071:	89 e5                	mov    %esp,%ebp
  100073:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  100076:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10007d:	00 
  10007e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100085:	00 
  100086:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10008d:	e8 c5 0c 00 00       	call   100d57 <mon_backtrace>
}
  100092:	c9                   	leave  
  100093:	c3                   	ret    

00100094 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  100094:	55                   	push   %ebp
  100095:	89 e5                	mov    %esp,%ebp
  100097:	53                   	push   %ebx
  100098:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  10009b:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  10009e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  1000a1:	8d 55 08             	lea    0x8(%ebp),%edx
  1000a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1000a7:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1000ab:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1000af:	89 54 24 04          	mov    %edx,0x4(%esp)
  1000b3:	89 04 24             	mov    %eax,(%esp)
  1000b6:	e8 b5 ff ff ff       	call   100070 <grade_backtrace2>
}
  1000bb:	83 c4 14             	add    $0x14,%esp
  1000be:	5b                   	pop    %ebx
  1000bf:	5d                   	pop    %ebp
  1000c0:	c3                   	ret    

001000c1 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000c1:	55                   	push   %ebp
  1000c2:	89 e5                	mov    %esp,%ebp
  1000c4:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000c7:	8b 45 10             	mov    0x10(%ebp),%eax
  1000ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1000d1:	89 04 24             	mov    %eax,(%esp)
  1000d4:	e8 bb ff ff ff       	call   100094 <grade_backtrace1>
}
  1000d9:	c9                   	leave  
  1000da:	c3                   	ret    

001000db <grade_backtrace>:

void
grade_backtrace(void) {
  1000db:	55                   	push   %ebp
  1000dc:	89 e5                	mov    %esp,%ebp
  1000de:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  1000e1:	b8 00 00 10 00       	mov    $0x100000,%eax
  1000e6:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  1000ed:	ff 
  1000ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000f2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000f9:	e8 c3 ff ff ff       	call   1000c1 <grade_backtrace0>
}
  1000fe:	c9                   	leave  
  1000ff:	c3                   	ret    

00100100 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  100100:	55                   	push   %ebp
  100101:	89 e5                	mov    %esp,%ebp
  100103:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  100106:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100109:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  10010c:	8c 45 f2             	mov    %es,-0xe(%ebp)
  10010f:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  100112:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100116:	0f b7 c0             	movzwl %ax,%eax
  100119:	83 e0 03             	and    $0x3,%eax
  10011c:	89 c2                	mov    %eax,%edx
  10011e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100123:	89 54 24 08          	mov    %edx,0x8(%esp)
  100127:	89 44 24 04          	mov    %eax,0x4(%esp)
  10012b:	c7 04 24 01 33 10 00 	movl   $0x103301,(%esp)
  100132:	e8 25 01 00 00       	call   10025c <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100137:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10013b:	0f b7 d0             	movzwl %ax,%edx
  10013e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100143:	89 54 24 08          	mov    %edx,0x8(%esp)
  100147:	89 44 24 04          	mov    %eax,0x4(%esp)
  10014b:	c7 04 24 0f 33 10 00 	movl   $0x10330f,(%esp)
  100152:	e8 05 01 00 00       	call   10025c <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  100157:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  10015b:	0f b7 d0             	movzwl %ax,%edx
  10015e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100163:	89 54 24 08          	mov    %edx,0x8(%esp)
  100167:	89 44 24 04          	mov    %eax,0x4(%esp)
  10016b:	c7 04 24 1d 33 10 00 	movl   $0x10331d,(%esp)
  100172:	e8 e5 00 00 00       	call   10025c <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  100177:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  10017b:	0f b7 d0             	movzwl %ax,%edx
  10017e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100183:	89 54 24 08          	mov    %edx,0x8(%esp)
  100187:	89 44 24 04          	mov    %eax,0x4(%esp)
  10018b:	c7 04 24 2b 33 10 00 	movl   $0x10332b,(%esp)
  100192:	e8 c5 00 00 00       	call   10025c <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  100197:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  10019b:	0f b7 d0             	movzwl %ax,%edx
  10019e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  1001a3:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001ab:	c7 04 24 39 33 10 00 	movl   $0x103339,(%esp)
  1001b2:	e8 a5 00 00 00       	call   10025c <cprintf>
    round ++;
  1001b7:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  1001bc:	83 c0 01             	add    $0x1,%eax
  1001bf:	a3 20 ea 10 00       	mov    %eax,0x10ea20
}
  1001c4:	c9                   	leave  
  1001c5:	c3                   	ret    

001001c6 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001c6:	55                   	push   %ebp
  1001c7:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
  1001c9:	5d                   	pop    %ebp
  1001ca:	c3                   	ret    

001001cb <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001cb:	55                   	push   %ebp
  1001cc:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
  1001ce:	5d                   	pop    %ebp
  1001cf:	c3                   	ret    

001001d0 <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001d0:	55                   	push   %ebp
  1001d1:	89 e5                	mov    %esp,%ebp
  1001d3:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  1001d6:	e8 25 ff ff ff       	call   100100 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  1001db:	c7 04 24 48 33 10 00 	movl   $0x103348,(%esp)
  1001e2:	e8 75 00 00 00       	call   10025c <cprintf>
    lab1_switch_to_user();
  1001e7:	e8 da ff ff ff       	call   1001c6 <lab1_switch_to_user>
    lab1_print_cur_status();
  1001ec:	e8 0f ff ff ff       	call   100100 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  1001f1:	c7 04 24 68 33 10 00 	movl   $0x103368,(%esp)
  1001f8:	e8 5f 00 00 00       	call   10025c <cprintf>
    lab1_switch_to_kernel();
  1001fd:	e8 c9 ff ff ff       	call   1001cb <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100202:	e8 f9 fe ff ff       	call   100100 <lab1_print_cur_status>
}
  100207:	c9                   	leave  
  100208:	c3                   	ret    

00100209 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  100209:	55                   	push   %ebp
  10020a:	89 e5                	mov    %esp,%ebp
  10020c:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  10020f:	8b 45 08             	mov    0x8(%ebp),%eax
  100212:	89 04 24             	mov    %eax,(%esp)
  100215:	e8 88 13 00 00       	call   1015a2 <cons_putc>
    (*cnt) ++;
  10021a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10021d:	8b 00                	mov    (%eax),%eax
  10021f:	8d 50 01             	lea    0x1(%eax),%edx
  100222:	8b 45 0c             	mov    0xc(%ebp),%eax
  100225:	89 10                	mov    %edx,(%eax)
}
  100227:	c9                   	leave  
  100228:	c3                   	ret    

00100229 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  100229:	55                   	push   %ebp
  10022a:	89 e5                	mov    %esp,%ebp
  10022c:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  10022f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  100236:	8b 45 0c             	mov    0xc(%ebp),%eax
  100239:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10023d:	8b 45 08             	mov    0x8(%ebp),%eax
  100240:	89 44 24 08          	mov    %eax,0x8(%esp)
  100244:	8d 45 f4             	lea    -0xc(%ebp),%eax
  100247:	89 44 24 04          	mov    %eax,0x4(%esp)
  10024b:	c7 04 24 09 02 10 00 	movl   $0x100209,(%esp)
  100252:	e8 c7 2b 00 00       	call   102e1e <vprintfmt>
    return cnt;
  100257:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10025a:	c9                   	leave  
  10025b:	c3                   	ret    

0010025c <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  10025c:	55                   	push   %ebp
  10025d:	89 e5                	mov    %esp,%ebp
  10025f:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100262:	8d 45 0c             	lea    0xc(%ebp),%eax
  100265:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  100268:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10026b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10026f:	8b 45 08             	mov    0x8(%ebp),%eax
  100272:	89 04 24             	mov    %eax,(%esp)
  100275:	e8 af ff ff ff       	call   100229 <vcprintf>
  10027a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  10027d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100280:	c9                   	leave  
  100281:	c3                   	ret    

00100282 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  100282:	55                   	push   %ebp
  100283:	89 e5                	mov    %esp,%ebp
  100285:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  100288:	8b 45 08             	mov    0x8(%ebp),%eax
  10028b:	89 04 24             	mov    %eax,(%esp)
  10028e:	e8 0f 13 00 00       	call   1015a2 <cons_putc>
}
  100293:	c9                   	leave  
  100294:	c3                   	ret    

00100295 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  100295:	55                   	push   %ebp
  100296:	89 e5                	mov    %esp,%ebp
  100298:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  10029b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  1002a2:	eb 13                	jmp    1002b7 <cputs+0x22>
        cputch(c, &cnt);
  1002a4:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  1002a8:	8d 55 f0             	lea    -0x10(%ebp),%edx
  1002ab:	89 54 24 04          	mov    %edx,0x4(%esp)
  1002af:	89 04 24             	mov    %eax,(%esp)
  1002b2:	e8 52 ff ff ff       	call   100209 <cputch>
    while ((c = *str ++) != '\0') {
  1002b7:	8b 45 08             	mov    0x8(%ebp),%eax
  1002ba:	8d 50 01             	lea    0x1(%eax),%edx
  1002bd:	89 55 08             	mov    %edx,0x8(%ebp)
  1002c0:	0f b6 00             	movzbl (%eax),%eax
  1002c3:	88 45 f7             	mov    %al,-0x9(%ebp)
  1002c6:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1002ca:	75 d8                	jne    1002a4 <cputs+0xf>
    }
    cputch('\n', &cnt);
  1002cc:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1002cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  1002d3:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  1002da:	e8 2a ff ff ff       	call   100209 <cputch>
    return cnt;
  1002df:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1002e2:	c9                   	leave  
  1002e3:	c3                   	ret    

001002e4 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1002e4:	55                   	push   %ebp
  1002e5:	89 e5                	mov    %esp,%ebp
  1002e7:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1002ea:	e8 dc 12 00 00       	call   1015cb <cons_getc>
  1002ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1002f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1002f6:	74 f2                	je     1002ea <getchar+0x6>
        /* do nothing */;
    return c;
  1002f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1002fb:	c9                   	leave  
  1002fc:	c3                   	ret    

001002fd <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  1002fd:	55                   	push   %ebp
  1002fe:	89 e5                	mov    %esp,%ebp
  100300:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  100303:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100307:	74 13                	je     10031c <readline+0x1f>
        cprintf("%s", prompt);
  100309:	8b 45 08             	mov    0x8(%ebp),%eax
  10030c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100310:	c7 04 24 87 33 10 00 	movl   $0x103387,(%esp)
  100317:	e8 40 ff ff ff       	call   10025c <cprintf>
    }
    int i = 0, c;
  10031c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100323:	e8 bc ff ff ff       	call   1002e4 <getchar>
  100328:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  10032b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10032f:	79 07                	jns    100338 <readline+0x3b>
            return NULL;
  100331:	b8 00 00 00 00       	mov    $0x0,%eax
  100336:	eb 79                	jmp    1003b1 <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  100338:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  10033c:	7e 28                	jle    100366 <readline+0x69>
  10033e:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  100345:	7f 1f                	jg     100366 <readline+0x69>
            cputchar(c);
  100347:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10034a:	89 04 24             	mov    %eax,(%esp)
  10034d:	e8 30 ff ff ff       	call   100282 <cputchar>
            buf[i ++] = c;
  100352:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100355:	8d 50 01             	lea    0x1(%eax),%edx
  100358:	89 55 f4             	mov    %edx,-0xc(%ebp)
  10035b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10035e:	88 90 40 ea 10 00    	mov    %dl,0x10ea40(%eax)
  100364:	eb 46                	jmp    1003ac <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
  100366:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  10036a:	75 17                	jne    100383 <readline+0x86>
  10036c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100370:	7e 11                	jle    100383 <readline+0x86>
            cputchar(c);
  100372:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100375:	89 04 24             	mov    %eax,(%esp)
  100378:	e8 05 ff ff ff       	call   100282 <cputchar>
            i --;
  10037d:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  100381:	eb 29                	jmp    1003ac <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
  100383:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  100387:	74 06                	je     10038f <readline+0x92>
  100389:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  10038d:	75 1d                	jne    1003ac <readline+0xaf>
            cputchar(c);
  10038f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100392:	89 04 24             	mov    %eax,(%esp)
  100395:	e8 e8 fe ff ff       	call   100282 <cputchar>
            buf[i] = '\0';
  10039a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10039d:	05 40 ea 10 00       	add    $0x10ea40,%eax
  1003a2:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1003a5:	b8 40 ea 10 00       	mov    $0x10ea40,%eax
  1003aa:	eb 05                	jmp    1003b1 <readline+0xb4>
        }
    }
  1003ac:	e9 72 ff ff ff       	jmp    100323 <readline+0x26>
}
  1003b1:	c9                   	leave  
  1003b2:	c3                   	ret    

001003b3 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  1003b3:	55                   	push   %ebp
  1003b4:	89 e5                	mov    %esp,%ebp
  1003b6:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  1003b9:	a1 40 ee 10 00       	mov    0x10ee40,%eax
  1003be:	85 c0                	test   %eax,%eax
  1003c0:	74 02                	je     1003c4 <__panic+0x11>
        goto panic_dead;
  1003c2:	eb 59                	jmp    10041d <__panic+0x6a>
    }
    is_panic = 1;
  1003c4:	c7 05 40 ee 10 00 01 	movl   $0x1,0x10ee40
  1003cb:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  1003ce:	8d 45 14             	lea    0x14(%ebp),%eax
  1003d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  1003d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1003d7:	89 44 24 08          	mov    %eax,0x8(%esp)
  1003db:	8b 45 08             	mov    0x8(%ebp),%eax
  1003de:	89 44 24 04          	mov    %eax,0x4(%esp)
  1003e2:	c7 04 24 8a 33 10 00 	movl   $0x10338a,(%esp)
  1003e9:	e8 6e fe ff ff       	call   10025c <cprintf>
    vcprintf(fmt, ap);
  1003ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1003f1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1003f5:	8b 45 10             	mov    0x10(%ebp),%eax
  1003f8:	89 04 24             	mov    %eax,(%esp)
  1003fb:	e8 29 fe ff ff       	call   100229 <vcprintf>
    cprintf("\n");
  100400:	c7 04 24 a6 33 10 00 	movl   $0x1033a6,(%esp)
  100407:	e8 50 fe ff ff       	call   10025c <cprintf>
    
    cprintf("stack trackback:\n");
  10040c:	c7 04 24 a8 33 10 00 	movl   $0x1033a8,(%esp)
  100413:	e8 44 fe ff ff       	call   10025c <cprintf>
    print_stackframe();
  100418:	e8 40 06 00 00       	call   100a5d <print_stackframe>
    
    va_end(ap);

panic_dead:
    intr_disable();
  10041d:	e8 cc 13 00 00       	call   1017ee <intr_disable>
    while (1) {
        kmonitor(NULL);
  100422:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100429:	e8 5a 08 00 00       	call   100c88 <kmonitor>
    }
  10042e:	eb f2                	jmp    100422 <__panic+0x6f>

00100430 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100430:	55                   	push   %ebp
  100431:	89 e5                	mov    %esp,%ebp
  100433:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100436:	8d 45 14             	lea    0x14(%ebp),%eax
  100439:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  10043c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10043f:	89 44 24 08          	mov    %eax,0x8(%esp)
  100443:	8b 45 08             	mov    0x8(%ebp),%eax
  100446:	89 44 24 04          	mov    %eax,0x4(%esp)
  10044a:	c7 04 24 ba 33 10 00 	movl   $0x1033ba,(%esp)
  100451:	e8 06 fe ff ff       	call   10025c <cprintf>
    vcprintf(fmt, ap);
  100456:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100459:	89 44 24 04          	mov    %eax,0x4(%esp)
  10045d:	8b 45 10             	mov    0x10(%ebp),%eax
  100460:	89 04 24             	mov    %eax,(%esp)
  100463:	e8 c1 fd ff ff       	call   100229 <vcprintf>
    cprintf("\n");
  100468:	c7 04 24 a6 33 10 00 	movl   $0x1033a6,(%esp)
  10046f:	e8 e8 fd ff ff       	call   10025c <cprintf>
    va_end(ap);
}
  100474:	c9                   	leave  
  100475:	c3                   	ret    

00100476 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100476:	55                   	push   %ebp
  100477:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100479:	a1 40 ee 10 00       	mov    0x10ee40,%eax
}
  10047e:	5d                   	pop    %ebp
  10047f:	c3                   	ret    

00100480 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  100480:	55                   	push   %ebp
  100481:	89 e5                	mov    %esp,%ebp
  100483:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  100486:	8b 45 0c             	mov    0xc(%ebp),%eax
  100489:	8b 00                	mov    (%eax),%eax
  10048b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  10048e:	8b 45 10             	mov    0x10(%ebp),%eax
  100491:	8b 00                	mov    (%eax),%eax
  100493:	89 45 f8             	mov    %eax,-0x8(%ebp)
  100496:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  10049d:	e9 d2 00 00 00       	jmp    100574 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
  1004a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1004a5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1004a8:	01 d0                	add    %edx,%eax
  1004aa:	89 c2                	mov    %eax,%edx
  1004ac:	c1 ea 1f             	shr    $0x1f,%edx
  1004af:	01 d0                	add    %edx,%eax
  1004b1:	d1 f8                	sar    %eax
  1004b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1004b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1004b9:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1004bc:	eb 04                	jmp    1004c2 <stab_binsearch+0x42>
            m --;
  1004be:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
  1004c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004c5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004c8:	7c 1f                	jl     1004e9 <stab_binsearch+0x69>
  1004ca:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004cd:	89 d0                	mov    %edx,%eax
  1004cf:	01 c0                	add    %eax,%eax
  1004d1:	01 d0                	add    %edx,%eax
  1004d3:	c1 e0 02             	shl    $0x2,%eax
  1004d6:	89 c2                	mov    %eax,%edx
  1004d8:	8b 45 08             	mov    0x8(%ebp),%eax
  1004db:	01 d0                	add    %edx,%eax
  1004dd:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1004e1:	0f b6 c0             	movzbl %al,%eax
  1004e4:	3b 45 14             	cmp    0x14(%ebp),%eax
  1004e7:	75 d5                	jne    1004be <stab_binsearch+0x3e>
        }
        if (m < l) {    // no match in [l, m]
  1004e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004ec:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004ef:	7d 0b                	jge    1004fc <stab_binsearch+0x7c>
            l = true_m + 1;
  1004f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1004f4:	83 c0 01             	add    $0x1,%eax
  1004f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  1004fa:	eb 78                	jmp    100574 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
  1004fc:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100503:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100506:	89 d0                	mov    %edx,%eax
  100508:	01 c0                	add    %eax,%eax
  10050a:	01 d0                	add    %edx,%eax
  10050c:	c1 e0 02             	shl    $0x2,%eax
  10050f:	89 c2                	mov    %eax,%edx
  100511:	8b 45 08             	mov    0x8(%ebp),%eax
  100514:	01 d0                	add    %edx,%eax
  100516:	8b 40 08             	mov    0x8(%eax),%eax
  100519:	3b 45 18             	cmp    0x18(%ebp),%eax
  10051c:	73 13                	jae    100531 <stab_binsearch+0xb1>
            *region_left = m;
  10051e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100521:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100524:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100526:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100529:	83 c0 01             	add    $0x1,%eax
  10052c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  10052f:	eb 43                	jmp    100574 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
  100531:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100534:	89 d0                	mov    %edx,%eax
  100536:	01 c0                	add    %eax,%eax
  100538:	01 d0                	add    %edx,%eax
  10053a:	c1 e0 02             	shl    $0x2,%eax
  10053d:	89 c2                	mov    %eax,%edx
  10053f:	8b 45 08             	mov    0x8(%ebp),%eax
  100542:	01 d0                	add    %edx,%eax
  100544:	8b 40 08             	mov    0x8(%eax),%eax
  100547:	3b 45 18             	cmp    0x18(%ebp),%eax
  10054a:	76 16                	jbe    100562 <stab_binsearch+0xe2>
            *region_right = m - 1;
  10054c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10054f:	8d 50 ff             	lea    -0x1(%eax),%edx
  100552:	8b 45 10             	mov    0x10(%ebp),%eax
  100555:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  100557:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10055a:	83 e8 01             	sub    $0x1,%eax
  10055d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  100560:	eb 12                	jmp    100574 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  100562:	8b 45 0c             	mov    0xc(%ebp),%eax
  100565:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100568:	89 10                	mov    %edx,(%eax)
            l = m;
  10056a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10056d:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  100570:	83 45 18 01          	addl   $0x1,0x18(%ebp)
    while (l <= r) {
  100574:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100577:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  10057a:	0f 8e 22 ff ff ff    	jle    1004a2 <stab_binsearch+0x22>
        }
    }

    if (!any_matches) {
  100580:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100584:	75 0f                	jne    100595 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
  100586:	8b 45 0c             	mov    0xc(%ebp),%eax
  100589:	8b 00                	mov    (%eax),%eax
  10058b:	8d 50 ff             	lea    -0x1(%eax),%edx
  10058e:	8b 45 10             	mov    0x10(%ebp),%eax
  100591:	89 10                	mov    %edx,(%eax)
  100593:	eb 3f                	jmp    1005d4 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
  100595:	8b 45 10             	mov    0x10(%ebp),%eax
  100598:	8b 00                	mov    (%eax),%eax
  10059a:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  10059d:	eb 04                	jmp    1005a3 <stab_binsearch+0x123>
  10059f:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  1005a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005a6:	8b 00                	mov    (%eax),%eax
  1005a8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1005ab:	7d 1f                	jge    1005cc <stab_binsearch+0x14c>
  1005ad:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1005b0:	89 d0                	mov    %edx,%eax
  1005b2:	01 c0                	add    %eax,%eax
  1005b4:	01 d0                	add    %edx,%eax
  1005b6:	c1 e0 02             	shl    $0x2,%eax
  1005b9:	89 c2                	mov    %eax,%edx
  1005bb:	8b 45 08             	mov    0x8(%ebp),%eax
  1005be:	01 d0                	add    %edx,%eax
  1005c0:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1005c4:	0f b6 c0             	movzbl %al,%eax
  1005c7:	3b 45 14             	cmp    0x14(%ebp),%eax
  1005ca:	75 d3                	jne    10059f <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
  1005cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005cf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1005d2:	89 10                	mov    %edx,(%eax)
    }
}
  1005d4:	c9                   	leave  
  1005d5:	c3                   	ret    

001005d6 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  1005d6:	55                   	push   %ebp
  1005d7:	89 e5                	mov    %esp,%ebp
  1005d9:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  1005dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005df:	c7 00 d8 33 10 00    	movl   $0x1033d8,(%eax)
    info->eip_line = 0;
  1005e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005e8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  1005ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005f2:	c7 40 08 d8 33 10 00 	movl   $0x1033d8,0x8(%eax)
    info->eip_fn_namelen = 9;
  1005f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005fc:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100603:	8b 45 0c             	mov    0xc(%ebp),%eax
  100606:	8b 55 08             	mov    0x8(%ebp),%edx
  100609:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  10060c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10060f:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100616:	c7 45 f4 ec 3b 10 00 	movl   $0x103bec,-0xc(%ebp)
    stab_end = __STAB_END__;
  10061d:	c7 45 f0 84 b2 10 00 	movl   $0x10b284,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100624:	c7 45 ec 85 b2 10 00 	movl   $0x10b285,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  10062b:	c7 45 e8 8e d2 10 00 	movl   $0x10d28e,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  100632:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100635:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  100638:	76 0d                	jbe    100647 <debuginfo_eip+0x71>
  10063a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10063d:	83 e8 01             	sub    $0x1,%eax
  100640:	0f b6 00             	movzbl (%eax),%eax
  100643:	84 c0                	test   %al,%al
  100645:	74 0a                	je     100651 <debuginfo_eip+0x7b>
        return -1;
  100647:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10064c:	e9 c0 02 00 00       	jmp    100911 <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  100651:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  100658:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10065b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10065e:	29 c2                	sub    %eax,%edx
  100660:	89 d0                	mov    %edx,%eax
  100662:	c1 f8 02             	sar    $0x2,%eax
  100665:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  10066b:	83 e8 01             	sub    $0x1,%eax
  10066e:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  100671:	8b 45 08             	mov    0x8(%ebp),%eax
  100674:	89 44 24 10          	mov    %eax,0x10(%esp)
  100678:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  10067f:	00 
  100680:	8d 45 e0             	lea    -0x20(%ebp),%eax
  100683:	89 44 24 08          	mov    %eax,0x8(%esp)
  100687:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  10068a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10068e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100691:	89 04 24             	mov    %eax,(%esp)
  100694:	e8 e7 fd ff ff       	call   100480 <stab_binsearch>
    if (lfile == 0)
  100699:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10069c:	85 c0                	test   %eax,%eax
  10069e:	75 0a                	jne    1006aa <debuginfo_eip+0xd4>
        return -1;
  1006a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1006a5:	e9 67 02 00 00       	jmp    100911 <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  1006aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006ad:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1006b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006b3:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  1006b6:	8b 45 08             	mov    0x8(%ebp),%eax
  1006b9:	89 44 24 10          	mov    %eax,0x10(%esp)
  1006bd:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  1006c4:	00 
  1006c5:	8d 45 d8             	lea    -0x28(%ebp),%eax
  1006c8:	89 44 24 08          	mov    %eax,0x8(%esp)
  1006cc:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1006cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  1006d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006d6:	89 04 24             	mov    %eax,(%esp)
  1006d9:	e8 a2 fd ff ff       	call   100480 <stab_binsearch>

    if (lfun <= rfun) {
  1006de:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1006e1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1006e4:	39 c2                	cmp    %eax,%edx
  1006e6:	7f 7c                	jg     100764 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  1006e8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006eb:	89 c2                	mov    %eax,%edx
  1006ed:	89 d0                	mov    %edx,%eax
  1006ef:	01 c0                	add    %eax,%eax
  1006f1:	01 d0                	add    %edx,%eax
  1006f3:	c1 e0 02             	shl    $0x2,%eax
  1006f6:	89 c2                	mov    %eax,%edx
  1006f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006fb:	01 d0                	add    %edx,%eax
  1006fd:	8b 10                	mov    (%eax),%edx
  1006ff:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  100702:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100705:	29 c1                	sub    %eax,%ecx
  100707:	89 c8                	mov    %ecx,%eax
  100709:	39 c2                	cmp    %eax,%edx
  10070b:	73 22                	jae    10072f <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  10070d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100710:	89 c2                	mov    %eax,%edx
  100712:	89 d0                	mov    %edx,%eax
  100714:	01 c0                	add    %eax,%eax
  100716:	01 d0                	add    %edx,%eax
  100718:	c1 e0 02             	shl    $0x2,%eax
  10071b:	89 c2                	mov    %eax,%edx
  10071d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100720:	01 d0                	add    %edx,%eax
  100722:	8b 10                	mov    (%eax),%edx
  100724:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100727:	01 c2                	add    %eax,%edx
  100729:	8b 45 0c             	mov    0xc(%ebp),%eax
  10072c:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  10072f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100732:	89 c2                	mov    %eax,%edx
  100734:	89 d0                	mov    %edx,%eax
  100736:	01 c0                	add    %eax,%eax
  100738:	01 d0                	add    %edx,%eax
  10073a:	c1 e0 02             	shl    $0x2,%eax
  10073d:	89 c2                	mov    %eax,%edx
  10073f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100742:	01 d0                	add    %edx,%eax
  100744:	8b 50 08             	mov    0x8(%eax),%edx
  100747:	8b 45 0c             	mov    0xc(%ebp),%eax
  10074a:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  10074d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100750:	8b 40 10             	mov    0x10(%eax),%eax
  100753:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  100756:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100759:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  10075c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10075f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  100762:	eb 15                	jmp    100779 <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  100764:	8b 45 0c             	mov    0xc(%ebp),%eax
  100767:	8b 55 08             	mov    0x8(%ebp),%edx
  10076a:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  10076d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100770:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  100773:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100776:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  100779:	8b 45 0c             	mov    0xc(%ebp),%eax
  10077c:	8b 40 08             	mov    0x8(%eax),%eax
  10077f:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  100786:	00 
  100787:	89 04 24             	mov    %eax,(%esp)
  10078a:	e8 b1 21 00 00       	call   102940 <strfind>
  10078f:	89 c2                	mov    %eax,%edx
  100791:	8b 45 0c             	mov    0xc(%ebp),%eax
  100794:	8b 40 08             	mov    0x8(%eax),%eax
  100797:	29 c2                	sub    %eax,%edx
  100799:	8b 45 0c             	mov    0xc(%ebp),%eax
  10079c:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  10079f:	8b 45 08             	mov    0x8(%ebp),%eax
  1007a2:	89 44 24 10          	mov    %eax,0x10(%esp)
  1007a6:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  1007ad:	00 
  1007ae:	8d 45 d0             	lea    -0x30(%ebp),%eax
  1007b1:	89 44 24 08          	mov    %eax,0x8(%esp)
  1007b5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  1007b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1007bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007bf:	89 04 24             	mov    %eax,(%esp)
  1007c2:	e8 b9 fc ff ff       	call   100480 <stab_binsearch>
    if (lline <= rline) {
  1007c7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007ca:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1007cd:	39 c2                	cmp    %eax,%edx
  1007cf:	7f 24                	jg     1007f5 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
  1007d1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1007d4:	89 c2                	mov    %eax,%edx
  1007d6:	89 d0                	mov    %edx,%eax
  1007d8:	01 c0                	add    %eax,%eax
  1007da:	01 d0                	add    %edx,%eax
  1007dc:	c1 e0 02             	shl    $0x2,%eax
  1007df:	89 c2                	mov    %eax,%edx
  1007e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007e4:	01 d0                	add    %edx,%eax
  1007e6:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  1007ea:	0f b7 d0             	movzwl %ax,%edx
  1007ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007f0:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  1007f3:	eb 13                	jmp    100808 <debuginfo_eip+0x232>
        return -1;
  1007f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1007fa:	e9 12 01 00 00       	jmp    100911 <debuginfo_eip+0x33b>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  1007ff:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100802:	83 e8 01             	sub    $0x1,%eax
  100805:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
  100808:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10080b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10080e:	39 c2                	cmp    %eax,%edx
  100810:	7c 56                	jl     100868 <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
  100812:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100815:	89 c2                	mov    %eax,%edx
  100817:	89 d0                	mov    %edx,%eax
  100819:	01 c0                	add    %eax,%eax
  10081b:	01 d0                	add    %edx,%eax
  10081d:	c1 e0 02             	shl    $0x2,%eax
  100820:	89 c2                	mov    %eax,%edx
  100822:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100825:	01 d0                	add    %edx,%eax
  100827:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10082b:	3c 84                	cmp    $0x84,%al
  10082d:	74 39                	je     100868 <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  10082f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100832:	89 c2                	mov    %eax,%edx
  100834:	89 d0                	mov    %edx,%eax
  100836:	01 c0                	add    %eax,%eax
  100838:	01 d0                	add    %edx,%eax
  10083a:	c1 e0 02             	shl    $0x2,%eax
  10083d:	89 c2                	mov    %eax,%edx
  10083f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100842:	01 d0                	add    %edx,%eax
  100844:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100848:	3c 64                	cmp    $0x64,%al
  10084a:	75 b3                	jne    1007ff <debuginfo_eip+0x229>
  10084c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10084f:	89 c2                	mov    %eax,%edx
  100851:	89 d0                	mov    %edx,%eax
  100853:	01 c0                	add    %eax,%eax
  100855:	01 d0                	add    %edx,%eax
  100857:	c1 e0 02             	shl    $0x2,%eax
  10085a:	89 c2                	mov    %eax,%edx
  10085c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10085f:	01 d0                	add    %edx,%eax
  100861:	8b 40 08             	mov    0x8(%eax),%eax
  100864:	85 c0                	test   %eax,%eax
  100866:	74 97                	je     1007ff <debuginfo_eip+0x229>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  100868:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10086b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10086e:	39 c2                	cmp    %eax,%edx
  100870:	7c 46                	jl     1008b8 <debuginfo_eip+0x2e2>
  100872:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100875:	89 c2                	mov    %eax,%edx
  100877:	89 d0                	mov    %edx,%eax
  100879:	01 c0                	add    %eax,%eax
  10087b:	01 d0                	add    %edx,%eax
  10087d:	c1 e0 02             	shl    $0x2,%eax
  100880:	89 c2                	mov    %eax,%edx
  100882:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100885:	01 d0                	add    %edx,%eax
  100887:	8b 10                	mov    (%eax),%edx
  100889:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  10088c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10088f:	29 c1                	sub    %eax,%ecx
  100891:	89 c8                	mov    %ecx,%eax
  100893:	39 c2                	cmp    %eax,%edx
  100895:	73 21                	jae    1008b8 <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
  100897:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10089a:	89 c2                	mov    %eax,%edx
  10089c:	89 d0                	mov    %edx,%eax
  10089e:	01 c0                	add    %eax,%eax
  1008a0:	01 d0                	add    %edx,%eax
  1008a2:	c1 e0 02             	shl    $0x2,%eax
  1008a5:	89 c2                	mov    %eax,%edx
  1008a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008aa:	01 d0                	add    %edx,%eax
  1008ac:	8b 10                	mov    (%eax),%edx
  1008ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1008b1:	01 c2                	add    %eax,%edx
  1008b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008b6:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  1008b8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1008bb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1008be:	39 c2                	cmp    %eax,%edx
  1008c0:	7d 4a                	jge    10090c <debuginfo_eip+0x336>
        for (lline = lfun + 1;
  1008c2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1008c5:	83 c0 01             	add    $0x1,%eax
  1008c8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  1008cb:	eb 18                	jmp    1008e5 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  1008cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008d0:	8b 40 14             	mov    0x14(%eax),%eax
  1008d3:	8d 50 01             	lea    0x1(%eax),%edx
  1008d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008d9:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
  1008dc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008df:	83 c0 01             	add    $0x1,%eax
  1008e2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
  1008e5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1008e8:	8b 45 d8             	mov    -0x28(%ebp),%eax
        for (lline = lfun + 1;
  1008eb:	39 c2                	cmp    %eax,%edx
  1008ed:	7d 1d                	jge    10090c <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  1008ef:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008f2:	89 c2                	mov    %eax,%edx
  1008f4:	89 d0                	mov    %edx,%eax
  1008f6:	01 c0                	add    %eax,%eax
  1008f8:	01 d0                	add    %edx,%eax
  1008fa:	c1 e0 02             	shl    $0x2,%eax
  1008fd:	89 c2                	mov    %eax,%edx
  1008ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100902:	01 d0                	add    %edx,%eax
  100904:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100908:	3c a0                	cmp    $0xa0,%al
  10090a:	74 c1                	je     1008cd <debuginfo_eip+0x2f7>
        }
    }
    return 0;
  10090c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100911:	c9                   	leave  
  100912:	c3                   	ret    

00100913 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100913:	55                   	push   %ebp
  100914:	89 e5                	mov    %esp,%ebp
  100916:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  100919:	c7 04 24 e2 33 10 00 	movl   $0x1033e2,(%esp)
  100920:	e8 37 f9 ff ff       	call   10025c <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100925:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  10092c:	00 
  10092d:	c7 04 24 fb 33 10 00 	movl   $0x1033fb,(%esp)
  100934:	e8 23 f9 ff ff       	call   10025c <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  100939:	c7 44 24 04 d6 32 10 	movl   $0x1032d6,0x4(%esp)
  100940:	00 
  100941:	c7 04 24 13 34 10 00 	movl   $0x103413,(%esp)
  100948:	e8 0f f9 ff ff       	call   10025c <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  10094d:	c7 44 24 04 16 ea 10 	movl   $0x10ea16,0x4(%esp)
  100954:	00 
  100955:	c7 04 24 2b 34 10 00 	movl   $0x10342b,(%esp)
  10095c:	e8 fb f8 ff ff       	call   10025c <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  100961:	c7 44 24 04 20 fd 10 	movl   $0x10fd20,0x4(%esp)
  100968:	00 
  100969:	c7 04 24 43 34 10 00 	movl   $0x103443,(%esp)
  100970:	e8 e7 f8 ff ff       	call   10025c <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  100975:	b8 20 fd 10 00       	mov    $0x10fd20,%eax
  10097a:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  100980:	b8 00 00 10 00       	mov    $0x100000,%eax
  100985:	29 c2                	sub    %eax,%edx
  100987:	89 d0                	mov    %edx,%eax
  100989:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  10098f:	85 c0                	test   %eax,%eax
  100991:	0f 48 c2             	cmovs  %edx,%eax
  100994:	c1 f8 0a             	sar    $0xa,%eax
  100997:	89 44 24 04          	mov    %eax,0x4(%esp)
  10099b:	c7 04 24 5c 34 10 00 	movl   $0x10345c,(%esp)
  1009a2:	e8 b5 f8 ff ff       	call   10025c <cprintf>
}
  1009a7:	c9                   	leave  
  1009a8:	c3                   	ret    

001009a9 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  1009a9:	55                   	push   %ebp
  1009aa:	89 e5                	mov    %esp,%ebp
  1009ac:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  1009b2:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1009b5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009b9:	8b 45 08             	mov    0x8(%ebp),%eax
  1009bc:	89 04 24             	mov    %eax,(%esp)
  1009bf:	e8 12 fc ff ff       	call   1005d6 <debuginfo_eip>
  1009c4:	85 c0                	test   %eax,%eax
  1009c6:	74 15                	je     1009dd <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  1009c8:	8b 45 08             	mov    0x8(%ebp),%eax
  1009cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009cf:	c7 04 24 86 34 10 00 	movl   $0x103486,(%esp)
  1009d6:	e8 81 f8 ff ff       	call   10025c <cprintf>
  1009db:	eb 6d                	jmp    100a4a <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  1009dd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1009e4:	eb 1c                	jmp    100a02 <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
  1009e6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1009e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009ec:	01 d0                	add    %edx,%eax
  1009ee:	0f b6 00             	movzbl (%eax),%eax
  1009f1:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  1009f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1009fa:	01 ca                	add    %ecx,%edx
  1009fc:	88 02                	mov    %al,(%edx)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  1009fe:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100a02:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a05:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  100a08:	7f dc                	jg     1009e6 <print_debuginfo+0x3d>
        }
        fnname[j] = '\0';
  100a0a:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  100a10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a13:	01 d0                	add    %edx,%eax
  100a15:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
  100a18:	8b 45 ec             	mov    -0x14(%ebp),%eax
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100a1b:	8b 55 08             	mov    0x8(%ebp),%edx
  100a1e:	89 d1                	mov    %edx,%ecx
  100a20:	29 c1                	sub    %eax,%ecx
  100a22:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100a25:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100a28:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  100a2c:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100a32:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100a36:	89 54 24 08          	mov    %edx,0x8(%esp)
  100a3a:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a3e:	c7 04 24 a2 34 10 00 	movl   $0x1034a2,(%esp)
  100a45:	e8 12 f8 ff ff       	call   10025c <cprintf>
    }
}
  100a4a:	c9                   	leave  
  100a4b:	c3                   	ret    

00100a4c <read_eip>:

static __noinline uint32_t
read_eip(void) {
  100a4c:	55                   	push   %ebp
  100a4d:	89 e5                	mov    %esp,%ebp
  100a4f:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100a52:	8b 45 04             	mov    0x4(%ebp),%eax
  100a55:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  100a58:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  100a5b:	c9                   	leave  
  100a5c:	c3                   	ret    

00100a5d <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100a5d:	55                   	push   %ebp
  100a5e:	89 e5                	mov    %esp,%ebp
  100a60:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100a63:	89 e8                	mov    %ebp,%eax
  100a65:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
  100a68:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */

	uint32_t ebp_v = read_ebp(), eip_v = read_eip();
  100a6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100a6e:	e8 d9 ff ff ff       	call   100a4c <read_eip>
  100a73:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32_t i, j;
	for (i = 0; ebp_v != 0 && i< STACKFRAME_DEPTH; i ++)
  100a76:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  100a7d:	e9 88 00 00 00       	jmp    100b0a <print_stackframe+0xad>
	{
		cprintf("ebp:0x%08x eip:0x%08x args:", ebp_v, eip_v);
  100a82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a85:	89 44 24 08          	mov    %eax,0x8(%esp)
  100a89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a8c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a90:	c7 04 24 b4 34 10 00 	movl   $0x1034b4,(%esp)
  100a97:	e8 c0 f7 ff ff       	call   10025c <cprintf>
		uint32_t *args = (uint32_t *)ebp_v + 0x2;
  100a9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a9f:	83 c0 08             	add    $0x8,%eax
  100aa2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		for (j = 0; j < 4; j ++)
  100aa5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  100aac:	eb 25                	jmp    100ad3 <print_stackframe+0x76>
		{
			cprintf(" 0x%08x ", args[j]);
  100aae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100ab1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100ab8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100abb:	01 d0                	add    %edx,%eax
  100abd:	8b 00                	mov    (%eax),%eax
  100abf:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ac3:	c7 04 24 d0 34 10 00 	movl   $0x1034d0,(%esp)
  100aca:	e8 8d f7 ff ff       	call   10025c <cprintf>
		for (j = 0; j < 4; j ++)
  100acf:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
  100ad3:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100ad7:	76 d5                	jbe    100aae <print_stackframe+0x51>
		}
		cprintf("\n");
  100ad9:	c7 04 24 d9 34 10 00 	movl   $0x1034d9,(%esp)
  100ae0:	e8 77 f7 ff ff       	call   10025c <cprintf>
		print_debuginfo(eip_v-0x1);
  100ae5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100ae8:	83 e8 01             	sub    $0x1,%eax
  100aeb:	89 04 24             	mov    %eax,(%esp)
  100aee:	e8 b6 fe ff ff       	call   1009a9 <print_debuginfo>
		eip_v = ((uint32_t*)ebp_v)[1];
  100af3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100af6:	83 c0 04             	add    $0x4,%eax
  100af9:	8b 00                	mov    (%eax),%eax
  100afb:	89 45 f0             	mov    %eax,-0x10(%ebp)
		ebp_v = ((uint32_t*)ebp_v)[0];
  100afe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b01:	8b 00                	mov    (%eax),%eax
  100b03:	89 45 f4             	mov    %eax,-0xc(%ebp)
	for (i = 0; ebp_v != 0 && i< STACKFRAME_DEPTH; i ++)
  100b06:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100b0a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100b0e:	74 0a                	je     100b1a <print_stackframe+0xbd>
  100b10:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100b14:	0f 86 68 ff ff ff    	jbe    100a82 <print_stackframe+0x25>
	}

}
  100b1a:	c9                   	leave  
  100b1b:	c3                   	ret    

00100b1c <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100b1c:	55                   	push   %ebp
  100b1d:	89 e5                	mov    %esp,%ebp
  100b1f:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100b22:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b29:	eb 0c                	jmp    100b37 <parse+0x1b>
            *buf ++ = '\0';
  100b2b:	8b 45 08             	mov    0x8(%ebp),%eax
  100b2e:	8d 50 01             	lea    0x1(%eax),%edx
  100b31:	89 55 08             	mov    %edx,0x8(%ebp)
  100b34:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b37:	8b 45 08             	mov    0x8(%ebp),%eax
  100b3a:	0f b6 00             	movzbl (%eax),%eax
  100b3d:	84 c0                	test   %al,%al
  100b3f:	74 1d                	je     100b5e <parse+0x42>
  100b41:	8b 45 08             	mov    0x8(%ebp),%eax
  100b44:	0f b6 00             	movzbl (%eax),%eax
  100b47:	0f be c0             	movsbl %al,%eax
  100b4a:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b4e:	c7 04 24 5c 35 10 00 	movl   $0x10355c,(%esp)
  100b55:	e8 b3 1d 00 00       	call   10290d <strchr>
  100b5a:	85 c0                	test   %eax,%eax
  100b5c:	75 cd                	jne    100b2b <parse+0xf>
        }
        if (*buf == '\0') {
  100b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  100b61:	0f b6 00             	movzbl (%eax),%eax
  100b64:	84 c0                	test   %al,%al
  100b66:	75 02                	jne    100b6a <parse+0x4e>
            break;
  100b68:	eb 67                	jmp    100bd1 <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100b6a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100b6e:	75 14                	jne    100b84 <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100b70:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100b77:	00 
  100b78:	c7 04 24 61 35 10 00 	movl   $0x103561,(%esp)
  100b7f:	e8 d8 f6 ff ff       	call   10025c <cprintf>
        }
        argv[argc ++] = buf;
  100b84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b87:	8d 50 01             	lea    0x1(%eax),%edx
  100b8a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100b8d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100b94:	8b 45 0c             	mov    0xc(%ebp),%eax
  100b97:	01 c2                	add    %eax,%edx
  100b99:	8b 45 08             	mov    0x8(%ebp),%eax
  100b9c:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b9e:	eb 04                	jmp    100ba4 <parse+0x88>
            buf ++;
  100ba0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100ba4:	8b 45 08             	mov    0x8(%ebp),%eax
  100ba7:	0f b6 00             	movzbl (%eax),%eax
  100baa:	84 c0                	test   %al,%al
  100bac:	74 1d                	je     100bcb <parse+0xaf>
  100bae:	8b 45 08             	mov    0x8(%ebp),%eax
  100bb1:	0f b6 00             	movzbl (%eax),%eax
  100bb4:	0f be c0             	movsbl %al,%eax
  100bb7:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bbb:	c7 04 24 5c 35 10 00 	movl   $0x10355c,(%esp)
  100bc2:	e8 46 1d 00 00       	call   10290d <strchr>
  100bc7:	85 c0                	test   %eax,%eax
  100bc9:	74 d5                	je     100ba0 <parse+0x84>
        }
    }
  100bcb:	90                   	nop
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100bcc:	e9 66 ff ff ff       	jmp    100b37 <parse+0x1b>
    return argc;
  100bd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100bd4:	c9                   	leave  
  100bd5:	c3                   	ret    

00100bd6 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100bd6:	55                   	push   %ebp
  100bd7:	89 e5                	mov    %esp,%ebp
  100bd9:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100bdc:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100bdf:	89 44 24 04          	mov    %eax,0x4(%esp)
  100be3:	8b 45 08             	mov    0x8(%ebp),%eax
  100be6:	89 04 24             	mov    %eax,(%esp)
  100be9:	e8 2e ff ff ff       	call   100b1c <parse>
  100bee:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100bf1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100bf5:	75 0a                	jne    100c01 <runcmd+0x2b>
        return 0;
  100bf7:	b8 00 00 00 00       	mov    $0x0,%eax
  100bfc:	e9 85 00 00 00       	jmp    100c86 <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c01:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c08:	eb 5c                	jmp    100c66 <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100c0a:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100c0d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c10:	89 d0                	mov    %edx,%eax
  100c12:	01 c0                	add    %eax,%eax
  100c14:	01 d0                	add    %edx,%eax
  100c16:	c1 e0 02             	shl    $0x2,%eax
  100c19:	05 00 e0 10 00       	add    $0x10e000,%eax
  100c1e:	8b 00                	mov    (%eax),%eax
  100c20:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100c24:	89 04 24             	mov    %eax,(%esp)
  100c27:	e8 42 1c 00 00       	call   10286e <strcmp>
  100c2c:	85 c0                	test   %eax,%eax
  100c2e:	75 32                	jne    100c62 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100c30:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c33:	89 d0                	mov    %edx,%eax
  100c35:	01 c0                	add    %eax,%eax
  100c37:	01 d0                	add    %edx,%eax
  100c39:	c1 e0 02             	shl    $0x2,%eax
  100c3c:	05 00 e0 10 00       	add    $0x10e000,%eax
  100c41:	8b 40 08             	mov    0x8(%eax),%eax
  100c44:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100c47:	8d 4a ff             	lea    -0x1(%edx),%ecx
  100c4a:	8b 55 0c             	mov    0xc(%ebp),%edx
  100c4d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100c51:	8d 55 b0             	lea    -0x50(%ebp),%edx
  100c54:	83 c2 04             	add    $0x4,%edx
  100c57:	89 54 24 04          	mov    %edx,0x4(%esp)
  100c5b:	89 0c 24             	mov    %ecx,(%esp)
  100c5e:	ff d0                	call   *%eax
  100c60:	eb 24                	jmp    100c86 <runcmd+0xb0>
    for (i = 0; i < NCOMMANDS; i ++) {
  100c62:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100c66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c69:	83 f8 02             	cmp    $0x2,%eax
  100c6c:	76 9c                	jbe    100c0a <runcmd+0x34>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100c6e:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100c71:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c75:	c7 04 24 7f 35 10 00 	movl   $0x10357f,(%esp)
  100c7c:	e8 db f5 ff ff       	call   10025c <cprintf>
    return 0;
  100c81:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c86:	c9                   	leave  
  100c87:	c3                   	ret    

00100c88 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100c88:	55                   	push   %ebp
  100c89:	89 e5                	mov    %esp,%ebp
  100c8b:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100c8e:	c7 04 24 98 35 10 00 	movl   $0x103598,(%esp)
  100c95:	e8 c2 f5 ff ff       	call   10025c <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100c9a:	c7 04 24 c0 35 10 00 	movl   $0x1035c0,(%esp)
  100ca1:	e8 b6 f5 ff ff       	call   10025c <cprintf>

    if (tf != NULL) {
  100ca6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100caa:	74 0b                	je     100cb7 <kmonitor+0x2f>
        print_trapframe(tf);
  100cac:	8b 45 08             	mov    0x8(%ebp),%eax
  100caf:	89 04 24             	mov    %eax,(%esp)
  100cb2:	e8 a5 0b 00 00       	call   10185c <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100cb7:	c7 04 24 e5 35 10 00 	movl   $0x1035e5,(%esp)
  100cbe:	e8 3a f6 ff ff       	call   1002fd <readline>
  100cc3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100cc6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100cca:	74 18                	je     100ce4 <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
  100ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  100ccf:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100cd6:	89 04 24             	mov    %eax,(%esp)
  100cd9:	e8 f8 fe ff ff       	call   100bd6 <runcmd>
  100cde:	85 c0                	test   %eax,%eax
  100ce0:	79 02                	jns    100ce4 <kmonitor+0x5c>
                break;
  100ce2:	eb 02                	jmp    100ce6 <kmonitor+0x5e>
            }
        }
    }
  100ce4:	eb d1                	jmp    100cb7 <kmonitor+0x2f>
}
  100ce6:	c9                   	leave  
  100ce7:	c3                   	ret    

00100ce8 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100ce8:	55                   	push   %ebp
  100ce9:	89 e5                	mov    %esp,%ebp
  100ceb:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100cee:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100cf5:	eb 3f                	jmp    100d36 <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100cf7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100cfa:	89 d0                	mov    %edx,%eax
  100cfc:	01 c0                	add    %eax,%eax
  100cfe:	01 d0                	add    %edx,%eax
  100d00:	c1 e0 02             	shl    $0x2,%eax
  100d03:	05 00 e0 10 00       	add    $0x10e000,%eax
  100d08:	8b 48 04             	mov    0x4(%eax),%ecx
  100d0b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100d0e:	89 d0                	mov    %edx,%eax
  100d10:	01 c0                	add    %eax,%eax
  100d12:	01 d0                	add    %edx,%eax
  100d14:	c1 e0 02             	shl    $0x2,%eax
  100d17:	05 00 e0 10 00       	add    $0x10e000,%eax
  100d1c:	8b 00                	mov    (%eax),%eax
  100d1e:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100d22:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d26:	c7 04 24 e9 35 10 00 	movl   $0x1035e9,(%esp)
  100d2d:	e8 2a f5 ff ff       	call   10025c <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
  100d32:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100d36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d39:	83 f8 02             	cmp    $0x2,%eax
  100d3c:	76 b9                	jbe    100cf7 <mon_help+0xf>
    }
    return 0;
  100d3e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d43:	c9                   	leave  
  100d44:	c3                   	ret    

00100d45 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100d45:	55                   	push   %ebp
  100d46:	89 e5                	mov    %esp,%ebp
  100d48:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100d4b:	e8 c3 fb ff ff       	call   100913 <print_kerninfo>
    return 0;
  100d50:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d55:	c9                   	leave  
  100d56:	c3                   	ret    

00100d57 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100d57:	55                   	push   %ebp
  100d58:	89 e5                	mov    %esp,%ebp
  100d5a:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100d5d:	e8 fb fc ff ff       	call   100a5d <print_stackframe>
    return 0;
  100d62:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d67:	c9                   	leave  
  100d68:	c3                   	ret    

00100d69 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d69:	55                   	push   %ebp
  100d6a:	89 e5                	mov    %esp,%ebp
  100d6c:	83 ec 28             	sub    $0x28,%esp
  100d6f:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100d75:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100d79:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100d7d:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100d81:	ee                   	out    %al,(%dx)
  100d82:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100d88:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100d8c:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100d90:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100d94:	ee                   	out    %al,(%dx)
  100d95:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
  100d9b:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
  100d9f:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100da3:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100da7:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100da8:	c7 05 08 f9 10 00 00 	movl   $0x0,0x10f908
  100daf:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100db2:	c7 04 24 f2 35 10 00 	movl   $0x1035f2,(%esp)
  100db9:	e8 9e f4 ff ff       	call   10025c <cprintf>
    pic_enable(IRQ_TIMER);
  100dbe:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100dc5:	e8 b5 08 00 00       	call   10167f <pic_enable>
}
  100dca:	c9                   	leave  
  100dcb:	c3                   	ret    

00100dcc <delay>:
#include <picirq.h>
#include <trap.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100dcc:	55                   	push   %ebp
  100dcd:	89 e5                	mov    %esp,%ebp
  100dcf:	83 ec 10             	sub    $0x10,%esp
  100dd2:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100dd8:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100ddc:	89 c2                	mov    %eax,%edx
  100dde:	ec                   	in     (%dx),%al
  100ddf:	88 45 fd             	mov    %al,-0x3(%ebp)
  100de2:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100de8:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100dec:	89 c2                	mov    %eax,%edx
  100dee:	ec                   	in     (%dx),%al
  100def:	88 45 f9             	mov    %al,-0x7(%ebp)
  100df2:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100df8:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100dfc:	89 c2                	mov    %eax,%edx
  100dfe:	ec                   	in     (%dx),%al
  100dff:	88 45 f5             	mov    %al,-0xb(%ebp)
  100e02:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
  100e08:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e0c:	89 c2                	mov    %eax,%edx
  100e0e:	ec                   	in     (%dx),%al
  100e0f:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e12:	c9                   	leave  
  100e13:	c3                   	ret    

00100e14 <cga_init>:
//    -- 数据寄存器 映射 到 端口 0x3D5或0x3B5 
//    -- 索引寄存器 0x3D4或0x3B4,决定在数据寄存器中的数据表示什么。

/* TEXT-mode CGA/VGA display output */
static void
cga_init(void) {
  100e14:	55                   	push   %ebp
  100e15:	89 e5                	mov    %esp,%ebp
  100e17:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;   //CGA_BUF: 0xB8000 (彩色显示的显存物理基址)
  100e1a:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;                                            //保存当前显存0xB8000处的值
  100e21:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e24:	0f b7 00             	movzwl (%eax),%eax
  100e27:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;                                   // 给这个地址随便写个值，看看能否再读出同样的值
  100e2b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e2e:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {                                            // 如果读不出来，说明没有这块显存，即是单显配置
  100e33:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e36:	0f b7 00             	movzwl (%eax),%eax
  100e39:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100e3d:	74 12                	je     100e51 <cga_init+0x3d>
        cp = (uint16_t*)MONO_BUF;                         //设置为单显的显存基址 MONO_BUF： 0xB0000
  100e3f:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;                           //设置为单显控制的IO地址，MONO_BASE: 0x3B4
  100e46:	66 c7 05 66 ee 10 00 	movw   $0x3b4,0x10ee66
  100e4d:	b4 03 
  100e4f:	eb 13                	jmp    100e64 <cga_init+0x50>
    } else {                                                                // 如果读出来了，有这块显存，即是彩显配置
        *cp = was;                                                      //还原原来显存位置的值
  100e51:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e54:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100e58:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;                               // 设置为彩显控制的IO地址，CGA_BASE: 0x3D4 
  100e5b:	66 c7 05 66 ee 10 00 	movw   $0x3d4,0x10ee66
  100e62:	d4 03 
    // Extract cursor location
    // 6845索引寄存器的index 0x0E（及十进制的14）== 光标位置(高位)
    // 6845索引寄存器的index 0x0F（及十进制的15）== 光标位置(低位)
    // 6845 reg 15 : Cursor Address (Low Byte)
    uint32_t pos;
    outb(addr_6845, 14);                                        
  100e64:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e6b:	0f b7 c0             	movzwl %ax,%eax
  100e6e:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  100e72:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e76:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100e7a:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100e7e:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;                       //读出了光标位置(高位)
  100e7f:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e86:	83 c0 01             	add    $0x1,%eax
  100e89:	0f b7 c0             	movzwl %ax,%eax
  100e8c:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100e90:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100e94:	89 c2                	mov    %eax,%edx
  100e96:	ec                   	in     (%dx),%al
  100e97:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100e9a:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100e9e:	0f b6 c0             	movzbl %al,%eax
  100ea1:	c1 e0 08             	shl    $0x8,%eax
  100ea4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100ea7:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100eae:	0f b7 c0             	movzwl %ax,%eax
  100eb1:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  100eb5:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100eb9:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100ebd:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100ec1:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);                             //读出了光标位置(低位)
  100ec2:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100ec9:	83 c0 01             	add    $0x1,%eax
  100ecc:	0f b7 c0             	movzwl %ax,%eax
  100ecf:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100ed3:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  100ed7:	89 c2                	mov    %eax,%edx
  100ed9:	ec                   	in     (%dx),%al
  100eda:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
  100edd:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100ee1:	0f b6 c0             	movzbl %al,%eax
  100ee4:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;                                  //crt_buf是CGA显存起始地址
  100ee7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100eea:	a3 60 ee 10 00       	mov    %eax,0x10ee60
    crt_pos = pos;                                                  //crt_pos是CGA当前光标位置
  100eef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ef2:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
}
  100ef8:	c9                   	leave  
  100ef9:	c3                   	ret    

00100efa <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100efa:	55                   	push   %ebp
  100efb:	89 e5                	mov    %esp,%ebp
  100efd:	83 ec 48             	sub    $0x48,%esp
  100f00:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100f06:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f0a:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100f0e:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100f12:	ee                   	out    %al,(%dx)
  100f13:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
  100f19:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
  100f1d:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f21:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100f25:	ee                   	out    %al,(%dx)
  100f26:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
  100f2c:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
  100f30:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f34:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f38:	ee                   	out    %al,(%dx)
  100f39:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100f3f:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
  100f43:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f47:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f4b:	ee                   	out    %al,(%dx)
  100f4c:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
  100f52:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
  100f56:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f5a:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100f5e:	ee                   	out    %al,(%dx)
  100f5f:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
  100f65:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
  100f69:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100f6d:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100f71:	ee                   	out    %al,(%dx)
  100f72:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100f78:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
  100f7c:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100f80:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100f84:	ee                   	out    %al,(%dx)
  100f85:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f8b:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
  100f8f:	89 c2                	mov    %eax,%edx
  100f91:	ec                   	in     (%dx),%al
  100f92:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
  100f95:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100f99:	3c ff                	cmp    $0xff,%al
  100f9b:	0f 95 c0             	setne  %al
  100f9e:	0f b6 c0             	movzbl %al,%eax
  100fa1:	a3 68 ee 10 00       	mov    %eax,0x10ee68
  100fa6:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100fac:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
  100fb0:	89 c2                	mov    %eax,%edx
  100fb2:	ec                   	in     (%dx),%al
  100fb3:	88 45 d5             	mov    %al,-0x2b(%ebp)
  100fb6:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
  100fbc:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
  100fc0:	89 c2                	mov    %eax,%edx
  100fc2:	ec                   	in     (%dx),%al
  100fc3:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  100fc6:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  100fcb:	85 c0                	test   %eax,%eax
  100fcd:	74 0c                	je     100fdb <serial_init+0xe1>
        pic_enable(IRQ_COM1);
  100fcf:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  100fd6:	e8 a4 06 00 00       	call   10167f <pic_enable>
    }
}
  100fdb:	c9                   	leave  
  100fdc:	c3                   	ret    

00100fdd <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  100fdd:	55                   	push   %ebp
  100fde:	89 e5                	mov    %esp,%ebp
  100fe0:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100fe3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  100fea:	eb 09                	jmp    100ff5 <lpt_putc_sub+0x18>
        delay();
  100fec:	e8 db fd ff ff       	call   100dcc <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100ff1:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  100ff5:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  100ffb:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100fff:	89 c2                	mov    %eax,%edx
  101001:	ec                   	in     (%dx),%al
  101002:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101005:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101009:	84 c0                	test   %al,%al
  10100b:	78 09                	js     101016 <lpt_putc_sub+0x39>
  10100d:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101014:	7e d6                	jle    100fec <lpt_putc_sub+0xf>
    }
    outb(LPTPORT + 0, c);
  101016:	8b 45 08             	mov    0x8(%ebp),%eax
  101019:	0f b6 c0             	movzbl %al,%eax
  10101c:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
  101022:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101025:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101029:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10102d:	ee                   	out    %al,(%dx)
  10102e:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  101034:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  101038:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10103c:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101040:	ee                   	out    %al,(%dx)
  101041:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
  101047:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
  10104b:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10104f:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101053:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  101054:	c9                   	leave  
  101055:	c3                   	ret    

00101056 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  101056:	55                   	push   %ebp
  101057:	89 e5                	mov    %esp,%ebp
  101059:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  10105c:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101060:	74 0d                	je     10106f <lpt_putc+0x19>
        lpt_putc_sub(c);
  101062:	8b 45 08             	mov    0x8(%ebp),%eax
  101065:	89 04 24             	mov    %eax,(%esp)
  101068:	e8 70 ff ff ff       	call   100fdd <lpt_putc_sub>
  10106d:	eb 24                	jmp    101093 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
  10106f:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101076:	e8 62 ff ff ff       	call   100fdd <lpt_putc_sub>
        lpt_putc_sub(' ');
  10107b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  101082:	e8 56 ff ff ff       	call   100fdd <lpt_putc_sub>
        lpt_putc_sub('\b');
  101087:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10108e:	e8 4a ff ff ff       	call   100fdd <lpt_putc_sub>
    }
}
  101093:	c9                   	leave  
  101094:	c3                   	ret    

00101095 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  101095:	55                   	push   %ebp
  101096:	89 e5                	mov    %esp,%ebp
  101098:	53                   	push   %ebx
  101099:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  10109c:	8b 45 08             	mov    0x8(%ebp),%eax
  10109f:	b0 00                	mov    $0x0,%al
  1010a1:	85 c0                	test   %eax,%eax
  1010a3:	75 07                	jne    1010ac <cga_putc+0x17>
        c |= 0x0700;
  1010a5:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  1010ac:	8b 45 08             	mov    0x8(%ebp),%eax
  1010af:	0f b6 c0             	movzbl %al,%eax
  1010b2:	83 f8 0a             	cmp    $0xa,%eax
  1010b5:	74 4c                	je     101103 <cga_putc+0x6e>
  1010b7:	83 f8 0d             	cmp    $0xd,%eax
  1010ba:	74 57                	je     101113 <cga_putc+0x7e>
  1010bc:	83 f8 08             	cmp    $0x8,%eax
  1010bf:	0f 85 88 00 00 00    	jne    10114d <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
  1010c5:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010cc:	66 85 c0             	test   %ax,%ax
  1010cf:	74 30                	je     101101 <cga_putc+0x6c>
            crt_pos --;
  1010d1:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010d8:	83 e8 01             	sub    $0x1,%eax
  1010db:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  1010e1:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  1010e6:	0f b7 15 64 ee 10 00 	movzwl 0x10ee64,%edx
  1010ed:	0f b7 d2             	movzwl %dx,%edx
  1010f0:	01 d2                	add    %edx,%edx
  1010f2:	01 c2                	add    %eax,%edx
  1010f4:	8b 45 08             	mov    0x8(%ebp),%eax
  1010f7:	b0 00                	mov    $0x0,%al
  1010f9:	83 c8 20             	or     $0x20,%eax
  1010fc:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  1010ff:	eb 72                	jmp    101173 <cga_putc+0xde>
  101101:	eb 70                	jmp    101173 <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
  101103:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  10110a:	83 c0 50             	add    $0x50,%eax
  10110d:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  101113:	0f b7 1d 64 ee 10 00 	movzwl 0x10ee64,%ebx
  10111a:	0f b7 0d 64 ee 10 00 	movzwl 0x10ee64,%ecx
  101121:	0f b7 c1             	movzwl %cx,%eax
  101124:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  10112a:	c1 e8 10             	shr    $0x10,%eax
  10112d:	89 c2                	mov    %eax,%edx
  10112f:	66 c1 ea 06          	shr    $0x6,%dx
  101133:	89 d0                	mov    %edx,%eax
  101135:	c1 e0 02             	shl    $0x2,%eax
  101138:	01 d0                	add    %edx,%eax
  10113a:	c1 e0 04             	shl    $0x4,%eax
  10113d:	29 c1                	sub    %eax,%ecx
  10113f:	89 ca                	mov    %ecx,%edx
  101141:	89 d8                	mov    %ebx,%eax
  101143:	29 d0                	sub    %edx,%eax
  101145:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
        break;
  10114b:	eb 26                	jmp    101173 <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  10114d:	8b 0d 60 ee 10 00    	mov    0x10ee60,%ecx
  101153:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  10115a:	8d 50 01             	lea    0x1(%eax),%edx
  10115d:	66 89 15 64 ee 10 00 	mov    %dx,0x10ee64
  101164:	0f b7 c0             	movzwl %ax,%eax
  101167:	01 c0                	add    %eax,%eax
  101169:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  10116c:	8b 45 08             	mov    0x8(%ebp),%eax
  10116f:	66 89 02             	mov    %ax,(%edx)
        break;
  101172:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  101173:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  10117a:	66 3d cf 07          	cmp    $0x7cf,%ax
  10117e:	76 5b                	jbe    1011db <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  101180:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  101185:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  10118b:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  101190:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  101197:	00 
  101198:	89 54 24 04          	mov    %edx,0x4(%esp)
  10119c:	89 04 24             	mov    %eax,(%esp)
  10119f:	e8 67 19 00 00       	call   102b0b <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011a4:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  1011ab:	eb 15                	jmp    1011c2 <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
  1011ad:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  1011b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1011b5:	01 d2                	add    %edx,%edx
  1011b7:	01 d0                	add    %edx,%eax
  1011b9:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011be:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1011c2:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  1011c9:	7e e2                	jle    1011ad <cga_putc+0x118>
        }
        crt_pos -= CRT_COLS;
  1011cb:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1011d2:	83 e8 50             	sub    $0x50,%eax
  1011d5:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  1011db:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  1011e2:	0f b7 c0             	movzwl %ax,%eax
  1011e5:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  1011e9:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
  1011ed:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1011f1:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1011f5:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  1011f6:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1011fd:	66 c1 e8 08          	shr    $0x8,%ax
  101201:	0f b6 c0             	movzbl %al,%eax
  101204:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  10120b:	83 c2 01             	add    $0x1,%edx
  10120e:	0f b7 d2             	movzwl %dx,%edx
  101211:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
  101215:	88 45 ed             	mov    %al,-0x13(%ebp)
  101218:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10121c:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101220:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  101221:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  101228:	0f b7 c0             	movzwl %ax,%eax
  10122b:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  10122f:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
  101233:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101237:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10123b:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  10123c:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101243:	0f b6 c0             	movzbl %al,%eax
  101246:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  10124d:	83 c2 01             	add    $0x1,%edx
  101250:	0f b7 d2             	movzwl %dx,%edx
  101253:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
  101257:	88 45 e5             	mov    %al,-0x1b(%ebp)
  10125a:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  10125e:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101262:	ee                   	out    %al,(%dx)
}
  101263:	83 c4 34             	add    $0x34,%esp
  101266:	5b                   	pop    %ebx
  101267:	5d                   	pop    %ebp
  101268:	c3                   	ret    

00101269 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  101269:	55                   	push   %ebp
  10126a:	89 e5                	mov    %esp,%ebp
  10126c:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  10126f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101276:	eb 09                	jmp    101281 <serial_putc_sub+0x18>
        delay();
  101278:	e8 4f fb ff ff       	call   100dcc <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  10127d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101281:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101287:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10128b:	89 c2                	mov    %eax,%edx
  10128d:	ec                   	in     (%dx),%al
  10128e:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101291:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101295:	0f b6 c0             	movzbl %al,%eax
  101298:	83 e0 20             	and    $0x20,%eax
  10129b:	85 c0                	test   %eax,%eax
  10129d:	75 09                	jne    1012a8 <serial_putc_sub+0x3f>
  10129f:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  1012a6:	7e d0                	jle    101278 <serial_putc_sub+0xf>
    }
    outb(COM1 + COM_TX, c);
  1012a8:	8b 45 08             	mov    0x8(%ebp),%eax
  1012ab:	0f b6 c0             	movzbl %al,%eax
  1012ae:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  1012b4:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1012b7:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1012bb:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1012bf:	ee                   	out    %al,(%dx)
}
  1012c0:	c9                   	leave  
  1012c1:	c3                   	ret    

001012c2 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  1012c2:	55                   	push   %ebp
  1012c3:	89 e5                	mov    %esp,%ebp
  1012c5:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1012c8:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1012cc:	74 0d                	je     1012db <serial_putc+0x19>
        serial_putc_sub(c);
  1012ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1012d1:	89 04 24             	mov    %eax,(%esp)
  1012d4:	e8 90 ff ff ff       	call   101269 <serial_putc_sub>
  1012d9:	eb 24                	jmp    1012ff <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
  1012db:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1012e2:	e8 82 ff ff ff       	call   101269 <serial_putc_sub>
        serial_putc_sub(' ');
  1012e7:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1012ee:	e8 76 ff ff ff       	call   101269 <serial_putc_sub>
        serial_putc_sub('\b');
  1012f3:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1012fa:	e8 6a ff ff ff       	call   101269 <serial_putc_sub>
    }
}
  1012ff:	c9                   	leave  
  101300:	c3                   	ret    

00101301 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  101301:	55                   	push   %ebp
  101302:	89 e5                	mov    %esp,%ebp
  101304:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  101307:	eb 33                	jmp    10133c <cons_intr+0x3b>
        if (c != 0) {
  101309:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10130d:	74 2d                	je     10133c <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  10130f:	a1 84 f0 10 00       	mov    0x10f084,%eax
  101314:	8d 50 01             	lea    0x1(%eax),%edx
  101317:	89 15 84 f0 10 00    	mov    %edx,0x10f084
  10131d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101320:	88 90 80 ee 10 00    	mov    %dl,0x10ee80(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  101326:	a1 84 f0 10 00       	mov    0x10f084,%eax
  10132b:	3d 00 02 00 00       	cmp    $0x200,%eax
  101330:	75 0a                	jne    10133c <cons_intr+0x3b>
                cons.wpos = 0;
  101332:	c7 05 84 f0 10 00 00 	movl   $0x0,0x10f084
  101339:	00 00 00 
    while ((c = (*proc)()) != -1) {
  10133c:	8b 45 08             	mov    0x8(%ebp),%eax
  10133f:	ff d0                	call   *%eax
  101341:	89 45 f4             	mov    %eax,-0xc(%ebp)
  101344:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  101348:	75 bf                	jne    101309 <cons_intr+0x8>
            }
        }
    }
}
  10134a:	c9                   	leave  
  10134b:	c3                   	ret    

0010134c <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  10134c:	55                   	push   %ebp
  10134d:	89 e5                	mov    %esp,%ebp
  10134f:	83 ec 10             	sub    $0x10,%esp
  101352:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101358:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10135c:	89 c2                	mov    %eax,%edx
  10135e:	ec                   	in     (%dx),%al
  10135f:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101362:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  101366:	0f b6 c0             	movzbl %al,%eax
  101369:	83 e0 01             	and    $0x1,%eax
  10136c:	85 c0                	test   %eax,%eax
  10136e:	75 07                	jne    101377 <serial_proc_data+0x2b>
        return -1;
  101370:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101375:	eb 2a                	jmp    1013a1 <serial_proc_data+0x55>
  101377:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10137d:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  101381:	89 c2                	mov    %eax,%edx
  101383:	ec                   	in     (%dx),%al
  101384:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  101387:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  10138b:	0f b6 c0             	movzbl %al,%eax
  10138e:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  101391:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  101395:	75 07                	jne    10139e <serial_proc_data+0x52>
        c = '\b';
  101397:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  10139e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1013a1:	c9                   	leave  
  1013a2:	c3                   	ret    

001013a3 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  1013a3:	55                   	push   %ebp
  1013a4:	89 e5                	mov    %esp,%ebp
  1013a6:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  1013a9:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  1013ae:	85 c0                	test   %eax,%eax
  1013b0:	74 0c                	je     1013be <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  1013b2:	c7 04 24 4c 13 10 00 	movl   $0x10134c,(%esp)
  1013b9:	e8 43 ff ff ff       	call   101301 <cons_intr>
    }
}
  1013be:	c9                   	leave  
  1013bf:	c3                   	ret    

001013c0 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  1013c0:	55                   	push   %ebp
  1013c1:	89 e5                	mov    %esp,%ebp
  1013c3:	83 ec 38             	sub    $0x38,%esp
  1013c6:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013cc:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1013d0:	89 c2                	mov    %eax,%edx
  1013d2:	ec                   	in     (%dx),%al
  1013d3:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  1013d6:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  1013da:	0f b6 c0             	movzbl %al,%eax
  1013dd:	83 e0 01             	and    $0x1,%eax
  1013e0:	85 c0                	test   %eax,%eax
  1013e2:	75 0a                	jne    1013ee <kbd_proc_data+0x2e>
        return -1;
  1013e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013e9:	e9 59 01 00 00       	jmp    101547 <kbd_proc_data+0x187>
  1013ee:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013f4:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1013f8:	89 c2                	mov    %eax,%edx
  1013fa:	ec                   	in     (%dx),%al
  1013fb:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  1013fe:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  101402:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  101405:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  101409:	75 17                	jne    101422 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  10140b:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101410:	83 c8 40             	or     $0x40,%eax
  101413:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  101418:	b8 00 00 00 00       	mov    $0x0,%eax
  10141d:	e9 25 01 00 00       	jmp    101547 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
  101422:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101426:	84 c0                	test   %al,%al
  101428:	79 47                	jns    101471 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  10142a:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10142f:	83 e0 40             	and    $0x40,%eax
  101432:	85 c0                	test   %eax,%eax
  101434:	75 09                	jne    10143f <kbd_proc_data+0x7f>
  101436:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10143a:	83 e0 7f             	and    $0x7f,%eax
  10143d:	eb 04                	jmp    101443 <kbd_proc_data+0x83>
  10143f:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101443:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  101446:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10144a:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  101451:	83 c8 40             	or     $0x40,%eax
  101454:	0f b6 c0             	movzbl %al,%eax
  101457:	f7 d0                	not    %eax
  101459:	89 c2                	mov    %eax,%edx
  10145b:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101460:	21 d0                	and    %edx,%eax
  101462:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  101467:	b8 00 00 00 00       	mov    $0x0,%eax
  10146c:	e9 d6 00 00 00       	jmp    101547 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
  101471:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101476:	83 e0 40             	and    $0x40,%eax
  101479:	85 c0                	test   %eax,%eax
  10147b:	74 11                	je     10148e <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  10147d:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  101481:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101486:	83 e0 bf             	and    $0xffffffbf,%eax
  101489:	a3 88 f0 10 00       	mov    %eax,0x10f088
    }

    shift |= shiftcode[data];
  10148e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101492:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  101499:	0f b6 d0             	movzbl %al,%edx
  10149c:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014a1:	09 d0                	or     %edx,%eax
  1014a3:	a3 88 f0 10 00       	mov    %eax,0x10f088
    shift ^= togglecode[data];
  1014a8:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014ac:	0f b6 80 40 e1 10 00 	movzbl 0x10e140(%eax),%eax
  1014b3:	0f b6 d0             	movzbl %al,%edx
  1014b6:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014bb:	31 d0                	xor    %edx,%eax
  1014bd:	a3 88 f0 10 00       	mov    %eax,0x10f088

    c = charcode[shift & (CTL | SHIFT)][data];
  1014c2:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014c7:	83 e0 03             	and    $0x3,%eax
  1014ca:	8b 14 85 40 e5 10 00 	mov    0x10e540(,%eax,4),%edx
  1014d1:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014d5:	01 d0                	add    %edx,%eax
  1014d7:	0f b6 00             	movzbl (%eax),%eax
  1014da:	0f b6 c0             	movzbl %al,%eax
  1014dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  1014e0:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014e5:	83 e0 08             	and    $0x8,%eax
  1014e8:	85 c0                	test   %eax,%eax
  1014ea:	74 22                	je     10150e <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  1014ec:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  1014f0:	7e 0c                	jle    1014fe <kbd_proc_data+0x13e>
  1014f2:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  1014f6:	7f 06                	jg     1014fe <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  1014f8:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  1014fc:	eb 10                	jmp    10150e <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  1014fe:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  101502:	7e 0a                	jle    10150e <kbd_proc_data+0x14e>
  101504:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  101508:	7f 04                	jg     10150e <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  10150a:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  10150e:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101513:	f7 d0                	not    %eax
  101515:	83 e0 06             	and    $0x6,%eax
  101518:	85 c0                	test   %eax,%eax
  10151a:	75 28                	jne    101544 <kbd_proc_data+0x184>
  10151c:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  101523:	75 1f                	jne    101544 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
  101525:	c7 04 24 0d 36 10 00 	movl   $0x10360d,(%esp)
  10152c:	e8 2b ed ff ff       	call   10025c <cprintf>
  101531:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  101537:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10153b:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  10153f:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  101543:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  101544:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  101547:	c9                   	leave  
  101548:	c3                   	ret    

00101549 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  101549:	55                   	push   %ebp
  10154a:	89 e5                	mov    %esp,%ebp
  10154c:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  10154f:	c7 04 24 c0 13 10 00 	movl   $0x1013c0,(%esp)
  101556:	e8 a6 fd ff ff       	call   101301 <cons_intr>
}
  10155b:	c9                   	leave  
  10155c:	c3                   	ret    

0010155d <kbd_init>:

static void
kbd_init(void) {
  10155d:	55                   	push   %ebp
  10155e:	89 e5                	mov    %esp,%ebp
  101560:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  101563:	e8 e1 ff ff ff       	call   101549 <kbd_intr>
    pic_enable(IRQ_KBD);
  101568:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10156f:	e8 0b 01 00 00       	call   10167f <pic_enable>
}
  101574:	c9                   	leave  
  101575:	c3                   	ret    

00101576 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  101576:	55                   	push   %ebp
  101577:	89 e5                	mov    %esp,%ebp
  101579:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  10157c:	e8 93 f8 ff ff       	call   100e14 <cga_init>
    serial_init();
  101581:	e8 74 f9 ff ff       	call   100efa <serial_init>
    kbd_init();
  101586:	e8 d2 ff ff ff       	call   10155d <kbd_init>
    if (!serial_exists) {
  10158b:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  101590:	85 c0                	test   %eax,%eax
  101592:	75 0c                	jne    1015a0 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  101594:	c7 04 24 19 36 10 00 	movl   $0x103619,(%esp)
  10159b:	e8 bc ec ff ff       	call   10025c <cprintf>
    }
}
  1015a0:	c9                   	leave  
  1015a1:	c3                   	ret    

001015a2 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  1015a2:	55                   	push   %ebp
  1015a3:	89 e5                	mov    %esp,%ebp
  1015a5:	83 ec 18             	sub    $0x18,%esp
    lpt_putc(c);
  1015a8:	8b 45 08             	mov    0x8(%ebp),%eax
  1015ab:	89 04 24             	mov    %eax,(%esp)
  1015ae:	e8 a3 fa ff ff       	call   101056 <lpt_putc>
    cga_putc(c);
  1015b3:	8b 45 08             	mov    0x8(%ebp),%eax
  1015b6:	89 04 24             	mov    %eax,(%esp)
  1015b9:	e8 d7 fa ff ff       	call   101095 <cga_putc>
    serial_putc(c);
  1015be:	8b 45 08             	mov    0x8(%ebp),%eax
  1015c1:	89 04 24             	mov    %eax,(%esp)
  1015c4:	e8 f9 fc ff ff       	call   1012c2 <serial_putc>
}
  1015c9:	c9                   	leave  
  1015ca:	c3                   	ret    

001015cb <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  1015cb:	55                   	push   %ebp
  1015cc:	89 e5                	mov    %esp,%ebp
  1015ce:	83 ec 18             	sub    $0x18,%esp
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  1015d1:	e8 cd fd ff ff       	call   1013a3 <serial_intr>
    kbd_intr();
  1015d6:	e8 6e ff ff ff       	call   101549 <kbd_intr>

    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  1015db:	8b 15 80 f0 10 00    	mov    0x10f080,%edx
  1015e1:	a1 84 f0 10 00       	mov    0x10f084,%eax
  1015e6:	39 c2                	cmp    %eax,%edx
  1015e8:	74 36                	je     101620 <cons_getc+0x55>
        c = cons.buf[cons.rpos ++];
  1015ea:	a1 80 f0 10 00       	mov    0x10f080,%eax
  1015ef:	8d 50 01             	lea    0x1(%eax),%edx
  1015f2:	89 15 80 f0 10 00    	mov    %edx,0x10f080
  1015f8:	0f b6 80 80 ee 10 00 	movzbl 0x10ee80(%eax),%eax
  1015ff:	0f b6 c0             	movzbl %al,%eax
  101602:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (cons.rpos == CONSBUFSIZE) {
  101605:	a1 80 f0 10 00       	mov    0x10f080,%eax
  10160a:	3d 00 02 00 00       	cmp    $0x200,%eax
  10160f:	75 0a                	jne    10161b <cons_getc+0x50>
            cons.rpos = 0;
  101611:	c7 05 80 f0 10 00 00 	movl   $0x0,0x10f080
  101618:	00 00 00 
        }
        return c;
  10161b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10161e:	eb 05                	jmp    101625 <cons_getc+0x5a>
    }
    return 0;
  101620:	b8 00 00 00 00       	mov    $0x0,%eax
}
  101625:	c9                   	leave  
  101626:	c3                   	ret    

00101627 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  101627:	55                   	push   %ebp
  101628:	89 e5                	mov    %esp,%ebp
  10162a:	83 ec 14             	sub    $0x14,%esp
  10162d:	8b 45 08             	mov    0x8(%ebp),%eax
  101630:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  101634:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101638:	66 a3 50 e5 10 00    	mov    %ax,0x10e550
    if (did_init) {
  10163e:	a1 8c f0 10 00       	mov    0x10f08c,%eax
  101643:	85 c0                	test   %eax,%eax
  101645:	74 36                	je     10167d <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  101647:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10164b:	0f b6 c0             	movzbl %al,%eax
  10164e:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  101654:	88 45 fd             	mov    %al,-0x3(%ebp)
  101657:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  10165b:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  10165f:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  101660:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101664:	66 c1 e8 08          	shr    $0x8,%ax
  101668:	0f b6 c0             	movzbl %al,%eax
  10166b:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  101671:	88 45 f9             	mov    %al,-0x7(%ebp)
  101674:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101678:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10167c:	ee                   	out    %al,(%dx)
    }
}
  10167d:	c9                   	leave  
  10167e:	c3                   	ret    

0010167f <pic_enable>:

void
pic_enable(unsigned int irq) {
  10167f:	55                   	push   %ebp
  101680:	89 e5                	mov    %esp,%ebp
  101682:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  101685:	8b 45 08             	mov    0x8(%ebp),%eax
  101688:	ba 01 00 00 00       	mov    $0x1,%edx
  10168d:	89 c1                	mov    %eax,%ecx
  10168f:	d3 e2                	shl    %cl,%edx
  101691:	89 d0                	mov    %edx,%eax
  101693:	f7 d0                	not    %eax
  101695:	89 c2                	mov    %eax,%edx
  101697:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  10169e:	21 d0                	and    %edx,%eax
  1016a0:	0f b7 c0             	movzwl %ax,%eax
  1016a3:	89 04 24             	mov    %eax,(%esp)
  1016a6:	e8 7c ff ff ff       	call   101627 <pic_setmask>
}
  1016ab:	c9                   	leave  
  1016ac:	c3                   	ret    

001016ad <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  1016ad:	55                   	push   %ebp
  1016ae:	89 e5                	mov    %esp,%ebp
  1016b0:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  1016b3:	c7 05 8c f0 10 00 01 	movl   $0x1,0x10f08c
  1016ba:	00 00 00 
  1016bd:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  1016c3:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
  1016c7:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1016cb:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1016cf:	ee                   	out    %al,(%dx)
  1016d0:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  1016d6:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
  1016da:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1016de:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1016e2:	ee                   	out    %al,(%dx)
  1016e3:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  1016e9:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
  1016ed:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1016f1:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1016f5:	ee                   	out    %al,(%dx)
  1016f6:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
  1016fc:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
  101700:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101704:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101708:	ee                   	out    %al,(%dx)
  101709:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
  10170f:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
  101713:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101717:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10171b:	ee                   	out    %al,(%dx)
  10171c:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
  101722:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
  101726:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10172a:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10172e:	ee                   	out    %al,(%dx)
  10172f:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  101735:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
  101739:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  10173d:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101741:	ee                   	out    %al,(%dx)
  101742:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
  101748:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
  10174c:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  101750:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  101754:	ee                   	out    %al,(%dx)
  101755:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
  10175b:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
  10175f:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  101763:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  101767:	ee                   	out    %al,(%dx)
  101768:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
  10176e:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
  101772:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  101776:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  10177a:	ee                   	out    %al,(%dx)
  10177b:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
  101781:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
  101785:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  101789:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  10178d:	ee                   	out    %al,(%dx)
  10178e:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  101794:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
  101798:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  10179c:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  1017a0:	ee                   	out    %al,(%dx)
  1017a1:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
  1017a7:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
  1017ab:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  1017af:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  1017b3:	ee                   	out    %al,(%dx)
  1017b4:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
  1017ba:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
  1017be:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  1017c2:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  1017c6:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  1017c7:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017ce:	66 83 f8 ff          	cmp    $0xffff,%ax
  1017d2:	74 12                	je     1017e6 <pic_init+0x139>
        pic_setmask(irq_mask);
  1017d4:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017db:	0f b7 c0             	movzwl %ax,%eax
  1017de:	89 04 24             	mov    %eax,(%esp)
  1017e1:	e8 41 fe ff ff       	call   101627 <pic_setmask>
    }
}
  1017e6:	c9                   	leave  
  1017e7:	c3                   	ret    

001017e8 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  1017e8:	55                   	push   %ebp
  1017e9:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd));
}

static inline void
sti(void) {
    asm volatile ("sti");
  1017eb:	fb                   	sti    
    sti();
}
  1017ec:	5d                   	pop    %ebp
  1017ed:	c3                   	ret    

001017ee <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  1017ee:	55                   	push   %ebp
  1017ef:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli");
  1017f1:	fa                   	cli    
    cli();
}
  1017f2:	5d                   	pop    %ebp
  1017f3:	c3                   	ret    

001017f4 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  1017f4:	55                   	push   %ebp
  1017f5:	89 e5                	mov    %esp,%ebp
  1017f7:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  1017fa:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  101801:	00 
  101802:	c7 04 24 40 36 10 00 	movl   $0x103640,(%esp)
  101809:	e8 4e ea ff ff       	call   10025c <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
  10180e:	c9                   	leave  
  10180f:	c3                   	ret    

00101810 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  101810:	55                   	push   %ebp
  101811:	89 e5                	mov    %esp,%ebp
      *     Can you see idt[256] in this file? Yes, it's IDT! you can use SETGATE macro to setup each item of IDT
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
}
  101813:	5d                   	pop    %ebp
  101814:	c3                   	ret    

00101815 <trapname>:

static const char *
trapname(int trapno) {
  101815:	55                   	push   %ebp
  101816:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101818:	8b 45 08             	mov    0x8(%ebp),%eax
  10181b:	83 f8 13             	cmp    $0x13,%eax
  10181e:	77 0c                	ja     10182c <trapname+0x17>
        return excnames[trapno];
  101820:	8b 45 08             	mov    0x8(%ebp),%eax
  101823:	8b 04 85 a0 39 10 00 	mov    0x1039a0(,%eax,4),%eax
  10182a:	eb 18                	jmp    101844 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  10182c:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101830:	7e 0d                	jle    10183f <trapname+0x2a>
  101832:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101836:	7f 07                	jg     10183f <trapname+0x2a>
        return "Hardware Interrupt";
  101838:	b8 4a 36 10 00       	mov    $0x10364a,%eax
  10183d:	eb 05                	jmp    101844 <trapname+0x2f>
    }
    return "(unknown trap)";
  10183f:	b8 5d 36 10 00       	mov    $0x10365d,%eax
}
  101844:	5d                   	pop    %ebp
  101845:	c3                   	ret    

00101846 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101846:	55                   	push   %ebp
  101847:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101849:	8b 45 08             	mov    0x8(%ebp),%eax
  10184c:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101850:	66 83 f8 08          	cmp    $0x8,%ax
  101854:	0f 94 c0             	sete   %al
  101857:	0f b6 c0             	movzbl %al,%eax
}
  10185a:	5d                   	pop    %ebp
  10185b:	c3                   	ret    

0010185c <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  10185c:	55                   	push   %ebp
  10185d:	89 e5                	mov    %esp,%ebp
  10185f:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101862:	8b 45 08             	mov    0x8(%ebp),%eax
  101865:	89 44 24 04          	mov    %eax,0x4(%esp)
  101869:	c7 04 24 9e 36 10 00 	movl   $0x10369e,(%esp)
  101870:	e8 e7 e9 ff ff       	call   10025c <cprintf>
    print_regs(&tf->tf_regs);
  101875:	8b 45 08             	mov    0x8(%ebp),%eax
  101878:	89 04 24             	mov    %eax,(%esp)
  10187b:	e8 a1 01 00 00       	call   101a21 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101880:	8b 45 08             	mov    0x8(%ebp),%eax
  101883:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101887:	0f b7 c0             	movzwl %ax,%eax
  10188a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10188e:	c7 04 24 af 36 10 00 	movl   $0x1036af,(%esp)
  101895:	e8 c2 e9 ff ff       	call   10025c <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  10189a:	8b 45 08             	mov    0x8(%ebp),%eax
  10189d:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  1018a1:	0f b7 c0             	movzwl %ax,%eax
  1018a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1018a8:	c7 04 24 c2 36 10 00 	movl   $0x1036c2,(%esp)
  1018af:	e8 a8 e9 ff ff       	call   10025c <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  1018b4:	8b 45 08             	mov    0x8(%ebp),%eax
  1018b7:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  1018bb:	0f b7 c0             	movzwl %ax,%eax
  1018be:	89 44 24 04          	mov    %eax,0x4(%esp)
  1018c2:	c7 04 24 d5 36 10 00 	movl   $0x1036d5,(%esp)
  1018c9:	e8 8e e9 ff ff       	call   10025c <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  1018ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1018d1:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  1018d5:	0f b7 c0             	movzwl %ax,%eax
  1018d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1018dc:	c7 04 24 e8 36 10 00 	movl   $0x1036e8,(%esp)
  1018e3:	e8 74 e9 ff ff       	call   10025c <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  1018e8:	8b 45 08             	mov    0x8(%ebp),%eax
  1018eb:	8b 40 30             	mov    0x30(%eax),%eax
  1018ee:	89 04 24             	mov    %eax,(%esp)
  1018f1:	e8 1f ff ff ff       	call   101815 <trapname>
  1018f6:	8b 55 08             	mov    0x8(%ebp),%edx
  1018f9:	8b 52 30             	mov    0x30(%edx),%edx
  1018fc:	89 44 24 08          	mov    %eax,0x8(%esp)
  101900:	89 54 24 04          	mov    %edx,0x4(%esp)
  101904:	c7 04 24 fb 36 10 00 	movl   $0x1036fb,(%esp)
  10190b:	e8 4c e9 ff ff       	call   10025c <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101910:	8b 45 08             	mov    0x8(%ebp),%eax
  101913:	8b 40 34             	mov    0x34(%eax),%eax
  101916:	89 44 24 04          	mov    %eax,0x4(%esp)
  10191a:	c7 04 24 0d 37 10 00 	movl   $0x10370d,(%esp)
  101921:	e8 36 e9 ff ff       	call   10025c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101926:	8b 45 08             	mov    0x8(%ebp),%eax
  101929:	8b 40 38             	mov    0x38(%eax),%eax
  10192c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101930:	c7 04 24 1c 37 10 00 	movl   $0x10371c,(%esp)
  101937:	e8 20 e9 ff ff       	call   10025c <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  10193c:	8b 45 08             	mov    0x8(%ebp),%eax
  10193f:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101943:	0f b7 c0             	movzwl %ax,%eax
  101946:	89 44 24 04          	mov    %eax,0x4(%esp)
  10194a:	c7 04 24 2b 37 10 00 	movl   $0x10372b,(%esp)
  101951:	e8 06 e9 ff ff       	call   10025c <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101956:	8b 45 08             	mov    0x8(%ebp),%eax
  101959:	8b 40 40             	mov    0x40(%eax),%eax
  10195c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101960:	c7 04 24 3e 37 10 00 	movl   $0x10373e,(%esp)
  101967:	e8 f0 e8 ff ff       	call   10025c <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  10196c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101973:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  10197a:	eb 3e                	jmp    1019ba <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  10197c:	8b 45 08             	mov    0x8(%ebp),%eax
  10197f:	8b 50 40             	mov    0x40(%eax),%edx
  101982:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101985:	21 d0                	and    %edx,%eax
  101987:	85 c0                	test   %eax,%eax
  101989:	74 28                	je     1019b3 <print_trapframe+0x157>
  10198b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10198e:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101995:	85 c0                	test   %eax,%eax
  101997:	74 1a                	je     1019b3 <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
  101999:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10199c:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  1019a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1019a7:	c7 04 24 4d 37 10 00 	movl   $0x10374d,(%esp)
  1019ae:	e8 a9 e8 ff ff       	call   10025c <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  1019b3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1019b7:	d1 65 f0             	shll   -0x10(%ebp)
  1019ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1019bd:	83 f8 17             	cmp    $0x17,%eax
  1019c0:	76 ba                	jbe    10197c <print_trapframe+0x120>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  1019c2:	8b 45 08             	mov    0x8(%ebp),%eax
  1019c5:	8b 40 40             	mov    0x40(%eax),%eax
  1019c8:	25 00 30 00 00       	and    $0x3000,%eax
  1019cd:	c1 e8 0c             	shr    $0xc,%eax
  1019d0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1019d4:	c7 04 24 51 37 10 00 	movl   $0x103751,(%esp)
  1019db:	e8 7c e8 ff ff       	call   10025c <cprintf>

    if (!trap_in_kernel(tf)) {
  1019e0:	8b 45 08             	mov    0x8(%ebp),%eax
  1019e3:	89 04 24             	mov    %eax,(%esp)
  1019e6:	e8 5b fe ff ff       	call   101846 <trap_in_kernel>
  1019eb:	85 c0                	test   %eax,%eax
  1019ed:	75 30                	jne    101a1f <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  1019ef:	8b 45 08             	mov    0x8(%ebp),%eax
  1019f2:	8b 40 44             	mov    0x44(%eax),%eax
  1019f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1019f9:	c7 04 24 5a 37 10 00 	movl   $0x10375a,(%esp)
  101a00:	e8 57 e8 ff ff       	call   10025c <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101a05:	8b 45 08             	mov    0x8(%ebp),%eax
  101a08:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101a0c:	0f b7 c0             	movzwl %ax,%eax
  101a0f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a13:	c7 04 24 69 37 10 00 	movl   $0x103769,(%esp)
  101a1a:	e8 3d e8 ff ff       	call   10025c <cprintf>
    }
}
  101a1f:	c9                   	leave  
  101a20:	c3                   	ret    

00101a21 <print_regs>:

void
print_regs(struct pushregs *regs) {
  101a21:	55                   	push   %ebp
  101a22:	89 e5                	mov    %esp,%ebp
  101a24:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101a27:	8b 45 08             	mov    0x8(%ebp),%eax
  101a2a:	8b 00                	mov    (%eax),%eax
  101a2c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a30:	c7 04 24 7c 37 10 00 	movl   $0x10377c,(%esp)
  101a37:	e8 20 e8 ff ff       	call   10025c <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  101a3f:	8b 40 04             	mov    0x4(%eax),%eax
  101a42:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a46:	c7 04 24 8b 37 10 00 	movl   $0x10378b,(%esp)
  101a4d:	e8 0a e8 ff ff       	call   10025c <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101a52:	8b 45 08             	mov    0x8(%ebp),%eax
  101a55:	8b 40 08             	mov    0x8(%eax),%eax
  101a58:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a5c:	c7 04 24 9a 37 10 00 	movl   $0x10379a,(%esp)
  101a63:	e8 f4 e7 ff ff       	call   10025c <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101a68:	8b 45 08             	mov    0x8(%ebp),%eax
  101a6b:	8b 40 0c             	mov    0xc(%eax),%eax
  101a6e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a72:	c7 04 24 a9 37 10 00 	movl   $0x1037a9,(%esp)
  101a79:	e8 de e7 ff ff       	call   10025c <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101a7e:	8b 45 08             	mov    0x8(%ebp),%eax
  101a81:	8b 40 10             	mov    0x10(%eax),%eax
  101a84:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a88:	c7 04 24 b8 37 10 00 	movl   $0x1037b8,(%esp)
  101a8f:	e8 c8 e7 ff ff       	call   10025c <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101a94:	8b 45 08             	mov    0x8(%ebp),%eax
  101a97:	8b 40 14             	mov    0x14(%eax),%eax
  101a9a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a9e:	c7 04 24 c7 37 10 00 	movl   $0x1037c7,(%esp)
  101aa5:	e8 b2 e7 ff ff       	call   10025c <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101aaa:	8b 45 08             	mov    0x8(%ebp),%eax
  101aad:	8b 40 18             	mov    0x18(%eax),%eax
  101ab0:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ab4:	c7 04 24 d6 37 10 00 	movl   $0x1037d6,(%esp)
  101abb:	e8 9c e7 ff ff       	call   10025c <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101ac0:	8b 45 08             	mov    0x8(%ebp),%eax
  101ac3:	8b 40 1c             	mov    0x1c(%eax),%eax
  101ac6:	89 44 24 04          	mov    %eax,0x4(%esp)
  101aca:	c7 04 24 e5 37 10 00 	movl   $0x1037e5,(%esp)
  101ad1:	e8 86 e7 ff ff       	call   10025c <cprintf>
}
  101ad6:	c9                   	leave  
  101ad7:	c3                   	ret    

00101ad8 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101ad8:	55                   	push   %ebp
  101ad9:	89 e5                	mov    %esp,%ebp
  101adb:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
  101ade:	8b 45 08             	mov    0x8(%ebp),%eax
  101ae1:	8b 40 30             	mov    0x30(%eax),%eax
  101ae4:	83 f8 2f             	cmp    $0x2f,%eax
  101ae7:	77 1e                	ja     101b07 <trap_dispatch+0x2f>
  101ae9:	83 f8 2e             	cmp    $0x2e,%eax
  101aec:	0f 83 bf 00 00 00    	jae    101bb1 <trap_dispatch+0xd9>
  101af2:	83 f8 21             	cmp    $0x21,%eax
  101af5:	74 40                	je     101b37 <trap_dispatch+0x5f>
  101af7:	83 f8 24             	cmp    $0x24,%eax
  101afa:	74 15                	je     101b11 <trap_dispatch+0x39>
  101afc:	83 f8 20             	cmp    $0x20,%eax
  101aff:	0f 84 af 00 00 00    	je     101bb4 <trap_dispatch+0xdc>
  101b05:	eb 72                	jmp    101b79 <trap_dispatch+0xa1>
  101b07:	83 e8 78             	sub    $0x78,%eax
  101b0a:	83 f8 01             	cmp    $0x1,%eax
  101b0d:	77 6a                	ja     101b79 <trap_dispatch+0xa1>
  101b0f:	eb 4c                	jmp    101b5d <trap_dispatch+0x85>
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        break;
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101b11:	e8 b5 fa ff ff       	call   1015cb <cons_getc>
  101b16:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101b19:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101b1d:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101b21:	89 54 24 08          	mov    %edx,0x8(%esp)
  101b25:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b29:	c7 04 24 f4 37 10 00 	movl   $0x1037f4,(%esp)
  101b30:	e8 27 e7 ff ff       	call   10025c <cprintf>
        break;
  101b35:	eb 7e                	jmp    101bb5 <trap_dispatch+0xdd>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101b37:	e8 8f fa ff ff       	call   1015cb <cons_getc>
  101b3c:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101b3f:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101b43:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101b47:	89 54 24 08          	mov    %edx,0x8(%esp)
  101b4b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b4f:	c7 04 24 06 38 10 00 	movl   $0x103806,(%esp)
  101b56:	e8 01 e7 ff ff       	call   10025c <cprintf>
        break;
  101b5b:	eb 58                	jmp    101bb5 <trap_dispatch+0xdd>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
  101b5d:	c7 44 24 08 15 38 10 	movl   $0x103815,0x8(%esp)
  101b64:	00 
  101b65:	c7 44 24 04 a2 00 00 	movl   $0xa2,0x4(%esp)
  101b6c:	00 
  101b6d:	c7 04 24 25 38 10 00 	movl   $0x103825,(%esp)
  101b74:	e8 3a e8 ff ff       	call   1003b3 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101b79:	8b 45 08             	mov    0x8(%ebp),%eax
  101b7c:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101b80:	0f b7 c0             	movzwl %ax,%eax
  101b83:	83 e0 03             	and    $0x3,%eax
  101b86:	85 c0                	test   %eax,%eax
  101b88:	75 2b                	jne    101bb5 <trap_dispatch+0xdd>
            print_trapframe(tf);
  101b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  101b8d:	89 04 24             	mov    %eax,(%esp)
  101b90:	e8 c7 fc ff ff       	call   10185c <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101b95:	c7 44 24 08 36 38 10 	movl   $0x103836,0x8(%esp)
  101b9c:	00 
  101b9d:	c7 44 24 04 ac 00 00 	movl   $0xac,0x4(%esp)
  101ba4:	00 
  101ba5:	c7 04 24 25 38 10 00 	movl   $0x103825,(%esp)
  101bac:	e8 02 e8 ff ff       	call   1003b3 <__panic>
        break;
  101bb1:	90                   	nop
  101bb2:	eb 01                	jmp    101bb5 <trap_dispatch+0xdd>
        break;
  101bb4:	90                   	nop
        }
    }
}
  101bb5:	c9                   	leave  
  101bb6:	c3                   	ret    

00101bb7 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101bb7:	55                   	push   %ebp
  101bb8:	89 e5                	mov    %esp,%ebp
  101bba:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101bbd:	8b 45 08             	mov    0x8(%ebp),%eax
  101bc0:	89 04 24             	mov    %eax,(%esp)
  101bc3:	e8 10 ff ff ff       	call   101ad8 <trap_dispatch>
}
  101bc8:	c9                   	leave  
  101bc9:	c3                   	ret    

00101bca <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101bca:	6a 00                	push   $0x0
  pushl $0
  101bcc:	6a 00                	push   $0x0
  jmp __alltraps
  101bce:	e9 69 0a 00 00       	jmp    10263c <__alltraps>

00101bd3 <vector1>:
.globl vector1
vector1:
  pushl $0
  101bd3:	6a 00                	push   $0x0
  pushl $1
  101bd5:	6a 01                	push   $0x1
  jmp __alltraps
  101bd7:	e9 60 0a 00 00       	jmp    10263c <__alltraps>

00101bdc <vector2>:
.globl vector2
vector2:
  pushl $0
  101bdc:	6a 00                	push   $0x0
  pushl $2
  101bde:	6a 02                	push   $0x2
  jmp __alltraps
  101be0:	e9 57 0a 00 00       	jmp    10263c <__alltraps>

00101be5 <vector3>:
.globl vector3
vector3:
  pushl $0
  101be5:	6a 00                	push   $0x0
  pushl $3
  101be7:	6a 03                	push   $0x3
  jmp __alltraps
  101be9:	e9 4e 0a 00 00       	jmp    10263c <__alltraps>

00101bee <vector4>:
.globl vector4
vector4:
  pushl $0
  101bee:	6a 00                	push   $0x0
  pushl $4
  101bf0:	6a 04                	push   $0x4
  jmp __alltraps
  101bf2:	e9 45 0a 00 00       	jmp    10263c <__alltraps>

00101bf7 <vector5>:
.globl vector5
vector5:
  pushl $0
  101bf7:	6a 00                	push   $0x0
  pushl $5
  101bf9:	6a 05                	push   $0x5
  jmp __alltraps
  101bfb:	e9 3c 0a 00 00       	jmp    10263c <__alltraps>

00101c00 <vector6>:
.globl vector6
vector6:
  pushl $0
  101c00:	6a 00                	push   $0x0
  pushl $6
  101c02:	6a 06                	push   $0x6
  jmp __alltraps
  101c04:	e9 33 0a 00 00       	jmp    10263c <__alltraps>

00101c09 <vector7>:
.globl vector7
vector7:
  pushl $0
  101c09:	6a 00                	push   $0x0
  pushl $7
  101c0b:	6a 07                	push   $0x7
  jmp __alltraps
  101c0d:	e9 2a 0a 00 00       	jmp    10263c <__alltraps>

00101c12 <vector8>:
.globl vector8
vector8:
  pushl $8
  101c12:	6a 08                	push   $0x8
  jmp __alltraps
  101c14:	e9 23 0a 00 00       	jmp    10263c <__alltraps>

00101c19 <vector9>:
.globl vector9
vector9:
  pushl $0
  101c19:	6a 00                	push   $0x0
  pushl $9
  101c1b:	6a 09                	push   $0x9
  jmp __alltraps
  101c1d:	e9 1a 0a 00 00       	jmp    10263c <__alltraps>

00101c22 <vector10>:
.globl vector10
vector10:
  pushl $10
  101c22:	6a 0a                	push   $0xa
  jmp __alltraps
  101c24:	e9 13 0a 00 00       	jmp    10263c <__alltraps>

00101c29 <vector11>:
.globl vector11
vector11:
  pushl $11
  101c29:	6a 0b                	push   $0xb
  jmp __alltraps
  101c2b:	e9 0c 0a 00 00       	jmp    10263c <__alltraps>

00101c30 <vector12>:
.globl vector12
vector12:
  pushl $12
  101c30:	6a 0c                	push   $0xc
  jmp __alltraps
  101c32:	e9 05 0a 00 00       	jmp    10263c <__alltraps>

00101c37 <vector13>:
.globl vector13
vector13:
  pushl $13
  101c37:	6a 0d                	push   $0xd
  jmp __alltraps
  101c39:	e9 fe 09 00 00       	jmp    10263c <__alltraps>

00101c3e <vector14>:
.globl vector14
vector14:
  pushl $14
  101c3e:	6a 0e                	push   $0xe
  jmp __alltraps
  101c40:	e9 f7 09 00 00       	jmp    10263c <__alltraps>

00101c45 <vector15>:
.globl vector15
vector15:
  pushl $0
  101c45:	6a 00                	push   $0x0
  pushl $15
  101c47:	6a 0f                	push   $0xf
  jmp __alltraps
  101c49:	e9 ee 09 00 00       	jmp    10263c <__alltraps>

00101c4e <vector16>:
.globl vector16
vector16:
  pushl $0
  101c4e:	6a 00                	push   $0x0
  pushl $16
  101c50:	6a 10                	push   $0x10
  jmp __alltraps
  101c52:	e9 e5 09 00 00       	jmp    10263c <__alltraps>

00101c57 <vector17>:
.globl vector17
vector17:
  pushl $17
  101c57:	6a 11                	push   $0x11
  jmp __alltraps
  101c59:	e9 de 09 00 00       	jmp    10263c <__alltraps>

00101c5e <vector18>:
.globl vector18
vector18:
  pushl $0
  101c5e:	6a 00                	push   $0x0
  pushl $18
  101c60:	6a 12                	push   $0x12
  jmp __alltraps
  101c62:	e9 d5 09 00 00       	jmp    10263c <__alltraps>

00101c67 <vector19>:
.globl vector19
vector19:
  pushl $0
  101c67:	6a 00                	push   $0x0
  pushl $19
  101c69:	6a 13                	push   $0x13
  jmp __alltraps
  101c6b:	e9 cc 09 00 00       	jmp    10263c <__alltraps>

00101c70 <vector20>:
.globl vector20
vector20:
  pushl $0
  101c70:	6a 00                	push   $0x0
  pushl $20
  101c72:	6a 14                	push   $0x14
  jmp __alltraps
  101c74:	e9 c3 09 00 00       	jmp    10263c <__alltraps>

00101c79 <vector21>:
.globl vector21
vector21:
  pushl $0
  101c79:	6a 00                	push   $0x0
  pushl $21
  101c7b:	6a 15                	push   $0x15
  jmp __alltraps
  101c7d:	e9 ba 09 00 00       	jmp    10263c <__alltraps>

00101c82 <vector22>:
.globl vector22
vector22:
  pushl $0
  101c82:	6a 00                	push   $0x0
  pushl $22
  101c84:	6a 16                	push   $0x16
  jmp __alltraps
  101c86:	e9 b1 09 00 00       	jmp    10263c <__alltraps>

00101c8b <vector23>:
.globl vector23
vector23:
  pushl $0
  101c8b:	6a 00                	push   $0x0
  pushl $23
  101c8d:	6a 17                	push   $0x17
  jmp __alltraps
  101c8f:	e9 a8 09 00 00       	jmp    10263c <__alltraps>

00101c94 <vector24>:
.globl vector24
vector24:
  pushl $0
  101c94:	6a 00                	push   $0x0
  pushl $24
  101c96:	6a 18                	push   $0x18
  jmp __alltraps
  101c98:	e9 9f 09 00 00       	jmp    10263c <__alltraps>

00101c9d <vector25>:
.globl vector25
vector25:
  pushl $0
  101c9d:	6a 00                	push   $0x0
  pushl $25
  101c9f:	6a 19                	push   $0x19
  jmp __alltraps
  101ca1:	e9 96 09 00 00       	jmp    10263c <__alltraps>

00101ca6 <vector26>:
.globl vector26
vector26:
  pushl $0
  101ca6:	6a 00                	push   $0x0
  pushl $26
  101ca8:	6a 1a                	push   $0x1a
  jmp __alltraps
  101caa:	e9 8d 09 00 00       	jmp    10263c <__alltraps>

00101caf <vector27>:
.globl vector27
vector27:
  pushl $0
  101caf:	6a 00                	push   $0x0
  pushl $27
  101cb1:	6a 1b                	push   $0x1b
  jmp __alltraps
  101cb3:	e9 84 09 00 00       	jmp    10263c <__alltraps>

00101cb8 <vector28>:
.globl vector28
vector28:
  pushl $0
  101cb8:	6a 00                	push   $0x0
  pushl $28
  101cba:	6a 1c                	push   $0x1c
  jmp __alltraps
  101cbc:	e9 7b 09 00 00       	jmp    10263c <__alltraps>

00101cc1 <vector29>:
.globl vector29
vector29:
  pushl $0
  101cc1:	6a 00                	push   $0x0
  pushl $29
  101cc3:	6a 1d                	push   $0x1d
  jmp __alltraps
  101cc5:	e9 72 09 00 00       	jmp    10263c <__alltraps>

00101cca <vector30>:
.globl vector30
vector30:
  pushl $0
  101cca:	6a 00                	push   $0x0
  pushl $30
  101ccc:	6a 1e                	push   $0x1e
  jmp __alltraps
  101cce:	e9 69 09 00 00       	jmp    10263c <__alltraps>

00101cd3 <vector31>:
.globl vector31
vector31:
  pushl $0
  101cd3:	6a 00                	push   $0x0
  pushl $31
  101cd5:	6a 1f                	push   $0x1f
  jmp __alltraps
  101cd7:	e9 60 09 00 00       	jmp    10263c <__alltraps>

00101cdc <vector32>:
.globl vector32
vector32:
  pushl $0
  101cdc:	6a 00                	push   $0x0
  pushl $32
  101cde:	6a 20                	push   $0x20
  jmp __alltraps
  101ce0:	e9 57 09 00 00       	jmp    10263c <__alltraps>

00101ce5 <vector33>:
.globl vector33
vector33:
  pushl $0
  101ce5:	6a 00                	push   $0x0
  pushl $33
  101ce7:	6a 21                	push   $0x21
  jmp __alltraps
  101ce9:	e9 4e 09 00 00       	jmp    10263c <__alltraps>

00101cee <vector34>:
.globl vector34
vector34:
  pushl $0
  101cee:	6a 00                	push   $0x0
  pushl $34
  101cf0:	6a 22                	push   $0x22
  jmp __alltraps
  101cf2:	e9 45 09 00 00       	jmp    10263c <__alltraps>

00101cf7 <vector35>:
.globl vector35
vector35:
  pushl $0
  101cf7:	6a 00                	push   $0x0
  pushl $35
  101cf9:	6a 23                	push   $0x23
  jmp __alltraps
  101cfb:	e9 3c 09 00 00       	jmp    10263c <__alltraps>

00101d00 <vector36>:
.globl vector36
vector36:
  pushl $0
  101d00:	6a 00                	push   $0x0
  pushl $36
  101d02:	6a 24                	push   $0x24
  jmp __alltraps
  101d04:	e9 33 09 00 00       	jmp    10263c <__alltraps>

00101d09 <vector37>:
.globl vector37
vector37:
  pushl $0
  101d09:	6a 00                	push   $0x0
  pushl $37
  101d0b:	6a 25                	push   $0x25
  jmp __alltraps
  101d0d:	e9 2a 09 00 00       	jmp    10263c <__alltraps>

00101d12 <vector38>:
.globl vector38
vector38:
  pushl $0
  101d12:	6a 00                	push   $0x0
  pushl $38
  101d14:	6a 26                	push   $0x26
  jmp __alltraps
  101d16:	e9 21 09 00 00       	jmp    10263c <__alltraps>

00101d1b <vector39>:
.globl vector39
vector39:
  pushl $0
  101d1b:	6a 00                	push   $0x0
  pushl $39
  101d1d:	6a 27                	push   $0x27
  jmp __alltraps
  101d1f:	e9 18 09 00 00       	jmp    10263c <__alltraps>

00101d24 <vector40>:
.globl vector40
vector40:
  pushl $0
  101d24:	6a 00                	push   $0x0
  pushl $40
  101d26:	6a 28                	push   $0x28
  jmp __alltraps
  101d28:	e9 0f 09 00 00       	jmp    10263c <__alltraps>

00101d2d <vector41>:
.globl vector41
vector41:
  pushl $0
  101d2d:	6a 00                	push   $0x0
  pushl $41
  101d2f:	6a 29                	push   $0x29
  jmp __alltraps
  101d31:	e9 06 09 00 00       	jmp    10263c <__alltraps>

00101d36 <vector42>:
.globl vector42
vector42:
  pushl $0
  101d36:	6a 00                	push   $0x0
  pushl $42
  101d38:	6a 2a                	push   $0x2a
  jmp __alltraps
  101d3a:	e9 fd 08 00 00       	jmp    10263c <__alltraps>

00101d3f <vector43>:
.globl vector43
vector43:
  pushl $0
  101d3f:	6a 00                	push   $0x0
  pushl $43
  101d41:	6a 2b                	push   $0x2b
  jmp __alltraps
  101d43:	e9 f4 08 00 00       	jmp    10263c <__alltraps>

00101d48 <vector44>:
.globl vector44
vector44:
  pushl $0
  101d48:	6a 00                	push   $0x0
  pushl $44
  101d4a:	6a 2c                	push   $0x2c
  jmp __alltraps
  101d4c:	e9 eb 08 00 00       	jmp    10263c <__alltraps>

00101d51 <vector45>:
.globl vector45
vector45:
  pushl $0
  101d51:	6a 00                	push   $0x0
  pushl $45
  101d53:	6a 2d                	push   $0x2d
  jmp __alltraps
  101d55:	e9 e2 08 00 00       	jmp    10263c <__alltraps>

00101d5a <vector46>:
.globl vector46
vector46:
  pushl $0
  101d5a:	6a 00                	push   $0x0
  pushl $46
  101d5c:	6a 2e                	push   $0x2e
  jmp __alltraps
  101d5e:	e9 d9 08 00 00       	jmp    10263c <__alltraps>

00101d63 <vector47>:
.globl vector47
vector47:
  pushl $0
  101d63:	6a 00                	push   $0x0
  pushl $47
  101d65:	6a 2f                	push   $0x2f
  jmp __alltraps
  101d67:	e9 d0 08 00 00       	jmp    10263c <__alltraps>

00101d6c <vector48>:
.globl vector48
vector48:
  pushl $0
  101d6c:	6a 00                	push   $0x0
  pushl $48
  101d6e:	6a 30                	push   $0x30
  jmp __alltraps
  101d70:	e9 c7 08 00 00       	jmp    10263c <__alltraps>

00101d75 <vector49>:
.globl vector49
vector49:
  pushl $0
  101d75:	6a 00                	push   $0x0
  pushl $49
  101d77:	6a 31                	push   $0x31
  jmp __alltraps
  101d79:	e9 be 08 00 00       	jmp    10263c <__alltraps>

00101d7e <vector50>:
.globl vector50
vector50:
  pushl $0
  101d7e:	6a 00                	push   $0x0
  pushl $50
  101d80:	6a 32                	push   $0x32
  jmp __alltraps
  101d82:	e9 b5 08 00 00       	jmp    10263c <__alltraps>

00101d87 <vector51>:
.globl vector51
vector51:
  pushl $0
  101d87:	6a 00                	push   $0x0
  pushl $51
  101d89:	6a 33                	push   $0x33
  jmp __alltraps
  101d8b:	e9 ac 08 00 00       	jmp    10263c <__alltraps>

00101d90 <vector52>:
.globl vector52
vector52:
  pushl $0
  101d90:	6a 00                	push   $0x0
  pushl $52
  101d92:	6a 34                	push   $0x34
  jmp __alltraps
  101d94:	e9 a3 08 00 00       	jmp    10263c <__alltraps>

00101d99 <vector53>:
.globl vector53
vector53:
  pushl $0
  101d99:	6a 00                	push   $0x0
  pushl $53
  101d9b:	6a 35                	push   $0x35
  jmp __alltraps
  101d9d:	e9 9a 08 00 00       	jmp    10263c <__alltraps>

00101da2 <vector54>:
.globl vector54
vector54:
  pushl $0
  101da2:	6a 00                	push   $0x0
  pushl $54
  101da4:	6a 36                	push   $0x36
  jmp __alltraps
  101da6:	e9 91 08 00 00       	jmp    10263c <__alltraps>

00101dab <vector55>:
.globl vector55
vector55:
  pushl $0
  101dab:	6a 00                	push   $0x0
  pushl $55
  101dad:	6a 37                	push   $0x37
  jmp __alltraps
  101daf:	e9 88 08 00 00       	jmp    10263c <__alltraps>

00101db4 <vector56>:
.globl vector56
vector56:
  pushl $0
  101db4:	6a 00                	push   $0x0
  pushl $56
  101db6:	6a 38                	push   $0x38
  jmp __alltraps
  101db8:	e9 7f 08 00 00       	jmp    10263c <__alltraps>

00101dbd <vector57>:
.globl vector57
vector57:
  pushl $0
  101dbd:	6a 00                	push   $0x0
  pushl $57
  101dbf:	6a 39                	push   $0x39
  jmp __alltraps
  101dc1:	e9 76 08 00 00       	jmp    10263c <__alltraps>

00101dc6 <vector58>:
.globl vector58
vector58:
  pushl $0
  101dc6:	6a 00                	push   $0x0
  pushl $58
  101dc8:	6a 3a                	push   $0x3a
  jmp __alltraps
  101dca:	e9 6d 08 00 00       	jmp    10263c <__alltraps>

00101dcf <vector59>:
.globl vector59
vector59:
  pushl $0
  101dcf:	6a 00                	push   $0x0
  pushl $59
  101dd1:	6a 3b                	push   $0x3b
  jmp __alltraps
  101dd3:	e9 64 08 00 00       	jmp    10263c <__alltraps>

00101dd8 <vector60>:
.globl vector60
vector60:
  pushl $0
  101dd8:	6a 00                	push   $0x0
  pushl $60
  101dda:	6a 3c                	push   $0x3c
  jmp __alltraps
  101ddc:	e9 5b 08 00 00       	jmp    10263c <__alltraps>

00101de1 <vector61>:
.globl vector61
vector61:
  pushl $0
  101de1:	6a 00                	push   $0x0
  pushl $61
  101de3:	6a 3d                	push   $0x3d
  jmp __alltraps
  101de5:	e9 52 08 00 00       	jmp    10263c <__alltraps>

00101dea <vector62>:
.globl vector62
vector62:
  pushl $0
  101dea:	6a 00                	push   $0x0
  pushl $62
  101dec:	6a 3e                	push   $0x3e
  jmp __alltraps
  101dee:	e9 49 08 00 00       	jmp    10263c <__alltraps>

00101df3 <vector63>:
.globl vector63
vector63:
  pushl $0
  101df3:	6a 00                	push   $0x0
  pushl $63
  101df5:	6a 3f                	push   $0x3f
  jmp __alltraps
  101df7:	e9 40 08 00 00       	jmp    10263c <__alltraps>

00101dfc <vector64>:
.globl vector64
vector64:
  pushl $0
  101dfc:	6a 00                	push   $0x0
  pushl $64
  101dfe:	6a 40                	push   $0x40
  jmp __alltraps
  101e00:	e9 37 08 00 00       	jmp    10263c <__alltraps>

00101e05 <vector65>:
.globl vector65
vector65:
  pushl $0
  101e05:	6a 00                	push   $0x0
  pushl $65
  101e07:	6a 41                	push   $0x41
  jmp __alltraps
  101e09:	e9 2e 08 00 00       	jmp    10263c <__alltraps>

00101e0e <vector66>:
.globl vector66
vector66:
  pushl $0
  101e0e:	6a 00                	push   $0x0
  pushl $66
  101e10:	6a 42                	push   $0x42
  jmp __alltraps
  101e12:	e9 25 08 00 00       	jmp    10263c <__alltraps>

00101e17 <vector67>:
.globl vector67
vector67:
  pushl $0
  101e17:	6a 00                	push   $0x0
  pushl $67
  101e19:	6a 43                	push   $0x43
  jmp __alltraps
  101e1b:	e9 1c 08 00 00       	jmp    10263c <__alltraps>

00101e20 <vector68>:
.globl vector68
vector68:
  pushl $0
  101e20:	6a 00                	push   $0x0
  pushl $68
  101e22:	6a 44                	push   $0x44
  jmp __alltraps
  101e24:	e9 13 08 00 00       	jmp    10263c <__alltraps>

00101e29 <vector69>:
.globl vector69
vector69:
  pushl $0
  101e29:	6a 00                	push   $0x0
  pushl $69
  101e2b:	6a 45                	push   $0x45
  jmp __alltraps
  101e2d:	e9 0a 08 00 00       	jmp    10263c <__alltraps>

00101e32 <vector70>:
.globl vector70
vector70:
  pushl $0
  101e32:	6a 00                	push   $0x0
  pushl $70
  101e34:	6a 46                	push   $0x46
  jmp __alltraps
  101e36:	e9 01 08 00 00       	jmp    10263c <__alltraps>

00101e3b <vector71>:
.globl vector71
vector71:
  pushl $0
  101e3b:	6a 00                	push   $0x0
  pushl $71
  101e3d:	6a 47                	push   $0x47
  jmp __alltraps
  101e3f:	e9 f8 07 00 00       	jmp    10263c <__alltraps>

00101e44 <vector72>:
.globl vector72
vector72:
  pushl $0
  101e44:	6a 00                	push   $0x0
  pushl $72
  101e46:	6a 48                	push   $0x48
  jmp __alltraps
  101e48:	e9 ef 07 00 00       	jmp    10263c <__alltraps>

00101e4d <vector73>:
.globl vector73
vector73:
  pushl $0
  101e4d:	6a 00                	push   $0x0
  pushl $73
  101e4f:	6a 49                	push   $0x49
  jmp __alltraps
  101e51:	e9 e6 07 00 00       	jmp    10263c <__alltraps>

00101e56 <vector74>:
.globl vector74
vector74:
  pushl $0
  101e56:	6a 00                	push   $0x0
  pushl $74
  101e58:	6a 4a                	push   $0x4a
  jmp __alltraps
  101e5a:	e9 dd 07 00 00       	jmp    10263c <__alltraps>

00101e5f <vector75>:
.globl vector75
vector75:
  pushl $0
  101e5f:	6a 00                	push   $0x0
  pushl $75
  101e61:	6a 4b                	push   $0x4b
  jmp __alltraps
  101e63:	e9 d4 07 00 00       	jmp    10263c <__alltraps>

00101e68 <vector76>:
.globl vector76
vector76:
  pushl $0
  101e68:	6a 00                	push   $0x0
  pushl $76
  101e6a:	6a 4c                	push   $0x4c
  jmp __alltraps
  101e6c:	e9 cb 07 00 00       	jmp    10263c <__alltraps>

00101e71 <vector77>:
.globl vector77
vector77:
  pushl $0
  101e71:	6a 00                	push   $0x0
  pushl $77
  101e73:	6a 4d                	push   $0x4d
  jmp __alltraps
  101e75:	e9 c2 07 00 00       	jmp    10263c <__alltraps>

00101e7a <vector78>:
.globl vector78
vector78:
  pushl $0
  101e7a:	6a 00                	push   $0x0
  pushl $78
  101e7c:	6a 4e                	push   $0x4e
  jmp __alltraps
  101e7e:	e9 b9 07 00 00       	jmp    10263c <__alltraps>

00101e83 <vector79>:
.globl vector79
vector79:
  pushl $0
  101e83:	6a 00                	push   $0x0
  pushl $79
  101e85:	6a 4f                	push   $0x4f
  jmp __alltraps
  101e87:	e9 b0 07 00 00       	jmp    10263c <__alltraps>

00101e8c <vector80>:
.globl vector80
vector80:
  pushl $0
  101e8c:	6a 00                	push   $0x0
  pushl $80
  101e8e:	6a 50                	push   $0x50
  jmp __alltraps
  101e90:	e9 a7 07 00 00       	jmp    10263c <__alltraps>

00101e95 <vector81>:
.globl vector81
vector81:
  pushl $0
  101e95:	6a 00                	push   $0x0
  pushl $81
  101e97:	6a 51                	push   $0x51
  jmp __alltraps
  101e99:	e9 9e 07 00 00       	jmp    10263c <__alltraps>

00101e9e <vector82>:
.globl vector82
vector82:
  pushl $0
  101e9e:	6a 00                	push   $0x0
  pushl $82
  101ea0:	6a 52                	push   $0x52
  jmp __alltraps
  101ea2:	e9 95 07 00 00       	jmp    10263c <__alltraps>

00101ea7 <vector83>:
.globl vector83
vector83:
  pushl $0
  101ea7:	6a 00                	push   $0x0
  pushl $83
  101ea9:	6a 53                	push   $0x53
  jmp __alltraps
  101eab:	e9 8c 07 00 00       	jmp    10263c <__alltraps>

00101eb0 <vector84>:
.globl vector84
vector84:
  pushl $0
  101eb0:	6a 00                	push   $0x0
  pushl $84
  101eb2:	6a 54                	push   $0x54
  jmp __alltraps
  101eb4:	e9 83 07 00 00       	jmp    10263c <__alltraps>

00101eb9 <vector85>:
.globl vector85
vector85:
  pushl $0
  101eb9:	6a 00                	push   $0x0
  pushl $85
  101ebb:	6a 55                	push   $0x55
  jmp __alltraps
  101ebd:	e9 7a 07 00 00       	jmp    10263c <__alltraps>

00101ec2 <vector86>:
.globl vector86
vector86:
  pushl $0
  101ec2:	6a 00                	push   $0x0
  pushl $86
  101ec4:	6a 56                	push   $0x56
  jmp __alltraps
  101ec6:	e9 71 07 00 00       	jmp    10263c <__alltraps>

00101ecb <vector87>:
.globl vector87
vector87:
  pushl $0
  101ecb:	6a 00                	push   $0x0
  pushl $87
  101ecd:	6a 57                	push   $0x57
  jmp __alltraps
  101ecf:	e9 68 07 00 00       	jmp    10263c <__alltraps>

00101ed4 <vector88>:
.globl vector88
vector88:
  pushl $0
  101ed4:	6a 00                	push   $0x0
  pushl $88
  101ed6:	6a 58                	push   $0x58
  jmp __alltraps
  101ed8:	e9 5f 07 00 00       	jmp    10263c <__alltraps>

00101edd <vector89>:
.globl vector89
vector89:
  pushl $0
  101edd:	6a 00                	push   $0x0
  pushl $89
  101edf:	6a 59                	push   $0x59
  jmp __alltraps
  101ee1:	e9 56 07 00 00       	jmp    10263c <__alltraps>

00101ee6 <vector90>:
.globl vector90
vector90:
  pushl $0
  101ee6:	6a 00                	push   $0x0
  pushl $90
  101ee8:	6a 5a                	push   $0x5a
  jmp __alltraps
  101eea:	e9 4d 07 00 00       	jmp    10263c <__alltraps>

00101eef <vector91>:
.globl vector91
vector91:
  pushl $0
  101eef:	6a 00                	push   $0x0
  pushl $91
  101ef1:	6a 5b                	push   $0x5b
  jmp __alltraps
  101ef3:	e9 44 07 00 00       	jmp    10263c <__alltraps>

00101ef8 <vector92>:
.globl vector92
vector92:
  pushl $0
  101ef8:	6a 00                	push   $0x0
  pushl $92
  101efa:	6a 5c                	push   $0x5c
  jmp __alltraps
  101efc:	e9 3b 07 00 00       	jmp    10263c <__alltraps>

00101f01 <vector93>:
.globl vector93
vector93:
  pushl $0
  101f01:	6a 00                	push   $0x0
  pushl $93
  101f03:	6a 5d                	push   $0x5d
  jmp __alltraps
  101f05:	e9 32 07 00 00       	jmp    10263c <__alltraps>

00101f0a <vector94>:
.globl vector94
vector94:
  pushl $0
  101f0a:	6a 00                	push   $0x0
  pushl $94
  101f0c:	6a 5e                	push   $0x5e
  jmp __alltraps
  101f0e:	e9 29 07 00 00       	jmp    10263c <__alltraps>

00101f13 <vector95>:
.globl vector95
vector95:
  pushl $0
  101f13:	6a 00                	push   $0x0
  pushl $95
  101f15:	6a 5f                	push   $0x5f
  jmp __alltraps
  101f17:	e9 20 07 00 00       	jmp    10263c <__alltraps>

00101f1c <vector96>:
.globl vector96
vector96:
  pushl $0
  101f1c:	6a 00                	push   $0x0
  pushl $96
  101f1e:	6a 60                	push   $0x60
  jmp __alltraps
  101f20:	e9 17 07 00 00       	jmp    10263c <__alltraps>

00101f25 <vector97>:
.globl vector97
vector97:
  pushl $0
  101f25:	6a 00                	push   $0x0
  pushl $97
  101f27:	6a 61                	push   $0x61
  jmp __alltraps
  101f29:	e9 0e 07 00 00       	jmp    10263c <__alltraps>

00101f2e <vector98>:
.globl vector98
vector98:
  pushl $0
  101f2e:	6a 00                	push   $0x0
  pushl $98
  101f30:	6a 62                	push   $0x62
  jmp __alltraps
  101f32:	e9 05 07 00 00       	jmp    10263c <__alltraps>

00101f37 <vector99>:
.globl vector99
vector99:
  pushl $0
  101f37:	6a 00                	push   $0x0
  pushl $99
  101f39:	6a 63                	push   $0x63
  jmp __alltraps
  101f3b:	e9 fc 06 00 00       	jmp    10263c <__alltraps>

00101f40 <vector100>:
.globl vector100
vector100:
  pushl $0
  101f40:	6a 00                	push   $0x0
  pushl $100
  101f42:	6a 64                	push   $0x64
  jmp __alltraps
  101f44:	e9 f3 06 00 00       	jmp    10263c <__alltraps>

00101f49 <vector101>:
.globl vector101
vector101:
  pushl $0
  101f49:	6a 00                	push   $0x0
  pushl $101
  101f4b:	6a 65                	push   $0x65
  jmp __alltraps
  101f4d:	e9 ea 06 00 00       	jmp    10263c <__alltraps>

00101f52 <vector102>:
.globl vector102
vector102:
  pushl $0
  101f52:	6a 00                	push   $0x0
  pushl $102
  101f54:	6a 66                	push   $0x66
  jmp __alltraps
  101f56:	e9 e1 06 00 00       	jmp    10263c <__alltraps>

00101f5b <vector103>:
.globl vector103
vector103:
  pushl $0
  101f5b:	6a 00                	push   $0x0
  pushl $103
  101f5d:	6a 67                	push   $0x67
  jmp __alltraps
  101f5f:	e9 d8 06 00 00       	jmp    10263c <__alltraps>

00101f64 <vector104>:
.globl vector104
vector104:
  pushl $0
  101f64:	6a 00                	push   $0x0
  pushl $104
  101f66:	6a 68                	push   $0x68
  jmp __alltraps
  101f68:	e9 cf 06 00 00       	jmp    10263c <__alltraps>

00101f6d <vector105>:
.globl vector105
vector105:
  pushl $0
  101f6d:	6a 00                	push   $0x0
  pushl $105
  101f6f:	6a 69                	push   $0x69
  jmp __alltraps
  101f71:	e9 c6 06 00 00       	jmp    10263c <__alltraps>

00101f76 <vector106>:
.globl vector106
vector106:
  pushl $0
  101f76:	6a 00                	push   $0x0
  pushl $106
  101f78:	6a 6a                	push   $0x6a
  jmp __alltraps
  101f7a:	e9 bd 06 00 00       	jmp    10263c <__alltraps>

00101f7f <vector107>:
.globl vector107
vector107:
  pushl $0
  101f7f:	6a 00                	push   $0x0
  pushl $107
  101f81:	6a 6b                	push   $0x6b
  jmp __alltraps
  101f83:	e9 b4 06 00 00       	jmp    10263c <__alltraps>

00101f88 <vector108>:
.globl vector108
vector108:
  pushl $0
  101f88:	6a 00                	push   $0x0
  pushl $108
  101f8a:	6a 6c                	push   $0x6c
  jmp __alltraps
  101f8c:	e9 ab 06 00 00       	jmp    10263c <__alltraps>

00101f91 <vector109>:
.globl vector109
vector109:
  pushl $0
  101f91:	6a 00                	push   $0x0
  pushl $109
  101f93:	6a 6d                	push   $0x6d
  jmp __alltraps
  101f95:	e9 a2 06 00 00       	jmp    10263c <__alltraps>

00101f9a <vector110>:
.globl vector110
vector110:
  pushl $0
  101f9a:	6a 00                	push   $0x0
  pushl $110
  101f9c:	6a 6e                	push   $0x6e
  jmp __alltraps
  101f9e:	e9 99 06 00 00       	jmp    10263c <__alltraps>

00101fa3 <vector111>:
.globl vector111
vector111:
  pushl $0
  101fa3:	6a 00                	push   $0x0
  pushl $111
  101fa5:	6a 6f                	push   $0x6f
  jmp __alltraps
  101fa7:	e9 90 06 00 00       	jmp    10263c <__alltraps>

00101fac <vector112>:
.globl vector112
vector112:
  pushl $0
  101fac:	6a 00                	push   $0x0
  pushl $112
  101fae:	6a 70                	push   $0x70
  jmp __alltraps
  101fb0:	e9 87 06 00 00       	jmp    10263c <__alltraps>

00101fb5 <vector113>:
.globl vector113
vector113:
  pushl $0
  101fb5:	6a 00                	push   $0x0
  pushl $113
  101fb7:	6a 71                	push   $0x71
  jmp __alltraps
  101fb9:	e9 7e 06 00 00       	jmp    10263c <__alltraps>

00101fbe <vector114>:
.globl vector114
vector114:
  pushl $0
  101fbe:	6a 00                	push   $0x0
  pushl $114
  101fc0:	6a 72                	push   $0x72
  jmp __alltraps
  101fc2:	e9 75 06 00 00       	jmp    10263c <__alltraps>

00101fc7 <vector115>:
.globl vector115
vector115:
  pushl $0
  101fc7:	6a 00                	push   $0x0
  pushl $115
  101fc9:	6a 73                	push   $0x73
  jmp __alltraps
  101fcb:	e9 6c 06 00 00       	jmp    10263c <__alltraps>

00101fd0 <vector116>:
.globl vector116
vector116:
  pushl $0
  101fd0:	6a 00                	push   $0x0
  pushl $116
  101fd2:	6a 74                	push   $0x74
  jmp __alltraps
  101fd4:	e9 63 06 00 00       	jmp    10263c <__alltraps>

00101fd9 <vector117>:
.globl vector117
vector117:
  pushl $0
  101fd9:	6a 00                	push   $0x0
  pushl $117
  101fdb:	6a 75                	push   $0x75
  jmp __alltraps
  101fdd:	e9 5a 06 00 00       	jmp    10263c <__alltraps>

00101fe2 <vector118>:
.globl vector118
vector118:
  pushl $0
  101fe2:	6a 00                	push   $0x0
  pushl $118
  101fe4:	6a 76                	push   $0x76
  jmp __alltraps
  101fe6:	e9 51 06 00 00       	jmp    10263c <__alltraps>

00101feb <vector119>:
.globl vector119
vector119:
  pushl $0
  101feb:	6a 00                	push   $0x0
  pushl $119
  101fed:	6a 77                	push   $0x77
  jmp __alltraps
  101fef:	e9 48 06 00 00       	jmp    10263c <__alltraps>

00101ff4 <vector120>:
.globl vector120
vector120:
  pushl $0
  101ff4:	6a 00                	push   $0x0
  pushl $120
  101ff6:	6a 78                	push   $0x78
  jmp __alltraps
  101ff8:	e9 3f 06 00 00       	jmp    10263c <__alltraps>

00101ffd <vector121>:
.globl vector121
vector121:
  pushl $0
  101ffd:	6a 00                	push   $0x0
  pushl $121
  101fff:	6a 79                	push   $0x79
  jmp __alltraps
  102001:	e9 36 06 00 00       	jmp    10263c <__alltraps>

00102006 <vector122>:
.globl vector122
vector122:
  pushl $0
  102006:	6a 00                	push   $0x0
  pushl $122
  102008:	6a 7a                	push   $0x7a
  jmp __alltraps
  10200a:	e9 2d 06 00 00       	jmp    10263c <__alltraps>

0010200f <vector123>:
.globl vector123
vector123:
  pushl $0
  10200f:	6a 00                	push   $0x0
  pushl $123
  102011:	6a 7b                	push   $0x7b
  jmp __alltraps
  102013:	e9 24 06 00 00       	jmp    10263c <__alltraps>

00102018 <vector124>:
.globl vector124
vector124:
  pushl $0
  102018:	6a 00                	push   $0x0
  pushl $124
  10201a:	6a 7c                	push   $0x7c
  jmp __alltraps
  10201c:	e9 1b 06 00 00       	jmp    10263c <__alltraps>

00102021 <vector125>:
.globl vector125
vector125:
  pushl $0
  102021:	6a 00                	push   $0x0
  pushl $125
  102023:	6a 7d                	push   $0x7d
  jmp __alltraps
  102025:	e9 12 06 00 00       	jmp    10263c <__alltraps>

0010202a <vector126>:
.globl vector126
vector126:
  pushl $0
  10202a:	6a 00                	push   $0x0
  pushl $126
  10202c:	6a 7e                	push   $0x7e
  jmp __alltraps
  10202e:	e9 09 06 00 00       	jmp    10263c <__alltraps>

00102033 <vector127>:
.globl vector127
vector127:
  pushl $0
  102033:	6a 00                	push   $0x0
  pushl $127
  102035:	6a 7f                	push   $0x7f
  jmp __alltraps
  102037:	e9 00 06 00 00       	jmp    10263c <__alltraps>

0010203c <vector128>:
.globl vector128
vector128:
  pushl $0
  10203c:	6a 00                	push   $0x0
  pushl $128
  10203e:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  102043:	e9 f4 05 00 00       	jmp    10263c <__alltraps>

00102048 <vector129>:
.globl vector129
vector129:
  pushl $0
  102048:	6a 00                	push   $0x0
  pushl $129
  10204a:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  10204f:	e9 e8 05 00 00       	jmp    10263c <__alltraps>

00102054 <vector130>:
.globl vector130
vector130:
  pushl $0
  102054:	6a 00                	push   $0x0
  pushl $130
  102056:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  10205b:	e9 dc 05 00 00       	jmp    10263c <__alltraps>

00102060 <vector131>:
.globl vector131
vector131:
  pushl $0
  102060:	6a 00                	push   $0x0
  pushl $131
  102062:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  102067:	e9 d0 05 00 00       	jmp    10263c <__alltraps>

0010206c <vector132>:
.globl vector132
vector132:
  pushl $0
  10206c:	6a 00                	push   $0x0
  pushl $132
  10206e:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  102073:	e9 c4 05 00 00       	jmp    10263c <__alltraps>

00102078 <vector133>:
.globl vector133
vector133:
  pushl $0
  102078:	6a 00                	push   $0x0
  pushl $133
  10207a:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  10207f:	e9 b8 05 00 00       	jmp    10263c <__alltraps>

00102084 <vector134>:
.globl vector134
vector134:
  pushl $0
  102084:	6a 00                	push   $0x0
  pushl $134
  102086:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  10208b:	e9 ac 05 00 00       	jmp    10263c <__alltraps>

00102090 <vector135>:
.globl vector135
vector135:
  pushl $0
  102090:	6a 00                	push   $0x0
  pushl $135
  102092:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  102097:	e9 a0 05 00 00       	jmp    10263c <__alltraps>

0010209c <vector136>:
.globl vector136
vector136:
  pushl $0
  10209c:	6a 00                	push   $0x0
  pushl $136
  10209e:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  1020a3:	e9 94 05 00 00       	jmp    10263c <__alltraps>

001020a8 <vector137>:
.globl vector137
vector137:
  pushl $0
  1020a8:	6a 00                	push   $0x0
  pushl $137
  1020aa:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  1020af:	e9 88 05 00 00       	jmp    10263c <__alltraps>

001020b4 <vector138>:
.globl vector138
vector138:
  pushl $0
  1020b4:	6a 00                	push   $0x0
  pushl $138
  1020b6:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  1020bb:	e9 7c 05 00 00       	jmp    10263c <__alltraps>

001020c0 <vector139>:
.globl vector139
vector139:
  pushl $0
  1020c0:	6a 00                	push   $0x0
  pushl $139
  1020c2:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  1020c7:	e9 70 05 00 00       	jmp    10263c <__alltraps>

001020cc <vector140>:
.globl vector140
vector140:
  pushl $0
  1020cc:	6a 00                	push   $0x0
  pushl $140
  1020ce:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  1020d3:	e9 64 05 00 00       	jmp    10263c <__alltraps>

001020d8 <vector141>:
.globl vector141
vector141:
  pushl $0
  1020d8:	6a 00                	push   $0x0
  pushl $141
  1020da:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  1020df:	e9 58 05 00 00       	jmp    10263c <__alltraps>

001020e4 <vector142>:
.globl vector142
vector142:
  pushl $0
  1020e4:	6a 00                	push   $0x0
  pushl $142
  1020e6:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  1020eb:	e9 4c 05 00 00       	jmp    10263c <__alltraps>

001020f0 <vector143>:
.globl vector143
vector143:
  pushl $0
  1020f0:	6a 00                	push   $0x0
  pushl $143
  1020f2:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  1020f7:	e9 40 05 00 00       	jmp    10263c <__alltraps>

001020fc <vector144>:
.globl vector144
vector144:
  pushl $0
  1020fc:	6a 00                	push   $0x0
  pushl $144
  1020fe:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  102103:	e9 34 05 00 00       	jmp    10263c <__alltraps>

00102108 <vector145>:
.globl vector145
vector145:
  pushl $0
  102108:	6a 00                	push   $0x0
  pushl $145
  10210a:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  10210f:	e9 28 05 00 00       	jmp    10263c <__alltraps>

00102114 <vector146>:
.globl vector146
vector146:
  pushl $0
  102114:	6a 00                	push   $0x0
  pushl $146
  102116:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  10211b:	e9 1c 05 00 00       	jmp    10263c <__alltraps>

00102120 <vector147>:
.globl vector147
vector147:
  pushl $0
  102120:	6a 00                	push   $0x0
  pushl $147
  102122:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  102127:	e9 10 05 00 00       	jmp    10263c <__alltraps>

0010212c <vector148>:
.globl vector148
vector148:
  pushl $0
  10212c:	6a 00                	push   $0x0
  pushl $148
  10212e:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  102133:	e9 04 05 00 00       	jmp    10263c <__alltraps>

00102138 <vector149>:
.globl vector149
vector149:
  pushl $0
  102138:	6a 00                	push   $0x0
  pushl $149
  10213a:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  10213f:	e9 f8 04 00 00       	jmp    10263c <__alltraps>

00102144 <vector150>:
.globl vector150
vector150:
  pushl $0
  102144:	6a 00                	push   $0x0
  pushl $150
  102146:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  10214b:	e9 ec 04 00 00       	jmp    10263c <__alltraps>

00102150 <vector151>:
.globl vector151
vector151:
  pushl $0
  102150:	6a 00                	push   $0x0
  pushl $151
  102152:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  102157:	e9 e0 04 00 00       	jmp    10263c <__alltraps>

0010215c <vector152>:
.globl vector152
vector152:
  pushl $0
  10215c:	6a 00                	push   $0x0
  pushl $152
  10215e:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  102163:	e9 d4 04 00 00       	jmp    10263c <__alltraps>

00102168 <vector153>:
.globl vector153
vector153:
  pushl $0
  102168:	6a 00                	push   $0x0
  pushl $153
  10216a:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  10216f:	e9 c8 04 00 00       	jmp    10263c <__alltraps>

00102174 <vector154>:
.globl vector154
vector154:
  pushl $0
  102174:	6a 00                	push   $0x0
  pushl $154
  102176:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  10217b:	e9 bc 04 00 00       	jmp    10263c <__alltraps>

00102180 <vector155>:
.globl vector155
vector155:
  pushl $0
  102180:	6a 00                	push   $0x0
  pushl $155
  102182:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  102187:	e9 b0 04 00 00       	jmp    10263c <__alltraps>

0010218c <vector156>:
.globl vector156
vector156:
  pushl $0
  10218c:	6a 00                	push   $0x0
  pushl $156
  10218e:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  102193:	e9 a4 04 00 00       	jmp    10263c <__alltraps>

00102198 <vector157>:
.globl vector157
vector157:
  pushl $0
  102198:	6a 00                	push   $0x0
  pushl $157
  10219a:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  10219f:	e9 98 04 00 00       	jmp    10263c <__alltraps>

001021a4 <vector158>:
.globl vector158
vector158:
  pushl $0
  1021a4:	6a 00                	push   $0x0
  pushl $158
  1021a6:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  1021ab:	e9 8c 04 00 00       	jmp    10263c <__alltraps>

001021b0 <vector159>:
.globl vector159
vector159:
  pushl $0
  1021b0:	6a 00                	push   $0x0
  pushl $159
  1021b2:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  1021b7:	e9 80 04 00 00       	jmp    10263c <__alltraps>

001021bc <vector160>:
.globl vector160
vector160:
  pushl $0
  1021bc:	6a 00                	push   $0x0
  pushl $160
  1021be:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  1021c3:	e9 74 04 00 00       	jmp    10263c <__alltraps>

001021c8 <vector161>:
.globl vector161
vector161:
  pushl $0
  1021c8:	6a 00                	push   $0x0
  pushl $161
  1021ca:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  1021cf:	e9 68 04 00 00       	jmp    10263c <__alltraps>

001021d4 <vector162>:
.globl vector162
vector162:
  pushl $0
  1021d4:	6a 00                	push   $0x0
  pushl $162
  1021d6:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  1021db:	e9 5c 04 00 00       	jmp    10263c <__alltraps>

001021e0 <vector163>:
.globl vector163
vector163:
  pushl $0
  1021e0:	6a 00                	push   $0x0
  pushl $163
  1021e2:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  1021e7:	e9 50 04 00 00       	jmp    10263c <__alltraps>

001021ec <vector164>:
.globl vector164
vector164:
  pushl $0
  1021ec:	6a 00                	push   $0x0
  pushl $164
  1021ee:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  1021f3:	e9 44 04 00 00       	jmp    10263c <__alltraps>

001021f8 <vector165>:
.globl vector165
vector165:
  pushl $0
  1021f8:	6a 00                	push   $0x0
  pushl $165
  1021fa:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  1021ff:	e9 38 04 00 00       	jmp    10263c <__alltraps>

00102204 <vector166>:
.globl vector166
vector166:
  pushl $0
  102204:	6a 00                	push   $0x0
  pushl $166
  102206:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  10220b:	e9 2c 04 00 00       	jmp    10263c <__alltraps>

00102210 <vector167>:
.globl vector167
vector167:
  pushl $0
  102210:	6a 00                	push   $0x0
  pushl $167
  102212:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  102217:	e9 20 04 00 00       	jmp    10263c <__alltraps>

0010221c <vector168>:
.globl vector168
vector168:
  pushl $0
  10221c:	6a 00                	push   $0x0
  pushl $168
  10221e:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  102223:	e9 14 04 00 00       	jmp    10263c <__alltraps>

00102228 <vector169>:
.globl vector169
vector169:
  pushl $0
  102228:	6a 00                	push   $0x0
  pushl $169
  10222a:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  10222f:	e9 08 04 00 00       	jmp    10263c <__alltraps>

00102234 <vector170>:
.globl vector170
vector170:
  pushl $0
  102234:	6a 00                	push   $0x0
  pushl $170
  102236:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  10223b:	e9 fc 03 00 00       	jmp    10263c <__alltraps>

00102240 <vector171>:
.globl vector171
vector171:
  pushl $0
  102240:	6a 00                	push   $0x0
  pushl $171
  102242:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  102247:	e9 f0 03 00 00       	jmp    10263c <__alltraps>

0010224c <vector172>:
.globl vector172
vector172:
  pushl $0
  10224c:	6a 00                	push   $0x0
  pushl $172
  10224e:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  102253:	e9 e4 03 00 00       	jmp    10263c <__alltraps>

00102258 <vector173>:
.globl vector173
vector173:
  pushl $0
  102258:	6a 00                	push   $0x0
  pushl $173
  10225a:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  10225f:	e9 d8 03 00 00       	jmp    10263c <__alltraps>

00102264 <vector174>:
.globl vector174
vector174:
  pushl $0
  102264:	6a 00                	push   $0x0
  pushl $174
  102266:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  10226b:	e9 cc 03 00 00       	jmp    10263c <__alltraps>

00102270 <vector175>:
.globl vector175
vector175:
  pushl $0
  102270:	6a 00                	push   $0x0
  pushl $175
  102272:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  102277:	e9 c0 03 00 00       	jmp    10263c <__alltraps>

0010227c <vector176>:
.globl vector176
vector176:
  pushl $0
  10227c:	6a 00                	push   $0x0
  pushl $176
  10227e:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  102283:	e9 b4 03 00 00       	jmp    10263c <__alltraps>

00102288 <vector177>:
.globl vector177
vector177:
  pushl $0
  102288:	6a 00                	push   $0x0
  pushl $177
  10228a:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  10228f:	e9 a8 03 00 00       	jmp    10263c <__alltraps>

00102294 <vector178>:
.globl vector178
vector178:
  pushl $0
  102294:	6a 00                	push   $0x0
  pushl $178
  102296:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  10229b:	e9 9c 03 00 00       	jmp    10263c <__alltraps>

001022a0 <vector179>:
.globl vector179
vector179:
  pushl $0
  1022a0:	6a 00                	push   $0x0
  pushl $179
  1022a2:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  1022a7:	e9 90 03 00 00       	jmp    10263c <__alltraps>

001022ac <vector180>:
.globl vector180
vector180:
  pushl $0
  1022ac:	6a 00                	push   $0x0
  pushl $180
  1022ae:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  1022b3:	e9 84 03 00 00       	jmp    10263c <__alltraps>

001022b8 <vector181>:
.globl vector181
vector181:
  pushl $0
  1022b8:	6a 00                	push   $0x0
  pushl $181
  1022ba:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  1022bf:	e9 78 03 00 00       	jmp    10263c <__alltraps>

001022c4 <vector182>:
.globl vector182
vector182:
  pushl $0
  1022c4:	6a 00                	push   $0x0
  pushl $182
  1022c6:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  1022cb:	e9 6c 03 00 00       	jmp    10263c <__alltraps>

001022d0 <vector183>:
.globl vector183
vector183:
  pushl $0
  1022d0:	6a 00                	push   $0x0
  pushl $183
  1022d2:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  1022d7:	e9 60 03 00 00       	jmp    10263c <__alltraps>

001022dc <vector184>:
.globl vector184
vector184:
  pushl $0
  1022dc:	6a 00                	push   $0x0
  pushl $184
  1022de:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  1022e3:	e9 54 03 00 00       	jmp    10263c <__alltraps>

001022e8 <vector185>:
.globl vector185
vector185:
  pushl $0
  1022e8:	6a 00                	push   $0x0
  pushl $185
  1022ea:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  1022ef:	e9 48 03 00 00       	jmp    10263c <__alltraps>

001022f4 <vector186>:
.globl vector186
vector186:
  pushl $0
  1022f4:	6a 00                	push   $0x0
  pushl $186
  1022f6:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  1022fb:	e9 3c 03 00 00       	jmp    10263c <__alltraps>

00102300 <vector187>:
.globl vector187
vector187:
  pushl $0
  102300:	6a 00                	push   $0x0
  pushl $187
  102302:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  102307:	e9 30 03 00 00       	jmp    10263c <__alltraps>

0010230c <vector188>:
.globl vector188
vector188:
  pushl $0
  10230c:	6a 00                	push   $0x0
  pushl $188
  10230e:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  102313:	e9 24 03 00 00       	jmp    10263c <__alltraps>

00102318 <vector189>:
.globl vector189
vector189:
  pushl $0
  102318:	6a 00                	push   $0x0
  pushl $189
  10231a:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  10231f:	e9 18 03 00 00       	jmp    10263c <__alltraps>

00102324 <vector190>:
.globl vector190
vector190:
  pushl $0
  102324:	6a 00                	push   $0x0
  pushl $190
  102326:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  10232b:	e9 0c 03 00 00       	jmp    10263c <__alltraps>

00102330 <vector191>:
.globl vector191
vector191:
  pushl $0
  102330:	6a 00                	push   $0x0
  pushl $191
  102332:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  102337:	e9 00 03 00 00       	jmp    10263c <__alltraps>

0010233c <vector192>:
.globl vector192
vector192:
  pushl $0
  10233c:	6a 00                	push   $0x0
  pushl $192
  10233e:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  102343:	e9 f4 02 00 00       	jmp    10263c <__alltraps>

00102348 <vector193>:
.globl vector193
vector193:
  pushl $0
  102348:	6a 00                	push   $0x0
  pushl $193
  10234a:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  10234f:	e9 e8 02 00 00       	jmp    10263c <__alltraps>

00102354 <vector194>:
.globl vector194
vector194:
  pushl $0
  102354:	6a 00                	push   $0x0
  pushl $194
  102356:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  10235b:	e9 dc 02 00 00       	jmp    10263c <__alltraps>

00102360 <vector195>:
.globl vector195
vector195:
  pushl $0
  102360:	6a 00                	push   $0x0
  pushl $195
  102362:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  102367:	e9 d0 02 00 00       	jmp    10263c <__alltraps>

0010236c <vector196>:
.globl vector196
vector196:
  pushl $0
  10236c:	6a 00                	push   $0x0
  pushl $196
  10236e:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  102373:	e9 c4 02 00 00       	jmp    10263c <__alltraps>

00102378 <vector197>:
.globl vector197
vector197:
  pushl $0
  102378:	6a 00                	push   $0x0
  pushl $197
  10237a:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  10237f:	e9 b8 02 00 00       	jmp    10263c <__alltraps>

00102384 <vector198>:
.globl vector198
vector198:
  pushl $0
  102384:	6a 00                	push   $0x0
  pushl $198
  102386:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  10238b:	e9 ac 02 00 00       	jmp    10263c <__alltraps>

00102390 <vector199>:
.globl vector199
vector199:
  pushl $0
  102390:	6a 00                	push   $0x0
  pushl $199
  102392:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  102397:	e9 a0 02 00 00       	jmp    10263c <__alltraps>

0010239c <vector200>:
.globl vector200
vector200:
  pushl $0
  10239c:	6a 00                	push   $0x0
  pushl $200
  10239e:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  1023a3:	e9 94 02 00 00       	jmp    10263c <__alltraps>

001023a8 <vector201>:
.globl vector201
vector201:
  pushl $0
  1023a8:	6a 00                	push   $0x0
  pushl $201
  1023aa:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  1023af:	e9 88 02 00 00       	jmp    10263c <__alltraps>

001023b4 <vector202>:
.globl vector202
vector202:
  pushl $0
  1023b4:	6a 00                	push   $0x0
  pushl $202
  1023b6:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  1023bb:	e9 7c 02 00 00       	jmp    10263c <__alltraps>

001023c0 <vector203>:
.globl vector203
vector203:
  pushl $0
  1023c0:	6a 00                	push   $0x0
  pushl $203
  1023c2:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  1023c7:	e9 70 02 00 00       	jmp    10263c <__alltraps>

001023cc <vector204>:
.globl vector204
vector204:
  pushl $0
  1023cc:	6a 00                	push   $0x0
  pushl $204
  1023ce:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  1023d3:	e9 64 02 00 00       	jmp    10263c <__alltraps>

001023d8 <vector205>:
.globl vector205
vector205:
  pushl $0
  1023d8:	6a 00                	push   $0x0
  pushl $205
  1023da:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  1023df:	e9 58 02 00 00       	jmp    10263c <__alltraps>

001023e4 <vector206>:
.globl vector206
vector206:
  pushl $0
  1023e4:	6a 00                	push   $0x0
  pushl $206
  1023e6:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  1023eb:	e9 4c 02 00 00       	jmp    10263c <__alltraps>

001023f0 <vector207>:
.globl vector207
vector207:
  pushl $0
  1023f0:	6a 00                	push   $0x0
  pushl $207
  1023f2:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  1023f7:	e9 40 02 00 00       	jmp    10263c <__alltraps>

001023fc <vector208>:
.globl vector208
vector208:
  pushl $0
  1023fc:	6a 00                	push   $0x0
  pushl $208
  1023fe:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  102403:	e9 34 02 00 00       	jmp    10263c <__alltraps>

00102408 <vector209>:
.globl vector209
vector209:
  pushl $0
  102408:	6a 00                	push   $0x0
  pushl $209
  10240a:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  10240f:	e9 28 02 00 00       	jmp    10263c <__alltraps>

00102414 <vector210>:
.globl vector210
vector210:
  pushl $0
  102414:	6a 00                	push   $0x0
  pushl $210
  102416:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  10241b:	e9 1c 02 00 00       	jmp    10263c <__alltraps>

00102420 <vector211>:
.globl vector211
vector211:
  pushl $0
  102420:	6a 00                	push   $0x0
  pushl $211
  102422:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  102427:	e9 10 02 00 00       	jmp    10263c <__alltraps>

0010242c <vector212>:
.globl vector212
vector212:
  pushl $0
  10242c:	6a 00                	push   $0x0
  pushl $212
  10242e:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  102433:	e9 04 02 00 00       	jmp    10263c <__alltraps>

00102438 <vector213>:
.globl vector213
vector213:
  pushl $0
  102438:	6a 00                	push   $0x0
  pushl $213
  10243a:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  10243f:	e9 f8 01 00 00       	jmp    10263c <__alltraps>

00102444 <vector214>:
.globl vector214
vector214:
  pushl $0
  102444:	6a 00                	push   $0x0
  pushl $214
  102446:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  10244b:	e9 ec 01 00 00       	jmp    10263c <__alltraps>

00102450 <vector215>:
.globl vector215
vector215:
  pushl $0
  102450:	6a 00                	push   $0x0
  pushl $215
  102452:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  102457:	e9 e0 01 00 00       	jmp    10263c <__alltraps>

0010245c <vector216>:
.globl vector216
vector216:
  pushl $0
  10245c:	6a 00                	push   $0x0
  pushl $216
  10245e:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  102463:	e9 d4 01 00 00       	jmp    10263c <__alltraps>

00102468 <vector217>:
.globl vector217
vector217:
  pushl $0
  102468:	6a 00                	push   $0x0
  pushl $217
  10246a:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  10246f:	e9 c8 01 00 00       	jmp    10263c <__alltraps>

00102474 <vector218>:
.globl vector218
vector218:
  pushl $0
  102474:	6a 00                	push   $0x0
  pushl $218
  102476:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  10247b:	e9 bc 01 00 00       	jmp    10263c <__alltraps>

00102480 <vector219>:
.globl vector219
vector219:
  pushl $0
  102480:	6a 00                	push   $0x0
  pushl $219
  102482:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  102487:	e9 b0 01 00 00       	jmp    10263c <__alltraps>

0010248c <vector220>:
.globl vector220
vector220:
  pushl $0
  10248c:	6a 00                	push   $0x0
  pushl $220
  10248e:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  102493:	e9 a4 01 00 00       	jmp    10263c <__alltraps>

00102498 <vector221>:
.globl vector221
vector221:
  pushl $0
  102498:	6a 00                	push   $0x0
  pushl $221
  10249a:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  10249f:	e9 98 01 00 00       	jmp    10263c <__alltraps>

001024a4 <vector222>:
.globl vector222
vector222:
  pushl $0
  1024a4:	6a 00                	push   $0x0
  pushl $222
  1024a6:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  1024ab:	e9 8c 01 00 00       	jmp    10263c <__alltraps>

001024b0 <vector223>:
.globl vector223
vector223:
  pushl $0
  1024b0:	6a 00                	push   $0x0
  pushl $223
  1024b2:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  1024b7:	e9 80 01 00 00       	jmp    10263c <__alltraps>

001024bc <vector224>:
.globl vector224
vector224:
  pushl $0
  1024bc:	6a 00                	push   $0x0
  pushl $224
  1024be:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  1024c3:	e9 74 01 00 00       	jmp    10263c <__alltraps>

001024c8 <vector225>:
.globl vector225
vector225:
  pushl $0
  1024c8:	6a 00                	push   $0x0
  pushl $225
  1024ca:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  1024cf:	e9 68 01 00 00       	jmp    10263c <__alltraps>

001024d4 <vector226>:
.globl vector226
vector226:
  pushl $0
  1024d4:	6a 00                	push   $0x0
  pushl $226
  1024d6:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  1024db:	e9 5c 01 00 00       	jmp    10263c <__alltraps>

001024e0 <vector227>:
.globl vector227
vector227:
  pushl $0
  1024e0:	6a 00                	push   $0x0
  pushl $227
  1024e2:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  1024e7:	e9 50 01 00 00       	jmp    10263c <__alltraps>

001024ec <vector228>:
.globl vector228
vector228:
  pushl $0
  1024ec:	6a 00                	push   $0x0
  pushl $228
  1024ee:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  1024f3:	e9 44 01 00 00       	jmp    10263c <__alltraps>

001024f8 <vector229>:
.globl vector229
vector229:
  pushl $0
  1024f8:	6a 00                	push   $0x0
  pushl $229
  1024fa:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  1024ff:	e9 38 01 00 00       	jmp    10263c <__alltraps>

00102504 <vector230>:
.globl vector230
vector230:
  pushl $0
  102504:	6a 00                	push   $0x0
  pushl $230
  102506:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  10250b:	e9 2c 01 00 00       	jmp    10263c <__alltraps>

00102510 <vector231>:
.globl vector231
vector231:
  pushl $0
  102510:	6a 00                	push   $0x0
  pushl $231
  102512:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  102517:	e9 20 01 00 00       	jmp    10263c <__alltraps>

0010251c <vector232>:
.globl vector232
vector232:
  pushl $0
  10251c:	6a 00                	push   $0x0
  pushl $232
  10251e:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  102523:	e9 14 01 00 00       	jmp    10263c <__alltraps>

00102528 <vector233>:
.globl vector233
vector233:
  pushl $0
  102528:	6a 00                	push   $0x0
  pushl $233
  10252a:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  10252f:	e9 08 01 00 00       	jmp    10263c <__alltraps>

00102534 <vector234>:
.globl vector234
vector234:
  pushl $0
  102534:	6a 00                	push   $0x0
  pushl $234
  102536:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  10253b:	e9 fc 00 00 00       	jmp    10263c <__alltraps>

00102540 <vector235>:
.globl vector235
vector235:
  pushl $0
  102540:	6a 00                	push   $0x0
  pushl $235
  102542:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  102547:	e9 f0 00 00 00       	jmp    10263c <__alltraps>

0010254c <vector236>:
.globl vector236
vector236:
  pushl $0
  10254c:	6a 00                	push   $0x0
  pushl $236
  10254e:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  102553:	e9 e4 00 00 00       	jmp    10263c <__alltraps>

00102558 <vector237>:
.globl vector237
vector237:
  pushl $0
  102558:	6a 00                	push   $0x0
  pushl $237
  10255a:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  10255f:	e9 d8 00 00 00       	jmp    10263c <__alltraps>

00102564 <vector238>:
.globl vector238
vector238:
  pushl $0
  102564:	6a 00                	push   $0x0
  pushl $238
  102566:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  10256b:	e9 cc 00 00 00       	jmp    10263c <__alltraps>

00102570 <vector239>:
.globl vector239
vector239:
  pushl $0
  102570:	6a 00                	push   $0x0
  pushl $239
  102572:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  102577:	e9 c0 00 00 00       	jmp    10263c <__alltraps>

0010257c <vector240>:
.globl vector240
vector240:
  pushl $0
  10257c:	6a 00                	push   $0x0
  pushl $240
  10257e:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  102583:	e9 b4 00 00 00       	jmp    10263c <__alltraps>

00102588 <vector241>:
.globl vector241
vector241:
  pushl $0
  102588:	6a 00                	push   $0x0
  pushl $241
  10258a:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  10258f:	e9 a8 00 00 00       	jmp    10263c <__alltraps>

00102594 <vector242>:
.globl vector242
vector242:
  pushl $0
  102594:	6a 00                	push   $0x0
  pushl $242
  102596:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  10259b:	e9 9c 00 00 00       	jmp    10263c <__alltraps>

001025a0 <vector243>:
.globl vector243
vector243:
  pushl $0
  1025a0:	6a 00                	push   $0x0
  pushl $243
  1025a2:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  1025a7:	e9 90 00 00 00       	jmp    10263c <__alltraps>

001025ac <vector244>:
.globl vector244
vector244:
  pushl $0
  1025ac:	6a 00                	push   $0x0
  pushl $244
  1025ae:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  1025b3:	e9 84 00 00 00       	jmp    10263c <__alltraps>

001025b8 <vector245>:
.globl vector245
vector245:
  pushl $0
  1025b8:	6a 00                	push   $0x0
  pushl $245
  1025ba:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  1025bf:	e9 78 00 00 00       	jmp    10263c <__alltraps>

001025c4 <vector246>:
.globl vector246
vector246:
  pushl $0
  1025c4:	6a 00                	push   $0x0
  pushl $246
  1025c6:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  1025cb:	e9 6c 00 00 00       	jmp    10263c <__alltraps>

001025d0 <vector247>:
.globl vector247
vector247:
  pushl $0
  1025d0:	6a 00                	push   $0x0
  pushl $247
  1025d2:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  1025d7:	e9 60 00 00 00       	jmp    10263c <__alltraps>

001025dc <vector248>:
.globl vector248
vector248:
  pushl $0
  1025dc:	6a 00                	push   $0x0
  pushl $248
  1025de:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  1025e3:	e9 54 00 00 00       	jmp    10263c <__alltraps>

001025e8 <vector249>:
.globl vector249
vector249:
  pushl $0
  1025e8:	6a 00                	push   $0x0
  pushl $249
  1025ea:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  1025ef:	e9 48 00 00 00       	jmp    10263c <__alltraps>

001025f4 <vector250>:
.globl vector250
vector250:
  pushl $0
  1025f4:	6a 00                	push   $0x0
  pushl $250
  1025f6:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  1025fb:	e9 3c 00 00 00       	jmp    10263c <__alltraps>

00102600 <vector251>:
.globl vector251
vector251:
  pushl $0
  102600:	6a 00                	push   $0x0
  pushl $251
  102602:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  102607:	e9 30 00 00 00       	jmp    10263c <__alltraps>

0010260c <vector252>:
.globl vector252
vector252:
  pushl $0
  10260c:	6a 00                	push   $0x0
  pushl $252
  10260e:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  102613:	e9 24 00 00 00       	jmp    10263c <__alltraps>

00102618 <vector253>:
.globl vector253
vector253:
  pushl $0
  102618:	6a 00                	push   $0x0
  pushl $253
  10261a:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  10261f:	e9 18 00 00 00       	jmp    10263c <__alltraps>

00102624 <vector254>:
.globl vector254
vector254:
  pushl $0
  102624:	6a 00                	push   $0x0
  pushl $254
  102626:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  10262b:	e9 0c 00 00 00       	jmp    10263c <__alltraps>

00102630 <vector255>:
.globl vector255
vector255:
  pushl $0
  102630:	6a 00                	push   $0x0
  pushl $255
  102632:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  102637:	e9 00 00 00 00       	jmp    10263c <__alltraps>

0010263c <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  10263c:	1e                   	push   %ds
    pushl %es
  10263d:	06                   	push   %es
    pushl %fs
  10263e:	0f a0                	push   %fs
    pushl %gs
  102640:	0f a8                	push   %gs
    pushal
  102642:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  102643:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  102648:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  10264a:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  10264c:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  10264d:	e8 65 f5 ff ff       	call   101bb7 <trap>

    # pop the pushed stack pointer
    popl %esp
  102652:	5c                   	pop    %esp

00102653 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  102653:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  102654:	0f a9                	pop    %gs
    popl %fs
  102656:	0f a1                	pop    %fs
    popl %es
  102658:	07                   	pop    %es
    popl %ds
  102659:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  10265a:	83 c4 08             	add    $0x8,%esp
    iret
  10265d:	cf                   	iret   

0010265e <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  10265e:	55                   	push   %ebp
  10265f:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  102661:	8b 45 08             	mov    0x8(%ebp),%eax
  102664:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  102667:	b8 23 00 00 00       	mov    $0x23,%eax
  10266c:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  10266e:	b8 23 00 00 00       	mov    $0x23,%eax
  102673:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  102675:	b8 10 00 00 00       	mov    $0x10,%eax
  10267a:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  10267c:	b8 10 00 00 00       	mov    $0x10,%eax
  102681:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  102683:	b8 10 00 00 00       	mov    $0x10,%eax
  102688:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  10268a:	ea 91 26 10 00 08 00 	ljmp   $0x8,$0x102691
}
  102691:	5d                   	pop    %ebp
  102692:	c3                   	ret    

00102693 <gdt_init>:
/* temporary kernel stack */
uint8_t stack0[1024];

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  102693:	55                   	push   %ebp
  102694:	89 e5                	mov    %esp,%ebp
  102696:	83 ec 14             	sub    $0x14,%esp
    // Setup a TSS so that we can get the right stack when we trap from
    // user to the kernel. But not safe here, it's only a temporary value,
    // it will be set to KSTACKTOP in lab2.
    ts.ts_esp0 = (uint32_t)&stack0 + sizeof(stack0);
  102699:	b8 20 f9 10 00       	mov    $0x10f920,%eax
  10269e:	05 00 04 00 00       	add    $0x400,%eax
  1026a3:	a3 a4 f8 10 00       	mov    %eax,0x10f8a4
    ts.ts_ss0 = KERNEL_DS;
  1026a8:	66 c7 05 a8 f8 10 00 	movw   $0x10,0x10f8a8
  1026af:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEG16(STS_T32A, (uint32_t)&ts, sizeof(ts), DPL_KERNEL);
  1026b1:	66 c7 05 08 ea 10 00 	movw   $0x68,0x10ea08
  1026b8:	68 00 
  1026ba:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  1026bf:	66 a3 0a ea 10 00    	mov    %ax,0x10ea0a
  1026c5:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  1026ca:	c1 e8 10             	shr    $0x10,%eax
  1026cd:	a2 0c ea 10 00       	mov    %al,0x10ea0c
  1026d2:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1026d9:	83 e0 f0             	and    $0xfffffff0,%eax
  1026dc:	83 c8 09             	or     $0x9,%eax
  1026df:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  1026e4:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1026eb:	83 c8 10             	or     $0x10,%eax
  1026ee:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  1026f3:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1026fa:	83 e0 9f             	and    $0xffffff9f,%eax
  1026fd:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102702:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102709:	83 c8 80             	or     $0xffffff80,%eax
  10270c:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102711:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102718:	83 e0 f0             	and    $0xfffffff0,%eax
  10271b:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102720:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102727:	83 e0 ef             	and    $0xffffffef,%eax
  10272a:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  10272f:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102736:	83 e0 df             	and    $0xffffffdf,%eax
  102739:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  10273e:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102745:	83 c8 40             	or     $0x40,%eax
  102748:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  10274d:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102754:	83 e0 7f             	and    $0x7f,%eax
  102757:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  10275c:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  102761:	c1 e8 18             	shr    $0x18,%eax
  102764:	a2 0f ea 10 00       	mov    %al,0x10ea0f
    gdt[SEG_TSS].sd_s = 0;
  102769:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102770:	83 e0 ef             	and    $0xffffffef,%eax
  102773:	a2 0d ea 10 00       	mov    %al,0x10ea0d

    // reload all segment registers
    lgdt(&gdt_pd);
  102778:	c7 04 24 10 ea 10 00 	movl   $0x10ea10,(%esp)
  10277f:	e8 da fe ff ff       	call   10265e <lgdt>
  102784:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel));
  10278a:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  10278e:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  102791:	c9                   	leave  
  102792:	c3                   	ret    

00102793 <pmm_init>:

/* pmm_init - initialize the physical memory management */
void
pmm_init(void) {
  102793:	55                   	push   %ebp
  102794:	89 e5                	mov    %esp,%ebp
    gdt_init();
  102796:	e8 f8 fe ff ff       	call   102693 <gdt_init>
}
  10279b:	5d                   	pop    %ebp
  10279c:	c3                   	ret    

0010279d <strlen>:
 * @s:        the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  10279d:	55                   	push   %ebp
  10279e:	89 e5                	mov    %esp,%ebp
  1027a0:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  1027a3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  1027aa:	eb 04                	jmp    1027b0 <strlen+0x13>
        cnt ++;
  1027ac:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    while (*s ++ != '\0') {
  1027b0:	8b 45 08             	mov    0x8(%ebp),%eax
  1027b3:	8d 50 01             	lea    0x1(%eax),%edx
  1027b6:	89 55 08             	mov    %edx,0x8(%ebp)
  1027b9:	0f b6 00             	movzbl (%eax),%eax
  1027bc:	84 c0                	test   %al,%al
  1027be:	75 ec                	jne    1027ac <strlen+0xf>
    }
    return cnt;
  1027c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1027c3:	c9                   	leave  
  1027c4:	c3                   	ret    

001027c5 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  1027c5:	55                   	push   %ebp
  1027c6:	89 e5                	mov    %esp,%ebp
  1027c8:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  1027cb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  1027d2:	eb 04                	jmp    1027d8 <strnlen+0x13>
        cnt ++;
  1027d4:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  1027d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1027db:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1027de:	73 10                	jae    1027f0 <strnlen+0x2b>
  1027e0:	8b 45 08             	mov    0x8(%ebp),%eax
  1027e3:	8d 50 01             	lea    0x1(%eax),%edx
  1027e6:	89 55 08             	mov    %edx,0x8(%ebp)
  1027e9:	0f b6 00             	movzbl (%eax),%eax
  1027ec:	84 c0                	test   %al,%al
  1027ee:	75 e4                	jne    1027d4 <strnlen+0xf>
    }
    return cnt;
  1027f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1027f3:	c9                   	leave  
  1027f4:	c3                   	ret    

001027f5 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  1027f5:	55                   	push   %ebp
  1027f6:	89 e5                	mov    %esp,%ebp
  1027f8:	57                   	push   %edi
  1027f9:	56                   	push   %esi
  1027fa:	83 ec 20             	sub    $0x20,%esp
  1027fd:	8b 45 08             	mov    0x8(%ebp),%eax
  102800:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102803:	8b 45 0c             	mov    0xc(%ebp),%eax
  102806:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  102809:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10280c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10280f:	89 d1                	mov    %edx,%ecx
  102811:	89 c2                	mov    %eax,%edx
  102813:	89 ce                	mov    %ecx,%esi
  102815:	89 d7                	mov    %edx,%edi
  102817:	ac                   	lods   %ds:(%esi),%al
  102818:	aa                   	stos   %al,%es:(%edi)
  102819:	84 c0                	test   %al,%al
  10281b:	75 fa                	jne    102817 <strcpy+0x22>
  10281d:	89 fa                	mov    %edi,%edx
  10281f:	89 f1                	mov    %esi,%ecx
  102821:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  102824:	89 55 e8             	mov    %edx,-0x18(%ebp)
  102827:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "stosb;"
            "testb %%al, %%al;"
            "jne 1b;"
            : "=&S" (d0), "=&D" (d1), "=&a" (d2)
            : "0" (src), "1" (dst) : "memory");
    return dst;
  10282a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  10282d:	83 c4 20             	add    $0x20,%esp
  102830:	5e                   	pop    %esi
  102831:	5f                   	pop    %edi
  102832:	5d                   	pop    %ebp
  102833:	c3                   	ret    

00102834 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  102834:	55                   	push   %ebp
  102835:	89 e5                	mov    %esp,%ebp
  102837:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  10283a:	8b 45 08             	mov    0x8(%ebp),%eax
  10283d:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  102840:	eb 21                	jmp    102863 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  102842:	8b 45 0c             	mov    0xc(%ebp),%eax
  102845:	0f b6 10             	movzbl (%eax),%edx
  102848:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10284b:	88 10                	mov    %dl,(%eax)
  10284d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102850:	0f b6 00             	movzbl (%eax),%eax
  102853:	84 c0                	test   %al,%al
  102855:	74 04                	je     10285b <strncpy+0x27>
            src ++;
  102857:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  10285b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10285f:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    while (len > 0) {
  102863:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102867:	75 d9                	jne    102842 <strncpy+0xe>
    }
    return dst;
  102869:	8b 45 08             	mov    0x8(%ebp),%eax
}
  10286c:	c9                   	leave  
  10286d:	c3                   	ret    

0010286e <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  10286e:	55                   	push   %ebp
  10286f:	89 e5                	mov    %esp,%ebp
  102871:	57                   	push   %edi
  102872:	56                   	push   %esi
  102873:	83 ec 20             	sub    $0x20,%esp
  102876:	8b 45 08             	mov    0x8(%ebp),%eax
  102879:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10287c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10287f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
  102882:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102885:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102888:	89 d1                	mov    %edx,%ecx
  10288a:	89 c2                	mov    %eax,%edx
  10288c:	89 ce                	mov    %ecx,%esi
  10288e:	89 d7                	mov    %edx,%edi
  102890:	ac                   	lods   %ds:(%esi),%al
  102891:	ae                   	scas   %es:(%edi),%al
  102892:	75 08                	jne    10289c <strcmp+0x2e>
  102894:	84 c0                	test   %al,%al
  102896:	75 f8                	jne    102890 <strcmp+0x22>
  102898:	31 c0                	xor    %eax,%eax
  10289a:	eb 04                	jmp    1028a0 <strcmp+0x32>
  10289c:	19 c0                	sbb    %eax,%eax
  10289e:	0c 01                	or     $0x1,%al
  1028a0:	89 fa                	mov    %edi,%edx
  1028a2:	89 f1                	mov    %esi,%ecx
  1028a4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1028a7:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  1028aa:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
  1028ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  1028b0:	83 c4 20             	add    $0x20,%esp
  1028b3:	5e                   	pop    %esi
  1028b4:	5f                   	pop    %edi
  1028b5:	5d                   	pop    %ebp
  1028b6:	c3                   	ret    

001028b7 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  1028b7:	55                   	push   %ebp
  1028b8:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  1028ba:	eb 0c                	jmp    1028c8 <strncmp+0x11>
        n --, s1 ++, s2 ++;
  1028bc:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  1028c0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1028c4:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  1028c8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1028cc:	74 1a                	je     1028e8 <strncmp+0x31>
  1028ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1028d1:	0f b6 00             	movzbl (%eax),%eax
  1028d4:	84 c0                	test   %al,%al
  1028d6:	74 10                	je     1028e8 <strncmp+0x31>
  1028d8:	8b 45 08             	mov    0x8(%ebp),%eax
  1028db:	0f b6 10             	movzbl (%eax),%edx
  1028de:	8b 45 0c             	mov    0xc(%ebp),%eax
  1028e1:	0f b6 00             	movzbl (%eax),%eax
  1028e4:	38 c2                	cmp    %al,%dl
  1028e6:	74 d4                	je     1028bc <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  1028e8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1028ec:	74 18                	je     102906 <strncmp+0x4f>
  1028ee:	8b 45 08             	mov    0x8(%ebp),%eax
  1028f1:	0f b6 00             	movzbl (%eax),%eax
  1028f4:	0f b6 d0             	movzbl %al,%edx
  1028f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1028fa:	0f b6 00             	movzbl (%eax),%eax
  1028fd:	0f b6 c0             	movzbl %al,%eax
  102900:	29 c2                	sub    %eax,%edx
  102902:	89 d0                	mov    %edx,%eax
  102904:	eb 05                	jmp    10290b <strncmp+0x54>
  102906:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10290b:	5d                   	pop    %ebp
  10290c:	c3                   	ret    

0010290d <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  10290d:	55                   	push   %ebp
  10290e:	89 e5                	mov    %esp,%ebp
  102910:	83 ec 04             	sub    $0x4,%esp
  102913:	8b 45 0c             	mov    0xc(%ebp),%eax
  102916:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102919:	eb 14                	jmp    10292f <strchr+0x22>
        if (*s == c) {
  10291b:	8b 45 08             	mov    0x8(%ebp),%eax
  10291e:	0f b6 00             	movzbl (%eax),%eax
  102921:	3a 45 fc             	cmp    -0x4(%ebp),%al
  102924:	75 05                	jne    10292b <strchr+0x1e>
            return (char *)s;
  102926:	8b 45 08             	mov    0x8(%ebp),%eax
  102929:	eb 13                	jmp    10293e <strchr+0x31>
        }
        s ++;
  10292b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s != '\0') {
  10292f:	8b 45 08             	mov    0x8(%ebp),%eax
  102932:	0f b6 00             	movzbl (%eax),%eax
  102935:	84 c0                	test   %al,%al
  102937:	75 e2                	jne    10291b <strchr+0xe>
    }
    return NULL;
  102939:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10293e:	c9                   	leave  
  10293f:	c3                   	ret    

00102940 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  102940:	55                   	push   %ebp
  102941:	89 e5                	mov    %esp,%ebp
  102943:	83 ec 04             	sub    $0x4,%esp
  102946:	8b 45 0c             	mov    0xc(%ebp),%eax
  102949:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  10294c:	eb 11                	jmp    10295f <strfind+0x1f>
        if (*s == c) {
  10294e:	8b 45 08             	mov    0x8(%ebp),%eax
  102951:	0f b6 00             	movzbl (%eax),%eax
  102954:	3a 45 fc             	cmp    -0x4(%ebp),%al
  102957:	75 02                	jne    10295b <strfind+0x1b>
            break;
  102959:	eb 0e                	jmp    102969 <strfind+0x29>
        }
        s ++;
  10295b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s != '\0') {
  10295f:	8b 45 08             	mov    0x8(%ebp),%eax
  102962:	0f b6 00             	movzbl (%eax),%eax
  102965:	84 c0                	test   %al,%al
  102967:	75 e5                	jne    10294e <strfind+0xe>
    }
    return (char *)s;
  102969:	8b 45 08             	mov    0x8(%ebp),%eax
}
  10296c:	c9                   	leave  
  10296d:	c3                   	ret    

0010296e <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  10296e:	55                   	push   %ebp
  10296f:	89 e5                	mov    %esp,%ebp
  102971:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  102974:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  10297b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  102982:	eb 04                	jmp    102988 <strtol+0x1a>
        s ++;
  102984:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
  102988:	8b 45 08             	mov    0x8(%ebp),%eax
  10298b:	0f b6 00             	movzbl (%eax),%eax
  10298e:	3c 20                	cmp    $0x20,%al
  102990:	74 f2                	je     102984 <strtol+0x16>
  102992:	8b 45 08             	mov    0x8(%ebp),%eax
  102995:	0f b6 00             	movzbl (%eax),%eax
  102998:	3c 09                	cmp    $0x9,%al
  10299a:	74 e8                	je     102984 <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+') {
  10299c:	8b 45 08             	mov    0x8(%ebp),%eax
  10299f:	0f b6 00             	movzbl (%eax),%eax
  1029a2:	3c 2b                	cmp    $0x2b,%al
  1029a4:	75 06                	jne    1029ac <strtol+0x3e>
        s ++;
  1029a6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1029aa:	eb 15                	jmp    1029c1 <strtol+0x53>
    }
    else if (*s == '-') {
  1029ac:	8b 45 08             	mov    0x8(%ebp),%eax
  1029af:	0f b6 00             	movzbl (%eax),%eax
  1029b2:	3c 2d                	cmp    $0x2d,%al
  1029b4:	75 0b                	jne    1029c1 <strtol+0x53>
        s ++, neg = 1;
  1029b6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1029ba:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  1029c1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1029c5:	74 06                	je     1029cd <strtol+0x5f>
  1029c7:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  1029cb:	75 24                	jne    1029f1 <strtol+0x83>
  1029cd:	8b 45 08             	mov    0x8(%ebp),%eax
  1029d0:	0f b6 00             	movzbl (%eax),%eax
  1029d3:	3c 30                	cmp    $0x30,%al
  1029d5:	75 1a                	jne    1029f1 <strtol+0x83>
  1029d7:	8b 45 08             	mov    0x8(%ebp),%eax
  1029da:	83 c0 01             	add    $0x1,%eax
  1029dd:	0f b6 00             	movzbl (%eax),%eax
  1029e0:	3c 78                	cmp    $0x78,%al
  1029e2:	75 0d                	jne    1029f1 <strtol+0x83>
        s += 2, base = 16;
  1029e4:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  1029e8:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  1029ef:	eb 2a                	jmp    102a1b <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  1029f1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1029f5:	75 17                	jne    102a0e <strtol+0xa0>
  1029f7:	8b 45 08             	mov    0x8(%ebp),%eax
  1029fa:	0f b6 00             	movzbl (%eax),%eax
  1029fd:	3c 30                	cmp    $0x30,%al
  1029ff:	75 0d                	jne    102a0e <strtol+0xa0>
        s ++, base = 8;
  102a01:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102a05:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  102a0c:	eb 0d                	jmp    102a1b <strtol+0xad>
    }
    else if (base == 0) {
  102a0e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102a12:	75 07                	jne    102a1b <strtol+0xad>
        base = 10;
  102a14:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  102a1b:	8b 45 08             	mov    0x8(%ebp),%eax
  102a1e:	0f b6 00             	movzbl (%eax),%eax
  102a21:	3c 2f                	cmp    $0x2f,%al
  102a23:	7e 1b                	jle    102a40 <strtol+0xd2>
  102a25:	8b 45 08             	mov    0x8(%ebp),%eax
  102a28:	0f b6 00             	movzbl (%eax),%eax
  102a2b:	3c 39                	cmp    $0x39,%al
  102a2d:	7f 11                	jg     102a40 <strtol+0xd2>
            dig = *s - '0';
  102a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  102a32:	0f b6 00             	movzbl (%eax),%eax
  102a35:	0f be c0             	movsbl %al,%eax
  102a38:	83 e8 30             	sub    $0x30,%eax
  102a3b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102a3e:	eb 48                	jmp    102a88 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  102a40:	8b 45 08             	mov    0x8(%ebp),%eax
  102a43:	0f b6 00             	movzbl (%eax),%eax
  102a46:	3c 60                	cmp    $0x60,%al
  102a48:	7e 1b                	jle    102a65 <strtol+0xf7>
  102a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  102a4d:	0f b6 00             	movzbl (%eax),%eax
  102a50:	3c 7a                	cmp    $0x7a,%al
  102a52:	7f 11                	jg     102a65 <strtol+0xf7>
            dig = *s - 'a' + 10;
  102a54:	8b 45 08             	mov    0x8(%ebp),%eax
  102a57:	0f b6 00             	movzbl (%eax),%eax
  102a5a:	0f be c0             	movsbl %al,%eax
  102a5d:	83 e8 57             	sub    $0x57,%eax
  102a60:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102a63:	eb 23                	jmp    102a88 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  102a65:	8b 45 08             	mov    0x8(%ebp),%eax
  102a68:	0f b6 00             	movzbl (%eax),%eax
  102a6b:	3c 40                	cmp    $0x40,%al
  102a6d:	7e 3d                	jle    102aac <strtol+0x13e>
  102a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  102a72:	0f b6 00             	movzbl (%eax),%eax
  102a75:	3c 5a                	cmp    $0x5a,%al
  102a77:	7f 33                	jg     102aac <strtol+0x13e>
            dig = *s - 'A' + 10;
  102a79:	8b 45 08             	mov    0x8(%ebp),%eax
  102a7c:	0f b6 00             	movzbl (%eax),%eax
  102a7f:	0f be c0             	movsbl %al,%eax
  102a82:	83 e8 37             	sub    $0x37,%eax
  102a85:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  102a88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a8b:	3b 45 10             	cmp    0x10(%ebp),%eax
  102a8e:	7c 02                	jl     102a92 <strtol+0x124>
            break;
  102a90:	eb 1a                	jmp    102aac <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
  102a92:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  102a96:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102a99:	0f af 45 10          	imul   0x10(%ebp),%eax
  102a9d:	89 c2                	mov    %eax,%edx
  102a9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102aa2:	01 d0                	add    %edx,%eax
  102aa4:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  102aa7:	e9 6f ff ff ff       	jmp    102a1b <strtol+0xad>

    if (endptr) {
  102aac:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102ab0:	74 08                	je     102aba <strtol+0x14c>
        *endptr = (char *) s;
  102ab2:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ab5:	8b 55 08             	mov    0x8(%ebp),%edx
  102ab8:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  102aba:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  102abe:	74 07                	je     102ac7 <strtol+0x159>
  102ac0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102ac3:	f7 d8                	neg    %eax
  102ac5:	eb 03                	jmp    102aca <strtol+0x15c>
  102ac7:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  102aca:	c9                   	leave  
  102acb:	c3                   	ret    

00102acc <memset>:
 * @n:        number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  102acc:	55                   	push   %ebp
  102acd:	89 e5                	mov    %esp,%ebp
  102acf:	57                   	push   %edi
  102ad0:	83 ec 24             	sub    $0x24,%esp
  102ad3:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ad6:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  102ad9:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  102add:	8b 55 08             	mov    0x8(%ebp),%edx
  102ae0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  102ae3:	88 45 f7             	mov    %al,-0x9(%ebp)
  102ae6:	8b 45 10             	mov    0x10(%ebp),%eax
  102ae9:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  102aec:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  102aef:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  102af3:	8b 55 f8             	mov    -0x8(%ebp),%edx
  102af6:	89 d7                	mov    %edx,%edi
  102af8:	f3 aa                	rep stos %al,%es:(%edi)
  102afa:	89 fa                	mov    %edi,%edx
  102afc:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  102aff:	89 55 e8             	mov    %edx,-0x18(%ebp)
            "rep; stosb;"
            : "=&c" (d0), "=&D" (d1)
            : "0" (n), "a" (c), "1" (s)
            : "memory");
    return s;
  102b02:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  102b05:	83 c4 24             	add    $0x24,%esp
  102b08:	5f                   	pop    %edi
  102b09:	5d                   	pop    %ebp
  102b0a:	c3                   	ret    

00102b0b <memmove>:
 * @n:        number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  102b0b:	55                   	push   %ebp
  102b0c:	89 e5                	mov    %esp,%ebp
  102b0e:	57                   	push   %edi
  102b0f:	56                   	push   %esi
  102b10:	53                   	push   %ebx
  102b11:	83 ec 30             	sub    $0x30,%esp
  102b14:	8b 45 08             	mov    0x8(%ebp),%eax
  102b17:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102b1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b1d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102b20:	8b 45 10             	mov    0x10(%ebp),%eax
  102b23:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  102b26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102b29:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  102b2c:	73 42                	jae    102b70 <memmove+0x65>
  102b2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102b31:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102b34:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102b37:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102b3a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102b3d:	89 45 dc             	mov    %eax,-0x24(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  102b40:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102b43:	c1 e8 02             	shr    $0x2,%eax
  102b46:	89 c1                	mov    %eax,%ecx
    asm volatile (
  102b48:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102b4b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102b4e:	89 d7                	mov    %edx,%edi
  102b50:	89 c6                	mov    %eax,%esi
  102b52:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  102b54:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  102b57:	83 e1 03             	and    $0x3,%ecx
  102b5a:	74 02                	je     102b5e <memmove+0x53>
  102b5c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102b5e:	89 f0                	mov    %esi,%eax
  102b60:	89 fa                	mov    %edi,%edx
  102b62:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  102b65:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102b68:	89 45 d0             	mov    %eax,-0x30(%ebp)
            : "memory");
    return dst;
  102b6b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102b6e:	eb 36                	jmp    102ba6 <memmove+0x9b>
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  102b70:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102b73:	8d 50 ff             	lea    -0x1(%eax),%edx
  102b76:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102b79:	01 c2                	add    %eax,%edx
  102b7b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102b7e:	8d 48 ff             	lea    -0x1(%eax),%ecx
  102b81:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102b84:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
  102b87:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102b8a:	89 c1                	mov    %eax,%ecx
  102b8c:	89 d8                	mov    %ebx,%eax
  102b8e:	89 d6                	mov    %edx,%esi
  102b90:	89 c7                	mov    %eax,%edi
  102b92:	fd                   	std    
  102b93:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102b95:	fc                   	cld    
  102b96:	89 f8                	mov    %edi,%eax
  102b98:	89 f2                	mov    %esi,%edx
  102b9a:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  102b9d:	89 55 c8             	mov    %edx,-0x38(%ebp)
  102ba0:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
  102ba3:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  102ba6:	83 c4 30             	add    $0x30,%esp
  102ba9:	5b                   	pop    %ebx
  102baa:	5e                   	pop    %esi
  102bab:	5f                   	pop    %edi
  102bac:	5d                   	pop    %ebp
  102bad:	c3                   	ret    

00102bae <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  102bae:	55                   	push   %ebp
  102baf:	89 e5                	mov    %esp,%ebp
  102bb1:	57                   	push   %edi
  102bb2:	56                   	push   %esi
  102bb3:	83 ec 20             	sub    $0x20,%esp
  102bb6:	8b 45 08             	mov    0x8(%ebp),%eax
  102bb9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102bbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  102bbf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102bc2:	8b 45 10             	mov    0x10(%ebp),%eax
  102bc5:	89 45 ec             	mov    %eax,-0x14(%ebp)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  102bc8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102bcb:	c1 e8 02             	shr    $0x2,%eax
  102bce:	89 c1                	mov    %eax,%ecx
    asm volatile (
  102bd0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102bd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102bd6:	89 d7                	mov    %edx,%edi
  102bd8:	89 c6                	mov    %eax,%esi
  102bda:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  102bdc:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  102bdf:	83 e1 03             	and    $0x3,%ecx
  102be2:	74 02                	je     102be6 <memcpy+0x38>
  102be4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102be6:	89 f0                	mov    %esi,%eax
  102be8:	89 fa                	mov    %edi,%edx
  102bea:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  102bed:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  102bf0:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
  102bf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  102bf6:	83 c4 20             	add    $0x20,%esp
  102bf9:	5e                   	pop    %esi
  102bfa:	5f                   	pop    %edi
  102bfb:	5d                   	pop    %ebp
  102bfc:	c3                   	ret    

00102bfd <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  102bfd:	55                   	push   %ebp
  102bfe:	89 e5                	mov    %esp,%ebp
  102c00:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  102c03:	8b 45 08             	mov    0x8(%ebp),%eax
  102c06:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  102c09:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c0c:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  102c0f:	eb 30                	jmp    102c41 <memcmp+0x44>
        if (*s1 != *s2) {
  102c11:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102c14:	0f b6 10             	movzbl (%eax),%edx
  102c17:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102c1a:	0f b6 00             	movzbl (%eax),%eax
  102c1d:	38 c2                	cmp    %al,%dl
  102c1f:	74 18                	je     102c39 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  102c21:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102c24:	0f b6 00             	movzbl (%eax),%eax
  102c27:	0f b6 d0             	movzbl %al,%edx
  102c2a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102c2d:	0f b6 00             	movzbl (%eax),%eax
  102c30:	0f b6 c0             	movzbl %al,%eax
  102c33:	29 c2                	sub    %eax,%edx
  102c35:	89 d0                	mov    %edx,%eax
  102c37:	eb 1a                	jmp    102c53 <memcmp+0x56>
        }
        s1 ++, s2 ++;
  102c39:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  102c3d:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
    while (n -- > 0) {
  102c41:	8b 45 10             	mov    0x10(%ebp),%eax
  102c44:	8d 50 ff             	lea    -0x1(%eax),%edx
  102c47:	89 55 10             	mov    %edx,0x10(%ebp)
  102c4a:	85 c0                	test   %eax,%eax
  102c4c:	75 c3                	jne    102c11 <memcmp+0x14>
    }
    return 0;
  102c4e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102c53:	c9                   	leave  
  102c54:	c3                   	ret    

00102c55 <printnum>:
 * @width:         maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:        character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  102c55:	55                   	push   %ebp
  102c56:	89 e5                	mov    %esp,%ebp
  102c58:	83 ec 58             	sub    $0x58,%esp
  102c5b:	8b 45 10             	mov    0x10(%ebp),%eax
  102c5e:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102c61:	8b 45 14             	mov    0x14(%ebp),%eax
  102c64:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  102c67:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102c6a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102c6d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102c70:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  102c73:	8b 45 18             	mov    0x18(%ebp),%eax
  102c76:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102c79:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102c7c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102c7f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102c82:	89 55 f0             	mov    %edx,-0x10(%ebp)
  102c85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102c88:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102c8b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102c8f:	74 1c                	je     102cad <printnum+0x58>
  102c91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102c94:	ba 00 00 00 00       	mov    $0x0,%edx
  102c99:	f7 75 e4             	divl   -0x1c(%ebp)
  102c9c:	89 55 f4             	mov    %edx,-0xc(%ebp)
  102c9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ca2:	ba 00 00 00 00       	mov    $0x0,%edx
  102ca7:	f7 75 e4             	divl   -0x1c(%ebp)
  102caa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102cad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102cb0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102cb3:	f7 75 e4             	divl   -0x1c(%ebp)
  102cb6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102cb9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  102cbc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102cbf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102cc2:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102cc5:	89 55 ec             	mov    %edx,-0x14(%ebp)
  102cc8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102ccb:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  102cce:	8b 45 18             	mov    0x18(%ebp),%eax
  102cd1:	ba 00 00 00 00       	mov    $0x0,%edx
  102cd6:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  102cd9:	77 56                	ja     102d31 <printnum+0xdc>
  102cdb:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  102cde:	72 05                	jb     102ce5 <printnum+0x90>
  102ce0:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  102ce3:	77 4c                	ja     102d31 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
  102ce5:	8b 45 1c             	mov    0x1c(%ebp),%eax
  102ce8:	8d 50 ff             	lea    -0x1(%eax),%edx
  102ceb:	8b 45 20             	mov    0x20(%ebp),%eax
  102cee:	89 44 24 18          	mov    %eax,0x18(%esp)
  102cf2:	89 54 24 14          	mov    %edx,0x14(%esp)
  102cf6:	8b 45 18             	mov    0x18(%ebp),%eax
  102cf9:	89 44 24 10          	mov    %eax,0x10(%esp)
  102cfd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102d00:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102d03:	89 44 24 08          	mov    %eax,0x8(%esp)
  102d07:	89 54 24 0c          	mov    %edx,0xc(%esp)
  102d0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d0e:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d12:	8b 45 08             	mov    0x8(%ebp),%eax
  102d15:	89 04 24             	mov    %eax,(%esp)
  102d18:	e8 38 ff ff ff       	call   102c55 <printnum>
  102d1d:	eb 1c                	jmp    102d3b <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  102d1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d22:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d26:	8b 45 20             	mov    0x20(%ebp),%eax
  102d29:	89 04 24             	mov    %eax,(%esp)
  102d2c:	8b 45 08             	mov    0x8(%ebp),%eax
  102d2f:	ff d0                	call   *%eax
        while (-- width > 0)
  102d31:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  102d35:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  102d39:	7f e4                	jg     102d1f <printnum+0xca>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  102d3b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102d3e:	05 70 3a 10 00       	add    $0x103a70,%eax
  102d43:	0f b6 00             	movzbl (%eax),%eax
  102d46:	0f be c0             	movsbl %al,%eax
  102d49:	8b 55 0c             	mov    0xc(%ebp),%edx
  102d4c:	89 54 24 04          	mov    %edx,0x4(%esp)
  102d50:	89 04 24             	mov    %eax,(%esp)
  102d53:	8b 45 08             	mov    0x8(%ebp),%eax
  102d56:	ff d0                	call   *%eax
}
  102d58:	c9                   	leave  
  102d59:	c3                   	ret    

00102d5a <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  102d5a:	55                   	push   %ebp
  102d5b:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102d5d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102d61:	7e 14                	jle    102d77 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  102d63:	8b 45 08             	mov    0x8(%ebp),%eax
  102d66:	8b 00                	mov    (%eax),%eax
  102d68:	8d 48 08             	lea    0x8(%eax),%ecx
  102d6b:	8b 55 08             	mov    0x8(%ebp),%edx
  102d6e:	89 0a                	mov    %ecx,(%edx)
  102d70:	8b 50 04             	mov    0x4(%eax),%edx
  102d73:	8b 00                	mov    (%eax),%eax
  102d75:	eb 30                	jmp    102da7 <getuint+0x4d>
    }
    else if (lflag) {
  102d77:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102d7b:	74 16                	je     102d93 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  102d7d:	8b 45 08             	mov    0x8(%ebp),%eax
  102d80:	8b 00                	mov    (%eax),%eax
  102d82:	8d 48 04             	lea    0x4(%eax),%ecx
  102d85:	8b 55 08             	mov    0x8(%ebp),%edx
  102d88:	89 0a                	mov    %ecx,(%edx)
  102d8a:	8b 00                	mov    (%eax),%eax
  102d8c:	ba 00 00 00 00       	mov    $0x0,%edx
  102d91:	eb 14                	jmp    102da7 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  102d93:	8b 45 08             	mov    0x8(%ebp),%eax
  102d96:	8b 00                	mov    (%eax),%eax
  102d98:	8d 48 04             	lea    0x4(%eax),%ecx
  102d9b:	8b 55 08             	mov    0x8(%ebp),%edx
  102d9e:	89 0a                	mov    %ecx,(%edx)
  102da0:	8b 00                	mov    (%eax),%eax
  102da2:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  102da7:	5d                   	pop    %ebp
  102da8:	c3                   	ret    

00102da9 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  102da9:	55                   	push   %ebp
  102daa:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102dac:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102db0:	7e 14                	jle    102dc6 <getint+0x1d>
        return va_arg(*ap, long long);
  102db2:	8b 45 08             	mov    0x8(%ebp),%eax
  102db5:	8b 00                	mov    (%eax),%eax
  102db7:	8d 48 08             	lea    0x8(%eax),%ecx
  102dba:	8b 55 08             	mov    0x8(%ebp),%edx
  102dbd:	89 0a                	mov    %ecx,(%edx)
  102dbf:	8b 50 04             	mov    0x4(%eax),%edx
  102dc2:	8b 00                	mov    (%eax),%eax
  102dc4:	eb 28                	jmp    102dee <getint+0x45>
    }
    else if (lflag) {
  102dc6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102dca:	74 12                	je     102dde <getint+0x35>
        return va_arg(*ap, long);
  102dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  102dcf:	8b 00                	mov    (%eax),%eax
  102dd1:	8d 48 04             	lea    0x4(%eax),%ecx
  102dd4:	8b 55 08             	mov    0x8(%ebp),%edx
  102dd7:	89 0a                	mov    %ecx,(%edx)
  102dd9:	8b 00                	mov    (%eax),%eax
  102ddb:	99                   	cltd   
  102ddc:	eb 10                	jmp    102dee <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  102dde:	8b 45 08             	mov    0x8(%ebp),%eax
  102de1:	8b 00                	mov    (%eax),%eax
  102de3:	8d 48 04             	lea    0x4(%eax),%ecx
  102de6:	8b 55 08             	mov    0x8(%ebp),%edx
  102de9:	89 0a                	mov    %ecx,(%edx)
  102deb:	8b 00                	mov    (%eax),%eax
  102ded:	99                   	cltd   
    }
}
  102dee:	5d                   	pop    %ebp
  102def:	c3                   	ret    

00102df0 <printfmt>:
 * @putch:        specified putch function, print a single character
 * @putdat:        used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  102df0:	55                   	push   %ebp
  102df1:	89 e5                	mov    %esp,%ebp
  102df3:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  102df6:	8d 45 14             	lea    0x14(%ebp),%eax
  102df9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  102dfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102dff:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102e03:	8b 45 10             	mov    0x10(%ebp),%eax
  102e06:	89 44 24 08          	mov    %eax,0x8(%esp)
  102e0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e0d:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e11:	8b 45 08             	mov    0x8(%ebp),%eax
  102e14:	89 04 24             	mov    %eax,(%esp)
  102e17:	e8 02 00 00 00       	call   102e1e <vprintfmt>
    va_end(ap);
}
  102e1c:	c9                   	leave  
  102e1d:	c3                   	ret    

00102e1e <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  102e1e:	55                   	push   %ebp
  102e1f:	89 e5                	mov    %esp,%ebp
  102e21:	56                   	push   %esi
  102e22:	53                   	push   %ebx
  102e23:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102e26:	eb 18                	jmp    102e40 <vprintfmt+0x22>
            if (ch == '\0') {
  102e28:	85 db                	test   %ebx,%ebx
  102e2a:	75 05                	jne    102e31 <vprintfmt+0x13>
                return;
  102e2c:	e9 d1 03 00 00       	jmp    103202 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
  102e31:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e34:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e38:	89 1c 24             	mov    %ebx,(%esp)
  102e3b:	8b 45 08             	mov    0x8(%ebp),%eax
  102e3e:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102e40:	8b 45 10             	mov    0x10(%ebp),%eax
  102e43:	8d 50 01             	lea    0x1(%eax),%edx
  102e46:	89 55 10             	mov    %edx,0x10(%ebp)
  102e49:	0f b6 00             	movzbl (%eax),%eax
  102e4c:	0f b6 d8             	movzbl %al,%ebx
  102e4f:	83 fb 25             	cmp    $0x25,%ebx
  102e52:	75 d4                	jne    102e28 <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
  102e54:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  102e58:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  102e5f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102e62:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  102e65:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102e6c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102e6f:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  102e72:	8b 45 10             	mov    0x10(%ebp),%eax
  102e75:	8d 50 01             	lea    0x1(%eax),%edx
  102e78:	89 55 10             	mov    %edx,0x10(%ebp)
  102e7b:	0f b6 00             	movzbl (%eax),%eax
  102e7e:	0f b6 d8             	movzbl %al,%ebx
  102e81:	8d 43 dd             	lea    -0x23(%ebx),%eax
  102e84:	83 f8 55             	cmp    $0x55,%eax
  102e87:	0f 87 44 03 00 00    	ja     1031d1 <vprintfmt+0x3b3>
  102e8d:	8b 04 85 94 3a 10 00 	mov    0x103a94(,%eax,4),%eax
  102e94:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  102e96:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  102e9a:	eb d6                	jmp    102e72 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  102e9c:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  102ea0:	eb d0                	jmp    102e72 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  102ea2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  102ea9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102eac:	89 d0                	mov    %edx,%eax
  102eae:	c1 e0 02             	shl    $0x2,%eax
  102eb1:	01 d0                	add    %edx,%eax
  102eb3:	01 c0                	add    %eax,%eax
  102eb5:	01 d8                	add    %ebx,%eax
  102eb7:	83 e8 30             	sub    $0x30,%eax
  102eba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  102ebd:	8b 45 10             	mov    0x10(%ebp),%eax
  102ec0:	0f b6 00             	movzbl (%eax),%eax
  102ec3:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  102ec6:	83 fb 2f             	cmp    $0x2f,%ebx
  102ec9:	7e 0b                	jle    102ed6 <vprintfmt+0xb8>
  102ecb:	83 fb 39             	cmp    $0x39,%ebx
  102ece:	7f 06                	jg     102ed6 <vprintfmt+0xb8>
            for (precision = 0; ; ++ fmt) {
  102ed0:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                    break;
                }
            }
  102ed4:	eb d3                	jmp    102ea9 <vprintfmt+0x8b>
            goto process_precision;
  102ed6:	eb 33                	jmp    102f0b <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
  102ed8:	8b 45 14             	mov    0x14(%ebp),%eax
  102edb:	8d 50 04             	lea    0x4(%eax),%edx
  102ede:	89 55 14             	mov    %edx,0x14(%ebp)
  102ee1:	8b 00                	mov    (%eax),%eax
  102ee3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  102ee6:	eb 23                	jmp    102f0b <vprintfmt+0xed>

        case '.':
            if (width < 0)
  102ee8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102eec:	79 0c                	jns    102efa <vprintfmt+0xdc>
                width = 0;
  102eee:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  102ef5:	e9 78 ff ff ff       	jmp    102e72 <vprintfmt+0x54>
  102efa:	e9 73 ff ff ff       	jmp    102e72 <vprintfmt+0x54>

        case '#':
            altflag = 1;
  102eff:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  102f06:	e9 67 ff ff ff       	jmp    102e72 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
  102f0b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102f0f:	79 12                	jns    102f23 <vprintfmt+0x105>
                width = precision, precision = -1;
  102f11:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102f14:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102f17:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  102f1e:	e9 4f ff ff ff       	jmp    102e72 <vprintfmt+0x54>
  102f23:	e9 4a ff ff ff       	jmp    102e72 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  102f28:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  102f2c:	e9 41 ff ff ff       	jmp    102e72 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  102f31:	8b 45 14             	mov    0x14(%ebp),%eax
  102f34:	8d 50 04             	lea    0x4(%eax),%edx
  102f37:	89 55 14             	mov    %edx,0x14(%ebp)
  102f3a:	8b 00                	mov    (%eax),%eax
  102f3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  102f3f:	89 54 24 04          	mov    %edx,0x4(%esp)
  102f43:	89 04 24             	mov    %eax,(%esp)
  102f46:	8b 45 08             	mov    0x8(%ebp),%eax
  102f49:	ff d0                	call   *%eax
            break;
  102f4b:	e9 ac 02 00 00       	jmp    1031fc <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
  102f50:	8b 45 14             	mov    0x14(%ebp),%eax
  102f53:	8d 50 04             	lea    0x4(%eax),%edx
  102f56:	89 55 14             	mov    %edx,0x14(%ebp)
  102f59:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  102f5b:	85 db                	test   %ebx,%ebx
  102f5d:	79 02                	jns    102f61 <vprintfmt+0x143>
                err = -err;
  102f5f:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  102f61:	83 fb 06             	cmp    $0x6,%ebx
  102f64:	7f 0b                	jg     102f71 <vprintfmt+0x153>
  102f66:	8b 34 9d 54 3a 10 00 	mov    0x103a54(,%ebx,4),%esi
  102f6d:	85 f6                	test   %esi,%esi
  102f6f:	75 23                	jne    102f94 <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
  102f71:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  102f75:	c7 44 24 08 81 3a 10 	movl   $0x103a81,0x8(%esp)
  102f7c:	00 
  102f7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f80:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f84:	8b 45 08             	mov    0x8(%ebp),%eax
  102f87:	89 04 24             	mov    %eax,(%esp)
  102f8a:	e8 61 fe ff ff       	call   102df0 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  102f8f:	e9 68 02 00 00       	jmp    1031fc <vprintfmt+0x3de>
                printfmt(putch, putdat, "%s", p);
  102f94:	89 74 24 0c          	mov    %esi,0xc(%esp)
  102f98:	c7 44 24 08 8a 3a 10 	movl   $0x103a8a,0x8(%esp)
  102f9f:	00 
  102fa0:	8b 45 0c             	mov    0xc(%ebp),%eax
  102fa3:	89 44 24 04          	mov    %eax,0x4(%esp)
  102fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  102faa:	89 04 24             	mov    %eax,(%esp)
  102fad:	e8 3e fe ff ff       	call   102df0 <printfmt>
            break;
  102fb2:	e9 45 02 00 00       	jmp    1031fc <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  102fb7:	8b 45 14             	mov    0x14(%ebp),%eax
  102fba:	8d 50 04             	lea    0x4(%eax),%edx
  102fbd:	89 55 14             	mov    %edx,0x14(%ebp)
  102fc0:	8b 30                	mov    (%eax),%esi
  102fc2:	85 f6                	test   %esi,%esi
  102fc4:	75 05                	jne    102fcb <vprintfmt+0x1ad>
                p = "(null)";
  102fc6:	be 8d 3a 10 00       	mov    $0x103a8d,%esi
            }
            if (width > 0 && padc != '-') {
  102fcb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102fcf:	7e 3e                	jle    10300f <vprintfmt+0x1f1>
  102fd1:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  102fd5:	74 38                	je     10300f <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
  102fd7:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  102fda:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102fdd:	89 44 24 04          	mov    %eax,0x4(%esp)
  102fe1:	89 34 24             	mov    %esi,(%esp)
  102fe4:	e8 dc f7 ff ff       	call   1027c5 <strnlen>
  102fe9:	29 c3                	sub    %eax,%ebx
  102feb:	89 d8                	mov    %ebx,%eax
  102fed:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102ff0:	eb 17                	jmp    103009 <vprintfmt+0x1eb>
                    putch(padc, putdat);
  102ff2:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  102ff6:	8b 55 0c             	mov    0xc(%ebp),%edx
  102ff9:	89 54 24 04          	mov    %edx,0x4(%esp)
  102ffd:	89 04 24             	mov    %eax,(%esp)
  103000:	8b 45 08             	mov    0x8(%ebp),%eax
  103003:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
  103005:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  103009:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10300d:	7f e3                	jg     102ff2 <vprintfmt+0x1d4>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  10300f:	eb 38                	jmp    103049 <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
  103011:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  103015:	74 1f                	je     103036 <vprintfmt+0x218>
  103017:	83 fb 1f             	cmp    $0x1f,%ebx
  10301a:	7e 05                	jle    103021 <vprintfmt+0x203>
  10301c:	83 fb 7e             	cmp    $0x7e,%ebx
  10301f:	7e 15                	jle    103036 <vprintfmt+0x218>
                    putch('?', putdat);
  103021:	8b 45 0c             	mov    0xc(%ebp),%eax
  103024:	89 44 24 04          	mov    %eax,0x4(%esp)
  103028:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  10302f:	8b 45 08             	mov    0x8(%ebp),%eax
  103032:	ff d0                	call   *%eax
  103034:	eb 0f                	jmp    103045 <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
  103036:	8b 45 0c             	mov    0xc(%ebp),%eax
  103039:	89 44 24 04          	mov    %eax,0x4(%esp)
  10303d:	89 1c 24             	mov    %ebx,(%esp)
  103040:	8b 45 08             	mov    0x8(%ebp),%eax
  103043:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  103045:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  103049:	89 f0                	mov    %esi,%eax
  10304b:	8d 70 01             	lea    0x1(%eax),%esi
  10304e:	0f b6 00             	movzbl (%eax),%eax
  103051:	0f be d8             	movsbl %al,%ebx
  103054:	85 db                	test   %ebx,%ebx
  103056:	74 10                	je     103068 <vprintfmt+0x24a>
  103058:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10305c:	78 b3                	js     103011 <vprintfmt+0x1f3>
  10305e:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  103062:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103066:	79 a9                	jns    103011 <vprintfmt+0x1f3>
                }
            }
            for (; width > 0; width --) {
  103068:	eb 17                	jmp    103081 <vprintfmt+0x263>
                putch(' ', putdat);
  10306a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10306d:	89 44 24 04          	mov    %eax,0x4(%esp)
  103071:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  103078:	8b 45 08             	mov    0x8(%ebp),%eax
  10307b:	ff d0                	call   *%eax
            for (; width > 0; width --) {
  10307d:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  103081:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103085:	7f e3                	jg     10306a <vprintfmt+0x24c>
            }
            break;
  103087:	e9 70 01 00 00       	jmp    1031fc <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  10308c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10308f:	89 44 24 04          	mov    %eax,0x4(%esp)
  103093:	8d 45 14             	lea    0x14(%ebp),%eax
  103096:	89 04 24             	mov    %eax,(%esp)
  103099:	e8 0b fd ff ff       	call   102da9 <getint>
  10309e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1030a1:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  1030a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1030a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1030aa:	85 d2                	test   %edx,%edx
  1030ac:	79 26                	jns    1030d4 <vprintfmt+0x2b6>
                putch('-', putdat);
  1030ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030b1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1030b5:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  1030bc:	8b 45 08             	mov    0x8(%ebp),%eax
  1030bf:	ff d0                	call   *%eax
                num = -(long long)num;
  1030c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1030c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1030c7:	f7 d8                	neg    %eax
  1030c9:	83 d2 00             	adc    $0x0,%edx
  1030cc:	f7 da                	neg    %edx
  1030ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1030d1:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  1030d4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1030db:	e9 a8 00 00 00       	jmp    103188 <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  1030e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1030e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1030e7:	8d 45 14             	lea    0x14(%ebp),%eax
  1030ea:	89 04 24             	mov    %eax,(%esp)
  1030ed:	e8 68 fc ff ff       	call   102d5a <getuint>
  1030f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1030f5:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  1030f8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1030ff:	e9 84 00 00 00       	jmp    103188 <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  103104:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103107:	89 44 24 04          	mov    %eax,0x4(%esp)
  10310b:	8d 45 14             	lea    0x14(%ebp),%eax
  10310e:	89 04 24             	mov    %eax,(%esp)
  103111:	e8 44 fc ff ff       	call   102d5a <getuint>
  103116:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103119:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  10311c:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  103123:	eb 63                	jmp    103188 <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
  103125:	8b 45 0c             	mov    0xc(%ebp),%eax
  103128:	89 44 24 04          	mov    %eax,0x4(%esp)
  10312c:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  103133:	8b 45 08             	mov    0x8(%ebp),%eax
  103136:	ff d0                	call   *%eax
            putch('x', putdat);
  103138:	8b 45 0c             	mov    0xc(%ebp),%eax
  10313b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10313f:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  103146:	8b 45 08             	mov    0x8(%ebp),%eax
  103149:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  10314b:	8b 45 14             	mov    0x14(%ebp),%eax
  10314e:	8d 50 04             	lea    0x4(%eax),%edx
  103151:	89 55 14             	mov    %edx,0x14(%ebp)
  103154:	8b 00                	mov    (%eax),%eax
  103156:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103159:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  103160:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  103167:	eb 1f                	jmp    103188 <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  103169:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10316c:	89 44 24 04          	mov    %eax,0x4(%esp)
  103170:	8d 45 14             	lea    0x14(%ebp),%eax
  103173:	89 04 24             	mov    %eax,(%esp)
  103176:	e8 df fb ff ff       	call   102d5a <getuint>
  10317b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10317e:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  103181:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  103188:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  10318c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10318f:	89 54 24 18          	mov    %edx,0x18(%esp)
  103193:	8b 55 e8             	mov    -0x18(%ebp),%edx
  103196:	89 54 24 14          	mov    %edx,0x14(%esp)
  10319a:	89 44 24 10          	mov    %eax,0x10(%esp)
  10319e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1031a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1031a4:	89 44 24 08          	mov    %eax,0x8(%esp)
  1031a8:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1031ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  1031af:	89 44 24 04          	mov    %eax,0x4(%esp)
  1031b3:	8b 45 08             	mov    0x8(%ebp),%eax
  1031b6:	89 04 24             	mov    %eax,(%esp)
  1031b9:	e8 97 fa ff ff       	call   102c55 <printnum>
            break;
  1031be:	eb 3c                	jmp    1031fc <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  1031c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1031c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1031c7:	89 1c 24             	mov    %ebx,(%esp)
  1031ca:	8b 45 08             	mov    0x8(%ebp),%eax
  1031cd:	ff d0                	call   *%eax
            break;
  1031cf:	eb 2b                	jmp    1031fc <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  1031d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1031d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1031d8:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  1031df:	8b 45 08             	mov    0x8(%ebp),%eax
  1031e2:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  1031e4:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  1031e8:	eb 04                	jmp    1031ee <vprintfmt+0x3d0>
  1031ea:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  1031ee:	8b 45 10             	mov    0x10(%ebp),%eax
  1031f1:	83 e8 01             	sub    $0x1,%eax
  1031f4:	0f b6 00             	movzbl (%eax),%eax
  1031f7:	3c 25                	cmp    $0x25,%al
  1031f9:	75 ef                	jne    1031ea <vprintfmt+0x3cc>
                /* do nothing */;
            break;
  1031fb:	90                   	nop
        }
    }
  1031fc:	90                   	nop
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1031fd:	e9 3e fc ff ff       	jmp    102e40 <vprintfmt+0x22>
}
  103202:	83 c4 40             	add    $0x40,%esp
  103205:	5b                   	pop    %ebx
  103206:	5e                   	pop    %esi
  103207:	5d                   	pop    %ebp
  103208:	c3                   	ret    

00103209 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:            the character will be printed
 * @b:            the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  103209:	55                   	push   %ebp
  10320a:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  10320c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10320f:	8b 40 08             	mov    0x8(%eax),%eax
  103212:	8d 50 01             	lea    0x1(%eax),%edx
  103215:	8b 45 0c             	mov    0xc(%ebp),%eax
  103218:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  10321b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10321e:	8b 10                	mov    (%eax),%edx
  103220:	8b 45 0c             	mov    0xc(%ebp),%eax
  103223:	8b 40 04             	mov    0x4(%eax),%eax
  103226:	39 c2                	cmp    %eax,%edx
  103228:	73 12                	jae    10323c <sprintputch+0x33>
        *b->buf ++ = ch;
  10322a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10322d:	8b 00                	mov    (%eax),%eax
  10322f:	8d 48 01             	lea    0x1(%eax),%ecx
  103232:	8b 55 0c             	mov    0xc(%ebp),%edx
  103235:	89 0a                	mov    %ecx,(%edx)
  103237:	8b 55 08             	mov    0x8(%ebp),%edx
  10323a:	88 10                	mov    %dl,(%eax)
    }
}
  10323c:	5d                   	pop    %ebp
  10323d:	c3                   	ret    

0010323e <snprintf>:
 * @str:        the buffer to place the result into
 * @size:        the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  10323e:	55                   	push   %ebp
  10323f:	89 e5                	mov    %esp,%ebp
  103241:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  103244:	8d 45 14             	lea    0x14(%ebp),%eax
  103247:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  10324a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10324d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103251:	8b 45 10             	mov    0x10(%ebp),%eax
  103254:	89 44 24 08          	mov    %eax,0x8(%esp)
  103258:	8b 45 0c             	mov    0xc(%ebp),%eax
  10325b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10325f:	8b 45 08             	mov    0x8(%ebp),%eax
  103262:	89 04 24             	mov    %eax,(%esp)
  103265:	e8 08 00 00 00       	call   103272 <vsnprintf>
  10326a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  10326d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103270:	c9                   	leave  
  103271:	c3                   	ret    

00103272 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  103272:	55                   	push   %ebp
  103273:	89 e5                	mov    %esp,%ebp
  103275:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  103278:	8b 45 08             	mov    0x8(%ebp),%eax
  10327b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10327e:	8b 45 0c             	mov    0xc(%ebp),%eax
  103281:	8d 50 ff             	lea    -0x1(%eax),%edx
  103284:	8b 45 08             	mov    0x8(%ebp),%eax
  103287:	01 d0                	add    %edx,%eax
  103289:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10328c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  103293:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  103297:	74 0a                	je     1032a3 <vsnprintf+0x31>
  103299:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10329c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10329f:	39 c2                	cmp    %eax,%edx
  1032a1:	76 07                	jbe    1032aa <vsnprintf+0x38>
        return -E_INVAL;
  1032a3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  1032a8:	eb 2a                	jmp    1032d4 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  1032aa:	8b 45 14             	mov    0x14(%ebp),%eax
  1032ad:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1032b1:	8b 45 10             	mov    0x10(%ebp),%eax
  1032b4:	89 44 24 08          	mov    %eax,0x8(%esp)
  1032b8:	8d 45 ec             	lea    -0x14(%ebp),%eax
  1032bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1032bf:	c7 04 24 09 32 10 00 	movl   $0x103209,(%esp)
  1032c6:	e8 53 fb ff ff       	call   102e1e <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  1032cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1032ce:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  1032d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1032d4:	c9                   	leave  
  1032d5:	c3                   	ret    
