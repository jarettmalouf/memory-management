
obj/p-test.full:     file format elf64-x86-64


Disassembly of section .text:

0000000000100000 <process_main>:
uint8_t *heap_bottom;
uint8_t *stack_bottom;



void process_main(void) {
  100000:	55                   	push   %rbp
  100001:	48 89 e5             	mov    %rsp,%rbp
  100004:	41 54                	push   %r12
  100006:	53                   	push   %rbx

// getpid
//    Return current process ID.
static inline pid_t getpid(void) {
    pid_t result;
    asm volatile ("int %1" : "=a" (result)
  100007:	cd 31                	int    $0x31
  100009:	89 c7                	mov    %eax,%edi
    pid_t p = getpid();
    srand(p);
  10000b:	e8 90 02 00 00       	callq  1002a0 <srand>
    heap_bottom = heap_top = ROUNDUP((uint8_t*) end, PAGESIZE);
  100010:	b8 57 30 10 00       	mov    $0x103057,%eax
  100015:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  10001b:	48 89 05 ee 1f 00 00 	mov    %rax,0x1fee(%rip)        # 102010 <heap_top>
  100022:	48 89 05 df 1f 00 00 	mov    %rax,0x1fdf(%rip)        # 102008 <heap_bottom>
    return rbp;
}

static inline uintptr_t read_rsp(void) {
    uintptr_t rsp;
    asm volatile("movq %%rsp,%0" : "=r" (rsp));
  100029:	48 89 e0             	mov    %rsp,%rax
    stack_bottom = ROUNDDOWN((uint8_t*) read_rsp() - 1, PAGESIZE);
  10002c:	48 83 e8 01          	sub    $0x1,%rax
  100030:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  100036:	48 89 05 c3 1f 00 00 	mov    %rax,0x1fc3(%rip)        # 102000 <stack_bottom>
  10003d:	41 bc 01 00 00 00    	mov    $0x1,%r12d

    /* Single elements on heap of varying sizes */
    for(int i = 1; i < 512; ++i) {
        void *ptr = malloc(i);
  100043:	4c 89 e7             	mov    %r12,%rdi
  100046:	e8 77 11 00 00       	callq  1011c2 <malloc>
  10004b:	48 89 c3             	mov    %rax,%rbx
        assert(ptr != NULL);
  10004e:	48 85 c0             	test   %rax,%rax
  100051:	74 34                	je     100087 <process_main+0x87>

        /* Check that we can write */
        memset(ptr, 'A', i);
  100053:	4c 89 e2             	mov    %r12,%rdx
  100056:	be 41 00 00 00       	mov    $0x41,%esi
  10005b:	48 89 c7             	mov    %rax,%rdi
  10005e:	e8 3d 01 00 00       	callq  1001a0 <memset>
        free(ptr);
  100063:	48 89 df             	mov    %rbx,%rdi
  100066:	e8 41 12 00 00       	callq  1012ac <free>
    for(int i = 1; i < 512; ++i) {
  10006b:	49 83 c4 01          	add    $0x1,%r12
  10006f:	49 81 fc 00 02 00 00 	cmp    $0x200,%r12
  100076:	75 cb                	jne    100043 <process_main+0x43>
    }

    TEST_PASS();
  100078:	bf 55 17 10 00       	mov    $0x101755,%edi
  10007d:	b8 00 00 00 00       	mov    $0x0,%eax
  100082:	e8 b3 15 00 00       	callq  10163a <kernel_panic>
        assert(ptr != NULL);
  100087:	ba 40 17 10 00       	mov    $0x101740,%edx
  10008c:	be 19 00 00 00       	mov    $0x19,%esi
  100091:	bf 4c 17 10 00       	mov    $0x10174c,%edi
  100096:	e8 6d 16 00 00       	callq  101708 <assert_fail>

000000000010009b <console_putc>:
typedef struct console_printer {
    printer p;
    uint16_t* cursor;
} console_printer;

static void console_putc(printer* p, unsigned char c, int color) {
  10009b:	48 89 f9             	mov    %rdi,%rcx
  10009e:	89 d7                	mov    %edx,%edi
    console_printer* cp = (console_printer*) p;
    if (cp->cursor >= console + CONSOLE_ROWS * CONSOLE_COLUMNS) {
  1000a0:	48 81 79 08 a0 8f 0b 	cmpq   $0xb8fa0,0x8(%rcx)
  1000a7:	00 
  1000a8:	72 08                	jb     1000b2 <console_putc+0x17>
        cp->cursor = console;
  1000aa:	48 c7 41 08 00 80 0b 	movq   $0xb8000,0x8(%rcx)
  1000b1:	00 
    }
    if (c == '\n') {
  1000b2:	40 80 fe 0a          	cmp    $0xa,%sil
  1000b6:	74 16                	je     1000ce <console_putc+0x33>
        int pos = (cp->cursor - console) % 80;
        for (; pos != 80; pos++) {
            *cp->cursor++ = ' ' | color;
        }
    } else {
        *cp->cursor++ = c | color;
  1000b8:	48 8b 41 08          	mov    0x8(%rcx),%rax
  1000bc:	48 8d 50 02          	lea    0x2(%rax),%rdx
  1000c0:	48 89 51 08          	mov    %rdx,0x8(%rcx)
  1000c4:	40 0f b6 f6          	movzbl %sil,%esi
  1000c8:	09 fe                	or     %edi,%esi
  1000ca:	66 89 30             	mov    %si,(%rax)
    }
}
  1000cd:	c3                   	retq   
        int pos = (cp->cursor - console) % 80;
  1000ce:	4c 8b 41 08          	mov    0x8(%rcx),%r8
  1000d2:	49 81 e8 00 80 0b 00 	sub    $0xb8000,%r8
  1000d9:	4c 89 c6             	mov    %r8,%rsi
  1000dc:	48 d1 fe             	sar    %rsi
  1000df:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
  1000e6:	66 66 66 
  1000e9:	48 89 f0             	mov    %rsi,%rax
  1000ec:	48 f7 ea             	imul   %rdx
  1000ef:	48 c1 fa 05          	sar    $0x5,%rdx
  1000f3:	49 c1 f8 3f          	sar    $0x3f,%r8
  1000f7:	4c 29 c2             	sub    %r8,%rdx
  1000fa:	48 8d 14 92          	lea    (%rdx,%rdx,4),%rdx
  1000fe:	48 c1 e2 04          	shl    $0x4,%rdx
  100102:	89 f0                	mov    %esi,%eax
  100104:	29 d0                	sub    %edx,%eax
            *cp->cursor++ = ' ' | color;
  100106:	83 cf 20             	or     $0x20,%edi
  100109:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  10010d:	48 8d 72 02          	lea    0x2(%rdx),%rsi
  100111:	48 89 71 08          	mov    %rsi,0x8(%rcx)
  100115:	66 89 3a             	mov    %di,(%rdx)
        for (; pos != 80; pos++) {
  100118:	83 c0 01             	add    $0x1,%eax
  10011b:	83 f8 50             	cmp    $0x50,%eax
  10011e:	75 e9                	jne    100109 <console_putc+0x6e>
  100120:	c3                   	retq   

0000000000100121 <string_putc>:
    char* end;
} string_printer;

static void string_putc(printer* p, unsigned char c, int color) {
    string_printer* sp = (string_printer*) p;
    if (sp->s < sp->end) {
  100121:	48 8b 47 08          	mov    0x8(%rdi),%rax
  100125:	48 3b 47 10          	cmp    0x10(%rdi),%rax
  100129:	73 0b                	jae    100136 <string_putc+0x15>
        *sp->s++ = c;
  10012b:	48 8d 50 01          	lea    0x1(%rax),%rdx
  10012f:	48 89 57 08          	mov    %rdx,0x8(%rdi)
  100133:	40 88 30             	mov    %sil,(%rax)
    }
    (void) color;
}
  100136:	c3                   	retq   

0000000000100137 <memcpy>:
void* memcpy(void* dst, const void* src, size_t n) {
  100137:	48 89 f8             	mov    %rdi,%rax
    for (char* d = (char*) dst; n > 0; --n, ++s, ++d) {
  10013a:	48 85 d2             	test   %rdx,%rdx
  10013d:	74 17                	je     100156 <memcpy+0x1f>
  10013f:	b9 00 00 00 00       	mov    $0x0,%ecx
        *d = *s;
  100144:	44 0f b6 04 0e       	movzbl (%rsi,%rcx,1),%r8d
  100149:	44 88 04 08          	mov    %r8b,(%rax,%rcx,1)
    for (char* d = (char*) dst; n > 0; --n, ++s, ++d) {
  10014d:	48 83 c1 01          	add    $0x1,%rcx
  100151:	48 39 d1             	cmp    %rdx,%rcx
  100154:	75 ee                	jne    100144 <memcpy+0xd>
}
  100156:	c3                   	retq   

0000000000100157 <memmove>:
void* memmove(void* dst, const void* src, size_t n) {
  100157:	48 89 f8             	mov    %rdi,%rax
    if (s < d && s + n > d) {
  10015a:	48 39 fe             	cmp    %rdi,%rsi
  10015d:	72 1d                	jb     10017c <memmove+0x25>
        while (n-- > 0) {
  10015f:	b9 00 00 00 00       	mov    $0x0,%ecx
  100164:	48 85 d2             	test   %rdx,%rdx
  100167:	74 12                	je     10017b <memmove+0x24>
            *d++ = *s++;
  100169:	0f b6 3c 0e          	movzbl (%rsi,%rcx,1),%edi
  10016d:	40 88 3c 08          	mov    %dil,(%rax,%rcx,1)
        while (n-- > 0) {
  100171:	48 83 c1 01          	add    $0x1,%rcx
  100175:	48 39 ca             	cmp    %rcx,%rdx
  100178:	75 ef                	jne    100169 <memmove+0x12>
}
  10017a:	c3                   	retq   
  10017b:	c3                   	retq   
    if (s < d && s + n > d) {
  10017c:	48 8d 0c 16          	lea    (%rsi,%rdx,1),%rcx
  100180:	48 39 cf             	cmp    %rcx,%rdi
  100183:	73 da                	jae    10015f <memmove+0x8>
        while (n-- > 0) {
  100185:	48 8d 4a ff          	lea    -0x1(%rdx),%rcx
  100189:	48 85 d2             	test   %rdx,%rdx
  10018c:	74 ec                	je     10017a <memmove+0x23>
            *--d = *--s;
  10018e:	0f b6 14 0e          	movzbl (%rsi,%rcx,1),%edx
  100192:	88 14 08             	mov    %dl,(%rax,%rcx,1)
        while (n-- > 0) {
  100195:	48 83 e9 01          	sub    $0x1,%rcx
  100199:	48 83 f9 ff          	cmp    $0xffffffffffffffff,%rcx
  10019d:	75 ef                	jne    10018e <memmove+0x37>
  10019f:	c3                   	retq   

00000000001001a0 <memset>:
void* memset(void* v, int c, size_t n) {
  1001a0:	48 89 f8             	mov    %rdi,%rax
    for (char* p = (char*) v; n > 0; ++p, --n) {
  1001a3:	48 85 d2             	test   %rdx,%rdx
  1001a6:	74 12                	je     1001ba <memset+0x1a>
  1001a8:	48 01 fa             	add    %rdi,%rdx
  1001ab:	48 89 f9             	mov    %rdi,%rcx
        *p = c;
  1001ae:	40 88 31             	mov    %sil,(%rcx)
    for (char* p = (char*) v; n > 0; ++p, --n) {
  1001b1:	48 83 c1 01          	add    $0x1,%rcx
  1001b5:	48 39 ca             	cmp    %rcx,%rdx
  1001b8:	75 f4                	jne    1001ae <memset+0xe>
}
  1001ba:	c3                   	retq   

00000000001001bb <strlen>:
    for (n = 0; *s != '\0'; ++s) {
  1001bb:	80 3f 00             	cmpb   $0x0,(%rdi)
  1001be:	74 10                	je     1001d0 <strlen+0x15>
  1001c0:	b8 00 00 00 00       	mov    $0x0,%eax
        ++n;
  1001c5:	48 83 c0 01          	add    $0x1,%rax
    for (n = 0; *s != '\0'; ++s) {
  1001c9:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  1001cd:	75 f6                	jne    1001c5 <strlen+0xa>
  1001cf:	c3                   	retq   
  1001d0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1001d5:	c3                   	retq   

00000000001001d6 <strnlen>:
size_t strnlen(const char* s, size_t maxlen) {
  1001d6:	48 89 f0             	mov    %rsi,%rax
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
  1001d9:	ba 00 00 00 00       	mov    $0x0,%edx
  1001de:	48 85 f6             	test   %rsi,%rsi
  1001e1:	74 11                	je     1001f4 <strnlen+0x1e>
  1001e3:	80 3c 17 00          	cmpb   $0x0,(%rdi,%rdx,1)
  1001e7:	74 0c                	je     1001f5 <strnlen+0x1f>
        ++n;
  1001e9:	48 83 c2 01          	add    $0x1,%rdx
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
  1001ed:	48 39 d0             	cmp    %rdx,%rax
  1001f0:	75 f1                	jne    1001e3 <strnlen+0xd>
  1001f2:	eb 04                	jmp    1001f8 <strnlen+0x22>
  1001f4:	c3                   	retq   
  1001f5:	48 89 d0             	mov    %rdx,%rax
}
  1001f8:	c3                   	retq   

00000000001001f9 <strcpy>:
char* strcpy(char* dst, const char* src) {
  1001f9:	48 89 f8             	mov    %rdi,%rax
  1001fc:	ba 00 00 00 00       	mov    $0x0,%edx
        *d++ = *src++;
  100201:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
  100205:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
    } while (d[-1]);
  100208:	48 83 c2 01          	add    $0x1,%rdx
  10020c:	84 c9                	test   %cl,%cl
  10020e:	75 f1                	jne    100201 <strcpy+0x8>
}
  100210:	c3                   	retq   

0000000000100211 <strcmp>:
    while (*a && *b && *a == *b) {
  100211:	0f b6 07             	movzbl (%rdi),%eax
  100214:	84 c0                	test   %al,%al
  100216:	74 1a                	je     100232 <strcmp+0x21>
  100218:	0f b6 16             	movzbl (%rsi),%edx
  10021b:	38 c2                	cmp    %al,%dl
  10021d:	75 13                	jne    100232 <strcmp+0x21>
  10021f:	84 d2                	test   %dl,%dl
  100221:	74 0f                	je     100232 <strcmp+0x21>
        ++a, ++b;
  100223:	48 83 c7 01          	add    $0x1,%rdi
  100227:	48 83 c6 01          	add    $0x1,%rsi
    while (*a && *b && *a == *b) {
  10022b:	0f b6 07             	movzbl (%rdi),%eax
  10022e:	84 c0                	test   %al,%al
  100230:	75 e6                	jne    100218 <strcmp+0x7>
    return ((unsigned char) *a > (unsigned char) *b)
  100232:	3a 06                	cmp    (%rsi),%al
  100234:	0f 97 c0             	seta   %al
  100237:	0f b6 c0             	movzbl %al,%eax
        - ((unsigned char) *a < (unsigned char) *b);
  10023a:	83 d8 00             	sbb    $0x0,%eax
}
  10023d:	c3                   	retq   

000000000010023e <strchr>:
    while (*s && *s != (char) c) {
  10023e:	0f b6 07             	movzbl (%rdi),%eax
  100241:	84 c0                	test   %al,%al
  100243:	74 10                	je     100255 <strchr+0x17>
  100245:	40 38 f0             	cmp    %sil,%al
  100248:	74 18                	je     100262 <strchr+0x24>
        ++s;
  10024a:	48 83 c7 01          	add    $0x1,%rdi
    while (*s && *s != (char) c) {
  10024e:	0f b6 07             	movzbl (%rdi),%eax
  100251:	84 c0                	test   %al,%al
  100253:	75 f0                	jne    100245 <strchr+0x7>
        return NULL;
  100255:	40 84 f6             	test   %sil,%sil
  100258:	b8 00 00 00 00       	mov    $0x0,%eax
  10025d:	48 0f 44 c7          	cmove  %rdi,%rax
}
  100261:	c3                   	retq   
  100262:	48 89 f8             	mov    %rdi,%rax
  100265:	c3                   	retq   

0000000000100266 <rand>:
    if (!rand_seed_set) {
  100266:	83 3d af 1d 00 00 00 	cmpl   $0x0,0x1daf(%rip)        # 10201c <rand_seed_set>
  10026d:	74 1b                	je     10028a <rand+0x24>
    rand_seed = rand_seed * 1664525U + 1013904223U;
  10026f:	69 05 9f 1d 00 00 0d 	imul   $0x19660d,0x1d9f(%rip),%eax        # 102018 <rand_seed>
  100276:	66 19 00 
  100279:	05 5f f3 6e 3c       	add    $0x3c6ef35f,%eax
  10027e:	89 05 94 1d 00 00    	mov    %eax,0x1d94(%rip)        # 102018 <rand_seed>
    return rand_seed & RAND_MAX;
  100284:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
}
  100289:	c3                   	retq   
    rand_seed = seed;
  10028a:	c7 05 84 1d 00 00 9e 	movl   $0x30d4879e,0x1d84(%rip)        # 102018 <rand_seed>
  100291:	87 d4 30 
    rand_seed_set = 1;
  100294:	c7 05 7e 1d 00 00 01 	movl   $0x1,0x1d7e(%rip)        # 10201c <rand_seed_set>
  10029b:	00 00 00 
}
  10029e:	eb cf                	jmp    10026f <rand+0x9>

00000000001002a0 <srand>:
    rand_seed = seed;
  1002a0:	89 3d 72 1d 00 00    	mov    %edi,0x1d72(%rip)        # 102018 <rand_seed>
    rand_seed_set = 1;
  1002a6:	c7 05 6c 1d 00 00 01 	movl   $0x1,0x1d6c(%rip)        # 10201c <rand_seed_set>
  1002ad:	00 00 00 
}
  1002b0:	c3                   	retq   

00000000001002b1 <printer_vprintf>:
void printer_vprintf(printer* p, int color, const char* format, va_list val) {
  1002b1:	55                   	push   %rbp
  1002b2:	48 89 e5             	mov    %rsp,%rbp
  1002b5:	41 57                	push   %r15
  1002b7:	41 56                	push   %r14
  1002b9:	41 55                	push   %r13
  1002bb:	41 54                	push   %r12
  1002bd:	53                   	push   %rbx
  1002be:	48 83 ec 58          	sub    $0x58,%rsp
  1002c2:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
    for (; *format; ++format) {
  1002c6:	0f b6 02             	movzbl (%rdx),%eax
  1002c9:	84 c0                	test   %al,%al
  1002cb:	0f 84 b0 06 00 00    	je     100981 <printer_vprintf+0x6d0>
  1002d1:	49 89 fe             	mov    %rdi,%r14
  1002d4:	49 89 d4             	mov    %rdx,%r12
            length = 1;
  1002d7:	41 89 f7             	mov    %esi,%r15d
  1002da:	e9 a4 04 00 00       	jmpq   100783 <printer_vprintf+0x4d2>
        for (++format; *format; ++format) {
  1002df:	49 8d 5c 24 01       	lea    0x1(%r12),%rbx
  1002e4:	45 0f b6 64 24 01    	movzbl 0x1(%r12),%r12d
  1002ea:	45 84 e4             	test   %r12b,%r12b
  1002ed:	0f 84 82 06 00 00    	je     100975 <printer_vprintf+0x6c4>
        int flags = 0;
  1002f3:	41 bd 00 00 00 00    	mov    $0x0,%r13d
            const char* flagc = strchr(flag_chars, *format);
  1002f9:	41 0f be f4          	movsbl %r12b,%esi
  1002fd:	bf 71 19 10 00       	mov    $0x101971,%edi
  100302:	e8 37 ff ff ff       	callq  10023e <strchr>
  100307:	48 89 c1             	mov    %rax,%rcx
            if (flagc) {
  10030a:	48 85 c0             	test   %rax,%rax
  10030d:	74 55                	je     100364 <printer_vprintf+0xb3>
                flags |= 1 << (flagc - flag_chars);
  10030f:	48 81 e9 71 19 10 00 	sub    $0x101971,%rcx
  100316:	b8 01 00 00 00       	mov    $0x1,%eax
  10031b:	d3 e0                	shl    %cl,%eax
  10031d:	41 09 c5             	or     %eax,%r13d
        for (++format; *format; ++format) {
  100320:	48 83 c3 01          	add    $0x1,%rbx
  100324:	44 0f b6 23          	movzbl (%rbx),%r12d
  100328:	45 84 e4             	test   %r12b,%r12b
  10032b:	75 cc                	jne    1002f9 <printer_vprintf+0x48>
  10032d:	44 89 6d a8          	mov    %r13d,-0x58(%rbp)
        int width = -1;
  100331:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
        int precision = -1;
  100337:	c7 45 9c ff ff ff ff 	movl   $0xffffffff,-0x64(%rbp)
        if (*format == '.') {
  10033e:	80 3b 2e             	cmpb   $0x2e,(%rbx)
  100341:	0f 84 a9 00 00 00    	je     1003f0 <printer_vprintf+0x13f>
        int length = 0;
  100347:	b9 00 00 00 00       	mov    $0x0,%ecx
        switch (*format) {
  10034c:	0f b6 13             	movzbl (%rbx),%edx
  10034f:	8d 42 bd             	lea    -0x43(%rdx),%eax
  100352:	3c 37                	cmp    $0x37,%al
  100354:	0f 87 c4 04 00 00    	ja     10081e <printer_vprintf+0x56d>
  10035a:	0f b6 c0             	movzbl %al,%eax
  10035d:	ff 24 c5 80 17 10 00 	jmpq   *0x101780(,%rax,8)
        if (*format >= '1' && *format <= '9') {
  100364:	44 89 6d a8          	mov    %r13d,-0x58(%rbp)
  100368:	41 8d 44 24 cf       	lea    -0x31(%r12),%eax
  10036d:	3c 08                	cmp    $0x8,%al
  10036f:	77 2f                	ja     1003a0 <printer_vprintf+0xef>
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  100371:	0f b6 03             	movzbl (%rbx),%eax
  100374:	8d 50 d0             	lea    -0x30(%rax),%edx
  100377:	80 fa 09             	cmp    $0x9,%dl
  10037a:	77 5e                	ja     1003da <printer_vprintf+0x129>
  10037c:	41 bd 00 00 00 00    	mov    $0x0,%r13d
                width = 10 * width + *format++ - '0';
  100382:	48 83 c3 01          	add    $0x1,%rbx
  100386:	43 8d 54 ad 00       	lea    0x0(%r13,%r13,4),%edx
  10038b:	0f be c0             	movsbl %al,%eax
  10038e:	44 8d 6c 50 d0       	lea    -0x30(%rax,%rdx,2),%r13d
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  100393:	0f b6 03             	movzbl (%rbx),%eax
  100396:	8d 50 d0             	lea    -0x30(%rax),%edx
  100399:	80 fa 09             	cmp    $0x9,%dl
  10039c:	76 e4                	jbe    100382 <printer_vprintf+0xd1>
  10039e:	eb 97                	jmp    100337 <printer_vprintf+0x86>
        } else if (*format == '*') {
  1003a0:	41 80 fc 2a          	cmp    $0x2a,%r12b
  1003a4:	75 3f                	jne    1003e5 <printer_vprintf+0x134>
            width = va_arg(val, int);
  1003a6:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1003aa:	8b 07                	mov    (%rdi),%eax
  1003ac:	83 f8 2f             	cmp    $0x2f,%eax
  1003af:	77 17                	ja     1003c8 <printer_vprintf+0x117>
  1003b1:	89 c2                	mov    %eax,%edx
  1003b3:	48 03 57 10          	add    0x10(%rdi),%rdx
  1003b7:	83 c0 08             	add    $0x8,%eax
  1003ba:	89 07                	mov    %eax,(%rdi)
  1003bc:	44 8b 2a             	mov    (%rdx),%r13d
            ++format;
  1003bf:	48 83 c3 01          	add    $0x1,%rbx
  1003c3:	e9 6f ff ff ff       	jmpq   100337 <printer_vprintf+0x86>
            width = va_arg(val, int);
  1003c8:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1003cc:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  1003d0:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1003d4:	48 89 41 08          	mov    %rax,0x8(%rcx)
  1003d8:	eb e2                	jmp    1003bc <printer_vprintf+0x10b>
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  1003da:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  1003e0:	e9 52 ff ff ff       	jmpq   100337 <printer_vprintf+0x86>
        int width = -1;
  1003e5:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  1003eb:	e9 47 ff ff ff       	jmpq   100337 <printer_vprintf+0x86>
            ++format;
  1003f0:	48 8d 53 01          	lea    0x1(%rbx),%rdx
            if (*format >= '0' && *format <= '9') {
  1003f4:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  1003f8:	8d 48 d0             	lea    -0x30(%rax),%ecx
  1003fb:	80 f9 09             	cmp    $0x9,%cl
  1003fe:	76 13                	jbe    100413 <printer_vprintf+0x162>
            } else if (*format == '*') {
  100400:	3c 2a                	cmp    $0x2a,%al
  100402:	74 33                	je     100437 <printer_vprintf+0x186>
            ++format;
  100404:	48 89 d3             	mov    %rdx,%rbx
                precision = 0;
  100407:	c7 45 9c 00 00 00 00 	movl   $0x0,-0x64(%rbp)
  10040e:	e9 34 ff ff ff       	jmpq   100347 <printer_vprintf+0x96>
                for (precision = 0; *format >= '0' && *format <= '9'; ) {
  100413:	b9 00 00 00 00       	mov    $0x0,%ecx
                    precision = 10 * precision + *format++ - '0';
  100418:	48 83 c2 01          	add    $0x1,%rdx
  10041c:	8d 0c 89             	lea    (%rcx,%rcx,4),%ecx
  10041f:	0f be c0             	movsbl %al,%eax
  100422:	8d 4c 48 d0          	lea    -0x30(%rax,%rcx,2),%ecx
                for (precision = 0; *format >= '0' && *format <= '9'; ) {
  100426:	0f b6 02             	movzbl (%rdx),%eax
  100429:	8d 70 d0             	lea    -0x30(%rax),%esi
  10042c:	40 80 fe 09          	cmp    $0x9,%sil
  100430:	76 e6                	jbe    100418 <printer_vprintf+0x167>
                    precision = 10 * precision + *format++ - '0';
  100432:	48 89 d3             	mov    %rdx,%rbx
  100435:	eb 1c                	jmp    100453 <printer_vprintf+0x1a2>
                precision = va_arg(val, int);
  100437:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  10043b:	8b 07                	mov    (%rdi),%eax
  10043d:	83 f8 2f             	cmp    $0x2f,%eax
  100440:	77 23                	ja     100465 <printer_vprintf+0x1b4>
  100442:	89 c2                	mov    %eax,%edx
  100444:	48 03 57 10          	add    0x10(%rdi),%rdx
  100448:	83 c0 08             	add    $0x8,%eax
  10044b:	89 07                	mov    %eax,(%rdi)
  10044d:	8b 0a                	mov    (%rdx),%ecx
                ++format;
  10044f:	48 83 c3 02          	add    $0x2,%rbx
            if (precision < 0) {
  100453:	85 c9                	test   %ecx,%ecx
  100455:	b8 00 00 00 00       	mov    $0x0,%eax
  10045a:	0f 49 c1             	cmovns %ecx,%eax
  10045d:	89 45 9c             	mov    %eax,-0x64(%rbp)
  100460:	e9 e2 fe ff ff       	jmpq   100347 <printer_vprintf+0x96>
                precision = va_arg(val, int);
  100465:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  100469:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  10046d:	48 8d 42 08          	lea    0x8(%rdx),%rax
  100471:	48 89 41 08          	mov    %rax,0x8(%rcx)
  100475:	eb d6                	jmp    10044d <printer_vprintf+0x19c>
        switch (*format) {
  100477:	be f0 ff ff ff       	mov    $0xfffffff0,%esi
  10047c:	e9 f3 00 00 00       	jmpq   100574 <printer_vprintf+0x2c3>
            ++format;
  100481:	48 83 c3 01          	add    $0x1,%rbx
            length = 1;
  100485:	b9 01 00 00 00       	mov    $0x1,%ecx
            goto again;
  10048a:	e9 bd fe ff ff       	jmpq   10034c <printer_vprintf+0x9b>
            long x = length ? va_arg(val, long) : va_arg(val, int);
  10048f:	85 c9                	test   %ecx,%ecx
  100491:	74 55                	je     1004e8 <printer_vprintf+0x237>
  100493:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  100497:	8b 07                	mov    (%rdi),%eax
  100499:	83 f8 2f             	cmp    $0x2f,%eax
  10049c:	77 38                	ja     1004d6 <printer_vprintf+0x225>
  10049e:	89 c2                	mov    %eax,%edx
  1004a0:	48 03 57 10          	add    0x10(%rdi),%rdx
  1004a4:	83 c0 08             	add    $0x8,%eax
  1004a7:	89 07                	mov    %eax,(%rdi)
  1004a9:	48 8b 12             	mov    (%rdx),%rdx
            int negative = x < 0 ? FLAG_NEGATIVE : 0;
  1004ac:	48 89 d0             	mov    %rdx,%rax
  1004af:	48 c1 f8 38          	sar    $0x38,%rax
            num = negative ? -x : x;
  1004b3:	49 89 d0             	mov    %rdx,%r8
  1004b6:	49 f7 d8             	neg    %r8
  1004b9:	25 80 00 00 00       	and    $0x80,%eax
  1004be:	4c 0f 44 c2          	cmove  %rdx,%r8
            flags |= FLAG_NUMERIC | FLAG_SIGNED | negative;
  1004c2:	0b 45 a8             	or     -0x58(%rbp),%eax
  1004c5:	83 c8 60             	or     $0x60,%eax
  1004c8:	89 45 a8             	mov    %eax,-0x58(%rbp)
        char* data = "";
  1004cb:	41 bc 92 19 10 00    	mov    $0x101992,%r12d
            break;
  1004d1:	e9 35 01 00 00       	jmpq   10060b <printer_vprintf+0x35a>
            long x = length ? va_arg(val, long) : va_arg(val, int);
  1004d6:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1004da:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  1004de:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1004e2:	48 89 41 08          	mov    %rax,0x8(%rcx)
  1004e6:	eb c1                	jmp    1004a9 <printer_vprintf+0x1f8>
  1004e8:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1004ec:	8b 07                	mov    (%rdi),%eax
  1004ee:	83 f8 2f             	cmp    $0x2f,%eax
  1004f1:	77 10                	ja     100503 <printer_vprintf+0x252>
  1004f3:	89 c2                	mov    %eax,%edx
  1004f5:	48 03 57 10          	add    0x10(%rdi),%rdx
  1004f9:	83 c0 08             	add    $0x8,%eax
  1004fc:	89 07                	mov    %eax,(%rdi)
  1004fe:	48 63 12             	movslq (%rdx),%rdx
  100501:	eb a9                	jmp    1004ac <printer_vprintf+0x1fb>
  100503:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  100507:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  10050b:	48 8d 42 08          	lea    0x8(%rdx),%rax
  10050f:	48 89 47 08          	mov    %rax,0x8(%rdi)
  100513:	eb e9                	jmp    1004fe <printer_vprintf+0x24d>
        int base = 10;
  100515:	be 0a 00 00 00       	mov    $0xa,%esi
  10051a:	eb 58                	jmp    100574 <printer_vprintf+0x2c3>
            num = length ? va_arg(val, unsigned long) : va_arg(val, unsigned);
  10051c:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  100520:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  100524:	48 8d 42 08          	lea    0x8(%rdx),%rax
  100528:	48 89 41 08          	mov    %rax,0x8(%rcx)
  10052c:	eb 60                	jmp    10058e <printer_vprintf+0x2dd>
  10052e:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  100532:	8b 07                	mov    (%rdi),%eax
  100534:	83 f8 2f             	cmp    $0x2f,%eax
  100537:	77 10                	ja     100549 <printer_vprintf+0x298>
  100539:	89 c2                	mov    %eax,%edx
  10053b:	48 03 57 10          	add    0x10(%rdi),%rdx
  10053f:	83 c0 08             	add    $0x8,%eax
  100542:	89 07                	mov    %eax,(%rdi)
  100544:	44 8b 02             	mov    (%rdx),%r8d
  100547:	eb 48                	jmp    100591 <printer_vprintf+0x2e0>
  100549:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  10054d:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  100551:	48 8d 42 08          	lea    0x8(%rdx),%rax
  100555:	48 89 41 08          	mov    %rax,0x8(%rcx)
  100559:	eb e9                	jmp    100544 <printer_vprintf+0x293>
  10055b:	41 89 f1             	mov    %esi,%r9d
        if (flags & FLAG_NUMERIC) {
  10055e:	c7 45 8c 20 00 00 00 	movl   $0x20,-0x74(%rbp)
    const char* digits = upper_digits;
  100565:	bf 60 19 10 00       	mov    $0x101960,%edi
  10056a:	e9 e2 02 00 00       	jmpq   100851 <printer_vprintf+0x5a0>
            base = 16;
  10056f:	be 10 00 00 00       	mov    $0x10,%esi
            num = length ? va_arg(val, unsigned long) : va_arg(val, unsigned);
  100574:	85 c9                	test   %ecx,%ecx
  100576:	74 b6                	je     10052e <printer_vprintf+0x27d>
  100578:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  10057c:	8b 01                	mov    (%rcx),%eax
  10057e:	83 f8 2f             	cmp    $0x2f,%eax
  100581:	77 99                	ja     10051c <printer_vprintf+0x26b>
  100583:	89 c2                	mov    %eax,%edx
  100585:	48 03 51 10          	add    0x10(%rcx),%rdx
  100589:	83 c0 08             	add    $0x8,%eax
  10058c:	89 01                	mov    %eax,(%rcx)
  10058e:	4c 8b 02             	mov    (%rdx),%r8
            flags |= FLAG_NUMERIC;
  100591:	83 4d a8 20          	orl    $0x20,-0x58(%rbp)
    if (base < 0) {
  100595:	85 f6                	test   %esi,%esi
  100597:	79 c2                	jns    10055b <printer_vprintf+0x2aa>
        base = -base;
  100599:	41 89 f1             	mov    %esi,%r9d
  10059c:	f7 de                	neg    %esi
  10059e:	c7 45 8c 20 00 00 00 	movl   $0x20,-0x74(%rbp)
        digits = lower_digits;
  1005a5:	bf 40 19 10 00       	mov    $0x101940,%edi
  1005aa:	e9 a2 02 00 00       	jmpq   100851 <printer_vprintf+0x5a0>
            num = (uintptr_t) va_arg(val, void*);
  1005af:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1005b3:	8b 07                	mov    (%rdi),%eax
  1005b5:	83 f8 2f             	cmp    $0x2f,%eax
  1005b8:	77 1c                	ja     1005d6 <printer_vprintf+0x325>
  1005ba:	89 c2                	mov    %eax,%edx
  1005bc:	48 03 57 10          	add    0x10(%rdi),%rdx
  1005c0:	83 c0 08             	add    $0x8,%eax
  1005c3:	89 07                	mov    %eax,(%rdi)
  1005c5:	4c 8b 02             	mov    (%rdx),%r8
            flags |= FLAG_ALT | FLAG_ALT2 | FLAG_NUMERIC;
  1005c8:	81 4d a8 21 01 00 00 	orl    $0x121,-0x58(%rbp)
            base = -16;
  1005cf:	be f0 ff ff ff       	mov    $0xfffffff0,%esi
  1005d4:	eb c3                	jmp    100599 <printer_vprintf+0x2e8>
            num = (uintptr_t) va_arg(val, void*);
  1005d6:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1005da:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  1005de:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1005e2:	48 89 41 08          	mov    %rax,0x8(%rcx)
  1005e6:	eb dd                	jmp    1005c5 <printer_vprintf+0x314>
            data = va_arg(val, char*);
  1005e8:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1005ec:	8b 01                	mov    (%rcx),%eax
  1005ee:	83 f8 2f             	cmp    $0x2f,%eax
  1005f1:	0f 87 a5 01 00 00    	ja     10079c <printer_vprintf+0x4eb>
  1005f7:	89 c2                	mov    %eax,%edx
  1005f9:	48 03 51 10          	add    0x10(%rcx),%rdx
  1005fd:	83 c0 08             	add    $0x8,%eax
  100600:	89 01                	mov    %eax,(%rcx)
  100602:	4c 8b 22             	mov    (%rdx),%r12
        unsigned long num = 0;
  100605:	41 b8 00 00 00 00    	mov    $0x0,%r8d
        if (flags & FLAG_NUMERIC) {
  10060b:	8b 45 a8             	mov    -0x58(%rbp),%eax
  10060e:	83 e0 20             	and    $0x20,%eax
  100611:	89 45 8c             	mov    %eax,-0x74(%rbp)
  100614:	41 b9 0a 00 00 00    	mov    $0xa,%r9d
  10061a:	0f 85 21 02 00 00    	jne    100841 <printer_vprintf+0x590>
        if ((flags & FLAG_NUMERIC) && (flags & FLAG_SIGNED)) {
  100620:	8b 45 a8             	mov    -0x58(%rbp),%eax
  100623:	89 45 88             	mov    %eax,-0x78(%rbp)
  100626:	83 e0 60             	and    $0x60,%eax
  100629:	83 f8 60             	cmp    $0x60,%eax
  10062c:	0f 84 54 02 00 00    	je     100886 <printer_vprintf+0x5d5>
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ALT)
  100632:	8b 45 a8             	mov    -0x58(%rbp),%eax
  100635:	83 e0 21             	and    $0x21,%eax
        const char* prefix = "";
  100638:	48 c7 45 a0 92 19 10 	movq   $0x101992,-0x60(%rbp)
  10063f:	00 
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ALT)
  100640:	83 f8 21             	cmp    $0x21,%eax
  100643:	0f 84 79 02 00 00    	je     1008c2 <printer_vprintf+0x611>
        if (precision >= 0 && !(flags & FLAG_NUMERIC)) {
  100649:	8b 7d 9c             	mov    -0x64(%rbp),%edi
  10064c:	89 f8                	mov    %edi,%eax
  10064e:	f7 d0                	not    %eax
  100650:	c1 e8 1f             	shr    $0x1f,%eax
  100653:	89 45 84             	mov    %eax,-0x7c(%rbp)
  100656:	83 7d 8c 00          	cmpl   $0x0,-0x74(%rbp)
  10065a:	0f 85 9e 02 00 00    	jne    1008fe <printer_vprintf+0x64d>
  100660:	84 c0                	test   %al,%al
  100662:	0f 84 96 02 00 00    	je     1008fe <printer_vprintf+0x64d>
            len = strnlen(data, precision);
  100668:	48 63 f7             	movslq %edi,%rsi
  10066b:	4c 89 e7             	mov    %r12,%rdi
  10066e:	e8 63 fb ff ff       	callq  1001d6 <strnlen>
  100673:	89 45 98             	mov    %eax,-0x68(%rbp)
                   && !(flags & FLAG_LEFTJUSTIFY)
  100676:	8b 45 88             	mov    -0x78(%rbp),%eax
  100679:	83 e0 26             	and    $0x26,%eax
            zeros = 0;
  10067c:	c7 45 9c 00 00 00 00 	movl   $0x0,-0x64(%rbp)
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ZERO)
  100683:	83 f8 22             	cmp    $0x22,%eax
  100686:	0f 84 aa 02 00 00    	je     100936 <printer_vprintf+0x685>
        width -= len + zeros + strlen(prefix);
  10068c:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  100690:	e8 26 fb ff ff       	callq  1001bb <strlen>
  100695:	8b 55 9c             	mov    -0x64(%rbp),%edx
  100698:	03 55 98             	add    -0x68(%rbp),%edx
  10069b:	44 89 e9             	mov    %r13d,%ecx
  10069e:	29 d1                	sub    %edx,%ecx
  1006a0:	29 c1                	sub    %eax,%ecx
  1006a2:	89 4d 8c             	mov    %ecx,-0x74(%rbp)
  1006a5:	41 89 cd             	mov    %ecx,%r13d
        for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width) {
  1006a8:	f6 45 a8 04          	testb  $0x4,-0x58(%rbp)
  1006ac:	75 2d                	jne    1006db <printer_vprintf+0x42a>
  1006ae:	85 c9                	test   %ecx,%ecx
  1006b0:	7e 29                	jle    1006db <printer_vprintf+0x42a>
            p->putc(p, ' ', color);
  1006b2:	44 89 fa             	mov    %r15d,%edx
  1006b5:	be 20 00 00 00       	mov    $0x20,%esi
  1006ba:	4c 89 f7             	mov    %r14,%rdi
  1006bd:	41 ff 16             	callq  *(%r14)
        for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width) {
  1006c0:	41 83 ed 01          	sub    $0x1,%r13d
  1006c4:	45 85 ed             	test   %r13d,%r13d
  1006c7:	7f e9                	jg     1006b2 <printer_vprintf+0x401>
  1006c9:	8b 7d 8c             	mov    -0x74(%rbp),%edi
  1006cc:	85 ff                	test   %edi,%edi
  1006ce:	b8 01 00 00 00       	mov    $0x1,%eax
  1006d3:	0f 4f c7             	cmovg  %edi,%eax
  1006d6:	29 c7                	sub    %eax,%edi
  1006d8:	41 89 fd             	mov    %edi,%r13d
        for (; *prefix; ++prefix) {
  1006db:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  1006df:	0f b6 07             	movzbl (%rdi),%eax
  1006e2:	84 c0                	test   %al,%al
  1006e4:	74 22                	je     100708 <printer_vprintf+0x457>
  1006e6:	48 89 5d a8          	mov    %rbx,-0x58(%rbp)
  1006ea:	48 89 fb             	mov    %rdi,%rbx
            p->putc(p, *prefix, color);
  1006ed:	0f b6 f0             	movzbl %al,%esi
  1006f0:	44 89 fa             	mov    %r15d,%edx
  1006f3:	4c 89 f7             	mov    %r14,%rdi
  1006f6:	41 ff 16             	callq  *(%r14)
        for (; *prefix; ++prefix) {
  1006f9:	48 83 c3 01          	add    $0x1,%rbx
  1006fd:	0f b6 03             	movzbl (%rbx),%eax
  100700:	84 c0                	test   %al,%al
  100702:	75 e9                	jne    1006ed <printer_vprintf+0x43c>
  100704:	48 8b 5d a8          	mov    -0x58(%rbp),%rbx
        for (; zeros > 0; --zeros) {
  100708:	8b 45 9c             	mov    -0x64(%rbp),%eax
  10070b:	85 c0                	test   %eax,%eax
  10070d:	7e 1d                	jle    10072c <printer_vprintf+0x47b>
  10070f:	48 89 5d a8          	mov    %rbx,-0x58(%rbp)
  100713:	89 c3                	mov    %eax,%ebx
            p->putc(p, '0', color);
  100715:	44 89 fa             	mov    %r15d,%edx
  100718:	be 30 00 00 00       	mov    $0x30,%esi
  10071d:	4c 89 f7             	mov    %r14,%rdi
  100720:	41 ff 16             	callq  *(%r14)
        for (; zeros > 0; --zeros) {
  100723:	83 eb 01             	sub    $0x1,%ebx
  100726:	75 ed                	jne    100715 <printer_vprintf+0x464>
  100728:	48 8b 5d a8          	mov    -0x58(%rbp),%rbx
        for (; len > 0; ++data, --len) {
  10072c:	8b 45 98             	mov    -0x68(%rbp),%eax
  10072f:	85 c0                	test   %eax,%eax
  100731:	7e 27                	jle    10075a <printer_vprintf+0x4a9>
  100733:	89 c0                	mov    %eax,%eax
  100735:	4c 01 e0             	add    %r12,%rax
  100738:	48 89 5d a8          	mov    %rbx,-0x58(%rbp)
  10073c:	48 89 c3             	mov    %rax,%rbx
            p->putc(p, *data, color);
  10073f:	41 0f b6 34 24       	movzbl (%r12),%esi
  100744:	44 89 fa             	mov    %r15d,%edx
  100747:	4c 89 f7             	mov    %r14,%rdi
  10074a:	41 ff 16             	callq  *(%r14)
        for (; len > 0; ++data, --len) {
  10074d:	49 83 c4 01          	add    $0x1,%r12
  100751:	49 39 dc             	cmp    %rbx,%r12
  100754:	75 e9                	jne    10073f <printer_vprintf+0x48e>
  100756:	48 8b 5d a8          	mov    -0x58(%rbp),%rbx
        for (; width > 0; --width) {
  10075a:	45 85 ed             	test   %r13d,%r13d
  10075d:	7e 14                	jle    100773 <printer_vprintf+0x4c2>
            p->putc(p, ' ', color);
  10075f:	44 89 fa             	mov    %r15d,%edx
  100762:	be 20 00 00 00       	mov    $0x20,%esi
  100767:	4c 89 f7             	mov    %r14,%rdi
  10076a:	41 ff 16             	callq  *(%r14)
        for (; width > 0; --width) {
  10076d:	41 83 ed 01          	sub    $0x1,%r13d
  100771:	75 ec                	jne    10075f <printer_vprintf+0x4ae>
    for (; *format; ++format) {
  100773:	4c 8d 63 01          	lea    0x1(%rbx),%r12
  100777:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  10077b:	84 c0                	test   %al,%al
  10077d:	0f 84 fe 01 00 00    	je     100981 <printer_vprintf+0x6d0>
        if (*format != '%') {
  100783:	3c 25                	cmp    $0x25,%al
  100785:	0f 84 54 fb ff ff    	je     1002df <printer_vprintf+0x2e>
            p->putc(p, *format, color);
  10078b:	0f b6 f0             	movzbl %al,%esi
  10078e:	44 89 fa             	mov    %r15d,%edx
  100791:	4c 89 f7             	mov    %r14,%rdi
  100794:	41 ff 16             	callq  *(%r14)
            continue;
  100797:	4c 89 e3             	mov    %r12,%rbx
  10079a:	eb d7                	jmp    100773 <printer_vprintf+0x4c2>
            data = va_arg(val, char*);
  10079c:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1007a0:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  1007a4:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1007a8:	48 89 47 08          	mov    %rax,0x8(%rdi)
  1007ac:	e9 51 fe ff ff       	jmpq   100602 <printer_vprintf+0x351>
            color = va_arg(val, int);
  1007b1:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1007b5:	8b 07                	mov    (%rdi),%eax
  1007b7:	83 f8 2f             	cmp    $0x2f,%eax
  1007ba:	77 10                	ja     1007cc <printer_vprintf+0x51b>
  1007bc:	89 c2                	mov    %eax,%edx
  1007be:	48 03 57 10          	add    0x10(%rdi),%rdx
  1007c2:	83 c0 08             	add    $0x8,%eax
  1007c5:	89 07                	mov    %eax,(%rdi)
  1007c7:	44 8b 3a             	mov    (%rdx),%r15d
            goto done;
  1007ca:	eb a7                	jmp    100773 <printer_vprintf+0x4c2>
            color = va_arg(val, int);
  1007cc:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1007d0:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  1007d4:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1007d8:	48 89 41 08          	mov    %rax,0x8(%rcx)
  1007dc:	eb e9                	jmp    1007c7 <printer_vprintf+0x516>
            numbuf[0] = va_arg(val, int);
  1007de:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1007e2:	8b 01                	mov    (%rcx),%eax
  1007e4:	83 f8 2f             	cmp    $0x2f,%eax
  1007e7:	77 23                	ja     10080c <printer_vprintf+0x55b>
  1007e9:	89 c2                	mov    %eax,%edx
  1007eb:	48 03 51 10          	add    0x10(%rcx),%rdx
  1007ef:	83 c0 08             	add    $0x8,%eax
  1007f2:	89 01                	mov    %eax,(%rcx)
  1007f4:	8b 02                	mov    (%rdx),%eax
  1007f6:	88 45 b8             	mov    %al,-0x48(%rbp)
            numbuf[1] = '\0';
  1007f9:	c6 45 b9 00          	movb   $0x0,-0x47(%rbp)
            data = numbuf;
  1007fd:	4c 8d 65 b8          	lea    -0x48(%rbp),%r12
        unsigned long num = 0;
  100801:	41 b8 00 00 00 00    	mov    $0x0,%r8d
            break;
  100807:	e9 ff fd ff ff       	jmpq   10060b <printer_vprintf+0x35a>
            numbuf[0] = va_arg(val, int);
  10080c:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  100810:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  100814:	48 8d 42 08          	lea    0x8(%rdx),%rax
  100818:	48 89 47 08          	mov    %rax,0x8(%rdi)
  10081c:	eb d6                	jmp    1007f4 <printer_vprintf+0x543>
            numbuf[0] = (*format ? *format : '%');
  10081e:	84 d2                	test   %dl,%dl
  100820:	0f 85 39 01 00 00    	jne    10095f <printer_vprintf+0x6ae>
  100826:	c6 45 b8 25          	movb   $0x25,-0x48(%rbp)
            numbuf[1] = '\0';
  10082a:	c6 45 b9 00          	movb   $0x0,-0x47(%rbp)
                format--;
  10082e:	48 83 eb 01          	sub    $0x1,%rbx
            data = numbuf;
  100832:	4c 8d 65 b8          	lea    -0x48(%rbp),%r12
        unsigned long num = 0;
  100836:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  10083c:	e9 ca fd ff ff       	jmpq   10060b <printer_vprintf+0x35a>
        if (flags & FLAG_NUMERIC) {
  100841:	41 b9 0a 00 00 00    	mov    $0xa,%r9d
    const char* digits = upper_digits;
  100847:	bf 60 19 10 00       	mov    $0x101960,%edi
        if (flags & FLAG_NUMERIC) {
  10084c:	be 0a 00 00 00       	mov    $0xa,%esi
    *--numbuf_end = '\0';
  100851:	c6 45 cf 00          	movb   $0x0,-0x31(%rbp)
  100855:	4c 89 c1             	mov    %r8,%rcx
  100858:	4c 8d 65 cf          	lea    -0x31(%rbp),%r12
        *--numbuf_end = digits[val % base];
  10085c:	48 63 f6             	movslq %esi,%rsi
  10085f:	49 83 ec 01          	sub    $0x1,%r12
  100863:	48 89 c8             	mov    %rcx,%rax
  100866:	ba 00 00 00 00       	mov    $0x0,%edx
  10086b:	48 f7 f6             	div    %rsi
  10086e:	0f b6 14 17          	movzbl (%rdi,%rdx,1),%edx
  100872:	41 88 14 24          	mov    %dl,(%r12)
        val /= base;
  100876:	48 89 ca             	mov    %rcx,%rdx
  100879:	48 89 c1             	mov    %rax,%rcx
    } while (val != 0);
  10087c:	48 39 d6             	cmp    %rdx,%rsi
  10087f:	76 de                	jbe    10085f <printer_vprintf+0x5ae>
  100881:	e9 9a fd ff ff       	jmpq   100620 <printer_vprintf+0x36f>
                prefix = "-";
  100886:	48 c7 45 a0 6e 17 10 	movq   $0x10176e,-0x60(%rbp)
  10088d:	00 
            if (flags & FLAG_NEGATIVE) {
  10088e:	8b 45 a8             	mov    -0x58(%rbp),%eax
  100891:	a8 80                	test   $0x80,%al
  100893:	0f 85 b0 fd ff ff    	jne    100649 <printer_vprintf+0x398>
                prefix = "+";
  100899:	48 c7 45 a0 69 17 10 	movq   $0x101769,-0x60(%rbp)
  1008a0:	00 
            } else if (flags & FLAG_PLUSPOSITIVE) {
  1008a1:	a8 10                	test   $0x10,%al
  1008a3:	0f 85 a0 fd ff ff    	jne    100649 <printer_vprintf+0x398>
                prefix = " ";
  1008a9:	a8 08                	test   $0x8,%al
  1008ab:	ba 92 19 10 00       	mov    $0x101992,%edx
  1008b0:	b8 8f 19 10 00       	mov    $0x10198f,%eax
  1008b5:	48 0f 44 c2          	cmove  %rdx,%rax
  1008b9:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  1008bd:	e9 87 fd ff ff       	jmpq   100649 <printer_vprintf+0x398>
                   && (base == 16 || base == -16)
  1008c2:	41 8d 41 10          	lea    0x10(%r9),%eax
  1008c6:	a9 df ff ff ff       	test   $0xffffffdf,%eax
  1008cb:	0f 85 78 fd ff ff    	jne    100649 <printer_vprintf+0x398>
                   && (num || (flags & FLAG_ALT2))) {
  1008d1:	4d 85 c0             	test   %r8,%r8
  1008d4:	75 0d                	jne    1008e3 <printer_vprintf+0x632>
  1008d6:	f7 45 a8 00 01 00 00 	testl  $0x100,-0x58(%rbp)
  1008dd:	0f 84 66 fd ff ff    	je     100649 <printer_vprintf+0x398>
            prefix = (base == -16 ? "0x" : "0X");
  1008e3:	41 83 f9 f0          	cmp    $0xfffffff0,%r9d
  1008e7:	ba 70 17 10 00       	mov    $0x101770,%edx
  1008ec:	b8 6b 17 10 00       	mov    $0x10176b,%eax
  1008f1:	48 0f 44 c2          	cmove  %rdx,%rax
  1008f5:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  1008f9:	e9 4b fd ff ff       	jmpq   100649 <printer_vprintf+0x398>
            len = strlen(data);
  1008fe:	4c 89 e7             	mov    %r12,%rdi
  100901:	e8 b5 f8 ff ff       	callq  1001bb <strlen>
  100906:	89 45 98             	mov    %eax,-0x68(%rbp)
        if ((flags & FLAG_NUMERIC) && precision >= 0) {
  100909:	83 7d 8c 00          	cmpl   $0x0,-0x74(%rbp)
  10090d:	0f 84 63 fd ff ff    	je     100676 <printer_vprintf+0x3c5>
  100913:	80 7d 84 00          	cmpb   $0x0,-0x7c(%rbp)
  100917:	0f 84 59 fd ff ff    	je     100676 <printer_vprintf+0x3c5>
            zeros = precision > len ? precision - len : 0;
  10091d:	8b 4d 9c             	mov    -0x64(%rbp),%ecx
  100920:	89 ca                	mov    %ecx,%edx
  100922:	29 c2                	sub    %eax,%edx
  100924:	39 c1                	cmp    %eax,%ecx
  100926:	b8 00 00 00 00       	mov    $0x0,%eax
  10092b:	0f 4e d0             	cmovle %eax,%edx
  10092e:	89 55 9c             	mov    %edx,-0x64(%rbp)
  100931:	e9 56 fd ff ff       	jmpq   10068c <printer_vprintf+0x3db>
                   && len + (int) strlen(prefix) < width) {
  100936:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  10093a:	e8 7c f8 ff ff       	callq  1001bb <strlen>
  10093f:	8b 7d 98             	mov    -0x68(%rbp),%edi
  100942:	8d 14 07             	lea    (%rdi,%rax,1),%edx
            zeros = width - len - strlen(prefix);
  100945:	44 89 e9             	mov    %r13d,%ecx
  100948:	29 f9                	sub    %edi,%ecx
  10094a:	29 c1                	sub    %eax,%ecx
  10094c:	44 39 ea             	cmp    %r13d,%edx
  10094f:	b8 00 00 00 00       	mov    $0x0,%eax
  100954:	0f 4d c8             	cmovge %eax,%ecx
  100957:	89 4d 9c             	mov    %ecx,-0x64(%rbp)
  10095a:	e9 2d fd ff ff       	jmpq   10068c <printer_vprintf+0x3db>
            numbuf[0] = (*format ? *format : '%');
  10095f:	88 55 b8             	mov    %dl,-0x48(%rbp)
            numbuf[1] = '\0';
  100962:	c6 45 b9 00          	movb   $0x0,-0x47(%rbp)
            data = numbuf;
  100966:	4c 8d 65 b8          	lea    -0x48(%rbp),%r12
        unsigned long num = 0;
  10096a:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  100970:	e9 96 fc ff ff       	jmpq   10060b <printer_vprintf+0x35a>
        int flags = 0;
  100975:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%rbp)
  10097c:	e9 b0 f9 ff ff       	jmpq   100331 <printer_vprintf+0x80>
}
  100981:	48 83 c4 58          	add    $0x58,%rsp
  100985:	5b                   	pop    %rbx
  100986:	41 5c                	pop    %r12
  100988:	41 5d                	pop    %r13
  10098a:	41 5e                	pop    %r14
  10098c:	41 5f                	pop    %r15
  10098e:	5d                   	pop    %rbp
  10098f:	c3                   	retq   

0000000000100990 <console_vprintf>:
int console_vprintf(int cpos, int color, const char* format, va_list val) {
  100990:	55                   	push   %rbp
  100991:	48 89 e5             	mov    %rsp,%rbp
  100994:	48 83 ec 10          	sub    $0x10,%rsp
    cp.p.putc = console_putc;
  100998:	48 c7 45 f0 9b 00 10 	movq   $0x10009b,-0x10(%rbp)
  10099f:	00 
        cpos = 0;
  1009a0:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
  1009a6:	b8 00 00 00 00       	mov    $0x0,%eax
  1009ab:	0f 43 f8             	cmovae %eax,%edi
    cp.cursor = console + cpos;
  1009ae:	48 63 ff             	movslq %edi,%rdi
  1009b1:	48 8d 84 3f 00 80 0b 	lea    0xb8000(%rdi,%rdi,1),%rax
  1009b8:	00 
  1009b9:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    printer_vprintf(&cp.p, color, format, val);
  1009bd:	48 8d 7d f0          	lea    -0x10(%rbp),%rdi
  1009c1:	e8 eb f8 ff ff       	callq  1002b1 <printer_vprintf>
    return cp.cursor - console;
  1009c6:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1009ca:	48 2d 00 80 0b 00    	sub    $0xb8000,%rax
  1009d0:	48 d1 f8             	sar    %rax
}
  1009d3:	c9                   	leaveq 
  1009d4:	c3                   	retq   

00000000001009d5 <console_printf>:
int console_printf(int cpos, int color, const char* format, ...) {
  1009d5:	55                   	push   %rbp
  1009d6:	48 89 e5             	mov    %rsp,%rbp
  1009d9:	48 83 ec 50          	sub    $0x50,%rsp
  1009dd:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  1009e1:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  1009e5:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(val, format);
  1009e9:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  1009f0:	48 8d 45 10          	lea    0x10(%rbp),%rax
  1009f4:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  1009f8:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  1009fc:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    cpos = console_vprintf(cpos, color, format, val);
  100a00:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  100a04:	e8 87 ff ff ff       	callq  100990 <console_vprintf>
}
  100a09:	c9                   	leaveq 
  100a0a:	c3                   	retq   

0000000000100a0b <vsnprintf>:

int vsnprintf(char* s, size_t size, const char* format, va_list val) {
  100a0b:	55                   	push   %rbp
  100a0c:	48 89 e5             	mov    %rsp,%rbp
  100a0f:	53                   	push   %rbx
  100a10:	48 83 ec 28          	sub    $0x28,%rsp
  100a14:	48 89 fb             	mov    %rdi,%rbx
    string_printer sp;
    sp.p.putc = string_putc;
  100a17:	48 c7 45 d8 21 01 10 	movq   $0x100121,-0x28(%rbp)
  100a1e:	00 
    sp.s = s;
  100a1f:	48 89 7d e0          	mov    %rdi,-0x20(%rbp)
    if (size) {
  100a23:	48 85 f6             	test   %rsi,%rsi
  100a26:	75 0b                	jne    100a33 <vsnprintf+0x28>
        sp.end = s + size - 1;
        printer_vprintf(&sp.p, 0, format, val);
        *sp.s = 0;
    }
    return sp.s - s;
  100a28:	8b 45 e0             	mov    -0x20(%rbp),%eax
  100a2b:	29 d8                	sub    %ebx,%eax
}
  100a2d:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  100a31:	c9                   	leaveq 
  100a32:	c3                   	retq   
        sp.end = s + size - 1;
  100a33:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  100a38:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
        printer_vprintf(&sp.p, 0, format, val);
  100a3c:	be 00 00 00 00       	mov    $0x0,%esi
  100a41:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  100a45:	e8 67 f8 ff ff       	callq  1002b1 <printer_vprintf>
        *sp.s = 0;
  100a4a:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  100a4e:	c6 00 00             	movb   $0x0,(%rax)
  100a51:	eb d5                	jmp    100a28 <vsnprintf+0x1d>

0000000000100a53 <snprintf>:

int snprintf(char* s, size_t size, const char* format, ...) {
  100a53:	55                   	push   %rbp
  100a54:	48 89 e5             	mov    %rsp,%rbp
  100a57:	48 83 ec 50          	sub    $0x50,%rsp
  100a5b:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  100a5f:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  100a63:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list val;
    va_start(val, format);
  100a67:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  100a6e:	48 8d 45 10          	lea    0x10(%rbp),%rax
  100a72:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  100a76:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  100a7a:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int n = vsnprintf(s, size, format, val);
  100a7e:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  100a82:	e8 84 ff ff ff       	callq  100a0b <vsnprintf>
    va_end(val);
    return n;
}
  100a87:	c9                   	leaveq 
  100a88:	c3                   	retq   

0000000000100a89 <console_clear>:

// console_clear
//    Erases the console and moves the cursor to the upper left (CPOS(0, 0)).

void console_clear(void) {
    for (int i = 0; i < CONSOLE_ROWS * CONSOLE_COLUMNS; ++i) {
  100a89:	b8 00 80 0b 00       	mov    $0xb8000,%eax
  100a8e:	ba a0 8f 0b 00       	mov    $0xb8fa0,%edx
        console[i] = ' ' | 0x0700;
  100a93:	66 c7 00 20 07       	movw   $0x720,(%rax)
    for (int i = 0; i < CONSOLE_ROWS * CONSOLE_COLUMNS; ++i) {
  100a98:	48 83 c0 02          	add    $0x2,%rax
  100a9c:	48 39 d0             	cmp    %rdx,%rax
  100a9f:	75 f2                	jne    100a93 <console_clear+0xa>
    }
    cursorpos = 0;
  100aa1:	c7 05 51 85 fb ff 00 	movl   $0x0,-0x47aaf(%rip)        # b8ffc <cursorpos>
  100aa8:	00 00 00 
}
  100aab:	c3                   	retq   

0000000000100aac <ptr_comparator_ptr_ascending>:
	    }
	}
    }
}
int ptr_comparator_ptr_ascending( const void * a, const void * b){
    return (uintptr_t)((ptr_with_size *) a)->ptr - (uintptr_t)((ptr_with_size *) b)->ptr;
  100aac:	48 8b 07             	mov    (%rdi),%rax
  100aaf:	2b 06                	sub    (%rsi),%eax
}
  100ab1:	c3                   	retq   

0000000000100ab2 <ptr_comparator_size_descending>:
int ptr_comparator_size_descending( const void * a, const void * b){
    return (size_t)((ptr_with_size *) b)->size - (size_t)((ptr_with_size *) a)->size;
  100ab2:	48 8b 46 08          	mov    0x8(%rsi),%rax
  100ab6:	2b 47 08             	sub    0x8(%rdi),%eax
}
  100ab9:	c3                   	retq   

0000000000100aba <__quicksort>:
{
  100aba:	55                   	push   %rbp
  100abb:	48 89 e5             	mov    %rsp,%rbp
  100abe:	41 57                	push   %r15
  100ac0:	41 56                	push   %r14
  100ac2:	41 55                	push   %r13
  100ac4:	41 54                	push   %r12
  100ac6:	53                   	push   %rbx
  100ac7:	48 81 ec 48 04 00 00 	sub    $0x448,%rsp
  100ace:	48 89 bd a0 fb ff ff 	mov    %rdi,-0x460(%rbp)
  100ad5:	48 89 b5 98 fb ff ff 	mov    %rsi,-0x468(%rbp)
  100adc:	48 89 95 c8 fb ff ff 	mov    %rdx,-0x438(%rbp)
    if (total_elems == 0)
  100ae3:	48 85 f6             	test   %rsi,%rsi
  100ae6:	0f 84 94 03 00 00    	je     100e80 <__quicksort+0x3c6>
  100aec:	48 89 f0             	mov    %rsi,%rax
  100aef:	48 89 cb             	mov    %rcx,%rbx
    const size_t max_thresh = MAX_THRESH * size;
  100af2:	48 8d 0c 95 00 00 00 	lea    0x0(,%rdx,4),%rcx
  100af9:	00 
  100afa:	48 89 8d a8 fb ff ff 	mov    %rcx,-0x458(%rbp)
    if (total_elems > MAX_THRESH)
  100b01:	48 83 fe 04          	cmp    $0x4,%rsi
  100b05:	0f 86 bd 02 00 00    	jbe    100dc8 <__quicksort+0x30e>
	char *hi = &lo[size * (total_elems - 1)];
  100b0b:	48 83 e8 01          	sub    $0x1,%rax
  100b0f:	48 0f af c2          	imul   %rdx,%rax
  100b13:	48 01 f8             	add    %rdi,%rax
  100b16:	48 89 85 c0 fb ff ff 	mov    %rax,-0x440(%rbp)
	PUSH (NULL, NULL);
  100b1d:	48 c7 85 d0 fb ff ff 	movq   $0x0,-0x430(%rbp)
  100b24:	00 00 00 00 
  100b28:	48 c7 85 d8 fb ff ff 	movq   $0x0,-0x428(%rbp)
  100b2f:	00 00 00 00 
	char *lo = base_ptr;
  100b33:	48 89 bd b8 fb ff ff 	mov    %rdi,-0x448(%rbp)
	PUSH (NULL, NULL);
  100b3a:	48 8d 85 e0 fb ff ff 	lea    -0x420(%rbp),%rax
  100b41:	48 89 85 b0 fb ff ff 	mov    %rax,-0x450(%rbp)
	  right_ptr = hi - size;
  100b48:	48 f7 da             	neg    %rdx
  100b4b:	49 89 d7             	mov    %rdx,%r15
  100b4e:	e9 8c 01 00 00       	jmpq   100cdf <__quicksort+0x225>
  100b53:	48 8b 85 c8 fb ff ff 	mov    -0x438(%rbp),%rax
  100b5a:	49 8d 7c 05 00       	lea    0x0(%r13,%rax,1),%rdi
	    if ((*cmp) ((void *) mid, (void *) lo) < 0)
  100b5f:	48 8b 95 b8 fb ff ff 	mov    -0x448(%rbp),%rdx
		SWAP (mid, lo, size);
  100b66:	4c 89 e8             	mov    %r13,%rax
  100b69:	0f b6 08             	movzbl (%rax),%ecx
  100b6c:	48 83 c0 01          	add    $0x1,%rax
  100b70:	0f b6 32             	movzbl (%rdx),%esi
  100b73:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  100b77:	48 83 c2 01          	add    $0x1,%rdx
  100b7b:	88 4a ff             	mov    %cl,-0x1(%rdx)
  100b7e:	48 39 c7             	cmp    %rax,%rdi
  100b81:	75 e6                	jne    100b69 <__quicksort+0xaf>
  100b83:	e9 92 01 00 00       	jmpq   100d1a <__quicksort+0x260>
  100b88:	48 8b 85 c8 fb ff ff 	mov    -0x438(%rbp),%rax
  100b8f:	4d 8d 64 05 00       	lea    0x0(%r13,%rax,1),%r12
	    if ((*cmp) ((void *) hi, (void *) mid) < 0)
  100b94:	48 8b 95 c0 fb ff ff 	mov    -0x440(%rbp),%rdx
		SWAP (mid, hi, size);
  100b9b:	4c 89 e8             	mov    %r13,%rax
  100b9e:	0f b6 08             	movzbl (%rax),%ecx
  100ba1:	48 83 c0 01          	add    $0x1,%rax
  100ba5:	0f b6 32             	movzbl (%rdx),%esi
  100ba8:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  100bac:	48 83 c2 01          	add    $0x1,%rdx
  100bb0:	88 4a ff             	mov    %cl,-0x1(%rdx)
  100bb3:	49 39 c4             	cmp    %rax,%r12
  100bb6:	75 e6                	jne    100b9e <__quicksort+0xe4>
	    if ((*cmp) ((void *) mid, (void *) lo) < 0)
  100bb8:	48 8b b5 b8 fb ff ff 	mov    -0x448(%rbp),%rsi
  100bbf:	4c 89 ef             	mov    %r13,%rdi
  100bc2:	ff d3                	callq  *%rbx
  100bc4:	85 c0                	test   %eax,%eax
  100bc6:	0f 89 62 01 00 00    	jns    100d2e <__quicksort+0x274>
  100bcc:	48 8b 95 b8 fb ff ff 	mov    -0x448(%rbp),%rdx
		SWAP (mid, lo, size);
  100bd3:	4c 89 e8             	mov    %r13,%rax
  100bd6:	0f b6 08             	movzbl (%rax),%ecx
  100bd9:	48 83 c0 01          	add    $0x1,%rax
  100bdd:	0f b6 32             	movzbl (%rdx),%esi
  100be0:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  100be4:	48 83 c2 01          	add    $0x1,%rdx
  100be8:	88 4a ff             	mov    %cl,-0x1(%rdx)
  100beb:	49 39 c4             	cmp    %rax,%r12
  100bee:	75 e6                	jne    100bd6 <__quicksort+0x11c>
jump_over:;
  100bf0:	e9 39 01 00 00       	jmpq   100d2e <__quicksort+0x274>
		  right_ptr -= size;
  100bf5:	4d 01 fc             	add    %r15,%r12
	      while ((*cmp) ((void *) mid, (void *) right_ptr) < 0)
  100bf8:	4c 89 e6             	mov    %r12,%rsi
  100bfb:	4c 89 ef             	mov    %r13,%rdi
  100bfe:	ff d3                	callq  *%rbx
  100c00:	85 c0                	test   %eax,%eax
  100c02:	78 f1                	js     100bf5 <__quicksort+0x13b>
	      if (left_ptr < right_ptr)
  100c04:	4d 39 e6             	cmp    %r12,%r14
  100c07:	72 1c                	jb     100c25 <__quicksort+0x16b>
	      else if (left_ptr == right_ptr)
  100c09:	74 5e                	je     100c69 <__quicksort+0x1af>
	  while (left_ptr <= right_ptr);
  100c0b:	4d 39 e6             	cmp    %r12,%r14
  100c0e:	77 63                	ja     100c73 <__quicksort+0x1b9>
	      while ((*cmp) ((void *) left_ptr, (void *) mid) < 0)
  100c10:	4c 89 ee             	mov    %r13,%rsi
  100c13:	4c 89 f7             	mov    %r14,%rdi
  100c16:	ff d3                	callq  *%rbx
  100c18:	85 c0                	test   %eax,%eax
  100c1a:	79 dc                	jns    100bf8 <__quicksort+0x13e>
		  left_ptr += size;
  100c1c:	4c 03 b5 c8 fb ff ff 	add    -0x438(%rbp),%r14
  100c23:	eb eb                	jmp    100c10 <__quicksort+0x156>
  100c25:	48 8b 85 c8 fb ff ff 	mov    -0x438(%rbp),%rax
  100c2c:	49 8d 3c 06          	lea    (%r14,%rax,1),%rdi
	      if (left_ptr < right_ptr)
  100c30:	4c 89 e2             	mov    %r12,%rdx
  100c33:	4c 89 f0             	mov    %r14,%rax
		  SWAP (left_ptr, right_ptr, size);
  100c36:	0f b6 08             	movzbl (%rax),%ecx
  100c39:	48 83 c0 01          	add    $0x1,%rax
  100c3d:	0f b6 32             	movzbl (%rdx),%esi
  100c40:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  100c44:	48 83 c2 01          	add    $0x1,%rdx
  100c48:	88 4a ff             	mov    %cl,-0x1(%rdx)
  100c4b:	48 39 f8             	cmp    %rdi,%rax
  100c4e:	75 e6                	jne    100c36 <__quicksort+0x17c>
		  if (mid == left_ptr)
  100c50:	4d 39 ee             	cmp    %r13,%r14
  100c53:	74 0f                	je     100c64 <__quicksort+0x1aa>
		  else if (mid == right_ptr)
  100c55:	4d 39 ec             	cmp    %r13,%r12
  100c58:	4d 0f 44 ee          	cmove  %r14,%r13
		  right_ptr -= size;
  100c5c:	4d 01 fc             	add    %r15,%r12
		  left_ptr += size;
  100c5f:	49 89 fe             	mov    %rdi,%r14
  100c62:	eb a7                	jmp    100c0b <__quicksort+0x151>
  100c64:	4d 89 e5             	mov    %r12,%r13
  100c67:	eb f3                	jmp    100c5c <__quicksort+0x1a2>
		  left_ptr += size;
  100c69:	4c 03 b5 c8 fb ff ff 	add    -0x438(%rbp),%r14
		  right_ptr -= size;
  100c70:	4d 01 fc             	add    %r15,%r12
	  if ((size_t) (right_ptr - lo) <= max_thresh)
  100c73:	4c 89 e0             	mov    %r12,%rax
  100c76:	48 2b 85 b8 fb ff ff 	sub    -0x448(%rbp),%rax
  100c7d:	48 8b bd a8 fb ff ff 	mov    -0x458(%rbp),%rdi
  100c84:	48 39 f8             	cmp    %rdi,%rax
  100c87:	0f 87 bf 00 00 00    	ja     100d4c <__quicksort+0x292>
	      if ((size_t) (hi - left_ptr) <= max_thresh)
  100c8d:	48 8b 85 c0 fb ff ff 	mov    -0x440(%rbp),%rax
  100c94:	4c 29 f0             	sub    %r14,%rax
		  lo = left_ptr;
  100c97:	4c 89 b5 b8 fb ff ff 	mov    %r14,-0x448(%rbp)
	      if ((size_t) (hi - left_ptr) <= max_thresh)
  100c9e:	48 39 f8             	cmp    %rdi,%rax
  100ca1:	77 28                	ja     100ccb <__quicksort+0x211>
		  POP (lo, hi);
  100ca3:	48 8b 85 b0 fb ff ff 	mov    -0x450(%rbp),%rax
  100caa:	48 8b 78 f0          	mov    -0x10(%rax),%rdi
  100cae:	48 89 bd b8 fb ff ff 	mov    %rdi,-0x448(%rbp)
  100cb5:	48 8b 78 f8          	mov    -0x8(%rax),%rdi
  100cb9:	48 89 bd c0 fb ff ff 	mov    %rdi,-0x440(%rbp)
  100cc0:	48 8d 40 f0          	lea    -0x10(%rax),%rax
  100cc4:	48 89 85 b0 fb ff ff 	mov    %rax,-0x450(%rbp)
	while (STACK_NOT_EMPTY)
  100ccb:	48 8d 85 d0 fb ff ff 	lea    -0x430(%rbp),%rax
  100cd2:	48 39 85 b0 fb ff ff 	cmp    %rax,-0x450(%rbp)
  100cd9:	0f 86 e9 00 00 00    	jbe    100dc8 <__quicksort+0x30e>
	    char *mid = lo + size * ((hi - lo) / size >> 1);
  100cdf:	48 8b 85 c0 fb ff ff 	mov    -0x440(%rbp),%rax
  100ce6:	48 8b bd b8 fb ff ff 	mov    -0x448(%rbp),%rdi
  100ced:	48 29 f8             	sub    %rdi,%rax
  100cf0:	48 8b 8d c8 fb ff ff 	mov    -0x438(%rbp),%rcx
  100cf7:	ba 00 00 00 00       	mov    $0x0,%edx
  100cfc:	48 f7 f1             	div    %rcx
  100cff:	48 d1 e8             	shr    %rax
  100d02:	48 0f af c1          	imul   %rcx,%rax
  100d06:	4c 8d 2c 07          	lea    (%rdi,%rax,1),%r13
	    if ((*cmp) ((void *) mid, (void *) lo) < 0)
  100d0a:	48 89 fe             	mov    %rdi,%rsi
  100d0d:	4c 89 ef             	mov    %r13,%rdi
  100d10:	ff d3                	callq  *%rbx
  100d12:	85 c0                	test   %eax,%eax
  100d14:	0f 88 39 fe ff ff    	js     100b53 <__quicksort+0x99>
	    if ((*cmp) ((void *) hi, (void *) mid) < 0)
  100d1a:	4c 89 ee             	mov    %r13,%rsi
  100d1d:	48 8b bd c0 fb ff ff 	mov    -0x440(%rbp),%rdi
  100d24:	ff d3                	callq  *%rbx
  100d26:	85 c0                	test   %eax,%eax
  100d28:	0f 88 5a fe ff ff    	js     100b88 <__quicksort+0xce>
	  left_ptr  = lo + size;
  100d2e:	4c 8b b5 b8 fb ff ff 	mov    -0x448(%rbp),%r14
  100d35:	4c 03 b5 c8 fb ff ff 	add    -0x438(%rbp),%r14
	  right_ptr = hi - size;
  100d3c:	48 8b 85 c0 fb ff ff 	mov    -0x440(%rbp),%rax
  100d43:	4e 8d 24 38          	lea    (%rax,%r15,1),%r12
  100d47:	e9 c4 fe ff ff       	jmpq   100c10 <__quicksort+0x156>
	  else if ((size_t) (hi - left_ptr) <= max_thresh)
  100d4c:	48 8b 95 c0 fb ff ff 	mov    -0x440(%rbp),%rdx
  100d53:	4c 29 f2             	sub    %r14,%rdx
  100d56:	48 3b 95 a8 fb ff ff 	cmp    -0x458(%rbp),%rdx
  100d5d:	76 5d                	jbe    100dbc <__quicksort+0x302>
	  else if ((right_ptr - lo) > (hi - left_ptr))
  100d5f:	48 39 d0             	cmp    %rdx,%rax
  100d62:	7e 2c                	jle    100d90 <__quicksort+0x2d6>
	      PUSH (lo, right_ptr);
  100d64:	48 8b 85 b0 fb ff ff 	mov    -0x450(%rbp),%rax
  100d6b:	48 8b bd b8 fb ff ff 	mov    -0x448(%rbp),%rdi
  100d72:	48 89 38             	mov    %rdi,(%rax)
  100d75:	4c 89 60 08          	mov    %r12,0x8(%rax)
  100d79:	48 83 c0 10          	add    $0x10,%rax
  100d7d:	48 89 85 b0 fb ff ff 	mov    %rax,-0x450(%rbp)
	      lo = left_ptr;
  100d84:	4c 89 b5 b8 fb ff ff 	mov    %r14,-0x448(%rbp)
  100d8b:	e9 3b ff ff ff       	jmpq   100ccb <__quicksort+0x211>
	      PUSH (left_ptr, hi);
  100d90:	48 8b 85 b0 fb ff ff 	mov    -0x450(%rbp),%rax
  100d97:	4c 89 30             	mov    %r14,(%rax)
  100d9a:	48 8b bd c0 fb ff ff 	mov    -0x440(%rbp),%rdi
  100da1:	48 89 78 08          	mov    %rdi,0x8(%rax)
  100da5:	48 83 c0 10          	add    $0x10,%rax
  100da9:	48 89 85 b0 fb ff ff 	mov    %rax,-0x450(%rbp)
	      hi = right_ptr;
  100db0:	4c 89 a5 c0 fb ff ff 	mov    %r12,-0x440(%rbp)
  100db7:	e9 0f ff ff ff       	jmpq   100ccb <__quicksort+0x211>
	      hi = right_ptr;
  100dbc:	4c 89 a5 c0 fb ff ff 	mov    %r12,-0x440(%rbp)
  100dc3:	e9 03 ff ff ff       	jmpq   100ccb <__quicksort+0x211>
	char *const end_ptr = &base_ptr[size * (total_elems - 1)];
  100dc8:	4c 8b bd 98 fb ff ff 	mov    -0x468(%rbp),%r15
  100dcf:	49 83 ef 01          	sub    $0x1,%r15
  100dd3:	48 8b bd c8 fb ff ff 	mov    -0x438(%rbp),%rdi
  100dda:	4c 0f af ff          	imul   %rdi,%r15
  100dde:	4c 8b ad a0 fb ff ff 	mov    -0x460(%rbp),%r13
  100de5:	4d 01 ef             	add    %r13,%r15
	char *thresh = min(end_ptr, base_ptr + max_thresh);
  100de8:	48 8b 85 a8 fb ff ff 	mov    -0x458(%rbp),%rax
  100def:	4c 01 e8             	add    %r13,%rax
  100df2:	49 39 c7             	cmp    %rax,%r15
  100df5:	49 0f 46 c7          	cmovbe %r15,%rax
	for (run_ptr = tmp_ptr + size; run_ptr <= thresh; run_ptr += size)
  100df9:	4d 89 ec             	mov    %r13,%r12
  100dfc:	49 01 fc             	add    %rdi,%r12
  100dff:	4c 39 e0             	cmp    %r12,%rax
  100e02:	72 66                	jb     100e6a <__quicksort+0x3b0>
  100e04:	4d 89 e6             	mov    %r12,%r14
	char *tmp_ptr = base_ptr;
  100e07:	4c 89 a5 c0 fb ff ff 	mov    %r12,-0x440(%rbp)
  100e0e:	49 89 c4             	mov    %rax,%r12
	    if ((*cmp) ((void *) run_ptr, (void *) tmp_ptr) < 0)
  100e11:	4c 89 ee             	mov    %r13,%rsi
  100e14:	4c 89 f7             	mov    %r14,%rdi
  100e17:	ff d3                	callq  *%rbx
  100e19:	85 c0                	test   %eax,%eax
  100e1b:	4d 0f 48 ee          	cmovs  %r14,%r13
	for (run_ptr = tmp_ptr + size; run_ptr <= thresh; run_ptr += size)
  100e1f:	4c 03 b5 c8 fb ff ff 	add    -0x438(%rbp),%r14
  100e26:	4d 39 f4             	cmp    %r14,%r12
  100e29:	73 e6                	jae    100e11 <__quicksort+0x357>
  100e2b:	4c 8b a5 c0 fb ff ff 	mov    -0x440(%rbp),%r12
	if (tmp_ptr != base_ptr)
  100e32:	48 8b 85 c8 fb ff ff 	mov    -0x438(%rbp),%rax
  100e39:	49 8d 4c 05 00       	lea    0x0(%r13,%rax,1),%rcx
  100e3e:	48 8b 85 a0 fb ff ff 	mov    -0x460(%rbp),%rax
  100e45:	4c 3b ad a0 fb ff ff 	cmp    -0x460(%rbp),%r13
  100e4c:	74 1c                	je     100e6a <__quicksort+0x3b0>
	    SWAP (tmp_ptr, base_ptr, size);
  100e4e:	41 0f b6 55 00       	movzbl 0x0(%r13),%edx
  100e53:	49 83 c5 01          	add    $0x1,%r13
  100e57:	0f b6 30             	movzbl (%rax),%esi
  100e5a:	41 88 75 ff          	mov    %sil,-0x1(%r13)
  100e5e:	48 83 c0 01          	add    $0x1,%rax
  100e62:	88 50 ff             	mov    %dl,-0x1(%rax)
  100e65:	49 39 cd             	cmp    %rcx,%r13
  100e68:	75 e4                	jne    100e4e <__quicksort+0x394>
	while ((run_ptr += size) <= end_ptr)
  100e6a:	48 8b 85 c8 fb ff ff 	mov    -0x438(%rbp),%rax
  100e71:	4d 8d 34 04          	lea    (%r12,%rax,1),%r14
	    tmp_ptr = run_ptr - size;
  100e75:	48 f7 d8             	neg    %rax
  100e78:	49 89 c5             	mov    %rax,%r13
	while ((run_ptr += size) <= end_ptr)
  100e7b:	4d 39 f7             	cmp    %r14,%r15
  100e7e:	73 15                	jae    100e95 <__quicksort+0x3db>
}
  100e80:	48 81 c4 48 04 00 00 	add    $0x448,%rsp
  100e87:	5b                   	pop    %rbx
  100e88:	41 5c                	pop    %r12
  100e8a:	41 5d                	pop    %r13
  100e8c:	41 5e                	pop    %r14
  100e8e:	41 5f                	pop    %r15
  100e90:	5d                   	pop    %rbp
  100e91:	c3                   	retq   
		tmp_ptr -= size;
  100e92:	4d 01 ec             	add    %r13,%r12
	    while ((*cmp) ((void *) run_ptr, (void *) tmp_ptr) < 0)
  100e95:	4c 89 e6             	mov    %r12,%rsi
  100e98:	4c 89 f7             	mov    %r14,%rdi
  100e9b:	ff d3                	callq  *%rbx
  100e9d:	85 c0                	test   %eax,%eax
  100e9f:	78 f1                	js     100e92 <__quicksort+0x3d8>
	    tmp_ptr += size;
  100ea1:	48 8b 85 c8 fb ff ff 	mov    -0x438(%rbp),%rax
  100ea8:	49 8d 34 04          	lea    (%r12,%rax,1),%rsi
	    if (tmp_ptr != run_ptr)
  100eac:	4c 39 f6             	cmp    %r14,%rsi
  100eaf:	75 17                	jne    100ec8 <__quicksort+0x40e>
	while ((run_ptr += size) <= end_ptr)
  100eb1:	48 8b 85 c8 fb ff ff 	mov    -0x438(%rbp),%rax
  100eb8:	4c 01 f0             	add    %r14,%rax
  100ebb:	4d 89 f4             	mov    %r14,%r12
  100ebe:	49 39 c7             	cmp    %rax,%r15
  100ec1:	72 bd                	jb     100e80 <__quicksort+0x3c6>
  100ec3:	49 89 c6             	mov    %rax,%r14
	    while ((*cmp) ((void *) run_ptr, (void *) tmp_ptr) < 0)
  100ec6:	eb cd                	jmp    100e95 <__quicksort+0x3db>
		while (--trav >= run_ptr)
  100ec8:	49 8d 7c 06 ff       	lea    -0x1(%r14,%rax,1),%rdi
  100ecd:	4c 39 f7             	cmp    %r14,%rdi
  100ed0:	72 df                	jb     100eb1 <__quicksort+0x3f7>
  100ed2:	4d 8d 46 ff          	lea    -0x1(%r14),%r8
  100ed6:	4d 89 c2             	mov    %r8,%r10
  100ed9:	eb 13                	jmp    100eee <__quicksort+0x434>
		    for (hi = lo = trav; (lo -= size) >= tmp_ptr; hi = lo)
  100edb:	48 89 f9             	mov    %rdi,%rcx
		    *hi = c;
  100ede:	44 88 09             	mov    %r9b,(%rcx)
		while (--trav >= run_ptr)
  100ee1:	48 83 ef 01          	sub    $0x1,%rdi
  100ee5:	49 83 e8 01          	sub    $0x1,%r8
  100ee9:	49 39 fa             	cmp    %rdi,%r10
  100eec:	74 c3                	je     100eb1 <__quicksort+0x3f7>
		    char c = *trav;
  100eee:	44 0f b6 0f          	movzbl (%rdi),%r9d
		    for (hi = lo = trav; (lo -= size) >= tmp_ptr; hi = lo)
  100ef2:	4c 89 c0             	mov    %r8,%rax
  100ef5:	4c 39 c6             	cmp    %r8,%rsi
  100ef8:	77 e1                	ja     100edb <__quicksort+0x421>
  100efa:	48 89 fa             	mov    %rdi,%rdx
			*hi = *lo;
  100efd:	0f b6 08             	movzbl (%rax),%ecx
  100f00:	88 0a                	mov    %cl,(%rdx)
		    for (hi = lo = trav; (lo -= size) >= tmp_ptr; hi = lo)
  100f02:	48 89 c1             	mov    %rax,%rcx
  100f05:	4c 01 e8             	add    %r13,%rax
  100f08:	48 2b 95 c8 fb ff ff 	sub    -0x438(%rbp),%rdx
  100f0f:	48 39 c6             	cmp    %rax,%rsi
  100f12:	76 e9                	jbe    100efd <__quicksort+0x443>
  100f14:	eb c8                	jmp    100ede <__quicksort+0x424>

0000000000100f16 <print_ptrs_with_size>:
void print_ptrs_with_size(ptr_with_size *ptrs_with_size, int end) {
  100f16:	55                   	push   %rbp
  100f17:	48 89 e5             	mov    %rsp,%rbp
  100f1a:	41 55                	push   %r13
  100f1c:	41 54                	push   %r12
  100f1e:	53                   	push   %rbx
  100f1f:	48 83 ec 08          	sub    $0x8,%rsp
  100f23:	49 89 fd             	mov    %rdi,%r13
  100f26:	41 89 f4             	mov    %esi,%r12d

// mem_tog
// toggles kernels printing of memory space for process if pid is its processID
// if pid == 0, toggles state globally (preference to global over local)
static inline void mem_tog(pid_t p) {
    asm volatile ("int %0" : /* no result */
  100f29:	bf 00 00 00 00       	mov    $0x0,%edi
  100f2e:	cd 38                	int    $0x38
    mem_tog(0);
    app_printf(1, "Start");
  100f30:	be 77 19 10 00       	mov    $0x101977,%esi
  100f35:	bf 01 00 00 00       	mov    $0x1,%edi
  100f3a:	b8 00 00 00 00       	mov    $0x0,%eax
  100f3f:	e8 66 06 00 00       	callq  1015aa <app_printf>
    for (int i = 0; i < end; i++) {
  100f44:	45 85 e4             	test   %r12d,%r12d
  100f47:	7e 35                	jle    100f7e <print_ptrs_with_size+0x68>
  100f49:	4c 89 eb             	mov    %r13,%rbx
  100f4c:	41 8d 44 24 ff       	lea    -0x1(%r12),%eax
  100f51:	48 c1 e0 04          	shl    $0x4,%rax
  100f55:	4d 8d 64 05 10       	lea    0x10(%r13,%rax,1),%r12
        app_printf(1, " %x-%x ", ptrs_with_size[i].ptr, ptrs_with_size[i].size);
  100f5a:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  100f5e:	48 8b 13             	mov    (%rbx),%rdx
  100f61:	be 7d 19 10 00       	mov    $0x10197d,%esi
  100f66:	bf 01 00 00 00       	mov    $0x1,%edi
  100f6b:	b8 00 00 00 00       	mov    $0x0,%eax
  100f70:	e8 35 06 00 00       	callq  1015aa <app_printf>
    for (int i = 0; i < end; i++) {
  100f75:	48 83 c3 10          	add    $0x10,%rbx
  100f79:	4c 39 e3             	cmp    %r12,%rbx
  100f7c:	75 dc                	jne    100f5a <print_ptrs_with_size+0x44>
    }
    app_printf(1, "End");
  100f7e:	be 85 19 10 00       	mov    $0x101985,%esi
  100f83:	bf 01 00 00 00       	mov    $0x1,%edi
  100f88:	b8 00 00 00 00       	mov    $0x0,%eax
  100f8d:	e8 18 06 00 00       	callq  1015aa <app_printf>
}
  100f92:	48 83 c4 08          	add    $0x8,%rsp
  100f96:	5b                   	pop    %rbx
  100f97:	41 5c                	pop    %r12
  100f99:	41 5d                	pop    %r13
  100f9b:	5d                   	pop    %rbp
  100f9c:	c3                   	retq   

0000000000100f9d <append_free_list_node>:
alloc_header *alloc_list_head = NULL;
alloc_header *alloc_list_tail = NULL;
int alloc_list_length = 0;

void append_free_list_node(free_list_node *node) {
    node->next = NULL;
  100f9d:	48 c7 47 08 00 00 00 	movq   $0x0,0x8(%rdi)
  100fa4:	00 
    node->prev = NULL;
  100fa5:	48 c7 07 00 00 00 00 	movq   $0x0,(%rdi)
    if (free_list_head == NULL && free_list_tail == NULL) {
  100fac:	48 83 3d 94 10 00 00 	cmpq   $0x0,0x1094(%rip)        # 102048 <free_list_head>
  100fb3:	00 
  100fb4:	74 1d                	je     100fd3 <append_free_list_node+0x36>
        free_list_head = node;
        free_list_tail = node;
    } else {
        free_list_tail->next = node;
  100fb6:	48 8b 05 83 10 00 00 	mov    0x1083(%rip),%rax        # 102040 <free_list_tail>
  100fbd:	48 89 78 08          	mov    %rdi,0x8(%rax)
        node->prev = free_list_tail;
  100fc1:	48 89 07             	mov    %rax,(%rdi)
        free_list_tail = node;
  100fc4:	48 89 3d 75 10 00 00 	mov    %rdi,0x1075(%rip)        # 102040 <free_list_tail>
        free_list_tail = node;
    }
    free_list_length++;
  100fcb:	83 05 66 10 00 00 01 	addl   $0x1,0x1066(%rip)        # 102038 <free_list_length>
}
  100fd2:	c3                   	retq   
    if (free_list_head == NULL && free_list_tail == NULL) {
  100fd3:	48 83 3d 65 10 00 00 	cmpq   $0x0,0x1065(%rip)        # 102040 <free_list_tail>
  100fda:	00 
  100fdb:	75 d9                	jne    100fb6 <append_free_list_node+0x19>
        free_list_head = node;
  100fdd:	48 89 3d 64 10 00 00 	mov    %rdi,0x1064(%rip)        # 102048 <free_list_head>
        free_list_tail = node;
  100fe4:	eb de                	jmp    100fc4 <append_free_list_node+0x27>

0000000000100fe6 <remove_free_list_node>:

void remove_free_list_node(free_list_node *node) {
    if (node == free_list_head) free_list_head = node->next;
  100fe6:	48 39 3d 5b 10 00 00 	cmp    %rdi,0x105b(%rip)        # 102048 <free_list_head>
  100fed:	74 30                	je     10101f <remove_free_list_node+0x39>
    if (node == free_list_tail) free_list_tail = node->prev;
  100fef:	48 39 3d 4a 10 00 00 	cmp    %rdi,0x104a(%rip)        # 102040 <free_list_tail>
  100ff6:	74 34                	je     10102c <remove_free_list_node+0x46>
    if (node->prev != NULL) node->prev->next = node->next;
  100ff8:	48 8b 07             	mov    (%rdi),%rax
  100ffb:	48 85 c0             	test   %rax,%rax
  100ffe:	74 08                	je     101008 <remove_free_list_node+0x22>
  101000:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  101004:	48 89 50 08          	mov    %rdx,0x8(%rax)
    if (node->next != NULL) node->next->prev = node->prev;
  101008:	48 8b 47 08          	mov    0x8(%rdi),%rax
  10100c:	48 85 c0             	test   %rax,%rax
  10100f:	74 06                	je     101017 <remove_free_list_node+0x31>
  101011:	48 8b 17             	mov    (%rdi),%rdx
  101014:	48 89 10             	mov    %rdx,(%rax)
    free_list_length--;
  101017:	83 2d 1a 10 00 00 01 	subl   $0x1,0x101a(%rip)        # 102038 <free_list_length>
}
  10101e:	c3                   	retq   
    if (node == free_list_head) free_list_head = node->next;
  10101f:	48 8b 47 08          	mov    0x8(%rdi),%rax
  101023:	48 89 05 1e 10 00 00 	mov    %rax,0x101e(%rip)        # 102048 <free_list_head>
  10102a:	eb c3                	jmp    100fef <remove_free_list_node+0x9>
    if (node == free_list_tail) free_list_tail = node->prev;
  10102c:	48 8b 07             	mov    (%rdi),%rax
  10102f:	48 89 05 0a 10 00 00 	mov    %rax,0x100a(%rip)        # 102040 <free_list_tail>
  101036:	eb c0                	jmp    100ff8 <remove_free_list_node+0x12>

0000000000101038 <append_alloc_list_node>:

void append_alloc_list_node(alloc_header *header) {
    header->next = NULL;
  101038:	48 c7 47 08 00 00 00 	movq   $0x0,0x8(%rdi)
  10103f:	00 
    header->prev = NULL;
  101040:	48 c7 07 00 00 00 00 	movq   $0x0,(%rdi)
    if (alloc_list_head == NULL && alloc_list_tail == NULL) {
  101047:	48 83 3d e1 0f 00 00 	cmpq   $0x0,0xfe1(%rip)        # 102030 <alloc_list_head>
  10104e:	00 
  10104f:	74 1d                	je     10106e <append_alloc_list_node+0x36>
        alloc_list_head = header;
        alloc_list_tail = header;
    } else {
        alloc_list_tail->next = header;
  101051:	48 8b 05 d0 0f 00 00 	mov    0xfd0(%rip),%rax        # 102028 <alloc_list_tail>
  101058:	48 89 78 08          	mov    %rdi,0x8(%rax)
        header->prev = alloc_list_tail;
  10105c:	48 89 07             	mov    %rax,(%rdi)
        alloc_list_tail = header;
  10105f:	48 89 3d c2 0f 00 00 	mov    %rdi,0xfc2(%rip)        # 102028 <alloc_list_tail>
        alloc_list_tail = header;
    }
    alloc_list_length++;
  101066:	83 05 b3 0f 00 00 01 	addl   $0x1,0xfb3(%rip)        # 102020 <alloc_list_length>
}
  10106d:	c3                   	retq   
    if (alloc_list_head == NULL && alloc_list_tail == NULL) {
  10106e:	48 83 3d b2 0f 00 00 	cmpq   $0x0,0xfb2(%rip)        # 102028 <alloc_list_tail>
  101075:	00 
  101076:	75 d9                	jne    101051 <append_alloc_list_node+0x19>
        alloc_list_head = header;
  101078:	48 89 3d b1 0f 00 00 	mov    %rdi,0xfb1(%rip)        # 102030 <alloc_list_head>
        alloc_list_tail = header;
  10107f:	eb de                	jmp    10105f <append_alloc_list_node+0x27>

0000000000101081 <remove_alloc_list_node>:

void remove_alloc_list_node(alloc_header *header) {
    if (header == alloc_list_head) alloc_list_head = header->next;
  101081:	48 39 3d a8 0f 00 00 	cmp    %rdi,0xfa8(%rip)        # 102030 <alloc_list_head>
  101088:	74 30                	je     1010ba <remove_alloc_list_node+0x39>
    if (header == alloc_list_tail) alloc_list_tail = header->prev;
  10108a:	48 39 3d 97 0f 00 00 	cmp    %rdi,0xf97(%rip)        # 102028 <alloc_list_tail>
  101091:	74 34                	je     1010c7 <remove_alloc_list_node+0x46>
    if (header->prev != NULL) header->prev->next = header->next;
  101093:	48 8b 07             	mov    (%rdi),%rax
  101096:	48 85 c0             	test   %rax,%rax
  101099:	74 08                	je     1010a3 <remove_alloc_list_node+0x22>
  10109b:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  10109f:	48 89 50 08          	mov    %rdx,0x8(%rax)
    if (header->next != NULL) header->next->prev = header->prev;
  1010a3:	48 8b 47 08          	mov    0x8(%rdi),%rax
  1010a7:	48 85 c0             	test   %rax,%rax
  1010aa:	74 06                	je     1010b2 <remove_alloc_list_node+0x31>
  1010ac:	48 8b 17             	mov    (%rdi),%rdx
  1010af:	48 89 10             	mov    %rdx,(%rax)
    alloc_list_length--;
  1010b2:	83 2d 67 0f 00 00 01 	subl   $0x1,0xf67(%rip)        # 102020 <alloc_list_length>
}
  1010b9:	c3                   	retq   
    if (header == alloc_list_head) alloc_list_head = header->next;
  1010ba:	48 8b 47 08          	mov    0x8(%rdi),%rax
  1010be:	48 89 05 6b 0f 00 00 	mov    %rax,0xf6b(%rip)        # 102030 <alloc_list_head>
  1010c5:	eb c3                	jmp    10108a <remove_alloc_list_node+0x9>
    if (header == alloc_list_tail) alloc_list_tail = header->prev;
  1010c7:	48 8b 07             	mov    (%rdi),%rax
  1010ca:	48 89 05 57 0f 00 00 	mov    %rax,0xf57(%rip)        # 102028 <alloc_list_tail>
  1010d1:	eb c0                	jmp    101093 <remove_alloc_list_node+0x12>

00000000001010d3 <get_free_block>:

struct free_list_node *get_free_block(uint64_t payload_sz) {
    free_list_node *ptr = free_list_head;
  1010d3:	48 8b 05 6e 0f 00 00 	mov    0xf6e(%rip),%rax        # 102048 <free_list_head>
    while (ptr != NULL) {
  1010da:	48 85 c0             	test   %rax,%rax
  1010dd:	74 13                	je     1010f2 <get_free_block+0x1f>
        if (ptr->sz >= ALLOC_HEADER_SIZE + payload_sz) return ptr;
  1010df:	48 83 c7 18          	add    $0x18,%rdi
  1010e3:	48 39 78 10          	cmp    %rdi,0x10(%rax)
  1010e7:	73 09                	jae    1010f2 <get_free_block+0x1f>
        ptr = ptr->next;
  1010e9:	48 8b 40 08          	mov    0x8(%rax),%rax
    while (ptr != NULL) {
  1010ed:	48 85 c0             	test   %rax,%rax
  1010f0:	75 f1                	jne    1010e3 <get_free_block+0x10>
    }
    return NULL;
}
  1010f2:	c3                   	retq   

00000000001010f3 <extend_heap>:


struct free_list_node *extend_heap(size_t sz) {
  1010f3:	55                   	push   %rbp
  1010f4:	48 89 e5             	mov    %rsp,%rbp
  1010f7:	53                   	push   %rbx
  1010f8:	48 83 ec 08          	sub    $0x8,%rsp
    size_t heap_extension = ROUNDUP(sz, BREAK_INCREMENT);
  1010fc:	48 8d 97 ff 9f 00 00 	lea    0x9fff(%rdi),%rdx
  101103:	48 b9 cd cc cc cc cc 	movabs $0xcccccccccccccccd,%rcx
  10110a:	cc cc cc 
  10110d:	48 89 d0             	mov    %rdx,%rax
  101110:	48 f7 e1             	mul    %rcx
  101113:	48 c1 ea 0f          	shr    $0xf,%rdx
  101117:	48 8d 3c 92          	lea    (%rdx,%rdx,4),%rdi
  10111b:	48 c1 e7 0d          	shl    $0xd,%rdi
//     On success, sbrk() returns the previous program break
//     (If the break was increased, then this value is a pointer to the start of the newly allocated memory)
//      On error, (void *) -1 is returned
static inline void * sbrk(const intptr_t increment) {
    static void * result;
    asm volatile ("int %1" :  "=a" (result)
  10111f:	cd 3a                	int    $0x3a
  101121:	48 89 05 28 0f 00 00 	mov    %rax,0xf28(%rip)        # 102050 <result.0>
    void *start = sbrk(heap_extension);
    if (start == (void *) -1) return NULL;
  101128:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  10112c:	74 18                	je     101146 <extend_heap+0x53>
  10112e:	48 89 c3             	mov    %rax,%rbx
    struct free_list_node *node = (struct free_list_node *) start;
    node->sz = heap_extension;
  101131:	48 89 78 10          	mov    %rdi,0x10(%rax)
    append_free_list_node(node);
  101135:	48 89 c7             	mov    %rax,%rdi
  101138:	e8 60 fe ff ff       	callq  100f9d <append_free_list_node>
    return node;
}
  10113d:	48 89 d8             	mov    %rbx,%rax
  101140:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  101144:	c9                   	leaveq 
  101145:	c3                   	retq   
    if (start == (void *) -1) return NULL;
  101146:	bb 00 00 00 00       	mov    $0x0,%ebx
  10114b:	eb f0                	jmp    10113d <extend_heap+0x4a>

000000000010114d <allocate_to_free_block>:

// returns address of the block (alloc_header) if allocated properly
// NULL if there was no space
uintptr_t allocate_to_free_block(uint64_t sz) {
  10114d:	55                   	push   %rbp
  10114e:	48 89 e5             	mov    %rsp,%rbp
  101151:	41 56                	push   %r14
  101153:	41 55                	push   %r13
  101155:	41 54                	push   %r12
  101157:	53                   	push   %rbx
  101158:	48 89 fb             	mov    %rdi,%rbx
    free_list_node *free_block = get_free_block(sz);
  10115b:	e8 73 ff ff ff       	callq  1010d3 <get_free_block>
    if (free_block == NULL) return (uintptr_t) -1;
  101160:	48 85 c0             	test   %rax,%rax
  101163:	74 54                	je     1011b9 <allocate_to_free_block+0x6c>
  101165:	49 89 c4             	mov    %rax,%r12

    uintptr_t block_addr = (uintptr_t) free_block;
  101168:	49 89 c6             	mov    %rax,%r14
    size_t block_size = free_block->sz;
  10116b:	4c 8b 68 10          	mov    0x10(%rax),%r13
    remove_free_list_node(free_block);
  10116f:	48 89 c7             	mov    %rax,%rdi
  101172:	e8 6f fe ff ff       	callq  100fe6 <remove_free_list_node>

    struct alloc_header *header = (struct alloc_header *) block_addr;
    size_t payload_size = ROUNDUP(sz, ALIGNMENT);
  101177:	48 83 c3 07          	add    $0x7,%rbx
  10117b:	48 83 e3 f8          	and    $0xfffffffffffffff8,%rbx
    size_t min_payload_size = FREE_LIST_NODE_SIZE - ALLOC_HEADER_SIZE;
    if (payload_size < min_payload_size) payload_size = min_payload_size;
    header->sz = payload_size;
  10117f:	49 89 5c 24 10       	mov    %rbx,0x10(%r12)
    append_alloc_list_node(header);
  101184:	4c 89 e7             	mov    %r12,%rdi
  101187:	e8 ac fe ff ff       	callq  101038 <append_alloc_list_node>

    size_t data_size = ALLOC_HEADER_SIZE + payload_size;
  10118c:	48 83 c3 18          	add    $0x18,%rbx
    size_t leftover = block_size - data_size;
  101190:	49 29 dd             	sub    %rbx,%r13

    if (leftover >= FREE_LIST_NODE_SIZE) {
  101193:	49 83 fd 17          	cmp    $0x17,%r13
  101197:	77 11                	ja     1011aa <allocate_to_free_block+0x5d>
        struct free_list_node *node = (struct free_list_node *) (block_addr + data_size);
        node->sz = leftover;
        append_free_list_node(node);
    } else header->sz += leftover;
  101199:	4d 01 6c 24 10       	add    %r13,0x10(%r12)

    return block_addr;
}
  10119e:	4c 89 f0             	mov    %r14,%rax
  1011a1:	5b                   	pop    %rbx
  1011a2:	41 5c                	pop    %r12
  1011a4:	41 5d                	pop    %r13
  1011a6:	41 5e                	pop    %r14
  1011a8:	5d                   	pop    %rbp
  1011a9:	c3                   	retq   
        struct free_list_node *node = (struct free_list_node *) (block_addr + data_size);
  1011aa:	49 8d 3c 1c          	lea    (%r12,%rbx,1),%rdi
        node->sz = leftover;
  1011ae:	4c 89 6f 10          	mov    %r13,0x10(%rdi)
        append_free_list_node(node);
  1011b2:	e8 e6 fd ff ff       	callq  100f9d <append_free_list_node>
  1011b7:	eb e5                	jmp    10119e <allocate_to_free_block+0x51>
    if (free_block == NULL) return (uintptr_t) -1;
  1011b9:	49 c7 c6 ff ff ff ff 	mov    $0xffffffffffffffff,%r14
  1011c0:	eb dc                	jmp    10119e <allocate_to_free_block+0x51>

00000000001011c2 <malloc>:
// allocates sz bytes of uninitialized memory and returns a pointer to the allocated memory
// if sz == 0, then malloc() either returns NULL or a unique pointer value that can be
// successfully passed to a later free
// the pointer should be aligned to 8 bytes
void *malloc(uint64_t sz) {
    if (sz == 0) return NULL;
  1011c2:	b8 00 00 00 00       	mov    $0x0,%eax
  1011c7:	48 85 ff             	test   %rdi,%rdi
  1011ca:	74 3c                	je     101208 <malloc+0x46>
void *malloc(uint64_t sz) {
  1011cc:	55                   	push   %rbp
  1011cd:	48 89 e5             	mov    %rsp,%rbp
  1011d0:	53                   	push   %rbx
  1011d1:	48 83 ec 08          	sub    $0x8,%rsp
  1011d5:	48 89 fb             	mov    %rdi,%rbx

    uintptr_t block_addr = allocate_to_free_block(sz);
  1011d8:	e8 70 ff ff ff       	callq  10114d <allocate_to_free_block>
    while (block_addr == (uintptr_t) -1) {
  1011dd:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  1011e1:	75 1b                	jne    1011fe <malloc+0x3c>
        if (extend_heap(sz) == NULL) return NULL;
  1011e3:	48 89 df             	mov    %rbx,%rdi
  1011e6:	e8 08 ff ff ff       	callq  1010f3 <extend_heap>
  1011eb:	48 85 c0             	test   %rax,%rax
  1011ee:	74 12                	je     101202 <malloc+0x40>
        block_addr = allocate_to_free_block(sz);
  1011f0:	48 89 df             	mov    %rbx,%rdi
  1011f3:	e8 55 ff ff ff       	callq  10114d <allocate_to_free_block>
    while (block_addr == (uintptr_t) -1) {
  1011f8:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  1011fc:	74 e5                	je     1011e3 <malloc+0x21>
    }

    return (void *) (block_addr + ALLOC_HEADER_SIZE);
  1011fe:	48 83 c0 18          	add    $0x18,%rax
}
  101202:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  101206:	c9                   	leaveq 
  101207:	c3                   	retq   
  101208:	c3                   	retq   

0000000000101209 <overflow>:
// to the allocated array. The memory is set to 0. if num or sz is equal to 0, then calloc
// returns NULL or a unique pointer value that can be successfully passed to a later free
// calloc also checks for size overflow caused by num*sz
// returns NULL on failure
int overflow(uint64_t a, uint64_t b) {
    return a * b / a != b || a * b / b != a;
  101209:	48 89 f9             	mov    %rdi,%rcx
  10120c:	48 0f af ce          	imul   %rsi,%rcx
  101210:	48 89 c8             	mov    %rcx,%rax
  101213:	ba 00 00 00 00       	mov    $0x0,%edx
  101218:	48 f7 f7             	div    %rdi
  10121b:	ba 01 00 00 00       	mov    $0x1,%edx
  101220:	48 39 f0             	cmp    %rsi,%rax
  101223:	74 03                	je     101228 <overflow+0x1f>
}
  101225:	89 d0                	mov    %edx,%eax
  101227:	c3                   	retq   
    return a * b / a != b || a * b / b != a;
  101228:	48 89 c8             	mov    %rcx,%rax
  10122b:	ba 00 00 00 00       	mov    $0x0,%edx
  101230:	48 f7 f6             	div    %rsi
  101233:	48 39 f8             	cmp    %rdi,%rax
  101236:	0f 95 c2             	setne  %dl
  101239:	0f b6 d2             	movzbl %dl,%edx
  10123c:	eb e7                	jmp    101225 <overflow+0x1c>

000000000010123e <calloc>:

void *calloc(uint64_t num, uint64_t sz) {
  10123e:	55                   	push   %rbp
  10123f:	48 89 e5             	mov    %rsp,%rbp
  101242:	41 55                	push   %r13
  101244:	41 54                	push   %r12
  101246:	53                   	push   %rbx
  101247:	48 83 ec 08          	sub    $0x8,%rsp
    if (num == 0 || sz == 0 || overflow(num, sz)) return NULL;
  10124b:	48 85 ff             	test   %rdi,%rdi
  10124e:	74 54                	je     1012a4 <calloc+0x66>
  101250:	48 89 fb             	mov    %rdi,%rbx
  101253:	49 89 f4             	mov    %rsi,%r12
  101256:	48 85 f6             	test   %rsi,%rsi
  101259:	74 49                	je     1012a4 <calloc+0x66>
  10125b:	e8 a9 ff ff ff       	callq  101209 <overflow>
  101260:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  101266:	85 c0                	test   %eax,%eax
  101268:	75 2c                	jne    101296 <calloc+0x58>

    size_t size = ROUNDUP(num * sz, ALIGNMENT);
  10126a:	49 0f af dc          	imul   %r12,%rbx
  10126e:	48 83 c3 07          	add    $0x7,%rbx
  101272:	48 83 e3 f8          	and    $0xfffffffffffffff8,%rbx
    void *malloc_addr = malloc(size);
  101276:	48 89 df             	mov    %rbx,%rdi
  101279:	e8 44 ff ff ff       	callq  1011c2 <malloc>
  10127e:	49 89 c5             	mov    %rax,%r13
    if (malloc_addr == NULL) return NULL;
  101281:	48 85 c0             	test   %rax,%rax
  101284:	74 10                	je     101296 <calloc+0x58>

    memset(malloc_addr, 0, size);
  101286:	48 89 da             	mov    %rbx,%rdx
  101289:	be 00 00 00 00       	mov    $0x0,%esi
  10128e:	48 89 c7             	mov    %rax,%rdi
  101291:	e8 0a ef ff ff       	callq  1001a0 <memset>
    return malloc_addr;
}
  101296:	4c 89 e8             	mov    %r13,%rax
  101299:	48 83 c4 08          	add    $0x8,%rsp
  10129d:	5b                   	pop    %rbx
  10129e:	41 5c                	pop    %r12
  1012a0:	41 5d                	pop    %r13
  1012a2:	5d                   	pop    %rbp
  1012a3:	c3                   	retq   
    if (num == 0 || sz == 0 || overflow(num, sz)) return NULL;
  1012a4:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  1012aa:	eb ea                	jmp    101296 <calloc+0x58>

00000000001012ac <free>:
// the free funtion frees the memory space pointed to by ptr, which must have been returned
// by a previous call to malloc or realloc, or if free has already been called before, then
// undefined behavior occurs
// if ptr == NULL, then no operation happens
void free(void *ptr) {
    if (ptr == NULL) return;
  1012ac:	48 85 ff             	test   %rdi,%rdi
  1012af:	74 2c                	je     1012dd <free+0x31>
void free(void *ptr) {
  1012b1:	55                   	push   %rbp
  1012b2:	48 89 e5             	mov    %rsp,%rbp
  1012b5:	41 54                	push   %r12
  1012b7:	53                   	push   %rbx

    uintptr_t block_addr = (uintptr_t) ptr - ALLOC_HEADER_SIZE;
  1012b8:	48 8d 5f e8          	lea    -0x18(%rdi),%rbx
    struct alloc_header *header = (struct alloc_header *) block_addr;
    size_t block_size = ALLOC_HEADER_SIZE + header->sz;
  1012bc:	48 8b 47 f8          	mov    -0x8(%rdi),%rax
  1012c0:	4c 8d 60 18          	lea    0x18(%rax),%r12
    remove_alloc_list_node(header);
  1012c4:	48 89 df             	mov    %rbx,%rdi
  1012c7:	e8 b5 fd ff ff       	callq  101081 <remove_alloc_list_node>

    struct free_list_node *node = (struct free_list_node *) block_addr;
    node->sz = block_size;
  1012cc:	4c 89 63 10          	mov    %r12,0x10(%rbx)
    append_free_list_node(node);
  1012d0:	48 89 df             	mov    %rbx,%rdi
  1012d3:	e8 c5 fc ff ff       	callq  100f9d <append_free_list_node>
    return;
}
  1012d8:	5b                   	pop    %rbx
  1012d9:	41 5c                	pop    %r12
  1012db:	5d                   	pop    %rbp
  1012dc:	c3                   	retq   
  1012dd:	c3                   	retq   

00000000001012de <realloc>:
void *realloc(void * ptr, uint64_t sz) {
  1012de:	55                   	push   %rbp
  1012df:	48 89 e5             	mov    %rsp,%rbp
  1012e2:	41 54                	push   %r12
  1012e4:	53                   	push   %rbx
    if (ptr == NULL) return malloc(sz);
  1012e5:	48 85 ff             	test   %rdi,%rdi
  1012e8:	74 40                	je     10132a <realloc+0x4c>
  1012ea:	48 89 fb             	mov    %rdi,%rbx
    if (sz == 0) { free(ptr); return NULL; }
  1012ed:	48 85 f6             	test   %rsi,%rsi
  1012f0:	74 45                	je     101337 <realloc+0x59>
    if (original_sz == sz) return ptr;
  1012f2:	49 89 fc             	mov    %rdi,%r12
  1012f5:	48 3b 77 f8          	cmp    -0x8(%rdi),%rsi
  1012f9:	74 27                	je     101322 <realloc+0x44>
    void *malloc_addr = malloc(sz);
  1012fb:	48 89 f7             	mov    %rsi,%rdi
  1012fe:	e8 bf fe ff ff       	callq  1011c2 <malloc>
  101303:	49 89 c4             	mov    %rax,%r12
    if (malloc_addr == NULL) return NULL;
  101306:	48 85 c0             	test   %rax,%rax
  101309:	74 17                	je     101322 <realloc+0x44>
    memcpy(malloc_addr, ptr, header->sz);
  10130b:	48 8b 50 f8          	mov    -0x8(%rax),%rdx
  10130f:	48 89 de             	mov    %rbx,%rsi
  101312:	48 89 c7             	mov    %rax,%rdi
  101315:	e8 1d ee ff ff       	callq  100137 <memcpy>
    free(ptr);
  10131a:	48 89 df             	mov    %rbx,%rdi
  10131d:	e8 8a ff ff ff       	callq  1012ac <free>
}
  101322:	4c 89 e0             	mov    %r12,%rax
  101325:	5b                   	pop    %rbx
  101326:	41 5c                	pop    %r12
  101328:	5d                   	pop    %rbp
  101329:	c3                   	retq   
    if (ptr == NULL) return malloc(sz);
  10132a:	48 89 f7             	mov    %rsi,%rdi
  10132d:	e8 90 fe ff ff       	callq  1011c2 <malloc>
  101332:	49 89 c4             	mov    %rax,%r12
  101335:	eb eb                	jmp    101322 <realloc+0x44>
    if (sz == 0) { free(ptr); return NULL; }
  101337:	e8 70 ff ff ff       	callq  1012ac <free>
  10133c:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  101342:	eb de                	jmp    101322 <realloc+0x44>

0000000000101344 <adjacent>:

int adjacent(ptr_with_size *ptrs_with_size, int i, int j) {
    ptr_with_size a = ptrs_with_size[i];
  101344:	48 63 f6             	movslq %esi,%rsi
  101347:	48 c1 e6 04          	shl    $0x4,%rsi
  10134b:	48 01 fe             	add    %rdi,%rsi
    ptr_with_size b = ptrs_with_size[j];
    return (uintptr_t) a.ptr + a.size == (uintptr_t) b.ptr;
  10134e:	48 8b 46 08          	mov    0x8(%rsi),%rax
  101352:	48 03 06             	add    (%rsi),%rax
    ptr_with_size b = ptrs_with_size[j];
  101355:	48 63 d2             	movslq %edx,%rdx
  101358:	48 c1 e2 04          	shl    $0x4,%rdx
    return (uintptr_t) a.ptr + a.size == (uintptr_t) b.ptr;
  10135c:	48 39 04 17          	cmp    %rax,(%rdi,%rdx,1)
  101360:	0f 94 c0             	sete   %al
  101363:	0f b6 c0             	movzbl %al,%eax
}
  101366:	c3                   	retq   

0000000000101367 <coalesce>:

void coalesce(ptr_with_size *ptrs_with_size, int i, int j) {
  101367:	55                   	push   %rbp
  101368:	48 89 e5             	mov    %rsp,%rbp
    struct free_list_node *node_a = (struct free_list_node *) ptrs_with_size[i].ptr;
  10136b:	48 63 f6             	movslq %esi,%rsi
  10136e:	48 c1 e6 04          	shl    $0x4,%rsi
  101372:	48 8b 04 37          	mov    (%rdi,%rsi,1),%rax
    struct free_list_node *node_b = (struct free_list_node *) ptrs_with_size[j].ptr;
  101376:	48 63 d2             	movslq %edx,%rdx
  101379:	48 c1 e2 04          	shl    $0x4,%rdx
  10137d:	48 8b 3c 17          	mov    (%rdi,%rdx,1),%rdi
    node_a->sz += node_b->sz;
  101381:	48 8b 57 10          	mov    0x10(%rdi),%rdx
  101385:	48 01 50 10          	add    %rdx,0x10(%rax)
    remove_free_list_node(node_b);
  101389:	e8 58 fc ff ff       	callq  100fe6 <remove_free_list_node>
}
  10138e:	5d                   	pop    %rbp
  10138f:	c3                   	retq   

0000000000101390 <defrag>:

void defrag() {
  101390:	55                   	push   %rbp
  101391:	48 89 e5             	mov    %rsp,%rbp
  101394:	41 55                	push   %r13
  101396:	41 54                	push   %r12
  101398:	53                   	push   %rbx
  101399:	48 83 ec 08          	sub    $0x8,%rsp
    ptr_with_size ptrs_with_size[free_list_length];
  10139d:	8b 0d 95 0c 00 00    	mov    0xc95(%rip),%ecx        # 102038 <free_list_length>
  1013a3:	48 63 f1             	movslq %ecx,%rsi
  1013a6:	48 89 f0             	mov    %rsi,%rax
  1013a9:	48 c1 e0 04          	shl    $0x4,%rax
  1013ad:	48 29 c4             	sub    %rax,%rsp
  1013b0:	49 89 e5             	mov    %rsp,%r13
    free_list_node *curr = free_list_head;
  1013b3:	48 8b 15 8e 0c 00 00 	mov    0xc8e(%rip),%rdx        # 102048 <free_list_head>
    for (int i = 0; i < free_list_length; i++, curr = curr->next) {
  1013ba:	85 c9                	test   %ecx,%ecx
  1013bc:	7e 24                	jle    1013e2 <defrag+0x52>
  1013be:	4c 89 e8             	mov    %r13,%rax
  1013c1:	89 c9                	mov    %ecx,%ecx
  1013c3:	48 c1 e1 04          	shl    $0x4,%rcx
  1013c7:	4c 01 e9             	add    %r13,%rcx
        ptrs_with_size[i].ptr = curr;
  1013ca:	48 89 10             	mov    %rdx,(%rax)
        ptrs_with_size[i].size = curr->sz;
  1013cd:	48 8b 7a 10          	mov    0x10(%rdx),%rdi
  1013d1:	48 89 78 08          	mov    %rdi,0x8(%rax)
    for (int i = 0; i < free_list_length; i++, curr = curr->next) {
  1013d5:	48 8b 52 08          	mov    0x8(%rdx),%rdx
  1013d9:	48 83 c0 10          	add    $0x10,%rax
  1013dd:	48 39 c8             	cmp    %rcx,%rax
  1013e0:	75 e8                	jne    1013ca <defrag+0x3a>
    }
    __quicksort(ptrs_with_size, free_list_length, sizeof(ptrs_with_size[0]), &ptr_comparator_ptr_ascending);
  1013e2:	b9 ac 0a 10 00       	mov    $0x100aac,%ecx
  1013e7:	ba 10 00 00 00       	mov    $0x10,%edx
  1013ec:	4c 89 ef             	mov    %r13,%rdi
  1013ef:	e8 c6 f6 ff ff       	callq  100aba <__quicksort>

    int i = 0, j = 1;
    for (; j < free_list_length; j++) {
  1013f4:	83 3d 3d 0c 00 00 01 	cmpl   $0x1,0xc3d(%rip)        # 102038 <free_list_length>
  1013fb:	7e 3b                	jle    101438 <defrag+0xa8>
    int i = 0, j = 1;
  1013fd:	bb 01 00 00 00       	mov    $0x1,%ebx
  101402:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  101408:	eb 18                	jmp    101422 <defrag+0x92>
        if (adjacent(ptrs_with_size, i, j)) coalesce(ptrs_with_size, i, j);
  10140a:	89 da                	mov    %ebx,%edx
  10140c:	44 89 e6             	mov    %r12d,%esi
  10140f:	4c 89 ef             	mov    %r13,%rdi
  101412:	e8 50 ff ff ff       	callq  101367 <coalesce>
    for (; j < free_list_length; j++) {
  101417:	83 c3 01             	add    $0x1,%ebx
  10141a:	39 1d 18 0c 00 00    	cmp    %ebx,0xc18(%rip)        # 102038 <free_list_length>
  101420:	7e 16                	jle    101438 <defrag+0xa8>
        if (adjacent(ptrs_with_size, i, j)) coalesce(ptrs_with_size, i, j);
  101422:	89 da                	mov    %ebx,%edx
  101424:	44 89 e6             	mov    %r12d,%esi
  101427:	4c 89 ef             	mov    %r13,%rdi
  10142a:	e8 15 ff ff ff       	callq  101344 <adjacent>
  10142f:	85 c0                	test   %eax,%eax
  101431:	75 d7                	jne    10140a <defrag+0x7a>
  101433:	41 89 dc             	mov    %ebx,%r12d
  101436:	eb df                	jmp    101417 <defrag+0x87>
        else i = j;
    }
}
  101438:	48 8d 65 e8          	lea    -0x18(%rbp),%rsp
  10143c:	5b                   	pop    %rbx
  10143d:	41 5c                	pop    %r12
  10143f:	41 5d                	pop    %r13
  101441:	5d                   	pop    %rbp
  101442:	c3                   	retq   

0000000000101443 <heap_info>:
// and should NOT be included in the heap info
// return 0 for a successfull call
// if for any reason the information cannot be saved, return -1


int heap_info(heap_info_struct * info) {
  101443:	55                   	push   %rbp
  101444:	48 89 e5             	mov    %rsp,%rbp
  101447:	41 56                	push   %r14
  101449:	41 55                	push   %r13
  10144b:	41 54                	push   %r12
  10144d:	53                   	push   %rbx
  10144e:	48 89 fb             	mov    %rdi,%rbx
    // alloc_list_length
    info->num_allocs = alloc_list_length;
  101451:	8b 0d c9 0b 00 00    	mov    0xbc9(%rip),%ecx        # 102020 <alloc_list_length>
  101457:	89 0f                	mov    %ecx,(%rdi)

    // size+ptr arrays
    if (alloc_list_length == 0) {
  101459:	85 c9                	test   %ecx,%ecx
  10145b:	75 68                	jne    1014c5 <heap_info+0x82>
        info->size_array = NULL;
  10145d:	48 c7 47 08 00 00 00 	movq   $0x0,0x8(%rdi)
  101464:	00 
        info->ptr_array = NULL;
  101465:	48 c7 47 10 00 00 00 	movq   $0x0,0x10(%rdi)
  10146c:	00 
    }
   
    // free space
    size_t free_space = 0;
    size_t largest_free_chunk = 0;
    free_list_node *curr_ = free_list_head;
  10146d:	48 8b 0d d4 0b 00 00 	mov    0xbd4(%rip),%rcx        # 102048 <free_list_head>
    for (int i = 0; i < free_list_length; i++, curr_ = curr_->next) {
  101474:	44 8b 05 bd 0b 00 00 	mov    0xbbd(%rip),%r8d        # 102038 <free_list_length>
  10147b:	45 85 c0             	test   %r8d,%r8d
  10147e:	0f 8e 17 01 00 00    	jle    10159b <heap_info+0x158>
  101484:	be 00 00 00 00       	mov    $0x0,%esi
    size_t largest_free_chunk = 0;
  101489:	ba 00 00 00 00       	mov    $0x0,%edx
    size_t free_space = 0;
  10148e:	bf 00 00 00 00       	mov    $0x0,%edi
        largest_free_chunk = MAX(largest_free_chunk, curr_->sz);
  101493:	48 8b 41 10          	mov    0x10(%rcx),%rax
  101497:	48 39 c2             	cmp    %rax,%rdx
  10149a:	48 0f 42 d0          	cmovb  %rax,%rdx
        free_space += curr_->sz;
  10149e:	48 01 c7             	add    %rax,%rdi
    for (int i = 0; i < free_list_length; i++, curr_ = curr_->next) {
  1014a1:	83 c6 01             	add    $0x1,%esi
  1014a4:	48 8b 49 08          	mov    0x8(%rcx),%rcx
  1014a8:	44 39 c6             	cmp    %r8d,%esi
  1014ab:	75 e6                	jne    101493 <heap_info+0x50>
    }
    info->free_space = (int) free_space;
  1014ad:	89 7b 18             	mov    %edi,0x18(%rbx)
    info->largest_free_chunk = (int) largest_free_chunk;
  1014b0:	89 53 1c             	mov    %edx,0x1c(%rbx)
    
    return 0;
  1014b3:	b8 00 00 00 00       	mov    $0x0,%eax
  1014b8:	48 8d 65 e0          	lea    -0x20(%rbp),%rsp
  1014bc:	5b                   	pop    %rbx
  1014bd:	41 5c                	pop    %r12
  1014bf:	41 5d                	pop    %r13
  1014c1:	41 5e                	pop    %r14
  1014c3:	5d                   	pop    %rbp
  1014c4:	c3                   	retq   
    } else {
  1014c5:	49 89 e4             	mov    %rsp,%r12
        ptr_with_size ptrs_with_size[alloc_list_length];
  1014c8:	48 63 f9             	movslq %ecx,%rdi
  1014cb:	48 89 f8             	mov    %rdi,%rax
  1014ce:	48 c1 e0 04          	shl    $0x4,%rax
  1014d2:	48 29 c4             	sub    %rax,%rsp
  1014d5:	49 89 e6             	mov    %rsp,%r14
        alloc_header *curr = alloc_list_head;
  1014d8:	48 8b 15 51 0b 00 00 	mov    0xb51(%rip),%rdx        # 102030 <alloc_list_head>
        for (int i = 0; i < alloc_list_length; i++, curr = curr->next) {
  1014df:	85 c9                	test   %ecx,%ecx
  1014e1:	7e 28                	jle    10150b <heap_info+0xc8>
  1014e3:	4c 89 f0             	mov    %r14,%rax
  1014e6:	89 c9                	mov    %ecx,%ecx
  1014e8:	48 c1 e1 04          	shl    $0x4,%rcx
  1014ec:	4c 01 f1             	add    %r14,%rcx
            ptrs_with_size[i].ptr = (void *) ((uintptr_t) curr + ALLOC_HEADER_SIZE);
  1014ef:	48 8d 72 18          	lea    0x18(%rdx),%rsi
  1014f3:	48 89 30             	mov    %rsi,(%rax)
            ptrs_with_size[i].size = curr->sz;
  1014f6:	48 8b 72 10          	mov    0x10(%rdx),%rsi
  1014fa:	48 89 70 08          	mov    %rsi,0x8(%rax)
        for (int i = 0; i < alloc_list_length; i++, curr = curr->next) {
  1014fe:	48 8b 52 08          	mov    0x8(%rdx),%rdx
  101502:	48 83 c0 10          	add    $0x10,%rax
  101506:	48 39 c8             	cmp    %rcx,%rax
  101509:	75 e4                	jne    1014ef <heap_info+0xac>
        __quicksort(ptrs_with_size, alloc_list_length, sizeof(ptrs_with_size[0]), &ptr_comparator_size_descending);
  10150b:	b9 b2 0a 10 00       	mov    $0x100ab2,%ecx
  101510:	ba 10 00 00 00       	mov    $0x10,%edx
  101515:	48 89 fe             	mov    %rdi,%rsi
  101518:	4c 89 f7             	mov    %r14,%rdi
  10151b:	e8 9a f5 ff ff       	callq  100aba <__quicksort>
        long *size_array = (long *) malloc(sizeof(long) * alloc_list_length);
  101520:	48 63 3d f9 0a 00 00 	movslq 0xaf9(%rip),%rdi        # 102020 <alloc_list_length>
  101527:	48 c1 e7 03          	shl    $0x3,%rdi
  10152b:	e8 92 fc ff ff       	callq  1011c2 <malloc>
  101530:	49 89 c5             	mov    %rax,%r13
        uintptr_t *ptr_array = (uintptr_t *) malloc(sizeof(uintptr_t) * alloc_list_length);
  101533:	48 63 3d e6 0a 00 00 	movslq 0xae6(%rip),%rdi        # 102020 <alloc_list_length>
  10153a:	48 c1 e7 03          	shl    $0x3,%rdi
  10153e:	e8 7f fc ff ff       	callq  1011c2 <malloc>
        if (size_array == NULL || ptr_array == NULL) return -1;
  101543:	4d 85 ed             	test   %r13,%r13
  101546:	74 46                	je     10158e <heap_info+0x14b>
  101548:	48 85 c0             	test   %rax,%rax
  10154b:	74 41                	je     10158e <heap_info+0x14b>
        for (int i = 0; i < alloc_list_length; i++) {
  10154d:	4c 89 f1             	mov    %r14,%rcx
  101550:	ba 00 00 00 00       	mov    $0x0,%edx
  101555:	83 3d c4 0a 00 00 00 	cmpl   $0x0,0xac4(%rip)        # 102020 <alloc_list_length>
  10155c:	7e 20                	jle    10157e <heap_info+0x13b>
            size_array[i] = ptrs_with_size[i].size;
  10155e:	48 8b 71 08          	mov    0x8(%rcx),%rsi
  101562:	49 89 74 d5 00       	mov    %rsi,0x0(%r13,%rdx,8)
            ptr_array[i] = (uintptr_t) ptrs_with_size[i].ptr;
  101567:	48 8b 31             	mov    (%rcx),%rsi
  10156a:	48 89 34 d0          	mov    %rsi,(%rax,%rdx,8)
        for (int i = 0; i < alloc_list_length; i++) {
  10156e:	48 83 c2 01          	add    $0x1,%rdx
  101572:	48 83 c1 10          	add    $0x10,%rcx
  101576:	39 15 a4 0a 00 00    	cmp    %edx,0xaa4(%rip)        # 102020 <alloc_list_length>
  10157c:	7f e0                	jg     10155e <heap_info+0x11b>
        info->size_array = size_array;
  10157e:	4c 89 6b 08          	mov    %r13,0x8(%rbx)
        info->ptr_array = (void **) ptr_array;
  101582:	48 89 43 10          	mov    %rax,0x10(%rbx)
  101586:	4c 89 e4             	mov    %r12,%rsp
  101589:	e9 df fe ff ff       	jmpq   10146d <heap_info+0x2a>
        if (size_array == NULL || ptr_array == NULL) return -1;
  10158e:	4c 89 e4             	mov    %r12,%rsp
  101591:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101596:	e9 1d ff ff ff       	jmpq   1014b8 <heap_info+0x75>
    size_t largest_free_chunk = 0;
  10159b:	ba 00 00 00 00       	mov    $0x0,%edx
    size_t free_space = 0;
  1015a0:	bf 00 00 00 00       	mov    $0x0,%edi
  1015a5:	e9 03 ff ff ff       	jmpq   1014ad <heap_info+0x6a>

00000000001015aa <app_printf>:
#include "process.h"

// app_printf
//     A version of console_printf that picks a sensible color by process ID.

void app_printf(int colorid, const char* format, ...) {
  1015aa:	55                   	push   %rbp
  1015ab:	48 89 e5             	mov    %rsp,%rbp
  1015ae:	48 83 ec 50          	sub    $0x50,%rsp
  1015b2:	49 89 f2             	mov    %rsi,%r10
  1015b5:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  1015b9:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  1015bd:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  1015c1:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    int color;
    if (colorid < 0) {
        color = 0x0700;
  1015c5:	be 00 07 00 00       	mov    $0x700,%esi
    if (colorid < 0) {
  1015ca:	85 ff                	test   %edi,%edi
  1015cc:	78 2e                	js     1015fc <app_printf+0x52>
    } else {
        static const uint8_t col[] = { 0x0E, 0x0F, 0x0C, 0x0A, 0x09 };
        color = col[colorid % sizeof(col)] << 8;
  1015ce:	48 63 ff             	movslq %edi,%rdi
  1015d1:	48 ba cd cc cc cc cc 	movabs $0xcccccccccccccccd,%rdx
  1015d8:	cc cc cc 
  1015db:	48 89 f8             	mov    %rdi,%rax
  1015de:	48 f7 e2             	mul    %rdx
  1015e1:	48 89 d0             	mov    %rdx,%rax
  1015e4:	48 c1 e8 02          	shr    $0x2,%rax
  1015e8:	48 83 e2 fc          	and    $0xfffffffffffffffc,%rdx
  1015ec:	48 01 c2             	add    %rax,%rdx
  1015ef:	48 29 d7             	sub    %rdx,%rdi
  1015f2:	0f b6 b7 bd 19 10 00 	movzbl 0x1019bd(%rdi),%esi
  1015f9:	c1 e6 08             	shl    $0x8,%esi
    }

    va_list val;
    va_start(val, format);
  1015fc:	c7 45 b8 10 00 00 00 	movl   $0x10,-0x48(%rbp)
  101603:	48 8d 45 10          	lea    0x10(%rbp),%rax
  101607:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  10160b:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  10160f:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    cursorpos = console_vprintf(cursorpos, color, format, val);
  101613:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  101617:	4c 89 d2             	mov    %r10,%rdx
  10161a:	8b 3d dc 79 fb ff    	mov    -0x48624(%rip),%edi        # b8ffc <cursorpos>
  101620:	e8 6b f3 ff ff       	callq  100990 <console_vprintf>
    va_end(val);

    if (CROW(cursorpos) >= 23) {
        cursorpos = CPOS(0, 0);
  101625:	3d 30 07 00 00       	cmp    $0x730,%eax
  10162a:	ba 00 00 00 00       	mov    $0x0,%edx
  10162f:	0f 4d c2             	cmovge %edx,%eax
  101632:	89 05 c4 79 fb ff    	mov    %eax,-0x4863c(%rip)        # b8ffc <cursorpos>
    }
}
  101638:	c9                   	leaveq 
  101639:	c3                   	retq   

000000000010163a <kernel_panic>:


// kernel_panic, assert_fail
//     Call the INT_SYS_PANIC system call so the kernel loops until Control-C.

void kernel_panic(const char* format, ...) {
  10163a:	55                   	push   %rbp
  10163b:	48 89 e5             	mov    %rsp,%rbp
  10163e:	53                   	push   %rbx
  10163f:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  101646:	48 89 fb             	mov    %rdi,%rbx
  101649:	48 89 75 c8          	mov    %rsi,-0x38(%rbp)
  10164d:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  101651:	48 89 4d d8          	mov    %rcx,-0x28(%rbp)
  101655:	4c 89 45 e0          	mov    %r8,-0x20(%rbp)
  101659:	4c 89 4d e8          	mov    %r9,-0x18(%rbp)
    va_list val;
    va_start(val, format);
  10165d:	c7 45 a8 08 00 00 00 	movl   $0x8,-0x58(%rbp)
  101664:	48 8d 45 10          	lea    0x10(%rbp),%rax
  101668:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  10166c:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
  101670:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
    char buf[160];
    memcpy(buf, "PANIC: ", 7);
  101674:	ba 07 00 00 00       	mov    $0x7,%edx
  101679:	be 89 19 10 00       	mov    $0x101989,%esi
  10167e:	48 8d bd 08 ff ff ff 	lea    -0xf8(%rbp),%rdi
  101685:	e8 ad ea ff ff       	callq  100137 <memcpy>
    int len = vsnprintf(&buf[7], sizeof(buf) - 7, format, val) + 7;
  10168a:	48 8d 4d a8          	lea    -0x58(%rbp),%rcx
  10168e:	48 89 da             	mov    %rbx,%rdx
  101691:	be 99 00 00 00       	mov    $0x99,%esi
  101696:	48 8d bd 0f ff ff ff 	lea    -0xf1(%rbp),%rdi
  10169d:	e8 69 f3 ff ff       	callq  100a0b <vsnprintf>
  1016a2:	8d 50 07             	lea    0x7(%rax),%edx
    va_end(val);
    if (len > 0 && buf[len - 1] != '\n') {
  1016a5:	85 d2                	test   %edx,%edx
  1016a7:	7e 0f                	jle    1016b8 <kernel_panic+0x7e>
  1016a9:	83 c0 06             	add    $0x6,%eax
  1016ac:	48 98                	cltq   
  1016ae:	80 bc 05 08 ff ff ff 	cmpb   $0xa,-0xf8(%rbp,%rax,1)
  1016b5:	0a 
  1016b6:	75 2a                	jne    1016e2 <kernel_panic+0xa8>
        strcpy(buf + len - (len == (int) sizeof(buf) - 1), "\n");
    }
    (void) console_printf(CPOS(23, 0), 0xC000, "%s", buf);
  1016b8:	48 8d 9d 08 ff ff ff 	lea    -0xf8(%rbp),%rbx
  1016bf:	48 89 d9             	mov    %rbx,%rcx
  1016c2:	ba 93 19 10 00       	mov    $0x101993,%edx
  1016c7:	be 00 c0 00 00       	mov    $0xc000,%esi
  1016cc:	bf 30 07 00 00       	mov    $0x730,%edi
  1016d1:	b8 00 00 00 00       	mov    $0x0,%eax
  1016d6:	e8 fa f2 ff ff       	callq  1009d5 <console_printf>
    asm volatile ("int %0" : /* no result */
  1016db:	48 89 df             	mov    %rbx,%rdi
  1016de:	cd 30                	int    $0x30
 loop: goto loop;
  1016e0:	eb fe                	jmp    1016e0 <kernel_panic+0xa6>
        strcpy(buf + len - (len == (int) sizeof(buf) - 1), "\n");
  1016e2:	48 63 c2             	movslq %edx,%rax
  1016e5:	81 fa 9f 00 00 00    	cmp    $0x9f,%edx
  1016eb:	0f 94 c2             	sete   %dl
  1016ee:	0f b6 d2             	movzbl %dl,%edx
  1016f1:	48 29 d0             	sub    %rdx,%rax
  1016f4:	48 8d bc 05 08 ff ff 	lea    -0xf8(%rbp,%rax,1),%rdi
  1016fb:	ff 
  1016fc:	be 91 19 10 00       	mov    $0x101991,%esi
  101701:	e8 f3 ea ff ff       	callq  1001f9 <strcpy>
  101706:	eb b0                	jmp    1016b8 <kernel_panic+0x7e>

0000000000101708 <assert_fail>:
    panic(buf);
 spinloop: goto spinloop;       // should never get here
}

void assert_fail(const char* file, int line, const char* msg) {
  101708:	55                   	push   %rbp
  101709:	48 89 e5             	mov    %rsp,%rbp
  10170c:	48 89 f9             	mov    %rdi,%rcx
  10170f:	41 89 f0             	mov    %esi,%r8d
  101712:	49 89 d1             	mov    %rdx,%r9
    (void) console_printf(CPOS(23, 0), 0xC000,
  101715:	ba 98 19 10 00       	mov    $0x101998,%edx
  10171a:	be 00 c0 00 00       	mov    $0xc000,%esi
  10171f:	bf 30 07 00 00       	mov    $0x730,%edi
  101724:	b8 00 00 00 00       	mov    $0x0,%eax
  101729:	e8 a7 f2 ff ff       	callq  1009d5 <console_printf>
    asm volatile ("int %0" : /* no result */
  10172e:	bf 00 00 00 00       	mov    $0x0,%edi
  101733:	cd 30                	int    $0x30
 loop: goto loop;
  101735:	eb fe                	jmp    101735 <assert_fail+0x2d>
