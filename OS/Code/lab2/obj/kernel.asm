
bin/kernel:     file format elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:

.text
.globl kern_entry
kern_entry:
    # load pa of boot pgdir
    movl $REALLOC(__boot_pgdir), %eax
c0100000:	b8 00 80 11 00       	mov    $0x118000,%eax
    movl %eax, %cr3
c0100005:	0f 22 d8             	mov    %eax,%cr3

    # enable paging
    movl %cr0, %eax
c0100008:	0f 20 c0             	mov    %cr0,%eax
    orl $(CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP), %eax
c010000b:	0d 2f 00 05 80       	or     $0x8005002f,%eax
    andl $~(CR0_TS | CR0_EM), %eax
c0100010:	83 e0 f3             	and    $0xfffffff3,%eax
    movl %eax, %cr0
c0100013:	0f 22 c0             	mov    %eax,%cr0

    # update eip
    # now, eip = 0x1.....
    leal next, %eax
c0100016:	8d 05 1e 00 10 c0    	lea    0xc010001e,%eax
    # set eip = KERNBASE + 0x1.....
    jmp *%eax
c010001c:	ff e0                	jmp    *%eax

c010001e <next>:
next:

    # unmap va 0 ~ 4M, it's temporary mapping
    xorl %eax, %eax
c010001e:	31 c0                	xor    %eax,%eax
    movl %eax, __boot_pgdir
c0100020:	a3 00 80 11 c0       	mov    %eax,0xc0118000

    # set ebp, esp
    movl $0x0, %ebp
c0100025:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010002a:	bc 00 70 11 c0       	mov    $0xc0117000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
c010002f:	e8 02 00 00 00       	call   c0100036 <kern_init>

c0100034 <spin>:

# should never get here
spin:
    jmp spin
c0100034:	eb fe                	jmp    c0100034 <spin>

c0100036 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
c0100036:	55                   	push   %ebp
c0100037:	89 e5                	mov    %esp,%ebp
c0100039:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
c010003c:	ba 88 af 11 c0       	mov    $0xc011af88,%edx
c0100041:	b8 00 a0 11 c0       	mov    $0xc011a000,%eax
c0100046:	29 c2                	sub    %eax,%edx
c0100048:	89 d0                	mov    %edx,%eax
c010004a:	89 44 24 08          	mov    %eax,0x8(%esp)
c010004e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100055:	00 
c0100056:	c7 04 24 00 a0 11 c0 	movl   $0xc011a000,(%esp)
c010005d:	e8 5e 58 00 00       	call   c01058c0 <memset>

    cons_init();                // init the console
c0100062:	e8 8d 15 00 00       	call   c01015f4 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c0100067:	c7 45 f4 e0 60 10 c0 	movl   $0xc01060e0,-0xc(%ebp)
    cprintf("%s\n\n", message);
c010006e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100071:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100075:	c7 04 24 fc 60 10 c0 	movl   $0xc01060fc,(%esp)
c010007c:	e8 1c 02 00 00       	call   c010029d <cprintf>

    print_kerninfo();
c0100081:	e8 ce 08 00 00       	call   c0100954 <print_kerninfo>

    grade_backtrace();
c0100086:	e8 86 00 00 00       	call   c0100111 <grade_backtrace>

    pmm_init();                 // init physical memory management
c010008b:	e8 3b 32 00 00       	call   c01032cb <pmm_init>

    pic_init();                 // init interrupt controller
c0100090:	e8 bc 16 00 00       	call   c0101751 <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100095:	e8 40 18 00 00       	call   c01018da <idt_init>

    clock_init();               // init clock interrupt
c010009a:	e8 0b 0d 00 00       	call   c0100daa <clock_init>
    intr_enable();              // enable irq interrupt
c010009f:	e8 e8 17 00 00       	call   c010188c <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
c01000a4:	eb fe                	jmp    c01000a4 <kern_init+0x6e>

c01000a6 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c01000a6:	55                   	push   %ebp
c01000a7:	89 e5                	mov    %esp,%ebp
c01000a9:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
c01000ac:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01000b3:	00 
c01000b4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01000bb:	00 
c01000bc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01000c3:	e8 d0 0c 00 00       	call   c0100d98 <mon_backtrace>
}
c01000c8:	c9                   	leave  
c01000c9:	c3                   	ret    

c01000ca <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000ca:	55                   	push   %ebp
c01000cb:	89 e5                	mov    %esp,%ebp
c01000cd:	53                   	push   %ebx
c01000ce:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000d1:	8d 5d 0c             	lea    0xc(%ebp),%ebx
c01000d4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c01000d7:	8d 55 08             	lea    0x8(%ebp),%edx
c01000da:	8b 45 08             	mov    0x8(%ebp),%eax
c01000dd:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01000e1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01000e5:	89 54 24 04          	mov    %edx,0x4(%esp)
c01000e9:	89 04 24             	mov    %eax,(%esp)
c01000ec:	e8 b5 ff ff ff       	call   c01000a6 <grade_backtrace2>
}
c01000f1:	83 c4 14             	add    $0x14,%esp
c01000f4:	5b                   	pop    %ebx
c01000f5:	5d                   	pop    %ebp
c01000f6:	c3                   	ret    

c01000f7 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c01000f7:	55                   	push   %ebp
c01000f8:	89 e5                	mov    %esp,%ebp
c01000fa:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
c01000fd:	8b 45 10             	mov    0x10(%ebp),%eax
c0100100:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100104:	8b 45 08             	mov    0x8(%ebp),%eax
c0100107:	89 04 24             	mov    %eax,(%esp)
c010010a:	e8 bb ff ff ff       	call   c01000ca <grade_backtrace1>
}
c010010f:	c9                   	leave  
c0100110:	c3                   	ret    

c0100111 <grade_backtrace>:

void
grade_backtrace(void) {
c0100111:	55                   	push   %ebp
c0100112:	89 e5                	mov    %esp,%ebp
c0100114:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c0100117:	b8 36 00 10 c0       	mov    $0xc0100036,%eax
c010011c:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
c0100123:	ff 
c0100124:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100128:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c010012f:	e8 c3 ff ff ff       	call   c01000f7 <grade_backtrace0>
}
c0100134:	c9                   	leave  
c0100135:	c3                   	ret    

c0100136 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c0100136:	55                   	push   %ebp
c0100137:	89 e5                	mov    %esp,%ebp
c0100139:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c010013c:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c010013f:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c0100142:	8c 45 f2             	mov    %es,-0xe(%ebp)
c0100145:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c0100148:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010014c:	0f b7 c0             	movzwl %ax,%eax
c010014f:	83 e0 03             	and    $0x3,%eax
c0100152:	89 c2                	mov    %eax,%edx
c0100154:	a1 00 a0 11 c0       	mov    0xc011a000,%eax
c0100159:	89 54 24 08          	mov    %edx,0x8(%esp)
c010015d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100161:	c7 04 24 01 61 10 c0 	movl   $0xc0106101,(%esp)
c0100168:	e8 30 01 00 00       	call   c010029d <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c010016d:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100171:	0f b7 d0             	movzwl %ax,%edx
c0100174:	a1 00 a0 11 c0       	mov    0xc011a000,%eax
c0100179:	89 54 24 08          	mov    %edx,0x8(%esp)
c010017d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100181:	c7 04 24 0f 61 10 c0 	movl   $0xc010610f,(%esp)
c0100188:	e8 10 01 00 00       	call   c010029d <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c010018d:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0100191:	0f b7 d0             	movzwl %ax,%edx
c0100194:	a1 00 a0 11 c0       	mov    0xc011a000,%eax
c0100199:	89 54 24 08          	mov    %edx,0x8(%esp)
c010019d:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001a1:	c7 04 24 1d 61 10 c0 	movl   $0xc010611d,(%esp)
c01001a8:	e8 f0 00 00 00       	call   c010029d <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001ad:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001b1:	0f b7 d0             	movzwl %ax,%edx
c01001b4:	a1 00 a0 11 c0       	mov    0xc011a000,%eax
c01001b9:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001bd:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001c1:	c7 04 24 2b 61 10 c0 	movl   $0xc010612b,(%esp)
c01001c8:	e8 d0 00 00 00       	call   c010029d <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001cd:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001d1:	0f b7 d0             	movzwl %ax,%edx
c01001d4:	a1 00 a0 11 c0       	mov    0xc011a000,%eax
c01001d9:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001dd:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001e1:	c7 04 24 39 61 10 c0 	movl   $0xc0106139,(%esp)
c01001e8:	e8 b0 00 00 00       	call   c010029d <cprintf>
    round ++;
c01001ed:	a1 00 a0 11 c0       	mov    0xc011a000,%eax
c01001f2:	83 c0 01             	add    $0x1,%eax
c01001f5:	a3 00 a0 11 c0       	mov    %eax,0xc011a000
}
c01001fa:	c9                   	leave  
c01001fb:	c3                   	ret    

c01001fc <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c01001fc:	55                   	push   %ebp
c01001fd:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
	asm volatile (
c01001ff:	83 ec 08             	sub    $0x8,%esp
c0100202:	cd 78                	int    $0x78
c0100204:	89 ec                	mov    %ebp,%esp
		"int %0 \n"
		"movl %%ebp, %%esp \n"  // 此处的作用，是为了跟后面的汇编一起发挥leave作用
		:
		: "i"(T_SWITCH_TOU)
	);
}
c0100206:	5d                   	pop    %ebp
c0100207:	c3                   	ret    

c0100208 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c0100208:	55                   	push   %ebp
c0100209:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
	asm volatile (
c010020b:	cd 79                	int    $0x79
c010020d:	89 ec                	mov    %ebp,%esp
		"movl %%ebp, %%esp \n"  // 此处的作用，是为了跟后面的汇编一起发挥leave作用
		:
		: "i"(T_SWITCH_TOK)
	);

}
c010020f:	5d                   	pop    %ebp
c0100210:	c3                   	ret    

c0100211 <lab1_switch_test>:

static void
lab1_switch_test(void) {
c0100211:	55                   	push   %ebp
c0100212:	89 e5                	mov    %esp,%ebp
c0100214:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
c0100217:	e8 1a ff ff ff       	call   c0100136 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c010021c:	c7 04 24 48 61 10 c0 	movl   $0xc0106148,(%esp)
c0100223:	e8 75 00 00 00       	call   c010029d <cprintf>
    lab1_switch_to_user();
c0100228:	e8 cf ff ff ff       	call   c01001fc <lab1_switch_to_user>
    lab1_print_cur_status();
c010022d:	e8 04 ff ff ff       	call   c0100136 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c0100232:	c7 04 24 68 61 10 c0 	movl   $0xc0106168,(%esp)
c0100239:	e8 5f 00 00 00       	call   c010029d <cprintf>
    lab1_switch_to_kernel();
c010023e:	e8 c5 ff ff ff       	call   c0100208 <lab1_switch_to_kernel>
    lab1_print_cur_status();
c0100243:	e8 ee fe ff ff       	call   c0100136 <lab1_print_cur_status>
}
c0100248:	c9                   	leave  
c0100249:	c3                   	ret    

c010024a <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c010024a:	55                   	push   %ebp
c010024b:	89 e5                	mov    %esp,%ebp
c010024d:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c0100250:	8b 45 08             	mov    0x8(%ebp),%eax
c0100253:	89 04 24             	mov    %eax,(%esp)
c0100256:	e8 c5 13 00 00       	call   c0101620 <cons_putc>
    (*cnt) ++;
c010025b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010025e:	8b 00                	mov    (%eax),%eax
c0100260:	8d 50 01             	lea    0x1(%eax),%edx
c0100263:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100266:	89 10                	mov    %edx,(%eax)
}
c0100268:	c9                   	leave  
c0100269:	c3                   	ret    

c010026a <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c010026a:	55                   	push   %ebp
c010026b:	89 e5                	mov    %esp,%ebp
c010026d:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c0100270:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c0100277:	8b 45 0c             	mov    0xc(%ebp),%eax
c010027a:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010027e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100281:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100285:	8d 45 f4             	lea    -0xc(%ebp),%eax
c0100288:	89 44 24 04          	mov    %eax,0x4(%esp)
c010028c:	c7 04 24 4a 02 10 c0 	movl   $0xc010024a,(%esp)
c0100293:	e8 7a 59 00 00       	call   c0105c12 <vprintfmt>
    return cnt;
c0100298:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010029b:	c9                   	leave  
c010029c:	c3                   	ret    

c010029d <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c010029d:	55                   	push   %ebp
c010029e:	89 e5                	mov    %esp,%ebp
c01002a0:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c01002a3:	8d 45 0c             	lea    0xc(%ebp),%eax
c01002a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c01002a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002ac:	89 44 24 04          	mov    %eax,0x4(%esp)
c01002b0:	8b 45 08             	mov    0x8(%ebp),%eax
c01002b3:	89 04 24             	mov    %eax,(%esp)
c01002b6:	e8 af ff ff ff       	call   c010026a <vcprintf>
c01002bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c01002be:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01002c1:	c9                   	leave  
c01002c2:	c3                   	ret    

c01002c3 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c01002c3:	55                   	push   %ebp
c01002c4:	89 e5                	mov    %esp,%ebp
c01002c6:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c01002c9:	8b 45 08             	mov    0x8(%ebp),%eax
c01002cc:	89 04 24             	mov    %eax,(%esp)
c01002cf:	e8 4c 13 00 00       	call   c0101620 <cons_putc>
}
c01002d4:	c9                   	leave  
c01002d5:	c3                   	ret    

c01002d6 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c01002d6:	55                   	push   %ebp
c01002d7:	89 e5                	mov    %esp,%ebp
c01002d9:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c01002dc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c01002e3:	eb 13                	jmp    c01002f8 <cputs+0x22>
        cputch(c, &cnt);
c01002e5:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c01002e9:	8d 55 f0             	lea    -0x10(%ebp),%edx
c01002ec:	89 54 24 04          	mov    %edx,0x4(%esp)
c01002f0:	89 04 24             	mov    %eax,(%esp)
c01002f3:	e8 52 ff ff ff       	call   c010024a <cputch>
    while ((c = *str ++) != '\0') {
c01002f8:	8b 45 08             	mov    0x8(%ebp),%eax
c01002fb:	8d 50 01             	lea    0x1(%eax),%edx
c01002fe:	89 55 08             	mov    %edx,0x8(%ebp)
c0100301:	0f b6 00             	movzbl (%eax),%eax
c0100304:	88 45 f7             	mov    %al,-0x9(%ebp)
c0100307:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c010030b:	75 d8                	jne    c01002e5 <cputs+0xf>
    }
    cputch('\n', &cnt);
c010030d:	8d 45 f0             	lea    -0x10(%ebp),%eax
c0100310:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100314:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
c010031b:	e8 2a ff ff ff       	call   c010024a <cputch>
    return cnt;
c0100320:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0100323:	c9                   	leave  
c0100324:	c3                   	ret    

c0100325 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c0100325:	55                   	push   %ebp
c0100326:	89 e5                	mov    %esp,%ebp
c0100328:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c010032b:	e8 2c 13 00 00       	call   c010165c <cons_getc>
c0100330:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100333:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100337:	74 f2                	je     c010032b <getchar+0x6>
        /* do nothing */;
    return c;
c0100339:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010033c:	c9                   	leave  
c010033d:	c3                   	ret    

c010033e <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c010033e:	55                   	push   %ebp
c010033f:	89 e5                	mov    %esp,%ebp
c0100341:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
c0100344:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100348:	74 13                	je     c010035d <readline+0x1f>
        cprintf("%s", prompt);
c010034a:	8b 45 08             	mov    0x8(%ebp),%eax
c010034d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100351:	c7 04 24 87 61 10 c0 	movl   $0xc0106187,(%esp)
c0100358:	e8 40 ff ff ff       	call   c010029d <cprintf>
    }
    int i = 0, c;
c010035d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c0100364:	e8 bc ff ff ff       	call   c0100325 <getchar>
c0100369:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c010036c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100370:	79 07                	jns    c0100379 <readline+0x3b>
            return NULL;
c0100372:	b8 00 00 00 00       	mov    $0x0,%eax
c0100377:	eb 79                	jmp    c01003f2 <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c0100379:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c010037d:	7e 28                	jle    c01003a7 <readline+0x69>
c010037f:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c0100386:	7f 1f                	jg     c01003a7 <readline+0x69>
            cputchar(c);
c0100388:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010038b:	89 04 24             	mov    %eax,(%esp)
c010038e:	e8 30 ff ff ff       	call   c01002c3 <cputchar>
            buf[i ++] = c;
c0100393:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100396:	8d 50 01             	lea    0x1(%eax),%edx
c0100399:	89 55 f4             	mov    %edx,-0xc(%ebp)
c010039c:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010039f:	88 90 20 a0 11 c0    	mov    %dl,-0x3fee5fe0(%eax)
c01003a5:	eb 46                	jmp    c01003ed <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
c01003a7:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c01003ab:	75 17                	jne    c01003c4 <readline+0x86>
c01003ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01003b1:	7e 11                	jle    c01003c4 <readline+0x86>
            cputchar(c);
c01003b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01003b6:	89 04 24             	mov    %eax,(%esp)
c01003b9:	e8 05 ff ff ff       	call   c01002c3 <cputchar>
            i --;
c01003be:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01003c2:	eb 29                	jmp    c01003ed <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
c01003c4:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01003c8:	74 06                	je     c01003d0 <readline+0x92>
c01003ca:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01003ce:	75 1d                	jne    c01003ed <readline+0xaf>
            cputchar(c);
c01003d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01003d3:	89 04 24             	mov    %eax,(%esp)
c01003d6:	e8 e8 fe ff ff       	call   c01002c3 <cputchar>
            buf[i] = '\0';
c01003db:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01003de:	05 20 a0 11 c0       	add    $0xc011a020,%eax
c01003e3:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01003e6:	b8 20 a0 11 c0       	mov    $0xc011a020,%eax
c01003eb:	eb 05                	jmp    c01003f2 <readline+0xb4>
        }
    }
c01003ed:	e9 72 ff ff ff       	jmp    c0100364 <readline+0x26>
}
c01003f2:	c9                   	leave  
c01003f3:	c3                   	ret    

c01003f4 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c01003f4:	55                   	push   %ebp
c01003f5:	89 e5                	mov    %esp,%ebp
c01003f7:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c01003fa:	a1 20 a4 11 c0       	mov    0xc011a420,%eax
c01003ff:	85 c0                	test   %eax,%eax
c0100401:	74 02                	je     c0100405 <__panic+0x11>
        goto panic_dead;
c0100403:	eb 59                	jmp    c010045e <__panic+0x6a>
    }
    is_panic = 1;
c0100405:	c7 05 20 a4 11 c0 01 	movl   $0x1,0xc011a420
c010040c:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c010040f:	8d 45 14             	lea    0x14(%ebp),%eax
c0100412:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100415:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100418:	89 44 24 08          	mov    %eax,0x8(%esp)
c010041c:	8b 45 08             	mov    0x8(%ebp),%eax
c010041f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100423:	c7 04 24 8a 61 10 c0 	movl   $0xc010618a,(%esp)
c010042a:	e8 6e fe ff ff       	call   c010029d <cprintf>
    vcprintf(fmt, ap);
c010042f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100432:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100436:	8b 45 10             	mov    0x10(%ebp),%eax
c0100439:	89 04 24             	mov    %eax,(%esp)
c010043c:	e8 29 fe ff ff       	call   c010026a <vcprintf>
    cprintf("\n");
c0100441:	c7 04 24 a6 61 10 c0 	movl   $0xc01061a6,(%esp)
c0100448:	e8 50 fe ff ff       	call   c010029d <cprintf>
    
    cprintf("stack trackback:\n");
c010044d:	c7 04 24 a8 61 10 c0 	movl   $0xc01061a8,(%esp)
c0100454:	e8 44 fe ff ff       	call   c010029d <cprintf>
    print_stackframe();
c0100459:	e8 40 06 00 00       	call   c0100a9e <print_stackframe>
    
    va_end(ap);

panic_dead:
    intr_disable();
c010045e:	e8 2f 14 00 00       	call   c0101892 <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100463:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c010046a:	e8 5a 08 00 00       	call   c0100cc9 <kmonitor>
    }
c010046f:	eb f2                	jmp    c0100463 <__panic+0x6f>

c0100471 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c0100471:	55                   	push   %ebp
c0100472:	89 e5                	mov    %esp,%ebp
c0100474:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c0100477:	8d 45 14             	lea    0x14(%ebp),%eax
c010047a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c010047d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100480:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100484:	8b 45 08             	mov    0x8(%ebp),%eax
c0100487:	89 44 24 04          	mov    %eax,0x4(%esp)
c010048b:	c7 04 24 ba 61 10 c0 	movl   $0xc01061ba,(%esp)
c0100492:	e8 06 fe ff ff       	call   c010029d <cprintf>
    vcprintf(fmt, ap);
c0100497:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010049a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010049e:	8b 45 10             	mov    0x10(%ebp),%eax
c01004a1:	89 04 24             	mov    %eax,(%esp)
c01004a4:	e8 c1 fd ff ff       	call   c010026a <vcprintf>
    cprintf("\n");
c01004a9:	c7 04 24 a6 61 10 c0 	movl   $0xc01061a6,(%esp)
c01004b0:	e8 e8 fd ff ff       	call   c010029d <cprintf>
    va_end(ap);
}
c01004b5:	c9                   	leave  
c01004b6:	c3                   	ret    

c01004b7 <is_kernel_panic>:

bool
is_kernel_panic(void) {
c01004b7:	55                   	push   %ebp
c01004b8:	89 e5                	mov    %esp,%ebp
    return is_panic;
c01004ba:	a1 20 a4 11 c0       	mov    0xc011a420,%eax
}
c01004bf:	5d                   	pop    %ebp
c01004c0:	c3                   	ret    

c01004c1 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c01004c1:	55                   	push   %ebp
c01004c2:	89 e5                	mov    %esp,%ebp
c01004c4:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c01004c7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004ca:	8b 00                	mov    (%eax),%eax
c01004cc:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01004cf:	8b 45 10             	mov    0x10(%ebp),%eax
c01004d2:	8b 00                	mov    (%eax),%eax
c01004d4:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004d7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c01004de:	e9 d2 00 00 00       	jmp    c01005b5 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
c01004e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01004e6:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01004e9:	01 d0                	add    %edx,%eax
c01004eb:	89 c2                	mov    %eax,%edx
c01004ed:	c1 ea 1f             	shr    $0x1f,%edx
c01004f0:	01 d0                	add    %edx,%eax
c01004f2:	d1 f8                	sar    %eax
c01004f4:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01004f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01004fa:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c01004fd:	eb 04                	jmp    c0100503 <stab_binsearch+0x42>
            m --;
c01004ff:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
c0100503:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100506:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100509:	7c 1f                	jl     c010052a <stab_binsearch+0x69>
c010050b:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010050e:	89 d0                	mov    %edx,%eax
c0100510:	01 c0                	add    %eax,%eax
c0100512:	01 d0                	add    %edx,%eax
c0100514:	c1 e0 02             	shl    $0x2,%eax
c0100517:	89 c2                	mov    %eax,%edx
c0100519:	8b 45 08             	mov    0x8(%ebp),%eax
c010051c:	01 d0                	add    %edx,%eax
c010051e:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100522:	0f b6 c0             	movzbl %al,%eax
c0100525:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100528:	75 d5                	jne    c01004ff <stab_binsearch+0x3e>
        }
        if (m < l) {    // no match in [l, m]
c010052a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010052d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100530:	7d 0b                	jge    c010053d <stab_binsearch+0x7c>
            l = true_m + 1;
c0100532:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100535:	83 c0 01             	add    $0x1,%eax
c0100538:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c010053b:	eb 78                	jmp    c01005b5 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
c010053d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c0100544:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100547:	89 d0                	mov    %edx,%eax
c0100549:	01 c0                	add    %eax,%eax
c010054b:	01 d0                	add    %edx,%eax
c010054d:	c1 e0 02             	shl    $0x2,%eax
c0100550:	89 c2                	mov    %eax,%edx
c0100552:	8b 45 08             	mov    0x8(%ebp),%eax
c0100555:	01 d0                	add    %edx,%eax
c0100557:	8b 40 08             	mov    0x8(%eax),%eax
c010055a:	3b 45 18             	cmp    0x18(%ebp),%eax
c010055d:	73 13                	jae    c0100572 <stab_binsearch+0xb1>
            *region_left = m;
c010055f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100562:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100565:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c0100567:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010056a:	83 c0 01             	add    $0x1,%eax
c010056d:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0100570:	eb 43                	jmp    c01005b5 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
c0100572:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100575:	89 d0                	mov    %edx,%eax
c0100577:	01 c0                	add    %eax,%eax
c0100579:	01 d0                	add    %edx,%eax
c010057b:	c1 e0 02             	shl    $0x2,%eax
c010057e:	89 c2                	mov    %eax,%edx
c0100580:	8b 45 08             	mov    0x8(%ebp),%eax
c0100583:	01 d0                	add    %edx,%eax
c0100585:	8b 40 08             	mov    0x8(%eax),%eax
c0100588:	3b 45 18             	cmp    0x18(%ebp),%eax
c010058b:	76 16                	jbe    c01005a3 <stab_binsearch+0xe2>
            *region_right = m - 1;
c010058d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100590:	8d 50 ff             	lea    -0x1(%eax),%edx
c0100593:	8b 45 10             	mov    0x10(%ebp),%eax
c0100596:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c0100598:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010059b:	83 e8 01             	sub    $0x1,%eax
c010059e:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01005a1:	eb 12                	jmp    c01005b5 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c01005a3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005a6:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005a9:	89 10                	mov    %edx,(%eax)
            l = m;
c01005ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01005ae:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c01005b1:	83 45 18 01          	addl   $0x1,0x18(%ebp)
    while (l <= r) {
c01005b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01005b8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01005bb:	0f 8e 22 ff ff ff    	jle    c01004e3 <stab_binsearch+0x22>
        }
    }

    if (!any_matches) {
c01005c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01005c5:	75 0f                	jne    c01005d6 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
c01005c7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005ca:	8b 00                	mov    (%eax),%eax
c01005cc:	8d 50 ff             	lea    -0x1(%eax),%edx
c01005cf:	8b 45 10             	mov    0x10(%ebp),%eax
c01005d2:	89 10                	mov    %edx,(%eax)
c01005d4:	eb 3f                	jmp    c0100615 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
c01005d6:	8b 45 10             	mov    0x10(%ebp),%eax
c01005d9:	8b 00                	mov    (%eax),%eax
c01005db:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c01005de:	eb 04                	jmp    c01005e4 <stab_binsearch+0x123>
c01005e0:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
c01005e4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005e7:	8b 00                	mov    (%eax),%eax
c01005e9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c01005ec:	7d 1f                	jge    c010060d <stab_binsearch+0x14c>
c01005ee:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01005f1:	89 d0                	mov    %edx,%eax
c01005f3:	01 c0                	add    %eax,%eax
c01005f5:	01 d0                	add    %edx,%eax
c01005f7:	c1 e0 02             	shl    $0x2,%eax
c01005fa:	89 c2                	mov    %eax,%edx
c01005fc:	8b 45 08             	mov    0x8(%ebp),%eax
c01005ff:	01 d0                	add    %edx,%eax
c0100601:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100605:	0f b6 c0             	movzbl %al,%eax
c0100608:	3b 45 14             	cmp    0x14(%ebp),%eax
c010060b:	75 d3                	jne    c01005e0 <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
c010060d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100610:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100613:	89 10                	mov    %edx,(%eax)
    }
}
c0100615:	c9                   	leave  
c0100616:	c3                   	ret    

c0100617 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c0100617:	55                   	push   %ebp
c0100618:	89 e5                	mov    %esp,%ebp
c010061a:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c010061d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100620:	c7 00 d8 61 10 c0    	movl   $0xc01061d8,(%eax)
    info->eip_line = 0;
c0100626:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100629:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c0100630:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100633:	c7 40 08 d8 61 10 c0 	movl   $0xc01061d8,0x8(%eax)
    info->eip_fn_namelen = 9;
c010063a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010063d:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c0100644:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100647:	8b 55 08             	mov    0x8(%ebp),%edx
c010064a:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c010064d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100650:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c0100657:	c7 45 f4 20 74 10 c0 	movl   $0xc0107420,-0xc(%ebp)
    stab_end = __STAB_END__;
c010065e:	c7 45 f0 88 20 11 c0 	movl   $0xc0112088,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c0100665:	c7 45 ec 89 20 11 c0 	movl   $0xc0112089,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c010066c:	c7 45 e8 f2 4a 11 c0 	movl   $0xc0114af2,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c0100673:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100676:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0100679:	76 0d                	jbe    c0100688 <debuginfo_eip+0x71>
c010067b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010067e:	83 e8 01             	sub    $0x1,%eax
c0100681:	0f b6 00             	movzbl (%eax),%eax
c0100684:	84 c0                	test   %al,%al
c0100686:	74 0a                	je     c0100692 <debuginfo_eip+0x7b>
        return -1;
c0100688:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010068d:	e9 c0 02 00 00       	jmp    c0100952 <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c0100692:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c0100699:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010069c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010069f:	29 c2                	sub    %eax,%edx
c01006a1:	89 d0                	mov    %edx,%eax
c01006a3:	c1 f8 02             	sar    $0x2,%eax
c01006a6:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01006ac:	83 e8 01             	sub    $0x1,%eax
c01006af:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01006b2:	8b 45 08             	mov    0x8(%ebp),%eax
c01006b5:	89 44 24 10          	mov    %eax,0x10(%esp)
c01006b9:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c01006c0:	00 
c01006c1:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01006c4:	89 44 24 08          	mov    %eax,0x8(%esp)
c01006c8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c01006cb:	89 44 24 04          	mov    %eax,0x4(%esp)
c01006cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006d2:	89 04 24             	mov    %eax,(%esp)
c01006d5:	e8 e7 fd ff ff       	call   c01004c1 <stab_binsearch>
    if (lfile == 0)
c01006da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006dd:	85 c0                	test   %eax,%eax
c01006df:	75 0a                	jne    c01006eb <debuginfo_eip+0xd4>
        return -1;
c01006e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01006e6:	e9 67 02 00 00       	jmp    c0100952 <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c01006eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006ee:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01006f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006f4:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c01006f7:	8b 45 08             	mov    0x8(%ebp),%eax
c01006fa:	89 44 24 10          	mov    %eax,0x10(%esp)
c01006fe:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c0100705:	00 
c0100706:	8d 45 d8             	lea    -0x28(%ebp),%eax
c0100709:	89 44 24 08          	mov    %eax,0x8(%esp)
c010070d:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100710:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100714:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100717:	89 04 24             	mov    %eax,(%esp)
c010071a:	e8 a2 fd ff ff       	call   c01004c1 <stab_binsearch>

    if (lfun <= rfun) {
c010071f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100722:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100725:	39 c2                	cmp    %eax,%edx
c0100727:	7f 7c                	jg     c01007a5 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c0100729:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010072c:	89 c2                	mov    %eax,%edx
c010072e:	89 d0                	mov    %edx,%eax
c0100730:	01 c0                	add    %eax,%eax
c0100732:	01 d0                	add    %edx,%eax
c0100734:	c1 e0 02             	shl    $0x2,%eax
c0100737:	89 c2                	mov    %eax,%edx
c0100739:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010073c:	01 d0                	add    %edx,%eax
c010073e:	8b 10                	mov    (%eax),%edx
c0100740:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c0100743:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100746:	29 c1                	sub    %eax,%ecx
c0100748:	89 c8                	mov    %ecx,%eax
c010074a:	39 c2                	cmp    %eax,%edx
c010074c:	73 22                	jae    c0100770 <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c010074e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100751:	89 c2                	mov    %eax,%edx
c0100753:	89 d0                	mov    %edx,%eax
c0100755:	01 c0                	add    %eax,%eax
c0100757:	01 d0                	add    %edx,%eax
c0100759:	c1 e0 02             	shl    $0x2,%eax
c010075c:	89 c2                	mov    %eax,%edx
c010075e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100761:	01 d0                	add    %edx,%eax
c0100763:	8b 10                	mov    (%eax),%edx
c0100765:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100768:	01 c2                	add    %eax,%edx
c010076a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010076d:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c0100770:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100773:	89 c2                	mov    %eax,%edx
c0100775:	89 d0                	mov    %edx,%eax
c0100777:	01 c0                	add    %eax,%eax
c0100779:	01 d0                	add    %edx,%eax
c010077b:	c1 e0 02             	shl    $0x2,%eax
c010077e:	89 c2                	mov    %eax,%edx
c0100780:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100783:	01 d0                	add    %edx,%eax
c0100785:	8b 50 08             	mov    0x8(%eax),%edx
c0100788:	8b 45 0c             	mov    0xc(%ebp),%eax
c010078b:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c010078e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100791:	8b 40 10             	mov    0x10(%eax),%eax
c0100794:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c0100797:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010079a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c010079d:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01007a0:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01007a3:	eb 15                	jmp    c01007ba <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c01007a5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007a8:	8b 55 08             	mov    0x8(%ebp),%edx
c01007ab:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c01007ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007b1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c01007b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01007b7:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01007ba:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007bd:	8b 40 08             	mov    0x8(%eax),%eax
c01007c0:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c01007c7:	00 
c01007c8:	89 04 24             	mov    %eax,(%esp)
c01007cb:	e8 64 4f 00 00       	call   c0105734 <strfind>
c01007d0:	89 c2                	mov    %eax,%edx
c01007d2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007d5:	8b 40 08             	mov    0x8(%eax),%eax
c01007d8:	29 c2                	sub    %eax,%edx
c01007da:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007dd:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c01007e0:	8b 45 08             	mov    0x8(%ebp),%eax
c01007e3:	89 44 24 10          	mov    %eax,0x10(%esp)
c01007e7:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c01007ee:	00 
c01007ef:	8d 45 d0             	lea    -0x30(%ebp),%eax
c01007f2:	89 44 24 08          	mov    %eax,0x8(%esp)
c01007f6:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c01007f9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01007fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100800:	89 04 24             	mov    %eax,(%esp)
c0100803:	e8 b9 fc ff ff       	call   c01004c1 <stab_binsearch>
    if (lline <= rline) {
c0100808:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010080b:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010080e:	39 c2                	cmp    %eax,%edx
c0100810:	7f 24                	jg     c0100836 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
c0100812:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100815:	89 c2                	mov    %eax,%edx
c0100817:	89 d0                	mov    %edx,%eax
c0100819:	01 c0                	add    %eax,%eax
c010081b:	01 d0                	add    %edx,%eax
c010081d:	c1 e0 02             	shl    $0x2,%eax
c0100820:	89 c2                	mov    %eax,%edx
c0100822:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100825:	01 d0                	add    %edx,%eax
c0100827:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c010082b:	0f b7 d0             	movzwl %ax,%edx
c010082e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100831:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100834:	eb 13                	jmp    c0100849 <debuginfo_eip+0x232>
        return -1;
c0100836:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010083b:	e9 12 01 00 00       	jmp    c0100952 <debuginfo_eip+0x33b>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c0100840:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100843:	83 e8 01             	sub    $0x1,%eax
c0100846:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
c0100849:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010084c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010084f:	39 c2                	cmp    %eax,%edx
c0100851:	7c 56                	jl     c01008a9 <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
c0100853:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100856:	89 c2                	mov    %eax,%edx
c0100858:	89 d0                	mov    %edx,%eax
c010085a:	01 c0                	add    %eax,%eax
c010085c:	01 d0                	add    %edx,%eax
c010085e:	c1 e0 02             	shl    $0x2,%eax
c0100861:	89 c2                	mov    %eax,%edx
c0100863:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100866:	01 d0                	add    %edx,%eax
c0100868:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010086c:	3c 84                	cmp    $0x84,%al
c010086e:	74 39                	je     c01008a9 <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c0100870:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100873:	89 c2                	mov    %eax,%edx
c0100875:	89 d0                	mov    %edx,%eax
c0100877:	01 c0                	add    %eax,%eax
c0100879:	01 d0                	add    %edx,%eax
c010087b:	c1 e0 02             	shl    $0x2,%eax
c010087e:	89 c2                	mov    %eax,%edx
c0100880:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100883:	01 d0                	add    %edx,%eax
c0100885:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100889:	3c 64                	cmp    $0x64,%al
c010088b:	75 b3                	jne    c0100840 <debuginfo_eip+0x229>
c010088d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100890:	89 c2                	mov    %eax,%edx
c0100892:	89 d0                	mov    %edx,%eax
c0100894:	01 c0                	add    %eax,%eax
c0100896:	01 d0                	add    %edx,%eax
c0100898:	c1 e0 02             	shl    $0x2,%eax
c010089b:	89 c2                	mov    %eax,%edx
c010089d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008a0:	01 d0                	add    %edx,%eax
c01008a2:	8b 40 08             	mov    0x8(%eax),%eax
c01008a5:	85 c0                	test   %eax,%eax
c01008a7:	74 97                	je     c0100840 <debuginfo_eip+0x229>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c01008a9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01008ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01008af:	39 c2                	cmp    %eax,%edx
c01008b1:	7c 46                	jl     c01008f9 <debuginfo_eip+0x2e2>
c01008b3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01008b6:	89 c2                	mov    %eax,%edx
c01008b8:	89 d0                	mov    %edx,%eax
c01008ba:	01 c0                	add    %eax,%eax
c01008bc:	01 d0                	add    %edx,%eax
c01008be:	c1 e0 02             	shl    $0x2,%eax
c01008c1:	89 c2                	mov    %eax,%edx
c01008c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008c6:	01 d0                	add    %edx,%eax
c01008c8:	8b 10                	mov    (%eax),%edx
c01008ca:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c01008cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01008d0:	29 c1                	sub    %eax,%ecx
c01008d2:	89 c8                	mov    %ecx,%eax
c01008d4:	39 c2                	cmp    %eax,%edx
c01008d6:	73 21                	jae    c01008f9 <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
c01008d8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01008db:	89 c2                	mov    %eax,%edx
c01008dd:	89 d0                	mov    %edx,%eax
c01008df:	01 c0                	add    %eax,%eax
c01008e1:	01 d0                	add    %edx,%eax
c01008e3:	c1 e0 02             	shl    $0x2,%eax
c01008e6:	89 c2                	mov    %eax,%edx
c01008e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008eb:	01 d0                	add    %edx,%eax
c01008ed:	8b 10                	mov    (%eax),%edx
c01008ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01008f2:	01 c2                	add    %eax,%edx
c01008f4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01008f7:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c01008f9:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01008fc:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01008ff:	39 c2                	cmp    %eax,%edx
c0100901:	7d 4a                	jge    c010094d <debuginfo_eip+0x336>
        for (lline = lfun + 1;
c0100903:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100906:	83 c0 01             	add    $0x1,%eax
c0100909:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c010090c:	eb 18                	jmp    c0100926 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c010090e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100911:	8b 40 14             	mov    0x14(%eax),%eax
c0100914:	8d 50 01             	lea    0x1(%eax),%edx
c0100917:	8b 45 0c             	mov    0xc(%ebp),%eax
c010091a:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
c010091d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100920:	83 c0 01             	add    $0x1,%eax
c0100923:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100926:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100929:	8b 45 d8             	mov    -0x28(%ebp),%eax
        for (lline = lfun + 1;
c010092c:	39 c2                	cmp    %eax,%edx
c010092e:	7d 1d                	jge    c010094d <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100930:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100933:	89 c2                	mov    %eax,%edx
c0100935:	89 d0                	mov    %edx,%eax
c0100937:	01 c0                	add    %eax,%eax
c0100939:	01 d0                	add    %edx,%eax
c010093b:	c1 e0 02             	shl    $0x2,%eax
c010093e:	89 c2                	mov    %eax,%edx
c0100940:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100943:	01 d0                	add    %edx,%eax
c0100945:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100949:	3c a0                	cmp    $0xa0,%al
c010094b:	74 c1                	je     c010090e <debuginfo_eip+0x2f7>
        }
    }
    return 0;
c010094d:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100952:	c9                   	leave  
c0100953:	c3                   	ret    

c0100954 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c0100954:	55                   	push   %ebp
c0100955:	89 e5                	mov    %esp,%ebp
c0100957:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c010095a:	c7 04 24 e2 61 10 c0 	movl   $0xc01061e2,(%esp)
c0100961:	e8 37 f9 ff ff       	call   c010029d <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c0100966:	c7 44 24 04 36 00 10 	movl   $0xc0100036,0x4(%esp)
c010096d:	c0 
c010096e:	c7 04 24 fb 61 10 c0 	movl   $0xc01061fb,(%esp)
c0100975:	e8 23 f9 ff ff       	call   c010029d <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c010097a:	c7 44 24 04 ca 60 10 	movl   $0xc01060ca,0x4(%esp)
c0100981:	c0 
c0100982:	c7 04 24 13 62 10 c0 	movl   $0xc0106213,(%esp)
c0100989:	e8 0f f9 ff ff       	call   c010029d <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c010098e:	c7 44 24 04 00 a0 11 	movl   $0xc011a000,0x4(%esp)
c0100995:	c0 
c0100996:	c7 04 24 2b 62 10 c0 	movl   $0xc010622b,(%esp)
c010099d:	e8 fb f8 ff ff       	call   c010029d <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c01009a2:	c7 44 24 04 88 af 11 	movl   $0xc011af88,0x4(%esp)
c01009a9:	c0 
c01009aa:	c7 04 24 43 62 10 c0 	movl   $0xc0106243,(%esp)
c01009b1:	e8 e7 f8 ff ff       	call   c010029d <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01009b6:	b8 88 af 11 c0       	mov    $0xc011af88,%eax
c01009bb:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01009c1:	b8 36 00 10 c0       	mov    $0xc0100036,%eax
c01009c6:	29 c2                	sub    %eax,%edx
c01009c8:	89 d0                	mov    %edx,%eax
c01009ca:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01009d0:	85 c0                	test   %eax,%eax
c01009d2:	0f 48 c2             	cmovs  %edx,%eax
c01009d5:	c1 f8 0a             	sar    $0xa,%eax
c01009d8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009dc:	c7 04 24 5c 62 10 c0 	movl   $0xc010625c,(%esp)
c01009e3:	e8 b5 f8 ff ff       	call   c010029d <cprintf>
}
c01009e8:	c9                   	leave  
c01009e9:	c3                   	ret    

c01009ea <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c01009ea:	55                   	push   %ebp
c01009eb:	89 e5                	mov    %esp,%ebp
c01009ed:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c01009f3:	8d 45 dc             	lea    -0x24(%ebp),%eax
c01009f6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009fa:	8b 45 08             	mov    0x8(%ebp),%eax
c01009fd:	89 04 24             	mov    %eax,(%esp)
c0100a00:	e8 12 fc ff ff       	call   c0100617 <debuginfo_eip>
c0100a05:	85 c0                	test   %eax,%eax
c0100a07:	74 15                	je     c0100a1e <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c0100a09:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a0c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a10:	c7 04 24 86 62 10 c0 	movl   $0xc0106286,(%esp)
c0100a17:	e8 81 f8 ff ff       	call   c010029d <cprintf>
c0100a1c:	eb 6d                	jmp    c0100a8b <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100a1e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100a25:	eb 1c                	jmp    c0100a43 <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
c0100a27:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0100a2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a2d:	01 d0                	add    %edx,%eax
c0100a2f:	0f b6 00             	movzbl (%eax),%eax
c0100a32:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100a38:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100a3b:	01 ca                	add    %ecx,%edx
c0100a3d:	88 02                	mov    %al,(%edx)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100a3f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100a43:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a46:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0100a49:	7f dc                	jg     c0100a27 <print_debuginfo+0x3d>
        }
        fnname[j] = '\0';
c0100a4b:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c0100a51:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a54:	01 d0                	add    %edx,%eax
c0100a56:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
c0100a59:	8b 45 ec             	mov    -0x14(%ebp),%eax
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100a5c:	8b 55 08             	mov    0x8(%ebp),%edx
c0100a5f:	89 d1                	mov    %edx,%ecx
c0100a61:	29 c1                	sub    %eax,%ecx
c0100a63:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100a66:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100a69:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0100a6d:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100a73:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0100a77:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100a7b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a7f:	c7 04 24 a2 62 10 c0 	movl   $0xc01062a2,(%esp)
c0100a86:	e8 12 f8 ff ff       	call   c010029d <cprintf>
    }
}
c0100a8b:	c9                   	leave  
c0100a8c:	c3                   	ret    

c0100a8d <read_eip>:

static __noinline uint32_t
read_eip(void) {
c0100a8d:	55                   	push   %ebp
c0100a8e:	89 e5                	mov    %esp,%ebp
c0100a90:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c0100a93:	8b 45 04             	mov    0x4(%ebp),%eax
c0100a96:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c0100a99:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0100a9c:	c9                   	leave  
c0100a9d:	c3                   	ret    

c0100a9e <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c0100a9e:	55                   	push   %ebp
c0100a9f:	89 e5                	mov    %esp,%ebp
c0100aa1:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c0100aa4:	89 e8                	mov    %ebp,%eax
c0100aa6:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
c0100aa9:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */

	uint32_t ebp_v = read_ebp(), eip_v = read_eip();
c0100aac:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100aaf:	e8 d9 ff ff ff       	call   c0100a8d <read_eip>
c0100ab4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32_t i, j;
	for (i = 0; ebp_v != 0 && i< STACKFRAME_DEPTH; i ++)
c0100ab7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0100abe:	e9 88 00 00 00       	jmp    c0100b4b <print_stackframe+0xad>
	{
		cprintf("ebp:0x%08x eip:0x%08x args:", ebp_v, eip_v);
c0100ac3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100ac6:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100aca:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100acd:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100ad1:	c7 04 24 b4 62 10 c0 	movl   $0xc01062b4,(%esp)
c0100ad8:	e8 c0 f7 ff ff       	call   c010029d <cprintf>
		uint32_t *args = (uint32_t *)ebp_v + 0x2;
c0100add:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ae0:	83 c0 08             	add    $0x8,%eax
c0100ae3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		for (j = 0; j < 4; j ++)
c0100ae6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0100aed:	eb 25                	jmp    c0100b14 <print_stackframe+0x76>
		{
			cprintf(" 0x%08x ", args[j]);
c0100aef:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100af2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100af9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100afc:	01 d0                	add    %edx,%eax
c0100afe:	8b 00                	mov    (%eax),%eax
c0100b00:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b04:	c7 04 24 d0 62 10 c0 	movl   $0xc01062d0,(%esp)
c0100b0b:	e8 8d f7 ff ff       	call   c010029d <cprintf>
		for (j = 0; j < 4; j ++)
c0100b10:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
c0100b14:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
c0100b18:	76 d5                	jbe    c0100aef <print_stackframe+0x51>
		}
		cprintf("\n");
c0100b1a:	c7 04 24 d9 62 10 c0 	movl   $0xc01062d9,(%esp)
c0100b21:	e8 77 f7 ff ff       	call   c010029d <cprintf>
		print_debuginfo(eip_v-0x1);
c0100b26:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100b29:	83 e8 01             	sub    $0x1,%eax
c0100b2c:	89 04 24             	mov    %eax,(%esp)
c0100b2f:	e8 b6 fe ff ff       	call   c01009ea <print_debuginfo>
		eip_v = ((uint32_t*)ebp_v)[1];
c0100b34:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b37:	83 c0 04             	add    $0x4,%eax
c0100b3a:	8b 00                	mov    (%eax),%eax
c0100b3c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		ebp_v = ((uint32_t*)ebp_v)[0];
c0100b3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b42:	8b 00                	mov    (%eax),%eax
c0100b44:	89 45 f4             	mov    %eax,-0xc(%ebp)
	for (i = 0; ebp_v != 0 && i< STACKFRAME_DEPTH; i ++)
c0100b47:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0100b4b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100b4f:	74 0a                	je     c0100b5b <print_stackframe+0xbd>
c0100b51:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100b55:	0f 86 68 ff ff ff    	jbe    c0100ac3 <print_stackframe+0x25>
	}

}
c0100b5b:	c9                   	leave  
c0100b5c:	c3                   	ret    

c0100b5d <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100b5d:	55                   	push   %ebp
c0100b5e:	89 e5                	mov    %esp,%ebp
c0100b60:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100b63:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b6a:	eb 0c                	jmp    c0100b78 <parse+0x1b>
            *buf ++ = '\0';
c0100b6c:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b6f:	8d 50 01             	lea    0x1(%eax),%edx
c0100b72:	89 55 08             	mov    %edx,0x8(%ebp)
c0100b75:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b78:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b7b:	0f b6 00             	movzbl (%eax),%eax
c0100b7e:	84 c0                	test   %al,%al
c0100b80:	74 1d                	je     c0100b9f <parse+0x42>
c0100b82:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b85:	0f b6 00             	movzbl (%eax),%eax
c0100b88:	0f be c0             	movsbl %al,%eax
c0100b8b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b8f:	c7 04 24 5c 63 10 c0 	movl   $0xc010635c,(%esp)
c0100b96:	e8 66 4b 00 00       	call   c0105701 <strchr>
c0100b9b:	85 c0                	test   %eax,%eax
c0100b9d:	75 cd                	jne    c0100b6c <parse+0xf>
        }
        if (*buf == '\0') {
c0100b9f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ba2:	0f b6 00             	movzbl (%eax),%eax
c0100ba5:	84 c0                	test   %al,%al
c0100ba7:	75 02                	jne    c0100bab <parse+0x4e>
            break;
c0100ba9:	eb 67                	jmp    c0100c12 <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100bab:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100baf:	75 14                	jne    c0100bc5 <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100bb1:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100bb8:	00 
c0100bb9:	c7 04 24 61 63 10 c0 	movl   $0xc0106361,(%esp)
c0100bc0:	e8 d8 f6 ff ff       	call   c010029d <cprintf>
        }
        argv[argc ++] = buf;
c0100bc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100bc8:	8d 50 01             	lea    0x1(%eax),%edx
c0100bcb:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100bce:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100bd5:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100bd8:	01 c2                	add    %eax,%edx
c0100bda:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bdd:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100bdf:	eb 04                	jmp    c0100be5 <parse+0x88>
            buf ++;
c0100be1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100be5:	8b 45 08             	mov    0x8(%ebp),%eax
c0100be8:	0f b6 00             	movzbl (%eax),%eax
c0100beb:	84 c0                	test   %al,%al
c0100bed:	74 1d                	je     c0100c0c <parse+0xaf>
c0100bef:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bf2:	0f b6 00             	movzbl (%eax),%eax
c0100bf5:	0f be c0             	movsbl %al,%eax
c0100bf8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100bfc:	c7 04 24 5c 63 10 c0 	movl   $0xc010635c,(%esp)
c0100c03:	e8 f9 4a 00 00       	call   c0105701 <strchr>
c0100c08:	85 c0                	test   %eax,%eax
c0100c0a:	74 d5                	je     c0100be1 <parse+0x84>
        }
    }
c0100c0c:	90                   	nop
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100c0d:	e9 66 ff ff ff       	jmp    c0100b78 <parse+0x1b>
    return argc;
c0100c12:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100c15:	c9                   	leave  
c0100c16:	c3                   	ret    

c0100c17 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100c17:	55                   	push   %ebp
c0100c18:	89 e5                	mov    %esp,%ebp
c0100c1a:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100c1d:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100c20:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c24:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c27:	89 04 24             	mov    %eax,(%esp)
c0100c2a:	e8 2e ff ff ff       	call   c0100b5d <parse>
c0100c2f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100c32:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100c36:	75 0a                	jne    c0100c42 <runcmd+0x2b>
        return 0;
c0100c38:	b8 00 00 00 00       	mov    $0x0,%eax
c0100c3d:	e9 85 00 00 00       	jmp    c0100cc7 <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c42:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c49:	eb 5c                	jmp    c0100ca7 <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100c4b:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100c4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c51:	89 d0                	mov    %edx,%eax
c0100c53:	01 c0                	add    %eax,%eax
c0100c55:	01 d0                	add    %edx,%eax
c0100c57:	c1 e0 02             	shl    $0x2,%eax
c0100c5a:	05 00 70 11 c0       	add    $0xc0117000,%eax
c0100c5f:	8b 00                	mov    (%eax),%eax
c0100c61:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0100c65:	89 04 24             	mov    %eax,(%esp)
c0100c68:	e8 f5 49 00 00       	call   c0105662 <strcmp>
c0100c6d:	85 c0                	test   %eax,%eax
c0100c6f:	75 32                	jne    c0100ca3 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100c71:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c74:	89 d0                	mov    %edx,%eax
c0100c76:	01 c0                	add    %eax,%eax
c0100c78:	01 d0                	add    %edx,%eax
c0100c7a:	c1 e0 02             	shl    $0x2,%eax
c0100c7d:	05 00 70 11 c0       	add    $0xc0117000,%eax
c0100c82:	8b 40 08             	mov    0x8(%eax),%eax
c0100c85:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100c88:	8d 4a ff             	lea    -0x1(%edx),%ecx
c0100c8b:	8b 55 0c             	mov    0xc(%ebp),%edx
c0100c8e:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100c92:	8d 55 b0             	lea    -0x50(%ebp),%edx
c0100c95:	83 c2 04             	add    $0x4,%edx
c0100c98:	89 54 24 04          	mov    %edx,0x4(%esp)
c0100c9c:	89 0c 24             	mov    %ecx,(%esp)
c0100c9f:	ff d0                	call   *%eax
c0100ca1:	eb 24                	jmp    c0100cc7 <runcmd+0xb0>
    for (i = 0; i < NCOMMANDS; i ++) {
c0100ca3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100ca7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100caa:	83 f8 02             	cmp    $0x2,%eax
c0100cad:	76 9c                	jbe    c0100c4b <runcmd+0x34>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100caf:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100cb2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100cb6:	c7 04 24 7f 63 10 c0 	movl   $0xc010637f,(%esp)
c0100cbd:	e8 db f5 ff ff       	call   c010029d <cprintf>
    return 0;
c0100cc2:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cc7:	c9                   	leave  
c0100cc8:	c3                   	ret    

c0100cc9 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100cc9:	55                   	push   %ebp
c0100cca:	89 e5                	mov    %esp,%ebp
c0100ccc:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100ccf:	c7 04 24 98 63 10 c0 	movl   $0xc0106398,(%esp)
c0100cd6:	e8 c2 f5 ff ff       	call   c010029d <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100cdb:	c7 04 24 c0 63 10 c0 	movl   $0xc01063c0,(%esp)
c0100ce2:	e8 b6 f5 ff ff       	call   c010029d <cprintf>

    if (tf != NULL) {
c0100ce7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100ceb:	74 0b                	je     c0100cf8 <kmonitor+0x2f>
        print_trapframe(tf);
c0100ced:	8b 45 08             	mov    0x8(%ebp),%eax
c0100cf0:	89 04 24             	mov    %eax,(%esp)
c0100cf3:	e8 99 0d 00 00       	call   c0101a91 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100cf8:	c7 04 24 e5 63 10 c0 	movl   $0xc01063e5,(%esp)
c0100cff:	e8 3a f6 ff ff       	call   c010033e <readline>
c0100d04:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100d07:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100d0b:	74 18                	je     c0100d25 <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
c0100d0d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d10:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d14:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d17:	89 04 24             	mov    %eax,(%esp)
c0100d1a:	e8 f8 fe ff ff       	call   c0100c17 <runcmd>
c0100d1f:	85 c0                	test   %eax,%eax
c0100d21:	79 02                	jns    c0100d25 <kmonitor+0x5c>
                break;
c0100d23:	eb 02                	jmp    c0100d27 <kmonitor+0x5e>
            }
        }
    }
c0100d25:	eb d1                	jmp    c0100cf8 <kmonitor+0x2f>
}
c0100d27:	c9                   	leave  
c0100d28:	c3                   	ret    

c0100d29 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100d29:	55                   	push   %ebp
c0100d2a:	89 e5                	mov    %esp,%ebp
c0100d2c:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100d2f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100d36:	eb 3f                	jmp    c0100d77 <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100d38:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100d3b:	89 d0                	mov    %edx,%eax
c0100d3d:	01 c0                	add    %eax,%eax
c0100d3f:	01 d0                	add    %edx,%eax
c0100d41:	c1 e0 02             	shl    $0x2,%eax
c0100d44:	05 00 70 11 c0       	add    $0xc0117000,%eax
c0100d49:	8b 48 04             	mov    0x4(%eax),%ecx
c0100d4c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100d4f:	89 d0                	mov    %edx,%eax
c0100d51:	01 c0                	add    %eax,%eax
c0100d53:	01 d0                	add    %edx,%eax
c0100d55:	c1 e0 02             	shl    $0x2,%eax
c0100d58:	05 00 70 11 c0       	add    $0xc0117000,%eax
c0100d5d:	8b 00                	mov    (%eax),%eax
c0100d5f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100d63:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d67:	c7 04 24 e9 63 10 c0 	movl   $0xc01063e9,(%esp)
c0100d6e:	e8 2a f5 ff ff       	call   c010029d <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
c0100d73:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100d77:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d7a:	83 f8 02             	cmp    $0x2,%eax
c0100d7d:	76 b9                	jbe    c0100d38 <mon_help+0xf>
    }
    return 0;
c0100d7f:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100d84:	c9                   	leave  
c0100d85:	c3                   	ret    

c0100d86 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100d86:	55                   	push   %ebp
c0100d87:	89 e5                	mov    %esp,%ebp
c0100d89:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100d8c:	e8 c3 fb ff ff       	call   c0100954 <print_kerninfo>
    return 0;
c0100d91:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100d96:	c9                   	leave  
c0100d97:	c3                   	ret    

c0100d98 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100d98:	55                   	push   %ebp
c0100d99:	89 e5                	mov    %esp,%ebp
c0100d9b:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100d9e:	e8 fb fc ff ff       	call   c0100a9e <print_stackframe>
    return 0;
c0100da3:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100da8:	c9                   	leave  
c0100da9:	c3                   	ret    

c0100daa <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100daa:	55                   	push   %ebp
c0100dab:	89 e5                	mov    %esp,%ebp
c0100dad:	83 ec 28             	sub    $0x28,%esp
c0100db0:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
c0100db6:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100dba:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100dbe:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100dc2:	ee                   	out    %al,(%dx)
c0100dc3:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100dc9:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
c0100dcd:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100dd1:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100dd5:	ee                   	out    %al,(%dx)
c0100dd6:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
c0100ddc:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
c0100de0:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100de4:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100de8:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100de9:	c7 05 0c af 11 c0 00 	movl   $0x0,0xc011af0c
c0100df0:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100df3:	c7 04 24 f2 63 10 c0 	movl   $0xc01063f2,(%esp)
c0100dfa:	e8 9e f4 ff ff       	call   c010029d <cprintf>
    pic_enable(IRQ_TIMER);
c0100dff:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100e06:	e8 18 09 00 00       	call   c0101723 <pic_enable>
}
c0100e0b:	c9                   	leave  
c0100e0c:	c3                   	ret    

c0100e0d <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100e0d:	55                   	push   %ebp
c0100e0e:	89 e5                	mov    %esp,%ebp
c0100e10:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100e13:	9c                   	pushf  
c0100e14:	58                   	pop    %eax
c0100e15:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100e18:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100e1b:	25 00 02 00 00       	and    $0x200,%eax
c0100e20:	85 c0                	test   %eax,%eax
c0100e22:	74 0c                	je     c0100e30 <__intr_save+0x23>
        intr_disable();
c0100e24:	e8 69 0a 00 00       	call   c0101892 <intr_disable>
        return 1;
c0100e29:	b8 01 00 00 00       	mov    $0x1,%eax
c0100e2e:	eb 05                	jmp    c0100e35 <__intr_save+0x28>
    }
    return 0;
c0100e30:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100e35:	c9                   	leave  
c0100e36:	c3                   	ret    

c0100e37 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100e37:	55                   	push   %ebp
c0100e38:	89 e5                	mov    %esp,%ebp
c0100e3a:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100e3d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100e41:	74 05                	je     c0100e48 <__intr_restore+0x11>
        intr_enable();
c0100e43:	e8 44 0a 00 00       	call   c010188c <intr_enable>
    }
}
c0100e48:	c9                   	leave  
c0100e49:	c3                   	ret    

c0100e4a <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100e4a:	55                   	push   %ebp
c0100e4b:	89 e5                	mov    %esp,%ebp
c0100e4d:	83 ec 10             	sub    $0x10,%esp
c0100e50:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e56:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100e5a:	89 c2                	mov    %eax,%edx
c0100e5c:	ec                   	in     (%dx),%al
c0100e5d:	88 45 fd             	mov    %al,-0x3(%ebp)
c0100e60:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100e66:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100e6a:	89 c2                	mov    %eax,%edx
c0100e6c:	ec                   	in     (%dx),%al
c0100e6d:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100e70:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100e76:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100e7a:	89 c2                	mov    %eax,%edx
c0100e7c:	ec                   	in     (%dx),%al
c0100e7d:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100e80:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
c0100e86:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100e8a:	89 c2                	mov    %eax,%edx
c0100e8c:	ec                   	in     (%dx),%al
c0100e8d:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100e90:	c9                   	leave  
c0100e91:	c3                   	ret    

c0100e92 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100e92:	55                   	push   %ebp
c0100e93:	89 e5                	mov    %esp,%ebp
c0100e95:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100e98:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100e9f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ea2:	0f b7 00             	movzwl (%eax),%eax
c0100ea5:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100ea9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100eac:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100eb1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100eb4:	0f b7 00             	movzwl (%eax),%eax
c0100eb7:	66 3d 5a a5          	cmp    $0xa55a,%ax
c0100ebb:	74 12                	je     c0100ecf <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100ebd:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100ec4:	66 c7 05 46 a4 11 c0 	movw   $0x3b4,0xc011a446
c0100ecb:	b4 03 
c0100ecd:	eb 13                	jmp    c0100ee2 <cga_init+0x50>
    } else {
        *cp = was;
c0100ecf:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100ed2:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100ed6:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100ed9:	66 c7 05 46 a4 11 c0 	movw   $0x3d4,0xc011a446
c0100ee0:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100ee2:	0f b7 05 46 a4 11 c0 	movzwl 0xc011a446,%eax
c0100ee9:	0f b7 c0             	movzwl %ax,%eax
c0100eec:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0100ef0:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100ef4:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100ef8:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100efc:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c0100efd:	0f b7 05 46 a4 11 c0 	movzwl 0xc011a446,%eax
c0100f04:	83 c0 01             	add    $0x1,%eax
c0100f07:	0f b7 c0             	movzwl %ax,%eax
c0100f0a:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f0e:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0100f12:	89 c2                	mov    %eax,%edx
c0100f14:	ec                   	in     (%dx),%al
c0100f15:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0100f18:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f1c:	0f b6 c0             	movzbl %al,%eax
c0100f1f:	c1 e0 08             	shl    $0x8,%eax
c0100f22:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100f25:	0f b7 05 46 a4 11 c0 	movzwl 0xc011a446,%eax
c0100f2c:	0f b7 c0             	movzwl %ax,%eax
c0100f2f:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c0100f33:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f37:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100f3b:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100f3f:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c0100f40:	0f b7 05 46 a4 11 c0 	movzwl 0xc011a446,%eax
c0100f47:	83 c0 01             	add    $0x1,%eax
c0100f4a:	0f b7 c0             	movzwl %ax,%eax
c0100f4d:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f51:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c0100f55:	89 c2                	mov    %eax,%edx
c0100f57:	ec                   	in     (%dx),%al
c0100f58:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
c0100f5b:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100f5f:	0f b6 c0             	movzbl %al,%eax
c0100f62:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100f65:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f68:	a3 40 a4 11 c0       	mov    %eax,0xc011a440
    crt_pos = pos;
c0100f6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100f70:	66 a3 44 a4 11 c0    	mov    %ax,0xc011a444
}
c0100f76:	c9                   	leave  
c0100f77:	c3                   	ret    

c0100f78 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100f78:	55                   	push   %ebp
c0100f79:	89 e5                	mov    %esp,%ebp
c0100f7b:	83 ec 48             	sub    $0x48,%esp
c0100f7e:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
c0100f84:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f88:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100f8c:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100f90:	ee                   	out    %al,(%dx)
c0100f91:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
c0100f97:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
c0100f9b:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100f9f:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100fa3:	ee                   	out    %al,(%dx)
c0100fa4:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
c0100faa:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
c0100fae:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100fb2:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100fb6:	ee                   	out    %al,(%dx)
c0100fb7:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0100fbd:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
c0100fc1:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100fc5:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100fc9:	ee                   	out    %al,(%dx)
c0100fca:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
c0100fd0:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
c0100fd4:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100fd8:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100fdc:	ee                   	out    %al,(%dx)
c0100fdd:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
c0100fe3:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
c0100fe7:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0100feb:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0100fef:	ee                   	out    %al,(%dx)
c0100ff0:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c0100ff6:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
c0100ffa:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0100ffe:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101002:	ee                   	out    %al,(%dx)
c0101003:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101009:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
c010100d:	89 c2                	mov    %eax,%edx
c010100f:	ec                   	in     (%dx),%al
c0101010:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
c0101013:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0101017:	3c ff                	cmp    $0xff,%al
c0101019:	0f 95 c0             	setne  %al
c010101c:	0f b6 c0             	movzbl %al,%eax
c010101f:	a3 48 a4 11 c0       	mov    %eax,0xc011a448
c0101024:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010102a:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
c010102e:	89 c2                	mov    %eax,%edx
c0101030:	ec                   	in     (%dx),%al
c0101031:	88 45 d5             	mov    %al,-0x2b(%ebp)
c0101034:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
c010103a:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
c010103e:	89 c2                	mov    %eax,%edx
c0101040:	ec                   	in     (%dx),%al
c0101041:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c0101044:	a1 48 a4 11 c0       	mov    0xc011a448,%eax
c0101049:	85 c0                	test   %eax,%eax
c010104b:	74 0c                	je     c0101059 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
c010104d:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0101054:	e8 ca 06 00 00       	call   c0101723 <pic_enable>
    }
}
c0101059:	c9                   	leave  
c010105a:	c3                   	ret    

c010105b <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c010105b:	55                   	push   %ebp
c010105c:	89 e5                	mov    %esp,%ebp
c010105e:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101061:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101068:	eb 09                	jmp    c0101073 <lpt_putc_sub+0x18>
        delay();
c010106a:	e8 db fd ff ff       	call   c0100e4a <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c010106f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101073:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c0101079:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c010107d:	89 c2                	mov    %eax,%edx
c010107f:	ec                   	in     (%dx),%al
c0101080:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0101083:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101087:	84 c0                	test   %al,%al
c0101089:	78 09                	js     c0101094 <lpt_putc_sub+0x39>
c010108b:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101092:	7e d6                	jle    c010106a <lpt_putc_sub+0xf>
    }
    outb(LPTPORT + 0, c);
c0101094:	8b 45 08             	mov    0x8(%ebp),%eax
c0101097:	0f b6 c0             	movzbl %al,%eax
c010109a:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
c01010a0:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01010a3:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c01010a7:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c01010ab:	ee                   	out    %al,(%dx)
c01010ac:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c01010b2:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
c01010b6:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01010ba:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01010be:	ee                   	out    %al,(%dx)
c01010bf:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
c01010c5:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
c01010c9:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01010cd:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01010d1:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c01010d2:	c9                   	leave  
c01010d3:	c3                   	ret    

c01010d4 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c01010d4:	55                   	push   %ebp
c01010d5:	89 e5                	mov    %esp,%ebp
c01010d7:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c01010da:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01010de:	74 0d                	je     c01010ed <lpt_putc+0x19>
        lpt_putc_sub(c);
c01010e0:	8b 45 08             	mov    0x8(%ebp),%eax
c01010e3:	89 04 24             	mov    %eax,(%esp)
c01010e6:	e8 70 ff ff ff       	call   c010105b <lpt_putc_sub>
c01010eb:	eb 24                	jmp    c0101111 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
c01010ed:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010f4:	e8 62 ff ff ff       	call   c010105b <lpt_putc_sub>
        lpt_putc_sub(' ');
c01010f9:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0101100:	e8 56 ff ff ff       	call   c010105b <lpt_putc_sub>
        lpt_putc_sub('\b');
c0101105:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c010110c:	e8 4a ff ff ff       	call   c010105b <lpt_putc_sub>
    }
}
c0101111:	c9                   	leave  
c0101112:	c3                   	ret    

c0101113 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c0101113:	55                   	push   %ebp
c0101114:	89 e5                	mov    %esp,%ebp
c0101116:	53                   	push   %ebx
c0101117:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c010111a:	8b 45 08             	mov    0x8(%ebp),%eax
c010111d:	b0 00                	mov    $0x0,%al
c010111f:	85 c0                	test   %eax,%eax
c0101121:	75 07                	jne    c010112a <cga_putc+0x17>
        c |= 0x0700;
c0101123:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c010112a:	8b 45 08             	mov    0x8(%ebp),%eax
c010112d:	0f b6 c0             	movzbl %al,%eax
c0101130:	83 f8 0a             	cmp    $0xa,%eax
c0101133:	74 4c                	je     c0101181 <cga_putc+0x6e>
c0101135:	83 f8 0d             	cmp    $0xd,%eax
c0101138:	74 57                	je     c0101191 <cga_putc+0x7e>
c010113a:	83 f8 08             	cmp    $0x8,%eax
c010113d:	0f 85 88 00 00 00    	jne    c01011cb <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
c0101143:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c010114a:	66 85 c0             	test   %ax,%ax
c010114d:	74 30                	je     c010117f <cga_putc+0x6c>
            crt_pos --;
c010114f:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c0101156:	83 e8 01             	sub    $0x1,%eax
c0101159:	66 a3 44 a4 11 c0    	mov    %ax,0xc011a444
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c010115f:	a1 40 a4 11 c0       	mov    0xc011a440,%eax
c0101164:	0f b7 15 44 a4 11 c0 	movzwl 0xc011a444,%edx
c010116b:	0f b7 d2             	movzwl %dx,%edx
c010116e:	01 d2                	add    %edx,%edx
c0101170:	01 c2                	add    %eax,%edx
c0101172:	8b 45 08             	mov    0x8(%ebp),%eax
c0101175:	b0 00                	mov    $0x0,%al
c0101177:	83 c8 20             	or     $0x20,%eax
c010117a:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c010117d:	eb 72                	jmp    c01011f1 <cga_putc+0xde>
c010117f:	eb 70                	jmp    c01011f1 <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
c0101181:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c0101188:	83 c0 50             	add    $0x50,%eax
c010118b:	66 a3 44 a4 11 c0    	mov    %ax,0xc011a444
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c0101191:	0f b7 1d 44 a4 11 c0 	movzwl 0xc011a444,%ebx
c0101198:	0f b7 0d 44 a4 11 c0 	movzwl 0xc011a444,%ecx
c010119f:	0f b7 c1             	movzwl %cx,%eax
c01011a2:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
c01011a8:	c1 e8 10             	shr    $0x10,%eax
c01011ab:	89 c2                	mov    %eax,%edx
c01011ad:	66 c1 ea 06          	shr    $0x6,%dx
c01011b1:	89 d0                	mov    %edx,%eax
c01011b3:	c1 e0 02             	shl    $0x2,%eax
c01011b6:	01 d0                	add    %edx,%eax
c01011b8:	c1 e0 04             	shl    $0x4,%eax
c01011bb:	29 c1                	sub    %eax,%ecx
c01011bd:	89 ca                	mov    %ecx,%edx
c01011bf:	89 d8                	mov    %ebx,%eax
c01011c1:	29 d0                	sub    %edx,%eax
c01011c3:	66 a3 44 a4 11 c0    	mov    %ax,0xc011a444
        break;
c01011c9:	eb 26                	jmp    c01011f1 <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c01011cb:	8b 0d 40 a4 11 c0    	mov    0xc011a440,%ecx
c01011d1:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c01011d8:	8d 50 01             	lea    0x1(%eax),%edx
c01011db:	66 89 15 44 a4 11 c0 	mov    %dx,0xc011a444
c01011e2:	0f b7 c0             	movzwl %ax,%eax
c01011e5:	01 c0                	add    %eax,%eax
c01011e7:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c01011ea:	8b 45 08             	mov    0x8(%ebp),%eax
c01011ed:	66 89 02             	mov    %ax,(%edx)
        break;
c01011f0:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c01011f1:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c01011f8:	66 3d cf 07          	cmp    $0x7cf,%ax
c01011fc:	76 5b                	jbe    c0101259 <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c01011fe:	a1 40 a4 11 c0       	mov    0xc011a440,%eax
c0101203:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c0101209:	a1 40 a4 11 c0       	mov    0xc011a440,%eax
c010120e:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c0101215:	00 
c0101216:	89 54 24 04          	mov    %edx,0x4(%esp)
c010121a:	89 04 24             	mov    %eax,(%esp)
c010121d:	e8 dd 46 00 00       	call   c01058ff <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101222:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c0101229:	eb 15                	jmp    c0101240 <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
c010122b:	a1 40 a4 11 c0       	mov    0xc011a440,%eax
c0101230:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101233:	01 d2                	add    %edx,%edx
c0101235:	01 d0                	add    %edx,%eax
c0101237:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c010123c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101240:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c0101247:	7e e2                	jle    c010122b <cga_putc+0x118>
        }
        crt_pos -= CRT_COLS;
c0101249:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c0101250:	83 e8 50             	sub    $0x50,%eax
c0101253:	66 a3 44 a4 11 c0    	mov    %ax,0xc011a444
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c0101259:	0f b7 05 46 a4 11 c0 	movzwl 0xc011a446,%eax
c0101260:	0f b7 c0             	movzwl %ax,%eax
c0101263:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101267:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
c010126b:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c010126f:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101273:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c0101274:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c010127b:	66 c1 e8 08          	shr    $0x8,%ax
c010127f:	0f b6 c0             	movzbl %al,%eax
c0101282:	0f b7 15 46 a4 11 c0 	movzwl 0xc011a446,%edx
c0101289:	83 c2 01             	add    $0x1,%edx
c010128c:	0f b7 d2             	movzwl %dx,%edx
c010128f:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
c0101293:	88 45 ed             	mov    %al,-0x13(%ebp)
c0101296:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c010129a:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c010129e:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c010129f:	0f b7 05 46 a4 11 c0 	movzwl 0xc011a446,%eax
c01012a6:	0f b7 c0             	movzwl %ax,%eax
c01012a9:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c01012ad:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
c01012b1:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01012b5:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01012b9:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c01012ba:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c01012c1:	0f b6 c0             	movzbl %al,%eax
c01012c4:	0f b7 15 46 a4 11 c0 	movzwl 0xc011a446,%edx
c01012cb:	83 c2 01             	add    $0x1,%edx
c01012ce:	0f b7 d2             	movzwl %dx,%edx
c01012d1:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c01012d5:	88 45 e5             	mov    %al,-0x1b(%ebp)
c01012d8:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01012dc:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01012e0:	ee                   	out    %al,(%dx)
}
c01012e1:	83 c4 34             	add    $0x34,%esp
c01012e4:	5b                   	pop    %ebx
c01012e5:	5d                   	pop    %ebp
c01012e6:	c3                   	ret    

c01012e7 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c01012e7:	55                   	push   %ebp
c01012e8:	89 e5                	mov    %esp,%ebp
c01012ea:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012ed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01012f4:	eb 09                	jmp    c01012ff <serial_putc_sub+0x18>
        delay();
c01012f6:	e8 4f fb ff ff       	call   c0100e4a <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012fb:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01012ff:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101305:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101309:	89 c2                	mov    %eax,%edx
c010130b:	ec                   	in     (%dx),%al
c010130c:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c010130f:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101313:	0f b6 c0             	movzbl %al,%eax
c0101316:	83 e0 20             	and    $0x20,%eax
c0101319:	85 c0                	test   %eax,%eax
c010131b:	75 09                	jne    c0101326 <serial_putc_sub+0x3f>
c010131d:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101324:	7e d0                	jle    c01012f6 <serial_putc_sub+0xf>
    }
    outb(COM1 + COM_TX, c);
c0101326:	8b 45 08             	mov    0x8(%ebp),%eax
c0101329:	0f b6 c0             	movzbl %al,%eax
c010132c:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c0101332:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101335:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101339:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010133d:	ee                   	out    %al,(%dx)
}
c010133e:	c9                   	leave  
c010133f:	c3                   	ret    

c0101340 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c0101340:	55                   	push   %ebp
c0101341:	89 e5                	mov    %esp,%ebp
c0101343:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c0101346:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c010134a:	74 0d                	je     c0101359 <serial_putc+0x19>
        serial_putc_sub(c);
c010134c:	8b 45 08             	mov    0x8(%ebp),%eax
c010134f:	89 04 24             	mov    %eax,(%esp)
c0101352:	e8 90 ff ff ff       	call   c01012e7 <serial_putc_sub>
c0101357:	eb 24                	jmp    c010137d <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
c0101359:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101360:	e8 82 ff ff ff       	call   c01012e7 <serial_putc_sub>
        serial_putc_sub(' ');
c0101365:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c010136c:	e8 76 ff ff ff       	call   c01012e7 <serial_putc_sub>
        serial_putc_sub('\b');
c0101371:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101378:	e8 6a ff ff ff       	call   c01012e7 <serial_putc_sub>
    }
}
c010137d:	c9                   	leave  
c010137e:	c3                   	ret    

c010137f <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c010137f:	55                   	push   %ebp
c0101380:	89 e5                	mov    %esp,%ebp
c0101382:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c0101385:	eb 33                	jmp    c01013ba <cons_intr+0x3b>
        if (c != 0) {
c0101387:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010138b:	74 2d                	je     c01013ba <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c010138d:	a1 64 a6 11 c0       	mov    0xc011a664,%eax
c0101392:	8d 50 01             	lea    0x1(%eax),%edx
c0101395:	89 15 64 a6 11 c0    	mov    %edx,0xc011a664
c010139b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010139e:	88 90 60 a4 11 c0    	mov    %dl,-0x3fee5ba0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c01013a4:	a1 64 a6 11 c0       	mov    0xc011a664,%eax
c01013a9:	3d 00 02 00 00       	cmp    $0x200,%eax
c01013ae:	75 0a                	jne    c01013ba <cons_intr+0x3b>
                cons.wpos = 0;
c01013b0:	c7 05 64 a6 11 c0 00 	movl   $0x0,0xc011a664
c01013b7:	00 00 00 
    while ((c = (*proc)()) != -1) {
c01013ba:	8b 45 08             	mov    0x8(%ebp),%eax
c01013bd:	ff d0                	call   *%eax
c01013bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01013c2:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c01013c6:	75 bf                	jne    c0101387 <cons_intr+0x8>
            }
        }
    }
}
c01013c8:	c9                   	leave  
c01013c9:	c3                   	ret    

c01013ca <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c01013ca:	55                   	push   %ebp
c01013cb:	89 e5                	mov    %esp,%ebp
c01013cd:	83 ec 10             	sub    $0x10,%esp
c01013d0:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013d6:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01013da:	89 c2                	mov    %eax,%edx
c01013dc:	ec                   	in     (%dx),%al
c01013dd:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01013e0:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c01013e4:	0f b6 c0             	movzbl %al,%eax
c01013e7:	83 e0 01             	and    $0x1,%eax
c01013ea:	85 c0                	test   %eax,%eax
c01013ec:	75 07                	jne    c01013f5 <serial_proc_data+0x2b>
        return -1;
c01013ee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01013f3:	eb 2a                	jmp    c010141f <serial_proc_data+0x55>
c01013f5:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013fb:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01013ff:	89 c2                	mov    %eax,%edx
c0101401:	ec                   	in     (%dx),%al
c0101402:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c0101405:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c0101409:	0f b6 c0             	movzbl %al,%eax
c010140c:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c010140f:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c0101413:	75 07                	jne    c010141c <serial_proc_data+0x52>
        c = '\b';
c0101415:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c010141c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010141f:	c9                   	leave  
c0101420:	c3                   	ret    

c0101421 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c0101421:	55                   	push   %ebp
c0101422:	89 e5                	mov    %esp,%ebp
c0101424:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c0101427:	a1 48 a4 11 c0       	mov    0xc011a448,%eax
c010142c:	85 c0                	test   %eax,%eax
c010142e:	74 0c                	je     c010143c <serial_intr+0x1b>
        cons_intr(serial_proc_data);
c0101430:	c7 04 24 ca 13 10 c0 	movl   $0xc01013ca,(%esp)
c0101437:	e8 43 ff ff ff       	call   c010137f <cons_intr>
    }
}
c010143c:	c9                   	leave  
c010143d:	c3                   	ret    

c010143e <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c010143e:	55                   	push   %ebp
c010143f:	89 e5                	mov    %esp,%ebp
c0101441:	83 ec 38             	sub    $0x38,%esp
c0101444:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010144a:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c010144e:	89 c2                	mov    %eax,%edx
c0101450:	ec                   	in     (%dx),%al
c0101451:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c0101454:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c0101458:	0f b6 c0             	movzbl %al,%eax
c010145b:	83 e0 01             	and    $0x1,%eax
c010145e:	85 c0                	test   %eax,%eax
c0101460:	75 0a                	jne    c010146c <kbd_proc_data+0x2e>
        return -1;
c0101462:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101467:	e9 59 01 00 00       	jmp    c01015c5 <kbd_proc_data+0x187>
c010146c:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101472:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101476:	89 c2                	mov    %eax,%edx
c0101478:	ec                   	in     (%dx),%al
c0101479:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c010147c:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c0101480:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c0101483:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c0101487:	75 17                	jne    c01014a0 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
c0101489:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c010148e:	83 c8 40             	or     $0x40,%eax
c0101491:	a3 68 a6 11 c0       	mov    %eax,0xc011a668
        return 0;
c0101496:	b8 00 00 00 00       	mov    $0x0,%eax
c010149b:	e9 25 01 00 00       	jmp    c01015c5 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
c01014a0:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014a4:	84 c0                	test   %al,%al
c01014a6:	79 47                	jns    c01014ef <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c01014a8:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c01014ad:	83 e0 40             	and    $0x40,%eax
c01014b0:	85 c0                	test   %eax,%eax
c01014b2:	75 09                	jne    c01014bd <kbd_proc_data+0x7f>
c01014b4:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014b8:	83 e0 7f             	and    $0x7f,%eax
c01014bb:	eb 04                	jmp    c01014c1 <kbd_proc_data+0x83>
c01014bd:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014c1:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c01014c4:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014c8:	0f b6 80 40 70 11 c0 	movzbl -0x3fee8fc0(%eax),%eax
c01014cf:	83 c8 40             	or     $0x40,%eax
c01014d2:	0f b6 c0             	movzbl %al,%eax
c01014d5:	f7 d0                	not    %eax
c01014d7:	89 c2                	mov    %eax,%edx
c01014d9:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c01014de:	21 d0                	and    %edx,%eax
c01014e0:	a3 68 a6 11 c0       	mov    %eax,0xc011a668
        return 0;
c01014e5:	b8 00 00 00 00       	mov    $0x0,%eax
c01014ea:	e9 d6 00 00 00       	jmp    c01015c5 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
c01014ef:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c01014f4:	83 e0 40             	and    $0x40,%eax
c01014f7:	85 c0                	test   %eax,%eax
c01014f9:	74 11                	je     c010150c <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c01014fb:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c01014ff:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c0101504:	83 e0 bf             	and    $0xffffffbf,%eax
c0101507:	a3 68 a6 11 c0       	mov    %eax,0xc011a668
    }

    shift |= shiftcode[data];
c010150c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101510:	0f b6 80 40 70 11 c0 	movzbl -0x3fee8fc0(%eax),%eax
c0101517:	0f b6 d0             	movzbl %al,%edx
c010151a:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c010151f:	09 d0                	or     %edx,%eax
c0101521:	a3 68 a6 11 c0       	mov    %eax,0xc011a668
    shift ^= togglecode[data];
c0101526:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010152a:	0f b6 80 40 71 11 c0 	movzbl -0x3fee8ec0(%eax),%eax
c0101531:	0f b6 d0             	movzbl %al,%edx
c0101534:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c0101539:	31 d0                	xor    %edx,%eax
c010153b:	a3 68 a6 11 c0       	mov    %eax,0xc011a668

    c = charcode[shift & (CTL | SHIFT)][data];
c0101540:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c0101545:	83 e0 03             	and    $0x3,%eax
c0101548:	8b 14 85 40 75 11 c0 	mov    -0x3fee8ac0(,%eax,4),%edx
c010154f:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101553:	01 d0                	add    %edx,%eax
c0101555:	0f b6 00             	movzbl (%eax),%eax
c0101558:	0f b6 c0             	movzbl %al,%eax
c010155b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c010155e:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c0101563:	83 e0 08             	and    $0x8,%eax
c0101566:	85 c0                	test   %eax,%eax
c0101568:	74 22                	je     c010158c <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
c010156a:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c010156e:	7e 0c                	jle    c010157c <kbd_proc_data+0x13e>
c0101570:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c0101574:	7f 06                	jg     c010157c <kbd_proc_data+0x13e>
            c += 'A' - 'a';
c0101576:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c010157a:	eb 10                	jmp    c010158c <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
c010157c:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c0101580:	7e 0a                	jle    c010158c <kbd_proc_data+0x14e>
c0101582:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c0101586:	7f 04                	jg     c010158c <kbd_proc_data+0x14e>
            c += 'a' - 'A';
c0101588:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c010158c:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c0101591:	f7 d0                	not    %eax
c0101593:	83 e0 06             	and    $0x6,%eax
c0101596:	85 c0                	test   %eax,%eax
c0101598:	75 28                	jne    c01015c2 <kbd_proc_data+0x184>
c010159a:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c01015a1:	75 1f                	jne    c01015c2 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
c01015a3:	c7 04 24 0d 64 10 c0 	movl   $0xc010640d,(%esp)
c01015aa:	e8 ee ec ff ff       	call   c010029d <cprintf>
c01015af:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c01015b5:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01015b9:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c01015bd:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c01015c1:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c01015c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01015c5:	c9                   	leave  
c01015c6:	c3                   	ret    

c01015c7 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c01015c7:	55                   	push   %ebp
c01015c8:	89 e5                	mov    %esp,%ebp
c01015ca:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c01015cd:	c7 04 24 3e 14 10 c0 	movl   $0xc010143e,(%esp)
c01015d4:	e8 a6 fd ff ff       	call   c010137f <cons_intr>
}
c01015d9:	c9                   	leave  
c01015da:	c3                   	ret    

c01015db <kbd_init>:

static void
kbd_init(void) {
c01015db:	55                   	push   %ebp
c01015dc:	89 e5                	mov    %esp,%ebp
c01015de:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c01015e1:	e8 e1 ff ff ff       	call   c01015c7 <kbd_intr>
    pic_enable(IRQ_KBD);
c01015e6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01015ed:	e8 31 01 00 00       	call   c0101723 <pic_enable>
}
c01015f2:	c9                   	leave  
c01015f3:	c3                   	ret    

c01015f4 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c01015f4:	55                   	push   %ebp
c01015f5:	89 e5                	mov    %esp,%ebp
c01015f7:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c01015fa:	e8 93 f8 ff ff       	call   c0100e92 <cga_init>
    serial_init();
c01015ff:	e8 74 f9 ff ff       	call   c0100f78 <serial_init>
    kbd_init();
c0101604:	e8 d2 ff ff ff       	call   c01015db <kbd_init>
    if (!serial_exists) {
c0101609:	a1 48 a4 11 c0       	mov    0xc011a448,%eax
c010160e:	85 c0                	test   %eax,%eax
c0101610:	75 0c                	jne    c010161e <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c0101612:	c7 04 24 19 64 10 c0 	movl   $0xc0106419,(%esp)
c0101619:	e8 7f ec ff ff       	call   c010029d <cprintf>
    }
}
c010161e:	c9                   	leave  
c010161f:	c3                   	ret    

c0101620 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c0101620:	55                   	push   %ebp
c0101621:	89 e5                	mov    %esp,%ebp
c0101623:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0101626:	e8 e2 f7 ff ff       	call   c0100e0d <__intr_save>
c010162b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c010162e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101631:	89 04 24             	mov    %eax,(%esp)
c0101634:	e8 9b fa ff ff       	call   c01010d4 <lpt_putc>
        cga_putc(c);
c0101639:	8b 45 08             	mov    0x8(%ebp),%eax
c010163c:	89 04 24             	mov    %eax,(%esp)
c010163f:	e8 cf fa ff ff       	call   c0101113 <cga_putc>
        serial_putc(c);
c0101644:	8b 45 08             	mov    0x8(%ebp),%eax
c0101647:	89 04 24             	mov    %eax,(%esp)
c010164a:	e8 f1 fc ff ff       	call   c0101340 <serial_putc>
    }
    local_intr_restore(intr_flag);
c010164f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101652:	89 04 24             	mov    %eax,(%esp)
c0101655:	e8 dd f7 ff ff       	call   c0100e37 <__intr_restore>
}
c010165a:	c9                   	leave  
c010165b:	c3                   	ret    

c010165c <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c010165c:	55                   	push   %ebp
c010165d:	89 e5                	mov    %esp,%ebp
c010165f:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c0101662:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0101669:	e8 9f f7 ff ff       	call   c0100e0d <__intr_save>
c010166e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c0101671:	e8 ab fd ff ff       	call   c0101421 <serial_intr>
        kbd_intr();
c0101676:	e8 4c ff ff ff       	call   c01015c7 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c010167b:	8b 15 60 a6 11 c0    	mov    0xc011a660,%edx
c0101681:	a1 64 a6 11 c0       	mov    0xc011a664,%eax
c0101686:	39 c2                	cmp    %eax,%edx
c0101688:	74 31                	je     c01016bb <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c010168a:	a1 60 a6 11 c0       	mov    0xc011a660,%eax
c010168f:	8d 50 01             	lea    0x1(%eax),%edx
c0101692:	89 15 60 a6 11 c0    	mov    %edx,0xc011a660
c0101698:	0f b6 80 60 a4 11 c0 	movzbl -0x3fee5ba0(%eax),%eax
c010169f:	0f b6 c0             	movzbl %al,%eax
c01016a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c01016a5:	a1 60 a6 11 c0       	mov    0xc011a660,%eax
c01016aa:	3d 00 02 00 00       	cmp    $0x200,%eax
c01016af:	75 0a                	jne    c01016bb <cons_getc+0x5f>
                cons.rpos = 0;
c01016b1:	c7 05 60 a6 11 c0 00 	movl   $0x0,0xc011a660
c01016b8:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c01016bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01016be:	89 04 24             	mov    %eax,(%esp)
c01016c1:	e8 71 f7 ff ff       	call   c0100e37 <__intr_restore>
    return c;
c01016c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01016c9:	c9                   	leave  
c01016ca:	c3                   	ret    

c01016cb <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c01016cb:	55                   	push   %ebp
c01016cc:	89 e5                	mov    %esp,%ebp
c01016ce:	83 ec 14             	sub    $0x14,%esp
c01016d1:	8b 45 08             	mov    0x8(%ebp),%eax
c01016d4:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c01016d8:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016dc:	66 a3 50 75 11 c0    	mov    %ax,0xc0117550
    if (did_init) {
c01016e2:	a1 6c a6 11 c0       	mov    0xc011a66c,%eax
c01016e7:	85 c0                	test   %eax,%eax
c01016e9:	74 36                	je     c0101721 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
c01016eb:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016ef:	0f b6 c0             	movzbl %al,%eax
c01016f2:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c01016f8:	88 45 fd             	mov    %al,-0x3(%ebp)
c01016fb:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c01016ff:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101703:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c0101704:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101708:	66 c1 e8 08          	shr    $0x8,%ax
c010170c:	0f b6 c0             	movzbl %al,%eax
c010170f:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c0101715:	88 45 f9             	mov    %al,-0x7(%ebp)
c0101718:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c010171c:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101720:	ee                   	out    %al,(%dx)
    }
}
c0101721:	c9                   	leave  
c0101722:	c3                   	ret    

c0101723 <pic_enable>:

void
pic_enable(unsigned int irq) {
c0101723:	55                   	push   %ebp
c0101724:	89 e5                	mov    %esp,%ebp
c0101726:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c0101729:	8b 45 08             	mov    0x8(%ebp),%eax
c010172c:	ba 01 00 00 00       	mov    $0x1,%edx
c0101731:	89 c1                	mov    %eax,%ecx
c0101733:	d3 e2                	shl    %cl,%edx
c0101735:	89 d0                	mov    %edx,%eax
c0101737:	f7 d0                	not    %eax
c0101739:	89 c2                	mov    %eax,%edx
c010173b:	0f b7 05 50 75 11 c0 	movzwl 0xc0117550,%eax
c0101742:	21 d0                	and    %edx,%eax
c0101744:	0f b7 c0             	movzwl %ax,%eax
c0101747:	89 04 24             	mov    %eax,(%esp)
c010174a:	e8 7c ff ff ff       	call   c01016cb <pic_setmask>
}
c010174f:	c9                   	leave  
c0101750:	c3                   	ret    

c0101751 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c0101751:	55                   	push   %ebp
c0101752:	89 e5                	mov    %esp,%ebp
c0101754:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c0101757:	c7 05 6c a6 11 c0 01 	movl   $0x1,0xc011a66c
c010175e:	00 00 00 
c0101761:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0101767:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
c010176b:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c010176f:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101773:	ee                   	out    %al,(%dx)
c0101774:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c010177a:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
c010177e:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101782:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101786:	ee                   	out    %al,(%dx)
c0101787:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c010178d:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
c0101791:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101795:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101799:	ee                   	out    %al,(%dx)
c010179a:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
c01017a0:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
c01017a4:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01017a8:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01017ac:	ee                   	out    %al,(%dx)
c01017ad:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
c01017b3:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
c01017b7:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01017bb:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01017bf:	ee                   	out    %al,(%dx)
c01017c0:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
c01017c6:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
c01017ca:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01017ce:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01017d2:	ee                   	out    %al,(%dx)
c01017d3:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
c01017d9:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
c01017dd:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01017e1:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01017e5:	ee                   	out    %al,(%dx)
c01017e6:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
c01017ec:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
c01017f0:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c01017f4:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c01017f8:	ee                   	out    %al,(%dx)
c01017f9:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
c01017ff:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
c0101803:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101807:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c010180b:	ee                   	out    %al,(%dx)
c010180c:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
c0101812:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
c0101816:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c010181a:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c010181e:	ee                   	out    %al,(%dx)
c010181f:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
c0101825:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
c0101829:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c010182d:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101831:	ee                   	out    %al,(%dx)
c0101832:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c0101838:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
c010183c:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0101840:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0101844:	ee                   	out    %al,(%dx)
c0101845:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
c010184b:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
c010184f:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c0101853:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c0101857:	ee                   	out    %al,(%dx)
c0101858:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
c010185e:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
c0101862:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c0101866:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c010186a:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c010186b:	0f b7 05 50 75 11 c0 	movzwl 0xc0117550,%eax
c0101872:	66 83 f8 ff          	cmp    $0xffff,%ax
c0101876:	74 12                	je     c010188a <pic_init+0x139>
        pic_setmask(irq_mask);
c0101878:	0f b7 05 50 75 11 c0 	movzwl 0xc0117550,%eax
c010187f:	0f b7 c0             	movzwl %ax,%eax
c0101882:	89 04 24             	mov    %eax,(%esp)
c0101885:	e8 41 fe ff ff       	call   c01016cb <pic_setmask>
    }
}
c010188a:	c9                   	leave  
c010188b:	c3                   	ret    

c010188c <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c010188c:	55                   	push   %ebp
c010188d:	89 e5                	mov    %esp,%ebp
    asm volatile ("sti");
c010188f:	fb                   	sti    
    sti();
}
c0101890:	5d                   	pop    %ebp
c0101891:	c3                   	ret    

c0101892 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c0101892:	55                   	push   %ebp
c0101893:	89 e5                	mov    %esp,%ebp
    asm volatile ("cli" ::: "memory");
c0101895:	fa                   	cli    
    cli();
}
c0101896:	5d                   	pop    %ebp
c0101897:	c3                   	ret    

c0101898 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c0101898:	55                   	push   %ebp
c0101899:	89 e5                	mov    %esp,%ebp
c010189b:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c010189e:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c01018a5:	00 
c01018a6:	c7 04 24 40 64 10 c0 	movl   $0xc0106440,(%esp)
c01018ad:	e8 eb e9 ff ff       	call   c010029d <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
c01018b2:	c7 04 24 4a 64 10 c0 	movl   $0xc010644a,(%esp)
c01018b9:	e8 df e9 ff ff       	call   c010029d <cprintf>
    panic("EOT: kernel seems ok.");
c01018be:	c7 44 24 08 58 64 10 	movl   $0xc0106458,0x8(%esp)
c01018c5:	c0 
c01018c6:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
c01018cd:	00 
c01018ce:	c7 04 24 6e 64 10 c0 	movl   $0xc010646e,(%esp)
c01018d5:	e8 1a eb ff ff       	call   c01003f4 <__panic>

c01018da <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c01018da:	55                   	push   %ebp
c01018db:	89 e5                	mov    %esp,%ebp
c01018dd:	83 ec 10             	sub    $0x10,%esp
      */

	extern uintptr_t __vectors[];

	uint32_t i;
	for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++)
c01018e0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01018e7:	e9 c3 00 00 00       	jmp    c01019af <idt_init+0xd5>
	{
		SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
c01018ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018ef:	8b 04 85 e0 75 11 c0 	mov    -0x3fee8a20(,%eax,4),%eax
c01018f6:	89 c2                	mov    %eax,%edx
c01018f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018fb:	66 89 14 c5 80 a6 11 	mov    %dx,-0x3fee5980(,%eax,8)
c0101902:	c0 
c0101903:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101906:	66 c7 04 c5 82 a6 11 	movw   $0x8,-0x3fee597e(,%eax,8)
c010190d:	c0 08 00 
c0101910:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101913:	0f b6 14 c5 84 a6 11 	movzbl -0x3fee597c(,%eax,8),%edx
c010191a:	c0 
c010191b:	83 e2 e0             	and    $0xffffffe0,%edx
c010191e:	88 14 c5 84 a6 11 c0 	mov    %dl,-0x3fee597c(,%eax,8)
c0101925:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101928:	0f b6 14 c5 84 a6 11 	movzbl -0x3fee597c(,%eax,8),%edx
c010192f:	c0 
c0101930:	83 e2 1f             	and    $0x1f,%edx
c0101933:	88 14 c5 84 a6 11 c0 	mov    %dl,-0x3fee597c(,%eax,8)
c010193a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010193d:	0f b6 14 c5 85 a6 11 	movzbl -0x3fee597b(,%eax,8),%edx
c0101944:	c0 
c0101945:	83 e2 f0             	and    $0xfffffff0,%edx
c0101948:	83 ca 0e             	or     $0xe,%edx
c010194b:	88 14 c5 85 a6 11 c0 	mov    %dl,-0x3fee597b(,%eax,8)
c0101952:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101955:	0f b6 14 c5 85 a6 11 	movzbl -0x3fee597b(,%eax,8),%edx
c010195c:	c0 
c010195d:	83 e2 ef             	and    $0xffffffef,%edx
c0101960:	88 14 c5 85 a6 11 c0 	mov    %dl,-0x3fee597b(,%eax,8)
c0101967:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010196a:	0f b6 14 c5 85 a6 11 	movzbl -0x3fee597b(,%eax,8),%edx
c0101971:	c0 
c0101972:	83 e2 9f             	and    $0xffffff9f,%edx
c0101975:	88 14 c5 85 a6 11 c0 	mov    %dl,-0x3fee597b(,%eax,8)
c010197c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010197f:	0f b6 14 c5 85 a6 11 	movzbl -0x3fee597b(,%eax,8),%edx
c0101986:	c0 
c0101987:	83 ca 80             	or     $0xffffff80,%edx
c010198a:	88 14 c5 85 a6 11 c0 	mov    %dl,-0x3fee597b(,%eax,8)
c0101991:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101994:	8b 04 85 e0 75 11 c0 	mov    -0x3fee8a20(,%eax,4),%eax
c010199b:	c1 e8 10             	shr    $0x10,%eax
c010199e:	89 c2                	mov    %eax,%edx
c01019a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019a3:	66 89 14 c5 86 a6 11 	mov    %dx,-0x3fee597a(,%eax,8)
c01019aa:	c0 
	for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++)
c01019ab:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01019af:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
c01019b6:	0f 86 30 ff ff ff    	jbe    c01018ec <idt_init+0x12>
	}

	// set for switch from user to kernel
	SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
c01019bc:	a1 c4 77 11 c0       	mov    0xc01177c4,%eax
c01019c1:	66 a3 48 aa 11 c0    	mov    %ax,0xc011aa48
c01019c7:	66 c7 05 4a aa 11 c0 	movw   $0x8,0xc011aa4a
c01019ce:	08 00 
c01019d0:	0f b6 05 4c aa 11 c0 	movzbl 0xc011aa4c,%eax
c01019d7:	83 e0 e0             	and    $0xffffffe0,%eax
c01019da:	a2 4c aa 11 c0       	mov    %al,0xc011aa4c
c01019df:	0f b6 05 4c aa 11 c0 	movzbl 0xc011aa4c,%eax
c01019e6:	83 e0 1f             	and    $0x1f,%eax
c01019e9:	a2 4c aa 11 c0       	mov    %al,0xc011aa4c
c01019ee:	0f b6 05 4d aa 11 c0 	movzbl 0xc011aa4d,%eax
c01019f5:	83 e0 f0             	and    $0xfffffff0,%eax
c01019f8:	83 c8 0e             	or     $0xe,%eax
c01019fb:	a2 4d aa 11 c0       	mov    %al,0xc011aa4d
c0101a00:	0f b6 05 4d aa 11 c0 	movzbl 0xc011aa4d,%eax
c0101a07:	83 e0 ef             	and    $0xffffffef,%eax
c0101a0a:	a2 4d aa 11 c0       	mov    %al,0xc011aa4d
c0101a0f:	0f b6 05 4d aa 11 c0 	movzbl 0xc011aa4d,%eax
c0101a16:	83 c8 60             	or     $0x60,%eax
c0101a19:	a2 4d aa 11 c0       	mov    %al,0xc011aa4d
c0101a1e:	0f b6 05 4d aa 11 c0 	movzbl 0xc011aa4d,%eax
c0101a25:	83 c8 80             	or     $0xffffff80,%eax
c0101a28:	a2 4d aa 11 c0       	mov    %al,0xc011aa4d
c0101a2d:	a1 c4 77 11 c0       	mov    0xc01177c4,%eax
c0101a32:	c1 e8 10             	shr    $0x10,%eax
c0101a35:	66 a3 4e aa 11 c0    	mov    %ax,0xc011aa4e
c0101a3b:	c7 45 f8 60 75 11 c0 	movl   $0xc0117560,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c0101a42:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101a45:	0f 01 18             	lidtl  (%eax)

	// idt 存储了具体的信息， idtpd，作为一个结构体，将idt进行了进一步封装，这种写法很常见
	lidt(&idt_pd);


}
c0101a48:	c9                   	leave  
c0101a49:	c3                   	ret    

c0101a4a <trapname>:

static const char *
trapname(int trapno) {
c0101a4a:	55                   	push   %ebp
c0101a4b:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c0101a4d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a50:	83 f8 13             	cmp    $0x13,%eax
c0101a53:	77 0c                	ja     c0101a61 <trapname+0x17>
        return excnames[trapno];
c0101a55:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a58:	8b 04 85 c0 67 10 c0 	mov    -0x3fef9840(,%eax,4),%eax
c0101a5f:	eb 18                	jmp    c0101a79 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c0101a61:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c0101a65:	7e 0d                	jle    c0101a74 <trapname+0x2a>
c0101a67:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c0101a6b:	7f 07                	jg     c0101a74 <trapname+0x2a>
        return "Hardware Interrupt";
c0101a6d:	b8 7f 64 10 c0       	mov    $0xc010647f,%eax
c0101a72:	eb 05                	jmp    c0101a79 <trapname+0x2f>
    }
    return "(unknown trap)";
c0101a74:	b8 92 64 10 c0       	mov    $0xc0106492,%eax
}
c0101a79:	5d                   	pop    %ebp
c0101a7a:	c3                   	ret    

c0101a7b <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c0101a7b:	55                   	push   %ebp
c0101a7c:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c0101a7e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a81:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101a85:	66 83 f8 08          	cmp    $0x8,%ax
c0101a89:	0f 94 c0             	sete   %al
c0101a8c:	0f b6 c0             	movzbl %al,%eax
}
c0101a8f:	5d                   	pop    %ebp
c0101a90:	c3                   	ret    

c0101a91 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c0101a91:	55                   	push   %ebp
c0101a92:	89 e5                	mov    %esp,%ebp
c0101a94:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c0101a97:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a9a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a9e:	c7 04 24 d3 64 10 c0 	movl   $0xc01064d3,(%esp)
c0101aa5:	e8 f3 e7 ff ff       	call   c010029d <cprintf>
    print_regs(&tf->tf_regs);
c0101aaa:	8b 45 08             	mov    0x8(%ebp),%eax
c0101aad:	89 04 24             	mov    %eax,(%esp)
c0101ab0:	e8 a1 01 00 00       	call   c0101c56 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0101ab5:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ab8:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0101abc:	0f b7 c0             	movzwl %ax,%eax
c0101abf:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ac3:	c7 04 24 e4 64 10 c0 	movl   $0xc01064e4,(%esp)
c0101aca:	e8 ce e7 ff ff       	call   c010029d <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0101acf:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ad2:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0101ad6:	0f b7 c0             	movzwl %ax,%eax
c0101ad9:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101add:	c7 04 24 f7 64 10 c0 	movl   $0xc01064f7,(%esp)
c0101ae4:	e8 b4 e7 ff ff       	call   c010029d <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0101ae9:	8b 45 08             	mov    0x8(%ebp),%eax
c0101aec:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0101af0:	0f b7 c0             	movzwl %ax,%eax
c0101af3:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101af7:	c7 04 24 0a 65 10 c0 	movl   $0xc010650a,(%esp)
c0101afe:	e8 9a e7 ff ff       	call   c010029d <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0101b03:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b06:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0101b0a:	0f b7 c0             	movzwl %ax,%eax
c0101b0d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b11:	c7 04 24 1d 65 10 c0 	movl   $0xc010651d,(%esp)
c0101b18:	e8 80 e7 ff ff       	call   c010029d <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0101b1d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b20:	8b 40 30             	mov    0x30(%eax),%eax
c0101b23:	89 04 24             	mov    %eax,(%esp)
c0101b26:	e8 1f ff ff ff       	call   c0101a4a <trapname>
c0101b2b:	8b 55 08             	mov    0x8(%ebp),%edx
c0101b2e:	8b 52 30             	mov    0x30(%edx),%edx
c0101b31:	89 44 24 08          	mov    %eax,0x8(%esp)
c0101b35:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101b39:	c7 04 24 30 65 10 c0 	movl   $0xc0106530,(%esp)
c0101b40:	e8 58 e7 ff ff       	call   c010029d <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c0101b45:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b48:	8b 40 34             	mov    0x34(%eax),%eax
c0101b4b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b4f:	c7 04 24 42 65 10 c0 	movl   $0xc0106542,(%esp)
c0101b56:	e8 42 e7 ff ff       	call   c010029d <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0101b5b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b5e:	8b 40 38             	mov    0x38(%eax),%eax
c0101b61:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b65:	c7 04 24 51 65 10 c0 	movl   $0xc0106551,(%esp)
c0101b6c:	e8 2c e7 ff ff       	call   c010029d <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0101b71:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b74:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101b78:	0f b7 c0             	movzwl %ax,%eax
c0101b7b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b7f:	c7 04 24 60 65 10 c0 	movl   $0xc0106560,(%esp)
c0101b86:	e8 12 e7 ff ff       	call   c010029d <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0101b8b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b8e:	8b 40 40             	mov    0x40(%eax),%eax
c0101b91:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b95:	c7 04 24 73 65 10 c0 	movl   $0xc0106573,(%esp)
c0101b9c:	e8 fc e6 ff ff       	call   c010029d <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101ba1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101ba8:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0101baf:	eb 3e                	jmp    c0101bef <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0101bb1:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bb4:	8b 50 40             	mov    0x40(%eax),%edx
c0101bb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101bba:	21 d0                	and    %edx,%eax
c0101bbc:	85 c0                	test   %eax,%eax
c0101bbe:	74 28                	je     c0101be8 <print_trapframe+0x157>
c0101bc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101bc3:	8b 04 85 80 75 11 c0 	mov    -0x3fee8a80(,%eax,4),%eax
c0101bca:	85 c0                	test   %eax,%eax
c0101bcc:	74 1a                	je     c0101be8 <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
c0101bce:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101bd1:	8b 04 85 80 75 11 c0 	mov    -0x3fee8a80(,%eax,4),%eax
c0101bd8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bdc:	c7 04 24 82 65 10 c0 	movl   $0xc0106582,(%esp)
c0101be3:	e8 b5 e6 ff ff       	call   c010029d <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101be8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101bec:	d1 65 f0             	shll   -0x10(%ebp)
c0101bef:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101bf2:	83 f8 17             	cmp    $0x17,%eax
c0101bf5:	76 ba                	jbe    c0101bb1 <print_trapframe+0x120>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0101bf7:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bfa:	8b 40 40             	mov    0x40(%eax),%eax
c0101bfd:	25 00 30 00 00       	and    $0x3000,%eax
c0101c02:	c1 e8 0c             	shr    $0xc,%eax
c0101c05:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c09:	c7 04 24 86 65 10 c0 	movl   $0xc0106586,(%esp)
c0101c10:	e8 88 e6 ff ff       	call   c010029d <cprintf>

    if (!trap_in_kernel(tf)) {
c0101c15:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c18:	89 04 24             	mov    %eax,(%esp)
c0101c1b:	e8 5b fe ff ff       	call   c0101a7b <trap_in_kernel>
c0101c20:	85 c0                	test   %eax,%eax
c0101c22:	75 30                	jne    c0101c54 <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0101c24:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c27:	8b 40 44             	mov    0x44(%eax),%eax
c0101c2a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c2e:	c7 04 24 8f 65 10 c0 	movl   $0xc010658f,(%esp)
c0101c35:	e8 63 e6 ff ff       	call   c010029d <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0101c3a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c3d:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0101c41:	0f b7 c0             	movzwl %ax,%eax
c0101c44:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c48:	c7 04 24 9e 65 10 c0 	movl   $0xc010659e,(%esp)
c0101c4f:	e8 49 e6 ff ff       	call   c010029d <cprintf>
    }
}
c0101c54:	c9                   	leave  
c0101c55:	c3                   	ret    

c0101c56 <print_regs>:

void
print_regs(struct pushregs *regs) {
c0101c56:	55                   	push   %ebp
c0101c57:	89 e5                	mov    %esp,%ebp
c0101c59:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0101c5c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c5f:	8b 00                	mov    (%eax),%eax
c0101c61:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c65:	c7 04 24 b1 65 10 c0 	movl   $0xc01065b1,(%esp)
c0101c6c:	e8 2c e6 ff ff       	call   c010029d <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0101c71:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c74:	8b 40 04             	mov    0x4(%eax),%eax
c0101c77:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c7b:	c7 04 24 c0 65 10 c0 	movl   $0xc01065c0,(%esp)
c0101c82:	e8 16 e6 ff ff       	call   c010029d <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0101c87:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c8a:	8b 40 08             	mov    0x8(%eax),%eax
c0101c8d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c91:	c7 04 24 cf 65 10 c0 	movl   $0xc01065cf,(%esp)
c0101c98:	e8 00 e6 ff ff       	call   c010029d <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0101c9d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ca0:	8b 40 0c             	mov    0xc(%eax),%eax
c0101ca3:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ca7:	c7 04 24 de 65 10 c0 	movl   $0xc01065de,(%esp)
c0101cae:	e8 ea e5 ff ff       	call   c010029d <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0101cb3:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cb6:	8b 40 10             	mov    0x10(%eax),%eax
c0101cb9:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cbd:	c7 04 24 ed 65 10 c0 	movl   $0xc01065ed,(%esp)
c0101cc4:	e8 d4 e5 ff ff       	call   c010029d <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0101cc9:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ccc:	8b 40 14             	mov    0x14(%eax),%eax
c0101ccf:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cd3:	c7 04 24 fc 65 10 c0 	movl   $0xc01065fc,(%esp)
c0101cda:	e8 be e5 ff ff       	call   c010029d <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0101cdf:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ce2:	8b 40 18             	mov    0x18(%eax),%eax
c0101ce5:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ce9:	c7 04 24 0b 66 10 c0 	movl   $0xc010660b,(%esp)
c0101cf0:	e8 a8 e5 ff ff       	call   c010029d <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0101cf5:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cf8:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101cfb:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cff:	c7 04 24 1a 66 10 c0 	movl   $0xc010661a,(%esp)
c0101d06:	e8 92 e5 ff ff       	call   c010029d <cprintf>
}
c0101d0b:	c9                   	leave  
c0101d0c:	c3                   	ret    

c0101d0d <trap_dispatch>:
/* temporary trapframe or pointer to trapframe */
struct trapframe switchk2u, *switchu2k;

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
c0101d0d:	55                   	push   %ebp
c0101d0e:	89 e5                	mov    %esp,%ebp
c0101d10:	57                   	push   %edi
c0101d11:	56                   	push   %esi
c0101d12:	53                   	push   %ebx
c0101d13:	83 ec 2c             	sub    $0x2c,%esp
    char c;

    switch (tf->tf_trapno) {
c0101d16:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d19:	8b 40 30             	mov    0x30(%eax),%eax
c0101d1c:	83 f8 2f             	cmp    $0x2f,%eax
c0101d1f:	77 21                	ja     c0101d42 <trap_dispatch+0x35>
c0101d21:	83 f8 2e             	cmp    $0x2e,%eax
c0101d24:	0f 83 ec 01 00 00    	jae    c0101f16 <trap_dispatch+0x209>
c0101d2a:	83 f8 21             	cmp    $0x21,%eax
c0101d2d:	0f 84 8a 00 00 00    	je     c0101dbd <trap_dispatch+0xb0>
c0101d33:	83 f8 24             	cmp    $0x24,%eax
c0101d36:	74 5c                	je     c0101d94 <trap_dispatch+0x87>
c0101d38:	83 f8 20             	cmp    $0x20,%eax
c0101d3b:	74 1c                	je     c0101d59 <trap_dispatch+0x4c>
c0101d3d:	e9 9c 01 00 00       	jmp    c0101ede <trap_dispatch+0x1d1>
c0101d42:	83 f8 78             	cmp    $0x78,%eax
c0101d45:	0f 84 9b 00 00 00    	je     c0101de6 <trap_dispatch+0xd9>
c0101d4b:	83 f8 79             	cmp    $0x79,%eax
c0101d4e:	0f 84 11 01 00 00    	je     c0101e65 <trap_dispatch+0x158>
c0101d54:	e9 85 01 00 00       	jmp    c0101ede <trap_dispatch+0x1d1>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
    	ticks ++;
c0101d59:	a1 0c af 11 c0       	mov    0xc011af0c,%eax
c0101d5e:	83 c0 01             	add    $0x1,%eax
c0101d61:	a3 0c af 11 c0       	mov    %eax,0xc011af0c
    	if (ticks % TICK_NUM == 0)
c0101d66:	8b 0d 0c af 11 c0    	mov    0xc011af0c,%ecx
c0101d6c:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
c0101d71:	89 c8                	mov    %ecx,%eax
c0101d73:	f7 e2                	mul    %edx
c0101d75:	89 d0                	mov    %edx,%eax
c0101d77:	c1 e8 05             	shr    $0x5,%eax
c0101d7a:	6b c0 64             	imul   $0x64,%eax,%eax
c0101d7d:	29 c1                	sub    %eax,%ecx
c0101d7f:	89 c8                	mov    %ecx,%eax
c0101d81:	85 c0                	test   %eax,%eax
c0101d83:	75 0a                	jne    c0101d8f <trap_dispatch+0x82>
    	{
    		print_ticks();
c0101d85:	e8 0e fb ff ff       	call   c0101898 <print_ticks>
    	}
        break;
c0101d8a:	e9 88 01 00 00       	jmp    c0101f17 <trap_dispatch+0x20a>
c0101d8f:	e9 83 01 00 00       	jmp    c0101f17 <trap_dispatch+0x20a>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0101d94:	e8 c3 f8 ff ff       	call   c010165c <cons_getc>
c0101d99:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0101d9c:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
c0101da0:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
c0101da4:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101da8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101dac:	c7 04 24 29 66 10 c0 	movl   $0xc0106629,(%esp)
c0101db3:	e8 e5 e4 ff ff       	call   c010029d <cprintf>
        break;
c0101db8:	e9 5a 01 00 00       	jmp    c0101f17 <trap_dispatch+0x20a>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0101dbd:	e8 9a f8 ff ff       	call   c010165c <cons_getc>
c0101dc2:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0101dc5:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
c0101dc9:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
c0101dcd:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101dd1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101dd5:	c7 04 24 3b 66 10 c0 	movl   $0xc010663b,(%esp)
c0101ddc:	e8 bc e4 ff ff       	call   c010029d <cprintf>
        break;
c0101de1:	e9 31 01 00 00       	jmp    c0101f17 <trap_dispatch+0x20a>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    	if(tf->tf_cs !=  USER_CS)
c0101de6:	8b 45 08             	mov    0x8(%ebp),%eax
c0101de9:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101ded:	66 83 f8 1b          	cmp    $0x1b,%ax
c0101df1:	74 6d                	je     c0101e60 <trap_dispatch+0x153>
    	{
    		switchk2u = *tf;
c0101df3:	8b 45 08             	mov    0x8(%ebp),%eax
c0101df6:	ba 20 af 11 c0       	mov    $0xc011af20,%edx
c0101dfb:	89 c3                	mov    %eax,%ebx
c0101dfd:	b8 13 00 00 00       	mov    $0x13,%eax
c0101e02:	89 d7                	mov    %edx,%edi
c0101e04:	89 de                	mov    %ebx,%esi
c0101e06:	89 c1                	mov    %eax,%ecx
c0101e08:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    		switchk2u.tf_cs =  USER_CS;
c0101e0a:	66 c7 05 5c af 11 c0 	movw   $0x1b,0xc011af5c
c0101e11:	1b 00 
    		switchk2u.tf_ds = switchk2u.tf_es = switchk2u.tf_ss = USER_DS;
c0101e13:	66 c7 05 68 af 11 c0 	movw   $0x23,0xc011af68
c0101e1a:	23 00 
c0101e1c:	0f b7 05 68 af 11 c0 	movzwl 0xc011af68,%eax
c0101e23:	66 a3 48 af 11 c0    	mov    %ax,0xc011af48
c0101e29:	0f b7 05 48 af 11 c0 	movzwl 0xc011af48,%eax
c0101e30:	66 a3 4c af 11 c0    	mov    %ax,0xc011af4c
    		switchk2u.tf_eflags |= FL_IOPL_MASK;
c0101e36:	a1 60 af 11 c0       	mov    0xc011af60,%eax
c0101e3b:	80 cc 30             	or     $0x30,%ah
c0101e3e:	a3 60 af 11 c0       	mov    %eax,0xc011af60
    	    switchk2u.tf_esp = (uint32_t)tf + sizeof(struct trapframe) - 8;
c0101e43:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e46:	83 c0 44             	add    $0x44,%eax
c0101e49:	a3 64 af 11 c0       	mov    %eax,0xc011af64

    	    *((uint32_t *) tf - 1) = (uint32_t) &switchk2u;
c0101e4e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e51:	8d 50 fc             	lea    -0x4(%eax),%edx
c0101e54:	b8 20 af 11 c0       	mov    $0xc011af20,%eax
c0101e59:	89 02                	mov    %eax,(%edx)
    	}
    	break;
c0101e5b:	e9 b7 00 00 00       	jmp    c0101f17 <trap_dispatch+0x20a>
c0101e60:	e9 b2 00 00 00       	jmp    c0101f17 <trap_dispatch+0x20a>
    case T_SWITCH_TOK:
    	if(tf->tf_cs != KERNEL_CS)
c0101e65:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e68:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101e6c:	66 83 f8 08          	cmp    $0x8,%ax
c0101e70:	74 6a                	je     c0101edc <trap_dispatch+0x1cf>
    	{
    		tf->tf_cs = KERNEL_CS;
c0101e72:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e75:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
    		tf->tf_ds = tf->tf_es = KERNEL_DS;
c0101e7b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e7e:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
c0101e84:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e87:	0f b7 50 28          	movzwl 0x28(%eax),%edx
c0101e8b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e8e:	66 89 50 2c          	mov    %dx,0x2c(%eax)
    		tf->tf_eflags &= ~FL_IOPL_MASK;
c0101e92:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e95:	8b 40 40             	mov    0x40(%eax),%eax
c0101e98:	80 e4 cf             	and    $0xcf,%ah
c0101e9b:	89 c2                	mov    %eax,%edx
c0101e9d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ea0:	89 50 40             	mov    %edx,0x40(%eax)
    		switchu2k = (struct trapframe *)(tf->tf_esp - (sizeof(struct trapframe) - 8));
c0101ea3:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ea6:	8b 40 44             	mov    0x44(%eax),%eax
c0101ea9:	83 e8 44             	sub    $0x44,%eax
c0101eac:	a3 6c af 11 c0       	mov    %eax,0xc011af6c
    		memmove(switchu2k, tf, sizeof(struct trapframe) - 8);
c0101eb1:	a1 6c af 11 c0       	mov    0xc011af6c,%eax
c0101eb6:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
c0101ebd:	00 
c0101ebe:	8b 55 08             	mov    0x8(%ebp),%edx
c0101ec1:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101ec5:	89 04 24             	mov    %eax,(%esp)
c0101ec8:	e8 32 3a 00 00       	call   c01058ff <memmove>
    		*((uint32_t *) tf - 1) = (uint32_t) switchu2k;
c0101ecd:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ed0:	8d 50 fc             	lea    -0x4(%eax),%edx
c0101ed3:	a1 6c af 11 c0       	mov    0xc011af6c,%eax
c0101ed8:	89 02                	mov    %eax,(%edx)
    	}
        break;
c0101eda:	eb 3b                	jmp    c0101f17 <trap_dispatch+0x20a>
c0101edc:	eb 39                	jmp    c0101f17 <trap_dispatch+0x20a>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c0101ede:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ee1:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101ee5:	0f b7 c0             	movzwl %ax,%eax
c0101ee8:	83 e0 03             	and    $0x3,%eax
c0101eeb:	85 c0                	test   %eax,%eax
c0101eed:	75 28                	jne    c0101f17 <trap_dispatch+0x20a>
            print_trapframe(tf);
c0101eef:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ef2:	89 04 24             	mov    %eax,(%esp)
c0101ef5:	e8 97 fb ff ff       	call   c0101a91 <print_trapframe>
            panic("unexpected trap in kernel.\n");
c0101efa:	c7 44 24 08 4a 66 10 	movl   $0xc010664a,0x8(%esp)
c0101f01:	c0 
c0101f02:	c7 44 24 04 d7 00 00 	movl   $0xd7,0x4(%esp)
c0101f09:	00 
c0101f0a:	c7 04 24 6e 64 10 c0 	movl   $0xc010646e,(%esp)
c0101f11:	e8 de e4 ff ff       	call   c01003f4 <__panic>
        break;
c0101f16:	90                   	nop
        }
    }
}
c0101f17:	83 c4 2c             	add    $0x2c,%esp
c0101f1a:	5b                   	pop    %ebx
c0101f1b:	5e                   	pop    %esi
c0101f1c:	5f                   	pop    %edi
c0101f1d:	5d                   	pop    %ebp
c0101f1e:	c3                   	ret    

c0101f1f <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c0101f1f:	55                   	push   %ebp
c0101f20:	89 e5                	mov    %esp,%ebp
c0101f22:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c0101f25:	8b 45 08             	mov    0x8(%ebp),%eax
c0101f28:	89 04 24             	mov    %eax,(%esp)
c0101f2b:	e8 dd fd ff ff       	call   c0101d0d <trap_dispatch>
}
c0101f30:	c9                   	leave  
c0101f31:	c3                   	ret    

c0101f32 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0101f32:	6a 00                	push   $0x0
  pushl $0
c0101f34:	6a 00                	push   $0x0
  jmp __alltraps
c0101f36:	e9 69 0a 00 00       	jmp    c01029a4 <__alltraps>

c0101f3b <vector1>:
.globl vector1
vector1:
  pushl $0
c0101f3b:	6a 00                	push   $0x0
  pushl $1
c0101f3d:	6a 01                	push   $0x1
  jmp __alltraps
c0101f3f:	e9 60 0a 00 00       	jmp    c01029a4 <__alltraps>

c0101f44 <vector2>:
.globl vector2
vector2:
  pushl $0
c0101f44:	6a 00                	push   $0x0
  pushl $2
c0101f46:	6a 02                	push   $0x2
  jmp __alltraps
c0101f48:	e9 57 0a 00 00       	jmp    c01029a4 <__alltraps>

c0101f4d <vector3>:
.globl vector3
vector3:
  pushl $0
c0101f4d:	6a 00                	push   $0x0
  pushl $3
c0101f4f:	6a 03                	push   $0x3
  jmp __alltraps
c0101f51:	e9 4e 0a 00 00       	jmp    c01029a4 <__alltraps>

c0101f56 <vector4>:
.globl vector4
vector4:
  pushl $0
c0101f56:	6a 00                	push   $0x0
  pushl $4
c0101f58:	6a 04                	push   $0x4
  jmp __alltraps
c0101f5a:	e9 45 0a 00 00       	jmp    c01029a4 <__alltraps>

c0101f5f <vector5>:
.globl vector5
vector5:
  pushl $0
c0101f5f:	6a 00                	push   $0x0
  pushl $5
c0101f61:	6a 05                	push   $0x5
  jmp __alltraps
c0101f63:	e9 3c 0a 00 00       	jmp    c01029a4 <__alltraps>

c0101f68 <vector6>:
.globl vector6
vector6:
  pushl $0
c0101f68:	6a 00                	push   $0x0
  pushl $6
c0101f6a:	6a 06                	push   $0x6
  jmp __alltraps
c0101f6c:	e9 33 0a 00 00       	jmp    c01029a4 <__alltraps>

c0101f71 <vector7>:
.globl vector7
vector7:
  pushl $0
c0101f71:	6a 00                	push   $0x0
  pushl $7
c0101f73:	6a 07                	push   $0x7
  jmp __alltraps
c0101f75:	e9 2a 0a 00 00       	jmp    c01029a4 <__alltraps>

c0101f7a <vector8>:
.globl vector8
vector8:
  pushl $8
c0101f7a:	6a 08                	push   $0x8
  jmp __alltraps
c0101f7c:	e9 23 0a 00 00       	jmp    c01029a4 <__alltraps>

c0101f81 <vector9>:
.globl vector9
vector9:
  pushl $0
c0101f81:	6a 00                	push   $0x0
  pushl $9
c0101f83:	6a 09                	push   $0x9
  jmp __alltraps
c0101f85:	e9 1a 0a 00 00       	jmp    c01029a4 <__alltraps>

c0101f8a <vector10>:
.globl vector10
vector10:
  pushl $10
c0101f8a:	6a 0a                	push   $0xa
  jmp __alltraps
c0101f8c:	e9 13 0a 00 00       	jmp    c01029a4 <__alltraps>

c0101f91 <vector11>:
.globl vector11
vector11:
  pushl $11
c0101f91:	6a 0b                	push   $0xb
  jmp __alltraps
c0101f93:	e9 0c 0a 00 00       	jmp    c01029a4 <__alltraps>

c0101f98 <vector12>:
.globl vector12
vector12:
  pushl $12
c0101f98:	6a 0c                	push   $0xc
  jmp __alltraps
c0101f9a:	e9 05 0a 00 00       	jmp    c01029a4 <__alltraps>

c0101f9f <vector13>:
.globl vector13
vector13:
  pushl $13
c0101f9f:	6a 0d                	push   $0xd
  jmp __alltraps
c0101fa1:	e9 fe 09 00 00       	jmp    c01029a4 <__alltraps>

c0101fa6 <vector14>:
.globl vector14
vector14:
  pushl $14
c0101fa6:	6a 0e                	push   $0xe
  jmp __alltraps
c0101fa8:	e9 f7 09 00 00       	jmp    c01029a4 <__alltraps>

c0101fad <vector15>:
.globl vector15
vector15:
  pushl $0
c0101fad:	6a 00                	push   $0x0
  pushl $15
c0101faf:	6a 0f                	push   $0xf
  jmp __alltraps
c0101fb1:	e9 ee 09 00 00       	jmp    c01029a4 <__alltraps>

c0101fb6 <vector16>:
.globl vector16
vector16:
  pushl $0
c0101fb6:	6a 00                	push   $0x0
  pushl $16
c0101fb8:	6a 10                	push   $0x10
  jmp __alltraps
c0101fba:	e9 e5 09 00 00       	jmp    c01029a4 <__alltraps>

c0101fbf <vector17>:
.globl vector17
vector17:
  pushl $17
c0101fbf:	6a 11                	push   $0x11
  jmp __alltraps
c0101fc1:	e9 de 09 00 00       	jmp    c01029a4 <__alltraps>

c0101fc6 <vector18>:
.globl vector18
vector18:
  pushl $0
c0101fc6:	6a 00                	push   $0x0
  pushl $18
c0101fc8:	6a 12                	push   $0x12
  jmp __alltraps
c0101fca:	e9 d5 09 00 00       	jmp    c01029a4 <__alltraps>

c0101fcf <vector19>:
.globl vector19
vector19:
  pushl $0
c0101fcf:	6a 00                	push   $0x0
  pushl $19
c0101fd1:	6a 13                	push   $0x13
  jmp __alltraps
c0101fd3:	e9 cc 09 00 00       	jmp    c01029a4 <__alltraps>

c0101fd8 <vector20>:
.globl vector20
vector20:
  pushl $0
c0101fd8:	6a 00                	push   $0x0
  pushl $20
c0101fda:	6a 14                	push   $0x14
  jmp __alltraps
c0101fdc:	e9 c3 09 00 00       	jmp    c01029a4 <__alltraps>

c0101fe1 <vector21>:
.globl vector21
vector21:
  pushl $0
c0101fe1:	6a 00                	push   $0x0
  pushl $21
c0101fe3:	6a 15                	push   $0x15
  jmp __alltraps
c0101fe5:	e9 ba 09 00 00       	jmp    c01029a4 <__alltraps>

c0101fea <vector22>:
.globl vector22
vector22:
  pushl $0
c0101fea:	6a 00                	push   $0x0
  pushl $22
c0101fec:	6a 16                	push   $0x16
  jmp __alltraps
c0101fee:	e9 b1 09 00 00       	jmp    c01029a4 <__alltraps>

c0101ff3 <vector23>:
.globl vector23
vector23:
  pushl $0
c0101ff3:	6a 00                	push   $0x0
  pushl $23
c0101ff5:	6a 17                	push   $0x17
  jmp __alltraps
c0101ff7:	e9 a8 09 00 00       	jmp    c01029a4 <__alltraps>

c0101ffc <vector24>:
.globl vector24
vector24:
  pushl $0
c0101ffc:	6a 00                	push   $0x0
  pushl $24
c0101ffe:	6a 18                	push   $0x18
  jmp __alltraps
c0102000:	e9 9f 09 00 00       	jmp    c01029a4 <__alltraps>

c0102005 <vector25>:
.globl vector25
vector25:
  pushl $0
c0102005:	6a 00                	push   $0x0
  pushl $25
c0102007:	6a 19                	push   $0x19
  jmp __alltraps
c0102009:	e9 96 09 00 00       	jmp    c01029a4 <__alltraps>

c010200e <vector26>:
.globl vector26
vector26:
  pushl $0
c010200e:	6a 00                	push   $0x0
  pushl $26
c0102010:	6a 1a                	push   $0x1a
  jmp __alltraps
c0102012:	e9 8d 09 00 00       	jmp    c01029a4 <__alltraps>

c0102017 <vector27>:
.globl vector27
vector27:
  pushl $0
c0102017:	6a 00                	push   $0x0
  pushl $27
c0102019:	6a 1b                	push   $0x1b
  jmp __alltraps
c010201b:	e9 84 09 00 00       	jmp    c01029a4 <__alltraps>

c0102020 <vector28>:
.globl vector28
vector28:
  pushl $0
c0102020:	6a 00                	push   $0x0
  pushl $28
c0102022:	6a 1c                	push   $0x1c
  jmp __alltraps
c0102024:	e9 7b 09 00 00       	jmp    c01029a4 <__alltraps>

c0102029 <vector29>:
.globl vector29
vector29:
  pushl $0
c0102029:	6a 00                	push   $0x0
  pushl $29
c010202b:	6a 1d                	push   $0x1d
  jmp __alltraps
c010202d:	e9 72 09 00 00       	jmp    c01029a4 <__alltraps>

c0102032 <vector30>:
.globl vector30
vector30:
  pushl $0
c0102032:	6a 00                	push   $0x0
  pushl $30
c0102034:	6a 1e                	push   $0x1e
  jmp __alltraps
c0102036:	e9 69 09 00 00       	jmp    c01029a4 <__alltraps>

c010203b <vector31>:
.globl vector31
vector31:
  pushl $0
c010203b:	6a 00                	push   $0x0
  pushl $31
c010203d:	6a 1f                	push   $0x1f
  jmp __alltraps
c010203f:	e9 60 09 00 00       	jmp    c01029a4 <__alltraps>

c0102044 <vector32>:
.globl vector32
vector32:
  pushl $0
c0102044:	6a 00                	push   $0x0
  pushl $32
c0102046:	6a 20                	push   $0x20
  jmp __alltraps
c0102048:	e9 57 09 00 00       	jmp    c01029a4 <__alltraps>

c010204d <vector33>:
.globl vector33
vector33:
  pushl $0
c010204d:	6a 00                	push   $0x0
  pushl $33
c010204f:	6a 21                	push   $0x21
  jmp __alltraps
c0102051:	e9 4e 09 00 00       	jmp    c01029a4 <__alltraps>

c0102056 <vector34>:
.globl vector34
vector34:
  pushl $0
c0102056:	6a 00                	push   $0x0
  pushl $34
c0102058:	6a 22                	push   $0x22
  jmp __alltraps
c010205a:	e9 45 09 00 00       	jmp    c01029a4 <__alltraps>

c010205f <vector35>:
.globl vector35
vector35:
  pushl $0
c010205f:	6a 00                	push   $0x0
  pushl $35
c0102061:	6a 23                	push   $0x23
  jmp __alltraps
c0102063:	e9 3c 09 00 00       	jmp    c01029a4 <__alltraps>

c0102068 <vector36>:
.globl vector36
vector36:
  pushl $0
c0102068:	6a 00                	push   $0x0
  pushl $36
c010206a:	6a 24                	push   $0x24
  jmp __alltraps
c010206c:	e9 33 09 00 00       	jmp    c01029a4 <__alltraps>

c0102071 <vector37>:
.globl vector37
vector37:
  pushl $0
c0102071:	6a 00                	push   $0x0
  pushl $37
c0102073:	6a 25                	push   $0x25
  jmp __alltraps
c0102075:	e9 2a 09 00 00       	jmp    c01029a4 <__alltraps>

c010207a <vector38>:
.globl vector38
vector38:
  pushl $0
c010207a:	6a 00                	push   $0x0
  pushl $38
c010207c:	6a 26                	push   $0x26
  jmp __alltraps
c010207e:	e9 21 09 00 00       	jmp    c01029a4 <__alltraps>

c0102083 <vector39>:
.globl vector39
vector39:
  pushl $0
c0102083:	6a 00                	push   $0x0
  pushl $39
c0102085:	6a 27                	push   $0x27
  jmp __alltraps
c0102087:	e9 18 09 00 00       	jmp    c01029a4 <__alltraps>

c010208c <vector40>:
.globl vector40
vector40:
  pushl $0
c010208c:	6a 00                	push   $0x0
  pushl $40
c010208e:	6a 28                	push   $0x28
  jmp __alltraps
c0102090:	e9 0f 09 00 00       	jmp    c01029a4 <__alltraps>

c0102095 <vector41>:
.globl vector41
vector41:
  pushl $0
c0102095:	6a 00                	push   $0x0
  pushl $41
c0102097:	6a 29                	push   $0x29
  jmp __alltraps
c0102099:	e9 06 09 00 00       	jmp    c01029a4 <__alltraps>

c010209e <vector42>:
.globl vector42
vector42:
  pushl $0
c010209e:	6a 00                	push   $0x0
  pushl $42
c01020a0:	6a 2a                	push   $0x2a
  jmp __alltraps
c01020a2:	e9 fd 08 00 00       	jmp    c01029a4 <__alltraps>

c01020a7 <vector43>:
.globl vector43
vector43:
  pushl $0
c01020a7:	6a 00                	push   $0x0
  pushl $43
c01020a9:	6a 2b                	push   $0x2b
  jmp __alltraps
c01020ab:	e9 f4 08 00 00       	jmp    c01029a4 <__alltraps>

c01020b0 <vector44>:
.globl vector44
vector44:
  pushl $0
c01020b0:	6a 00                	push   $0x0
  pushl $44
c01020b2:	6a 2c                	push   $0x2c
  jmp __alltraps
c01020b4:	e9 eb 08 00 00       	jmp    c01029a4 <__alltraps>

c01020b9 <vector45>:
.globl vector45
vector45:
  pushl $0
c01020b9:	6a 00                	push   $0x0
  pushl $45
c01020bb:	6a 2d                	push   $0x2d
  jmp __alltraps
c01020bd:	e9 e2 08 00 00       	jmp    c01029a4 <__alltraps>

c01020c2 <vector46>:
.globl vector46
vector46:
  pushl $0
c01020c2:	6a 00                	push   $0x0
  pushl $46
c01020c4:	6a 2e                	push   $0x2e
  jmp __alltraps
c01020c6:	e9 d9 08 00 00       	jmp    c01029a4 <__alltraps>

c01020cb <vector47>:
.globl vector47
vector47:
  pushl $0
c01020cb:	6a 00                	push   $0x0
  pushl $47
c01020cd:	6a 2f                	push   $0x2f
  jmp __alltraps
c01020cf:	e9 d0 08 00 00       	jmp    c01029a4 <__alltraps>

c01020d4 <vector48>:
.globl vector48
vector48:
  pushl $0
c01020d4:	6a 00                	push   $0x0
  pushl $48
c01020d6:	6a 30                	push   $0x30
  jmp __alltraps
c01020d8:	e9 c7 08 00 00       	jmp    c01029a4 <__alltraps>

c01020dd <vector49>:
.globl vector49
vector49:
  pushl $0
c01020dd:	6a 00                	push   $0x0
  pushl $49
c01020df:	6a 31                	push   $0x31
  jmp __alltraps
c01020e1:	e9 be 08 00 00       	jmp    c01029a4 <__alltraps>

c01020e6 <vector50>:
.globl vector50
vector50:
  pushl $0
c01020e6:	6a 00                	push   $0x0
  pushl $50
c01020e8:	6a 32                	push   $0x32
  jmp __alltraps
c01020ea:	e9 b5 08 00 00       	jmp    c01029a4 <__alltraps>

c01020ef <vector51>:
.globl vector51
vector51:
  pushl $0
c01020ef:	6a 00                	push   $0x0
  pushl $51
c01020f1:	6a 33                	push   $0x33
  jmp __alltraps
c01020f3:	e9 ac 08 00 00       	jmp    c01029a4 <__alltraps>

c01020f8 <vector52>:
.globl vector52
vector52:
  pushl $0
c01020f8:	6a 00                	push   $0x0
  pushl $52
c01020fa:	6a 34                	push   $0x34
  jmp __alltraps
c01020fc:	e9 a3 08 00 00       	jmp    c01029a4 <__alltraps>

c0102101 <vector53>:
.globl vector53
vector53:
  pushl $0
c0102101:	6a 00                	push   $0x0
  pushl $53
c0102103:	6a 35                	push   $0x35
  jmp __alltraps
c0102105:	e9 9a 08 00 00       	jmp    c01029a4 <__alltraps>

c010210a <vector54>:
.globl vector54
vector54:
  pushl $0
c010210a:	6a 00                	push   $0x0
  pushl $54
c010210c:	6a 36                	push   $0x36
  jmp __alltraps
c010210e:	e9 91 08 00 00       	jmp    c01029a4 <__alltraps>

c0102113 <vector55>:
.globl vector55
vector55:
  pushl $0
c0102113:	6a 00                	push   $0x0
  pushl $55
c0102115:	6a 37                	push   $0x37
  jmp __alltraps
c0102117:	e9 88 08 00 00       	jmp    c01029a4 <__alltraps>

c010211c <vector56>:
.globl vector56
vector56:
  pushl $0
c010211c:	6a 00                	push   $0x0
  pushl $56
c010211e:	6a 38                	push   $0x38
  jmp __alltraps
c0102120:	e9 7f 08 00 00       	jmp    c01029a4 <__alltraps>

c0102125 <vector57>:
.globl vector57
vector57:
  pushl $0
c0102125:	6a 00                	push   $0x0
  pushl $57
c0102127:	6a 39                	push   $0x39
  jmp __alltraps
c0102129:	e9 76 08 00 00       	jmp    c01029a4 <__alltraps>

c010212e <vector58>:
.globl vector58
vector58:
  pushl $0
c010212e:	6a 00                	push   $0x0
  pushl $58
c0102130:	6a 3a                	push   $0x3a
  jmp __alltraps
c0102132:	e9 6d 08 00 00       	jmp    c01029a4 <__alltraps>

c0102137 <vector59>:
.globl vector59
vector59:
  pushl $0
c0102137:	6a 00                	push   $0x0
  pushl $59
c0102139:	6a 3b                	push   $0x3b
  jmp __alltraps
c010213b:	e9 64 08 00 00       	jmp    c01029a4 <__alltraps>

c0102140 <vector60>:
.globl vector60
vector60:
  pushl $0
c0102140:	6a 00                	push   $0x0
  pushl $60
c0102142:	6a 3c                	push   $0x3c
  jmp __alltraps
c0102144:	e9 5b 08 00 00       	jmp    c01029a4 <__alltraps>

c0102149 <vector61>:
.globl vector61
vector61:
  pushl $0
c0102149:	6a 00                	push   $0x0
  pushl $61
c010214b:	6a 3d                	push   $0x3d
  jmp __alltraps
c010214d:	e9 52 08 00 00       	jmp    c01029a4 <__alltraps>

c0102152 <vector62>:
.globl vector62
vector62:
  pushl $0
c0102152:	6a 00                	push   $0x0
  pushl $62
c0102154:	6a 3e                	push   $0x3e
  jmp __alltraps
c0102156:	e9 49 08 00 00       	jmp    c01029a4 <__alltraps>

c010215b <vector63>:
.globl vector63
vector63:
  pushl $0
c010215b:	6a 00                	push   $0x0
  pushl $63
c010215d:	6a 3f                	push   $0x3f
  jmp __alltraps
c010215f:	e9 40 08 00 00       	jmp    c01029a4 <__alltraps>

c0102164 <vector64>:
.globl vector64
vector64:
  pushl $0
c0102164:	6a 00                	push   $0x0
  pushl $64
c0102166:	6a 40                	push   $0x40
  jmp __alltraps
c0102168:	e9 37 08 00 00       	jmp    c01029a4 <__alltraps>

c010216d <vector65>:
.globl vector65
vector65:
  pushl $0
c010216d:	6a 00                	push   $0x0
  pushl $65
c010216f:	6a 41                	push   $0x41
  jmp __alltraps
c0102171:	e9 2e 08 00 00       	jmp    c01029a4 <__alltraps>

c0102176 <vector66>:
.globl vector66
vector66:
  pushl $0
c0102176:	6a 00                	push   $0x0
  pushl $66
c0102178:	6a 42                	push   $0x42
  jmp __alltraps
c010217a:	e9 25 08 00 00       	jmp    c01029a4 <__alltraps>

c010217f <vector67>:
.globl vector67
vector67:
  pushl $0
c010217f:	6a 00                	push   $0x0
  pushl $67
c0102181:	6a 43                	push   $0x43
  jmp __alltraps
c0102183:	e9 1c 08 00 00       	jmp    c01029a4 <__alltraps>

c0102188 <vector68>:
.globl vector68
vector68:
  pushl $0
c0102188:	6a 00                	push   $0x0
  pushl $68
c010218a:	6a 44                	push   $0x44
  jmp __alltraps
c010218c:	e9 13 08 00 00       	jmp    c01029a4 <__alltraps>

c0102191 <vector69>:
.globl vector69
vector69:
  pushl $0
c0102191:	6a 00                	push   $0x0
  pushl $69
c0102193:	6a 45                	push   $0x45
  jmp __alltraps
c0102195:	e9 0a 08 00 00       	jmp    c01029a4 <__alltraps>

c010219a <vector70>:
.globl vector70
vector70:
  pushl $0
c010219a:	6a 00                	push   $0x0
  pushl $70
c010219c:	6a 46                	push   $0x46
  jmp __alltraps
c010219e:	e9 01 08 00 00       	jmp    c01029a4 <__alltraps>

c01021a3 <vector71>:
.globl vector71
vector71:
  pushl $0
c01021a3:	6a 00                	push   $0x0
  pushl $71
c01021a5:	6a 47                	push   $0x47
  jmp __alltraps
c01021a7:	e9 f8 07 00 00       	jmp    c01029a4 <__alltraps>

c01021ac <vector72>:
.globl vector72
vector72:
  pushl $0
c01021ac:	6a 00                	push   $0x0
  pushl $72
c01021ae:	6a 48                	push   $0x48
  jmp __alltraps
c01021b0:	e9 ef 07 00 00       	jmp    c01029a4 <__alltraps>

c01021b5 <vector73>:
.globl vector73
vector73:
  pushl $0
c01021b5:	6a 00                	push   $0x0
  pushl $73
c01021b7:	6a 49                	push   $0x49
  jmp __alltraps
c01021b9:	e9 e6 07 00 00       	jmp    c01029a4 <__alltraps>

c01021be <vector74>:
.globl vector74
vector74:
  pushl $0
c01021be:	6a 00                	push   $0x0
  pushl $74
c01021c0:	6a 4a                	push   $0x4a
  jmp __alltraps
c01021c2:	e9 dd 07 00 00       	jmp    c01029a4 <__alltraps>

c01021c7 <vector75>:
.globl vector75
vector75:
  pushl $0
c01021c7:	6a 00                	push   $0x0
  pushl $75
c01021c9:	6a 4b                	push   $0x4b
  jmp __alltraps
c01021cb:	e9 d4 07 00 00       	jmp    c01029a4 <__alltraps>

c01021d0 <vector76>:
.globl vector76
vector76:
  pushl $0
c01021d0:	6a 00                	push   $0x0
  pushl $76
c01021d2:	6a 4c                	push   $0x4c
  jmp __alltraps
c01021d4:	e9 cb 07 00 00       	jmp    c01029a4 <__alltraps>

c01021d9 <vector77>:
.globl vector77
vector77:
  pushl $0
c01021d9:	6a 00                	push   $0x0
  pushl $77
c01021db:	6a 4d                	push   $0x4d
  jmp __alltraps
c01021dd:	e9 c2 07 00 00       	jmp    c01029a4 <__alltraps>

c01021e2 <vector78>:
.globl vector78
vector78:
  pushl $0
c01021e2:	6a 00                	push   $0x0
  pushl $78
c01021e4:	6a 4e                	push   $0x4e
  jmp __alltraps
c01021e6:	e9 b9 07 00 00       	jmp    c01029a4 <__alltraps>

c01021eb <vector79>:
.globl vector79
vector79:
  pushl $0
c01021eb:	6a 00                	push   $0x0
  pushl $79
c01021ed:	6a 4f                	push   $0x4f
  jmp __alltraps
c01021ef:	e9 b0 07 00 00       	jmp    c01029a4 <__alltraps>

c01021f4 <vector80>:
.globl vector80
vector80:
  pushl $0
c01021f4:	6a 00                	push   $0x0
  pushl $80
c01021f6:	6a 50                	push   $0x50
  jmp __alltraps
c01021f8:	e9 a7 07 00 00       	jmp    c01029a4 <__alltraps>

c01021fd <vector81>:
.globl vector81
vector81:
  pushl $0
c01021fd:	6a 00                	push   $0x0
  pushl $81
c01021ff:	6a 51                	push   $0x51
  jmp __alltraps
c0102201:	e9 9e 07 00 00       	jmp    c01029a4 <__alltraps>

c0102206 <vector82>:
.globl vector82
vector82:
  pushl $0
c0102206:	6a 00                	push   $0x0
  pushl $82
c0102208:	6a 52                	push   $0x52
  jmp __alltraps
c010220a:	e9 95 07 00 00       	jmp    c01029a4 <__alltraps>

c010220f <vector83>:
.globl vector83
vector83:
  pushl $0
c010220f:	6a 00                	push   $0x0
  pushl $83
c0102211:	6a 53                	push   $0x53
  jmp __alltraps
c0102213:	e9 8c 07 00 00       	jmp    c01029a4 <__alltraps>

c0102218 <vector84>:
.globl vector84
vector84:
  pushl $0
c0102218:	6a 00                	push   $0x0
  pushl $84
c010221a:	6a 54                	push   $0x54
  jmp __alltraps
c010221c:	e9 83 07 00 00       	jmp    c01029a4 <__alltraps>

c0102221 <vector85>:
.globl vector85
vector85:
  pushl $0
c0102221:	6a 00                	push   $0x0
  pushl $85
c0102223:	6a 55                	push   $0x55
  jmp __alltraps
c0102225:	e9 7a 07 00 00       	jmp    c01029a4 <__alltraps>

c010222a <vector86>:
.globl vector86
vector86:
  pushl $0
c010222a:	6a 00                	push   $0x0
  pushl $86
c010222c:	6a 56                	push   $0x56
  jmp __alltraps
c010222e:	e9 71 07 00 00       	jmp    c01029a4 <__alltraps>

c0102233 <vector87>:
.globl vector87
vector87:
  pushl $0
c0102233:	6a 00                	push   $0x0
  pushl $87
c0102235:	6a 57                	push   $0x57
  jmp __alltraps
c0102237:	e9 68 07 00 00       	jmp    c01029a4 <__alltraps>

c010223c <vector88>:
.globl vector88
vector88:
  pushl $0
c010223c:	6a 00                	push   $0x0
  pushl $88
c010223e:	6a 58                	push   $0x58
  jmp __alltraps
c0102240:	e9 5f 07 00 00       	jmp    c01029a4 <__alltraps>

c0102245 <vector89>:
.globl vector89
vector89:
  pushl $0
c0102245:	6a 00                	push   $0x0
  pushl $89
c0102247:	6a 59                	push   $0x59
  jmp __alltraps
c0102249:	e9 56 07 00 00       	jmp    c01029a4 <__alltraps>

c010224e <vector90>:
.globl vector90
vector90:
  pushl $0
c010224e:	6a 00                	push   $0x0
  pushl $90
c0102250:	6a 5a                	push   $0x5a
  jmp __alltraps
c0102252:	e9 4d 07 00 00       	jmp    c01029a4 <__alltraps>

c0102257 <vector91>:
.globl vector91
vector91:
  pushl $0
c0102257:	6a 00                	push   $0x0
  pushl $91
c0102259:	6a 5b                	push   $0x5b
  jmp __alltraps
c010225b:	e9 44 07 00 00       	jmp    c01029a4 <__alltraps>

c0102260 <vector92>:
.globl vector92
vector92:
  pushl $0
c0102260:	6a 00                	push   $0x0
  pushl $92
c0102262:	6a 5c                	push   $0x5c
  jmp __alltraps
c0102264:	e9 3b 07 00 00       	jmp    c01029a4 <__alltraps>

c0102269 <vector93>:
.globl vector93
vector93:
  pushl $0
c0102269:	6a 00                	push   $0x0
  pushl $93
c010226b:	6a 5d                	push   $0x5d
  jmp __alltraps
c010226d:	e9 32 07 00 00       	jmp    c01029a4 <__alltraps>

c0102272 <vector94>:
.globl vector94
vector94:
  pushl $0
c0102272:	6a 00                	push   $0x0
  pushl $94
c0102274:	6a 5e                	push   $0x5e
  jmp __alltraps
c0102276:	e9 29 07 00 00       	jmp    c01029a4 <__alltraps>

c010227b <vector95>:
.globl vector95
vector95:
  pushl $0
c010227b:	6a 00                	push   $0x0
  pushl $95
c010227d:	6a 5f                	push   $0x5f
  jmp __alltraps
c010227f:	e9 20 07 00 00       	jmp    c01029a4 <__alltraps>

c0102284 <vector96>:
.globl vector96
vector96:
  pushl $0
c0102284:	6a 00                	push   $0x0
  pushl $96
c0102286:	6a 60                	push   $0x60
  jmp __alltraps
c0102288:	e9 17 07 00 00       	jmp    c01029a4 <__alltraps>

c010228d <vector97>:
.globl vector97
vector97:
  pushl $0
c010228d:	6a 00                	push   $0x0
  pushl $97
c010228f:	6a 61                	push   $0x61
  jmp __alltraps
c0102291:	e9 0e 07 00 00       	jmp    c01029a4 <__alltraps>

c0102296 <vector98>:
.globl vector98
vector98:
  pushl $0
c0102296:	6a 00                	push   $0x0
  pushl $98
c0102298:	6a 62                	push   $0x62
  jmp __alltraps
c010229a:	e9 05 07 00 00       	jmp    c01029a4 <__alltraps>

c010229f <vector99>:
.globl vector99
vector99:
  pushl $0
c010229f:	6a 00                	push   $0x0
  pushl $99
c01022a1:	6a 63                	push   $0x63
  jmp __alltraps
c01022a3:	e9 fc 06 00 00       	jmp    c01029a4 <__alltraps>

c01022a8 <vector100>:
.globl vector100
vector100:
  pushl $0
c01022a8:	6a 00                	push   $0x0
  pushl $100
c01022aa:	6a 64                	push   $0x64
  jmp __alltraps
c01022ac:	e9 f3 06 00 00       	jmp    c01029a4 <__alltraps>

c01022b1 <vector101>:
.globl vector101
vector101:
  pushl $0
c01022b1:	6a 00                	push   $0x0
  pushl $101
c01022b3:	6a 65                	push   $0x65
  jmp __alltraps
c01022b5:	e9 ea 06 00 00       	jmp    c01029a4 <__alltraps>

c01022ba <vector102>:
.globl vector102
vector102:
  pushl $0
c01022ba:	6a 00                	push   $0x0
  pushl $102
c01022bc:	6a 66                	push   $0x66
  jmp __alltraps
c01022be:	e9 e1 06 00 00       	jmp    c01029a4 <__alltraps>

c01022c3 <vector103>:
.globl vector103
vector103:
  pushl $0
c01022c3:	6a 00                	push   $0x0
  pushl $103
c01022c5:	6a 67                	push   $0x67
  jmp __alltraps
c01022c7:	e9 d8 06 00 00       	jmp    c01029a4 <__alltraps>

c01022cc <vector104>:
.globl vector104
vector104:
  pushl $0
c01022cc:	6a 00                	push   $0x0
  pushl $104
c01022ce:	6a 68                	push   $0x68
  jmp __alltraps
c01022d0:	e9 cf 06 00 00       	jmp    c01029a4 <__alltraps>

c01022d5 <vector105>:
.globl vector105
vector105:
  pushl $0
c01022d5:	6a 00                	push   $0x0
  pushl $105
c01022d7:	6a 69                	push   $0x69
  jmp __alltraps
c01022d9:	e9 c6 06 00 00       	jmp    c01029a4 <__alltraps>

c01022de <vector106>:
.globl vector106
vector106:
  pushl $0
c01022de:	6a 00                	push   $0x0
  pushl $106
c01022e0:	6a 6a                	push   $0x6a
  jmp __alltraps
c01022e2:	e9 bd 06 00 00       	jmp    c01029a4 <__alltraps>

c01022e7 <vector107>:
.globl vector107
vector107:
  pushl $0
c01022e7:	6a 00                	push   $0x0
  pushl $107
c01022e9:	6a 6b                	push   $0x6b
  jmp __alltraps
c01022eb:	e9 b4 06 00 00       	jmp    c01029a4 <__alltraps>

c01022f0 <vector108>:
.globl vector108
vector108:
  pushl $0
c01022f0:	6a 00                	push   $0x0
  pushl $108
c01022f2:	6a 6c                	push   $0x6c
  jmp __alltraps
c01022f4:	e9 ab 06 00 00       	jmp    c01029a4 <__alltraps>

c01022f9 <vector109>:
.globl vector109
vector109:
  pushl $0
c01022f9:	6a 00                	push   $0x0
  pushl $109
c01022fb:	6a 6d                	push   $0x6d
  jmp __alltraps
c01022fd:	e9 a2 06 00 00       	jmp    c01029a4 <__alltraps>

c0102302 <vector110>:
.globl vector110
vector110:
  pushl $0
c0102302:	6a 00                	push   $0x0
  pushl $110
c0102304:	6a 6e                	push   $0x6e
  jmp __alltraps
c0102306:	e9 99 06 00 00       	jmp    c01029a4 <__alltraps>

c010230b <vector111>:
.globl vector111
vector111:
  pushl $0
c010230b:	6a 00                	push   $0x0
  pushl $111
c010230d:	6a 6f                	push   $0x6f
  jmp __alltraps
c010230f:	e9 90 06 00 00       	jmp    c01029a4 <__alltraps>

c0102314 <vector112>:
.globl vector112
vector112:
  pushl $0
c0102314:	6a 00                	push   $0x0
  pushl $112
c0102316:	6a 70                	push   $0x70
  jmp __alltraps
c0102318:	e9 87 06 00 00       	jmp    c01029a4 <__alltraps>

c010231d <vector113>:
.globl vector113
vector113:
  pushl $0
c010231d:	6a 00                	push   $0x0
  pushl $113
c010231f:	6a 71                	push   $0x71
  jmp __alltraps
c0102321:	e9 7e 06 00 00       	jmp    c01029a4 <__alltraps>

c0102326 <vector114>:
.globl vector114
vector114:
  pushl $0
c0102326:	6a 00                	push   $0x0
  pushl $114
c0102328:	6a 72                	push   $0x72
  jmp __alltraps
c010232a:	e9 75 06 00 00       	jmp    c01029a4 <__alltraps>

c010232f <vector115>:
.globl vector115
vector115:
  pushl $0
c010232f:	6a 00                	push   $0x0
  pushl $115
c0102331:	6a 73                	push   $0x73
  jmp __alltraps
c0102333:	e9 6c 06 00 00       	jmp    c01029a4 <__alltraps>

c0102338 <vector116>:
.globl vector116
vector116:
  pushl $0
c0102338:	6a 00                	push   $0x0
  pushl $116
c010233a:	6a 74                	push   $0x74
  jmp __alltraps
c010233c:	e9 63 06 00 00       	jmp    c01029a4 <__alltraps>

c0102341 <vector117>:
.globl vector117
vector117:
  pushl $0
c0102341:	6a 00                	push   $0x0
  pushl $117
c0102343:	6a 75                	push   $0x75
  jmp __alltraps
c0102345:	e9 5a 06 00 00       	jmp    c01029a4 <__alltraps>

c010234a <vector118>:
.globl vector118
vector118:
  pushl $0
c010234a:	6a 00                	push   $0x0
  pushl $118
c010234c:	6a 76                	push   $0x76
  jmp __alltraps
c010234e:	e9 51 06 00 00       	jmp    c01029a4 <__alltraps>

c0102353 <vector119>:
.globl vector119
vector119:
  pushl $0
c0102353:	6a 00                	push   $0x0
  pushl $119
c0102355:	6a 77                	push   $0x77
  jmp __alltraps
c0102357:	e9 48 06 00 00       	jmp    c01029a4 <__alltraps>

c010235c <vector120>:
.globl vector120
vector120:
  pushl $0
c010235c:	6a 00                	push   $0x0
  pushl $120
c010235e:	6a 78                	push   $0x78
  jmp __alltraps
c0102360:	e9 3f 06 00 00       	jmp    c01029a4 <__alltraps>

c0102365 <vector121>:
.globl vector121
vector121:
  pushl $0
c0102365:	6a 00                	push   $0x0
  pushl $121
c0102367:	6a 79                	push   $0x79
  jmp __alltraps
c0102369:	e9 36 06 00 00       	jmp    c01029a4 <__alltraps>

c010236e <vector122>:
.globl vector122
vector122:
  pushl $0
c010236e:	6a 00                	push   $0x0
  pushl $122
c0102370:	6a 7a                	push   $0x7a
  jmp __alltraps
c0102372:	e9 2d 06 00 00       	jmp    c01029a4 <__alltraps>

c0102377 <vector123>:
.globl vector123
vector123:
  pushl $0
c0102377:	6a 00                	push   $0x0
  pushl $123
c0102379:	6a 7b                	push   $0x7b
  jmp __alltraps
c010237b:	e9 24 06 00 00       	jmp    c01029a4 <__alltraps>

c0102380 <vector124>:
.globl vector124
vector124:
  pushl $0
c0102380:	6a 00                	push   $0x0
  pushl $124
c0102382:	6a 7c                	push   $0x7c
  jmp __alltraps
c0102384:	e9 1b 06 00 00       	jmp    c01029a4 <__alltraps>

c0102389 <vector125>:
.globl vector125
vector125:
  pushl $0
c0102389:	6a 00                	push   $0x0
  pushl $125
c010238b:	6a 7d                	push   $0x7d
  jmp __alltraps
c010238d:	e9 12 06 00 00       	jmp    c01029a4 <__alltraps>

c0102392 <vector126>:
.globl vector126
vector126:
  pushl $0
c0102392:	6a 00                	push   $0x0
  pushl $126
c0102394:	6a 7e                	push   $0x7e
  jmp __alltraps
c0102396:	e9 09 06 00 00       	jmp    c01029a4 <__alltraps>

c010239b <vector127>:
.globl vector127
vector127:
  pushl $0
c010239b:	6a 00                	push   $0x0
  pushl $127
c010239d:	6a 7f                	push   $0x7f
  jmp __alltraps
c010239f:	e9 00 06 00 00       	jmp    c01029a4 <__alltraps>

c01023a4 <vector128>:
.globl vector128
vector128:
  pushl $0
c01023a4:	6a 00                	push   $0x0
  pushl $128
c01023a6:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c01023ab:	e9 f4 05 00 00       	jmp    c01029a4 <__alltraps>

c01023b0 <vector129>:
.globl vector129
vector129:
  pushl $0
c01023b0:	6a 00                	push   $0x0
  pushl $129
c01023b2:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c01023b7:	e9 e8 05 00 00       	jmp    c01029a4 <__alltraps>

c01023bc <vector130>:
.globl vector130
vector130:
  pushl $0
c01023bc:	6a 00                	push   $0x0
  pushl $130
c01023be:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c01023c3:	e9 dc 05 00 00       	jmp    c01029a4 <__alltraps>

c01023c8 <vector131>:
.globl vector131
vector131:
  pushl $0
c01023c8:	6a 00                	push   $0x0
  pushl $131
c01023ca:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c01023cf:	e9 d0 05 00 00       	jmp    c01029a4 <__alltraps>

c01023d4 <vector132>:
.globl vector132
vector132:
  pushl $0
c01023d4:	6a 00                	push   $0x0
  pushl $132
c01023d6:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c01023db:	e9 c4 05 00 00       	jmp    c01029a4 <__alltraps>

c01023e0 <vector133>:
.globl vector133
vector133:
  pushl $0
c01023e0:	6a 00                	push   $0x0
  pushl $133
c01023e2:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c01023e7:	e9 b8 05 00 00       	jmp    c01029a4 <__alltraps>

c01023ec <vector134>:
.globl vector134
vector134:
  pushl $0
c01023ec:	6a 00                	push   $0x0
  pushl $134
c01023ee:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c01023f3:	e9 ac 05 00 00       	jmp    c01029a4 <__alltraps>

c01023f8 <vector135>:
.globl vector135
vector135:
  pushl $0
c01023f8:	6a 00                	push   $0x0
  pushl $135
c01023fa:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c01023ff:	e9 a0 05 00 00       	jmp    c01029a4 <__alltraps>

c0102404 <vector136>:
.globl vector136
vector136:
  pushl $0
c0102404:	6a 00                	push   $0x0
  pushl $136
c0102406:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c010240b:	e9 94 05 00 00       	jmp    c01029a4 <__alltraps>

c0102410 <vector137>:
.globl vector137
vector137:
  pushl $0
c0102410:	6a 00                	push   $0x0
  pushl $137
c0102412:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c0102417:	e9 88 05 00 00       	jmp    c01029a4 <__alltraps>

c010241c <vector138>:
.globl vector138
vector138:
  pushl $0
c010241c:	6a 00                	push   $0x0
  pushl $138
c010241e:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c0102423:	e9 7c 05 00 00       	jmp    c01029a4 <__alltraps>

c0102428 <vector139>:
.globl vector139
vector139:
  pushl $0
c0102428:	6a 00                	push   $0x0
  pushl $139
c010242a:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c010242f:	e9 70 05 00 00       	jmp    c01029a4 <__alltraps>

c0102434 <vector140>:
.globl vector140
vector140:
  pushl $0
c0102434:	6a 00                	push   $0x0
  pushl $140
c0102436:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c010243b:	e9 64 05 00 00       	jmp    c01029a4 <__alltraps>

c0102440 <vector141>:
.globl vector141
vector141:
  pushl $0
c0102440:	6a 00                	push   $0x0
  pushl $141
c0102442:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c0102447:	e9 58 05 00 00       	jmp    c01029a4 <__alltraps>

c010244c <vector142>:
.globl vector142
vector142:
  pushl $0
c010244c:	6a 00                	push   $0x0
  pushl $142
c010244e:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c0102453:	e9 4c 05 00 00       	jmp    c01029a4 <__alltraps>

c0102458 <vector143>:
.globl vector143
vector143:
  pushl $0
c0102458:	6a 00                	push   $0x0
  pushl $143
c010245a:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c010245f:	e9 40 05 00 00       	jmp    c01029a4 <__alltraps>

c0102464 <vector144>:
.globl vector144
vector144:
  pushl $0
c0102464:	6a 00                	push   $0x0
  pushl $144
c0102466:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c010246b:	e9 34 05 00 00       	jmp    c01029a4 <__alltraps>

c0102470 <vector145>:
.globl vector145
vector145:
  pushl $0
c0102470:	6a 00                	push   $0x0
  pushl $145
c0102472:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c0102477:	e9 28 05 00 00       	jmp    c01029a4 <__alltraps>

c010247c <vector146>:
.globl vector146
vector146:
  pushl $0
c010247c:	6a 00                	push   $0x0
  pushl $146
c010247e:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c0102483:	e9 1c 05 00 00       	jmp    c01029a4 <__alltraps>

c0102488 <vector147>:
.globl vector147
vector147:
  pushl $0
c0102488:	6a 00                	push   $0x0
  pushl $147
c010248a:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c010248f:	e9 10 05 00 00       	jmp    c01029a4 <__alltraps>

c0102494 <vector148>:
.globl vector148
vector148:
  pushl $0
c0102494:	6a 00                	push   $0x0
  pushl $148
c0102496:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c010249b:	e9 04 05 00 00       	jmp    c01029a4 <__alltraps>

c01024a0 <vector149>:
.globl vector149
vector149:
  pushl $0
c01024a0:	6a 00                	push   $0x0
  pushl $149
c01024a2:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c01024a7:	e9 f8 04 00 00       	jmp    c01029a4 <__alltraps>

c01024ac <vector150>:
.globl vector150
vector150:
  pushl $0
c01024ac:	6a 00                	push   $0x0
  pushl $150
c01024ae:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c01024b3:	e9 ec 04 00 00       	jmp    c01029a4 <__alltraps>

c01024b8 <vector151>:
.globl vector151
vector151:
  pushl $0
c01024b8:	6a 00                	push   $0x0
  pushl $151
c01024ba:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c01024bf:	e9 e0 04 00 00       	jmp    c01029a4 <__alltraps>

c01024c4 <vector152>:
.globl vector152
vector152:
  pushl $0
c01024c4:	6a 00                	push   $0x0
  pushl $152
c01024c6:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c01024cb:	e9 d4 04 00 00       	jmp    c01029a4 <__alltraps>

c01024d0 <vector153>:
.globl vector153
vector153:
  pushl $0
c01024d0:	6a 00                	push   $0x0
  pushl $153
c01024d2:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c01024d7:	e9 c8 04 00 00       	jmp    c01029a4 <__alltraps>

c01024dc <vector154>:
.globl vector154
vector154:
  pushl $0
c01024dc:	6a 00                	push   $0x0
  pushl $154
c01024de:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c01024e3:	e9 bc 04 00 00       	jmp    c01029a4 <__alltraps>

c01024e8 <vector155>:
.globl vector155
vector155:
  pushl $0
c01024e8:	6a 00                	push   $0x0
  pushl $155
c01024ea:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c01024ef:	e9 b0 04 00 00       	jmp    c01029a4 <__alltraps>

c01024f4 <vector156>:
.globl vector156
vector156:
  pushl $0
c01024f4:	6a 00                	push   $0x0
  pushl $156
c01024f6:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c01024fb:	e9 a4 04 00 00       	jmp    c01029a4 <__alltraps>

c0102500 <vector157>:
.globl vector157
vector157:
  pushl $0
c0102500:	6a 00                	push   $0x0
  pushl $157
c0102502:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c0102507:	e9 98 04 00 00       	jmp    c01029a4 <__alltraps>

c010250c <vector158>:
.globl vector158
vector158:
  pushl $0
c010250c:	6a 00                	push   $0x0
  pushl $158
c010250e:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c0102513:	e9 8c 04 00 00       	jmp    c01029a4 <__alltraps>

c0102518 <vector159>:
.globl vector159
vector159:
  pushl $0
c0102518:	6a 00                	push   $0x0
  pushl $159
c010251a:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c010251f:	e9 80 04 00 00       	jmp    c01029a4 <__alltraps>

c0102524 <vector160>:
.globl vector160
vector160:
  pushl $0
c0102524:	6a 00                	push   $0x0
  pushl $160
c0102526:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c010252b:	e9 74 04 00 00       	jmp    c01029a4 <__alltraps>

c0102530 <vector161>:
.globl vector161
vector161:
  pushl $0
c0102530:	6a 00                	push   $0x0
  pushl $161
c0102532:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c0102537:	e9 68 04 00 00       	jmp    c01029a4 <__alltraps>

c010253c <vector162>:
.globl vector162
vector162:
  pushl $0
c010253c:	6a 00                	push   $0x0
  pushl $162
c010253e:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c0102543:	e9 5c 04 00 00       	jmp    c01029a4 <__alltraps>

c0102548 <vector163>:
.globl vector163
vector163:
  pushl $0
c0102548:	6a 00                	push   $0x0
  pushl $163
c010254a:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c010254f:	e9 50 04 00 00       	jmp    c01029a4 <__alltraps>

c0102554 <vector164>:
.globl vector164
vector164:
  pushl $0
c0102554:	6a 00                	push   $0x0
  pushl $164
c0102556:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c010255b:	e9 44 04 00 00       	jmp    c01029a4 <__alltraps>

c0102560 <vector165>:
.globl vector165
vector165:
  pushl $0
c0102560:	6a 00                	push   $0x0
  pushl $165
c0102562:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c0102567:	e9 38 04 00 00       	jmp    c01029a4 <__alltraps>

c010256c <vector166>:
.globl vector166
vector166:
  pushl $0
c010256c:	6a 00                	push   $0x0
  pushl $166
c010256e:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c0102573:	e9 2c 04 00 00       	jmp    c01029a4 <__alltraps>

c0102578 <vector167>:
.globl vector167
vector167:
  pushl $0
c0102578:	6a 00                	push   $0x0
  pushl $167
c010257a:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c010257f:	e9 20 04 00 00       	jmp    c01029a4 <__alltraps>

c0102584 <vector168>:
.globl vector168
vector168:
  pushl $0
c0102584:	6a 00                	push   $0x0
  pushl $168
c0102586:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c010258b:	e9 14 04 00 00       	jmp    c01029a4 <__alltraps>

c0102590 <vector169>:
.globl vector169
vector169:
  pushl $0
c0102590:	6a 00                	push   $0x0
  pushl $169
c0102592:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c0102597:	e9 08 04 00 00       	jmp    c01029a4 <__alltraps>

c010259c <vector170>:
.globl vector170
vector170:
  pushl $0
c010259c:	6a 00                	push   $0x0
  pushl $170
c010259e:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c01025a3:	e9 fc 03 00 00       	jmp    c01029a4 <__alltraps>

c01025a8 <vector171>:
.globl vector171
vector171:
  pushl $0
c01025a8:	6a 00                	push   $0x0
  pushl $171
c01025aa:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c01025af:	e9 f0 03 00 00       	jmp    c01029a4 <__alltraps>

c01025b4 <vector172>:
.globl vector172
vector172:
  pushl $0
c01025b4:	6a 00                	push   $0x0
  pushl $172
c01025b6:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c01025bb:	e9 e4 03 00 00       	jmp    c01029a4 <__alltraps>

c01025c0 <vector173>:
.globl vector173
vector173:
  pushl $0
c01025c0:	6a 00                	push   $0x0
  pushl $173
c01025c2:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c01025c7:	e9 d8 03 00 00       	jmp    c01029a4 <__alltraps>

c01025cc <vector174>:
.globl vector174
vector174:
  pushl $0
c01025cc:	6a 00                	push   $0x0
  pushl $174
c01025ce:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c01025d3:	e9 cc 03 00 00       	jmp    c01029a4 <__alltraps>

c01025d8 <vector175>:
.globl vector175
vector175:
  pushl $0
c01025d8:	6a 00                	push   $0x0
  pushl $175
c01025da:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c01025df:	e9 c0 03 00 00       	jmp    c01029a4 <__alltraps>

c01025e4 <vector176>:
.globl vector176
vector176:
  pushl $0
c01025e4:	6a 00                	push   $0x0
  pushl $176
c01025e6:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c01025eb:	e9 b4 03 00 00       	jmp    c01029a4 <__alltraps>

c01025f0 <vector177>:
.globl vector177
vector177:
  pushl $0
c01025f0:	6a 00                	push   $0x0
  pushl $177
c01025f2:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c01025f7:	e9 a8 03 00 00       	jmp    c01029a4 <__alltraps>

c01025fc <vector178>:
.globl vector178
vector178:
  pushl $0
c01025fc:	6a 00                	push   $0x0
  pushl $178
c01025fe:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c0102603:	e9 9c 03 00 00       	jmp    c01029a4 <__alltraps>

c0102608 <vector179>:
.globl vector179
vector179:
  pushl $0
c0102608:	6a 00                	push   $0x0
  pushl $179
c010260a:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c010260f:	e9 90 03 00 00       	jmp    c01029a4 <__alltraps>

c0102614 <vector180>:
.globl vector180
vector180:
  pushl $0
c0102614:	6a 00                	push   $0x0
  pushl $180
c0102616:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c010261b:	e9 84 03 00 00       	jmp    c01029a4 <__alltraps>

c0102620 <vector181>:
.globl vector181
vector181:
  pushl $0
c0102620:	6a 00                	push   $0x0
  pushl $181
c0102622:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c0102627:	e9 78 03 00 00       	jmp    c01029a4 <__alltraps>

c010262c <vector182>:
.globl vector182
vector182:
  pushl $0
c010262c:	6a 00                	push   $0x0
  pushl $182
c010262e:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c0102633:	e9 6c 03 00 00       	jmp    c01029a4 <__alltraps>

c0102638 <vector183>:
.globl vector183
vector183:
  pushl $0
c0102638:	6a 00                	push   $0x0
  pushl $183
c010263a:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c010263f:	e9 60 03 00 00       	jmp    c01029a4 <__alltraps>

c0102644 <vector184>:
.globl vector184
vector184:
  pushl $0
c0102644:	6a 00                	push   $0x0
  pushl $184
c0102646:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c010264b:	e9 54 03 00 00       	jmp    c01029a4 <__alltraps>

c0102650 <vector185>:
.globl vector185
vector185:
  pushl $0
c0102650:	6a 00                	push   $0x0
  pushl $185
c0102652:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c0102657:	e9 48 03 00 00       	jmp    c01029a4 <__alltraps>

c010265c <vector186>:
.globl vector186
vector186:
  pushl $0
c010265c:	6a 00                	push   $0x0
  pushl $186
c010265e:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c0102663:	e9 3c 03 00 00       	jmp    c01029a4 <__alltraps>

c0102668 <vector187>:
.globl vector187
vector187:
  pushl $0
c0102668:	6a 00                	push   $0x0
  pushl $187
c010266a:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c010266f:	e9 30 03 00 00       	jmp    c01029a4 <__alltraps>

c0102674 <vector188>:
.globl vector188
vector188:
  pushl $0
c0102674:	6a 00                	push   $0x0
  pushl $188
c0102676:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c010267b:	e9 24 03 00 00       	jmp    c01029a4 <__alltraps>

c0102680 <vector189>:
.globl vector189
vector189:
  pushl $0
c0102680:	6a 00                	push   $0x0
  pushl $189
c0102682:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c0102687:	e9 18 03 00 00       	jmp    c01029a4 <__alltraps>

c010268c <vector190>:
.globl vector190
vector190:
  pushl $0
c010268c:	6a 00                	push   $0x0
  pushl $190
c010268e:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c0102693:	e9 0c 03 00 00       	jmp    c01029a4 <__alltraps>

c0102698 <vector191>:
.globl vector191
vector191:
  pushl $0
c0102698:	6a 00                	push   $0x0
  pushl $191
c010269a:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c010269f:	e9 00 03 00 00       	jmp    c01029a4 <__alltraps>

c01026a4 <vector192>:
.globl vector192
vector192:
  pushl $0
c01026a4:	6a 00                	push   $0x0
  pushl $192
c01026a6:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c01026ab:	e9 f4 02 00 00       	jmp    c01029a4 <__alltraps>

c01026b0 <vector193>:
.globl vector193
vector193:
  pushl $0
c01026b0:	6a 00                	push   $0x0
  pushl $193
c01026b2:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c01026b7:	e9 e8 02 00 00       	jmp    c01029a4 <__alltraps>

c01026bc <vector194>:
.globl vector194
vector194:
  pushl $0
c01026bc:	6a 00                	push   $0x0
  pushl $194
c01026be:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c01026c3:	e9 dc 02 00 00       	jmp    c01029a4 <__alltraps>

c01026c8 <vector195>:
.globl vector195
vector195:
  pushl $0
c01026c8:	6a 00                	push   $0x0
  pushl $195
c01026ca:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c01026cf:	e9 d0 02 00 00       	jmp    c01029a4 <__alltraps>

c01026d4 <vector196>:
.globl vector196
vector196:
  pushl $0
c01026d4:	6a 00                	push   $0x0
  pushl $196
c01026d6:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c01026db:	e9 c4 02 00 00       	jmp    c01029a4 <__alltraps>

c01026e0 <vector197>:
.globl vector197
vector197:
  pushl $0
c01026e0:	6a 00                	push   $0x0
  pushl $197
c01026e2:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c01026e7:	e9 b8 02 00 00       	jmp    c01029a4 <__alltraps>

c01026ec <vector198>:
.globl vector198
vector198:
  pushl $0
c01026ec:	6a 00                	push   $0x0
  pushl $198
c01026ee:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c01026f3:	e9 ac 02 00 00       	jmp    c01029a4 <__alltraps>

c01026f8 <vector199>:
.globl vector199
vector199:
  pushl $0
c01026f8:	6a 00                	push   $0x0
  pushl $199
c01026fa:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c01026ff:	e9 a0 02 00 00       	jmp    c01029a4 <__alltraps>

c0102704 <vector200>:
.globl vector200
vector200:
  pushl $0
c0102704:	6a 00                	push   $0x0
  pushl $200
c0102706:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c010270b:	e9 94 02 00 00       	jmp    c01029a4 <__alltraps>

c0102710 <vector201>:
.globl vector201
vector201:
  pushl $0
c0102710:	6a 00                	push   $0x0
  pushl $201
c0102712:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c0102717:	e9 88 02 00 00       	jmp    c01029a4 <__alltraps>

c010271c <vector202>:
.globl vector202
vector202:
  pushl $0
c010271c:	6a 00                	push   $0x0
  pushl $202
c010271e:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c0102723:	e9 7c 02 00 00       	jmp    c01029a4 <__alltraps>

c0102728 <vector203>:
.globl vector203
vector203:
  pushl $0
c0102728:	6a 00                	push   $0x0
  pushl $203
c010272a:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c010272f:	e9 70 02 00 00       	jmp    c01029a4 <__alltraps>

c0102734 <vector204>:
.globl vector204
vector204:
  pushl $0
c0102734:	6a 00                	push   $0x0
  pushl $204
c0102736:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c010273b:	e9 64 02 00 00       	jmp    c01029a4 <__alltraps>

c0102740 <vector205>:
.globl vector205
vector205:
  pushl $0
c0102740:	6a 00                	push   $0x0
  pushl $205
c0102742:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c0102747:	e9 58 02 00 00       	jmp    c01029a4 <__alltraps>

c010274c <vector206>:
.globl vector206
vector206:
  pushl $0
c010274c:	6a 00                	push   $0x0
  pushl $206
c010274e:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c0102753:	e9 4c 02 00 00       	jmp    c01029a4 <__alltraps>

c0102758 <vector207>:
.globl vector207
vector207:
  pushl $0
c0102758:	6a 00                	push   $0x0
  pushl $207
c010275a:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c010275f:	e9 40 02 00 00       	jmp    c01029a4 <__alltraps>

c0102764 <vector208>:
.globl vector208
vector208:
  pushl $0
c0102764:	6a 00                	push   $0x0
  pushl $208
c0102766:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c010276b:	e9 34 02 00 00       	jmp    c01029a4 <__alltraps>

c0102770 <vector209>:
.globl vector209
vector209:
  pushl $0
c0102770:	6a 00                	push   $0x0
  pushl $209
c0102772:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c0102777:	e9 28 02 00 00       	jmp    c01029a4 <__alltraps>

c010277c <vector210>:
.globl vector210
vector210:
  pushl $0
c010277c:	6a 00                	push   $0x0
  pushl $210
c010277e:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c0102783:	e9 1c 02 00 00       	jmp    c01029a4 <__alltraps>

c0102788 <vector211>:
.globl vector211
vector211:
  pushl $0
c0102788:	6a 00                	push   $0x0
  pushl $211
c010278a:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c010278f:	e9 10 02 00 00       	jmp    c01029a4 <__alltraps>

c0102794 <vector212>:
.globl vector212
vector212:
  pushl $0
c0102794:	6a 00                	push   $0x0
  pushl $212
c0102796:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c010279b:	e9 04 02 00 00       	jmp    c01029a4 <__alltraps>

c01027a0 <vector213>:
.globl vector213
vector213:
  pushl $0
c01027a0:	6a 00                	push   $0x0
  pushl $213
c01027a2:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c01027a7:	e9 f8 01 00 00       	jmp    c01029a4 <__alltraps>

c01027ac <vector214>:
.globl vector214
vector214:
  pushl $0
c01027ac:	6a 00                	push   $0x0
  pushl $214
c01027ae:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c01027b3:	e9 ec 01 00 00       	jmp    c01029a4 <__alltraps>

c01027b8 <vector215>:
.globl vector215
vector215:
  pushl $0
c01027b8:	6a 00                	push   $0x0
  pushl $215
c01027ba:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c01027bf:	e9 e0 01 00 00       	jmp    c01029a4 <__alltraps>

c01027c4 <vector216>:
.globl vector216
vector216:
  pushl $0
c01027c4:	6a 00                	push   $0x0
  pushl $216
c01027c6:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c01027cb:	e9 d4 01 00 00       	jmp    c01029a4 <__alltraps>

c01027d0 <vector217>:
.globl vector217
vector217:
  pushl $0
c01027d0:	6a 00                	push   $0x0
  pushl $217
c01027d2:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c01027d7:	e9 c8 01 00 00       	jmp    c01029a4 <__alltraps>

c01027dc <vector218>:
.globl vector218
vector218:
  pushl $0
c01027dc:	6a 00                	push   $0x0
  pushl $218
c01027de:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c01027e3:	e9 bc 01 00 00       	jmp    c01029a4 <__alltraps>

c01027e8 <vector219>:
.globl vector219
vector219:
  pushl $0
c01027e8:	6a 00                	push   $0x0
  pushl $219
c01027ea:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c01027ef:	e9 b0 01 00 00       	jmp    c01029a4 <__alltraps>

c01027f4 <vector220>:
.globl vector220
vector220:
  pushl $0
c01027f4:	6a 00                	push   $0x0
  pushl $220
c01027f6:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c01027fb:	e9 a4 01 00 00       	jmp    c01029a4 <__alltraps>

c0102800 <vector221>:
.globl vector221
vector221:
  pushl $0
c0102800:	6a 00                	push   $0x0
  pushl $221
c0102802:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c0102807:	e9 98 01 00 00       	jmp    c01029a4 <__alltraps>

c010280c <vector222>:
.globl vector222
vector222:
  pushl $0
c010280c:	6a 00                	push   $0x0
  pushl $222
c010280e:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c0102813:	e9 8c 01 00 00       	jmp    c01029a4 <__alltraps>

c0102818 <vector223>:
.globl vector223
vector223:
  pushl $0
c0102818:	6a 00                	push   $0x0
  pushl $223
c010281a:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c010281f:	e9 80 01 00 00       	jmp    c01029a4 <__alltraps>

c0102824 <vector224>:
.globl vector224
vector224:
  pushl $0
c0102824:	6a 00                	push   $0x0
  pushl $224
c0102826:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c010282b:	e9 74 01 00 00       	jmp    c01029a4 <__alltraps>

c0102830 <vector225>:
.globl vector225
vector225:
  pushl $0
c0102830:	6a 00                	push   $0x0
  pushl $225
c0102832:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c0102837:	e9 68 01 00 00       	jmp    c01029a4 <__alltraps>

c010283c <vector226>:
.globl vector226
vector226:
  pushl $0
c010283c:	6a 00                	push   $0x0
  pushl $226
c010283e:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c0102843:	e9 5c 01 00 00       	jmp    c01029a4 <__alltraps>

c0102848 <vector227>:
.globl vector227
vector227:
  pushl $0
c0102848:	6a 00                	push   $0x0
  pushl $227
c010284a:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c010284f:	e9 50 01 00 00       	jmp    c01029a4 <__alltraps>

c0102854 <vector228>:
.globl vector228
vector228:
  pushl $0
c0102854:	6a 00                	push   $0x0
  pushl $228
c0102856:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c010285b:	e9 44 01 00 00       	jmp    c01029a4 <__alltraps>

c0102860 <vector229>:
.globl vector229
vector229:
  pushl $0
c0102860:	6a 00                	push   $0x0
  pushl $229
c0102862:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c0102867:	e9 38 01 00 00       	jmp    c01029a4 <__alltraps>

c010286c <vector230>:
.globl vector230
vector230:
  pushl $0
c010286c:	6a 00                	push   $0x0
  pushl $230
c010286e:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c0102873:	e9 2c 01 00 00       	jmp    c01029a4 <__alltraps>

c0102878 <vector231>:
.globl vector231
vector231:
  pushl $0
c0102878:	6a 00                	push   $0x0
  pushl $231
c010287a:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c010287f:	e9 20 01 00 00       	jmp    c01029a4 <__alltraps>

c0102884 <vector232>:
.globl vector232
vector232:
  pushl $0
c0102884:	6a 00                	push   $0x0
  pushl $232
c0102886:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c010288b:	e9 14 01 00 00       	jmp    c01029a4 <__alltraps>

c0102890 <vector233>:
.globl vector233
vector233:
  pushl $0
c0102890:	6a 00                	push   $0x0
  pushl $233
c0102892:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c0102897:	e9 08 01 00 00       	jmp    c01029a4 <__alltraps>

c010289c <vector234>:
.globl vector234
vector234:
  pushl $0
c010289c:	6a 00                	push   $0x0
  pushl $234
c010289e:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c01028a3:	e9 fc 00 00 00       	jmp    c01029a4 <__alltraps>

c01028a8 <vector235>:
.globl vector235
vector235:
  pushl $0
c01028a8:	6a 00                	push   $0x0
  pushl $235
c01028aa:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c01028af:	e9 f0 00 00 00       	jmp    c01029a4 <__alltraps>

c01028b4 <vector236>:
.globl vector236
vector236:
  pushl $0
c01028b4:	6a 00                	push   $0x0
  pushl $236
c01028b6:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c01028bb:	e9 e4 00 00 00       	jmp    c01029a4 <__alltraps>

c01028c0 <vector237>:
.globl vector237
vector237:
  pushl $0
c01028c0:	6a 00                	push   $0x0
  pushl $237
c01028c2:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c01028c7:	e9 d8 00 00 00       	jmp    c01029a4 <__alltraps>

c01028cc <vector238>:
.globl vector238
vector238:
  pushl $0
c01028cc:	6a 00                	push   $0x0
  pushl $238
c01028ce:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c01028d3:	e9 cc 00 00 00       	jmp    c01029a4 <__alltraps>

c01028d8 <vector239>:
.globl vector239
vector239:
  pushl $0
c01028d8:	6a 00                	push   $0x0
  pushl $239
c01028da:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c01028df:	e9 c0 00 00 00       	jmp    c01029a4 <__alltraps>

c01028e4 <vector240>:
.globl vector240
vector240:
  pushl $0
c01028e4:	6a 00                	push   $0x0
  pushl $240
c01028e6:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c01028eb:	e9 b4 00 00 00       	jmp    c01029a4 <__alltraps>

c01028f0 <vector241>:
.globl vector241
vector241:
  pushl $0
c01028f0:	6a 00                	push   $0x0
  pushl $241
c01028f2:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c01028f7:	e9 a8 00 00 00       	jmp    c01029a4 <__alltraps>

c01028fc <vector242>:
.globl vector242
vector242:
  pushl $0
c01028fc:	6a 00                	push   $0x0
  pushl $242
c01028fe:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c0102903:	e9 9c 00 00 00       	jmp    c01029a4 <__alltraps>

c0102908 <vector243>:
.globl vector243
vector243:
  pushl $0
c0102908:	6a 00                	push   $0x0
  pushl $243
c010290a:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c010290f:	e9 90 00 00 00       	jmp    c01029a4 <__alltraps>

c0102914 <vector244>:
.globl vector244
vector244:
  pushl $0
c0102914:	6a 00                	push   $0x0
  pushl $244
c0102916:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c010291b:	e9 84 00 00 00       	jmp    c01029a4 <__alltraps>

c0102920 <vector245>:
.globl vector245
vector245:
  pushl $0
c0102920:	6a 00                	push   $0x0
  pushl $245
c0102922:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c0102927:	e9 78 00 00 00       	jmp    c01029a4 <__alltraps>

c010292c <vector246>:
.globl vector246
vector246:
  pushl $0
c010292c:	6a 00                	push   $0x0
  pushl $246
c010292e:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c0102933:	e9 6c 00 00 00       	jmp    c01029a4 <__alltraps>

c0102938 <vector247>:
.globl vector247
vector247:
  pushl $0
c0102938:	6a 00                	push   $0x0
  pushl $247
c010293a:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c010293f:	e9 60 00 00 00       	jmp    c01029a4 <__alltraps>

c0102944 <vector248>:
.globl vector248
vector248:
  pushl $0
c0102944:	6a 00                	push   $0x0
  pushl $248
c0102946:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c010294b:	e9 54 00 00 00       	jmp    c01029a4 <__alltraps>

c0102950 <vector249>:
.globl vector249
vector249:
  pushl $0
c0102950:	6a 00                	push   $0x0
  pushl $249
c0102952:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c0102957:	e9 48 00 00 00       	jmp    c01029a4 <__alltraps>

c010295c <vector250>:
.globl vector250
vector250:
  pushl $0
c010295c:	6a 00                	push   $0x0
  pushl $250
c010295e:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c0102963:	e9 3c 00 00 00       	jmp    c01029a4 <__alltraps>

c0102968 <vector251>:
.globl vector251
vector251:
  pushl $0
c0102968:	6a 00                	push   $0x0
  pushl $251
c010296a:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c010296f:	e9 30 00 00 00       	jmp    c01029a4 <__alltraps>

c0102974 <vector252>:
.globl vector252
vector252:
  pushl $0
c0102974:	6a 00                	push   $0x0
  pushl $252
c0102976:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c010297b:	e9 24 00 00 00       	jmp    c01029a4 <__alltraps>

c0102980 <vector253>:
.globl vector253
vector253:
  pushl $0
c0102980:	6a 00                	push   $0x0
  pushl $253
c0102982:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c0102987:	e9 18 00 00 00       	jmp    c01029a4 <__alltraps>

c010298c <vector254>:
.globl vector254
vector254:
  pushl $0
c010298c:	6a 00                	push   $0x0
  pushl $254
c010298e:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c0102993:	e9 0c 00 00 00       	jmp    c01029a4 <__alltraps>

c0102998 <vector255>:
.globl vector255
vector255:
  pushl $0
c0102998:	6a 00                	push   $0x0
  pushl $255
c010299a:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c010299f:	e9 00 00 00 00       	jmp    c01029a4 <__alltraps>

c01029a4 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c01029a4:	1e                   	push   %ds
    pushl %es
c01029a5:	06                   	push   %es
    pushl %fs
c01029a6:	0f a0                	push   %fs
    pushl %gs
c01029a8:	0f a8                	push   %gs
    pushal
c01029aa:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c01029ab:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c01029b0:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c01029b2:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c01029b4:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c01029b5:	e8 65 f5 ff ff       	call   c0101f1f <trap>

    # pop the pushed stack pointer
    popl %esp
c01029ba:	5c                   	pop    %esp

c01029bb <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c01029bb:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c01029bc:	0f a9                	pop    %gs
    popl %fs
c01029be:	0f a1                	pop    %fs
    popl %es
c01029c0:	07                   	pop    %es
    popl %ds
c01029c1:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c01029c2:	83 c4 08             	add    $0x8,%esp
    iret
c01029c5:	cf                   	iret   

c01029c6 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c01029c6:	55                   	push   %ebp
c01029c7:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01029c9:	8b 55 08             	mov    0x8(%ebp),%edx
c01029cc:	a1 78 af 11 c0       	mov    0xc011af78,%eax
c01029d1:	29 c2                	sub    %eax,%edx
c01029d3:	89 d0                	mov    %edx,%eax
c01029d5:	c1 f8 02             	sar    $0x2,%eax
c01029d8:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c01029de:	5d                   	pop    %ebp
c01029df:	c3                   	ret    

c01029e0 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c01029e0:	55                   	push   %ebp
c01029e1:	89 e5                	mov    %esp,%ebp
c01029e3:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c01029e6:	8b 45 08             	mov    0x8(%ebp),%eax
c01029e9:	89 04 24             	mov    %eax,(%esp)
c01029ec:	e8 d5 ff ff ff       	call   c01029c6 <page2ppn>
c01029f1:	c1 e0 0c             	shl    $0xc,%eax
}
c01029f4:	c9                   	leave  
c01029f5:	c3                   	ret    

c01029f6 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c01029f6:	55                   	push   %ebp
c01029f7:	89 e5                	mov    %esp,%ebp
c01029f9:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c01029fc:	8b 45 08             	mov    0x8(%ebp),%eax
c01029ff:	c1 e8 0c             	shr    $0xc,%eax
c0102a02:	89 c2                	mov    %eax,%edx
c0102a04:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c0102a09:	39 c2                	cmp    %eax,%edx
c0102a0b:	72 1c                	jb     c0102a29 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0102a0d:	c7 44 24 08 10 68 10 	movl   $0xc0106810,0x8(%esp)
c0102a14:	c0 
c0102a15:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
c0102a1c:	00 
c0102a1d:	c7 04 24 2f 68 10 c0 	movl   $0xc010682f,(%esp)
c0102a24:	e8 cb d9 ff ff       	call   c01003f4 <__panic>
    }
    return &pages[PPN(pa)];
c0102a29:	8b 0d 78 af 11 c0    	mov    0xc011af78,%ecx
c0102a2f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a32:	c1 e8 0c             	shr    $0xc,%eax
c0102a35:	89 c2                	mov    %eax,%edx
c0102a37:	89 d0                	mov    %edx,%eax
c0102a39:	c1 e0 02             	shl    $0x2,%eax
c0102a3c:	01 d0                	add    %edx,%eax
c0102a3e:	c1 e0 02             	shl    $0x2,%eax
c0102a41:	01 c8                	add    %ecx,%eax
}
c0102a43:	c9                   	leave  
c0102a44:	c3                   	ret    

c0102a45 <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0102a45:	55                   	push   %ebp
c0102a46:	89 e5                	mov    %esp,%ebp
c0102a48:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0102a4b:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a4e:	89 04 24             	mov    %eax,(%esp)
c0102a51:	e8 8a ff ff ff       	call   c01029e0 <page2pa>
c0102a56:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102a59:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a5c:	c1 e8 0c             	shr    $0xc,%eax
c0102a5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102a62:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c0102a67:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0102a6a:	72 23                	jb     c0102a8f <page2kva+0x4a>
c0102a6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a6f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0102a73:	c7 44 24 08 40 68 10 	movl   $0xc0106840,0x8(%esp)
c0102a7a:	c0 
c0102a7b:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c0102a82:	00 
c0102a83:	c7 04 24 2f 68 10 c0 	movl   $0xc010682f,(%esp)
c0102a8a:	e8 65 d9 ff ff       	call   c01003f4 <__panic>
c0102a8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a92:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0102a97:	c9                   	leave  
c0102a98:	c3                   	ret    

c0102a99 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0102a99:	55                   	push   %ebp
c0102a9a:	89 e5                	mov    %esp,%ebp
c0102a9c:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0102a9f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102aa2:	83 e0 01             	and    $0x1,%eax
c0102aa5:	85 c0                	test   %eax,%eax
c0102aa7:	75 1c                	jne    c0102ac5 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0102aa9:	c7 44 24 08 64 68 10 	movl   $0xc0106864,0x8(%esp)
c0102ab0:	c0 
c0102ab1:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c0102ab8:	00 
c0102ab9:	c7 04 24 2f 68 10 c0 	movl   $0xc010682f,(%esp)
c0102ac0:	e8 2f d9 ff ff       	call   c01003f4 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0102ac5:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ac8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0102acd:	89 04 24             	mov    %eax,(%esp)
c0102ad0:	e8 21 ff ff ff       	call   c01029f6 <pa2page>
}
c0102ad5:	c9                   	leave  
c0102ad6:	c3                   	ret    

c0102ad7 <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
c0102ad7:	55                   	push   %ebp
c0102ad8:	89 e5                	mov    %esp,%ebp
c0102ada:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
c0102add:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ae0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0102ae5:	89 04 24             	mov    %eax,(%esp)
c0102ae8:	e8 09 ff ff ff       	call   c01029f6 <pa2page>
}
c0102aed:	c9                   	leave  
c0102aee:	c3                   	ret    

c0102aef <page_ref>:

static inline int
page_ref(struct Page *page) {
c0102aef:	55                   	push   %ebp
c0102af0:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0102af2:	8b 45 08             	mov    0x8(%ebp),%eax
c0102af5:	8b 00                	mov    (%eax),%eax
}
c0102af7:	5d                   	pop    %ebp
c0102af8:	c3                   	ret    

c0102af9 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0102af9:	55                   	push   %ebp
c0102afa:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0102afc:	8b 45 08             	mov    0x8(%ebp),%eax
c0102aff:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102b02:	89 10                	mov    %edx,(%eax)
}
c0102b04:	5d                   	pop    %ebp
c0102b05:	c3                   	ret    

c0102b06 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c0102b06:	55                   	push   %ebp
c0102b07:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0102b09:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b0c:	8b 00                	mov    (%eax),%eax
c0102b0e:	8d 50 01             	lea    0x1(%eax),%edx
c0102b11:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b14:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0102b16:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b19:	8b 00                	mov    (%eax),%eax
}
c0102b1b:	5d                   	pop    %ebp
c0102b1c:	c3                   	ret    

c0102b1d <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0102b1d:	55                   	push   %ebp
c0102b1e:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0102b20:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b23:	8b 00                	mov    (%eax),%eax
c0102b25:	8d 50 ff             	lea    -0x1(%eax),%edx
c0102b28:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b2b:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0102b2d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b30:	8b 00                	mov    (%eax),%eax
}
c0102b32:	5d                   	pop    %ebp
c0102b33:	c3                   	ret    

c0102b34 <__intr_save>:
__intr_save(void) {
c0102b34:	55                   	push   %ebp
c0102b35:	89 e5                	mov    %esp,%ebp
c0102b37:	83 ec 18             	sub    $0x18,%esp
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0102b3a:	9c                   	pushf  
c0102b3b:	58                   	pop    %eax
c0102b3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0102b3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0102b42:	25 00 02 00 00       	and    $0x200,%eax
c0102b47:	85 c0                	test   %eax,%eax
c0102b49:	74 0c                	je     c0102b57 <__intr_save+0x23>
        intr_disable();
c0102b4b:	e8 42 ed ff ff       	call   c0101892 <intr_disable>
        return 1;
c0102b50:	b8 01 00 00 00       	mov    $0x1,%eax
c0102b55:	eb 05                	jmp    c0102b5c <__intr_save+0x28>
    return 0;
c0102b57:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0102b5c:	c9                   	leave  
c0102b5d:	c3                   	ret    

c0102b5e <__intr_restore>:
__intr_restore(bool flag) {
c0102b5e:	55                   	push   %ebp
c0102b5f:	89 e5                	mov    %esp,%ebp
c0102b61:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0102b64:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0102b68:	74 05                	je     c0102b6f <__intr_restore+0x11>
        intr_enable();
c0102b6a:	e8 1d ed ff ff       	call   c010188c <intr_enable>
}
c0102b6f:	c9                   	leave  
c0102b70:	c3                   	ret    

c0102b71 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0102b71:	55                   	push   %ebp
c0102b72:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0102b74:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b77:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0102b7a:	b8 23 00 00 00       	mov    $0x23,%eax
c0102b7f:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0102b81:	b8 23 00 00 00       	mov    $0x23,%eax
c0102b86:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0102b88:	b8 10 00 00 00       	mov    $0x10,%eax
c0102b8d:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0102b8f:	b8 10 00 00 00       	mov    $0x10,%eax
c0102b94:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0102b96:	b8 10 00 00 00       	mov    $0x10,%eax
c0102b9b:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0102b9d:	ea a4 2b 10 c0 08 00 	ljmp   $0x8,$0xc0102ba4
}
c0102ba4:	5d                   	pop    %ebp
c0102ba5:	c3                   	ret    

c0102ba6 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0102ba6:	55                   	push   %ebp
c0102ba7:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0102ba9:	8b 45 08             	mov    0x8(%ebp),%eax
c0102bac:	a3 a4 ae 11 c0       	mov    %eax,0xc011aea4
}
c0102bb1:	5d                   	pop    %ebp
c0102bb2:	c3                   	ret    

c0102bb3 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0102bb3:	55                   	push   %ebp
c0102bb4:	89 e5                	mov    %esp,%ebp
c0102bb6:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0102bb9:	b8 00 70 11 c0       	mov    $0xc0117000,%eax
c0102bbe:	89 04 24             	mov    %eax,(%esp)
c0102bc1:	e8 e0 ff ff ff       	call   c0102ba6 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0102bc6:	66 c7 05 a8 ae 11 c0 	movw   $0x10,0xc011aea8
c0102bcd:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0102bcf:	66 c7 05 28 7a 11 c0 	movw   $0x68,0xc0117a28
c0102bd6:	68 00 
c0102bd8:	b8 a0 ae 11 c0       	mov    $0xc011aea0,%eax
c0102bdd:	66 a3 2a 7a 11 c0    	mov    %ax,0xc0117a2a
c0102be3:	b8 a0 ae 11 c0       	mov    $0xc011aea0,%eax
c0102be8:	c1 e8 10             	shr    $0x10,%eax
c0102beb:	a2 2c 7a 11 c0       	mov    %al,0xc0117a2c
c0102bf0:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0102bf7:	83 e0 f0             	and    $0xfffffff0,%eax
c0102bfa:	83 c8 09             	or     $0x9,%eax
c0102bfd:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0102c02:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0102c09:	83 e0 ef             	and    $0xffffffef,%eax
c0102c0c:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0102c11:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0102c18:	83 e0 9f             	and    $0xffffff9f,%eax
c0102c1b:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0102c20:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0102c27:	83 c8 80             	or     $0xffffff80,%eax
c0102c2a:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0102c2f:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0102c36:	83 e0 f0             	and    $0xfffffff0,%eax
c0102c39:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0102c3e:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0102c45:	83 e0 ef             	and    $0xffffffef,%eax
c0102c48:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0102c4d:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0102c54:	83 e0 df             	and    $0xffffffdf,%eax
c0102c57:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0102c5c:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0102c63:	83 c8 40             	or     $0x40,%eax
c0102c66:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0102c6b:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0102c72:	83 e0 7f             	and    $0x7f,%eax
c0102c75:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0102c7a:	b8 a0 ae 11 c0       	mov    $0xc011aea0,%eax
c0102c7f:	c1 e8 18             	shr    $0x18,%eax
c0102c82:	a2 2f 7a 11 c0       	mov    %al,0xc0117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0102c87:	c7 04 24 30 7a 11 c0 	movl   $0xc0117a30,(%esp)
c0102c8e:	e8 de fe ff ff       	call   c0102b71 <lgdt>
c0102c93:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0102c99:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0102c9d:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c0102ca0:	c9                   	leave  
c0102ca1:	c3                   	ret    

c0102ca2 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0102ca2:	55                   	push   %ebp
c0102ca3:	89 e5                	mov    %esp,%ebp
c0102ca5:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c0102ca8:	c7 05 70 af 11 c0 08 	movl   $0xc0107208,0xc011af70
c0102caf:	72 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0102cb2:	a1 70 af 11 c0       	mov    0xc011af70,%eax
c0102cb7:	8b 00                	mov    (%eax),%eax
c0102cb9:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102cbd:	c7 04 24 90 68 10 c0 	movl   $0xc0106890,(%esp)
c0102cc4:	e8 d4 d5 ff ff       	call   c010029d <cprintf>
    pmm_manager->init();
c0102cc9:	a1 70 af 11 c0       	mov    0xc011af70,%eax
c0102cce:	8b 40 04             	mov    0x4(%eax),%eax
c0102cd1:	ff d0                	call   *%eax
}
c0102cd3:	c9                   	leave  
c0102cd4:	c3                   	ret    

c0102cd5 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0102cd5:	55                   	push   %ebp
c0102cd6:	89 e5                	mov    %esp,%ebp
c0102cd8:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0102cdb:	a1 70 af 11 c0       	mov    0xc011af70,%eax
c0102ce0:	8b 40 08             	mov    0x8(%eax),%eax
c0102ce3:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102ce6:	89 54 24 04          	mov    %edx,0x4(%esp)
c0102cea:	8b 55 08             	mov    0x8(%ebp),%edx
c0102ced:	89 14 24             	mov    %edx,(%esp)
c0102cf0:	ff d0                	call   *%eax
}
c0102cf2:	c9                   	leave  
c0102cf3:	c3                   	ret    

c0102cf4 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0102cf4:	55                   	push   %ebp
c0102cf5:	89 e5                	mov    %esp,%ebp
c0102cf7:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c0102cfa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0102d01:	e8 2e fe ff ff       	call   c0102b34 <__intr_save>
c0102d06:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c0102d09:	a1 70 af 11 c0       	mov    0xc011af70,%eax
c0102d0e:	8b 40 0c             	mov    0xc(%eax),%eax
c0102d11:	8b 55 08             	mov    0x8(%ebp),%edx
c0102d14:	89 14 24             	mov    %edx,(%esp)
c0102d17:	ff d0                	call   *%eax
c0102d19:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c0102d1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102d1f:	89 04 24             	mov    %eax,(%esp)
c0102d22:	e8 37 fe ff ff       	call   c0102b5e <__intr_restore>
    return page;
c0102d27:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0102d2a:	c9                   	leave  
c0102d2b:	c3                   	ret    

c0102d2c <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0102d2c:	55                   	push   %ebp
c0102d2d:	89 e5                	mov    %esp,%ebp
c0102d2f:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0102d32:	e8 fd fd ff ff       	call   c0102b34 <__intr_save>
c0102d37:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0102d3a:	a1 70 af 11 c0       	mov    0xc011af70,%eax
c0102d3f:	8b 40 10             	mov    0x10(%eax),%eax
c0102d42:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102d45:	89 54 24 04          	mov    %edx,0x4(%esp)
c0102d49:	8b 55 08             	mov    0x8(%ebp),%edx
c0102d4c:	89 14 24             	mov    %edx,(%esp)
c0102d4f:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c0102d51:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d54:	89 04 24             	mov    %eax,(%esp)
c0102d57:	e8 02 fe ff ff       	call   c0102b5e <__intr_restore>
}
c0102d5c:	c9                   	leave  
c0102d5d:	c3                   	ret    

c0102d5e <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0102d5e:	55                   	push   %ebp
c0102d5f:	89 e5                	mov    %esp,%ebp
c0102d61:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0102d64:	e8 cb fd ff ff       	call   c0102b34 <__intr_save>
c0102d69:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0102d6c:	a1 70 af 11 c0       	mov    0xc011af70,%eax
c0102d71:	8b 40 14             	mov    0x14(%eax),%eax
c0102d74:	ff d0                	call   *%eax
c0102d76:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0102d79:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d7c:	89 04 24             	mov    %eax,(%esp)
c0102d7f:	e8 da fd ff ff       	call   c0102b5e <__intr_restore>
    return ret;
c0102d84:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0102d87:	c9                   	leave  
c0102d88:	c3                   	ret    

c0102d89 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0102d89:	55                   	push   %ebp
c0102d8a:	89 e5                	mov    %esp,%ebp
c0102d8c:	57                   	push   %edi
c0102d8d:	56                   	push   %esi
c0102d8e:	53                   	push   %ebx
c0102d8f:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0102d95:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0102d9c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0102da3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0102daa:	c7 04 24 a7 68 10 c0 	movl   $0xc01068a7,(%esp)
c0102db1:	e8 e7 d4 ff ff       	call   c010029d <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0102db6:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0102dbd:	e9 15 01 00 00       	jmp    c0102ed7 <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0102dc2:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102dc5:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102dc8:	89 d0                	mov    %edx,%eax
c0102dca:	c1 e0 02             	shl    $0x2,%eax
c0102dcd:	01 d0                	add    %edx,%eax
c0102dcf:	c1 e0 02             	shl    $0x2,%eax
c0102dd2:	01 c8                	add    %ecx,%eax
c0102dd4:	8b 50 08             	mov    0x8(%eax),%edx
c0102dd7:	8b 40 04             	mov    0x4(%eax),%eax
c0102dda:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0102ddd:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0102de0:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102de3:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102de6:	89 d0                	mov    %edx,%eax
c0102de8:	c1 e0 02             	shl    $0x2,%eax
c0102deb:	01 d0                	add    %edx,%eax
c0102ded:	c1 e0 02             	shl    $0x2,%eax
c0102df0:	01 c8                	add    %ecx,%eax
c0102df2:	8b 48 0c             	mov    0xc(%eax),%ecx
c0102df5:	8b 58 10             	mov    0x10(%eax),%ebx
c0102df8:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0102dfb:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0102dfe:	01 c8                	add    %ecx,%eax
c0102e00:	11 da                	adc    %ebx,%edx
c0102e02:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0102e05:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0102e08:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102e0b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102e0e:	89 d0                	mov    %edx,%eax
c0102e10:	c1 e0 02             	shl    $0x2,%eax
c0102e13:	01 d0                	add    %edx,%eax
c0102e15:	c1 e0 02             	shl    $0x2,%eax
c0102e18:	01 c8                	add    %ecx,%eax
c0102e1a:	83 c0 14             	add    $0x14,%eax
c0102e1d:	8b 00                	mov    (%eax),%eax
c0102e1f:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c0102e25:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0102e28:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0102e2b:	83 c0 ff             	add    $0xffffffff,%eax
c0102e2e:	83 d2 ff             	adc    $0xffffffff,%edx
c0102e31:	89 c6                	mov    %eax,%esi
c0102e33:	89 d7                	mov    %edx,%edi
c0102e35:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102e38:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102e3b:	89 d0                	mov    %edx,%eax
c0102e3d:	c1 e0 02             	shl    $0x2,%eax
c0102e40:	01 d0                	add    %edx,%eax
c0102e42:	c1 e0 02             	shl    $0x2,%eax
c0102e45:	01 c8                	add    %ecx,%eax
c0102e47:	8b 48 0c             	mov    0xc(%eax),%ecx
c0102e4a:	8b 58 10             	mov    0x10(%eax),%ebx
c0102e4d:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c0102e53:	89 44 24 1c          	mov    %eax,0x1c(%esp)
c0102e57:	89 74 24 14          	mov    %esi,0x14(%esp)
c0102e5b:	89 7c 24 18          	mov    %edi,0x18(%esp)
c0102e5f:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0102e62:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0102e65:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0102e69:	89 54 24 10          	mov    %edx,0x10(%esp)
c0102e6d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0102e71:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c0102e75:	c7 04 24 b4 68 10 c0 	movl   $0xc01068b4,(%esp)
c0102e7c:	e8 1c d4 ff ff       	call   c010029d <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0102e81:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102e84:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102e87:	89 d0                	mov    %edx,%eax
c0102e89:	c1 e0 02             	shl    $0x2,%eax
c0102e8c:	01 d0                	add    %edx,%eax
c0102e8e:	c1 e0 02             	shl    $0x2,%eax
c0102e91:	01 c8                	add    %ecx,%eax
c0102e93:	83 c0 14             	add    $0x14,%eax
c0102e96:	8b 00                	mov    (%eax),%eax
c0102e98:	83 f8 01             	cmp    $0x1,%eax
c0102e9b:	75 36                	jne    c0102ed3 <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
c0102e9d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102ea0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0102ea3:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0102ea6:	77 2b                	ja     c0102ed3 <page_init+0x14a>
c0102ea8:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0102eab:	72 05                	jb     c0102eb2 <page_init+0x129>
c0102ead:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c0102eb0:	73 21                	jae    c0102ed3 <page_init+0x14a>
c0102eb2:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0102eb6:	77 1b                	ja     c0102ed3 <page_init+0x14a>
c0102eb8:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0102ebc:	72 09                	jb     c0102ec7 <page_init+0x13e>
c0102ebe:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
c0102ec5:	77 0c                	ja     c0102ed3 <page_init+0x14a>
                maxpa = end;
c0102ec7:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0102eca:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0102ecd:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0102ed0:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (i = 0; i < memmap->nr_map; i ++) {
c0102ed3:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0102ed7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102eda:	8b 00                	mov    (%eax),%eax
c0102edc:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0102edf:	0f 8f dd fe ff ff    	jg     c0102dc2 <page_init+0x39>
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0102ee5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0102ee9:	72 1d                	jb     c0102f08 <page_init+0x17f>
c0102eeb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0102eef:	77 09                	ja     c0102efa <page_init+0x171>
c0102ef1:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c0102ef8:	76 0e                	jbe    c0102f08 <page_init+0x17f>
        maxpa = KMEMSIZE;
c0102efa:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0102f01:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0102f08:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102f0b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0102f0e:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0102f12:	c1 ea 0c             	shr    $0xc,%edx
c0102f15:	a3 80 ae 11 c0       	mov    %eax,0xc011ae80

    // 将地址进行4K对齐
    // end 为bootloader加载完ucore的地址，以此地址为基础的地址是可以使用的，对齐后作为页表的起始地址
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0102f1a:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c0102f21:	b8 88 af 11 c0       	mov    $0xc011af88,%eax
c0102f26:	8d 50 ff             	lea    -0x1(%eax),%edx
c0102f29:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0102f2c:	01 d0                	add    %edx,%eax
c0102f2e:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0102f31:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0102f34:	ba 00 00 00 00       	mov    $0x0,%edx
c0102f39:	f7 75 ac             	divl   -0x54(%ebp)
c0102f3c:	89 d0                	mov    %edx,%eax
c0102f3e:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0102f41:	29 c2                	sub    %eax,%edx
c0102f43:	89 d0                	mov    %edx,%eax
c0102f45:	a3 78 af 11 c0       	mov    %eax,0xc011af78

    // 设置保留标志位
    for (i = 0; i < npage; i ++) {
c0102f4a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0102f51:	eb 2f                	jmp    c0102f82 <page_init+0x1f9>
        SetPageReserved(pages + i);
c0102f53:	8b 0d 78 af 11 c0    	mov    0xc011af78,%ecx
c0102f59:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102f5c:	89 d0                	mov    %edx,%eax
c0102f5e:	c1 e0 02             	shl    $0x2,%eax
c0102f61:	01 d0                	add    %edx,%eax
c0102f63:	c1 e0 02             	shl    $0x2,%eax
c0102f66:	01 c8                	add    %ecx,%eax
c0102f68:	83 c0 04             	add    $0x4,%eax
c0102f6b:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c0102f72:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102f75:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0102f78:	8b 55 90             	mov    -0x70(%ebp),%edx
c0102f7b:	0f ab 10             	bts    %edx,(%eax)
    for (i = 0; i < npage; i ++) {
c0102f7e:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0102f82:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102f85:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c0102f8a:	39 c2                	cmp    %eax,%edx
c0102f8c:	72 c5                	jb     c0102f53 <page_init+0x1ca>
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c0102f8e:	8b 15 80 ae 11 c0    	mov    0xc011ae80,%edx
c0102f94:	89 d0                	mov    %edx,%eax
c0102f96:	c1 e0 02             	shl    $0x2,%eax
c0102f99:	01 d0                	add    %edx,%eax
c0102f9b:	c1 e0 02             	shl    $0x2,%eax
c0102f9e:	89 c2                	mov    %eax,%edx
c0102fa0:	a1 78 af 11 c0       	mov    0xc011af78,%eax
c0102fa5:	01 d0                	add    %edx,%eax
c0102fa7:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c0102faa:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c0102fb1:	77 23                	ja     c0102fd6 <page_init+0x24d>
c0102fb3:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0102fb6:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0102fba:	c7 44 24 08 e4 68 10 	movl   $0xc01068e4,0x8(%esp)
c0102fc1:	c0 
c0102fc2:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
c0102fc9:	00 
c0102fca:	c7 04 24 08 69 10 c0 	movl   $0xc0106908,(%esp)
c0102fd1:	e8 1e d4 ff ff       	call   c01003f4 <__panic>
c0102fd6:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0102fd9:	05 00 00 00 40       	add    $0x40000000,%eax
c0102fde:	89 45 a0             	mov    %eax,-0x60(%ebp)

    // 开始对其他页表项进行处理
    for (i = 0; i < memmap->nr_map; i ++) {
c0102fe1:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0102fe8:	e9 74 01 00 00       	jmp    c0103161 <page_init+0x3d8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0102fed:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102ff0:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102ff3:	89 d0                	mov    %edx,%eax
c0102ff5:	c1 e0 02             	shl    $0x2,%eax
c0102ff8:	01 d0                	add    %edx,%eax
c0102ffa:	c1 e0 02             	shl    $0x2,%eax
c0102ffd:	01 c8                	add    %ecx,%eax
c0102fff:	8b 50 08             	mov    0x8(%eax),%edx
c0103002:	8b 40 04             	mov    0x4(%eax),%eax
c0103005:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103008:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010300b:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010300e:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103011:	89 d0                	mov    %edx,%eax
c0103013:	c1 e0 02             	shl    $0x2,%eax
c0103016:	01 d0                	add    %edx,%eax
c0103018:	c1 e0 02             	shl    $0x2,%eax
c010301b:	01 c8                	add    %ecx,%eax
c010301d:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103020:	8b 58 10             	mov    0x10(%eax),%ebx
c0103023:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103026:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103029:	01 c8                	add    %ecx,%eax
c010302b:	11 da                	adc    %ebx,%edx
c010302d:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0103030:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c0103033:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103036:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103039:	89 d0                	mov    %edx,%eax
c010303b:	c1 e0 02             	shl    $0x2,%eax
c010303e:	01 d0                	add    %edx,%eax
c0103040:	c1 e0 02             	shl    $0x2,%eax
c0103043:	01 c8                	add    %ecx,%eax
c0103045:	83 c0 14             	add    $0x14,%eax
c0103048:	8b 00                	mov    (%eax),%eax
c010304a:	83 f8 01             	cmp    $0x1,%eax
c010304d:	0f 85 0a 01 00 00    	jne    c010315d <page_init+0x3d4>
            if (begin < freemem) {
c0103053:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0103056:	ba 00 00 00 00       	mov    $0x0,%edx
c010305b:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c010305e:	72 17                	jb     c0103077 <page_init+0x2ee>
c0103060:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0103063:	77 05                	ja     c010306a <page_init+0x2e1>
c0103065:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0103068:	76 0d                	jbe    c0103077 <page_init+0x2ee>
                begin = freemem;
c010306a:	8b 45 a0             	mov    -0x60(%ebp),%eax
c010306d:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103070:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c0103077:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c010307b:	72 1d                	jb     c010309a <page_init+0x311>
c010307d:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0103081:	77 09                	ja     c010308c <page_init+0x303>
c0103083:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c010308a:	76 0e                	jbe    c010309a <page_init+0x311>
                end = KMEMSIZE;
c010308c:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c0103093:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c010309a:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010309d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01030a0:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01030a3:	0f 87 b4 00 00 00    	ja     c010315d <page_init+0x3d4>
c01030a9:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01030ac:	72 09                	jb     c01030b7 <page_init+0x32e>
c01030ae:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c01030b1:	0f 83 a6 00 00 00    	jae    c010315d <page_init+0x3d4>
                begin = ROUNDUP(begin, PGSIZE);
c01030b7:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c01030be:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01030c1:	8b 45 9c             	mov    -0x64(%ebp),%eax
c01030c4:	01 d0                	add    %edx,%eax
c01030c6:	83 e8 01             	sub    $0x1,%eax
c01030c9:	89 45 98             	mov    %eax,-0x68(%ebp)
c01030cc:	8b 45 98             	mov    -0x68(%ebp),%eax
c01030cf:	ba 00 00 00 00       	mov    $0x0,%edx
c01030d4:	f7 75 9c             	divl   -0x64(%ebp)
c01030d7:	89 d0                	mov    %edx,%eax
c01030d9:	8b 55 98             	mov    -0x68(%ebp),%edx
c01030dc:	29 c2                	sub    %eax,%edx
c01030de:	89 d0                	mov    %edx,%eax
c01030e0:	ba 00 00 00 00       	mov    $0x0,%edx
c01030e5:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01030e8:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c01030eb:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01030ee:	89 45 94             	mov    %eax,-0x6c(%ebp)
c01030f1:	8b 45 94             	mov    -0x6c(%ebp),%eax
c01030f4:	ba 00 00 00 00       	mov    $0x0,%edx
c01030f9:	89 c7                	mov    %eax,%edi
c01030fb:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
c0103101:	89 7d 80             	mov    %edi,-0x80(%ebp)
c0103104:	89 d0                	mov    %edx,%eax
c0103106:	83 e0 00             	and    $0x0,%eax
c0103109:	89 45 84             	mov    %eax,-0x7c(%ebp)
c010310c:	8b 45 80             	mov    -0x80(%ebp),%eax
c010310f:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0103112:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0103115:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
c0103118:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010311b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010311e:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0103121:	77 3a                	ja     c010315d <page_init+0x3d4>
c0103123:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0103126:	72 05                	jb     c010312d <page_init+0x3a4>
c0103128:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c010312b:	73 30                	jae    c010315d <page_init+0x3d4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c010312d:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c0103130:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
c0103133:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103136:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0103139:	29 c8                	sub    %ecx,%eax
c010313b:	19 da                	sbb    %ebx,%edx
c010313d:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0103141:	c1 ea 0c             	shr    $0xc,%edx
c0103144:	89 c3                	mov    %eax,%ebx
c0103146:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103149:	89 04 24             	mov    %eax,(%esp)
c010314c:	e8 a5 f8 ff ff       	call   c01029f6 <pa2page>
c0103151:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0103155:	89 04 24             	mov    %eax,(%esp)
c0103158:	e8 78 fb ff ff       	call   c0102cd5 <init_memmap>
    for (i = 0; i < memmap->nr_map; i ++) {
c010315d:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0103161:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103164:	8b 00                	mov    (%eax),%eax
c0103166:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0103169:	0f 8f 7e fe ff ff    	jg     c0102fed <page_init+0x264>
                }
            }
        }
    }
}
c010316f:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c0103175:	5b                   	pop    %ebx
c0103176:	5e                   	pop    %esi
c0103177:	5f                   	pop    %edi
c0103178:	5d                   	pop    %ebp
c0103179:	c3                   	ret    

c010317a <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c010317a:	55                   	push   %ebp
c010317b:	89 e5                	mov    %esp,%ebp
c010317d:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c0103180:	8b 45 14             	mov    0x14(%ebp),%eax
c0103183:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103186:	31 d0                	xor    %edx,%eax
c0103188:	25 ff 0f 00 00       	and    $0xfff,%eax
c010318d:	85 c0                	test   %eax,%eax
c010318f:	74 24                	je     c01031b5 <boot_map_segment+0x3b>
c0103191:	c7 44 24 0c 16 69 10 	movl   $0xc0106916,0xc(%esp)
c0103198:	c0 
c0103199:	c7 44 24 08 2d 69 10 	movl   $0xc010692d,0x8(%esp)
c01031a0:	c0 
c01031a1:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
c01031a8:	00 
c01031a9:	c7 04 24 08 69 10 c0 	movl   $0xc0106908,(%esp)
c01031b0:	e8 3f d2 ff ff       	call   c01003f4 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c01031b5:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c01031bc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01031bf:	25 ff 0f 00 00       	and    $0xfff,%eax
c01031c4:	89 c2                	mov    %eax,%edx
c01031c6:	8b 45 10             	mov    0x10(%ebp),%eax
c01031c9:	01 c2                	add    %eax,%edx
c01031cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01031ce:	01 d0                	add    %edx,%eax
c01031d0:	83 e8 01             	sub    $0x1,%eax
c01031d3:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01031d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01031d9:	ba 00 00 00 00       	mov    $0x0,%edx
c01031de:	f7 75 f0             	divl   -0x10(%ebp)
c01031e1:	89 d0                	mov    %edx,%eax
c01031e3:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01031e6:	29 c2                	sub    %eax,%edx
c01031e8:	89 d0                	mov    %edx,%eax
c01031ea:	c1 e8 0c             	shr    $0xc,%eax
c01031ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c01031f0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01031f3:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01031f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01031f9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01031fe:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c0103201:	8b 45 14             	mov    0x14(%ebp),%eax
c0103204:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103207:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010320a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010320f:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0103212:	eb 6b                	jmp    c010327f <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
c0103214:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c010321b:	00 
c010321c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010321f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103223:	8b 45 08             	mov    0x8(%ebp),%eax
c0103226:	89 04 24             	mov    %eax,(%esp)
c0103229:	e8 82 01 00 00       	call   c01033b0 <get_pte>
c010322e:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c0103231:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0103235:	75 24                	jne    c010325b <boot_map_segment+0xe1>
c0103237:	c7 44 24 0c 42 69 10 	movl   $0xc0106942,0xc(%esp)
c010323e:	c0 
c010323f:	c7 44 24 08 2d 69 10 	movl   $0xc010692d,0x8(%esp)
c0103246:	c0 
c0103247:	c7 44 24 04 05 01 00 	movl   $0x105,0x4(%esp)
c010324e:	00 
c010324f:	c7 04 24 08 69 10 c0 	movl   $0xc0106908,(%esp)
c0103256:	e8 99 d1 ff ff       	call   c01003f4 <__panic>
        *ptep = pa | PTE_P | perm;
c010325b:	8b 45 18             	mov    0x18(%ebp),%eax
c010325e:	8b 55 14             	mov    0x14(%ebp),%edx
c0103261:	09 d0                	or     %edx,%eax
c0103263:	83 c8 01             	or     $0x1,%eax
c0103266:	89 c2                	mov    %eax,%edx
c0103268:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010326b:	89 10                	mov    %edx,(%eax)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c010326d:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0103271:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c0103278:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c010327f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103283:	75 8f                	jne    c0103214 <boot_map_segment+0x9a>
    }
}
c0103285:	c9                   	leave  
c0103286:	c3                   	ret    

c0103287 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c0103287:	55                   	push   %ebp
c0103288:	89 e5                	mov    %esp,%ebp
c010328a:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c010328d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103294:	e8 5b fa ff ff       	call   c0102cf4 <alloc_pages>
c0103299:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c010329c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01032a0:	75 1c                	jne    c01032be <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c01032a2:	c7 44 24 08 4f 69 10 	movl   $0xc010694f,0x8(%esp)
c01032a9:	c0 
c01032aa:	c7 44 24 04 11 01 00 	movl   $0x111,0x4(%esp)
c01032b1:	00 
c01032b2:	c7 04 24 08 69 10 c0 	movl   $0xc0106908,(%esp)
c01032b9:	e8 36 d1 ff ff       	call   c01003f4 <__panic>
    }
    return page2kva(p);
c01032be:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01032c1:	89 04 24             	mov    %eax,(%esp)
c01032c4:	e8 7c f7 ff ff       	call   c0102a45 <page2kva>
}
c01032c9:	c9                   	leave  
c01032ca:	c3                   	ret    

c01032cb <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c01032cb:	55                   	push   %ebp
c01032cc:	89 e5                	mov    %esp,%ebp
c01032ce:	83 ec 38             	sub    $0x38,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
c01032d1:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c01032d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01032d9:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01032e0:	77 23                	ja     c0103305 <pmm_init+0x3a>
c01032e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01032e5:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01032e9:	c7 44 24 08 e4 68 10 	movl   $0xc01068e4,0x8(%esp)
c01032f0:	c0 
c01032f1:	c7 44 24 04 1b 01 00 	movl   $0x11b,0x4(%esp)
c01032f8:	00 
c01032f9:	c7 04 24 08 69 10 c0 	movl   $0xc0106908,(%esp)
c0103300:	e8 ef d0 ff ff       	call   c01003f4 <__panic>
c0103305:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103308:	05 00 00 00 40       	add    $0x40000000,%eax
c010330d:	a3 74 af 11 c0       	mov    %eax,0xc011af74
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c0103312:	e8 8b f9 ff ff       	call   c0102ca2 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c0103317:	e8 6d fa ff ff       	call   c0102d89 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c010331c:	e8 e0 03 00 00       	call   c0103701 <check_alloc_page>

    check_pgdir();
c0103321:	e8 f9 03 00 00       	call   c010371f <check_pgdir>

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT

    // boot_pgdir 和 VPT 都是PD的虚拟地址，是不同时期的虚拟地址
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c0103326:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c010332b:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c0103331:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103336:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103339:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0103340:	77 23                	ja     c0103365 <pmm_init+0x9a>
c0103342:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103345:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103349:	c7 44 24 08 e4 68 10 	movl   $0xc01068e4,0x8(%esp)
c0103350:	c0 
c0103351:	c7 44 24 04 33 01 00 	movl   $0x133,0x4(%esp)
c0103358:	00 
c0103359:	c7 04 24 08 69 10 c0 	movl   $0xc0106908,(%esp)
c0103360:	e8 8f d0 ff ff       	call   c01003f4 <__panic>
c0103365:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103368:	05 00 00 00 40       	add    $0x40000000,%eax
c010336d:	83 c8 03             	or     $0x3,%eax
c0103370:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c0103372:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103377:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c010337e:	00 
c010337f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0103386:	00 
c0103387:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c010338e:	38 
c010338f:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c0103396:	c0 
c0103397:	89 04 24             	mov    %eax,(%esp)
c010339a:	e8 db fd ff ff       	call   c010317a <boot_map_segment>

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c010339f:	e8 0f f8 ff ff       	call   c0102bb3 <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c01033a4:	e8 11 0a 00 00       	call   c0103dba <check_boot_pgdir>

    print_pgdir();
c01033a9:	e8 99 0e 00 00       	call   c0104247 <print_pgdir>

}
c01033ae:	c9                   	leave  
c01033af:	c3                   	ret    

c01033b0 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c01033b0:	55                   	push   %ebp
c01033b1:	89 e5                	mov    %esp,%ebp
c01033b3:	83 ec 38             	sub    $0x38,%esp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    pde_t *pdep = &pgdir[PDX(la)];
c01033b6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01033b9:	c1 e8 16             	shr    $0x16,%eax
c01033bc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01033c3:	8b 45 08             	mov    0x8(%ebp),%eax
c01033c6:	01 d0                	add    %edx,%eax
c01033c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(!(*pdep & PTE_P))
c01033cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01033ce:	8b 00                	mov    (%eax),%eax
c01033d0:	83 e0 01             	and    $0x1,%eax
c01033d3:	85 c0                	test   %eax,%eax
c01033d5:	0f 85 af 00 00 00    	jne    c010348a <get_pte+0xda>
    {
    	struct Page *page;
    	if(!create || (page = alloc_page()) == NULL){
c01033db:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01033df:	74 15                	je     c01033f6 <get_pte+0x46>
c01033e1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01033e8:	e8 07 f9 ff ff       	call   c0102cf4 <alloc_pages>
c01033ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01033f0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01033f4:	75 0a                	jne    c0103400 <get_pte+0x50>
    		return NULL;
c01033f6:	b8 00 00 00 00       	mov    $0x0,%eax
c01033fb:	e9 e6 00 00 00       	jmp    c01034e6 <get_pte+0x136>
    	}
    	set_page_ref(page, 1);
c0103400:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103407:	00 
c0103408:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010340b:	89 04 24             	mov    %eax,(%esp)
c010340e:	e8 e6 f6 ff ff       	call   c0102af9 <set_page_ref>
    	// 获得刚申请页的物理地址
    	uintptr_t pa = page2pa(page);
c0103413:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103416:	89 04 24             	mov    %eax,(%esp)
c0103419:	e8 c2 f5 ff ff       	call   c01029e0 <page2pa>
c010341e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    	// 函数所有的地址都是虚拟地址，利用KADDR进行转化
    	memset(KADDR(pa), 0, PGSIZE);
c0103421:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103424:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103427:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010342a:	c1 e8 0c             	shr    $0xc,%eax
c010342d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103430:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c0103435:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0103438:	72 23                	jb     c010345d <get_pte+0xad>
c010343a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010343d:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103441:	c7 44 24 08 40 68 10 	movl   $0xc0106840,0x8(%esp)
c0103448:	c0 
c0103449:	c7 44 24 04 7c 01 00 	movl   $0x17c,0x4(%esp)
c0103450:	00 
c0103451:	c7 04 24 08 69 10 c0 	movl   $0xc0106908,(%esp)
c0103458:	e8 97 cf ff ff       	call   c01003f4 <__panic>
c010345d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103460:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0103465:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c010346c:	00 
c010346d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0103474:	00 
c0103475:	89 04 24             	mov    %eax,(%esp)
c0103478:	e8 43 24 00 00       	call   c01058c0 <memset>
    	*pdep = pa | PTE_U | PTE_W | PTE_P;
c010347d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103480:	83 c8 07             	or     $0x7,%eax
c0103483:	89 c2                	mov    %eax,%edx
c0103485:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103488:	89 10                	mov    %edx,(%eax)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];
c010348a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010348d:	8b 00                	mov    (%eax),%eax
c010348f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103494:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0103497:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010349a:	c1 e8 0c             	shr    $0xc,%eax
c010349d:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01034a0:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c01034a5:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c01034a8:	72 23                	jb     c01034cd <get_pte+0x11d>
c01034aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01034ad:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01034b1:	c7 44 24 08 40 68 10 	movl   $0xc0106840,0x8(%esp)
c01034b8:	c0 
c01034b9:	c7 44 24 04 7f 01 00 	movl   $0x17f,0x4(%esp)
c01034c0:	00 
c01034c1:	c7 04 24 08 69 10 c0 	movl   $0xc0106908,(%esp)
c01034c8:	e8 27 cf ff ff       	call   c01003f4 <__panic>
c01034cd:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01034d0:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01034d5:	8b 55 0c             	mov    0xc(%ebp),%edx
c01034d8:	c1 ea 0c             	shr    $0xc,%edx
c01034db:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
c01034e1:	c1 e2 02             	shl    $0x2,%edx
c01034e4:	01 d0                	add    %edx,%eax

}
c01034e6:	c9                   	leave  
c01034e7:	c3                   	ret    

c01034e8 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c01034e8:	55                   	push   %ebp
c01034e9:	89 e5                	mov    %esp,%ebp
c01034eb:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c01034ee:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01034f5:	00 
c01034f6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01034f9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01034fd:	8b 45 08             	mov    0x8(%ebp),%eax
c0103500:	89 04 24             	mov    %eax,(%esp)
c0103503:	e8 a8 fe ff ff       	call   c01033b0 <get_pte>
c0103508:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c010350b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010350f:	74 08                	je     c0103519 <get_page+0x31>
        *ptep_store = ptep;
c0103511:	8b 45 10             	mov    0x10(%ebp),%eax
c0103514:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103517:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c0103519:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010351d:	74 1b                	je     c010353a <get_page+0x52>
c010351f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103522:	8b 00                	mov    (%eax),%eax
c0103524:	83 e0 01             	and    $0x1,%eax
c0103527:	85 c0                	test   %eax,%eax
c0103529:	74 0f                	je     c010353a <get_page+0x52>
        return pte2page(*ptep);
c010352b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010352e:	8b 00                	mov    (%eax),%eax
c0103530:	89 04 24             	mov    %eax,(%esp)
c0103533:	e8 61 f5 ff ff       	call   c0102a99 <pte2page>
c0103538:	eb 05                	jmp    c010353f <get_page+0x57>
    }
    return NULL;
c010353a:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010353f:	c9                   	leave  
c0103540:	c3                   	ret    

c0103541 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c0103541:	55                   	push   %ebp
c0103542:	89 e5                	mov    %esp,%ebp
c0103544:	83 ec 28             	sub    $0x28,%esp
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif

    if(*ptep & PTE_P)
c0103547:	8b 45 10             	mov    0x10(%ebp),%eax
c010354a:	8b 00                	mov    (%eax),%eax
c010354c:	83 e0 01             	and    $0x1,%eax
c010354f:	85 c0                	test   %eax,%eax
c0103551:	74 52                	je     c01035a5 <page_remove_pte+0x64>
    {
    	struct Page *page = pte2page(*ptep);
c0103553:	8b 45 10             	mov    0x10(%ebp),%eax
c0103556:	8b 00                	mov    (%eax),%eax
c0103558:	89 04 24             	mov    %eax,(%esp)
c010355b:	e8 39 f5 ff ff       	call   c0102a99 <pte2page>
c0103560:	89 45 f4             	mov    %eax,-0xc(%ebp)
    	page_ref_dec(page);
c0103563:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103566:	89 04 24             	mov    %eax,(%esp)
c0103569:	e8 af f5 ff ff       	call   c0102b1d <page_ref_dec>
    	if(page->ref == 0)
c010356e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103571:	8b 00                	mov    (%eax),%eax
c0103573:	85 c0                	test   %eax,%eax
c0103575:	75 13                	jne    c010358a <page_remove_pte+0x49>
    	{
    		free_page(page);
c0103577:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010357e:	00 
c010357f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103582:	89 04 24             	mov    %eax,(%esp)
c0103585:	e8 a2 f7 ff ff       	call   c0102d2c <free_pages>
    	}
    	*ptep = 0;
c010358a:	8b 45 10             	mov    0x10(%ebp),%eax
c010358d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    	tlb_invalidate(pgdir, la);
c0103593:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103596:	89 44 24 04          	mov    %eax,0x4(%esp)
c010359a:	8b 45 08             	mov    0x8(%ebp),%eax
c010359d:	89 04 24             	mov    %eax,(%esp)
c01035a0:	e8 ff 00 00 00       	call   c01036a4 <tlb_invalidate>
    }
}
c01035a5:	c9                   	leave  
c01035a6:	c3                   	ret    

c01035a7 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c01035a7:	55                   	push   %ebp
c01035a8:	89 e5                	mov    %esp,%ebp
c01035aa:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c01035ad:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01035b4:	00 
c01035b5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01035b8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01035bc:	8b 45 08             	mov    0x8(%ebp),%eax
c01035bf:	89 04 24             	mov    %eax,(%esp)
c01035c2:	e8 e9 fd ff ff       	call   c01033b0 <get_pte>
c01035c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c01035ca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01035ce:	74 19                	je     c01035e9 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c01035d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035d3:	89 44 24 08          	mov    %eax,0x8(%esp)
c01035d7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01035da:	89 44 24 04          	mov    %eax,0x4(%esp)
c01035de:	8b 45 08             	mov    0x8(%ebp),%eax
c01035e1:	89 04 24             	mov    %eax,(%esp)
c01035e4:	e8 58 ff ff ff       	call   c0103541 <page_remove_pte>
    }
}
c01035e9:	c9                   	leave  
c01035ea:	c3                   	ret    

c01035eb <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c01035eb:	55                   	push   %ebp
c01035ec:	89 e5                	mov    %esp,%ebp
c01035ee:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c01035f1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c01035f8:	00 
c01035f9:	8b 45 10             	mov    0x10(%ebp),%eax
c01035fc:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103600:	8b 45 08             	mov    0x8(%ebp),%eax
c0103603:	89 04 24             	mov    %eax,(%esp)
c0103606:	e8 a5 fd ff ff       	call   c01033b0 <get_pte>
c010360b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c010360e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103612:	75 0a                	jne    c010361e <page_insert+0x33>
        return -E_NO_MEM;
c0103614:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c0103619:	e9 84 00 00 00       	jmp    c01036a2 <page_insert+0xb7>
    }
    page_ref_inc(page);
c010361e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103621:	89 04 24             	mov    %eax,(%esp)
c0103624:	e8 dd f4 ff ff       	call   c0102b06 <page_ref_inc>
    if (*ptep & PTE_P) {
c0103629:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010362c:	8b 00                	mov    (%eax),%eax
c010362e:	83 e0 01             	and    $0x1,%eax
c0103631:	85 c0                	test   %eax,%eax
c0103633:	74 3e                	je     c0103673 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c0103635:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103638:	8b 00                	mov    (%eax),%eax
c010363a:	89 04 24             	mov    %eax,(%esp)
c010363d:	e8 57 f4 ff ff       	call   c0102a99 <pte2page>
c0103642:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c0103645:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103648:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010364b:	75 0d                	jne    c010365a <page_insert+0x6f>
            page_ref_dec(page);
c010364d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103650:	89 04 24             	mov    %eax,(%esp)
c0103653:	e8 c5 f4 ff ff       	call   c0102b1d <page_ref_dec>
c0103658:	eb 19                	jmp    c0103673 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c010365a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010365d:	89 44 24 08          	mov    %eax,0x8(%esp)
c0103661:	8b 45 10             	mov    0x10(%ebp),%eax
c0103664:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103668:	8b 45 08             	mov    0x8(%ebp),%eax
c010366b:	89 04 24             	mov    %eax,(%esp)
c010366e:	e8 ce fe ff ff       	call   c0103541 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c0103673:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103676:	89 04 24             	mov    %eax,(%esp)
c0103679:	e8 62 f3 ff ff       	call   c01029e0 <page2pa>
c010367e:	0b 45 14             	or     0x14(%ebp),%eax
c0103681:	83 c8 01             	or     $0x1,%eax
c0103684:	89 c2                	mov    %eax,%edx
c0103686:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103689:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c010368b:	8b 45 10             	mov    0x10(%ebp),%eax
c010368e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103692:	8b 45 08             	mov    0x8(%ebp),%eax
c0103695:	89 04 24             	mov    %eax,(%esp)
c0103698:	e8 07 00 00 00       	call   c01036a4 <tlb_invalidate>
    return 0;
c010369d:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01036a2:	c9                   	leave  
c01036a3:	c3                   	ret    

c01036a4 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c01036a4:	55                   	push   %ebp
c01036a5:	89 e5                	mov    %esp,%ebp
c01036a7:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c01036aa:	0f 20 d8             	mov    %cr3,%eax
c01036ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c01036b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
c01036b3:	89 c2                	mov    %eax,%edx
c01036b5:	8b 45 08             	mov    0x8(%ebp),%eax
c01036b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01036bb:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01036c2:	77 23                	ja     c01036e7 <tlb_invalidate+0x43>
c01036c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036c7:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01036cb:	c7 44 24 08 e4 68 10 	movl   $0xc01068e4,0x8(%esp)
c01036d2:	c0 
c01036d3:	c7 44 24 04 e6 01 00 	movl   $0x1e6,0x4(%esp)
c01036da:	00 
c01036db:	c7 04 24 08 69 10 c0 	movl   $0xc0106908,(%esp)
c01036e2:	e8 0d cd ff ff       	call   c01003f4 <__panic>
c01036e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036ea:	05 00 00 00 40       	add    $0x40000000,%eax
c01036ef:	39 c2                	cmp    %eax,%edx
c01036f1:	75 0c                	jne    c01036ff <tlb_invalidate+0x5b>
        invlpg((void *)la);
c01036f3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01036f6:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c01036f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01036fc:	0f 01 38             	invlpg (%eax)
    }
}
c01036ff:	c9                   	leave  
c0103700:	c3                   	ret    

c0103701 <check_alloc_page>:

static void
check_alloc_page(void) {
c0103701:	55                   	push   %ebp
c0103702:	89 e5                	mov    %esp,%ebp
c0103704:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c0103707:	a1 70 af 11 c0       	mov    0xc011af70,%eax
c010370c:	8b 40 18             	mov    0x18(%eax),%eax
c010370f:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c0103711:	c7 04 24 68 69 10 c0 	movl   $0xc0106968,(%esp)
c0103718:	e8 80 cb ff ff       	call   c010029d <cprintf>
}
c010371d:	c9                   	leave  
c010371e:	c3                   	ret    

c010371f <check_pgdir>:

static void
check_pgdir(void) {
c010371f:	55                   	push   %ebp
c0103720:	89 e5                	mov    %esp,%ebp
c0103722:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c0103725:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c010372a:	3d 00 80 03 00       	cmp    $0x38000,%eax
c010372f:	76 24                	jbe    c0103755 <check_pgdir+0x36>
c0103731:	c7 44 24 0c 87 69 10 	movl   $0xc0106987,0xc(%esp)
c0103738:	c0 
c0103739:	c7 44 24 08 2d 69 10 	movl   $0xc010692d,0x8(%esp)
c0103740:	c0 
c0103741:	c7 44 24 04 f3 01 00 	movl   $0x1f3,0x4(%esp)
c0103748:	00 
c0103749:	c7 04 24 08 69 10 c0 	movl   $0xc0106908,(%esp)
c0103750:	e8 9f cc ff ff       	call   c01003f4 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c0103755:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c010375a:	85 c0                	test   %eax,%eax
c010375c:	74 0e                	je     c010376c <check_pgdir+0x4d>
c010375e:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103763:	25 ff 0f 00 00       	and    $0xfff,%eax
c0103768:	85 c0                	test   %eax,%eax
c010376a:	74 24                	je     c0103790 <check_pgdir+0x71>
c010376c:	c7 44 24 0c a4 69 10 	movl   $0xc01069a4,0xc(%esp)
c0103773:	c0 
c0103774:	c7 44 24 08 2d 69 10 	movl   $0xc010692d,0x8(%esp)
c010377b:	c0 
c010377c:	c7 44 24 04 f4 01 00 	movl   $0x1f4,0x4(%esp)
c0103783:	00 
c0103784:	c7 04 24 08 69 10 c0 	movl   $0xc0106908,(%esp)
c010378b:	e8 64 cc ff ff       	call   c01003f4 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c0103790:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103795:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010379c:	00 
c010379d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01037a4:	00 
c01037a5:	89 04 24             	mov    %eax,(%esp)
c01037a8:	e8 3b fd ff ff       	call   c01034e8 <get_page>
c01037ad:	85 c0                	test   %eax,%eax
c01037af:	74 24                	je     c01037d5 <check_pgdir+0xb6>
c01037b1:	c7 44 24 0c dc 69 10 	movl   $0xc01069dc,0xc(%esp)
c01037b8:	c0 
c01037b9:	c7 44 24 08 2d 69 10 	movl   $0xc010692d,0x8(%esp)
c01037c0:	c0 
c01037c1:	c7 44 24 04 f5 01 00 	movl   $0x1f5,0x4(%esp)
c01037c8:	00 
c01037c9:	c7 04 24 08 69 10 c0 	movl   $0xc0106908,(%esp)
c01037d0:	e8 1f cc ff ff       	call   c01003f4 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c01037d5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01037dc:	e8 13 f5 ff ff       	call   c0102cf4 <alloc_pages>
c01037e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c01037e4:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c01037e9:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01037f0:	00 
c01037f1:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01037f8:	00 
c01037f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01037fc:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103800:	89 04 24             	mov    %eax,(%esp)
c0103803:	e8 e3 fd ff ff       	call   c01035eb <page_insert>
c0103808:	85 c0                	test   %eax,%eax
c010380a:	74 24                	je     c0103830 <check_pgdir+0x111>
c010380c:	c7 44 24 0c 04 6a 10 	movl   $0xc0106a04,0xc(%esp)
c0103813:	c0 
c0103814:	c7 44 24 08 2d 69 10 	movl   $0xc010692d,0x8(%esp)
c010381b:	c0 
c010381c:	c7 44 24 04 f9 01 00 	movl   $0x1f9,0x4(%esp)
c0103823:	00 
c0103824:	c7 04 24 08 69 10 c0 	movl   $0xc0106908,(%esp)
c010382b:	e8 c4 cb ff ff       	call   c01003f4 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c0103830:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103835:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010383c:	00 
c010383d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0103844:	00 
c0103845:	89 04 24             	mov    %eax,(%esp)
c0103848:	e8 63 fb ff ff       	call   c01033b0 <get_pte>
c010384d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103850:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103854:	75 24                	jne    c010387a <check_pgdir+0x15b>
c0103856:	c7 44 24 0c 30 6a 10 	movl   $0xc0106a30,0xc(%esp)
c010385d:	c0 
c010385e:	c7 44 24 08 2d 69 10 	movl   $0xc010692d,0x8(%esp)
c0103865:	c0 
c0103866:	c7 44 24 04 fc 01 00 	movl   $0x1fc,0x4(%esp)
c010386d:	00 
c010386e:	c7 04 24 08 69 10 c0 	movl   $0xc0106908,(%esp)
c0103875:	e8 7a cb ff ff       	call   c01003f4 <__panic>
    assert(pte2page(*ptep) == p1);
c010387a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010387d:	8b 00                	mov    (%eax),%eax
c010387f:	89 04 24             	mov    %eax,(%esp)
c0103882:	e8 12 f2 ff ff       	call   c0102a99 <pte2page>
c0103887:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010388a:	74 24                	je     c01038b0 <check_pgdir+0x191>
c010388c:	c7 44 24 0c 5d 6a 10 	movl   $0xc0106a5d,0xc(%esp)
c0103893:	c0 
c0103894:	c7 44 24 08 2d 69 10 	movl   $0xc010692d,0x8(%esp)
c010389b:	c0 
c010389c:	c7 44 24 04 fd 01 00 	movl   $0x1fd,0x4(%esp)
c01038a3:	00 
c01038a4:	c7 04 24 08 69 10 c0 	movl   $0xc0106908,(%esp)
c01038ab:	e8 44 cb ff ff       	call   c01003f4 <__panic>
    assert(page_ref(p1) == 1);
c01038b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01038b3:	89 04 24             	mov    %eax,(%esp)
c01038b6:	e8 34 f2 ff ff       	call   c0102aef <page_ref>
c01038bb:	83 f8 01             	cmp    $0x1,%eax
c01038be:	74 24                	je     c01038e4 <check_pgdir+0x1c5>
c01038c0:	c7 44 24 0c 73 6a 10 	movl   $0xc0106a73,0xc(%esp)
c01038c7:	c0 
c01038c8:	c7 44 24 08 2d 69 10 	movl   $0xc010692d,0x8(%esp)
c01038cf:	c0 
c01038d0:	c7 44 24 04 fe 01 00 	movl   $0x1fe,0x4(%esp)
c01038d7:	00 
c01038d8:	c7 04 24 08 69 10 c0 	movl   $0xc0106908,(%esp)
c01038df:	e8 10 cb ff ff       	call   c01003f4 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c01038e4:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c01038e9:	8b 00                	mov    (%eax),%eax
c01038eb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01038f0:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01038f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01038f6:	c1 e8 0c             	shr    $0xc,%eax
c01038f9:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01038fc:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c0103901:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0103904:	72 23                	jb     c0103929 <check_pgdir+0x20a>
c0103906:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103909:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010390d:	c7 44 24 08 40 68 10 	movl   $0xc0106840,0x8(%esp)
c0103914:	c0 
c0103915:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
c010391c:	00 
c010391d:	c7 04 24 08 69 10 c0 	movl   $0xc0106908,(%esp)
c0103924:	e8 cb ca ff ff       	call   c01003f4 <__panic>
c0103929:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010392c:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0103931:	83 c0 04             	add    $0x4,%eax
c0103934:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c0103937:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c010393c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103943:	00 
c0103944:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c010394b:	00 
c010394c:	89 04 24             	mov    %eax,(%esp)
c010394f:	e8 5c fa ff ff       	call   c01033b0 <get_pte>
c0103954:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0103957:	74 24                	je     c010397d <check_pgdir+0x25e>
c0103959:	c7 44 24 0c 88 6a 10 	movl   $0xc0106a88,0xc(%esp)
c0103960:	c0 
c0103961:	c7 44 24 08 2d 69 10 	movl   $0xc010692d,0x8(%esp)
c0103968:	c0 
c0103969:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
c0103970:	00 
c0103971:	c7 04 24 08 69 10 c0 	movl   $0xc0106908,(%esp)
c0103978:	e8 77 ca ff ff       	call   c01003f4 <__panic>

    p2 = alloc_page();
c010397d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103984:	e8 6b f3 ff ff       	call   c0102cf4 <alloc_pages>
c0103989:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c010398c:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103991:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c0103998:	00 
c0103999:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c01039a0:	00 
c01039a1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01039a4:	89 54 24 04          	mov    %edx,0x4(%esp)
c01039a8:	89 04 24             	mov    %eax,(%esp)
c01039ab:	e8 3b fc ff ff       	call   c01035eb <page_insert>
c01039b0:	85 c0                	test   %eax,%eax
c01039b2:	74 24                	je     c01039d8 <check_pgdir+0x2b9>
c01039b4:	c7 44 24 0c b0 6a 10 	movl   $0xc0106ab0,0xc(%esp)
c01039bb:	c0 
c01039bc:	c7 44 24 08 2d 69 10 	movl   $0xc010692d,0x8(%esp)
c01039c3:	c0 
c01039c4:	c7 44 24 04 04 02 00 	movl   $0x204,0x4(%esp)
c01039cb:	00 
c01039cc:	c7 04 24 08 69 10 c0 	movl   $0xc0106908,(%esp)
c01039d3:	e8 1c ca ff ff       	call   c01003f4 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c01039d8:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c01039dd:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01039e4:	00 
c01039e5:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01039ec:	00 
c01039ed:	89 04 24             	mov    %eax,(%esp)
c01039f0:	e8 bb f9 ff ff       	call   c01033b0 <get_pte>
c01039f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01039f8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01039fc:	75 24                	jne    c0103a22 <check_pgdir+0x303>
c01039fe:	c7 44 24 0c e8 6a 10 	movl   $0xc0106ae8,0xc(%esp)
c0103a05:	c0 
c0103a06:	c7 44 24 08 2d 69 10 	movl   $0xc010692d,0x8(%esp)
c0103a0d:	c0 
c0103a0e:	c7 44 24 04 05 02 00 	movl   $0x205,0x4(%esp)
c0103a15:	00 
c0103a16:	c7 04 24 08 69 10 c0 	movl   $0xc0106908,(%esp)
c0103a1d:	e8 d2 c9 ff ff       	call   c01003f4 <__panic>
    assert(*ptep & PTE_U);
c0103a22:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103a25:	8b 00                	mov    (%eax),%eax
c0103a27:	83 e0 04             	and    $0x4,%eax
c0103a2a:	85 c0                	test   %eax,%eax
c0103a2c:	75 24                	jne    c0103a52 <check_pgdir+0x333>
c0103a2e:	c7 44 24 0c 18 6b 10 	movl   $0xc0106b18,0xc(%esp)
c0103a35:	c0 
c0103a36:	c7 44 24 08 2d 69 10 	movl   $0xc010692d,0x8(%esp)
c0103a3d:	c0 
c0103a3e:	c7 44 24 04 06 02 00 	movl   $0x206,0x4(%esp)
c0103a45:	00 
c0103a46:	c7 04 24 08 69 10 c0 	movl   $0xc0106908,(%esp)
c0103a4d:	e8 a2 c9 ff ff       	call   c01003f4 <__panic>
    assert(*ptep & PTE_W);
c0103a52:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103a55:	8b 00                	mov    (%eax),%eax
c0103a57:	83 e0 02             	and    $0x2,%eax
c0103a5a:	85 c0                	test   %eax,%eax
c0103a5c:	75 24                	jne    c0103a82 <check_pgdir+0x363>
c0103a5e:	c7 44 24 0c 26 6b 10 	movl   $0xc0106b26,0xc(%esp)
c0103a65:	c0 
c0103a66:	c7 44 24 08 2d 69 10 	movl   $0xc010692d,0x8(%esp)
c0103a6d:	c0 
c0103a6e:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
c0103a75:	00 
c0103a76:	c7 04 24 08 69 10 c0 	movl   $0xc0106908,(%esp)
c0103a7d:	e8 72 c9 ff ff       	call   c01003f4 <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0103a82:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103a87:	8b 00                	mov    (%eax),%eax
c0103a89:	83 e0 04             	and    $0x4,%eax
c0103a8c:	85 c0                	test   %eax,%eax
c0103a8e:	75 24                	jne    c0103ab4 <check_pgdir+0x395>
c0103a90:	c7 44 24 0c 34 6b 10 	movl   $0xc0106b34,0xc(%esp)
c0103a97:	c0 
c0103a98:	c7 44 24 08 2d 69 10 	movl   $0xc010692d,0x8(%esp)
c0103a9f:	c0 
c0103aa0:	c7 44 24 04 08 02 00 	movl   $0x208,0x4(%esp)
c0103aa7:	00 
c0103aa8:	c7 04 24 08 69 10 c0 	movl   $0xc0106908,(%esp)
c0103aaf:	e8 40 c9 ff ff       	call   c01003f4 <__panic>
    assert(page_ref(p2) == 1);
c0103ab4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103ab7:	89 04 24             	mov    %eax,(%esp)
c0103aba:	e8 30 f0 ff ff       	call   c0102aef <page_ref>
c0103abf:	83 f8 01             	cmp    $0x1,%eax
c0103ac2:	74 24                	je     c0103ae8 <check_pgdir+0x3c9>
c0103ac4:	c7 44 24 0c 4a 6b 10 	movl   $0xc0106b4a,0xc(%esp)
c0103acb:	c0 
c0103acc:	c7 44 24 08 2d 69 10 	movl   $0xc010692d,0x8(%esp)
c0103ad3:	c0 
c0103ad4:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
c0103adb:	00 
c0103adc:	c7 04 24 08 69 10 c0 	movl   $0xc0106908,(%esp)
c0103ae3:	e8 0c c9 ff ff       	call   c01003f4 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0103ae8:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103aed:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0103af4:	00 
c0103af5:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0103afc:	00 
c0103afd:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103b00:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103b04:	89 04 24             	mov    %eax,(%esp)
c0103b07:	e8 df fa ff ff       	call   c01035eb <page_insert>
c0103b0c:	85 c0                	test   %eax,%eax
c0103b0e:	74 24                	je     c0103b34 <check_pgdir+0x415>
c0103b10:	c7 44 24 0c 5c 6b 10 	movl   $0xc0106b5c,0xc(%esp)
c0103b17:	c0 
c0103b18:	c7 44 24 08 2d 69 10 	movl   $0xc010692d,0x8(%esp)
c0103b1f:	c0 
c0103b20:	c7 44 24 04 0b 02 00 	movl   $0x20b,0x4(%esp)
c0103b27:	00 
c0103b28:	c7 04 24 08 69 10 c0 	movl   $0xc0106908,(%esp)
c0103b2f:	e8 c0 c8 ff ff       	call   c01003f4 <__panic>
    assert(page_ref(p1) == 2);
c0103b34:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b37:	89 04 24             	mov    %eax,(%esp)
c0103b3a:	e8 b0 ef ff ff       	call   c0102aef <page_ref>
c0103b3f:	83 f8 02             	cmp    $0x2,%eax
c0103b42:	74 24                	je     c0103b68 <check_pgdir+0x449>
c0103b44:	c7 44 24 0c 88 6b 10 	movl   $0xc0106b88,0xc(%esp)
c0103b4b:	c0 
c0103b4c:	c7 44 24 08 2d 69 10 	movl   $0xc010692d,0x8(%esp)
c0103b53:	c0 
c0103b54:	c7 44 24 04 0c 02 00 	movl   $0x20c,0x4(%esp)
c0103b5b:	00 
c0103b5c:	c7 04 24 08 69 10 c0 	movl   $0xc0106908,(%esp)
c0103b63:	e8 8c c8 ff ff       	call   c01003f4 <__panic>
    assert(page_ref(p2) == 0);
c0103b68:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103b6b:	89 04 24             	mov    %eax,(%esp)
c0103b6e:	e8 7c ef ff ff       	call   c0102aef <page_ref>
c0103b73:	85 c0                	test   %eax,%eax
c0103b75:	74 24                	je     c0103b9b <check_pgdir+0x47c>
c0103b77:	c7 44 24 0c 9a 6b 10 	movl   $0xc0106b9a,0xc(%esp)
c0103b7e:	c0 
c0103b7f:	c7 44 24 08 2d 69 10 	movl   $0xc010692d,0x8(%esp)
c0103b86:	c0 
c0103b87:	c7 44 24 04 0d 02 00 	movl   $0x20d,0x4(%esp)
c0103b8e:	00 
c0103b8f:	c7 04 24 08 69 10 c0 	movl   $0xc0106908,(%esp)
c0103b96:	e8 59 c8 ff ff       	call   c01003f4 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0103b9b:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103ba0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103ba7:	00 
c0103ba8:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0103baf:	00 
c0103bb0:	89 04 24             	mov    %eax,(%esp)
c0103bb3:	e8 f8 f7 ff ff       	call   c01033b0 <get_pte>
c0103bb8:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103bbb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103bbf:	75 24                	jne    c0103be5 <check_pgdir+0x4c6>
c0103bc1:	c7 44 24 0c e8 6a 10 	movl   $0xc0106ae8,0xc(%esp)
c0103bc8:	c0 
c0103bc9:	c7 44 24 08 2d 69 10 	movl   $0xc010692d,0x8(%esp)
c0103bd0:	c0 
c0103bd1:	c7 44 24 04 0e 02 00 	movl   $0x20e,0x4(%esp)
c0103bd8:	00 
c0103bd9:	c7 04 24 08 69 10 c0 	movl   $0xc0106908,(%esp)
c0103be0:	e8 0f c8 ff ff       	call   c01003f4 <__panic>
    assert(pte2page(*ptep) == p1);
c0103be5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103be8:	8b 00                	mov    (%eax),%eax
c0103bea:	89 04 24             	mov    %eax,(%esp)
c0103bed:	e8 a7 ee ff ff       	call   c0102a99 <pte2page>
c0103bf2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103bf5:	74 24                	je     c0103c1b <check_pgdir+0x4fc>
c0103bf7:	c7 44 24 0c 5d 6a 10 	movl   $0xc0106a5d,0xc(%esp)
c0103bfe:	c0 
c0103bff:	c7 44 24 08 2d 69 10 	movl   $0xc010692d,0x8(%esp)
c0103c06:	c0 
c0103c07:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
c0103c0e:	00 
c0103c0f:	c7 04 24 08 69 10 c0 	movl   $0xc0106908,(%esp)
c0103c16:	e8 d9 c7 ff ff       	call   c01003f4 <__panic>
    assert((*ptep & PTE_U) == 0);
c0103c1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103c1e:	8b 00                	mov    (%eax),%eax
c0103c20:	83 e0 04             	and    $0x4,%eax
c0103c23:	85 c0                	test   %eax,%eax
c0103c25:	74 24                	je     c0103c4b <check_pgdir+0x52c>
c0103c27:	c7 44 24 0c ac 6b 10 	movl   $0xc0106bac,0xc(%esp)
c0103c2e:	c0 
c0103c2f:	c7 44 24 08 2d 69 10 	movl   $0xc010692d,0x8(%esp)
c0103c36:	c0 
c0103c37:	c7 44 24 04 10 02 00 	movl   $0x210,0x4(%esp)
c0103c3e:	00 
c0103c3f:	c7 04 24 08 69 10 c0 	movl   $0xc0106908,(%esp)
c0103c46:	e8 a9 c7 ff ff       	call   c01003f4 <__panic>

    page_remove(boot_pgdir, 0x0);
c0103c4b:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103c50:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0103c57:	00 
c0103c58:	89 04 24             	mov    %eax,(%esp)
c0103c5b:	e8 47 f9 ff ff       	call   c01035a7 <page_remove>
    assert(page_ref(p1) == 1);
c0103c60:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103c63:	89 04 24             	mov    %eax,(%esp)
c0103c66:	e8 84 ee ff ff       	call   c0102aef <page_ref>
c0103c6b:	83 f8 01             	cmp    $0x1,%eax
c0103c6e:	74 24                	je     c0103c94 <check_pgdir+0x575>
c0103c70:	c7 44 24 0c 73 6a 10 	movl   $0xc0106a73,0xc(%esp)
c0103c77:	c0 
c0103c78:	c7 44 24 08 2d 69 10 	movl   $0xc010692d,0x8(%esp)
c0103c7f:	c0 
c0103c80:	c7 44 24 04 13 02 00 	movl   $0x213,0x4(%esp)
c0103c87:	00 
c0103c88:	c7 04 24 08 69 10 c0 	movl   $0xc0106908,(%esp)
c0103c8f:	e8 60 c7 ff ff       	call   c01003f4 <__panic>
    assert(page_ref(p2) == 0);
c0103c94:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103c97:	89 04 24             	mov    %eax,(%esp)
c0103c9a:	e8 50 ee ff ff       	call   c0102aef <page_ref>
c0103c9f:	85 c0                	test   %eax,%eax
c0103ca1:	74 24                	je     c0103cc7 <check_pgdir+0x5a8>
c0103ca3:	c7 44 24 0c 9a 6b 10 	movl   $0xc0106b9a,0xc(%esp)
c0103caa:	c0 
c0103cab:	c7 44 24 08 2d 69 10 	movl   $0xc010692d,0x8(%esp)
c0103cb2:	c0 
c0103cb3:	c7 44 24 04 14 02 00 	movl   $0x214,0x4(%esp)
c0103cba:	00 
c0103cbb:	c7 04 24 08 69 10 c0 	movl   $0xc0106908,(%esp)
c0103cc2:	e8 2d c7 ff ff       	call   c01003f4 <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0103cc7:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103ccc:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0103cd3:	00 
c0103cd4:	89 04 24             	mov    %eax,(%esp)
c0103cd7:	e8 cb f8 ff ff       	call   c01035a7 <page_remove>
    assert(page_ref(p1) == 0);
c0103cdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103cdf:	89 04 24             	mov    %eax,(%esp)
c0103ce2:	e8 08 ee ff ff       	call   c0102aef <page_ref>
c0103ce7:	85 c0                	test   %eax,%eax
c0103ce9:	74 24                	je     c0103d0f <check_pgdir+0x5f0>
c0103ceb:	c7 44 24 0c c1 6b 10 	movl   $0xc0106bc1,0xc(%esp)
c0103cf2:	c0 
c0103cf3:	c7 44 24 08 2d 69 10 	movl   $0xc010692d,0x8(%esp)
c0103cfa:	c0 
c0103cfb:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
c0103d02:	00 
c0103d03:	c7 04 24 08 69 10 c0 	movl   $0xc0106908,(%esp)
c0103d0a:	e8 e5 c6 ff ff       	call   c01003f4 <__panic>
    assert(page_ref(p2) == 0);
c0103d0f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103d12:	89 04 24             	mov    %eax,(%esp)
c0103d15:	e8 d5 ed ff ff       	call   c0102aef <page_ref>
c0103d1a:	85 c0                	test   %eax,%eax
c0103d1c:	74 24                	je     c0103d42 <check_pgdir+0x623>
c0103d1e:	c7 44 24 0c 9a 6b 10 	movl   $0xc0106b9a,0xc(%esp)
c0103d25:	c0 
c0103d26:	c7 44 24 08 2d 69 10 	movl   $0xc010692d,0x8(%esp)
c0103d2d:	c0 
c0103d2e:	c7 44 24 04 18 02 00 	movl   $0x218,0x4(%esp)
c0103d35:	00 
c0103d36:	c7 04 24 08 69 10 c0 	movl   $0xc0106908,(%esp)
c0103d3d:	e8 b2 c6 ff ff       	call   c01003f4 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
c0103d42:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103d47:	8b 00                	mov    (%eax),%eax
c0103d49:	89 04 24             	mov    %eax,(%esp)
c0103d4c:	e8 86 ed ff ff       	call   c0102ad7 <pde2page>
c0103d51:	89 04 24             	mov    %eax,(%esp)
c0103d54:	e8 96 ed ff ff       	call   c0102aef <page_ref>
c0103d59:	83 f8 01             	cmp    $0x1,%eax
c0103d5c:	74 24                	je     c0103d82 <check_pgdir+0x663>
c0103d5e:	c7 44 24 0c d4 6b 10 	movl   $0xc0106bd4,0xc(%esp)
c0103d65:	c0 
c0103d66:	c7 44 24 08 2d 69 10 	movl   $0xc010692d,0x8(%esp)
c0103d6d:	c0 
c0103d6e:	c7 44 24 04 1a 02 00 	movl   $0x21a,0x4(%esp)
c0103d75:	00 
c0103d76:	c7 04 24 08 69 10 c0 	movl   $0xc0106908,(%esp)
c0103d7d:	e8 72 c6 ff ff       	call   c01003f4 <__panic>
    free_page(pde2page(boot_pgdir[0]));
c0103d82:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103d87:	8b 00                	mov    (%eax),%eax
c0103d89:	89 04 24             	mov    %eax,(%esp)
c0103d8c:	e8 46 ed ff ff       	call   c0102ad7 <pde2page>
c0103d91:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103d98:	00 
c0103d99:	89 04 24             	mov    %eax,(%esp)
c0103d9c:	e8 8b ef ff ff       	call   c0102d2c <free_pages>
    boot_pgdir[0] = 0;
c0103da1:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103da6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0103dac:	c7 04 24 fb 6b 10 c0 	movl   $0xc0106bfb,(%esp)
c0103db3:	e8 e5 c4 ff ff       	call   c010029d <cprintf>
}
c0103db8:	c9                   	leave  
c0103db9:	c3                   	ret    

c0103dba <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0103dba:	55                   	push   %ebp
c0103dbb:	89 e5                	mov    %esp,%ebp
c0103dbd:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0103dc0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103dc7:	e9 ca 00 00 00       	jmp    c0103e96 <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0103dcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103dcf:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103dd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103dd5:	c1 e8 0c             	shr    $0xc,%eax
c0103dd8:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103ddb:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c0103de0:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0103de3:	72 23                	jb     c0103e08 <check_boot_pgdir+0x4e>
c0103de5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103de8:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103dec:	c7 44 24 08 40 68 10 	movl   $0xc0106840,0x8(%esp)
c0103df3:	c0 
c0103df4:	c7 44 24 04 26 02 00 	movl   $0x226,0x4(%esp)
c0103dfb:	00 
c0103dfc:	c7 04 24 08 69 10 c0 	movl   $0xc0106908,(%esp)
c0103e03:	e8 ec c5 ff ff       	call   c01003f4 <__panic>
c0103e08:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103e0b:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0103e10:	89 c2                	mov    %eax,%edx
c0103e12:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103e17:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103e1e:	00 
c0103e1f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103e23:	89 04 24             	mov    %eax,(%esp)
c0103e26:	e8 85 f5 ff ff       	call   c01033b0 <get_pte>
c0103e2b:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103e2e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0103e32:	75 24                	jne    c0103e58 <check_boot_pgdir+0x9e>
c0103e34:	c7 44 24 0c 18 6c 10 	movl   $0xc0106c18,0xc(%esp)
c0103e3b:	c0 
c0103e3c:	c7 44 24 08 2d 69 10 	movl   $0xc010692d,0x8(%esp)
c0103e43:	c0 
c0103e44:	c7 44 24 04 26 02 00 	movl   $0x226,0x4(%esp)
c0103e4b:	00 
c0103e4c:	c7 04 24 08 69 10 c0 	movl   $0xc0106908,(%esp)
c0103e53:	e8 9c c5 ff ff       	call   c01003f4 <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0103e58:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103e5b:	8b 00                	mov    (%eax),%eax
c0103e5d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103e62:	89 c2                	mov    %eax,%edx
c0103e64:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103e67:	39 c2                	cmp    %eax,%edx
c0103e69:	74 24                	je     c0103e8f <check_boot_pgdir+0xd5>
c0103e6b:	c7 44 24 0c 55 6c 10 	movl   $0xc0106c55,0xc(%esp)
c0103e72:	c0 
c0103e73:	c7 44 24 08 2d 69 10 	movl   $0xc010692d,0x8(%esp)
c0103e7a:	c0 
c0103e7b:	c7 44 24 04 27 02 00 	movl   $0x227,0x4(%esp)
c0103e82:	00 
c0103e83:	c7 04 24 08 69 10 c0 	movl   $0xc0106908,(%esp)
c0103e8a:	e8 65 c5 ff ff       	call   c01003f4 <__panic>
    for (i = 0; i < npage; i += PGSIZE) {
c0103e8f:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0103e96:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103e99:	a1 80 ae 11 c0       	mov    0xc011ae80,%eax
c0103e9e:	39 c2                	cmp    %eax,%edx
c0103ea0:	0f 82 26 ff ff ff    	jb     c0103dcc <check_boot_pgdir+0x12>
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0103ea6:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103eab:	05 ac 0f 00 00       	add    $0xfac,%eax
c0103eb0:	8b 00                	mov    (%eax),%eax
c0103eb2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103eb7:	89 c2                	mov    %eax,%edx
c0103eb9:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103ebe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103ec1:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c0103ec8:	77 23                	ja     c0103eed <check_boot_pgdir+0x133>
c0103eca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103ecd:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103ed1:	c7 44 24 08 e4 68 10 	movl   $0xc01068e4,0x8(%esp)
c0103ed8:	c0 
c0103ed9:	c7 44 24 04 2a 02 00 	movl   $0x22a,0x4(%esp)
c0103ee0:	00 
c0103ee1:	c7 04 24 08 69 10 c0 	movl   $0xc0106908,(%esp)
c0103ee8:	e8 07 c5 ff ff       	call   c01003f4 <__panic>
c0103eed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103ef0:	05 00 00 00 40       	add    $0x40000000,%eax
c0103ef5:	39 c2                	cmp    %eax,%edx
c0103ef7:	74 24                	je     c0103f1d <check_boot_pgdir+0x163>
c0103ef9:	c7 44 24 0c 6c 6c 10 	movl   $0xc0106c6c,0xc(%esp)
c0103f00:	c0 
c0103f01:	c7 44 24 08 2d 69 10 	movl   $0xc010692d,0x8(%esp)
c0103f08:	c0 
c0103f09:	c7 44 24 04 2a 02 00 	movl   $0x22a,0x4(%esp)
c0103f10:	00 
c0103f11:	c7 04 24 08 69 10 c0 	movl   $0xc0106908,(%esp)
c0103f18:	e8 d7 c4 ff ff       	call   c01003f4 <__panic>

    assert(boot_pgdir[0] == 0);
c0103f1d:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103f22:	8b 00                	mov    (%eax),%eax
c0103f24:	85 c0                	test   %eax,%eax
c0103f26:	74 24                	je     c0103f4c <check_boot_pgdir+0x192>
c0103f28:	c7 44 24 0c a0 6c 10 	movl   $0xc0106ca0,0xc(%esp)
c0103f2f:	c0 
c0103f30:	c7 44 24 08 2d 69 10 	movl   $0xc010692d,0x8(%esp)
c0103f37:	c0 
c0103f38:	c7 44 24 04 2c 02 00 	movl   $0x22c,0x4(%esp)
c0103f3f:	00 
c0103f40:	c7 04 24 08 69 10 c0 	movl   $0xc0106908,(%esp)
c0103f47:	e8 a8 c4 ff ff       	call   c01003f4 <__panic>

    struct Page *p;
    p = alloc_page();
c0103f4c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103f53:	e8 9c ed ff ff       	call   c0102cf4 <alloc_pages>
c0103f58:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0103f5b:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103f60:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0103f67:	00 
c0103f68:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c0103f6f:	00 
c0103f70:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0103f73:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103f77:	89 04 24             	mov    %eax,(%esp)
c0103f7a:	e8 6c f6 ff ff       	call   c01035eb <page_insert>
c0103f7f:	85 c0                	test   %eax,%eax
c0103f81:	74 24                	je     c0103fa7 <check_boot_pgdir+0x1ed>
c0103f83:	c7 44 24 0c b4 6c 10 	movl   $0xc0106cb4,0xc(%esp)
c0103f8a:	c0 
c0103f8b:	c7 44 24 08 2d 69 10 	movl   $0xc010692d,0x8(%esp)
c0103f92:	c0 
c0103f93:	c7 44 24 04 30 02 00 	movl   $0x230,0x4(%esp)
c0103f9a:	00 
c0103f9b:	c7 04 24 08 69 10 c0 	movl   $0xc0106908,(%esp)
c0103fa2:	e8 4d c4 ff ff       	call   c01003f4 <__panic>
    assert(page_ref(p) == 1);
c0103fa7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103faa:	89 04 24             	mov    %eax,(%esp)
c0103fad:	e8 3d eb ff ff       	call   c0102aef <page_ref>
c0103fb2:	83 f8 01             	cmp    $0x1,%eax
c0103fb5:	74 24                	je     c0103fdb <check_boot_pgdir+0x221>
c0103fb7:	c7 44 24 0c e2 6c 10 	movl   $0xc0106ce2,0xc(%esp)
c0103fbe:	c0 
c0103fbf:	c7 44 24 08 2d 69 10 	movl   $0xc010692d,0x8(%esp)
c0103fc6:	c0 
c0103fc7:	c7 44 24 04 31 02 00 	movl   $0x231,0x4(%esp)
c0103fce:	00 
c0103fcf:	c7 04 24 08 69 10 c0 	movl   $0xc0106908,(%esp)
c0103fd6:	e8 19 c4 ff ff       	call   c01003f4 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0103fdb:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103fe0:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0103fe7:	00 
c0103fe8:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c0103fef:	00 
c0103ff0:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0103ff3:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103ff7:	89 04 24             	mov    %eax,(%esp)
c0103ffa:	e8 ec f5 ff ff       	call   c01035eb <page_insert>
c0103fff:	85 c0                	test   %eax,%eax
c0104001:	74 24                	je     c0104027 <check_boot_pgdir+0x26d>
c0104003:	c7 44 24 0c f4 6c 10 	movl   $0xc0106cf4,0xc(%esp)
c010400a:	c0 
c010400b:	c7 44 24 08 2d 69 10 	movl   $0xc010692d,0x8(%esp)
c0104012:	c0 
c0104013:	c7 44 24 04 32 02 00 	movl   $0x232,0x4(%esp)
c010401a:	00 
c010401b:	c7 04 24 08 69 10 c0 	movl   $0xc0106908,(%esp)
c0104022:	e8 cd c3 ff ff       	call   c01003f4 <__panic>
    assert(page_ref(p) == 2);
c0104027:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010402a:	89 04 24             	mov    %eax,(%esp)
c010402d:	e8 bd ea ff ff       	call   c0102aef <page_ref>
c0104032:	83 f8 02             	cmp    $0x2,%eax
c0104035:	74 24                	je     c010405b <check_boot_pgdir+0x2a1>
c0104037:	c7 44 24 0c 2b 6d 10 	movl   $0xc0106d2b,0xc(%esp)
c010403e:	c0 
c010403f:	c7 44 24 08 2d 69 10 	movl   $0xc010692d,0x8(%esp)
c0104046:	c0 
c0104047:	c7 44 24 04 33 02 00 	movl   $0x233,0x4(%esp)
c010404e:	00 
c010404f:	c7 04 24 08 69 10 c0 	movl   $0xc0106908,(%esp)
c0104056:	e8 99 c3 ff ff       	call   c01003f4 <__panic>

    const char *str = "ucore: Hello world!!";
c010405b:	c7 45 dc 3c 6d 10 c0 	movl   $0xc0106d3c,-0x24(%ebp)
    strcpy((void *)0x100, str);
c0104062:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104065:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104069:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0104070:	e8 74 15 00 00       	call   c01055e9 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c0104075:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c010407c:	00 
c010407d:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0104084:	e8 d9 15 00 00       	call   c0105662 <strcmp>
c0104089:	85 c0                	test   %eax,%eax
c010408b:	74 24                	je     c01040b1 <check_boot_pgdir+0x2f7>
c010408d:	c7 44 24 0c 54 6d 10 	movl   $0xc0106d54,0xc(%esp)
c0104094:	c0 
c0104095:	c7 44 24 08 2d 69 10 	movl   $0xc010692d,0x8(%esp)
c010409c:	c0 
c010409d:	c7 44 24 04 37 02 00 	movl   $0x237,0x4(%esp)
c01040a4:	00 
c01040a5:	c7 04 24 08 69 10 c0 	movl   $0xc0106908,(%esp)
c01040ac:	e8 43 c3 ff ff       	call   c01003f4 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c01040b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01040b4:	89 04 24             	mov    %eax,(%esp)
c01040b7:	e8 89 e9 ff ff       	call   c0102a45 <page2kva>
c01040bc:	05 00 01 00 00       	add    $0x100,%eax
c01040c1:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c01040c4:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c01040cb:	e8 c1 14 00 00       	call   c0105591 <strlen>
c01040d0:	85 c0                	test   %eax,%eax
c01040d2:	74 24                	je     c01040f8 <check_boot_pgdir+0x33e>
c01040d4:	c7 44 24 0c 8c 6d 10 	movl   $0xc0106d8c,0xc(%esp)
c01040db:	c0 
c01040dc:	c7 44 24 08 2d 69 10 	movl   $0xc010692d,0x8(%esp)
c01040e3:	c0 
c01040e4:	c7 44 24 04 3a 02 00 	movl   $0x23a,0x4(%esp)
c01040eb:	00 
c01040ec:	c7 04 24 08 69 10 c0 	movl   $0xc0106908,(%esp)
c01040f3:	e8 fc c2 ff ff       	call   c01003f4 <__panic>

    free_page(p);
c01040f8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01040ff:	00 
c0104100:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104103:	89 04 24             	mov    %eax,(%esp)
c0104106:	e8 21 ec ff ff       	call   c0102d2c <free_pages>
    free_page(pde2page(boot_pgdir[0]));
c010410b:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0104110:	8b 00                	mov    (%eax),%eax
c0104112:	89 04 24             	mov    %eax,(%esp)
c0104115:	e8 bd e9 ff ff       	call   c0102ad7 <pde2page>
c010411a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104121:	00 
c0104122:	89 04 24             	mov    %eax,(%esp)
c0104125:	e8 02 ec ff ff       	call   c0102d2c <free_pages>
    boot_pgdir[0] = 0;
c010412a:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c010412f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c0104135:	c7 04 24 b0 6d 10 c0 	movl   $0xc0106db0,(%esp)
c010413c:	e8 5c c1 ff ff       	call   c010029d <cprintf>
}
c0104141:	c9                   	leave  
c0104142:	c3                   	ret    

c0104143 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c0104143:	55                   	push   %ebp
c0104144:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c0104146:	8b 45 08             	mov    0x8(%ebp),%eax
c0104149:	83 e0 04             	and    $0x4,%eax
c010414c:	85 c0                	test   %eax,%eax
c010414e:	74 07                	je     c0104157 <perm2str+0x14>
c0104150:	b8 75 00 00 00       	mov    $0x75,%eax
c0104155:	eb 05                	jmp    c010415c <perm2str+0x19>
c0104157:	b8 2d 00 00 00       	mov    $0x2d,%eax
c010415c:	a2 08 af 11 c0       	mov    %al,0xc011af08
    str[1] = 'r';
c0104161:	c6 05 09 af 11 c0 72 	movb   $0x72,0xc011af09
    str[2] = (perm & PTE_W) ? 'w' : '-';
c0104168:	8b 45 08             	mov    0x8(%ebp),%eax
c010416b:	83 e0 02             	and    $0x2,%eax
c010416e:	85 c0                	test   %eax,%eax
c0104170:	74 07                	je     c0104179 <perm2str+0x36>
c0104172:	b8 77 00 00 00       	mov    $0x77,%eax
c0104177:	eb 05                	jmp    c010417e <perm2str+0x3b>
c0104179:	b8 2d 00 00 00       	mov    $0x2d,%eax
c010417e:	a2 0a af 11 c0       	mov    %al,0xc011af0a
    str[3] = '\0';
c0104183:	c6 05 0b af 11 c0 00 	movb   $0x0,0xc011af0b
    return str;
c010418a:	b8 08 af 11 c0       	mov    $0xc011af08,%eax
}
c010418f:	5d                   	pop    %ebp
c0104190:	c3                   	ret    

c0104191 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c0104191:	55                   	push   %ebp
c0104192:	89 e5                	mov    %esp,%ebp
c0104194:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c0104197:	8b 45 10             	mov    0x10(%ebp),%eax
c010419a:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010419d:	72 0a                	jb     c01041a9 <get_pgtable_items+0x18>
        return 0;
c010419f:	b8 00 00 00 00       	mov    $0x0,%eax
c01041a4:	e9 9c 00 00 00       	jmp    c0104245 <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
c01041a9:	eb 04                	jmp    c01041af <get_pgtable_items+0x1e>
        start ++;
c01041ab:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    while (start < right && !(table[start] & PTE_P)) {
c01041af:	8b 45 10             	mov    0x10(%ebp),%eax
c01041b2:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01041b5:	73 18                	jae    c01041cf <get_pgtable_items+0x3e>
c01041b7:	8b 45 10             	mov    0x10(%ebp),%eax
c01041ba:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01041c1:	8b 45 14             	mov    0x14(%ebp),%eax
c01041c4:	01 d0                	add    %edx,%eax
c01041c6:	8b 00                	mov    (%eax),%eax
c01041c8:	83 e0 01             	and    $0x1,%eax
c01041cb:	85 c0                	test   %eax,%eax
c01041cd:	74 dc                	je     c01041ab <get_pgtable_items+0x1a>
    }
    if (start < right) {
c01041cf:	8b 45 10             	mov    0x10(%ebp),%eax
c01041d2:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01041d5:	73 69                	jae    c0104240 <get_pgtable_items+0xaf>
        if (left_store != NULL) {
c01041d7:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c01041db:	74 08                	je     c01041e5 <get_pgtable_items+0x54>
            *left_store = start;
c01041dd:	8b 45 18             	mov    0x18(%ebp),%eax
c01041e0:	8b 55 10             	mov    0x10(%ebp),%edx
c01041e3:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c01041e5:	8b 45 10             	mov    0x10(%ebp),%eax
c01041e8:	8d 50 01             	lea    0x1(%eax),%edx
c01041eb:	89 55 10             	mov    %edx,0x10(%ebp)
c01041ee:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01041f5:	8b 45 14             	mov    0x14(%ebp),%eax
c01041f8:	01 d0                	add    %edx,%eax
c01041fa:	8b 00                	mov    (%eax),%eax
c01041fc:	83 e0 07             	and    $0x7,%eax
c01041ff:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0104202:	eb 04                	jmp    c0104208 <get_pgtable_items+0x77>
            start ++;
c0104204:	83 45 10 01          	addl   $0x1,0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0104208:	8b 45 10             	mov    0x10(%ebp),%eax
c010420b:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010420e:	73 1d                	jae    c010422d <get_pgtable_items+0x9c>
c0104210:	8b 45 10             	mov    0x10(%ebp),%eax
c0104213:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010421a:	8b 45 14             	mov    0x14(%ebp),%eax
c010421d:	01 d0                	add    %edx,%eax
c010421f:	8b 00                	mov    (%eax),%eax
c0104221:	83 e0 07             	and    $0x7,%eax
c0104224:	89 c2                	mov    %eax,%edx
c0104226:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104229:	39 c2                	cmp    %eax,%edx
c010422b:	74 d7                	je     c0104204 <get_pgtable_items+0x73>
        }
        if (right_store != NULL) {
c010422d:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0104231:	74 08                	je     c010423b <get_pgtable_items+0xaa>
            *right_store = start;
c0104233:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0104236:	8b 55 10             	mov    0x10(%ebp),%edx
c0104239:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c010423b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010423e:	eb 05                	jmp    c0104245 <get_pgtable_items+0xb4>
    }
    return 0;
c0104240:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104245:	c9                   	leave  
c0104246:	c3                   	ret    

c0104247 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c0104247:	55                   	push   %ebp
c0104248:	89 e5                	mov    %esp,%ebp
c010424a:	57                   	push   %edi
c010424b:	56                   	push   %esi
c010424c:	53                   	push   %ebx
c010424d:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c0104250:	c7 04 24 d0 6d 10 c0 	movl   $0xc0106dd0,(%esp)
c0104257:	e8 41 c0 ff ff       	call   c010029d <cprintf>
    size_t left, right = 0, perm;
c010425c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0104263:	e9 fa 00 00 00       	jmp    c0104362 <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0104268:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010426b:	89 04 24             	mov    %eax,(%esp)
c010426e:	e8 d0 fe ff ff       	call   c0104143 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c0104273:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0104276:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104279:	29 d1                	sub    %edx,%ecx
c010427b:	89 ca                	mov    %ecx,%edx
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c010427d:	89 d6                	mov    %edx,%esi
c010427f:	c1 e6 16             	shl    $0x16,%esi
c0104282:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104285:	89 d3                	mov    %edx,%ebx
c0104287:	c1 e3 16             	shl    $0x16,%ebx
c010428a:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010428d:	89 d1                	mov    %edx,%ecx
c010428f:	c1 e1 16             	shl    $0x16,%ecx
c0104292:	8b 7d dc             	mov    -0x24(%ebp),%edi
c0104295:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104298:	29 d7                	sub    %edx,%edi
c010429a:	89 fa                	mov    %edi,%edx
c010429c:	89 44 24 14          	mov    %eax,0x14(%esp)
c01042a0:	89 74 24 10          	mov    %esi,0x10(%esp)
c01042a4:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01042a8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01042ac:	89 54 24 04          	mov    %edx,0x4(%esp)
c01042b0:	c7 04 24 01 6e 10 c0 	movl   $0xc0106e01,(%esp)
c01042b7:	e8 e1 bf ff ff       	call   c010029d <cprintf>
        size_t l, r = left * NPTEENTRY;
c01042bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01042bf:	c1 e0 0a             	shl    $0xa,%eax
c01042c2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c01042c5:	eb 54                	jmp    c010431b <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c01042c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01042ca:	89 04 24             	mov    %eax,(%esp)
c01042cd:	e8 71 fe ff ff       	call   c0104143 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c01042d2:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c01042d5:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01042d8:	29 d1                	sub    %edx,%ecx
c01042da:	89 ca                	mov    %ecx,%edx
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c01042dc:	89 d6                	mov    %edx,%esi
c01042de:	c1 e6 0c             	shl    $0xc,%esi
c01042e1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01042e4:	89 d3                	mov    %edx,%ebx
c01042e6:	c1 e3 0c             	shl    $0xc,%ebx
c01042e9:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01042ec:	c1 e2 0c             	shl    $0xc,%edx
c01042ef:	89 d1                	mov    %edx,%ecx
c01042f1:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c01042f4:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01042f7:	29 d7                	sub    %edx,%edi
c01042f9:	89 fa                	mov    %edi,%edx
c01042fb:	89 44 24 14          	mov    %eax,0x14(%esp)
c01042ff:	89 74 24 10          	mov    %esi,0x10(%esp)
c0104303:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0104307:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c010430b:	89 54 24 04          	mov    %edx,0x4(%esp)
c010430f:	c7 04 24 20 6e 10 c0 	movl   $0xc0106e20,(%esp)
c0104316:	e8 82 bf ff ff       	call   c010029d <cprintf>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c010431b:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
c0104320:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104323:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0104326:	89 ce                	mov    %ecx,%esi
c0104328:	c1 e6 0a             	shl    $0xa,%esi
c010432b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c010432e:	89 cb                	mov    %ecx,%ebx
c0104330:	c1 e3 0a             	shl    $0xa,%ebx
c0104333:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
c0104336:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c010433a:	8d 4d d8             	lea    -0x28(%ebp),%ecx
c010433d:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0104341:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0104345:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104349:	89 74 24 04          	mov    %esi,0x4(%esp)
c010434d:	89 1c 24             	mov    %ebx,(%esp)
c0104350:	e8 3c fe ff ff       	call   c0104191 <get_pgtable_items>
c0104355:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104358:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010435c:	0f 85 65 ff ff ff    	jne    c01042c7 <print_pgdir+0x80>
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0104362:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
c0104367:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010436a:	8d 4d dc             	lea    -0x24(%ebp),%ecx
c010436d:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c0104371:	8d 4d e0             	lea    -0x20(%ebp),%ecx
c0104374:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0104378:	89 54 24 0c          	mov    %edx,0xc(%esp)
c010437c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104380:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c0104387:	00 
c0104388:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c010438f:	e8 fd fd ff ff       	call   c0104191 <get_pgtable_items>
c0104394:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104397:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010439b:	0f 85 c7 fe ff ff    	jne    c0104268 <print_pgdir+0x21>
        }
    }
    cprintf("--------------------- END ---------------------\n");
c01043a1:	c7 04 24 44 6e 10 c0 	movl   $0xc0106e44,(%esp)
c01043a8:	e8 f0 be ff ff       	call   c010029d <cprintf>
}
c01043ad:	83 c4 4c             	add    $0x4c,%esp
c01043b0:	5b                   	pop    %ebx
c01043b1:	5e                   	pop    %esi
c01043b2:	5f                   	pop    %edi
c01043b3:	5d                   	pop    %ebp
c01043b4:	c3                   	ret    

c01043b5 <page2ppn>:
page2ppn(struct Page *page) {
c01043b5:	55                   	push   %ebp
c01043b6:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01043b8:	8b 55 08             	mov    0x8(%ebp),%edx
c01043bb:	a1 78 af 11 c0       	mov    0xc011af78,%eax
c01043c0:	29 c2                	sub    %eax,%edx
c01043c2:	89 d0                	mov    %edx,%eax
c01043c4:	c1 f8 02             	sar    $0x2,%eax
c01043c7:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c01043cd:	5d                   	pop    %ebp
c01043ce:	c3                   	ret    

c01043cf <page2pa>:
page2pa(struct Page *page) {
c01043cf:	55                   	push   %ebp
c01043d0:	89 e5                	mov    %esp,%ebp
c01043d2:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c01043d5:	8b 45 08             	mov    0x8(%ebp),%eax
c01043d8:	89 04 24             	mov    %eax,(%esp)
c01043db:	e8 d5 ff ff ff       	call   c01043b5 <page2ppn>
c01043e0:	c1 e0 0c             	shl    $0xc,%eax
}
c01043e3:	c9                   	leave  
c01043e4:	c3                   	ret    

c01043e5 <page_ref>:
page_ref(struct Page *page) {
c01043e5:	55                   	push   %ebp
c01043e6:	89 e5                	mov    %esp,%ebp
    return page->ref;
c01043e8:	8b 45 08             	mov    0x8(%ebp),%eax
c01043eb:	8b 00                	mov    (%eax),%eax
}
c01043ed:	5d                   	pop    %ebp
c01043ee:	c3                   	ret    

c01043ef <set_page_ref>:
set_page_ref(struct Page *page, int val) {
c01043ef:	55                   	push   %ebp
c01043f0:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c01043f2:	8b 45 08             	mov    0x8(%ebp),%eax
c01043f5:	8b 55 0c             	mov    0xc(%ebp),%edx
c01043f8:	89 10                	mov    %edx,(%eax)
}
c01043fa:	5d                   	pop    %ebp
c01043fb:	c3                   	ret    

c01043fc <default_init>:
#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

// 主要是一些参数的初始化工作
static void
default_init(void) {
c01043fc:	55                   	push   %ebp
c01043fd:	89 e5                	mov    %esp,%ebp
c01043ff:	83 ec 10             	sub    $0x10,%esp
c0104402:	c7 45 fc 7c af 11 c0 	movl   $0xc011af7c,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0104409:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010440c:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010440f:	89 50 04             	mov    %edx,0x4(%eax)
c0104412:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104415:	8b 50 04             	mov    0x4(%eax),%edx
c0104418:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010441b:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c010441d:	c7 05 84 af 11 c0 00 	movl   $0x0,0xc011af84
c0104424:	00 00 00 
}
c0104427:	c9                   	leave  
c0104428:	c3                   	ret    

c0104429 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c0104429:	55                   	push   %ebp
c010442a:	89 e5                	mov    %esp,%ebp
c010442c:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
c010442f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0104433:	75 24                	jne    c0104459 <default_init_memmap+0x30>
c0104435:	c7 44 24 0c 78 6e 10 	movl   $0xc0106e78,0xc(%esp)
c010443c:	c0 
c010443d:	c7 44 24 08 7e 6e 10 	movl   $0xc0106e7e,0x8(%esp)
c0104444:	c0 
c0104445:	c7 44 24 04 6e 00 00 	movl   $0x6e,0x4(%esp)
c010444c:	00 
c010444d:	c7 04 24 93 6e 10 c0 	movl   $0xc0106e93,(%esp)
c0104454:	e8 9b bf ff ff       	call   c01003f4 <__panic>
    struct Page *p = base;
c0104459:	8b 45 08             	mov    0x8(%ebp),%eax
c010445c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c010445f:	eb 7d                	jmp    c01044de <default_init_memmap+0xb5>
        assert(PageReserved(p));
c0104461:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104464:	83 c0 04             	add    $0x4,%eax
c0104467:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c010446e:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104471:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104474:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104477:	0f a3 10             	bt     %edx,(%eax)
c010447a:	19 c0                	sbb    %eax,%eax
c010447c:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c010447f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0104483:	0f 95 c0             	setne  %al
c0104486:	0f b6 c0             	movzbl %al,%eax
c0104489:	85 c0                	test   %eax,%eax
c010448b:	75 24                	jne    c01044b1 <default_init_memmap+0x88>
c010448d:	c7 44 24 0c a9 6e 10 	movl   $0xc0106ea9,0xc(%esp)
c0104494:	c0 
c0104495:	c7 44 24 08 7e 6e 10 	movl   $0xc0106e7e,0x8(%esp)
c010449c:	c0 
c010449d:	c7 44 24 04 71 00 00 	movl   $0x71,0x4(%esp)
c01044a4:	00 
c01044a5:	c7 04 24 93 6e 10 c0 	movl   $0xc0106e93,(%esp)
c01044ac:	e8 43 bf ff ff       	call   c01003f4 <__panic>
        p->flags = p->property = 0;
c01044b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044b4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c01044bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044be:	8b 50 08             	mov    0x8(%eax),%edx
c01044c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044c4:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
c01044c7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01044ce:	00 
c01044cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044d2:	89 04 24             	mov    %eax,(%esp)
c01044d5:	e8 15 ff ff ff       	call   c01043ef <set_page_ref>
    for (; p != base + n; p ++) {
c01044da:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c01044de:	8b 55 0c             	mov    0xc(%ebp),%edx
c01044e1:	89 d0                	mov    %edx,%eax
c01044e3:	c1 e0 02             	shl    $0x2,%eax
c01044e6:	01 d0                	add    %edx,%eax
c01044e8:	c1 e0 02             	shl    $0x2,%eax
c01044eb:	89 c2                	mov    %eax,%edx
c01044ed:	8b 45 08             	mov    0x8(%ebp),%eax
c01044f0:	01 d0                	add    %edx,%eax
c01044f2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01044f5:	0f 85 66 ff ff ff    	jne    c0104461 <default_init_memmap+0x38>
    }
    base->property = n;
c01044fb:	8b 45 08             	mov    0x8(%ebp),%eax
c01044fe:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104501:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c0104504:	8b 45 08             	mov    0x8(%ebp),%eax
c0104507:	83 c0 04             	add    $0x4,%eax
c010450a:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c0104511:	89 45 e0             	mov    %eax,-0x20(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104514:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104517:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010451a:	0f ab 10             	bts    %edx,(%eax)
    nr_free += n;
c010451d:	8b 15 84 af 11 c0    	mov    0xc011af84,%edx
c0104523:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104526:	01 d0                	add    %edx,%eax
c0104528:	a3 84 af 11 c0       	mov    %eax,0xc011af84
    list_add(&free_list, &(base->page_link));
c010452d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104530:	83 c0 0c             	add    $0xc,%eax
c0104533:	c7 45 dc 7c af 11 c0 	movl   $0xc011af7c,-0x24(%ebp)
c010453a:	89 45 d8             	mov    %eax,-0x28(%ebp)
c010453d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104540:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0104543:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104546:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0104549:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010454c:	8b 40 04             	mov    0x4(%eax),%eax
c010454f:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104552:	89 55 cc             	mov    %edx,-0x34(%ebp)
c0104555:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104558:	89 55 c8             	mov    %edx,-0x38(%ebp)
c010455b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c010455e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104561:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0104564:	89 10                	mov    %edx,(%eax)
c0104566:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104569:	8b 10                	mov    (%eax),%edx
c010456b:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010456e:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0104571:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0104574:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0104577:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c010457a:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010457d:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0104580:	89 10                	mov    %edx,(%eax)
}
c0104582:	c9                   	leave  
c0104583:	c3                   	ret    

c0104584 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c0104584:	55                   	push   %ebp
c0104585:	89 e5                	mov    %esp,%ebp
c0104587:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c010458a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010458e:	75 24                	jne    c01045b4 <default_alloc_pages+0x30>
c0104590:	c7 44 24 0c 78 6e 10 	movl   $0xc0106e78,0xc(%esp)
c0104597:	c0 
c0104598:	c7 44 24 08 7e 6e 10 	movl   $0xc0106e7e,0x8(%esp)
c010459f:	c0 
c01045a0:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
c01045a7:	00 
c01045a8:	c7 04 24 93 6e 10 c0 	movl   $0xc0106e93,(%esp)
c01045af:	e8 40 be ff ff       	call   c01003f4 <__panic>
    if (n > nr_free) {
c01045b4:	a1 84 af 11 c0       	mov    0xc011af84,%eax
c01045b9:	3b 45 08             	cmp    0x8(%ebp),%eax
c01045bc:	73 0a                	jae    c01045c8 <default_alloc_pages+0x44>
        return NULL;
c01045be:	b8 00 00 00 00       	mov    $0x0,%eax
c01045c3:	e9 3d 01 00 00       	jmp    c0104705 <default_alloc_pages+0x181>
    }
    struct Page *page = NULL;
c01045c8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
c01045cf:	c7 45 f0 7c af 11 c0 	movl   $0xc011af7c,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
c01045d6:	eb 1c                	jmp    c01045f4 <default_alloc_pages+0x70>
        struct Page *p = le2page(le, page_link);
c01045d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01045db:	83 e8 0c             	sub    $0xc,%eax
c01045de:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) {
c01045e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01045e4:	8b 40 08             	mov    0x8(%eax),%eax
c01045e7:	3b 45 08             	cmp    0x8(%ebp),%eax
c01045ea:	72 08                	jb     c01045f4 <default_alloc_pages+0x70>
            page = p;
c01045ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01045ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c01045f2:	eb 18                	jmp    c010460c <default_alloc_pages+0x88>
c01045f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01045f7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return listelm->next;
c01045fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01045fd:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c0104600:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104603:	81 7d f0 7c af 11 c0 	cmpl   $0xc011af7c,-0x10(%ebp)
c010460a:	75 cc                	jne    c01045d8 <default_alloc_pages+0x54>
        }
    }

    // 每一页的属性都在特定地址存储，因此在将空闲页块进行重新链接时，不能复用原有的位置
    if (page != NULL) {
c010460c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104610:	0f 84 ec 00 00 00    	je     c0104702 <default_alloc_pages+0x17e>
        if (page->property > n) {
c0104616:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104619:	8b 40 08             	mov    0x8(%eax),%eax
c010461c:	3b 45 08             	cmp    0x8(%ebp),%eax
c010461f:	0f 86 8c 00 00 00    	jbe    c01046b1 <default_alloc_pages+0x12d>
            struct Page *p = page + n;
c0104625:	8b 55 08             	mov    0x8(%ebp),%edx
c0104628:	89 d0                	mov    %edx,%eax
c010462a:	c1 e0 02             	shl    $0x2,%eax
c010462d:	01 d0                	add    %edx,%eax
c010462f:	c1 e0 02             	shl    $0x2,%eax
c0104632:	89 c2                	mov    %eax,%edx
c0104634:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104637:	01 d0                	add    %edx,%eax
c0104639:	89 45 e8             	mov    %eax,-0x18(%ebp)
            p->property = page->property - n;
c010463c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010463f:	8b 40 08             	mov    0x8(%eax),%eax
c0104642:	2b 45 08             	sub    0x8(%ebp),%eax
c0104645:	89 c2                	mov    %eax,%edx
c0104647:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010464a:	89 50 08             	mov    %edx,0x8(%eax)
            SetPageProperty(p);
c010464d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104650:	83 c0 04             	add    $0x4,%eax
c0104653:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c010465a:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010465d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104660:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104663:	0f ab 10             	bts    %edx,(%eax)
            list_add_after(&(page->page_link), &(p->page_link));
c0104666:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104669:	83 c0 0c             	add    $0xc,%eax
c010466c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010466f:	83 c2 0c             	add    $0xc,%edx
c0104672:	89 55 d8             	mov    %edx,-0x28(%ebp)
c0104675:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    __list_add(elm, listelm, listelm->next);
c0104678:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010467b:	8b 40 04             	mov    0x4(%eax),%eax
c010467e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104681:	89 55 d0             	mov    %edx,-0x30(%ebp)
c0104684:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0104687:	89 55 cc             	mov    %edx,-0x34(%ebp)
c010468a:	89 45 c8             	mov    %eax,-0x38(%ebp)
    prev->next = next->prev = elm;
c010468d:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104690:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104693:	89 10                	mov    %edx,(%eax)
c0104695:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104698:	8b 10                	mov    (%eax),%edx
c010469a:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010469d:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01046a0:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01046a3:	8b 55 c8             	mov    -0x38(%ebp),%edx
c01046a6:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01046a9:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01046ac:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01046af:	89 10                	mov    %edx,(%eax)
        }
        nr_free -= n;
c01046b1:	a1 84 af 11 c0       	mov    0xc011af84,%eax
c01046b6:	2b 45 08             	sub    0x8(%ebp),%eax
c01046b9:	a3 84 af 11 c0       	mov    %eax,0xc011af84
        list_del(&(page->page_link));
c01046be:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046c1:	83 c0 0c             	add    $0xc,%eax
c01046c4:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    __list_del(listelm->prev, listelm->next);
c01046c7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01046ca:	8b 40 04             	mov    0x4(%eax),%eax
c01046cd:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c01046d0:	8b 12                	mov    (%edx),%edx
c01046d2:	89 55 c0             	mov    %edx,-0x40(%ebp)
c01046d5:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c01046d8:	8b 45 c0             	mov    -0x40(%ebp),%eax
c01046db:	8b 55 bc             	mov    -0x44(%ebp),%edx
c01046de:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01046e1:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01046e4:	8b 55 c0             	mov    -0x40(%ebp),%edx
c01046e7:	89 10                	mov    %edx,(%eax)
        ClearPageProperty(page);
c01046e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046ec:	83 c0 04             	add    $0x4,%eax
c01046ef:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
c01046f6:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01046f9:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01046fc:	8b 55 b8             	mov    -0x48(%ebp),%edx
c01046ff:	0f b3 10             	btr    %edx,(%eax)
    }
    return page;
c0104702:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0104705:	c9                   	leave  
c0104706:	c3                   	ret    

c0104707 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c0104707:	55                   	push   %ebp
c0104708:	89 e5                	mov    %esp,%ebp
c010470a:	81 ec 88 00 00 00    	sub    $0x88,%esp
    assert(n > 0);
c0104710:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0104714:	75 24                	jne    c010473a <default_free_pages+0x33>
c0104716:	c7 44 24 0c 78 6e 10 	movl   $0xc0106e78,0xc(%esp)
c010471d:	c0 
c010471e:	c7 44 24 08 7e 6e 10 	movl   $0xc0106e7e,0x8(%esp)
c0104725:	c0 
c0104726:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
c010472d:	00 
c010472e:	c7 04 24 93 6e 10 c0 	movl   $0xc0106e93,(%esp)
c0104735:	e8 ba bc ff ff       	call   c01003f4 <__panic>
    struct Page *p = base;
c010473a:	8b 45 08             	mov    0x8(%ebp),%eax
c010473d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0104740:	e9 9d 00 00 00       	jmp    c01047e2 <default_free_pages+0xdb>
        assert(!PageReserved(p) && !PageProperty(p));
c0104745:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104748:	83 c0 04             	add    $0x4,%eax
c010474b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0104752:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104755:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104758:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010475b:	0f a3 10             	bt     %edx,(%eax)
c010475e:	19 c0                	sbb    %eax,%eax
c0104760:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
c0104763:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0104767:	0f 95 c0             	setne  %al
c010476a:	0f b6 c0             	movzbl %al,%eax
c010476d:	85 c0                	test   %eax,%eax
c010476f:	75 2c                	jne    c010479d <default_free_pages+0x96>
c0104771:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104774:	83 c0 04             	add    $0x4,%eax
c0104777:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c010477e:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104781:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104784:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104787:	0f a3 10             	bt     %edx,(%eax)
c010478a:	19 c0                	sbb    %eax,%eax
c010478c:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
c010478f:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0104793:	0f 95 c0             	setne  %al
c0104796:	0f b6 c0             	movzbl %al,%eax
c0104799:	85 c0                	test   %eax,%eax
c010479b:	74 24                	je     c01047c1 <default_free_pages+0xba>
c010479d:	c7 44 24 0c bc 6e 10 	movl   $0xc0106ebc,0xc(%esp)
c01047a4:	c0 
c01047a5:	c7 44 24 08 7e 6e 10 	movl   $0xc0106e7e,0x8(%esp)
c01047ac:	c0 
c01047ad:	c7 44 24 04 9f 00 00 	movl   $0x9f,0x4(%esp)
c01047b4:	00 
c01047b5:	c7 04 24 93 6e 10 c0 	movl   $0xc0106e93,(%esp)
c01047bc:	e8 33 bc ff ff       	call   c01003f4 <__panic>
        p->flags = 0;
c01047c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047c4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
c01047cb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01047d2:	00 
c01047d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047d6:	89 04 24             	mov    %eax,(%esp)
c01047d9:	e8 11 fc ff ff       	call   c01043ef <set_page_ref>
    for (; p != base + n; p ++) {
c01047de:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c01047e2:	8b 55 0c             	mov    0xc(%ebp),%edx
c01047e5:	89 d0                	mov    %edx,%eax
c01047e7:	c1 e0 02             	shl    $0x2,%eax
c01047ea:	01 d0                	add    %edx,%eax
c01047ec:	c1 e0 02             	shl    $0x2,%eax
c01047ef:	89 c2                	mov    %eax,%edx
c01047f1:	8b 45 08             	mov    0x8(%ebp),%eax
c01047f4:	01 d0                	add    %edx,%eax
c01047f6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01047f9:	0f 85 46 ff ff ff    	jne    c0104745 <default_free_pages+0x3e>
    }
    base->property = n;
c01047ff:	8b 45 08             	mov    0x8(%ebp),%eax
c0104802:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104805:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c0104808:	8b 45 08             	mov    0x8(%ebp),%eax
c010480b:	83 c0 04             	add    $0x4,%eax
c010480e:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c0104815:	89 45 d0             	mov    %eax,-0x30(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104818:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010481b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010481e:	0f ab 10             	bts    %edx,(%eax)
c0104821:	c7 45 cc 7c af 11 c0 	movl   $0xc011af7c,-0x34(%ebp)
    return listelm->next;
c0104828:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010482b:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
c010482e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c0104831:	e9 57 01 00 00       	jmp    c010498d <default_free_pages+0x286>
        p = le2page(le, page_link);
c0104836:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104839:	83 e8 0c             	sub    $0xc,%eax
c010483c:	89 45 f4             	mov    %eax,-0xc(%ebp)
        // TODO: optimize
        if (base + base->property == p) {
c010483f:	8b 45 08             	mov    0x8(%ebp),%eax
c0104842:	8b 50 08             	mov    0x8(%eax),%edx
c0104845:	89 d0                	mov    %edx,%eax
c0104847:	c1 e0 02             	shl    $0x2,%eax
c010484a:	01 d0                	add    %edx,%eax
c010484c:	c1 e0 02             	shl    $0x2,%eax
c010484f:	89 c2                	mov    %eax,%edx
c0104851:	8b 45 08             	mov    0x8(%ebp),%eax
c0104854:	01 d0                	add    %edx,%eax
c0104856:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104859:	75 5d                	jne    c01048b8 <default_free_pages+0x1b1>
            base->property += p->property;
c010485b:	8b 45 08             	mov    0x8(%ebp),%eax
c010485e:	8b 50 08             	mov    0x8(%eax),%edx
c0104861:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104864:	8b 40 08             	mov    0x8(%eax),%eax
c0104867:	01 c2                	add    %eax,%edx
c0104869:	8b 45 08             	mov    0x8(%ebp),%eax
c010486c:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
c010486f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104872:	83 c0 04             	add    $0x4,%eax
c0104875:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
c010487c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010487f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104882:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0104885:	0f b3 10             	btr    %edx,(%eax)
            list_del(&(p->page_link));
c0104888:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010488b:	83 c0 0c             	add    $0xc,%eax
c010488e:	89 45 c0             	mov    %eax,-0x40(%ebp)
    __list_del(listelm->prev, listelm->next);
c0104891:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0104894:	8b 40 04             	mov    0x4(%eax),%eax
c0104897:	8b 55 c0             	mov    -0x40(%ebp),%edx
c010489a:	8b 12                	mov    (%edx),%edx
c010489c:	89 55 bc             	mov    %edx,-0x44(%ebp)
c010489f:	89 45 b8             	mov    %eax,-0x48(%ebp)
    prev->next = next;
c01048a2:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01048a5:	8b 55 b8             	mov    -0x48(%ebp),%edx
c01048a8:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01048ab:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01048ae:	8b 55 bc             	mov    -0x44(%ebp),%edx
c01048b1:	89 10                	mov    %edx,(%eax)
c01048b3:	e9 c6 00 00 00       	jmp    c010497e <default_free_pages+0x277>
        }
        else if (p + p->property == base) {
c01048b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048bb:	8b 50 08             	mov    0x8(%eax),%edx
c01048be:	89 d0                	mov    %edx,%eax
c01048c0:	c1 e0 02             	shl    $0x2,%eax
c01048c3:	01 d0                	add    %edx,%eax
c01048c5:	c1 e0 02             	shl    $0x2,%eax
c01048c8:	89 c2                	mov    %eax,%edx
c01048ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048cd:	01 d0                	add    %edx,%eax
c01048cf:	3b 45 08             	cmp    0x8(%ebp),%eax
c01048d2:	75 60                	jne    c0104934 <default_free_pages+0x22d>
            p->property += base->property;
c01048d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048d7:	8b 50 08             	mov    0x8(%eax),%edx
c01048da:	8b 45 08             	mov    0x8(%ebp),%eax
c01048dd:	8b 40 08             	mov    0x8(%eax),%eax
c01048e0:	01 c2                	add    %eax,%edx
c01048e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048e5:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
c01048e8:	8b 45 08             	mov    0x8(%ebp),%eax
c01048eb:	83 c0 04             	add    $0x4,%eax
c01048ee:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
c01048f5:	89 45 b0             	mov    %eax,-0x50(%ebp)
c01048f8:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01048fb:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c01048fe:	0f b3 10             	btr    %edx,(%eax)
            base = p;
c0104901:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104904:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
c0104907:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010490a:	83 c0 0c             	add    $0xc,%eax
c010490d:	89 45 ac             	mov    %eax,-0x54(%ebp)
    __list_del(listelm->prev, listelm->next);
c0104910:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0104913:	8b 40 04             	mov    0x4(%eax),%eax
c0104916:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0104919:	8b 12                	mov    (%edx),%edx
c010491b:	89 55 a8             	mov    %edx,-0x58(%ebp)
c010491e:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    prev->next = next;
c0104921:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0104924:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0104927:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c010492a:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c010492d:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0104930:	89 10                	mov    %edx,(%eax)
c0104932:	eb 4a                	jmp    c010497e <default_free_pages+0x277>
        }else if(base <= p)
c0104934:	8b 45 08             	mov    0x8(%ebp),%eax
c0104937:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010493a:	77 42                	ja     c010497e <default_free_pages+0x277>
		{
			assert(base != p + p->property);
c010493c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010493f:	8b 50 08             	mov    0x8(%eax),%edx
c0104942:	89 d0                	mov    %edx,%eax
c0104944:	c1 e0 02             	shl    $0x2,%eax
c0104947:	01 d0                	add    %edx,%eax
c0104949:	c1 e0 02             	shl    $0x2,%eax
c010494c:	89 c2                	mov    %eax,%edx
c010494e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104951:	01 d0                	add    %edx,%eax
c0104953:	3b 45 08             	cmp    0x8(%ebp),%eax
c0104956:	75 24                	jne    c010497c <default_free_pages+0x275>
c0104958:	c7 44 24 0c e1 6e 10 	movl   $0xc0106ee1,0xc(%esp)
c010495f:	c0 
c0104960:	c7 44 24 08 7e 6e 10 	movl   $0xc0106e7e,0x8(%esp)
c0104967:	c0 
c0104968:	c7 44 24 04 b5 00 00 	movl   $0xb5,0x4(%esp)
c010496f:	00 
c0104970:	c7 04 24 93 6e 10 c0 	movl   $0xc0106e93,(%esp)
c0104977:	e8 78 ba ff ff       	call   c01003f4 <__panic>
			break;
c010497c:	eb 1c                	jmp    c010499a <default_free_pages+0x293>
c010497e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104981:	89 45 a0             	mov    %eax,-0x60(%ebp)
    return listelm->next;
c0104984:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0104987:	8b 40 04             	mov    0x4(%eax),%eax
		}
		le = list_next(le);
c010498a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c010498d:	81 7d f0 7c af 11 c0 	cmpl   $0xc011af7c,-0x10(%ebp)
c0104994:	0f 85 9c fe ff ff    	jne    c0104836 <default_free_pages+0x12f>
    }

    // 通过前面的处理，此处必定要新加一个空白块，如果空白块地址最大，插入头指针之前，即末尾，该种结构更为科学合理
	list_add_before(le, &(base->page_link));
c010499a:	8b 45 08             	mov    0x8(%ebp),%eax
c010499d:	8d 50 0c             	lea    0xc(%eax),%edx
c01049a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01049a3:	89 45 9c             	mov    %eax,-0x64(%ebp)
c01049a6:	89 55 98             	mov    %edx,-0x68(%ebp)
    __list_add(elm, listelm->prev, listelm);
c01049a9:	8b 45 9c             	mov    -0x64(%ebp),%eax
c01049ac:	8b 00                	mov    (%eax),%eax
c01049ae:	8b 55 98             	mov    -0x68(%ebp),%edx
c01049b1:	89 55 94             	mov    %edx,-0x6c(%ebp)
c01049b4:	89 45 90             	mov    %eax,-0x70(%ebp)
c01049b7:	8b 45 9c             	mov    -0x64(%ebp),%eax
c01049ba:	89 45 8c             	mov    %eax,-0x74(%ebp)
    prev->next = next->prev = elm;
c01049bd:	8b 45 8c             	mov    -0x74(%ebp),%eax
c01049c0:	8b 55 94             	mov    -0x6c(%ebp),%edx
c01049c3:	89 10                	mov    %edx,(%eax)
c01049c5:	8b 45 8c             	mov    -0x74(%ebp),%eax
c01049c8:	8b 10                	mov    (%eax),%edx
c01049ca:	8b 45 90             	mov    -0x70(%ebp),%eax
c01049cd:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01049d0:	8b 45 94             	mov    -0x6c(%ebp),%eax
c01049d3:	8b 55 8c             	mov    -0x74(%ebp),%edx
c01049d6:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01049d9:	8b 45 94             	mov    -0x6c(%ebp),%eax
c01049dc:	8b 55 90             	mov    -0x70(%ebp),%edx
c01049df:	89 10                	mov    %edx,(%eax)
    nr_free += n;
c01049e1:	8b 15 84 af 11 c0    	mov    0xc011af84,%edx
c01049e7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01049ea:	01 d0                	add    %edx,%eax
c01049ec:	a3 84 af 11 c0       	mov    %eax,0xc011af84
}
c01049f1:	c9                   	leave  
c01049f2:	c3                   	ret    

c01049f3 <default_nr_free_pages>:
static size_t
default_nr_free_pages(void) {
c01049f3:	55                   	push   %ebp
c01049f4:	89 e5                	mov    %esp,%ebp
    return nr_free;
c01049f6:	a1 84 af 11 c0       	mov    0xc011af84,%eax
}
c01049fb:	5d                   	pop    %ebp
c01049fc:	c3                   	ret    

c01049fd <basic_check>:

static void
basic_check(void) {
c01049fd:	55                   	push   %ebp
c01049fe:	89 e5                	mov    %esp,%ebp
c0104a00:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c0104a03:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104a0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a0d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104a10:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104a13:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c0104a16:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104a1d:	e8 d2 e2 ff ff       	call   c0102cf4 <alloc_pages>
c0104a22:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104a25:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0104a29:	75 24                	jne    c0104a4f <basic_check+0x52>
c0104a2b:	c7 44 24 0c f9 6e 10 	movl   $0xc0106ef9,0xc(%esp)
c0104a32:	c0 
c0104a33:	c7 44 24 08 7e 6e 10 	movl   $0xc0106e7e,0x8(%esp)
c0104a3a:	c0 
c0104a3b:	c7 44 24 04 c8 00 00 	movl   $0xc8,0x4(%esp)
c0104a42:	00 
c0104a43:	c7 04 24 93 6e 10 c0 	movl   $0xc0106e93,(%esp)
c0104a4a:	e8 a5 b9 ff ff       	call   c01003f4 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0104a4f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104a56:	e8 99 e2 ff ff       	call   c0102cf4 <alloc_pages>
c0104a5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104a5e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104a62:	75 24                	jne    c0104a88 <basic_check+0x8b>
c0104a64:	c7 44 24 0c 15 6f 10 	movl   $0xc0106f15,0xc(%esp)
c0104a6b:	c0 
c0104a6c:	c7 44 24 08 7e 6e 10 	movl   $0xc0106e7e,0x8(%esp)
c0104a73:	c0 
c0104a74:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
c0104a7b:	00 
c0104a7c:	c7 04 24 93 6e 10 c0 	movl   $0xc0106e93,(%esp)
c0104a83:	e8 6c b9 ff ff       	call   c01003f4 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0104a88:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104a8f:	e8 60 e2 ff ff       	call   c0102cf4 <alloc_pages>
c0104a94:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104a97:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104a9b:	75 24                	jne    c0104ac1 <basic_check+0xc4>
c0104a9d:	c7 44 24 0c 31 6f 10 	movl   $0xc0106f31,0xc(%esp)
c0104aa4:	c0 
c0104aa5:	c7 44 24 08 7e 6e 10 	movl   $0xc0106e7e,0x8(%esp)
c0104aac:	c0 
c0104aad:	c7 44 24 04 ca 00 00 	movl   $0xca,0x4(%esp)
c0104ab4:	00 
c0104ab5:	c7 04 24 93 6e 10 c0 	movl   $0xc0106e93,(%esp)
c0104abc:	e8 33 b9 ff ff       	call   c01003f4 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c0104ac1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104ac4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0104ac7:	74 10                	je     c0104ad9 <basic_check+0xdc>
c0104ac9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104acc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104acf:	74 08                	je     c0104ad9 <basic_check+0xdc>
c0104ad1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ad4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104ad7:	75 24                	jne    c0104afd <basic_check+0x100>
c0104ad9:	c7 44 24 0c 50 6f 10 	movl   $0xc0106f50,0xc(%esp)
c0104ae0:	c0 
c0104ae1:	c7 44 24 08 7e 6e 10 	movl   $0xc0106e7e,0x8(%esp)
c0104ae8:	c0 
c0104ae9:	c7 44 24 04 cc 00 00 	movl   $0xcc,0x4(%esp)
c0104af0:	00 
c0104af1:	c7 04 24 93 6e 10 c0 	movl   $0xc0106e93,(%esp)
c0104af8:	e8 f7 b8 ff ff       	call   c01003f4 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0104afd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104b00:	89 04 24             	mov    %eax,(%esp)
c0104b03:	e8 dd f8 ff ff       	call   c01043e5 <page_ref>
c0104b08:	85 c0                	test   %eax,%eax
c0104b0a:	75 1e                	jne    c0104b2a <basic_check+0x12d>
c0104b0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104b0f:	89 04 24             	mov    %eax,(%esp)
c0104b12:	e8 ce f8 ff ff       	call   c01043e5 <page_ref>
c0104b17:	85 c0                	test   %eax,%eax
c0104b19:	75 0f                	jne    c0104b2a <basic_check+0x12d>
c0104b1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b1e:	89 04 24             	mov    %eax,(%esp)
c0104b21:	e8 bf f8 ff ff       	call   c01043e5 <page_ref>
c0104b26:	85 c0                	test   %eax,%eax
c0104b28:	74 24                	je     c0104b4e <basic_check+0x151>
c0104b2a:	c7 44 24 0c 74 6f 10 	movl   $0xc0106f74,0xc(%esp)
c0104b31:	c0 
c0104b32:	c7 44 24 08 7e 6e 10 	movl   $0xc0106e7e,0x8(%esp)
c0104b39:	c0 
c0104b3a:	c7 44 24 04 cd 00 00 	movl   $0xcd,0x4(%esp)
c0104b41:	00 
c0104b42:	c7 04 24 93 6e 10 c0 	movl   $0xc0106e93,(%esp)
c0104b49:	e8 a6 b8 ff ff       	call   c01003f4 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0104b4e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104b51:	89 04 24             	mov    %eax,(%esp)
c0104b54:	e8 76 f8 ff ff       	call   c01043cf <page2pa>
c0104b59:	8b 15 80 ae 11 c0    	mov    0xc011ae80,%edx
c0104b5f:	c1 e2 0c             	shl    $0xc,%edx
c0104b62:	39 d0                	cmp    %edx,%eax
c0104b64:	72 24                	jb     c0104b8a <basic_check+0x18d>
c0104b66:	c7 44 24 0c b0 6f 10 	movl   $0xc0106fb0,0xc(%esp)
c0104b6d:	c0 
c0104b6e:	c7 44 24 08 7e 6e 10 	movl   $0xc0106e7e,0x8(%esp)
c0104b75:	c0 
c0104b76:	c7 44 24 04 cf 00 00 	movl   $0xcf,0x4(%esp)
c0104b7d:	00 
c0104b7e:	c7 04 24 93 6e 10 c0 	movl   $0xc0106e93,(%esp)
c0104b85:	e8 6a b8 ff ff       	call   c01003f4 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c0104b8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104b8d:	89 04 24             	mov    %eax,(%esp)
c0104b90:	e8 3a f8 ff ff       	call   c01043cf <page2pa>
c0104b95:	8b 15 80 ae 11 c0    	mov    0xc011ae80,%edx
c0104b9b:	c1 e2 0c             	shl    $0xc,%edx
c0104b9e:	39 d0                	cmp    %edx,%eax
c0104ba0:	72 24                	jb     c0104bc6 <basic_check+0x1c9>
c0104ba2:	c7 44 24 0c cd 6f 10 	movl   $0xc0106fcd,0xc(%esp)
c0104ba9:	c0 
c0104baa:	c7 44 24 08 7e 6e 10 	movl   $0xc0106e7e,0x8(%esp)
c0104bb1:	c0 
c0104bb2:	c7 44 24 04 d0 00 00 	movl   $0xd0,0x4(%esp)
c0104bb9:	00 
c0104bba:	c7 04 24 93 6e 10 c0 	movl   $0xc0106e93,(%esp)
c0104bc1:	e8 2e b8 ff ff       	call   c01003f4 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c0104bc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104bc9:	89 04 24             	mov    %eax,(%esp)
c0104bcc:	e8 fe f7 ff ff       	call   c01043cf <page2pa>
c0104bd1:	8b 15 80 ae 11 c0    	mov    0xc011ae80,%edx
c0104bd7:	c1 e2 0c             	shl    $0xc,%edx
c0104bda:	39 d0                	cmp    %edx,%eax
c0104bdc:	72 24                	jb     c0104c02 <basic_check+0x205>
c0104bde:	c7 44 24 0c ea 6f 10 	movl   $0xc0106fea,0xc(%esp)
c0104be5:	c0 
c0104be6:	c7 44 24 08 7e 6e 10 	movl   $0xc0106e7e,0x8(%esp)
c0104bed:	c0 
c0104bee:	c7 44 24 04 d1 00 00 	movl   $0xd1,0x4(%esp)
c0104bf5:	00 
c0104bf6:	c7 04 24 93 6e 10 c0 	movl   $0xc0106e93,(%esp)
c0104bfd:	e8 f2 b7 ff ff       	call   c01003f4 <__panic>

    list_entry_t free_list_store = free_list;
c0104c02:	a1 7c af 11 c0       	mov    0xc011af7c,%eax
c0104c07:	8b 15 80 af 11 c0    	mov    0xc011af80,%edx
c0104c0d:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104c10:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0104c13:	c7 45 e0 7c af 11 c0 	movl   $0xc011af7c,-0x20(%ebp)
    elm->prev = elm->next = elm;
c0104c1a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104c1d:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104c20:	89 50 04             	mov    %edx,0x4(%eax)
c0104c23:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104c26:	8b 50 04             	mov    0x4(%eax),%edx
c0104c29:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104c2c:	89 10                	mov    %edx,(%eax)
c0104c2e:	c7 45 dc 7c af 11 c0 	movl   $0xc011af7c,-0x24(%ebp)
    return list->next == list;
c0104c35:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104c38:	8b 40 04             	mov    0x4(%eax),%eax
c0104c3b:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0104c3e:	0f 94 c0             	sete   %al
c0104c41:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0104c44:	85 c0                	test   %eax,%eax
c0104c46:	75 24                	jne    c0104c6c <basic_check+0x26f>
c0104c48:	c7 44 24 0c 07 70 10 	movl   $0xc0107007,0xc(%esp)
c0104c4f:	c0 
c0104c50:	c7 44 24 08 7e 6e 10 	movl   $0xc0106e7e,0x8(%esp)
c0104c57:	c0 
c0104c58:	c7 44 24 04 d5 00 00 	movl   $0xd5,0x4(%esp)
c0104c5f:	00 
c0104c60:	c7 04 24 93 6e 10 c0 	movl   $0xc0106e93,(%esp)
c0104c67:	e8 88 b7 ff ff       	call   c01003f4 <__panic>

    unsigned int nr_free_store = nr_free;
c0104c6c:	a1 84 af 11 c0       	mov    0xc011af84,%eax
c0104c71:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c0104c74:	c7 05 84 af 11 c0 00 	movl   $0x0,0xc011af84
c0104c7b:	00 00 00 

    assert(alloc_page() == NULL);
c0104c7e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104c85:	e8 6a e0 ff ff       	call   c0102cf4 <alloc_pages>
c0104c8a:	85 c0                	test   %eax,%eax
c0104c8c:	74 24                	je     c0104cb2 <basic_check+0x2b5>
c0104c8e:	c7 44 24 0c 1e 70 10 	movl   $0xc010701e,0xc(%esp)
c0104c95:	c0 
c0104c96:	c7 44 24 08 7e 6e 10 	movl   $0xc0106e7e,0x8(%esp)
c0104c9d:	c0 
c0104c9e:	c7 44 24 04 da 00 00 	movl   $0xda,0x4(%esp)
c0104ca5:	00 
c0104ca6:	c7 04 24 93 6e 10 c0 	movl   $0xc0106e93,(%esp)
c0104cad:	e8 42 b7 ff ff       	call   c01003f4 <__panic>

    free_page(p0);
c0104cb2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104cb9:	00 
c0104cba:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104cbd:	89 04 24             	mov    %eax,(%esp)
c0104cc0:	e8 67 e0 ff ff       	call   c0102d2c <free_pages>
    free_page(p1);
c0104cc5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104ccc:	00 
c0104ccd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104cd0:	89 04 24             	mov    %eax,(%esp)
c0104cd3:	e8 54 e0 ff ff       	call   c0102d2c <free_pages>
    free_page(p2);
c0104cd8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104cdf:	00 
c0104ce0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ce3:	89 04 24             	mov    %eax,(%esp)
c0104ce6:	e8 41 e0 ff ff       	call   c0102d2c <free_pages>
    assert(nr_free == 3);
c0104ceb:	a1 84 af 11 c0       	mov    0xc011af84,%eax
c0104cf0:	83 f8 03             	cmp    $0x3,%eax
c0104cf3:	74 24                	je     c0104d19 <basic_check+0x31c>
c0104cf5:	c7 44 24 0c 33 70 10 	movl   $0xc0107033,0xc(%esp)
c0104cfc:	c0 
c0104cfd:	c7 44 24 08 7e 6e 10 	movl   $0xc0106e7e,0x8(%esp)
c0104d04:	c0 
c0104d05:	c7 44 24 04 df 00 00 	movl   $0xdf,0x4(%esp)
c0104d0c:	00 
c0104d0d:	c7 04 24 93 6e 10 c0 	movl   $0xc0106e93,(%esp)
c0104d14:	e8 db b6 ff ff       	call   c01003f4 <__panic>

    assert((p0 = alloc_page()) != NULL);
c0104d19:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104d20:	e8 cf df ff ff       	call   c0102cf4 <alloc_pages>
c0104d25:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104d28:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0104d2c:	75 24                	jne    c0104d52 <basic_check+0x355>
c0104d2e:	c7 44 24 0c f9 6e 10 	movl   $0xc0106ef9,0xc(%esp)
c0104d35:	c0 
c0104d36:	c7 44 24 08 7e 6e 10 	movl   $0xc0106e7e,0x8(%esp)
c0104d3d:	c0 
c0104d3e:	c7 44 24 04 e1 00 00 	movl   $0xe1,0x4(%esp)
c0104d45:	00 
c0104d46:	c7 04 24 93 6e 10 c0 	movl   $0xc0106e93,(%esp)
c0104d4d:	e8 a2 b6 ff ff       	call   c01003f4 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0104d52:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104d59:	e8 96 df ff ff       	call   c0102cf4 <alloc_pages>
c0104d5e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104d61:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104d65:	75 24                	jne    c0104d8b <basic_check+0x38e>
c0104d67:	c7 44 24 0c 15 6f 10 	movl   $0xc0106f15,0xc(%esp)
c0104d6e:	c0 
c0104d6f:	c7 44 24 08 7e 6e 10 	movl   $0xc0106e7e,0x8(%esp)
c0104d76:	c0 
c0104d77:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
c0104d7e:	00 
c0104d7f:	c7 04 24 93 6e 10 c0 	movl   $0xc0106e93,(%esp)
c0104d86:	e8 69 b6 ff ff       	call   c01003f4 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0104d8b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104d92:	e8 5d df ff ff       	call   c0102cf4 <alloc_pages>
c0104d97:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104d9a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104d9e:	75 24                	jne    c0104dc4 <basic_check+0x3c7>
c0104da0:	c7 44 24 0c 31 6f 10 	movl   $0xc0106f31,0xc(%esp)
c0104da7:	c0 
c0104da8:	c7 44 24 08 7e 6e 10 	movl   $0xc0106e7e,0x8(%esp)
c0104daf:	c0 
c0104db0:	c7 44 24 04 e3 00 00 	movl   $0xe3,0x4(%esp)
c0104db7:	00 
c0104db8:	c7 04 24 93 6e 10 c0 	movl   $0xc0106e93,(%esp)
c0104dbf:	e8 30 b6 ff ff       	call   c01003f4 <__panic>

    assert(alloc_page() == NULL);
c0104dc4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104dcb:	e8 24 df ff ff       	call   c0102cf4 <alloc_pages>
c0104dd0:	85 c0                	test   %eax,%eax
c0104dd2:	74 24                	je     c0104df8 <basic_check+0x3fb>
c0104dd4:	c7 44 24 0c 1e 70 10 	movl   $0xc010701e,0xc(%esp)
c0104ddb:	c0 
c0104ddc:	c7 44 24 08 7e 6e 10 	movl   $0xc0106e7e,0x8(%esp)
c0104de3:	c0 
c0104de4:	c7 44 24 04 e5 00 00 	movl   $0xe5,0x4(%esp)
c0104deb:	00 
c0104dec:	c7 04 24 93 6e 10 c0 	movl   $0xc0106e93,(%esp)
c0104df3:	e8 fc b5 ff ff       	call   c01003f4 <__panic>

    free_page(p0);
c0104df8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104dff:	00 
c0104e00:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104e03:	89 04 24             	mov    %eax,(%esp)
c0104e06:	e8 21 df ff ff       	call   c0102d2c <free_pages>
c0104e0b:	c7 45 d8 7c af 11 c0 	movl   $0xc011af7c,-0x28(%ebp)
c0104e12:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104e15:	8b 40 04             	mov    0x4(%eax),%eax
c0104e18:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0104e1b:	0f 94 c0             	sete   %al
c0104e1e:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c0104e21:	85 c0                	test   %eax,%eax
c0104e23:	74 24                	je     c0104e49 <basic_check+0x44c>
c0104e25:	c7 44 24 0c 40 70 10 	movl   $0xc0107040,0xc(%esp)
c0104e2c:	c0 
c0104e2d:	c7 44 24 08 7e 6e 10 	movl   $0xc0106e7e,0x8(%esp)
c0104e34:	c0 
c0104e35:	c7 44 24 04 e8 00 00 	movl   $0xe8,0x4(%esp)
c0104e3c:	00 
c0104e3d:	c7 04 24 93 6e 10 c0 	movl   $0xc0106e93,(%esp)
c0104e44:	e8 ab b5 ff ff       	call   c01003f4 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c0104e49:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104e50:	e8 9f de ff ff       	call   c0102cf4 <alloc_pages>
c0104e55:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104e58:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104e5b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0104e5e:	74 24                	je     c0104e84 <basic_check+0x487>
c0104e60:	c7 44 24 0c 58 70 10 	movl   $0xc0107058,0xc(%esp)
c0104e67:	c0 
c0104e68:	c7 44 24 08 7e 6e 10 	movl   $0xc0106e7e,0x8(%esp)
c0104e6f:	c0 
c0104e70:	c7 44 24 04 eb 00 00 	movl   $0xeb,0x4(%esp)
c0104e77:	00 
c0104e78:	c7 04 24 93 6e 10 c0 	movl   $0xc0106e93,(%esp)
c0104e7f:	e8 70 b5 ff ff       	call   c01003f4 <__panic>
    assert(alloc_page() == NULL);
c0104e84:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104e8b:	e8 64 de ff ff       	call   c0102cf4 <alloc_pages>
c0104e90:	85 c0                	test   %eax,%eax
c0104e92:	74 24                	je     c0104eb8 <basic_check+0x4bb>
c0104e94:	c7 44 24 0c 1e 70 10 	movl   $0xc010701e,0xc(%esp)
c0104e9b:	c0 
c0104e9c:	c7 44 24 08 7e 6e 10 	movl   $0xc0106e7e,0x8(%esp)
c0104ea3:	c0 
c0104ea4:	c7 44 24 04 ec 00 00 	movl   $0xec,0x4(%esp)
c0104eab:	00 
c0104eac:	c7 04 24 93 6e 10 c0 	movl   $0xc0106e93,(%esp)
c0104eb3:	e8 3c b5 ff ff       	call   c01003f4 <__panic>

    assert(nr_free == 0);
c0104eb8:	a1 84 af 11 c0       	mov    0xc011af84,%eax
c0104ebd:	85 c0                	test   %eax,%eax
c0104ebf:	74 24                	je     c0104ee5 <basic_check+0x4e8>
c0104ec1:	c7 44 24 0c 71 70 10 	movl   $0xc0107071,0xc(%esp)
c0104ec8:	c0 
c0104ec9:	c7 44 24 08 7e 6e 10 	movl   $0xc0106e7e,0x8(%esp)
c0104ed0:	c0 
c0104ed1:	c7 44 24 04 ee 00 00 	movl   $0xee,0x4(%esp)
c0104ed8:	00 
c0104ed9:	c7 04 24 93 6e 10 c0 	movl   $0xc0106e93,(%esp)
c0104ee0:	e8 0f b5 ff ff       	call   c01003f4 <__panic>
    free_list = free_list_store;
c0104ee5:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104ee8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104eeb:	a3 7c af 11 c0       	mov    %eax,0xc011af7c
c0104ef0:	89 15 80 af 11 c0    	mov    %edx,0xc011af80
    nr_free = nr_free_store;
c0104ef6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104ef9:	a3 84 af 11 c0       	mov    %eax,0xc011af84

    free_page(p);
c0104efe:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104f05:	00 
c0104f06:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104f09:	89 04 24             	mov    %eax,(%esp)
c0104f0c:	e8 1b de ff ff       	call   c0102d2c <free_pages>
    free_page(p1);
c0104f11:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104f18:	00 
c0104f19:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104f1c:	89 04 24             	mov    %eax,(%esp)
c0104f1f:	e8 08 de ff ff       	call   c0102d2c <free_pages>
    free_page(p2);
c0104f24:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104f2b:	00 
c0104f2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f2f:	89 04 24             	mov    %eax,(%esp)
c0104f32:	e8 f5 dd ff ff       	call   c0102d2c <free_pages>
}
c0104f37:	c9                   	leave  
c0104f38:	c3                   	ret    

c0104f39 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c0104f39:	55                   	push   %ebp
c0104f3a:	89 e5                	mov    %esp,%ebp
c0104f3c:	53                   	push   %ebx
c0104f3d:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
c0104f43:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104f4a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c0104f51:	c7 45 ec 7c af 11 c0 	movl   $0xc011af7c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0104f58:	eb 6b                	jmp    c0104fc5 <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
c0104f5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104f5d:	83 e8 0c             	sub    $0xc,%eax
c0104f60:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
c0104f63:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104f66:	83 c0 04             	add    $0x4,%eax
c0104f69:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0104f70:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104f73:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0104f76:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104f79:	0f a3 10             	bt     %edx,(%eax)
c0104f7c:	19 c0                	sbb    %eax,%eax
c0104f7e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c0104f81:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0104f85:	0f 95 c0             	setne  %al
c0104f88:	0f b6 c0             	movzbl %al,%eax
c0104f8b:	85 c0                	test   %eax,%eax
c0104f8d:	75 24                	jne    c0104fb3 <default_check+0x7a>
c0104f8f:	c7 44 24 0c 7e 70 10 	movl   $0xc010707e,0xc(%esp)
c0104f96:	c0 
c0104f97:	c7 44 24 08 7e 6e 10 	movl   $0xc0106e7e,0x8(%esp)
c0104f9e:	c0 
c0104f9f:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
c0104fa6:	00 
c0104fa7:	c7 04 24 93 6e 10 c0 	movl   $0xc0106e93,(%esp)
c0104fae:	e8 41 b4 ff ff       	call   c01003f4 <__panic>
        count ++, total += p->property;
c0104fb3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0104fb7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104fba:	8b 50 08             	mov    0x8(%eax),%edx
c0104fbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104fc0:	01 d0                	add    %edx,%eax
c0104fc2:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104fc5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104fc8:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return listelm->next;
c0104fcb:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104fce:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c0104fd1:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104fd4:	81 7d ec 7c af 11 c0 	cmpl   $0xc011af7c,-0x14(%ebp)
c0104fdb:	0f 85 79 ff ff ff    	jne    c0104f5a <default_check+0x21>
    }
    assert(total == nr_free_pages());
c0104fe1:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c0104fe4:	e8 75 dd ff ff       	call   c0102d5e <nr_free_pages>
c0104fe9:	39 c3                	cmp    %eax,%ebx
c0104feb:	74 24                	je     c0105011 <default_check+0xd8>
c0104fed:	c7 44 24 0c 8e 70 10 	movl   $0xc010708e,0xc(%esp)
c0104ff4:	c0 
c0104ff5:	c7 44 24 08 7e 6e 10 	movl   $0xc0106e7e,0x8(%esp)
c0104ffc:	c0 
c0104ffd:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
c0105004:	00 
c0105005:	c7 04 24 93 6e 10 c0 	movl   $0xc0106e93,(%esp)
c010500c:	e8 e3 b3 ff ff       	call   c01003f4 <__panic>

    basic_check();
c0105011:	e8 e7 f9 ff ff       	call   c01049fd <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c0105016:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c010501d:	e8 d2 dc ff ff       	call   c0102cf4 <alloc_pages>
c0105022:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
c0105025:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105029:	75 24                	jne    c010504f <default_check+0x116>
c010502b:	c7 44 24 0c a7 70 10 	movl   $0xc01070a7,0xc(%esp)
c0105032:	c0 
c0105033:	c7 44 24 08 7e 6e 10 	movl   $0xc0106e7e,0x8(%esp)
c010503a:	c0 
c010503b:	c7 44 24 04 07 01 00 	movl   $0x107,0x4(%esp)
c0105042:	00 
c0105043:	c7 04 24 93 6e 10 c0 	movl   $0xc0106e93,(%esp)
c010504a:	e8 a5 b3 ff ff       	call   c01003f4 <__panic>
    assert(!PageProperty(p0));
c010504f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105052:	83 c0 04             	add    $0x4,%eax
c0105055:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c010505c:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010505f:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0105062:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0105065:	0f a3 10             	bt     %edx,(%eax)
c0105068:	19 c0                	sbb    %eax,%eax
c010506a:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c010506d:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c0105071:	0f 95 c0             	setne  %al
c0105074:	0f b6 c0             	movzbl %al,%eax
c0105077:	85 c0                	test   %eax,%eax
c0105079:	74 24                	je     c010509f <default_check+0x166>
c010507b:	c7 44 24 0c b2 70 10 	movl   $0xc01070b2,0xc(%esp)
c0105082:	c0 
c0105083:	c7 44 24 08 7e 6e 10 	movl   $0xc0106e7e,0x8(%esp)
c010508a:	c0 
c010508b:	c7 44 24 04 08 01 00 	movl   $0x108,0x4(%esp)
c0105092:	00 
c0105093:	c7 04 24 93 6e 10 c0 	movl   $0xc0106e93,(%esp)
c010509a:	e8 55 b3 ff ff       	call   c01003f4 <__panic>

    list_entry_t free_list_store = free_list;
c010509f:	a1 7c af 11 c0       	mov    0xc011af7c,%eax
c01050a4:	8b 15 80 af 11 c0    	mov    0xc011af80,%edx
c01050aa:	89 45 80             	mov    %eax,-0x80(%ebp)
c01050ad:	89 55 84             	mov    %edx,-0x7c(%ebp)
c01050b0:	c7 45 b4 7c af 11 c0 	movl   $0xc011af7c,-0x4c(%ebp)
    elm->prev = elm->next = elm;
c01050b7:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01050ba:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c01050bd:	89 50 04             	mov    %edx,0x4(%eax)
c01050c0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01050c3:	8b 50 04             	mov    0x4(%eax),%edx
c01050c6:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01050c9:	89 10                	mov    %edx,(%eax)
c01050cb:	c7 45 b0 7c af 11 c0 	movl   $0xc011af7c,-0x50(%ebp)
    return list->next == list;
c01050d2:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01050d5:	8b 40 04             	mov    0x4(%eax),%eax
c01050d8:	39 45 b0             	cmp    %eax,-0x50(%ebp)
c01050db:	0f 94 c0             	sete   %al
c01050de:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c01050e1:	85 c0                	test   %eax,%eax
c01050e3:	75 24                	jne    c0105109 <default_check+0x1d0>
c01050e5:	c7 44 24 0c 07 70 10 	movl   $0xc0107007,0xc(%esp)
c01050ec:	c0 
c01050ed:	c7 44 24 08 7e 6e 10 	movl   $0xc0106e7e,0x8(%esp)
c01050f4:	c0 
c01050f5:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
c01050fc:	00 
c01050fd:	c7 04 24 93 6e 10 c0 	movl   $0xc0106e93,(%esp)
c0105104:	e8 eb b2 ff ff       	call   c01003f4 <__panic>
    assert(alloc_page() == NULL);
c0105109:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105110:	e8 df db ff ff       	call   c0102cf4 <alloc_pages>
c0105115:	85 c0                	test   %eax,%eax
c0105117:	74 24                	je     c010513d <default_check+0x204>
c0105119:	c7 44 24 0c 1e 70 10 	movl   $0xc010701e,0xc(%esp)
c0105120:	c0 
c0105121:	c7 44 24 08 7e 6e 10 	movl   $0xc0106e7e,0x8(%esp)
c0105128:	c0 
c0105129:	c7 44 24 04 0d 01 00 	movl   $0x10d,0x4(%esp)
c0105130:	00 
c0105131:	c7 04 24 93 6e 10 c0 	movl   $0xc0106e93,(%esp)
c0105138:	e8 b7 b2 ff ff       	call   c01003f4 <__panic>

    unsigned int nr_free_store = nr_free;
c010513d:	a1 84 af 11 c0       	mov    0xc011af84,%eax
c0105142:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c0105145:	c7 05 84 af 11 c0 00 	movl   $0x0,0xc011af84
c010514c:	00 00 00 

    free_pages(p0 + 2, 3);
c010514f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105152:	83 c0 28             	add    $0x28,%eax
c0105155:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c010515c:	00 
c010515d:	89 04 24             	mov    %eax,(%esp)
c0105160:	e8 c7 db ff ff       	call   c0102d2c <free_pages>
    assert(alloc_pages(4) == NULL);
c0105165:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c010516c:	e8 83 db ff ff       	call   c0102cf4 <alloc_pages>
c0105171:	85 c0                	test   %eax,%eax
c0105173:	74 24                	je     c0105199 <default_check+0x260>
c0105175:	c7 44 24 0c c4 70 10 	movl   $0xc01070c4,0xc(%esp)
c010517c:	c0 
c010517d:	c7 44 24 08 7e 6e 10 	movl   $0xc0106e7e,0x8(%esp)
c0105184:	c0 
c0105185:	c7 44 24 04 13 01 00 	movl   $0x113,0x4(%esp)
c010518c:	00 
c010518d:	c7 04 24 93 6e 10 c0 	movl   $0xc0106e93,(%esp)
c0105194:	e8 5b b2 ff ff       	call   c01003f4 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c0105199:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010519c:	83 c0 28             	add    $0x28,%eax
c010519f:	83 c0 04             	add    $0x4,%eax
c01051a2:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c01051a9:	89 45 a8             	mov    %eax,-0x58(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01051ac:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01051af:	8b 55 ac             	mov    -0x54(%ebp),%edx
c01051b2:	0f a3 10             	bt     %edx,(%eax)
c01051b5:	19 c0                	sbb    %eax,%eax
c01051b7:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c01051ba:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c01051be:	0f 95 c0             	setne  %al
c01051c1:	0f b6 c0             	movzbl %al,%eax
c01051c4:	85 c0                	test   %eax,%eax
c01051c6:	74 0e                	je     c01051d6 <default_check+0x29d>
c01051c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01051cb:	83 c0 28             	add    $0x28,%eax
c01051ce:	8b 40 08             	mov    0x8(%eax),%eax
c01051d1:	83 f8 03             	cmp    $0x3,%eax
c01051d4:	74 24                	je     c01051fa <default_check+0x2c1>
c01051d6:	c7 44 24 0c dc 70 10 	movl   $0xc01070dc,0xc(%esp)
c01051dd:	c0 
c01051de:	c7 44 24 08 7e 6e 10 	movl   $0xc0106e7e,0x8(%esp)
c01051e5:	c0 
c01051e6:	c7 44 24 04 14 01 00 	movl   $0x114,0x4(%esp)
c01051ed:	00 
c01051ee:	c7 04 24 93 6e 10 c0 	movl   $0xc0106e93,(%esp)
c01051f5:	e8 fa b1 ff ff       	call   c01003f4 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c01051fa:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c0105201:	e8 ee da ff ff       	call   c0102cf4 <alloc_pages>
c0105206:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0105209:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c010520d:	75 24                	jne    c0105233 <default_check+0x2fa>
c010520f:	c7 44 24 0c 08 71 10 	movl   $0xc0107108,0xc(%esp)
c0105216:	c0 
c0105217:	c7 44 24 08 7e 6e 10 	movl   $0xc0106e7e,0x8(%esp)
c010521e:	c0 
c010521f:	c7 44 24 04 15 01 00 	movl   $0x115,0x4(%esp)
c0105226:	00 
c0105227:	c7 04 24 93 6e 10 c0 	movl   $0xc0106e93,(%esp)
c010522e:	e8 c1 b1 ff ff       	call   c01003f4 <__panic>
    assert(alloc_page() == NULL);
c0105233:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010523a:	e8 b5 da ff ff       	call   c0102cf4 <alloc_pages>
c010523f:	85 c0                	test   %eax,%eax
c0105241:	74 24                	je     c0105267 <default_check+0x32e>
c0105243:	c7 44 24 0c 1e 70 10 	movl   $0xc010701e,0xc(%esp)
c010524a:	c0 
c010524b:	c7 44 24 08 7e 6e 10 	movl   $0xc0106e7e,0x8(%esp)
c0105252:	c0 
c0105253:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
c010525a:	00 
c010525b:	c7 04 24 93 6e 10 c0 	movl   $0xc0106e93,(%esp)
c0105262:	e8 8d b1 ff ff       	call   c01003f4 <__panic>
    assert(p0 + 2 == p1);
c0105267:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010526a:	83 c0 28             	add    $0x28,%eax
c010526d:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0105270:	74 24                	je     c0105296 <default_check+0x35d>
c0105272:	c7 44 24 0c 26 71 10 	movl   $0xc0107126,0xc(%esp)
c0105279:	c0 
c010527a:	c7 44 24 08 7e 6e 10 	movl   $0xc0106e7e,0x8(%esp)
c0105281:	c0 
c0105282:	c7 44 24 04 17 01 00 	movl   $0x117,0x4(%esp)
c0105289:	00 
c010528a:	c7 04 24 93 6e 10 c0 	movl   $0xc0106e93,(%esp)
c0105291:	e8 5e b1 ff ff       	call   c01003f4 <__panic>

    p2 = p0 + 1;
c0105296:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105299:	83 c0 14             	add    $0x14,%eax
c010529c:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
c010529f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01052a6:	00 
c01052a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01052aa:	89 04 24             	mov    %eax,(%esp)
c01052ad:	e8 7a da ff ff       	call   c0102d2c <free_pages>
    free_pages(p1, 3);
c01052b2:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c01052b9:	00 
c01052ba:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01052bd:	89 04 24             	mov    %eax,(%esp)
c01052c0:	e8 67 da ff ff       	call   c0102d2c <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c01052c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01052c8:	83 c0 04             	add    $0x4,%eax
c01052cb:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c01052d2:	89 45 9c             	mov    %eax,-0x64(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01052d5:	8b 45 9c             	mov    -0x64(%ebp),%eax
c01052d8:	8b 55 a0             	mov    -0x60(%ebp),%edx
c01052db:	0f a3 10             	bt     %edx,(%eax)
c01052de:	19 c0                	sbb    %eax,%eax
c01052e0:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c01052e3:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c01052e7:	0f 95 c0             	setne  %al
c01052ea:	0f b6 c0             	movzbl %al,%eax
c01052ed:	85 c0                	test   %eax,%eax
c01052ef:	74 0b                	je     c01052fc <default_check+0x3c3>
c01052f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01052f4:	8b 40 08             	mov    0x8(%eax),%eax
c01052f7:	83 f8 01             	cmp    $0x1,%eax
c01052fa:	74 24                	je     c0105320 <default_check+0x3e7>
c01052fc:	c7 44 24 0c 34 71 10 	movl   $0xc0107134,0xc(%esp)
c0105303:	c0 
c0105304:	c7 44 24 08 7e 6e 10 	movl   $0xc0106e7e,0x8(%esp)
c010530b:	c0 
c010530c:	c7 44 24 04 1c 01 00 	movl   $0x11c,0x4(%esp)
c0105313:	00 
c0105314:	c7 04 24 93 6e 10 c0 	movl   $0xc0106e93,(%esp)
c010531b:	e8 d4 b0 ff ff       	call   c01003f4 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c0105320:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105323:	83 c0 04             	add    $0x4,%eax
c0105326:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c010532d:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0105330:	8b 45 90             	mov    -0x70(%ebp),%eax
c0105333:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0105336:	0f a3 10             	bt     %edx,(%eax)
c0105339:	19 c0                	sbb    %eax,%eax
c010533b:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c010533e:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c0105342:	0f 95 c0             	setne  %al
c0105345:	0f b6 c0             	movzbl %al,%eax
c0105348:	85 c0                	test   %eax,%eax
c010534a:	74 0b                	je     c0105357 <default_check+0x41e>
c010534c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010534f:	8b 40 08             	mov    0x8(%eax),%eax
c0105352:	83 f8 03             	cmp    $0x3,%eax
c0105355:	74 24                	je     c010537b <default_check+0x442>
c0105357:	c7 44 24 0c 5c 71 10 	movl   $0xc010715c,0xc(%esp)
c010535e:	c0 
c010535f:	c7 44 24 08 7e 6e 10 	movl   $0xc0106e7e,0x8(%esp)
c0105366:	c0 
c0105367:	c7 44 24 04 1d 01 00 	movl   $0x11d,0x4(%esp)
c010536e:	00 
c010536f:	c7 04 24 93 6e 10 c0 	movl   $0xc0106e93,(%esp)
c0105376:	e8 79 b0 ff ff       	call   c01003f4 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c010537b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105382:	e8 6d d9 ff ff       	call   c0102cf4 <alloc_pages>
c0105387:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010538a:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010538d:	83 e8 14             	sub    $0x14,%eax
c0105390:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0105393:	74 24                	je     c01053b9 <default_check+0x480>
c0105395:	c7 44 24 0c 82 71 10 	movl   $0xc0107182,0xc(%esp)
c010539c:	c0 
c010539d:	c7 44 24 08 7e 6e 10 	movl   $0xc0106e7e,0x8(%esp)
c01053a4:	c0 
c01053a5:	c7 44 24 04 1f 01 00 	movl   $0x11f,0x4(%esp)
c01053ac:	00 
c01053ad:	c7 04 24 93 6e 10 c0 	movl   $0xc0106e93,(%esp)
c01053b4:	e8 3b b0 ff ff       	call   c01003f4 <__panic>
    free_page(p0);
c01053b9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01053c0:	00 
c01053c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01053c4:	89 04 24             	mov    %eax,(%esp)
c01053c7:	e8 60 d9 ff ff       	call   c0102d2c <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c01053cc:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c01053d3:	e8 1c d9 ff ff       	call   c0102cf4 <alloc_pages>
c01053d8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01053db:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01053de:	83 c0 14             	add    $0x14,%eax
c01053e1:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c01053e4:	74 24                	je     c010540a <default_check+0x4d1>
c01053e6:	c7 44 24 0c a0 71 10 	movl   $0xc01071a0,0xc(%esp)
c01053ed:	c0 
c01053ee:	c7 44 24 08 7e 6e 10 	movl   $0xc0106e7e,0x8(%esp)
c01053f5:	c0 
c01053f6:	c7 44 24 04 21 01 00 	movl   $0x121,0x4(%esp)
c01053fd:	00 
c01053fe:	c7 04 24 93 6e 10 c0 	movl   $0xc0106e93,(%esp)
c0105405:	e8 ea af ff ff       	call   c01003f4 <__panic>

    free_pages(p0, 2);
c010540a:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c0105411:	00 
c0105412:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105415:	89 04 24             	mov    %eax,(%esp)
c0105418:	e8 0f d9 ff ff       	call   c0102d2c <free_pages>
    free_page(p2);
c010541d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105424:	00 
c0105425:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105428:	89 04 24             	mov    %eax,(%esp)
c010542b:	e8 fc d8 ff ff       	call   c0102d2c <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c0105430:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0105437:	e8 b8 d8 ff ff       	call   c0102cf4 <alloc_pages>
c010543c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010543f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105443:	75 24                	jne    c0105469 <default_check+0x530>
c0105445:	c7 44 24 0c c0 71 10 	movl   $0xc01071c0,0xc(%esp)
c010544c:	c0 
c010544d:	c7 44 24 08 7e 6e 10 	movl   $0xc0106e7e,0x8(%esp)
c0105454:	c0 
c0105455:	c7 44 24 04 26 01 00 	movl   $0x126,0x4(%esp)
c010545c:	00 
c010545d:	c7 04 24 93 6e 10 c0 	movl   $0xc0106e93,(%esp)
c0105464:	e8 8b af ff ff       	call   c01003f4 <__panic>
    assert(alloc_page() == NULL);
c0105469:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105470:	e8 7f d8 ff ff       	call   c0102cf4 <alloc_pages>
c0105475:	85 c0                	test   %eax,%eax
c0105477:	74 24                	je     c010549d <default_check+0x564>
c0105479:	c7 44 24 0c 1e 70 10 	movl   $0xc010701e,0xc(%esp)
c0105480:	c0 
c0105481:	c7 44 24 08 7e 6e 10 	movl   $0xc0106e7e,0x8(%esp)
c0105488:	c0 
c0105489:	c7 44 24 04 27 01 00 	movl   $0x127,0x4(%esp)
c0105490:	00 
c0105491:	c7 04 24 93 6e 10 c0 	movl   $0xc0106e93,(%esp)
c0105498:	e8 57 af ff ff       	call   c01003f4 <__panic>

    assert(nr_free == 0);
c010549d:	a1 84 af 11 c0       	mov    0xc011af84,%eax
c01054a2:	85 c0                	test   %eax,%eax
c01054a4:	74 24                	je     c01054ca <default_check+0x591>
c01054a6:	c7 44 24 0c 71 70 10 	movl   $0xc0107071,0xc(%esp)
c01054ad:	c0 
c01054ae:	c7 44 24 08 7e 6e 10 	movl   $0xc0106e7e,0x8(%esp)
c01054b5:	c0 
c01054b6:	c7 44 24 04 29 01 00 	movl   $0x129,0x4(%esp)
c01054bd:	00 
c01054be:	c7 04 24 93 6e 10 c0 	movl   $0xc0106e93,(%esp)
c01054c5:	e8 2a af ff ff       	call   c01003f4 <__panic>
    nr_free = nr_free_store;
c01054ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01054cd:	a3 84 af 11 c0       	mov    %eax,0xc011af84

    free_list = free_list_store;
c01054d2:	8b 45 80             	mov    -0x80(%ebp),%eax
c01054d5:	8b 55 84             	mov    -0x7c(%ebp),%edx
c01054d8:	a3 7c af 11 c0       	mov    %eax,0xc011af7c
c01054dd:	89 15 80 af 11 c0    	mov    %edx,0xc011af80
    free_pages(p0, 5);
c01054e3:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c01054ea:	00 
c01054eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01054ee:	89 04 24             	mov    %eax,(%esp)
c01054f1:	e8 36 d8 ff ff       	call   c0102d2c <free_pages>

    le = &free_list;
c01054f6:	c7 45 ec 7c af 11 c0 	movl   $0xc011af7c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c01054fd:	eb 1d                	jmp    c010551c <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
c01054ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105502:	83 e8 0c             	sub    $0xc,%eax
c0105505:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
c0105508:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c010550c:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010550f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0105512:	8b 40 08             	mov    0x8(%eax),%eax
c0105515:	29 c2                	sub    %eax,%edx
c0105517:	89 d0                	mov    %edx,%eax
c0105519:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010551c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010551f:	89 45 88             	mov    %eax,-0x78(%ebp)
    return listelm->next;
c0105522:	8b 45 88             	mov    -0x78(%ebp),%eax
c0105525:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c0105528:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010552b:	81 7d ec 7c af 11 c0 	cmpl   $0xc011af7c,-0x14(%ebp)
c0105532:	75 cb                	jne    c01054ff <default_check+0x5c6>
    }
    assert(count == 0);
c0105534:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105538:	74 24                	je     c010555e <default_check+0x625>
c010553a:	c7 44 24 0c de 71 10 	movl   $0xc01071de,0xc(%esp)
c0105541:	c0 
c0105542:	c7 44 24 08 7e 6e 10 	movl   $0xc0106e7e,0x8(%esp)
c0105549:	c0 
c010554a:	c7 44 24 04 34 01 00 	movl   $0x134,0x4(%esp)
c0105551:	00 
c0105552:	c7 04 24 93 6e 10 c0 	movl   $0xc0106e93,(%esp)
c0105559:	e8 96 ae ff ff       	call   c01003f4 <__panic>
    assert(total == 0);
c010555e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105562:	74 24                	je     c0105588 <default_check+0x64f>
c0105564:	c7 44 24 0c e9 71 10 	movl   $0xc01071e9,0xc(%esp)
c010556b:	c0 
c010556c:	c7 44 24 08 7e 6e 10 	movl   $0xc0106e7e,0x8(%esp)
c0105573:	c0 
c0105574:	c7 44 24 04 35 01 00 	movl   $0x135,0x4(%esp)
c010557b:	00 
c010557c:	c7 04 24 93 6e 10 c0 	movl   $0xc0106e93,(%esp)
c0105583:	e8 6c ae ff ff       	call   c01003f4 <__panic>
}
c0105588:	81 c4 94 00 00 00    	add    $0x94,%esp
c010558e:	5b                   	pop    %ebx
c010558f:	5d                   	pop    %ebp
c0105590:	c3                   	ret    

c0105591 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c0105591:	55                   	push   %ebp
c0105592:	89 e5                	mov    %esp,%ebp
c0105594:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105597:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c010559e:	eb 04                	jmp    c01055a4 <strlen+0x13>
        cnt ++;
c01055a0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    while (*s ++ != '\0') {
c01055a4:	8b 45 08             	mov    0x8(%ebp),%eax
c01055a7:	8d 50 01             	lea    0x1(%eax),%edx
c01055aa:	89 55 08             	mov    %edx,0x8(%ebp)
c01055ad:	0f b6 00             	movzbl (%eax),%eax
c01055b0:	84 c0                	test   %al,%al
c01055b2:	75 ec                	jne    c01055a0 <strlen+0xf>
    }
    return cnt;
c01055b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01055b7:	c9                   	leave  
c01055b8:	c3                   	ret    

c01055b9 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c01055b9:	55                   	push   %ebp
c01055ba:	89 e5                	mov    %esp,%ebp
c01055bc:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c01055bf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c01055c6:	eb 04                	jmp    c01055cc <strnlen+0x13>
        cnt ++;
c01055c8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c01055cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01055cf:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01055d2:	73 10                	jae    c01055e4 <strnlen+0x2b>
c01055d4:	8b 45 08             	mov    0x8(%ebp),%eax
c01055d7:	8d 50 01             	lea    0x1(%eax),%edx
c01055da:	89 55 08             	mov    %edx,0x8(%ebp)
c01055dd:	0f b6 00             	movzbl (%eax),%eax
c01055e0:	84 c0                	test   %al,%al
c01055e2:	75 e4                	jne    c01055c8 <strnlen+0xf>
    }
    return cnt;
c01055e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01055e7:	c9                   	leave  
c01055e8:	c3                   	ret    

c01055e9 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c01055e9:	55                   	push   %ebp
c01055ea:	89 e5                	mov    %esp,%ebp
c01055ec:	57                   	push   %edi
c01055ed:	56                   	push   %esi
c01055ee:	83 ec 20             	sub    $0x20,%esp
c01055f1:	8b 45 08             	mov    0x8(%ebp),%eax
c01055f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01055f7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01055fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c01055fd:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105600:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105603:	89 d1                	mov    %edx,%ecx
c0105605:	89 c2                	mov    %eax,%edx
c0105607:	89 ce                	mov    %ecx,%esi
c0105609:	89 d7                	mov    %edx,%edi
c010560b:	ac                   	lods   %ds:(%esi),%al
c010560c:	aa                   	stos   %al,%es:(%edi)
c010560d:	84 c0                	test   %al,%al
c010560f:	75 fa                	jne    c010560b <strcpy+0x22>
c0105611:	89 fa                	mov    %edi,%edx
c0105613:	89 f1                	mov    %esi,%ecx
c0105615:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105618:	89 55 e8             	mov    %edx,-0x18(%ebp)
c010561b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c010561e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c0105621:	83 c4 20             	add    $0x20,%esp
c0105624:	5e                   	pop    %esi
c0105625:	5f                   	pop    %edi
c0105626:	5d                   	pop    %ebp
c0105627:	c3                   	ret    

c0105628 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c0105628:	55                   	push   %ebp
c0105629:	89 e5                	mov    %esp,%ebp
c010562b:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c010562e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105631:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c0105634:	eb 21                	jmp    c0105657 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c0105636:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105639:	0f b6 10             	movzbl (%eax),%edx
c010563c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010563f:	88 10                	mov    %dl,(%eax)
c0105641:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105644:	0f b6 00             	movzbl (%eax),%eax
c0105647:	84 c0                	test   %al,%al
c0105649:	74 04                	je     c010564f <strncpy+0x27>
            src ++;
c010564b:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c010564f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0105653:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    while (len > 0) {
c0105657:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010565b:	75 d9                	jne    c0105636 <strncpy+0xe>
    }
    return dst;
c010565d:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105660:	c9                   	leave  
c0105661:	c3                   	ret    

c0105662 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c0105662:	55                   	push   %ebp
c0105663:	89 e5                	mov    %esp,%ebp
c0105665:	57                   	push   %edi
c0105666:	56                   	push   %esi
c0105667:	83 ec 20             	sub    $0x20,%esp
c010566a:	8b 45 08             	mov    0x8(%ebp),%eax
c010566d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105670:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105673:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
c0105676:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105679:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010567c:	89 d1                	mov    %edx,%ecx
c010567e:	89 c2                	mov    %eax,%edx
c0105680:	89 ce                	mov    %ecx,%esi
c0105682:	89 d7                	mov    %edx,%edi
c0105684:	ac                   	lods   %ds:(%esi),%al
c0105685:	ae                   	scas   %es:(%edi),%al
c0105686:	75 08                	jne    c0105690 <strcmp+0x2e>
c0105688:	84 c0                	test   %al,%al
c010568a:	75 f8                	jne    c0105684 <strcmp+0x22>
c010568c:	31 c0                	xor    %eax,%eax
c010568e:	eb 04                	jmp    c0105694 <strcmp+0x32>
c0105690:	19 c0                	sbb    %eax,%eax
c0105692:	0c 01                	or     $0x1,%al
c0105694:	89 fa                	mov    %edi,%edx
c0105696:	89 f1                	mov    %esi,%ecx
c0105698:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010569b:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c010569e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
c01056a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c01056a4:	83 c4 20             	add    $0x20,%esp
c01056a7:	5e                   	pop    %esi
c01056a8:	5f                   	pop    %edi
c01056a9:	5d                   	pop    %ebp
c01056aa:	c3                   	ret    

c01056ab <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c01056ab:	55                   	push   %ebp
c01056ac:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c01056ae:	eb 0c                	jmp    c01056bc <strncmp+0x11>
        n --, s1 ++, s2 ++;
c01056b0:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c01056b4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01056b8:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c01056bc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01056c0:	74 1a                	je     c01056dc <strncmp+0x31>
c01056c2:	8b 45 08             	mov    0x8(%ebp),%eax
c01056c5:	0f b6 00             	movzbl (%eax),%eax
c01056c8:	84 c0                	test   %al,%al
c01056ca:	74 10                	je     c01056dc <strncmp+0x31>
c01056cc:	8b 45 08             	mov    0x8(%ebp),%eax
c01056cf:	0f b6 10             	movzbl (%eax),%edx
c01056d2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01056d5:	0f b6 00             	movzbl (%eax),%eax
c01056d8:	38 c2                	cmp    %al,%dl
c01056da:	74 d4                	je     c01056b0 <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c01056dc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01056e0:	74 18                	je     c01056fa <strncmp+0x4f>
c01056e2:	8b 45 08             	mov    0x8(%ebp),%eax
c01056e5:	0f b6 00             	movzbl (%eax),%eax
c01056e8:	0f b6 d0             	movzbl %al,%edx
c01056eb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01056ee:	0f b6 00             	movzbl (%eax),%eax
c01056f1:	0f b6 c0             	movzbl %al,%eax
c01056f4:	29 c2                	sub    %eax,%edx
c01056f6:	89 d0                	mov    %edx,%eax
c01056f8:	eb 05                	jmp    c01056ff <strncmp+0x54>
c01056fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01056ff:	5d                   	pop    %ebp
c0105700:	c3                   	ret    

c0105701 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0105701:	55                   	push   %ebp
c0105702:	89 e5                	mov    %esp,%ebp
c0105704:	83 ec 04             	sub    $0x4,%esp
c0105707:	8b 45 0c             	mov    0xc(%ebp),%eax
c010570a:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c010570d:	eb 14                	jmp    c0105723 <strchr+0x22>
        if (*s == c) {
c010570f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105712:	0f b6 00             	movzbl (%eax),%eax
c0105715:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0105718:	75 05                	jne    c010571f <strchr+0x1e>
            return (char *)s;
c010571a:	8b 45 08             	mov    0x8(%ebp),%eax
c010571d:	eb 13                	jmp    c0105732 <strchr+0x31>
        }
        s ++;
c010571f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s != '\0') {
c0105723:	8b 45 08             	mov    0x8(%ebp),%eax
c0105726:	0f b6 00             	movzbl (%eax),%eax
c0105729:	84 c0                	test   %al,%al
c010572b:	75 e2                	jne    c010570f <strchr+0xe>
    }
    return NULL;
c010572d:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105732:	c9                   	leave  
c0105733:	c3                   	ret    

c0105734 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c0105734:	55                   	push   %ebp
c0105735:	89 e5                	mov    %esp,%ebp
c0105737:	83 ec 04             	sub    $0x4,%esp
c010573a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010573d:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105740:	eb 11                	jmp    c0105753 <strfind+0x1f>
        if (*s == c) {
c0105742:	8b 45 08             	mov    0x8(%ebp),%eax
c0105745:	0f b6 00             	movzbl (%eax),%eax
c0105748:	3a 45 fc             	cmp    -0x4(%ebp),%al
c010574b:	75 02                	jne    c010574f <strfind+0x1b>
            break;
c010574d:	eb 0e                	jmp    c010575d <strfind+0x29>
        }
        s ++;
c010574f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s != '\0') {
c0105753:	8b 45 08             	mov    0x8(%ebp),%eax
c0105756:	0f b6 00             	movzbl (%eax),%eax
c0105759:	84 c0                	test   %al,%al
c010575b:	75 e5                	jne    c0105742 <strfind+0xe>
    }
    return (char *)s;
c010575d:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105760:	c9                   	leave  
c0105761:	c3                   	ret    

c0105762 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c0105762:	55                   	push   %ebp
c0105763:	89 e5                	mov    %esp,%ebp
c0105765:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c0105768:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c010576f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105776:	eb 04                	jmp    c010577c <strtol+0x1a>
        s ++;
c0105778:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
c010577c:	8b 45 08             	mov    0x8(%ebp),%eax
c010577f:	0f b6 00             	movzbl (%eax),%eax
c0105782:	3c 20                	cmp    $0x20,%al
c0105784:	74 f2                	je     c0105778 <strtol+0x16>
c0105786:	8b 45 08             	mov    0x8(%ebp),%eax
c0105789:	0f b6 00             	movzbl (%eax),%eax
c010578c:	3c 09                	cmp    $0x9,%al
c010578e:	74 e8                	je     c0105778 <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+') {
c0105790:	8b 45 08             	mov    0x8(%ebp),%eax
c0105793:	0f b6 00             	movzbl (%eax),%eax
c0105796:	3c 2b                	cmp    $0x2b,%al
c0105798:	75 06                	jne    c01057a0 <strtol+0x3e>
        s ++;
c010579a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c010579e:	eb 15                	jmp    c01057b5 <strtol+0x53>
    }
    else if (*s == '-') {
c01057a0:	8b 45 08             	mov    0x8(%ebp),%eax
c01057a3:	0f b6 00             	movzbl (%eax),%eax
c01057a6:	3c 2d                	cmp    $0x2d,%al
c01057a8:	75 0b                	jne    c01057b5 <strtol+0x53>
        s ++, neg = 1;
c01057aa:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01057ae:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c01057b5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01057b9:	74 06                	je     c01057c1 <strtol+0x5f>
c01057bb:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c01057bf:	75 24                	jne    c01057e5 <strtol+0x83>
c01057c1:	8b 45 08             	mov    0x8(%ebp),%eax
c01057c4:	0f b6 00             	movzbl (%eax),%eax
c01057c7:	3c 30                	cmp    $0x30,%al
c01057c9:	75 1a                	jne    c01057e5 <strtol+0x83>
c01057cb:	8b 45 08             	mov    0x8(%ebp),%eax
c01057ce:	83 c0 01             	add    $0x1,%eax
c01057d1:	0f b6 00             	movzbl (%eax),%eax
c01057d4:	3c 78                	cmp    $0x78,%al
c01057d6:	75 0d                	jne    c01057e5 <strtol+0x83>
        s += 2, base = 16;
c01057d8:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c01057dc:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c01057e3:	eb 2a                	jmp    c010580f <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c01057e5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01057e9:	75 17                	jne    c0105802 <strtol+0xa0>
c01057eb:	8b 45 08             	mov    0x8(%ebp),%eax
c01057ee:	0f b6 00             	movzbl (%eax),%eax
c01057f1:	3c 30                	cmp    $0x30,%al
c01057f3:	75 0d                	jne    c0105802 <strtol+0xa0>
        s ++, base = 8;
c01057f5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01057f9:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0105800:	eb 0d                	jmp    c010580f <strtol+0xad>
    }
    else if (base == 0) {
c0105802:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105806:	75 07                	jne    c010580f <strtol+0xad>
        base = 10;
c0105808:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c010580f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105812:	0f b6 00             	movzbl (%eax),%eax
c0105815:	3c 2f                	cmp    $0x2f,%al
c0105817:	7e 1b                	jle    c0105834 <strtol+0xd2>
c0105819:	8b 45 08             	mov    0x8(%ebp),%eax
c010581c:	0f b6 00             	movzbl (%eax),%eax
c010581f:	3c 39                	cmp    $0x39,%al
c0105821:	7f 11                	jg     c0105834 <strtol+0xd2>
            dig = *s - '0';
c0105823:	8b 45 08             	mov    0x8(%ebp),%eax
c0105826:	0f b6 00             	movzbl (%eax),%eax
c0105829:	0f be c0             	movsbl %al,%eax
c010582c:	83 e8 30             	sub    $0x30,%eax
c010582f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105832:	eb 48                	jmp    c010587c <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c0105834:	8b 45 08             	mov    0x8(%ebp),%eax
c0105837:	0f b6 00             	movzbl (%eax),%eax
c010583a:	3c 60                	cmp    $0x60,%al
c010583c:	7e 1b                	jle    c0105859 <strtol+0xf7>
c010583e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105841:	0f b6 00             	movzbl (%eax),%eax
c0105844:	3c 7a                	cmp    $0x7a,%al
c0105846:	7f 11                	jg     c0105859 <strtol+0xf7>
            dig = *s - 'a' + 10;
c0105848:	8b 45 08             	mov    0x8(%ebp),%eax
c010584b:	0f b6 00             	movzbl (%eax),%eax
c010584e:	0f be c0             	movsbl %al,%eax
c0105851:	83 e8 57             	sub    $0x57,%eax
c0105854:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105857:	eb 23                	jmp    c010587c <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0105859:	8b 45 08             	mov    0x8(%ebp),%eax
c010585c:	0f b6 00             	movzbl (%eax),%eax
c010585f:	3c 40                	cmp    $0x40,%al
c0105861:	7e 3d                	jle    c01058a0 <strtol+0x13e>
c0105863:	8b 45 08             	mov    0x8(%ebp),%eax
c0105866:	0f b6 00             	movzbl (%eax),%eax
c0105869:	3c 5a                	cmp    $0x5a,%al
c010586b:	7f 33                	jg     c01058a0 <strtol+0x13e>
            dig = *s - 'A' + 10;
c010586d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105870:	0f b6 00             	movzbl (%eax),%eax
c0105873:	0f be c0             	movsbl %al,%eax
c0105876:	83 e8 37             	sub    $0x37,%eax
c0105879:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c010587c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010587f:	3b 45 10             	cmp    0x10(%ebp),%eax
c0105882:	7c 02                	jl     c0105886 <strtol+0x124>
            break;
c0105884:	eb 1a                	jmp    c01058a0 <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
c0105886:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c010588a:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010588d:	0f af 45 10          	imul   0x10(%ebp),%eax
c0105891:	89 c2                	mov    %eax,%edx
c0105893:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105896:	01 d0                	add    %edx,%eax
c0105898:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
c010589b:	e9 6f ff ff ff       	jmp    c010580f <strtol+0xad>

    if (endptr) {
c01058a0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01058a4:	74 08                	je     c01058ae <strtol+0x14c>
        *endptr = (char *) s;
c01058a6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058a9:	8b 55 08             	mov    0x8(%ebp),%edx
c01058ac:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c01058ae:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c01058b2:	74 07                	je     c01058bb <strtol+0x159>
c01058b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01058b7:	f7 d8                	neg    %eax
c01058b9:	eb 03                	jmp    c01058be <strtol+0x15c>
c01058bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c01058be:	c9                   	leave  
c01058bf:	c3                   	ret    

c01058c0 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c01058c0:	55                   	push   %ebp
c01058c1:	89 e5                	mov    %esp,%ebp
c01058c3:	57                   	push   %edi
c01058c4:	83 ec 24             	sub    $0x24,%esp
c01058c7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058ca:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c01058cd:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c01058d1:	8b 55 08             	mov    0x8(%ebp),%edx
c01058d4:	89 55 f8             	mov    %edx,-0x8(%ebp)
c01058d7:	88 45 f7             	mov    %al,-0x9(%ebp)
c01058da:	8b 45 10             	mov    0x10(%ebp),%eax
c01058dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c01058e0:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c01058e3:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c01058e7:	8b 55 f8             	mov    -0x8(%ebp),%edx
c01058ea:	89 d7                	mov    %edx,%edi
c01058ec:	f3 aa                	rep stos %al,%es:(%edi)
c01058ee:	89 fa                	mov    %edi,%edx
c01058f0:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c01058f3:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c01058f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c01058f9:	83 c4 24             	add    $0x24,%esp
c01058fc:	5f                   	pop    %edi
c01058fd:	5d                   	pop    %ebp
c01058fe:	c3                   	ret    

c01058ff <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c01058ff:	55                   	push   %ebp
c0105900:	89 e5                	mov    %esp,%ebp
c0105902:	57                   	push   %edi
c0105903:	56                   	push   %esi
c0105904:	53                   	push   %ebx
c0105905:	83 ec 30             	sub    $0x30,%esp
c0105908:	8b 45 08             	mov    0x8(%ebp),%eax
c010590b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010590e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105911:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105914:	8b 45 10             	mov    0x10(%ebp),%eax
c0105917:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c010591a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010591d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0105920:	73 42                	jae    c0105964 <memmove+0x65>
c0105922:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105925:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105928:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010592b:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010592e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105931:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105934:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105937:	c1 e8 02             	shr    $0x2,%eax
c010593a:	89 c1                	mov    %eax,%ecx
    asm volatile (
c010593c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010593f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105942:	89 d7                	mov    %edx,%edi
c0105944:	89 c6                	mov    %eax,%esi
c0105946:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105948:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c010594b:	83 e1 03             	and    $0x3,%ecx
c010594e:	74 02                	je     c0105952 <memmove+0x53>
c0105950:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105952:	89 f0                	mov    %esi,%eax
c0105954:	89 fa                	mov    %edi,%edx
c0105956:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0105959:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010595c:	89 45 d0             	mov    %eax,-0x30(%ebp)
        : "memory");
    return dst;
c010595f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105962:	eb 36                	jmp    c010599a <memmove+0x9b>
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c0105964:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105967:	8d 50 ff             	lea    -0x1(%eax),%edx
c010596a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010596d:	01 c2                	add    %eax,%edx
c010596f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105972:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0105975:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105978:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
c010597b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010597e:	89 c1                	mov    %eax,%ecx
c0105980:	89 d8                	mov    %ebx,%eax
c0105982:	89 d6                	mov    %edx,%esi
c0105984:	89 c7                	mov    %eax,%edi
c0105986:	fd                   	std    
c0105987:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105989:	fc                   	cld    
c010598a:	89 f8                	mov    %edi,%eax
c010598c:	89 f2                	mov    %esi,%edx
c010598e:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0105991:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0105994:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
c0105997:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c010599a:	83 c4 30             	add    $0x30,%esp
c010599d:	5b                   	pop    %ebx
c010599e:	5e                   	pop    %esi
c010599f:	5f                   	pop    %edi
c01059a0:	5d                   	pop    %ebp
c01059a1:	c3                   	ret    

c01059a2 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c01059a2:	55                   	push   %ebp
c01059a3:	89 e5                	mov    %esp,%ebp
c01059a5:	57                   	push   %edi
c01059a6:	56                   	push   %esi
c01059a7:	83 ec 20             	sub    $0x20,%esp
c01059aa:	8b 45 08             	mov    0x8(%ebp),%eax
c01059ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01059b0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01059b6:	8b 45 10             	mov    0x10(%ebp),%eax
c01059b9:	89 45 ec             	mov    %eax,-0x14(%ebp)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c01059bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01059bf:	c1 e8 02             	shr    $0x2,%eax
c01059c2:	89 c1                	mov    %eax,%ecx
    asm volatile (
c01059c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01059c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01059ca:	89 d7                	mov    %edx,%edi
c01059cc:	89 c6                	mov    %eax,%esi
c01059ce:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c01059d0:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c01059d3:	83 e1 03             	and    $0x3,%ecx
c01059d6:	74 02                	je     c01059da <memcpy+0x38>
c01059d8:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c01059da:	89 f0                	mov    %esi,%eax
c01059dc:	89 fa                	mov    %edi,%edx
c01059de:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c01059e1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c01059e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
c01059e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c01059ea:	83 c4 20             	add    $0x20,%esp
c01059ed:	5e                   	pop    %esi
c01059ee:	5f                   	pop    %edi
c01059ef:	5d                   	pop    %ebp
c01059f0:	c3                   	ret    

c01059f1 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c01059f1:	55                   	push   %ebp
c01059f2:	89 e5                	mov    %esp,%ebp
c01059f4:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c01059f7:	8b 45 08             	mov    0x8(%ebp),%eax
c01059fa:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c01059fd:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a00:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c0105a03:	eb 30                	jmp    c0105a35 <memcmp+0x44>
        if (*s1 != *s2) {
c0105a05:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105a08:	0f b6 10             	movzbl (%eax),%edx
c0105a0b:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105a0e:	0f b6 00             	movzbl (%eax),%eax
c0105a11:	38 c2                	cmp    %al,%dl
c0105a13:	74 18                	je     c0105a2d <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105a15:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105a18:	0f b6 00             	movzbl (%eax),%eax
c0105a1b:	0f b6 d0             	movzbl %al,%edx
c0105a1e:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105a21:	0f b6 00             	movzbl (%eax),%eax
c0105a24:	0f b6 c0             	movzbl %al,%eax
c0105a27:	29 c2                	sub    %eax,%edx
c0105a29:	89 d0                	mov    %edx,%eax
c0105a2b:	eb 1a                	jmp    c0105a47 <memcmp+0x56>
        }
        s1 ++, s2 ++;
c0105a2d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0105a31:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
    while (n -- > 0) {
c0105a35:	8b 45 10             	mov    0x10(%ebp),%eax
c0105a38:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105a3b:	89 55 10             	mov    %edx,0x10(%ebp)
c0105a3e:	85 c0                	test   %eax,%eax
c0105a40:	75 c3                	jne    c0105a05 <memcmp+0x14>
    }
    return 0;
c0105a42:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105a47:	c9                   	leave  
c0105a48:	c3                   	ret    

c0105a49 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c0105a49:	55                   	push   %ebp
c0105a4a:	89 e5                	mov    %esp,%ebp
c0105a4c:	83 ec 58             	sub    $0x58,%esp
c0105a4f:	8b 45 10             	mov    0x10(%ebp),%eax
c0105a52:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0105a55:	8b 45 14             	mov    0x14(%ebp),%eax
c0105a58:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c0105a5b:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105a5e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105a61:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105a64:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c0105a67:	8b 45 18             	mov    0x18(%ebp),%eax
c0105a6a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105a6d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105a70:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105a73:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105a76:	89 55 f0             	mov    %edx,-0x10(%ebp)
c0105a79:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a7c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105a7f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105a83:	74 1c                	je     c0105aa1 <printnum+0x58>
c0105a85:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a88:	ba 00 00 00 00       	mov    $0x0,%edx
c0105a8d:	f7 75 e4             	divl   -0x1c(%ebp)
c0105a90:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0105a93:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a96:	ba 00 00 00 00       	mov    $0x0,%edx
c0105a9b:	f7 75 e4             	divl   -0x1c(%ebp)
c0105a9e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105aa1:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105aa4:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105aa7:	f7 75 e4             	divl   -0x1c(%ebp)
c0105aaa:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105aad:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0105ab0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105ab3:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105ab6:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105ab9:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0105abc:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105abf:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c0105ac2:	8b 45 18             	mov    0x18(%ebp),%eax
c0105ac5:	ba 00 00 00 00       	mov    $0x0,%edx
c0105aca:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0105acd:	77 56                	ja     c0105b25 <printnum+0xdc>
c0105acf:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0105ad2:	72 05                	jb     c0105ad9 <printnum+0x90>
c0105ad4:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0105ad7:	77 4c                	ja     c0105b25 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
c0105ad9:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0105adc:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105adf:	8b 45 20             	mov    0x20(%ebp),%eax
c0105ae2:	89 44 24 18          	mov    %eax,0x18(%esp)
c0105ae6:	89 54 24 14          	mov    %edx,0x14(%esp)
c0105aea:	8b 45 18             	mov    0x18(%ebp),%eax
c0105aed:	89 44 24 10          	mov    %eax,0x10(%esp)
c0105af1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105af4:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105af7:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105afb:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105aff:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b02:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105b06:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b09:	89 04 24             	mov    %eax,(%esp)
c0105b0c:	e8 38 ff ff ff       	call   c0105a49 <printnum>
c0105b11:	eb 1c                	jmp    c0105b2f <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c0105b13:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b16:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105b1a:	8b 45 20             	mov    0x20(%ebp),%eax
c0105b1d:	89 04 24             	mov    %eax,(%esp)
c0105b20:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b23:	ff d0                	call   *%eax
        while (-- width > 0)
c0105b25:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c0105b29:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0105b2d:	7f e4                	jg     c0105b13 <printnum+0xca>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c0105b2f:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105b32:	05 a4 72 10 c0       	add    $0xc01072a4,%eax
c0105b37:	0f b6 00             	movzbl (%eax),%eax
c0105b3a:	0f be c0             	movsbl %al,%eax
c0105b3d:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105b40:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105b44:	89 04 24             	mov    %eax,(%esp)
c0105b47:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b4a:	ff d0                	call   *%eax
}
c0105b4c:	c9                   	leave  
c0105b4d:	c3                   	ret    

c0105b4e <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c0105b4e:	55                   	push   %ebp
c0105b4f:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0105b51:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0105b55:	7e 14                	jle    c0105b6b <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c0105b57:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b5a:	8b 00                	mov    (%eax),%eax
c0105b5c:	8d 48 08             	lea    0x8(%eax),%ecx
c0105b5f:	8b 55 08             	mov    0x8(%ebp),%edx
c0105b62:	89 0a                	mov    %ecx,(%edx)
c0105b64:	8b 50 04             	mov    0x4(%eax),%edx
c0105b67:	8b 00                	mov    (%eax),%eax
c0105b69:	eb 30                	jmp    c0105b9b <getuint+0x4d>
    }
    else if (lflag) {
c0105b6b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105b6f:	74 16                	je     c0105b87 <getuint+0x39>
        return va_arg(*ap, unsigned long);
c0105b71:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b74:	8b 00                	mov    (%eax),%eax
c0105b76:	8d 48 04             	lea    0x4(%eax),%ecx
c0105b79:	8b 55 08             	mov    0x8(%ebp),%edx
c0105b7c:	89 0a                	mov    %ecx,(%edx)
c0105b7e:	8b 00                	mov    (%eax),%eax
c0105b80:	ba 00 00 00 00       	mov    $0x0,%edx
c0105b85:	eb 14                	jmp    c0105b9b <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c0105b87:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b8a:	8b 00                	mov    (%eax),%eax
c0105b8c:	8d 48 04             	lea    0x4(%eax),%ecx
c0105b8f:	8b 55 08             	mov    0x8(%ebp),%edx
c0105b92:	89 0a                	mov    %ecx,(%edx)
c0105b94:	8b 00                	mov    (%eax),%eax
c0105b96:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c0105b9b:	5d                   	pop    %ebp
c0105b9c:	c3                   	ret    

c0105b9d <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c0105b9d:	55                   	push   %ebp
c0105b9e:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0105ba0:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0105ba4:	7e 14                	jle    c0105bba <getint+0x1d>
        return va_arg(*ap, long long);
c0105ba6:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ba9:	8b 00                	mov    (%eax),%eax
c0105bab:	8d 48 08             	lea    0x8(%eax),%ecx
c0105bae:	8b 55 08             	mov    0x8(%ebp),%edx
c0105bb1:	89 0a                	mov    %ecx,(%edx)
c0105bb3:	8b 50 04             	mov    0x4(%eax),%edx
c0105bb6:	8b 00                	mov    (%eax),%eax
c0105bb8:	eb 28                	jmp    c0105be2 <getint+0x45>
    }
    else if (lflag) {
c0105bba:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105bbe:	74 12                	je     c0105bd2 <getint+0x35>
        return va_arg(*ap, long);
c0105bc0:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bc3:	8b 00                	mov    (%eax),%eax
c0105bc5:	8d 48 04             	lea    0x4(%eax),%ecx
c0105bc8:	8b 55 08             	mov    0x8(%ebp),%edx
c0105bcb:	89 0a                	mov    %ecx,(%edx)
c0105bcd:	8b 00                	mov    (%eax),%eax
c0105bcf:	99                   	cltd   
c0105bd0:	eb 10                	jmp    c0105be2 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c0105bd2:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bd5:	8b 00                	mov    (%eax),%eax
c0105bd7:	8d 48 04             	lea    0x4(%eax),%ecx
c0105bda:	8b 55 08             	mov    0x8(%ebp),%edx
c0105bdd:	89 0a                	mov    %ecx,(%edx)
c0105bdf:	8b 00                	mov    (%eax),%eax
c0105be1:	99                   	cltd   
    }
}
c0105be2:	5d                   	pop    %ebp
c0105be3:	c3                   	ret    

c0105be4 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c0105be4:	55                   	push   %ebp
c0105be5:	89 e5                	mov    %esp,%ebp
c0105be7:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c0105bea:	8d 45 14             	lea    0x14(%ebp),%eax
c0105bed:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c0105bf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105bf3:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105bf7:	8b 45 10             	mov    0x10(%ebp),%eax
c0105bfa:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105bfe:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c01:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105c05:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c08:	89 04 24             	mov    %eax,(%esp)
c0105c0b:	e8 02 00 00 00       	call   c0105c12 <vprintfmt>
    va_end(ap);
}
c0105c10:	c9                   	leave  
c0105c11:	c3                   	ret    

c0105c12 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c0105c12:	55                   	push   %ebp
c0105c13:	89 e5                	mov    %esp,%ebp
c0105c15:	56                   	push   %esi
c0105c16:	53                   	push   %ebx
c0105c17:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0105c1a:	eb 18                	jmp    c0105c34 <vprintfmt+0x22>
            if (ch == '\0') {
c0105c1c:	85 db                	test   %ebx,%ebx
c0105c1e:	75 05                	jne    c0105c25 <vprintfmt+0x13>
                return;
c0105c20:	e9 d1 03 00 00       	jmp    c0105ff6 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
c0105c25:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c28:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105c2c:	89 1c 24             	mov    %ebx,(%esp)
c0105c2f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c32:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0105c34:	8b 45 10             	mov    0x10(%ebp),%eax
c0105c37:	8d 50 01             	lea    0x1(%eax),%edx
c0105c3a:	89 55 10             	mov    %edx,0x10(%ebp)
c0105c3d:	0f b6 00             	movzbl (%eax),%eax
c0105c40:	0f b6 d8             	movzbl %al,%ebx
c0105c43:	83 fb 25             	cmp    $0x25,%ebx
c0105c46:	75 d4                	jne    c0105c1c <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
c0105c48:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c0105c4c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c0105c53:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105c56:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c0105c59:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0105c60:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105c63:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c0105c66:	8b 45 10             	mov    0x10(%ebp),%eax
c0105c69:	8d 50 01             	lea    0x1(%eax),%edx
c0105c6c:	89 55 10             	mov    %edx,0x10(%ebp)
c0105c6f:	0f b6 00             	movzbl (%eax),%eax
c0105c72:	0f b6 d8             	movzbl %al,%ebx
c0105c75:	8d 43 dd             	lea    -0x23(%ebx),%eax
c0105c78:	83 f8 55             	cmp    $0x55,%eax
c0105c7b:	0f 87 44 03 00 00    	ja     c0105fc5 <vprintfmt+0x3b3>
c0105c81:	8b 04 85 c8 72 10 c0 	mov    -0x3fef8d38(,%eax,4),%eax
c0105c88:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c0105c8a:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c0105c8e:	eb d6                	jmp    c0105c66 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c0105c90:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c0105c94:	eb d0                	jmp    c0105c66 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0105c96:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c0105c9d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105ca0:	89 d0                	mov    %edx,%eax
c0105ca2:	c1 e0 02             	shl    $0x2,%eax
c0105ca5:	01 d0                	add    %edx,%eax
c0105ca7:	01 c0                	add    %eax,%eax
c0105ca9:	01 d8                	add    %ebx,%eax
c0105cab:	83 e8 30             	sub    $0x30,%eax
c0105cae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c0105cb1:	8b 45 10             	mov    0x10(%ebp),%eax
c0105cb4:	0f b6 00             	movzbl (%eax),%eax
c0105cb7:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c0105cba:	83 fb 2f             	cmp    $0x2f,%ebx
c0105cbd:	7e 0b                	jle    c0105cca <vprintfmt+0xb8>
c0105cbf:	83 fb 39             	cmp    $0x39,%ebx
c0105cc2:	7f 06                	jg     c0105cca <vprintfmt+0xb8>
            for (precision = 0; ; ++ fmt) {
c0105cc4:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                    break;
                }
            }
c0105cc8:	eb d3                	jmp    c0105c9d <vprintfmt+0x8b>
            goto process_precision;
c0105cca:	eb 33                	jmp    c0105cff <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
c0105ccc:	8b 45 14             	mov    0x14(%ebp),%eax
c0105ccf:	8d 50 04             	lea    0x4(%eax),%edx
c0105cd2:	89 55 14             	mov    %edx,0x14(%ebp)
c0105cd5:	8b 00                	mov    (%eax),%eax
c0105cd7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c0105cda:	eb 23                	jmp    c0105cff <vprintfmt+0xed>

        case '.':
            if (width < 0)
c0105cdc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105ce0:	79 0c                	jns    c0105cee <vprintfmt+0xdc>
                width = 0;
c0105ce2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c0105ce9:	e9 78 ff ff ff       	jmp    c0105c66 <vprintfmt+0x54>
c0105cee:	e9 73 ff ff ff       	jmp    c0105c66 <vprintfmt+0x54>

        case '#':
            altflag = 1;
c0105cf3:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c0105cfa:	e9 67 ff ff ff       	jmp    c0105c66 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
c0105cff:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105d03:	79 12                	jns    c0105d17 <vprintfmt+0x105>
                width = precision, precision = -1;
c0105d05:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105d08:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105d0b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c0105d12:	e9 4f ff ff ff       	jmp    c0105c66 <vprintfmt+0x54>
c0105d17:	e9 4a ff ff ff       	jmp    c0105c66 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c0105d1c:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c0105d20:	e9 41 ff ff ff       	jmp    c0105c66 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c0105d25:	8b 45 14             	mov    0x14(%ebp),%eax
c0105d28:	8d 50 04             	lea    0x4(%eax),%edx
c0105d2b:	89 55 14             	mov    %edx,0x14(%ebp)
c0105d2e:	8b 00                	mov    (%eax),%eax
c0105d30:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105d33:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105d37:	89 04 24             	mov    %eax,(%esp)
c0105d3a:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d3d:	ff d0                	call   *%eax
            break;
c0105d3f:	e9 ac 02 00 00       	jmp    c0105ff0 <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
c0105d44:	8b 45 14             	mov    0x14(%ebp),%eax
c0105d47:	8d 50 04             	lea    0x4(%eax),%edx
c0105d4a:	89 55 14             	mov    %edx,0x14(%ebp)
c0105d4d:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c0105d4f:	85 db                	test   %ebx,%ebx
c0105d51:	79 02                	jns    c0105d55 <vprintfmt+0x143>
                err = -err;
c0105d53:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c0105d55:	83 fb 06             	cmp    $0x6,%ebx
c0105d58:	7f 0b                	jg     c0105d65 <vprintfmt+0x153>
c0105d5a:	8b 34 9d 88 72 10 c0 	mov    -0x3fef8d78(,%ebx,4),%esi
c0105d61:	85 f6                	test   %esi,%esi
c0105d63:	75 23                	jne    c0105d88 <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
c0105d65:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105d69:	c7 44 24 08 b5 72 10 	movl   $0xc01072b5,0x8(%esp)
c0105d70:	c0 
c0105d71:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d74:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105d78:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d7b:	89 04 24             	mov    %eax,(%esp)
c0105d7e:	e8 61 fe ff ff       	call   c0105be4 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c0105d83:	e9 68 02 00 00       	jmp    c0105ff0 <vprintfmt+0x3de>
                printfmt(putch, putdat, "%s", p);
c0105d88:	89 74 24 0c          	mov    %esi,0xc(%esp)
c0105d8c:	c7 44 24 08 be 72 10 	movl   $0xc01072be,0x8(%esp)
c0105d93:	c0 
c0105d94:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d97:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105d9b:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d9e:	89 04 24             	mov    %eax,(%esp)
c0105da1:	e8 3e fe ff ff       	call   c0105be4 <printfmt>
            break;
c0105da6:	e9 45 02 00 00       	jmp    c0105ff0 <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c0105dab:	8b 45 14             	mov    0x14(%ebp),%eax
c0105dae:	8d 50 04             	lea    0x4(%eax),%edx
c0105db1:	89 55 14             	mov    %edx,0x14(%ebp)
c0105db4:	8b 30                	mov    (%eax),%esi
c0105db6:	85 f6                	test   %esi,%esi
c0105db8:	75 05                	jne    c0105dbf <vprintfmt+0x1ad>
                p = "(null)";
c0105dba:	be c1 72 10 c0       	mov    $0xc01072c1,%esi
            }
            if (width > 0 && padc != '-') {
c0105dbf:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105dc3:	7e 3e                	jle    c0105e03 <vprintfmt+0x1f1>
c0105dc5:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c0105dc9:	74 38                	je     c0105e03 <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
c0105dcb:	8b 5d e8             	mov    -0x18(%ebp),%ebx
c0105dce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105dd1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105dd5:	89 34 24             	mov    %esi,(%esp)
c0105dd8:	e8 dc f7 ff ff       	call   c01055b9 <strnlen>
c0105ddd:	29 c3                	sub    %eax,%ebx
c0105ddf:	89 d8                	mov    %ebx,%eax
c0105de1:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105de4:	eb 17                	jmp    c0105dfd <vprintfmt+0x1eb>
                    putch(padc, putdat);
c0105de6:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c0105dea:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105ded:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105df1:	89 04 24             	mov    %eax,(%esp)
c0105df4:	8b 45 08             	mov    0x8(%ebp),%eax
c0105df7:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
c0105df9:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0105dfd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105e01:	7f e3                	jg     c0105de6 <vprintfmt+0x1d4>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0105e03:	eb 38                	jmp    c0105e3d <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
c0105e05:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0105e09:	74 1f                	je     c0105e2a <vprintfmt+0x218>
c0105e0b:	83 fb 1f             	cmp    $0x1f,%ebx
c0105e0e:	7e 05                	jle    c0105e15 <vprintfmt+0x203>
c0105e10:	83 fb 7e             	cmp    $0x7e,%ebx
c0105e13:	7e 15                	jle    c0105e2a <vprintfmt+0x218>
                    putch('?', putdat);
c0105e15:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e18:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105e1c:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c0105e23:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e26:	ff d0                	call   *%eax
c0105e28:	eb 0f                	jmp    c0105e39 <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
c0105e2a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e2d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105e31:	89 1c 24             	mov    %ebx,(%esp)
c0105e34:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e37:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0105e39:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0105e3d:	89 f0                	mov    %esi,%eax
c0105e3f:	8d 70 01             	lea    0x1(%eax),%esi
c0105e42:	0f b6 00             	movzbl (%eax),%eax
c0105e45:	0f be d8             	movsbl %al,%ebx
c0105e48:	85 db                	test   %ebx,%ebx
c0105e4a:	74 10                	je     c0105e5c <vprintfmt+0x24a>
c0105e4c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105e50:	78 b3                	js     c0105e05 <vprintfmt+0x1f3>
c0105e52:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c0105e56:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105e5a:	79 a9                	jns    c0105e05 <vprintfmt+0x1f3>
                }
            }
            for (; width > 0; width --) {
c0105e5c:	eb 17                	jmp    c0105e75 <vprintfmt+0x263>
                putch(' ', putdat);
c0105e5e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e61:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105e65:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0105e6c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e6f:	ff d0                	call   *%eax
            for (; width > 0; width --) {
c0105e71:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0105e75:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105e79:	7f e3                	jg     c0105e5e <vprintfmt+0x24c>
            }
            break;
c0105e7b:	e9 70 01 00 00       	jmp    c0105ff0 <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c0105e80:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105e83:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105e87:	8d 45 14             	lea    0x14(%ebp),%eax
c0105e8a:	89 04 24             	mov    %eax,(%esp)
c0105e8d:	e8 0b fd ff ff       	call   c0105b9d <getint>
c0105e92:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105e95:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c0105e98:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105e9b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105e9e:	85 d2                	test   %edx,%edx
c0105ea0:	79 26                	jns    c0105ec8 <vprintfmt+0x2b6>
                putch('-', putdat);
c0105ea2:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ea5:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105ea9:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c0105eb0:	8b 45 08             	mov    0x8(%ebp),%eax
c0105eb3:	ff d0                	call   *%eax
                num = -(long long)num;
c0105eb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105eb8:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105ebb:	f7 d8                	neg    %eax
c0105ebd:	83 d2 00             	adc    $0x0,%edx
c0105ec0:	f7 da                	neg    %edx
c0105ec2:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105ec5:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c0105ec8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0105ecf:	e9 a8 00 00 00       	jmp    c0105f7c <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c0105ed4:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105ed7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105edb:	8d 45 14             	lea    0x14(%ebp),%eax
c0105ede:	89 04 24             	mov    %eax,(%esp)
c0105ee1:	e8 68 fc ff ff       	call   c0105b4e <getuint>
c0105ee6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105ee9:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c0105eec:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0105ef3:	e9 84 00 00 00       	jmp    c0105f7c <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c0105ef8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105efb:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105eff:	8d 45 14             	lea    0x14(%ebp),%eax
c0105f02:	89 04 24             	mov    %eax,(%esp)
c0105f05:	e8 44 fc ff ff       	call   c0105b4e <getuint>
c0105f0a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105f0d:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c0105f10:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c0105f17:	eb 63                	jmp    c0105f7c <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
c0105f19:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105f1c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105f20:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c0105f27:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f2a:	ff d0                	call   *%eax
            putch('x', putdat);
c0105f2c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105f2f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105f33:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c0105f3a:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f3d:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c0105f3f:	8b 45 14             	mov    0x14(%ebp),%eax
c0105f42:	8d 50 04             	lea    0x4(%eax),%edx
c0105f45:	89 55 14             	mov    %edx,0x14(%ebp)
c0105f48:	8b 00                	mov    (%eax),%eax
c0105f4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105f4d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c0105f54:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c0105f5b:	eb 1f                	jmp    c0105f7c <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c0105f5d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105f60:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105f64:	8d 45 14             	lea    0x14(%ebp),%eax
c0105f67:	89 04 24             	mov    %eax,(%esp)
c0105f6a:	e8 df fb ff ff       	call   c0105b4e <getuint>
c0105f6f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105f72:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c0105f75:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c0105f7c:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c0105f80:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105f83:	89 54 24 18          	mov    %edx,0x18(%esp)
c0105f87:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0105f8a:	89 54 24 14          	mov    %edx,0x14(%esp)
c0105f8e:	89 44 24 10          	mov    %eax,0x10(%esp)
c0105f92:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105f95:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105f98:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105f9c:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105fa0:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105fa3:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105fa7:	8b 45 08             	mov    0x8(%ebp),%eax
c0105faa:	89 04 24             	mov    %eax,(%esp)
c0105fad:	e8 97 fa ff ff       	call   c0105a49 <printnum>
            break;
c0105fb2:	eb 3c                	jmp    c0105ff0 <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c0105fb4:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105fb7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105fbb:	89 1c 24             	mov    %ebx,(%esp)
c0105fbe:	8b 45 08             	mov    0x8(%ebp),%eax
c0105fc1:	ff d0                	call   *%eax
            break;
c0105fc3:	eb 2b                	jmp    c0105ff0 <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c0105fc5:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105fc8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105fcc:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c0105fd3:	8b 45 08             	mov    0x8(%ebp),%eax
c0105fd6:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c0105fd8:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105fdc:	eb 04                	jmp    c0105fe2 <vprintfmt+0x3d0>
c0105fde:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105fe2:	8b 45 10             	mov    0x10(%ebp),%eax
c0105fe5:	83 e8 01             	sub    $0x1,%eax
c0105fe8:	0f b6 00             	movzbl (%eax),%eax
c0105feb:	3c 25                	cmp    $0x25,%al
c0105fed:	75 ef                	jne    c0105fde <vprintfmt+0x3cc>
                /* do nothing */;
            break;
c0105fef:	90                   	nop
        }
    }
c0105ff0:	90                   	nop
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0105ff1:	e9 3e fc ff ff       	jmp    c0105c34 <vprintfmt+0x22>
}
c0105ff6:	83 c4 40             	add    $0x40,%esp
c0105ff9:	5b                   	pop    %ebx
c0105ffa:	5e                   	pop    %esi
c0105ffb:	5d                   	pop    %ebp
c0105ffc:	c3                   	ret    

c0105ffd <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c0105ffd:	55                   	push   %ebp
c0105ffe:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c0106000:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106003:	8b 40 08             	mov    0x8(%eax),%eax
c0106006:	8d 50 01             	lea    0x1(%eax),%edx
c0106009:	8b 45 0c             	mov    0xc(%ebp),%eax
c010600c:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c010600f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106012:	8b 10                	mov    (%eax),%edx
c0106014:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106017:	8b 40 04             	mov    0x4(%eax),%eax
c010601a:	39 c2                	cmp    %eax,%edx
c010601c:	73 12                	jae    c0106030 <sprintputch+0x33>
        *b->buf ++ = ch;
c010601e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106021:	8b 00                	mov    (%eax),%eax
c0106023:	8d 48 01             	lea    0x1(%eax),%ecx
c0106026:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106029:	89 0a                	mov    %ecx,(%edx)
c010602b:	8b 55 08             	mov    0x8(%ebp),%edx
c010602e:	88 10                	mov    %dl,(%eax)
    }
}
c0106030:	5d                   	pop    %ebp
c0106031:	c3                   	ret    

c0106032 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c0106032:	55                   	push   %ebp
c0106033:	89 e5                	mov    %esp,%ebp
c0106035:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0106038:	8d 45 14             	lea    0x14(%ebp),%eax
c010603b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c010603e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106041:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0106045:	8b 45 10             	mov    0x10(%ebp),%eax
c0106048:	89 44 24 08          	mov    %eax,0x8(%esp)
c010604c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010604f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106053:	8b 45 08             	mov    0x8(%ebp),%eax
c0106056:	89 04 24             	mov    %eax,(%esp)
c0106059:	e8 08 00 00 00       	call   c0106066 <vsnprintf>
c010605e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0106061:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0106064:	c9                   	leave  
c0106065:	c3                   	ret    

c0106066 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c0106066:	55                   	push   %ebp
c0106067:	89 e5                	mov    %esp,%ebp
c0106069:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c010606c:	8b 45 08             	mov    0x8(%ebp),%eax
c010606f:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0106072:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106075:	8d 50 ff             	lea    -0x1(%eax),%edx
c0106078:	8b 45 08             	mov    0x8(%ebp),%eax
c010607b:	01 d0                	add    %edx,%eax
c010607d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106080:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c0106087:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010608b:	74 0a                	je     c0106097 <vsnprintf+0x31>
c010608d:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106090:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106093:	39 c2                	cmp    %eax,%edx
c0106095:	76 07                	jbe    c010609e <vsnprintf+0x38>
        return -E_INVAL;
c0106097:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c010609c:	eb 2a                	jmp    c01060c8 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c010609e:	8b 45 14             	mov    0x14(%ebp),%eax
c01060a1:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01060a5:	8b 45 10             	mov    0x10(%ebp),%eax
c01060a8:	89 44 24 08          	mov    %eax,0x8(%esp)
c01060ac:	8d 45 ec             	lea    -0x14(%ebp),%eax
c01060af:	89 44 24 04          	mov    %eax,0x4(%esp)
c01060b3:	c7 04 24 fd 5f 10 c0 	movl   $0xc0105ffd,(%esp)
c01060ba:	e8 53 fb ff ff       	call   c0105c12 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c01060bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01060c2:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c01060c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01060c8:	c9                   	leave  
c01060c9:	c3                   	ret    
