
obj/p-test.full:     file format elf64-x86-64


Disassembly of section .text:

0000000000100000 <process_main>:
uint8_t *heap_bottom;
uint8_t *stack_bottom;



void process_main(void) {
  100000:	55                   	push   %rbp
  100001:	48 89 e5             	mov    %rsp,%rbp
  100004:	41 55                	push   %r13
  100006:	41 54                	push   %r12
  100008:	53                   	push   %rbx
  100009:	48 83 ec 08          	sub    $0x8,%rsp

// getpid
//    Return current process ID.
static inline pid_t getpid(void) {
    pid_t result;
    asm volatile ("int %1" : "=a" (result)
  10000d:	cd 31                	int    $0x31
  10000f:	89 c7                	mov    %eax,%edi
    pid_t p = getpid();
    srand(p);
  100011:	e8 8b 03 00 00       	callq  1003a1 <srand>
    heap_bottom = heap_top = ROUNDUP((uint8_t*) end, PAGESIZE);
  100016:	b8 57 30 10 00       	mov    $0x103057,%eax
  10001b:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  100021:	48 89 05 e8 1f 00 00 	mov    %rax,0x1fe8(%rip)        # 102010 <heap_top>
  100028:	48 89 05 d9 1f 00 00 	mov    %rax,0x1fd9(%rip)        # 102008 <heap_bottom>
    return rbp;
}

static inline uintptr_t read_rsp(void) {
    uintptr_t rsp;
    asm volatile("movq %%rsp,%0" : "=r" (rsp));
  10002f:	48 89 e0             	mov    %rsp,%rax
    stack_bottom = ROUNDDOWN((uint8_t*) read_rsp() - 1, PAGESIZE);
  100032:	48 83 e8 01          	sub    $0x1,%rax
  100036:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  10003c:	48 89 05 bd 1f 00 00 	mov    %rax,0x1fbd(%rip)        # 102000 <stack_bottom>

    void *ptr = malloc(25);
  100043:	bf 19 00 00 00       	mov    $0x19,%edi
  100048:	e8 78 12 00 00       	callq  1012c5 <malloc>
    assert(ptr != NULL);
  10004d:	48 85 c0             	test   %rax,%rax
  100050:	74 75                	je     1000c7 <process_main+0xc7>
  100052:	48 89 c3             	mov    %rax,%rbx

    memset(ptr, 'A', 25);
  100055:	ba 19 00 00 00       	mov    $0x19,%edx
  10005a:	be 41 00 00 00       	mov    $0x41,%esi
  10005f:	48 89 c7             	mov    %rax,%rdi
  100062:	e8 3a 02 00 00       	callq  1002a1 <memset>

    ptr = realloc(ptr, 25000);
  100067:	be a8 61 00 00       	mov    $0x61a8,%esi
  10006c:	48 89 df             	mov    %rbx,%rdi
  10006f:	e8 6d 13 00 00       	callq  1013e1 <realloc>
  100074:	49 89 c4             	mov    %rax,%r12
    assert(ptr != NULL);
  100077:	48 8d 50 19          	lea    0x19(%rax),%rdx
  10007b:	48 85 c0             	test   %rax,%rax
  10007e:	74 5b                	je     1000db <process_main+0xdb>

    /* check that memory was copied */
    for(size_t i = 0; i < 25; ++i) {
        assert(((char *)ptr)[i] == 'A');
  100080:	80 38 41             	cmpb   $0x41,(%rax)
  100083:	75 6a                	jne    1000ef <process_main+0xef>
    for(size_t i = 0; i < 25; ++i) {
  100085:	48 83 c0 01          	add    $0x1,%rax
  100089:	48 39 d0             	cmp    %rdx,%rax
  10008c:	75 f2                	jne    100080 <process_main+0x80>
    }
    memset(ptr, 'A', 25000);
  10008e:	ba a8 61 00 00       	mov    $0x61a8,%edx
  100093:	be 41 00 00 00       	mov    $0x41,%esi
  100098:	4c 89 e7             	mov    %r12,%rdi
  10009b:	e8 01 02 00 00       	callq  1002a1 <memset>


    void *ptr2 = malloc(1024);
  1000a0:	bf 00 04 00 00       	mov    $0x400,%edi
  1000a5:	e8 1b 12 00 00       	callq  1012c5 <malloc>
  1000aa:	48 89 c3             	mov    %rax,%rbx
    memset(ptr2, 'B', 1024);
  1000ad:	ba 00 04 00 00       	mov    $0x400,%edx
  1000b2:	be 42 00 00 00       	mov    $0x42,%esi
  1000b7:	48 89 c7             	mov    %rax,%rdi
  1000ba:	e8 e2 01 00 00       	callq  1002a1 <memset>

    for(size_t i = 512; i > 0; --i) {
  1000bf:	41 bd 00 02 00 00    	mov    $0x200,%r13d
  1000c5:	eb 56                	jmp    10011d <process_main+0x11d>
    assert(ptr != NULL);
  1000c7:	ba 40 18 10 00       	mov    $0x101840,%edx
  1000cc:	be 17 00 00 00       	mov    $0x17,%esi
  1000d1:	bf 4c 18 10 00       	mov    $0x10184c,%edi
  1000d6:	e8 2f 17 00 00       	callq  10180a <assert_fail>
    assert(ptr != NULL);
  1000db:	ba 40 18 10 00       	mov    $0x101840,%edx
  1000e0:	be 1c 00 00 00       	mov    $0x1c,%esi
  1000e5:	bf 4c 18 10 00       	mov    $0x10184c,%edi
  1000ea:	e8 1b 17 00 00       	callq  10180a <assert_fail>
        assert(((char *)ptr)[i] == 'A');
  1000ef:	ba 55 18 10 00       	mov    $0x101855,%edx
  1000f4:	be 20 00 00 00       	mov    $0x20,%esi
  1000f9:	bf 4c 18 10 00       	mov    $0x10184c,%edi
  1000fe:	e8 07 17 00 00       	callq  10180a <assert_fail>
        ptr2 = realloc(ptr2, i);
	for(size_t j = 0; j < i; ++j) {
            assert(((char *)ptr2)[j] == 'B');
  100103:	ba 6d 18 10 00       	mov    $0x10186d,%edx
  100108:	be 2b 00 00 00       	mov    $0x2b,%esi
  10010d:	bf 4c 18 10 00       	mov    $0x10184c,%edi
  100112:	e8 f3 16 00 00       	callq  10180a <assert_fail>
    for(size_t i = 512; i > 0; --i) {
  100117:	49 83 ed 01          	sub    $0x1,%r13
  10011b:	74 24                	je     100141 <process_main+0x141>
        ptr2 = realloc(ptr2, i);
  10011d:	4c 89 ee             	mov    %r13,%rsi
  100120:	48 89 df             	mov    %rbx,%rdi
  100123:	e8 b9 12 00 00       	callq  1013e1 <realloc>
  100128:	48 89 c3             	mov    %rax,%rbx
	for(size_t j = 0; j < i; ++j) {
  10012b:	ba 00 00 00 00       	mov    $0x0,%edx
            assert(((char *)ptr2)[j] == 'B');
  100130:	80 3c 13 42          	cmpb   $0x42,(%rbx,%rdx,1)
  100134:	75 cd                	jne    100103 <process_main+0x103>
	for(size_t j = 0; j < i; ++j) {
  100136:	48 83 c2 01          	add    $0x1,%rdx
  10013a:	4c 39 ea             	cmp    %r13,%rdx
  10013d:	72 f1                	jb     100130 <process_main+0x130>
  10013f:	eb d6                	jmp    100117 <process_main+0x117>
        }
    }

    ptr2 = realloc(ptr2, 0);
  100141:	be 00 00 00 00       	mov    $0x0,%esi
  100146:	48 89 df             	mov    %rbx,%rdi
  100149:	e8 93 12 00 00       	callq  1013e1 <realloc>
    ptr2 = realloc(NULL, 0);
  10014e:	be 00 00 00 00       	mov    $0x0,%esi
  100153:	bf 00 00 00 00       	mov    $0x0,%edi
  100158:	e8 84 12 00 00       	callq  1013e1 <realloc>

    /* confirm no tampering */
    for(size_t i = 0; i < 25000; ++i) {
        assert(((char *)ptr)[i] == 'A');
  10015d:	43 80 3c 2c 41       	cmpb   $0x41,(%r12,%r13,1)
  100162:	75 24                	jne    100188 <process_main+0x188>
    for(size_t i = 0; i < 25000; ++i) {
  100164:	49 83 c5 01          	add    $0x1,%r13
  100168:	49 81 fd a8 61 00 00 	cmp    $0x61a8,%r13
  10016f:	75 ec                	jne    10015d <process_main+0x15d>
    }

    free(ptr);
  100171:	4c 89 e7             	mov    %r12,%rdi
  100174:	e8 36 12 00 00       	callq  1013af <free>

    TEST_PASS();
  100179:	bf 86 18 10 00       	mov    $0x101886,%edi
  10017e:	b8 00 00 00 00       	mov    $0x0,%eax
  100183:	e8 b4 15 00 00       	callq  10173c <kernel_panic>
        assert(((char *)ptr)[i] == 'A');
  100188:	ba 55 18 10 00       	mov    $0x101855,%edx
  10018d:	be 34 00 00 00       	mov    $0x34,%esi
  100192:	bf 4c 18 10 00       	mov    $0x10184c,%edi
  100197:	e8 6e 16 00 00       	callq  10180a <assert_fail>

000000000010019c <console_putc>:
typedef struct console_printer {
    printer p;
    uint16_t* cursor;
} console_printer;

static void console_putc(printer* p, unsigned char c, int color) {
  10019c:	48 89 f9             	mov    %rdi,%rcx
  10019f:	89 d7                	mov    %edx,%edi
    console_printer* cp = (console_printer*) p;
    if (cp->cursor >= console + CONSOLE_ROWS * CONSOLE_COLUMNS) {
  1001a1:	48 81 79 08 a0 8f 0b 	cmpq   $0xb8fa0,0x8(%rcx)
  1001a8:	00 
  1001a9:	72 08                	jb     1001b3 <console_putc+0x17>
        cp->cursor = console;
  1001ab:	48 c7 41 08 00 80 0b 	movq   $0xb8000,0x8(%rcx)
  1001b2:	00 
    }
    if (c == '\n') {
  1001b3:	40 80 fe 0a          	cmp    $0xa,%sil
  1001b7:	74 16                	je     1001cf <console_putc+0x33>
        int pos = (cp->cursor - console) % 80;
        for (; pos != 80; pos++) {
            *cp->cursor++ = ' ' | color;
        }
    } else {
        *cp->cursor++ = c | color;
  1001b9:	48 8b 41 08          	mov    0x8(%rcx),%rax
  1001bd:	48 8d 50 02          	lea    0x2(%rax),%rdx
  1001c1:	48 89 51 08          	mov    %rdx,0x8(%rcx)
  1001c5:	40 0f b6 f6          	movzbl %sil,%esi
  1001c9:	09 fe                	or     %edi,%esi
  1001cb:	66 89 30             	mov    %si,(%rax)
    }
}
  1001ce:	c3                   	retq   
        int pos = (cp->cursor - console) % 80;
  1001cf:	4c 8b 41 08          	mov    0x8(%rcx),%r8
  1001d3:	49 81 e8 00 80 0b 00 	sub    $0xb8000,%r8
  1001da:	4c 89 c6             	mov    %r8,%rsi
  1001dd:	48 d1 fe             	sar    %rsi
  1001e0:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
  1001e7:	66 66 66 
  1001ea:	48 89 f0             	mov    %rsi,%rax
  1001ed:	48 f7 ea             	imul   %rdx
  1001f0:	48 c1 fa 05          	sar    $0x5,%rdx
  1001f4:	49 c1 f8 3f          	sar    $0x3f,%r8
  1001f8:	4c 29 c2             	sub    %r8,%rdx
  1001fb:	48 8d 14 92          	lea    (%rdx,%rdx,4),%rdx
  1001ff:	48 c1 e2 04          	shl    $0x4,%rdx
  100203:	89 f0                	mov    %esi,%eax
  100205:	29 d0                	sub    %edx,%eax
            *cp->cursor++ = ' ' | color;
  100207:	83 cf 20             	or     $0x20,%edi
  10020a:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  10020e:	48 8d 72 02          	lea    0x2(%rdx),%rsi
  100212:	48 89 71 08          	mov    %rsi,0x8(%rcx)
  100216:	66 89 3a             	mov    %di,(%rdx)
        for (; pos != 80; pos++) {
  100219:	83 c0 01             	add    $0x1,%eax
  10021c:	83 f8 50             	cmp    $0x50,%eax
  10021f:	75 e9                	jne    10020a <console_putc+0x6e>
  100221:	c3                   	retq   

0000000000100222 <string_putc>:
    char* end;
} string_printer;

static void string_putc(printer* p, unsigned char c, int color) {
    string_printer* sp = (string_printer*) p;
    if (sp->s < sp->end) {
  100222:	48 8b 47 08          	mov    0x8(%rdi),%rax
  100226:	48 3b 47 10          	cmp    0x10(%rdi),%rax
  10022a:	73 0b                	jae    100237 <string_putc+0x15>
        *sp->s++ = c;
  10022c:	48 8d 50 01          	lea    0x1(%rax),%rdx
  100230:	48 89 57 08          	mov    %rdx,0x8(%rdi)
  100234:	40 88 30             	mov    %sil,(%rax)
    }
    (void) color;
}
  100237:	c3                   	retq   

0000000000100238 <memcpy>:
void* memcpy(void* dst, const void* src, size_t n) {
  100238:	48 89 f8             	mov    %rdi,%rax
    for (char* d = (char*) dst; n > 0; --n, ++s, ++d) {
  10023b:	48 85 d2             	test   %rdx,%rdx
  10023e:	74 17                	je     100257 <memcpy+0x1f>
  100240:	b9 00 00 00 00       	mov    $0x0,%ecx
        *d = *s;
  100245:	44 0f b6 04 0e       	movzbl (%rsi,%rcx,1),%r8d
  10024a:	44 88 04 08          	mov    %r8b,(%rax,%rcx,1)
    for (char* d = (char*) dst; n > 0; --n, ++s, ++d) {
  10024e:	48 83 c1 01          	add    $0x1,%rcx
  100252:	48 39 d1             	cmp    %rdx,%rcx
  100255:	75 ee                	jne    100245 <memcpy+0xd>
}
  100257:	c3                   	retq   

0000000000100258 <memmove>:
void* memmove(void* dst, const void* src, size_t n) {
  100258:	48 89 f8             	mov    %rdi,%rax
    if (s < d && s + n > d) {
  10025b:	48 39 fe             	cmp    %rdi,%rsi
  10025e:	72 1d                	jb     10027d <memmove+0x25>
        while (n-- > 0) {
  100260:	b9 00 00 00 00       	mov    $0x0,%ecx
  100265:	48 85 d2             	test   %rdx,%rdx
  100268:	74 12                	je     10027c <memmove+0x24>
            *d++ = *s++;
  10026a:	0f b6 3c 0e          	movzbl (%rsi,%rcx,1),%edi
  10026e:	40 88 3c 08          	mov    %dil,(%rax,%rcx,1)
        while (n-- > 0) {
  100272:	48 83 c1 01          	add    $0x1,%rcx
  100276:	48 39 ca             	cmp    %rcx,%rdx
  100279:	75 ef                	jne    10026a <memmove+0x12>
}
  10027b:	c3                   	retq   
  10027c:	c3                   	retq   
    if (s < d && s + n > d) {
  10027d:	48 8d 0c 16          	lea    (%rsi,%rdx,1),%rcx
  100281:	48 39 cf             	cmp    %rcx,%rdi
  100284:	73 da                	jae    100260 <memmove+0x8>
        while (n-- > 0) {
  100286:	48 8d 4a ff          	lea    -0x1(%rdx),%rcx
  10028a:	48 85 d2             	test   %rdx,%rdx
  10028d:	74 ec                	je     10027b <memmove+0x23>
            *--d = *--s;
  10028f:	0f b6 14 0e          	movzbl (%rsi,%rcx,1),%edx
  100293:	88 14 08             	mov    %dl,(%rax,%rcx,1)
        while (n-- > 0) {
  100296:	48 83 e9 01          	sub    $0x1,%rcx
  10029a:	48 83 f9 ff          	cmp    $0xffffffffffffffff,%rcx
  10029e:	75 ef                	jne    10028f <memmove+0x37>
  1002a0:	c3                   	retq   

00000000001002a1 <memset>:
void* memset(void* v, int c, size_t n) {
  1002a1:	48 89 f8             	mov    %rdi,%rax
    for (char* p = (char*) v; n > 0; ++p, --n) {
  1002a4:	48 85 d2             	test   %rdx,%rdx
  1002a7:	74 12                	je     1002bb <memset+0x1a>
  1002a9:	48 01 fa             	add    %rdi,%rdx
  1002ac:	48 89 f9             	mov    %rdi,%rcx
        *p = c;
  1002af:	40 88 31             	mov    %sil,(%rcx)
    for (char* p = (char*) v; n > 0; ++p, --n) {
  1002b2:	48 83 c1 01          	add    $0x1,%rcx
  1002b6:	48 39 ca             	cmp    %rcx,%rdx
  1002b9:	75 f4                	jne    1002af <memset+0xe>
}
  1002bb:	c3                   	retq   

00000000001002bc <strlen>:
    for (n = 0; *s != '\0'; ++s) {
  1002bc:	80 3f 00             	cmpb   $0x0,(%rdi)
  1002bf:	74 10                	je     1002d1 <strlen+0x15>
  1002c1:	b8 00 00 00 00       	mov    $0x0,%eax
        ++n;
  1002c6:	48 83 c0 01          	add    $0x1,%rax
    for (n = 0; *s != '\0'; ++s) {
  1002ca:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  1002ce:	75 f6                	jne    1002c6 <strlen+0xa>
  1002d0:	c3                   	retq   
  1002d1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1002d6:	c3                   	retq   

00000000001002d7 <strnlen>:
size_t strnlen(const char* s, size_t maxlen) {
  1002d7:	48 89 f0             	mov    %rsi,%rax
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
  1002da:	ba 00 00 00 00       	mov    $0x0,%edx
  1002df:	48 85 f6             	test   %rsi,%rsi
  1002e2:	74 11                	je     1002f5 <strnlen+0x1e>
  1002e4:	80 3c 17 00          	cmpb   $0x0,(%rdi,%rdx,1)
  1002e8:	74 0c                	je     1002f6 <strnlen+0x1f>
        ++n;
  1002ea:	48 83 c2 01          	add    $0x1,%rdx
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
  1002ee:	48 39 d0             	cmp    %rdx,%rax
  1002f1:	75 f1                	jne    1002e4 <strnlen+0xd>
  1002f3:	eb 04                	jmp    1002f9 <strnlen+0x22>
  1002f5:	c3                   	retq   
  1002f6:	48 89 d0             	mov    %rdx,%rax
}
  1002f9:	c3                   	retq   

00000000001002fa <strcpy>:
char* strcpy(char* dst, const char* src) {
  1002fa:	48 89 f8             	mov    %rdi,%rax
  1002fd:	ba 00 00 00 00       	mov    $0x0,%edx
        *d++ = *src++;
  100302:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
  100306:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
    } while (d[-1]);
  100309:	48 83 c2 01          	add    $0x1,%rdx
  10030d:	84 c9                	test   %cl,%cl
  10030f:	75 f1                	jne    100302 <strcpy+0x8>
}
  100311:	c3                   	retq   

0000000000100312 <strcmp>:
    while (*a && *b && *a == *b) {
  100312:	0f b6 07             	movzbl (%rdi),%eax
  100315:	84 c0                	test   %al,%al
  100317:	74 1a                	je     100333 <strcmp+0x21>
  100319:	0f b6 16             	movzbl (%rsi),%edx
  10031c:	38 c2                	cmp    %al,%dl
  10031e:	75 13                	jne    100333 <strcmp+0x21>
  100320:	84 d2                	test   %dl,%dl
  100322:	74 0f                	je     100333 <strcmp+0x21>
        ++a, ++b;
  100324:	48 83 c7 01          	add    $0x1,%rdi
  100328:	48 83 c6 01          	add    $0x1,%rsi
    while (*a && *b && *a == *b) {
  10032c:	0f b6 07             	movzbl (%rdi),%eax
  10032f:	84 c0                	test   %al,%al
  100331:	75 e6                	jne    100319 <strcmp+0x7>
    return ((unsigned char) *a > (unsigned char) *b)
  100333:	3a 06                	cmp    (%rsi),%al
  100335:	0f 97 c0             	seta   %al
  100338:	0f b6 c0             	movzbl %al,%eax
        - ((unsigned char) *a < (unsigned char) *b);
  10033b:	83 d8 00             	sbb    $0x0,%eax
}
  10033e:	c3                   	retq   

000000000010033f <strchr>:
    while (*s && *s != (char) c) {
  10033f:	0f b6 07             	movzbl (%rdi),%eax
  100342:	84 c0                	test   %al,%al
  100344:	74 10                	je     100356 <strchr+0x17>
  100346:	40 38 f0             	cmp    %sil,%al
  100349:	74 18                	je     100363 <strchr+0x24>
        ++s;
  10034b:	48 83 c7 01          	add    $0x1,%rdi
    while (*s && *s != (char) c) {
  10034f:	0f b6 07             	movzbl (%rdi),%eax
  100352:	84 c0                	test   %al,%al
  100354:	75 f0                	jne    100346 <strchr+0x7>
        return NULL;
  100356:	40 84 f6             	test   %sil,%sil
  100359:	b8 00 00 00 00       	mov    $0x0,%eax
  10035e:	48 0f 44 c7          	cmove  %rdi,%rax
}
  100362:	c3                   	retq   
  100363:	48 89 f8             	mov    %rdi,%rax
  100366:	c3                   	retq   

0000000000100367 <rand>:
    if (!rand_seed_set) {
  100367:	83 3d ae 1c 00 00 00 	cmpl   $0x0,0x1cae(%rip)        # 10201c <rand_seed_set>
  10036e:	74 1b                	je     10038b <rand+0x24>
    rand_seed = rand_seed * 1664525U + 1013904223U;
  100370:	69 05 9e 1c 00 00 0d 	imul   $0x19660d,0x1c9e(%rip),%eax        # 102018 <rand_seed>
  100377:	66 19 00 
  10037a:	05 5f f3 6e 3c       	add    $0x3c6ef35f,%eax
  10037f:	89 05 93 1c 00 00    	mov    %eax,0x1c93(%rip)        # 102018 <rand_seed>
    return rand_seed & RAND_MAX;
  100385:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
}
  10038a:	c3                   	retq   
    rand_seed = seed;
  10038b:	c7 05 83 1c 00 00 9e 	movl   $0x30d4879e,0x1c83(%rip)        # 102018 <rand_seed>
  100392:	87 d4 30 
    rand_seed_set = 1;
  100395:	c7 05 7d 1c 00 00 01 	movl   $0x1,0x1c7d(%rip)        # 10201c <rand_seed_set>
  10039c:	00 00 00 
}
  10039f:	eb cf                	jmp    100370 <rand+0x9>

00000000001003a1 <srand>:
    rand_seed = seed;
  1003a1:	89 3d 71 1c 00 00    	mov    %edi,0x1c71(%rip)        # 102018 <rand_seed>
    rand_seed_set = 1;
  1003a7:	c7 05 6b 1c 00 00 01 	movl   $0x1,0x1c6b(%rip)        # 10201c <rand_seed_set>
  1003ae:	00 00 00 
}
  1003b1:	c3                   	retq   

00000000001003b2 <printer_vprintf>:
void printer_vprintf(printer* p, int color, const char* format, va_list val) {
  1003b2:	55                   	push   %rbp
  1003b3:	48 89 e5             	mov    %rsp,%rbp
  1003b6:	41 57                	push   %r15
  1003b8:	41 56                	push   %r14
  1003ba:	41 55                	push   %r13
  1003bc:	41 54                	push   %r12
  1003be:	53                   	push   %rbx
  1003bf:	48 83 ec 58          	sub    $0x58,%rsp
  1003c3:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
    for (; *format; ++format) {
  1003c7:	0f b6 02             	movzbl (%rdx),%eax
  1003ca:	84 c0                	test   %al,%al
  1003cc:	0f 84 b0 06 00 00    	je     100a82 <printer_vprintf+0x6d0>
  1003d2:	49 89 fe             	mov    %rdi,%r14
  1003d5:	49 89 d4             	mov    %rdx,%r12
            length = 1;
  1003d8:	41 89 f7             	mov    %esi,%r15d
  1003db:	e9 a4 04 00 00       	jmpq   100884 <printer_vprintf+0x4d2>
        for (++format; *format; ++format) {
  1003e0:	49 8d 5c 24 01       	lea    0x1(%r12),%rbx
  1003e5:	45 0f b6 64 24 01    	movzbl 0x1(%r12),%r12d
  1003eb:	45 84 e4             	test   %r12b,%r12b
  1003ee:	0f 84 82 06 00 00    	je     100a76 <printer_vprintf+0x6c4>
        int flags = 0;
  1003f4:	41 bd 00 00 00 00    	mov    $0x0,%r13d
            const char* flagc = strchr(flag_chars, *format);
  1003fa:	41 0f be f4          	movsbl %r12b,%esi
  1003fe:	bf a1 1a 10 00       	mov    $0x101aa1,%edi
  100403:	e8 37 ff ff ff       	callq  10033f <strchr>
  100408:	48 89 c1             	mov    %rax,%rcx
            if (flagc) {
  10040b:	48 85 c0             	test   %rax,%rax
  10040e:	74 55                	je     100465 <printer_vprintf+0xb3>
                flags |= 1 << (flagc - flag_chars);
  100410:	48 81 e9 a1 1a 10 00 	sub    $0x101aa1,%rcx
  100417:	b8 01 00 00 00       	mov    $0x1,%eax
  10041c:	d3 e0                	shl    %cl,%eax
  10041e:	41 09 c5             	or     %eax,%r13d
        for (++format; *format; ++format) {
  100421:	48 83 c3 01          	add    $0x1,%rbx
  100425:	44 0f b6 23          	movzbl (%rbx),%r12d
  100429:	45 84 e4             	test   %r12b,%r12b
  10042c:	75 cc                	jne    1003fa <printer_vprintf+0x48>
  10042e:	44 89 6d a8          	mov    %r13d,-0x58(%rbp)
        int width = -1;
  100432:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
        int precision = -1;
  100438:	c7 45 9c ff ff ff ff 	movl   $0xffffffff,-0x64(%rbp)
        if (*format == '.') {
  10043f:	80 3b 2e             	cmpb   $0x2e,(%rbx)
  100442:	0f 84 a9 00 00 00    	je     1004f1 <printer_vprintf+0x13f>
        int length = 0;
  100448:	b9 00 00 00 00       	mov    $0x0,%ecx
        switch (*format) {
  10044d:	0f b6 13             	movzbl (%rbx),%edx
  100450:	8d 42 bd             	lea    -0x43(%rdx),%eax
  100453:	3c 37                	cmp    $0x37,%al
  100455:	0f 87 c4 04 00 00    	ja     10091f <printer_vprintf+0x56d>
  10045b:	0f b6 c0             	movzbl %al,%eax
  10045e:	ff 24 c5 b0 18 10 00 	jmpq   *0x1018b0(,%rax,8)
        if (*format >= '1' && *format <= '9') {
  100465:	44 89 6d a8          	mov    %r13d,-0x58(%rbp)
  100469:	41 8d 44 24 cf       	lea    -0x31(%r12),%eax
  10046e:	3c 08                	cmp    $0x8,%al
  100470:	77 2f                	ja     1004a1 <printer_vprintf+0xef>
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  100472:	0f b6 03             	movzbl (%rbx),%eax
  100475:	8d 50 d0             	lea    -0x30(%rax),%edx
  100478:	80 fa 09             	cmp    $0x9,%dl
  10047b:	77 5e                	ja     1004db <printer_vprintf+0x129>
  10047d:	41 bd 00 00 00 00    	mov    $0x0,%r13d
                width = 10 * width + *format++ - '0';
  100483:	48 83 c3 01          	add    $0x1,%rbx
  100487:	43 8d 54 ad 00       	lea    0x0(%r13,%r13,4),%edx
  10048c:	0f be c0             	movsbl %al,%eax
  10048f:	44 8d 6c 50 d0       	lea    -0x30(%rax,%rdx,2),%r13d
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  100494:	0f b6 03             	movzbl (%rbx),%eax
  100497:	8d 50 d0             	lea    -0x30(%rax),%edx
  10049a:	80 fa 09             	cmp    $0x9,%dl
  10049d:	76 e4                	jbe    100483 <printer_vprintf+0xd1>
  10049f:	eb 97                	jmp    100438 <printer_vprintf+0x86>
        } else if (*format == '*') {
  1004a1:	41 80 fc 2a          	cmp    $0x2a,%r12b
  1004a5:	75 3f                	jne    1004e6 <printer_vprintf+0x134>
            width = va_arg(val, int);
  1004a7:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1004ab:	8b 07                	mov    (%rdi),%eax
  1004ad:	83 f8 2f             	cmp    $0x2f,%eax
  1004b0:	77 17                	ja     1004c9 <printer_vprintf+0x117>
  1004b2:	89 c2                	mov    %eax,%edx
  1004b4:	48 03 57 10          	add    0x10(%rdi),%rdx
  1004b8:	83 c0 08             	add    $0x8,%eax
  1004bb:	89 07                	mov    %eax,(%rdi)
  1004bd:	44 8b 2a             	mov    (%rdx),%r13d
            ++format;
  1004c0:	48 83 c3 01          	add    $0x1,%rbx
  1004c4:	e9 6f ff ff ff       	jmpq   100438 <printer_vprintf+0x86>
            width = va_arg(val, int);
  1004c9:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1004cd:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  1004d1:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1004d5:	48 89 41 08          	mov    %rax,0x8(%rcx)
  1004d9:	eb e2                	jmp    1004bd <printer_vprintf+0x10b>
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  1004db:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  1004e1:	e9 52 ff ff ff       	jmpq   100438 <printer_vprintf+0x86>
        int width = -1;
  1004e6:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  1004ec:	e9 47 ff ff ff       	jmpq   100438 <printer_vprintf+0x86>
            ++format;
  1004f1:	48 8d 53 01          	lea    0x1(%rbx),%rdx
            if (*format >= '0' && *format <= '9') {
  1004f5:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  1004f9:	8d 48 d0             	lea    -0x30(%rax),%ecx
  1004fc:	80 f9 09             	cmp    $0x9,%cl
  1004ff:	76 13                	jbe    100514 <printer_vprintf+0x162>
            } else if (*format == '*') {
  100501:	3c 2a                	cmp    $0x2a,%al
  100503:	74 33                	je     100538 <printer_vprintf+0x186>
            ++format;
  100505:	48 89 d3             	mov    %rdx,%rbx
                precision = 0;
  100508:	c7 45 9c 00 00 00 00 	movl   $0x0,-0x64(%rbp)
  10050f:	e9 34 ff ff ff       	jmpq   100448 <printer_vprintf+0x96>
                for (precision = 0; *format >= '0' && *format <= '9'; ) {
  100514:	b9 00 00 00 00       	mov    $0x0,%ecx
                    precision = 10 * precision + *format++ - '0';
  100519:	48 83 c2 01          	add    $0x1,%rdx
  10051d:	8d 0c 89             	lea    (%rcx,%rcx,4),%ecx
  100520:	0f be c0             	movsbl %al,%eax
  100523:	8d 4c 48 d0          	lea    -0x30(%rax,%rcx,2),%ecx
                for (precision = 0; *format >= '0' && *format <= '9'; ) {
  100527:	0f b6 02             	movzbl (%rdx),%eax
  10052a:	8d 70 d0             	lea    -0x30(%rax),%esi
  10052d:	40 80 fe 09          	cmp    $0x9,%sil
  100531:	76 e6                	jbe    100519 <printer_vprintf+0x167>
                    precision = 10 * precision + *format++ - '0';
  100533:	48 89 d3             	mov    %rdx,%rbx
  100536:	eb 1c                	jmp    100554 <printer_vprintf+0x1a2>
                precision = va_arg(val, int);
  100538:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  10053c:	8b 07                	mov    (%rdi),%eax
  10053e:	83 f8 2f             	cmp    $0x2f,%eax
  100541:	77 23                	ja     100566 <printer_vprintf+0x1b4>
  100543:	89 c2                	mov    %eax,%edx
  100545:	48 03 57 10          	add    0x10(%rdi),%rdx
  100549:	83 c0 08             	add    $0x8,%eax
  10054c:	89 07                	mov    %eax,(%rdi)
  10054e:	8b 0a                	mov    (%rdx),%ecx
                ++format;
  100550:	48 83 c3 02          	add    $0x2,%rbx
            if (precision < 0) {
  100554:	85 c9                	test   %ecx,%ecx
  100556:	b8 00 00 00 00       	mov    $0x0,%eax
  10055b:	0f 49 c1             	cmovns %ecx,%eax
  10055e:	89 45 9c             	mov    %eax,-0x64(%rbp)
  100561:	e9 e2 fe ff ff       	jmpq   100448 <printer_vprintf+0x96>
                precision = va_arg(val, int);
  100566:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  10056a:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  10056e:	48 8d 42 08          	lea    0x8(%rdx),%rax
  100572:	48 89 41 08          	mov    %rax,0x8(%rcx)
  100576:	eb d6                	jmp    10054e <printer_vprintf+0x19c>
        switch (*format) {
  100578:	be f0 ff ff ff       	mov    $0xfffffff0,%esi
  10057d:	e9 f3 00 00 00       	jmpq   100675 <printer_vprintf+0x2c3>
            ++format;
  100582:	48 83 c3 01          	add    $0x1,%rbx
            length = 1;
  100586:	b9 01 00 00 00       	mov    $0x1,%ecx
            goto again;
  10058b:	e9 bd fe ff ff       	jmpq   10044d <printer_vprintf+0x9b>
            long x = length ? va_arg(val, long) : va_arg(val, int);
  100590:	85 c9                	test   %ecx,%ecx
  100592:	74 55                	je     1005e9 <printer_vprintf+0x237>
  100594:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  100598:	8b 07                	mov    (%rdi),%eax
  10059a:	83 f8 2f             	cmp    $0x2f,%eax
  10059d:	77 38                	ja     1005d7 <printer_vprintf+0x225>
  10059f:	89 c2                	mov    %eax,%edx
  1005a1:	48 03 57 10          	add    0x10(%rdi),%rdx
  1005a5:	83 c0 08             	add    $0x8,%eax
  1005a8:	89 07                	mov    %eax,(%rdi)
  1005aa:	48 8b 12             	mov    (%rdx),%rdx
            int negative = x < 0 ? FLAG_NEGATIVE : 0;
  1005ad:	48 89 d0             	mov    %rdx,%rax
  1005b0:	48 c1 f8 38          	sar    $0x38,%rax
            num = negative ? -x : x;
  1005b4:	49 89 d0             	mov    %rdx,%r8
  1005b7:	49 f7 d8             	neg    %r8
  1005ba:	25 80 00 00 00       	and    $0x80,%eax
  1005bf:	4c 0f 44 c2          	cmove  %rdx,%r8
            flags |= FLAG_NUMERIC | FLAG_SIGNED | negative;
  1005c3:	0b 45 a8             	or     -0x58(%rbp),%eax
  1005c6:	83 c8 60             	or     $0x60,%eax
  1005c9:	89 45 a8             	mov    %eax,-0x58(%rbp)
        char* data = "";
  1005cc:	41 bc cc 1a 10 00    	mov    $0x101acc,%r12d
            break;
  1005d2:	e9 35 01 00 00       	jmpq   10070c <printer_vprintf+0x35a>
            long x = length ? va_arg(val, long) : va_arg(val, int);
  1005d7:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1005db:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  1005df:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1005e3:	48 89 41 08          	mov    %rax,0x8(%rcx)
  1005e7:	eb c1                	jmp    1005aa <printer_vprintf+0x1f8>
  1005e9:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1005ed:	8b 07                	mov    (%rdi),%eax
  1005ef:	83 f8 2f             	cmp    $0x2f,%eax
  1005f2:	77 10                	ja     100604 <printer_vprintf+0x252>
  1005f4:	89 c2                	mov    %eax,%edx
  1005f6:	48 03 57 10          	add    0x10(%rdi),%rdx
  1005fa:	83 c0 08             	add    $0x8,%eax
  1005fd:	89 07                	mov    %eax,(%rdi)
  1005ff:	48 63 12             	movslq (%rdx),%rdx
  100602:	eb a9                	jmp    1005ad <printer_vprintf+0x1fb>
  100604:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  100608:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  10060c:	48 8d 42 08          	lea    0x8(%rdx),%rax
  100610:	48 89 47 08          	mov    %rax,0x8(%rdi)
  100614:	eb e9                	jmp    1005ff <printer_vprintf+0x24d>
        int base = 10;
  100616:	be 0a 00 00 00       	mov    $0xa,%esi
  10061b:	eb 58                	jmp    100675 <printer_vprintf+0x2c3>
            num = length ? va_arg(val, unsigned long) : va_arg(val, unsigned);
  10061d:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  100621:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  100625:	48 8d 42 08          	lea    0x8(%rdx),%rax
  100629:	48 89 41 08          	mov    %rax,0x8(%rcx)
  10062d:	eb 60                	jmp    10068f <printer_vprintf+0x2dd>
  10062f:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  100633:	8b 07                	mov    (%rdi),%eax
  100635:	83 f8 2f             	cmp    $0x2f,%eax
  100638:	77 10                	ja     10064a <printer_vprintf+0x298>
  10063a:	89 c2                	mov    %eax,%edx
  10063c:	48 03 57 10          	add    0x10(%rdi),%rdx
  100640:	83 c0 08             	add    $0x8,%eax
  100643:	89 07                	mov    %eax,(%rdi)
  100645:	44 8b 02             	mov    (%rdx),%r8d
  100648:	eb 48                	jmp    100692 <printer_vprintf+0x2e0>
  10064a:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  10064e:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  100652:	48 8d 42 08          	lea    0x8(%rdx),%rax
  100656:	48 89 41 08          	mov    %rax,0x8(%rcx)
  10065a:	eb e9                	jmp    100645 <printer_vprintf+0x293>
  10065c:	41 89 f1             	mov    %esi,%r9d
        if (flags & FLAG_NUMERIC) {
  10065f:	c7 45 8c 20 00 00 00 	movl   $0x20,-0x74(%rbp)
    const char* digits = upper_digits;
  100666:	bf 90 1a 10 00       	mov    $0x101a90,%edi
  10066b:	e9 e2 02 00 00       	jmpq   100952 <printer_vprintf+0x5a0>
            base = 16;
  100670:	be 10 00 00 00       	mov    $0x10,%esi
            num = length ? va_arg(val, unsigned long) : va_arg(val, unsigned);
  100675:	85 c9                	test   %ecx,%ecx
  100677:	74 b6                	je     10062f <printer_vprintf+0x27d>
  100679:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  10067d:	8b 01                	mov    (%rcx),%eax
  10067f:	83 f8 2f             	cmp    $0x2f,%eax
  100682:	77 99                	ja     10061d <printer_vprintf+0x26b>
  100684:	89 c2                	mov    %eax,%edx
  100686:	48 03 51 10          	add    0x10(%rcx),%rdx
  10068a:	83 c0 08             	add    $0x8,%eax
  10068d:	89 01                	mov    %eax,(%rcx)
  10068f:	4c 8b 02             	mov    (%rdx),%r8
            flags |= FLAG_NUMERIC;
  100692:	83 4d a8 20          	orl    $0x20,-0x58(%rbp)
    if (base < 0) {
  100696:	85 f6                	test   %esi,%esi
  100698:	79 c2                	jns    10065c <printer_vprintf+0x2aa>
        base = -base;
  10069a:	41 89 f1             	mov    %esi,%r9d
  10069d:	f7 de                	neg    %esi
  10069f:	c7 45 8c 20 00 00 00 	movl   $0x20,-0x74(%rbp)
        digits = lower_digits;
  1006a6:	bf 70 1a 10 00       	mov    $0x101a70,%edi
  1006ab:	e9 a2 02 00 00       	jmpq   100952 <printer_vprintf+0x5a0>
            num = (uintptr_t) va_arg(val, void*);
  1006b0:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1006b4:	8b 07                	mov    (%rdi),%eax
  1006b6:	83 f8 2f             	cmp    $0x2f,%eax
  1006b9:	77 1c                	ja     1006d7 <printer_vprintf+0x325>
  1006bb:	89 c2                	mov    %eax,%edx
  1006bd:	48 03 57 10          	add    0x10(%rdi),%rdx
  1006c1:	83 c0 08             	add    $0x8,%eax
  1006c4:	89 07                	mov    %eax,(%rdi)
  1006c6:	4c 8b 02             	mov    (%rdx),%r8
            flags |= FLAG_ALT | FLAG_ALT2 | FLAG_NUMERIC;
  1006c9:	81 4d a8 21 01 00 00 	orl    $0x121,-0x58(%rbp)
            base = -16;
  1006d0:	be f0 ff ff ff       	mov    $0xfffffff0,%esi
  1006d5:	eb c3                	jmp    10069a <printer_vprintf+0x2e8>
            num = (uintptr_t) va_arg(val, void*);
  1006d7:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1006db:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  1006df:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1006e3:	48 89 41 08          	mov    %rax,0x8(%rcx)
  1006e7:	eb dd                	jmp    1006c6 <printer_vprintf+0x314>
            data = va_arg(val, char*);
  1006e9:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1006ed:	8b 01                	mov    (%rcx),%eax
  1006ef:	83 f8 2f             	cmp    $0x2f,%eax
  1006f2:	0f 87 a5 01 00 00    	ja     10089d <printer_vprintf+0x4eb>
  1006f8:	89 c2                	mov    %eax,%edx
  1006fa:	48 03 51 10          	add    0x10(%rcx),%rdx
  1006fe:	83 c0 08             	add    $0x8,%eax
  100701:	89 01                	mov    %eax,(%rcx)
  100703:	4c 8b 22             	mov    (%rdx),%r12
        unsigned long num = 0;
  100706:	41 b8 00 00 00 00    	mov    $0x0,%r8d
        if (flags & FLAG_NUMERIC) {
  10070c:	8b 45 a8             	mov    -0x58(%rbp),%eax
  10070f:	83 e0 20             	and    $0x20,%eax
  100712:	89 45 8c             	mov    %eax,-0x74(%rbp)
  100715:	41 b9 0a 00 00 00    	mov    $0xa,%r9d
  10071b:	0f 85 21 02 00 00    	jne    100942 <printer_vprintf+0x590>
        if ((flags & FLAG_NUMERIC) && (flags & FLAG_SIGNED)) {
  100721:	8b 45 a8             	mov    -0x58(%rbp),%eax
  100724:	89 45 88             	mov    %eax,-0x78(%rbp)
  100727:	83 e0 60             	and    $0x60,%eax
  10072a:	83 f8 60             	cmp    $0x60,%eax
  10072d:	0f 84 54 02 00 00    	je     100987 <printer_vprintf+0x5d5>
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ALT)
  100733:	8b 45 a8             	mov    -0x58(%rbp),%eax
  100736:	83 e0 21             	and    $0x21,%eax
        const char* prefix = "";
  100739:	48 c7 45 a0 cc 1a 10 	movq   $0x101acc,-0x60(%rbp)
  100740:	00 
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ALT)
  100741:	83 f8 21             	cmp    $0x21,%eax
  100744:	0f 84 79 02 00 00    	je     1009c3 <printer_vprintf+0x611>
        if (precision >= 0 && !(flags & FLAG_NUMERIC)) {
  10074a:	8b 7d 9c             	mov    -0x64(%rbp),%edi
  10074d:	89 f8                	mov    %edi,%eax
  10074f:	f7 d0                	not    %eax
  100751:	c1 e8 1f             	shr    $0x1f,%eax
  100754:	89 45 84             	mov    %eax,-0x7c(%rbp)
  100757:	83 7d 8c 00          	cmpl   $0x0,-0x74(%rbp)
  10075b:	0f 85 9e 02 00 00    	jne    1009ff <printer_vprintf+0x64d>
  100761:	84 c0                	test   %al,%al
  100763:	0f 84 96 02 00 00    	je     1009ff <printer_vprintf+0x64d>
            len = strnlen(data, precision);
  100769:	48 63 f7             	movslq %edi,%rsi
  10076c:	4c 89 e7             	mov    %r12,%rdi
  10076f:	e8 63 fb ff ff       	callq  1002d7 <strnlen>
  100774:	89 45 98             	mov    %eax,-0x68(%rbp)
                   && !(flags & FLAG_LEFTJUSTIFY)
  100777:	8b 45 88             	mov    -0x78(%rbp),%eax
  10077a:	83 e0 26             	and    $0x26,%eax
            zeros = 0;
  10077d:	c7 45 9c 00 00 00 00 	movl   $0x0,-0x64(%rbp)
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ZERO)
  100784:	83 f8 22             	cmp    $0x22,%eax
  100787:	0f 84 aa 02 00 00    	je     100a37 <printer_vprintf+0x685>
        width -= len + zeros + strlen(prefix);
  10078d:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  100791:	e8 26 fb ff ff       	callq  1002bc <strlen>
  100796:	8b 55 9c             	mov    -0x64(%rbp),%edx
  100799:	03 55 98             	add    -0x68(%rbp),%edx
  10079c:	44 89 e9             	mov    %r13d,%ecx
  10079f:	29 d1                	sub    %edx,%ecx
  1007a1:	29 c1                	sub    %eax,%ecx
  1007a3:	89 4d 8c             	mov    %ecx,-0x74(%rbp)
  1007a6:	41 89 cd             	mov    %ecx,%r13d
        for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width) {
  1007a9:	f6 45 a8 04          	testb  $0x4,-0x58(%rbp)
  1007ad:	75 2d                	jne    1007dc <printer_vprintf+0x42a>
  1007af:	85 c9                	test   %ecx,%ecx
  1007b1:	7e 29                	jle    1007dc <printer_vprintf+0x42a>
            p->putc(p, ' ', color);
  1007b3:	44 89 fa             	mov    %r15d,%edx
  1007b6:	be 20 00 00 00       	mov    $0x20,%esi
  1007bb:	4c 89 f7             	mov    %r14,%rdi
  1007be:	41 ff 16             	callq  *(%r14)
        for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width) {
  1007c1:	41 83 ed 01          	sub    $0x1,%r13d
  1007c5:	45 85 ed             	test   %r13d,%r13d
  1007c8:	7f e9                	jg     1007b3 <printer_vprintf+0x401>
  1007ca:	8b 7d 8c             	mov    -0x74(%rbp),%edi
  1007cd:	85 ff                	test   %edi,%edi
  1007cf:	b8 01 00 00 00       	mov    $0x1,%eax
  1007d4:	0f 4f c7             	cmovg  %edi,%eax
  1007d7:	29 c7                	sub    %eax,%edi
  1007d9:	41 89 fd             	mov    %edi,%r13d
        for (; *prefix; ++prefix) {
  1007dc:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  1007e0:	0f b6 07             	movzbl (%rdi),%eax
  1007e3:	84 c0                	test   %al,%al
  1007e5:	74 22                	je     100809 <printer_vprintf+0x457>
  1007e7:	48 89 5d a8          	mov    %rbx,-0x58(%rbp)
  1007eb:	48 89 fb             	mov    %rdi,%rbx
            p->putc(p, *prefix, color);
  1007ee:	0f b6 f0             	movzbl %al,%esi
  1007f1:	44 89 fa             	mov    %r15d,%edx
  1007f4:	4c 89 f7             	mov    %r14,%rdi
  1007f7:	41 ff 16             	callq  *(%r14)
        for (; *prefix; ++prefix) {
  1007fa:	48 83 c3 01          	add    $0x1,%rbx
  1007fe:	0f b6 03             	movzbl (%rbx),%eax
  100801:	84 c0                	test   %al,%al
  100803:	75 e9                	jne    1007ee <printer_vprintf+0x43c>
  100805:	48 8b 5d a8          	mov    -0x58(%rbp),%rbx
        for (; zeros > 0; --zeros) {
  100809:	8b 45 9c             	mov    -0x64(%rbp),%eax
  10080c:	85 c0                	test   %eax,%eax
  10080e:	7e 1d                	jle    10082d <printer_vprintf+0x47b>
  100810:	48 89 5d a8          	mov    %rbx,-0x58(%rbp)
  100814:	89 c3                	mov    %eax,%ebx
            p->putc(p, '0', color);
  100816:	44 89 fa             	mov    %r15d,%edx
  100819:	be 30 00 00 00       	mov    $0x30,%esi
  10081e:	4c 89 f7             	mov    %r14,%rdi
  100821:	41 ff 16             	callq  *(%r14)
        for (; zeros > 0; --zeros) {
  100824:	83 eb 01             	sub    $0x1,%ebx
  100827:	75 ed                	jne    100816 <printer_vprintf+0x464>
  100829:	48 8b 5d a8          	mov    -0x58(%rbp),%rbx
        for (; len > 0; ++data, --len) {
  10082d:	8b 45 98             	mov    -0x68(%rbp),%eax
  100830:	85 c0                	test   %eax,%eax
  100832:	7e 27                	jle    10085b <printer_vprintf+0x4a9>
  100834:	89 c0                	mov    %eax,%eax
  100836:	4c 01 e0             	add    %r12,%rax
  100839:	48 89 5d a8          	mov    %rbx,-0x58(%rbp)
  10083d:	48 89 c3             	mov    %rax,%rbx
            p->putc(p, *data, color);
  100840:	41 0f b6 34 24       	movzbl (%r12),%esi
  100845:	44 89 fa             	mov    %r15d,%edx
  100848:	4c 89 f7             	mov    %r14,%rdi
  10084b:	41 ff 16             	callq  *(%r14)
        for (; len > 0; ++data, --len) {
  10084e:	49 83 c4 01          	add    $0x1,%r12
  100852:	49 39 dc             	cmp    %rbx,%r12
  100855:	75 e9                	jne    100840 <printer_vprintf+0x48e>
  100857:	48 8b 5d a8          	mov    -0x58(%rbp),%rbx
        for (; width > 0; --width) {
  10085b:	45 85 ed             	test   %r13d,%r13d
  10085e:	7e 14                	jle    100874 <printer_vprintf+0x4c2>
            p->putc(p, ' ', color);
  100860:	44 89 fa             	mov    %r15d,%edx
  100863:	be 20 00 00 00       	mov    $0x20,%esi
  100868:	4c 89 f7             	mov    %r14,%rdi
  10086b:	41 ff 16             	callq  *(%r14)
        for (; width > 0; --width) {
  10086e:	41 83 ed 01          	sub    $0x1,%r13d
  100872:	75 ec                	jne    100860 <printer_vprintf+0x4ae>
    for (; *format; ++format) {
  100874:	4c 8d 63 01          	lea    0x1(%rbx),%r12
  100878:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  10087c:	84 c0                	test   %al,%al
  10087e:	0f 84 fe 01 00 00    	je     100a82 <printer_vprintf+0x6d0>
        if (*format != '%') {
  100884:	3c 25                	cmp    $0x25,%al
  100886:	0f 84 54 fb ff ff    	je     1003e0 <printer_vprintf+0x2e>
            p->putc(p, *format, color);
  10088c:	0f b6 f0             	movzbl %al,%esi
  10088f:	44 89 fa             	mov    %r15d,%edx
  100892:	4c 89 f7             	mov    %r14,%rdi
  100895:	41 ff 16             	callq  *(%r14)
            continue;
  100898:	4c 89 e3             	mov    %r12,%rbx
  10089b:	eb d7                	jmp    100874 <printer_vprintf+0x4c2>
            data = va_arg(val, char*);
  10089d:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1008a1:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  1008a5:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1008a9:	48 89 47 08          	mov    %rax,0x8(%rdi)
  1008ad:	e9 51 fe ff ff       	jmpq   100703 <printer_vprintf+0x351>
            color = va_arg(val, int);
  1008b2:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  1008b6:	8b 07                	mov    (%rdi),%eax
  1008b8:	83 f8 2f             	cmp    $0x2f,%eax
  1008bb:	77 10                	ja     1008cd <printer_vprintf+0x51b>
  1008bd:	89 c2                	mov    %eax,%edx
  1008bf:	48 03 57 10          	add    0x10(%rdi),%rdx
  1008c3:	83 c0 08             	add    $0x8,%eax
  1008c6:	89 07                	mov    %eax,(%rdi)
  1008c8:	44 8b 3a             	mov    (%rdx),%r15d
            goto done;
  1008cb:	eb a7                	jmp    100874 <printer_vprintf+0x4c2>
            color = va_arg(val, int);
  1008cd:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1008d1:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  1008d5:	48 8d 42 08          	lea    0x8(%rdx),%rax
  1008d9:	48 89 41 08          	mov    %rax,0x8(%rcx)
  1008dd:	eb e9                	jmp    1008c8 <printer_vprintf+0x516>
            numbuf[0] = va_arg(val, int);
  1008df:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  1008e3:	8b 01                	mov    (%rcx),%eax
  1008e5:	83 f8 2f             	cmp    $0x2f,%eax
  1008e8:	77 23                	ja     10090d <printer_vprintf+0x55b>
  1008ea:	89 c2                	mov    %eax,%edx
  1008ec:	48 03 51 10          	add    0x10(%rcx),%rdx
  1008f0:	83 c0 08             	add    $0x8,%eax
  1008f3:	89 01                	mov    %eax,(%rcx)
  1008f5:	8b 02                	mov    (%rdx),%eax
  1008f7:	88 45 b8             	mov    %al,-0x48(%rbp)
            numbuf[1] = '\0';
  1008fa:	c6 45 b9 00          	movb   $0x0,-0x47(%rbp)
            data = numbuf;
  1008fe:	4c 8d 65 b8          	lea    -0x48(%rbp),%r12
        unsigned long num = 0;
  100902:	41 b8 00 00 00 00    	mov    $0x0,%r8d
            break;
  100908:	e9 ff fd ff ff       	jmpq   10070c <printer_vprintf+0x35a>
            numbuf[0] = va_arg(val, int);
  10090d:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  100911:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  100915:	48 8d 42 08          	lea    0x8(%rdx),%rax
  100919:	48 89 47 08          	mov    %rax,0x8(%rdi)
  10091d:	eb d6                	jmp    1008f5 <printer_vprintf+0x543>
            numbuf[0] = (*format ? *format : '%');
  10091f:	84 d2                	test   %dl,%dl
  100921:	0f 85 39 01 00 00    	jne    100a60 <printer_vprintf+0x6ae>
  100927:	c6 45 b8 25          	movb   $0x25,-0x48(%rbp)
            numbuf[1] = '\0';
  10092b:	c6 45 b9 00          	movb   $0x0,-0x47(%rbp)
                format--;
  10092f:	48 83 eb 01          	sub    $0x1,%rbx
            data = numbuf;
  100933:	4c 8d 65 b8          	lea    -0x48(%rbp),%r12
        unsigned long num = 0;
  100937:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  10093d:	e9 ca fd ff ff       	jmpq   10070c <printer_vprintf+0x35a>
        if (flags & FLAG_NUMERIC) {
  100942:	41 b9 0a 00 00 00    	mov    $0xa,%r9d
    const char* digits = upper_digits;
  100948:	bf 90 1a 10 00       	mov    $0x101a90,%edi
        if (flags & FLAG_NUMERIC) {
  10094d:	be 0a 00 00 00       	mov    $0xa,%esi
    *--numbuf_end = '\0';
  100952:	c6 45 cf 00          	movb   $0x0,-0x31(%rbp)
  100956:	4c 89 c1             	mov    %r8,%rcx
  100959:	4c 8d 65 cf          	lea    -0x31(%rbp),%r12
        *--numbuf_end = digits[val % base];
  10095d:	48 63 f6             	movslq %esi,%rsi
  100960:	49 83 ec 01          	sub    $0x1,%r12
  100964:	48 89 c8             	mov    %rcx,%rax
  100967:	ba 00 00 00 00       	mov    $0x0,%edx
  10096c:	48 f7 f6             	div    %rsi
  10096f:	0f b6 14 17          	movzbl (%rdi,%rdx,1),%edx
  100973:	41 88 14 24          	mov    %dl,(%r12)
        val /= base;
  100977:	48 89 ca             	mov    %rcx,%rdx
  10097a:	48 89 c1             	mov    %rax,%rcx
    } while (val != 0);
  10097d:	48 39 d6             	cmp    %rdx,%rsi
  100980:	76 de                	jbe    100960 <printer_vprintf+0x5ae>
  100982:	e9 9a fd ff ff       	jmpq   100721 <printer_vprintf+0x36f>
                prefix = "-";
  100987:	48 c7 45 a0 9f 18 10 	movq   $0x10189f,-0x60(%rbp)
  10098e:	00 
            if (flags & FLAG_NEGATIVE) {
  10098f:	8b 45 a8             	mov    -0x58(%rbp),%eax
  100992:	a8 80                	test   $0x80,%al
  100994:	0f 85 b0 fd ff ff    	jne    10074a <printer_vprintf+0x398>
                prefix = "+";
  10099a:	48 c7 45 a0 9a 18 10 	movq   $0x10189a,-0x60(%rbp)
  1009a1:	00 
            } else if (flags & FLAG_PLUSPOSITIVE) {
  1009a2:	a8 10                	test   $0x10,%al
  1009a4:	0f 85 a0 fd ff ff    	jne    10074a <printer_vprintf+0x398>
                prefix = " ";
  1009aa:	a8 08                	test   $0x8,%al
  1009ac:	ba cc 1a 10 00       	mov    $0x101acc,%edx
  1009b1:	b8 d3 1a 10 00       	mov    $0x101ad3,%eax
  1009b6:	48 0f 44 c2          	cmove  %rdx,%rax
  1009ba:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  1009be:	e9 87 fd ff ff       	jmpq   10074a <printer_vprintf+0x398>
                   && (base == 16 || base == -16)
  1009c3:	41 8d 41 10          	lea    0x10(%r9),%eax
  1009c7:	a9 df ff ff ff       	test   $0xffffffdf,%eax
  1009cc:	0f 85 78 fd ff ff    	jne    10074a <printer_vprintf+0x398>
                   && (num || (flags & FLAG_ALT2))) {
  1009d2:	4d 85 c0             	test   %r8,%r8
  1009d5:	75 0d                	jne    1009e4 <printer_vprintf+0x632>
  1009d7:	f7 45 a8 00 01 00 00 	testl  $0x100,-0x58(%rbp)
  1009de:	0f 84 66 fd ff ff    	je     10074a <printer_vprintf+0x398>
            prefix = (base == -16 ? "0x" : "0X");
  1009e4:	41 83 f9 f0          	cmp    $0xfffffff0,%r9d
  1009e8:	ba a1 18 10 00       	mov    $0x1018a1,%edx
  1009ed:	b8 9c 18 10 00       	mov    $0x10189c,%eax
  1009f2:	48 0f 44 c2          	cmove  %rdx,%rax
  1009f6:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  1009fa:	e9 4b fd ff ff       	jmpq   10074a <printer_vprintf+0x398>
            len = strlen(data);
  1009ff:	4c 89 e7             	mov    %r12,%rdi
  100a02:	e8 b5 f8 ff ff       	callq  1002bc <strlen>
  100a07:	89 45 98             	mov    %eax,-0x68(%rbp)
        if ((flags & FLAG_NUMERIC) && precision >= 0) {
  100a0a:	83 7d 8c 00          	cmpl   $0x0,-0x74(%rbp)
  100a0e:	0f 84 63 fd ff ff    	je     100777 <printer_vprintf+0x3c5>
  100a14:	80 7d 84 00          	cmpb   $0x0,-0x7c(%rbp)
  100a18:	0f 84 59 fd ff ff    	je     100777 <printer_vprintf+0x3c5>
            zeros = precision > len ? precision - len : 0;
  100a1e:	8b 4d 9c             	mov    -0x64(%rbp),%ecx
  100a21:	89 ca                	mov    %ecx,%edx
  100a23:	29 c2                	sub    %eax,%edx
  100a25:	39 c1                	cmp    %eax,%ecx
  100a27:	b8 00 00 00 00       	mov    $0x0,%eax
  100a2c:	0f 4e d0             	cmovle %eax,%edx
  100a2f:	89 55 9c             	mov    %edx,-0x64(%rbp)
  100a32:	e9 56 fd ff ff       	jmpq   10078d <printer_vprintf+0x3db>
                   && len + (int) strlen(prefix) < width) {
  100a37:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  100a3b:	e8 7c f8 ff ff       	callq  1002bc <strlen>
  100a40:	8b 7d 98             	mov    -0x68(%rbp),%edi
  100a43:	8d 14 07             	lea    (%rdi,%rax,1),%edx
            zeros = width - len - strlen(prefix);
  100a46:	44 89 e9             	mov    %r13d,%ecx
  100a49:	29 f9                	sub    %edi,%ecx
  100a4b:	29 c1                	sub    %eax,%ecx
  100a4d:	44 39 ea             	cmp    %r13d,%edx
  100a50:	b8 00 00 00 00       	mov    $0x0,%eax
  100a55:	0f 4d c8             	cmovge %eax,%ecx
  100a58:	89 4d 9c             	mov    %ecx,-0x64(%rbp)
  100a5b:	e9 2d fd ff ff       	jmpq   10078d <printer_vprintf+0x3db>
            numbuf[0] = (*format ? *format : '%');
  100a60:	88 55 b8             	mov    %dl,-0x48(%rbp)
            numbuf[1] = '\0';
  100a63:	c6 45 b9 00          	movb   $0x0,-0x47(%rbp)
            data = numbuf;
  100a67:	4c 8d 65 b8          	lea    -0x48(%rbp),%r12
        unsigned long num = 0;
  100a6b:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  100a71:	e9 96 fc ff ff       	jmpq   10070c <printer_vprintf+0x35a>
        int flags = 0;
  100a76:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%rbp)
  100a7d:	e9 b0 f9 ff ff       	jmpq   100432 <printer_vprintf+0x80>
}
  100a82:	48 83 c4 58          	add    $0x58,%rsp
  100a86:	5b                   	pop    %rbx
  100a87:	41 5c                	pop    %r12
  100a89:	41 5d                	pop    %r13
  100a8b:	41 5e                	pop    %r14
  100a8d:	41 5f                	pop    %r15
  100a8f:	5d                   	pop    %rbp
  100a90:	c3                   	retq   

0000000000100a91 <console_vprintf>:
int console_vprintf(int cpos, int color, const char* format, va_list val) {
  100a91:	55                   	push   %rbp
  100a92:	48 89 e5             	mov    %rsp,%rbp
  100a95:	48 83 ec 10          	sub    $0x10,%rsp
    cp.p.putc = console_putc;
  100a99:	48 c7 45 f0 9c 01 10 	movq   $0x10019c,-0x10(%rbp)
  100aa0:	00 
        cpos = 0;
  100aa1:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
  100aa7:	b8 00 00 00 00       	mov    $0x0,%eax
  100aac:	0f 43 f8             	cmovae %eax,%edi
    cp.cursor = console + cpos;
  100aaf:	48 63 ff             	movslq %edi,%rdi
  100ab2:	48 8d 84 3f 00 80 0b 	lea    0xb8000(%rdi,%rdi,1),%rax
  100ab9:	00 
  100aba:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    printer_vprintf(&cp.p, color, format, val);
  100abe:	48 8d 7d f0          	lea    -0x10(%rbp),%rdi
  100ac2:	e8 eb f8 ff ff       	callq  1003b2 <printer_vprintf>
    return cp.cursor - console;
  100ac7:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  100acb:	48 2d 00 80 0b 00    	sub    $0xb8000,%rax
  100ad1:	48 d1 f8             	sar    %rax
}
  100ad4:	c9                   	leaveq 
  100ad5:	c3                   	retq   

0000000000100ad6 <console_printf>:
int console_printf(int cpos, int color, const char* format, ...) {
  100ad6:	55                   	push   %rbp
  100ad7:	48 89 e5             	mov    %rsp,%rbp
  100ada:	48 83 ec 50          	sub    $0x50,%rsp
  100ade:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  100ae2:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  100ae6:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(val, format);
  100aea:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  100af1:	48 8d 45 10          	lea    0x10(%rbp),%rax
  100af5:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  100af9:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  100afd:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    cpos = console_vprintf(cpos, color, format, val);
  100b01:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  100b05:	e8 87 ff ff ff       	callq  100a91 <console_vprintf>
}
  100b0a:	c9                   	leaveq 
  100b0b:	c3                   	retq   

0000000000100b0c <vsnprintf>:

int vsnprintf(char* s, size_t size, const char* format, va_list val) {
  100b0c:	55                   	push   %rbp
  100b0d:	48 89 e5             	mov    %rsp,%rbp
  100b10:	53                   	push   %rbx
  100b11:	48 83 ec 28          	sub    $0x28,%rsp
  100b15:	48 89 fb             	mov    %rdi,%rbx
    string_printer sp;
    sp.p.putc = string_putc;
  100b18:	48 c7 45 d8 22 02 10 	movq   $0x100222,-0x28(%rbp)
  100b1f:	00 
    sp.s = s;
  100b20:	48 89 7d e0          	mov    %rdi,-0x20(%rbp)
    if (size) {
  100b24:	48 85 f6             	test   %rsi,%rsi
  100b27:	75 0b                	jne    100b34 <vsnprintf+0x28>
        sp.end = s + size - 1;
        printer_vprintf(&sp.p, 0, format, val);
        *sp.s = 0;
    }
    return sp.s - s;
  100b29:	8b 45 e0             	mov    -0x20(%rbp),%eax
  100b2c:	29 d8                	sub    %ebx,%eax
}
  100b2e:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  100b32:	c9                   	leaveq 
  100b33:	c3                   	retq   
        sp.end = s + size - 1;
  100b34:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  100b39:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
        printer_vprintf(&sp.p, 0, format, val);
  100b3d:	be 00 00 00 00       	mov    $0x0,%esi
  100b42:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  100b46:	e8 67 f8 ff ff       	callq  1003b2 <printer_vprintf>
        *sp.s = 0;
  100b4b:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  100b4f:	c6 00 00             	movb   $0x0,(%rax)
  100b52:	eb d5                	jmp    100b29 <vsnprintf+0x1d>

0000000000100b54 <snprintf>:

int snprintf(char* s, size_t size, const char* format, ...) {
  100b54:	55                   	push   %rbp
  100b55:	48 89 e5             	mov    %rsp,%rbp
  100b58:	48 83 ec 50          	sub    $0x50,%rsp
  100b5c:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  100b60:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  100b64:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list val;
    va_start(val, format);
  100b68:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  100b6f:	48 8d 45 10          	lea    0x10(%rbp),%rax
  100b73:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  100b77:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  100b7b:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int n = vsnprintf(s, size, format, val);
  100b7f:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  100b83:	e8 84 ff ff ff       	callq  100b0c <vsnprintf>
    va_end(val);
    return n;
}
  100b88:	c9                   	leaveq 
  100b89:	c3                   	retq   

0000000000100b8a <console_clear>:

// console_clear
//    Erases the console and moves the cursor to the upper left (CPOS(0, 0)).

void console_clear(void) {
    for (int i = 0; i < CONSOLE_ROWS * CONSOLE_COLUMNS; ++i) {
  100b8a:	b8 00 80 0b 00       	mov    $0xb8000,%eax
  100b8f:	ba a0 8f 0b 00       	mov    $0xb8fa0,%edx
        console[i] = ' ' | 0x0700;
  100b94:	66 c7 00 20 07       	movw   $0x720,(%rax)
    for (int i = 0; i < CONSOLE_ROWS * CONSOLE_COLUMNS; ++i) {
  100b99:	48 83 c0 02          	add    $0x2,%rax
  100b9d:	48 39 d0             	cmp    %rdx,%rax
  100ba0:	75 f2                	jne    100b94 <console_clear+0xa>
    }
    cursorpos = 0;
  100ba2:	c7 05 50 84 fb ff 00 	movl   $0x0,-0x47bb0(%rip)        # b8ffc <cursorpos>
  100ba9:	00 00 00 
}
  100bac:	c3                   	retq   

0000000000100bad <ptr_comparator>:
	    }
	}
    }
}
int ptr_comparator( const void * a, const void * b){
    return (uintptr_t)((ptr_with_size *) a)->ptr - (uintptr_t)((ptr_with_size *) b)->ptr;
  100bad:	48 8b 07             	mov    (%rdi),%rax
  100bb0:	2b 06                	sub    (%rsi),%eax
}
  100bb2:	c3                   	retq   

0000000000100bb3 <ptr_comparator_size_descending>:
int ptr_comparator_size_descending( const void * a, const void * b){
    return (size_t)((ptr_with_size *) b)->size - (size_t)((ptr_with_size *) a)->size;
  100bb3:	48 8b 46 08          	mov    0x8(%rsi),%rax
  100bb7:	2b 47 08             	sub    0x8(%rdi),%eax
}
  100bba:	c3                   	retq   

0000000000100bbb <_quicksort>:
{
  100bbb:	55                   	push   %rbp
  100bbc:	48 89 e5             	mov    %rsp,%rbp
  100bbf:	41 57                	push   %r15
  100bc1:	41 56                	push   %r14
  100bc3:	41 55                	push   %r13
  100bc5:	41 54                	push   %r12
  100bc7:	53                   	push   %rbx
  100bc8:	48 81 ec 48 04 00 00 	sub    $0x448,%rsp
  100bcf:	48 89 bd a0 fb ff ff 	mov    %rdi,-0x460(%rbp)
  100bd6:	48 89 b5 98 fb ff ff 	mov    %rsi,-0x468(%rbp)
  100bdd:	48 89 95 c8 fb ff ff 	mov    %rdx,-0x438(%rbp)
    if (total_elems == 0)
  100be4:	48 85 f6             	test   %rsi,%rsi
  100be7:	0f 84 94 03 00 00    	je     100f81 <_quicksort+0x3c6>
  100bed:	48 89 f0             	mov    %rsi,%rax
  100bf0:	48 89 cb             	mov    %rcx,%rbx
    const size_t max_thresh = MAX_THRESH * size;
  100bf3:	48 8d 0c 95 00 00 00 	lea    0x0(,%rdx,4),%rcx
  100bfa:	00 
  100bfb:	48 89 8d a8 fb ff ff 	mov    %rcx,-0x458(%rbp)
    if (total_elems > MAX_THRESH)
  100c02:	48 83 fe 04          	cmp    $0x4,%rsi
  100c06:	0f 86 bd 02 00 00    	jbe    100ec9 <_quicksort+0x30e>
	char *hi = &lo[size * (total_elems - 1)];
  100c0c:	48 83 e8 01          	sub    $0x1,%rax
  100c10:	48 0f af c2          	imul   %rdx,%rax
  100c14:	48 01 f8             	add    %rdi,%rax
  100c17:	48 89 85 c0 fb ff ff 	mov    %rax,-0x440(%rbp)
	PUSH (NULL, NULL);
  100c1e:	48 c7 85 d0 fb ff ff 	movq   $0x0,-0x430(%rbp)
  100c25:	00 00 00 00 
  100c29:	48 c7 85 d8 fb ff ff 	movq   $0x0,-0x428(%rbp)
  100c30:	00 00 00 00 
	char *lo = base_ptr;
  100c34:	48 89 bd b8 fb ff ff 	mov    %rdi,-0x448(%rbp)
	PUSH (NULL, NULL);
  100c3b:	48 8d 85 e0 fb ff ff 	lea    -0x420(%rbp),%rax
  100c42:	48 89 85 b0 fb ff ff 	mov    %rax,-0x450(%rbp)
	  right_ptr = hi - size;
  100c49:	48 f7 da             	neg    %rdx
  100c4c:	49 89 d7             	mov    %rdx,%r15
  100c4f:	e9 8c 01 00 00       	jmpq   100de0 <_quicksort+0x225>
  100c54:	48 8b 85 c8 fb ff ff 	mov    -0x438(%rbp),%rax
  100c5b:	49 8d 7c 05 00       	lea    0x0(%r13,%rax,1),%rdi
	    if ((*cmp) ((void *) mid, (void *) lo) < 0)
  100c60:	48 8b 95 b8 fb ff ff 	mov    -0x448(%rbp),%rdx
		SWAP (mid, lo, size);
  100c67:	4c 89 e8             	mov    %r13,%rax
  100c6a:	0f b6 08             	movzbl (%rax),%ecx
  100c6d:	48 83 c0 01          	add    $0x1,%rax
  100c71:	0f b6 32             	movzbl (%rdx),%esi
  100c74:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  100c78:	48 83 c2 01          	add    $0x1,%rdx
  100c7c:	88 4a ff             	mov    %cl,-0x1(%rdx)
  100c7f:	48 39 c7             	cmp    %rax,%rdi
  100c82:	75 e6                	jne    100c6a <_quicksort+0xaf>
  100c84:	e9 92 01 00 00       	jmpq   100e1b <_quicksort+0x260>
  100c89:	48 8b 85 c8 fb ff ff 	mov    -0x438(%rbp),%rax
  100c90:	4d 8d 64 05 00       	lea    0x0(%r13,%rax,1),%r12
	    if ((*cmp) ((void *) hi, (void *) mid) < 0)
  100c95:	48 8b 95 c0 fb ff ff 	mov    -0x440(%rbp),%rdx
		SWAP (mid, hi, size);
  100c9c:	4c 89 e8             	mov    %r13,%rax
  100c9f:	0f b6 08             	movzbl (%rax),%ecx
  100ca2:	48 83 c0 01          	add    $0x1,%rax
  100ca6:	0f b6 32             	movzbl (%rdx),%esi
  100ca9:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  100cad:	48 83 c2 01          	add    $0x1,%rdx
  100cb1:	88 4a ff             	mov    %cl,-0x1(%rdx)
  100cb4:	49 39 c4             	cmp    %rax,%r12
  100cb7:	75 e6                	jne    100c9f <_quicksort+0xe4>
	    if ((*cmp) ((void *) mid, (void *) lo) < 0)
  100cb9:	48 8b b5 b8 fb ff ff 	mov    -0x448(%rbp),%rsi
  100cc0:	4c 89 ef             	mov    %r13,%rdi
  100cc3:	ff d3                	callq  *%rbx
  100cc5:	85 c0                	test   %eax,%eax
  100cc7:	0f 89 62 01 00 00    	jns    100e2f <_quicksort+0x274>
  100ccd:	48 8b 95 b8 fb ff ff 	mov    -0x448(%rbp),%rdx
		SWAP (mid, lo, size);
  100cd4:	4c 89 e8             	mov    %r13,%rax
  100cd7:	0f b6 08             	movzbl (%rax),%ecx
  100cda:	48 83 c0 01          	add    $0x1,%rax
  100cde:	0f b6 32             	movzbl (%rdx),%esi
  100ce1:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  100ce5:	48 83 c2 01          	add    $0x1,%rdx
  100ce9:	88 4a ff             	mov    %cl,-0x1(%rdx)
  100cec:	49 39 c4             	cmp    %rax,%r12
  100cef:	75 e6                	jne    100cd7 <_quicksort+0x11c>
jump_over:;
  100cf1:	e9 39 01 00 00       	jmpq   100e2f <_quicksort+0x274>
		  right_ptr -= size;
  100cf6:	4d 01 fc             	add    %r15,%r12
	      while ((*cmp) ((void *) mid, (void *) right_ptr) < 0)
  100cf9:	4c 89 e6             	mov    %r12,%rsi
  100cfc:	4c 89 ef             	mov    %r13,%rdi
  100cff:	ff d3                	callq  *%rbx
  100d01:	85 c0                	test   %eax,%eax
  100d03:	78 f1                	js     100cf6 <_quicksort+0x13b>
	      if (left_ptr < right_ptr)
  100d05:	4d 39 e6             	cmp    %r12,%r14
  100d08:	72 1c                	jb     100d26 <_quicksort+0x16b>
	      else if (left_ptr == right_ptr)
  100d0a:	74 5e                	je     100d6a <_quicksort+0x1af>
	  while (left_ptr <= right_ptr);
  100d0c:	4d 39 e6             	cmp    %r12,%r14
  100d0f:	77 63                	ja     100d74 <_quicksort+0x1b9>
	      while ((*cmp) ((void *) left_ptr, (void *) mid) < 0)
  100d11:	4c 89 ee             	mov    %r13,%rsi
  100d14:	4c 89 f7             	mov    %r14,%rdi
  100d17:	ff d3                	callq  *%rbx
  100d19:	85 c0                	test   %eax,%eax
  100d1b:	79 dc                	jns    100cf9 <_quicksort+0x13e>
		  left_ptr += size;
  100d1d:	4c 03 b5 c8 fb ff ff 	add    -0x438(%rbp),%r14
  100d24:	eb eb                	jmp    100d11 <_quicksort+0x156>
  100d26:	48 8b 85 c8 fb ff ff 	mov    -0x438(%rbp),%rax
  100d2d:	49 8d 3c 06          	lea    (%r14,%rax,1),%rdi
	      if (left_ptr < right_ptr)
  100d31:	4c 89 e2             	mov    %r12,%rdx
  100d34:	4c 89 f0             	mov    %r14,%rax
		  SWAP (left_ptr, right_ptr, size);
  100d37:	0f b6 08             	movzbl (%rax),%ecx
  100d3a:	48 83 c0 01          	add    $0x1,%rax
  100d3e:	0f b6 32             	movzbl (%rdx),%esi
  100d41:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  100d45:	48 83 c2 01          	add    $0x1,%rdx
  100d49:	88 4a ff             	mov    %cl,-0x1(%rdx)
  100d4c:	48 39 f8             	cmp    %rdi,%rax
  100d4f:	75 e6                	jne    100d37 <_quicksort+0x17c>
		  if (mid == left_ptr)
  100d51:	4d 39 ee             	cmp    %r13,%r14
  100d54:	74 0f                	je     100d65 <_quicksort+0x1aa>
		  else if (mid == right_ptr)
  100d56:	4d 39 ec             	cmp    %r13,%r12
  100d59:	4d 0f 44 ee          	cmove  %r14,%r13
		  right_ptr -= size;
  100d5d:	4d 01 fc             	add    %r15,%r12
		  left_ptr += size;
  100d60:	49 89 fe             	mov    %rdi,%r14
  100d63:	eb a7                	jmp    100d0c <_quicksort+0x151>
  100d65:	4d 89 e5             	mov    %r12,%r13
  100d68:	eb f3                	jmp    100d5d <_quicksort+0x1a2>
		  left_ptr += size;
  100d6a:	4c 03 b5 c8 fb ff ff 	add    -0x438(%rbp),%r14
		  right_ptr -= size;
  100d71:	4d 01 fc             	add    %r15,%r12
	  if ((size_t) (right_ptr - lo) <= max_thresh)
  100d74:	4c 89 e0             	mov    %r12,%rax
  100d77:	48 2b 85 b8 fb ff ff 	sub    -0x448(%rbp),%rax
  100d7e:	48 8b bd a8 fb ff ff 	mov    -0x458(%rbp),%rdi
  100d85:	48 39 f8             	cmp    %rdi,%rax
  100d88:	0f 87 bf 00 00 00    	ja     100e4d <_quicksort+0x292>
	      if ((size_t) (hi - left_ptr) <= max_thresh)
  100d8e:	48 8b 85 c0 fb ff ff 	mov    -0x440(%rbp),%rax
  100d95:	4c 29 f0             	sub    %r14,%rax
		  lo = left_ptr;
  100d98:	4c 89 b5 b8 fb ff ff 	mov    %r14,-0x448(%rbp)
	      if ((size_t) (hi - left_ptr) <= max_thresh)
  100d9f:	48 39 f8             	cmp    %rdi,%rax
  100da2:	77 28                	ja     100dcc <_quicksort+0x211>
		  POP (lo, hi);
  100da4:	48 8b 85 b0 fb ff ff 	mov    -0x450(%rbp),%rax
  100dab:	48 8b 78 f0          	mov    -0x10(%rax),%rdi
  100daf:	48 89 bd b8 fb ff ff 	mov    %rdi,-0x448(%rbp)
  100db6:	48 8b 78 f8          	mov    -0x8(%rax),%rdi
  100dba:	48 89 bd c0 fb ff ff 	mov    %rdi,-0x440(%rbp)
  100dc1:	48 8d 40 f0          	lea    -0x10(%rax),%rax
  100dc5:	48 89 85 b0 fb ff ff 	mov    %rax,-0x450(%rbp)
	while (STACK_NOT_EMPTY)
  100dcc:	48 8d 85 d0 fb ff ff 	lea    -0x430(%rbp),%rax
  100dd3:	48 39 85 b0 fb ff ff 	cmp    %rax,-0x450(%rbp)
  100dda:	0f 86 e9 00 00 00    	jbe    100ec9 <_quicksort+0x30e>
	    char *mid = lo + size * ((hi - lo) / size >> 1);
  100de0:	48 8b 85 c0 fb ff ff 	mov    -0x440(%rbp),%rax
  100de7:	48 8b bd b8 fb ff ff 	mov    -0x448(%rbp),%rdi
  100dee:	48 29 f8             	sub    %rdi,%rax
  100df1:	48 8b 8d c8 fb ff ff 	mov    -0x438(%rbp),%rcx
  100df8:	ba 00 00 00 00       	mov    $0x0,%edx
  100dfd:	48 f7 f1             	div    %rcx
  100e00:	48 d1 e8             	shr    %rax
  100e03:	48 0f af c1          	imul   %rcx,%rax
  100e07:	4c 8d 2c 07          	lea    (%rdi,%rax,1),%r13
	    if ((*cmp) ((void *) mid, (void *) lo) < 0)
  100e0b:	48 89 fe             	mov    %rdi,%rsi
  100e0e:	4c 89 ef             	mov    %r13,%rdi
  100e11:	ff d3                	callq  *%rbx
  100e13:	85 c0                	test   %eax,%eax
  100e15:	0f 88 39 fe ff ff    	js     100c54 <_quicksort+0x99>
	    if ((*cmp) ((void *) hi, (void *) mid) < 0)
  100e1b:	4c 89 ee             	mov    %r13,%rsi
  100e1e:	48 8b bd c0 fb ff ff 	mov    -0x440(%rbp),%rdi
  100e25:	ff d3                	callq  *%rbx
  100e27:	85 c0                	test   %eax,%eax
  100e29:	0f 88 5a fe ff ff    	js     100c89 <_quicksort+0xce>
	  left_ptr  = lo + size;
  100e2f:	4c 8b b5 b8 fb ff ff 	mov    -0x448(%rbp),%r14
  100e36:	4c 03 b5 c8 fb ff ff 	add    -0x438(%rbp),%r14
	  right_ptr = hi - size;
  100e3d:	48 8b 85 c0 fb ff ff 	mov    -0x440(%rbp),%rax
  100e44:	4e 8d 24 38          	lea    (%rax,%r15,1),%r12
  100e48:	e9 c4 fe ff ff       	jmpq   100d11 <_quicksort+0x156>
	  else if ((size_t) (hi - left_ptr) <= max_thresh)
  100e4d:	48 8b 95 c0 fb ff ff 	mov    -0x440(%rbp),%rdx
  100e54:	4c 29 f2             	sub    %r14,%rdx
  100e57:	48 3b 95 a8 fb ff ff 	cmp    -0x458(%rbp),%rdx
  100e5e:	76 5d                	jbe    100ebd <_quicksort+0x302>
	  else if ((right_ptr - lo) > (hi - left_ptr))
  100e60:	48 39 d0             	cmp    %rdx,%rax
  100e63:	7e 2c                	jle    100e91 <_quicksort+0x2d6>
	      PUSH (lo, right_ptr);
  100e65:	48 8b 85 b0 fb ff ff 	mov    -0x450(%rbp),%rax
  100e6c:	48 8b bd b8 fb ff ff 	mov    -0x448(%rbp),%rdi
  100e73:	48 89 38             	mov    %rdi,(%rax)
  100e76:	4c 89 60 08          	mov    %r12,0x8(%rax)
  100e7a:	48 83 c0 10          	add    $0x10,%rax
  100e7e:	48 89 85 b0 fb ff ff 	mov    %rax,-0x450(%rbp)
	      lo = left_ptr;
  100e85:	4c 89 b5 b8 fb ff ff 	mov    %r14,-0x448(%rbp)
  100e8c:	e9 3b ff ff ff       	jmpq   100dcc <_quicksort+0x211>
	      PUSH (left_ptr, hi);
  100e91:	48 8b 85 b0 fb ff ff 	mov    -0x450(%rbp),%rax
  100e98:	4c 89 30             	mov    %r14,(%rax)
  100e9b:	48 8b bd c0 fb ff ff 	mov    -0x440(%rbp),%rdi
  100ea2:	48 89 78 08          	mov    %rdi,0x8(%rax)
  100ea6:	48 83 c0 10          	add    $0x10,%rax
  100eaa:	48 89 85 b0 fb ff ff 	mov    %rax,-0x450(%rbp)
	      hi = right_ptr;
  100eb1:	4c 89 a5 c0 fb ff ff 	mov    %r12,-0x440(%rbp)
  100eb8:	e9 0f ff ff ff       	jmpq   100dcc <_quicksort+0x211>
	      hi = right_ptr;
  100ebd:	4c 89 a5 c0 fb ff ff 	mov    %r12,-0x440(%rbp)
  100ec4:	e9 03 ff ff ff       	jmpq   100dcc <_quicksort+0x211>
	char *const end_ptr = &base_ptr[size * (total_elems - 1)];
  100ec9:	4c 8b bd 98 fb ff ff 	mov    -0x468(%rbp),%r15
  100ed0:	49 83 ef 01          	sub    $0x1,%r15
  100ed4:	48 8b bd c8 fb ff ff 	mov    -0x438(%rbp),%rdi
  100edb:	4c 0f af ff          	imul   %rdi,%r15
  100edf:	4c 8b ad a0 fb ff ff 	mov    -0x460(%rbp),%r13
  100ee6:	4d 01 ef             	add    %r13,%r15
	char *thresh = min(end_ptr, base_ptr + max_thresh);
  100ee9:	48 8b 85 a8 fb ff ff 	mov    -0x458(%rbp),%rax
  100ef0:	4c 01 e8             	add    %r13,%rax
  100ef3:	49 39 c7             	cmp    %rax,%r15
  100ef6:	49 0f 46 c7          	cmovbe %r15,%rax
	for (run_ptr = tmp_ptr + size; run_ptr <= thresh; run_ptr += size)
  100efa:	4d 89 ec             	mov    %r13,%r12
  100efd:	49 01 fc             	add    %rdi,%r12
  100f00:	4c 39 e0             	cmp    %r12,%rax
  100f03:	72 66                	jb     100f6b <_quicksort+0x3b0>
  100f05:	4d 89 e6             	mov    %r12,%r14
	char *tmp_ptr = base_ptr;
  100f08:	4c 89 a5 c0 fb ff ff 	mov    %r12,-0x440(%rbp)
  100f0f:	49 89 c4             	mov    %rax,%r12
	    if ((*cmp) ((void *) run_ptr, (void *) tmp_ptr) < 0)
  100f12:	4c 89 ee             	mov    %r13,%rsi
  100f15:	4c 89 f7             	mov    %r14,%rdi
  100f18:	ff d3                	callq  *%rbx
  100f1a:	85 c0                	test   %eax,%eax
  100f1c:	4d 0f 48 ee          	cmovs  %r14,%r13
	for (run_ptr = tmp_ptr + size; run_ptr <= thresh; run_ptr += size)
  100f20:	4c 03 b5 c8 fb ff ff 	add    -0x438(%rbp),%r14
  100f27:	4d 39 f4             	cmp    %r14,%r12
  100f2a:	73 e6                	jae    100f12 <_quicksort+0x357>
  100f2c:	4c 8b a5 c0 fb ff ff 	mov    -0x440(%rbp),%r12
	if (tmp_ptr != base_ptr)
  100f33:	48 8b 85 c8 fb ff ff 	mov    -0x438(%rbp),%rax
  100f3a:	49 8d 4c 05 00       	lea    0x0(%r13,%rax,1),%rcx
  100f3f:	48 8b 85 a0 fb ff ff 	mov    -0x460(%rbp),%rax
  100f46:	4c 3b ad a0 fb ff ff 	cmp    -0x460(%rbp),%r13
  100f4d:	74 1c                	je     100f6b <_quicksort+0x3b0>
	    SWAP (tmp_ptr, base_ptr, size);
  100f4f:	41 0f b6 55 00       	movzbl 0x0(%r13),%edx
  100f54:	49 83 c5 01          	add    $0x1,%r13
  100f58:	0f b6 30             	movzbl (%rax),%esi
  100f5b:	41 88 75 ff          	mov    %sil,-0x1(%r13)
  100f5f:	48 83 c0 01          	add    $0x1,%rax
  100f63:	88 50 ff             	mov    %dl,-0x1(%rax)
  100f66:	49 39 cd             	cmp    %rcx,%r13
  100f69:	75 e4                	jne    100f4f <_quicksort+0x394>
	while ((run_ptr += size) <= end_ptr)
  100f6b:	48 8b 85 c8 fb ff ff 	mov    -0x438(%rbp),%rax
  100f72:	4d 8d 34 04          	lea    (%r12,%rax,1),%r14
	    tmp_ptr = run_ptr - size;
  100f76:	48 f7 d8             	neg    %rax
  100f79:	49 89 c5             	mov    %rax,%r13
	while ((run_ptr += size) <= end_ptr)
  100f7c:	4d 39 f7             	cmp    %r14,%r15
  100f7f:	73 15                	jae    100f96 <_quicksort+0x3db>
}
  100f81:	48 81 c4 48 04 00 00 	add    $0x448,%rsp
  100f88:	5b                   	pop    %rbx
  100f89:	41 5c                	pop    %r12
  100f8b:	41 5d                	pop    %r13
  100f8d:	41 5e                	pop    %r14
  100f8f:	41 5f                	pop    %r15
  100f91:	5d                   	pop    %rbp
  100f92:	c3                   	retq   
		tmp_ptr -= size;
  100f93:	4d 01 ec             	add    %r13,%r12
	    while ((*cmp) ((void *) run_ptr, (void *) tmp_ptr) < 0)
  100f96:	4c 89 e6             	mov    %r12,%rsi
  100f99:	4c 89 f7             	mov    %r14,%rdi
  100f9c:	ff d3                	callq  *%rbx
  100f9e:	85 c0                	test   %eax,%eax
  100fa0:	78 f1                	js     100f93 <_quicksort+0x3d8>
	    tmp_ptr += size;
  100fa2:	48 8b 85 c8 fb ff ff 	mov    -0x438(%rbp),%rax
  100fa9:	49 8d 34 04          	lea    (%r12,%rax,1),%rsi
	    if (tmp_ptr != run_ptr)
  100fad:	4c 39 f6             	cmp    %r14,%rsi
  100fb0:	75 17                	jne    100fc9 <_quicksort+0x40e>
	while ((run_ptr += size) <= end_ptr)
  100fb2:	48 8b 85 c8 fb ff ff 	mov    -0x438(%rbp),%rax
  100fb9:	4c 01 f0             	add    %r14,%rax
  100fbc:	4d 89 f4             	mov    %r14,%r12
  100fbf:	49 39 c7             	cmp    %rax,%r15
  100fc2:	72 bd                	jb     100f81 <_quicksort+0x3c6>
  100fc4:	49 89 c6             	mov    %rax,%r14
	    while ((*cmp) ((void *) run_ptr, (void *) tmp_ptr) < 0)
  100fc7:	eb cd                	jmp    100f96 <_quicksort+0x3db>
		while (--trav >= run_ptr)
  100fc9:	49 8d 7c 06 ff       	lea    -0x1(%r14,%rax,1),%rdi
  100fce:	4c 39 f7             	cmp    %r14,%rdi
  100fd1:	72 df                	jb     100fb2 <_quicksort+0x3f7>
  100fd3:	4d 8d 46 ff          	lea    -0x1(%r14),%r8
  100fd7:	4d 89 c2             	mov    %r8,%r10
  100fda:	eb 13                	jmp    100fef <_quicksort+0x434>
		    for (hi = lo = trav; (lo -= size) >= tmp_ptr; hi = lo)
  100fdc:	48 89 f9             	mov    %rdi,%rcx
		    *hi = c;
  100fdf:	44 88 09             	mov    %r9b,(%rcx)
		while (--trav >= run_ptr)
  100fe2:	48 83 ef 01          	sub    $0x1,%rdi
  100fe6:	49 83 e8 01          	sub    $0x1,%r8
  100fea:	49 39 fa             	cmp    %rdi,%r10
  100fed:	74 c3                	je     100fb2 <_quicksort+0x3f7>
		    char c = *trav;
  100fef:	44 0f b6 0f          	movzbl (%rdi),%r9d
		    for (hi = lo = trav; (lo -= size) >= tmp_ptr; hi = lo)
  100ff3:	4c 89 c0             	mov    %r8,%rax
  100ff6:	4c 39 c6             	cmp    %r8,%rsi
  100ff9:	77 e1                	ja     100fdc <_quicksort+0x421>
  100ffb:	48 89 fa             	mov    %rdi,%rdx
			*hi = *lo;
  100ffe:	0f b6 08             	movzbl (%rax),%ecx
  101001:	88 0a                	mov    %cl,(%rdx)
		    for (hi = lo = trav; (lo -= size) >= tmp_ptr; hi = lo)
  101003:	48 89 c1             	mov    %rax,%rcx
  101006:	4c 01 e8             	add    %r13,%rax
  101009:	48 2b 95 c8 fb ff ff 	sub    -0x438(%rbp),%rdx
  101010:	48 39 c6             	cmp    %rax,%rsi
  101013:	76 e9                	jbe    100ffe <_quicksort+0x443>
  101015:	eb c8                	jmp    100fdf <_quicksort+0x424>

0000000000101017 <print_ptrs_with_size>:
void print_ptrs_with_size(ptr_with_size *ptrs_with_size, int end) {
  101017:	55                   	push   %rbp
  101018:	48 89 e5             	mov    %rsp,%rbp
  10101b:	41 55                	push   %r13
  10101d:	41 54                	push   %r12
  10101f:	53                   	push   %rbx
  101020:	48 83 ec 08          	sub    $0x8,%rsp
  101024:	49 89 fd             	mov    %rdi,%r13
  101027:	41 89 f4             	mov    %esi,%r12d

// mem_tog
// toggles kernels printing of memory space for process if pid is its processID
// if pid == 0, toggles state globally (preference to global over local)
static inline void mem_tog(pid_t p) {
    asm volatile ("int %0" : /* no result */
  10102a:	bf 00 00 00 00       	mov    $0x0,%edi
  10102f:	cd 38                	int    $0x38
    mem_tog(0);
    app_printf(1, "Start");
  101031:	be a7 1a 10 00       	mov    $0x101aa7,%esi
  101036:	bf 01 00 00 00       	mov    $0x1,%edi
  10103b:	b8 00 00 00 00       	mov    $0x0,%eax
  101040:	e8 67 06 00 00       	callq  1016ac <app_printf>
    for (int i = 0; i < end; i++) {
  101045:	45 85 e4             	test   %r12d,%r12d
  101048:	7e 35                	jle    10107f <print_ptrs_with_size+0x68>
  10104a:	4c 89 eb             	mov    %r13,%rbx
  10104d:	41 8d 44 24 ff       	lea    -0x1(%r12),%eax
  101052:	48 c1 e0 04          	shl    $0x4,%rax
  101056:	4d 8d 64 05 10       	lea    0x10(%r13,%rax,1),%r12
        app_printf(1, " %x-%x ", ptrs_with_size[i].ptr, ptrs_with_size[i].size);
  10105b:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  10105f:	48 8b 13             	mov    (%rbx),%rdx
  101062:	be ad 1a 10 00       	mov    $0x101aad,%esi
  101067:	bf 01 00 00 00       	mov    $0x1,%edi
  10106c:	b8 00 00 00 00       	mov    $0x0,%eax
  101071:	e8 36 06 00 00       	callq  1016ac <app_printf>
    for (int i = 0; i < end; i++) {
  101076:	48 83 c3 10          	add    $0x10,%rbx
  10107a:	4c 39 e3             	cmp    %r12,%rbx
  10107d:	75 dc                	jne    10105b <print_ptrs_with_size+0x44>
    }
    app_printf(1, "End");
  10107f:	be b5 1a 10 00       	mov    $0x101ab5,%esi
  101084:	bf 01 00 00 00       	mov    $0x1,%edi
  101089:	b8 00 00 00 00       	mov    $0x0,%eax
  10108e:	e8 19 06 00 00       	callq  1016ac <app_printf>
}
  101093:	48 83 c4 08          	add    $0x8,%rsp
  101097:	5b                   	pop    %rbx
  101098:	41 5c                	pop    %r12
  10109a:	41 5d                	pop    %r13
  10109c:	5d                   	pop    %rbp
  10109d:	c3                   	retq   

000000000010109e <append_free_list_node>:
alloc_header *alloc_list_head = NULL;
alloc_header *alloc_list_tail = NULL;
int alloc_list_length = 0;

void append_free_list_node(free_list_node *node) {
    node->next = NULL;
  10109e:	48 c7 47 08 00 00 00 	movq   $0x0,0x8(%rdi)
  1010a5:	00 
    node->prev = NULL;
  1010a6:	48 c7 07 00 00 00 00 	movq   $0x0,(%rdi)
    if (free_list_head == NULL && free_list_tail == NULL) {
  1010ad:	48 83 3d 93 0f 00 00 	cmpq   $0x0,0xf93(%rip)        # 102048 <free_list_head>
  1010b4:	00 
  1010b5:	74 1d                	je     1010d4 <append_free_list_node+0x36>
        free_list_head = node;
        free_list_tail = node;
    } else {
        free_list_tail->next = node;
  1010b7:	48 8b 05 82 0f 00 00 	mov    0xf82(%rip),%rax        # 102040 <free_list_tail>
  1010be:	48 89 78 08          	mov    %rdi,0x8(%rax)
        node->prev = free_list_tail;
  1010c2:	48 89 07             	mov    %rax,(%rdi)
        free_list_tail = node;
  1010c5:	48 89 3d 74 0f 00 00 	mov    %rdi,0xf74(%rip)        # 102040 <free_list_tail>
        free_list_tail = node;
    }
    free_list_length++;
  1010cc:	83 05 65 0f 00 00 01 	addl   $0x1,0xf65(%rip)        # 102038 <free_list_length>
}
  1010d3:	c3                   	retq   
    if (free_list_head == NULL && free_list_tail == NULL) {
  1010d4:	48 83 3d 64 0f 00 00 	cmpq   $0x0,0xf64(%rip)        # 102040 <free_list_tail>
  1010db:	00 
  1010dc:	75 d9                	jne    1010b7 <append_free_list_node+0x19>
        free_list_head = node;
  1010de:	48 89 3d 63 0f 00 00 	mov    %rdi,0xf63(%rip)        # 102048 <free_list_head>
        free_list_tail = node;
  1010e5:	eb de                	jmp    1010c5 <append_free_list_node+0x27>

00000000001010e7 <remove_free_list_node>:

void remove_free_list_node(free_list_node *node) {
    if (node == free_list_head) free_list_head = node->next;
  1010e7:	48 39 3d 5a 0f 00 00 	cmp    %rdi,0xf5a(%rip)        # 102048 <free_list_head>
  1010ee:	74 30                	je     101120 <remove_free_list_node+0x39>
    if (node == free_list_tail) free_list_tail = node->prev;
  1010f0:	48 39 3d 49 0f 00 00 	cmp    %rdi,0xf49(%rip)        # 102040 <free_list_tail>
  1010f7:	74 34                	je     10112d <remove_free_list_node+0x46>
    if (node->prev != NULL) node->prev->next = node->next;
  1010f9:	48 8b 07             	mov    (%rdi),%rax
  1010fc:	48 85 c0             	test   %rax,%rax
  1010ff:	74 08                	je     101109 <remove_free_list_node+0x22>
  101101:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  101105:	48 89 50 08          	mov    %rdx,0x8(%rax)
    if (node->next != NULL) node->next->prev = node->prev;
  101109:	48 8b 47 08          	mov    0x8(%rdi),%rax
  10110d:	48 85 c0             	test   %rax,%rax
  101110:	74 06                	je     101118 <remove_free_list_node+0x31>
  101112:	48 8b 17             	mov    (%rdi),%rdx
  101115:	48 89 10             	mov    %rdx,(%rax)
    free_list_length--;
  101118:	83 2d 19 0f 00 00 01 	subl   $0x1,0xf19(%rip)        # 102038 <free_list_length>
}
  10111f:	c3                   	retq   
    if (node == free_list_head) free_list_head = node->next;
  101120:	48 8b 47 08          	mov    0x8(%rdi),%rax
  101124:	48 89 05 1d 0f 00 00 	mov    %rax,0xf1d(%rip)        # 102048 <free_list_head>
  10112b:	eb c3                	jmp    1010f0 <remove_free_list_node+0x9>
    if (node == free_list_tail) free_list_tail = node->prev;
  10112d:	48 8b 07             	mov    (%rdi),%rax
  101130:	48 89 05 09 0f 00 00 	mov    %rax,0xf09(%rip)        # 102040 <free_list_tail>
  101137:	eb c0                	jmp    1010f9 <remove_free_list_node+0x12>

0000000000101139 <append_alloc_list_node>:

void append_alloc_list_node(alloc_header *header) {
    header->next = NULL;
  101139:	48 c7 47 08 00 00 00 	movq   $0x0,0x8(%rdi)
  101140:	00 
    header->prev = NULL;
  101141:	48 c7 07 00 00 00 00 	movq   $0x0,(%rdi)
    if (alloc_list_head == NULL && alloc_list_tail == NULL) {
  101148:	48 83 3d e0 0e 00 00 	cmpq   $0x0,0xee0(%rip)        # 102030 <alloc_list_head>
  10114f:	00 
  101150:	74 1d                	je     10116f <append_alloc_list_node+0x36>
        alloc_list_head = header;
        alloc_list_tail = header;
    } else {
        alloc_list_tail->next = header;
  101152:	48 8b 05 cf 0e 00 00 	mov    0xecf(%rip),%rax        # 102028 <alloc_list_tail>
  101159:	48 89 78 08          	mov    %rdi,0x8(%rax)
        header->prev = alloc_list_tail;
  10115d:	48 89 07             	mov    %rax,(%rdi)
        alloc_list_tail = header;
  101160:	48 89 3d c1 0e 00 00 	mov    %rdi,0xec1(%rip)        # 102028 <alloc_list_tail>
        alloc_list_tail = header;
    }
    alloc_list_length++;
  101167:	83 05 b2 0e 00 00 01 	addl   $0x1,0xeb2(%rip)        # 102020 <alloc_list_length>
}
  10116e:	c3                   	retq   
    if (alloc_list_head == NULL && alloc_list_tail == NULL) {
  10116f:	48 83 3d b1 0e 00 00 	cmpq   $0x0,0xeb1(%rip)        # 102028 <alloc_list_tail>
  101176:	00 
  101177:	75 d9                	jne    101152 <append_alloc_list_node+0x19>
        alloc_list_head = header;
  101179:	48 89 3d b0 0e 00 00 	mov    %rdi,0xeb0(%rip)        # 102030 <alloc_list_head>
        alloc_list_tail = header;
  101180:	eb de                	jmp    101160 <append_alloc_list_node+0x27>

0000000000101182 <remove_alloc_list_node>:

void remove_alloc_list_node(alloc_header *header) {
    if (header == alloc_list_head) alloc_list_head = header->next;
  101182:	48 39 3d a7 0e 00 00 	cmp    %rdi,0xea7(%rip)        # 102030 <alloc_list_head>
  101189:	74 30                	je     1011bb <remove_alloc_list_node+0x39>
    if (header == alloc_list_tail) alloc_list_tail = header->prev;
  10118b:	48 39 3d 96 0e 00 00 	cmp    %rdi,0xe96(%rip)        # 102028 <alloc_list_tail>
  101192:	74 34                	je     1011c8 <remove_alloc_list_node+0x46>
    if (header->prev != NULL) header->prev->next = header->next;
  101194:	48 8b 07             	mov    (%rdi),%rax
  101197:	48 85 c0             	test   %rax,%rax
  10119a:	74 08                	je     1011a4 <remove_alloc_list_node+0x22>
  10119c:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  1011a0:	48 89 50 08          	mov    %rdx,0x8(%rax)
    if (header->next != NULL) header->next->prev = header->prev;
  1011a4:	48 8b 47 08          	mov    0x8(%rdi),%rax
  1011a8:	48 85 c0             	test   %rax,%rax
  1011ab:	74 06                	je     1011b3 <remove_alloc_list_node+0x31>
  1011ad:	48 8b 17             	mov    (%rdi),%rdx
  1011b0:	48 89 10             	mov    %rdx,(%rax)
    alloc_list_length--;
  1011b3:	83 2d 66 0e 00 00 01 	subl   $0x1,0xe66(%rip)        # 102020 <alloc_list_length>
}
  1011ba:	c3                   	retq   
    if (header == alloc_list_head) alloc_list_head = header->next;
  1011bb:	48 8b 47 08          	mov    0x8(%rdi),%rax
  1011bf:	48 89 05 6a 0e 00 00 	mov    %rax,0xe6a(%rip)        # 102030 <alloc_list_head>
  1011c6:	eb c3                	jmp    10118b <remove_alloc_list_node+0x9>
    if (header == alloc_list_tail) alloc_list_tail = header->prev;
  1011c8:	48 8b 07             	mov    (%rdi),%rax
  1011cb:	48 89 05 56 0e 00 00 	mov    %rax,0xe56(%rip)        # 102028 <alloc_list_tail>
  1011d2:	eb c0                	jmp    101194 <remove_alloc_list_node+0x12>

00000000001011d4 <get_free_block>:

struct free_list_node *get_free_block(uint64_t payload_sz) {
    free_list_node *ptr = free_list_head;
  1011d4:	48 8b 05 6d 0e 00 00 	mov    0xe6d(%rip),%rax        # 102048 <free_list_head>
    free_list_node *insertion_block = NULL;
    while (ptr != NULL && insertion_block == NULL) {
  1011db:	48 85 c0             	test   %rax,%rax
  1011de:	74 15                	je     1011f5 <get_free_block+0x21>
        if (ptr->sz >= ALLOC_HEADER_SIZE + payload_sz) insertion_block = ptr;
  1011e0:	48 83 c7 18          	add    $0x18,%rdi
  1011e4:	eb 09                	jmp    1011ef <get_free_block+0x1b>
        ptr = ptr->next;
  1011e6:	48 8b 40 08          	mov    0x8(%rax),%rax
    while (ptr != NULL && insertion_block == NULL) {
  1011ea:	48 85 c0             	test   %rax,%rax
  1011ed:	74 06                	je     1011f5 <get_free_block+0x21>
        if (ptr->sz >= ALLOC_HEADER_SIZE + payload_sz) insertion_block = ptr;
  1011ef:	48 39 78 10          	cmp    %rdi,0x10(%rax)
  1011f3:	72 f1                	jb     1011e6 <get_free_block+0x12>
    }
    return insertion_block;
}
  1011f5:	c3                   	retq   

00000000001011f6 <extend_heap>:


struct free_list_node *extend_heap(size_t sz) {
  1011f6:	55                   	push   %rbp
  1011f7:	48 89 e5             	mov    %rsp,%rbp
  1011fa:	53                   	push   %rbx
  1011fb:	48 83 ec 08          	sub    $0x8,%rsp
    size_t heap_extension = ROUNDUP(sz, BREAK_INCREMENT);
  1011ff:	48 8d 97 ff 9f 00 00 	lea    0x9fff(%rdi),%rdx
  101206:	48 b9 cd cc cc cc cc 	movabs $0xcccccccccccccccd,%rcx
  10120d:	cc cc cc 
  101210:	48 89 d0             	mov    %rdx,%rax
  101213:	48 f7 e1             	mul    %rcx
  101216:	48 c1 ea 0f          	shr    $0xf,%rdx
  10121a:	48 8d 3c 92          	lea    (%rdx,%rdx,4),%rdi
  10121e:	48 c1 e7 0d          	shl    $0xd,%rdi
//     On success, sbrk() returns the previous program break
//     (If the break was increased, then this value is a pointer to the start of the newly allocated memory)
//      On error, (void *) -1 is returned
static inline void * sbrk(const intptr_t increment) {
    static void * result;
    asm volatile ("int %1" :  "=a" (result)
  101222:	cd 3a                	int    $0x3a
  101224:	48 89 05 25 0e 00 00 	mov    %rax,0xe25(%rip)        # 102050 <result.0>
    void *start = sbrk(heap_extension);
    if (start == (void *) -1) return NULL;
  10122b:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  10122f:	74 18                	je     101249 <extend_heap+0x53>
  101231:	48 89 c3             	mov    %rax,%rbx
    struct free_list_node *node = (struct free_list_node *) start;
    node->sz = heap_extension;
  101234:	48 89 78 10          	mov    %rdi,0x10(%rax)
    append_free_list_node(node);
  101238:	48 89 c7             	mov    %rax,%rdi
  10123b:	e8 5e fe ff ff       	callq  10109e <append_free_list_node>
    return node;
}
  101240:	48 89 d8             	mov    %rbx,%rax
  101243:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  101247:	c9                   	leaveq 
  101248:	c3                   	retq   
    if (start == (void *) -1) return NULL;
  101249:	bb 00 00 00 00       	mov    $0x0,%ebx
  10124e:	eb f0                	jmp    101240 <extend_heap+0x4a>

0000000000101250 <allocate_to_free_block>:

// returns address of the block (alloc_header) if allocated properly
// NULL if there was no space
uintptr_t allocate_to_free_block(uint64_t sz) {
  101250:	55                   	push   %rbp
  101251:	48 89 e5             	mov    %rsp,%rbp
  101254:	41 56                	push   %r14
  101256:	41 55                	push   %r13
  101258:	41 54                	push   %r12
  10125a:	53                   	push   %rbx
  10125b:	48 89 fb             	mov    %rdi,%rbx
    free_list_node *free_block = get_free_block(sz);
  10125e:	e8 71 ff ff ff       	callq  1011d4 <get_free_block>
    if (free_block == NULL) return (uintptr_t) -1;
  101263:	48 85 c0             	test   %rax,%rax
  101266:	74 54                	je     1012bc <allocate_to_free_block+0x6c>
  101268:	49 89 c4             	mov    %rax,%r12

    uintptr_t block_addr = (uintptr_t) free_block;
  10126b:	49 89 c6             	mov    %rax,%r14
    size_t block_size = free_block->sz;
  10126e:	4c 8b 68 10          	mov    0x10(%rax),%r13
    remove_free_list_node(free_block);
  101272:	48 89 c7             	mov    %rax,%rdi
  101275:	e8 6d fe ff ff       	callq  1010e7 <remove_free_list_node>

    struct alloc_header *header = (struct alloc_header *) block_addr;
    size_t payload_size = ROUNDUP(sz, ALIGNMENT);
  10127a:	48 83 c3 07          	add    $0x7,%rbx
  10127e:	48 83 e3 f8          	and    $0xfffffffffffffff8,%rbx
    size_t min_payload_size = FREE_LIST_NODE_SIZE - ALLOC_HEADER_SIZE;
    if (payload_size < min_payload_size) payload_size = min_payload_size;
    header->sz = payload_size;
  101282:	49 89 5c 24 10       	mov    %rbx,0x10(%r12)
    append_alloc_list_node(header);
  101287:	4c 89 e7             	mov    %r12,%rdi
  10128a:	e8 aa fe ff ff       	callq  101139 <append_alloc_list_node>

    size_t data_size = ALLOC_HEADER_SIZE + payload_size;
  10128f:	48 83 c3 18          	add    $0x18,%rbx
    size_t leftover = block_size - data_size;
  101293:	49 29 dd             	sub    %rbx,%r13

    if (leftover >= FREE_LIST_NODE_SIZE) {
  101296:	49 83 fd 17          	cmp    $0x17,%r13
  10129a:	77 11                	ja     1012ad <allocate_to_free_block+0x5d>
        struct free_list_node *node = (struct free_list_node *) (block_addr + data_size);
        node->sz = leftover;
        append_free_list_node(node);
    } else header->sz += leftover;
  10129c:	4d 01 6c 24 10       	add    %r13,0x10(%r12)

    return block_addr;
}
  1012a1:	4c 89 f0             	mov    %r14,%rax
  1012a4:	5b                   	pop    %rbx
  1012a5:	41 5c                	pop    %r12
  1012a7:	41 5d                	pop    %r13
  1012a9:	41 5e                	pop    %r14
  1012ab:	5d                   	pop    %rbp
  1012ac:	c3                   	retq   
        struct free_list_node *node = (struct free_list_node *) (block_addr + data_size);
  1012ad:	49 8d 3c 1c          	lea    (%r12,%rbx,1),%rdi
        node->sz = leftover;
  1012b1:	4c 89 6f 10          	mov    %r13,0x10(%rdi)
        append_free_list_node(node);
  1012b5:	e8 e4 fd ff ff       	callq  10109e <append_free_list_node>
  1012ba:	eb e5                	jmp    1012a1 <allocate_to_free_block+0x51>
    if (free_block == NULL) return (uintptr_t) -1;
  1012bc:	49 c7 c6 ff ff ff ff 	mov    $0xffffffffffffffff,%r14
  1012c3:	eb dc                	jmp    1012a1 <allocate_to_free_block+0x51>

00000000001012c5 <malloc>:
// allocates sz bytes of uninitialized memory and returns a pointer to the allocated memory
// if sz == 0, then malloc() either returns NULL or a unique pointer value that can be
// successfully passed to a later free
// the pointer should be aligned to 8 bytes
void *malloc(uint64_t sz) {
    if (sz == 0) return NULL;
  1012c5:	b8 00 00 00 00       	mov    $0x0,%eax
  1012ca:	48 85 ff             	test   %rdi,%rdi
  1012cd:	74 3c                	je     10130b <malloc+0x46>
void *malloc(uint64_t sz) {
  1012cf:	55                   	push   %rbp
  1012d0:	48 89 e5             	mov    %rsp,%rbp
  1012d3:	53                   	push   %rbx
  1012d4:	48 83 ec 08          	sub    $0x8,%rsp
  1012d8:	48 89 fb             	mov    %rdi,%rbx

    uintptr_t block_addr = allocate_to_free_block(sz);
  1012db:	e8 70 ff ff ff       	callq  101250 <allocate_to_free_block>
    while (block_addr == (uintptr_t) -1) {
  1012e0:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  1012e4:	75 1b                	jne    101301 <malloc+0x3c>
        if (extend_heap(sz) == NULL) return NULL;
  1012e6:	48 89 df             	mov    %rbx,%rdi
  1012e9:	e8 08 ff ff ff       	callq  1011f6 <extend_heap>
  1012ee:	48 85 c0             	test   %rax,%rax
  1012f1:	74 12                	je     101305 <malloc+0x40>
        block_addr = allocate_to_free_block(sz);
  1012f3:	48 89 df             	mov    %rbx,%rdi
  1012f6:	e8 55 ff ff ff       	callq  101250 <allocate_to_free_block>
    while (block_addr == (uintptr_t) -1) {
  1012fb:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  1012ff:	74 e5                	je     1012e6 <malloc+0x21>
    }

    return (void *) (block_addr + ALLOC_HEADER_SIZE);
  101301:	48 83 c0 18          	add    $0x18,%rax
}
  101305:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  101309:	c9                   	leaveq 
  10130a:	c3                   	retq   
  10130b:	c3                   	retq   

000000000010130c <overflow>:
// to the allocated array. The memory is set to 0. if num or sz is equal to 0, then calloc
// returns NULL or a unique pointer value that can be successfully passed to a later free
// calloc also checks for size overflow caused by num*sz
// returns NULL on failure
int overflow(uint64_t a, uint64_t b) {
    return a * b / a != b || a * b / b != a;
  10130c:	48 89 f9             	mov    %rdi,%rcx
  10130f:	48 0f af ce          	imul   %rsi,%rcx
  101313:	48 89 c8             	mov    %rcx,%rax
  101316:	ba 00 00 00 00       	mov    $0x0,%edx
  10131b:	48 f7 f7             	div    %rdi
  10131e:	ba 01 00 00 00       	mov    $0x1,%edx
  101323:	48 39 f0             	cmp    %rsi,%rax
  101326:	74 03                	je     10132b <overflow+0x1f>
}
  101328:	89 d0                	mov    %edx,%eax
  10132a:	c3                   	retq   
    return a * b / a != b || a * b / b != a;
  10132b:	48 89 c8             	mov    %rcx,%rax
  10132e:	ba 00 00 00 00       	mov    $0x0,%edx
  101333:	48 f7 f6             	div    %rsi
  101336:	48 39 f8             	cmp    %rdi,%rax
  101339:	0f 95 c2             	setne  %dl
  10133c:	0f b6 d2             	movzbl %dl,%edx
  10133f:	eb e7                	jmp    101328 <overflow+0x1c>

0000000000101341 <calloc>:

void *calloc(uint64_t num, uint64_t sz) {
  101341:	55                   	push   %rbp
  101342:	48 89 e5             	mov    %rsp,%rbp
  101345:	41 55                	push   %r13
  101347:	41 54                	push   %r12
  101349:	53                   	push   %rbx
  10134a:	48 83 ec 08          	sub    $0x8,%rsp
    if (num == 0 || sz == 0 || overflow(num, sz)) return NULL;
  10134e:	48 85 ff             	test   %rdi,%rdi
  101351:	74 54                	je     1013a7 <calloc+0x66>
  101353:	48 89 fb             	mov    %rdi,%rbx
  101356:	49 89 f4             	mov    %rsi,%r12
  101359:	48 85 f6             	test   %rsi,%rsi
  10135c:	74 49                	je     1013a7 <calloc+0x66>
  10135e:	e8 a9 ff ff ff       	callq  10130c <overflow>
  101363:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  101369:	85 c0                	test   %eax,%eax
  10136b:	75 2c                	jne    101399 <calloc+0x58>

    size_t size = ROUNDUP(num * sz, ALIGNMENT);
  10136d:	49 0f af dc          	imul   %r12,%rbx
  101371:	48 83 c3 07          	add    $0x7,%rbx
  101375:	48 83 e3 f8          	and    $0xfffffffffffffff8,%rbx
    void *malloc_addr = malloc(size);
  101379:	48 89 df             	mov    %rbx,%rdi
  10137c:	e8 44 ff ff ff       	callq  1012c5 <malloc>
  101381:	49 89 c5             	mov    %rax,%r13
    if (malloc_addr == NULL) return NULL;
  101384:	48 85 c0             	test   %rax,%rax
  101387:	74 10                	je     101399 <calloc+0x58>

    memset(malloc_addr, 0, size);
  101389:	48 89 da             	mov    %rbx,%rdx
  10138c:	be 00 00 00 00       	mov    $0x0,%esi
  101391:	48 89 c7             	mov    %rax,%rdi
  101394:	e8 08 ef ff ff       	callq  1002a1 <memset>
    return malloc_addr;
}
  101399:	4c 89 e8             	mov    %r13,%rax
  10139c:	48 83 c4 08          	add    $0x8,%rsp
  1013a0:	5b                   	pop    %rbx
  1013a1:	41 5c                	pop    %r12
  1013a3:	41 5d                	pop    %r13
  1013a5:	5d                   	pop    %rbp
  1013a6:	c3                   	retq   
    if (num == 0 || sz == 0 || overflow(num, sz)) return NULL;
  1013a7:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  1013ad:	eb ea                	jmp    101399 <calloc+0x58>

00000000001013af <free>:
// the free funtion frees the memory space pointed to by ptr, which must have been returned
// by a previous call to malloc or realloc, or if free has already been called before, then
// undefined behavior occurs
// if ptr == NULL, then no operation happens
void free(void *ptr) {
    if (ptr == NULL) return;
  1013af:	48 85 ff             	test   %rdi,%rdi
  1013b2:	74 2c                	je     1013e0 <free+0x31>
void free(void *ptr) {
  1013b4:	55                   	push   %rbp
  1013b5:	48 89 e5             	mov    %rsp,%rbp
  1013b8:	41 54                	push   %r12
  1013ba:	53                   	push   %rbx

    uintptr_t block_addr = (uintptr_t) ptr - ALLOC_HEADER_SIZE;
  1013bb:	48 8d 5f e8          	lea    -0x18(%rdi),%rbx
    struct alloc_header *header = (struct alloc_header *) block_addr;
    size_t block_size = ALLOC_HEADER_SIZE + header->sz;
  1013bf:	48 8b 47 f8          	mov    -0x8(%rdi),%rax
  1013c3:	4c 8d 60 18          	lea    0x18(%rax),%r12
    remove_alloc_list_node(header);
  1013c7:	48 89 df             	mov    %rbx,%rdi
  1013ca:	e8 b3 fd ff ff       	callq  101182 <remove_alloc_list_node>

    struct free_list_node *node = (struct free_list_node *) block_addr;
    node->sz = block_size;
  1013cf:	4c 89 63 10          	mov    %r12,0x10(%rbx)
    append_free_list_node(node);
  1013d3:	48 89 df             	mov    %rbx,%rdi
  1013d6:	e8 c3 fc ff ff       	callq  10109e <append_free_list_node>
    return;
}
  1013db:	5b                   	pop    %rbx
  1013dc:	41 5c                	pop    %r12
  1013de:	5d                   	pop    %rbp
  1013df:	c3                   	retq   
  1013e0:	c3                   	retq   

00000000001013e1 <realloc>:
void *realloc(void * ptr, uint64_t sz) {
  1013e1:	55                   	push   %rbp
  1013e2:	48 89 e5             	mov    %rsp,%rbp
  1013e5:	41 55                	push   %r13
  1013e7:	41 54                	push   %r12
  1013e9:	53                   	push   %rbx
  1013ea:	48 83 ec 08          	sub    $0x8,%rsp
  1013ee:	49 89 f4             	mov    %rsi,%r12
    if (ptr == NULL) return malloc(sz);
  1013f1:	48 85 ff             	test   %rdi,%rdi
  1013f4:	0f 84 21 01 00 00    	je     10151b <realloc+0x13a>
  1013fa:	48 89 fb             	mov    %rdi,%rbx
    if (sz == 0) { free(ptr); return NULL; }
  1013fd:	48 85 f6             	test   %rsi,%rsi
  101400:	0f 84 22 01 00 00    	je     101528 <realloc+0x147>
    if (original_sz == sz) return ptr;
  101406:	49 89 fd             	mov    %rdi,%r13
  101409:	48 3b 77 f8          	cmp    -0x8(%rdi),%rsi
  10140d:	0f 84 fa 00 00 00    	je     10150d <realloc+0x12c>
      ptr_with_size ptrs_with_size[alloc_list_length];
  101413:	8b 0d 07 0c 00 00    	mov    0xc07(%rip),%ecx        # 102020 <alloc_list_length>
  101419:	48 63 f9             	movslq %ecx,%rdi
  10141c:	48 89 f8             	mov    %rdi,%rax
  10141f:	48 c1 e0 04          	shl    $0x4,%rax
  101423:	48 29 c4             	sub    %rax,%rsp
  101426:	49 89 e5             	mov    %rsp,%r13
    alloc_header *curr = alloc_list_head;
  101429:	48 8b 15 00 0c 00 00 	mov    0xc00(%rip),%rdx        # 102030 <alloc_list_head>
    for (int i = 0; i < alloc_list_length; i++, curr = curr->next) {
  101430:	85 c9                	test   %ecx,%ecx
  101432:	7e 28                	jle    10145c <realloc+0x7b>
  101434:	4c 89 e8             	mov    %r13,%rax
  101437:	89 c9                	mov    %ecx,%ecx
  101439:	48 c1 e1 04          	shl    $0x4,%rcx
  10143d:	4c 01 e9             	add    %r13,%rcx
        ptrs_with_size[i].ptr = (void *) ((uintptr_t) curr + ALLOC_HEADER_SIZE);
  101440:	48 8d 72 18          	lea    0x18(%rdx),%rsi
  101444:	48 89 30             	mov    %rsi,(%rax)
        ptrs_with_size[i].size = curr->sz;
  101447:	48 8b 72 10          	mov    0x10(%rdx),%rsi
  10144b:	48 89 70 08          	mov    %rsi,0x8(%rax)
    for (int i = 0; i < alloc_list_length; i++, curr = curr->next) {
  10144f:	48 8b 52 08          	mov    0x8(%rdx),%rdx
  101453:	48 83 c0 10          	add    $0x10,%rax
  101457:	48 39 c8             	cmp    %rcx,%rax
  10145a:	75 e4                	jne    101440 <realloc+0x5f>
    _quicksort(ptrs_with_size, alloc_list_length, sizeof(ptrs_with_size[0]), &ptr_comparator);
  10145c:	b9 ad 0b 10 00       	mov    $0x100bad,%ecx
  101461:	ba 10 00 00 00       	mov    $0x10,%edx
  101466:	48 89 fe             	mov    %rdi,%rsi
  101469:	4c 89 ef             	mov    %r13,%rdi
  10146c:	e8 4a f7 ff ff       	callq  100bbb <_quicksort>
    for (int i = 0; i < alloc_list_length-1; i++) {
  101471:	8b 15 a9 0b 00 00    	mov    0xba9(%rip),%edx        # 102020 <alloc_list_length>
  101477:	83 fa 01             	cmp    $0x1,%edx
  10147a:	0f 8e b5 00 00 00    	jle    101535 <realloc+0x154>
  101480:	49 8d 45 08          	lea    0x8(%r13),%rax
  101484:	8d 52 fe             	lea    -0x2(%rdx),%edx
  101487:	48 c1 e2 04          	shl    $0x4,%rdx
  10148b:	49 8d 74 15 18       	lea    0x18(%r13,%rdx,1),%rsi
    int success = 0;
  101490:	ba 00 00 00 00       	mov    $0x0,%edx
        if ((uintptr_t) ptrs_with_size[i].size > (uintptr_t) ptrs_with_size[i+1].size) success = 1; 
  101495:	b9 01 00 00 00       	mov    $0x1,%ecx
  10149a:	48 8b 78 10          	mov    0x10(%rax),%rdi
  10149e:	48 39 38             	cmp    %rdi,(%rax)
  1014a1:	0f 47 d1             	cmova  %ecx,%edx
    for (int i = 0; i < alloc_list_length-1; i++) {
  1014a4:	48 83 c0 10          	add    $0x10,%rax
  1014a8:	48 39 f0             	cmp    %rsi,%rax
  1014ab:	75 ed                	jne    10149a <realloc+0xb9>
    asm volatile ("int %0" : /* no result */
  1014ad:	bf 00 00 00 00       	mov    $0x0,%edi
  1014b2:	cd 38                	int    $0x38
    app_printf(1, "Success: %s\n", success == 0 ? "Yes" : "No");
  1014b4:	85 d2                	test   %edx,%edx
  1014b6:	ba b9 1a 10 00       	mov    $0x101ab9,%edx
  1014bb:	b8 bd 1a 10 00       	mov    $0x101abd,%eax
  1014c0:	48 0f 45 d0          	cmovne %rax,%rdx
  1014c4:	be c0 1a 10 00       	mov    $0x101ac0,%esi
  1014c9:	bf 01 00 00 00       	mov    $0x1,%edi
  1014ce:	b8 00 00 00 00       	mov    $0x0,%eax
  1014d3:	e8 d4 01 00 00       	callq  1016ac <app_printf>
    print_ptrs_with_size(ptrs_with_size, alloc_list_length);
  1014d8:	8b 35 42 0b 00 00    	mov    0xb42(%rip),%esi        # 102020 <alloc_list_length>
  1014de:	4c 89 ef             	mov    %r13,%rdi
  1014e1:	e8 31 fb ff ff       	callq  101017 <print_ptrs_with_size>
    void *malloc_addr = malloc(sz);
  1014e6:	4c 89 e7             	mov    %r12,%rdi
  1014e9:	e8 d7 fd ff ff       	callq  1012c5 <malloc>
  1014ee:	49 89 c5             	mov    %rax,%r13
    if (malloc_addr == NULL) return NULL;
  1014f1:	48 85 c0             	test   %rax,%rax
  1014f4:	74 17                	je     10150d <realloc+0x12c>
    memcpy(malloc_addr, ptr, header->sz);
  1014f6:	48 8b 50 f8          	mov    -0x8(%rax),%rdx
  1014fa:	48 89 de             	mov    %rbx,%rsi
  1014fd:	48 89 c7             	mov    %rax,%rdi
  101500:	e8 33 ed ff ff       	callq  100238 <memcpy>
    free(ptr);
  101505:	48 89 df             	mov    %rbx,%rdi
  101508:	e8 a2 fe ff ff       	callq  1013af <free>
}
  10150d:	4c 89 e8             	mov    %r13,%rax
  101510:	48 8d 65 e8          	lea    -0x18(%rbp),%rsp
  101514:	5b                   	pop    %rbx
  101515:	41 5c                	pop    %r12
  101517:	41 5d                	pop    %r13
  101519:	5d                   	pop    %rbp
  10151a:	c3                   	retq   
    if (ptr == NULL) return malloc(sz);
  10151b:	48 89 f7             	mov    %rsi,%rdi
  10151e:	e8 a2 fd ff ff       	callq  1012c5 <malloc>
  101523:	49 89 c5             	mov    %rax,%r13
  101526:	eb e5                	jmp    10150d <realloc+0x12c>
    if (sz == 0) { free(ptr); return NULL; }
  101528:	e8 82 fe ff ff       	callq  1013af <free>
  10152d:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  101533:	eb d8                	jmp    10150d <realloc+0x12c>
    int success = 0;
  101535:	ba 00 00 00 00       	mov    $0x0,%edx
  10153a:	e9 6e ff ff ff       	jmpq   1014ad <realloc+0xcc>

000000000010153f <adjacent>:

int adjacent(ptr_with_size *ptrs_with_size, int i, int j) {
    ptr_with_size a = ptrs_with_size[i];
  10153f:	48 63 f6             	movslq %esi,%rsi
  101542:	48 c1 e6 04          	shl    $0x4,%rsi
  101546:	48 01 fe             	add    %rdi,%rsi
    ptr_with_size b = ptrs_with_size[j];
    return (uintptr_t) a.ptr + a.size == (uintptr_t) b.ptr;
  101549:	48 8b 46 08          	mov    0x8(%rsi),%rax
  10154d:	48 03 06             	add    (%rsi),%rax
    ptr_with_size b = ptrs_with_size[j];
  101550:	48 63 d2             	movslq %edx,%rdx
  101553:	48 c1 e2 04          	shl    $0x4,%rdx
    return (uintptr_t) a.ptr + a.size == (uintptr_t) b.ptr;
  101557:	48 39 04 17          	cmp    %rax,(%rdi,%rdx,1)
  10155b:	0f 94 c0             	sete   %al
  10155e:	0f b6 c0             	movzbl %al,%eax
}
  101561:	c3                   	retq   

0000000000101562 <coalesce>:

void coalesce(ptr_with_size *ptrs_with_size, int i, int j) {
  101562:	55                   	push   %rbp
  101563:	48 89 e5             	mov    %rsp,%rbp
    struct free_list_node *node_a = (struct free_list_node *) ptrs_with_size[i].ptr;
  101566:	48 63 f6             	movslq %esi,%rsi
  101569:	48 c1 e6 04          	shl    $0x4,%rsi
  10156d:	48 8b 04 37          	mov    (%rdi,%rsi,1),%rax
    struct free_list_node *node_b = (struct free_list_node *) ptrs_with_size[j].ptr;
  101571:	48 63 d2             	movslq %edx,%rdx
  101574:	48 c1 e2 04          	shl    $0x4,%rdx
  101578:	48 8b 3c 17          	mov    (%rdi,%rdx,1),%rdi
    node_a->sz += node_b->sz;
  10157c:	48 8b 57 10          	mov    0x10(%rdi),%rdx
  101580:	48 01 50 10          	add    %rdx,0x10(%rax)
    remove_free_list_node(node_b);
  101584:	e8 5e fb ff ff       	callq  1010e7 <remove_free_list_node>
}
  101589:	5d                   	pop    %rbp
  10158a:	c3                   	retq   

000000000010158b <defrag>:

void defrag() {
  10158b:	55                   	push   %rbp
  10158c:	48 89 e5             	mov    %rsp,%rbp
  10158f:	41 55                	push   %r13
  101591:	41 54                	push   %r12
  101593:	53                   	push   %rbx
  101594:	48 83 ec 08          	sub    $0x8,%rsp
    ptr_with_size ptrs_with_size[free_list_length];
  101598:	8b 0d 9a 0a 00 00    	mov    0xa9a(%rip),%ecx        # 102038 <free_list_length>
  10159e:	48 63 f1             	movslq %ecx,%rsi
  1015a1:	48 89 f0             	mov    %rsi,%rax
  1015a4:	48 c1 e0 04          	shl    $0x4,%rax
  1015a8:	48 29 c4             	sub    %rax,%rsp
  1015ab:	49 89 e5             	mov    %rsp,%r13
    free_list_node *curr = free_list_head;
  1015ae:	48 8b 15 93 0a 00 00 	mov    0xa93(%rip),%rdx        # 102048 <free_list_head>
    for (int i = 0; i < free_list_length; i++, curr = curr->next) {
  1015b5:	85 c9                	test   %ecx,%ecx
  1015b7:	7e 24                	jle    1015dd <defrag+0x52>
  1015b9:	4c 89 e8             	mov    %r13,%rax
  1015bc:	89 c9                	mov    %ecx,%ecx
  1015be:	48 c1 e1 04          	shl    $0x4,%rcx
  1015c2:	4c 01 e9             	add    %r13,%rcx
        ptrs_with_size[i].ptr = curr;
  1015c5:	48 89 10             	mov    %rdx,(%rax)
        ptrs_with_size[i].size = curr->sz;
  1015c8:	48 8b 7a 10          	mov    0x10(%rdx),%rdi
  1015cc:	48 89 78 08          	mov    %rdi,0x8(%rax)
    for (int i = 0; i < free_list_length; i++, curr = curr->next) {
  1015d0:	48 8b 52 08          	mov    0x8(%rdx),%rdx
  1015d4:	48 83 c0 10          	add    $0x10,%rax
  1015d8:	48 39 c8             	cmp    %rcx,%rax
  1015db:	75 e8                	jne    1015c5 <defrag+0x3a>
    }
    _quicksort(ptrs_with_size, free_list_length, sizeof(ptrs_with_size[0]), &ptr_comparator);
  1015dd:	b9 ad 0b 10 00       	mov    $0x100bad,%ecx
  1015e2:	ba 10 00 00 00       	mov    $0x10,%edx
  1015e7:	4c 89 ef             	mov    %r13,%rdi
  1015ea:	e8 cc f5 ff ff       	callq  100bbb <_quicksort>

    int i = 0, j = 1;
    for (; j < free_list_length; j++) {
  1015ef:	83 3d 42 0a 00 00 01 	cmpl   $0x1,0xa42(%rip)        # 102038 <free_list_length>
  1015f6:	7e 3b                	jle    101633 <defrag+0xa8>
    int i = 0, j = 1;
  1015f8:	bb 01 00 00 00       	mov    $0x1,%ebx
  1015fd:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  101603:	eb 18                	jmp    10161d <defrag+0x92>
        if (adjacent(ptrs_with_size, i, j)) coalesce(ptrs_with_size, i, j);
  101605:	89 da                	mov    %ebx,%edx
  101607:	44 89 e6             	mov    %r12d,%esi
  10160a:	4c 89 ef             	mov    %r13,%rdi
  10160d:	e8 50 ff ff ff       	callq  101562 <coalesce>
    for (; j < free_list_length; j++) {
  101612:	83 c3 01             	add    $0x1,%ebx
  101615:	39 1d 1d 0a 00 00    	cmp    %ebx,0xa1d(%rip)        # 102038 <free_list_length>
  10161b:	7e 16                	jle    101633 <defrag+0xa8>
        if (adjacent(ptrs_with_size, i, j)) coalesce(ptrs_with_size, i, j);
  10161d:	89 da                	mov    %ebx,%edx
  10161f:	44 89 e6             	mov    %r12d,%esi
  101622:	4c 89 ef             	mov    %r13,%rdi
  101625:	e8 15 ff ff ff       	callq  10153f <adjacent>
  10162a:	85 c0                	test   %eax,%eax
  10162c:	75 d7                	jne    101605 <defrag+0x7a>
  10162e:	41 89 dc             	mov    %ebx,%r12d
  101631:	eb df                	jmp    101612 <defrag+0x87>
        else i = j;
    }
}
  101633:	48 8d 65 e8          	lea    -0x18(%rbp),%rsp
  101637:	5b                   	pop    %rbx
  101638:	41 5c                	pop    %r12
  10163a:	41 5d                	pop    %r13
  10163c:	5d                   	pop    %rbp
  10163d:	c3                   	retq   

000000000010163e <heap_info>:
// and should NOT be included in the heap info
// return 0 for a successfull call
// if for any reason the information cannot be saved, return -1


int heap_info(heap_info_struct * info) {
  10163e:	55                   	push   %rbp
  10163f:	48 89 e5             	mov    %rsp,%rbp
    // alloc_list_length
    info->num_allocs = alloc_list_length;
  101642:	8b 05 d8 09 00 00    	mov    0x9d8(%rip),%eax        # 102020 <alloc_list_length>
  101648:	89 07                	mov    %eax,(%rdi)

    // size array
      ptr_with_size ptrs_with_size[alloc_list_length];
  10164a:	8b 0d d0 09 00 00    	mov    0x9d0(%rip),%ecx        # 102020 <alloc_list_length>
  101650:	4c 63 c1             	movslq %ecx,%r8
  101653:	4c 89 c0             	mov    %r8,%rax
  101656:	48 c1 e0 04          	shl    $0x4,%rax
  10165a:	48 29 c4             	sub    %rax,%rsp
  10165d:	48 89 e7             	mov    %rsp,%rdi
    alloc_header *curr = alloc_list_head;
  101660:	48 8b 15 c9 09 00 00 	mov    0x9c9(%rip),%rdx        # 102030 <alloc_list_head>
    for (int i = 0; i < alloc_list_length; i++, curr = curr->next) {
  101667:	85 c9                	test   %ecx,%ecx
  101669:	7e 28                	jle    101693 <heap_info+0x55>
  10166b:	48 89 f8             	mov    %rdi,%rax
  10166e:	89 c9                	mov    %ecx,%ecx
  101670:	48 c1 e1 04          	shl    $0x4,%rcx
  101674:	48 01 f9             	add    %rdi,%rcx
        ptrs_with_size[i].ptr = (void *) ((uintptr_t) curr + ALLOC_HEADER_SIZE);
  101677:	48 8d 72 18          	lea    0x18(%rdx),%rsi
  10167b:	48 89 30             	mov    %rsi,(%rax)
        ptrs_with_size[i].size = curr->sz;
  10167e:	48 8b 72 10          	mov    0x10(%rdx),%rsi
  101682:	48 89 70 08          	mov    %rsi,0x8(%rax)
    for (int i = 0; i < alloc_list_length; i++, curr = curr->next) {
  101686:	48 8b 52 08          	mov    0x8(%rdx),%rdx
  10168a:	48 83 c0 10          	add    $0x10,%rax
  10168e:	48 39 c8             	cmp    %rcx,%rax
  101691:	75 e4                	jne    101677 <heap_info+0x39>
    }
    _quicksort(ptrs_with_size, alloc_list_length, sizeof(ptrs_with_size[0]), &ptr_comparator_size_descending);
  101693:	b9 b3 0b 10 00       	mov    $0x100bb3,%ecx
  101698:	ba 10 00 00 00       	mov    $0x10,%edx
  10169d:	4c 89 c6             	mov    %r8,%rsi
  1016a0:	e8 16 f5 ff ff       	callq  100bbb <_quicksort>
    
    return 0;
  1016a5:	b8 00 00 00 00       	mov    $0x0,%eax
  1016aa:	c9                   	leaveq 
  1016ab:	c3                   	retq   

00000000001016ac <app_printf>:
#include "process.h"

// app_printf
//     A version of console_printf that picks a sensible color by process ID.

void app_printf(int colorid, const char* format, ...) {
  1016ac:	55                   	push   %rbp
  1016ad:	48 89 e5             	mov    %rsp,%rbp
  1016b0:	48 83 ec 50          	sub    $0x50,%rsp
  1016b4:	49 89 f2             	mov    %rsi,%r10
  1016b7:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  1016bb:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  1016bf:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  1016c3:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    int color;
    if (colorid < 0) {
        color = 0x0700;
  1016c7:	be 00 07 00 00       	mov    $0x700,%esi
    if (colorid < 0) {
  1016cc:	85 ff                	test   %edi,%edi
  1016ce:	78 2e                	js     1016fe <app_printf+0x52>
    } else {
        static const uint8_t col[] = { 0x0E, 0x0F, 0x0C, 0x0A, 0x09 };
        color = col[colorid % sizeof(col)] << 8;
  1016d0:	48 63 ff             	movslq %edi,%rdi
  1016d3:	48 ba cd cc cc cc cc 	movabs $0xcccccccccccccccd,%rdx
  1016da:	cc cc cc 
  1016dd:	48 89 f8             	mov    %rdi,%rax
  1016e0:	48 f7 e2             	mul    %rdx
  1016e3:	48 89 d0             	mov    %rdx,%rax
  1016e6:	48 c1 e8 02          	shr    $0x2,%rax
  1016ea:	48 83 e2 fc          	and    $0xfffffffffffffffc,%rdx
  1016ee:	48 01 c2             	add    %rax,%rdx
  1016f1:	48 29 d7             	sub    %rdx,%rdi
  1016f4:	0f b6 b7 fd 1a 10 00 	movzbl 0x101afd(%rdi),%esi
  1016fb:	c1 e6 08             	shl    $0x8,%esi
    }

    va_list val;
    va_start(val, format);
  1016fe:	c7 45 b8 10 00 00 00 	movl   $0x10,-0x48(%rbp)
  101705:	48 8d 45 10          	lea    0x10(%rbp),%rax
  101709:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  10170d:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  101711:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    cursorpos = console_vprintf(cursorpos, color, format, val);
  101715:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  101719:	4c 89 d2             	mov    %r10,%rdx
  10171c:	8b 3d da 78 fb ff    	mov    -0x48726(%rip),%edi        # b8ffc <cursorpos>
  101722:	e8 6a f3 ff ff       	callq  100a91 <console_vprintf>
    va_end(val);

    if (CROW(cursorpos) >= 23) {
        cursorpos = CPOS(0, 0);
  101727:	3d 30 07 00 00       	cmp    $0x730,%eax
  10172c:	ba 00 00 00 00       	mov    $0x0,%edx
  101731:	0f 4d c2             	cmovge %edx,%eax
  101734:	89 05 c2 78 fb ff    	mov    %eax,-0x4873e(%rip)        # b8ffc <cursorpos>
    }
}
  10173a:	c9                   	leaveq 
  10173b:	c3                   	retq   

000000000010173c <kernel_panic>:


// kernel_panic, assert_fail
//     Call the INT_SYS_PANIC system call so the kernel loops until Control-C.

void kernel_panic(const char* format, ...) {
  10173c:	55                   	push   %rbp
  10173d:	48 89 e5             	mov    %rsp,%rbp
  101740:	53                   	push   %rbx
  101741:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  101748:	48 89 fb             	mov    %rdi,%rbx
  10174b:	48 89 75 c8          	mov    %rsi,-0x38(%rbp)
  10174f:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  101753:	48 89 4d d8          	mov    %rcx,-0x28(%rbp)
  101757:	4c 89 45 e0          	mov    %r8,-0x20(%rbp)
  10175b:	4c 89 4d e8          	mov    %r9,-0x18(%rbp)
    va_list val;
    va_start(val, format);
  10175f:	c7 45 a8 08 00 00 00 	movl   $0x8,-0x58(%rbp)
  101766:	48 8d 45 10          	lea    0x10(%rbp),%rax
  10176a:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  10176e:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
  101772:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
    char buf[160];
    memcpy(buf, "PANIC: ", 7);
  101776:	ba 07 00 00 00       	mov    $0x7,%edx
  10177b:	be cd 1a 10 00       	mov    $0x101acd,%esi
  101780:	48 8d bd 08 ff ff ff 	lea    -0xf8(%rbp),%rdi
  101787:	e8 ac ea ff ff       	callq  100238 <memcpy>
    int len = vsnprintf(&buf[7], sizeof(buf) - 7, format, val) + 7;
  10178c:	48 8d 4d a8          	lea    -0x58(%rbp),%rcx
  101790:	48 89 da             	mov    %rbx,%rdx
  101793:	be 99 00 00 00       	mov    $0x99,%esi
  101798:	48 8d bd 0f ff ff ff 	lea    -0xf1(%rbp),%rdi
  10179f:	e8 68 f3 ff ff       	callq  100b0c <vsnprintf>
  1017a4:	8d 50 07             	lea    0x7(%rax),%edx
    va_end(val);
    if (len > 0 && buf[len - 1] != '\n') {
  1017a7:	85 d2                	test   %edx,%edx
  1017a9:	7e 0f                	jle    1017ba <kernel_panic+0x7e>
  1017ab:	83 c0 06             	add    $0x6,%eax
  1017ae:	48 98                	cltq   
  1017b0:	80 bc 05 08 ff ff ff 	cmpb   $0xa,-0xf8(%rbp,%rax,1)
  1017b7:	0a 
  1017b8:	75 2a                	jne    1017e4 <kernel_panic+0xa8>
        strcpy(buf + len - (len == (int) sizeof(buf) - 1), "\n");
    }
    (void) console_printf(CPOS(23, 0), 0xC000, "%s", buf);
  1017ba:	48 8d 9d 08 ff ff ff 	lea    -0xf8(%rbp),%rbx
  1017c1:	48 89 d9             	mov    %rbx,%rcx
  1017c4:	ba d5 1a 10 00       	mov    $0x101ad5,%edx
  1017c9:	be 00 c0 00 00       	mov    $0xc000,%esi
  1017ce:	bf 30 07 00 00       	mov    $0x730,%edi
  1017d3:	b8 00 00 00 00       	mov    $0x0,%eax
  1017d8:	e8 f9 f2 ff ff       	callq  100ad6 <console_printf>
    asm volatile ("int %0" : /* no result */
  1017dd:	48 89 df             	mov    %rbx,%rdi
  1017e0:	cd 30                	int    $0x30
 loop: goto loop;
  1017e2:	eb fe                	jmp    1017e2 <kernel_panic+0xa6>
        strcpy(buf + len - (len == (int) sizeof(buf) - 1), "\n");
  1017e4:	48 63 c2             	movslq %edx,%rax
  1017e7:	81 fa 9f 00 00 00    	cmp    $0x9f,%edx
  1017ed:	0f 94 c2             	sete   %dl
  1017f0:	0f b6 d2             	movzbl %dl,%edx
  1017f3:	48 29 d0             	sub    %rdx,%rax
  1017f6:	48 8d bc 05 08 ff ff 	lea    -0xf8(%rbp,%rax,1),%rdi
  1017fd:	ff 
  1017fe:	be cb 1a 10 00       	mov    $0x101acb,%esi
  101803:	e8 f2 ea ff ff       	callq  1002fa <strcpy>
  101808:	eb b0                	jmp    1017ba <kernel_panic+0x7e>

000000000010180a <assert_fail>:
    panic(buf);
 spinloop: goto spinloop;       // should never get here
}

void assert_fail(const char* file, int line, const char* msg) {
  10180a:	55                   	push   %rbp
  10180b:	48 89 e5             	mov    %rsp,%rbp
  10180e:	48 89 f9             	mov    %rdi,%rcx
  101811:	41 89 f0             	mov    %esi,%r8d
  101814:	49 89 d1             	mov    %rdx,%r9
    (void) console_printf(CPOS(23, 0), 0xC000,
  101817:	ba d8 1a 10 00       	mov    $0x101ad8,%edx
  10181c:	be 00 c0 00 00       	mov    $0xc000,%esi
  101821:	bf 30 07 00 00       	mov    $0x730,%edi
  101826:	b8 00 00 00 00       	mov    $0x0,%eax
  10182b:	e8 a6 f2 ff ff       	callq  100ad6 <console_printf>
    asm volatile ("int %0" : /* no result */
  101830:	bf 00 00 00 00       	mov    $0x0,%edi
  101835:	cd 30                	int    $0x30
 loop: goto loop;
  101837:	eb fe                	jmp    101837 <assert_fail+0x2d>
