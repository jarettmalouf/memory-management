
obj/p-test.full:     file format elf64-x86-64


Disassembly of section .text:

0000000000100000 <process_main>:
uint8_t* heap_top;
uint8_t* stack_bottom;



void process_main(void) {
  100000:	55                   	push   %rbp
  100001:	48 89 e5             	mov    %rsp,%rbp

// getpid
//    Return current process ID.
static inline pid_t getpid(void) {
    pid_t result;
    asm volatile ("int %1" : "=a" (result)
  100004:	cd 31                	int    $0x31
  100006:	89 c7                	mov    %eax,%edi
    pid_t p = getpid();
    srand(p);
  100008:	e8 1b 03 00 00       	callq  100328 <srand>
    heap_top = ROUNDUP((uint8_t*) end, PAGESIZE);
  10000d:	b8 1f 20 10 00       	mov    $0x10201f,%eax
  100012:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  100018:	48 89 05 e9 0f 00 00 	mov    %rax,0xfe9(%rip)        # 101008 <heap_top>
    return rbp;
}

static inline uintptr_t read_rsp(void) {
    uintptr_t rsp;
    asm volatile("movq %%rsp,%0" : "=r" (rsp));
  10001f:	48 89 e0             	mov    %rsp,%rax
    stack_bottom = ROUNDDOWN((uint8_t*) read_rsp() - 1, PAGESIZE);
  100022:	48 83 e8 01          	sub    $0x1,%rax
  100026:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  10002c:	48 89 05 cd 0f 00 00 	mov    %rax,0xfcd(%rip)        # 101000 <stack_bottom>
//     On success, sbrk() returns the previous program break
//     (If the break was increased, then this value is a pointer to the start of the newly allocated memory)
//      On error, (void *) -1 is returned
static inline void * sbrk(const intptr_t increment) {
    static void * result;
    asm volatile ("int %1" :  "=a" (result)
  100033:	bf 00 00 00 00       	mov    $0x0,%edi
  100038:	cd 3a                	int    $0x3a
  10003a:	48 89 05 cf 0f 00 00 	mov    %rax,0xfcf(%rip)        # 101010 <result.0>

    intptr_t break1, break2;

    //Sanity
    break1 = (intptr_t)sbrk(0);
    assert(break1 == (intptr_t)heap_top);
  100041:	48 39 05 c0 0f 00 00 	cmp    %rax,0xfc0(%rip)        # 101008 <heap_top>
  100048:	75 7a                	jne    1000c4 <process_main+0xc4>
  10004a:	48 89 c2             	mov    %rax,%rdx
  10004d:	bf 0a 00 00 00       	mov    $0xa,%edi
  100052:	cd 3a                	int    $0x3a
  100054:	48 89 c1             	mov    %rax,%rcx
  100057:	48 89 05 b2 0f 00 00 	mov    %rax,0xfb2(%rip)        # 101010 <result.0>
    break2 = break1;

    //Increase, returns previous break
    break1 = (intptr_t)sbrk(10);
    assert(break1 == break2);
  10005e:	48 39 c2             	cmp    %rax,%rdx
  100061:	75 75                	jne    1000d8 <process_main+0xd8>
  100063:	bf 0b 00 00 00       	mov    $0xb,%edi
  100068:	cd 3a                	int    $0x3a
  10006a:	48 89 c2             	mov    %rax,%rdx
  10006d:	48 89 05 9c 0f 00 00 	mov    %rax,0xf9c(%rip)        # 101010 <result.0>
    break2 = break1;

    //Inrease again, returns previously increased break
    break1 = (intptr_t)sbrk(11);
    assert(break1 == break2 + 10);
  100074:	48 83 c1 0a          	add    $0xa,%rcx
  100078:	48 39 c1             	cmp    %rax,%rcx
  10007b:	75 6f                	jne    1000ec <process_main+0xec>
  10007d:	48 c7 c7 fb ff ff ff 	mov    $0xfffffffffffffffb,%rdi
  100084:	cd 3a                	int    $0x3a
  100086:	48 89 c1             	mov    %rax,%rcx
  100089:	48 89 05 80 0f 00 00 	mov    %rax,0xf80(%rip)        # 101010 <result.0>
    break2 = break1;

    //Decrease, returns twice increased break
    break1 = (intptr_t)sbrk(-5);
    assert(break1 == break2 + 11);
  100090:	48 83 c2 0b          	add    $0xb,%rdx
  100094:	48 39 c2             	cmp    %rax,%rdx
  100097:	75 67                	jne    100100 <process_main+0x100>
  100099:	bf 00 00 00 00       	mov    $0x0,%edi
  10009e:	cd 3a                	int    $0x3a
  1000a0:	48 89 05 69 0f 00 00 	mov    %rax,0xf69(%rip)        # 101010 <result.0>
    break2 = break1;

    //Check safe decrease
    break1 = (intptr_t)sbrk(0);
    assert(break1 == break2 - 5);
  1000a7:	48 83 e9 05          	sub    $0x5,%rcx
  1000ab:	48 39 c8             	cmp    %rcx,%rax
  1000ae:	74 64                	je     100114 <process_main+0x114>
  1000b0:	ba 33 0d 10 00       	mov    $0x100d33,%edx
  1000b5:	be 2f 00 00 00       	mov    $0x2f,%esi
  1000ba:	bf ed 0c 10 00       	mov    $0x100ced,%edi
  1000bf:	e8 ce 0b 00 00       	callq  100c92 <assert_fail>
    assert(break1 == (intptr_t)heap_top);
  1000c4:	ba d0 0c 10 00       	mov    $0x100cd0,%edx
  1000c9:	be 1b 00 00 00       	mov    $0x1b,%esi
  1000ce:	bf ed 0c 10 00       	mov    $0x100ced,%edi
  1000d3:	e8 ba 0b 00 00       	callq  100c92 <assert_fail>
    assert(break1 == break2);
  1000d8:	ba f6 0c 10 00       	mov    $0x100cf6,%edx
  1000dd:	be 20 00 00 00       	mov    $0x20,%esi
  1000e2:	bf ed 0c 10 00       	mov    $0x100ced,%edi
  1000e7:	e8 a6 0b 00 00       	callq  100c92 <assert_fail>
    assert(break1 == break2 + 10);
  1000ec:	ba 07 0d 10 00       	mov    $0x100d07,%edx
  1000f1:	be 25 00 00 00       	mov    $0x25,%esi
  1000f6:	bf ed 0c 10 00       	mov    $0x100ced,%edi
  1000fb:	e8 92 0b 00 00       	callq  100c92 <assert_fail>
    assert(break1 == break2 + 11);
  100100:	ba 1d 0d 10 00       	mov    $0x100d1d,%edx
  100105:	be 2a 00 00 00       	mov    $0x2a,%esi
  10010a:	bf ed 0c 10 00       	mov    $0x100ced,%edi
  10010f:	e8 7e 0b 00 00       	callq  100c92 <assert_fail>
    break2 = break1;

    TEST_PASS();
  100114:	bf 48 0d 10 00       	mov    $0x100d48,%edi
  100119:	b8 00 00 00 00       	mov    $0x0,%eax
  10011e:	e8 a1 0a 00 00       	callq  100bc4 <kernel_panic>

0000000000100123 <console_putc>:
typedef struct console_printer {
    printer p;
    uint16_t* cursor;
} console_printer;

static void console_putc(printer* p, unsigned char c, int color) {
  100123:	48 89 f9             	mov    %rdi,%rcx
  100126:	89 d7                	mov    %edx,%edi
    console_printer* cp = (console_printer*) p;
    if (cp->cursor >= console + CONSOLE_ROWS * CONSOLE_COLUMNS) {
  100128:	48 81 79 08 a0 8f 0b 	cmpq   $0xb8fa0,0x8(%rcx)
  10012f:	00 
  100130:	72 08                	jb     10013a <console_putc+0x17>
        cp->cursor = console;
  100132:	48 c7 41 08 00 80 0b 	movq   $0xb8000,0x8(%rcx)
  100139:	00 
    }
    if (c == '\n') {
  10013a:	40 80 fe 0a          	cmp    $0xa,%sil
  10013e:	74 16                	je     100156 <console_putc+0x33>
        int pos = (cp->cursor - console) % 80;
        for (; pos != 80; pos++) {
            *cp->cursor++ = ' ' | color;
        }
    } else {
        *cp->cursor++ = c | color;
  100140:	48 8b 41 08          	mov    0x8(%rcx),%rax
  100144:	48 8d 50 02          	lea    0x2(%rax),%rdx
  100148:	48 89 51 08          	mov    %rdx,0x8(%rcx)
  10014c:	40 0f b6 f6          	movzbl %sil,%esi
  100150:	09 fe                	or     %edi,%esi
  100152:	66 89 30             	mov    %si,(%rax)
    }
}
  100155:	c3                   	retq   
        int pos = (cp->cursor - console) % 80;
  100156:	4c 8b 41 08          	mov    0x8(%rcx),%r8
  10015a:	49 81 e8 00 80 0b 00 	sub    $0xb8000,%r8
  100161:	4c 89 c6             	mov    %r8,%rsi
  100164:	48 d1 fe             	sar    %rsi
  100167:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
  10016e:	66 66 66 
  100171:	48 89 f0             	mov    %rsi,%rax
  100174:	48 f7 ea             	imul   %rdx
  100177:	48 c1 fa 05          	sar    $0x5,%rdx
  10017b:	49 c1 f8 3f          	sar    $0x3f,%r8
  10017f:	4c 29 c2             	sub    %r8,%rdx
  100182:	48 8d 14 92          	lea    (%rdx,%rdx,4),%rdx
  100186:	48 c1 e2 04          	shl    $0x4,%rdx
  10018a:	89 f0                	mov    %esi,%eax
  10018c:	29 d0                	sub    %edx,%eax
            *cp->cursor++ = ' ' | color;
  10018e:	83 cf 20             	or     $0x20,%edi
  100191:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  100195:	48 8d 72 02          	lea    0x2(%rdx),%rsi
  100199:	48 89 71 08          	mov    %rsi,0x8(%rcx)
  10019d:	66 89 3a             	mov    %di,(%rdx)
        for (; pos != 80; pos++) {
  1001a0:	83 c0 01             	add    $0x1,%eax
  1001a3:	83 f8 50             	cmp    $0x50,%eax
  1001a6:	75 e9                	jne    100191 <console_putc+0x6e>
  1001a8:	c3                   	retq   

00000000001001a9 <string_putc>:
    char* end;
} string_printer;

static void string_putc(printer* p, unsigned char c, int color) {
    string_printer* sp = (string_printer*) p;
    if (sp->s < sp->end) {
  1001a9:	48 8b 47 08          	mov    0x8(%rdi),%rax
  1001ad:	48 3b 47 10          	cmp    0x10(%rdi),%rax
  1001b1:	73 0b                	jae    1001be <string_putc+0x15>
        *sp->s++ = c;
  1001b3:	48 8d 50 01          	lea    0x1(%rax),%rdx
  1001b7:	48 89 57 08          	mov    %rdx,0x8(%rdi)
  1001bb:	40 88 30             	mov    %sil,(%rax)
    }
    (void) color;
}
  1001be:	c3                   	retq   

00000000001001bf <memcpy>:
void* memcpy(void* dst, const void* src, size_t n) {
  1001bf:	48 89 f8             	mov    %rdi,%rax
    for (char* d = (char*) dst; n > 0; --n, ++s, ++d) {
  1001c2:	48 85 d2             	test   %rdx,%rdx
  1001c5:	74 17                	je     1001de <memcpy+0x1f>
  1001c7:	b9 00 00 00 00       	mov    $0x0,%ecx
        *d = *s;
  1001cc:	44 0f b6 04 0e       	movzbl (%rsi,%rcx,1),%r8d
  1001d1:	44 88 04 08          	mov    %r8b,(%rax,%rcx,1)
    for (char* d = (char*) dst; n > 0; --n, ++s, ++d) {
  1001d5:	48 83 c1 01          	add    $0x1,%rcx
  1001d9:	48 39 d1             	cmp    %rdx,%rcx
  1001dc:	75 ee                	jne    1001cc <memcpy+0xd>
}
  1001de:	c3                   	retq   

00000000001001df <memmove>:
void* memmove(void* dst, const void* src, size_t n) {
  1001df:	48 89 f8             	mov    %rdi,%rax
    if (s < d && s + n > d) {
  1001e2:	48 39 fe             	cmp    %rdi,%rsi
  1001e5:	72 1d                	jb     100204 <memmove+0x25>
        while (n-- > 0) {
  1001e7:	b9 00 00 00 00       	mov    $0x0,%ecx
  1001ec:	48 85 d2             	test   %rdx,%rdx
  1001ef:	74 12                	je     100203 <memmove+0x24>
            *d++ = *s++;
  1001f1:	0f b6 3c 0e          	movzbl (%rsi,%rcx,1),%edi
  1001f5:	40 88 3c 08          	mov    %dil,(%rax,%rcx,1)
        while (n-- > 0) {
  1001f9:	48 83 c1 01          	add    $0x1,%rcx
  1001fd:	48 39 ca             	cmp    %rcx,%rdx
  100200:	75 ef                	jne    1001f1 <memmove+0x12>
}
  100202:	c3                   	retq   
  100203:	c3                   	retq   
    if (s < d && s + n > d) {
  100204:	48 8d 0c 16          	lea    (%rsi,%rdx,1),%rcx
  100208:	48 39 cf             	cmp    %rcx,%rdi
  10020b:	73 da                	jae    1001e7 <memmove+0x8>
        while (n-- > 0) {
  10020d:	48 8d 4a ff          	lea    -0x1(%rdx),%rcx
  100211:	48 85 d2             	test   %rdx,%rdx
  100214:	74 ec                	je     100202 <memmove+0x23>
            *--d = *--s;
  100216:	0f b6 14 0e          	movzbl (%rsi,%rcx,1),%edx
  10021a:	88 14 08             	mov    %dl,(%rax,%rcx,1)
        while (n-- > 0) {
  10021d:	48 83 e9 01          	sub    $0x1,%rcx
  100221:	48 83 f9 ff          	cmp    $0xffffffffffffffff,%rcx
  100225:	75 ef                	jne    100216 <memmove+0x37>
  100227:	c3                   	retq   

0000000000100228 <memset>:
void* memset(void* v, int c, size_t n) {
  100228:	48 89 f8             	mov    %rdi,%rax
    for (char* p = (char*) v; n > 0; ++p, --n) {
  10022b:	48 85 d2             	test   %rdx,%rdx
  10022e:	74 12                	je     100242 <memset+0x1a>
  100230:	48 01 fa             	add    %rdi,%rdx
  100233:	48 89 f9             	mov    %rdi,%rcx
        *p = c;
  100236:	40 88 31             	mov    %sil,(%rcx)
    for (char* p = (char*) v; n > 0; ++p, --n) {
  100239:	48 83 c1 01          	add    $0x1,%rcx
  10023d:	48 39 ca             	cmp    %rcx,%rdx
  100240:	75 f4                	jne    100236 <memset+0xe>
}
  100242:	c3                   	retq   

0000000000100243 <strlen>:
    for (n = 0; *s != '\0'; ++s) {
  100243:	80 3f 00             	cmpb   $0x0,(%rdi)
  100246:	74 10                	je     100258 <strlen+0x15>
  100248:	b8 00 00 00 00       	mov    $0x0,%eax
        ++n;
  10024d:	48 83 c0 01          	add    $0x1,%rax
    for (n = 0; *s != '\0'; ++s) {
  100251:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  100255:	75 f6                	jne    10024d <strlen+0xa>
  100257:	c3                   	retq   
  100258:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10025d:	c3                   	retq   

000000000010025e <strnlen>:
size_t strnlen(const char* s, size_t maxlen) {
  10025e:	48 89 f0             	mov    %rsi,%rax
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
  100261:	ba 00 00 00 00       	mov    $0x0,%edx
  100266:	48 85 f6             	test   %rsi,%rsi
  100269:	74 11                	je     10027c <strnlen+0x1e>
  10026b:	80 3c 17 00          	cmpb   $0x0,(%rdi,%rdx,1)
  10026f:	74 0c                	je     10027d <strnlen+0x1f>
        ++n;
  100271:	48 83 c2 01          	add    $0x1,%rdx
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
  100275:	48 39 d0             	cmp    %rdx,%rax
  100278:	75 f1                	jne    10026b <strnlen+0xd>
  10027a:	eb 04                	jmp    100280 <strnlen+0x22>
  10027c:	c3                   	retq   
  10027d:	48 89 d0             	mov    %rdx,%rax
}
  100280:	c3                   	retq   

0000000000100281 <strcpy>:
char* strcpy(char* dst, const char* src) {
  100281:	48 89 f8             	mov    %rdi,%rax
  100284:	ba 00 00 00 00       	mov    $0x0,%edx
        *d++ = *src++;
  100289:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
  10028d:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
    } while (d[-1]);
  100290:	48 83 c2 01          	add    $0x1,%rdx
  100294:	84 c9                	test   %cl,%cl
  100296:	75 f1                	jne    100289 <strcpy+0x8>
}
  100298:	c3                   	retq   

0000000000100299 <strcmp>:
    while (*a && *b && *a == *b) {
  100299:	0f b6 07             	movzbl (%rdi),%eax
  10029c:	84 c0                	test   %al,%al
  10029e:	74 1a                	je     1002ba <strcmp+0x21>
  1002a0:	0f b6 16             	movzbl (%rsi),%edx
  1002a3:	38 c2                	cmp    %al,%dl
  1002a5:	75 13                	jne    1002ba <strcmp+0x21>
  1002a7:	84 d2                	test   %dl,%dl
  1002a9:	74 0f                	je     1002ba <strcmp+0x21>
        ++a, ++b;
  1002ab:	48 83 c7 01          	add    $0x1,%rdi
  1002af:	48 83 c6 01          	add    $0x1,%rsi
    while (*a && *b && *a == *b) {
  1002b3:	0f b6 07             	movzbl (%rdi),%eax
  1002b6:	84 c0                	test   %al,%al
  1002b8:	75 e6                	jne    1002a0 <strcmp+0x7>
    return ((unsigned char) *a > (unsigned char) *b)
  1002ba:	3a 06                	cmp    (%rsi),%al
  1002bc:	0f 97 c0             	seta   %al
  1002bf:	0f b6 c0             	movzbl %al,%eax
        - ((unsigned char) *a < (unsigned char) *b);
  1002c2:	83 d8 00             	sbb    $0x0,%eax
}
  1002c5:	c3                   	retq   

00000000001002c6 <strchr>:
    while (*s && *s != (char) c) {
  1002c6:	0f b6 07             	movzbl (%rdi),%eax
  1002c9:	84 c0                	test   %al,%al
  1002cb:	74 10                	je     1002dd <strchr+0x17>
  1002cd:	40 38 f0             	cmp    %sil,%al
  1002d0:	74 18                	je     1002ea <strchr+0x24>
        ++s;
  1002d2:	48 83 c7 01          	add    $0x1,%rdi
    while (*s && *s != (char) c) {
  1002d6:	0f b6 07             	movzbl (%rdi),%eax
  1002d9:	84 c0                	test   %al,%al
  1002db:	75 f0                	jne    1002cd <strchr+0x7>
        return NULL;
  1002dd:	40 84 f6             	test   %sil,%sil
  1002e0:	b8 00 00 00 00       	mov    $0x0,%eax
  1002e5:	48 0f 44 c7          	cmove  %rdi,%rax
}
  1002e9:	c3                   	retq   
  1002ea:	48 89 f8             	mov    %rdi,%rax
  1002ed:	c3                   	retq   

00000000001002ee <rand>:
    if (!rand_seed_set) {
  1002ee:	83 3d 27 0d 00 00 00 	cmpl   $0x0,0xd27(%rip)        # 10101c <rand_seed_set>
  1002f5:	74 1b                	je     100312 <rand+0x24>
    rand_seed = rand_seed * 1664525U + 1013904223U;
  1002f7:	69 05 17 0d 00 00 0d 	imul   $0x19660d,0xd17(%rip),%eax        # 101018 <rand_seed>
  1002fe:	66 19 00 
  100301:	05 5f f3 6e 3c       	add    $0x3c6ef35f,%eax
  100306:	89 05 0c 0d 00 00    	mov    %eax,0xd0c(%rip)        # 101018 <rand_seed>
    return rand_seed & RAND_MAX;
  10030c:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
}
  100311:	c3                   	retq   
    rand_seed = seed;
  100312:	c7 05 fc 0c 00 00 9e 	movl   $0x30d4879e,0xcfc(%rip)        # 101018 <rand_seed>
  100319:	87 d4 30 
    rand_seed_set = 1;
  10031c:	c7 05 f6 0c 00 00 01 	movl   $0x1,0xcf6(%rip)        # 10101c <rand_seed_set>
  100323:	00 00 00 
}
  100326:	eb cf                	jmp    1002f7 <rand+0x9>

0000000000100328 <srand>:
    rand_seed = seed;
  100328:	89 3d ea 0c 00 00    	mov    %edi,0xcea(%rip)        # 101018 <rand_seed>
    rand_seed_set = 1;
  10032e:	c7 05 e4 0c 00 00 01 	movl   $0x1,0xce4(%rip)        # 10101c <rand_seed_set>
  100335:	00 00 00 
}
  100338:	c3                   	retq   

0000000000100339 <printer_vprintf>:
void printer_vprintf(printer* p, int color, const char* format, va_list val) {
  100339:	55                   	push   %rbp
  10033a:	48 89 e5             	mov    %rsp,%rbp
  10033d:	41 57                	push   %r15
  10033f:	41 56                	push   %r14
  100341:	41 55                	push   %r13
  100343:	41 54                	push   %r12
  100345:	53                   	push   %rbx
  100346:	48 83 ec 58          	sub    $0x58,%rsp
  10034a:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
    for (; *format; ++format) {
  10034e:	0f b6 02             	movzbl (%rdx),%eax
  100351:	84 c0                	test   %al,%al
  100353:	0f 84 b0 06 00 00    	je     100a09 <printer_vprintf+0x6d0>
  100359:	49 89 fe             	mov    %rdi,%r14
  10035c:	49 89 d4             	mov    %rdx,%r12
            length = 1;
  10035f:	41 89 f7             	mov    %esi,%r15d
  100362:	e9 a4 04 00 00       	jmpq   10080b <printer_vprintf+0x4d2>
        for (++format; *format; ++format) {
  100367:	49 8d 5c 24 01       	lea    0x1(%r12),%rbx
  10036c:	45 0f b6 64 24 01    	movzbl 0x1(%r12),%r12d
  100372:	45 84 e4             	test   %r12b,%r12b
  100375:	0f 84 82 06 00 00    	je     1009fd <printer_vprintf+0x6c4>
        int flags = 0;
  10037b:	41 bd 00 00 00 00    	mov    $0x0,%r13d
            const char* flagc = strchr(flag_chars, *format);
  100381:	41 0f be f4          	movsbl %r12b,%esi
  100385:	bf 61 0f 10 00       	mov    $0x100f61,%edi
  10038a:	e8 37 ff ff ff       	callq  1002c6 <strchr>
  10038f:	48 89 c1             	mov    %rax,%rcx
            if (flagc) {
  100392:	48 85 c0             	test   %rax,%rax
  100395:	74 55                	je     1003ec <printer_vprintf+0xb3>
                flags |= 1 << (flagc - flag_chars);
  100397:	48 81 e9 61 0f 10 00 	sub    $0x100f61,%rcx
  10039e:	b8 01 00 00 00       	mov    $0x1,%eax
  1003a3:	d3 e0                	shl    %cl,%eax
  1003a5:	41 09 c5             	or     %eax,%r13d
        for (++format; *format; ++format) {
  1003a8:	48 83 c3 01          	add    $0x1,%rbx
  1003ac:	44 0f b6 23          	movzbl (%rbx),%r12d
  1003b0:	45 84 e4             	test   %r12b,%r12b
  1003b3:	75 cc                	jne    100381 <printer_vprintf+0x48>
  1003b5:	44 89 6d a8          	mov    %r13d,-0x58(%rbp)
        int width = -1;
  1003b9:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
        int precision = -1;
  1003bf:	c7 45 9c ff ff ff ff 	movl   $0xffffffff,-0x64(%rbp)
        if (*format == '.') {
  1003c6:	80 3b 2e             	cmpb   $0x2e,(%rbx)
  1003c9:	0f 84 a9 00 00 00    	je     100478 <printer_vprintf+0x13f>
        int length = 0;
  1003cf:	b9 00 00 00 00       	mov    $0x0,%ecx
        switch (*format) {
  1003d4:	0f b6 13             	movzbl (%rbx),%edx
  1003d7:	8d 42 bd             	lea    -0x43(%rdx),%eax
  1003da:	3c 37                	cmp    $0x37,%al
  1003dc:	0f 87 c4 04 00 00    	ja     1008a6 <printer_vprintf+0x56d>
  1003e2:	0f b6 c0             	movzbl %al,%eax
  1003e5:	ff 24 c5 70 0d 10 00 	jmpq   *0x100d70(,%rax,8)
        if (*format >= '1' && *format <= '9') {
  1003ec:	44 89 6d a8          	mov    %r13d,-0x58(%rbp)
  1003f0:	41 8d 44 24 cf       	lea    -0x31(%r12),%eax
  1003f5:	3c 08                	cmp    $0x8,%al
  1003f7:	77 2f                	ja     100428 <printer_vprintf+0xef>
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  1003f9:	0f b6 03             	movzbl (%rbx),%eax
  1003fc:	8d 50 d0             	lea    -0x30(%rax),%edx
  1003ff:	80 fa 09             	cmp    $0x9,%dl
  100402:	77 5e                	ja     100462 <printer_vprintf+0x129>
  100404:	41 bd 00 00 00 00    	mov    $0x0,%r13d
                width = 10 * width + *format++ - '0';
  10040a:	48 83 c3 01          	add    $0x1,%rbx
  10040e:	43 8d 54 ad 00       	lea    0x0(%r13,%r13,4),%edx
  100413:	0f be c0             	movsbl %al,%eax
  100416:	44 8d 6c 50 d0       	lea    -0x30(%rax,%rdx,2),%r13d
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  10041b:	0f b6 03             	movzbl (%rbx),%eax
  10041e:	8d 50 d0             	lea    -0x30(%rax),%edx
  100421:	80 fa 09             	cmp    $0x9,%dl
  100424:	76 e4                	jbe    10040a <printer_vprintf+0xd1>
  100426:	eb 97                	jmp    1003bf <printer_vprintf+0x86>
        } else if (*format == '*') {
  100428:	41 80 fc 2a          	cmp    $0x2a,%r12b
  10042c:	75 3f                	jne    10046d <printer_vprintf+0x134>
            width = va_arg(val, int);
  10042e:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  100432:	8b 07                	mov    (%rdi),%eax
  100434:	83 f8 2f             	cmp    $0x2f,%eax
  100437:	77 17                	ja     100450 <printer_vprintf+0x117>
  100439:	89 c2                	mov    %eax,%edx
  10043b:	48 03 57 10          	add    0x10(%rdi),%rdx
  10043f:	83 c0 08             	add    $0x8,%eax
  100442:	89 07                	mov    %eax,(%rdi)
  100444:	44 8b 2a             	mov    (%rdx),%r13d
            ++format;
  100447:	48 83 c3 01          	add    $0x1,%rbx
  10044b:	e9 6f ff ff ff       	jmpq   1003bf <printer_vprintf+0x86>
            width = va_arg(val, int);
  100450:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  100454:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  100458:	48 8d 42 08          	lea    0x8(%rdx),%rax
  10045c:	48 89 41 08          	mov    %rax,0x8(%rcx)
  100460:	eb e2                	jmp    100444 <printer_vprintf+0x10b>
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  100462:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  100468:	e9 52 ff ff ff       	jmpq   1003bf <printer_vprintf+0x86>
        int width = -1;
  10046d:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  100473:	e9 47 ff ff ff       	jmpq   1003bf <printer_vprintf+0x86>
            ++format;
  100478:	48 8d 53 01          	lea    0x1(%rbx),%rdx
            if (*format >= '0' && *format <= '9') {
  10047c:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  100480:	8d 48 d0             	lea    -0x30(%rax),%ecx
  100483:	80 f9 09             	cmp    $0x9,%cl
  100486:	76 13                	jbe    10049b <printer_vprintf+0x162>
            } else if (*format == '*') {
  100488:	3c 2a                	cmp    $0x2a,%al
  10048a:	74 33                	je     1004bf <printer_vprintf+0x186>
            ++format;
  10048c:	48 89 d3             	mov    %rdx,%rbx
                precision = 0;
  10048f:	c7 45 9c 00 00 00 00 	movl   $0x0,-0x64(%rbp)
  100496:	e9 34 ff ff ff       	jmpq   1003cf <printer_vprintf+0x96>
                for (precision = 0; *format >= '0' && *format <= '9'; ) {
  10049b:	b9 00 00 00 00       	mov    $0x0,%ecx
                    precision = 10 * precision + *format++ - '0';
  1004a0:	48 83 c2 01          	add    $0x1,%rdx
  1004a4:	8d 0c 89             	lea    (%rcx,%rcx,4),%ecx
  1004a7:	0f be c0             	movsbl %al,%eax
  1004aa:	8d 4c 48 d0          	lea    -0x30(%rax,%rcx,2),%ecx
                for (precision = 0; *format >= '0' && *format <= '9'; ) {
  1004ae:	0f b6 02             	movzbl (%rdx),%eax
  1004b1:	8d 70 d0             	lea    -0x30(%rax),%esi
  1004b4:	40 80 fe 09          	cmp    $0x9,%sil
  1004b8:	76 e6                	jbe    1004a0 <printer_vprintf+0x167>
                    precision = 10 * precision + *format++ - '0';
  1004ba:	48 89 d3             	mov    %rdx,%rbx
  1004bd:	eb 1c                	jmp    1004db <printer_vprintf+0x1a2>
                precision = va_arg(val, int);
  1004bf:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1004c3:	8b 07                	mov    (%rdi),%eax
  1004c5:	83 f8 2f             	cmp    $0x2f,%eax
  1004c8:	77 23                	ja     1004ed <printer_vprintf+0x1b4>
  1004ca:	89 c2                	mov    %eax,%edx
  1004cc:	48 03 57 10          	add    0x10(%rdi),%rdx
  1004d0:	83 c0 08             	add    $0x8,%eax
  1004d3:	89 07                	mov    %eax,(%rdi)
  1004d5:	8b 0a                	mov    (%rdx),%ecx
                ++format;
  1004d7:	48 83 c3 02          	add    $0x2,%rbx
            if (precision < 0) {
  1004db:	85 c9                	test   %ecx,%ecx
  1004dd:	b8 00 00 00 00       	mov    $0x0,%eax
  1004e2:	0f 49 c1             	cmovns %ecx,%eax
  1004e5:	89 45 9c             	mov    %eax,-0x64(%rbp)
  1004e8:	e9 e2 fe ff ff       	jmpq   1003cf <printer_vprintf+0x96>
                precision = va_arg(val, int);
  1004ed:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1004f1:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  1004f5:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1004f9:	48 89 41 08          	mov    %rax,0x8(%rcx)
  1004fd:	eb d6                	jmp    1004d5 <printer_vprintf+0x19c>
        switch (*format) {
  1004ff:	be f0 ff ff ff       	mov    $0xfffffff0,%esi
  100504:	e9 f3 00 00 00       	jmpq   1005fc <printer_vprintf+0x2c3>
            ++format;
  100509:	48 83 c3 01          	add    $0x1,%rbx
            length = 1;
  10050d:	b9 01 00 00 00       	mov    $0x1,%ecx
            goto again;
  100512:	e9 bd fe ff ff       	jmpq   1003d4 <printer_vprintf+0x9b>
            long x = length ? va_arg(val, long) : va_arg(val, int);
  100517:	85 c9                	test   %ecx,%ecx
  100519:	74 55                	je     100570 <printer_vprintf+0x237>
  10051b:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  10051f:	8b 07                	mov    (%rdi),%eax
  100521:	83 f8 2f             	cmp    $0x2f,%eax
  100524:	77 38                	ja     10055e <printer_vprintf+0x225>
  100526:	89 c2                	mov    %eax,%edx
  100528:	48 03 57 10          	add    0x10(%rdi),%rdx
  10052c:	83 c0 08             	add    $0x8,%eax
  10052f:	89 07                	mov    %eax,(%rdi)
  100531:	48 8b 12             	mov    (%rdx),%rdx
            int negative = x < 0 ? FLAG_NEGATIVE : 0;
  100534:	48 89 d0             	mov    %rdx,%rax
  100537:	48 c1 f8 38          	sar    $0x38,%rax
            num = negative ? -x : x;
  10053b:	49 89 d0             	mov    %rdx,%r8
  10053e:	49 f7 d8             	neg    %r8
  100541:	25 80 00 00 00       	and    $0x80,%eax
  100546:	4c 0f 44 c2          	cmove  %rdx,%r8
            flags |= FLAG_NUMERIC | FLAG_SIGNED | negative;
  10054a:	0b 45 a8             	or     -0x58(%rbp),%eax
  10054d:	83 c8 60             	or     $0x60,%eax
  100550:	89 45 a8             	mov    %eax,-0x58(%rbp)
        char* data = "";
  100553:	41 bc 70 0f 10 00    	mov    $0x100f70,%r12d
            break;
  100559:	e9 35 01 00 00       	jmpq   100693 <printer_vprintf+0x35a>
            long x = length ? va_arg(val, long) : va_arg(val, int);
  10055e:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  100562:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  100566:	48 8d 42 08          	lea    0x8(%rdx),%rax
  10056a:	48 89 41 08          	mov    %rax,0x8(%rcx)
  10056e:	eb c1                	jmp    100531 <printer_vprintf+0x1f8>
  100570:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  100574:	8b 07                	mov    (%rdi),%eax
  100576:	83 f8 2f             	cmp    $0x2f,%eax
  100579:	77 10                	ja     10058b <printer_vprintf+0x252>
  10057b:	89 c2                	mov    %eax,%edx
  10057d:	48 03 57 10          	add    0x10(%rdi),%rdx
  100581:	83 c0 08             	add    $0x8,%eax
  100584:	89 07                	mov    %eax,(%rdi)
  100586:	48 63 12             	movslq (%rdx),%rdx
  100589:	eb a9                	jmp    100534 <printer_vprintf+0x1fb>
  10058b:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  10058f:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  100593:	48 8d 42 08          	lea    0x8(%rdx),%rax
  100597:	48 89 47 08          	mov    %rax,0x8(%rdi)
  10059b:	eb e9                	jmp    100586 <printer_vprintf+0x24d>
        int base = 10;
  10059d:	be 0a 00 00 00       	mov    $0xa,%esi
  1005a2:	eb 58                	jmp    1005fc <printer_vprintf+0x2c3>
            num = length ? va_arg(val, unsigned long) : va_arg(val, unsigned);
  1005a4:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1005a8:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  1005ac:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1005b0:	48 89 41 08          	mov    %rax,0x8(%rcx)
  1005b4:	eb 60                	jmp    100616 <printer_vprintf+0x2dd>
  1005b6:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1005ba:	8b 07                	mov    (%rdi),%eax
  1005bc:	83 f8 2f             	cmp    $0x2f,%eax
  1005bf:	77 10                	ja     1005d1 <printer_vprintf+0x298>
  1005c1:	89 c2                	mov    %eax,%edx
  1005c3:	48 03 57 10          	add    0x10(%rdi),%rdx
  1005c7:	83 c0 08             	add    $0x8,%eax
  1005ca:	89 07                	mov    %eax,(%rdi)
  1005cc:	44 8b 02             	mov    (%rdx),%r8d
  1005cf:	eb 48                	jmp    100619 <printer_vprintf+0x2e0>
  1005d1:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1005d5:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  1005d9:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1005dd:	48 89 41 08          	mov    %rax,0x8(%rcx)
  1005e1:	eb e9                	jmp    1005cc <printer_vprintf+0x293>
  1005e3:	41 89 f1             	mov    %esi,%r9d
        if (flags & FLAG_NUMERIC) {
  1005e6:	c7 45 8c 20 00 00 00 	movl   $0x20,-0x74(%rbp)
    const char* digits = upper_digits;
  1005ed:	bf 50 0f 10 00       	mov    $0x100f50,%edi
  1005f2:	e9 e2 02 00 00       	jmpq   1008d9 <printer_vprintf+0x5a0>
            base = 16;
  1005f7:	be 10 00 00 00       	mov    $0x10,%esi
            num = length ? va_arg(val, unsigned long) : va_arg(val, unsigned);
  1005fc:	85 c9                	test   %ecx,%ecx
  1005fe:	74 b6                	je     1005b6 <printer_vprintf+0x27d>
  100600:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  100604:	8b 01                	mov    (%rcx),%eax
  100606:	83 f8 2f             	cmp    $0x2f,%eax
  100609:	77 99                	ja     1005a4 <printer_vprintf+0x26b>
  10060b:	89 c2                	mov    %eax,%edx
  10060d:	48 03 51 10          	add    0x10(%rcx),%rdx
  100611:	83 c0 08             	add    $0x8,%eax
  100614:	89 01                	mov    %eax,(%rcx)
  100616:	4c 8b 02             	mov    (%rdx),%r8
            flags |= FLAG_NUMERIC;
  100619:	83 4d a8 20          	orl    $0x20,-0x58(%rbp)
    if (base < 0) {
  10061d:	85 f6                	test   %esi,%esi
  10061f:	79 c2                	jns    1005e3 <printer_vprintf+0x2aa>
        base = -base;
  100621:	41 89 f1             	mov    %esi,%r9d
  100624:	f7 de                	neg    %esi
  100626:	c7 45 8c 20 00 00 00 	movl   $0x20,-0x74(%rbp)
        digits = lower_digits;
  10062d:	bf 30 0f 10 00       	mov    $0x100f30,%edi
  100632:	e9 a2 02 00 00       	jmpq   1008d9 <printer_vprintf+0x5a0>
            num = (uintptr_t) va_arg(val, void*);
  100637:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  10063b:	8b 07                	mov    (%rdi),%eax
  10063d:	83 f8 2f             	cmp    $0x2f,%eax
  100640:	77 1c                	ja     10065e <printer_vprintf+0x325>
  100642:	89 c2                	mov    %eax,%edx
  100644:	48 03 57 10          	add    0x10(%rdi),%rdx
  100648:	83 c0 08             	add    $0x8,%eax
  10064b:	89 07                	mov    %eax,(%rdi)
  10064d:	4c 8b 02             	mov    (%rdx),%r8
            flags |= FLAG_ALT | FLAG_ALT2 | FLAG_NUMERIC;
  100650:	81 4d a8 21 01 00 00 	orl    $0x121,-0x58(%rbp)
            base = -16;
  100657:	be f0 ff ff ff       	mov    $0xfffffff0,%esi
  10065c:	eb c3                	jmp    100621 <printer_vprintf+0x2e8>
            num = (uintptr_t) va_arg(val, void*);
  10065e:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  100662:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  100666:	48 8d 42 08          	lea    0x8(%rdx),%rax
  10066a:	48 89 41 08          	mov    %rax,0x8(%rcx)
  10066e:	eb dd                	jmp    10064d <printer_vprintf+0x314>
            data = va_arg(val, char*);
  100670:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  100674:	8b 01                	mov    (%rcx),%eax
  100676:	83 f8 2f             	cmp    $0x2f,%eax
  100679:	0f 87 a5 01 00 00    	ja     100824 <printer_vprintf+0x4eb>
  10067f:	89 c2                	mov    %eax,%edx
  100681:	48 03 51 10          	add    0x10(%rcx),%rdx
  100685:	83 c0 08             	add    $0x8,%eax
  100688:	89 01                	mov    %eax,(%rcx)
  10068a:	4c 8b 22             	mov    (%rdx),%r12
        unsigned long num = 0;
  10068d:	41 b8 00 00 00 00    	mov    $0x0,%r8d
        if (flags & FLAG_NUMERIC) {
  100693:	8b 45 a8             	mov    -0x58(%rbp),%eax
  100696:	83 e0 20             	and    $0x20,%eax
  100699:	89 45 8c             	mov    %eax,-0x74(%rbp)
  10069c:	41 b9 0a 00 00 00    	mov    $0xa,%r9d
  1006a2:	0f 85 21 02 00 00    	jne    1008c9 <printer_vprintf+0x590>
        if ((flags & FLAG_NUMERIC) && (flags & FLAG_SIGNED)) {
  1006a8:	8b 45 a8             	mov    -0x58(%rbp),%eax
  1006ab:	89 45 88             	mov    %eax,-0x78(%rbp)
  1006ae:	83 e0 60             	and    $0x60,%eax
  1006b1:	83 f8 60             	cmp    $0x60,%eax
  1006b4:	0f 84 54 02 00 00    	je     10090e <printer_vprintf+0x5d5>
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ALT)
  1006ba:	8b 45 a8             	mov    -0x58(%rbp),%eax
  1006bd:	83 e0 21             	and    $0x21,%eax
        const char* prefix = "";
  1006c0:	48 c7 45 a0 70 0f 10 	movq   $0x100f70,-0x60(%rbp)
  1006c7:	00 
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ALT)
  1006c8:	83 f8 21             	cmp    $0x21,%eax
  1006cb:	0f 84 79 02 00 00    	je     10094a <printer_vprintf+0x611>
        if (precision >= 0 && !(flags & FLAG_NUMERIC)) {
  1006d1:	8b 7d 9c             	mov    -0x64(%rbp),%edi
  1006d4:	89 f8                	mov    %edi,%eax
  1006d6:	f7 d0                	not    %eax
  1006d8:	c1 e8 1f             	shr    $0x1f,%eax
  1006db:	89 45 84             	mov    %eax,-0x7c(%rbp)
  1006de:	83 7d 8c 00          	cmpl   $0x0,-0x74(%rbp)
  1006e2:	0f 85 9e 02 00 00    	jne    100986 <printer_vprintf+0x64d>
  1006e8:	84 c0                	test   %al,%al
  1006ea:	0f 84 96 02 00 00    	je     100986 <printer_vprintf+0x64d>
            len = strnlen(data, precision);
  1006f0:	48 63 f7             	movslq %edi,%rsi
  1006f3:	4c 89 e7             	mov    %r12,%rdi
  1006f6:	e8 63 fb ff ff       	callq  10025e <strnlen>
  1006fb:	89 45 98             	mov    %eax,-0x68(%rbp)
                   && !(flags & FLAG_LEFTJUSTIFY)
  1006fe:	8b 45 88             	mov    -0x78(%rbp),%eax
  100701:	83 e0 26             	and    $0x26,%eax
            zeros = 0;
  100704:	c7 45 9c 00 00 00 00 	movl   $0x0,-0x64(%rbp)
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ZERO)
  10070b:	83 f8 22             	cmp    $0x22,%eax
  10070e:	0f 84 aa 02 00 00    	je     1009be <printer_vprintf+0x685>
        width -= len + zeros + strlen(prefix);
  100714:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  100718:	e8 26 fb ff ff       	callq  100243 <strlen>
  10071d:	8b 55 9c             	mov    -0x64(%rbp),%edx
  100720:	03 55 98             	add    -0x68(%rbp),%edx
  100723:	44 89 e9             	mov    %r13d,%ecx
  100726:	29 d1                	sub    %edx,%ecx
  100728:	29 c1                	sub    %eax,%ecx
  10072a:	89 4d 8c             	mov    %ecx,-0x74(%rbp)
  10072d:	41 89 cd             	mov    %ecx,%r13d
        for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width) {
  100730:	f6 45 a8 04          	testb  $0x4,-0x58(%rbp)
  100734:	75 2d                	jne    100763 <printer_vprintf+0x42a>
  100736:	85 c9                	test   %ecx,%ecx
  100738:	7e 29                	jle    100763 <printer_vprintf+0x42a>
            p->putc(p, ' ', color);
  10073a:	44 89 fa             	mov    %r15d,%edx
  10073d:	be 20 00 00 00       	mov    $0x20,%esi
  100742:	4c 89 f7             	mov    %r14,%rdi
  100745:	41 ff 16             	callq  *(%r14)
        for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width) {
  100748:	41 83 ed 01          	sub    $0x1,%r13d
  10074c:	45 85 ed             	test   %r13d,%r13d
  10074f:	7f e9                	jg     10073a <printer_vprintf+0x401>
  100751:	8b 7d 8c             	mov    -0x74(%rbp),%edi
  100754:	85 ff                	test   %edi,%edi
  100756:	b8 01 00 00 00       	mov    $0x1,%eax
  10075b:	0f 4f c7             	cmovg  %edi,%eax
  10075e:	29 c7                	sub    %eax,%edi
  100760:	41 89 fd             	mov    %edi,%r13d
        for (; *prefix; ++prefix) {
  100763:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  100767:	0f b6 07             	movzbl (%rdi),%eax
  10076a:	84 c0                	test   %al,%al
  10076c:	74 22                	je     100790 <printer_vprintf+0x457>
  10076e:	48 89 5d a8          	mov    %rbx,-0x58(%rbp)
  100772:	48 89 fb             	mov    %rdi,%rbx
            p->putc(p, *prefix, color);
  100775:	0f b6 f0             	movzbl %al,%esi
  100778:	44 89 fa             	mov    %r15d,%edx
  10077b:	4c 89 f7             	mov    %r14,%rdi
  10077e:	41 ff 16             	callq  *(%r14)
        for (; *prefix; ++prefix) {
  100781:	48 83 c3 01          	add    $0x1,%rbx
  100785:	0f b6 03             	movzbl (%rbx),%eax
  100788:	84 c0                	test   %al,%al
  10078a:	75 e9                	jne    100775 <printer_vprintf+0x43c>
  10078c:	48 8b 5d a8          	mov    -0x58(%rbp),%rbx
        for (; zeros > 0; --zeros) {
  100790:	8b 45 9c             	mov    -0x64(%rbp),%eax
  100793:	85 c0                	test   %eax,%eax
  100795:	7e 1d                	jle    1007b4 <printer_vprintf+0x47b>
  100797:	48 89 5d a8          	mov    %rbx,-0x58(%rbp)
  10079b:	89 c3                	mov    %eax,%ebx
            p->putc(p, '0', color);
  10079d:	44 89 fa             	mov    %r15d,%edx
  1007a0:	be 30 00 00 00       	mov    $0x30,%esi
  1007a5:	4c 89 f7             	mov    %r14,%rdi
  1007a8:	41 ff 16             	callq  *(%r14)
        for (; zeros > 0; --zeros) {
  1007ab:	83 eb 01             	sub    $0x1,%ebx
  1007ae:	75 ed                	jne    10079d <printer_vprintf+0x464>
  1007b0:	48 8b 5d a8          	mov    -0x58(%rbp),%rbx
        for (; len > 0; ++data, --len) {
  1007b4:	8b 45 98             	mov    -0x68(%rbp),%eax
  1007b7:	85 c0                	test   %eax,%eax
  1007b9:	7e 27                	jle    1007e2 <printer_vprintf+0x4a9>
  1007bb:	89 c0                	mov    %eax,%eax
  1007bd:	4c 01 e0             	add    %r12,%rax
  1007c0:	48 89 5d a8          	mov    %rbx,-0x58(%rbp)
  1007c4:	48 89 c3             	mov    %rax,%rbx
            p->putc(p, *data, color);
  1007c7:	41 0f b6 34 24       	movzbl (%r12),%esi
  1007cc:	44 89 fa             	mov    %r15d,%edx
  1007cf:	4c 89 f7             	mov    %r14,%rdi
  1007d2:	41 ff 16             	callq  *(%r14)
        for (; len > 0; ++data, --len) {
  1007d5:	49 83 c4 01          	add    $0x1,%r12
  1007d9:	49 39 dc             	cmp    %rbx,%r12
  1007dc:	75 e9                	jne    1007c7 <printer_vprintf+0x48e>
  1007de:	48 8b 5d a8          	mov    -0x58(%rbp),%rbx
        for (; width > 0; --width) {
  1007e2:	45 85 ed             	test   %r13d,%r13d
  1007e5:	7e 14                	jle    1007fb <printer_vprintf+0x4c2>
            p->putc(p, ' ', color);
  1007e7:	44 89 fa             	mov    %r15d,%edx
  1007ea:	be 20 00 00 00       	mov    $0x20,%esi
  1007ef:	4c 89 f7             	mov    %r14,%rdi
  1007f2:	41 ff 16             	callq  *(%r14)
        for (; width > 0; --width) {
  1007f5:	41 83 ed 01          	sub    $0x1,%r13d
  1007f9:	75 ec                	jne    1007e7 <printer_vprintf+0x4ae>
    for (; *format; ++format) {
  1007fb:	4c 8d 63 01          	lea    0x1(%rbx),%r12
  1007ff:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  100803:	84 c0                	test   %al,%al
  100805:	0f 84 fe 01 00 00    	je     100a09 <printer_vprintf+0x6d0>
        if (*format != '%') {
  10080b:	3c 25                	cmp    $0x25,%al
  10080d:	0f 84 54 fb ff ff    	je     100367 <printer_vprintf+0x2e>
            p->putc(p, *format, color);
  100813:	0f b6 f0             	movzbl %al,%esi
  100816:	44 89 fa             	mov    %r15d,%edx
  100819:	4c 89 f7             	mov    %r14,%rdi
  10081c:	41 ff 16             	callq  *(%r14)
            continue;
  10081f:	4c 89 e3             	mov    %r12,%rbx
  100822:	eb d7                	jmp    1007fb <printer_vprintf+0x4c2>
            data = va_arg(val, char*);
  100824:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  100828:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  10082c:	48 8d 42 08          	lea    0x8(%rdx),%rax
  100830:	48 89 47 08          	mov    %rax,0x8(%rdi)
  100834:	e9 51 fe ff ff       	jmpq   10068a <printer_vprintf+0x351>
            color = va_arg(val, int);
  100839:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  10083d:	8b 07                	mov    (%rdi),%eax
  10083f:	83 f8 2f             	cmp    $0x2f,%eax
  100842:	77 10                	ja     100854 <printer_vprintf+0x51b>
  100844:	89 c2                	mov    %eax,%edx
  100846:	48 03 57 10          	add    0x10(%rdi),%rdx
  10084a:	83 c0 08             	add    $0x8,%eax
  10084d:	89 07                	mov    %eax,(%rdi)
  10084f:	44 8b 3a             	mov    (%rdx),%r15d
            goto done;
  100852:	eb a7                	jmp    1007fb <printer_vprintf+0x4c2>
            color = va_arg(val, int);
  100854:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  100858:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  10085c:	48 8d 42 08          	lea    0x8(%rdx),%rax
  100860:	48 89 41 08          	mov    %rax,0x8(%rcx)
  100864:	eb e9                	jmp    10084f <printer_vprintf+0x516>
            numbuf[0] = va_arg(val, int);
  100866:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  10086a:	8b 01                	mov    (%rcx),%eax
  10086c:	83 f8 2f             	cmp    $0x2f,%eax
  10086f:	77 23                	ja     100894 <printer_vprintf+0x55b>
  100871:	89 c2                	mov    %eax,%edx
  100873:	48 03 51 10          	add    0x10(%rcx),%rdx
  100877:	83 c0 08             	add    $0x8,%eax
  10087a:	89 01                	mov    %eax,(%rcx)
  10087c:	8b 02                	mov    (%rdx),%eax
  10087e:	88 45 b8             	mov    %al,-0x48(%rbp)
            numbuf[1] = '\0';
  100881:	c6 45 b9 00          	movb   $0x0,-0x47(%rbp)
            data = numbuf;
  100885:	4c 8d 65 b8          	lea    -0x48(%rbp),%r12
        unsigned long num = 0;
  100889:	41 b8 00 00 00 00    	mov    $0x0,%r8d
            break;
  10088f:	e9 ff fd ff ff       	jmpq   100693 <printer_vprintf+0x35a>
            numbuf[0] = va_arg(val, int);
  100894:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  100898:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  10089c:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1008a0:	48 89 47 08          	mov    %rax,0x8(%rdi)
  1008a4:	eb d6                	jmp    10087c <printer_vprintf+0x543>
            numbuf[0] = (*format ? *format : '%');
  1008a6:	84 d2                	test   %dl,%dl
  1008a8:	0f 85 39 01 00 00    	jne    1009e7 <printer_vprintf+0x6ae>
  1008ae:	c6 45 b8 25          	movb   $0x25,-0x48(%rbp)
            numbuf[1] = '\0';
  1008b2:	c6 45 b9 00          	movb   $0x0,-0x47(%rbp)
                format--;
  1008b6:	48 83 eb 01          	sub    $0x1,%rbx
            data = numbuf;
  1008ba:	4c 8d 65 b8          	lea    -0x48(%rbp),%r12
        unsigned long num = 0;
  1008be:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  1008c4:	e9 ca fd ff ff       	jmpq   100693 <printer_vprintf+0x35a>
        if (flags & FLAG_NUMERIC) {
  1008c9:	41 b9 0a 00 00 00    	mov    $0xa,%r9d
    const char* digits = upper_digits;
  1008cf:	bf 50 0f 10 00       	mov    $0x100f50,%edi
        if (flags & FLAG_NUMERIC) {
  1008d4:	be 0a 00 00 00       	mov    $0xa,%esi
    *--numbuf_end = '\0';
  1008d9:	c6 45 cf 00          	movb   $0x0,-0x31(%rbp)
  1008dd:	4c 89 c1             	mov    %r8,%rcx
  1008e0:	4c 8d 65 cf          	lea    -0x31(%rbp),%r12
        *--numbuf_end = digits[val % base];
  1008e4:	48 63 f6             	movslq %esi,%rsi
  1008e7:	49 83 ec 01          	sub    $0x1,%r12
  1008eb:	48 89 c8             	mov    %rcx,%rax
  1008ee:	ba 00 00 00 00       	mov    $0x0,%edx
  1008f3:	48 f7 f6             	div    %rsi
  1008f6:	0f b6 14 17          	movzbl (%rdi,%rdx,1),%edx
  1008fa:	41 88 14 24          	mov    %dl,(%r12)
        val /= base;
  1008fe:	48 89 ca             	mov    %rcx,%rdx
  100901:	48 89 c1             	mov    %rax,%rcx
    } while (val != 0);
  100904:	48 39 d6             	cmp    %rdx,%rsi
  100907:	76 de                	jbe    1008e7 <printer_vprintf+0x5ae>
  100909:	e9 9a fd ff ff       	jmpq   1006a8 <printer_vprintf+0x36f>
                prefix = "-";
  10090e:	48 c7 45 a0 61 0d 10 	movq   $0x100d61,-0x60(%rbp)
  100915:	00 
            if (flags & FLAG_NEGATIVE) {
  100916:	8b 45 a8             	mov    -0x58(%rbp),%eax
  100919:	a8 80                	test   $0x80,%al
  10091b:	0f 85 b0 fd ff ff    	jne    1006d1 <printer_vprintf+0x398>
                prefix = "+";
  100921:	48 c7 45 a0 5c 0d 10 	movq   $0x100d5c,-0x60(%rbp)
  100928:	00 
            } else if (flags & FLAG_PLUSPOSITIVE) {
  100929:	a8 10                	test   $0x10,%al
  10092b:	0f 85 a0 fd ff ff    	jne    1006d1 <printer_vprintf+0x398>
                prefix = " ";
  100931:	a8 08                	test   $0x8,%al
  100933:	ba 70 0f 10 00       	mov    $0x100f70,%edx
  100938:	b8 6d 0f 10 00       	mov    $0x100f6d,%eax
  10093d:	48 0f 44 c2          	cmove  %rdx,%rax
  100941:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  100945:	e9 87 fd ff ff       	jmpq   1006d1 <printer_vprintf+0x398>
                   && (base == 16 || base == -16)
  10094a:	41 8d 41 10          	lea    0x10(%r9),%eax
  10094e:	a9 df ff ff ff       	test   $0xffffffdf,%eax
  100953:	0f 85 78 fd ff ff    	jne    1006d1 <printer_vprintf+0x398>
                   && (num || (flags & FLAG_ALT2))) {
  100959:	4d 85 c0             	test   %r8,%r8
  10095c:	75 0d                	jne    10096b <printer_vprintf+0x632>
  10095e:	f7 45 a8 00 01 00 00 	testl  $0x100,-0x58(%rbp)
  100965:	0f 84 66 fd ff ff    	je     1006d1 <printer_vprintf+0x398>
            prefix = (base == -16 ? "0x" : "0X");
  10096b:	41 83 f9 f0          	cmp    $0xfffffff0,%r9d
  10096f:	ba 63 0d 10 00       	mov    $0x100d63,%edx
  100974:	b8 5e 0d 10 00       	mov    $0x100d5e,%eax
  100979:	48 0f 44 c2          	cmove  %rdx,%rax
  10097d:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  100981:	e9 4b fd ff ff       	jmpq   1006d1 <printer_vprintf+0x398>
            len = strlen(data);
  100986:	4c 89 e7             	mov    %r12,%rdi
  100989:	e8 b5 f8 ff ff       	callq  100243 <strlen>
  10098e:	89 45 98             	mov    %eax,-0x68(%rbp)
        if ((flags & FLAG_NUMERIC) && precision >= 0) {
  100991:	83 7d 8c 00          	cmpl   $0x0,-0x74(%rbp)
  100995:	0f 84 63 fd ff ff    	je     1006fe <printer_vprintf+0x3c5>
  10099b:	80 7d 84 00          	cmpb   $0x0,-0x7c(%rbp)
  10099f:	0f 84 59 fd ff ff    	je     1006fe <printer_vprintf+0x3c5>
            zeros = precision > len ? precision - len : 0;
  1009a5:	8b 4d 9c             	mov    -0x64(%rbp),%ecx
  1009a8:	89 ca                	mov    %ecx,%edx
  1009aa:	29 c2                	sub    %eax,%edx
  1009ac:	39 c1                	cmp    %eax,%ecx
  1009ae:	b8 00 00 00 00       	mov    $0x0,%eax
  1009b3:	0f 4e d0             	cmovle %eax,%edx
  1009b6:	89 55 9c             	mov    %edx,-0x64(%rbp)
  1009b9:	e9 56 fd ff ff       	jmpq   100714 <printer_vprintf+0x3db>
                   && len + (int) strlen(prefix) < width) {
  1009be:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  1009c2:	e8 7c f8 ff ff       	callq  100243 <strlen>
  1009c7:	8b 7d 98             	mov    -0x68(%rbp),%edi
  1009ca:	8d 14 07             	lea    (%rdi,%rax,1),%edx
            zeros = width - len - strlen(prefix);
  1009cd:	44 89 e9             	mov    %r13d,%ecx
  1009d0:	29 f9                	sub    %edi,%ecx
  1009d2:	29 c1                	sub    %eax,%ecx
  1009d4:	44 39 ea             	cmp    %r13d,%edx
  1009d7:	b8 00 00 00 00       	mov    $0x0,%eax
  1009dc:	0f 4d c8             	cmovge %eax,%ecx
  1009df:	89 4d 9c             	mov    %ecx,-0x64(%rbp)
  1009e2:	e9 2d fd ff ff       	jmpq   100714 <printer_vprintf+0x3db>
            numbuf[0] = (*format ? *format : '%');
  1009e7:	88 55 b8             	mov    %dl,-0x48(%rbp)
            numbuf[1] = '\0';
  1009ea:	c6 45 b9 00          	movb   $0x0,-0x47(%rbp)
            data = numbuf;
  1009ee:	4c 8d 65 b8          	lea    -0x48(%rbp),%r12
        unsigned long num = 0;
  1009f2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  1009f8:	e9 96 fc ff ff       	jmpq   100693 <printer_vprintf+0x35a>
        int flags = 0;
  1009fd:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%rbp)
  100a04:	e9 b0 f9 ff ff       	jmpq   1003b9 <printer_vprintf+0x80>
}
  100a09:	48 83 c4 58          	add    $0x58,%rsp
  100a0d:	5b                   	pop    %rbx
  100a0e:	41 5c                	pop    %r12
  100a10:	41 5d                	pop    %r13
  100a12:	41 5e                	pop    %r14
  100a14:	41 5f                	pop    %r15
  100a16:	5d                   	pop    %rbp
  100a17:	c3                   	retq   

0000000000100a18 <console_vprintf>:
int console_vprintf(int cpos, int color, const char* format, va_list val) {
  100a18:	55                   	push   %rbp
  100a19:	48 89 e5             	mov    %rsp,%rbp
  100a1c:	48 83 ec 10          	sub    $0x10,%rsp
    cp.p.putc = console_putc;
  100a20:	48 c7 45 f0 23 01 10 	movq   $0x100123,-0x10(%rbp)
  100a27:	00 
        cpos = 0;
  100a28:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
  100a2e:	b8 00 00 00 00       	mov    $0x0,%eax
  100a33:	0f 43 f8             	cmovae %eax,%edi
    cp.cursor = console + cpos;
  100a36:	48 63 ff             	movslq %edi,%rdi
  100a39:	48 8d 84 3f 00 80 0b 	lea    0xb8000(%rdi,%rdi,1),%rax
  100a40:	00 
  100a41:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    printer_vprintf(&cp.p, color, format, val);
  100a45:	48 8d 7d f0          	lea    -0x10(%rbp),%rdi
  100a49:	e8 eb f8 ff ff       	callq  100339 <printer_vprintf>
    return cp.cursor - console;
  100a4e:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  100a52:	48 2d 00 80 0b 00    	sub    $0xb8000,%rax
  100a58:	48 d1 f8             	sar    %rax
}
  100a5b:	c9                   	leaveq 
  100a5c:	c3                   	retq   

0000000000100a5d <console_printf>:
int console_printf(int cpos, int color, const char* format, ...) {
  100a5d:	55                   	push   %rbp
  100a5e:	48 89 e5             	mov    %rsp,%rbp
  100a61:	48 83 ec 50          	sub    $0x50,%rsp
  100a65:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  100a69:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  100a6d:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(val, format);
  100a71:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  100a78:	48 8d 45 10          	lea    0x10(%rbp),%rax
  100a7c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  100a80:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  100a84:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    cpos = console_vprintf(cpos, color, format, val);
  100a88:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  100a8c:	e8 87 ff ff ff       	callq  100a18 <console_vprintf>
}
  100a91:	c9                   	leaveq 
  100a92:	c3                   	retq   

0000000000100a93 <vsnprintf>:

int vsnprintf(char* s, size_t size, const char* format, va_list val) {
  100a93:	55                   	push   %rbp
  100a94:	48 89 e5             	mov    %rsp,%rbp
  100a97:	53                   	push   %rbx
  100a98:	48 83 ec 28          	sub    $0x28,%rsp
  100a9c:	48 89 fb             	mov    %rdi,%rbx
    string_printer sp;
    sp.p.putc = string_putc;
  100a9f:	48 c7 45 d8 a9 01 10 	movq   $0x1001a9,-0x28(%rbp)
  100aa6:	00 
    sp.s = s;
  100aa7:	48 89 7d e0          	mov    %rdi,-0x20(%rbp)
    if (size) {
  100aab:	48 85 f6             	test   %rsi,%rsi
  100aae:	75 0b                	jne    100abb <vsnprintf+0x28>
        sp.end = s + size - 1;
        printer_vprintf(&sp.p, 0, format, val);
        *sp.s = 0;
    }
    return sp.s - s;
  100ab0:	8b 45 e0             	mov    -0x20(%rbp),%eax
  100ab3:	29 d8                	sub    %ebx,%eax
}
  100ab5:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  100ab9:	c9                   	leaveq 
  100aba:	c3                   	retq   
        sp.end = s + size - 1;
  100abb:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  100ac0:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
        printer_vprintf(&sp.p, 0, format, val);
  100ac4:	be 00 00 00 00       	mov    $0x0,%esi
  100ac9:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  100acd:	e8 67 f8 ff ff       	callq  100339 <printer_vprintf>
        *sp.s = 0;
  100ad2:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  100ad6:	c6 00 00             	movb   $0x0,(%rax)
  100ad9:	eb d5                	jmp    100ab0 <vsnprintf+0x1d>

0000000000100adb <snprintf>:

int snprintf(char* s, size_t size, const char* format, ...) {
  100adb:	55                   	push   %rbp
  100adc:	48 89 e5             	mov    %rsp,%rbp
  100adf:	48 83 ec 50          	sub    $0x50,%rsp
  100ae3:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  100ae7:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  100aeb:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list val;
    va_start(val, format);
  100aef:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  100af6:	48 8d 45 10          	lea    0x10(%rbp),%rax
  100afa:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  100afe:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  100b02:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int n = vsnprintf(s, size, format, val);
  100b06:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  100b0a:	e8 84 ff ff ff       	callq  100a93 <vsnprintf>
    va_end(val);
    return n;
}
  100b0f:	c9                   	leaveq 
  100b10:	c3                   	retq   

0000000000100b11 <console_clear>:

// console_clear
//    Erases the console and moves the cursor to the upper left (CPOS(0, 0)).

void console_clear(void) {
    for (int i = 0; i < CONSOLE_ROWS * CONSOLE_COLUMNS; ++i) {
  100b11:	b8 00 80 0b 00       	mov    $0xb8000,%eax
  100b16:	ba a0 8f 0b 00       	mov    $0xb8fa0,%edx
        console[i] = ' ' | 0x0700;
  100b1b:	66 c7 00 20 07       	movw   $0x720,(%rax)
    for (int i = 0; i < CONSOLE_ROWS * CONSOLE_COLUMNS; ++i) {
  100b20:	48 83 c0 02          	add    $0x2,%rax
  100b24:	48 39 d0             	cmp    %rdx,%rax
  100b27:	75 f2                	jne    100b1b <console_clear+0xa>
    }
    cursorpos = 0;
  100b29:	c7 05 c9 84 fb ff 00 	movl   $0x0,-0x47b37(%rip)        # b8ffc <cursorpos>
  100b30:	00 00 00 
}
  100b33:	c3                   	retq   

0000000000100b34 <app_printf>:
#include "process.h"

// app_printf
//     A version of console_printf that picks a sensible color by process ID.

void app_printf(int colorid, const char* format, ...) {
  100b34:	55                   	push   %rbp
  100b35:	48 89 e5             	mov    %rsp,%rbp
  100b38:	48 83 ec 50          	sub    $0x50,%rsp
  100b3c:	49 89 f2             	mov    %rsi,%r10
  100b3f:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  100b43:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  100b47:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  100b4b:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    int color;
    if (colorid < 0) {
        color = 0x0700;
  100b4f:	be 00 07 00 00       	mov    $0x700,%esi
    if (colorid < 0) {
  100b54:	85 ff                	test   %edi,%edi
  100b56:	78 2e                	js     100b86 <app_printf+0x52>
    } else {
        static const uint8_t col[] = { 0x0E, 0x0F, 0x0C, 0x0A, 0x09 };
        color = col[colorid % sizeof(col)] << 8;
  100b58:	48 63 ff             	movslq %edi,%rdi
  100b5b:	48 ba cd cc cc cc cc 	movabs $0xcccccccccccccccd,%rdx
  100b62:	cc cc cc 
  100b65:	48 89 f8             	mov    %rdi,%rax
  100b68:	48 f7 e2             	mul    %rdx
  100b6b:	48 89 d0             	mov    %rdx,%rax
  100b6e:	48 c1 e8 02          	shr    $0x2,%rax
  100b72:	48 83 e2 fc          	and    $0xfffffffffffffffc,%rdx
  100b76:	48 01 c2             	add    %rax,%rdx
  100b79:	48 29 d7             	sub    %rdx,%rdi
  100b7c:	0f b6 b7 9d 0f 10 00 	movzbl 0x100f9d(%rdi),%esi
  100b83:	c1 e6 08             	shl    $0x8,%esi
    }

    va_list val;
    va_start(val, format);
  100b86:	c7 45 b8 10 00 00 00 	movl   $0x10,-0x48(%rbp)
  100b8d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  100b91:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  100b95:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  100b99:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    cursorpos = console_vprintf(cursorpos, color, format, val);
  100b9d:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  100ba1:	4c 89 d2             	mov    %r10,%rdx
  100ba4:	8b 3d 52 84 fb ff    	mov    -0x47bae(%rip),%edi        # b8ffc <cursorpos>
  100baa:	e8 69 fe ff ff       	callq  100a18 <console_vprintf>
    va_end(val);

    if (CROW(cursorpos) >= 23) {
        cursorpos = CPOS(0, 0);
  100baf:	3d 30 07 00 00       	cmp    $0x730,%eax
  100bb4:	ba 00 00 00 00       	mov    $0x0,%edx
  100bb9:	0f 4d c2             	cmovge %edx,%eax
  100bbc:	89 05 3a 84 fb ff    	mov    %eax,-0x47bc6(%rip)        # b8ffc <cursorpos>
    }
}
  100bc2:	c9                   	leaveq 
  100bc3:	c3                   	retq   

0000000000100bc4 <kernel_panic>:


// kernel_panic, assert_fail
//     Call the INT_SYS_PANIC system call so the kernel loops until Control-C.

void kernel_panic(const char* format, ...) {
  100bc4:	55                   	push   %rbp
  100bc5:	48 89 e5             	mov    %rsp,%rbp
  100bc8:	53                   	push   %rbx
  100bc9:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  100bd0:	48 89 fb             	mov    %rdi,%rbx
  100bd3:	48 89 75 c8          	mov    %rsi,-0x38(%rbp)
  100bd7:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  100bdb:	48 89 4d d8          	mov    %rcx,-0x28(%rbp)
  100bdf:	4c 89 45 e0          	mov    %r8,-0x20(%rbp)
  100be3:	4c 89 4d e8          	mov    %r9,-0x18(%rbp)
    va_list val;
    va_start(val, format);
  100be7:	c7 45 a8 08 00 00 00 	movl   $0x8,-0x58(%rbp)
  100bee:	48 8d 45 10          	lea    0x10(%rbp),%rax
  100bf2:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  100bf6:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
  100bfa:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
    char buf[160];
    memcpy(buf, "PANIC: ", 7);
  100bfe:	ba 07 00 00 00       	mov    $0x7,%edx
  100c03:	be 67 0f 10 00       	mov    $0x100f67,%esi
  100c08:	48 8d bd 08 ff ff ff 	lea    -0xf8(%rbp),%rdi
  100c0f:	e8 ab f5 ff ff       	callq  1001bf <memcpy>
    int len = vsnprintf(&buf[7], sizeof(buf) - 7, format, val) + 7;
  100c14:	48 8d 4d a8          	lea    -0x58(%rbp),%rcx
  100c18:	48 89 da             	mov    %rbx,%rdx
  100c1b:	be 99 00 00 00       	mov    $0x99,%esi
  100c20:	48 8d bd 0f ff ff ff 	lea    -0xf1(%rbp),%rdi
  100c27:	e8 67 fe ff ff       	callq  100a93 <vsnprintf>
  100c2c:	8d 50 07             	lea    0x7(%rax),%edx
    va_end(val);
    if (len > 0 && buf[len - 1] != '\n') {
  100c2f:	85 d2                	test   %edx,%edx
  100c31:	7e 0f                	jle    100c42 <kernel_panic+0x7e>
  100c33:	83 c0 06             	add    $0x6,%eax
  100c36:	48 98                	cltq   
  100c38:	80 bc 05 08 ff ff ff 	cmpb   $0xa,-0xf8(%rbp,%rax,1)
  100c3f:	0a 
  100c40:	75 2a                	jne    100c6c <kernel_panic+0xa8>
        strcpy(buf + len - (len == (int) sizeof(buf) - 1), "\n");
    }
    (void) console_printf(CPOS(23, 0), 0xC000, "%s", buf);
  100c42:	48 8d 9d 08 ff ff ff 	lea    -0xf8(%rbp),%rbx
  100c49:	48 89 d9             	mov    %rbx,%rcx
  100c4c:	ba 71 0f 10 00       	mov    $0x100f71,%edx
  100c51:	be 00 c0 00 00       	mov    $0xc000,%esi
  100c56:	bf 30 07 00 00       	mov    $0x730,%edi
  100c5b:	b8 00 00 00 00       	mov    $0x0,%eax
  100c60:	e8 f8 fd ff ff       	callq  100a5d <console_printf>
    asm volatile ("int %0" : /* no result */
  100c65:	48 89 df             	mov    %rbx,%rdi
  100c68:	cd 30                	int    $0x30
 loop: goto loop;
  100c6a:	eb fe                	jmp    100c6a <kernel_panic+0xa6>
        strcpy(buf + len - (len == (int) sizeof(buf) - 1), "\n");
  100c6c:	48 63 c2             	movslq %edx,%rax
  100c6f:	81 fa 9f 00 00 00    	cmp    $0x9f,%edx
  100c75:	0f 94 c2             	sete   %dl
  100c78:	0f b6 d2             	movzbl %dl,%edx
  100c7b:	48 29 d0             	sub    %rdx,%rax
  100c7e:	48 8d bc 05 08 ff ff 	lea    -0xf8(%rbp,%rax,1),%rdi
  100c85:	ff 
  100c86:	be 6f 0f 10 00       	mov    $0x100f6f,%esi
  100c8b:	e8 f1 f5 ff ff       	callq  100281 <strcpy>
  100c90:	eb b0                	jmp    100c42 <kernel_panic+0x7e>

0000000000100c92 <assert_fail>:
    panic(buf);
 spinloop: goto spinloop;       // should never get here
}

void assert_fail(const char* file, int line, const char* msg) {
  100c92:	55                   	push   %rbp
  100c93:	48 89 e5             	mov    %rsp,%rbp
  100c96:	48 89 f9             	mov    %rdi,%rcx
  100c99:	41 89 f0             	mov    %esi,%r8d
  100c9c:	49 89 d1             	mov    %rdx,%r9
    (void) console_printf(CPOS(23, 0), 0xC000,
  100c9f:	ba 78 0f 10 00       	mov    $0x100f78,%edx
  100ca4:	be 00 c0 00 00       	mov    $0xc000,%esi
  100ca9:	bf 30 07 00 00       	mov    $0x730,%edi
  100cae:	b8 00 00 00 00       	mov    $0x0,%eax
  100cb3:	e8 a5 fd ff ff       	callq  100a5d <console_printf>
    asm volatile ("int %0" : /* no result */
  100cb8:	bf 00 00 00 00       	mov    $0x0,%edi
  100cbd:	cd 30                	int    $0x30
 loop: goto loop;
  100cbf:	eb fe                	jmp    100cbf <assert_fail+0x2d>
