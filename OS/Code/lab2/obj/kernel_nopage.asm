
bin/kernel_nopage:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_entry>:

.text
.globl kern_entry
kern_entry:
    # load pa of boot pgdir
    movl $REALLOC(__boot_pgdir), %eax
  100000:	b8 00 80 11 40       	mov    $0x40118000,%eax
    movl %eax, %cr3
  100005:	0f 22 d8             	mov    %eax,%cr3

    # enable paging
    movl %cr0, %eax
  100008:	0f 20 c0             	mov    %cr0,%eax
    orl $(CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP), %eax
  10000b:	0d 2f 00 05 80       	or     $0x8005002f,%eax
    andl $~(CR0_TS | CR0_EM), %eax
  100010:	83 e0 f3             	and    $0xfffffff3,%eax
    movl %eax, %cr0
  100013:	0f 22 c0             	mov    %eax,%cr0

    # update eip
    # now, eip = 0x1.....
    leal next, %eax
  100016:	8d 05 1e 00 10 00    	lea    0x10001e,%eax
    # set eip = KERNBASE + 0x1.....
    jmp *%eax
  10001c:	ff e0                	jmp    *%eax

0010001e <next>:
next:

    # unmap va 0 ~ 4M, it's temporary mapping
    xorl %eax, %eax
  10001e:	31 c0                	xor    %eax,%eax
    movl %eax, __boot_pgdir
  100020:	a3 00 80 11 00       	mov    %eax,0x118000

    # set ebp, esp
    movl $0x0, %ebp
  100025:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
  10002a:	bc 00 70 11 00       	mov    $0x117000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
  10002f:	e8 02 00 00 00       	call   100036 <kern_init>

00100034 <spin>:

# should never get here
spin:
    jmp spin
  100034:	eb fe                	jmp    100034 <spin>

00100036 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  100036:	55                   	push   %ebp
  100037:	89 e5                	mov    %esp,%ebp
  100039:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  10003c:	ba 88 af 11 00       	mov    $0x11af88,%edx
  100041:	b8 36 7a 11 00       	mov    $0x117a36,%eax
  100046:	29 c2                	sub    %eax,%edx
  100048:	89 d0                	mov    %edx,%eax
  10004a:	89 44 24 08          	mov    %eax,0x8(%esp)
  10004e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100055:	00 
  100056:	c7 04 24 36 7a 11 00 	movl   $0x117a36,(%esp)
  10005d:	e8 5e 58 00 00       	call   1058c0 <memset>

    cons_init();                // init the console
  100062:	e8 8d 15 00 00       	call   1015f4 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100067:	c7 45 f4 e0 60 10 00 	movl   $0x1060e0,-0xc(%ebp)
    cprintf("%s\n\n", message);
  10006e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100071:	89 44 24 04          	mov    %eax,0x4(%esp)
  100075:	c7 04 24 fc 60 10 00 	movl   $0x1060fc,(%esp)
  10007c:	e8 1c 02 00 00       	call   10029d <cprintf>

    print_kerninfo();
  100081:	e8 ce 08 00 00       	call   100954 <print_kerninfo>

    grade_backtrace();
  100086:	e8 86 00 00 00       	call   100111 <grade_backtrace>

    pmm_init();                 // init physical memory management
  10008b:	e8 3b 32 00 00       	call   1032cb <pmm_init>

    pic_init();                 // init interrupt controller
  100090:	e8 bc 16 00 00       	call   101751 <pic_init>
    idt_init();                 // init interrupt descriptor table
  100095:	e8 40 18 00 00       	call   1018da <idt_init>

    clock_init();               // init clock interrupt
  10009a:	e8 0b 0d 00 00       	call   100daa <clock_init>
    intr_enable();              // enable irq interrupt
  10009f:	e8 e8 17 00 00       	call   10188c <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
  1000a4:	eb fe                	jmp    1000a4 <kern_init+0x6e>

001000a6 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  1000a6:	55                   	push   %ebp
  1000a7:	89 e5                	mov    %esp,%ebp
  1000a9:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  1000ac:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1000b3:	00 
  1000b4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1000bb:	00 
  1000bc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000c3:	e8 d0 0c 00 00       	call   100d98 <mon_backtrace>
}
  1000c8:	c9                   	leave  
  1000c9:	c3                   	ret    

001000ca <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  1000ca:	55                   	push   %ebp
  1000cb:	89 e5                	mov    %esp,%ebp
  1000cd:	53                   	push   %ebx
  1000ce:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000d1:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  1000d4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  1000d7:	8d 55 08             	lea    0x8(%ebp),%edx
  1000da:	8b 45 08             	mov    0x8(%ebp),%eax
  1000dd:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1000e1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1000e5:	89 54 24 04          	mov    %edx,0x4(%esp)
  1000e9:	89 04 24             	mov    %eax,(%esp)
  1000ec:	e8 b5 ff ff ff       	call   1000a6 <grade_backtrace2>
}
  1000f1:	83 c4 14             	add    $0x14,%esp
  1000f4:	5b                   	pop    %ebx
  1000f5:	5d                   	pop    %ebp
  1000f6:	c3                   	ret    

001000f7 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000f7:	55                   	push   %ebp
  1000f8:	89 e5                	mov    %esp,%ebp
  1000fa:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000fd:	8b 45 10             	mov    0x10(%ebp),%eax
  100100:	89 44 24 04          	mov    %eax,0x4(%esp)
  100104:	8b 45 08             	mov    0x8(%ebp),%eax
  100107:	89 04 24             	mov    %eax,(%esp)
  10010a:	e8 bb ff ff ff       	call   1000ca <grade_backtrace1>
}
  10010f:	c9                   	leave  
  100110:	c3                   	ret    

00100111 <grade_backtrace>:

void
grade_backtrace(void) {
  100111:	55                   	push   %ebp
  100112:	89 e5                	mov    %esp,%ebp
  100114:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  100117:	b8 36 00 10 00       	mov    $0x100036,%eax
  10011c:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  100123:	ff 
  100124:	89 44 24 04          	mov    %eax,0x4(%esp)
  100128:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10012f:	e8 c3 ff ff ff       	call   1000f7 <grade_backtrace0>
}
  100134:	c9                   	leave  
  100135:	c3                   	ret    

00100136 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  100136:	55                   	push   %ebp
  100137:	89 e5                	mov    %esp,%ebp
  100139:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  10013c:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  10013f:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  100142:	8c 45 f2             	mov    %es,-0xe(%ebp)
  100145:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  100148:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10014c:	0f b7 c0             	movzwl %ax,%eax
  10014f:	83 e0 03             	and    $0x3,%eax
  100152:	89 c2                	mov    %eax,%edx
  100154:	a1 00 a0 11 00       	mov    0x11a000,%eax
  100159:	89 54 24 08          	mov    %edx,0x8(%esp)
  10015d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100161:	c7 04 24 01 61 10 00 	movl   $0x106101,(%esp)
  100168:	e8 30 01 00 00       	call   10029d <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  10016d:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100171:	0f b7 d0             	movzwl %ax,%edx
  100174:	a1 00 a0 11 00       	mov    0x11a000,%eax
  100179:	89 54 24 08          	mov    %edx,0x8(%esp)
  10017d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100181:	c7 04 24 0f 61 10 00 	movl   $0x10610f,(%esp)
  100188:	e8 10 01 00 00       	call   10029d <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  10018d:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100191:	0f b7 d0             	movzwl %ax,%edx
  100194:	a1 00 a0 11 00       	mov    0x11a000,%eax
  100199:	89 54 24 08          	mov    %edx,0x8(%esp)
  10019d:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001a1:	c7 04 24 1d 61 10 00 	movl   $0x10611d,(%esp)
  1001a8:	e8 f0 00 00 00       	call   10029d <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  1001ad:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  1001b1:	0f b7 d0             	movzwl %ax,%edx
  1001b4:	a1 00 a0 11 00       	mov    0x11a000,%eax
  1001b9:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001c1:	c7 04 24 2b 61 10 00 	movl   $0x10612b,(%esp)
  1001c8:	e8 d0 00 00 00       	call   10029d <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  1001cd:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001d1:	0f b7 d0             	movzwl %ax,%edx
  1001d4:	a1 00 a0 11 00       	mov    0x11a000,%eax
  1001d9:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001e1:	c7 04 24 39 61 10 00 	movl   $0x106139,(%esp)
  1001e8:	e8 b0 00 00 00       	call   10029d <cprintf>
    round ++;
  1001ed:	a1 00 a0 11 00       	mov    0x11a000,%eax
  1001f2:	83 c0 01             	add    $0x1,%eax
  1001f5:	a3 00 a0 11 00       	mov    %eax,0x11a000
}
  1001fa:	c9                   	leave  
  1001fb:	c3                   	ret    

001001fc <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001fc:	55                   	push   %ebp
  1001fd:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
	asm volatile (
  1001ff:	83 ec 08             	sub    $0x8,%esp
  100202:	cd 78                	int    $0x78
  100204:	89 ec                	mov    %ebp,%esp
		"int %0 \n"
		"movl %%ebp, %%esp \n"  // 此处的作用，是为了跟后面的汇编一起发挥leave作用
		:
		: "i"(T_SWITCH_TOU)
	);
}
  100206:	5d                   	pop    %ebp
  100207:	c3                   	ret    

00100208 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  100208:	55                   	push   %ebp
  100209:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
	asm volatile (
  10020b:	cd 79                	int    $0x79
  10020d:	89 ec                	mov    %ebp,%esp
		"movl %%ebp, %%esp \n"  // 此处的作用，是为了跟后面的汇编一起发挥leave作用
		:
		: "i"(T_SWITCH_TOK)
	);

}
  10020f:	5d                   	pop    %ebp
  100210:	c3                   	ret    

00100211 <lab1_switch_test>:

static void
lab1_switch_test(void) {
  100211:	55                   	push   %ebp
  100212:	89 e5                	mov    %esp,%ebp
  100214:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  100217:	e8 1a ff ff ff       	call   100136 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  10021c:	c7 04 24 48 61 10 00 	movl   $0x106148,(%esp)
  100223:	e8 75 00 00 00       	call   10029d <cprintf>
    lab1_switch_to_user();
  100228:	e8 cf ff ff ff       	call   1001fc <lab1_switch_to_user>
    lab1_print_cur_status();
  10022d:	e8 04 ff ff ff       	call   100136 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  100232:	c7 04 24 68 61 10 00 	movl   $0x106168,(%esp)
  100239:	e8 5f 00 00 00       	call   10029d <cprintf>
    lab1_switch_to_kernel();
  10023e:	e8 c5 ff ff ff       	call   100208 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100243:	e8 ee fe ff ff       	call   100136 <lab1_print_cur_status>
}
  100248:	c9                   	leave  
  100249:	c3                   	ret    

0010024a <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  10024a:	55                   	push   %ebp
  10024b:	89 e5                	mov    %esp,%ebp
  10024d:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  100250:	8b 45 08             	mov    0x8(%ebp),%eax
  100253:	89 04 24             	mov    %eax,(%esp)
  100256:	e8 c5 13 00 00       	call   101620 <cons_putc>
    (*cnt) ++;
  10025b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10025e:	8b 00                	mov    (%eax),%eax
  100260:	8d 50 01             	lea    0x1(%eax),%edx
  100263:	8b 45 0c             	mov    0xc(%ebp),%eax
  100266:	89 10                	mov    %edx,(%eax)
}
  100268:	c9                   	leave  
  100269:	c3                   	ret    

0010026a <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  10026a:	55                   	push   %ebp
  10026b:	89 e5                	mov    %esp,%ebp
  10026d:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  100270:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  100277:	8b 45 0c             	mov    0xc(%ebp),%eax
  10027a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10027e:	8b 45 08             	mov    0x8(%ebp),%eax
  100281:	89 44 24 08          	mov    %eax,0x8(%esp)
  100285:	8d 45 f4             	lea    -0xc(%ebp),%eax
  100288:	89 44 24 04          	mov    %eax,0x4(%esp)
  10028c:	c7 04 24 4a 02 10 00 	movl   $0x10024a,(%esp)
  100293:	e8 7a 59 00 00       	call   105c12 <vprintfmt>
    return cnt;
  100298:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10029b:	c9                   	leave  
  10029c:	c3                   	ret    

0010029d <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  10029d:	55                   	push   %ebp
  10029e:	89 e5                	mov    %esp,%ebp
  1002a0:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  1002a3:	8d 45 0c             	lea    0xc(%ebp),%eax
  1002a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  1002a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  1002b0:	8b 45 08             	mov    0x8(%ebp),%eax
  1002b3:	89 04 24             	mov    %eax,(%esp)
  1002b6:	e8 af ff ff ff       	call   10026a <vcprintf>
  1002bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  1002be:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1002c1:	c9                   	leave  
  1002c2:	c3                   	ret    

001002c3 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  1002c3:	55                   	push   %ebp
  1002c4:	89 e5                	mov    %esp,%ebp
  1002c6:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002c9:	8b 45 08             	mov    0x8(%ebp),%eax
  1002cc:	89 04 24             	mov    %eax,(%esp)
  1002cf:	e8 4c 13 00 00       	call   101620 <cons_putc>
}
  1002d4:	c9                   	leave  
  1002d5:	c3                   	ret    

001002d6 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  1002d6:	55                   	push   %ebp
  1002d7:	89 e5                	mov    %esp,%ebp
  1002d9:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  1002dc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  1002e3:	eb 13                	jmp    1002f8 <cputs+0x22>
        cputch(c, &cnt);
  1002e5:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  1002e9:	8d 55 f0             	lea    -0x10(%ebp),%edx
  1002ec:	89 54 24 04          	mov    %edx,0x4(%esp)
  1002f0:	89 04 24             	mov    %eax,(%esp)
  1002f3:	e8 52 ff ff ff       	call   10024a <cputch>
    while ((c = *str ++) != '\0') {
  1002f8:	8b 45 08             	mov    0x8(%ebp),%eax
  1002fb:	8d 50 01             	lea    0x1(%eax),%edx
  1002fe:	89 55 08             	mov    %edx,0x8(%ebp)
  100301:	0f b6 00             	movzbl (%eax),%eax
  100304:	88 45 f7             	mov    %al,-0x9(%ebp)
  100307:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  10030b:	75 d8                	jne    1002e5 <cputs+0xf>
    }
    cputch('\n', &cnt);
  10030d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  100310:	89 44 24 04          	mov    %eax,0x4(%esp)
  100314:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  10031b:	e8 2a ff ff ff       	call   10024a <cputch>
    return cnt;
  100320:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  100323:	c9                   	leave  
  100324:	c3                   	ret    

00100325 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  100325:	55                   	push   %ebp
  100326:	89 e5                	mov    %esp,%ebp
  100328:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  10032b:	e8 2c 13 00 00       	call   10165c <cons_getc>
  100330:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100333:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100337:	74 f2                	je     10032b <getchar+0x6>
        /* do nothing */;
    return c;
  100339:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10033c:	c9                   	leave  
  10033d:	c3                   	ret    

0010033e <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  10033e:	55                   	push   %ebp
  10033f:	89 e5                	mov    %esp,%ebp
  100341:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  100344:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100348:	74 13                	je     10035d <readline+0x1f>
        cprintf("%s", prompt);
  10034a:	8b 45 08             	mov    0x8(%ebp),%eax
  10034d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100351:	c7 04 24 87 61 10 00 	movl   $0x106187,(%esp)
  100358:	e8 40 ff ff ff       	call   10029d <cprintf>
    }
    int i = 0, c;
  10035d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100364:	e8 bc ff ff ff       	call   100325 <getchar>
  100369:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  10036c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100370:	79 07                	jns    100379 <readline+0x3b>
            return NULL;
  100372:	b8 00 00 00 00       	mov    $0x0,%eax
  100377:	eb 79                	jmp    1003f2 <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  100379:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  10037d:	7e 28                	jle    1003a7 <readline+0x69>
  10037f:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  100386:	7f 1f                	jg     1003a7 <readline+0x69>
            cputchar(c);
  100388:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10038b:	89 04 24             	mov    %eax,(%esp)
  10038e:	e8 30 ff ff ff       	call   1002c3 <cputchar>
            buf[i ++] = c;
  100393:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100396:	8d 50 01             	lea    0x1(%eax),%edx
  100399:	89 55 f4             	mov    %edx,-0xc(%ebp)
  10039c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10039f:	88 90 20 a0 11 00    	mov    %dl,0x11a020(%eax)
  1003a5:	eb 46                	jmp    1003ed <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
  1003a7:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  1003ab:	75 17                	jne    1003c4 <readline+0x86>
  1003ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003b1:	7e 11                	jle    1003c4 <readline+0x86>
            cputchar(c);
  1003b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003b6:	89 04 24             	mov    %eax,(%esp)
  1003b9:	e8 05 ff ff ff       	call   1002c3 <cputchar>
            i --;
  1003be:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  1003c2:	eb 29                	jmp    1003ed <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
  1003c4:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  1003c8:	74 06                	je     1003d0 <readline+0x92>
  1003ca:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1003ce:	75 1d                	jne    1003ed <readline+0xaf>
            cputchar(c);
  1003d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003d3:	89 04 24             	mov    %eax,(%esp)
  1003d6:	e8 e8 fe ff ff       	call   1002c3 <cputchar>
            buf[i] = '\0';
  1003db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1003de:	05 20 a0 11 00       	add    $0x11a020,%eax
  1003e3:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1003e6:	b8 20 a0 11 00       	mov    $0x11a020,%eax
  1003eb:	eb 05                	jmp    1003f2 <readline+0xb4>
        }
    }
  1003ed:	e9 72 ff ff ff       	jmp    100364 <readline+0x26>
}
  1003f2:	c9                   	leave  
  1003f3:	c3                   	ret    

001003f4 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  1003f4:	55                   	push   %ebp
  1003f5:	89 e5                	mov    %esp,%ebp
  1003f7:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  1003fa:	a1 20 a4 11 00       	mov    0x11a420,%eax
  1003ff:	85 c0                	test   %eax,%eax
  100401:	74 02                	je     100405 <__panic+0x11>
        goto panic_dead;
  100403:	eb 59                	jmp    10045e <__panic+0x6a>
    }
    is_panic = 1;
  100405:	c7 05 20 a4 11 00 01 	movl   $0x1,0x11a420
  10040c:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  10040f:	8d 45 14             	lea    0x14(%ebp),%eax
  100412:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100415:	8b 45 0c             	mov    0xc(%ebp),%eax
  100418:	89 44 24 08          	mov    %eax,0x8(%esp)
  10041c:	8b 45 08             	mov    0x8(%ebp),%eax
  10041f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100423:	c7 04 24 8a 61 10 00 	movl   $0x10618a,(%esp)
  10042a:	e8 6e fe ff ff       	call   10029d <cprintf>
    vcprintf(fmt, ap);
  10042f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100432:	89 44 24 04          	mov    %eax,0x4(%esp)
  100436:	8b 45 10             	mov    0x10(%ebp),%eax
  100439:	89 04 24             	mov    %eax,(%esp)
  10043c:	e8 29 fe ff ff       	call   10026a <vcprintf>
    cprintf("\n");
  100441:	c7 04 24 a6 61 10 00 	movl   $0x1061a6,(%esp)
  100448:	e8 50 fe ff ff       	call   10029d <cprintf>
    
    cprintf("stack trackback:\n");
  10044d:	c7 04 24 a8 61 10 00 	movl   $0x1061a8,(%esp)
  100454:	e8 44 fe ff ff       	call   10029d <cprintf>
    print_stackframe();
  100459:	e8 40 06 00 00       	call   100a9e <print_stackframe>
    
    va_end(ap);

panic_dead:
    intr_disable();
  10045e:	e8 2f 14 00 00       	call   101892 <intr_disable>
    while (1) {
        kmonitor(NULL);
  100463:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10046a:	e8 5a 08 00 00       	call   100cc9 <kmonitor>
    }
  10046f:	eb f2                	jmp    100463 <__panic+0x6f>

00100471 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100471:	55                   	push   %ebp
  100472:	89 e5                	mov    %esp,%ebp
  100474:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100477:	8d 45 14             	lea    0x14(%ebp),%eax
  10047a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  10047d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100480:	89 44 24 08          	mov    %eax,0x8(%esp)
  100484:	8b 45 08             	mov    0x8(%ebp),%eax
  100487:	89 44 24 04          	mov    %eax,0x4(%esp)
  10048b:	c7 04 24 ba 61 10 00 	movl   $0x1061ba,(%esp)
  100492:	e8 06 fe ff ff       	call   10029d <cprintf>
    vcprintf(fmt, ap);
  100497:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10049a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10049e:	8b 45 10             	mov    0x10(%ebp),%eax
  1004a1:	89 04 24             	mov    %eax,(%esp)
  1004a4:	e8 c1 fd ff ff       	call   10026a <vcprintf>
    cprintf("\n");
  1004a9:	c7 04 24 a6 61 10 00 	movl   $0x1061a6,(%esp)
  1004b0:	e8 e8 fd ff ff       	call   10029d <cprintf>
    va_end(ap);
}
  1004b5:	c9                   	leave  
  1004b6:	c3                   	ret    

001004b7 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  1004b7:	55                   	push   %ebp
  1004b8:	89 e5                	mov    %esp,%ebp
    return is_panic;
  1004ba:	a1 20 a4 11 00       	mov    0x11a420,%eax
}
  1004bf:	5d                   	pop    %ebp
  1004c0:	c3                   	ret    

001004c1 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1004c1:	55                   	push   %ebp
  1004c2:	89 e5                	mov    %esp,%ebp
  1004c4:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1004c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004ca:	8b 00                	mov    (%eax),%eax
  1004cc:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1004cf:	8b 45 10             	mov    0x10(%ebp),%eax
  1004d2:	8b 00                	mov    (%eax),%eax
  1004d4:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004d7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1004de:	e9 d2 00 00 00       	jmp    1005b5 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
  1004e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1004e6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1004e9:	01 d0                	add    %edx,%eax
  1004eb:	89 c2                	mov    %eax,%edx
  1004ed:	c1 ea 1f             	shr    $0x1f,%edx
  1004f0:	01 d0                	add    %edx,%eax
  1004f2:	d1 f8                	sar    %eax
  1004f4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1004f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1004fa:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1004fd:	eb 04                	jmp    100503 <stab_binsearch+0x42>
            m --;
  1004ff:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
  100503:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100506:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100509:	7c 1f                	jl     10052a <stab_binsearch+0x69>
  10050b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10050e:	89 d0                	mov    %edx,%eax
  100510:	01 c0                	add    %eax,%eax
  100512:	01 d0                	add    %edx,%eax
  100514:	c1 e0 02             	shl    $0x2,%eax
  100517:	89 c2                	mov    %eax,%edx
  100519:	8b 45 08             	mov    0x8(%ebp),%eax
  10051c:	01 d0                	add    %edx,%eax
  10051e:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100522:	0f b6 c0             	movzbl %al,%eax
  100525:	3b 45 14             	cmp    0x14(%ebp),%eax
  100528:	75 d5                	jne    1004ff <stab_binsearch+0x3e>
        }
        if (m < l) {    // no match in [l, m]
  10052a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10052d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100530:	7d 0b                	jge    10053d <stab_binsearch+0x7c>
            l = true_m + 1;
  100532:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100535:	83 c0 01             	add    $0x1,%eax
  100538:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  10053b:	eb 78                	jmp    1005b5 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
  10053d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100544:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100547:	89 d0                	mov    %edx,%eax
  100549:	01 c0                	add    %eax,%eax
  10054b:	01 d0                	add    %edx,%eax
  10054d:	c1 e0 02             	shl    $0x2,%eax
  100550:	89 c2                	mov    %eax,%edx
  100552:	8b 45 08             	mov    0x8(%ebp),%eax
  100555:	01 d0                	add    %edx,%eax
  100557:	8b 40 08             	mov    0x8(%eax),%eax
  10055a:	3b 45 18             	cmp    0x18(%ebp),%eax
  10055d:	73 13                	jae    100572 <stab_binsearch+0xb1>
            *region_left = m;
  10055f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100562:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100565:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100567:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10056a:	83 c0 01             	add    $0x1,%eax
  10056d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100570:	eb 43                	jmp    1005b5 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
  100572:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100575:	89 d0                	mov    %edx,%eax
  100577:	01 c0                	add    %eax,%eax
  100579:	01 d0                	add    %edx,%eax
  10057b:	c1 e0 02             	shl    $0x2,%eax
  10057e:	89 c2                	mov    %eax,%edx
  100580:	8b 45 08             	mov    0x8(%ebp),%eax
  100583:	01 d0                	add    %edx,%eax
  100585:	8b 40 08             	mov    0x8(%eax),%eax
  100588:	3b 45 18             	cmp    0x18(%ebp),%eax
  10058b:	76 16                	jbe    1005a3 <stab_binsearch+0xe2>
            *region_right = m - 1;
  10058d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100590:	8d 50 ff             	lea    -0x1(%eax),%edx
  100593:	8b 45 10             	mov    0x10(%ebp),%eax
  100596:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  100598:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10059b:	83 e8 01             	sub    $0x1,%eax
  10059e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1005a1:	eb 12                	jmp    1005b5 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  1005a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005a6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1005a9:	89 10                	mov    %edx,(%eax)
            l = m;
  1005ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1005ae:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1005b1:	83 45 18 01          	addl   $0x1,0x18(%ebp)
    while (l <= r) {
  1005b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1005b8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1005bb:	0f 8e 22 ff ff ff    	jle    1004e3 <stab_binsearch+0x22>
        }
    }

    if (!any_matches) {
  1005c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1005c5:	75 0f                	jne    1005d6 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
  1005c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005ca:	8b 00                	mov    (%eax),%eax
  1005cc:	8d 50 ff             	lea    -0x1(%eax),%edx
  1005cf:	8b 45 10             	mov    0x10(%ebp),%eax
  1005d2:	89 10                	mov    %edx,(%eax)
  1005d4:	eb 3f                	jmp    100615 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
  1005d6:	8b 45 10             	mov    0x10(%ebp),%eax
  1005d9:	8b 00                	mov    (%eax),%eax
  1005db:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1005de:	eb 04                	jmp    1005e4 <stab_binsearch+0x123>
  1005e0:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  1005e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005e7:	8b 00                	mov    (%eax),%eax
  1005e9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1005ec:	7d 1f                	jge    10060d <stab_binsearch+0x14c>
  1005ee:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1005f1:	89 d0                	mov    %edx,%eax
  1005f3:	01 c0                	add    %eax,%eax
  1005f5:	01 d0                	add    %edx,%eax
  1005f7:	c1 e0 02             	shl    $0x2,%eax
  1005fa:	89 c2                	mov    %eax,%edx
  1005fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1005ff:	01 d0                	add    %edx,%eax
  100601:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100605:	0f b6 c0             	movzbl %al,%eax
  100608:	3b 45 14             	cmp    0x14(%ebp),%eax
  10060b:	75 d3                	jne    1005e0 <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
  10060d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100610:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100613:	89 10                	mov    %edx,(%eax)
    }
}
  100615:	c9                   	leave  
  100616:	c3                   	ret    

00100617 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  100617:	55                   	push   %ebp
  100618:	89 e5                	mov    %esp,%ebp
  10061a:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  10061d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100620:	c7 00 d8 61 10 00    	movl   $0x1061d8,(%eax)
    info->eip_line = 0;
  100626:	8b 45 0c             	mov    0xc(%ebp),%eax
  100629:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  100630:	8b 45 0c             	mov    0xc(%ebp),%eax
  100633:	c7 40 08 d8 61 10 00 	movl   $0x1061d8,0x8(%eax)
    info->eip_fn_namelen = 9;
  10063a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10063d:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100644:	8b 45 0c             	mov    0xc(%ebp),%eax
  100647:	8b 55 08             	mov    0x8(%ebp),%edx
  10064a:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  10064d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100650:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100657:	c7 45 f4 20 74 10 00 	movl   $0x107420,-0xc(%ebp)
    stab_end = __STAB_END__;
  10065e:	c7 45 f0 88 20 11 00 	movl   $0x112088,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100665:	c7 45 ec 89 20 11 00 	movl   $0x112089,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  10066c:	c7 45 e8 f2 4a 11 00 	movl   $0x114af2,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  100673:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100676:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  100679:	76 0d                	jbe    100688 <debuginfo_eip+0x71>
  10067b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10067e:	83 e8 01             	sub    $0x1,%eax
  100681:	0f b6 00             	movzbl (%eax),%eax
  100684:	84 c0                	test   %al,%al
  100686:	74 0a                	je     100692 <debuginfo_eip+0x7b>
        return -1;
  100688:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10068d:	e9 c0 02 00 00       	jmp    100952 <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  100692:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  100699:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10069c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10069f:	29 c2                	sub    %eax,%edx
  1006a1:	89 d0                	mov    %edx,%eax
  1006a3:	c1 f8 02             	sar    $0x2,%eax
  1006a6:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  1006ac:	83 e8 01             	sub    $0x1,%eax
  1006af:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1006b2:	8b 45 08             	mov    0x8(%ebp),%eax
  1006b5:	89 44 24 10          	mov    %eax,0x10(%esp)
  1006b9:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1006c0:	00 
  1006c1:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1006c4:	89 44 24 08          	mov    %eax,0x8(%esp)
  1006c8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1006cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1006cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006d2:	89 04 24             	mov    %eax,(%esp)
  1006d5:	e8 e7 fd ff ff       	call   1004c1 <stab_binsearch>
    if (lfile == 0)
  1006da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006dd:	85 c0                	test   %eax,%eax
  1006df:	75 0a                	jne    1006eb <debuginfo_eip+0xd4>
        return -1;
  1006e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1006e6:	e9 67 02 00 00       	jmp    100952 <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  1006eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006ee:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1006f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006f4:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  1006f7:	8b 45 08             	mov    0x8(%ebp),%eax
  1006fa:	89 44 24 10          	mov    %eax,0x10(%esp)
  1006fe:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  100705:	00 
  100706:	8d 45 d8             	lea    -0x28(%ebp),%eax
  100709:	89 44 24 08          	mov    %eax,0x8(%esp)
  10070d:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100710:	89 44 24 04          	mov    %eax,0x4(%esp)
  100714:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100717:	89 04 24             	mov    %eax,(%esp)
  10071a:	e8 a2 fd ff ff       	call   1004c1 <stab_binsearch>

    if (lfun <= rfun) {
  10071f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100722:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100725:	39 c2                	cmp    %eax,%edx
  100727:	7f 7c                	jg     1007a5 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  100729:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10072c:	89 c2                	mov    %eax,%edx
  10072e:	89 d0                	mov    %edx,%eax
  100730:	01 c0                	add    %eax,%eax
  100732:	01 d0                	add    %edx,%eax
  100734:	c1 e0 02             	shl    $0x2,%eax
  100737:	89 c2                	mov    %eax,%edx
  100739:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10073c:	01 d0                	add    %edx,%eax
  10073e:	8b 10                	mov    (%eax),%edx
  100740:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  100743:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100746:	29 c1                	sub    %eax,%ecx
  100748:	89 c8                	mov    %ecx,%eax
  10074a:	39 c2                	cmp    %eax,%edx
  10074c:	73 22                	jae    100770 <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  10074e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100751:	89 c2                	mov    %eax,%edx
  100753:	89 d0                	mov    %edx,%eax
  100755:	01 c0                	add    %eax,%eax
  100757:	01 d0                	add    %edx,%eax
  100759:	c1 e0 02             	shl    $0x2,%eax
  10075c:	89 c2                	mov    %eax,%edx
  10075e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100761:	01 d0                	add    %edx,%eax
  100763:	8b 10                	mov    (%eax),%edx
  100765:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100768:	01 c2                	add    %eax,%edx
  10076a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10076d:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  100770:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100773:	89 c2                	mov    %eax,%edx
  100775:	89 d0                	mov    %edx,%eax
  100777:	01 c0                	add    %eax,%eax
  100779:	01 d0                	add    %edx,%eax
  10077b:	c1 e0 02             	shl    $0x2,%eax
  10077e:	89 c2                	mov    %eax,%edx
  100780:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100783:	01 d0                	add    %edx,%eax
  100785:	8b 50 08             	mov    0x8(%eax),%edx
  100788:	8b 45 0c             	mov    0xc(%ebp),%eax
  10078b:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  10078e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100791:	8b 40 10             	mov    0x10(%eax),%eax
  100794:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  100797:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10079a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  10079d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1007a0:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1007a3:	eb 15                	jmp    1007ba <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  1007a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007a8:	8b 55 08             	mov    0x8(%ebp),%edx
  1007ab:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1007ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007b1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1007b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1007b7:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1007ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007bd:	8b 40 08             	mov    0x8(%eax),%eax
  1007c0:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1007c7:	00 
  1007c8:	89 04 24             	mov    %eax,(%esp)
  1007cb:	e8 64 4f 00 00       	call   105734 <strfind>
  1007d0:	89 c2                	mov    %eax,%edx
  1007d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007d5:	8b 40 08             	mov    0x8(%eax),%eax
  1007d8:	29 c2                	sub    %eax,%edx
  1007da:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007dd:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1007e0:	8b 45 08             	mov    0x8(%ebp),%eax
  1007e3:	89 44 24 10          	mov    %eax,0x10(%esp)
  1007e7:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  1007ee:	00 
  1007ef:	8d 45 d0             	lea    -0x30(%ebp),%eax
  1007f2:	89 44 24 08          	mov    %eax,0x8(%esp)
  1007f6:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  1007f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1007fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100800:	89 04 24             	mov    %eax,(%esp)
  100803:	e8 b9 fc ff ff       	call   1004c1 <stab_binsearch>
    if (lline <= rline) {
  100808:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10080b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10080e:	39 c2                	cmp    %eax,%edx
  100810:	7f 24                	jg     100836 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
  100812:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100815:	89 c2                	mov    %eax,%edx
  100817:	89 d0                	mov    %edx,%eax
  100819:	01 c0                	add    %eax,%eax
  10081b:	01 d0                	add    %edx,%eax
  10081d:	c1 e0 02             	shl    $0x2,%eax
  100820:	89 c2                	mov    %eax,%edx
  100822:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100825:	01 d0                	add    %edx,%eax
  100827:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  10082b:	0f b7 d0             	movzwl %ax,%edx
  10082e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100831:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100834:	eb 13                	jmp    100849 <debuginfo_eip+0x232>
        return -1;
  100836:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10083b:	e9 12 01 00 00       	jmp    100952 <debuginfo_eip+0x33b>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  100840:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100843:	83 e8 01             	sub    $0x1,%eax
  100846:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
  100849:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10084c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10084f:	39 c2                	cmp    %eax,%edx
  100851:	7c 56                	jl     1008a9 <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
  100853:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100856:	89 c2                	mov    %eax,%edx
  100858:	89 d0                	mov    %edx,%eax
  10085a:	01 c0                	add    %eax,%eax
  10085c:	01 d0                	add    %edx,%eax
  10085e:	c1 e0 02             	shl    $0x2,%eax
  100861:	89 c2                	mov    %eax,%edx
  100863:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100866:	01 d0                	add    %edx,%eax
  100868:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10086c:	3c 84                	cmp    $0x84,%al
  10086e:	74 39                	je     1008a9 <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  100870:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100873:	89 c2                	mov    %eax,%edx
  100875:	89 d0                	mov    %edx,%eax
  100877:	01 c0                	add    %eax,%eax
  100879:	01 d0                	add    %edx,%eax
  10087b:	c1 e0 02             	shl    $0x2,%eax
  10087e:	89 c2                	mov    %eax,%edx
  100880:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100883:	01 d0                	add    %edx,%eax
  100885:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100889:	3c 64                	cmp    $0x64,%al
  10088b:	75 b3                	jne    100840 <debuginfo_eip+0x229>
  10088d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100890:	89 c2                	mov    %eax,%edx
  100892:	89 d0                	mov    %edx,%eax
  100894:	01 c0                	add    %eax,%eax
  100896:	01 d0                	add    %edx,%eax
  100898:	c1 e0 02             	shl    $0x2,%eax
  10089b:	89 c2                	mov    %eax,%edx
  10089d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008a0:	01 d0                	add    %edx,%eax
  1008a2:	8b 40 08             	mov    0x8(%eax),%eax
  1008a5:	85 c0                	test   %eax,%eax
  1008a7:	74 97                	je     100840 <debuginfo_eip+0x229>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  1008a9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1008ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1008af:	39 c2                	cmp    %eax,%edx
  1008b1:	7c 46                	jl     1008f9 <debuginfo_eip+0x2e2>
  1008b3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008b6:	89 c2                	mov    %eax,%edx
  1008b8:	89 d0                	mov    %edx,%eax
  1008ba:	01 c0                	add    %eax,%eax
  1008bc:	01 d0                	add    %edx,%eax
  1008be:	c1 e0 02             	shl    $0x2,%eax
  1008c1:	89 c2                	mov    %eax,%edx
  1008c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008c6:	01 d0                	add    %edx,%eax
  1008c8:	8b 10                	mov    (%eax),%edx
  1008ca:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1008cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1008d0:	29 c1                	sub    %eax,%ecx
  1008d2:	89 c8                	mov    %ecx,%eax
  1008d4:	39 c2                	cmp    %eax,%edx
  1008d6:	73 21                	jae    1008f9 <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1008d8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008db:	89 c2                	mov    %eax,%edx
  1008dd:	89 d0                	mov    %edx,%eax
  1008df:	01 c0                	add    %eax,%eax
  1008e1:	01 d0                	add    %edx,%eax
  1008e3:	c1 e0 02             	shl    $0x2,%eax
  1008e6:	89 c2                	mov    %eax,%edx
  1008e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008eb:	01 d0                	add    %edx,%eax
  1008ed:	8b 10                	mov    (%eax),%edx
  1008ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1008f2:	01 c2                	add    %eax,%edx
  1008f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008f7:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  1008f9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1008fc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1008ff:	39 c2                	cmp    %eax,%edx
  100901:	7d 4a                	jge    10094d <debuginfo_eip+0x336>
        for (lline = lfun + 1;
  100903:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100906:	83 c0 01             	add    $0x1,%eax
  100909:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  10090c:	eb 18                	jmp    100926 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  10090e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100911:	8b 40 14             	mov    0x14(%eax),%eax
  100914:	8d 50 01             	lea    0x1(%eax),%edx
  100917:	8b 45 0c             	mov    0xc(%ebp),%eax
  10091a:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
  10091d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100920:	83 c0 01             	add    $0x1,%eax
  100923:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100926:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100929:	8b 45 d8             	mov    -0x28(%ebp),%eax
        for (lline = lfun + 1;
  10092c:	39 c2                	cmp    %eax,%edx
  10092e:	7d 1d                	jge    10094d <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100930:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100933:	89 c2                	mov    %eax,%edx
  100935:	89 d0                	mov    %edx,%eax
  100937:	01 c0                	add    %eax,%eax
  100939:	01 d0                	add    %edx,%eax
  10093b:	c1 e0 02             	shl    $0x2,%eax
  10093e:	89 c2                	mov    %eax,%edx
  100940:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100943:	01 d0                	add    %edx,%eax
  100945:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100949:	3c a0                	cmp    $0xa0,%al
  10094b:	74 c1                	je     10090e <debuginfo_eip+0x2f7>
        }
    }
    return 0;
  10094d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100952:	c9                   	leave  
  100953:	c3                   	ret    

00100954 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100954:	55                   	push   %ebp
  100955:	89 e5                	mov    %esp,%ebp
  100957:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  10095a:	c7 04 24 e2 61 10 00 	movl   $0x1061e2,(%esp)
  100961:	e8 37 f9 ff ff       	call   10029d <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100966:	c7 44 24 04 36 00 10 	movl   $0x100036,0x4(%esp)
  10096d:	00 
  10096e:	c7 04 24 fb 61 10 00 	movl   $0x1061fb,(%esp)
  100975:	e8 23 f9 ff ff       	call   10029d <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  10097a:	c7 44 24 04 ca 60 10 	movl   $0x1060ca,0x4(%esp)
  100981:	00 
  100982:	c7 04 24 13 62 10 00 	movl   $0x106213,(%esp)
  100989:	e8 0f f9 ff ff       	call   10029d <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  10098e:	c7 44 24 04 36 7a 11 	movl   $0x117a36,0x4(%esp)
  100995:	00 
  100996:	c7 04 24 2b 62 10 00 	movl   $0x10622b,(%esp)
  10099d:	e8 fb f8 ff ff       	call   10029d <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  1009a2:	c7 44 24 04 88 af 11 	movl   $0x11af88,0x4(%esp)
  1009a9:	00 
  1009aa:	c7 04 24 43 62 10 00 	movl   $0x106243,(%esp)
  1009b1:	e8 e7 f8 ff ff       	call   10029d <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1009b6:	b8 88 af 11 00       	mov    $0x11af88,%eax
  1009bb:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1009c1:	b8 36 00 10 00       	mov    $0x100036,%eax
  1009c6:	29 c2                	sub    %eax,%edx
  1009c8:	89 d0                	mov    %edx,%eax
  1009ca:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1009d0:	85 c0                	test   %eax,%eax
  1009d2:	0f 48 c2             	cmovs  %edx,%eax
  1009d5:	c1 f8 0a             	sar    $0xa,%eax
  1009d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009dc:	c7 04 24 5c 62 10 00 	movl   $0x10625c,(%esp)
  1009e3:	e8 b5 f8 ff ff       	call   10029d <cprintf>
}
  1009e8:	c9                   	leave  
  1009e9:	c3                   	ret    

001009ea <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  1009ea:	55                   	push   %ebp
  1009eb:	89 e5                	mov    %esp,%ebp
  1009ed:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  1009f3:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1009f6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009fa:	8b 45 08             	mov    0x8(%ebp),%eax
  1009fd:	89 04 24             	mov    %eax,(%esp)
  100a00:	e8 12 fc ff ff       	call   100617 <debuginfo_eip>
  100a05:	85 c0                	test   %eax,%eax
  100a07:	74 15                	je     100a1e <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  100a09:	8b 45 08             	mov    0x8(%ebp),%eax
  100a0c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a10:	c7 04 24 86 62 10 00 	movl   $0x106286,(%esp)
  100a17:	e8 81 f8 ff ff       	call   10029d <cprintf>
  100a1c:	eb 6d                	jmp    100a8b <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100a1e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100a25:	eb 1c                	jmp    100a43 <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
  100a27:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  100a2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a2d:	01 d0                	add    %edx,%eax
  100a2f:	0f b6 00             	movzbl (%eax),%eax
  100a32:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100a38:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100a3b:	01 ca                	add    %ecx,%edx
  100a3d:	88 02                	mov    %al,(%edx)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100a3f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100a43:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a46:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  100a49:	7f dc                	jg     100a27 <print_debuginfo+0x3d>
        }
        fnname[j] = '\0';
  100a4b:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  100a51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a54:	01 d0                	add    %edx,%eax
  100a56:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
  100a59:	8b 45 ec             	mov    -0x14(%ebp),%eax
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100a5c:	8b 55 08             	mov    0x8(%ebp),%edx
  100a5f:	89 d1                	mov    %edx,%ecx
  100a61:	29 c1                	sub    %eax,%ecx
  100a63:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100a66:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100a69:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  100a6d:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100a73:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100a77:	89 54 24 08          	mov    %edx,0x8(%esp)
  100a7b:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a7f:	c7 04 24 a2 62 10 00 	movl   $0x1062a2,(%esp)
  100a86:	e8 12 f8 ff ff       	call   10029d <cprintf>
    }
}
  100a8b:	c9                   	leave  
  100a8c:	c3                   	ret    

00100a8d <read_eip>:

static __noinline uint32_t
read_eip(void) {
  100a8d:	55                   	push   %ebp
  100a8e:	89 e5                	mov    %esp,%ebp
  100a90:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100a93:	8b 45 04             	mov    0x4(%ebp),%eax
  100a96:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  100a99:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  100a9c:	c9                   	leave  
  100a9d:	c3                   	ret    

00100a9e <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100a9e:	55                   	push   %ebp
  100a9f:	89 e5                	mov    %esp,%ebp
  100aa1:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100aa4:	89 e8                	mov    %ebp,%eax
  100aa6:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
  100aa9:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */

	uint32_t ebp_v = read_ebp(), eip_v = read_eip();
  100aac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100aaf:	e8 d9 ff ff ff       	call   100a8d <read_eip>
  100ab4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32_t i, j;
	for (i = 0; ebp_v != 0 && i< STACKFRAME_DEPTH; i ++)
  100ab7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  100abe:	e9 88 00 00 00       	jmp    100b4b <print_stackframe+0xad>
	{
		cprintf("ebp:0x%08x eip:0x%08x args:", ebp_v, eip_v);
  100ac3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100ac6:	89 44 24 08          	mov    %eax,0x8(%esp)
  100aca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100acd:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ad1:	c7 04 24 b4 62 10 00 	movl   $0x1062b4,(%esp)
  100ad8:	e8 c0 f7 ff ff       	call   10029d <cprintf>
		uint32_t *args = (uint32_t *)ebp_v + 0x2;
  100add:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ae0:	83 c0 08             	add    $0x8,%eax
  100ae3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		for (j = 0; j < 4; j ++)
  100ae6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  100aed:	eb 25                	jmp    100b14 <print_stackframe+0x76>
		{
			cprintf(" 0x%08x ", args[j]);
  100aef:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100af2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100af9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100afc:	01 d0                	add    %edx,%eax
  100afe:	8b 00                	mov    (%eax),%eax
  100b00:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b04:	c7 04 24 d0 62 10 00 	movl   $0x1062d0,(%esp)
  100b0b:	e8 8d f7 ff ff       	call   10029d <cprintf>
		for (j = 0; j < 4; j ++)
  100b10:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
  100b14:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100b18:	76 d5                	jbe    100aef <print_stackframe+0x51>
		}
		cprintf("\n");
  100b1a:	c7 04 24 d9 62 10 00 	movl   $0x1062d9,(%esp)
  100b21:	e8 77 f7 ff ff       	call   10029d <cprintf>
		print_debuginfo(eip_v-0x1);
  100b26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100b29:	83 e8 01             	sub    $0x1,%eax
  100b2c:	89 04 24             	mov    %eax,(%esp)
  100b2f:	e8 b6 fe ff ff       	call   1009ea <print_debuginfo>
		eip_v = ((uint32_t*)ebp_v)[1];
  100b34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b37:	83 c0 04             	add    $0x4,%eax
  100b3a:	8b 00                	mov    (%eax),%eax
  100b3c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		ebp_v = ((uint32_t*)ebp_v)[0];
  100b3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b42:	8b 00                	mov    (%eax),%eax
  100b44:	89 45 f4             	mov    %eax,-0xc(%ebp)
	for (i = 0; ebp_v != 0 && i< STACKFRAME_DEPTH; i ++)
  100b47:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100b4b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100b4f:	74 0a                	je     100b5b <print_stackframe+0xbd>
  100b51:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100b55:	0f 86 68 ff ff ff    	jbe    100ac3 <print_stackframe+0x25>
	}

}
  100b5b:	c9                   	leave  
  100b5c:	c3                   	ret    

00100b5d <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100b5d:	55                   	push   %ebp
  100b5e:	89 e5                	mov    %esp,%ebp
  100b60:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100b63:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b6a:	eb 0c                	jmp    100b78 <parse+0x1b>
            *buf ++ = '\0';
  100b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  100b6f:	8d 50 01             	lea    0x1(%eax),%edx
  100b72:	89 55 08             	mov    %edx,0x8(%ebp)
  100b75:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b78:	8b 45 08             	mov    0x8(%ebp),%eax
  100b7b:	0f b6 00             	movzbl (%eax),%eax
  100b7e:	84 c0                	test   %al,%al
  100b80:	74 1d                	je     100b9f <parse+0x42>
  100b82:	8b 45 08             	mov    0x8(%ebp),%eax
  100b85:	0f b6 00             	movzbl (%eax),%eax
  100b88:	0f be c0             	movsbl %al,%eax
  100b8b:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b8f:	c7 04 24 5c 63 10 00 	movl   $0x10635c,(%esp)
  100b96:	e8 66 4b 00 00       	call   105701 <strchr>
  100b9b:	85 c0                	test   %eax,%eax
  100b9d:	75 cd                	jne    100b6c <parse+0xf>
        }
        if (*buf == '\0') {
  100b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  100ba2:	0f b6 00             	movzbl (%eax),%eax
  100ba5:	84 c0                	test   %al,%al
  100ba7:	75 02                	jne    100bab <parse+0x4e>
            break;
  100ba9:	eb 67                	jmp    100c12 <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100bab:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100baf:	75 14                	jne    100bc5 <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100bb1:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100bb8:	00 
  100bb9:	c7 04 24 61 63 10 00 	movl   $0x106361,(%esp)
  100bc0:	e8 d8 f6 ff ff       	call   10029d <cprintf>
        }
        argv[argc ++] = buf;
  100bc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100bc8:	8d 50 01             	lea    0x1(%eax),%edx
  100bcb:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100bce:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100bd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  100bd8:	01 c2                	add    %eax,%edx
  100bda:	8b 45 08             	mov    0x8(%ebp),%eax
  100bdd:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100bdf:	eb 04                	jmp    100be5 <parse+0x88>
            buf ++;
  100be1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100be5:	8b 45 08             	mov    0x8(%ebp),%eax
  100be8:	0f b6 00             	movzbl (%eax),%eax
  100beb:	84 c0                	test   %al,%al
  100bed:	74 1d                	je     100c0c <parse+0xaf>
  100bef:	8b 45 08             	mov    0x8(%ebp),%eax
  100bf2:	0f b6 00             	movzbl (%eax),%eax
  100bf5:	0f be c0             	movsbl %al,%eax
  100bf8:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bfc:	c7 04 24 5c 63 10 00 	movl   $0x10635c,(%esp)
  100c03:	e8 f9 4a 00 00       	call   105701 <strchr>
  100c08:	85 c0                	test   %eax,%eax
  100c0a:	74 d5                	je     100be1 <parse+0x84>
        }
    }
  100c0c:	90                   	nop
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100c0d:	e9 66 ff ff ff       	jmp    100b78 <parse+0x1b>
    return argc;
  100c12:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100c15:	c9                   	leave  
  100c16:	c3                   	ret    

00100c17 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100c17:	55                   	push   %ebp
  100c18:	89 e5                	mov    %esp,%ebp
  100c1a:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100c1d:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100c20:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c24:	8b 45 08             	mov    0x8(%ebp),%eax
  100c27:	89 04 24             	mov    %eax,(%esp)
  100c2a:	e8 2e ff ff ff       	call   100b5d <parse>
  100c2f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100c32:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100c36:	75 0a                	jne    100c42 <runcmd+0x2b>
        return 0;
  100c38:	b8 00 00 00 00       	mov    $0x0,%eax
  100c3d:	e9 85 00 00 00       	jmp    100cc7 <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c42:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c49:	eb 5c                	jmp    100ca7 <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100c4b:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100c4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c51:	89 d0                	mov    %edx,%eax
  100c53:	01 c0                	add    %eax,%eax
  100c55:	01 d0                	add    %edx,%eax
  100c57:	c1 e0 02             	shl    $0x2,%eax
  100c5a:	05 00 70 11 00       	add    $0x117000,%eax
  100c5f:	8b 00                	mov    (%eax),%eax
  100c61:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100c65:	89 04 24             	mov    %eax,(%esp)
  100c68:	e8 f5 49 00 00       	call   105662 <strcmp>
  100c6d:	85 c0                	test   %eax,%eax
  100c6f:	75 32                	jne    100ca3 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100c71:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c74:	89 d0                	mov    %edx,%eax
  100c76:	01 c0                	add    %eax,%eax
  100c78:	01 d0                	add    %edx,%eax
  100c7a:	c1 e0 02             	shl    $0x2,%eax
  100c7d:	05 00 70 11 00       	add    $0x117000,%eax
  100c82:	8b 40 08             	mov    0x8(%eax),%eax
  100c85:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100c88:	8d 4a ff             	lea    -0x1(%edx),%ecx
  100c8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  100c8e:	89 54 24 08          	mov    %edx,0x8(%esp)
  100c92:	8d 55 b0             	lea    -0x50(%ebp),%edx
  100c95:	83 c2 04             	add    $0x4,%edx
  100c98:	89 54 24 04          	mov    %edx,0x4(%esp)
  100c9c:	89 0c 24             	mov    %ecx,(%esp)
  100c9f:	ff d0                	call   *%eax
  100ca1:	eb 24                	jmp    100cc7 <runcmd+0xb0>
    for (i = 0; i < NCOMMANDS; i ++) {
  100ca3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100ca7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100caa:	83 f8 02             	cmp    $0x2,%eax
  100cad:	76 9c                	jbe    100c4b <runcmd+0x34>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100caf:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100cb2:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cb6:	c7 04 24 7f 63 10 00 	movl   $0x10637f,(%esp)
  100cbd:	e8 db f5 ff ff       	call   10029d <cprintf>
    return 0;
  100cc2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cc7:	c9                   	leave  
  100cc8:	c3                   	ret    

00100cc9 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100cc9:	55                   	push   %ebp
  100cca:	89 e5                	mov    %esp,%ebp
  100ccc:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100ccf:	c7 04 24 98 63 10 00 	movl   $0x106398,(%esp)
  100cd6:	e8 c2 f5 ff ff       	call   10029d <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100cdb:	c7 04 24 c0 63 10 00 	movl   $0x1063c0,(%esp)
  100ce2:	e8 b6 f5 ff ff       	call   10029d <cprintf>

    if (tf != NULL) {
  100ce7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100ceb:	74 0b                	je     100cf8 <kmonitor+0x2f>
        print_trapframe(tf);
  100ced:	8b 45 08             	mov    0x8(%ebp),%eax
  100cf0:	89 04 24             	mov    %eax,(%esp)
  100cf3:	e8 99 0d 00 00       	call   101a91 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100cf8:	c7 04 24 e5 63 10 00 	movl   $0x1063e5,(%esp)
  100cff:	e8 3a f6 ff ff       	call   10033e <readline>
  100d04:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100d07:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100d0b:	74 18                	je     100d25 <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
  100d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  100d10:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d17:	89 04 24             	mov    %eax,(%esp)
  100d1a:	e8 f8 fe ff ff       	call   100c17 <runcmd>
  100d1f:	85 c0                	test   %eax,%eax
  100d21:	79 02                	jns    100d25 <kmonitor+0x5c>
                break;
  100d23:	eb 02                	jmp    100d27 <kmonitor+0x5e>
            }
        }
    }
  100d25:	eb d1                	jmp    100cf8 <kmonitor+0x2f>
}
  100d27:	c9                   	leave  
  100d28:	c3                   	ret    

00100d29 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100d29:	55                   	push   %ebp
  100d2a:	89 e5                	mov    %esp,%ebp
  100d2c:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100d2f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100d36:	eb 3f                	jmp    100d77 <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100d38:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100d3b:	89 d0                	mov    %edx,%eax
  100d3d:	01 c0                	add    %eax,%eax
  100d3f:	01 d0                	add    %edx,%eax
  100d41:	c1 e0 02             	shl    $0x2,%eax
  100d44:	05 00 70 11 00       	add    $0x117000,%eax
  100d49:	8b 48 04             	mov    0x4(%eax),%ecx
  100d4c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100d4f:	89 d0                	mov    %edx,%eax
  100d51:	01 c0                	add    %eax,%eax
  100d53:	01 d0                	add    %edx,%eax
  100d55:	c1 e0 02             	shl    $0x2,%eax
  100d58:	05 00 70 11 00       	add    $0x117000,%eax
  100d5d:	8b 00                	mov    (%eax),%eax
  100d5f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100d63:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d67:	c7 04 24 e9 63 10 00 	movl   $0x1063e9,(%esp)
  100d6e:	e8 2a f5 ff ff       	call   10029d <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
  100d73:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100d77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d7a:	83 f8 02             	cmp    $0x2,%eax
  100d7d:	76 b9                	jbe    100d38 <mon_help+0xf>
    }
    return 0;
  100d7f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d84:	c9                   	leave  
  100d85:	c3                   	ret    

00100d86 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100d86:	55                   	push   %ebp
  100d87:	89 e5                	mov    %esp,%ebp
  100d89:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100d8c:	e8 c3 fb ff ff       	call   100954 <print_kerninfo>
    return 0;
  100d91:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d96:	c9                   	leave  
  100d97:	c3                   	ret    

00100d98 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100d98:	55                   	push   %ebp
  100d99:	89 e5                	mov    %esp,%ebp
  100d9b:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100d9e:	e8 fb fc ff ff       	call   100a9e <print_stackframe>
    return 0;
  100da3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100da8:	c9                   	leave  
  100da9:	c3                   	ret    

00100daa <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100daa:	55                   	push   %ebp
  100dab:	89 e5                	mov    %esp,%ebp
  100dad:	83 ec 28             	sub    $0x28,%esp
  100db0:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100db6:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100dba:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100dbe:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100dc2:	ee                   	out    %al,(%dx)
  100dc3:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100dc9:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100dcd:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100dd1:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100dd5:	ee                   	out    %al,(%dx)
  100dd6:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
  100ddc:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
  100de0:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100de4:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100de8:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100de9:	c7 05 0c af 11 00 00 	movl   $0x0,0x11af0c
  100df0:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100df3:	c7 04 24 f2 63 10 00 	movl   $0x1063f2,(%esp)
  100dfa:	e8 9e f4 ff ff       	call   10029d <cprintf>
    pic_enable(IRQ_TIMER);
  100dff:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100e06:	e8 18 09 00 00       	call   101723 <pic_enable>
}
  100e0b:	c9                   	leave  
  100e0c:	c3                   	ret    

00100e0d <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  100e0d:	55                   	push   %ebp
  100e0e:	89 e5                	mov    %esp,%ebp
  100e10:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  100e13:	9c                   	pushf  
  100e14:	58                   	pop    %eax
  100e15:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  100e18:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  100e1b:	25 00 02 00 00       	and    $0x200,%eax
  100e20:	85 c0                	test   %eax,%eax
  100e22:	74 0c                	je     100e30 <__intr_save+0x23>
        intr_disable();
  100e24:	e8 69 0a 00 00       	call   101892 <intr_disable>
        return 1;
  100e29:	b8 01 00 00 00       	mov    $0x1,%eax
  100e2e:	eb 05                	jmp    100e35 <__intr_save+0x28>
    }
    return 0;
  100e30:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100e35:	c9                   	leave  
  100e36:	c3                   	ret    

00100e37 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  100e37:	55                   	push   %ebp
  100e38:	89 e5                	mov    %esp,%ebp
  100e3a:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  100e3d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100e41:	74 05                	je     100e48 <__intr_restore+0x11>
        intr_enable();
  100e43:	e8 44 0a 00 00       	call   10188c <intr_enable>
    }
}
  100e48:	c9                   	leave  
  100e49:	c3                   	ret    

00100e4a <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100e4a:	55                   	push   %ebp
  100e4b:	89 e5                	mov    %esp,%ebp
  100e4d:	83 ec 10             	sub    $0x10,%esp
  100e50:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100e56:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100e5a:	89 c2                	mov    %eax,%edx
  100e5c:	ec                   	in     (%dx),%al
  100e5d:	88 45 fd             	mov    %al,-0x3(%ebp)
  100e60:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100e66:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100e6a:	89 c2                	mov    %eax,%edx
  100e6c:	ec                   	in     (%dx),%al
  100e6d:	88 45 f9             	mov    %al,-0x7(%ebp)
  100e70:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100e76:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100e7a:	89 c2                	mov    %eax,%edx
  100e7c:	ec                   	in     (%dx),%al
  100e7d:	88 45 f5             	mov    %al,-0xb(%ebp)
  100e80:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
  100e86:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e8a:	89 c2                	mov    %eax,%edx
  100e8c:	ec                   	in     (%dx),%al
  100e8d:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e90:	c9                   	leave  
  100e91:	c3                   	ret    

00100e92 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100e92:	55                   	push   %ebp
  100e93:	89 e5                	mov    %esp,%ebp
  100e95:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
  100e98:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
  100e9f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ea2:	0f b7 00             	movzwl (%eax),%eax
  100ea5:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  100ea9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100eac:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100eb1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100eb4:	0f b7 00             	movzwl (%eax),%eax
  100eb7:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100ebb:	74 12                	je     100ecf <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
  100ebd:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  100ec4:	66 c7 05 46 a4 11 00 	movw   $0x3b4,0x11a446
  100ecb:	b4 03 
  100ecd:	eb 13                	jmp    100ee2 <cga_init+0x50>
    } else {
        *cp = was;
  100ecf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ed2:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100ed6:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100ed9:	66 c7 05 46 a4 11 00 	movw   $0x3d4,0x11a446
  100ee0:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100ee2:	0f b7 05 46 a4 11 00 	movzwl 0x11a446,%eax
  100ee9:	0f b7 c0             	movzwl %ax,%eax
  100eec:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  100ef0:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100ef4:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100ef8:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100efc:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
  100efd:	0f b7 05 46 a4 11 00 	movzwl 0x11a446,%eax
  100f04:	83 c0 01             	add    $0x1,%eax
  100f07:	0f b7 c0             	movzwl %ax,%eax
  100f0a:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100f0e:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100f12:	89 c2                	mov    %eax,%edx
  100f14:	ec                   	in     (%dx),%al
  100f15:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100f18:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f1c:	0f b6 c0             	movzbl %al,%eax
  100f1f:	c1 e0 08             	shl    $0x8,%eax
  100f22:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100f25:	0f b7 05 46 a4 11 00 	movzwl 0x11a446,%eax
  100f2c:	0f b7 c0             	movzwl %ax,%eax
  100f2f:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  100f33:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f37:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f3b:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f3f:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
  100f40:	0f b7 05 46 a4 11 00 	movzwl 0x11a446,%eax
  100f47:	83 c0 01             	add    $0x1,%eax
  100f4a:	0f b7 c0             	movzwl %ax,%eax
  100f4d:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100f51:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  100f55:	89 c2                	mov    %eax,%edx
  100f57:	ec                   	in     (%dx),%al
  100f58:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
  100f5b:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f5f:	0f b6 c0             	movzbl %al,%eax
  100f62:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100f65:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f68:	a3 40 a4 11 00       	mov    %eax,0x11a440
    crt_pos = pos;
  100f6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100f70:	66 a3 44 a4 11 00    	mov    %ax,0x11a444
}
  100f76:	c9                   	leave  
  100f77:	c3                   	ret    

00100f78 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100f78:	55                   	push   %ebp
  100f79:	89 e5                	mov    %esp,%ebp
  100f7b:	83 ec 48             	sub    $0x48,%esp
  100f7e:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100f84:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f88:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100f8c:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100f90:	ee                   	out    %al,(%dx)
  100f91:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
  100f97:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
  100f9b:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f9f:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100fa3:	ee                   	out    %al,(%dx)
  100fa4:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
  100faa:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
  100fae:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100fb2:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100fb6:	ee                   	out    %al,(%dx)
  100fb7:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100fbd:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
  100fc1:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100fc5:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100fc9:	ee                   	out    %al,(%dx)
  100fca:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
  100fd0:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
  100fd4:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100fd8:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100fdc:	ee                   	out    %al,(%dx)
  100fdd:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
  100fe3:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
  100fe7:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100feb:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100fef:	ee                   	out    %al,(%dx)
  100ff0:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100ff6:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
  100ffa:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100ffe:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  101002:	ee                   	out    %al,(%dx)
  101003:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101009:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
  10100d:	89 c2                	mov    %eax,%edx
  10100f:	ec                   	in     (%dx),%al
  101010:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
  101013:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  101017:	3c ff                	cmp    $0xff,%al
  101019:	0f 95 c0             	setne  %al
  10101c:	0f b6 c0             	movzbl %al,%eax
  10101f:	a3 48 a4 11 00       	mov    %eax,0x11a448
  101024:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10102a:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
  10102e:	89 c2                	mov    %eax,%edx
  101030:	ec                   	in     (%dx),%al
  101031:	88 45 d5             	mov    %al,-0x2b(%ebp)
  101034:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
  10103a:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
  10103e:	89 c2                	mov    %eax,%edx
  101040:	ec                   	in     (%dx),%al
  101041:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  101044:	a1 48 a4 11 00       	mov    0x11a448,%eax
  101049:	85 c0                	test   %eax,%eax
  10104b:	74 0c                	je     101059 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
  10104d:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  101054:	e8 ca 06 00 00       	call   101723 <pic_enable>
    }
}
  101059:	c9                   	leave  
  10105a:	c3                   	ret    

0010105b <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  10105b:	55                   	push   %ebp
  10105c:	89 e5                	mov    %esp,%ebp
  10105e:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101061:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101068:	eb 09                	jmp    101073 <lpt_putc_sub+0x18>
        delay();
  10106a:	e8 db fd ff ff       	call   100e4a <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  10106f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101073:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  101079:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10107d:	89 c2                	mov    %eax,%edx
  10107f:	ec                   	in     (%dx),%al
  101080:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101083:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101087:	84 c0                	test   %al,%al
  101089:	78 09                	js     101094 <lpt_putc_sub+0x39>
  10108b:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101092:	7e d6                	jle    10106a <lpt_putc_sub+0xf>
    }
    outb(LPTPORT + 0, c);
  101094:	8b 45 08             	mov    0x8(%ebp),%eax
  101097:	0f b6 c0             	movzbl %al,%eax
  10109a:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
  1010a0:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1010a3:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1010a7:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1010ab:	ee                   	out    %al,(%dx)
  1010ac:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  1010b2:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  1010b6:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1010ba:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1010be:	ee                   	out    %al,(%dx)
  1010bf:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
  1010c5:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
  1010c9:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1010cd:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1010d1:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  1010d2:	c9                   	leave  
  1010d3:	c3                   	ret    

001010d4 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  1010d4:	55                   	push   %ebp
  1010d5:	89 e5                	mov    %esp,%ebp
  1010d7:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1010da:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1010de:	74 0d                	je     1010ed <lpt_putc+0x19>
        lpt_putc_sub(c);
  1010e0:	8b 45 08             	mov    0x8(%ebp),%eax
  1010e3:	89 04 24             	mov    %eax,(%esp)
  1010e6:	e8 70 ff ff ff       	call   10105b <lpt_putc_sub>
  1010eb:	eb 24                	jmp    101111 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
  1010ed:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010f4:	e8 62 ff ff ff       	call   10105b <lpt_putc_sub>
        lpt_putc_sub(' ');
  1010f9:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  101100:	e8 56 ff ff ff       	call   10105b <lpt_putc_sub>
        lpt_putc_sub('\b');
  101105:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10110c:	e8 4a ff ff ff       	call   10105b <lpt_putc_sub>
    }
}
  101111:	c9                   	leave  
  101112:	c3                   	ret    

00101113 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  101113:	55                   	push   %ebp
  101114:	89 e5                	mov    %esp,%ebp
  101116:	53                   	push   %ebx
  101117:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  10111a:	8b 45 08             	mov    0x8(%ebp),%eax
  10111d:	b0 00                	mov    $0x0,%al
  10111f:	85 c0                	test   %eax,%eax
  101121:	75 07                	jne    10112a <cga_putc+0x17>
        c |= 0x0700;
  101123:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  10112a:	8b 45 08             	mov    0x8(%ebp),%eax
  10112d:	0f b6 c0             	movzbl %al,%eax
  101130:	83 f8 0a             	cmp    $0xa,%eax
  101133:	74 4c                	je     101181 <cga_putc+0x6e>
  101135:	83 f8 0d             	cmp    $0xd,%eax
  101138:	74 57                	je     101191 <cga_putc+0x7e>
  10113a:	83 f8 08             	cmp    $0x8,%eax
  10113d:	0f 85 88 00 00 00    	jne    1011cb <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
  101143:	0f b7 05 44 a4 11 00 	movzwl 0x11a444,%eax
  10114a:	66 85 c0             	test   %ax,%ax
  10114d:	74 30                	je     10117f <cga_putc+0x6c>
            crt_pos --;
  10114f:	0f b7 05 44 a4 11 00 	movzwl 0x11a444,%eax
  101156:	83 e8 01             	sub    $0x1,%eax
  101159:	66 a3 44 a4 11 00    	mov    %ax,0x11a444
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  10115f:	a1 40 a4 11 00       	mov    0x11a440,%eax
  101164:	0f b7 15 44 a4 11 00 	movzwl 0x11a444,%edx
  10116b:	0f b7 d2             	movzwl %dx,%edx
  10116e:	01 d2                	add    %edx,%edx
  101170:	01 c2                	add    %eax,%edx
  101172:	8b 45 08             	mov    0x8(%ebp),%eax
  101175:	b0 00                	mov    $0x0,%al
  101177:	83 c8 20             	or     $0x20,%eax
  10117a:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  10117d:	eb 72                	jmp    1011f1 <cga_putc+0xde>
  10117f:	eb 70                	jmp    1011f1 <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
  101181:	0f b7 05 44 a4 11 00 	movzwl 0x11a444,%eax
  101188:	83 c0 50             	add    $0x50,%eax
  10118b:	66 a3 44 a4 11 00    	mov    %ax,0x11a444
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  101191:	0f b7 1d 44 a4 11 00 	movzwl 0x11a444,%ebx
  101198:	0f b7 0d 44 a4 11 00 	movzwl 0x11a444,%ecx
  10119f:	0f b7 c1             	movzwl %cx,%eax
  1011a2:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  1011a8:	c1 e8 10             	shr    $0x10,%eax
  1011ab:	89 c2                	mov    %eax,%edx
  1011ad:	66 c1 ea 06          	shr    $0x6,%dx
  1011b1:	89 d0                	mov    %edx,%eax
  1011b3:	c1 e0 02             	shl    $0x2,%eax
  1011b6:	01 d0                	add    %edx,%eax
  1011b8:	c1 e0 04             	shl    $0x4,%eax
  1011bb:	29 c1                	sub    %eax,%ecx
  1011bd:	89 ca                	mov    %ecx,%edx
  1011bf:	89 d8                	mov    %ebx,%eax
  1011c1:	29 d0                	sub    %edx,%eax
  1011c3:	66 a3 44 a4 11 00    	mov    %ax,0x11a444
        break;
  1011c9:	eb 26                	jmp    1011f1 <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  1011cb:	8b 0d 40 a4 11 00    	mov    0x11a440,%ecx
  1011d1:	0f b7 05 44 a4 11 00 	movzwl 0x11a444,%eax
  1011d8:	8d 50 01             	lea    0x1(%eax),%edx
  1011db:	66 89 15 44 a4 11 00 	mov    %dx,0x11a444
  1011e2:	0f b7 c0             	movzwl %ax,%eax
  1011e5:	01 c0                	add    %eax,%eax
  1011e7:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  1011ea:	8b 45 08             	mov    0x8(%ebp),%eax
  1011ed:	66 89 02             	mov    %ax,(%edx)
        break;
  1011f0:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  1011f1:	0f b7 05 44 a4 11 00 	movzwl 0x11a444,%eax
  1011f8:	66 3d cf 07          	cmp    $0x7cf,%ax
  1011fc:	76 5b                	jbe    101259 <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  1011fe:	a1 40 a4 11 00       	mov    0x11a440,%eax
  101203:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  101209:	a1 40 a4 11 00       	mov    0x11a440,%eax
  10120e:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  101215:	00 
  101216:	89 54 24 04          	mov    %edx,0x4(%esp)
  10121a:	89 04 24             	mov    %eax,(%esp)
  10121d:	e8 dd 46 00 00       	call   1058ff <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101222:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  101229:	eb 15                	jmp    101240 <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
  10122b:	a1 40 a4 11 00       	mov    0x11a440,%eax
  101230:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101233:	01 d2                	add    %edx,%edx
  101235:	01 d0                	add    %edx,%eax
  101237:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  10123c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101240:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  101247:	7e e2                	jle    10122b <cga_putc+0x118>
        }
        crt_pos -= CRT_COLS;
  101249:	0f b7 05 44 a4 11 00 	movzwl 0x11a444,%eax
  101250:	83 e8 50             	sub    $0x50,%eax
  101253:	66 a3 44 a4 11 00    	mov    %ax,0x11a444
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  101259:	0f b7 05 46 a4 11 00 	movzwl 0x11a446,%eax
  101260:	0f b7 c0             	movzwl %ax,%eax
  101263:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  101267:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
  10126b:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10126f:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101273:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  101274:	0f b7 05 44 a4 11 00 	movzwl 0x11a444,%eax
  10127b:	66 c1 e8 08          	shr    $0x8,%ax
  10127f:	0f b6 c0             	movzbl %al,%eax
  101282:	0f b7 15 46 a4 11 00 	movzwl 0x11a446,%edx
  101289:	83 c2 01             	add    $0x1,%edx
  10128c:	0f b7 d2             	movzwl %dx,%edx
  10128f:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
  101293:	88 45 ed             	mov    %al,-0x13(%ebp)
  101296:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10129a:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10129e:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  10129f:	0f b7 05 46 a4 11 00 	movzwl 0x11a446,%eax
  1012a6:	0f b7 c0             	movzwl %ax,%eax
  1012a9:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  1012ad:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
  1012b1:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1012b5:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1012b9:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  1012ba:	0f b7 05 44 a4 11 00 	movzwl 0x11a444,%eax
  1012c1:	0f b6 c0             	movzbl %al,%eax
  1012c4:	0f b7 15 46 a4 11 00 	movzwl 0x11a446,%edx
  1012cb:	83 c2 01             	add    $0x1,%edx
  1012ce:	0f b7 d2             	movzwl %dx,%edx
  1012d1:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
  1012d5:	88 45 e5             	mov    %al,-0x1b(%ebp)
  1012d8:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1012dc:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1012e0:	ee                   	out    %al,(%dx)
}
  1012e1:	83 c4 34             	add    $0x34,%esp
  1012e4:	5b                   	pop    %ebx
  1012e5:	5d                   	pop    %ebp
  1012e6:	c3                   	ret    

001012e7 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  1012e7:	55                   	push   %ebp
  1012e8:	89 e5                	mov    %esp,%ebp
  1012ea:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012ed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1012f4:	eb 09                	jmp    1012ff <serial_putc_sub+0x18>
        delay();
  1012f6:	e8 4f fb ff ff       	call   100e4a <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012fb:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1012ff:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101305:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101309:	89 c2                	mov    %eax,%edx
  10130b:	ec                   	in     (%dx),%al
  10130c:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  10130f:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101313:	0f b6 c0             	movzbl %al,%eax
  101316:	83 e0 20             	and    $0x20,%eax
  101319:	85 c0                	test   %eax,%eax
  10131b:	75 09                	jne    101326 <serial_putc_sub+0x3f>
  10131d:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101324:	7e d0                	jle    1012f6 <serial_putc_sub+0xf>
    }
    outb(COM1 + COM_TX, c);
  101326:	8b 45 08             	mov    0x8(%ebp),%eax
  101329:	0f b6 c0             	movzbl %al,%eax
  10132c:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  101332:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101335:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101339:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10133d:	ee                   	out    %al,(%dx)
}
  10133e:	c9                   	leave  
  10133f:	c3                   	ret    

00101340 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  101340:	55                   	push   %ebp
  101341:	89 e5                	mov    %esp,%ebp
  101343:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  101346:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  10134a:	74 0d                	je     101359 <serial_putc+0x19>
        serial_putc_sub(c);
  10134c:	8b 45 08             	mov    0x8(%ebp),%eax
  10134f:	89 04 24             	mov    %eax,(%esp)
  101352:	e8 90 ff ff ff       	call   1012e7 <serial_putc_sub>
  101357:	eb 24                	jmp    10137d <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
  101359:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101360:	e8 82 ff ff ff       	call   1012e7 <serial_putc_sub>
        serial_putc_sub(' ');
  101365:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  10136c:	e8 76 ff ff ff       	call   1012e7 <serial_putc_sub>
        serial_putc_sub('\b');
  101371:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101378:	e8 6a ff ff ff       	call   1012e7 <serial_putc_sub>
    }
}
  10137d:	c9                   	leave  
  10137e:	c3                   	ret    

0010137f <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  10137f:	55                   	push   %ebp
  101380:	89 e5                	mov    %esp,%ebp
  101382:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  101385:	eb 33                	jmp    1013ba <cons_intr+0x3b>
        if (c != 0) {
  101387:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10138b:	74 2d                	je     1013ba <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  10138d:	a1 64 a6 11 00       	mov    0x11a664,%eax
  101392:	8d 50 01             	lea    0x1(%eax),%edx
  101395:	89 15 64 a6 11 00    	mov    %edx,0x11a664
  10139b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10139e:	88 90 60 a4 11 00    	mov    %dl,0x11a460(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  1013a4:	a1 64 a6 11 00       	mov    0x11a664,%eax
  1013a9:	3d 00 02 00 00       	cmp    $0x200,%eax
  1013ae:	75 0a                	jne    1013ba <cons_intr+0x3b>
                cons.wpos = 0;
  1013b0:	c7 05 64 a6 11 00 00 	movl   $0x0,0x11a664
  1013b7:	00 00 00 
    while ((c = (*proc)()) != -1) {
  1013ba:	8b 45 08             	mov    0x8(%ebp),%eax
  1013bd:	ff d0                	call   *%eax
  1013bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1013c2:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  1013c6:	75 bf                	jne    101387 <cons_intr+0x8>
            }
        }
    }
}
  1013c8:	c9                   	leave  
  1013c9:	c3                   	ret    

001013ca <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  1013ca:	55                   	push   %ebp
  1013cb:	89 e5                	mov    %esp,%ebp
  1013cd:	83 ec 10             	sub    $0x10,%esp
  1013d0:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013d6:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1013da:	89 c2                	mov    %eax,%edx
  1013dc:	ec                   	in     (%dx),%al
  1013dd:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1013e0:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  1013e4:	0f b6 c0             	movzbl %al,%eax
  1013e7:	83 e0 01             	and    $0x1,%eax
  1013ea:	85 c0                	test   %eax,%eax
  1013ec:	75 07                	jne    1013f5 <serial_proc_data+0x2b>
        return -1;
  1013ee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013f3:	eb 2a                	jmp    10141f <serial_proc_data+0x55>
  1013f5:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013fb:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  1013ff:	89 c2                	mov    %eax,%edx
  101401:	ec                   	in     (%dx),%al
  101402:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  101405:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  101409:	0f b6 c0             	movzbl %al,%eax
  10140c:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  10140f:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  101413:	75 07                	jne    10141c <serial_proc_data+0x52>
        c = '\b';
  101415:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  10141c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10141f:	c9                   	leave  
  101420:	c3                   	ret    

00101421 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  101421:	55                   	push   %ebp
  101422:	89 e5                	mov    %esp,%ebp
  101424:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  101427:	a1 48 a4 11 00       	mov    0x11a448,%eax
  10142c:	85 c0                	test   %eax,%eax
  10142e:	74 0c                	je     10143c <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  101430:	c7 04 24 ca 13 10 00 	movl   $0x1013ca,(%esp)
  101437:	e8 43 ff ff ff       	call   10137f <cons_intr>
    }
}
  10143c:	c9                   	leave  
  10143d:	c3                   	ret    

0010143e <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  10143e:	55                   	push   %ebp
  10143f:	89 e5                	mov    %esp,%ebp
  101441:	83 ec 38             	sub    $0x38,%esp
  101444:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10144a:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  10144e:	89 c2                	mov    %eax,%edx
  101450:	ec                   	in     (%dx),%al
  101451:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  101454:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  101458:	0f b6 c0             	movzbl %al,%eax
  10145b:	83 e0 01             	and    $0x1,%eax
  10145e:	85 c0                	test   %eax,%eax
  101460:	75 0a                	jne    10146c <kbd_proc_data+0x2e>
        return -1;
  101462:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101467:	e9 59 01 00 00       	jmp    1015c5 <kbd_proc_data+0x187>
  10146c:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101472:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101476:	89 c2                	mov    %eax,%edx
  101478:	ec                   	in     (%dx),%al
  101479:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  10147c:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  101480:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  101483:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  101487:	75 17                	jne    1014a0 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  101489:	a1 68 a6 11 00       	mov    0x11a668,%eax
  10148e:	83 c8 40             	or     $0x40,%eax
  101491:	a3 68 a6 11 00       	mov    %eax,0x11a668
        return 0;
  101496:	b8 00 00 00 00       	mov    $0x0,%eax
  10149b:	e9 25 01 00 00       	jmp    1015c5 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
  1014a0:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014a4:	84 c0                	test   %al,%al
  1014a6:	79 47                	jns    1014ef <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  1014a8:	a1 68 a6 11 00       	mov    0x11a668,%eax
  1014ad:	83 e0 40             	and    $0x40,%eax
  1014b0:	85 c0                	test   %eax,%eax
  1014b2:	75 09                	jne    1014bd <kbd_proc_data+0x7f>
  1014b4:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014b8:	83 e0 7f             	and    $0x7f,%eax
  1014bb:	eb 04                	jmp    1014c1 <kbd_proc_data+0x83>
  1014bd:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014c1:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  1014c4:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014c8:	0f b6 80 40 70 11 00 	movzbl 0x117040(%eax),%eax
  1014cf:	83 c8 40             	or     $0x40,%eax
  1014d2:	0f b6 c0             	movzbl %al,%eax
  1014d5:	f7 d0                	not    %eax
  1014d7:	89 c2                	mov    %eax,%edx
  1014d9:	a1 68 a6 11 00       	mov    0x11a668,%eax
  1014de:	21 d0                	and    %edx,%eax
  1014e0:	a3 68 a6 11 00       	mov    %eax,0x11a668
        return 0;
  1014e5:	b8 00 00 00 00       	mov    $0x0,%eax
  1014ea:	e9 d6 00 00 00       	jmp    1015c5 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
  1014ef:	a1 68 a6 11 00       	mov    0x11a668,%eax
  1014f4:	83 e0 40             	and    $0x40,%eax
  1014f7:	85 c0                	test   %eax,%eax
  1014f9:	74 11                	je     10150c <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  1014fb:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  1014ff:	a1 68 a6 11 00       	mov    0x11a668,%eax
  101504:	83 e0 bf             	and    $0xffffffbf,%eax
  101507:	a3 68 a6 11 00       	mov    %eax,0x11a668
    }

    shift |= shiftcode[data];
  10150c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101510:	0f b6 80 40 70 11 00 	movzbl 0x117040(%eax),%eax
  101517:	0f b6 d0             	movzbl %al,%edx
  10151a:	a1 68 a6 11 00       	mov    0x11a668,%eax
  10151f:	09 d0                	or     %edx,%eax
  101521:	a3 68 a6 11 00       	mov    %eax,0x11a668
    shift ^= togglecode[data];
  101526:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10152a:	0f b6 80 40 71 11 00 	movzbl 0x117140(%eax),%eax
  101531:	0f b6 d0             	movzbl %al,%edx
  101534:	a1 68 a6 11 00       	mov    0x11a668,%eax
  101539:	31 d0                	xor    %edx,%eax
  10153b:	a3 68 a6 11 00       	mov    %eax,0x11a668

    c = charcode[shift & (CTL | SHIFT)][data];
  101540:	a1 68 a6 11 00       	mov    0x11a668,%eax
  101545:	83 e0 03             	and    $0x3,%eax
  101548:	8b 14 85 40 75 11 00 	mov    0x117540(,%eax,4),%edx
  10154f:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101553:	01 d0                	add    %edx,%eax
  101555:	0f b6 00             	movzbl (%eax),%eax
  101558:	0f b6 c0             	movzbl %al,%eax
  10155b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  10155e:	a1 68 a6 11 00       	mov    0x11a668,%eax
  101563:	83 e0 08             	and    $0x8,%eax
  101566:	85 c0                	test   %eax,%eax
  101568:	74 22                	je     10158c <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  10156a:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  10156e:	7e 0c                	jle    10157c <kbd_proc_data+0x13e>
  101570:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  101574:	7f 06                	jg     10157c <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  101576:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  10157a:	eb 10                	jmp    10158c <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  10157c:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  101580:	7e 0a                	jle    10158c <kbd_proc_data+0x14e>
  101582:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  101586:	7f 04                	jg     10158c <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  101588:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  10158c:	a1 68 a6 11 00       	mov    0x11a668,%eax
  101591:	f7 d0                	not    %eax
  101593:	83 e0 06             	and    $0x6,%eax
  101596:	85 c0                	test   %eax,%eax
  101598:	75 28                	jne    1015c2 <kbd_proc_data+0x184>
  10159a:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  1015a1:	75 1f                	jne    1015c2 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
  1015a3:	c7 04 24 0d 64 10 00 	movl   $0x10640d,(%esp)
  1015aa:	e8 ee ec ff ff       	call   10029d <cprintf>
  1015af:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  1015b5:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1015b9:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  1015bd:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  1015c1:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  1015c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1015c5:	c9                   	leave  
  1015c6:	c3                   	ret    

001015c7 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  1015c7:	55                   	push   %ebp
  1015c8:	89 e5                	mov    %esp,%ebp
  1015ca:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  1015cd:	c7 04 24 3e 14 10 00 	movl   $0x10143e,(%esp)
  1015d4:	e8 a6 fd ff ff       	call   10137f <cons_intr>
}
  1015d9:	c9                   	leave  
  1015da:	c3                   	ret    

001015db <kbd_init>:

static void
kbd_init(void) {
  1015db:	55                   	push   %ebp
  1015dc:	89 e5                	mov    %esp,%ebp
  1015de:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  1015e1:	e8 e1 ff ff ff       	call   1015c7 <kbd_intr>
    pic_enable(IRQ_KBD);
  1015e6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1015ed:	e8 31 01 00 00       	call   101723 <pic_enable>
}
  1015f2:	c9                   	leave  
  1015f3:	c3                   	ret    

001015f4 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  1015f4:	55                   	push   %ebp
  1015f5:	89 e5                	mov    %esp,%ebp
  1015f7:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  1015fa:	e8 93 f8 ff ff       	call   100e92 <cga_init>
    serial_init();
  1015ff:	e8 74 f9 ff ff       	call   100f78 <serial_init>
    kbd_init();
  101604:	e8 d2 ff ff ff       	call   1015db <kbd_init>
    if (!serial_exists) {
  101609:	a1 48 a4 11 00       	mov    0x11a448,%eax
  10160e:	85 c0                	test   %eax,%eax
  101610:	75 0c                	jne    10161e <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  101612:	c7 04 24 19 64 10 00 	movl   $0x106419,(%esp)
  101619:	e8 7f ec ff ff       	call   10029d <cprintf>
    }
}
  10161e:	c9                   	leave  
  10161f:	c3                   	ret    

00101620 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  101620:	55                   	push   %ebp
  101621:	89 e5                	mov    %esp,%ebp
  101623:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  101626:	e8 e2 f7 ff ff       	call   100e0d <__intr_save>
  10162b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
  10162e:	8b 45 08             	mov    0x8(%ebp),%eax
  101631:	89 04 24             	mov    %eax,(%esp)
  101634:	e8 9b fa ff ff       	call   1010d4 <lpt_putc>
        cga_putc(c);
  101639:	8b 45 08             	mov    0x8(%ebp),%eax
  10163c:	89 04 24             	mov    %eax,(%esp)
  10163f:	e8 cf fa ff ff       	call   101113 <cga_putc>
        serial_putc(c);
  101644:	8b 45 08             	mov    0x8(%ebp),%eax
  101647:	89 04 24             	mov    %eax,(%esp)
  10164a:	e8 f1 fc ff ff       	call   101340 <serial_putc>
    }
    local_intr_restore(intr_flag);
  10164f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101652:	89 04 24             	mov    %eax,(%esp)
  101655:	e8 dd f7 ff ff       	call   100e37 <__intr_restore>
}
  10165a:	c9                   	leave  
  10165b:	c3                   	ret    

0010165c <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  10165c:	55                   	push   %ebp
  10165d:	89 e5                	mov    %esp,%ebp
  10165f:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
  101662:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  101669:	e8 9f f7 ff ff       	call   100e0d <__intr_save>
  10166e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
  101671:	e8 ab fd ff ff       	call   101421 <serial_intr>
        kbd_intr();
  101676:	e8 4c ff ff ff       	call   1015c7 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
  10167b:	8b 15 60 a6 11 00    	mov    0x11a660,%edx
  101681:	a1 64 a6 11 00       	mov    0x11a664,%eax
  101686:	39 c2                	cmp    %eax,%edx
  101688:	74 31                	je     1016bb <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
  10168a:	a1 60 a6 11 00       	mov    0x11a660,%eax
  10168f:	8d 50 01             	lea    0x1(%eax),%edx
  101692:	89 15 60 a6 11 00    	mov    %edx,0x11a660
  101698:	0f b6 80 60 a4 11 00 	movzbl 0x11a460(%eax),%eax
  10169f:	0f b6 c0             	movzbl %al,%eax
  1016a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
  1016a5:	a1 60 a6 11 00       	mov    0x11a660,%eax
  1016aa:	3d 00 02 00 00       	cmp    $0x200,%eax
  1016af:	75 0a                	jne    1016bb <cons_getc+0x5f>
                cons.rpos = 0;
  1016b1:	c7 05 60 a6 11 00 00 	movl   $0x0,0x11a660
  1016b8:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
  1016bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1016be:	89 04 24             	mov    %eax,(%esp)
  1016c1:	e8 71 f7 ff ff       	call   100e37 <__intr_restore>
    return c;
  1016c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1016c9:	c9                   	leave  
  1016ca:	c3                   	ret    

001016cb <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  1016cb:	55                   	push   %ebp
  1016cc:	89 e5                	mov    %esp,%ebp
  1016ce:	83 ec 14             	sub    $0x14,%esp
  1016d1:	8b 45 08             	mov    0x8(%ebp),%eax
  1016d4:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  1016d8:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016dc:	66 a3 50 75 11 00    	mov    %ax,0x117550
    if (did_init) {
  1016e2:	a1 6c a6 11 00       	mov    0x11a66c,%eax
  1016e7:	85 c0                	test   %eax,%eax
  1016e9:	74 36                	je     101721 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  1016eb:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016ef:	0f b6 c0             	movzbl %al,%eax
  1016f2:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  1016f8:	88 45 fd             	mov    %al,-0x3(%ebp)
  1016fb:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1016ff:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101703:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  101704:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101708:	66 c1 e8 08          	shr    $0x8,%ax
  10170c:	0f b6 c0             	movzbl %al,%eax
  10170f:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  101715:	88 45 f9             	mov    %al,-0x7(%ebp)
  101718:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10171c:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101720:	ee                   	out    %al,(%dx)
    }
}
  101721:	c9                   	leave  
  101722:	c3                   	ret    

00101723 <pic_enable>:

void
pic_enable(unsigned int irq) {
  101723:	55                   	push   %ebp
  101724:	89 e5                	mov    %esp,%ebp
  101726:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  101729:	8b 45 08             	mov    0x8(%ebp),%eax
  10172c:	ba 01 00 00 00       	mov    $0x1,%edx
  101731:	89 c1                	mov    %eax,%ecx
  101733:	d3 e2                	shl    %cl,%edx
  101735:	89 d0                	mov    %edx,%eax
  101737:	f7 d0                	not    %eax
  101739:	89 c2                	mov    %eax,%edx
  10173b:	0f b7 05 50 75 11 00 	movzwl 0x117550,%eax
  101742:	21 d0                	and    %edx,%eax
  101744:	0f b7 c0             	movzwl %ax,%eax
  101747:	89 04 24             	mov    %eax,(%esp)
  10174a:	e8 7c ff ff ff       	call   1016cb <pic_setmask>
}
  10174f:	c9                   	leave  
  101750:	c3                   	ret    

00101751 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  101751:	55                   	push   %ebp
  101752:	89 e5                	mov    %esp,%ebp
  101754:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  101757:	c7 05 6c a6 11 00 01 	movl   $0x1,0x11a66c
  10175e:	00 00 00 
  101761:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  101767:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
  10176b:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  10176f:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101773:	ee                   	out    %al,(%dx)
  101774:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  10177a:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
  10177e:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101782:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101786:	ee                   	out    %al,(%dx)
  101787:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  10178d:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
  101791:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101795:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101799:	ee                   	out    %al,(%dx)
  10179a:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
  1017a0:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
  1017a4:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1017a8:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1017ac:	ee                   	out    %al,(%dx)
  1017ad:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
  1017b3:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
  1017b7:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1017bb:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1017bf:	ee                   	out    %al,(%dx)
  1017c0:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
  1017c6:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
  1017ca:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1017ce:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1017d2:	ee                   	out    %al,(%dx)
  1017d3:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  1017d9:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
  1017dd:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1017e1:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1017e5:	ee                   	out    %al,(%dx)
  1017e6:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
  1017ec:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
  1017f0:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  1017f4:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  1017f8:	ee                   	out    %al,(%dx)
  1017f9:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
  1017ff:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
  101803:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  101807:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  10180b:	ee                   	out    %al,(%dx)
  10180c:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
  101812:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
  101816:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  10181a:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  10181e:	ee                   	out    %al,(%dx)
  10181f:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
  101825:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
  101829:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  10182d:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  101831:	ee                   	out    %al,(%dx)
  101832:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  101838:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
  10183c:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  101840:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  101844:	ee                   	out    %al,(%dx)
  101845:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
  10184b:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
  10184f:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  101853:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  101857:	ee                   	out    %al,(%dx)
  101858:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
  10185e:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
  101862:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  101866:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  10186a:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  10186b:	0f b7 05 50 75 11 00 	movzwl 0x117550,%eax
  101872:	66 83 f8 ff          	cmp    $0xffff,%ax
  101876:	74 12                	je     10188a <pic_init+0x139>
        pic_setmask(irq_mask);
  101878:	0f b7 05 50 75 11 00 	movzwl 0x117550,%eax
  10187f:	0f b7 c0             	movzwl %ax,%eax
  101882:	89 04 24             	mov    %eax,(%esp)
  101885:	e8 41 fe ff ff       	call   1016cb <pic_setmask>
    }
}
  10188a:	c9                   	leave  
  10188b:	c3                   	ret    

0010188c <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  10188c:	55                   	push   %ebp
  10188d:	89 e5                	mov    %esp,%ebp
    asm volatile ("sti");
  10188f:	fb                   	sti    
    sti();
}
  101890:	5d                   	pop    %ebp
  101891:	c3                   	ret    

00101892 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  101892:	55                   	push   %ebp
  101893:	89 e5                	mov    %esp,%ebp
    asm volatile ("cli" ::: "memory");
  101895:	fa                   	cli    
    cli();
}
  101896:	5d                   	pop    %ebp
  101897:	c3                   	ret    

00101898 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  101898:	55                   	push   %ebp
  101899:	89 e5                	mov    %esp,%ebp
  10189b:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  10189e:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  1018a5:	00 
  1018a6:	c7 04 24 40 64 10 00 	movl   $0x106440,(%esp)
  1018ad:	e8 eb e9 ff ff       	call   10029d <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
  1018b2:	c7 04 24 4a 64 10 00 	movl   $0x10644a,(%esp)
  1018b9:	e8 df e9 ff ff       	call   10029d <cprintf>
    panic("EOT: kernel seems ok.");
  1018be:	c7 44 24 08 58 64 10 	movl   $0x106458,0x8(%esp)
  1018c5:	00 
  1018c6:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
  1018cd:	00 
  1018ce:	c7 04 24 6e 64 10 00 	movl   $0x10646e,(%esp)
  1018d5:	e8 1a eb ff ff       	call   1003f4 <__panic>

001018da <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  1018da:	55                   	push   %ebp
  1018db:	89 e5                	mov    %esp,%ebp
  1018dd:	83 ec 10             	sub    $0x10,%esp
      */

	extern uintptr_t __vectors[];

	uint32_t i;
	for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++)
  1018e0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1018e7:	e9 c3 00 00 00       	jmp    1019af <idt_init+0xd5>
	{
		SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  1018ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018ef:	8b 04 85 e0 75 11 00 	mov    0x1175e0(,%eax,4),%eax
  1018f6:	89 c2                	mov    %eax,%edx
  1018f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018fb:	66 89 14 c5 80 a6 11 	mov    %dx,0x11a680(,%eax,8)
  101902:	00 
  101903:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101906:	66 c7 04 c5 82 a6 11 	movw   $0x8,0x11a682(,%eax,8)
  10190d:	00 08 00 
  101910:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101913:	0f b6 14 c5 84 a6 11 	movzbl 0x11a684(,%eax,8),%edx
  10191a:	00 
  10191b:	83 e2 e0             	and    $0xffffffe0,%edx
  10191e:	88 14 c5 84 a6 11 00 	mov    %dl,0x11a684(,%eax,8)
  101925:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101928:	0f b6 14 c5 84 a6 11 	movzbl 0x11a684(,%eax,8),%edx
  10192f:	00 
  101930:	83 e2 1f             	and    $0x1f,%edx
  101933:	88 14 c5 84 a6 11 00 	mov    %dl,0x11a684(,%eax,8)
  10193a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10193d:	0f b6 14 c5 85 a6 11 	movzbl 0x11a685(,%eax,8),%edx
  101944:	00 
  101945:	83 e2 f0             	and    $0xfffffff0,%edx
  101948:	83 ca 0e             	or     $0xe,%edx
  10194b:	88 14 c5 85 a6 11 00 	mov    %dl,0x11a685(,%eax,8)
  101952:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101955:	0f b6 14 c5 85 a6 11 	movzbl 0x11a685(,%eax,8),%edx
  10195c:	00 
  10195d:	83 e2 ef             	and    $0xffffffef,%edx
  101960:	88 14 c5 85 a6 11 00 	mov    %dl,0x11a685(,%eax,8)
  101967:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10196a:	0f b6 14 c5 85 a6 11 	movzbl 0x11a685(,%eax,8),%edx
  101971:	00 
  101972:	83 e2 9f             	and    $0xffffff9f,%edx
  101975:	88 14 c5 85 a6 11 00 	mov    %dl,0x11a685(,%eax,8)
  10197c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10197f:	0f b6 14 c5 85 a6 11 	movzbl 0x11a685(,%eax,8),%edx
  101986:	00 
  101987:	83 ca 80             	or     $0xffffff80,%edx
  10198a:	88 14 c5 85 a6 11 00 	mov    %dl,0x11a685(,%eax,8)
  101991:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101994:	8b 04 85 e0 75 11 00 	mov    0x1175e0(,%eax,4),%eax
  10199b:	c1 e8 10             	shr    $0x10,%eax
  10199e:	89 c2                	mov    %eax,%edx
  1019a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019a3:	66 89 14 c5 86 a6 11 	mov    %dx,0x11a686(,%eax,8)
  1019aa:	00 
	for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++)
  1019ab:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1019af:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
  1019b6:	0f 86 30 ff ff ff    	jbe    1018ec <idt_init+0x12>
	}

	// set for switch from user to kernel
	SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
  1019bc:	a1 c4 77 11 00       	mov    0x1177c4,%eax
  1019c1:	66 a3 48 aa 11 00    	mov    %ax,0x11aa48
  1019c7:	66 c7 05 4a aa 11 00 	movw   $0x8,0x11aa4a
  1019ce:	08 00 
  1019d0:	0f b6 05 4c aa 11 00 	movzbl 0x11aa4c,%eax
  1019d7:	83 e0 e0             	and    $0xffffffe0,%eax
  1019da:	a2 4c aa 11 00       	mov    %al,0x11aa4c
  1019df:	0f b6 05 4c aa 11 00 	movzbl 0x11aa4c,%eax
  1019e6:	83 e0 1f             	and    $0x1f,%eax
  1019e9:	a2 4c aa 11 00       	mov    %al,0x11aa4c
  1019ee:	0f b6 05 4d aa 11 00 	movzbl 0x11aa4d,%eax
  1019f5:	83 e0 f0             	and    $0xfffffff0,%eax
  1019f8:	83 c8 0e             	or     $0xe,%eax
  1019fb:	a2 4d aa 11 00       	mov    %al,0x11aa4d
  101a00:	0f b6 05 4d aa 11 00 	movzbl 0x11aa4d,%eax
  101a07:	83 e0 ef             	and    $0xffffffef,%eax
  101a0a:	a2 4d aa 11 00       	mov    %al,0x11aa4d
  101a0f:	0f b6 05 4d aa 11 00 	movzbl 0x11aa4d,%eax
  101a16:	83 c8 60             	or     $0x60,%eax
  101a19:	a2 4d aa 11 00       	mov    %al,0x11aa4d
  101a1e:	0f b6 05 4d aa 11 00 	movzbl 0x11aa4d,%eax
  101a25:	83 c8 80             	or     $0xffffff80,%eax
  101a28:	a2 4d aa 11 00       	mov    %al,0x11aa4d
  101a2d:	a1 c4 77 11 00       	mov    0x1177c4,%eax
  101a32:	c1 e8 10             	shr    $0x10,%eax
  101a35:	66 a3 4e aa 11 00    	mov    %ax,0x11aa4e
  101a3b:	c7 45 f8 60 75 11 00 	movl   $0x117560,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
  101a42:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101a45:	0f 01 18             	lidtl  (%eax)

	// idt 存储了具体的信息， idtpd，作为一个结构体，将idt进行了进一步封装，这种写法很常见
	lidt(&idt_pd);


}
  101a48:	c9                   	leave  
  101a49:	c3                   	ret    

00101a4a <trapname>:

static const char *
trapname(int trapno) {
  101a4a:	55                   	push   %ebp
  101a4b:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101a4d:	8b 45 08             	mov    0x8(%ebp),%eax
  101a50:	83 f8 13             	cmp    $0x13,%eax
  101a53:	77 0c                	ja     101a61 <trapname+0x17>
        return excnames[trapno];
  101a55:	8b 45 08             	mov    0x8(%ebp),%eax
  101a58:	8b 04 85 c0 67 10 00 	mov    0x1067c0(,%eax,4),%eax
  101a5f:	eb 18                	jmp    101a79 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101a61:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101a65:	7e 0d                	jle    101a74 <trapname+0x2a>
  101a67:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101a6b:	7f 07                	jg     101a74 <trapname+0x2a>
        return "Hardware Interrupt";
  101a6d:	b8 7f 64 10 00       	mov    $0x10647f,%eax
  101a72:	eb 05                	jmp    101a79 <trapname+0x2f>
    }
    return "(unknown trap)";
  101a74:	b8 92 64 10 00       	mov    $0x106492,%eax
}
  101a79:	5d                   	pop    %ebp
  101a7a:	c3                   	ret    

00101a7b <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101a7b:	55                   	push   %ebp
  101a7c:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101a7e:	8b 45 08             	mov    0x8(%ebp),%eax
  101a81:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101a85:	66 83 f8 08          	cmp    $0x8,%ax
  101a89:	0f 94 c0             	sete   %al
  101a8c:	0f b6 c0             	movzbl %al,%eax
}
  101a8f:	5d                   	pop    %ebp
  101a90:	c3                   	ret    

00101a91 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101a91:	55                   	push   %ebp
  101a92:	89 e5                	mov    %esp,%ebp
  101a94:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101a97:	8b 45 08             	mov    0x8(%ebp),%eax
  101a9a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a9e:	c7 04 24 d3 64 10 00 	movl   $0x1064d3,(%esp)
  101aa5:	e8 f3 e7 ff ff       	call   10029d <cprintf>
    print_regs(&tf->tf_regs);
  101aaa:	8b 45 08             	mov    0x8(%ebp),%eax
  101aad:	89 04 24             	mov    %eax,(%esp)
  101ab0:	e8 a1 01 00 00       	call   101c56 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101ab5:	8b 45 08             	mov    0x8(%ebp),%eax
  101ab8:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101abc:	0f b7 c0             	movzwl %ax,%eax
  101abf:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ac3:	c7 04 24 e4 64 10 00 	movl   $0x1064e4,(%esp)
  101aca:	e8 ce e7 ff ff       	call   10029d <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101acf:	8b 45 08             	mov    0x8(%ebp),%eax
  101ad2:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101ad6:	0f b7 c0             	movzwl %ax,%eax
  101ad9:	89 44 24 04          	mov    %eax,0x4(%esp)
  101add:	c7 04 24 f7 64 10 00 	movl   $0x1064f7,(%esp)
  101ae4:	e8 b4 e7 ff ff       	call   10029d <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  101aec:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101af0:	0f b7 c0             	movzwl %ax,%eax
  101af3:	89 44 24 04          	mov    %eax,0x4(%esp)
  101af7:	c7 04 24 0a 65 10 00 	movl   $0x10650a,(%esp)
  101afe:	e8 9a e7 ff ff       	call   10029d <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101b03:	8b 45 08             	mov    0x8(%ebp),%eax
  101b06:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101b0a:	0f b7 c0             	movzwl %ax,%eax
  101b0d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b11:	c7 04 24 1d 65 10 00 	movl   $0x10651d,(%esp)
  101b18:	e8 80 e7 ff ff       	call   10029d <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  101b20:	8b 40 30             	mov    0x30(%eax),%eax
  101b23:	89 04 24             	mov    %eax,(%esp)
  101b26:	e8 1f ff ff ff       	call   101a4a <trapname>
  101b2b:	8b 55 08             	mov    0x8(%ebp),%edx
  101b2e:	8b 52 30             	mov    0x30(%edx),%edx
  101b31:	89 44 24 08          	mov    %eax,0x8(%esp)
  101b35:	89 54 24 04          	mov    %edx,0x4(%esp)
  101b39:	c7 04 24 30 65 10 00 	movl   $0x106530,(%esp)
  101b40:	e8 58 e7 ff ff       	call   10029d <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101b45:	8b 45 08             	mov    0x8(%ebp),%eax
  101b48:	8b 40 34             	mov    0x34(%eax),%eax
  101b4b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b4f:	c7 04 24 42 65 10 00 	movl   $0x106542,(%esp)
  101b56:	e8 42 e7 ff ff       	call   10029d <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  101b5e:	8b 40 38             	mov    0x38(%eax),%eax
  101b61:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b65:	c7 04 24 51 65 10 00 	movl   $0x106551,(%esp)
  101b6c:	e8 2c e7 ff ff       	call   10029d <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101b71:	8b 45 08             	mov    0x8(%ebp),%eax
  101b74:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101b78:	0f b7 c0             	movzwl %ax,%eax
  101b7b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b7f:	c7 04 24 60 65 10 00 	movl   $0x106560,(%esp)
  101b86:	e8 12 e7 ff ff       	call   10029d <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  101b8e:	8b 40 40             	mov    0x40(%eax),%eax
  101b91:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b95:	c7 04 24 73 65 10 00 	movl   $0x106573,(%esp)
  101b9c:	e8 fc e6 ff ff       	call   10029d <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101ba1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101ba8:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101baf:	eb 3e                	jmp    101bef <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101bb1:	8b 45 08             	mov    0x8(%ebp),%eax
  101bb4:	8b 50 40             	mov    0x40(%eax),%edx
  101bb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101bba:	21 d0                	and    %edx,%eax
  101bbc:	85 c0                	test   %eax,%eax
  101bbe:	74 28                	je     101be8 <print_trapframe+0x157>
  101bc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101bc3:	8b 04 85 80 75 11 00 	mov    0x117580(,%eax,4),%eax
  101bca:	85 c0                	test   %eax,%eax
  101bcc:	74 1a                	je     101be8 <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
  101bce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101bd1:	8b 04 85 80 75 11 00 	mov    0x117580(,%eax,4),%eax
  101bd8:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bdc:	c7 04 24 82 65 10 00 	movl   $0x106582,(%esp)
  101be3:	e8 b5 e6 ff ff       	call   10029d <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101be8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101bec:	d1 65 f0             	shll   -0x10(%ebp)
  101bef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101bf2:	83 f8 17             	cmp    $0x17,%eax
  101bf5:	76 ba                	jbe    101bb1 <print_trapframe+0x120>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101bf7:	8b 45 08             	mov    0x8(%ebp),%eax
  101bfa:	8b 40 40             	mov    0x40(%eax),%eax
  101bfd:	25 00 30 00 00       	and    $0x3000,%eax
  101c02:	c1 e8 0c             	shr    $0xc,%eax
  101c05:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c09:	c7 04 24 86 65 10 00 	movl   $0x106586,(%esp)
  101c10:	e8 88 e6 ff ff       	call   10029d <cprintf>

    if (!trap_in_kernel(tf)) {
  101c15:	8b 45 08             	mov    0x8(%ebp),%eax
  101c18:	89 04 24             	mov    %eax,(%esp)
  101c1b:	e8 5b fe ff ff       	call   101a7b <trap_in_kernel>
  101c20:	85 c0                	test   %eax,%eax
  101c22:	75 30                	jne    101c54 <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101c24:	8b 45 08             	mov    0x8(%ebp),%eax
  101c27:	8b 40 44             	mov    0x44(%eax),%eax
  101c2a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c2e:	c7 04 24 8f 65 10 00 	movl   $0x10658f,(%esp)
  101c35:	e8 63 e6 ff ff       	call   10029d <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101c3a:	8b 45 08             	mov    0x8(%ebp),%eax
  101c3d:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101c41:	0f b7 c0             	movzwl %ax,%eax
  101c44:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c48:	c7 04 24 9e 65 10 00 	movl   $0x10659e,(%esp)
  101c4f:	e8 49 e6 ff ff       	call   10029d <cprintf>
    }
}
  101c54:	c9                   	leave  
  101c55:	c3                   	ret    

00101c56 <print_regs>:

void
print_regs(struct pushregs *regs) {
  101c56:	55                   	push   %ebp
  101c57:	89 e5                	mov    %esp,%ebp
  101c59:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101c5c:	8b 45 08             	mov    0x8(%ebp),%eax
  101c5f:	8b 00                	mov    (%eax),%eax
  101c61:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c65:	c7 04 24 b1 65 10 00 	movl   $0x1065b1,(%esp)
  101c6c:	e8 2c e6 ff ff       	call   10029d <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101c71:	8b 45 08             	mov    0x8(%ebp),%eax
  101c74:	8b 40 04             	mov    0x4(%eax),%eax
  101c77:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c7b:	c7 04 24 c0 65 10 00 	movl   $0x1065c0,(%esp)
  101c82:	e8 16 e6 ff ff       	call   10029d <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101c87:	8b 45 08             	mov    0x8(%ebp),%eax
  101c8a:	8b 40 08             	mov    0x8(%eax),%eax
  101c8d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c91:	c7 04 24 cf 65 10 00 	movl   $0x1065cf,(%esp)
  101c98:	e8 00 e6 ff ff       	call   10029d <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  101ca0:	8b 40 0c             	mov    0xc(%eax),%eax
  101ca3:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ca7:	c7 04 24 de 65 10 00 	movl   $0x1065de,(%esp)
  101cae:	e8 ea e5 ff ff       	call   10029d <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101cb3:	8b 45 08             	mov    0x8(%ebp),%eax
  101cb6:	8b 40 10             	mov    0x10(%eax),%eax
  101cb9:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cbd:	c7 04 24 ed 65 10 00 	movl   $0x1065ed,(%esp)
  101cc4:	e8 d4 e5 ff ff       	call   10029d <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  101ccc:	8b 40 14             	mov    0x14(%eax),%eax
  101ccf:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cd3:	c7 04 24 fc 65 10 00 	movl   $0x1065fc,(%esp)
  101cda:	e8 be e5 ff ff       	call   10029d <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101cdf:	8b 45 08             	mov    0x8(%ebp),%eax
  101ce2:	8b 40 18             	mov    0x18(%eax),%eax
  101ce5:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ce9:	c7 04 24 0b 66 10 00 	movl   $0x10660b,(%esp)
  101cf0:	e8 a8 e5 ff ff       	call   10029d <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  101cf8:	8b 40 1c             	mov    0x1c(%eax),%eax
  101cfb:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cff:	c7 04 24 1a 66 10 00 	movl   $0x10661a,(%esp)
  101d06:	e8 92 e5 ff ff       	call   10029d <cprintf>
}
  101d0b:	c9                   	leave  
  101d0c:	c3                   	ret    

00101d0d <trap_dispatch>:
/* temporary trapframe or pointer to trapframe */
struct trapframe switchk2u, *switchu2k;

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101d0d:	55                   	push   %ebp
  101d0e:	89 e5                	mov    %esp,%ebp
  101d10:	57                   	push   %edi
  101d11:	56                   	push   %esi
  101d12:	53                   	push   %ebx
  101d13:	83 ec 2c             	sub    $0x2c,%esp
    char c;

    switch (tf->tf_trapno) {
  101d16:	8b 45 08             	mov    0x8(%ebp),%eax
  101d19:	8b 40 30             	mov    0x30(%eax),%eax
  101d1c:	83 f8 2f             	cmp    $0x2f,%eax
  101d1f:	77 21                	ja     101d42 <trap_dispatch+0x35>
  101d21:	83 f8 2e             	cmp    $0x2e,%eax
  101d24:	0f 83 ec 01 00 00    	jae    101f16 <trap_dispatch+0x209>
  101d2a:	83 f8 21             	cmp    $0x21,%eax
  101d2d:	0f 84 8a 00 00 00    	je     101dbd <trap_dispatch+0xb0>
  101d33:	83 f8 24             	cmp    $0x24,%eax
  101d36:	74 5c                	je     101d94 <trap_dispatch+0x87>
  101d38:	83 f8 20             	cmp    $0x20,%eax
  101d3b:	74 1c                	je     101d59 <trap_dispatch+0x4c>
  101d3d:	e9 9c 01 00 00       	jmp    101ede <trap_dispatch+0x1d1>
  101d42:	83 f8 78             	cmp    $0x78,%eax
  101d45:	0f 84 9b 00 00 00    	je     101de6 <trap_dispatch+0xd9>
  101d4b:	83 f8 79             	cmp    $0x79,%eax
  101d4e:	0f 84 11 01 00 00    	je     101e65 <trap_dispatch+0x158>
  101d54:	e9 85 01 00 00       	jmp    101ede <trap_dispatch+0x1d1>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
    	ticks ++;
  101d59:	a1 0c af 11 00       	mov    0x11af0c,%eax
  101d5e:	83 c0 01             	add    $0x1,%eax
  101d61:	a3 0c af 11 00       	mov    %eax,0x11af0c
    	if (ticks % TICK_NUM == 0)
  101d66:	8b 0d 0c af 11 00    	mov    0x11af0c,%ecx
  101d6c:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101d71:	89 c8                	mov    %ecx,%eax
  101d73:	f7 e2                	mul    %edx
  101d75:	89 d0                	mov    %edx,%eax
  101d77:	c1 e8 05             	shr    $0x5,%eax
  101d7a:	6b c0 64             	imul   $0x64,%eax,%eax
  101d7d:	29 c1                	sub    %eax,%ecx
  101d7f:	89 c8                	mov    %ecx,%eax
  101d81:	85 c0                	test   %eax,%eax
  101d83:	75 0a                	jne    101d8f <trap_dispatch+0x82>
    	{
    		print_ticks();
  101d85:	e8 0e fb ff ff       	call   101898 <print_ticks>
    	}
        break;
  101d8a:	e9 88 01 00 00       	jmp    101f17 <trap_dispatch+0x20a>
  101d8f:	e9 83 01 00 00       	jmp    101f17 <trap_dispatch+0x20a>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101d94:	e8 c3 f8 ff ff       	call   10165c <cons_getc>
  101d99:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101d9c:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101da0:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101da4:	89 54 24 08          	mov    %edx,0x8(%esp)
  101da8:	89 44 24 04          	mov    %eax,0x4(%esp)
  101dac:	c7 04 24 29 66 10 00 	movl   $0x106629,(%esp)
  101db3:	e8 e5 e4 ff ff       	call   10029d <cprintf>
        break;
  101db8:	e9 5a 01 00 00       	jmp    101f17 <trap_dispatch+0x20a>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101dbd:	e8 9a f8 ff ff       	call   10165c <cons_getc>
  101dc2:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101dc5:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101dc9:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101dcd:	89 54 24 08          	mov    %edx,0x8(%esp)
  101dd1:	89 44 24 04          	mov    %eax,0x4(%esp)
  101dd5:	c7 04 24 3b 66 10 00 	movl   $0x10663b,(%esp)
  101ddc:	e8 bc e4 ff ff       	call   10029d <cprintf>
        break;
  101de1:	e9 31 01 00 00       	jmp    101f17 <trap_dispatch+0x20a>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    	if(tf->tf_cs !=  USER_CS)
  101de6:	8b 45 08             	mov    0x8(%ebp),%eax
  101de9:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101ded:	66 83 f8 1b          	cmp    $0x1b,%ax
  101df1:	74 6d                	je     101e60 <trap_dispatch+0x153>
    	{
    		switchk2u = *tf;
  101df3:	8b 45 08             	mov    0x8(%ebp),%eax
  101df6:	ba 20 af 11 00       	mov    $0x11af20,%edx
  101dfb:	89 c3                	mov    %eax,%ebx
  101dfd:	b8 13 00 00 00       	mov    $0x13,%eax
  101e02:	89 d7                	mov    %edx,%edi
  101e04:	89 de                	mov    %ebx,%esi
  101e06:	89 c1                	mov    %eax,%ecx
  101e08:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    		switchk2u.tf_cs =  USER_CS;
  101e0a:	66 c7 05 5c af 11 00 	movw   $0x1b,0x11af5c
  101e11:	1b 00 
    		switchk2u.tf_ds = switchk2u.tf_es = switchk2u.tf_ss = USER_DS;
  101e13:	66 c7 05 68 af 11 00 	movw   $0x23,0x11af68
  101e1a:	23 00 
  101e1c:	0f b7 05 68 af 11 00 	movzwl 0x11af68,%eax
  101e23:	66 a3 48 af 11 00    	mov    %ax,0x11af48
  101e29:	0f b7 05 48 af 11 00 	movzwl 0x11af48,%eax
  101e30:	66 a3 4c af 11 00    	mov    %ax,0x11af4c
    		switchk2u.tf_eflags |= FL_IOPL_MASK;
  101e36:	a1 60 af 11 00       	mov    0x11af60,%eax
  101e3b:	80 cc 30             	or     $0x30,%ah
  101e3e:	a3 60 af 11 00       	mov    %eax,0x11af60
    	    switchk2u.tf_esp = (uint32_t)tf + sizeof(struct trapframe) - 8;
  101e43:	8b 45 08             	mov    0x8(%ebp),%eax
  101e46:	83 c0 44             	add    $0x44,%eax
  101e49:	a3 64 af 11 00       	mov    %eax,0x11af64

    	    *((uint32_t *) tf - 1) = (uint32_t) &switchk2u;
  101e4e:	8b 45 08             	mov    0x8(%ebp),%eax
  101e51:	8d 50 fc             	lea    -0x4(%eax),%edx
  101e54:	b8 20 af 11 00       	mov    $0x11af20,%eax
  101e59:	89 02                	mov    %eax,(%edx)
    	}
    	break;
  101e5b:	e9 b7 00 00 00       	jmp    101f17 <trap_dispatch+0x20a>
  101e60:	e9 b2 00 00 00       	jmp    101f17 <trap_dispatch+0x20a>
    case T_SWITCH_TOK:
    	if(tf->tf_cs != KERNEL_CS)
  101e65:	8b 45 08             	mov    0x8(%ebp),%eax
  101e68:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101e6c:	66 83 f8 08          	cmp    $0x8,%ax
  101e70:	74 6a                	je     101edc <trap_dispatch+0x1cf>
    	{
    		tf->tf_cs = KERNEL_CS;
  101e72:	8b 45 08             	mov    0x8(%ebp),%eax
  101e75:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
    		tf->tf_ds = tf->tf_es = KERNEL_DS;
  101e7b:	8b 45 08             	mov    0x8(%ebp),%eax
  101e7e:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
  101e84:	8b 45 08             	mov    0x8(%ebp),%eax
  101e87:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  101e8e:	66 89 50 2c          	mov    %dx,0x2c(%eax)
    		tf->tf_eflags &= ~FL_IOPL_MASK;
  101e92:	8b 45 08             	mov    0x8(%ebp),%eax
  101e95:	8b 40 40             	mov    0x40(%eax),%eax
  101e98:	80 e4 cf             	and    $0xcf,%ah
  101e9b:	89 c2                	mov    %eax,%edx
  101e9d:	8b 45 08             	mov    0x8(%ebp),%eax
  101ea0:	89 50 40             	mov    %edx,0x40(%eax)
    		switchu2k = (struct trapframe *)(tf->tf_esp - (sizeof(struct trapframe) - 8));
  101ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  101ea6:	8b 40 44             	mov    0x44(%eax),%eax
  101ea9:	83 e8 44             	sub    $0x44,%eax
  101eac:	a3 6c af 11 00       	mov    %eax,0x11af6c
    		memmove(switchu2k, tf, sizeof(struct trapframe) - 8);
  101eb1:	a1 6c af 11 00       	mov    0x11af6c,%eax
  101eb6:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  101ebd:	00 
  101ebe:	8b 55 08             	mov    0x8(%ebp),%edx
  101ec1:	89 54 24 04          	mov    %edx,0x4(%esp)
  101ec5:	89 04 24             	mov    %eax,(%esp)
  101ec8:	e8 32 3a 00 00       	call   1058ff <memmove>
    		*((uint32_t *) tf - 1) = (uint32_t) switchu2k;
  101ecd:	8b 45 08             	mov    0x8(%ebp),%eax
  101ed0:	8d 50 fc             	lea    -0x4(%eax),%edx
  101ed3:	a1 6c af 11 00       	mov    0x11af6c,%eax
  101ed8:	89 02                	mov    %eax,(%edx)
    	}
        break;
  101eda:	eb 3b                	jmp    101f17 <trap_dispatch+0x20a>
  101edc:	eb 39                	jmp    101f17 <trap_dispatch+0x20a>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101ede:	8b 45 08             	mov    0x8(%ebp),%eax
  101ee1:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101ee5:	0f b7 c0             	movzwl %ax,%eax
  101ee8:	83 e0 03             	and    $0x3,%eax
  101eeb:	85 c0                	test   %eax,%eax
  101eed:	75 28                	jne    101f17 <trap_dispatch+0x20a>
            print_trapframe(tf);
  101eef:	8b 45 08             	mov    0x8(%ebp),%eax
  101ef2:	89 04 24             	mov    %eax,(%esp)
  101ef5:	e8 97 fb ff ff       	call   101a91 <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101efa:	c7 44 24 08 4a 66 10 	movl   $0x10664a,0x8(%esp)
  101f01:	00 
  101f02:	c7 44 24 04 d7 00 00 	movl   $0xd7,0x4(%esp)
  101f09:	00 
  101f0a:	c7 04 24 6e 64 10 00 	movl   $0x10646e,(%esp)
  101f11:	e8 de e4 ff ff       	call   1003f4 <__panic>
        break;
  101f16:	90                   	nop
        }
    }
}
  101f17:	83 c4 2c             	add    $0x2c,%esp
  101f1a:	5b                   	pop    %ebx
  101f1b:	5e                   	pop    %esi
  101f1c:	5f                   	pop    %edi
  101f1d:	5d                   	pop    %ebp
  101f1e:	c3                   	ret    

00101f1f <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101f1f:	55                   	push   %ebp
  101f20:	89 e5                	mov    %esp,%ebp
  101f22:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101f25:	8b 45 08             	mov    0x8(%ebp),%eax
  101f28:	89 04 24             	mov    %eax,(%esp)
  101f2b:	e8 dd fd ff ff       	call   101d0d <trap_dispatch>
}
  101f30:	c9                   	leave  
  101f31:	c3                   	ret    

00101f32 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101f32:	6a 00                	push   $0x0
  pushl $0
  101f34:	6a 00                	push   $0x0
  jmp __alltraps
  101f36:	e9 69 0a 00 00       	jmp    1029a4 <__alltraps>

00101f3b <vector1>:
.globl vector1
vector1:
  pushl $0
  101f3b:	6a 00                	push   $0x0
  pushl $1
  101f3d:	6a 01                	push   $0x1
  jmp __alltraps
  101f3f:	e9 60 0a 00 00       	jmp    1029a4 <__alltraps>

00101f44 <vector2>:
.globl vector2
vector2:
  pushl $0
  101f44:	6a 00                	push   $0x0
  pushl $2
  101f46:	6a 02                	push   $0x2
  jmp __alltraps
  101f48:	e9 57 0a 00 00       	jmp    1029a4 <__alltraps>

00101f4d <vector3>:
.globl vector3
vector3:
  pushl $0
  101f4d:	6a 00                	push   $0x0
  pushl $3
  101f4f:	6a 03                	push   $0x3
  jmp __alltraps
  101f51:	e9 4e 0a 00 00       	jmp    1029a4 <__alltraps>

00101f56 <vector4>:
.globl vector4
vector4:
  pushl $0
  101f56:	6a 00                	push   $0x0
  pushl $4
  101f58:	6a 04                	push   $0x4
  jmp __alltraps
  101f5a:	e9 45 0a 00 00       	jmp    1029a4 <__alltraps>

00101f5f <vector5>:
.globl vector5
vector5:
  pushl $0
  101f5f:	6a 00                	push   $0x0
  pushl $5
  101f61:	6a 05                	push   $0x5
  jmp __alltraps
  101f63:	e9 3c 0a 00 00       	jmp    1029a4 <__alltraps>

00101f68 <vector6>:
.globl vector6
vector6:
  pushl $0
  101f68:	6a 00                	push   $0x0
  pushl $6
  101f6a:	6a 06                	push   $0x6
  jmp __alltraps
  101f6c:	e9 33 0a 00 00       	jmp    1029a4 <__alltraps>

00101f71 <vector7>:
.globl vector7
vector7:
  pushl $0
  101f71:	6a 00                	push   $0x0
  pushl $7
  101f73:	6a 07                	push   $0x7
  jmp __alltraps
  101f75:	e9 2a 0a 00 00       	jmp    1029a4 <__alltraps>

00101f7a <vector8>:
.globl vector8
vector8:
  pushl $8
  101f7a:	6a 08                	push   $0x8
  jmp __alltraps
  101f7c:	e9 23 0a 00 00       	jmp    1029a4 <__alltraps>

00101f81 <vector9>:
.globl vector9
vector9:
  pushl $0
  101f81:	6a 00                	push   $0x0
  pushl $9
  101f83:	6a 09                	push   $0x9
  jmp __alltraps
  101f85:	e9 1a 0a 00 00       	jmp    1029a4 <__alltraps>

00101f8a <vector10>:
.globl vector10
vector10:
  pushl $10
  101f8a:	6a 0a                	push   $0xa
  jmp __alltraps
  101f8c:	e9 13 0a 00 00       	jmp    1029a4 <__alltraps>

00101f91 <vector11>:
.globl vector11
vector11:
  pushl $11
  101f91:	6a 0b                	push   $0xb
  jmp __alltraps
  101f93:	e9 0c 0a 00 00       	jmp    1029a4 <__alltraps>

00101f98 <vector12>:
.globl vector12
vector12:
  pushl $12
  101f98:	6a 0c                	push   $0xc
  jmp __alltraps
  101f9a:	e9 05 0a 00 00       	jmp    1029a4 <__alltraps>

00101f9f <vector13>:
.globl vector13
vector13:
  pushl $13
  101f9f:	6a 0d                	push   $0xd
  jmp __alltraps
  101fa1:	e9 fe 09 00 00       	jmp    1029a4 <__alltraps>

00101fa6 <vector14>:
.globl vector14
vector14:
  pushl $14
  101fa6:	6a 0e                	push   $0xe
  jmp __alltraps
  101fa8:	e9 f7 09 00 00       	jmp    1029a4 <__alltraps>

00101fad <vector15>:
.globl vector15
vector15:
  pushl $0
  101fad:	6a 00                	push   $0x0
  pushl $15
  101faf:	6a 0f                	push   $0xf
  jmp __alltraps
  101fb1:	e9 ee 09 00 00       	jmp    1029a4 <__alltraps>

00101fb6 <vector16>:
.globl vector16
vector16:
  pushl $0
  101fb6:	6a 00                	push   $0x0
  pushl $16
  101fb8:	6a 10                	push   $0x10
  jmp __alltraps
  101fba:	e9 e5 09 00 00       	jmp    1029a4 <__alltraps>

00101fbf <vector17>:
.globl vector17
vector17:
  pushl $17
  101fbf:	6a 11                	push   $0x11
  jmp __alltraps
  101fc1:	e9 de 09 00 00       	jmp    1029a4 <__alltraps>

00101fc6 <vector18>:
.globl vector18
vector18:
  pushl $0
  101fc6:	6a 00                	push   $0x0
  pushl $18
  101fc8:	6a 12                	push   $0x12
  jmp __alltraps
  101fca:	e9 d5 09 00 00       	jmp    1029a4 <__alltraps>

00101fcf <vector19>:
.globl vector19
vector19:
  pushl $0
  101fcf:	6a 00                	push   $0x0
  pushl $19
  101fd1:	6a 13                	push   $0x13
  jmp __alltraps
  101fd3:	e9 cc 09 00 00       	jmp    1029a4 <__alltraps>

00101fd8 <vector20>:
.globl vector20
vector20:
  pushl $0
  101fd8:	6a 00                	push   $0x0
  pushl $20
  101fda:	6a 14                	push   $0x14
  jmp __alltraps
  101fdc:	e9 c3 09 00 00       	jmp    1029a4 <__alltraps>

00101fe1 <vector21>:
.globl vector21
vector21:
  pushl $0
  101fe1:	6a 00                	push   $0x0
  pushl $21
  101fe3:	6a 15                	push   $0x15
  jmp __alltraps
  101fe5:	e9 ba 09 00 00       	jmp    1029a4 <__alltraps>

00101fea <vector22>:
.globl vector22
vector22:
  pushl $0
  101fea:	6a 00                	push   $0x0
  pushl $22
  101fec:	6a 16                	push   $0x16
  jmp __alltraps
  101fee:	e9 b1 09 00 00       	jmp    1029a4 <__alltraps>

00101ff3 <vector23>:
.globl vector23
vector23:
  pushl $0
  101ff3:	6a 00                	push   $0x0
  pushl $23
  101ff5:	6a 17                	push   $0x17
  jmp __alltraps
  101ff7:	e9 a8 09 00 00       	jmp    1029a4 <__alltraps>

00101ffc <vector24>:
.globl vector24
vector24:
  pushl $0
  101ffc:	6a 00                	push   $0x0
  pushl $24
  101ffe:	6a 18                	push   $0x18
  jmp __alltraps
  102000:	e9 9f 09 00 00       	jmp    1029a4 <__alltraps>

00102005 <vector25>:
.globl vector25
vector25:
  pushl $0
  102005:	6a 00                	push   $0x0
  pushl $25
  102007:	6a 19                	push   $0x19
  jmp __alltraps
  102009:	e9 96 09 00 00       	jmp    1029a4 <__alltraps>

0010200e <vector26>:
.globl vector26
vector26:
  pushl $0
  10200e:	6a 00                	push   $0x0
  pushl $26
  102010:	6a 1a                	push   $0x1a
  jmp __alltraps
  102012:	e9 8d 09 00 00       	jmp    1029a4 <__alltraps>

00102017 <vector27>:
.globl vector27
vector27:
  pushl $0
  102017:	6a 00                	push   $0x0
  pushl $27
  102019:	6a 1b                	push   $0x1b
  jmp __alltraps
  10201b:	e9 84 09 00 00       	jmp    1029a4 <__alltraps>

00102020 <vector28>:
.globl vector28
vector28:
  pushl $0
  102020:	6a 00                	push   $0x0
  pushl $28
  102022:	6a 1c                	push   $0x1c
  jmp __alltraps
  102024:	e9 7b 09 00 00       	jmp    1029a4 <__alltraps>

00102029 <vector29>:
.globl vector29
vector29:
  pushl $0
  102029:	6a 00                	push   $0x0
  pushl $29
  10202b:	6a 1d                	push   $0x1d
  jmp __alltraps
  10202d:	e9 72 09 00 00       	jmp    1029a4 <__alltraps>

00102032 <vector30>:
.globl vector30
vector30:
  pushl $0
  102032:	6a 00                	push   $0x0
  pushl $30
  102034:	6a 1e                	push   $0x1e
  jmp __alltraps
  102036:	e9 69 09 00 00       	jmp    1029a4 <__alltraps>

0010203b <vector31>:
.globl vector31
vector31:
  pushl $0
  10203b:	6a 00                	push   $0x0
  pushl $31
  10203d:	6a 1f                	push   $0x1f
  jmp __alltraps
  10203f:	e9 60 09 00 00       	jmp    1029a4 <__alltraps>

00102044 <vector32>:
.globl vector32
vector32:
  pushl $0
  102044:	6a 00                	push   $0x0
  pushl $32
  102046:	6a 20                	push   $0x20
  jmp __alltraps
  102048:	e9 57 09 00 00       	jmp    1029a4 <__alltraps>

0010204d <vector33>:
.globl vector33
vector33:
  pushl $0
  10204d:	6a 00                	push   $0x0
  pushl $33
  10204f:	6a 21                	push   $0x21
  jmp __alltraps
  102051:	e9 4e 09 00 00       	jmp    1029a4 <__alltraps>

00102056 <vector34>:
.globl vector34
vector34:
  pushl $0
  102056:	6a 00                	push   $0x0
  pushl $34
  102058:	6a 22                	push   $0x22
  jmp __alltraps
  10205a:	e9 45 09 00 00       	jmp    1029a4 <__alltraps>

0010205f <vector35>:
.globl vector35
vector35:
  pushl $0
  10205f:	6a 00                	push   $0x0
  pushl $35
  102061:	6a 23                	push   $0x23
  jmp __alltraps
  102063:	e9 3c 09 00 00       	jmp    1029a4 <__alltraps>

00102068 <vector36>:
.globl vector36
vector36:
  pushl $0
  102068:	6a 00                	push   $0x0
  pushl $36
  10206a:	6a 24                	push   $0x24
  jmp __alltraps
  10206c:	e9 33 09 00 00       	jmp    1029a4 <__alltraps>

00102071 <vector37>:
.globl vector37
vector37:
  pushl $0
  102071:	6a 00                	push   $0x0
  pushl $37
  102073:	6a 25                	push   $0x25
  jmp __alltraps
  102075:	e9 2a 09 00 00       	jmp    1029a4 <__alltraps>

0010207a <vector38>:
.globl vector38
vector38:
  pushl $0
  10207a:	6a 00                	push   $0x0
  pushl $38
  10207c:	6a 26                	push   $0x26
  jmp __alltraps
  10207e:	e9 21 09 00 00       	jmp    1029a4 <__alltraps>

00102083 <vector39>:
.globl vector39
vector39:
  pushl $0
  102083:	6a 00                	push   $0x0
  pushl $39
  102085:	6a 27                	push   $0x27
  jmp __alltraps
  102087:	e9 18 09 00 00       	jmp    1029a4 <__alltraps>

0010208c <vector40>:
.globl vector40
vector40:
  pushl $0
  10208c:	6a 00                	push   $0x0
  pushl $40
  10208e:	6a 28                	push   $0x28
  jmp __alltraps
  102090:	e9 0f 09 00 00       	jmp    1029a4 <__alltraps>

00102095 <vector41>:
.globl vector41
vector41:
  pushl $0
  102095:	6a 00                	push   $0x0
  pushl $41
  102097:	6a 29                	push   $0x29
  jmp __alltraps
  102099:	e9 06 09 00 00       	jmp    1029a4 <__alltraps>

0010209e <vector42>:
.globl vector42
vector42:
  pushl $0
  10209e:	6a 00                	push   $0x0
  pushl $42
  1020a0:	6a 2a                	push   $0x2a
  jmp __alltraps
  1020a2:	e9 fd 08 00 00       	jmp    1029a4 <__alltraps>

001020a7 <vector43>:
.globl vector43
vector43:
  pushl $0
  1020a7:	6a 00                	push   $0x0
  pushl $43
  1020a9:	6a 2b                	push   $0x2b
  jmp __alltraps
  1020ab:	e9 f4 08 00 00       	jmp    1029a4 <__alltraps>

001020b0 <vector44>:
.globl vector44
vector44:
  pushl $0
  1020b0:	6a 00                	push   $0x0
  pushl $44
  1020b2:	6a 2c                	push   $0x2c
  jmp __alltraps
  1020b4:	e9 eb 08 00 00       	jmp    1029a4 <__alltraps>

001020b9 <vector45>:
.globl vector45
vector45:
  pushl $0
  1020b9:	6a 00                	push   $0x0
  pushl $45
  1020bb:	6a 2d                	push   $0x2d
  jmp __alltraps
  1020bd:	e9 e2 08 00 00       	jmp    1029a4 <__alltraps>

001020c2 <vector46>:
.globl vector46
vector46:
  pushl $0
  1020c2:	6a 00                	push   $0x0
  pushl $46
  1020c4:	6a 2e                	push   $0x2e
  jmp __alltraps
  1020c6:	e9 d9 08 00 00       	jmp    1029a4 <__alltraps>

001020cb <vector47>:
.globl vector47
vector47:
  pushl $0
  1020cb:	6a 00                	push   $0x0
  pushl $47
  1020cd:	6a 2f                	push   $0x2f
  jmp __alltraps
  1020cf:	e9 d0 08 00 00       	jmp    1029a4 <__alltraps>

001020d4 <vector48>:
.globl vector48
vector48:
  pushl $0
  1020d4:	6a 00                	push   $0x0
  pushl $48
  1020d6:	6a 30                	push   $0x30
  jmp __alltraps
  1020d8:	e9 c7 08 00 00       	jmp    1029a4 <__alltraps>

001020dd <vector49>:
.globl vector49
vector49:
  pushl $0
  1020dd:	6a 00                	push   $0x0
  pushl $49
  1020df:	6a 31                	push   $0x31
  jmp __alltraps
  1020e1:	e9 be 08 00 00       	jmp    1029a4 <__alltraps>

001020e6 <vector50>:
.globl vector50
vector50:
  pushl $0
  1020e6:	6a 00                	push   $0x0
  pushl $50
  1020e8:	6a 32                	push   $0x32
  jmp __alltraps
  1020ea:	e9 b5 08 00 00       	jmp    1029a4 <__alltraps>

001020ef <vector51>:
.globl vector51
vector51:
  pushl $0
  1020ef:	6a 00                	push   $0x0
  pushl $51
  1020f1:	6a 33                	push   $0x33
  jmp __alltraps
  1020f3:	e9 ac 08 00 00       	jmp    1029a4 <__alltraps>

001020f8 <vector52>:
.globl vector52
vector52:
  pushl $0
  1020f8:	6a 00                	push   $0x0
  pushl $52
  1020fa:	6a 34                	push   $0x34
  jmp __alltraps
  1020fc:	e9 a3 08 00 00       	jmp    1029a4 <__alltraps>

00102101 <vector53>:
.globl vector53
vector53:
  pushl $0
  102101:	6a 00                	push   $0x0
  pushl $53
  102103:	6a 35                	push   $0x35
  jmp __alltraps
  102105:	e9 9a 08 00 00       	jmp    1029a4 <__alltraps>

0010210a <vector54>:
.globl vector54
vector54:
  pushl $0
  10210a:	6a 00                	push   $0x0
  pushl $54
  10210c:	6a 36                	push   $0x36
  jmp __alltraps
  10210e:	e9 91 08 00 00       	jmp    1029a4 <__alltraps>

00102113 <vector55>:
.globl vector55
vector55:
  pushl $0
  102113:	6a 00                	push   $0x0
  pushl $55
  102115:	6a 37                	push   $0x37
  jmp __alltraps
  102117:	e9 88 08 00 00       	jmp    1029a4 <__alltraps>

0010211c <vector56>:
.globl vector56
vector56:
  pushl $0
  10211c:	6a 00                	push   $0x0
  pushl $56
  10211e:	6a 38                	push   $0x38
  jmp __alltraps
  102120:	e9 7f 08 00 00       	jmp    1029a4 <__alltraps>

00102125 <vector57>:
.globl vector57
vector57:
  pushl $0
  102125:	6a 00                	push   $0x0
  pushl $57
  102127:	6a 39                	push   $0x39
  jmp __alltraps
  102129:	e9 76 08 00 00       	jmp    1029a4 <__alltraps>

0010212e <vector58>:
.globl vector58
vector58:
  pushl $0
  10212e:	6a 00                	push   $0x0
  pushl $58
  102130:	6a 3a                	push   $0x3a
  jmp __alltraps
  102132:	e9 6d 08 00 00       	jmp    1029a4 <__alltraps>

00102137 <vector59>:
.globl vector59
vector59:
  pushl $0
  102137:	6a 00                	push   $0x0
  pushl $59
  102139:	6a 3b                	push   $0x3b
  jmp __alltraps
  10213b:	e9 64 08 00 00       	jmp    1029a4 <__alltraps>

00102140 <vector60>:
.globl vector60
vector60:
  pushl $0
  102140:	6a 00                	push   $0x0
  pushl $60
  102142:	6a 3c                	push   $0x3c
  jmp __alltraps
  102144:	e9 5b 08 00 00       	jmp    1029a4 <__alltraps>

00102149 <vector61>:
.globl vector61
vector61:
  pushl $0
  102149:	6a 00                	push   $0x0
  pushl $61
  10214b:	6a 3d                	push   $0x3d
  jmp __alltraps
  10214d:	e9 52 08 00 00       	jmp    1029a4 <__alltraps>

00102152 <vector62>:
.globl vector62
vector62:
  pushl $0
  102152:	6a 00                	push   $0x0
  pushl $62
  102154:	6a 3e                	push   $0x3e
  jmp __alltraps
  102156:	e9 49 08 00 00       	jmp    1029a4 <__alltraps>

0010215b <vector63>:
.globl vector63
vector63:
  pushl $0
  10215b:	6a 00                	push   $0x0
  pushl $63
  10215d:	6a 3f                	push   $0x3f
  jmp __alltraps
  10215f:	e9 40 08 00 00       	jmp    1029a4 <__alltraps>

00102164 <vector64>:
.globl vector64
vector64:
  pushl $0
  102164:	6a 00                	push   $0x0
  pushl $64
  102166:	6a 40                	push   $0x40
  jmp __alltraps
  102168:	e9 37 08 00 00       	jmp    1029a4 <__alltraps>

0010216d <vector65>:
.globl vector65
vector65:
  pushl $0
  10216d:	6a 00                	push   $0x0
  pushl $65
  10216f:	6a 41                	push   $0x41
  jmp __alltraps
  102171:	e9 2e 08 00 00       	jmp    1029a4 <__alltraps>

00102176 <vector66>:
.globl vector66
vector66:
  pushl $0
  102176:	6a 00                	push   $0x0
  pushl $66
  102178:	6a 42                	push   $0x42
  jmp __alltraps
  10217a:	e9 25 08 00 00       	jmp    1029a4 <__alltraps>

0010217f <vector67>:
.globl vector67
vector67:
  pushl $0
  10217f:	6a 00                	push   $0x0
  pushl $67
  102181:	6a 43                	push   $0x43
  jmp __alltraps
  102183:	e9 1c 08 00 00       	jmp    1029a4 <__alltraps>

00102188 <vector68>:
.globl vector68
vector68:
  pushl $0
  102188:	6a 00                	push   $0x0
  pushl $68
  10218a:	6a 44                	push   $0x44
  jmp __alltraps
  10218c:	e9 13 08 00 00       	jmp    1029a4 <__alltraps>

00102191 <vector69>:
.globl vector69
vector69:
  pushl $0
  102191:	6a 00                	push   $0x0
  pushl $69
  102193:	6a 45                	push   $0x45
  jmp __alltraps
  102195:	e9 0a 08 00 00       	jmp    1029a4 <__alltraps>

0010219a <vector70>:
.globl vector70
vector70:
  pushl $0
  10219a:	6a 00                	push   $0x0
  pushl $70
  10219c:	6a 46                	push   $0x46
  jmp __alltraps
  10219e:	e9 01 08 00 00       	jmp    1029a4 <__alltraps>

001021a3 <vector71>:
.globl vector71
vector71:
  pushl $0
  1021a3:	6a 00                	push   $0x0
  pushl $71
  1021a5:	6a 47                	push   $0x47
  jmp __alltraps
  1021a7:	e9 f8 07 00 00       	jmp    1029a4 <__alltraps>

001021ac <vector72>:
.globl vector72
vector72:
  pushl $0
  1021ac:	6a 00                	push   $0x0
  pushl $72
  1021ae:	6a 48                	push   $0x48
  jmp __alltraps
  1021b0:	e9 ef 07 00 00       	jmp    1029a4 <__alltraps>

001021b5 <vector73>:
.globl vector73
vector73:
  pushl $0
  1021b5:	6a 00                	push   $0x0
  pushl $73
  1021b7:	6a 49                	push   $0x49
  jmp __alltraps
  1021b9:	e9 e6 07 00 00       	jmp    1029a4 <__alltraps>

001021be <vector74>:
.globl vector74
vector74:
  pushl $0
  1021be:	6a 00                	push   $0x0
  pushl $74
  1021c0:	6a 4a                	push   $0x4a
  jmp __alltraps
  1021c2:	e9 dd 07 00 00       	jmp    1029a4 <__alltraps>

001021c7 <vector75>:
.globl vector75
vector75:
  pushl $0
  1021c7:	6a 00                	push   $0x0
  pushl $75
  1021c9:	6a 4b                	push   $0x4b
  jmp __alltraps
  1021cb:	e9 d4 07 00 00       	jmp    1029a4 <__alltraps>

001021d0 <vector76>:
.globl vector76
vector76:
  pushl $0
  1021d0:	6a 00                	push   $0x0
  pushl $76
  1021d2:	6a 4c                	push   $0x4c
  jmp __alltraps
  1021d4:	e9 cb 07 00 00       	jmp    1029a4 <__alltraps>

001021d9 <vector77>:
.globl vector77
vector77:
  pushl $0
  1021d9:	6a 00                	push   $0x0
  pushl $77
  1021db:	6a 4d                	push   $0x4d
  jmp __alltraps
  1021dd:	e9 c2 07 00 00       	jmp    1029a4 <__alltraps>

001021e2 <vector78>:
.globl vector78
vector78:
  pushl $0
  1021e2:	6a 00                	push   $0x0
  pushl $78
  1021e4:	6a 4e                	push   $0x4e
  jmp __alltraps
  1021e6:	e9 b9 07 00 00       	jmp    1029a4 <__alltraps>

001021eb <vector79>:
.globl vector79
vector79:
  pushl $0
  1021eb:	6a 00                	push   $0x0
  pushl $79
  1021ed:	6a 4f                	push   $0x4f
  jmp __alltraps
  1021ef:	e9 b0 07 00 00       	jmp    1029a4 <__alltraps>

001021f4 <vector80>:
.globl vector80
vector80:
  pushl $0
  1021f4:	6a 00                	push   $0x0
  pushl $80
  1021f6:	6a 50                	push   $0x50
  jmp __alltraps
  1021f8:	e9 a7 07 00 00       	jmp    1029a4 <__alltraps>

001021fd <vector81>:
.globl vector81
vector81:
  pushl $0
  1021fd:	6a 00                	push   $0x0
  pushl $81
  1021ff:	6a 51                	push   $0x51
  jmp __alltraps
  102201:	e9 9e 07 00 00       	jmp    1029a4 <__alltraps>

00102206 <vector82>:
.globl vector82
vector82:
  pushl $0
  102206:	6a 00                	push   $0x0
  pushl $82
  102208:	6a 52                	push   $0x52
  jmp __alltraps
  10220a:	e9 95 07 00 00       	jmp    1029a4 <__alltraps>

0010220f <vector83>:
.globl vector83
vector83:
  pushl $0
  10220f:	6a 00                	push   $0x0
  pushl $83
  102211:	6a 53                	push   $0x53
  jmp __alltraps
  102213:	e9 8c 07 00 00       	jmp    1029a4 <__alltraps>

00102218 <vector84>:
.globl vector84
vector84:
  pushl $0
  102218:	6a 00                	push   $0x0
  pushl $84
  10221a:	6a 54                	push   $0x54
  jmp __alltraps
  10221c:	e9 83 07 00 00       	jmp    1029a4 <__alltraps>

00102221 <vector85>:
.globl vector85
vector85:
  pushl $0
  102221:	6a 00                	push   $0x0
  pushl $85
  102223:	6a 55                	push   $0x55
  jmp __alltraps
  102225:	e9 7a 07 00 00       	jmp    1029a4 <__alltraps>

0010222a <vector86>:
.globl vector86
vector86:
  pushl $0
  10222a:	6a 00                	push   $0x0
  pushl $86
  10222c:	6a 56                	push   $0x56
  jmp __alltraps
  10222e:	e9 71 07 00 00       	jmp    1029a4 <__alltraps>

00102233 <vector87>:
.globl vector87
vector87:
  pushl $0
  102233:	6a 00                	push   $0x0
  pushl $87
  102235:	6a 57                	push   $0x57
  jmp __alltraps
  102237:	e9 68 07 00 00       	jmp    1029a4 <__alltraps>

0010223c <vector88>:
.globl vector88
vector88:
  pushl $0
  10223c:	6a 00                	push   $0x0
  pushl $88
  10223e:	6a 58                	push   $0x58
  jmp __alltraps
  102240:	e9 5f 07 00 00       	jmp    1029a4 <__alltraps>

00102245 <vector89>:
.globl vector89
vector89:
  pushl $0
  102245:	6a 00                	push   $0x0
  pushl $89
  102247:	6a 59                	push   $0x59
  jmp __alltraps
  102249:	e9 56 07 00 00       	jmp    1029a4 <__alltraps>

0010224e <vector90>:
.globl vector90
vector90:
  pushl $0
  10224e:	6a 00                	push   $0x0
  pushl $90
  102250:	6a 5a                	push   $0x5a
  jmp __alltraps
  102252:	e9 4d 07 00 00       	jmp    1029a4 <__alltraps>

00102257 <vector91>:
.globl vector91
vector91:
  pushl $0
  102257:	6a 00                	push   $0x0
  pushl $91
  102259:	6a 5b                	push   $0x5b
  jmp __alltraps
  10225b:	e9 44 07 00 00       	jmp    1029a4 <__alltraps>

00102260 <vector92>:
.globl vector92
vector92:
  pushl $0
  102260:	6a 00                	push   $0x0
  pushl $92
  102262:	6a 5c                	push   $0x5c
  jmp __alltraps
  102264:	e9 3b 07 00 00       	jmp    1029a4 <__alltraps>

00102269 <vector93>:
.globl vector93
vector93:
  pushl $0
  102269:	6a 00                	push   $0x0
  pushl $93
  10226b:	6a 5d                	push   $0x5d
  jmp __alltraps
  10226d:	e9 32 07 00 00       	jmp    1029a4 <__alltraps>

00102272 <vector94>:
.globl vector94
vector94:
  pushl $0
  102272:	6a 00                	push   $0x0
  pushl $94
  102274:	6a 5e                	push   $0x5e
  jmp __alltraps
  102276:	e9 29 07 00 00       	jmp    1029a4 <__alltraps>

0010227b <vector95>:
.globl vector95
vector95:
  pushl $0
  10227b:	6a 00                	push   $0x0
  pushl $95
  10227d:	6a 5f                	push   $0x5f
  jmp __alltraps
  10227f:	e9 20 07 00 00       	jmp    1029a4 <__alltraps>

00102284 <vector96>:
.globl vector96
vector96:
  pushl $0
  102284:	6a 00                	push   $0x0
  pushl $96
  102286:	6a 60                	push   $0x60
  jmp __alltraps
  102288:	e9 17 07 00 00       	jmp    1029a4 <__alltraps>

0010228d <vector97>:
.globl vector97
vector97:
  pushl $0
  10228d:	6a 00                	push   $0x0
  pushl $97
  10228f:	6a 61                	push   $0x61
  jmp __alltraps
  102291:	e9 0e 07 00 00       	jmp    1029a4 <__alltraps>

00102296 <vector98>:
.globl vector98
vector98:
  pushl $0
  102296:	6a 00                	push   $0x0
  pushl $98
  102298:	6a 62                	push   $0x62
  jmp __alltraps
  10229a:	e9 05 07 00 00       	jmp    1029a4 <__alltraps>

0010229f <vector99>:
.globl vector99
vector99:
  pushl $0
  10229f:	6a 00                	push   $0x0
  pushl $99
  1022a1:	6a 63                	push   $0x63
  jmp __alltraps
  1022a3:	e9 fc 06 00 00       	jmp    1029a4 <__alltraps>

001022a8 <vector100>:
.globl vector100
vector100:
  pushl $0
  1022a8:	6a 00                	push   $0x0
  pushl $100
  1022aa:	6a 64                	push   $0x64
  jmp __alltraps
  1022ac:	e9 f3 06 00 00       	jmp    1029a4 <__alltraps>

001022b1 <vector101>:
.globl vector101
vector101:
  pushl $0
  1022b1:	6a 00                	push   $0x0
  pushl $101
  1022b3:	6a 65                	push   $0x65
  jmp __alltraps
  1022b5:	e9 ea 06 00 00       	jmp    1029a4 <__alltraps>

001022ba <vector102>:
.globl vector102
vector102:
  pushl $0
  1022ba:	6a 00                	push   $0x0
  pushl $102
  1022bc:	6a 66                	push   $0x66
  jmp __alltraps
  1022be:	e9 e1 06 00 00       	jmp    1029a4 <__alltraps>

001022c3 <vector103>:
.globl vector103
vector103:
  pushl $0
  1022c3:	6a 00                	push   $0x0
  pushl $103
  1022c5:	6a 67                	push   $0x67
  jmp __alltraps
  1022c7:	e9 d8 06 00 00       	jmp    1029a4 <__alltraps>

001022cc <vector104>:
.globl vector104
vector104:
  pushl $0
  1022cc:	6a 00                	push   $0x0
  pushl $104
  1022ce:	6a 68                	push   $0x68
  jmp __alltraps
  1022d0:	e9 cf 06 00 00       	jmp    1029a4 <__alltraps>

001022d5 <vector105>:
.globl vector105
vector105:
  pushl $0
  1022d5:	6a 00                	push   $0x0
  pushl $105
  1022d7:	6a 69                	push   $0x69
  jmp __alltraps
  1022d9:	e9 c6 06 00 00       	jmp    1029a4 <__alltraps>

001022de <vector106>:
.globl vector106
vector106:
  pushl $0
  1022de:	6a 00                	push   $0x0
  pushl $106
  1022e0:	6a 6a                	push   $0x6a
  jmp __alltraps
  1022e2:	e9 bd 06 00 00       	jmp    1029a4 <__alltraps>

001022e7 <vector107>:
.globl vector107
vector107:
  pushl $0
  1022e7:	6a 00                	push   $0x0
  pushl $107
  1022e9:	6a 6b                	push   $0x6b
  jmp __alltraps
  1022eb:	e9 b4 06 00 00       	jmp    1029a4 <__alltraps>

001022f0 <vector108>:
.globl vector108
vector108:
  pushl $0
  1022f0:	6a 00                	push   $0x0
  pushl $108
  1022f2:	6a 6c                	push   $0x6c
  jmp __alltraps
  1022f4:	e9 ab 06 00 00       	jmp    1029a4 <__alltraps>

001022f9 <vector109>:
.globl vector109
vector109:
  pushl $0
  1022f9:	6a 00                	push   $0x0
  pushl $109
  1022fb:	6a 6d                	push   $0x6d
  jmp __alltraps
  1022fd:	e9 a2 06 00 00       	jmp    1029a4 <__alltraps>

00102302 <vector110>:
.globl vector110
vector110:
  pushl $0
  102302:	6a 00                	push   $0x0
  pushl $110
  102304:	6a 6e                	push   $0x6e
  jmp __alltraps
  102306:	e9 99 06 00 00       	jmp    1029a4 <__alltraps>

0010230b <vector111>:
.globl vector111
vector111:
  pushl $0
  10230b:	6a 00                	push   $0x0
  pushl $111
  10230d:	6a 6f                	push   $0x6f
  jmp __alltraps
  10230f:	e9 90 06 00 00       	jmp    1029a4 <__alltraps>

00102314 <vector112>:
.globl vector112
vector112:
  pushl $0
  102314:	6a 00                	push   $0x0
  pushl $112
  102316:	6a 70                	push   $0x70
  jmp __alltraps
  102318:	e9 87 06 00 00       	jmp    1029a4 <__alltraps>

0010231d <vector113>:
.globl vector113
vector113:
  pushl $0
  10231d:	6a 00                	push   $0x0
  pushl $113
  10231f:	6a 71                	push   $0x71
  jmp __alltraps
  102321:	e9 7e 06 00 00       	jmp    1029a4 <__alltraps>

00102326 <vector114>:
.globl vector114
vector114:
  pushl $0
  102326:	6a 00                	push   $0x0
  pushl $114
  102328:	6a 72                	push   $0x72
  jmp __alltraps
  10232a:	e9 75 06 00 00       	jmp    1029a4 <__alltraps>

0010232f <vector115>:
.globl vector115
vector115:
  pushl $0
  10232f:	6a 00                	push   $0x0
  pushl $115
  102331:	6a 73                	push   $0x73
  jmp __alltraps
  102333:	e9 6c 06 00 00       	jmp    1029a4 <__alltraps>

00102338 <vector116>:
.globl vector116
vector116:
  pushl $0
  102338:	6a 00                	push   $0x0
  pushl $116
  10233a:	6a 74                	push   $0x74
  jmp __alltraps
  10233c:	e9 63 06 00 00       	jmp    1029a4 <__alltraps>

00102341 <vector117>:
.globl vector117
vector117:
  pushl $0
  102341:	6a 00                	push   $0x0
  pushl $117
  102343:	6a 75                	push   $0x75
  jmp __alltraps
  102345:	e9 5a 06 00 00       	jmp    1029a4 <__alltraps>

0010234a <vector118>:
.globl vector118
vector118:
  pushl $0
  10234a:	6a 00                	push   $0x0
  pushl $118
  10234c:	6a 76                	push   $0x76
  jmp __alltraps
  10234e:	e9 51 06 00 00       	jmp    1029a4 <__alltraps>

00102353 <vector119>:
.globl vector119
vector119:
  pushl $0
  102353:	6a 00                	push   $0x0
  pushl $119
  102355:	6a 77                	push   $0x77
  jmp __alltraps
  102357:	e9 48 06 00 00       	jmp    1029a4 <__alltraps>

0010235c <vector120>:
.globl vector120
vector120:
  pushl $0
  10235c:	6a 00                	push   $0x0
  pushl $120
  10235e:	6a 78                	push   $0x78
  jmp __alltraps
  102360:	e9 3f 06 00 00       	jmp    1029a4 <__alltraps>

00102365 <vector121>:
.globl vector121
vector121:
  pushl $0
  102365:	6a 00                	push   $0x0
  pushl $121
  102367:	6a 79                	push   $0x79
  jmp __alltraps
  102369:	e9 36 06 00 00       	jmp    1029a4 <__alltraps>

0010236e <vector122>:
.globl vector122
vector122:
  pushl $0
  10236e:	6a 00                	push   $0x0
  pushl $122
  102370:	6a 7a                	push   $0x7a
  jmp __alltraps
  102372:	e9 2d 06 00 00       	jmp    1029a4 <__alltraps>

00102377 <vector123>:
.globl vector123
vector123:
  pushl $0
  102377:	6a 00                	push   $0x0
  pushl $123
  102379:	6a 7b                	push   $0x7b
  jmp __alltraps
  10237b:	e9 24 06 00 00       	jmp    1029a4 <__alltraps>

00102380 <vector124>:
.globl vector124
vector124:
  pushl $0
  102380:	6a 00                	push   $0x0
  pushl $124
  102382:	6a 7c                	push   $0x7c
  jmp __alltraps
  102384:	e9 1b 06 00 00       	jmp    1029a4 <__alltraps>

00102389 <vector125>:
.globl vector125
vector125:
  pushl $0
  102389:	6a 00                	push   $0x0
  pushl $125
  10238b:	6a 7d                	push   $0x7d
  jmp __alltraps
  10238d:	e9 12 06 00 00       	jmp    1029a4 <__alltraps>

00102392 <vector126>:
.globl vector126
vector126:
  pushl $0
  102392:	6a 00                	push   $0x0
  pushl $126
  102394:	6a 7e                	push   $0x7e
  jmp __alltraps
  102396:	e9 09 06 00 00       	jmp    1029a4 <__alltraps>

0010239b <vector127>:
.globl vector127
vector127:
  pushl $0
  10239b:	6a 00                	push   $0x0
  pushl $127
  10239d:	6a 7f                	push   $0x7f
  jmp __alltraps
  10239f:	e9 00 06 00 00       	jmp    1029a4 <__alltraps>

001023a4 <vector128>:
.globl vector128
vector128:
  pushl $0
  1023a4:	6a 00                	push   $0x0
  pushl $128
  1023a6:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  1023ab:	e9 f4 05 00 00       	jmp    1029a4 <__alltraps>

001023b0 <vector129>:
.globl vector129
vector129:
  pushl $0
  1023b0:	6a 00                	push   $0x0
  pushl $129
  1023b2:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  1023b7:	e9 e8 05 00 00       	jmp    1029a4 <__alltraps>

001023bc <vector130>:
.globl vector130
vector130:
  pushl $0
  1023bc:	6a 00                	push   $0x0
  pushl $130
  1023be:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  1023c3:	e9 dc 05 00 00       	jmp    1029a4 <__alltraps>

001023c8 <vector131>:
.globl vector131
vector131:
  pushl $0
  1023c8:	6a 00                	push   $0x0
  pushl $131
  1023ca:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  1023cf:	e9 d0 05 00 00       	jmp    1029a4 <__alltraps>

001023d4 <vector132>:
.globl vector132
vector132:
  pushl $0
  1023d4:	6a 00                	push   $0x0
  pushl $132
  1023d6:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  1023db:	e9 c4 05 00 00       	jmp    1029a4 <__alltraps>

001023e0 <vector133>:
.globl vector133
vector133:
  pushl $0
  1023e0:	6a 00                	push   $0x0
  pushl $133
  1023e2:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  1023e7:	e9 b8 05 00 00       	jmp    1029a4 <__alltraps>

001023ec <vector134>:
.globl vector134
vector134:
  pushl $0
  1023ec:	6a 00                	push   $0x0
  pushl $134
  1023ee:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  1023f3:	e9 ac 05 00 00       	jmp    1029a4 <__alltraps>

001023f8 <vector135>:
.globl vector135
vector135:
  pushl $0
  1023f8:	6a 00                	push   $0x0
  pushl $135
  1023fa:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  1023ff:	e9 a0 05 00 00       	jmp    1029a4 <__alltraps>

00102404 <vector136>:
.globl vector136
vector136:
  pushl $0
  102404:	6a 00                	push   $0x0
  pushl $136
  102406:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  10240b:	e9 94 05 00 00       	jmp    1029a4 <__alltraps>

00102410 <vector137>:
.globl vector137
vector137:
  pushl $0
  102410:	6a 00                	push   $0x0
  pushl $137
  102412:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  102417:	e9 88 05 00 00       	jmp    1029a4 <__alltraps>

0010241c <vector138>:
.globl vector138
vector138:
  pushl $0
  10241c:	6a 00                	push   $0x0
  pushl $138
  10241e:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  102423:	e9 7c 05 00 00       	jmp    1029a4 <__alltraps>

00102428 <vector139>:
.globl vector139
vector139:
  pushl $0
  102428:	6a 00                	push   $0x0
  pushl $139
  10242a:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  10242f:	e9 70 05 00 00       	jmp    1029a4 <__alltraps>

00102434 <vector140>:
.globl vector140
vector140:
  pushl $0
  102434:	6a 00                	push   $0x0
  pushl $140
  102436:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  10243b:	e9 64 05 00 00       	jmp    1029a4 <__alltraps>

00102440 <vector141>:
.globl vector141
vector141:
  pushl $0
  102440:	6a 00                	push   $0x0
  pushl $141
  102442:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  102447:	e9 58 05 00 00       	jmp    1029a4 <__alltraps>

0010244c <vector142>:
.globl vector142
vector142:
  pushl $0
  10244c:	6a 00                	push   $0x0
  pushl $142
  10244e:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  102453:	e9 4c 05 00 00       	jmp    1029a4 <__alltraps>

00102458 <vector143>:
.globl vector143
vector143:
  pushl $0
  102458:	6a 00                	push   $0x0
  pushl $143
  10245a:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  10245f:	e9 40 05 00 00       	jmp    1029a4 <__alltraps>

00102464 <vector144>:
.globl vector144
vector144:
  pushl $0
  102464:	6a 00                	push   $0x0
  pushl $144
  102466:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  10246b:	e9 34 05 00 00       	jmp    1029a4 <__alltraps>

00102470 <vector145>:
.globl vector145
vector145:
  pushl $0
  102470:	6a 00                	push   $0x0
  pushl $145
  102472:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  102477:	e9 28 05 00 00       	jmp    1029a4 <__alltraps>

0010247c <vector146>:
.globl vector146
vector146:
  pushl $0
  10247c:	6a 00                	push   $0x0
  pushl $146
  10247e:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  102483:	e9 1c 05 00 00       	jmp    1029a4 <__alltraps>

00102488 <vector147>:
.globl vector147
vector147:
  pushl $0
  102488:	6a 00                	push   $0x0
  pushl $147
  10248a:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  10248f:	e9 10 05 00 00       	jmp    1029a4 <__alltraps>

00102494 <vector148>:
.globl vector148
vector148:
  pushl $0
  102494:	6a 00                	push   $0x0
  pushl $148
  102496:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  10249b:	e9 04 05 00 00       	jmp    1029a4 <__alltraps>

001024a0 <vector149>:
.globl vector149
vector149:
  pushl $0
  1024a0:	6a 00                	push   $0x0
  pushl $149
  1024a2:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  1024a7:	e9 f8 04 00 00       	jmp    1029a4 <__alltraps>

001024ac <vector150>:
.globl vector150
vector150:
  pushl $0
  1024ac:	6a 00                	push   $0x0
  pushl $150
  1024ae:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  1024b3:	e9 ec 04 00 00       	jmp    1029a4 <__alltraps>

001024b8 <vector151>:
.globl vector151
vector151:
  pushl $0
  1024b8:	6a 00                	push   $0x0
  pushl $151
  1024ba:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  1024bf:	e9 e0 04 00 00       	jmp    1029a4 <__alltraps>

001024c4 <vector152>:
.globl vector152
vector152:
  pushl $0
  1024c4:	6a 00                	push   $0x0
  pushl $152
  1024c6:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  1024cb:	e9 d4 04 00 00       	jmp    1029a4 <__alltraps>

001024d0 <vector153>:
.globl vector153
vector153:
  pushl $0
  1024d0:	6a 00                	push   $0x0
  pushl $153
  1024d2:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  1024d7:	e9 c8 04 00 00       	jmp    1029a4 <__alltraps>

001024dc <vector154>:
.globl vector154
vector154:
  pushl $0
  1024dc:	6a 00                	push   $0x0
  pushl $154
  1024de:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  1024e3:	e9 bc 04 00 00       	jmp    1029a4 <__alltraps>

001024e8 <vector155>:
.globl vector155
vector155:
  pushl $0
  1024e8:	6a 00                	push   $0x0
  pushl $155
  1024ea:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  1024ef:	e9 b0 04 00 00       	jmp    1029a4 <__alltraps>

001024f4 <vector156>:
.globl vector156
vector156:
  pushl $0
  1024f4:	6a 00                	push   $0x0
  pushl $156
  1024f6:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  1024fb:	e9 a4 04 00 00       	jmp    1029a4 <__alltraps>

00102500 <vector157>:
.globl vector157
vector157:
  pushl $0
  102500:	6a 00                	push   $0x0
  pushl $157
  102502:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  102507:	e9 98 04 00 00       	jmp    1029a4 <__alltraps>

0010250c <vector158>:
.globl vector158
vector158:
  pushl $0
  10250c:	6a 00                	push   $0x0
  pushl $158
  10250e:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  102513:	e9 8c 04 00 00       	jmp    1029a4 <__alltraps>

00102518 <vector159>:
.globl vector159
vector159:
  pushl $0
  102518:	6a 00                	push   $0x0
  pushl $159
  10251a:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  10251f:	e9 80 04 00 00       	jmp    1029a4 <__alltraps>

00102524 <vector160>:
.globl vector160
vector160:
  pushl $0
  102524:	6a 00                	push   $0x0
  pushl $160
  102526:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  10252b:	e9 74 04 00 00       	jmp    1029a4 <__alltraps>

00102530 <vector161>:
.globl vector161
vector161:
  pushl $0
  102530:	6a 00                	push   $0x0
  pushl $161
  102532:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  102537:	e9 68 04 00 00       	jmp    1029a4 <__alltraps>

0010253c <vector162>:
.globl vector162
vector162:
  pushl $0
  10253c:	6a 00                	push   $0x0
  pushl $162
  10253e:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  102543:	e9 5c 04 00 00       	jmp    1029a4 <__alltraps>

00102548 <vector163>:
.globl vector163
vector163:
  pushl $0
  102548:	6a 00                	push   $0x0
  pushl $163
  10254a:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  10254f:	e9 50 04 00 00       	jmp    1029a4 <__alltraps>

00102554 <vector164>:
.globl vector164
vector164:
  pushl $0
  102554:	6a 00                	push   $0x0
  pushl $164
  102556:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  10255b:	e9 44 04 00 00       	jmp    1029a4 <__alltraps>

00102560 <vector165>:
.globl vector165
vector165:
  pushl $0
  102560:	6a 00                	push   $0x0
  pushl $165
  102562:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  102567:	e9 38 04 00 00       	jmp    1029a4 <__alltraps>

0010256c <vector166>:
.globl vector166
vector166:
  pushl $0
  10256c:	6a 00                	push   $0x0
  pushl $166
  10256e:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  102573:	e9 2c 04 00 00       	jmp    1029a4 <__alltraps>

00102578 <vector167>:
.globl vector167
vector167:
  pushl $0
  102578:	6a 00                	push   $0x0
  pushl $167
  10257a:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  10257f:	e9 20 04 00 00       	jmp    1029a4 <__alltraps>

00102584 <vector168>:
.globl vector168
vector168:
  pushl $0
  102584:	6a 00                	push   $0x0
  pushl $168
  102586:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  10258b:	e9 14 04 00 00       	jmp    1029a4 <__alltraps>

00102590 <vector169>:
.globl vector169
vector169:
  pushl $0
  102590:	6a 00                	push   $0x0
  pushl $169
  102592:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  102597:	e9 08 04 00 00       	jmp    1029a4 <__alltraps>

0010259c <vector170>:
.globl vector170
vector170:
  pushl $0
  10259c:	6a 00                	push   $0x0
  pushl $170
  10259e:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  1025a3:	e9 fc 03 00 00       	jmp    1029a4 <__alltraps>

001025a8 <vector171>:
.globl vector171
vector171:
  pushl $0
  1025a8:	6a 00                	push   $0x0
  pushl $171
  1025aa:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  1025af:	e9 f0 03 00 00       	jmp    1029a4 <__alltraps>

001025b4 <vector172>:
.globl vector172
vector172:
  pushl $0
  1025b4:	6a 00                	push   $0x0
  pushl $172
  1025b6:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  1025bb:	e9 e4 03 00 00       	jmp    1029a4 <__alltraps>

001025c0 <vector173>:
.globl vector173
vector173:
  pushl $0
  1025c0:	6a 00                	push   $0x0
  pushl $173
  1025c2:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  1025c7:	e9 d8 03 00 00       	jmp    1029a4 <__alltraps>

001025cc <vector174>:
.globl vector174
vector174:
  pushl $0
  1025cc:	6a 00                	push   $0x0
  pushl $174
  1025ce:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  1025d3:	e9 cc 03 00 00       	jmp    1029a4 <__alltraps>

001025d8 <vector175>:
.globl vector175
vector175:
  pushl $0
  1025d8:	6a 00                	push   $0x0
  pushl $175
  1025da:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  1025df:	e9 c0 03 00 00       	jmp    1029a4 <__alltraps>

001025e4 <vector176>:
.globl vector176
vector176:
  pushl $0
  1025e4:	6a 00                	push   $0x0
  pushl $176
  1025e6:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  1025eb:	e9 b4 03 00 00       	jmp    1029a4 <__alltraps>

001025f0 <vector177>:
.globl vector177
vector177:
  pushl $0
  1025f0:	6a 00                	push   $0x0
  pushl $177
  1025f2:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  1025f7:	e9 a8 03 00 00       	jmp    1029a4 <__alltraps>

001025fc <vector178>:
.globl vector178
vector178:
  pushl $0
  1025fc:	6a 00                	push   $0x0
  pushl $178
  1025fe:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  102603:	e9 9c 03 00 00       	jmp    1029a4 <__alltraps>

00102608 <vector179>:
.globl vector179
vector179:
  pushl $0
  102608:	6a 00                	push   $0x0
  pushl $179
  10260a:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  10260f:	e9 90 03 00 00       	jmp    1029a4 <__alltraps>

00102614 <vector180>:
.globl vector180
vector180:
  pushl $0
  102614:	6a 00                	push   $0x0
  pushl $180
  102616:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  10261b:	e9 84 03 00 00       	jmp    1029a4 <__alltraps>

00102620 <vector181>:
.globl vector181
vector181:
  pushl $0
  102620:	6a 00                	push   $0x0
  pushl $181
  102622:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  102627:	e9 78 03 00 00       	jmp    1029a4 <__alltraps>

0010262c <vector182>:
.globl vector182
vector182:
  pushl $0
  10262c:	6a 00                	push   $0x0
  pushl $182
  10262e:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  102633:	e9 6c 03 00 00       	jmp    1029a4 <__alltraps>

00102638 <vector183>:
.globl vector183
vector183:
  pushl $0
  102638:	6a 00                	push   $0x0
  pushl $183
  10263a:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  10263f:	e9 60 03 00 00       	jmp    1029a4 <__alltraps>

00102644 <vector184>:
.globl vector184
vector184:
  pushl $0
  102644:	6a 00                	push   $0x0
  pushl $184
  102646:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  10264b:	e9 54 03 00 00       	jmp    1029a4 <__alltraps>

00102650 <vector185>:
.globl vector185
vector185:
  pushl $0
  102650:	6a 00                	push   $0x0
  pushl $185
  102652:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  102657:	e9 48 03 00 00       	jmp    1029a4 <__alltraps>

0010265c <vector186>:
.globl vector186
vector186:
  pushl $0
  10265c:	6a 00                	push   $0x0
  pushl $186
  10265e:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  102663:	e9 3c 03 00 00       	jmp    1029a4 <__alltraps>

00102668 <vector187>:
.globl vector187
vector187:
  pushl $0
  102668:	6a 00                	push   $0x0
  pushl $187
  10266a:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  10266f:	e9 30 03 00 00       	jmp    1029a4 <__alltraps>

00102674 <vector188>:
.globl vector188
vector188:
  pushl $0
  102674:	6a 00                	push   $0x0
  pushl $188
  102676:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  10267b:	e9 24 03 00 00       	jmp    1029a4 <__alltraps>

00102680 <vector189>:
.globl vector189
vector189:
  pushl $0
  102680:	6a 00                	push   $0x0
  pushl $189
  102682:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  102687:	e9 18 03 00 00       	jmp    1029a4 <__alltraps>

0010268c <vector190>:
.globl vector190
vector190:
  pushl $0
  10268c:	6a 00                	push   $0x0
  pushl $190
  10268e:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  102693:	e9 0c 03 00 00       	jmp    1029a4 <__alltraps>

00102698 <vector191>:
.globl vector191
vector191:
  pushl $0
  102698:	6a 00                	push   $0x0
  pushl $191
  10269a:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  10269f:	e9 00 03 00 00       	jmp    1029a4 <__alltraps>

001026a4 <vector192>:
.globl vector192
vector192:
  pushl $0
  1026a4:	6a 00                	push   $0x0
  pushl $192
  1026a6:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  1026ab:	e9 f4 02 00 00       	jmp    1029a4 <__alltraps>

001026b0 <vector193>:
.globl vector193
vector193:
  pushl $0
  1026b0:	6a 00                	push   $0x0
  pushl $193
  1026b2:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  1026b7:	e9 e8 02 00 00       	jmp    1029a4 <__alltraps>

001026bc <vector194>:
.globl vector194
vector194:
  pushl $0
  1026bc:	6a 00                	push   $0x0
  pushl $194
  1026be:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  1026c3:	e9 dc 02 00 00       	jmp    1029a4 <__alltraps>

001026c8 <vector195>:
.globl vector195
vector195:
  pushl $0
  1026c8:	6a 00                	push   $0x0
  pushl $195
  1026ca:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  1026cf:	e9 d0 02 00 00       	jmp    1029a4 <__alltraps>

001026d4 <vector196>:
.globl vector196
vector196:
  pushl $0
  1026d4:	6a 00                	push   $0x0
  pushl $196
  1026d6:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  1026db:	e9 c4 02 00 00       	jmp    1029a4 <__alltraps>

001026e0 <vector197>:
.globl vector197
vector197:
  pushl $0
  1026e0:	6a 00                	push   $0x0
  pushl $197
  1026e2:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  1026e7:	e9 b8 02 00 00       	jmp    1029a4 <__alltraps>

001026ec <vector198>:
.globl vector198
vector198:
  pushl $0
  1026ec:	6a 00                	push   $0x0
  pushl $198
  1026ee:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  1026f3:	e9 ac 02 00 00       	jmp    1029a4 <__alltraps>

001026f8 <vector199>:
.globl vector199
vector199:
  pushl $0
  1026f8:	6a 00                	push   $0x0
  pushl $199
  1026fa:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  1026ff:	e9 a0 02 00 00       	jmp    1029a4 <__alltraps>

00102704 <vector200>:
.globl vector200
vector200:
  pushl $0
  102704:	6a 00                	push   $0x0
  pushl $200
  102706:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  10270b:	e9 94 02 00 00       	jmp    1029a4 <__alltraps>

00102710 <vector201>:
.globl vector201
vector201:
  pushl $0
  102710:	6a 00                	push   $0x0
  pushl $201
  102712:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  102717:	e9 88 02 00 00       	jmp    1029a4 <__alltraps>

0010271c <vector202>:
.globl vector202
vector202:
  pushl $0
  10271c:	6a 00                	push   $0x0
  pushl $202
  10271e:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  102723:	e9 7c 02 00 00       	jmp    1029a4 <__alltraps>

00102728 <vector203>:
.globl vector203
vector203:
  pushl $0
  102728:	6a 00                	push   $0x0
  pushl $203
  10272a:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  10272f:	e9 70 02 00 00       	jmp    1029a4 <__alltraps>

00102734 <vector204>:
.globl vector204
vector204:
  pushl $0
  102734:	6a 00                	push   $0x0
  pushl $204
  102736:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  10273b:	e9 64 02 00 00       	jmp    1029a4 <__alltraps>

00102740 <vector205>:
.globl vector205
vector205:
  pushl $0
  102740:	6a 00                	push   $0x0
  pushl $205
  102742:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  102747:	e9 58 02 00 00       	jmp    1029a4 <__alltraps>

0010274c <vector206>:
.globl vector206
vector206:
  pushl $0
  10274c:	6a 00                	push   $0x0
  pushl $206
  10274e:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  102753:	e9 4c 02 00 00       	jmp    1029a4 <__alltraps>

00102758 <vector207>:
.globl vector207
vector207:
  pushl $0
  102758:	6a 00                	push   $0x0
  pushl $207
  10275a:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  10275f:	e9 40 02 00 00       	jmp    1029a4 <__alltraps>

00102764 <vector208>:
.globl vector208
vector208:
  pushl $0
  102764:	6a 00                	push   $0x0
  pushl $208
  102766:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  10276b:	e9 34 02 00 00       	jmp    1029a4 <__alltraps>

00102770 <vector209>:
.globl vector209
vector209:
  pushl $0
  102770:	6a 00                	push   $0x0
  pushl $209
  102772:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  102777:	e9 28 02 00 00       	jmp    1029a4 <__alltraps>

0010277c <vector210>:
.globl vector210
vector210:
  pushl $0
  10277c:	6a 00                	push   $0x0
  pushl $210
  10277e:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  102783:	e9 1c 02 00 00       	jmp    1029a4 <__alltraps>

00102788 <vector211>:
.globl vector211
vector211:
  pushl $0
  102788:	6a 00                	push   $0x0
  pushl $211
  10278a:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  10278f:	e9 10 02 00 00       	jmp    1029a4 <__alltraps>

00102794 <vector212>:
.globl vector212
vector212:
  pushl $0
  102794:	6a 00                	push   $0x0
  pushl $212
  102796:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  10279b:	e9 04 02 00 00       	jmp    1029a4 <__alltraps>

001027a0 <vector213>:
.globl vector213
vector213:
  pushl $0
  1027a0:	6a 00                	push   $0x0
  pushl $213
  1027a2:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  1027a7:	e9 f8 01 00 00       	jmp    1029a4 <__alltraps>

001027ac <vector214>:
.globl vector214
vector214:
  pushl $0
  1027ac:	6a 00                	push   $0x0
  pushl $214
  1027ae:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  1027b3:	e9 ec 01 00 00       	jmp    1029a4 <__alltraps>

001027b8 <vector215>:
.globl vector215
vector215:
  pushl $0
  1027b8:	6a 00                	push   $0x0
  pushl $215
  1027ba:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  1027bf:	e9 e0 01 00 00       	jmp    1029a4 <__alltraps>

001027c4 <vector216>:
.globl vector216
vector216:
  pushl $0
  1027c4:	6a 00                	push   $0x0
  pushl $216
  1027c6:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  1027cb:	e9 d4 01 00 00       	jmp    1029a4 <__alltraps>

001027d0 <vector217>:
.globl vector217
vector217:
  pushl $0
  1027d0:	6a 00                	push   $0x0
  pushl $217
  1027d2:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  1027d7:	e9 c8 01 00 00       	jmp    1029a4 <__alltraps>

001027dc <vector218>:
.globl vector218
vector218:
  pushl $0
  1027dc:	6a 00                	push   $0x0
  pushl $218
  1027de:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  1027e3:	e9 bc 01 00 00       	jmp    1029a4 <__alltraps>

001027e8 <vector219>:
.globl vector219
vector219:
  pushl $0
  1027e8:	6a 00                	push   $0x0
  pushl $219
  1027ea:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  1027ef:	e9 b0 01 00 00       	jmp    1029a4 <__alltraps>

001027f4 <vector220>:
.globl vector220
vector220:
  pushl $0
  1027f4:	6a 00                	push   $0x0
  pushl $220
  1027f6:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  1027fb:	e9 a4 01 00 00       	jmp    1029a4 <__alltraps>

00102800 <vector221>:
.globl vector221
vector221:
  pushl $0
  102800:	6a 00                	push   $0x0
  pushl $221
  102802:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  102807:	e9 98 01 00 00       	jmp    1029a4 <__alltraps>

0010280c <vector222>:
.globl vector222
vector222:
  pushl $0
  10280c:	6a 00                	push   $0x0
  pushl $222
  10280e:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  102813:	e9 8c 01 00 00       	jmp    1029a4 <__alltraps>

00102818 <vector223>:
.globl vector223
vector223:
  pushl $0
  102818:	6a 00                	push   $0x0
  pushl $223
  10281a:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  10281f:	e9 80 01 00 00       	jmp    1029a4 <__alltraps>

00102824 <vector224>:
.globl vector224
vector224:
  pushl $0
  102824:	6a 00                	push   $0x0
  pushl $224
  102826:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  10282b:	e9 74 01 00 00       	jmp    1029a4 <__alltraps>

00102830 <vector225>:
.globl vector225
vector225:
  pushl $0
  102830:	6a 00                	push   $0x0
  pushl $225
  102832:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  102837:	e9 68 01 00 00       	jmp    1029a4 <__alltraps>

0010283c <vector226>:
.globl vector226
vector226:
  pushl $0
  10283c:	6a 00                	push   $0x0
  pushl $226
  10283e:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  102843:	e9 5c 01 00 00       	jmp    1029a4 <__alltraps>

00102848 <vector227>:
.globl vector227
vector227:
  pushl $0
  102848:	6a 00                	push   $0x0
  pushl $227
  10284a:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  10284f:	e9 50 01 00 00       	jmp    1029a4 <__alltraps>

00102854 <vector228>:
.globl vector228
vector228:
  pushl $0
  102854:	6a 00                	push   $0x0
  pushl $228
  102856:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  10285b:	e9 44 01 00 00       	jmp    1029a4 <__alltraps>

00102860 <vector229>:
.globl vector229
vector229:
  pushl $0
  102860:	6a 00                	push   $0x0
  pushl $229
  102862:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  102867:	e9 38 01 00 00       	jmp    1029a4 <__alltraps>

0010286c <vector230>:
.globl vector230
vector230:
  pushl $0
  10286c:	6a 00                	push   $0x0
  pushl $230
  10286e:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  102873:	e9 2c 01 00 00       	jmp    1029a4 <__alltraps>

00102878 <vector231>:
.globl vector231
vector231:
  pushl $0
  102878:	6a 00                	push   $0x0
  pushl $231
  10287a:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  10287f:	e9 20 01 00 00       	jmp    1029a4 <__alltraps>

00102884 <vector232>:
.globl vector232
vector232:
  pushl $0
  102884:	6a 00                	push   $0x0
  pushl $232
  102886:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  10288b:	e9 14 01 00 00       	jmp    1029a4 <__alltraps>

00102890 <vector233>:
.globl vector233
vector233:
  pushl $0
  102890:	6a 00                	push   $0x0
  pushl $233
  102892:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  102897:	e9 08 01 00 00       	jmp    1029a4 <__alltraps>

0010289c <vector234>:
.globl vector234
vector234:
  pushl $0
  10289c:	6a 00                	push   $0x0
  pushl $234
  10289e:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  1028a3:	e9 fc 00 00 00       	jmp    1029a4 <__alltraps>

001028a8 <vector235>:
.globl vector235
vector235:
  pushl $0
  1028a8:	6a 00                	push   $0x0
  pushl $235
  1028aa:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  1028af:	e9 f0 00 00 00       	jmp    1029a4 <__alltraps>

001028b4 <vector236>:
.globl vector236
vector236:
  pushl $0
  1028b4:	6a 00                	push   $0x0
  pushl $236
  1028b6:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  1028bb:	e9 e4 00 00 00       	jmp    1029a4 <__alltraps>

001028c0 <vector237>:
.globl vector237
vector237:
  pushl $0
  1028c0:	6a 00                	push   $0x0
  pushl $237
  1028c2:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  1028c7:	e9 d8 00 00 00       	jmp    1029a4 <__alltraps>

001028cc <vector238>:
.globl vector238
vector238:
  pushl $0
  1028cc:	6a 00                	push   $0x0
  pushl $238
  1028ce:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  1028d3:	e9 cc 00 00 00       	jmp    1029a4 <__alltraps>

001028d8 <vector239>:
.globl vector239
vector239:
  pushl $0
  1028d8:	6a 00                	push   $0x0
  pushl $239
  1028da:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  1028df:	e9 c0 00 00 00       	jmp    1029a4 <__alltraps>

001028e4 <vector240>:
.globl vector240
vector240:
  pushl $0
  1028e4:	6a 00                	push   $0x0
  pushl $240
  1028e6:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  1028eb:	e9 b4 00 00 00       	jmp    1029a4 <__alltraps>

001028f0 <vector241>:
.globl vector241
vector241:
  pushl $0
  1028f0:	6a 00                	push   $0x0
  pushl $241
  1028f2:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  1028f7:	e9 a8 00 00 00       	jmp    1029a4 <__alltraps>

001028fc <vector242>:
.globl vector242
vector242:
  pushl $0
  1028fc:	6a 00                	push   $0x0
  pushl $242
  1028fe:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  102903:	e9 9c 00 00 00       	jmp    1029a4 <__alltraps>

00102908 <vector243>:
.globl vector243
vector243:
  pushl $0
  102908:	6a 00                	push   $0x0
  pushl $243
  10290a:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  10290f:	e9 90 00 00 00       	jmp    1029a4 <__alltraps>

00102914 <vector244>:
.globl vector244
vector244:
  pushl $0
  102914:	6a 00                	push   $0x0
  pushl $244
  102916:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  10291b:	e9 84 00 00 00       	jmp    1029a4 <__alltraps>

00102920 <vector245>:
.globl vector245
vector245:
  pushl $0
  102920:	6a 00                	push   $0x0
  pushl $245
  102922:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  102927:	e9 78 00 00 00       	jmp    1029a4 <__alltraps>

0010292c <vector246>:
.globl vector246
vector246:
  pushl $0
  10292c:	6a 00                	push   $0x0
  pushl $246
  10292e:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  102933:	e9 6c 00 00 00       	jmp    1029a4 <__alltraps>

00102938 <vector247>:
.globl vector247
vector247:
  pushl $0
  102938:	6a 00                	push   $0x0
  pushl $247
  10293a:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  10293f:	e9 60 00 00 00       	jmp    1029a4 <__alltraps>

00102944 <vector248>:
.globl vector248
vector248:
  pushl $0
  102944:	6a 00                	push   $0x0
  pushl $248
  102946:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  10294b:	e9 54 00 00 00       	jmp    1029a4 <__alltraps>

00102950 <vector249>:
.globl vector249
vector249:
  pushl $0
  102950:	6a 00                	push   $0x0
  pushl $249
  102952:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  102957:	e9 48 00 00 00       	jmp    1029a4 <__alltraps>

0010295c <vector250>:
.globl vector250
vector250:
  pushl $0
  10295c:	6a 00                	push   $0x0
  pushl $250
  10295e:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  102963:	e9 3c 00 00 00       	jmp    1029a4 <__alltraps>

00102968 <vector251>:
.globl vector251
vector251:
  pushl $0
  102968:	6a 00                	push   $0x0
  pushl $251
  10296a:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  10296f:	e9 30 00 00 00       	jmp    1029a4 <__alltraps>

00102974 <vector252>:
.globl vector252
vector252:
  pushl $0
  102974:	6a 00                	push   $0x0
  pushl $252
  102976:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  10297b:	e9 24 00 00 00       	jmp    1029a4 <__alltraps>

00102980 <vector253>:
.globl vector253
vector253:
  pushl $0
  102980:	6a 00                	push   $0x0
  pushl $253
  102982:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102987:	e9 18 00 00 00       	jmp    1029a4 <__alltraps>

0010298c <vector254>:
.globl vector254
vector254:
  pushl $0
  10298c:	6a 00                	push   $0x0
  pushl $254
  10298e:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  102993:	e9 0c 00 00 00       	jmp    1029a4 <__alltraps>

00102998 <vector255>:
.globl vector255
vector255:
  pushl $0
  102998:	6a 00                	push   $0x0
  pushl $255
  10299a:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  10299f:	e9 00 00 00 00       	jmp    1029a4 <__alltraps>

001029a4 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  1029a4:	1e                   	push   %ds
    pushl %es
  1029a5:	06                   	push   %es
    pushl %fs
  1029a6:	0f a0                	push   %fs
    pushl %gs
  1029a8:	0f a8                	push   %gs
    pushal
  1029aa:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  1029ab:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  1029b0:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  1029b2:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  1029b4:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  1029b5:	e8 65 f5 ff ff       	call   101f1f <trap>

    # pop the pushed stack pointer
    popl %esp
  1029ba:	5c                   	pop    %esp

001029bb <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  1029bb:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  1029bc:	0f a9                	pop    %gs
    popl %fs
  1029be:	0f a1                	pop    %fs
    popl %es
  1029c0:	07                   	pop    %es
    popl %ds
  1029c1:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  1029c2:	83 c4 08             	add    $0x8,%esp
    iret
  1029c5:	cf                   	iret   

001029c6 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  1029c6:	55                   	push   %ebp
  1029c7:	89 e5                	mov    %esp,%ebp
    return page - pages;
  1029c9:	8b 55 08             	mov    0x8(%ebp),%edx
  1029cc:	a1 78 af 11 00       	mov    0x11af78,%eax
  1029d1:	29 c2                	sub    %eax,%edx
  1029d3:	89 d0                	mov    %edx,%eax
  1029d5:	c1 f8 02             	sar    $0x2,%eax
  1029d8:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  1029de:	5d                   	pop    %ebp
  1029df:	c3                   	ret    

001029e0 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  1029e0:	55                   	push   %ebp
  1029e1:	89 e5                	mov    %esp,%ebp
  1029e3:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  1029e6:	8b 45 08             	mov    0x8(%ebp),%eax
  1029e9:	89 04 24             	mov    %eax,(%esp)
  1029ec:	e8 d5 ff ff ff       	call   1029c6 <page2ppn>
  1029f1:	c1 e0 0c             	shl    $0xc,%eax
}
  1029f4:	c9                   	leave  
  1029f5:	c3                   	ret    

001029f6 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
  1029f6:	55                   	push   %ebp
  1029f7:	89 e5                	mov    %esp,%ebp
  1029f9:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
  1029fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1029ff:	c1 e8 0c             	shr    $0xc,%eax
  102a02:	89 c2                	mov    %eax,%edx
  102a04:	a1 80 ae 11 00       	mov    0x11ae80,%eax
  102a09:	39 c2                	cmp    %eax,%edx
  102a0b:	72 1c                	jb     102a29 <pa2page+0x33>
        panic("pa2page called with invalid pa");
  102a0d:	c7 44 24 08 10 68 10 	movl   $0x106810,0x8(%esp)
  102a14:	00 
  102a15:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  102a1c:	00 
  102a1d:	c7 04 24 2f 68 10 00 	movl   $0x10682f,(%esp)
  102a24:	e8 cb d9 ff ff       	call   1003f4 <__panic>
    }
    return &pages[PPN(pa)];
  102a29:	8b 0d 78 af 11 00    	mov    0x11af78,%ecx
  102a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  102a32:	c1 e8 0c             	shr    $0xc,%eax
  102a35:	89 c2                	mov    %eax,%edx
  102a37:	89 d0                	mov    %edx,%eax
  102a39:	c1 e0 02             	shl    $0x2,%eax
  102a3c:	01 d0                	add    %edx,%eax
  102a3e:	c1 e0 02             	shl    $0x2,%eax
  102a41:	01 c8                	add    %ecx,%eax
}
  102a43:	c9                   	leave  
  102a44:	c3                   	ret    

00102a45 <page2kva>:

static inline void *
page2kva(struct Page *page) {
  102a45:	55                   	push   %ebp
  102a46:	89 e5                	mov    %esp,%ebp
  102a48:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
  102a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  102a4e:	89 04 24             	mov    %eax,(%esp)
  102a51:	e8 8a ff ff ff       	call   1029e0 <page2pa>
  102a56:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102a59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a5c:	c1 e8 0c             	shr    $0xc,%eax
  102a5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102a62:	a1 80 ae 11 00       	mov    0x11ae80,%eax
  102a67:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  102a6a:	72 23                	jb     102a8f <page2kva+0x4a>
  102a6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a6f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102a73:	c7 44 24 08 40 68 10 	movl   $0x106840,0x8(%esp)
  102a7a:	00 
  102a7b:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  102a82:	00 
  102a83:	c7 04 24 2f 68 10 00 	movl   $0x10682f,(%esp)
  102a8a:	e8 65 d9 ff ff       	call   1003f4 <__panic>
  102a8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a92:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
  102a97:	c9                   	leave  
  102a98:	c3                   	ret    

00102a99 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
  102a99:	55                   	push   %ebp
  102a9a:	89 e5                	mov    %esp,%ebp
  102a9c:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
  102a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  102aa2:	83 e0 01             	and    $0x1,%eax
  102aa5:	85 c0                	test   %eax,%eax
  102aa7:	75 1c                	jne    102ac5 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
  102aa9:	c7 44 24 08 64 68 10 	movl   $0x106864,0x8(%esp)
  102ab0:	00 
  102ab1:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
  102ab8:	00 
  102ab9:	c7 04 24 2f 68 10 00 	movl   $0x10682f,(%esp)
  102ac0:	e8 2f d9 ff ff       	call   1003f4 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
  102ac5:	8b 45 08             	mov    0x8(%ebp),%eax
  102ac8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  102acd:	89 04 24             	mov    %eax,(%esp)
  102ad0:	e8 21 ff ff ff       	call   1029f6 <pa2page>
}
  102ad5:	c9                   	leave  
  102ad6:	c3                   	ret    

00102ad7 <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
  102ad7:	55                   	push   %ebp
  102ad8:	89 e5                	mov    %esp,%ebp
  102ada:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
  102add:	8b 45 08             	mov    0x8(%ebp),%eax
  102ae0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  102ae5:	89 04 24             	mov    %eax,(%esp)
  102ae8:	e8 09 ff ff ff       	call   1029f6 <pa2page>
}
  102aed:	c9                   	leave  
  102aee:	c3                   	ret    

00102aef <page_ref>:

static inline int
page_ref(struct Page *page) {
  102aef:	55                   	push   %ebp
  102af0:	89 e5                	mov    %esp,%ebp
    return page->ref;
  102af2:	8b 45 08             	mov    0x8(%ebp),%eax
  102af5:	8b 00                	mov    (%eax),%eax
}
  102af7:	5d                   	pop    %ebp
  102af8:	c3                   	ret    

00102af9 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  102af9:	55                   	push   %ebp
  102afa:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  102afc:	8b 45 08             	mov    0x8(%ebp),%eax
  102aff:	8b 55 0c             	mov    0xc(%ebp),%edx
  102b02:	89 10                	mov    %edx,(%eax)
}
  102b04:	5d                   	pop    %ebp
  102b05:	c3                   	ret    

00102b06 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
  102b06:	55                   	push   %ebp
  102b07:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
  102b09:	8b 45 08             	mov    0x8(%ebp),%eax
  102b0c:	8b 00                	mov    (%eax),%eax
  102b0e:	8d 50 01             	lea    0x1(%eax),%edx
  102b11:	8b 45 08             	mov    0x8(%ebp),%eax
  102b14:	89 10                	mov    %edx,(%eax)
    return page->ref;
  102b16:	8b 45 08             	mov    0x8(%ebp),%eax
  102b19:	8b 00                	mov    (%eax),%eax
}
  102b1b:	5d                   	pop    %ebp
  102b1c:	c3                   	ret    

00102b1d <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
  102b1d:	55                   	push   %ebp
  102b1e:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
  102b20:	8b 45 08             	mov    0x8(%ebp),%eax
  102b23:	8b 00                	mov    (%eax),%eax
  102b25:	8d 50 ff             	lea    -0x1(%eax),%edx
  102b28:	8b 45 08             	mov    0x8(%ebp),%eax
  102b2b:	89 10                	mov    %edx,(%eax)
    return page->ref;
  102b2d:	8b 45 08             	mov    0x8(%ebp),%eax
  102b30:	8b 00                	mov    (%eax),%eax
}
  102b32:	5d                   	pop    %ebp
  102b33:	c3                   	ret    

00102b34 <__intr_save>:
__intr_save(void) {
  102b34:	55                   	push   %ebp
  102b35:	89 e5                	mov    %esp,%ebp
  102b37:	83 ec 18             	sub    $0x18,%esp
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  102b3a:	9c                   	pushf  
  102b3b:	58                   	pop    %eax
  102b3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  102b3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  102b42:	25 00 02 00 00       	and    $0x200,%eax
  102b47:	85 c0                	test   %eax,%eax
  102b49:	74 0c                	je     102b57 <__intr_save+0x23>
        intr_disable();
  102b4b:	e8 42 ed ff ff       	call   101892 <intr_disable>
        return 1;
  102b50:	b8 01 00 00 00       	mov    $0x1,%eax
  102b55:	eb 05                	jmp    102b5c <__intr_save+0x28>
    return 0;
  102b57:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102b5c:	c9                   	leave  
  102b5d:	c3                   	ret    

00102b5e <__intr_restore>:
__intr_restore(bool flag) {
  102b5e:	55                   	push   %ebp
  102b5f:	89 e5                	mov    %esp,%ebp
  102b61:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  102b64:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102b68:	74 05                	je     102b6f <__intr_restore+0x11>
        intr_enable();
  102b6a:	e8 1d ed ff ff       	call   10188c <intr_enable>
}
  102b6f:	c9                   	leave  
  102b70:	c3                   	ret    

00102b71 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  102b71:	55                   	push   %ebp
  102b72:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  102b74:	8b 45 08             	mov    0x8(%ebp),%eax
  102b77:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  102b7a:	b8 23 00 00 00       	mov    $0x23,%eax
  102b7f:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  102b81:	b8 23 00 00 00       	mov    $0x23,%eax
  102b86:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  102b88:	b8 10 00 00 00       	mov    $0x10,%eax
  102b8d:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  102b8f:	b8 10 00 00 00       	mov    $0x10,%eax
  102b94:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  102b96:	b8 10 00 00 00       	mov    $0x10,%eax
  102b9b:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  102b9d:	ea a4 2b 10 00 08 00 	ljmp   $0x8,$0x102ba4
}
  102ba4:	5d                   	pop    %ebp
  102ba5:	c3                   	ret    

00102ba6 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
  102ba6:	55                   	push   %ebp
  102ba7:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
  102ba9:	8b 45 08             	mov    0x8(%ebp),%eax
  102bac:	a3 a4 ae 11 00       	mov    %eax,0x11aea4
}
  102bb1:	5d                   	pop    %ebp
  102bb2:	c3                   	ret    

00102bb3 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  102bb3:	55                   	push   %ebp
  102bb4:	89 e5                	mov    %esp,%ebp
  102bb6:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
  102bb9:	b8 00 70 11 00       	mov    $0x117000,%eax
  102bbe:	89 04 24             	mov    %eax,(%esp)
  102bc1:	e8 e0 ff ff ff       	call   102ba6 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
  102bc6:	66 c7 05 a8 ae 11 00 	movw   $0x10,0x11aea8
  102bcd:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
  102bcf:	66 c7 05 28 7a 11 00 	movw   $0x68,0x117a28
  102bd6:	68 00 
  102bd8:	b8 a0 ae 11 00       	mov    $0x11aea0,%eax
  102bdd:	66 a3 2a 7a 11 00    	mov    %ax,0x117a2a
  102be3:	b8 a0 ae 11 00       	mov    $0x11aea0,%eax
  102be8:	c1 e8 10             	shr    $0x10,%eax
  102beb:	a2 2c 7a 11 00       	mov    %al,0x117a2c
  102bf0:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  102bf7:	83 e0 f0             	and    $0xfffffff0,%eax
  102bfa:	83 c8 09             	or     $0x9,%eax
  102bfd:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  102c02:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  102c09:	83 e0 ef             	and    $0xffffffef,%eax
  102c0c:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  102c11:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  102c18:	83 e0 9f             	and    $0xffffff9f,%eax
  102c1b:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  102c20:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  102c27:	83 c8 80             	or     $0xffffff80,%eax
  102c2a:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  102c2f:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  102c36:	83 e0 f0             	and    $0xfffffff0,%eax
  102c39:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  102c3e:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  102c45:	83 e0 ef             	and    $0xffffffef,%eax
  102c48:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  102c4d:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  102c54:	83 e0 df             	and    $0xffffffdf,%eax
  102c57:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  102c5c:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  102c63:	83 c8 40             	or     $0x40,%eax
  102c66:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  102c6b:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  102c72:	83 e0 7f             	and    $0x7f,%eax
  102c75:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  102c7a:	b8 a0 ae 11 00       	mov    $0x11aea0,%eax
  102c7f:	c1 e8 18             	shr    $0x18,%eax
  102c82:	a2 2f 7a 11 00       	mov    %al,0x117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
  102c87:	c7 04 24 30 7a 11 00 	movl   $0x117a30,(%esp)
  102c8e:	e8 de fe ff ff       	call   102b71 <lgdt>
  102c93:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
  102c99:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  102c9d:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  102ca0:	c9                   	leave  
  102ca1:	c3                   	ret    

00102ca2 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
  102ca2:	55                   	push   %ebp
  102ca3:	89 e5                	mov    %esp,%ebp
  102ca5:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
  102ca8:	c7 05 70 af 11 00 08 	movl   $0x107208,0x11af70
  102caf:	72 10 00 
    cprintf("memory management: %s\n", pmm_manager->name);
  102cb2:	a1 70 af 11 00       	mov    0x11af70,%eax
  102cb7:	8b 00                	mov    (%eax),%eax
  102cb9:	89 44 24 04          	mov    %eax,0x4(%esp)
  102cbd:	c7 04 24 90 68 10 00 	movl   $0x106890,(%esp)
  102cc4:	e8 d4 d5 ff ff       	call   10029d <cprintf>
    pmm_manager->init();
  102cc9:	a1 70 af 11 00       	mov    0x11af70,%eax
  102cce:	8b 40 04             	mov    0x4(%eax),%eax
  102cd1:	ff d0                	call   *%eax
}
  102cd3:	c9                   	leave  
  102cd4:	c3                   	ret    

00102cd5 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
  102cd5:	55                   	push   %ebp
  102cd6:	89 e5                	mov    %esp,%ebp
  102cd8:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
  102cdb:	a1 70 af 11 00       	mov    0x11af70,%eax
  102ce0:	8b 40 08             	mov    0x8(%eax),%eax
  102ce3:	8b 55 0c             	mov    0xc(%ebp),%edx
  102ce6:	89 54 24 04          	mov    %edx,0x4(%esp)
  102cea:	8b 55 08             	mov    0x8(%ebp),%edx
  102ced:	89 14 24             	mov    %edx,(%esp)
  102cf0:	ff d0                	call   *%eax
}
  102cf2:	c9                   	leave  
  102cf3:	c3                   	ret    

00102cf4 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
  102cf4:	55                   	push   %ebp
  102cf5:	89 e5                	mov    %esp,%ebp
  102cf7:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
  102cfa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  102d01:	e8 2e fe ff ff       	call   102b34 <__intr_save>
  102d06:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
  102d09:	a1 70 af 11 00       	mov    0x11af70,%eax
  102d0e:	8b 40 0c             	mov    0xc(%eax),%eax
  102d11:	8b 55 08             	mov    0x8(%ebp),%edx
  102d14:	89 14 24             	mov    %edx,(%esp)
  102d17:	ff d0                	call   *%eax
  102d19:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
  102d1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d1f:	89 04 24             	mov    %eax,(%esp)
  102d22:	e8 37 fe ff ff       	call   102b5e <__intr_restore>
    return page;
  102d27:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102d2a:	c9                   	leave  
  102d2b:	c3                   	ret    

00102d2c <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
  102d2c:	55                   	push   %ebp
  102d2d:	89 e5                	mov    %esp,%ebp
  102d2f:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  102d32:	e8 fd fd ff ff       	call   102b34 <__intr_save>
  102d37:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
  102d3a:	a1 70 af 11 00       	mov    0x11af70,%eax
  102d3f:	8b 40 10             	mov    0x10(%eax),%eax
  102d42:	8b 55 0c             	mov    0xc(%ebp),%edx
  102d45:	89 54 24 04          	mov    %edx,0x4(%esp)
  102d49:	8b 55 08             	mov    0x8(%ebp),%edx
  102d4c:	89 14 24             	mov    %edx,(%esp)
  102d4f:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
  102d51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d54:	89 04 24             	mov    %eax,(%esp)
  102d57:	e8 02 fe ff ff       	call   102b5e <__intr_restore>
}
  102d5c:	c9                   	leave  
  102d5d:	c3                   	ret    

00102d5e <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
  102d5e:	55                   	push   %ebp
  102d5f:	89 e5                	mov    %esp,%ebp
  102d61:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
  102d64:	e8 cb fd ff ff       	call   102b34 <__intr_save>
  102d69:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
  102d6c:	a1 70 af 11 00       	mov    0x11af70,%eax
  102d71:	8b 40 14             	mov    0x14(%eax),%eax
  102d74:	ff d0                	call   *%eax
  102d76:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
  102d79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d7c:	89 04 24             	mov    %eax,(%esp)
  102d7f:	e8 da fd ff ff       	call   102b5e <__intr_restore>
    return ret;
  102d84:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  102d87:	c9                   	leave  
  102d88:	c3                   	ret    

00102d89 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
  102d89:	55                   	push   %ebp
  102d8a:	89 e5                	mov    %esp,%ebp
  102d8c:	57                   	push   %edi
  102d8d:	56                   	push   %esi
  102d8e:	53                   	push   %ebx
  102d8f:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
  102d95:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
  102d9c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  102da3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
  102daa:	c7 04 24 a7 68 10 00 	movl   $0x1068a7,(%esp)
  102db1:	e8 e7 d4 ff ff       	call   10029d <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  102db6:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102dbd:	e9 15 01 00 00       	jmp    102ed7 <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  102dc2:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102dc5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102dc8:	89 d0                	mov    %edx,%eax
  102dca:	c1 e0 02             	shl    $0x2,%eax
  102dcd:	01 d0                	add    %edx,%eax
  102dcf:	c1 e0 02             	shl    $0x2,%eax
  102dd2:	01 c8                	add    %ecx,%eax
  102dd4:	8b 50 08             	mov    0x8(%eax),%edx
  102dd7:	8b 40 04             	mov    0x4(%eax),%eax
  102dda:	89 45 b8             	mov    %eax,-0x48(%ebp)
  102ddd:	89 55 bc             	mov    %edx,-0x44(%ebp)
  102de0:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102de3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102de6:	89 d0                	mov    %edx,%eax
  102de8:	c1 e0 02             	shl    $0x2,%eax
  102deb:	01 d0                	add    %edx,%eax
  102ded:	c1 e0 02             	shl    $0x2,%eax
  102df0:	01 c8                	add    %ecx,%eax
  102df2:	8b 48 0c             	mov    0xc(%eax),%ecx
  102df5:	8b 58 10             	mov    0x10(%eax),%ebx
  102df8:	8b 45 b8             	mov    -0x48(%ebp),%eax
  102dfb:	8b 55 bc             	mov    -0x44(%ebp),%edx
  102dfe:	01 c8                	add    %ecx,%eax
  102e00:	11 da                	adc    %ebx,%edx
  102e02:	89 45 b0             	mov    %eax,-0x50(%ebp)
  102e05:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
  102e08:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102e0b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102e0e:	89 d0                	mov    %edx,%eax
  102e10:	c1 e0 02             	shl    $0x2,%eax
  102e13:	01 d0                	add    %edx,%eax
  102e15:	c1 e0 02             	shl    $0x2,%eax
  102e18:	01 c8                	add    %ecx,%eax
  102e1a:	83 c0 14             	add    $0x14,%eax
  102e1d:	8b 00                	mov    (%eax),%eax
  102e1f:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  102e25:	8b 45 b0             	mov    -0x50(%ebp),%eax
  102e28:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  102e2b:	83 c0 ff             	add    $0xffffffff,%eax
  102e2e:	83 d2 ff             	adc    $0xffffffff,%edx
  102e31:	89 c6                	mov    %eax,%esi
  102e33:	89 d7                	mov    %edx,%edi
  102e35:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102e38:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102e3b:	89 d0                	mov    %edx,%eax
  102e3d:	c1 e0 02             	shl    $0x2,%eax
  102e40:	01 d0                	add    %edx,%eax
  102e42:	c1 e0 02             	shl    $0x2,%eax
  102e45:	01 c8                	add    %ecx,%eax
  102e47:	8b 48 0c             	mov    0xc(%eax),%ecx
  102e4a:	8b 58 10             	mov    0x10(%eax),%ebx
  102e4d:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  102e53:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  102e57:	89 74 24 14          	mov    %esi,0x14(%esp)
  102e5b:	89 7c 24 18          	mov    %edi,0x18(%esp)
  102e5f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  102e62:	8b 55 bc             	mov    -0x44(%ebp),%edx
  102e65:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102e69:	89 54 24 10          	mov    %edx,0x10(%esp)
  102e6d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  102e71:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  102e75:	c7 04 24 b4 68 10 00 	movl   $0x1068b4,(%esp)
  102e7c:	e8 1c d4 ff ff       	call   10029d <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
  102e81:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102e84:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102e87:	89 d0                	mov    %edx,%eax
  102e89:	c1 e0 02             	shl    $0x2,%eax
  102e8c:	01 d0                	add    %edx,%eax
  102e8e:	c1 e0 02             	shl    $0x2,%eax
  102e91:	01 c8                	add    %ecx,%eax
  102e93:	83 c0 14             	add    $0x14,%eax
  102e96:	8b 00                	mov    (%eax),%eax
  102e98:	83 f8 01             	cmp    $0x1,%eax
  102e9b:	75 36                	jne    102ed3 <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
  102e9d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102ea0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102ea3:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  102ea6:	77 2b                	ja     102ed3 <page_init+0x14a>
  102ea8:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  102eab:	72 05                	jb     102eb2 <page_init+0x129>
  102ead:	3b 45 b0             	cmp    -0x50(%ebp),%eax
  102eb0:	73 21                	jae    102ed3 <page_init+0x14a>
  102eb2:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  102eb6:	77 1b                	ja     102ed3 <page_init+0x14a>
  102eb8:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  102ebc:	72 09                	jb     102ec7 <page_init+0x13e>
  102ebe:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
  102ec5:	77 0c                	ja     102ed3 <page_init+0x14a>
                maxpa = end;
  102ec7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  102eca:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  102ecd:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102ed0:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (i = 0; i < memmap->nr_map; i ++) {
  102ed3:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  102ed7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102eda:	8b 00                	mov    (%eax),%eax
  102edc:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  102edf:	0f 8f dd fe ff ff    	jg     102dc2 <page_init+0x39>
            }
        }
    }
    if (maxpa > KMEMSIZE) {
  102ee5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102ee9:	72 1d                	jb     102f08 <page_init+0x17f>
  102eeb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102eef:	77 09                	ja     102efa <page_init+0x171>
  102ef1:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
  102ef8:	76 0e                	jbe    102f08 <page_init+0x17f>
        maxpa = KMEMSIZE;
  102efa:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
  102f01:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
  102f08:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102f0b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102f0e:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  102f12:	c1 ea 0c             	shr    $0xc,%edx
  102f15:	a3 80 ae 11 00       	mov    %eax,0x11ae80

    // 将地址进行4K对齐
    // end 为bootloader加载完ucore的地址，以此地址为基础的地址是可以使用的，对齐后作为页表的起始地址
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
  102f1a:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  102f21:	b8 88 af 11 00       	mov    $0x11af88,%eax
  102f26:	8d 50 ff             	lea    -0x1(%eax),%edx
  102f29:	8b 45 ac             	mov    -0x54(%ebp),%eax
  102f2c:	01 d0                	add    %edx,%eax
  102f2e:	89 45 a8             	mov    %eax,-0x58(%ebp)
  102f31:	8b 45 a8             	mov    -0x58(%ebp),%eax
  102f34:	ba 00 00 00 00       	mov    $0x0,%edx
  102f39:	f7 75 ac             	divl   -0x54(%ebp)
  102f3c:	89 d0                	mov    %edx,%eax
  102f3e:	8b 55 a8             	mov    -0x58(%ebp),%edx
  102f41:	29 c2                	sub    %eax,%edx
  102f43:	89 d0                	mov    %edx,%eax
  102f45:	a3 78 af 11 00       	mov    %eax,0x11af78

    // 设置保留标志位
    for (i = 0; i < npage; i ++) {
  102f4a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102f51:	eb 2f                	jmp    102f82 <page_init+0x1f9>
        SetPageReserved(pages + i);
  102f53:	8b 0d 78 af 11 00    	mov    0x11af78,%ecx
  102f59:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102f5c:	89 d0                	mov    %edx,%eax
  102f5e:	c1 e0 02             	shl    $0x2,%eax
  102f61:	01 d0                	add    %edx,%eax
  102f63:	c1 e0 02             	shl    $0x2,%eax
  102f66:	01 c8                	add    %ecx,%eax
  102f68:	83 c0 04             	add    $0x4,%eax
  102f6b:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
  102f72:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102f75:	8b 45 8c             	mov    -0x74(%ebp),%eax
  102f78:	8b 55 90             	mov    -0x70(%ebp),%edx
  102f7b:	0f ab 10             	bts    %edx,(%eax)
    for (i = 0; i < npage; i ++) {
  102f7e:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  102f82:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102f85:	a1 80 ae 11 00       	mov    0x11ae80,%eax
  102f8a:	39 c2                	cmp    %eax,%edx
  102f8c:	72 c5                	jb     102f53 <page_init+0x1ca>
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
  102f8e:	8b 15 80 ae 11 00    	mov    0x11ae80,%edx
  102f94:	89 d0                	mov    %edx,%eax
  102f96:	c1 e0 02             	shl    $0x2,%eax
  102f99:	01 d0                	add    %edx,%eax
  102f9b:	c1 e0 02             	shl    $0x2,%eax
  102f9e:	89 c2                	mov    %eax,%edx
  102fa0:	a1 78 af 11 00       	mov    0x11af78,%eax
  102fa5:	01 d0                	add    %edx,%eax
  102fa7:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  102faa:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
  102fb1:	77 23                	ja     102fd6 <page_init+0x24d>
  102fb3:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  102fb6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102fba:	c7 44 24 08 e4 68 10 	movl   $0x1068e4,0x8(%esp)
  102fc1:	00 
  102fc2:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
  102fc9:	00 
  102fca:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  102fd1:	e8 1e d4 ff ff       	call   1003f4 <__panic>
  102fd6:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  102fd9:	05 00 00 00 40       	add    $0x40000000,%eax
  102fde:	89 45 a0             	mov    %eax,-0x60(%ebp)

    // 开始对其他页表项进行处理
    for (i = 0; i < memmap->nr_map; i ++) {
  102fe1:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102fe8:	e9 74 01 00 00       	jmp    103161 <page_init+0x3d8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  102fed:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102ff0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102ff3:	89 d0                	mov    %edx,%eax
  102ff5:	c1 e0 02             	shl    $0x2,%eax
  102ff8:	01 d0                	add    %edx,%eax
  102ffa:	c1 e0 02             	shl    $0x2,%eax
  102ffd:	01 c8                	add    %ecx,%eax
  102fff:	8b 50 08             	mov    0x8(%eax),%edx
  103002:	8b 40 04             	mov    0x4(%eax),%eax
  103005:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103008:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  10300b:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  10300e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103011:	89 d0                	mov    %edx,%eax
  103013:	c1 e0 02             	shl    $0x2,%eax
  103016:	01 d0                	add    %edx,%eax
  103018:	c1 e0 02             	shl    $0x2,%eax
  10301b:	01 c8                	add    %ecx,%eax
  10301d:	8b 48 0c             	mov    0xc(%eax),%ecx
  103020:	8b 58 10             	mov    0x10(%eax),%ebx
  103023:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103026:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103029:	01 c8                	add    %ecx,%eax
  10302b:	11 da                	adc    %ebx,%edx
  10302d:	89 45 c8             	mov    %eax,-0x38(%ebp)
  103030:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
  103033:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103036:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103039:	89 d0                	mov    %edx,%eax
  10303b:	c1 e0 02             	shl    $0x2,%eax
  10303e:	01 d0                	add    %edx,%eax
  103040:	c1 e0 02             	shl    $0x2,%eax
  103043:	01 c8                	add    %ecx,%eax
  103045:	83 c0 14             	add    $0x14,%eax
  103048:	8b 00                	mov    (%eax),%eax
  10304a:	83 f8 01             	cmp    $0x1,%eax
  10304d:	0f 85 0a 01 00 00    	jne    10315d <page_init+0x3d4>
            if (begin < freemem) {
  103053:	8b 45 a0             	mov    -0x60(%ebp),%eax
  103056:	ba 00 00 00 00       	mov    $0x0,%edx
  10305b:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  10305e:	72 17                	jb     103077 <page_init+0x2ee>
  103060:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  103063:	77 05                	ja     10306a <page_init+0x2e1>
  103065:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  103068:	76 0d                	jbe    103077 <page_init+0x2ee>
                begin = freemem;
  10306a:	8b 45 a0             	mov    -0x60(%ebp),%eax
  10306d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103070:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
  103077:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  10307b:	72 1d                	jb     10309a <page_init+0x311>
  10307d:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  103081:	77 09                	ja     10308c <page_init+0x303>
  103083:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
  10308a:	76 0e                	jbe    10309a <page_init+0x311>
                end = KMEMSIZE;
  10308c:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
  103093:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
  10309a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10309d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1030a0:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  1030a3:	0f 87 b4 00 00 00    	ja     10315d <page_init+0x3d4>
  1030a9:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  1030ac:	72 09                	jb     1030b7 <page_init+0x32e>
  1030ae:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  1030b1:	0f 83 a6 00 00 00    	jae    10315d <page_init+0x3d4>
                begin = ROUNDUP(begin, PGSIZE);
  1030b7:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
  1030be:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1030c1:	8b 45 9c             	mov    -0x64(%ebp),%eax
  1030c4:	01 d0                	add    %edx,%eax
  1030c6:	83 e8 01             	sub    $0x1,%eax
  1030c9:	89 45 98             	mov    %eax,-0x68(%ebp)
  1030cc:	8b 45 98             	mov    -0x68(%ebp),%eax
  1030cf:	ba 00 00 00 00       	mov    $0x0,%edx
  1030d4:	f7 75 9c             	divl   -0x64(%ebp)
  1030d7:	89 d0                	mov    %edx,%eax
  1030d9:	8b 55 98             	mov    -0x68(%ebp),%edx
  1030dc:	29 c2                	sub    %eax,%edx
  1030de:	89 d0                	mov    %edx,%eax
  1030e0:	ba 00 00 00 00       	mov    $0x0,%edx
  1030e5:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1030e8:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
  1030eb:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1030ee:	89 45 94             	mov    %eax,-0x6c(%ebp)
  1030f1:	8b 45 94             	mov    -0x6c(%ebp),%eax
  1030f4:	ba 00 00 00 00       	mov    $0x0,%edx
  1030f9:	89 c7                	mov    %eax,%edi
  1030fb:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  103101:	89 7d 80             	mov    %edi,-0x80(%ebp)
  103104:	89 d0                	mov    %edx,%eax
  103106:	83 e0 00             	and    $0x0,%eax
  103109:	89 45 84             	mov    %eax,-0x7c(%ebp)
  10310c:	8b 45 80             	mov    -0x80(%ebp),%eax
  10310f:	8b 55 84             	mov    -0x7c(%ebp),%edx
  103112:	89 45 c8             	mov    %eax,-0x38(%ebp)
  103115:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
  103118:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10311b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10311e:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  103121:	77 3a                	ja     10315d <page_init+0x3d4>
  103123:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  103126:	72 05                	jb     10312d <page_init+0x3a4>
  103128:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  10312b:	73 30                	jae    10315d <page_init+0x3d4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
  10312d:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  103130:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  103133:	8b 45 c8             	mov    -0x38(%ebp),%eax
  103136:	8b 55 cc             	mov    -0x34(%ebp),%edx
  103139:	29 c8                	sub    %ecx,%eax
  10313b:	19 da                	sbb    %ebx,%edx
  10313d:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  103141:	c1 ea 0c             	shr    $0xc,%edx
  103144:	89 c3                	mov    %eax,%ebx
  103146:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103149:	89 04 24             	mov    %eax,(%esp)
  10314c:	e8 a5 f8 ff ff       	call   1029f6 <pa2page>
  103151:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  103155:	89 04 24             	mov    %eax,(%esp)
  103158:	e8 78 fb ff ff       	call   102cd5 <init_memmap>
    for (i = 0; i < memmap->nr_map; i ++) {
  10315d:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  103161:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  103164:	8b 00                	mov    (%eax),%eax
  103166:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  103169:	0f 8f 7e fe ff ff    	jg     102fed <page_init+0x264>
                }
            }
        }
    }
}
  10316f:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  103175:	5b                   	pop    %ebx
  103176:	5e                   	pop    %esi
  103177:	5f                   	pop    %edi
  103178:	5d                   	pop    %ebp
  103179:	c3                   	ret    

0010317a <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
  10317a:	55                   	push   %ebp
  10317b:	89 e5                	mov    %esp,%ebp
  10317d:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
  103180:	8b 45 14             	mov    0x14(%ebp),%eax
  103183:	8b 55 0c             	mov    0xc(%ebp),%edx
  103186:	31 d0                	xor    %edx,%eax
  103188:	25 ff 0f 00 00       	and    $0xfff,%eax
  10318d:	85 c0                	test   %eax,%eax
  10318f:	74 24                	je     1031b5 <boot_map_segment+0x3b>
  103191:	c7 44 24 0c 16 69 10 	movl   $0x106916,0xc(%esp)
  103198:	00 
  103199:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  1031a0:	00 
  1031a1:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  1031a8:	00 
  1031a9:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  1031b0:	e8 3f d2 ff ff       	call   1003f4 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
  1031b5:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  1031bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1031bf:	25 ff 0f 00 00       	and    $0xfff,%eax
  1031c4:	89 c2                	mov    %eax,%edx
  1031c6:	8b 45 10             	mov    0x10(%ebp),%eax
  1031c9:	01 c2                	add    %eax,%edx
  1031cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1031ce:	01 d0                	add    %edx,%eax
  1031d0:	83 e8 01             	sub    $0x1,%eax
  1031d3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1031d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1031d9:	ba 00 00 00 00       	mov    $0x0,%edx
  1031de:	f7 75 f0             	divl   -0x10(%ebp)
  1031e1:	89 d0                	mov    %edx,%eax
  1031e3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1031e6:	29 c2                	sub    %eax,%edx
  1031e8:	89 d0                	mov    %edx,%eax
  1031ea:	c1 e8 0c             	shr    $0xc,%eax
  1031ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
  1031f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1031f3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1031f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1031f9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1031fe:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
  103201:	8b 45 14             	mov    0x14(%ebp),%eax
  103204:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103207:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10320a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10320f:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  103212:	eb 6b                	jmp    10327f <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
  103214:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  10321b:	00 
  10321c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10321f:	89 44 24 04          	mov    %eax,0x4(%esp)
  103223:	8b 45 08             	mov    0x8(%ebp),%eax
  103226:	89 04 24             	mov    %eax,(%esp)
  103229:	e8 82 01 00 00       	call   1033b0 <get_pte>
  10322e:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
  103231:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  103235:	75 24                	jne    10325b <boot_map_segment+0xe1>
  103237:	c7 44 24 0c 42 69 10 	movl   $0x106942,0xc(%esp)
  10323e:	00 
  10323f:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  103246:	00 
  103247:	c7 44 24 04 05 01 00 	movl   $0x105,0x4(%esp)
  10324e:	00 
  10324f:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103256:	e8 99 d1 ff ff       	call   1003f4 <__panic>
        *ptep = pa | PTE_P | perm;
  10325b:	8b 45 18             	mov    0x18(%ebp),%eax
  10325e:	8b 55 14             	mov    0x14(%ebp),%edx
  103261:	09 d0                	or     %edx,%eax
  103263:	83 c8 01             	or     $0x1,%eax
  103266:	89 c2                	mov    %eax,%edx
  103268:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10326b:	89 10                	mov    %edx,(%eax)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  10326d:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  103271:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
  103278:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  10327f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103283:	75 8f                	jne    103214 <boot_map_segment+0x9a>
    }
}
  103285:	c9                   	leave  
  103286:	c3                   	ret    

00103287 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
  103287:	55                   	push   %ebp
  103288:	89 e5                	mov    %esp,%ebp
  10328a:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
  10328d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103294:	e8 5b fa ff ff       	call   102cf4 <alloc_pages>
  103299:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
  10329c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1032a0:	75 1c                	jne    1032be <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
  1032a2:	c7 44 24 08 4f 69 10 	movl   $0x10694f,0x8(%esp)
  1032a9:	00 
  1032aa:	c7 44 24 04 11 01 00 	movl   $0x111,0x4(%esp)
  1032b1:	00 
  1032b2:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  1032b9:	e8 36 d1 ff ff       	call   1003f4 <__panic>
    }
    return page2kva(p);
  1032be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1032c1:	89 04 24             	mov    %eax,(%esp)
  1032c4:	e8 7c f7 ff ff       	call   102a45 <page2kva>
}
  1032c9:	c9                   	leave  
  1032ca:	c3                   	ret    

001032cb <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
  1032cb:	55                   	push   %ebp
  1032cc:	89 e5                	mov    %esp,%ebp
  1032ce:	83 ec 38             	sub    $0x38,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
  1032d1:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  1032d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1032d9:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  1032e0:	77 23                	ja     103305 <pmm_init+0x3a>
  1032e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1032e5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1032e9:	c7 44 24 08 e4 68 10 	movl   $0x1068e4,0x8(%esp)
  1032f0:	00 
  1032f1:	c7 44 24 04 1b 01 00 	movl   $0x11b,0x4(%esp)
  1032f8:	00 
  1032f9:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103300:	e8 ef d0 ff ff       	call   1003f4 <__panic>
  103305:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103308:	05 00 00 00 40       	add    $0x40000000,%eax
  10330d:	a3 74 af 11 00       	mov    %eax,0x11af74
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
  103312:	e8 8b f9 ff ff       	call   102ca2 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
  103317:	e8 6d fa ff ff       	call   102d89 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
  10331c:	e8 e0 03 00 00       	call   103701 <check_alloc_page>

    check_pgdir();
  103321:	e8 f9 03 00 00       	call   10371f <check_pgdir>

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT

    // boot_pgdir 和 VPT 都是PD的虚拟地址，是不同时期的虚拟地址
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
  103326:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  10332b:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
  103331:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103336:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103339:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  103340:	77 23                	ja     103365 <pmm_init+0x9a>
  103342:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103345:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103349:	c7 44 24 08 e4 68 10 	movl   $0x1068e4,0x8(%esp)
  103350:	00 
  103351:	c7 44 24 04 33 01 00 	movl   $0x133,0x4(%esp)
  103358:	00 
  103359:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103360:	e8 8f d0 ff ff       	call   1003f4 <__panic>
  103365:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103368:	05 00 00 00 40       	add    $0x40000000,%eax
  10336d:	83 c8 03             	or     $0x3,%eax
  103370:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
  103372:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103377:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
  10337e:	00 
  10337f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  103386:	00 
  103387:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
  10338e:	38 
  10338f:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
  103396:	c0 
  103397:	89 04 24             	mov    %eax,(%esp)
  10339a:	e8 db fd ff ff       	call   10317a <boot_map_segment>

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
  10339f:	e8 0f f8 ff ff       	call   102bb3 <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
  1033a4:	e8 11 0a 00 00       	call   103dba <check_boot_pgdir>

    print_pgdir();
  1033a9:	e8 99 0e 00 00       	call   104247 <print_pgdir>

}
  1033ae:	c9                   	leave  
  1033af:	c3                   	ret    

001033b0 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
  1033b0:	55                   	push   %ebp
  1033b1:	89 e5                	mov    %esp,%ebp
  1033b3:	83 ec 38             	sub    $0x38,%esp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    pde_t *pdep = &pgdir[PDX(la)];
  1033b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1033b9:	c1 e8 16             	shr    $0x16,%eax
  1033bc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1033c3:	8b 45 08             	mov    0x8(%ebp),%eax
  1033c6:	01 d0                	add    %edx,%eax
  1033c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(!(*pdep & PTE_P))
  1033cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1033ce:	8b 00                	mov    (%eax),%eax
  1033d0:	83 e0 01             	and    $0x1,%eax
  1033d3:	85 c0                	test   %eax,%eax
  1033d5:	0f 85 af 00 00 00    	jne    10348a <get_pte+0xda>
    {
    	struct Page *page;
    	if(!create || (page = alloc_page()) == NULL){
  1033db:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1033df:	74 15                	je     1033f6 <get_pte+0x46>
  1033e1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1033e8:	e8 07 f9 ff ff       	call   102cf4 <alloc_pages>
  1033ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1033f0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1033f4:	75 0a                	jne    103400 <get_pte+0x50>
    		return NULL;
  1033f6:	b8 00 00 00 00       	mov    $0x0,%eax
  1033fb:	e9 e6 00 00 00       	jmp    1034e6 <get_pte+0x136>
    	}
    	set_page_ref(page, 1);
  103400:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103407:	00 
  103408:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10340b:	89 04 24             	mov    %eax,(%esp)
  10340e:	e8 e6 f6 ff ff       	call   102af9 <set_page_ref>
    	// 获得刚申请页的物理地址
    	uintptr_t pa = page2pa(page);
  103413:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103416:	89 04 24             	mov    %eax,(%esp)
  103419:	e8 c2 f5 ff ff       	call   1029e0 <page2pa>
  10341e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    	// 函数所有的地址都是虚拟地址，利用KADDR进行转化
    	memset(KADDR(pa), 0, PGSIZE);
  103421:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103424:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103427:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10342a:	c1 e8 0c             	shr    $0xc,%eax
  10342d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103430:	a1 80 ae 11 00       	mov    0x11ae80,%eax
  103435:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  103438:	72 23                	jb     10345d <get_pte+0xad>
  10343a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10343d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103441:	c7 44 24 08 40 68 10 	movl   $0x106840,0x8(%esp)
  103448:	00 
  103449:	c7 44 24 04 7c 01 00 	movl   $0x17c,0x4(%esp)
  103450:	00 
  103451:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103458:	e8 97 cf ff ff       	call   1003f4 <__panic>
  10345d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103460:	2d 00 00 00 40       	sub    $0x40000000,%eax
  103465:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  10346c:	00 
  10346d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103474:	00 
  103475:	89 04 24             	mov    %eax,(%esp)
  103478:	e8 43 24 00 00       	call   1058c0 <memset>
    	*pdep = pa | PTE_U | PTE_W | PTE_P;
  10347d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103480:	83 c8 07             	or     $0x7,%eax
  103483:	89 c2                	mov    %eax,%edx
  103485:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103488:	89 10                	mov    %edx,(%eax)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];
  10348a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10348d:	8b 00                	mov    (%eax),%eax
  10348f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103494:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103497:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10349a:	c1 e8 0c             	shr    $0xc,%eax
  10349d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1034a0:	a1 80 ae 11 00       	mov    0x11ae80,%eax
  1034a5:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  1034a8:	72 23                	jb     1034cd <get_pte+0x11d>
  1034aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1034ad:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1034b1:	c7 44 24 08 40 68 10 	movl   $0x106840,0x8(%esp)
  1034b8:	00 
  1034b9:	c7 44 24 04 7f 01 00 	movl   $0x17f,0x4(%esp)
  1034c0:	00 
  1034c1:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  1034c8:	e8 27 cf ff ff       	call   1003f4 <__panic>
  1034cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1034d0:	2d 00 00 00 40       	sub    $0x40000000,%eax
  1034d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  1034d8:	c1 ea 0c             	shr    $0xc,%edx
  1034db:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  1034e1:	c1 e2 02             	shl    $0x2,%edx
  1034e4:	01 d0                	add    %edx,%eax

}
  1034e6:	c9                   	leave  
  1034e7:	c3                   	ret    

001034e8 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
  1034e8:	55                   	push   %ebp
  1034e9:	89 e5                	mov    %esp,%ebp
  1034eb:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  1034ee:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1034f5:	00 
  1034f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1034fd:	8b 45 08             	mov    0x8(%ebp),%eax
  103500:	89 04 24             	mov    %eax,(%esp)
  103503:	e8 a8 fe ff ff       	call   1033b0 <get_pte>
  103508:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
  10350b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10350f:	74 08                	je     103519 <get_page+0x31>
        *ptep_store = ptep;
  103511:	8b 45 10             	mov    0x10(%ebp),%eax
  103514:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103517:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
  103519:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10351d:	74 1b                	je     10353a <get_page+0x52>
  10351f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103522:	8b 00                	mov    (%eax),%eax
  103524:	83 e0 01             	and    $0x1,%eax
  103527:	85 c0                	test   %eax,%eax
  103529:	74 0f                	je     10353a <get_page+0x52>
        return pte2page(*ptep);
  10352b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10352e:	8b 00                	mov    (%eax),%eax
  103530:	89 04 24             	mov    %eax,(%esp)
  103533:	e8 61 f5 ff ff       	call   102a99 <pte2page>
  103538:	eb 05                	jmp    10353f <get_page+0x57>
    }
    return NULL;
  10353a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10353f:	c9                   	leave  
  103540:	c3                   	ret    

00103541 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
  103541:	55                   	push   %ebp
  103542:	89 e5                	mov    %esp,%ebp
  103544:	83 ec 28             	sub    $0x28,%esp
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif

    if(*ptep & PTE_P)
  103547:	8b 45 10             	mov    0x10(%ebp),%eax
  10354a:	8b 00                	mov    (%eax),%eax
  10354c:	83 e0 01             	and    $0x1,%eax
  10354f:	85 c0                	test   %eax,%eax
  103551:	74 52                	je     1035a5 <page_remove_pte+0x64>
    {
    	struct Page *page = pte2page(*ptep);
  103553:	8b 45 10             	mov    0x10(%ebp),%eax
  103556:	8b 00                	mov    (%eax),%eax
  103558:	89 04 24             	mov    %eax,(%esp)
  10355b:	e8 39 f5 ff ff       	call   102a99 <pte2page>
  103560:	89 45 f4             	mov    %eax,-0xc(%ebp)
    	page_ref_dec(page);
  103563:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103566:	89 04 24             	mov    %eax,(%esp)
  103569:	e8 af f5 ff ff       	call   102b1d <page_ref_dec>
    	if(page->ref == 0)
  10356e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103571:	8b 00                	mov    (%eax),%eax
  103573:	85 c0                	test   %eax,%eax
  103575:	75 13                	jne    10358a <page_remove_pte+0x49>
    	{
    		free_page(page);
  103577:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10357e:	00 
  10357f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103582:	89 04 24             	mov    %eax,(%esp)
  103585:	e8 a2 f7 ff ff       	call   102d2c <free_pages>
    	}
    	*ptep = 0;
  10358a:	8b 45 10             	mov    0x10(%ebp),%eax
  10358d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    	tlb_invalidate(pgdir, la);
  103593:	8b 45 0c             	mov    0xc(%ebp),%eax
  103596:	89 44 24 04          	mov    %eax,0x4(%esp)
  10359a:	8b 45 08             	mov    0x8(%ebp),%eax
  10359d:	89 04 24             	mov    %eax,(%esp)
  1035a0:	e8 ff 00 00 00       	call   1036a4 <tlb_invalidate>
    }
}
  1035a5:	c9                   	leave  
  1035a6:	c3                   	ret    

001035a7 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
  1035a7:	55                   	push   %ebp
  1035a8:	89 e5                	mov    %esp,%ebp
  1035aa:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  1035ad:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1035b4:	00 
  1035b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1035b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1035bc:	8b 45 08             	mov    0x8(%ebp),%eax
  1035bf:	89 04 24             	mov    %eax,(%esp)
  1035c2:	e8 e9 fd ff ff       	call   1033b0 <get_pte>
  1035c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
  1035ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1035ce:	74 19                	je     1035e9 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
  1035d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1035d3:	89 44 24 08          	mov    %eax,0x8(%esp)
  1035d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1035da:	89 44 24 04          	mov    %eax,0x4(%esp)
  1035de:	8b 45 08             	mov    0x8(%ebp),%eax
  1035e1:	89 04 24             	mov    %eax,(%esp)
  1035e4:	e8 58 ff ff ff       	call   103541 <page_remove_pte>
    }
}
  1035e9:	c9                   	leave  
  1035ea:	c3                   	ret    

001035eb <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
  1035eb:	55                   	push   %ebp
  1035ec:	89 e5                	mov    %esp,%ebp
  1035ee:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
  1035f1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  1035f8:	00 
  1035f9:	8b 45 10             	mov    0x10(%ebp),%eax
  1035fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  103600:	8b 45 08             	mov    0x8(%ebp),%eax
  103603:	89 04 24             	mov    %eax,(%esp)
  103606:	e8 a5 fd ff ff       	call   1033b0 <get_pte>
  10360b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
  10360e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103612:	75 0a                	jne    10361e <page_insert+0x33>
        return -E_NO_MEM;
  103614:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  103619:	e9 84 00 00 00       	jmp    1036a2 <page_insert+0xb7>
    }
    page_ref_inc(page);
  10361e:	8b 45 0c             	mov    0xc(%ebp),%eax
  103621:	89 04 24             	mov    %eax,(%esp)
  103624:	e8 dd f4 ff ff       	call   102b06 <page_ref_inc>
    if (*ptep & PTE_P) {
  103629:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10362c:	8b 00                	mov    (%eax),%eax
  10362e:	83 e0 01             	and    $0x1,%eax
  103631:	85 c0                	test   %eax,%eax
  103633:	74 3e                	je     103673 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
  103635:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103638:	8b 00                	mov    (%eax),%eax
  10363a:	89 04 24             	mov    %eax,(%esp)
  10363d:	e8 57 f4 ff ff       	call   102a99 <pte2page>
  103642:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
  103645:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103648:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10364b:	75 0d                	jne    10365a <page_insert+0x6f>
            page_ref_dec(page);
  10364d:	8b 45 0c             	mov    0xc(%ebp),%eax
  103650:	89 04 24             	mov    %eax,(%esp)
  103653:	e8 c5 f4 ff ff       	call   102b1d <page_ref_dec>
  103658:	eb 19                	jmp    103673 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
  10365a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10365d:	89 44 24 08          	mov    %eax,0x8(%esp)
  103661:	8b 45 10             	mov    0x10(%ebp),%eax
  103664:	89 44 24 04          	mov    %eax,0x4(%esp)
  103668:	8b 45 08             	mov    0x8(%ebp),%eax
  10366b:	89 04 24             	mov    %eax,(%esp)
  10366e:	e8 ce fe ff ff       	call   103541 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
  103673:	8b 45 0c             	mov    0xc(%ebp),%eax
  103676:	89 04 24             	mov    %eax,(%esp)
  103679:	e8 62 f3 ff ff       	call   1029e0 <page2pa>
  10367e:	0b 45 14             	or     0x14(%ebp),%eax
  103681:	83 c8 01             	or     $0x1,%eax
  103684:	89 c2                	mov    %eax,%edx
  103686:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103689:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
  10368b:	8b 45 10             	mov    0x10(%ebp),%eax
  10368e:	89 44 24 04          	mov    %eax,0x4(%esp)
  103692:	8b 45 08             	mov    0x8(%ebp),%eax
  103695:	89 04 24             	mov    %eax,(%esp)
  103698:	e8 07 00 00 00       	call   1036a4 <tlb_invalidate>
    return 0;
  10369d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1036a2:	c9                   	leave  
  1036a3:	c3                   	ret    

001036a4 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
  1036a4:	55                   	push   %ebp
  1036a5:	89 e5                	mov    %esp,%ebp
  1036a7:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
  1036aa:	0f 20 d8             	mov    %cr3,%eax
  1036ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
  1036b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
  1036b3:	89 c2                	mov    %eax,%edx
  1036b5:	8b 45 08             	mov    0x8(%ebp),%eax
  1036b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1036bb:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  1036c2:	77 23                	ja     1036e7 <tlb_invalidate+0x43>
  1036c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1036c7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1036cb:	c7 44 24 08 e4 68 10 	movl   $0x1068e4,0x8(%esp)
  1036d2:	00 
  1036d3:	c7 44 24 04 e6 01 00 	movl   $0x1e6,0x4(%esp)
  1036da:	00 
  1036db:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  1036e2:	e8 0d cd ff ff       	call   1003f4 <__panic>
  1036e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1036ea:	05 00 00 00 40       	add    $0x40000000,%eax
  1036ef:	39 c2                	cmp    %eax,%edx
  1036f1:	75 0c                	jne    1036ff <tlb_invalidate+0x5b>
        invlpg((void *)la);
  1036f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1036f6:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
  1036f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1036fc:	0f 01 38             	invlpg (%eax)
    }
}
  1036ff:	c9                   	leave  
  103700:	c3                   	ret    

00103701 <check_alloc_page>:

static void
check_alloc_page(void) {
  103701:	55                   	push   %ebp
  103702:	89 e5                	mov    %esp,%ebp
  103704:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
  103707:	a1 70 af 11 00       	mov    0x11af70,%eax
  10370c:	8b 40 18             	mov    0x18(%eax),%eax
  10370f:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
  103711:	c7 04 24 68 69 10 00 	movl   $0x106968,(%esp)
  103718:	e8 80 cb ff ff       	call   10029d <cprintf>
}
  10371d:	c9                   	leave  
  10371e:	c3                   	ret    

0010371f <check_pgdir>:

static void
check_pgdir(void) {
  10371f:	55                   	push   %ebp
  103720:	89 e5                	mov    %esp,%ebp
  103722:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
  103725:	a1 80 ae 11 00       	mov    0x11ae80,%eax
  10372a:	3d 00 80 03 00       	cmp    $0x38000,%eax
  10372f:	76 24                	jbe    103755 <check_pgdir+0x36>
  103731:	c7 44 24 0c 87 69 10 	movl   $0x106987,0xc(%esp)
  103738:	00 
  103739:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  103740:	00 
  103741:	c7 44 24 04 f3 01 00 	movl   $0x1f3,0x4(%esp)
  103748:	00 
  103749:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103750:	e8 9f cc ff ff       	call   1003f4 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
  103755:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  10375a:	85 c0                	test   %eax,%eax
  10375c:	74 0e                	je     10376c <check_pgdir+0x4d>
  10375e:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103763:	25 ff 0f 00 00       	and    $0xfff,%eax
  103768:	85 c0                	test   %eax,%eax
  10376a:	74 24                	je     103790 <check_pgdir+0x71>
  10376c:	c7 44 24 0c a4 69 10 	movl   $0x1069a4,0xc(%esp)
  103773:	00 
  103774:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  10377b:	00 
  10377c:	c7 44 24 04 f4 01 00 	movl   $0x1f4,0x4(%esp)
  103783:	00 
  103784:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  10378b:	e8 64 cc ff ff       	call   1003f4 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
  103790:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103795:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10379c:	00 
  10379d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1037a4:	00 
  1037a5:	89 04 24             	mov    %eax,(%esp)
  1037a8:	e8 3b fd ff ff       	call   1034e8 <get_page>
  1037ad:	85 c0                	test   %eax,%eax
  1037af:	74 24                	je     1037d5 <check_pgdir+0xb6>
  1037b1:	c7 44 24 0c dc 69 10 	movl   $0x1069dc,0xc(%esp)
  1037b8:	00 
  1037b9:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  1037c0:	00 
  1037c1:	c7 44 24 04 f5 01 00 	movl   $0x1f5,0x4(%esp)
  1037c8:	00 
  1037c9:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  1037d0:	e8 1f cc ff ff       	call   1003f4 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
  1037d5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1037dc:	e8 13 f5 ff ff       	call   102cf4 <alloc_pages>
  1037e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
  1037e4:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  1037e9:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  1037f0:	00 
  1037f1:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1037f8:	00 
  1037f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1037fc:	89 54 24 04          	mov    %edx,0x4(%esp)
  103800:	89 04 24             	mov    %eax,(%esp)
  103803:	e8 e3 fd ff ff       	call   1035eb <page_insert>
  103808:	85 c0                	test   %eax,%eax
  10380a:	74 24                	je     103830 <check_pgdir+0x111>
  10380c:	c7 44 24 0c 04 6a 10 	movl   $0x106a04,0xc(%esp)
  103813:	00 
  103814:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  10381b:	00 
  10381c:	c7 44 24 04 f9 01 00 	movl   $0x1f9,0x4(%esp)
  103823:	00 
  103824:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  10382b:	e8 c4 cb ff ff       	call   1003f4 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
  103830:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103835:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10383c:	00 
  10383d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103844:	00 
  103845:	89 04 24             	mov    %eax,(%esp)
  103848:	e8 63 fb ff ff       	call   1033b0 <get_pte>
  10384d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103850:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103854:	75 24                	jne    10387a <check_pgdir+0x15b>
  103856:	c7 44 24 0c 30 6a 10 	movl   $0x106a30,0xc(%esp)
  10385d:	00 
  10385e:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  103865:	00 
  103866:	c7 44 24 04 fc 01 00 	movl   $0x1fc,0x4(%esp)
  10386d:	00 
  10386e:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103875:	e8 7a cb ff ff       	call   1003f4 <__panic>
    assert(pte2page(*ptep) == p1);
  10387a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10387d:	8b 00                	mov    (%eax),%eax
  10387f:	89 04 24             	mov    %eax,(%esp)
  103882:	e8 12 f2 ff ff       	call   102a99 <pte2page>
  103887:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  10388a:	74 24                	je     1038b0 <check_pgdir+0x191>
  10388c:	c7 44 24 0c 5d 6a 10 	movl   $0x106a5d,0xc(%esp)
  103893:	00 
  103894:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  10389b:	00 
  10389c:	c7 44 24 04 fd 01 00 	movl   $0x1fd,0x4(%esp)
  1038a3:	00 
  1038a4:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  1038ab:	e8 44 cb ff ff       	call   1003f4 <__panic>
    assert(page_ref(p1) == 1);
  1038b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1038b3:	89 04 24             	mov    %eax,(%esp)
  1038b6:	e8 34 f2 ff ff       	call   102aef <page_ref>
  1038bb:	83 f8 01             	cmp    $0x1,%eax
  1038be:	74 24                	je     1038e4 <check_pgdir+0x1c5>
  1038c0:	c7 44 24 0c 73 6a 10 	movl   $0x106a73,0xc(%esp)
  1038c7:	00 
  1038c8:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  1038cf:	00 
  1038d0:	c7 44 24 04 fe 01 00 	movl   $0x1fe,0x4(%esp)
  1038d7:	00 
  1038d8:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  1038df:	e8 10 cb ff ff       	call   1003f4 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
  1038e4:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  1038e9:	8b 00                	mov    (%eax),%eax
  1038eb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1038f0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1038f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1038f6:	c1 e8 0c             	shr    $0xc,%eax
  1038f9:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1038fc:	a1 80 ae 11 00       	mov    0x11ae80,%eax
  103901:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  103904:	72 23                	jb     103929 <check_pgdir+0x20a>
  103906:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103909:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10390d:	c7 44 24 08 40 68 10 	movl   $0x106840,0x8(%esp)
  103914:	00 
  103915:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
  10391c:	00 
  10391d:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103924:	e8 cb ca ff ff       	call   1003f4 <__panic>
  103929:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10392c:	2d 00 00 00 40       	sub    $0x40000000,%eax
  103931:	83 c0 04             	add    $0x4,%eax
  103934:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
  103937:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  10393c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103943:	00 
  103944:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  10394b:	00 
  10394c:	89 04 24             	mov    %eax,(%esp)
  10394f:	e8 5c fa ff ff       	call   1033b0 <get_pte>
  103954:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  103957:	74 24                	je     10397d <check_pgdir+0x25e>
  103959:	c7 44 24 0c 88 6a 10 	movl   $0x106a88,0xc(%esp)
  103960:	00 
  103961:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  103968:	00 
  103969:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
  103970:	00 
  103971:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103978:	e8 77 ca ff ff       	call   1003f4 <__panic>

    p2 = alloc_page();
  10397d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103984:	e8 6b f3 ff ff       	call   102cf4 <alloc_pages>
  103989:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
  10398c:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103991:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  103998:	00 
  103999:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  1039a0:	00 
  1039a1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1039a4:	89 54 24 04          	mov    %edx,0x4(%esp)
  1039a8:	89 04 24             	mov    %eax,(%esp)
  1039ab:	e8 3b fc ff ff       	call   1035eb <page_insert>
  1039b0:	85 c0                	test   %eax,%eax
  1039b2:	74 24                	je     1039d8 <check_pgdir+0x2b9>
  1039b4:	c7 44 24 0c b0 6a 10 	movl   $0x106ab0,0xc(%esp)
  1039bb:	00 
  1039bc:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  1039c3:	00 
  1039c4:	c7 44 24 04 04 02 00 	movl   $0x204,0x4(%esp)
  1039cb:	00 
  1039cc:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  1039d3:	e8 1c ca ff ff       	call   1003f4 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  1039d8:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  1039dd:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1039e4:	00 
  1039e5:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  1039ec:	00 
  1039ed:	89 04 24             	mov    %eax,(%esp)
  1039f0:	e8 bb f9 ff ff       	call   1033b0 <get_pte>
  1039f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1039f8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1039fc:	75 24                	jne    103a22 <check_pgdir+0x303>
  1039fe:	c7 44 24 0c e8 6a 10 	movl   $0x106ae8,0xc(%esp)
  103a05:	00 
  103a06:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  103a0d:	00 
  103a0e:	c7 44 24 04 05 02 00 	movl   $0x205,0x4(%esp)
  103a15:	00 
  103a16:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103a1d:	e8 d2 c9 ff ff       	call   1003f4 <__panic>
    assert(*ptep & PTE_U);
  103a22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103a25:	8b 00                	mov    (%eax),%eax
  103a27:	83 e0 04             	and    $0x4,%eax
  103a2a:	85 c0                	test   %eax,%eax
  103a2c:	75 24                	jne    103a52 <check_pgdir+0x333>
  103a2e:	c7 44 24 0c 18 6b 10 	movl   $0x106b18,0xc(%esp)
  103a35:	00 
  103a36:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  103a3d:	00 
  103a3e:	c7 44 24 04 06 02 00 	movl   $0x206,0x4(%esp)
  103a45:	00 
  103a46:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103a4d:	e8 a2 c9 ff ff       	call   1003f4 <__panic>
    assert(*ptep & PTE_W);
  103a52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103a55:	8b 00                	mov    (%eax),%eax
  103a57:	83 e0 02             	and    $0x2,%eax
  103a5a:	85 c0                	test   %eax,%eax
  103a5c:	75 24                	jne    103a82 <check_pgdir+0x363>
  103a5e:	c7 44 24 0c 26 6b 10 	movl   $0x106b26,0xc(%esp)
  103a65:	00 
  103a66:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  103a6d:	00 
  103a6e:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
  103a75:	00 
  103a76:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103a7d:	e8 72 c9 ff ff       	call   1003f4 <__panic>
    assert(boot_pgdir[0] & PTE_U);
  103a82:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103a87:	8b 00                	mov    (%eax),%eax
  103a89:	83 e0 04             	and    $0x4,%eax
  103a8c:	85 c0                	test   %eax,%eax
  103a8e:	75 24                	jne    103ab4 <check_pgdir+0x395>
  103a90:	c7 44 24 0c 34 6b 10 	movl   $0x106b34,0xc(%esp)
  103a97:	00 
  103a98:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  103a9f:	00 
  103aa0:	c7 44 24 04 08 02 00 	movl   $0x208,0x4(%esp)
  103aa7:	00 
  103aa8:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103aaf:	e8 40 c9 ff ff       	call   1003f4 <__panic>
    assert(page_ref(p2) == 1);
  103ab4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103ab7:	89 04 24             	mov    %eax,(%esp)
  103aba:	e8 30 f0 ff ff       	call   102aef <page_ref>
  103abf:	83 f8 01             	cmp    $0x1,%eax
  103ac2:	74 24                	je     103ae8 <check_pgdir+0x3c9>
  103ac4:	c7 44 24 0c 4a 6b 10 	movl   $0x106b4a,0xc(%esp)
  103acb:	00 
  103acc:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  103ad3:	00 
  103ad4:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
  103adb:	00 
  103adc:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103ae3:	e8 0c c9 ff ff       	call   1003f4 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
  103ae8:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103aed:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  103af4:	00 
  103af5:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  103afc:	00 
  103afd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103b00:	89 54 24 04          	mov    %edx,0x4(%esp)
  103b04:	89 04 24             	mov    %eax,(%esp)
  103b07:	e8 df fa ff ff       	call   1035eb <page_insert>
  103b0c:	85 c0                	test   %eax,%eax
  103b0e:	74 24                	je     103b34 <check_pgdir+0x415>
  103b10:	c7 44 24 0c 5c 6b 10 	movl   $0x106b5c,0xc(%esp)
  103b17:	00 
  103b18:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  103b1f:	00 
  103b20:	c7 44 24 04 0b 02 00 	movl   $0x20b,0x4(%esp)
  103b27:	00 
  103b28:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103b2f:	e8 c0 c8 ff ff       	call   1003f4 <__panic>
    assert(page_ref(p1) == 2);
  103b34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103b37:	89 04 24             	mov    %eax,(%esp)
  103b3a:	e8 b0 ef ff ff       	call   102aef <page_ref>
  103b3f:	83 f8 02             	cmp    $0x2,%eax
  103b42:	74 24                	je     103b68 <check_pgdir+0x449>
  103b44:	c7 44 24 0c 88 6b 10 	movl   $0x106b88,0xc(%esp)
  103b4b:	00 
  103b4c:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  103b53:	00 
  103b54:	c7 44 24 04 0c 02 00 	movl   $0x20c,0x4(%esp)
  103b5b:	00 
  103b5c:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103b63:	e8 8c c8 ff ff       	call   1003f4 <__panic>
    assert(page_ref(p2) == 0);
  103b68:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103b6b:	89 04 24             	mov    %eax,(%esp)
  103b6e:	e8 7c ef ff ff       	call   102aef <page_ref>
  103b73:	85 c0                	test   %eax,%eax
  103b75:	74 24                	je     103b9b <check_pgdir+0x47c>
  103b77:	c7 44 24 0c 9a 6b 10 	movl   $0x106b9a,0xc(%esp)
  103b7e:	00 
  103b7f:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  103b86:	00 
  103b87:	c7 44 24 04 0d 02 00 	movl   $0x20d,0x4(%esp)
  103b8e:	00 
  103b8f:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103b96:	e8 59 c8 ff ff       	call   1003f4 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  103b9b:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103ba0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103ba7:	00 
  103ba8:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103baf:	00 
  103bb0:	89 04 24             	mov    %eax,(%esp)
  103bb3:	e8 f8 f7 ff ff       	call   1033b0 <get_pte>
  103bb8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103bbb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103bbf:	75 24                	jne    103be5 <check_pgdir+0x4c6>
  103bc1:	c7 44 24 0c e8 6a 10 	movl   $0x106ae8,0xc(%esp)
  103bc8:	00 
  103bc9:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  103bd0:	00 
  103bd1:	c7 44 24 04 0e 02 00 	movl   $0x20e,0x4(%esp)
  103bd8:	00 
  103bd9:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103be0:	e8 0f c8 ff ff       	call   1003f4 <__panic>
    assert(pte2page(*ptep) == p1);
  103be5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103be8:	8b 00                	mov    (%eax),%eax
  103bea:	89 04 24             	mov    %eax,(%esp)
  103bed:	e8 a7 ee ff ff       	call   102a99 <pte2page>
  103bf2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  103bf5:	74 24                	je     103c1b <check_pgdir+0x4fc>
  103bf7:	c7 44 24 0c 5d 6a 10 	movl   $0x106a5d,0xc(%esp)
  103bfe:	00 
  103bff:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  103c06:	00 
  103c07:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
  103c0e:	00 
  103c0f:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103c16:	e8 d9 c7 ff ff       	call   1003f4 <__panic>
    assert((*ptep & PTE_U) == 0);
  103c1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103c1e:	8b 00                	mov    (%eax),%eax
  103c20:	83 e0 04             	and    $0x4,%eax
  103c23:	85 c0                	test   %eax,%eax
  103c25:	74 24                	je     103c4b <check_pgdir+0x52c>
  103c27:	c7 44 24 0c ac 6b 10 	movl   $0x106bac,0xc(%esp)
  103c2e:	00 
  103c2f:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  103c36:	00 
  103c37:	c7 44 24 04 10 02 00 	movl   $0x210,0x4(%esp)
  103c3e:	00 
  103c3f:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103c46:	e8 a9 c7 ff ff       	call   1003f4 <__panic>

    page_remove(boot_pgdir, 0x0);
  103c4b:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103c50:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103c57:	00 
  103c58:	89 04 24             	mov    %eax,(%esp)
  103c5b:	e8 47 f9 ff ff       	call   1035a7 <page_remove>
    assert(page_ref(p1) == 1);
  103c60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103c63:	89 04 24             	mov    %eax,(%esp)
  103c66:	e8 84 ee ff ff       	call   102aef <page_ref>
  103c6b:	83 f8 01             	cmp    $0x1,%eax
  103c6e:	74 24                	je     103c94 <check_pgdir+0x575>
  103c70:	c7 44 24 0c 73 6a 10 	movl   $0x106a73,0xc(%esp)
  103c77:	00 
  103c78:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  103c7f:	00 
  103c80:	c7 44 24 04 13 02 00 	movl   $0x213,0x4(%esp)
  103c87:	00 
  103c88:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103c8f:	e8 60 c7 ff ff       	call   1003f4 <__panic>
    assert(page_ref(p2) == 0);
  103c94:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103c97:	89 04 24             	mov    %eax,(%esp)
  103c9a:	e8 50 ee ff ff       	call   102aef <page_ref>
  103c9f:	85 c0                	test   %eax,%eax
  103ca1:	74 24                	je     103cc7 <check_pgdir+0x5a8>
  103ca3:	c7 44 24 0c 9a 6b 10 	movl   $0x106b9a,0xc(%esp)
  103caa:	00 
  103cab:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  103cb2:	00 
  103cb3:	c7 44 24 04 14 02 00 	movl   $0x214,0x4(%esp)
  103cba:	00 
  103cbb:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103cc2:	e8 2d c7 ff ff       	call   1003f4 <__panic>

    page_remove(boot_pgdir, PGSIZE);
  103cc7:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103ccc:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103cd3:	00 
  103cd4:	89 04 24             	mov    %eax,(%esp)
  103cd7:	e8 cb f8 ff ff       	call   1035a7 <page_remove>
    assert(page_ref(p1) == 0);
  103cdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103cdf:	89 04 24             	mov    %eax,(%esp)
  103ce2:	e8 08 ee ff ff       	call   102aef <page_ref>
  103ce7:	85 c0                	test   %eax,%eax
  103ce9:	74 24                	je     103d0f <check_pgdir+0x5f0>
  103ceb:	c7 44 24 0c c1 6b 10 	movl   $0x106bc1,0xc(%esp)
  103cf2:	00 
  103cf3:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  103cfa:	00 
  103cfb:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
  103d02:	00 
  103d03:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103d0a:	e8 e5 c6 ff ff       	call   1003f4 <__panic>
    assert(page_ref(p2) == 0);
  103d0f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103d12:	89 04 24             	mov    %eax,(%esp)
  103d15:	e8 d5 ed ff ff       	call   102aef <page_ref>
  103d1a:	85 c0                	test   %eax,%eax
  103d1c:	74 24                	je     103d42 <check_pgdir+0x623>
  103d1e:	c7 44 24 0c 9a 6b 10 	movl   $0x106b9a,0xc(%esp)
  103d25:	00 
  103d26:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  103d2d:	00 
  103d2e:	c7 44 24 04 18 02 00 	movl   $0x218,0x4(%esp)
  103d35:	00 
  103d36:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103d3d:	e8 b2 c6 ff ff       	call   1003f4 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
  103d42:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103d47:	8b 00                	mov    (%eax),%eax
  103d49:	89 04 24             	mov    %eax,(%esp)
  103d4c:	e8 86 ed ff ff       	call   102ad7 <pde2page>
  103d51:	89 04 24             	mov    %eax,(%esp)
  103d54:	e8 96 ed ff ff       	call   102aef <page_ref>
  103d59:	83 f8 01             	cmp    $0x1,%eax
  103d5c:	74 24                	je     103d82 <check_pgdir+0x663>
  103d5e:	c7 44 24 0c d4 6b 10 	movl   $0x106bd4,0xc(%esp)
  103d65:	00 
  103d66:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  103d6d:	00 
  103d6e:	c7 44 24 04 1a 02 00 	movl   $0x21a,0x4(%esp)
  103d75:	00 
  103d76:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103d7d:	e8 72 c6 ff ff       	call   1003f4 <__panic>
    free_page(pde2page(boot_pgdir[0]));
  103d82:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103d87:	8b 00                	mov    (%eax),%eax
  103d89:	89 04 24             	mov    %eax,(%esp)
  103d8c:	e8 46 ed ff ff       	call   102ad7 <pde2page>
  103d91:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103d98:	00 
  103d99:	89 04 24             	mov    %eax,(%esp)
  103d9c:	e8 8b ef ff ff       	call   102d2c <free_pages>
    boot_pgdir[0] = 0;
  103da1:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103da6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
  103dac:	c7 04 24 fb 6b 10 00 	movl   $0x106bfb,(%esp)
  103db3:	e8 e5 c4 ff ff       	call   10029d <cprintf>
}
  103db8:	c9                   	leave  
  103db9:	c3                   	ret    

00103dba <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
  103dba:	55                   	push   %ebp
  103dbb:	89 e5                	mov    %esp,%ebp
  103dbd:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  103dc0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  103dc7:	e9 ca 00 00 00       	jmp    103e96 <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
  103dcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103dcf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103dd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103dd5:	c1 e8 0c             	shr    $0xc,%eax
  103dd8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103ddb:	a1 80 ae 11 00       	mov    0x11ae80,%eax
  103de0:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  103de3:	72 23                	jb     103e08 <check_boot_pgdir+0x4e>
  103de5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103de8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103dec:	c7 44 24 08 40 68 10 	movl   $0x106840,0x8(%esp)
  103df3:	00 
  103df4:	c7 44 24 04 26 02 00 	movl   $0x226,0x4(%esp)
  103dfb:	00 
  103dfc:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103e03:	e8 ec c5 ff ff       	call   1003f4 <__panic>
  103e08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103e0b:	2d 00 00 00 40       	sub    $0x40000000,%eax
  103e10:	89 c2                	mov    %eax,%edx
  103e12:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103e17:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103e1e:	00 
  103e1f:	89 54 24 04          	mov    %edx,0x4(%esp)
  103e23:	89 04 24             	mov    %eax,(%esp)
  103e26:	e8 85 f5 ff ff       	call   1033b0 <get_pte>
  103e2b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103e2e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103e32:	75 24                	jne    103e58 <check_boot_pgdir+0x9e>
  103e34:	c7 44 24 0c 18 6c 10 	movl   $0x106c18,0xc(%esp)
  103e3b:	00 
  103e3c:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  103e43:	00 
  103e44:	c7 44 24 04 26 02 00 	movl   $0x226,0x4(%esp)
  103e4b:	00 
  103e4c:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103e53:	e8 9c c5 ff ff       	call   1003f4 <__panic>
        assert(PTE_ADDR(*ptep) == i);
  103e58:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103e5b:	8b 00                	mov    (%eax),%eax
  103e5d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103e62:	89 c2                	mov    %eax,%edx
  103e64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103e67:	39 c2                	cmp    %eax,%edx
  103e69:	74 24                	je     103e8f <check_boot_pgdir+0xd5>
  103e6b:	c7 44 24 0c 55 6c 10 	movl   $0x106c55,0xc(%esp)
  103e72:	00 
  103e73:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  103e7a:	00 
  103e7b:	c7 44 24 04 27 02 00 	movl   $0x227,0x4(%esp)
  103e82:	00 
  103e83:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103e8a:	e8 65 c5 ff ff       	call   1003f4 <__panic>
    for (i = 0; i < npage; i += PGSIZE) {
  103e8f:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  103e96:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103e99:	a1 80 ae 11 00       	mov    0x11ae80,%eax
  103e9e:	39 c2                	cmp    %eax,%edx
  103ea0:	0f 82 26 ff ff ff    	jb     103dcc <check_boot_pgdir+0x12>
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
  103ea6:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103eab:	05 ac 0f 00 00       	add    $0xfac,%eax
  103eb0:	8b 00                	mov    (%eax),%eax
  103eb2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103eb7:	89 c2                	mov    %eax,%edx
  103eb9:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103ebe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103ec1:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
  103ec8:	77 23                	ja     103eed <check_boot_pgdir+0x133>
  103eca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103ecd:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103ed1:	c7 44 24 08 e4 68 10 	movl   $0x1068e4,0x8(%esp)
  103ed8:	00 
  103ed9:	c7 44 24 04 2a 02 00 	movl   $0x22a,0x4(%esp)
  103ee0:	00 
  103ee1:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103ee8:	e8 07 c5 ff ff       	call   1003f4 <__panic>
  103eed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103ef0:	05 00 00 00 40       	add    $0x40000000,%eax
  103ef5:	39 c2                	cmp    %eax,%edx
  103ef7:	74 24                	je     103f1d <check_boot_pgdir+0x163>
  103ef9:	c7 44 24 0c 6c 6c 10 	movl   $0x106c6c,0xc(%esp)
  103f00:	00 
  103f01:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  103f08:	00 
  103f09:	c7 44 24 04 2a 02 00 	movl   $0x22a,0x4(%esp)
  103f10:	00 
  103f11:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103f18:	e8 d7 c4 ff ff       	call   1003f4 <__panic>

    assert(boot_pgdir[0] == 0);
  103f1d:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103f22:	8b 00                	mov    (%eax),%eax
  103f24:	85 c0                	test   %eax,%eax
  103f26:	74 24                	je     103f4c <check_boot_pgdir+0x192>
  103f28:	c7 44 24 0c a0 6c 10 	movl   $0x106ca0,0xc(%esp)
  103f2f:	00 
  103f30:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  103f37:	00 
  103f38:	c7 44 24 04 2c 02 00 	movl   $0x22c,0x4(%esp)
  103f3f:	00 
  103f40:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103f47:	e8 a8 c4 ff ff       	call   1003f4 <__panic>

    struct Page *p;
    p = alloc_page();
  103f4c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103f53:	e8 9c ed ff ff       	call   102cf4 <alloc_pages>
  103f58:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
  103f5b:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103f60:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  103f67:	00 
  103f68:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
  103f6f:	00 
  103f70:	8b 55 e0             	mov    -0x20(%ebp),%edx
  103f73:	89 54 24 04          	mov    %edx,0x4(%esp)
  103f77:	89 04 24             	mov    %eax,(%esp)
  103f7a:	e8 6c f6 ff ff       	call   1035eb <page_insert>
  103f7f:	85 c0                	test   %eax,%eax
  103f81:	74 24                	je     103fa7 <check_boot_pgdir+0x1ed>
  103f83:	c7 44 24 0c b4 6c 10 	movl   $0x106cb4,0xc(%esp)
  103f8a:	00 
  103f8b:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  103f92:	00 
  103f93:	c7 44 24 04 30 02 00 	movl   $0x230,0x4(%esp)
  103f9a:	00 
  103f9b:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103fa2:	e8 4d c4 ff ff       	call   1003f4 <__panic>
    assert(page_ref(p) == 1);
  103fa7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103faa:	89 04 24             	mov    %eax,(%esp)
  103fad:	e8 3d eb ff ff       	call   102aef <page_ref>
  103fb2:	83 f8 01             	cmp    $0x1,%eax
  103fb5:	74 24                	je     103fdb <check_boot_pgdir+0x221>
  103fb7:	c7 44 24 0c e2 6c 10 	movl   $0x106ce2,0xc(%esp)
  103fbe:	00 
  103fbf:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  103fc6:	00 
  103fc7:	c7 44 24 04 31 02 00 	movl   $0x231,0x4(%esp)
  103fce:	00 
  103fcf:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103fd6:	e8 19 c4 ff ff       	call   1003f4 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
  103fdb:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103fe0:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  103fe7:	00 
  103fe8:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
  103fef:	00 
  103ff0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  103ff3:	89 54 24 04          	mov    %edx,0x4(%esp)
  103ff7:	89 04 24             	mov    %eax,(%esp)
  103ffa:	e8 ec f5 ff ff       	call   1035eb <page_insert>
  103fff:	85 c0                	test   %eax,%eax
  104001:	74 24                	je     104027 <check_boot_pgdir+0x26d>
  104003:	c7 44 24 0c f4 6c 10 	movl   $0x106cf4,0xc(%esp)
  10400a:	00 
  10400b:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  104012:	00 
  104013:	c7 44 24 04 32 02 00 	movl   $0x232,0x4(%esp)
  10401a:	00 
  10401b:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  104022:	e8 cd c3 ff ff       	call   1003f4 <__panic>
    assert(page_ref(p) == 2);
  104027:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10402a:	89 04 24             	mov    %eax,(%esp)
  10402d:	e8 bd ea ff ff       	call   102aef <page_ref>
  104032:	83 f8 02             	cmp    $0x2,%eax
  104035:	74 24                	je     10405b <check_boot_pgdir+0x2a1>
  104037:	c7 44 24 0c 2b 6d 10 	movl   $0x106d2b,0xc(%esp)
  10403e:	00 
  10403f:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  104046:	00 
  104047:	c7 44 24 04 33 02 00 	movl   $0x233,0x4(%esp)
  10404e:	00 
  10404f:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  104056:	e8 99 c3 ff ff       	call   1003f4 <__panic>

    const char *str = "ucore: Hello world!!";
  10405b:	c7 45 dc 3c 6d 10 00 	movl   $0x106d3c,-0x24(%ebp)
    strcpy((void *)0x100, str);
  104062:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104065:	89 44 24 04          	mov    %eax,0x4(%esp)
  104069:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  104070:	e8 74 15 00 00       	call   1055e9 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
  104075:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
  10407c:	00 
  10407d:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  104084:	e8 d9 15 00 00       	call   105662 <strcmp>
  104089:	85 c0                	test   %eax,%eax
  10408b:	74 24                	je     1040b1 <check_boot_pgdir+0x2f7>
  10408d:	c7 44 24 0c 54 6d 10 	movl   $0x106d54,0xc(%esp)
  104094:	00 
  104095:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  10409c:	00 
  10409d:	c7 44 24 04 37 02 00 	movl   $0x237,0x4(%esp)
  1040a4:	00 
  1040a5:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  1040ac:	e8 43 c3 ff ff       	call   1003f4 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
  1040b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1040b4:	89 04 24             	mov    %eax,(%esp)
  1040b7:	e8 89 e9 ff ff       	call   102a45 <page2kva>
  1040bc:	05 00 01 00 00       	add    $0x100,%eax
  1040c1:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
  1040c4:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  1040cb:	e8 c1 14 00 00       	call   105591 <strlen>
  1040d0:	85 c0                	test   %eax,%eax
  1040d2:	74 24                	je     1040f8 <check_boot_pgdir+0x33e>
  1040d4:	c7 44 24 0c 8c 6d 10 	movl   $0x106d8c,0xc(%esp)
  1040db:	00 
  1040dc:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  1040e3:	00 
  1040e4:	c7 44 24 04 3a 02 00 	movl   $0x23a,0x4(%esp)
  1040eb:	00 
  1040ec:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  1040f3:	e8 fc c2 ff ff       	call   1003f4 <__panic>

    free_page(p);
  1040f8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1040ff:	00 
  104100:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104103:	89 04 24             	mov    %eax,(%esp)
  104106:	e8 21 ec ff ff       	call   102d2c <free_pages>
    free_page(pde2page(boot_pgdir[0]));
  10410b:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  104110:	8b 00                	mov    (%eax),%eax
  104112:	89 04 24             	mov    %eax,(%esp)
  104115:	e8 bd e9 ff ff       	call   102ad7 <pde2page>
  10411a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104121:	00 
  104122:	89 04 24             	mov    %eax,(%esp)
  104125:	e8 02 ec ff ff       	call   102d2c <free_pages>
    boot_pgdir[0] = 0;
  10412a:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  10412f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
  104135:	c7 04 24 b0 6d 10 00 	movl   $0x106db0,(%esp)
  10413c:	e8 5c c1 ff ff       	call   10029d <cprintf>
}
  104141:	c9                   	leave  
  104142:	c3                   	ret    

00104143 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
  104143:	55                   	push   %ebp
  104144:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
  104146:	8b 45 08             	mov    0x8(%ebp),%eax
  104149:	83 e0 04             	and    $0x4,%eax
  10414c:	85 c0                	test   %eax,%eax
  10414e:	74 07                	je     104157 <perm2str+0x14>
  104150:	b8 75 00 00 00       	mov    $0x75,%eax
  104155:	eb 05                	jmp    10415c <perm2str+0x19>
  104157:	b8 2d 00 00 00       	mov    $0x2d,%eax
  10415c:	a2 08 af 11 00       	mov    %al,0x11af08
    str[1] = 'r';
  104161:	c6 05 09 af 11 00 72 	movb   $0x72,0x11af09
    str[2] = (perm & PTE_W) ? 'w' : '-';
  104168:	8b 45 08             	mov    0x8(%ebp),%eax
  10416b:	83 e0 02             	and    $0x2,%eax
  10416e:	85 c0                	test   %eax,%eax
  104170:	74 07                	je     104179 <perm2str+0x36>
  104172:	b8 77 00 00 00       	mov    $0x77,%eax
  104177:	eb 05                	jmp    10417e <perm2str+0x3b>
  104179:	b8 2d 00 00 00       	mov    $0x2d,%eax
  10417e:	a2 0a af 11 00       	mov    %al,0x11af0a
    str[3] = '\0';
  104183:	c6 05 0b af 11 00 00 	movb   $0x0,0x11af0b
    return str;
  10418a:	b8 08 af 11 00       	mov    $0x11af08,%eax
}
  10418f:	5d                   	pop    %ebp
  104190:	c3                   	ret    

00104191 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
  104191:	55                   	push   %ebp
  104192:	89 e5                	mov    %esp,%ebp
  104194:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
  104197:	8b 45 10             	mov    0x10(%ebp),%eax
  10419a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10419d:	72 0a                	jb     1041a9 <get_pgtable_items+0x18>
        return 0;
  10419f:	b8 00 00 00 00       	mov    $0x0,%eax
  1041a4:	e9 9c 00 00 00       	jmp    104245 <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
  1041a9:	eb 04                	jmp    1041af <get_pgtable_items+0x1e>
        start ++;
  1041ab:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    while (start < right && !(table[start] & PTE_P)) {
  1041af:	8b 45 10             	mov    0x10(%ebp),%eax
  1041b2:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1041b5:	73 18                	jae    1041cf <get_pgtable_items+0x3e>
  1041b7:	8b 45 10             	mov    0x10(%ebp),%eax
  1041ba:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1041c1:	8b 45 14             	mov    0x14(%ebp),%eax
  1041c4:	01 d0                	add    %edx,%eax
  1041c6:	8b 00                	mov    (%eax),%eax
  1041c8:	83 e0 01             	and    $0x1,%eax
  1041cb:	85 c0                	test   %eax,%eax
  1041cd:	74 dc                	je     1041ab <get_pgtable_items+0x1a>
    }
    if (start < right) {
  1041cf:	8b 45 10             	mov    0x10(%ebp),%eax
  1041d2:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1041d5:	73 69                	jae    104240 <get_pgtable_items+0xaf>
        if (left_store != NULL) {
  1041d7:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
  1041db:	74 08                	je     1041e5 <get_pgtable_items+0x54>
            *left_store = start;
  1041dd:	8b 45 18             	mov    0x18(%ebp),%eax
  1041e0:	8b 55 10             	mov    0x10(%ebp),%edx
  1041e3:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
  1041e5:	8b 45 10             	mov    0x10(%ebp),%eax
  1041e8:	8d 50 01             	lea    0x1(%eax),%edx
  1041eb:	89 55 10             	mov    %edx,0x10(%ebp)
  1041ee:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1041f5:	8b 45 14             	mov    0x14(%ebp),%eax
  1041f8:	01 d0                	add    %edx,%eax
  1041fa:	8b 00                	mov    (%eax),%eax
  1041fc:	83 e0 07             	and    $0x7,%eax
  1041ff:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  104202:	eb 04                	jmp    104208 <get_pgtable_items+0x77>
            start ++;
  104204:	83 45 10 01          	addl   $0x1,0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  104208:	8b 45 10             	mov    0x10(%ebp),%eax
  10420b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10420e:	73 1d                	jae    10422d <get_pgtable_items+0x9c>
  104210:	8b 45 10             	mov    0x10(%ebp),%eax
  104213:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  10421a:	8b 45 14             	mov    0x14(%ebp),%eax
  10421d:	01 d0                	add    %edx,%eax
  10421f:	8b 00                	mov    (%eax),%eax
  104221:	83 e0 07             	and    $0x7,%eax
  104224:	89 c2                	mov    %eax,%edx
  104226:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104229:	39 c2                	cmp    %eax,%edx
  10422b:	74 d7                	je     104204 <get_pgtable_items+0x73>
        }
        if (right_store != NULL) {
  10422d:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  104231:	74 08                	je     10423b <get_pgtable_items+0xaa>
            *right_store = start;
  104233:	8b 45 1c             	mov    0x1c(%ebp),%eax
  104236:	8b 55 10             	mov    0x10(%ebp),%edx
  104239:	89 10                	mov    %edx,(%eax)
        }
        return perm;
  10423b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10423e:	eb 05                	jmp    104245 <get_pgtable_items+0xb4>
    }
    return 0;
  104240:	b8 00 00 00 00       	mov    $0x0,%eax
}
  104245:	c9                   	leave  
  104246:	c3                   	ret    

00104247 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
  104247:	55                   	push   %ebp
  104248:	89 e5                	mov    %esp,%ebp
  10424a:	57                   	push   %edi
  10424b:	56                   	push   %esi
  10424c:	53                   	push   %ebx
  10424d:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
  104250:	c7 04 24 d0 6d 10 00 	movl   $0x106dd0,(%esp)
  104257:	e8 41 c0 ff ff       	call   10029d <cprintf>
    size_t left, right = 0, perm;
  10425c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  104263:	e9 fa 00 00 00       	jmp    104362 <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  104268:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10426b:	89 04 24             	mov    %eax,(%esp)
  10426e:	e8 d0 fe ff ff       	call   104143 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
  104273:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  104276:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104279:	29 d1                	sub    %edx,%ecx
  10427b:	89 ca                	mov    %ecx,%edx
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  10427d:	89 d6                	mov    %edx,%esi
  10427f:	c1 e6 16             	shl    $0x16,%esi
  104282:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104285:	89 d3                	mov    %edx,%ebx
  104287:	c1 e3 16             	shl    $0x16,%ebx
  10428a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10428d:	89 d1                	mov    %edx,%ecx
  10428f:	c1 e1 16             	shl    $0x16,%ecx
  104292:	8b 7d dc             	mov    -0x24(%ebp),%edi
  104295:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104298:	29 d7                	sub    %edx,%edi
  10429a:	89 fa                	mov    %edi,%edx
  10429c:	89 44 24 14          	mov    %eax,0x14(%esp)
  1042a0:	89 74 24 10          	mov    %esi,0x10(%esp)
  1042a4:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1042a8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1042ac:	89 54 24 04          	mov    %edx,0x4(%esp)
  1042b0:	c7 04 24 01 6e 10 00 	movl   $0x106e01,(%esp)
  1042b7:	e8 e1 bf ff ff       	call   10029d <cprintf>
        size_t l, r = left * NPTEENTRY;
  1042bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1042bf:	c1 e0 0a             	shl    $0xa,%eax
  1042c2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  1042c5:	eb 54                	jmp    10431b <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  1042c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1042ca:	89 04 24             	mov    %eax,(%esp)
  1042cd:	e8 71 fe ff ff       	call   104143 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
  1042d2:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  1042d5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1042d8:	29 d1                	sub    %edx,%ecx
  1042da:	89 ca                	mov    %ecx,%edx
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  1042dc:	89 d6                	mov    %edx,%esi
  1042de:	c1 e6 0c             	shl    $0xc,%esi
  1042e1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1042e4:	89 d3                	mov    %edx,%ebx
  1042e6:	c1 e3 0c             	shl    $0xc,%ebx
  1042e9:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1042ec:	c1 e2 0c             	shl    $0xc,%edx
  1042ef:	89 d1                	mov    %edx,%ecx
  1042f1:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  1042f4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1042f7:	29 d7                	sub    %edx,%edi
  1042f9:	89 fa                	mov    %edi,%edx
  1042fb:	89 44 24 14          	mov    %eax,0x14(%esp)
  1042ff:	89 74 24 10          	mov    %esi,0x10(%esp)
  104303:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  104307:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  10430b:	89 54 24 04          	mov    %edx,0x4(%esp)
  10430f:	c7 04 24 20 6e 10 00 	movl   $0x106e20,(%esp)
  104316:	e8 82 bf ff ff       	call   10029d <cprintf>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  10431b:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
  104320:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  104323:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  104326:	89 ce                	mov    %ecx,%esi
  104328:	c1 e6 0a             	shl    $0xa,%esi
  10432b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  10432e:	89 cb                	mov    %ecx,%ebx
  104330:	c1 e3 0a             	shl    $0xa,%ebx
  104333:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
  104336:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  10433a:	8d 4d d8             	lea    -0x28(%ebp),%ecx
  10433d:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  104341:	89 54 24 0c          	mov    %edx,0xc(%esp)
  104345:	89 44 24 08          	mov    %eax,0x8(%esp)
  104349:	89 74 24 04          	mov    %esi,0x4(%esp)
  10434d:	89 1c 24             	mov    %ebx,(%esp)
  104350:	e8 3c fe ff ff       	call   104191 <get_pgtable_items>
  104355:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104358:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10435c:	0f 85 65 ff ff ff    	jne    1042c7 <print_pgdir+0x80>
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  104362:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
  104367:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10436a:	8d 4d dc             	lea    -0x24(%ebp),%ecx
  10436d:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  104371:	8d 4d e0             	lea    -0x20(%ebp),%ecx
  104374:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  104378:	89 54 24 0c          	mov    %edx,0xc(%esp)
  10437c:	89 44 24 08          	mov    %eax,0x8(%esp)
  104380:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
  104387:	00 
  104388:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10438f:	e8 fd fd ff ff       	call   104191 <get_pgtable_items>
  104394:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104397:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10439b:	0f 85 c7 fe ff ff    	jne    104268 <print_pgdir+0x21>
        }
    }
    cprintf("--------------------- END ---------------------\n");
  1043a1:	c7 04 24 44 6e 10 00 	movl   $0x106e44,(%esp)
  1043a8:	e8 f0 be ff ff       	call   10029d <cprintf>
}
  1043ad:	83 c4 4c             	add    $0x4c,%esp
  1043b0:	5b                   	pop    %ebx
  1043b1:	5e                   	pop    %esi
  1043b2:	5f                   	pop    %edi
  1043b3:	5d                   	pop    %ebp
  1043b4:	c3                   	ret    

001043b5 <page2ppn>:
page2ppn(struct Page *page) {
  1043b5:	55                   	push   %ebp
  1043b6:	89 e5                	mov    %esp,%ebp
    return page - pages;
  1043b8:	8b 55 08             	mov    0x8(%ebp),%edx
  1043bb:	a1 78 af 11 00       	mov    0x11af78,%eax
  1043c0:	29 c2                	sub    %eax,%edx
  1043c2:	89 d0                	mov    %edx,%eax
  1043c4:	c1 f8 02             	sar    $0x2,%eax
  1043c7:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  1043cd:	5d                   	pop    %ebp
  1043ce:	c3                   	ret    

001043cf <page2pa>:
page2pa(struct Page *page) {
  1043cf:	55                   	push   %ebp
  1043d0:	89 e5                	mov    %esp,%ebp
  1043d2:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  1043d5:	8b 45 08             	mov    0x8(%ebp),%eax
  1043d8:	89 04 24             	mov    %eax,(%esp)
  1043db:	e8 d5 ff ff ff       	call   1043b5 <page2ppn>
  1043e0:	c1 e0 0c             	shl    $0xc,%eax
}
  1043e3:	c9                   	leave  
  1043e4:	c3                   	ret    

001043e5 <page_ref>:
page_ref(struct Page *page) {
  1043e5:	55                   	push   %ebp
  1043e6:	89 e5                	mov    %esp,%ebp
    return page->ref;
  1043e8:	8b 45 08             	mov    0x8(%ebp),%eax
  1043eb:	8b 00                	mov    (%eax),%eax
}
  1043ed:	5d                   	pop    %ebp
  1043ee:	c3                   	ret    

001043ef <set_page_ref>:
set_page_ref(struct Page *page, int val) {
  1043ef:	55                   	push   %ebp
  1043f0:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  1043f2:	8b 45 08             	mov    0x8(%ebp),%eax
  1043f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  1043f8:	89 10                	mov    %edx,(%eax)
}
  1043fa:	5d                   	pop    %ebp
  1043fb:	c3                   	ret    

001043fc <default_init>:
#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

// 主要是一些参数的初始化工作
static void
default_init(void) {
  1043fc:	55                   	push   %ebp
  1043fd:	89 e5                	mov    %esp,%ebp
  1043ff:	83 ec 10             	sub    $0x10,%esp
  104402:	c7 45 fc 7c af 11 00 	movl   $0x11af7c,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  104409:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10440c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10440f:	89 50 04             	mov    %edx,0x4(%eax)
  104412:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104415:	8b 50 04             	mov    0x4(%eax),%edx
  104418:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10441b:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
  10441d:	c7 05 84 af 11 00 00 	movl   $0x0,0x11af84
  104424:	00 00 00 
}
  104427:	c9                   	leave  
  104428:	c3                   	ret    

00104429 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
  104429:	55                   	push   %ebp
  10442a:	89 e5                	mov    %esp,%ebp
  10442c:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
  10442f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  104433:	75 24                	jne    104459 <default_init_memmap+0x30>
  104435:	c7 44 24 0c 78 6e 10 	movl   $0x106e78,0xc(%esp)
  10443c:	00 
  10443d:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  104444:	00 
  104445:	c7 44 24 04 6e 00 00 	movl   $0x6e,0x4(%esp)
  10444c:	00 
  10444d:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  104454:	e8 9b bf ff ff       	call   1003f4 <__panic>
    struct Page *p = base;
  104459:	8b 45 08             	mov    0x8(%ebp),%eax
  10445c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  10445f:	eb 7d                	jmp    1044de <default_init_memmap+0xb5>
        assert(PageReserved(p));
  104461:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104464:	83 c0 04             	add    $0x4,%eax
  104467:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  10446e:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104471:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104474:	8b 55 f0             	mov    -0x10(%ebp),%edx
  104477:	0f a3 10             	bt     %edx,(%eax)
  10447a:	19 c0                	sbb    %eax,%eax
  10447c:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
  10447f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  104483:	0f 95 c0             	setne  %al
  104486:	0f b6 c0             	movzbl %al,%eax
  104489:	85 c0                	test   %eax,%eax
  10448b:	75 24                	jne    1044b1 <default_init_memmap+0x88>
  10448d:	c7 44 24 0c a9 6e 10 	movl   $0x106ea9,0xc(%esp)
  104494:	00 
  104495:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  10449c:	00 
  10449d:	c7 44 24 04 71 00 00 	movl   $0x71,0x4(%esp)
  1044a4:	00 
  1044a5:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  1044ac:	e8 43 bf ff ff       	call   1003f4 <__panic>
        p->flags = p->property = 0;
  1044b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1044b4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  1044bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1044be:	8b 50 08             	mov    0x8(%eax),%edx
  1044c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1044c4:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
  1044c7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1044ce:	00 
  1044cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1044d2:	89 04 24             	mov    %eax,(%esp)
  1044d5:	e8 15 ff ff ff       	call   1043ef <set_page_ref>
    for (; p != base + n; p ++) {
  1044da:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  1044de:	8b 55 0c             	mov    0xc(%ebp),%edx
  1044e1:	89 d0                	mov    %edx,%eax
  1044e3:	c1 e0 02             	shl    $0x2,%eax
  1044e6:	01 d0                	add    %edx,%eax
  1044e8:	c1 e0 02             	shl    $0x2,%eax
  1044eb:	89 c2                	mov    %eax,%edx
  1044ed:	8b 45 08             	mov    0x8(%ebp),%eax
  1044f0:	01 d0                	add    %edx,%eax
  1044f2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  1044f5:	0f 85 66 ff ff ff    	jne    104461 <default_init_memmap+0x38>
    }
    base->property = n;
  1044fb:	8b 45 08             	mov    0x8(%ebp),%eax
  1044fe:	8b 55 0c             	mov    0xc(%ebp),%edx
  104501:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  104504:	8b 45 08             	mov    0x8(%ebp),%eax
  104507:	83 c0 04             	add    $0x4,%eax
  10450a:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  104511:	89 45 e0             	mov    %eax,-0x20(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  104514:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104517:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10451a:	0f ab 10             	bts    %edx,(%eax)
    nr_free += n;
  10451d:	8b 15 84 af 11 00    	mov    0x11af84,%edx
  104523:	8b 45 0c             	mov    0xc(%ebp),%eax
  104526:	01 d0                	add    %edx,%eax
  104528:	a3 84 af 11 00       	mov    %eax,0x11af84
    list_add(&free_list, &(base->page_link));
  10452d:	8b 45 08             	mov    0x8(%ebp),%eax
  104530:	83 c0 0c             	add    $0xc,%eax
  104533:	c7 45 dc 7c af 11 00 	movl   $0x11af7c,-0x24(%ebp)
  10453a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  10453d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104540:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  104543:	8b 45 d8             	mov    -0x28(%ebp),%eax
  104546:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
  104549:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10454c:	8b 40 04             	mov    0x4(%eax),%eax
  10454f:	8b 55 d0             	mov    -0x30(%ebp),%edx
  104552:	89 55 cc             	mov    %edx,-0x34(%ebp)
  104555:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104558:	89 55 c8             	mov    %edx,-0x38(%ebp)
  10455b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  10455e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104561:	8b 55 cc             	mov    -0x34(%ebp),%edx
  104564:	89 10                	mov    %edx,(%eax)
  104566:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104569:	8b 10                	mov    (%eax),%edx
  10456b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  10456e:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  104571:	8b 45 cc             	mov    -0x34(%ebp),%eax
  104574:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  104577:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  10457a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  10457d:	8b 55 c8             	mov    -0x38(%ebp),%edx
  104580:	89 10                	mov    %edx,(%eax)
}
  104582:	c9                   	leave  
  104583:	c3                   	ret    

00104584 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
  104584:	55                   	push   %ebp
  104585:	89 e5                	mov    %esp,%ebp
  104587:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
  10458a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  10458e:	75 24                	jne    1045b4 <default_alloc_pages+0x30>
  104590:	c7 44 24 0c 78 6e 10 	movl   $0x106e78,0xc(%esp)
  104597:	00 
  104598:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  10459f:	00 
  1045a0:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
  1045a7:	00 
  1045a8:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  1045af:	e8 40 be ff ff       	call   1003f4 <__panic>
    if (n > nr_free) {
  1045b4:	a1 84 af 11 00       	mov    0x11af84,%eax
  1045b9:	3b 45 08             	cmp    0x8(%ebp),%eax
  1045bc:	73 0a                	jae    1045c8 <default_alloc_pages+0x44>
        return NULL;
  1045be:	b8 00 00 00 00       	mov    $0x0,%eax
  1045c3:	e9 3d 01 00 00       	jmp    104705 <default_alloc_pages+0x181>
    }
    struct Page *page = NULL;
  1045c8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
  1045cf:	c7 45 f0 7c af 11 00 	movl   $0x11af7c,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
  1045d6:	eb 1c                	jmp    1045f4 <default_alloc_pages+0x70>
        struct Page *p = le2page(le, page_link);
  1045d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1045db:	83 e8 0c             	sub    $0xc,%eax
  1045de:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) {
  1045e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1045e4:	8b 40 08             	mov    0x8(%eax),%eax
  1045e7:	3b 45 08             	cmp    0x8(%ebp),%eax
  1045ea:	72 08                	jb     1045f4 <default_alloc_pages+0x70>
            page = p;
  1045ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1045ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  1045f2:	eb 18                	jmp    10460c <default_alloc_pages+0x88>
  1045f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1045f7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return listelm->next;
  1045fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1045fd:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
  104600:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104603:	81 7d f0 7c af 11 00 	cmpl   $0x11af7c,-0x10(%ebp)
  10460a:	75 cc                	jne    1045d8 <default_alloc_pages+0x54>
        }
    }

    // 每一页的属性都在特定地址存储，因此在将空闲页块进行重新链接时，不能复用原有的位置
    if (page != NULL) {
  10460c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104610:	0f 84 ec 00 00 00    	je     104702 <default_alloc_pages+0x17e>
        if (page->property > n) {
  104616:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104619:	8b 40 08             	mov    0x8(%eax),%eax
  10461c:	3b 45 08             	cmp    0x8(%ebp),%eax
  10461f:	0f 86 8c 00 00 00    	jbe    1046b1 <default_alloc_pages+0x12d>
            struct Page *p = page + n;
  104625:	8b 55 08             	mov    0x8(%ebp),%edx
  104628:	89 d0                	mov    %edx,%eax
  10462a:	c1 e0 02             	shl    $0x2,%eax
  10462d:	01 d0                	add    %edx,%eax
  10462f:	c1 e0 02             	shl    $0x2,%eax
  104632:	89 c2                	mov    %eax,%edx
  104634:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104637:	01 d0                	add    %edx,%eax
  104639:	89 45 e8             	mov    %eax,-0x18(%ebp)
            p->property = page->property - n;
  10463c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10463f:	8b 40 08             	mov    0x8(%eax),%eax
  104642:	2b 45 08             	sub    0x8(%ebp),%eax
  104645:	89 c2                	mov    %eax,%edx
  104647:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10464a:	89 50 08             	mov    %edx,0x8(%eax)
            SetPageProperty(p);
  10464d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104650:	83 c0 04             	add    $0x4,%eax
  104653:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
  10465a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  10465d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104660:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104663:	0f ab 10             	bts    %edx,(%eax)
            list_add_after(&(page->page_link), &(p->page_link));
  104666:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104669:	83 c0 0c             	add    $0xc,%eax
  10466c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10466f:	83 c2 0c             	add    $0xc,%edx
  104672:	89 55 d8             	mov    %edx,-0x28(%ebp)
  104675:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    __list_add(elm, listelm, listelm->next);
  104678:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10467b:	8b 40 04             	mov    0x4(%eax),%eax
  10467e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104681:	89 55 d0             	mov    %edx,-0x30(%ebp)
  104684:	8b 55 d8             	mov    -0x28(%ebp),%edx
  104687:	89 55 cc             	mov    %edx,-0x34(%ebp)
  10468a:	89 45 c8             	mov    %eax,-0x38(%ebp)
    prev->next = next->prev = elm;
  10468d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  104690:	8b 55 d0             	mov    -0x30(%ebp),%edx
  104693:	89 10                	mov    %edx,(%eax)
  104695:	8b 45 c8             	mov    -0x38(%ebp),%eax
  104698:	8b 10                	mov    (%eax),%edx
  10469a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  10469d:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  1046a0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1046a3:	8b 55 c8             	mov    -0x38(%ebp),%edx
  1046a6:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  1046a9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1046ac:	8b 55 cc             	mov    -0x34(%ebp),%edx
  1046af:	89 10                	mov    %edx,(%eax)
        }
        nr_free -= n;
  1046b1:	a1 84 af 11 00       	mov    0x11af84,%eax
  1046b6:	2b 45 08             	sub    0x8(%ebp),%eax
  1046b9:	a3 84 af 11 00       	mov    %eax,0x11af84
        list_del(&(page->page_link));
  1046be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1046c1:	83 c0 0c             	add    $0xc,%eax
  1046c4:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    __list_del(listelm->prev, listelm->next);
  1046c7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  1046ca:	8b 40 04             	mov    0x4(%eax),%eax
  1046cd:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  1046d0:	8b 12                	mov    (%edx),%edx
  1046d2:	89 55 c0             	mov    %edx,-0x40(%ebp)
  1046d5:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  1046d8:	8b 45 c0             	mov    -0x40(%ebp),%eax
  1046db:	8b 55 bc             	mov    -0x44(%ebp),%edx
  1046de:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  1046e1:	8b 45 bc             	mov    -0x44(%ebp),%eax
  1046e4:	8b 55 c0             	mov    -0x40(%ebp),%edx
  1046e7:	89 10                	mov    %edx,(%eax)
        ClearPageProperty(page);
  1046e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1046ec:	83 c0 04             	add    $0x4,%eax
  1046ef:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
  1046f6:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  1046f9:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1046fc:	8b 55 b8             	mov    -0x48(%ebp),%edx
  1046ff:	0f b3 10             	btr    %edx,(%eax)
    }
    return page;
  104702:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  104705:	c9                   	leave  
  104706:	c3                   	ret    

00104707 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
  104707:	55                   	push   %ebp
  104708:	89 e5                	mov    %esp,%ebp
  10470a:	81 ec 88 00 00 00    	sub    $0x88,%esp
    assert(n > 0);
  104710:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  104714:	75 24                	jne    10473a <default_free_pages+0x33>
  104716:	c7 44 24 0c 78 6e 10 	movl   $0x106e78,0xc(%esp)
  10471d:	00 
  10471e:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  104725:	00 
  104726:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
  10472d:	00 
  10472e:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  104735:	e8 ba bc ff ff       	call   1003f4 <__panic>
    struct Page *p = base;
  10473a:	8b 45 08             	mov    0x8(%ebp),%eax
  10473d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  104740:	e9 9d 00 00 00       	jmp    1047e2 <default_free_pages+0xdb>
        assert(!PageReserved(p) && !PageProperty(p));
  104745:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104748:	83 c0 04             	add    $0x4,%eax
  10474b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  104752:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104755:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104758:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10475b:	0f a3 10             	bt     %edx,(%eax)
  10475e:	19 c0                	sbb    %eax,%eax
  104760:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
  104763:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  104767:	0f 95 c0             	setne  %al
  10476a:	0f b6 c0             	movzbl %al,%eax
  10476d:	85 c0                	test   %eax,%eax
  10476f:	75 2c                	jne    10479d <default_free_pages+0x96>
  104771:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104774:	83 c0 04             	add    $0x4,%eax
  104777:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
  10477e:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104781:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104784:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104787:	0f a3 10             	bt     %edx,(%eax)
  10478a:	19 c0                	sbb    %eax,%eax
  10478c:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
  10478f:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  104793:	0f 95 c0             	setne  %al
  104796:	0f b6 c0             	movzbl %al,%eax
  104799:	85 c0                	test   %eax,%eax
  10479b:	74 24                	je     1047c1 <default_free_pages+0xba>
  10479d:	c7 44 24 0c bc 6e 10 	movl   $0x106ebc,0xc(%esp)
  1047a4:	00 
  1047a5:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  1047ac:	00 
  1047ad:	c7 44 24 04 9f 00 00 	movl   $0x9f,0x4(%esp)
  1047b4:	00 
  1047b5:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  1047bc:	e8 33 bc ff ff       	call   1003f4 <__panic>
        p->flags = 0;
  1047c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1047c4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
  1047cb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1047d2:	00 
  1047d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1047d6:	89 04 24             	mov    %eax,(%esp)
  1047d9:	e8 11 fc ff ff       	call   1043ef <set_page_ref>
    for (; p != base + n; p ++) {
  1047de:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  1047e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  1047e5:	89 d0                	mov    %edx,%eax
  1047e7:	c1 e0 02             	shl    $0x2,%eax
  1047ea:	01 d0                	add    %edx,%eax
  1047ec:	c1 e0 02             	shl    $0x2,%eax
  1047ef:	89 c2                	mov    %eax,%edx
  1047f1:	8b 45 08             	mov    0x8(%ebp),%eax
  1047f4:	01 d0                	add    %edx,%eax
  1047f6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  1047f9:	0f 85 46 ff ff ff    	jne    104745 <default_free_pages+0x3e>
    }
    base->property = n;
  1047ff:	8b 45 08             	mov    0x8(%ebp),%eax
  104802:	8b 55 0c             	mov    0xc(%ebp),%edx
  104805:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  104808:	8b 45 08             	mov    0x8(%ebp),%eax
  10480b:	83 c0 04             	add    $0x4,%eax
  10480e:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  104815:	89 45 d0             	mov    %eax,-0x30(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  104818:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10481b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10481e:	0f ab 10             	bts    %edx,(%eax)
  104821:	c7 45 cc 7c af 11 00 	movl   $0x11af7c,-0x34(%ebp)
    return listelm->next;
  104828:	8b 45 cc             	mov    -0x34(%ebp),%eax
  10482b:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
  10482e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
  104831:	e9 57 01 00 00       	jmp    10498d <default_free_pages+0x286>
        p = le2page(le, page_link);
  104836:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104839:	83 e8 0c             	sub    $0xc,%eax
  10483c:	89 45 f4             	mov    %eax,-0xc(%ebp)
        // TODO: optimize
        if (base + base->property == p) {
  10483f:	8b 45 08             	mov    0x8(%ebp),%eax
  104842:	8b 50 08             	mov    0x8(%eax),%edx
  104845:	89 d0                	mov    %edx,%eax
  104847:	c1 e0 02             	shl    $0x2,%eax
  10484a:	01 d0                	add    %edx,%eax
  10484c:	c1 e0 02             	shl    $0x2,%eax
  10484f:	89 c2                	mov    %eax,%edx
  104851:	8b 45 08             	mov    0x8(%ebp),%eax
  104854:	01 d0                	add    %edx,%eax
  104856:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104859:	75 5d                	jne    1048b8 <default_free_pages+0x1b1>
            base->property += p->property;
  10485b:	8b 45 08             	mov    0x8(%ebp),%eax
  10485e:	8b 50 08             	mov    0x8(%eax),%edx
  104861:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104864:	8b 40 08             	mov    0x8(%eax),%eax
  104867:	01 c2                	add    %eax,%edx
  104869:	8b 45 08             	mov    0x8(%ebp),%eax
  10486c:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
  10486f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104872:	83 c0 04             	add    $0x4,%eax
  104875:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
  10487c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  10487f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104882:	8b 55 c8             	mov    -0x38(%ebp),%edx
  104885:	0f b3 10             	btr    %edx,(%eax)
            list_del(&(p->page_link));
  104888:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10488b:	83 c0 0c             	add    $0xc,%eax
  10488e:	89 45 c0             	mov    %eax,-0x40(%ebp)
    __list_del(listelm->prev, listelm->next);
  104891:	8b 45 c0             	mov    -0x40(%ebp),%eax
  104894:	8b 40 04             	mov    0x4(%eax),%eax
  104897:	8b 55 c0             	mov    -0x40(%ebp),%edx
  10489a:	8b 12                	mov    (%edx),%edx
  10489c:	89 55 bc             	mov    %edx,-0x44(%ebp)
  10489f:	89 45 b8             	mov    %eax,-0x48(%ebp)
    prev->next = next;
  1048a2:	8b 45 bc             	mov    -0x44(%ebp),%eax
  1048a5:	8b 55 b8             	mov    -0x48(%ebp),%edx
  1048a8:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  1048ab:	8b 45 b8             	mov    -0x48(%ebp),%eax
  1048ae:	8b 55 bc             	mov    -0x44(%ebp),%edx
  1048b1:	89 10                	mov    %edx,(%eax)
  1048b3:	e9 c6 00 00 00       	jmp    10497e <default_free_pages+0x277>
        }
        else if (p + p->property == base) {
  1048b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1048bb:	8b 50 08             	mov    0x8(%eax),%edx
  1048be:	89 d0                	mov    %edx,%eax
  1048c0:	c1 e0 02             	shl    $0x2,%eax
  1048c3:	01 d0                	add    %edx,%eax
  1048c5:	c1 e0 02             	shl    $0x2,%eax
  1048c8:	89 c2                	mov    %eax,%edx
  1048ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1048cd:	01 d0                	add    %edx,%eax
  1048cf:	3b 45 08             	cmp    0x8(%ebp),%eax
  1048d2:	75 60                	jne    104934 <default_free_pages+0x22d>
            p->property += base->property;
  1048d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1048d7:	8b 50 08             	mov    0x8(%eax),%edx
  1048da:	8b 45 08             	mov    0x8(%ebp),%eax
  1048dd:	8b 40 08             	mov    0x8(%eax),%eax
  1048e0:	01 c2                	add    %eax,%edx
  1048e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1048e5:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
  1048e8:	8b 45 08             	mov    0x8(%ebp),%eax
  1048eb:	83 c0 04             	add    $0x4,%eax
  1048ee:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
  1048f5:	89 45 b0             	mov    %eax,-0x50(%ebp)
  1048f8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  1048fb:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  1048fe:	0f b3 10             	btr    %edx,(%eax)
            base = p;
  104901:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104904:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
  104907:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10490a:	83 c0 0c             	add    $0xc,%eax
  10490d:	89 45 ac             	mov    %eax,-0x54(%ebp)
    __list_del(listelm->prev, listelm->next);
  104910:	8b 45 ac             	mov    -0x54(%ebp),%eax
  104913:	8b 40 04             	mov    0x4(%eax),%eax
  104916:	8b 55 ac             	mov    -0x54(%ebp),%edx
  104919:	8b 12                	mov    (%edx),%edx
  10491b:	89 55 a8             	mov    %edx,-0x58(%ebp)
  10491e:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    prev->next = next;
  104921:	8b 45 a8             	mov    -0x58(%ebp),%eax
  104924:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  104927:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  10492a:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  10492d:	8b 55 a8             	mov    -0x58(%ebp),%edx
  104930:	89 10                	mov    %edx,(%eax)
  104932:	eb 4a                	jmp    10497e <default_free_pages+0x277>
        }else if(base <= p)
  104934:	8b 45 08             	mov    0x8(%ebp),%eax
  104937:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  10493a:	77 42                	ja     10497e <default_free_pages+0x277>
		{
			assert(base != p + p->property);
  10493c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10493f:	8b 50 08             	mov    0x8(%eax),%edx
  104942:	89 d0                	mov    %edx,%eax
  104944:	c1 e0 02             	shl    $0x2,%eax
  104947:	01 d0                	add    %edx,%eax
  104949:	c1 e0 02             	shl    $0x2,%eax
  10494c:	89 c2                	mov    %eax,%edx
  10494e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104951:	01 d0                	add    %edx,%eax
  104953:	3b 45 08             	cmp    0x8(%ebp),%eax
  104956:	75 24                	jne    10497c <default_free_pages+0x275>
  104958:	c7 44 24 0c e1 6e 10 	movl   $0x106ee1,0xc(%esp)
  10495f:	00 
  104960:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  104967:	00 
  104968:	c7 44 24 04 b5 00 00 	movl   $0xb5,0x4(%esp)
  10496f:	00 
  104970:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  104977:	e8 78 ba ff ff       	call   1003f4 <__panic>
			break;
  10497c:	eb 1c                	jmp    10499a <default_free_pages+0x293>
  10497e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104981:	89 45 a0             	mov    %eax,-0x60(%ebp)
    return listelm->next;
  104984:	8b 45 a0             	mov    -0x60(%ebp),%eax
  104987:	8b 40 04             	mov    0x4(%eax),%eax
		}
		le = list_next(le);
  10498a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
  10498d:	81 7d f0 7c af 11 00 	cmpl   $0x11af7c,-0x10(%ebp)
  104994:	0f 85 9c fe ff ff    	jne    104836 <default_free_pages+0x12f>
    }

    // 通过前面的处理，此处必定要新加一个空白块，如果空白块地址最大，插入头指针之前，即末尾，该种结构更为科学合理
	list_add_before(le, &(base->page_link));
  10499a:	8b 45 08             	mov    0x8(%ebp),%eax
  10499d:	8d 50 0c             	lea    0xc(%eax),%edx
  1049a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1049a3:	89 45 9c             	mov    %eax,-0x64(%ebp)
  1049a6:	89 55 98             	mov    %edx,-0x68(%ebp)
    __list_add(elm, listelm->prev, listelm);
  1049a9:	8b 45 9c             	mov    -0x64(%ebp),%eax
  1049ac:	8b 00                	mov    (%eax),%eax
  1049ae:	8b 55 98             	mov    -0x68(%ebp),%edx
  1049b1:	89 55 94             	mov    %edx,-0x6c(%ebp)
  1049b4:	89 45 90             	mov    %eax,-0x70(%ebp)
  1049b7:	8b 45 9c             	mov    -0x64(%ebp),%eax
  1049ba:	89 45 8c             	mov    %eax,-0x74(%ebp)
    prev->next = next->prev = elm;
  1049bd:	8b 45 8c             	mov    -0x74(%ebp),%eax
  1049c0:	8b 55 94             	mov    -0x6c(%ebp),%edx
  1049c3:	89 10                	mov    %edx,(%eax)
  1049c5:	8b 45 8c             	mov    -0x74(%ebp),%eax
  1049c8:	8b 10                	mov    (%eax),%edx
  1049ca:	8b 45 90             	mov    -0x70(%ebp),%eax
  1049cd:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  1049d0:	8b 45 94             	mov    -0x6c(%ebp),%eax
  1049d3:	8b 55 8c             	mov    -0x74(%ebp),%edx
  1049d6:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  1049d9:	8b 45 94             	mov    -0x6c(%ebp),%eax
  1049dc:	8b 55 90             	mov    -0x70(%ebp),%edx
  1049df:	89 10                	mov    %edx,(%eax)
    nr_free += n;
  1049e1:	8b 15 84 af 11 00    	mov    0x11af84,%edx
  1049e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1049ea:	01 d0                	add    %edx,%eax
  1049ec:	a3 84 af 11 00       	mov    %eax,0x11af84
}
  1049f1:	c9                   	leave  
  1049f2:	c3                   	ret    

001049f3 <default_nr_free_pages>:
static size_t
default_nr_free_pages(void) {
  1049f3:	55                   	push   %ebp
  1049f4:	89 e5                	mov    %esp,%ebp
    return nr_free;
  1049f6:	a1 84 af 11 00       	mov    0x11af84,%eax
}
  1049fb:	5d                   	pop    %ebp
  1049fc:	c3                   	ret    

001049fd <basic_check>:

static void
basic_check(void) {
  1049fd:	55                   	push   %ebp
  1049fe:	89 e5                	mov    %esp,%ebp
  104a00:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
  104a03:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  104a0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104a0d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104a10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104a13:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
  104a16:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104a1d:	e8 d2 e2 ff ff       	call   102cf4 <alloc_pages>
  104a22:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104a25:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  104a29:	75 24                	jne    104a4f <basic_check+0x52>
  104a2b:	c7 44 24 0c f9 6e 10 	movl   $0x106ef9,0xc(%esp)
  104a32:	00 
  104a33:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  104a3a:	00 
  104a3b:	c7 44 24 04 c8 00 00 	movl   $0xc8,0x4(%esp)
  104a42:	00 
  104a43:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  104a4a:	e8 a5 b9 ff ff       	call   1003f4 <__panic>
    assert((p1 = alloc_page()) != NULL);
  104a4f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104a56:	e8 99 e2 ff ff       	call   102cf4 <alloc_pages>
  104a5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104a5e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104a62:	75 24                	jne    104a88 <basic_check+0x8b>
  104a64:	c7 44 24 0c 15 6f 10 	movl   $0x106f15,0xc(%esp)
  104a6b:	00 
  104a6c:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  104a73:	00 
  104a74:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
  104a7b:	00 
  104a7c:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  104a83:	e8 6c b9 ff ff       	call   1003f4 <__panic>
    assert((p2 = alloc_page()) != NULL);
  104a88:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104a8f:	e8 60 e2 ff ff       	call   102cf4 <alloc_pages>
  104a94:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104a97:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104a9b:	75 24                	jne    104ac1 <basic_check+0xc4>
  104a9d:	c7 44 24 0c 31 6f 10 	movl   $0x106f31,0xc(%esp)
  104aa4:	00 
  104aa5:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  104aac:	00 
  104aad:	c7 44 24 04 ca 00 00 	movl   $0xca,0x4(%esp)
  104ab4:	00 
  104ab5:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  104abc:	e8 33 b9 ff ff       	call   1003f4 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
  104ac1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104ac4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  104ac7:	74 10                	je     104ad9 <basic_check+0xdc>
  104ac9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104acc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104acf:	74 08                	je     104ad9 <basic_check+0xdc>
  104ad1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104ad4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104ad7:	75 24                	jne    104afd <basic_check+0x100>
  104ad9:	c7 44 24 0c 50 6f 10 	movl   $0x106f50,0xc(%esp)
  104ae0:	00 
  104ae1:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  104ae8:	00 
  104ae9:	c7 44 24 04 cc 00 00 	movl   $0xcc,0x4(%esp)
  104af0:	00 
  104af1:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  104af8:	e8 f7 b8 ff ff       	call   1003f4 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
  104afd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104b00:	89 04 24             	mov    %eax,(%esp)
  104b03:	e8 dd f8 ff ff       	call   1043e5 <page_ref>
  104b08:	85 c0                	test   %eax,%eax
  104b0a:	75 1e                	jne    104b2a <basic_check+0x12d>
  104b0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104b0f:	89 04 24             	mov    %eax,(%esp)
  104b12:	e8 ce f8 ff ff       	call   1043e5 <page_ref>
  104b17:	85 c0                	test   %eax,%eax
  104b19:	75 0f                	jne    104b2a <basic_check+0x12d>
  104b1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104b1e:	89 04 24             	mov    %eax,(%esp)
  104b21:	e8 bf f8 ff ff       	call   1043e5 <page_ref>
  104b26:	85 c0                	test   %eax,%eax
  104b28:	74 24                	je     104b4e <basic_check+0x151>
  104b2a:	c7 44 24 0c 74 6f 10 	movl   $0x106f74,0xc(%esp)
  104b31:	00 
  104b32:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  104b39:	00 
  104b3a:	c7 44 24 04 cd 00 00 	movl   $0xcd,0x4(%esp)
  104b41:	00 
  104b42:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  104b49:	e8 a6 b8 ff ff       	call   1003f4 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
  104b4e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104b51:	89 04 24             	mov    %eax,(%esp)
  104b54:	e8 76 f8 ff ff       	call   1043cf <page2pa>
  104b59:	8b 15 80 ae 11 00    	mov    0x11ae80,%edx
  104b5f:	c1 e2 0c             	shl    $0xc,%edx
  104b62:	39 d0                	cmp    %edx,%eax
  104b64:	72 24                	jb     104b8a <basic_check+0x18d>
  104b66:	c7 44 24 0c b0 6f 10 	movl   $0x106fb0,0xc(%esp)
  104b6d:	00 
  104b6e:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  104b75:	00 
  104b76:	c7 44 24 04 cf 00 00 	movl   $0xcf,0x4(%esp)
  104b7d:	00 
  104b7e:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  104b85:	e8 6a b8 ff ff       	call   1003f4 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
  104b8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104b8d:	89 04 24             	mov    %eax,(%esp)
  104b90:	e8 3a f8 ff ff       	call   1043cf <page2pa>
  104b95:	8b 15 80 ae 11 00    	mov    0x11ae80,%edx
  104b9b:	c1 e2 0c             	shl    $0xc,%edx
  104b9e:	39 d0                	cmp    %edx,%eax
  104ba0:	72 24                	jb     104bc6 <basic_check+0x1c9>
  104ba2:	c7 44 24 0c cd 6f 10 	movl   $0x106fcd,0xc(%esp)
  104ba9:	00 
  104baa:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  104bb1:	00 
  104bb2:	c7 44 24 04 d0 00 00 	movl   $0xd0,0x4(%esp)
  104bb9:	00 
  104bba:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  104bc1:	e8 2e b8 ff ff       	call   1003f4 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
  104bc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104bc9:	89 04 24             	mov    %eax,(%esp)
  104bcc:	e8 fe f7 ff ff       	call   1043cf <page2pa>
  104bd1:	8b 15 80 ae 11 00    	mov    0x11ae80,%edx
  104bd7:	c1 e2 0c             	shl    $0xc,%edx
  104bda:	39 d0                	cmp    %edx,%eax
  104bdc:	72 24                	jb     104c02 <basic_check+0x205>
  104bde:	c7 44 24 0c ea 6f 10 	movl   $0x106fea,0xc(%esp)
  104be5:	00 
  104be6:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  104bed:	00 
  104bee:	c7 44 24 04 d1 00 00 	movl   $0xd1,0x4(%esp)
  104bf5:	00 
  104bf6:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  104bfd:	e8 f2 b7 ff ff       	call   1003f4 <__panic>

    list_entry_t free_list_store = free_list;
  104c02:	a1 7c af 11 00       	mov    0x11af7c,%eax
  104c07:	8b 15 80 af 11 00    	mov    0x11af80,%edx
  104c0d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  104c10:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  104c13:	c7 45 e0 7c af 11 00 	movl   $0x11af7c,-0x20(%ebp)
    elm->prev = elm->next = elm;
  104c1a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104c1d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104c20:	89 50 04             	mov    %edx,0x4(%eax)
  104c23:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104c26:	8b 50 04             	mov    0x4(%eax),%edx
  104c29:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104c2c:	89 10                	mov    %edx,(%eax)
  104c2e:	c7 45 dc 7c af 11 00 	movl   $0x11af7c,-0x24(%ebp)
    return list->next == list;
  104c35:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104c38:	8b 40 04             	mov    0x4(%eax),%eax
  104c3b:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  104c3e:	0f 94 c0             	sete   %al
  104c41:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  104c44:	85 c0                	test   %eax,%eax
  104c46:	75 24                	jne    104c6c <basic_check+0x26f>
  104c48:	c7 44 24 0c 07 70 10 	movl   $0x107007,0xc(%esp)
  104c4f:	00 
  104c50:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  104c57:	00 
  104c58:	c7 44 24 04 d5 00 00 	movl   $0xd5,0x4(%esp)
  104c5f:	00 
  104c60:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  104c67:	e8 88 b7 ff ff       	call   1003f4 <__panic>

    unsigned int nr_free_store = nr_free;
  104c6c:	a1 84 af 11 00       	mov    0x11af84,%eax
  104c71:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
  104c74:	c7 05 84 af 11 00 00 	movl   $0x0,0x11af84
  104c7b:	00 00 00 

    assert(alloc_page() == NULL);
  104c7e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104c85:	e8 6a e0 ff ff       	call   102cf4 <alloc_pages>
  104c8a:	85 c0                	test   %eax,%eax
  104c8c:	74 24                	je     104cb2 <basic_check+0x2b5>
  104c8e:	c7 44 24 0c 1e 70 10 	movl   $0x10701e,0xc(%esp)
  104c95:	00 
  104c96:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  104c9d:	00 
  104c9e:	c7 44 24 04 da 00 00 	movl   $0xda,0x4(%esp)
  104ca5:	00 
  104ca6:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  104cad:	e8 42 b7 ff ff       	call   1003f4 <__panic>

    free_page(p0);
  104cb2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104cb9:	00 
  104cba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104cbd:	89 04 24             	mov    %eax,(%esp)
  104cc0:	e8 67 e0 ff ff       	call   102d2c <free_pages>
    free_page(p1);
  104cc5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104ccc:	00 
  104ccd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104cd0:	89 04 24             	mov    %eax,(%esp)
  104cd3:	e8 54 e0 ff ff       	call   102d2c <free_pages>
    free_page(p2);
  104cd8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104cdf:	00 
  104ce0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104ce3:	89 04 24             	mov    %eax,(%esp)
  104ce6:	e8 41 e0 ff ff       	call   102d2c <free_pages>
    assert(nr_free == 3);
  104ceb:	a1 84 af 11 00       	mov    0x11af84,%eax
  104cf0:	83 f8 03             	cmp    $0x3,%eax
  104cf3:	74 24                	je     104d19 <basic_check+0x31c>
  104cf5:	c7 44 24 0c 33 70 10 	movl   $0x107033,0xc(%esp)
  104cfc:	00 
  104cfd:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  104d04:	00 
  104d05:	c7 44 24 04 df 00 00 	movl   $0xdf,0x4(%esp)
  104d0c:	00 
  104d0d:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  104d14:	e8 db b6 ff ff       	call   1003f4 <__panic>

    assert((p0 = alloc_page()) != NULL);
  104d19:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104d20:	e8 cf df ff ff       	call   102cf4 <alloc_pages>
  104d25:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104d28:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  104d2c:	75 24                	jne    104d52 <basic_check+0x355>
  104d2e:	c7 44 24 0c f9 6e 10 	movl   $0x106ef9,0xc(%esp)
  104d35:	00 
  104d36:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  104d3d:	00 
  104d3e:	c7 44 24 04 e1 00 00 	movl   $0xe1,0x4(%esp)
  104d45:	00 
  104d46:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  104d4d:	e8 a2 b6 ff ff       	call   1003f4 <__panic>
    assert((p1 = alloc_page()) != NULL);
  104d52:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104d59:	e8 96 df ff ff       	call   102cf4 <alloc_pages>
  104d5e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104d61:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104d65:	75 24                	jne    104d8b <basic_check+0x38e>
  104d67:	c7 44 24 0c 15 6f 10 	movl   $0x106f15,0xc(%esp)
  104d6e:	00 
  104d6f:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  104d76:	00 
  104d77:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
  104d7e:	00 
  104d7f:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  104d86:	e8 69 b6 ff ff       	call   1003f4 <__panic>
    assert((p2 = alloc_page()) != NULL);
  104d8b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104d92:	e8 5d df ff ff       	call   102cf4 <alloc_pages>
  104d97:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104d9a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104d9e:	75 24                	jne    104dc4 <basic_check+0x3c7>
  104da0:	c7 44 24 0c 31 6f 10 	movl   $0x106f31,0xc(%esp)
  104da7:	00 
  104da8:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  104daf:	00 
  104db0:	c7 44 24 04 e3 00 00 	movl   $0xe3,0x4(%esp)
  104db7:	00 
  104db8:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  104dbf:	e8 30 b6 ff ff       	call   1003f4 <__panic>

    assert(alloc_page() == NULL);
  104dc4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104dcb:	e8 24 df ff ff       	call   102cf4 <alloc_pages>
  104dd0:	85 c0                	test   %eax,%eax
  104dd2:	74 24                	je     104df8 <basic_check+0x3fb>
  104dd4:	c7 44 24 0c 1e 70 10 	movl   $0x10701e,0xc(%esp)
  104ddb:	00 
  104ddc:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  104de3:	00 
  104de4:	c7 44 24 04 e5 00 00 	movl   $0xe5,0x4(%esp)
  104deb:	00 
  104dec:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  104df3:	e8 fc b5 ff ff       	call   1003f4 <__panic>

    free_page(p0);
  104df8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104dff:	00 
  104e00:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104e03:	89 04 24             	mov    %eax,(%esp)
  104e06:	e8 21 df ff ff       	call   102d2c <free_pages>
  104e0b:	c7 45 d8 7c af 11 00 	movl   $0x11af7c,-0x28(%ebp)
  104e12:	8b 45 d8             	mov    -0x28(%ebp),%eax
  104e15:	8b 40 04             	mov    0x4(%eax),%eax
  104e18:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  104e1b:	0f 94 c0             	sete   %al
  104e1e:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
  104e21:	85 c0                	test   %eax,%eax
  104e23:	74 24                	je     104e49 <basic_check+0x44c>
  104e25:	c7 44 24 0c 40 70 10 	movl   $0x107040,0xc(%esp)
  104e2c:	00 
  104e2d:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  104e34:	00 
  104e35:	c7 44 24 04 e8 00 00 	movl   $0xe8,0x4(%esp)
  104e3c:	00 
  104e3d:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  104e44:	e8 ab b5 ff ff       	call   1003f4 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
  104e49:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104e50:	e8 9f de ff ff       	call   102cf4 <alloc_pages>
  104e55:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104e58:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104e5b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  104e5e:	74 24                	je     104e84 <basic_check+0x487>
  104e60:	c7 44 24 0c 58 70 10 	movl   $0x107058,0xc(%esp)
  104e67:	00 
  104e68:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  104e6f:	00 
  104e70:	c7 44 24 04 eb 00 00 	movl   $0xeb,0x4(%esp)
  104e77:	00 
  104e78:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  104e7f:	e8 70 b5 ff ff       	call   1003f4 <__panic>
    assert(alloc_page() == NULL);
  104e84:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104e8b:	e8 64 de ff ff       	call   102cf4 <alloc_pages>
  104e90:	85 c0                	test   %eax,%eax
  104e92:	74 24                	je     104eb8 <basic_check+0x4bb>
  104e94:	c7 44 24 0c 1e 70 10 	movl   $0x10701e,0xc(%esp)
  104e9b:	00 
  104e9c:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  104ea3:	00 
  104ea4:	c7 44 24 04 ec 00 00 	movl   $0xec,0x4(%esp)
  104eab:	00 
  104eac:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  104eb3:	e8 3c b5 ff ff       	call   1003f4 <__panic>

    assert(nr_free == 0);
  104eb8:	a1 84 af 11 00       	mov    0x11af84,%eax
  104ebd:	85 c0                	test   %eax,%eax
  104ebf:	74 24                	je     104ee5 <basic_check+0x4e8>
  104ec1:	c7 44 24 0c 71 70 10 	movl   $0x107071,0xc(%esp)
  104ec8:	00 
  104ec9:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  104ed0:	00 
  104ed1:	c7 44 24 04 ee 00 00 	movl   $0xee,0x4(%esp)
  104ed8:	00 
  104ed9:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  104ee0:	e8 0f b5 ff ff       	call   1003f4 <__panic>
    free_list = free_list_store;
  104ee5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104ee8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104eeb:	a3 7c af 11 00       	mov    %eax,0x11af7c
  104ef0:	89 15 80 af 11 00    	mov    %edx,0x11af80
    nr_free = nr_free_store;
  104ef6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104ef9:	a3 84 af 11 00       	mov    %eax,0x11af84

    free_page(p);
  104efe:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104f05:	00 
  104f06:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104f09:	89 04 24             	mov    %eax,(%esp)
  104f0c:	e8 1b de ff ff       	call   102d2c <free_pages>
    free_page(p1);
  104f11:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104f18:	00 
  104f19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104f1c:	89 04 24             	mov    %eax,(%esp)
  104f1f:	e8 08 de ff ff       	call   102d2c <free_pages>
    free_page(p2);
  104f24:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104f2b:	00 
  104f2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104f2f:	89 04 24             	mov    %eax,(%esp)
  104f32:	e8 f5 dd ff ff       	call   102d2c <free_pages>
}
  104f37:	c9                   	leave  
  104f38:	c3                   	ret    

00104f39 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
  104f39:	55                   	push   %ebp
  104f3a:	89 e5                	mov    %esp,%ebp
  104f3c:	53                   	push   %ebx
  104f3d:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
  104f43:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  104f4a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
  104f51:	c7 45 ec 7c af 11 00 	movl   $0x11af7c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  104f58:	eb 6b                	jmp    104fc5 <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
  104f5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104f5d:	83 e8 0c             	sub    $0xc,%eax
  104f60:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
  104f63:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104f66:	83 c0 04             	add    $0x4,%eax
  104f69:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  104f70:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104f73:	8b 45 cc             	mov    -0x34(%ebp),%eax
  104f76:	8b 55 d0             	mov    -0x30(%ebp),%edx
  104f79:	0f a3 10             	bt     %edx,(%eax)
  104f7c:	19 c0                	sbb    %eax,%eax
  104f7e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
  104f81:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  104f85:	0f 95 c0             	setne  %al
  104f88:	0f b6 c0             	movzbl %al,%eax
  104f8b:	85 c0                	test   %eax,%eax
  104f8d:	75 24                	jne    104fb3 <default_check+0x7a>
  104f8f:	c7 44 24 0c 7e 70 10 	movl   $0x10707e,0xc(%esp)
  104f96:	00 
  104f97:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  104f9e:	00 
  104f9f:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  104fa6:	00 
  104fa7:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  104fae:	e8 41 b4 ff ff       	call   1003f4 <__panic>
        count ++, total += p->property;
  104fb3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  104fb7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104fba:	8b 50 08             	mov    0x8(%eax),%edx
  104fbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104fc0:	01 d0                	add    %edx,%eax
  104fc2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104fc5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104fc8:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return listelm->next;
  104fcb:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104fce:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
  104fd1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104fd4:	81 7d ec 7c af 11 00 	cmpl   $0x11af7c,-0x14(%ebp)
  104fdb:	0f 85 79 ff ff ff    	jne    104f5a <default_check+0x21>
    }
    assert(total == nr_free_pages());
  104fe1:	8b 5d f0             	mov    -0x10(%ebp),%ebx
  104fe4:	e8 75 dd ff ff       	call   102d5e <nr_free_pages>
  104fe9:	39 c3                	cmp    %eax,%ebx
  104feb:	74 24                	je     105011 <default_check+0xd8>
  104fed:	c7 44 24 0c 8e 70 10 	movl   $0x10708e,0xc(%esp)
  104ff4:	00 
  104ff5:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  104ffc:	00 
  104ffd:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
  105004:	00 
  105005:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  10500c:	e8 e3 b3 ff ff       	call   1003f4 <__panic>

    basic_check();
  105011:	e8 e7 f9 ff ff       	call   1049fd <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
  105016:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  10501d:	e8 d2 dc ff ff       	call   102cf4 <alloc_pages>
  105022:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
  105025:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105029:	75 24                	jne    10504f <default_check+0x116>
  10502b:	c7 44 24 0c a7 70 10 	movl   $0x1070a7,0xc(%esp)
  105032:	00 
  105033:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  10503a:	00 
  10503b:	c7 44 24 04 07 01 00 	movl   $0x107,0x4(%esp)
  105042:	00 
  105043:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  10504a:	e8 a5 b3 ff ff       	call   1003f4 <__panic>
    assert(!PageProperty(p0));
  10504f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105052:	83 c0 04             	add    $0x4,%eax
  105055:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  10505c:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10505f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  105062:	8b 55 c0             	mov    -0x40(%ebp),%edx
  105065:	0f a3 10             	bt     %edx,(%eax)
  105068:	19 c0                	sbb    %eax,%eax
  10506a:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
  10506d:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  105071:	0f 95 c0             	setne  %al
  105074:	0f b6 c0             	movzbl %al,%eax
  105077:	85 c0                	test   %eax,%eax
  105079:	74 24                	je     10509f <default_check+0x166>
  10507b:	c7 44 24 0c b2 70 10 	movl   $0x1070b2,0xc(%esp)
  105082:	00 
  105083:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  10508a:	00 
  10508b:	c7 44 24 04 08 01 00 	movl   $0x108,0x4(%esp)
  105092:	00 
  105093:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  10509a:	e8 55 b3 ff ff       	call   1003f4 <__panic>

    list_entry_t free_list_store = free_list;
  10509f:	a1 7c af 11 00       	mov    0x11af7c,%eax
  1050a4:	8b 15 80 af 11 00    	mov    0x11af80,%edx
  1050aa:	89 45 80             	mov    %eax,-0x80(%ebp)
  1050ad:	89 55 84             	mov    %edx,-0x7c(%ebp)
  1050b0:	c7 45 b4 7c af 11 00 	movl   $0x11af7c,-0x4c(%ebp)
    elm->prev = elm->next = elm;
  1050b7:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1050ba:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  1050bd:	89 50 04             	mov    %edx,0x4(%eax)
  1050c0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1050c3:	8b 50 04             	mov    0x4(%eax),%edx
  1050c6:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1050c9:	89 10                	mov    %edx,(%eax)
  1050cb:	c7 45 b0 7c af 11 00 	movl   $0x11af7c,-0x50(%ebp)
    return list->next == list;
  1050d2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  1050d5:	8b 40 04             	mov    0x4(%eax),%eax
  1050d8:	39 45 b0             	cmp    %eax,-0x50(%ebp)
  1050db:	0f 94 c0             	sete   %al
  1050de:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  1050e1:	85 c0                	test   %eax,%eax
  1050e3:	75 24                	jne    105109 <default_check+0x1d0>
  1050e5:	c7 44 24 0c 07 70 10 	movl   $0x107007,0xc(%esp)
  1050ec:	00 
  1050ed:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  1050f4:	00 
  1050f5:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
  1050fc:	00 
  1050fd:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  105104:	e8 eb b2 ff ff       	call   1003f4 <__panic>
    assert(alloc_page() == NULL);
  105109:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105110:	e8 df db ff ff       	call   102cf4 <alloc_pages>
  105115:	85 c0                	test   %eax,%eax
  105117:	74 24                	je     10513d <default_check+0x204>
  105119:	c7 44 24 0c 1e 70 10 	movl   $0x10701e,0xc(%esp)
  105120:	00 
  105121:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  105128:	00 
  105129:	c7 44 24 04 0d 01 00 	movl   $0x10d,0x4(%esp)
  105130:	00 
  105131:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  105138:	e8 b7 b2 ff ff       	call   1003f4 <__panic>

    unsigned int nr_free_store = nr_free;
  10513d:	a1 84 af 11 00       	mov    0x11af84,%eax
  105142:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
  105145:	c7 05 84 af 11 00 00 	movl   $0x0,0x11af84
  10514c:	00 00 00 

    free_pages(p0 + 2, 3);
  10514f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105152:	83 c0 28             	add    $0x28,%eax
  105155:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  10515c:	00 
  10515d:	89 04 24             	mov    %eax,(%esp)
  105160:	e8 c7 db ff ff       	call   102d2c <free_pages>
    assert(alloc_pages(4) == NULL);
  105165:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  10516c:	e8 83 db ff ff       	call   102cf4 <alloc_pages>
  105171:	85 c0                	test   %eax,%eax
  105173:	74 24                	je     105199 <default_check+0x260>
  105175:	c7 44 24 0c c4 70 10 	movl   $0x1070c4,0xc(%esp)
  10517c:	00 
  10517d:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  105184:	00 
  105185:	c7 44 24 04 13 01 00 	movl   $0x113,0x4(%esp)
  10518c:	00 
  10518d:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  105194:	e8 5b b2 ff ff       	call   1003f4 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
  105199:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10519c:	83 c0 28             	add    $0x28,%eax
  10519f:	83 c0 04             	add    $0x4,%eax
  1051a2:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
  1051a9:	89 45 a8             	mov    %eax,-0x58(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1051ac:	8b 45 a8             	mov    -0x58(%ebp),%eax
  1051af:	8b 55 ac             	mov    -0x54(%ebp),%edx
  1051b2:	0f a3 10             	bt     %edx,(%eax)
  1051b5:	19 c0                	sbb    %eax,%eax
  1051b7:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
  1051ba:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  1051be:	0f 95 c0             	setne  %al
  1051c1:	0f b6 c0             	movzbl %al,%eax
  1051c4:	85 c0                	test   %eax,%eax
  1051c6:	74 0e                	je     1051d6 <default_check+0x29d>
  1051c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1051cb:	83 c0 28             	add    $0x28,%eax
  1051ce:	8b 40 08             	mov    0x8(%eax),%eax
  1051d1:	83 f8 03             	cmp    $0x3,%eax
  1051d4:	74 24                	je     1051fa <default_check+0x2c1>
  1051d6:	c7 44 24 0c dc 70 10 	movl   $0x1070dc,0xc(%esp)
  1051dd:	00 
  1051de:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  1051e5:	00 
  1051e6:	c7 44 24 04 14 01 00 	movl   $0x114,0x4(%esp)
  1051ed:	00 
  1051ee:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  1051f5:	e8 fa b1 ff ff       	call   1003f4 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
  1051fa:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  105201:	e8 ee da ff ff       	call   102cf4 <alloc_pages>
  105206:	89 45 dc             	mov    %eax,-0x24(%ebp)
  105209:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  10520d:	75 24                	jne    105233 <default_check+0x2fa>
  10520f:	c7 44 24 0c 08 71 10 	movl   $0x107108,0xc(%esp)
  105216:	00 
  105217:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  10521e:	00 
  10521f:	c7 44 24 04 15 01 00 	movl   $0x115,0x4(%esp)
  105226:	00 
  105227:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  10522e:	e8 c1 b1 ff ff       	call   1003f4 <__panic>
    assert(alloc_page() == NULL);
  105233:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10523a:	e8 b5 da ff ff       	call   102cf4 <alloc_pages>
  10523f:	85 c0                	test   %eax,%eax
  105241:	74 24                	je     105267 <default_check+0x32e>
  105243:	c7 44 24 0c 1e 70 10 	movl   $0x10701e,0xc(%esp)
  10524a:	00 
  10524b:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  105252:	00 
  105253:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
  10525a:	00 
  10525b:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  105262:	e8 8d b1 ff ff       	call   1003f4 <__panic>
    assert(p0 + 2 == p1);
  105267:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10526a:	83 c0 28             	add    $0x28,%eax
  10526d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  105270:	74 24                	je     105296 <default_check+0x35d>
  105272:	c7 44 24 0c 26 71 10 	movl   $0x107126,0xc(%esp)
  105279:	00 
  10527a:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  105281:	00 
  105282:	c7 44 24 04 17 01 00 	movl   $0x117,0x4(%esp)
  105289:	00 
  10528a:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  105291:	e8 5e b1 ff ff       	call   1003f4 <__panic>

    p2 = p0 + 1;
  105296:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105299:	83 c0 14             	add    $0x14,%eax
  10529c:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
  10529f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1052a6:	00 
  1052a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1052aa:	89 04 24             	mov    %eax,(%esp)
  1052ad:	e8 7a da ff ff       	call   102d2c <free_pages>
    free_pages(p1, 3);
  1052b2:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  1052b9:	00 
  1052ba:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1052bd:	89 04 24             	mov    %eax,(%esp)
  1052c0:	e8 67 da ff ff       	call   102d2c <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
  1052c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1052c8:	83 c0 04             	add    $0x4,%eax
  1052cb:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
  1052d2:	89 45 9c             	mov    %eax,-0x64(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1052d5:	8b 45 9c             	mov    -0x64(%ebp),%eax
  1052d8:	8b 55 a0             	mov    -0x60(%ebp),%edx
  1052db:	0f a3 10             	bt     %edx,(%eax)
  1052de:	19 c0                	sbb    %eax,%eax
  1052e0:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
  1052e3:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
  1052e7:	0f 95 c0             	setne  %al
  1052ea:	0f b6 c0             	movzbl %al,%eax
  1052ed:	85 c0                	test   %eax,%eax
  1052ef:	74 0b                	je     1052fc <default_check+0x3c3>
  1052f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1052f4:	8b 40 08             	mov    0x8(%eax),%eax
  1052f7:	83 f8 01             	cmp    $0x1,%eax
  1052fa:	74 24                	je     105320 <default_check+0x3e7>
  1052fc:	c7 44 24 0c 34 71 10 	movl   $0x107134,0xc(%esp)
  105303:	00 
  105304:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  10530b:	00 
  10530c:	c7 44 24 04 1c 01 00 	movl   $0x11c,0x4(%esp)
  105313:	00 
  105314:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  10531b:	e8 d4 b0 ff ff       	call   1003f4 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
  105320:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105323:	83 c0 04             	add    $0x4,%eax
  105326:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
  10532d:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  105330:	8b 45 90             	mov    -0x70(%ebp),%eax
  105333:	8b 55 94             	mov    -0x6c(%ebp),%edx
  105336:	0f a3 10             	bt     %edx,(%eax)
  105339:	19 c0                	sbb    %eax,%eax
  10533b:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
  10533e:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
  105342:	0f 95 c0             	setne  %al
  105345:	0f b6 c0             	movzbl %al,%eax
  105348:	85 c0                	test   %eax,%eax
  10534a:	74 0b                	je     105357 <default_check+0x41e>
  10534c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10534f:	8b 40 08             	mov    0x8(%eax),%eax
  105352:	83 f8 03             	cmp    $0x3,%eax
  105355:	74 24                	je     10537b <default_check+0x442>
  105357:	c7 44 24 0c 5c 71 10 	movl   $0x10715c,0xc(%esp)
  10535e:	00 
  10535f:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  105366:	00 
  105367:	c7 44 24 04 1d 01 00 	movl   $0x11d,0x4(%esp)
  10536e:	00 
  10536f:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  105376:	e8 79 b0 ff ff       	call   1003f4 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
  10537b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105382:	e8 6d d9 ff ff       	call   102cf4 <alloc_pages>
  105387:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10538a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10538d:	83 e8 14             	sub    $0x14,%eax
  105390:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  105393:	74 24                	je     1053b9 <default_check+0x480>
  105395:	c7 44 24 0c 82 71 10 	movl   $0x107182,0xc(%esp)
  10539c:	00 
  10539d:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  1053a4:	00 
  1053a5:	c7 44 24 04 1f 01 00 	movl   $0x11f,0x4(%esp)
  1053ac:	00 
  1053ad:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  1053b4:	e8 3b b0 ff ff       	call   1003f4 <__panic>
    free_page(p0);
  1053b9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1053c0:	00 
  1053c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1053c4:	89 04 24             	mov    %eax,(%esp)
  1053c7:	e8 60 d9 ff ff       	call   102d2c <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
  1053cc:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1053d3:	e8 1c d9 ff ff       	call   102cf4 <alloc_pages>
  1053d8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1053db:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1053de:	83 c0 14             	add    $0x14,%eax
  1053e1:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  1053e4:	74 24                	je     10540a <default_check+0x4d1>
  1053e6:	c7 44 24 0c a0 71 10 	movl   $0x1071a0,0xc(%esp)
  1053ed:	00 
  1053ee:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  1053f5:	00 
  1053f6:	c7 44 24 04 21 01 00 	movl   $0x121,0x4(%esp)
  1053fd:	00 
  1053fe:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  105405:	e8 ea af ff ff       	call   1003f4 <__panic>

    free_pages(p0, 2);
  10540a:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  105411:	00 
  105412:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105415:	89 04 24             	mov    %eax,(%esp)
  105418:	e8 0f d9 ff ff       	call   102d2c <free_pages>
    free_page(p2);
  10541d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105424:	00 
  105425:	8b 45 d8             	mov    -0x28(%ebp),%eax
  105428:	89 04 24             	mov    %eax,(%esp)
  10542b:	e8 fc d8 ff ff       	call   102d2c <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
  105430:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  105437:	e8 b8 d8 ff ff       	call   102cf4 <alloc_pages>
  10543c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10543f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105443:	75 24                	jne    105469 <default_check+0x530>
  105445:	c7 44 24 0c c0 71 10 	movl   $0x1071c0,0xc(%esp)
  10544c:	00 
  10544d:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  105454:	00 
  105455:	c7 44 24 04 26 01 00 	movl   $0x126,0x4(%esp)
  10545c:	00 
  10545d:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  105464:	e8 8b af ff ff       	call   1003f4 <__panic>
    assert(alloc_page() == NULL);
  105469:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105470:	e8 7f d8 ff ff       	call   102cf4 <alloc_pages>
  105475:	85 c0                	test   %eax,%eax
  105477:	74 24                	je     10549d <default_check+0x564>
  105479:	c7 44 24 0c 1e 70 10 	movl   $0x10701e,0xc(%esp)
  105480:	00 
  105481:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  105488:	00 
  105489:	c7 44 24 04 27 01 00 	movl   $0x127,0x4(%esp)
  105490:	00 
  105491:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  105498:	e8 57 af ff ff       	call   1003f4 <__panic>

    assert(nr_free == 0);
  10549d:	a1 84 af 11 00       	mov    0x11af84,%eax
  1054a2:	85 c0                	test   %eax,%eax
  1054a4:	74 24                	je     1054ca <default_check+0x591>
  1054a6:	c7 44 24 0c 71 70 10 	movl   $0x107071,0xc(%esp)
  1054ad:	00 
  1054ae:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  1054b5:	00 
  1054b6:	c7 44 24 04 29 01 00 	movl   $0x129,0x4(%esp)
  1054bd:	00 
  1054be:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  1054c5:	e8 2a af ff ff       	call   1003f4 <__panic>
    nr_free = nr_free_store;
  1054ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1054cd:	a3 84 af 11 00       	mov    %eax,0x11af84

    free_list = free_list_store;
  1054d2:	8b 45 80             	mov    -0x80(%ebp),%eax
  1054d5:	8b 55 84             	mov    -0x7c(%ebp),%edx
  1054d8:	a3 7c af 11 00       	mov    %eax,0x11af7c
  1054dd:	89 15 80 af 11 00    	mov    %edx,0x11af80
    free_pages(p0, 5);
  1054e3:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
  1054ea:	00 
  1054eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1054ee:	89 04 24             	mov    %eax,(%esp)
  1054f1:	e8 36 d8 ff ff       	call   102d2c <free_pages>

    le = &free_list;
  1054f6:	c7 45 ec 7c af 11 00 	movl   $0x11af7c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  1054fd:	eb 1d                	jmp    10551c <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
  1054ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105502:	83 e8 0c             	sub    $0xc,%eax
  105505:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
  105508:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  10550c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10550f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  105512:	8b 40 08             	mov    0x8(%eax),%eax
  105515:	29 c2                	sub    %eax,%edx
  105517:	89 d0                	mov    %edx,%eax
  105519:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10551c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10551f:	89 45 88             	mov    %eax,-0x78(%ebp)
    return listelm->next;
  105522:	8b 45 88             	mov    -0x78(%ebp),%eax
  105525:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
  105528:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10552b:	81 7d ec 7c af 11 00 	cmpl   $0x11af7c,-0x14(%ebp)
  105532:	75 cb                	jne    1054ff <default_check+0x5c6>
    }
    assert(count == 0);
  105534:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  105538:	74 24                	je     10555e <default_check+0x625>
  10553a:	c7 44 24 0c de 71 10 	movl   $0x1071de,0xc(%esp)
  105541:	00 
  105542:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  105549:	00 
  10554a:	c7 44 24 04 34 01 00 	movl   $0x134,0x4(%esp)
  105551:	00 
  105552:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  105559:	e8 96 ae ff ff       	call   1003f4 <__panic>
    assert(total == 0);
  10555e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  105562:	74 24                	je     105588 <default_check+0x64f>
  105564:	c7 44 24 0c e9 71 10 	movl   $0x1071e9,0xc(%esp)
  10556b:	00 
  10556c:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  105573:	00 
  105574:	c7 44 24 04 35 01 00 	movl   $0x135,0x4(%esp)
  10557b:	00 
  10557c:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  105583:	e8 6c ae ff ff       	call   1003f4 <__panic>
}
  105588:	81 c4 94 00 00 00    	add    $0x94,%esp
  10558e:	5b                   	pop    %ebx
  10558f:	5d                   	pop    %ebp
  105590:	c3                   	ret    

00105591 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  105591:	55                   	push   %ebp
  105592:	89 e5                	mov    %esp,%ebp
  105594:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105597:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  10559e:	eb 04                	jmp    1055a4 <strlen+0x13>
        cnt ++;
  1055a0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    while (*s ++ != '\0') {
  1055a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1055a7:	8d 50 01             	lea    0x1(%eax),%edx
  1055aa:	89 55 08             	mov    %edx,0x8(%ebp)
  1055ad:	0f b6 00             	movzbl (%eax),%eax
  1055b0:	84 c0                	test   %al,%al
  1055b2:	75 ec                	jne    1055a0 <strlen+0xf>
    }
    return cnt;
  1055b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1055b7:	c9                   	leave  
  1055b8:	c3                   	ret    

001055b9 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  1055b9:	55                   	push   %ebp
  1055ba:	89 e5                	mov    %esp,%ebp
  1055bc:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  1055bf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  1055c6:	eb 04                	jmp    1055cc <strnlen+0x13>
        cnt ++;
  1055c8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  1055cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1055cf:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1055d2:	73 10                	jae    1055e4 <strnlen+0x2b>
  1055d4:	8b 45 08             	mov    0x8(%ebp),%eax
  1055d7:	8d 50 01             	lea    0x1(%eax),%edx
  1055da:	89 55 08             	mov    %edx,0x8(%ebp)
  1055dd:	0f b6 00             	movzbl (%eax),%eax
  1055e0:	84 c0                	test   %al,%al
  1055e2:	75 e4                	jne    1055c8 <strnlen+0xf>
    }
    return cnt;
  1055e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1055e7:	c9                   	leave  
  1055e8:	c3                   	ret    

001055e9 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  1055e9:	55                   	push   %ebp
  1055ea:	89 e5                	mov    %esp,%ebp
  1055ec:	57                   	push   %edi
  1055ed:	56                   	push   %esi
  1055ee:	83 ec 20             	sub    $0x20,%esp
  1055f1:	8b 45 08             	mov    0x8(%ebp),%eax
  1055f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1055f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1055fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  1055fd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105600:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105603:	89 d1                	mov    %edx,%ecx
  105605:	89 c2                	mov    %eax,%edx
  105607:	89 ce                	mov    %ecx,%esi
  105609:	89 d7                	mov    %edx,%edi
  10560b:	ac                   	lods   %ds:(%esi),%al
  10560c:	aa                   	stos   %al,%es:(%edi)
  10560d:	84 c0                	test   %al,%al
  10560f:	75 fa                	jne    10560b <strcpy+0x22>
  105611:	89 fa                	mov    %edi,%edx
  105613:	89 f1                	mov    %esi,%ecx
  105615:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105618:	89 55 e8             	mov    %edx,-0x18(%ebp)
  10561b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
  10561e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  105621:	83 c4 20             	add    $0x20,%esp
  105624:	5e                   	pop    %esi
  105625:	5f                   	pop    %edi
  105626:	5d                   	pop    %ebp
  105627:	c3                   	ret    

00105628 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  105628:	55                   	push   %ebp
  105629:	89 e5                	mov    %esp,%ebp
  10562b:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  10562e:	8b 45 08             	mov    0x8(%ebp),%eax
  105631:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  105634:	eb 21                	jmp    105657 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  105636:	8b 45 0c             	mov    0xc(%ebp),%eax
  105639:	0f b6 10             	movzbl (%eax),%edx
  10563c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10563f:	88 10                	mov    %dl,(%eax)
  105641:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105644:	0f b6 00             	movzbl (%eax),%eax
  105647:	84 c0                	test   %al,%al
  105649:	74 04                	je     10564f <strncpy+0x27>
            src ++;
  10564b:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  10564f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  105653:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    while (len > 0) {
  105657:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10565b:	75 d9                	jne    105636 <strncpy+0xe>
    }
    return dst;
  10565d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105660:	c9                   	leave  
  105661:	c3                   	ret    

00105662 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  105662:	55                   	push   %ebp
  105663:	89 e5                	mov    %esp,%ebp
  105665:	57                   	push   %edi
  105666:	56                   	push   %esi
  105667:	83 ec 20             	sub    $0x20,%esp
  10566a:	8b 45 08             	mov    0x8(%ebp),%eax
  10566d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105670:	8b 45 0c             	mov    0xc(%ebp),%eax
  105673:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
  105676:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105679:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10567c:	89 d1                	mov    %edx,%ecx
  10567e:	89 c2                	mov    %eax,%edx
  105680:	89 ce                	mov    %ecx,%esi
  105682:	89 d7                	mov    %edx,%edi
  105684:	ac                   	lods   %ds:(%esi),%al
  105685:	ae                   	scas   %es:(%edi),%al
  105686:	75 08                	jne    105690 <strcmp+0x2e>
  105688:	84 c0                	test   %al,%al
  10568a:	75 f8                	jne    105684 <strcmp+0x22>
  10568c:	31 c0                	xor    %eax,%eax
  10568e:	eb 04                	jmp    105694 <strcmp+0x32>
  105690:	19 c0                	sbb    %eax,%eax
  105692:	0c 01                	or     $0x1,%al
  105694:	89 fa                	mov    %edi,%edx
  105696:	89 f1                	mov    %esi,%ecx
  105698:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10569b:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  10569e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
  1056a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  1056a4:	83 c4 20             	add    $0x20,%esp
  1056a7:	5e                   	pop    %esi
  1056a8:	5f                   	pop    %edi
  1056a9:	5d                   	pop    %ebp
  1056aa:	c3                   	ret    

001056ab <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  1056ab:	55                   	push   %ebp
  1056ac:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  1056ae:	eb 0c                	jmp    1056bc <strncmp+0x11>
        n --, s1 ++, s2 ++;
  1056b0:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  1056b4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1056b8:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  1056bc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1056c0:	74 1a                	je     1056dc <strncmp+0x31>
  1056c2:	8b 45 08             	mov    0x8(%ebp),%eax
  1056c5:	0f b6 00             	movzbl (%eax),%eax
  1056c8:	84 c0                	test   %al,%al
  1056ca:	74 10                	je     1056dc <strncmp+0x31>
  1056cc:	8b 45 08             	mov    0x8(%ebp),%eax
  1056cf:	0f b6 10             	movzbl (%eax),%edx
  1056d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1056d5:	0f b6 00             	movzbl (%eax),%eax
  1056d8:	38 c2                	cmp    %al,%dl
  1056da:	74 d4                	je     1056b0 <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  1056dc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1056e0:	74 18                	je     1056fa <strncmp+0x4f>
  1056e2:	8b 45 08             	mov    0x8(%ebp),%eax
  1056e5:	0f b6 00             	movzbl (%eax),%eax
  1056e8:	0f b6 d0             	movzbl %al,%edx
  1056eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1056ee:	0f b6 00             	movzbl (%eax),%eax
  1056f1:	0f b6 c0             	movzbl %al,%eax
  1056f4:	29 c2                	sub    %eax,%edx
  1056f6:	89 d0                	mov    %edx,%eax
  1056f8:	eb 05                	jmp    1056ff <strncmp+0x54>
  1056fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1056ff:	5d                   	pop    %ebp
  105700:	c3                   	ret    

00105701 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  105701:	55                   	push   %ebp
  105702:	89 e5                	mov    %esp,%ebp
  105704:	83 ec 04             	sub    $0x4,%esp
  105707:	8b 45 0c             	mov    0xc(%ebp),%eax
  10570a:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  10570d:	eb 14                	jmp    105723 <strchr+0x22>
        if (*s == c) {
  10570f:	8b 45 08             	mov    0x8(%ebp),%eax
  105712:	0f b6 00             	movzbl (%eax),%eax
  105715:	3a 45 fc             	cmp    -0x4(%ebp),%al
  105718:	75 05                	jne    10571f <strchr+0x1e>
            return (char *)s;
  10571a:	8b 45 08             	mov    0x8(%ebp),%eax
  10571d:	eb 13                	jmp    105732 <strchr+0x31>
        }
        s ++;
  10571f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s != '\0') {
  105723:	8b 45 08             	mov    0x8(%ebp),%eax
  105726:	0f b6 00             	movzbl (%eax),%eax
  105729:	84 c0                	test   %al,%al
  10572b:	75 e2                	jne    10570f <strchr+0xe>
    }
    return NULL;
  10572d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105732:	c9                   	leave  
  105733:	c3                   	ret    

00105734 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  105734:	55                   	push   %ebp
  105735:	89 e5                	mov    %esp,%ebp
  105737:	83 ec 04             	sub    $0x4,%esp
  10573a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10573d:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105740:	eb 11                	jmp    105753 <strfind+0x1f>
        if (*s == c) {
  105742:	8b 45 08             	mov    0x8(%ebp),%eax
  105745:	0f b6 00             	movzbl (%eax),%eax
  105748:	3a 45 fc             	cmp    -0x4(%ebp),%al
  10574b:	75 02                	jne    10574f <strfind+0x1b>
            break;
  10574d:	eb 0e                	jmp    10575d <strfind+0x29>
        }
        s ++;
  10574f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s != '\0') {
  105753:	8b 45 08             	mov    0x8(%ebp),%eax
  105756:	0f b6 00             	movzbl (%eax),%eax
  105759:	84 c0                	test   %al,%al
  10575b:	75 e5                	jne    105742 <strfind+0xe>
    }
    return (char *)s;
  10575d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105760:	c9                   	leave  
  105761:	c3                   	ret    

00105762 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  105762:	55                   	push   %ebp
  105763:	89 e5                	mov    %esp,%ebp
  105765:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  105768:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  10576f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  105776:	eb 04                	jmp    10577c <strtol+0x1a>
        s ++;
  105778:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
  10577c:	8b 45 08             	mov    0x8(%ebp),%eax
  10577f:	0f b6 00             	movzbl (%eax),%eax
  105782:	3c 20                	cmp    $0x20,%al
  105784:	74 f2                	je     105778 <strtol+0x16>
  105786:	8b 45 08             	mov    0x8(%ebp),%eax
  105789:	0f b6 00             	movzbl (%eax),%eax
  10578c:	3c 09                	cmp    $0x9,%al
  10578e:	74 e8                	je     105778 <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+') {
  105790:	8b 45 08             	mov    0x8(%ebp),%eax
  105793:	0f b6 00             	movzbl (%eax),%eax
  105796:	3c 2b                	cmp    $0x2b,%al
  105798:	75 06                	jne    1057a0 <strtol+0x3e>
        s ++;
  10579a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  10579e:	eb 15                	jmp    1057b5 <strtol+0x53>
    }
    else if (*s == '-') {
  1057a0:	8b 45 08             	mov    0x8(%ebp),%eax
  1057a3:	0f b6 00             	movzbl (%eax),%eax
  1057a6:	3c 2d                	cmp    $0x2d,%al
  1057a8:	75 0b                	jne    1057b5 <strtol+0x53>
        s ++, neg = 1;
  1057aa:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1057ae:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  1057b5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1057b9:	74 06                	je     1057c1 <strtol+0x5f>
  1057bb:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  1057bf:	75 24                	jne    1057e5 <strtol+0x83>
  1057c1:	8b 45 08             	mov    0x8(%ebp),%eax
  1057c4:	0f b6 00             	movzbl (%eax),%eax
  1057c7:	3c 30                	cmp    $0x30,%al
  1057c9:	75 1a                	jne    1057e5 <strtol+0x83>
  1057cb:	8b 45 08             	mov    0x8(%ebp),%eax
  1057ce:	83 c0 01             	add    $0x1,%eax
  1057d1:	0f b6 00             	movzbl (%eax),%eax
  1057d4:	3c 78                	cmp    $0x78,%al
  1057d6:	75 0d                	jne    1057e5 <strtol+0x83>
        s += 2, base = 16;
  1057d8:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  1057dc:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  1057e3:	eb 2a                	jmp    10580f <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  1057e5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1057e9:	75 17                	jne    105802 <strtol+0xa0>
  1057eb:	8b 45 08             	mov    0x8(%ebp),%eax
  1057ee:	0f b6 00             	movzbl (%eax),%eax
  1057f1:	3c 30                	cmp    $0x30,%al
  1057f3:	75 0d                	jne    105802 <strtol+0xa0>
        s ++, base = 8;
  1057f5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1057f9:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  105800:	eb 0d                	jmp    10580f <strtol+0xad>
    }
    else if (base == 0) {
  105802:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105806:	75 07                	jne    10580f <strtol+0xad>
        base = 10;
  105808:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  10580f:	8b 45 08             	mov    0x8(%ebp),%eax
  105812:	0f b6 00             	movzbl (%eax),%eax
  105815:	3c 2f                	cmp    $0x2f,%al
  105817:	7e 1b                	jle    105834 <strtol+0xd2>
  105819:	8b 45 08             	mov    0x8(%ebp),%eax
  10581c:	0f b6 00             	movzbl (%eax),%eax
  10581f:	3c 39                	cmp    $0x39,%al
  105821:	7f 11                	jg     105834 <strtol+0xd2>
            dig = *s - '0';
  105823:	8b 45 08             	mov    0x8(%ebp),%eax
  105826:	0f b6 00             	movzbl (%eax),%eax
  105829:	0f be c0             	movsbl %al,%eax
  10582c:	83 e8 30             	sub    $0x30,%eax
  10582f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105832:	eb 48                	jmp    10587c <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  105834:	8b 45 08             	mov    0x8(%ebp),%eax
  105837:	0f b6 00             	movzbl (%eax),%eax
  10583a:	3c 60                	cmp    $0x60,%al
  10583c:	7e 1b                	jle    105859 <strtol+0xf7>
  10583e:	8b 45 08             	mov    0x8(%ebp),%eax
  105841:	0f b6 00             	movzbl (%eax),%eax
  105844:	3c 7a                	cmp    $0x7a,%al
  105846:	7f 11                	jg     105859 <strtol+0xf7>
            dig = *s - 'a' + 10;
  105848:	8b 45 08             	mov    0x8(%ebp),%eax
  10584b:	0f b6 00             	movzbl (%eax),%eax
  10584e:	0f be c0             	movsbl %al,%eax
  105851:	83 e8 57             	sub    $0x57,%eax
  105854:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105857:	eb 23                	jmp    10587c <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  105859:	8b 45 08             	mov    0x8(%ebp),%eax
  10585c:	0f b6 00             	movzbl (%eax),%eax
  10585f:	3c 40                	cmp    $0x40,%al
  105861:	7e 3d                	jle    1058a0 <strtol+0x13e>
  105863:	8b 45 08             	mov    0x8(%ebp),%eax
  105866:	0f b6 00             	movzbl (%eax),%eax
  105869:	3c 5a                	cmp    $0x5a,%al
  10586b:	7f 33                	jg     1058a0 <strtol+0x13e>
            dig = *s - 'A' + 10;
  10586d:	8b 45 08             	mov    0x8(%ebp),%eax
  105870:	0f b6 00             	movzbl (%eax),%eax
  105873:	0f be c0             	movsbl %al,%eax
  105876:	83 e8 37             	sub    $0x37,%eax
  105879:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  10587c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10587f:	3b 45 10             	cmp    0x10(%ebp),%eax
  105882:	7c 02                	jl     105886 <strtol+0x124>
            break;
  105884:	eb 1a                	jmp    1058a0 <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
  105886:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  10588a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10588d:	0f af 45 10          	imul   0x10(%ebp),%eax
  105891:	89 c2                	mov    %eax,%edx
  105893:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105896:	01 d0                	add    %edx,%eax
  105898:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  10589b:	e9 6f ff ff ff       	jmp    10580f <strtol+0xad>

    if (endptr) {
  1058a0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1058a4:	74 08                	je     1058ae <strtol+0x14c>
        *endptr = (char *) s;
  1058a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1058a9:	8b 55 08             	mov    0x8(%ebp),%edx
  1058ac:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  1058ae:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  1058b2:	74 07                	je     1058bb <strtol+0x159>
  1058b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1058b7:	f7 d8                	neg    %eax
  1058b9:	eb 03                	jmp    1058be <strtol+0x15c>
  1058bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  1058be:	c9                   	leave  
  1058bf:	c3                   	ret    

001058c0 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  1058c0:	55                   	push   %ebp
  1058c1:	89 e5                	mov    %esp,%ebp
  1058c3:	57                   	push   %edi
  1058c4:	83 ec 24             	sub    $0x24,%esp
  1058c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1058ca:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  1058cd:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  1058d1:	8b 55 08             	mov    0x8(%ebp),%edx
  1058d4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  1058d7:	88 45 f7             	mov    %al,-0x9(%ebp)
  1058da:	8b 45 10             	mov    0x10(%ebp),%eax
  1058dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  1058e0:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  1058e3:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  1058e7:	8b 55 f8             	mov    -0x8(%ebp),%edx
  1058ea:	89 d7                	mov    %edx,%edi
  1058ec:	f3 aa                	rep stos %al,%es:(%edi)
  1058ee:	89 fa                	mov    %edi,%edx
  1058f0:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  1058f3:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
  1058f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  1058f9:	83 c4 24             	add    $0x24,%esp
  1058fc:	5f                   	pop    %edi
  1058fd:	5d                   	pop    %ebp
  1058fe:	c3                   	ret    

001058ff <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  1058ff:	55                   	push   %ebp
  105900:	89 e5                	mov    %esp,%ebp
  105902:	57                   	push   %edi
  105903:	56                   	push   %esi
  105904:	53                   	push   %ebx
  105905:	83 ec 30             	sub    $0x30,%esp
  105908:	8b 45 08             	mov    0x8(%ebp),%eax
  10590b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10590e:	8b 45 0c             	mov    0xc(%ebp),%eax
  105911:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105914:	8b 45 10             	mov    0x10(%ebp),%eax
  105917:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  10591a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10591d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  105920:	73 42                	jae    105964 <memmove+0x65>
  105922:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105925:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105928:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10592b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10592e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105931:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105934:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105937:	c1 e8 02             	shr    $0x2,%eax
  10593a:	89 c1                	mov    %eax,%ecx
    asm volatile (
  10593c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10593f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105942:	89 d7                	mov    %edx,%edi
  105944:	89 c6                	mov    %eax,%esi
  105946:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105948:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  10594b:	83 e1 03             	and    $0x3,%ecx
  10594e:	74 02                	je     105952 <memmove+0x53>
  105950:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105952:	89 f0                	mov    %esi,%eax
  105954:	89 fa                	mov    %edi,%edx
  105956:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  105959:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  10595c:	89 45 d0             	mov    %eax,-0x30(%ebp)
        : "memory");
    return dst;
  10595f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105962:	eb 36                	jmp    10599a <memmove+0x9b>
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  105964:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105967:	8d 50 ff             	lea    -0x1(%eax),%edx
  10596a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10596d:	01 c2                	add    %eax,%edx
  10596f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105972:	8d 48 ff             	lea    -0x1(%eax),%ecx
  105975:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105978:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
  10597b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10597e:	89 c1                	mov    %eax,%ecx
  105980:	89 d8                	mov    %ebx,%eax
  105982:	89 d6                	mov    %edx,%esi
  105984:	89 c7                	mov    %eax,%edi
  105986:	fd                   	std    
  105987:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105989:	fc                   	cld    
  10598a:	89 f8                	mov    %edi,%eax
  10598c:	89 f2                	mov    %esi,%edx
  10598e:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  105991:	89 55 c8             	mov    %edx,-0x38(%ebp)
  105994:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
  105997:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  10599a:	83 c4 30             	add    $0x30,%esp
  10599d:	5b                   	pop    %ebx
  10599e:	5e                   	pop    %esi
  10599f:	5f                   	pop    %edi
  1059a0:	5d                   	pop    %ebp
  1059a1:	c3                   	ret    

001059a2 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  1059a2:	55                   	push   %ebp
  1059a3:	89 e5                	mov    %esp,%ebp
  1059a5:	57                   	push   %edi
  1059a6:	56                   	push   %esi
  1059a7:	83 ec 20             	sub    $0x20,%esp
  1059aa:	8b 45 08             	mov    0x8(%ebp),%eax
  1059ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1059b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1059b6:	8b 45 10             	mov    0x10(%ebp),%eax
  1059b9:	89 45 ec             	mov    %eax,-0x14(%ebp)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  1059bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1059bf:	c1 e8 02             	shr    $0x2,%eax
  1059c2:	89 c1                	mov    %eax,%ecx
    asm volatile (
  1059c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1059c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1059ca:	89 d7                	mov    %edx,%edi
  1059cc:	89 c6                	mov    %eax,%esi
  1059ce:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  1059d0:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  1059d3:	83 e1 03             	and    $0x3,%ecx
  1059d6:	74 02                	je     1059da <memcpy+0x38>
  1059d8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1059da:	89 f0                	mov    %esi,%eax
  1059dc:	89 fa                	mov    %edi,%edx
  1059de:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  1059e1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  1059e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
  1059e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  1059ea:	83 c4 20             	add    $0x20,%esp
  1059ed:	5e                   	pop    %esi
  1059ee:	5f                   	pop    %edi
  1059ef:	5d                   	pop    %ebp
  1059f0:	c3                   	ret    

001059f1 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  1059f1:	55                   	push   %ebp
  1059f2:	89 e5                	mov    %esp,%ebp
  1059f4:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  1059f7:	8b 45 08             	mov    0x8(%ebp),%eax
  1059fa:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  1059fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a00:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  105a03:	eb 30                	jmp    105a35 <memcmp+0x44>
        if (*s1 != *s2) {
  105a05:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105a08:	0f b6 10             	movzbl (%eax),%edx
  105a0b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105a0e:	0f b6 00             	movzbl (%eax),%eax
  105a11:	38 c2                	cmp    %al,%dl
  105a13:	74 18                	je     105a2d <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  105a15:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105a18:	0f b6 00             	movzbl (%eax),%eax
  105a1b:	0f b6 d0             	movzbl %al,%edx
  105a1e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105a21:	0f b6 00             	movzbl (%eax),%eax
  105a24:	0f b6 c0             	movzbl %al,%eax
  105a27:	29 c2                	sub    %eax,%edx
  105a29:	89 d0                	mov    %edx,%eax
  105a2b:	eb 1a                	jmp    105a47 <memcmp+0x56>
        }
        s1 ++, s2 ++;
  105a2d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  105a31:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
    while (n -- > 0) {
  105a35:	8b 45 10             	mov    0x10(%ebp),%eax
  105a38:	8d 50 ff             	lea    -0x1(%eax),%edx
  105a3b:	89 55 10             	mov    %edx,0x10(%ebp)
  105a3e:	85 c0                	test   %eax,%eax
  105a40:	75 c3                	jne    105a05 <memcmp+0x14>
    }
    return 0;
  105a42:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105a47:	c9                   	leave  
  105a48:	c3                   	ret    

00105a49 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  105a49:	55                   	push   %ebp
  105a4a:	89 e5                	mov    %esp,%ebp
  105a4c:	83 ec 58             	sub    $0x58,%esp
  105a4f:	8b 45 10             	mov    0x10(%ebp),%eax
  105a52:	89 45 d0             	mov    %eax,-0x30(%ebp)
  105a55:	8b 45 14             	mov    0x14(%ebp),%eax
  105a58:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  105a5b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  105a5e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  105a61:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105a64:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  105a67:	8b 45 18             	mov    0x18(%ebp),%eax
  105a6a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105a6d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105a70:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105a73:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105a76:	89 55 f0             	mov    %edx,-0x10(%ebp)
  105a79:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105a7c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105a7f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  105a83:	74 1c                	je     105aa1 <printnum+0x58>
  105a85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105a88:	ba 00 00 00 00       	mov    $0x0,%edx
  105a8d:	f7 75 e4             	divl   -0x1c(%ebp)
  105a90:	89 55 f4             	mov    %edx,-0xc(%ebp)
  105a93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105a96:	ba 00 00 00 00       	mov    $0x0,%edx
  105a9b:	f7 75 e4             	divl   -0x1c(%ebp)
  105a9e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105aa1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105aa4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105aa7:	f7 75 e4             	divl   -0x1c(%ebp)
  105aaa:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105aad:	89 55 dc             	mov    %edx,-0x24(%ebp)
  105ab0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105ab3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105ab6:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105ab9:	89 55 ec             	mov    %edx,-0x14(%ebp)
  105abc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105abf:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  105ac2:	8b 45 18             	mov    0x18(%ebp),%eax
  105ac5:	ba 00 00 00 00       	mov    $0x0,%edx
  105aca:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  105acd:	77 56                	ja     105b25 <printnum+0xdc>
  105acf:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  105ad2:	72 05                	jb     105ad9 <printnum+0x90>
  105ad4:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  105ad7:	77 4c                	ja     105b25 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
  105ad9:	8b 45 1c             	mov    0x1c(%ebp),%eax
  105adc:	8d 50 ff             	lea    -0x1(%eax),%edx
  105adf:	8b 45 20             	mov    0x20(%ebp),%eax
  105ae2:	89 44 24 18          	mov    %eax,0x18(%esp)
  105ae6:	89 54 24 14          	mov    %edx,0x14(%esp)
  105aea:	8b 45 18             	mov    0x18(%ebp),%eax
  105aed:	89 44 24 10          	mov    %eax,0x10(%esp)
  105af1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105af4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105af7:	89 44 24 08          	mov    %eax,0x8(%esp)
  105afb:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105aff:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b02:	89 44 24 04          	mov    %eax,0x4(%esp)
  105b06:	8b 45 08             	mov    0x8(%ebp),%eax
  105b09:	89 04 24             	mov    %eax,(%esp)
  105b0c:	e8 38 ff ff ff       	call   105a49 <printnum>
  105b11:	eb 1c                	jmp    105b2f <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  105b13:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b16:	89 44 24 04          	mov    %eax,0x4(%esp)
  105b1a:	8b 45 20             	mov    0x20(%ebp),%eax
  105b1d:	89 04 24             	mov    %eax,(%esp)
  105b20:	8b 45 08             	mov    0x8(%ebp),%eax
  105b23:	ff d0                	call   *%eax
        while (-- width > 0)
  105b25:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  105b29:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  105b2d:	7f e4                	jg     105b13 <printnum+0xca>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  105b2f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  105b32:	05 a4 72 10 00       	add    $0x1072a4,%eax
  105b37:	0f b6 00             	movzbl (%eax),%eax
  105b3a:	0f be c0             	movsbl %al,%eax
  105b3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  105b40:	89 54 24 04          	mov    %edx,0x4(%esp)
  105b44:	89 04 24             	mov    %eax,(%esp)
  105b47:	8b 45 08             	mov    0x8(%ebp),%eax
  105b4a:	ff d0                	call   *%eax
}
  105b4c:	c9                   	leave  
  105b4d:	c3                   	ret    

00105b4e <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  105b4e:	55                   	push   %ebp
  105b4f:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  105b51:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  105b55:	7e 14                	jle    105b6b <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  105b57:	8b 45 08             	mov    0x8(%ebp),%eax
  105b5a:	8b 00                	mov    (%eax),%eax
  105b5c:	8d 48 08             	lea    0x8(%eax),%ecx
  105b5f:	8b 55 08             	mov    0x8(%ebp),%edx
  105b62:	89 0a                	mov    %ecx,(%edx)
  105b64:	8b 50 04             	mov    0x4(%eax),%edx
  105b67:	8b 00                	mov    (%eax),%eax
  105b69:	eb 30                	jmp    105b9b <getuint+0x4d>
    }
    else if (lflag) {
  105b6b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105b6f:	74 16                	je     105b87 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  105b71:	8b 45 08             	mov    0x8(%ebp),%eax
  105b74:	8b 00                	mov    (%eax),%eax
  105b76:	8d 48 04             	lea    0x4(%eax),%ecx
  105b79:	8b 55 08             	mov    0x8(%ebp),%edx
  105b7c:	89 0a                	mov    %ecx,(%edx)
  105b7e:	8b 00                	mov    (%eax),%eax
  105b80:	ba 00 00 00 00       	mov    $0x0,%edx
  105b85:	eb 14                	jmp    105b9b <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  105b87:	8b 45 08             	mov    0x8(%ebp),%eax
  105b8a:	8b 00                	mov    (%eax),%eax
  105b8c:	8d 48 04             	lea    0x4(%eax),%ecx
  105b8f:	8b 55 08             	mov    0x8(%ebp),%edx
  105b92:	89 0a                	mov    %ecx,(%edx)
  105b94:	8b 00                	mov    (%eax),%eax
  105b96:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  105b9b:	5d                   	pop    %ebp
  105b9c:	c3                   	ret    

00105b9d <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  105b9d:	55                   	push   %ebp
  105b9e:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  105ba0:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  105ba4:	7e 14                	jle    105bba <getint+0x1d>
        return va_arg(*ap, long long);
  105ba6:	8b 45 08             	mov    0x8(%ebp),%eax
  105ba9:	8b 00                	mov    (%eax),%eax
  105bab:	8d 48 08             	lea    0x8(%eax),%ecx
  105bae:	8b 55 08             	mov    0x8(%ebp),%edx
  105bb1:	89 0a                	mov    %ecx,(%edx)
  105bb3:	8b 50 04             	mov    0x4(%eax),%edx
  105bb6:	8b 00                	mov    (%eax),%eax
  105bb8:	eb 28                	jmp    105be2 <getint+0x45>
    }
    else if (lflag) {
  105bba:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105bbe:	74 12                	je     105bd2 <getint+0x35>
        return va_arg(*ap, long);
  105bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  105bc3:	8b 00                	mov    (%eax),%eax
  105bc5:	8d 48 04             	lea    0x4(%eax),%ecx
  105bc8:	8b 55 08             	mov    0x8(%ebp),%edx
  105bcb:	89 0a                	mov    %ecx,(%edx)
  105bcd:	8b 00                	mov    (%eax),%eax
  105bcf:	99                   	cltd   
  105bd0:	eb 10                	jmp    105be2 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  105bd2:	8b 45 08             	mov    0x8(%ebp),%eax
  105bd5:	8b 00                	mov    (%eax),%eax
  105bd7:	8d 48 04             	lea    0x4(%eax),%ecx
  105bda:	8b 55 08             	mov    0x8(%ebp),%edx
  105bdd:	89 0a                	mov    %ecx,(%edx)
  105bdf:	8b 00                	mov    (%eax),%eax
  105be1:	99                   	cltd   
    }
}
  105be2:	5d                   	pop    %ebp
  105be3:	c3                   	ret    

00105be4 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  105be4:	55                   	push   %ebp
  105be5:	89 e5                	mov    %esp,%ebp
  105be7:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  105bea:	8d 45 14             	lea    0x14(%ebp),%eax
  105bed:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  105bf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105bf3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105bf7:	8b 45 10             	mov    0x10(%ebp),%eax
  105bfa:	89 44 24 08          	mov    %eax,0x8(%esp)
  105bfe:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c01:	89 44 24 04          	mov    %eax,0x4(%esp)
  105c05:	8b 45 08             	mov    0x8(%ebp),%eax
  105c08:	89 04 24             	mov    %eax,(%esp)
  105c0b:	e8 02 00 00 00       	call   105c12 <vprintfmt>
    va_end(ap);
}
  105c10:	c9                   	leave  
  105c11:	c3                   	ret    

00105c12 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  105c12:	55                   	push   %ebp
  105c13:	89 e5                	mov    %esp,%ebp
  105c15:	56                   	push   %esi
  105c16:	53                   	push   %ebx
  105c17:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  105c1a:	eb 18                	jmp    105c34 <vprintfmt+0x22>
            if (ch == '\0') {
  105c1c:	85 db                	test   %ebx,%ebx
  105c1e:	75 05                	jne    105c25 <vprintfmt+0x13>
                return;
  105c20:	e9 d1 03 00 00       	jmp    105ff6 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
  105c25:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c28:	89 44 24 04          	mov    %eax,0x4(%esp)
  105c2c:	89 1c 24             	mov    %ebx,(%esp)
  105c2f:	8b 45 08             	mov    0x8(%ebp),%eax
  105c32:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  105c34:	8b 45 10             	mov    0x10(%ebp),%eax
  105c37:	8d 50 01             	lea    0x1(%eax),%edx
  105c3a:	89 55 10             	mov    %edx,0x10(%ebp)
  105c3d:	0f b6 00             	movzbl (%eax),%eax
  105c40:	0f b6 d8             	movzbl %al,%ebx
  105c43:	83 fb 25             	cmp    $0x25,%ebx
  105c46:	75 d4                	jne    105c1c <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
  105c48:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  105c4c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  105c53:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105c56:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  105c59:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  105c60:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105c63:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  105c66:	8b 45 10             	mov    0x10(%ebp),%eax
  105c69:	8d 50 01             	lea    0x1(%eax),%edx
  105c6c:	89 55 10             	mov    %edx,0x10(%ebp)
  105c6f:	0f b6 00             	movzbl (%eax),%eax
  105c72:	0f b6 d8             	movzbl %al,%ebx
  105c75:	8d 43 dd             	lea    -0x23(%ebx),%eax
  105c78:	83 f8 55             	cmp    $0x55,%eax
  105c7b:	0f 87 44 03 00 00    	ja     105fc5 <vprintfmt+0x3b3>
  105c81:	8b 04 85 c8 72 10 00 	mov    0x1072c8(,%eax,4),%eax
  105c88:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  105c8a:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  105c8e:	eb d6                	jmp    105c66 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  105c90:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  105c94:	eb d0                	jmp    105c66 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  105c96:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  105c9d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105ca0:	89 d0                	mov    %edx,%eax
  105ca2:	c1 e0 02             	shl    $0x2,%eax
  105ca5:	01 d0                	add    %edx,%eax
  105ca7:	01 c0                	add    %eax,%eax
  105ca9:	01 d8                	add    %ebx,%eax
  105cab:	83 e8 30             	sub    $0x30,%eax
  105cae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  105cb1:	8b 45 10             	mov    0x10(%ebp),%eax
  105cb4:	0f b6 00             	movzbl (%eax),%eax
  105cb7:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  105cba:	83 fb 2f             	cmp    $0x2f,%ebx
  105cbd:	7e 0b                	jle    105cca <vprintfmt+0xb8>
  105cbf:	83 fb 39             	cmp    $0x39,%ebx
  105cc2:	7f 06                	jg     105cca <vprintfmt+0xb8>
            for (precision = 0; ; ++ fmt) {
  105cc4:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                    break;
                }
            }
  105cc8:	eb d3                	jmp    105c9d <vprintfmt+0x8b>
            goto process_precision;
  105cca:	eb 33                	jmp    105cff <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
  105ccc:	8b 45 14             	mov    0x14(%ebp),%eax
  105ccf:	8d 50 04             	lea    0x4(%eax),%edx
  105cd2:	89 55 14             	mov    %edx,0x14(%ebp)
  105cd5:	8b 00                	mov    (%eax),%eax
  105cd7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  105cda:	eb 23                	jmp    105cff <vprintfmt+0xed>

        case '.':
            if (width < 0)
  105cdc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105ce0:	79 0c                	jns    105cee <vprintfmt+0xdc>
                width = 0;
  105ce2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  105ce9:	e9 78 ff ff ff       	jmp    105c66 <vprintfmt+0x54>
  105cee:	e9 73 ff ff ff       	jmp    105c66 <vprintfmt+0x54>

        case '#':
            altflag = 1;
  105cf3:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  105cfa:	e9 67 ff ff ff       	jmp    105c66 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
  105cff:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105d03:	79 12                	jns    105d17 <vprintfmt+0x105>
                width = precision, precision = -1;
  105d05:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105d08:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105d0b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  105d12:	e9 4f ff ff ff       	jmp    105c66 <vprintfmt+0x54>
  105d17:	e9 4a ff ff ff       	jmp    105c66 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  105d1c:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  105d20:	e9 41 ff ff ff       	jmp    105c66 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  105d25:	8b 45 14             	mov    0x14(%ebp),%eax
  105d28:	8d 50 04             	lea    0x4(%eax),%edx
  105d2b:	89 55 14             	mov    %edx,0x14(%ebp)
  105d2e:	8b 00                	mov    (%eax),%eax
  105d30:	8b 55 0c             	mov    0xc(%ebp),%edx
  105d33:	89 54 24 04          	mov    %edx,0x4(%esp)
  105d37:	89 04 24             	mov    %eax,(%esp)
  105d3a:	8b 45 08             	mov    0x8(%ebp),%eax
  105d3d:	ff d0                	call   *%eax
            break;
  105d3f:	e9 ac 02 00 00       	jmp    105ff0 <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
  105d44:	8b 45 14             	mov    0x14(%ebp),%eax
  105d47:	8d 50 04             	lea    0x4(%eax),%edx
  105d4a:	89 55 14             	mov    %edx,0x14(%ebp)
  105d4d:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  105d4f:	85 db                	test   %ebx,%ebx
  105d51:	79 02                	jns    105d55 <vprintfmt+0x143>
                err = -err;
  105d53:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  105d55:	83 fb 06             	cmp    $0x6,%ebx
  105d58:	7f 0b                	jg     105d65 <vprintfmt+0x153>
  105d5a:	8b 34 9d 88 72 10 00 	mov    0x107288(,%ebx,4),%esi
  105d61:	85 f6                	test   %esi,%esi
  105d63:	75 23                	jne    105d88 <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
  105d65:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  105d69:	c7 44 24 08 b5 72 10 	movl   $0x1072b5,0x8(%esp)
  105d70:	00 
  105d71:	8b 45 0c             	mov    0xc(%ebp),%eax
  105d74:	89 44 24 04          	mov    %eax,0x4(%esp)
  105d78:	8b 45 08             	mov    0x8(%ebp),%eax
  105d7b:	89 04 24             	mov    %eax,(%esp)
  105d7e:	e8 61 fe ff ff       	call   105be4 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  105d83:	e9 68 02 00 00       	jmp    105ff0 <vprintfmt+0x3de>
                printfmt(putch, putdat, "%s", p);
  105d88:	89 74 24 0c          	mov    %esi,0xc(%esp)
  105d8c:	c7 44 24 08 be 72 10 	movl   $0x1072be,0x8(%esp)
  105d93:	00 
  105d94:	8b 45 0c             	mov    0xc(%ebp),%eax
  105d97:	89 44 24 04          	mov    %eax,0x4(%esp)
  105d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  105d9e:	89 04 24             	mov    %eax,(%esp)
  105da1:	e8 3e fe ff ff       	call   105be4 <printfmt>
            break;
  105da6:	e9 45 02 00 00       	jmp    105ff0 <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  105dab:	8b 45 14             	mov    0x14(%ebp),%eax
  105dae:	8d 50 04             	lea    0x4(%eax),%edx
  105db1:	89 55 14             	mov    %edx,0x14(%ebp)
  105db4:	8b 30                	mov    (%eax),%esi
  105db6:	85 f6                	test   %esi,%esi
  105db8:	75 05                	jne    105dbf <vprintfmt+0x1ad>
                p = "(null)";
  105dba:	be c1 72 10 00       	mov    $0x1072c1,%esi
            }
            if (width > 0 && padc != '-') {
  105dbf:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105dc3:	7e 3e                	jle    105e03 <vprintfmt+0x1f1>
  105dc5:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  105dc9:	74 38                	je     105e03 <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
  105dcb:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  105dce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105dd1:	89 44 24 04          	mov    %eax,0x4(%esp)
  105dd5:	89 34 24             	mov    %esi,(%esp)
  105dd8:	e8 dc f7 ff ff       	call   1055b9 <strnlen>
  105ddd:	29 c3                	sub    %eax,%ebx
  105ddf:	89 d8                	mov    %ebx,%eax
  105de1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105de4:	eb 17                	jmp    105dfd <vprintfmt+0x1eb>
                    putch(padc, putdat);
  105de6:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  105dea:	8b 55 0c             	mov    0xc(%ebp),%edx
  105ded:	89 54 24 04          	mov    %edx,0x4(%esp)
  105df1:	89 04 24             	mov    %eax,(%esp)
  105df4:	8b 45 08             	mov    0x8(%ebp),%eax
  105df7:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
  105df9:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  105dfd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105e01:	7f e3                	jg     105de6 <vprintfmt+0x1d4>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  105e03:	eb 38                	jmp    105e3d <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
  105e05:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  105e09:	74 1f                	je     105e2a <vprintfmt+0x218>
  105e0b:	83 fb 1f             	cmp    $0x1f,%ebx
  105e0e:	7e 05                	jle    105e15 <vprintfmt+0x203>
  105e10:	83 fb 7e             	cmp    $0x7e,%ebx
  105e13:	7e 15                	jle    105e2a <vprintfmt+0x218>
                    putch('?', putdat);
  105e15:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e18:	89 44 24 04          	mov    %eax,0x4(%esp)
  105e1c:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  105e23:	8b 45 08             	mov    0x8(%ebp),%eax
  105e26:	ff d0                	call   *%eax
  105e28:	eb 0f                	jmp    105e39 <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
  105e2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e2d:	89 44 24 04          	mov    %eax,0x4(%esp)
  105e31:	89 1c 24             	mov    %ebx,(%esp)
  105e34:	8b 45 08             	mov    0x8(%ebp),%eax
  105e37:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  105e39:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  105e3d:	89 f0                	mov    %esi,%eax
  105e3f:	8d 70 01             	lea    0x1(%eax),%esi
  105e42:	0f b6 00             	movzbl (%eax),%eax
  105e45:	0f be d8             	movsbl %al,%ebx
  105e48:	85 db                	test   %ebx,%ebx
  105e4a:	74 10                	je     105e5c <vprintfmt+0x24a>
  105e4c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105e50:	78 b3                	js     105e05 <vprintfmt+0x1f3>
  105e52:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  105e56:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105e5a:	79 a9                	jns    105e05 <vprintfmt+0x1f3>
                }
            }
            for (; width > 0; width --) {
  105e5c:	eb 17                	jmp    105e75 <vprintfmt+0x263>
                putch(' ', putdat);
  105e5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e61:	89 44 24 04          	mov    %eax,0x4(%esp)
  105e65:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  105e6c:	8b 45 08             	mov    0x8(%ebp),%eax
  105e6f:	ff d0                	call   *%eax
            for (; width > 0; width --) {
  105e71:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  105e75:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105e79:	7f e3                	jg     105e5e <vprintfmt+0x24c>
            }
            break;
  105e7b:	e9 70 01 00 00       	jmp    105ff0 <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  105e80:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105e83:	89 44 24 04          	mov    %eax,0x4(%esp)
  105e87:	8d 45 14             	lea    0x14(%ebp),%eax
  105e8a:	89 04 24             	mov    %eax,(%esp)
  105e8d:	e8 0b fd ff ff       	call   105b9d <getint>
  105e92:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105e95:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  105e98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105e9b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105e9e:	85 d2                	test   %edx,%edx
  105ea0:	79 26                	jns    105ec8 <vprintfmt+0x2b6>
                putch('-', putdat);
  105ea2:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ea5:	89 44 24 04          	mov    %eax,0x4(%esp)
  105ea9:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  105eb0:	8b 45 08             	mov    0x8(%ebp),%eax
  105eb3:	ff d0                	call   *%eax
                num = -(long long)num;
  105eb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105eb8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105ebb:	f7 d8                	neg    %eax
  105ebd:	83 d2 00             	adc    $0x0,%edx
  105ec0:	f7 da                	neg    %edx
  105ec2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105ec5:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  105ec8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  105ecf:	e9 a8 00 00 00       	jmp    105f7c <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  105ed4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105ed7:	89 44 24 04          	mov    %eax,0x4(%esp)
  105edb:	8d 45 14             	lea    0x14(%ebp),%eax
  105ede:	89 04 24             	mov    %eax,(%esp)
  105ee1:	e8 68 fc ff ff       	call   105b4e <getuint>
  105ee6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105ee9:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  105eec:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  105ef3:	e9 84 00 00 00       	jmp    105f7c <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  105ef8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105efb:	89 44 24 04          	mov    %eax,0x4(%esp)
  105eff:	8d 45 14             	lea    0x14(%ebp),%eax
  105f02:	89 04 24             	mov    %eax,(%esp)
  105f05:	e8 44 fc ff ff       	call   105b4e <getuint>
  105f0a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105f0d:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  105f10:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  105f17:	eb 63                	jmp    105f7c <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
  105f19:	8b 45 0c             	mov    0xc(%ebp),%eax
  105f1c:	89 44 24 04          	mov    %eax,0x4(%esp)
  105f20:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  105f27:	8b 45 08             	mov    0x8(%ebp),%eax
  105f2a:	ff d0                	call   *%eax
            putch('x', putdat);
  105f2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  105f2f:	89 44 24 04          	mov    %eax,0x4(%esp)
  105f33:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  105f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  105f3d:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  105f3f:	8b 45 14             	mov    0x14(%ebp),%eax
  105f42:	8d 50 04             	lea    0x4(%eax),%edx
  105f45:	89 55 14             	mov    %edx,0x14(%ebp)
  105f48:	8b 00                	mov    (%eax),%eax
  105f4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105f4d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  105f54:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  105f5b:	eb 1f                	jmp    105f7c <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  105f5d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105f60:	89 44 24 04          	mov    %eax,0x4(%esp)
  105f64:	8d 45 14             	lea    0x14(%ebp),%eax
  105f67:	89 04 24             	mov    %eax,(%esp)
  105f6a:	e8 df fb ff ff       	call   105b4e <getuint>
  105f6f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105f72:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  105f75:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  105f7c:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  105f80:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105f83:	89 54 24 18          	mov    %edx,0x18(%esp)
  105f87:	8b 55 e8             	mov    -0x18(%ebp),%edx
  105f8a:	89 54 24 14          	mov    %edx,0x14(%esp)
  105f8e:	89 44 24 10          	mov    %eax,0x10(%esp)
  105f92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105f95:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105f98:	89 44 24 08          	mov    %eax,0x8(%esp)
  105f9c:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105fa0:	8b 45 0c             	mov    0xc(%ebp),%eax
  105fa3:	89 44 24 04          	mov    %eax,0x4(%esp)
  105fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  105faa:	89 04 24             	mov    %eax,(%esp)
  105fad:	e8 97 fa ff ff       	call   105a49 <printnum>
            break;
  105fb2:	eb 3c                	jmp    105ff0 <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  105fb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  105fb7:	89 44 24 04          	mov    %eax,0x4(%esp)
  105fbb:	89 1c 24             	mov    %ebx,(%esp)
  105fbe:	8b 45 08             	mov    0x8(%ebp),%eax
  105fc1:	ff d0                	call   *%eax
            break;
  105fc3:	eb 2b                	jmp    105ff0 <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  105fc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  105fc8:	89 44 24 04          	mov    %eax,0x4(%esp)
  105fcc:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  105fd3:	8b 45 08             	mov    0x8(%ebp),%eax
  105fd6:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  105fd8:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  105fdc:	eb 04                	jmp    105fe2 <vprintfmt+0x3d0>
  105fde:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  105fe2:	8b 45 10             	mov    0x10(%ebp),%eax
  105fe5:	83 e8 01             	sub    $0x1,%eax
  105fe8:	0f b6 00             	movzbl (%eax),%eax
  105feb:	3c 25                	cmp    $0x25,%al
  105fed:	75 ef                	jne    105fde <vprintfmt+0x3cc>
                /* do nothing */;
            break;
  105fef:	90                   	nop
        }
    }
  105ff0:	90                   	nop
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  105ff1:	e9 3e fc ff ff       	jmp    105c34 <vprintfmt+0x22>
}
  105ff6:	83 c4 40             	add    $0x40,%esp
  105ff9:	5b                   	pop    %ebx
  105ffa:	5e                   	pop    %esi
  105ffb:	5d                   	pop    %ebp
  105ffc:	c3                   	ret    

00105ffd <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  105ffd:	55                   	push   %ebp
  105ffe:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  106000:	8b 45 0c             	mov    0xc(%ebp),%eax
  106003:	8b 40 08             	mov    0x8(%eax),%eax
  106006:	8d 50 01             	lea    0x1(%eax),%edx
  106009:	8b 45 0c             	mov    0xc(%ebp),%eax
  10600c:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  10600f:	8b 45 0c             	mov    0xc(%ebp),%eax
  106012:	8b 10                	mov    (%eax),%edx
  106014:	8b 45 0c             	mov    0xc(%ebp),%eax
  106017:	8b 40 04             	mov    0x4(%eax),%eax
  10601a:	39 c2                	cmp    %eax,%edx
  10601c:	73 12                	jae    106030 <sprintputch+0x33>
        *b->buf ++ = ch;
  10601e:	8b 45 0c             	mov    0xc(%ebp),%eax
  106021:	8b 00                	mov    (%eax),%eax
  106023:	8d 48 01             	lea    0x1(%eax),%ecx
  106026:	8b 55 0c             	mov    0xc(%ebp),%edx
  106029:	89 0a                	mov    %ecx,(%edx)
  10602b:	8b 55 08             	mov    0x8(%ebp),%edx
  10602e:	88 10                	mov    %dl,(%eax)
    }
}
  106030:	5d                   	pop    %ebp
  106031:	c3                   	ret    

00106032 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  106032:	55                   	push   %ebp
  106033:	89 e5                	mov    %esp,%ebp
  106035:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  106038:	8d 45 14             	lea    0x14(%ebp),%eax
  10603b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  10603e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106041:	89 44 24 0c          	mov    %eax,0xc(%esp)
  106045:	8b 45 10             	mov    0x10(%ebp),%eax
  106048:	89 44 24 08          	mov    %eax,0x8(%esp)
  10604c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10604f:	89 44 24 04          	mov    %eax,0x4(%esp)
  106053:	8b 45 08             	mov    0x8(%ebp),%eax
  106056:	89 04 24             	mov    %eax,(%esp)
  106059:	e8 08 00 00 00       	call   106066 <vsnprintf>
  10605e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  106061:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  106064:	c9                   	leave  
  106065:	c3                   	ret    

00106066 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  106066:	55                   	push   %ebp
  106067:	89 e5                	mov    %esp,%ebp
  106069:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  10606c:	8b 45 08             	mov    0x8(%ebp),%eax
  10606f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  106072:	8b 45 0c             	mov    0xc(%ebp),%eax
  106075:	8d 50 ff             	lea    -0x1(%eax),%edx
  106078:	8b 45 08             	mov    0x8(%ebp),%eax
  10607b:	01 d0                	add    %edx,%eax
  10607d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  106080:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  106087:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  10608b:	74 0a                	je     106097 <vsnprintf+0x31>
  10608d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  106090:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106093:	39 c2                	cmp    %eax,%edx
  106095:	76 07                	jbe    10609e <vsnprintf+0x38>
        return -E_INVAL;
  106097:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  10609c:	eb 2a                	jmp    1060c8 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  10609e:	8b 45 14             	mov    0x14(%ebp),%eax
  1060a1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1060a5:	8b 45 10             	mov    0x10(%ebp),%eax
  1060a8:	89 44 24 08          	mov    %eax,0x8(%esp)
  1060ac:	8d 45 ec             	lea    -0x14(%ebp),%eax
  1060af:	89 44 24 04          	mov    %eax,0x4(%esp)
  1060b3:	c7 04 24 fd 5f 10 00 	movl   $0x105ffd,(%esp)
  1060ba:	e8 53 fb ff ff       	call   105c12 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  1060bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1060c2:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  1060c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1060c8:	c9                   	leave  
  1060c9:	c3                   	ret    
