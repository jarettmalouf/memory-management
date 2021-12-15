
obj/p-allocator2.full:     file format elf64-x86-64


Disassembly of section .text:

0000000000140000 <process_main>:
uint8_t *heap_bottom;
uint8_t *stack_bottom;



void process_main(void) {
  140000:	55                   	push   %rbp
  140001:	48 89 e5             	mov    %rsp,%rbp
  140004:	53                   	push   %rbx
  140005:	48 83 ec 08          	sub    $0x8,%rsp

// getpid
//    Return current process ID.
static inline pid_t getpid(void) {
    pid_t result;
    asm volatile ("int %1" : "=a" (result)
  140009:	cd 31                	int    $0x31
  14000b:	89 c3                	mov    %eax,%ebx
    pid_t p = getpid();
    srand(p);
  14000d:	89 c7                	mov    %eax,%edi
  14000f:	e8 87 02 00 00       	callq  14029b <srand>
    heap_bottom = heap_top = ROUNDUP((uint8_t*) end, PAGESIZE);
  140014:	b8 27 20 14 00       	mov    $0x142027,%eax
  140019:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  14001f:	48 89 05 ea 0f 00 00 	mov    %rax,0xfea(%rip)        # 141010 <heap_top>
  140026:	48 89 05 db 0f 00 00 	mov    %rax,0xfdb(%rip)        # 141008 <heap_bottom>
    return rbp;
}

static inline uintptr_t read_rsp(void) {
    uintptr_t rsp;
    asm volatile("movq %%rsp,%0" : "=r" (rsp));
  14002d:	48 89 e2             	mov    %rsp,%rdx
    stack_bottom = ROUNDDOWN((uint8_t*) read_rsp() - 1, PAGESIZE);
  140030:	48 83 ea 01          	sub    $0x1,%rdx
  140034:	48 81 e2 00 f0 ff ff 	and    $0xfffffffffffff000,%rdx
  14003b:	48 89 15 be 0f 00 00 	mov    %rdx,0xfbe(%rip)        # 141000 <stack_bottom>

    while(heap_top + PAGESIZE < stack_bottom) {
  140042:	48 05 00 10 00 00    	add    $0x1000,%rax
  140048:	48 39 c2             	cmp    %rax,%rdx
  14004b:	76 3a                	jbe    140087 <process_main+0x87>
//     On success, sbrk() returns the previous program break
//     (If the break was increased, then this value is a pointer to the start of the newly allocated memory)
//      On error, (void *) -1 is returned
static inline void * sbrk(const intptr_t increment) {
    static void * result;
    asm volatile ("int %1" :  "=a" (result)
  14004d:	bf 00 10 00 00       	mov    $0x1000,%edi
  140052:	cd 3a                	int    $0x3a
  140054:	48 89 05 bd 0f 00 00 	mov    %rax,0xfbd(%rip)        # 141018 <result.0>

        void * ret = sbrk(PAGESIZE);
        if(ret == (void *) -1) break;
  14005b:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  14005f:	74 26                	je     140087 <process_main+0x87>

        *heap_top = p;      /* check we have write access to new page */
  140061:	48 8b 15 a8 0f 00 00 	mov    0xfa8(%rip),%rdx        # 141010 <heap_top>
  140068:	88 1a                	mov    %bl,(%rdx)
        heap_top = (uint8_t *)ret + PAGESIZE;
  14006a:	48 8d 90 00 10 00 00 	lea    0x1000(%rax),%rdx
  140071:	48 89 15 98 0f 00 00 	mov    %rdx,0xf98(%rip)        # 141010 <heap_top>
    while(heap_top + PAGESIZE < stack_bottom) {
  140078:	48 05 00 20 00 00    	add    $0x2000,%rax
  14007e:	48 39 05 7b 0f 00 00 	cmp    %rax,0xf7b(%rip)        # 141000 <stack_bottom>
  140085:	77 cb                	ja     140052 <process_main+0x52>
    }

    TEST_PASS();
  140087:	bf 40 0c 14 00       	mov    $0x140c40,%edi
  14008c:	b8 00 00 00 00       	mov    $0x0,%eax
  140091:	e8 a1 0a 00 00       	callq  140b37 <kernel_panic>

0000000000140096 <console_putc>:
typedef struct console_printer {
    printer p;
    uint16_t* cursor;
} console_printer;

static void console_putc(printer* p, unsigned char c, int color) {
  140096:	48 89 f9             	mov    %rdi,%rcx
  140099:	89 d7                	mov    %edx,%edi
    console_printer* cp = (console_printer*) p;
    if (cp->cursor >= console + CONSOLE_ROWS * CONSOLE_COLUMNS) {
  14009b:	48 81 79 08 a0 8f 0b 	cmpq   $0xb8fa0,0x8(%rcx)
  1400a2:	00 
  1400a3:	72 08                	jb     1400ad <console_putc+0x17>
        cp->cursor = console;
  1400a5:	48 c7 41 08 00 80 0b 	movq   $0xb8000,0x8(%rcx)
  1400ac:	00 
    }
    if (c == '\n') {
  1400ad:	40 80 fe 0a          	cmp    $0xa,%sil
  1400b1:	74 16                	je     1400c9 <console_putc+0x33>
        int pos = (cp->cursor - console) % 80;
        for (; pos != 80; pos++) {
            *cp->cursor++ = ' ' | color;
        }
    } else {
        *cp->cursor++ = c | color;
  1400b3:	48 8b 41 08          	mov    0x8(%rcx),%rax
  1400b7:	48 8d 50 02          	lea    0x2(%rax),%rdx
  1400bb:	48 89 51 08          	mov    %rdx,0x8(%rcx)
  1400bf:	40 0f b6 f6          	movzbl %sil,%esi
  1400c3:	09 fe                	or     %edi,%esi
  1400c5:	66 89 30             	mov    %si,(%rax)
    }
}
  1400c8:	c3                   	retq   
        int pos = (cp->cursor - console) % 80;
  1400c9:	4c 8b 41 08          	mov    0x8(%rcx),%r8
  1400cd:	49 81 e8 00 80 0b 00 	sub    $0xb8000,%r8
  1400d4:	4c 89 c6             	mov    %r8,%rsi
  1400d7:	48 d1 fe             	sar    %rsi
  1400da:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
  1400e1:	66 66 66 
  1400e4:	48 89 f0             	mov    %rsi,%rax
  1400e7:	48 f7 ea             	imul   %rdx
  1400ea:	48 c1 fa 05          	sar    $0x5,%rdx
  1400ee:	49 c1 f8 3f          	sar    $0x3f,%r8
  1400f2:	4c 29 c2             	sub    %r8,%rdx
  1400f5:	48 8d 14 92          	lea    (%rdx,%rdx,4),%rdx
  1400f9:	48 c1 e2 04          	shl    $0x4,%rdx
  1400fd:	89 f0                	mov    %esi,%eax
  1400ff:	29 d0                	sub    %edx,%eax
            *cp->cursor++ = ' ' | color;
  140101:	83 cf 20             	or     $0x20,%edi
  140104:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  140108:	48 8d 72 02          	lea    0x2(%rdx),%rsi
  14010c:	48 89 71 08          	mov    %rsi,0x8(%rcx)
  140110:	66 89 3a             	mov    %di,(%rdx)
        for (; pos != 80; pos++) {
  140113:	83 c0 01             	add    $0x1,%eax
  140116:	83 f8 50             	cmp    $0x50,%eax
  140119:	75 e9                	jne    140104 <console_putc+0x6e>
  14011b:	c3                   	retq   

000000000014011c <string_putc>:
    char* end;
} string_printer;

static void string_putc(printer* p, unsigned char c, int color) {
    string_printer* sp = (string_printer*) p;
    if (sp->s < sp->end) {
  14011c:	48 8b 47 08          	mov    0x8(%rdi),%rax
  140120:	48 3b 47 10          	cmp    0x10(%rdi),%rax
  140124:	73 0b                	jae    140131 <string_putc+0x15>
        *sp->s++ = c;
  140126:	48 8d 50 01          	lea    0x1(%rax),%rdx
  14012a:	48 89 57 08          	mov    %rdx,0x8(%rdi)
  14012e:	40 88 30             	mov    %sil,(%rax)
    }
    (void) color;
}
  140131:	c3                   	retq   

0000000000140132 <memcpy>:
void* memcpy(void* dst, const void* src, size_t n) {
  140132:	48 89 f8             	mov    %rdi,%rax
    for (char* d = (char*) dst; n > 0; --n, ++s, ++d) {
  140135:	48 85 d2             	test   %rdx,%rdx
  140138:	74 17                	je     140151 <memcpy+0x1f>
  14013a:	b9 00 00 00 00       	mov    $0x0,%ecx
        *d = *s;
  14013f:	44 0f b6 04 0e       	movzbl (%rsi,%rcx,1),%r8d
  140144:	44 88 04 08          	mov    %r8b,(%rax,%rcx,1)
    for (char* d = (char*) dst; n > 0; --n, ++s, ++d) {
  140148:	48 83 c1 01          	add    $0x1,%rcx
  14014c:	48 39 d1             	cmp    %rdx,%rcx
  14014f:	75 ee                	jne    14013f <memcpy+0xd>
}
  140151:	c3                   	retq   

0000000000140152 <memmove>:
void* memmove(void* dst, const void* src, size_t n) {
  140152:	48 89 f8             	mov    %rdi,%rax
    if (s < d && s + n > d) {
  140155:	48 39 fe             	cmp    %rdi,%rsi
  140158:	72 1d                	jb     140177 <memmove+0x25>
        while (n-- > 0) {
  14015a:	b9 00 00 00 00       	mov    $0x0,%ecx
  14015f:	48 85 d2             	test   %rdx,%rdx
  140162:	74 12                	je     140176 <memmove+0x24>
            *d++ = *s++;
  140164:	0f b6 3c 0e          	movzbl (%rsi,%rcx,1),%edi
  140168:	40 88 3c 08          	mov    %dil,(%rax,%rcx,1)
        while (n-- > 0) {
  14016c:	48 83 c1 01          	add    $0x1,%rcx
  140170:	48 39 ca             	cmp    %rcx,%rdx
  140173:	75 ef                	jne    140164 <memmove+0x12>
}
  140175:	c3                   	retq   
  140176:	c3                   	retq   
    if (s < d && s + n > d) {
  140177:	48 8d 0c 16          	lea    (%rsi,%rdx,1),%rcx
  14017b:	48 39 cf             	cmp    %rcx,%rdi
  14017e:	73 da                	jae    14015a <memmove+0x8>
        while (n-- > 0) {
  140180:	48 8d 4a ff          	lea    -0x1(%rdx),%rcx
  140184:	48 85 d2             	test   %rdx,%rdx
  140187:	74 ec                	je     140175 <memmove+0x23>
            *--d = *--s;
  140189:	0f b6 14 0e          	movzbl (%rsi,%rcx,1),%edx
  14018d:	88 14 08             	mov    %dl,(%rax,%rcx,1)
        while (n-- > 0) {
  140190:	48 83 e9 01          	sub    $0x1,%rcx
  140194:	48 83 f9 ff          	cmp    $0xffffffffffffffff,%rcx
  140198:	75 ef                	jne    140189 <memmove+0x37>
  14019a:	c3                   	retq   

000000000014019b <memset>:
void* memset(void* v, int c, size_t n) {
  14019b:	48 89 f8             	mov    %rdi,%rax
    for (char* p = (char*) v; n > 0; ++p, --n) {
  14019e:	48 85 d2             	test   %rdx,%rdx
  1401a1:	74 12                	je     1401b5 <memset+0x1a>
  1401a3:	48 01 fa             	add    %rdi,%rdx
  1401a6:	48 89 f9             	mov    %rdi,%rcx
        *p = c;
  1401a9:	40 88 31             	mov    %sil,(%rcx)
    for (char* p = (char*) v; n > 0; ++p, --n) {
  1401ac:	48 83 c1 01          	add    $0x1,%rcx
  1401b0:	48 39 ca             	cmp    %rcx,%rdx
  1401b3:	75 f4                	jne    1401a9 <memset+0xe>
}
  1401b5:	c3                   	retq   

00000000001401b6 <strlen>:
    for (n = 0; *s != '\0'; ++s) {
  1401b6:	80 3f 00             	cmpb   $0x0,(%rdi)
  1401b9:	74 10                	je     1401cb <strlen+0x15>
  1401bb:	b8 00 00 00 00       	mov    $0x0,%eax
        ++n;
  1401c0:	48 83 c0 01          	add    $0x1,%rax
    for (n = 0; *s != '\0'; ++s) {
  1401c4:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  1401c8:	75 f6                	jne    1401c0 <strlen+0xa>
  1401ca:	c3                   	retq   
  1401cb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1401d0:	c3                   	retq   

00000000001401d1 <strnlen>:
size_t strnlen(const char* s, size_t maxlen) {
  1401d1:	48 89 f0             	mov    %rsi,%rax
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
  1401d4:	ba 00 00 00 00       	mov    $0x0,%edx
  1401d9:	48 85 f6             	test   %rsi,%rsi
  1401dc:	74 11                	je     1401ef <strnlen+0x1e>
  1401de:	80 3c 17 00          	cmpb   $0x0,(%rdi,%rdx,1)
  1401e2:	74 0c                	je     1401f0 <strnlen+0x1f>
        ++n;
  1401e4:	48 83 c2 01          	add    $0x1,%rdx
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
  1401e8:	48 39 d0             	cmp    %rdx,%rax
  1401eb:	75 f1                	jne    1401de <strnlen+0xd>
  1401ed:	eb 04                	jmp    1401f3 <strnlen+0x22>
  1401ef:	c3                   	retq   
  1401f0:	48 89 d0             	mov    %rdx,%rax
}
  1401f3:	c3                   	retq   

00000000001401f4 <strcpy>:
char* strcpy(char* dst, const char* src) {
  1401f4:	48 89 f8             	mov    %rdi,%rax
  1401f7:	ba 00 00 00 00       	mov    $0x0,%edx
        *d++ = *src++;
  1401fc:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
  140200:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
    } while (d[-1]);
  140203:	48 83 c2 01          	add    $0x1,%rdx
  140207:	84 c9                	test   %cl,%cl
  140209:	75 f1                	jne    1401fc <strcpy+0x8>
}
  14020b:	c3                   	retq   

000000000014020c <strcmp>:
    while (*a && *b && *a == *b) {
  14020c:	0f b6 07             	movzbl (%rdi),%eax
  14020f:	84 c0                	test   %al,%al
  140211:	74 1a                	je     14022d <strcmp+0x21>
  140213:	0f b6 16             	movzbl (%rsi),%edx
  140216:	38 c2                	cmp    %al,%dl
  140218:	75 13                	jne    14022d <strcmp+0x21>
  14021a:	84 d2                	test   %dl,%dl
  14021c:	74 0f                	je     14022d <strcmp+0x21>
        ++a, ++b;
  14021e:	48 83 c7 01          	add    $0x1,%rdi
  140222:	48 83 c6 01          	add    $0x1,%rsi
    while (*a && *b && *a == *b) {
  140226:	0f b6 07             	movzbl (%rdi),%eax
  140229:	84 c0                	test   %al,%al
  14022b:	75 e6                	jne    140213 <strcmp+0x7>
    return ((unsigned char) *a > (unsigned char) *b)
  14022d:	3a 06                	cmp    (%rsi),%al
  14022f:	0f 97 c0             	seta   %al
  140232:	0f b6 c0             	movzbl %al,%eax
        - ((unsigned char) *a < (unsigned char) *b);
  140235:	83 d8 00             	sbb    $0x0,%eax
}
  140238:	c3                   	retq   

0000000000140239 <strchr>:
    while (*s && *s != (char) c) {
  140239:	0f b6 07             	movzbl (%rdi),%eax
  14023c:	84 c0                	test   %al,%al
  14023e:	74 10                	je     140250 <strchr+0x17>
  140240:	40 38 f0             	cmp    %sil,%al
  140243:	74 18                	je     14025d <strchr+0x24>
        ++s;
  140245:	48 83 c7 01          	add    $0x1,%rdi
    while (*s && *s != (char) c) {
  140249:	0f b6 07             	movzbl (%rdi),%eax
  14024c:	84 c0                	test   %al,%al
  14024e:	75 f0                	jne    140240 <strchr+0x7>
        return NULL;
  140250:	40 84 f6             	test   %sil,%sil
  140253:	b8 00 00 00 00       	mov    $0x0,%eax
  140258:	48 0f 44 c7          	cmove  %rdi,%rax
}
  14025c:	c3                   	retq   
  14025d:	48 89 f8             	mov    %rdi,%rax
  140260:	c3                   	retq   

0000000000140261 <rand>:
    if (!rand_seed_set) {
  140261:	83 3d bc 0d 00 00 00 	cmpl   $0x0,0xdbc(%rip)        # 141024 <rand_seed_set>
  140268:	74 1b                	je     140285 <rand+0x24>
    rand_seed = rand_seed * 1664525U + 1013904223U;
  14026a:	69 05 ac 0d 00 00 0d 	imul   $0x19660d,0xdac(%rip),%eax        # 141020 <rand_seed>
  140271:	66 19 00 
  140274:	05 5f f3 6e 3c       	add    $0x3c6ef35f,%eax
  140279:	89 05 a1 0d 00 00    	mov    %eax,0xda1(%rip)        # 141020 <rand_seed>
    return rand_seed & RAND_MAX;
  14027f:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
}
  140284:	c3                   	retq   
    rand_seed = seed;
  140285:	c7 05 91 0d 00 00 9e 	movl   $0x30d4879e,0xd91(%rip)        # 141020 <rand_seed>
  14028c:	87 d4 30 
    rand_seed_set = 1;
  14028f:	c7 05 8b 0d 00 00 01 	movl   $0x1,0xd8b(%rip)        # 141024 <rand_seed_set>
  140296:	00 00 00 
}
  140299:	eb cf                	jmp    14026a <rand+0x9>

000000000014029b <srand>:
    rand_seed = seed;
  14029b:	89 3d 7f 0d 00 00    	mov    %edi,0xd7f(%rip)        # 141020 <rand_seed>
    rand_seed_set = 1;
  1402a1:	c7 05 79 0d 00 00 01 	movl   $0x1,0xd79(%rip)        # 141024 <rand_seed_set>
  1402a8:	00 00 00 
}
  1402ab:	c3                   	retq   

00000000001402ac <printer_vprintf>:
void printer_vprintf(printer* p, int color, const char* format, va_list val) {
  1402ac:	55                   	push   %rbp
  1402ad:	48 89 e5             	mov    %rsp,%rbp
  1402b0:	41 57                	push   %r15
  1402b2:	41 56                	push   %r14
  1402b4:	41 55                	push   %r13
  1402b6:	41 54                	push   %r12
  1402b8:	53                   	push   %rbx
  1402b9:	48 83 ec 58          	sub    $0x58,%rsp
  1402bd:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
    for (; *format; ++format) {
  1402c1:	0f b6 02             	movzbl (%rdx),%eax
  1402c4:	84 c0                	test   %al,%al
  1402c6:	0f 84 b0 06 00 00    	je     14097c <printer_vprintf+0x6d0>
  1402cc:	49 89 fe             	mov    %rdi,%r14
  1402cf:	49 89 d4             	mov    %rdx,%r12
            length = 1;
  1402d2:	41 89 f7             	mov    %esi,%r15d
  1402d5:	e9 a4 04 00 00       	jmpq   14077e <printer_vprintf+0x4d2>
        for (++format; *format; ++format) {
  1402da:	49 8d 5c 24 01       	lea    0x1(%r12),%rbx
  1402df:	45 0f b6 64 24 01    	movzbl 0x1(%r12),%r12d
  1402e5:	45 84 e4             	test   %r12b,%r12b
  1402e8:	0f 84 82 06 00 00    	je     140970 <printer_vprintf+0x6c4>
        int flags = 0;
  1402ee:	41 bd 00 00 00 00    	mov    $0x0,%r13d
            const char* flagc = strchr(flag_chars, *format);
  1402f4:	41 0f be f4          	movsbl %r12b,%esi
  1402f8:	bf 61 0e 14 00       	mov    $0x140e61,%edi
  1402fd:	e8 37 ff ff ff       	callq  140239 <strchr>
  140302:	48 89 c1             	mov    %rax,%rcx
            if (flagc) {
  140305:	48 85 c0             	test   %rax,%rax
  140308:	74 55                	je     14035f <printer_vprintf+0xb3>
                flags |= 1 << (flagc - flag_chars);
  14030a:	48 81 e9 61 0e 14 00 	sub    $0x140e61,%rcx
  140311:	b8 01 00 00 00       	mov    $0x1,%eax
  140316:	d3 e0                	shl    %cl,%eax
  140318:	41 09 c5             	or     %eax,%r13d
        for (++format; *format; ++format) {
  14031b:	48 83 c3 01          	add    $0x1,%rbx
  14031f:	44 0f b6 23          	movzbl (%rbx),%r12d
  140323:	45 84 e4             	test   %r12b,%r12b
  140326:	75 cc                	jne    1402f4 <printer_vprintf+0x48>
  140328:	44 89 6d a8          	mov    %r13d,-0x58(%rbp)
        int width = -1;
  14032c:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
        int precision = -1;
  140332:	c7 45 9c ff ff ff ff 	movl   $0xffffffff,-0x64(%rbp)
        if (*format == '.') {
  140339:	80 3b 2e             	cmpb   $0x2e,(%rbx)
  14033c:	0f 84 a9 00 00 00    	je     1403eb <printer_vprintf+0x13f>
        int length = 0;
  140342:	b9 00 00 00 00       	mov    $0x0,%ecx
        switch (*format) {
  140347:	0f b6 13             	movzbl (%rbx),%edx
  14034a:	8d 42 bd             	lea    -0x43(%rdx),%eax
  14034d:	3c 37                	cmp    $0x37,%al
  14034f:	0f 87 c4 04 00 00    	ja     140819 <printer_vprintf+0x56d>
  140355:	0f b6 c0             	movzbl %al,%eax
  140358:	ff 24 c5 70 0c 14 00 	jmpq   *0x140c70(,%rax,8)
        if (*format >= '1' && *format <= '9') {
  14035f:	44 89 6d a8          	mov    %r13d,-0x58(%rbp)
  140363:	41 8d 44 24 cf       	lea    -0x31(%r12),%eax
  140368:	3c 08                	cmp    $0x8,%al
  14036a:	77 2f                	ja     14039b <printer_vprintf+0xef>
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  14036c:	0f b6 03             	movzbl (%rbx),%eax
  14036f:	8d 50 d0             	lea    -0x30(%rax),%edx
  140372:	80 fa 09             	cmp    $0x9,%dl
  140375:	77 5e                	ja     1403d5 <printer_vprintf+0x129>
  140377:	41 bd 00 00 00 00    	mov    $0x0,%r13d
                width = 10 * width + *format++ - '0';
  14037d:	48 83 c3 01          	add    $0x1,%rbx
  140381:	43 8d 54 ad 00       	lea    0x0(%r13,%r13,4),%edx
  140386:	0f be c0             	movsbl %al,%eax
  140389:	44 8d 6c 50 d0       	lea    -0x30(%rax,%rdx,2),%r13d
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  14038e:	0f b6 03             	movzbl (%rbx),%eax
  140391:	8d 50 d0             	lea    -0x30(%rax),%edx
  140394:	80 fa 09             	cmp    $0x9,%dl
  140397:	76 e4                	jbe    14037d <printer_vprintf+0xd1>
  140399:	eb 97                	jmp    140332 <printer_vprintf+0x86>
        } else if (*format == '*') {
  14039b:	41 80 fc 2a          	cmp    $0x2a,%r12b
  14039f:	75 3f                	jne    1403e0 <printer_vprintf+0x134>
            width = va_arg(val, int);
  1403a1:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1403a5:	8b 07                	mov    (%rdi),%eax
  1403a7:	83 f8 2f             	cmp    $0x2f,%eax
  1403aa:	77 17                	ja     1403c3 <printer_vprintf+0x117>
  1403ac:	89 c2                	mov    %eax,%edx
  1403ae:	48 03 57 10          	add    0x10(%rdi),%rdx
  1403b2:	83 c0 08             	add    $0x8,%eax
  1403b5:	89 07                	mov    %eax,(%rdi)
  1403b7:	44 8b 2a             	mov    (%rdx),%r13d
            ++format;
  1403ba:	48 83 c3 01          	add    $0x1,%rbx
  1403be:	e9 6f ff ff ff       	jmpq   140332 <printer_vprintf+0x86>
            width = va_arg(val, int);
  1403c3:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1403c7:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  1403cb:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1403cf:	48 89 41 08          	mov    %rax,0x8(%rcx)
  1403d3:	eb e2                	jmp    1403b7 <printer_vprintf+0x10b>
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  1403d5:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  1403db:	e9 52 ff ff ff       	jmpq   140332 <printer_vprintf+0x86>
        int width = -1;
  1403e0:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  1403e6:	e9 47 ff ff ff       	jmpq   140332 <printer_vprintf+0x86>
            ++format;
  1403eb:	48 8d 53 01          	lea    0x1(%rbx),%rdx
            if (*format >= '0' && *format <= '9') {
  1403ef:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  1403f3:	8d 48 d0             	lea    -0x30(%rax),%ecx
  1403f6:	80 f9 09             	cmp    $0x9,%cl
  1403f9:	76 13                	jbe    14040e <printer_vprintf+0x162>
            } else if (*format == '*') {
  1403fb:	3c 2a                	cmp    $0x2a,%al
  1403fd:	74 33                	je     140432 <printer_vprintf+0x186>
            ++format;
  1403ff:	48 89 d3             	mov    %rdx,%rbx
                precision = 0;
  140402:	c7 45 9c 00 00 00 00 	movl   $0x0,-0x64(%rbp)
  140409:	e9 34 ff ff ff       	jmpq   140342 <printer_vprintf+0x96>
                for (precision = 0; *format >= '0' && *format <= '9'; ) {
  14040e:	b9 00 00 00 00       	mov    $0x0,%ecx
                    precision = 10 * precision + *format++ - '0';
  140413:	48 83 c2 01          	add    $0x1,%rdx
  140417:	8d 0c 89             	lea    (%rcx,%rcx,4),%ecx
  14041a:	0f be c0             	movsbl %al,%eax
  14041d:	8d 4c 48 d0          	lea    -0x30(%rax,%rcx,2),%ecx
                for (precision = 0; *format >= '0' && *format <= '9'; ) {
  140421:	0f b6 02             	movzbl (%rdx),%eax
  140424:	8d 70 d0             	lea    -0x30(%rax),%esi
  140427:	40 80 fe 09          	cmp    $0x9,%sil
  14042b:	76 e6                	jbe    140413 <printer_vprintf+0x167>
                    precision = 10 * precision + *format++ - '0';
  14042d:	48 89 d3             	mov    %rdx,%rbx
  140430:	eb 1c                	jmp    14044e <printer_vprintf+0x1a2>
                precision = va_arg(val, int);
  140432:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  140436:	8b 07                	mov    (%rdi),%eax
  140438:	83 f8 2f             	cmp    $0x2f,%eax
  14043b:	77 23                	ja     140460 <printer_vprintf+0x1b4>
  14043d:	89 c2                	mov    %eax,%edx
  14043f:	48 03 57 10          	add    0x10(%rdi),%rdx
  140443:	83 c0 08             	add    $0x8,%eax
  140446:	89 07                	mov    %eax,(%rdi)
  140448:	8b 0a                	mov    (%rdx),%ecx
                ++format;
  14044a:	48 83 c3 02          	add    $0x2,%rbx
            if (precision < 0) {
  14044e:	85 c9                	test   %ecx,%ecx
  140450:	b8 00 00 00 00       	mov    $0x0,%eax
  140455:	0f 49 c1             	cmovns %ecx,%eax
  140458:	89 45 9c             	mov    %eax,-0x64(%rbp)
  14045b:	e9 e2 fe ff ff       	jmpq   140342 <printer_vprintf+0x96>
                precision = va_arg(val, int);
  140460:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  140464:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  140468:	48 8d 42 08          	lea    0x8(%rdx),%rax
  14046c:	48 89 41 08          	mov    %rax,0x8(%rcx)
  140470:	eb d6                	jmp    140448 <printer_vprintf+0x19c>
        switch (*format) {
  140472:	be f0 ff ff ff       	mov    $0xfffffff0,%esi
  140477:	e9 f3 00 00 00       	jmpq   14056f <printer_vprintf+0x2c3>
            ++format;
  14047c:	48 83 c3 01          	add    $0x1,%rbx
            length = 1;
  140480:	b9 01 00 00 00       	mov    $0x1,%ecx
            goto again;
  140485:	e9 bd fe ff ff       	jmpq   140347 <printer_vprintf+0x9b>
            long x = length ? va_arg(val, long) : va_arg(val, int);
  14048a:	85 c9                	test   %ecx,%ecx
  14048c:	74 55                	je     1404e3 <printer_vprintf+0x237>
  14048e:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  140492:	8b 07                	mov    (%rdi),%eax
  140494:	83 f8 2f             	cmp    $0x2f,%eax
  140497:	77 38                	ja     1404d1 <printer_vprintf+0x225>
  140499:	89 c2                	mov    %eax,%edx
  14049b:	48 03 57 10          	add    0x10(%rdi),%rdx
  14049f:	83 c0 08             	add    $0x8,%eax
  1404a2:	89 07                	mov    %eax,(%rdi)
  1404a4:	48 8b 12             	mov    (%rdx),%rdx
            int negative = x < 0 ? FLAG_NEGATIVE : 0;
  1404a7:	48 89 d0             	mov    %rdx,%rax
  1404aa:	48 c1 f8 38          	sar    $0x38,%rax
            num = negative ? -x : x;
  1404ae:	49 89 d0             	mov    %rdx,%r8
  1404b1:	49 f7 d8             	neg    %r8
  1404b4:	25 80 00 00 00       	and    $0x80,%eax
  1404b9:	4c 0f 44 c2          	cmove  %rdx,%r8
            flags |= FLAG_NUMERIC | FLAG_SIGNED | negative;
  1404bd:	0b 45 a8             	or     -0x58(%rbp),%eax
  1404c0:	83 c8 60             	or     $0x60,%eax
  1404c3:	89 45 a8             	mov    %eax,-0x58(%rbp)
        char* data = "";
  1404c6:	41 bc 70 0e 14 00    	mov    $0x140e70,%r12d
            break;
  1404cc:	e9 35 01 00 00       	jmpq   140606 <printer_vprintf+0x35a>
            long x = length ? va_arg(val, long) : va_arg(val, int);
  1404d1:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1404d5:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  1404d9:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1404dd:	48 89 41 08          	mov    %rax,0x8(%rcx)
  1404e1:	eb c1                	jmp    1404a4 <printer_vprintf+0x1f8>
  1404e3:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1404e7:	8b 07                	mov    (%rdi),%eax
  1404e9:	83 f8 2f             	cmp    $0x2f,%eax
  1404ec:	77 10                	ja     1404fe <printer_vprintf+0x252>
  1404ee:	89 c2                	mov    %eax,%edx
  1404f0:	48 03 57 10          	add    0x10(%rdi),%rdx
  1404f4:	83 c0 08             	add    $0x8,%eax
  1404f7:	89 07                	mov    %eax,(%rdi)
  1404f9:	48 63 12             	movslq (%rdx),%rdx
  1404fc:	eb a9                	jmp    1404a7 <printer_vprintf+0x1fb>
  1404fe:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  140502:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  140506:	48 8d 42 08          	lea    0x8(%rdx),%rax
  14050a:	48 89 47 08          	mov    %rax,0x8(%rdi)
  14050e:	eb e9                	jmp    1404f9 <printer_vprintf+0x24d>
        int base = 10;
  140510:	be 0a 00 00 00       	mov    $0xa,%esi
  140515:	eb 58                	jmp    14056f <printer_vprintf+0x2c3>
            num = length ? va_arg(val, unsigned long) : va_arg(val, unsigned);
  140517:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  14051b:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  14051f:	48 8d 42 08          	lea    0x8(%rdx),%rax
  140523:	48 89 41 08          	mov    %rax,0x8(%rcx)
  140527:	eb 60                	jmp    140589 <printer_vprintf+0x2dd>
  140529:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  14052d:	8b 07                	mov    (%rdi),%eax
  14052f:	83 f8 2f             	cmp    $0x2f,%eax
  140532:	77 10                	ja     140544 <printer_vprintf+0x298>
  140534:	89 c2                	mov    %eax,%edx
  140536:	48 03 57 10          	add    0x10(%rdi),%rdx
  14053a:	83 c0 08             	add    $0x8,%eax
  14053d:	89 07                	mov    %eax,(%rdi)
  14053f:	44 8b 02             	mov    (%rdx),%r8d
  140542:	eb 48                	jmp    14058c <printer_vprintf+0x2e0>
  140544:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  140548:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  14054c:	48 8d 42 08          	lea    0x8(%rdx),%rax
  140550:	48 89 41 08          	mov    %rax,0x8(%rcx)
  140554:	eb e9                	jmp    14053f <printer_vprintf+0x293>
  140556:	41 89 f1             	mov    %esi,%r9d
        if (flags & FLAG_NUMERIC) {
  140559:	c7 45 8c 20 00 00 00 	movl   $0x20,-0x74(%rbp)
    const char* digits = upper_digits;
  140560:	bf 50 0e 14 00       	mov    $0x140e50,%edi
  140565:	e9 e2 02 00 00       	jmpq   14084c <printer_vprintf+0x5a0>
            base = 16;
  14056a:	be 10 00 00 00       	mov    $0x10,%esi
            num = length ? va_arg(val, unsigned long) : va_arg(val, unsigned);
  14056f:	85 c9                	test   %ecx,%ecx
  140571:	74 b6                	je     140529 <printer_vprintf+0x27d>
  140573:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  140577:	8b 01                	mov    (%rcx),%eax
  140579:	83 f8 2f             	cmp    $0x2f,%eax
  14057c:	77 99                	ja     140517 <printer_vprintf+0x26b>
  14057e:	89 c2                	mov    %eax,%edx
  140580:	48 03 51 10          	add    0x10(%rcx),%rdx
  140584:	83 c0 08             	add    $0x8,%eax
  140587:	89 01                	mov    %eax,(%rcx)
  140589:	4c 8b 02             	mov    (%rdx),%r8
            flags |= FLAG_NUMERIC;
  14058c:	83 4d a8 20          	orl    $0x20,-0x58(%rbp)
    if (base < 0) {
  140590:	85 f6                	test   %esi,%esi
  140592:	79 c2                	jns    140556 <printer_vprintf+0x2aa>
        base = -base;
  140594:	41 89 f1             	mov    %esi,%r9d
  140597:	f7 de                	neg    %esi
  140599:	c7 45 8c 20 00 00 00 	movl   $0x20,-0x74(%rbp)
        digits = lower_digits;
  1405a0:	bf 30 0e 14 00       	mov    $0x140e30,%edi
  1405a5:	e9 a2 02 00 00       	jmpq   14084c <printer_vprintf+0x5a0>
            num = (uintptr_t) va_arg(val, void*);
  1405aa:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1405ae:	8b 07                	mov    (%rdi),%eax
  1405b0:	83 f8 2f             	cmp    $0x2f,%eax
  1405b3:	77 1c                	ja     1405d1 <printer_vprintf+0x325>
  1405b5:	89 c2                	mov    %eax,%edx
  1405b7:	48 03 57 10          	add    0x10(%rdi),%rdx
  1405bb:	83 c0 08             	add    $0x8,%eax
  1405be:	89 07                	mov    %eax,(%rdi)
  1405c0:	4c 8b 02             	mov    (%rdx),%r8
            flags |= FLAG_ALT | FLAG_ALT2 | FLAG_NUMERIC;
  1405c3:	81 4d a8 21 01 00 00 	orl    $0x121,-0x58(%rbp)
            base = -16;
  1405ca:	be f0 ff ff ff       	mov    $0xfffffff0,%esi
  1405cf:	eb c3                	jmp    140594 <printer_vprintf+0x2e8>
            num = (uintptr_t) va_arg(val, void*);
  1405d1:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1405d5:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  1405d9:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1405dd:	48 89 41 08          	mov    %rax,0x8(%rcx)
  1405e1:	eb dd                	jmp    1405c0 <printer_vprintf+0x314>
            data = va_arg(val, char*);
  1405e3:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1405e7:	8b 01                	mov    (%rcx),%eax
  1405e9:	83 f8 2f             	cmp    $0x2f,%eax
  1405ec:	0f 87 a5 01 00 00    	ja     140797 <printer_vprintf+0x4eb>
  1405f2:	89 c2                	mov    %eax,%edx
  1405f4:	48 03 51 10          	add    0x10(%rcx),%rdx
  1405f8:	83 c0 08             	add    $0x8,%eax
  1405fb:	89 01                	mov    %eax,(%rcx)
  1405fd:	4c 8b 22             	mov    (%rdx),%r12
        unsigned long num = 0;
  140600:	41 b8 00 00 00 00    	mov    $0x0,%r8d
        if (flags & FLAG_NUMERIC) {
  140606:	8b 45 a8             	mov    -0x58(%rbp),%eax
  140609:	83 e0 20             	and    $0x20,%eax
  14060c:	89 45 8c             	mov    %eax,-0x74(%rbp)
  14060f:	41 b9 0a 00 00 00    	mov    $0xa,%r9d
  140615:	0f 85 21 02 00 00    	jne    14083c <printer_vprintf+0x590>
        if ((flags & FLAG_NUMERIC) && (flags & FLAG_SIGNED)) {
  14061b:	8b 45 a8             	mov    -0x58(%rbp),%eax
  14061e:	89 45 88             	mov    %eax,-0x78(%rbp)
  140621:	83 e0 60             	and    $0x60,%eax
  140624:	83 f8 60             	cmp    $0x60,%eax
  140627:	0f 84 54 02 00 00    	je     140881 <printer_vprintf+0x5d5>
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ALT)
  14062d:	8b 45 a8             	mov    -0x58(%rbp),%eax
  140630:	83 e0 21             	and    $0x21,%eax
        const char* prefix = "";
  140633:	48 c7 45 a0 70 0e 14 	movq   $0x140e70,-0x60(%rbp)
  14063a:	00 
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ALT)
  14063b:	83 f8 21             	cmp    $0x21,%eax
  14063e:	0f 84 79 02 00 00    	je     1408bd <printer_vprintf+0x611>
        if (precision >= 0 && !(flags & FLAG_NUMERIC)) {
  140644:	8b 7d 9c             	mov    -0x64(%rbp),%edi
  140647:	89 f8                	mov    %edi,%eax
  140649:	f7 d0                	not    %eax
  14064b:	c1 e8 1f             	shr    $0x1f,%eax
  14064e:	89 45 84             	mov    %eax,-0x7c(%rbp)
  140651:	83 7d 8c 00          	cmpl   $0x0,-0x74(%rbp)
  140655:	0f 85 9e 02 00 00    	jne    1408f9 <printer_vprintf+0x64d>
  14065b:	84 c0                	test   %al,%al
  14065d:	0f 84 96 02 00 00    	je     1408f9 <printer_vprintf+0x64d>
            len = strnlen(data, precision);
  140663:	48 63 f7             	movslq %edi,%rsi
  140666:	4c 89 e7             	mov    %r12,%rdi
  140669:	e8 63 fb ff ff       	callq  1401d1 <strnlen>
  14066e:	89 45 98             	mov    %eax,-0x68(%rbp)
                   && !(flags & FLAG_LEFTJUSTIFY)
  140671:	8b 45 88             	mov    -0x78(%rbp),%eax
  140674:	83 e0 26             	and    $0x26,%eax
            zeros = 0;
  140677:	c7 45 9c 00 00 00 00 	movl   $0x0,-0x64(%rbp)
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ZERO)
  14067e:	83 f8 22             	cmp    $0x22,%eax
  140681:	0f 84 aa 02 00 00    	je     140931 <printer_vprintf+0x685>
        width -= len + zeros + strlen(prefix);
  140687:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  14068b:	e8 26 fb ff ff       	callq  1401b6 <strlen>
  140690:	8b 55 9c             	mov    -0x64(%rbp),%edx
  140693:	03 55 98             	add    -0x68(%rbp),%edx
  140696:	44 89 e9             	mov    %r13d,%ecx
  140699:	29 d1                	sub    %edx,%ecx
  14069b:	29 c1                	sub    %eax,%ecx
  14069d:	89 4d 8c             	mov    %ecx,-0x74(%rbp)
  1406a0:	41 89 cd             	mov    %ecx,%r13d
        for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width) {
  1406a3:	f6 45 a8 04          	testb  $0x4,-0x58(%rbp)
  1406a7:	75 2d                	jne    1406d6 <printer_vprintf+0x42a>
  1406a9:	85 c9                	test   %ecx,%ecx
  1406ab:	7e 29                	jle    1406d6 <printer_vprintf+0x42a>
            p->putc(p, ' ', color);
  1406ad:	44 89 fa             	mov    %r15d,%edx
  1406b0:	be 20 00 00 00       	mov    $0x20,%esi
  1406b5:	4c 89 f7             	mov    %r14,%rdi
  1406b8:	41 ff 16             	callq  *(%r14)
        for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width) {
  1406bb:	41 83 ed 01          	sub    $0x1,%r13d
  1406bf:	45 85 ed             	test   %r13d,%r13d
  1406c2:	7f e9                	jg     1406ad <printer_vprintf+0x401>
  1406c4:	8b 7d 8c             	mov    -0x74(%rbp),%edi
  1406c7:	85 ff                	test   %edi,%edi
  1406c9:	b8 01 00 00 00       	mov    $0x1,%eax
  1406ce:	0f 4f c7             	cmovg  %edi,%eax
  1406d1:	29 c7                	sub    %eax,%edi
  1406d3:	41 89 fd             	mov    %edi,%r13d
        for (; *prefix; ++prefix) {
  1406d6:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  1406da:	0f b6 07             	movzbl (%rdi),%eax
  1406dd:	84 c0                	test   %al,%al
  1406df:	74 22                	je     140703 <printer_vprintf+0x457>
  1406e1:	48 89 5d a8          	mov    %rbx,-0x58(%rbp)
  1406e5:	48 89 fb             	mov    %rdi,%rbx
            p->putc(p, *prefix, color);
  1406e8:	0f b6 f0             	movzbl %al,%esi
  1406eb:	44 89 fa             	mov    %r15d,%edx
  1406ee:	4c 89 f7             	mov    %r14,%rdi
  1406f1:	41 ff 16             	callq  *(%r14)
        for (; *prefix; ++prefix) {
  1406f4:	48 83 c3 01          	add    $0x1,%rbx
  1406f8:	0f b6 03             	movzbl (%rbx),%eax
  1406fb:	84 c0                	test   %al,%al
  1406fd:	75 e9                	jne    1406e8 <printer_vprintf+0x43c>
  1406ff:	48 8b 5d a8          	mov    -0x58(%rbp),%rbx
        for (; zeros > 0; --zeros) {
  140703:	8b 45 9c             	mov    -0x64(%rbp),%eax
  140706:	85 c0                	test   %eax,%eax
  140708:	7e 1d                	jle    140727 <printer_vprintf+0x47b>
  14070a:	48 89 5d a8          	mov    %rbx,-0x58(%rbp)
  14070e:	89 c3                	mov    %eax,%ebx
            p->putc(p, '0', color);
  140710:	44 89 fa             	mov    %r15d,%edx
  140713:	be 30 00 00 00       	mov    $0x30,%esi
  140718:	4c 89 f7             	mov    %r14,%rdi
  14071b:	41 ff 16             	callq  *(%r14)
        for (; zeros > 0; --zeros) {
  14071e:	83 eb 01             	sub    $0x1,%ebx
  140721:	75 ed                	jne    140710 <printer_vprintf+0x464>
  140723:	48 8b 5d a8          	mov    -0x58(%rbp),%rbx
        for (; len > 0; ++data, --len) {
  140727:	8b 45 98             	mov    -0x68(%rbp),%eax
  14072a:	85 c0                	test   %eax,%eax
  14072c:	7e 27                	jle    140755 <printer_vprintf+0x4a9>
  14072e:	89 c0                	mov    %eax,%eax
  140730:	4c 01 e0             	add    %r12,%rax
  140733:	48 89 5d a8          	mov    %rbx,-0x58(%rbp)
  140737:	48 89 c3             	mov    %rax,%rbx
            p->putc(p, *data, color);
  14073a:	41 0f b6 34 24       	movzbl (%r12),%esi
  14073f:	44 89 fa             	mov    %r15d,%edx
  140742:	4c 89 f7             	mov    %r14,%rdi
  140745:	41 ff 16             	callq  *(%r14)
        for (; len > 0; ++data, --len) {
  140748:	49 83 c4 01          	add    $0x1,%r12
  14074c:	49 39 dc             	cmp    %rbx,%r12
  14074f:	75 e9                	jne    14073a <printer_vprintf+0x48e>
  140751:	48 8b 5d a8          	mov    -0x58(%rbp),%rbx
        for (; width > 0; --width) {
  140755:	45 85 ed             	test   %r13d,%r13d
  140758:	7e 14                	jle    14076e <printer_vprintf+0x4c2>
            p->putc(p, ' ', color);
  14075a:	44 89 fa             	mov    %r15d,%edx
  14075d:	be 20 00 00 00       	mov    $0x20,%esi
  140762:	4c 89 f7             	mov    %r14,%rdi
  140765:	41 ff 16             	callq  *(%r14)
        for (; width > 0; --width) {
  140768:	41 83 ed 01          	sub    $0x1,%r13d
  14076c:	75 ec                	jne    14075a <printer_vprintf+0x4ae>
    for (; *format; ++format) {
  14076e:	4c 8d 63 01          	lea    0x1(%rbx),%r12
  140772:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  140776:	84 c0                	test   %al,%al
  140778:	0f 84 fe 01 00 00    	je     14097c <printer_vprintf+0x6d0>
        if (*format != '%') {
  14077e:	3c 25                	cmp    $0x25,%al
  140780:	0f 84 54 fb ff ff    	je     1402da <printer_vprintf+0x2e>
            p->putc(p, *format, color);
  140786:	0f b6 f0             	movzbl %al,%esi
  140789:	44 89 fa             	mov    %r15d,%edx
  14078c:	4c 89 f7             	mov    %r14,%rdi
  14078f:	41 ff 16             	callq  *(%r14)
            continue;
  140792:	4c 89 e3             	mov    %r12,%rbx
  140795:	eb d7                	jmp    14076e <printer_vprintf+0x4c2>
            data = va_arg(val, char*);
  140797:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  14079b:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  14079f:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1407a3:	48 89 47 08          	mov    %rax,0x8(%rdi)
  1407a7:	e9 51 fe ff ff       	jmpq   1405fd <printer_vprintf+0x351>
            color = va_arg(val, int);
  1407ac:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1407b0:	8b 07                	mov    (%rdi),%eax
  1407b2:	83 f8 2f             	cmp    $0x2f,%eax
  1407b5:	77 10                	ja     1407c7 <printer_vprintf+0x51b>
  1407b7:	89 c2                	mov    %eax,%edx
  1407b9:	48 03 57 10          	add    0x10(%rdi),%rdx
  1407bd:	83 c0 08             	add    $0x8,%eax
  1407c0:	89 07                	mov    %eax,(%rdi)
  1407c2:	44 8b 3a             	mov    (%rdx),%r15d
            goto done;
  1407c5:	eb a7                	jmp    14076e <printer_vprintf+0x4c2>
            color = va_arg(val, int);
  1407c7:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1407cb:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  1407cf:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1407d3:	48 89 41 08          	mov    %rax,0x8(%rcx)
  1407d7:	eb e9                	jmp    1407c2 <printer_vprintf+0x516>
            numbuf[0] = va_arg(val, int);
  1407d9:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1407dd:	8b 01                	mov    (%rcx),%eax
  1407df:	83 f8 2f             	cmp    $0x2f,%eax
  1407e2:	77 23                	ja     140807 <printer_vprintf+0x55b>
  1407e4:	89 c2                	mov    %eax,%edx
  1407e6:	48 03 51 10          	add    0x10(%rcx),%rdx
  1407ea:	83 c0 08             	add    $0x8,%eax
  1407ed:	89 01                	mov    %eax,(%rcx)
  1407ef:	8b 02                	mov    (%rdx),%eax
  1407f1:	88 45 b8             	mov    %al,-0x48(%rbp)
            numbuf[1] = '\0';
  1407f4:	c6 45 b9 00          	movb   $0x0,-0x47(%rbp)
            data = numbuf;
  1407f8:	4c 8d 65 b8          	lea    -0x48(%rbp),%r12
        unsigned long num = 0;
  1407fc:	41 b8 00 00 00 00    	mov    $0x0,%r8d
            break;
  140802:	e9 ff fd ff ff       	jmpq   140606 <printer_vprintf+0x35a>
            numbuf[0] = va_arg(val, int);
  140807:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  14080b:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  14080f:	48 8d 42 08          	lea    0x8(%rdx),%rax
  140813:	48 89 47 08          	mov    %rax,0x8(%rdi)
  140817:	eb d6                	jmp    1407ef <printer_vprintf+0x543>
            numbuf[0] = (*format ? *format : '%');
  140819:	84 d2                	test   %dl,%dl
  14081b:	0f 85 39 01 00 00    	jne    14095a <printer_vprintf+0x6ae>
  140821:	c6 45 b8 25          	movb   $0x25,-0x48(%rbp)
            numbuf[1] = '\0';
  140825:	c6 45 b9 00          	movb   $0x0,-0x47(%rbp)
                format--;
  140829:	48 83 eb 01          	sub    $0x1,%rbx
            data = numbuf;
  14082d:	4c 8d 65 b8          	lea    -0x48(%rbp),%r12
        unsigned long num = 0;
  140831:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  140837:	e9 ca fd ff ff       	jmpq   140606 <printer_vprintf+0x35a>
        if (flags & FLAG_NUMERIC) {
  14083c:	41 b9 0a 00 00 00    	mov    $0xa,%r9d
    const char* digits = upper_digits;
  140842:	bf 50 0e 14 00       	mov    $0x140e50,%edi
        if (flags & FLAG_NUMERIC) {
  140847:	be 0a 00 00 00       	mov    $0xa,%esi
    *--numbuf_end = '\0';
  14084c:	c6 45 cf 00          	movb   $0x0,-0x31(%rbp)
  140850:	4c 89 c1             	mov    %r8,%rcx
  140853:	4c 8d 65 cf          	lea    -0x31(%rbp),%r12
        *--numbuf_end = digits[val % base];
  140857:	48 63 f6             	movslq %esi,%rsi
  14085a:	49 83 ec 01          	sub    $0x1,%r12
  14085e:	48 89 c8             	mov    %rcx,%rax
  140861:	ba 00 00 00 00       	mov    $0x0,%edx
  140866:	48 f7 f6             	div    %rsi
  140869:	0f b6 14 17          	movzbl (%rdi,%rdx,1),%edx
  14086d:	41 88 14 24          	mov    %dl,(%r12)
        val /= base;
  140871:	48 89 ca             	mov    %rcx,%rdx
  140874:	48 89 c1             	mov    %rax,%rcx
    } while (val != 0);
  140877:	48 39 d6             	cmp    %rdx,%rsi
  14087a:	76 de                	jbe    14085a <printer_vprintf+0x5ae>
  14087c:	e9 9a fd ff ff       	jmpq   14061b <printer_vprintf+0x36f>
                prefix = "-";
  140881:	48 c7 45 a0 5e 0c 14 	movq   $0x140c5e,-0x60(%rbp)
  140888:	00 
            if (flags & FLAG_NEGATIVE) {
  140889:	8b 45 a8             	mov    -0x58(%rbp),%eax
  14088c:	a8 80                	test   $0x80,%al
  14088e:	0f 85 b0 fd ff ff    	jne    140644 <printer_vprintf+0x398>
                prefix = "+";
  140894:	48 c7 45 a0 59 0c 14 	movq   $0x140c59,-0x60(%rbp)
  14089b:	00 
            } else if (flags & FLAG_PLUSPOSITIVE) {
  14089c:	a8 10                	test   $0x10,%al
  14089e:	0f 85 a0 fd ff ff    	jne    140644 <printer_vprintf+0x398>
                prefix = " ";
  1408a4:	a8 08                	test   $0x8,%al
  1408a6:	ba 70 0e 14 00       	mov    $0x140e70,%edx
  1408ab:	b8 6d 0e 14 00       	mov    $0x140e6d,%eax
  1408b0:	48 0f 44 c2          	cmove  %rdx,%rax
  1408b4:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  1408b8:	e9 87 fd ff ff       	jmpq   140644 <printer_vprintf+0x398>
                   && (base == 16 || base == -16)
  1408bd:	41 8d 41 10          	lea    0x10(%r9),%eax
  1408c1:	a9 df ff ff ff       	test   $0xffffffdf,%eax
  1408c6:	0f 85 78 fd ff ff    	jne    140644 <printer_vprintf+0x398>
                   && (num || (flags & FLAG_ALT2))) {
  1408cc:	4d 85 c0             	test   %r8,%r8
  1408cf:	75 0d                	jne    1408de <printer_vprintf+0x632>
  1408d1:	f7 45 a8 00 01 00 00 	testl  $0x100,-0x58(%rbp)
  1408d8:	0f 84 66 fd ff ff    	je     140644 <printer_vprintf+0x398>
            prefix = (base == -16 ? "0x" : "0X");
  1408de:	41 83 f9 f0          	cmp    $0xfffffff0,%r9d
  1408e2:	ba 60 0c 14 00       	mov    $0x140c60,%edx
  1408e7:	b8 5b 0c 14 00       	mov    $0x140c5b,%eax
  1408ec:	48 0f 44 c2          	cmove  %rdx,%rax
  1408f0:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  1408f4:	e9 4b fd ff ff       	jmpq   140644 <printer_vprintf+0x398>
            len = strlen(data);
  1408f9:	4c 89 e7             	mov    %r12,%rdi
  1408fc:	e8 b5 f8 ff ff       	callq  1401b6 <strlen>
  140901:	89 45 98             	mov    %eax,-0x68(%rbp)
        if ((flags & FLAG_NUMERIC) && precision >= 0) {
  140904:	83 7d 8c 00          	cmpl   $0x0,-0x74(%rbp)
  140908:	0f 84 63 fd ff ff    	je     140671 <printer_vprintf+0x3c5>
  14090e:	80 7d 84 00          	cmpb   $0x0,-0x7c(%rbp)
  140912:	0f 84 59 fd ff ff    	je     140671 <printer_vprintf+0x3c5>
            zeros = precision > len ? precision - len : 0;
  140918:	8b 4d 9c             	mov    -0x64(%rbp),%ecx
  14091b:	89 ca                	mov    %ecx,%edx
  14091d:	29 c2                	sub    %eax,%edx
  14091f:	39 c1                	cmp    %eax,%ecx
  140921:	b8 00 00 00 00       	mov    $0x0,%eax
  140926:	0f 4e d0             	cmovle %eax,%edx
  140929:	89 55 9c             	mov    %edx,-0x64(%rbp)
  14092c:	e9 56 fd ff ff       	jmpq   140687 <printer_vprintf+0x3db>
                   && len + (int) strlen(prefix) < width) {
  140931:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  140935:	e8 7c f8 ff ff       	callq  1401b6 <strlen>
  14093a:	8b 7d 98             	mov    -0x68(%rbp),%edi
  14093d:	8d 14 07             	lea    (%rdi,%rax,1),%edx
            zeros = width - len - strlen(prefix);
  140940:	44 89 e9             	mov    %r13d,%ecx
  140943:	29 f9                	sub    %edi,%ecx
  140945:	29 c1                	sub    %eax,%ecx
  140947:	44 39 ea             	cmp    %r13d,%edx
  14094a:	b8 00 00 00 00       	mov    $0x0,%eax
  14094f:	0f 4d c8             	cmovge %eax,%ecx
  140952:	89 4d 9c             	mov    %ecx,-0x64(%rbp)
  140955:	e9 2d fd ff ff       	jmpq   140687 <printer_vprintf+0x3db>
            numbuf[0] = (*format ? *format : '%');
  14095a:	88 55 b8             	mov    %dl,-0x48(%rbp)
            numbuf[1] = '\0';
  14095d:	c6 45 b9 00          	movb   $0x0,-0x47(%rbp)
            data = numbuf;
  140961:	4c 8d 65 b8          	lea    -0x48(%rbp),%r12
        unsigned long num = 0;
  140965:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  14096b:	e9 96 fc ff ff       	jmpq   140606 <printer_vprintf+0x35a>
        int flags = 0;
  140970:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%rbp)
  140977:	e9 b0 f9 ff ff       	jmpq   14032c <printer_vprintf+0x80>
}
  14097c:	48 83 c4 58          	add    $0x58,%rsp
  140980:	5b                   	pop    %rbx
  140981:	41 5c                	pop    %r12
  140983:	41 5d                	pop    %r13
  140985:	41 5e                	pop    %r14
  140987:	41 5f                	pop    %r15
  140989:	5d                   	pop    %rbp
  14098a:	c3                   	retq   

000000000014098b <console_vprintf>:
int console_vprintf(int cpos, int color, const char* format, va_list val) {
  14098b:	55                   	push   %rbp
  14098c:	48 89 e5             	mov    %rsp,%rbp
  14098f:	48 83 ec 10          	sub    $0x10,%rsp
    cp.p.putc = console_putc;
  140993:	48 c7 45 f0 96 00 14 	movq   $0x140096,-0x10(%rbp)
  14099a:	00 
        cpos = 0;
  14099b:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
  1409a1:	b8 00 00 00 00       	mov    $0x0,%eax
  1409a6:	0f 43 f8             	cmovae %eax,%edi
    cp.cursor = console + cpos;
  1409a9:	48 63 ff             	movslq %edi,%rdi
  1409ac:	48 8d 84 3f 00 80 0b 	lea    0xb8000(%rdi,%rdi,1),%rax
  1409b3:	00 
  1409b4:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    printer_vprintf(&cp.p, color, format, val);
  1409b8:	48 8d 7d f0          	lea    -0x10(%rbp),%rdi
  1409bc:	e8 eb f8 ff ff       	callq  1402ac <printer_vprintf>
    return cp.cursor - console;
  1409c1:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  1409c5:	48 2d 00 80 0b 00    	sub    $0xb8000,%rax
  1409cb:	48 d1 f8             	sar    %rax
}
  1409ce:	c9                   	leaveq 
  1409cf:	c3                   	retq   

00000000001409d0 <console_printf>:
int console_printf(int cpos, int color, const char* format, ...) {
  1409d0:	55                   	push   %rbp
  1409d1:	48 89 e5             	mov    %rsp,%rbp
  1409d4:	48 83 ec 50          	sub    $0x50,%rsp
  1409d8:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  1409dc:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  1409e0:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(val, format);
  1409e4:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  1409eb:	48 8d 45 10          	lea    0x10(%rbp),%rax
  1409ef:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  1409f3:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  1409f7:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    cpos = console_vprintf(cpos, color, format, val);
  1409fb:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  1409ff:	e8 87 ff ff ff       	callq  14098b <console_vprintf>
}
  140a04:	c9                   	leaveq 
  140a05:	c3                   	retq   

0000000000140a06 <vsnprintf>:

int vsnprintf(char* s, size_t size, const char* format, va_list val) {
  140a06:	55                   	push   %rbp
  140a07:	48 89 e5             	mov    %rsp,%rbp
  140a0a:	53                   	push   %rbx
  140a0b:	48 83 ec 28          	sub    $0x28,%rsp
  140a0f:	48 89 fb             	mov    %rdi,%rbx
    string_printer sp;
    sp.p.putc = string_putc;
  140a12:	48 c7 45 d8 1c 01 14 	movq   $0x14011c,-0x28(%rbp)
  140a19:	00 
    sp.s = s;
  140a1a:	48 89 7d e0          	mov    %rdi,-0x20(%rbp)
    if (size) {
  140a1e:	48 85 f6             	test   %rsi,%rsi
  140a21:	75 0b                	jne    140a2e <vsnprintf+0x28>
        sp.end = s + size - 1;
        printer_vprintf(&sp.p, 0, format, val);
        *sp.s = 0;
    }
    return sp.s - s;
  140a23:	8b 45 e0             	mov    -0x20(%rbp),%eax
  140a26:	29 d8                	sub    %ebx,%eax
}
  140a28:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  140a2c:	c9                   	leaveq 
  140a2d:	c3                   	retq   
        sp.end = s + size - 1;
  140a2e:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  140a33:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
        printer_vprintf(&sp.p, 0, format, val);
  140a37:	be 00 00 00 00       	mov    $0x0,%esi
  140a3c:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  140a40:	e8 67 f8 ff ff       	callq  1402ac <printer_vprintf>
        *sp.s = 0;
  140a45:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  140a49:	c6 00 00             	movb   $0x0,(%rax)
  140a4c:	eb d5                	jmp    140a23 <vsnprintf+0x1d>

0000000000140a4e <snprintf>:

int snprintf(char* s, size_t size, const char* format, ...) {
  140a4e:	55                   	push   %rbp
  140a4f:	48 89 e5             	mov    %rsp,%rbp
  140a52:	48 83 ec 50          	sub    $0x50,%rsp
  140a56:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  140a5a:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  140a5e:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list val;
    va_start(val, format);
  140a62:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  140a69:	48 8d 45 10          	lea    0x10(%rbp),%rax
  140a6d:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  140a71:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  140a75:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int n = vsnprintf(s, size, format, val);
  140a79:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  140a7d:	e8 84 ff ff ff       	callq  140a06 <vsnprintf>
    va_end(val);
    return n;
}
  140a82:	c9                   	leaveq 
  140a83:	c3                   	retq   

0000000000140a84 <console_clear>:

// console_clear
//    Erases the console and moves the cursor to the upper left (CPOS(0, 0)).

void console_clear(void) {
    for (int i = 0; i < CONSOLE_ROWS * CONSOLE_COLUMNS; ++i) {
  140a84:	b8 00 80 0b 00       	mov    $0xb8000,%eax
  140a89:	ba a0 8f 0b 00       	mov    $0xb8fa0,%edx
        console[i] = ' ' | 0x0700;
  140a8e:	66 c7 00 20 07       	movw   $0x720,(%rax)
    for (int i = 0; i < CONSOLE_ROWS * CONSOLE_COLUMNS; ++i) {
  140a93:	48 83 c0 02          	add    $0x2,%rax
  140a97:	48 39 d0             	cmp    %rdx,%rax
  140a9a:	75 f2                	jne    140a8e <console_clear+0xa>
    }
    cursorpos = 0;
  140a9c:	c7 05 56 85 f7 ff 00 	movl   $0x0,-0x87aaa(%rip)        # b8ffc <cursorpos>
  140aa3:	00 00 00 
}
  140aa6:	c3                   	retq   

0000000000140aa7 <app_printf>:
#include "process.h"

// app_printf
//     A version of console_printf that picks a sensible color by process ID.

void app_printf(int colorid, const char* format, ...) {
  140aa7:	55                   	push   %rbp
  140aa8:	48 89 e5             	mov    %rsp,%rbp
  140aab:	48 83 ec 50          	sub    $0x50,%rsp
  140aaf:	49 89 f2             	mov    %rsi,%r10
  140ab2:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  140ab6:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  140aba:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  140abe:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    int color;
    if (colorid < 0) {
        color = 0x0700;
  140ac2:	be 00 07 00 00       	mov    $0x700,%esi
    if (colorid < 0) {
  140ac7:	85 ff                	test   %edi,%edi
  140ac9:	78 2e                	js     140af9 <app_printf+0x52>
    } else {
        static const uint8_t col[] = { 0x0E, 0x0F, 0x0C, 0x0A, 0x09 };
        color = col[colorid % sizeof(col)] << 8;
  140acb:	48 63 ff             	movslq %edi,%rdi
  140ace:	48 ba cd cc cc cc cc 	movabs $0xcccccccccccccccd,%rdx
  140ad5:	cc cc cc 
  140ad8:	48 89 f8             	mov    %rdi,%rax
  140adb:	48 f7 e2             	mul    %rdx
  140ade:	48 89 d0             	mov    %rdx,%rax
  140ae1:	48 c1 e8 02          	shr    $0x2,%rax
  140ae5:	48 83 e2 fc          	and    $0xfffffffffffffffc,%rdx
  140ae9:	48 01 c2             	add    %rax,%rdx
  140aec:	48 29 d7             	sub    %rdx,%rdi
  140aef:	0f b6 b7 9d 0e 14 00 	movzbl 0x140e9d(%rdi),%esi
  140af6:	c1 e6 08             	shl    $0x8,%esi
    }

    va_list val;
    va_start(val, format);
  140af9:	c7 45 b8 10 00 00 00 	movl   $0x10,-0x48(%rbp)
  140b00:	48 8d 45 10          	lea    0x10(%rbp),%rax
  140b04:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  140b08:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  140b0c:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    cursorpos = console_vprintf(cursorpos, color, format, val);
  140b10:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  140b14:	4c 89 d2             	mov    %r10,%rdx
  140b17:	8b 3d df 84 f7 ff    	mov    -0x87b21(%rip),%edi        # b8ffc <cursorpos>
  140b1d:	e8 69 fe ff ff       	callq  14098b <console_vprintf>
    va_end(val);

    if (CROW(cursorpos) >= 23) {
        cursorpos = CPOS(0, 0);
  140b22:	3d 30 07 00 00       	cmp    $0x730,%eax
  140b27:	ba 00 00 00 00       	mov    $0x0,%edx
  140b2c:	0f 4d c2             	cmovge %edx,%eax
  140b2f:	89 05 c7 84 f7 ff    	mov    %eax,-0x87b39(%rip)        # b8ffc <cursorpos>
    }
}
  140b35:	c9                   	leaveq 
  140b36:	c3                   	retq   

0000000000140b37 <kernel_panic>:


// kernel_panic, assert_fail
//     Call the INT_SYS_PANIC system call so the kernel loops until Control-C.

void kernel_panic(const char* format, ...) {
  140b37:	55                   	push   %rbp
  140b38:	48 89 e5             	mov    %rsp,%rbp
  140b3b:	53                   	push   %rbx
  140b3c:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  140b43:	48 89 fb             	mov    %rdi,%rbx
  140b46:	48 89 75 c8          	mov    %rsi,-0x38(%rbp)
  140b4a:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  140b4e:	48 89 4d d8          	mov    %rcx,-0x28(%rbp)
  140b52:	4c 89 45 e0          	mov    %r8,-0x20(%rbp)
  140b56:	4c 89 4d e8          	mov    %r9,-0x18(%rbp)
    va_list val;
    va_start(val, format);
  140b5a:	c7 45 a8 08 00 00 00 	movl   $0x8,-0x58(%rbp)
  140b61:	48 8d 45 10          	lea    0x10(%rbp),%rax
  140b65:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  140b69:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
  140b6d:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
    char buf[160];
    memcpy(buf, "PANIC: ", 7);
  140b71:	ba 07 00 00 00       	mov    $0x7,%edx
  140b76:	be 67 0e 14 00       	mov    $0x140e67,%esi
  140b7b:	48 8d bd 08 ff ff ff 	lea    -0xf8(%rbp),%rdi
  140b82:	e8 ab f5 ff ff       	callq  140132 <memcpy>
    int len = vsnprintf(&buf[7], sizeof(buf) - 7, format, val) + 7;
  140b87:	48 8d 4d a8          	lea    -0x58(%rbp),%rcx
  140b8b:	48 89 da             	mov    %rbx,%rdx
  140b8e:	be 99 00 00 00       	mov    $0x99,%esi
  140b93:	48 8d bd 0f ff ff ff 	lea    -0xf1(%rbp),%rdi
  140b9a:	e8 67 fe ff ff       	callq  140a06 <vsnprintf>
  140b9f:	8d 50 07             	lea    0x7(%rax),%edx
    va_end(val);
    if (len > 0 && buf[len - 1] != '\n') {
  140ba2:	85 d2                	test   %edx,%edx
  140ba4:	7e 0f                	jle    140bb5 <kernel_panic+0x7e>
  140ba6:	83 c0 06             	add    $0x6,%eax
  140ba9:	48 98                	cltq   
  140bab:	80 bc 05 08 ff ff ff 	cmpb   $0xa,-0xf8(%rbp,%rax,1)
  140bb2:	0a 
  140bb3:	75 2a                	jne    140bdf <kernel_panic+0xa8>
        strcpy(buf + len - (len == (int) sizeof(buf) - 1), "\n");
    }
    (void) console_printf(CPOS(23, 0), 0xC000, "%s", buf);
  140bb5:	48 8d 9d 08 ff ff ff 	lea    -0xf8(%rbp),%rbx
  140bbc:	48 89 d9             	mov    %rbx,%rcx
  140bbf:	ba 71 0e 14 00       	mov    $0x140e71,%edx
  140bc4:	be 00 c0 00 00       	mov    $0xc000,%esi
  140bc9:	bf 30 07 00 00       	mov    $0x730,%edi
  140bce:	b8 00 00 00 00       	mov    $0x0,%eax
  140bd3:	e8 f8 fd ff ff       	callq  1409d0 <console_printf>
    asm volatile ("int %0" : /* no result */
  140bd8:	48 89 df             	mov    %rbx,%rdi
  140bdb:	cd 30                	int    $0x30
 loop: goto loop;
  140bdd:	eb fe                	jmp    140bdd <kernel_panic+0xa6>
        strcpy(buf + len - (len == (int) sizeof(buf) - 1), "\n");
  140bdf:	48 63 c2             	movslq %edx,%rax
  140be2:	81 fa 9f 00 00 00    	cmp    $0x9f,%edx
  140be8:	0f 94 c2             	sete   %dl
  140beb:	0f b6 d2             	movzbl %dl,%edx
  140bee:	48 29 d0             	sub    %rdx,%rax
  140bf1:	48 8d bc 05 08 ff ff 	lea    -0xf8(%rbp,%rax,1),%rdi
  140bf8:	ff 
  140bf9:	be 6f 0e 14 00       	mov    $0x140e6f,%esi
  140bfe:	e8 f1 f5 ff ff       	callq  1401f4 <strcpy>
  140c03:	eb b0                	jmp    140bb5 <kernel_panic+0x7e>

0000000000140c05 <assert_fail>:
    panic(buf);
 spinloop: goto spinloop;       // should never get here
}

void assert_fail(const char* file, int line, const char* msg) {
  140c05:	55                   	push   %rbp
  140c06:	48 89 e5             	mov    %rsp,%rbp
  140c09:	48 89 f9             	mov    %rdi,%rcx
  140c0c:	41 89 f0             	mov    %esi,%r8d
  140c0f:	49 89 d1             	mov    %rdx,%r9
    (void) console_printf(CPOS(23, 0), 0xC000,
  140c12:	ba 78 0e 14 00       	mov    $0x140e78,%edx
  140c17:	be 00 c0 00 00       	mov    $0xc000,%esi
  140c1c:	bf 30 07 00 00       	mov    $0x730,%edi
  140c21:	b8 00 00 00 00       	mov    $0x0,%eax
  140c26:	e8 a5 fd ff ff       	callq  1409d0 <console_printf>
    asm volatile ("int %0" : /* no result */
  140c2b:	bf 00 00 00 00       	mov    $0x0,%edi
  140c30:	cd 30                	int    $0x30
 loop: goto loop;
  140c32:	eb fe                	jmp    140c32 <assert_fail+0x2d>
