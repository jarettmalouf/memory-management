
obj/p-test.full:     file format elf64-x86-64


Disassembly of section .text:

0000000000100000 <ptr_comparator>:

int ptr_comparator( const void * a, const void * b){
    ptr_with_size * a_ptr = (ptr_with_size *) a;
    ptr_with_size * b_ptr = (ptr_with_size *) b;

    return (int)b_ptr->size - (int)a_ptr->size;
  100000:	48 8b 46 08          	mov    0x8(%rsi),%rax
  100004:	2b 47 08             	sub    0x8(%rdi),%eax
}
  100007:	c3                   	retq   

0000000000100008 <_quicksort>:
{
  100008:	55                   	push   %rbp
  100009:	48 89 e5             	mov    %rsp,%rbp
  10000c:	41 57                	push   %r15
  10000e:	41 56                	push   %r14
  100010:	41 55                	push   %r13
  100012:	41 54                	push   %r12
  100014:	53                   	push   %rbx
  100015:	48 81 ec 48 04 00 00 	sub    $0x448,%rsp
  10001c:	48 89 bd a0 fb ff ff 	mov    %rdi,-0x460(%rbp)
  100023:	48 89 b5 98 fb ff ff 	mov    %rsi,-0x468(%rbp)
  10002a:	48 89 95 c8 fb ff ff 	mov    %rdx,-0x438(%rbp)
    if (total_elems == 0)
  100031:	48 85 f6             	test   %rsi,%rsi
  100034:	0f 84 94 03 00 00    	je     1003ce <_quicksort+0x3c6>
  10003a:	48 89 f0             	mov    %rsi,%rax
  10003d:	48 89 cb             	mov    %rcx,%rbx
    const size_t max_thresh = MAX_THRESH * size;
  100040:	48 8d 0c 95 00 00 00 	lea    0x0(,%rdx,4),%rcx
  100047:	00 
  100048:	48 89 8d a8 fb ff ff 	mov    %rcx,-0x458(%rbp)
    if (total_elems > MAX_THRESH)
  10004f:	48 83 fe 04          	cmp    $0x4,%rsi
  100053:	0f 86 bd 02 00 00    	jbe    100316 <_quicksort+0x30e>
	char *hi = &lo[size * (total_elems - 1)];
  100059:	48 83 e8 01          	sub    $0x1,%rax
  10005d:	48 0f af c2          	imul   %rdx,%rax
  100061:	48 01 f8             	add    %rdi,%rax
  100064:	48 89 85 c0 fb ff ff 	mov    %rax,-0x440(%rbp)
	PUSH (NULL, NULL);
  10006b:	48 c7 85 d0 fb ff ff 	movq   $0x0,-0x430(%rbp)
  100072:	00 00 00 00 
  100076:	48 c7 85 d8 fb ff ff 	movq   $0x0,-0x428(%rbp)
  10007d:	00 00 00 00 
	char *lo = base_ptr;
  100081:	48 89 bd b8 fb ff ff 	mov    %rdi,-0x448(%rbp)
	PUSH (NULL, NULL);
  100088:	48 8d 85 e0 fb ff ff 	lea    -0x420(%rbp),%rax
  10008f:	48 89 85 b0 fb ff ff 	mov    %rax,-0x450(%rbp)
	  right_ptr = hi - size;
  100096:	48 f7 da             	neg    %rdx
  100099:	49 89 d7             	mov    %rdx,%r15
  10009c:	e9 8c 01 00 00       	jmpq   10022d <_quicksort+0x225>
  1000a1:	48 8b 85 c8 fb ff ff 	mov    -0x438(%rbp),%rax
  1000a8:	49 8d 7c 05 00       	lea    0x0(%r13,%rax,1),%rdi
	    if ((*cmp) ((void *) mid, (void *) lo) < 0)
  1000ad:	48 8b 95 b8 fb ff ff 	mov    -0x448(%rbp),%rdx
		SWAP (mid, lo, size);
  1000b4:	4c 89 e8             	mov    %r13,%rax
  1000b7:	0f b6 08             	movzbl (%rax),%ecx
  1000ba:	48 83 c0 01          	add    $0x1,%rax
  1000be:	0f b6 32             	movzbl (%rdx),%esi
  1000c1:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  1000c5:	48 83 c2 01          	add    $0x1,%rdx
  1000c9:	88 4a ff             	mov    %cl,-0x1(%rdx)
  1000cc:	48 39 c7             	cmp    %rax,%rdi
  1000cf:	75 e6                	jne    1000b7 <_quicksort+0xaf>
  1000d1:	e9 92 01 00 00       	jmpq   100268 <_quicksort+0x260>
  1000d6:	48 8b 85 c8 fb ff ff 	mov    -0x438(%rbp),%rax
  1000dd:	4d 8d 64 05 00       	lea    0x0(%r13,%rax,1),%r12
	    if ((*cmp) ((void *) hi, (void *) mid) < 0)
  1000e2:	48 8b 95 c0 fb ff ff 	mov    -0x440(%rbp),%rdx
		SWAP (mid, hi, size);
  1000e9:	4c 89 e8             	mov    %r13,%rax
  1000ec:	0f b6 08             	movzbl (%rax),%ecx
  1000ef:	48 83 c0 01          	add    $0x1,%rax
  1000f3:	0f b6 32             	movzbl (%rdx),%esi
  1000f6:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  1000fa:	48 83 c2 01          	add    $0x1,%rdx
  1000fe:	88 4a ff             	mov    %cl,-0x1(%rdx)
  100101:	49 39 c4             	cmp    %rax,%r12
  100104:	75 e6                	jne    1000ec <_quicksort+0xe4>
	    if ((*cmp) ((void *) mid, (void *) lo) < 0)
  100106:	48 8b b5 b8 fb ff ff 	mov    -0x448(%rbp),%rsi
  10010d:	4c 89 ef             	mov    %r13,%rdi
  100110:	ff d3                	callq  *%rbx
  100112:	85 c0                	test   %eax,%eax
  100114:	0f 89 62 01 00 00    	jns    10027c <_quicksort+0x274>
  10011a:	48 8b 95 b8 fb ff ff 	mov    -0x448(%rbp),%rdx
		SWAP (mid, lo, size);
  100121:	4c 89 e8             	mov    %r13,%rax
  100124:	0f b6 08             	movzbl (%rax),%ecx
  100127:	48 83 c0 01          	add    $0x1,%rax
  10012b:	0f b6 32             	movzbl (%rdx),%esi
  10012e:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  100132:	48 83 c2 01          	add    $0x1,%rdx
  100136:	88 4a ff             	mov    %cl,-0x1(%rdx)
  100139:	49 39 c4             	cmp    %rax,%r12
  10013c:	75 e6                	jne    100124 <_quicksort+0x11c>
jump_over:;
  10013e:	e9 39 01 00 00       	jmpq   10027c <_quicksort+0x274>
		  right_ptr -= size;
  100143:	4d 01 fc             	add    %r15,%r12
	      while ((*cmp) ((void *) mid, (void *) right_ptr) < 0)
  100146:	4c 89 e6             	mov    %r12,%rsi
  100149:	4c 89 ef             	mov    %r13,%rdi
  10014c:	ff d3                	callq  *%rbx
  10014e:	85 c0                	test   %eax,%eax
  100150:	78 f1                	js     100143 <_quicksort+0x13b>
	      if (left_ptr < right_ptr)
  100152:	4d 39 e6             	cmp    %r12,%r14
  100155:	72 1c                	jb     100173 <_quicksort+0x16b>
	      else if (left_ptr == right_ptr)
  100157:	74 5e                	je     1001b7 <_quicksort+0x1af>
	  while (left_ptr <= right_ptr);
  100159:	4d 39 e6             	cmp    %r12,%r14
  10015c:	77 63                	ja     1001c1 <_quicksort+0x1b9>
	      while ((*cmp) ((void *) left_ptr, (void *) mid) < 0)
  10015e:	4c 89 ee             	mov    %r13,%rsi
  100161:	4c 89 f7             	mov    %r14,%rdi
  100164:	ff d3                	callq  *%rbx
  100166:	85 c0                	test   %eax,%eax
  100168:	79 dc                	jns    100146 <_quicksort+0x13e>
		  left_ptr += size;
  10016a:	4c 03 b5 c8 fb ff ff 	add    -0x438(%rbp),%r14
  100171:	eb eb                	jmp    10015e <_quicksort+0x156>
  100173:	48 8b 85 c8 fb ff ff 	mov    -0x438(%rbp),%rax
  10017a:	49 8d 3c 06          	lea    (%r14,%rax,1),%rdi
	      if (left_ptr < right_ptr)
  10017e:	4c 89 e2             	mov    %r12,%rdx
  100181:	4c 89 f0             	mov    %r14,%rax
		  SWAP (left_ptr, right_ptr, size);
  100184:	0f b6 08             	movzbl (%rax),%ecx
  100187:	48 83 c0 01          	add    $0x1,%rax
  10018b:	0f b6 32             	movzbl (%rdx),%esi
  10018e:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  100192:	48 83 c2 01          	add    $0x1,%rdx
  100196:	88 4a ff             	mov    %cl,-0x1(%rdx)
  100199:	48 39 f8             	cmp    %rdi,%rax
  10019c:	75 e6                	jne    100184 <_quicksort+0x17c>
		  if (mid == left_ptr)
  10019e:	4d 39 ee             	cmp    %r13,%r14
  1001a1:	74 0f                	je     1001b2 <_quicksort+0x1aa>
		  else if (mid == right_ptr)
  1001a3:	4d 39 ec             	cmp    %r13,%r12
  1001a6:	4d 0f 44 ee          	cmove  %r14,%r13
		  right_ptr -= size;
  1001aa:	4d 01 fc             	add    %r15,%r12
		  left_ptr += size;
  1001ad:	49 89 fe             	mov    %rdi,%r14
  1001b0:	eb a7                	jmp    100159 <_quicksort+0x151>
  1001b2:	4d 89 e5             	mov    %r12,%r13
  1001b5:	eb f3                	jmp    1001aa <_quicksort+0x1a2>
		  left_ptr += size;
  1001b7:	4c 03 b5 c8 fb ff ff 	add    -0x438(%rbp),%r14
		  right_ptr -= size;
  1001be:	4d 01 fc             	add    %r15,%r12
	  if ((size_t) (right_ptr - lo) <= max_thresh)
  1001c1:	4c 89 e0             	mov    %r12,%rax
  1001c4:	48 2b 85 b8 fb ff ff 	sub    -0x448(%rbp),%rax
  1001cb:	48 8b bd a8 fb ff ff 	mov    -0x458(%rbp),%rdi
  1001d2:	48 39 f8             	cmp    %rdi,%rax
  1001d5:	0f 87 bf 00 00 00    	ja     10029a <_quicksort+0x292>
	      if ((size_t) (hi - left_ptr) <= max_thresh)
  1001db:	48 8b 85 c0 fb ff ff 	mov    -0x440(%rbp),%rax
  1001e2:	4c 29 f0             	sub    %r14,%rax
		  lo = left_ptr;
  1001e5:	4c 89 b5 b8 fb ff ff 	mov    %r14,-0x448(%rbp)
	      if ((size_t) (hi - left_ptr) <= max_thresh)
  1001ec:	48 39 f8             	cmp    %rdi,%rax
  1001ef:	77 28                	ja     100219 <_quicksort+0x211>
		  POP (lo, hi);
  1001f1:	48 8b 85 b0 fb ff ff 	mov    -0x450(%rbp),%rax
  1001f8:	48 8b 78 f0          	mov    -0x10(%rax),%rdi
  1001fc:	48 89 bd b8 fb ff ff 	mov    %rdi,-0x448(%rbp)
  100203:	48 8b 78 f8          	mov    -0x8(%rax),%rdi
  100207:	48 89 bd c0 fb ff ff 	mov    %rdi,-0x440(%rbp)
  10020e:	48 8d 40 f0          	lea    -0x10(%rax),%rax
  100212:	48 89 85 b0 fb ff ff 	mov    %rax,-0x450(%rbp)
	while (STACK_NOT_EMPTY)
  100219:	48 8d 85 d0 fb ff ff 	lea    -0x430(%rbp),%rax
  100220:	48 39 85 b0 fb ff ff 	cmp    %rax,-0x450(%rbp)
  100227:	0f 86 e9 00 00 00    	jbe    100316 <_quicksort+0x30e>
	    char *mid = lo + size * ((hi - lo) / size >> 1);
  10022d:	48 8b 85 c0 fb ff ff 	mov    -0x440(%rbp),%rax
  100234:	48 8b bd b8 fb ff ff 	mov    -0x448(%rbp),%rdi
  10023b:	48 29 f8             	sub    %rdi,%rax
  10023e:	48 8b 8d c8 fb ff ff 	mov    -0x438(%rbp),%rcx
  100245:	ba 00 00 00 00       	mov    $0x0,%edx
  10024a:	48 f7 f1             	div    %rcx
  10024d:	48 d1 e8             	shr    %rax
  100250:	48 0f af c1          	imul   %rcx,%rax
  100254:	4c 8d 2c 07          	lea    (%rdi,%rax,1),%r13
	    if ((*cmp) ((void *) mid, (void *) lo) < 0)
  100258:	48 89 fe             	mov    %rdi,%rsi
  10025b:	4c 89 ef             	mov    %r13,%rdi
  10025e:	ff d3                	callq  *%rbx
  100260:	85 c0                	test   %eax,%eax
  100262:	0f 88 39 fe ff ff    	js     1000a1 <_quicksort+0x99>
	    if ((*cmp) ((void *) hi, (void *) mid) < 0)
  100268:	4c 89 ee             	mov    %r13,%rsi
  10026b:	48 8b bd c0 fb ff ff 	mov    -0x440(%rbp),%rdi
  100272:	ff d3                	callq  *%rbx
  100274:	85 c0                	test   %eax,%eax
  100276:	0f 88 5a fe ff ff    	js     1000d6 <_quicksort+0xce>
	  left_ptr  = lo + size;
  10027c:	4c 8b b5 b8 fb ff ff 	mov    -0x448(%rbp),%r14
  100283:	4c 03 b5 c8 fb ff ff 	add    -0x438(%rbp),%r14
	  right_ptr = hi - size;
  10028a:	48 8b 85 c0 fb ff ff 	mov    -0x440(%rbp),%rax
  100291:	4e 8d 24 38          	lea    (%rax,%r15,1),%r12
  100295:	e9 c4 fe ff ff       	jmpq   10015e <_quicksort+0x156>
	  else if ((size_t) (hi - left_ptr) <= max_thresh)
  10029a:	48 8b 95 c0 fb ff ff 	mov    -0x440(%rbp),%rdx
  1002a1:	4c 29 f2             	sub    %r14,%rdx
  1002a4:	48 3b 95 a8 fb ff ff 	cmp    -0x458(%rbp),%rdx
  1002ab:	76 5d                	jbe    10030a <_quicksort+0x302>
	  else if ((right_ptr - lo) > (hi - left_ptr))
  1002ad:	48 39 d0             	cmp    %rdx,%rax
  1002b0:	7e 2c                	jle    1002de <_quicksort+0x2d6>
	      PUSH (lo, right_ptr);
  1002b2:	48 8b 85 b0 fb ff ff 	mov    -0x450(%rbp),%rax
  1002b9:	48 8b bd b8 fb ff ff 	mov    -0x448(%rbp),%rdi
  1002c0:	48 89 38             	mov    %rdi,(%rax)
  1002c3:	4c 89 60 08          	mov    %r12,0x8(%rax)
  1002c7:	48 83 c0 10          	add    $0x10,%rax
  1002cb:	48 89 85 b0 fb ff ff 	mov    %rax,-0x450(%rbp)
	      lo = left_ptr;
  1002d2:	4c 89 b5 b8 fb ff ff 	mov    %r14,-0x448(%rbp)
  1002d9:	e9 3b ff ff ff       	jmpq   100219 <_quicksort+0x211>
	      PUSH (left_ptr, hi);
  1002de:	48 8b 85 b0 fb ff ff 	mov    -0x450(%rbp),%rax
  1002e5:	4c 89 30             	mov    %r14,(%rax)
  1002e8:	48 8b bd c0 fb ff ff 	mov    -0x440(%rbp),%rdi
  1002ef:	48 89 78 08          	mov    %rdi,0x8(%rax)
  1002f3:	48 83 c0 10          	add    $0x10,%rax
  1002f7:	48 89 85 b0 fb ff ff 	mov    %rax,-0x450(%rbp)
	      hi = right_ptr;
  1002fe:	4c 89 a5 c0 fb ff ff 	mov    %r12,-0x440(%rbp)
  100305:	e9 0f ff ff ff       	jmpq   100219 <_quicksort+0x211>
	      hi = right_ptr;
  10030a:	4c 89 a5 c0 fb ff ff 	mov    %r12,-0x440(%rbp)
  100311:	e9 03 ff ff ff       	jmpq   100219 <_quicksort+0x211>
	char *const end_ptr = &base_ptr[size * (total_elems - 1)];
  100316:	4c 8b bd 98 fb ff ff 	mov    -0x468(%rbp),%r15
  10031d:	49 83 ef 01          	sub    $0x1,%r15
  100321:	48 8b bd c8 fb ff ff 	mov    -0x438(%rbp),%rdi
  100328:	4c 0f af ff          	imul   %rdi,%r15
  10032c:	4c 8b ad a0 fb ff ff 	mov    -0x460(%rbp),%r13
  100333:	4d 01 ef             	add    %r13,%r15
	char *thresh = min(end_ptr, base_ptr + max_thresh);
  100336:	48 8b 85 a8 fb ff ff 	mov    -0x458(%rbp),%rax
  10033d:	4c 01 e8             	add    %r13,%rax
  100340:	49 39 c7             	cmp    %rax,%r15
  100343:	49 0f 46 c7          	cmovbe %r15,%rax
	for (run_ptr = tmp_ptr + size; run_ptr <= thresh; run_ptr += size)
  100347:	4d 89 ec             	mov    %r13,%r12
  10034a:	49 01 fc             	add    %rdi,%r12
  10034d:	4c 39 e0             	cmp    %r12,%rax
  100350:	72 66                	jb     1003b8 <_quicksort+0x3b0>
  100352:	4d 89 e6             	mov    %r12,%r14
	char *tmp_ptr = base_ptr;
  100355:	4c 89 a5 c0 fb ff ff 	mov    %r12,-0x440(%rbp)
  10035c:	49 89 c4             	mov    %rax,%r12
	    if ((*cmp) ((void *) run_ptr, (void *) tmp_ptr) < 0)
  10035f:	4c 89 ee             	mov    %r13,%rsi
  100362:	4c 89 f7             	mov    %r14,%rdi
  100365:	ff d3                	callq  *%rbx
  100367:	85 c0                	test   %eax,%eax
  100369:	4d 0f 48 ee          	cmovs  %r14,%r13
	for (run_ptr = tmp_ptr + size; run_ptr <= thresh; run_ptr += size)
  10036d:	4c 03 b5 c8 fb ff ff 	add    -0x438(%rbp),%r14
  100374:	4d 39 f4             	cmp    %r14,%r12
  100377:	73 e6                	jae    10035f <_quicksort+0x357>
  100379:	4c 8b a5 c0 fb ff ff 	mov    -0x440(%rbp),%r12
	if (tmp_ptr != base_ptr)
  100380:	48 8b 85 c8 fb ff ff 	mov    -0x438(%rbp),%rax
  100387:	49 8d 4c 05 00       	lea    0x0(%r13,%rax,1),%rcx
  10038c:	48 8b 85 a0 fb ff ff 	mov    -0x460(%rbp),%rax
  100393:	4c 3b ad a0 fb ff ff 	cmp    -0x460(%rbp),%r13
  10039a:	74 1c                	je     1003b8 <_quicksort+0x3b0>
	    SWAP (tmp_ptr, base_ptr, size);
  10039c:	41 0f b6 55 00       	movzbl 0x0(%r13),%edx
  1003a1:	49 83 c5 01          	add    $0x1,%r13
  1003a5:	0f b6 30             	movzbl (%rax),%esi
  1003a8:	41 88 75 ff          	mov    %sil,-0x1(%r13)
  1003ac:	48 83 c0 01          	add    $0x1,%rax
  1003b0:	88 50 ff             	mov    %dl,-0x1(%rax)
  1003b3:	49 39 cd             	cmp    %rcx,%r13
  1003b6:	75 e4                	jne    10039c <_quicksort+0x394>
	while ((run_ptr += size) <= end_ptr)
  1003b8:	48 8b 85 c8 fb ff ff 	mov    -0x438(%rbp),%rax
  1003bf:	4d 8d 34 04          	lea    (%r12,%rax,1),%r14
	    tmp_ptr = run_ptr - size;
  1003c3:	48 f7 d8             	neg    %rax
  1003c6:	49 89 c5             	mov    %rax,%r13
	while ((run_ptr += size) <= end_ptr)
  1003c9:	4d 39 f7             	cmp    %r14,%r15
  1003cc:	73 15                	jae    1003e3 <_quicksort+0x3db>
}
  1003ce:	48 81 c4 48 04 00 00 	add    $0x448,%rsp
  1003d5:	5b                   	pop    %rbx
  1003d6:	41 5c                	pop    %r12
  1003d8:	41 5d                	pop    %r13
  1003da:	41 5e                	pop    %r14
  1003dc:	41 5f                	pop    %r15
  1003de:	5d                   	pop    %rbp
  1003df:	c3                   	retq   
		tmp_ptr -= size;
  1003e0:	4d 01 ec             	add    %r13,%r12
	    while ((*cmp) ((void *) run_ptr, (void *) tmp_ptr) < 0)
  1003e3:	4c 89 e6             	mov    %r12,%rsi
  1003e6:	4c 89 f7             	mov    %r14,%rdi
  1003e9:	ff d3                	callq  *%rbx
  1003eb:	85 c0                	test   %eax,%eax
  1003ed:	78 f1                	js     1003e0 <_quicksort+0x3d8>
	    tmp_ptr += size;
  1003ef:	48 8b 85 c8 fb ff ff 	mov    -0x438(%rbp),%rax
  1003f6:	49 8d 34 04          	lea    (%r12,%rax,1),%rsi
	    if (tmp_ptr != run_ptr)
  1003fa:	4c 39 f6             	cmp    %r14,%rsi
  1003fd:	75 17                	jne    100416 <_quicksort+0x40e>
	while ((run_ptr += size) <= end_ptr)
  1003ff:	48 8b 85 c8 fb ff ff 	mov    -0x438(%rbp),%rax
  100406:	4c 01 f0             	add    %r14,%rax
  100409:	4d 89 f4             	mov    %r14,%r12
  10040c:	49 39 c7             	cmp    %rax,%r15
  10040f:	72 bd                	jb     1003ce <_quicksort+0x3c6>
  100411:	49 89 c6             	mov    %rax,%r14
	    while ((*cmp) ((void *) run_ptr, (void *) tmp_ptr) < 0)
  100414:	eb cd                	jmp    1003e3 <_quicksort+0x3db>
		while (--trav >= run_ptr)
  100416:	49 8d 7c 06 ff       	lea    -0x1(%r14,%rax,1),%rdi
  10041b:	4c 39 f7             	cmp    %r14,%rdi
  10041e:	72 df                	jb     1003ff <_quicksort+0x3f7>
  100420:	4d 8d 46 ff          	lea    -0x1(%r14),%r8
  100424:	4d 89 c2             	mov    %r8,%r10
  100427:	eb 13                	jmp    10043c <_quicksort+0x434>
		    for (hi = lo = trav; (lo -= size) >= tmp_ptr; hi = lo)
  100429:	48 89 f9             	mov    %rdi,%rcx
		    *hi = c;
  10042c:	44 88 09             	mov    %r9b,(%rcx)
		while (--trav >= run_ptr)
  10042f:	48 83 ef 01          	sub    $0x1,%rdi
  100433:	49 83 e8 01          	sub    $0x1,%r8
  100437:	49 39 fa             	cmp    %rdi,%r10
  10043a:	74 c3                	je     1003ff <_quicksort+0x3f7>
		    char c = *trav;
  10043c:	44 0f b6 0f          	movzbl (%rdi),%r9d
		    for (hi = lo = trav; (lo -= size) >= tmp_ptr; hi = lo)
  100440:	4c 89 c0             	mov    %r8,%rax
  100443:	4c 39 c6             	cmp    %r8,%rsi
  100446:	77 e1                	ja     100429 <_quicksort+0x421>
  100448:	48 89 fa             	mov    %rdi,%rdx
			*hi = *lo;
  10044b:	0f b6 08             	movzbl (%rax),%ecx
  10044e:	88 0a                	mov    %cl,(%rdx)
		    for (hi = lo = trav; (lo -= size) >= tmp_ptr; hi = lo)
  100450:	48 89 c1             	mov    %rax,%rcx
  100453:	4c 01 e8             	add    %r13,%rax
  100456:	48 2b 95 c8 fb ff ff 	sub    -0x438(%rbp),%rdx
  10045d:	48 39 c6             	cmp    %rax,%rsi
  100460:	76 e9                	jbe    10044b <_quicksort+0x443>
  100462:	eb c8                	jmp    10042c <_quicksort+0x424>

0000000000100464 <exists_in_between>:


int exists_in_between(ptr_with_size *ptrs, void * ptr, long size, int len){

    for(int i = 0; i < len ; i++){
  100464:	85 c9                	test   %ecx,%ecx
  100466:	7e 53                	jle    1004bb <exists_in_between+0x57>
  100468:	41 b8 00 00 00 00    	mov    $0x0,%r8d
        if(ptrs[i].ptr == ptr){
  10046e:	48 39 37             	cmp    %rsi,(%rdi)
  100471:	74 13                	je     100486 <exists_in_between+0x22>
    for(int i = 0; i < len ; i++){
  100473:	41 83 c0 01          	add    $0x1,%r8d
  100477:	48 83 c7 10          	add    $0x10,%rdi
  10047b:	44 39 c1             	cmp    %r8d,%ecx
  10047e:	75 ee                	jne    10046e <exists_in_between+0xa>
                return 0;
            }
        }
    }

    return 0;
  100480:	b8 00 00 00 00       	mov    $0x0,%eax
  100485:	c3                   	retq   
            if(ptrs[i].size <= size)
  100486:	48 8b 77 08          	mov    0x8(%rdi),%rsi
                return 1;
  10048a:	b8 01 00 00 00       	mov    $0x1,%eax
            if(ptrs[i].size <= size)
  10048f:	48 39 d6             	cmp    %rdx,%rsi
  100492:	7f 01                	jg     100495 <exists_in_between+0x31>
}
  100494:	c3                   	retq   
int exists_in_between(ptr_with_size *ptrs, void * ptr, long size, int len){
  100495:	55                   	push   %rbp
  100496:	48 89 e5             	mov    %rsp,%rbp
                app_printf(0, "size (%ld, %ld) [%d, %d] ", size, ptrs[i].size, i, len - 1);
  100499:	44 8d 49 ff          	lea    -0x1(%rcx),%r9d
  10049d:	48 89 f1             	mov    %rsi,%rcx
  1004a0:	be 60 1e 10 00       	mov    $0x101e60,%esi
  1004a5:	bf 00 00 00 00       	mov    $0x0,%edi
  1004aa:	b8 00 00 00 00       	mov    $0x0,%eax
  1004af:	e8 1b 18 00 00       	callq  101ccf <app_printf>
                return 0;
  1004b4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1004b9:	5d                   	pop    %rbp
  1004ba:	c3                   	retq   
    return 0;
  1004bb:	b8 00 00 00 00       	mov    $0x0,%eax
  1004c0:	c3                   	retq   

00000000001004c1 <process_main>:
void process_main(void) {
  1004c1:	55                   	push   %rbp
  1004c2:	48 89 e5             	mov    %rsp,%rbp
  1004c5:	41 55                	push   %r13
  1004c7:	41 54                	push   %r12
  1004c9:	53                   	push   %rbx
  1004ca:	48 83 ec 48          	sub    $0x48,%rsp

// getpid
//    Return current process ID.
static inline pid_t getpid(void) {
    pid_t result;
    asm volatile ("int %1" : "=a" (result)
  1004ce:	cd 31                	int    $0x31
  1004d0:	89 c7                	mov    %eax,%edi
    pid_t p = getpid();
    srand(p);
  1004d2:	e8 76 04 00 00       	callq  10094d <srand>
    heap_bottom = heap_top = ROUNDUP((uint8_t*) end, PAGESIZE);
  1004d7:	b8 67 40 10 00       	mov    $0x104067,%eax
  1004dc:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  1004e2:	48 89 05 27 2b 00 00 	mov    %rax,0x2b27(%rip)        # 103010 <heap_top>
  1004e9:	48 89 05 18 2b 00 00 	mov    %rax,0x2b18(%rip)        # 103008 <heap_bottom>
    return rbp;
}

static inline uintptr_t read_rsp(void) {
    uintptr_t rsp;
    asm volatile("movq %%rsp,%0" : "=r" (rsp));
  1004f0:	48 89 e0             	mov    %rsp,%rax
    stack_bottom = ROUNDDOWN((uint8_t*) read_rsp() - 1, PAGESIZE);
  1004f3:	48 83 e8 01          	sub    $0x1,%rax
  1004f7:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  1004fd:	48 89 05 fc 2a 00 00 	mov    %rax,0x2afc(%rip)        # 103000 <stack_bottom>

    int sizes[] = {10, 20, 30, 1999};
  100504:	c7 45 d0 0a 00 00 00 	movl   $0xa,-0x30(%rbp)
  10050b:	c7 45 d4 14 00 00 00 	movl   $0x14,-0x2c(%rbp)
  100512:	c7 45 d8 1e 00 00 00 	movl   $0x1e,-0x28(%rbp)
  100519:	c7 45 dc cf 07 00 00 	movl   $0x7cf,-0x24(%rbp)
//     On success, sbrk() returns the previous program break
//     (If the break was increased, then this value is a pointer to the start of the newly allocated memory)
//      On error, (void *) -1 is returned
static inline void * sbrk(const intptr_t increment) {
    static void * result;
    asm volatile ("int %1" :  "=a" (result)
  100520:	bf 00 b0 07 00       	mov    $0x7b000,%edi
  100525:	cd 3a                	int    $0x3a
  100527:	48 89 05 ea 2a 00 00 	mov    %rax,0x2aea(%rip)        # 103018 <result.0>
  10052e:	ba 00 00 00 00       	mov    $0x0,%edx
  100533:	48 89 d7             	mov    %rdx,%rdi
  100536:	cd 3a                	int    $0x3a
  100538:	48 89 05 d9 2a 00 00 	mov    %rax,0x2ad9(%rip)        # 103018 <result.0>

    // leave about 1 MB for malloc
    sbrk(123 * PAGESIZE);
    heap_top = sbrk(0);
  10053f:	48 89 05 ca 2a 00 00 	mov    %rax,0x2aca(%rip)        # 103010 <heap_top>

    ptr_with_size *ptr = (ptr_with_size *)heap_bottom;
  100546:	4c 8b 25 bb 2a 00 00 	mov    0x2abb(%rip),%r12        # 103008 <heap_bottom>
    asm volatile ("int %1" :  "=a" (result)
  10054d:	bf 00 f0 1f 00       	mov    $0x1ff000,%edi
  100552:	cd 39                	int    $0x39
  100554:	89 05 c6 2a 00 00    	mov    %eax,0x2ac6(%rip)        # 103020 <result.1>
    // shift brk so we are 1 MB before stack
    brk((void *)(intptr_t)ROUNDDOWN(0x200000-1, PAGESIZE));


    volatile int ptr_size = 0;
  10055a:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%rbp)
    asm volatile ("int %0" : /* no result */
  100561:	bf 00 00 00 00       	mov    $0x0,%edi
  100566:	cd 38                	int    $0x38
    asm volatile ("int %1" :  "=a" (result)
  100568:	48 89 d7             	mov    %rdx,%rdi
  10056b:	cd 3a                	int    $0x3a
  10056d:	48 89 05 a4 2a 00 00 	mov    %rax,0x2aa4(%rip)        # 103018 <result.0>
    mem_tog(0);

    while((intptr_t)ROUNDUP(sbrk(0), PAGESIZE) <= 0x280000){
  100574:	48 05 ff 0f 00 00    	add    $0xfff,%rax
  10057a:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  100580:	48 3d 00 00 28 00    	cmp    $0x280000,%rax
  100586:	0f 8f 8c 00 00 00    	jg     100618 <process_main+0x157>
  10058c:	41 bd 00 00 00 00    	mov    $0x0,%r13d
	int sz = ALLOC(ptr_size);
  100592:	8b 45 cc             	mov    -0x34(%rbp),%eax
  100595:	8b 55 cc             	mov    -0x34(%rbp),%edx
  100598:	89 d3                	mov    %edx,%ebx
  10059a:	c1 fb 02             	sar    $0x2,%ebx
  10059d:	c1 fa 1f             	sar    $0x1f,%edx
  1005a0:	c1 ea 1e             	shr    $0x1e,%edx
  1005a3:	01 d3                	add    %edx,%ebx
  1005a5:	83 e3 03             	and    $0x3,%ebx
  1005a8:	29 d3                	sub    %edx,%ebx
  1005aa:	83 c3 01             	add    $0x1,%ebx
  1005ad:	99                   	cltd   
  1005ae:	c1 ea 1e             	shr    $0x1e,%edx
  1005b1:	01 d0                	add    %edx,%eax
  1005b3:	83 e0 03             	and    $0x3,%eax
  1005b6:	29 d0                	sub    %edx,%eax
  1005b8:	48 98                	cltq   
  1005ba:	0f af 5c 85 d0       	imul   -0x30(%rbp,%rax,4),%ebx
	void * temp_ptr = malloc(sz);
  1005bf:	48 63 fb             	movslq %ebx,%rdi
  1005c2:	e8 a8 12 00 00       	callq  10186f <malloc>
	if(temp_ptr == NULL)
  1005c7:	48 85 c0             	test   %rax,%rax
  1005ca:	74 4c                	je     100618 <process_main+0x157>
	    break;
	ptr[ptr_size].ptr = temp_ptr;
  1005cc:	8b 55 cc             	mov    -0x34(%rbp),%edx
  1005cf:	48 63 d2             	movslq %edx,%rdx
  1005d2:	48 c1 e2 04          	shl    $0x4,%rdx
  1005d6:	49 89 04 14          	mov    %rax,(%r12,%rdx,1)
	ptr[ptr_size].size = sz;
  1005da:	8b 45 cc             	mov    -0x34(%rbp),%eax
  1005dd:	48 98                	cltq   
  1005df:	48 c1 e0 04          	shl    $0x4,%rax
  1005e3:	48 63 db             	movslq %ebx,%rbx
  1005e6:	49 89 5c 04 08       	mov    %rbx,0x8(%r12,%rax,1)
	ptr_size++;
  1005eb:	8b 45 cc             	mov    -0x34(%rbp),%eax
  1005ee:	83 c0 01             	add    $0x1,%eax
  1005f1:	89 45 cc             	mov    %eax,-0x34(%rbp)
  1005f4:	4c 89 ef             	mov    %r13,%rdi
  1005f7:	cd 3a                	int    $0x3a
  1005f9:	48 89 05 18 2a 00 00 	mov    %rax,0x2a18(%rip)        # 103018 <result.0>
    while((intptr_t)ROUNDUP(sbrk(0), PAGESIZE) <= 0x280000){
  100600:	48 05 ff 0f 00 00    	add    $0xfff,%rax
  100606:	48 25 00 f0 ff ff    	and    $0xfffffffffffff000,%rax
  10060c:	48 3d 00 00 28 00    	cmp    $0x280000,%rax
  100612:	0f 8e 7a ff ff ff    	jle    100592 <process_main+0xd1>
    }

    _quicksort(ptr, ptr_size, sizeof(ptr[0]), &ptr_comparator);
  100618:	8b 75 cc             	mov    -0x34(%rbp),%esi
  10061b:	48 63 f6             	movslq %esi,%rsi
  10061e:	b9 00 00 10 00       	mov    $0x100000,%ecx
  100623:	ba 10 00 00 00       	mov    $0x10,%edx
  100628:	4c 89 e7             	mov    %r12,%rdi
  10062b:	e8 d8 f9 ff ff       	callq  100008 <_quicksort>
/* rdtscp */
static uint64_t rdtsc(void) {
	uint64_t var;
	uint32_t hi, lo;

	__asm volatile
  100630:	0f 31                	rdtsc  
	    ("rdtsc" : "=a" (lo), "=d" (hi));

	var = ((uint64_t)hi << 32) | lo;
  100632:	48 c1 e2 20          	shl    $0x20,%rdx
  100636:	89 c0                	mov    %eax,%eax
  100638:	48 89 d3             	mov    %rdx,%rbx
  10063b:	48 09 c3             	or     %rax,%rbx

//
    heap_info_struct h;
    register uint64_t time1 = rdtsc(); 
    int ret = heap_info(&h);
  10063e:	48 8d 7d a8          	lea    -0x58(%rbp),%rdi
  100642:	e8 aa 14 00 00       	callq  101af1 <heap_info>
  100647:	41 89 c5             	mov    %eax,%r13d
	__asm volatile
  10064a:	0f 31                	rdtsc  
	var = ((uint64_t)hi << 32) | lo;
  10064c:	48 c1 e2 20          	shl    $0x20,%rdx
  100650:	89 c0                	mov    %eax,%eax
  100652:	48 09 c2             	or     %rax,%rdx
    time1 = rdtsc() - time1;
  100655:	48 29 da             	sub    %rbx,%rdx
    app_printf(0, "time: %ld\n", time1);
  100658:	be 7a 1e 10 00       	mov    $0x101e7a,%esi
  10065d:	bf 00 00 00 00       	mov    $0x0,%edi
  100662:	b8 00 00 00 00       	mov    $0x0,%eax
  100667:	e8 63 16 00 00       	callq  101ccf <app_printf>

    if(ret){
  10066c:	45 85 ed             	test   %r13d,%r13d
  10066f:	75 3b                	jne    1006ac <process_main+0x1eb>
	exit();
    }

    assert(h.num_allocs == ptr_size);
  100671:	8b 45 a8             	mov    -0x58(%rbp),%eax
  100674:	8b 55 cc             	mov    -0x34(%rbp),%edx
  100677:	39 d0                	cmp    %edx,%eax
  100679:	75 35                	jne    1006b0 <process_main+0x1ef>

    for(volatile int i = 0 ; i < h.num_allocs ; i++){
  10067b:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%rbp)
  100682:	8b 55 a4             	mov    -0x5c(%rbp),%edx
  100685:	39 d0                	cmp    %edx,%eax
  100687:	7f 76                	jg     1006ff <process_main+0x23e>
        int r = exists_in_between(ptr, h.ptr_array[i], h.size_array[i], ptr_size);
        assert(r);
    }
		

    app_printf(0, "HEAP INFO PASS\n");
  100689:	be a9 1e 10 00       	mov    $0x101ea9,%esi
  10068e:	bf 00 00 00 00       	mov    $0x0,%edi
  100693:	b8 00 00 00 00       	mov    $0x0,%eax
  100698:	e8 32 16 00 00       	callq  101ccf <app_printf>
    TEST_PASS();
  10069d:	bf b9 1e 10 00       	mov    $0x101eb9,%edi
  1006a2:	b8 00 00 00 00       	mov    $0x0,%eax
  1006a7:	e8 b3 16 00 00       	callq  101d5f <kernel_panic>
    asm volatile ("int %0" : /* no result */
  1006ac:	cd 35                	int    $0x35
 spinloop: goto spinloop;       // should never get here
  1006ae:	eb fe                	jmp    1006ae <process_main+0x1ed>
    assert(h.num_allocs == ptr_size);
  1006b0:	ba 85 1e 10 00       	mov    $0x101e85,%edx
  1006b5:	be fd 00 00 00       	mov    $0xfd,%esi
  1006ba:	bf 9e 1e 10 00       	mov    $0x101e9e,%edi
  1006bf:	e8 69 17 00 00       	callq  101e2d <assert_fail>
        int r = exists_in_between(ptr, h.ptr_array[i], h.size_array[i], ptr_size);
  1006c4:	8b 4d cc             	mov    -0x34(%rbp),%ecx
  1006c7:	8b 55 a4             	mov    -0x5c(%rbp),%edx
  1006ca:	8b 45 a4             	mov    -0x5c(%rbp),%eax
  1006cd:	48 63 d2             	movslq %edx,%rdx
  1006d0:	48 8b 75 b0          	mov    -0x50(%rbp),%rsi
  1006d4:	48 8b 14 d6          	mov    (%rsi,%rdx,8),%rdx
  1006d8:	48 98                	cltq   
  1006da:	48 8b 75 b8          	mov    -0x48(%rbp),%rsi
  1006de:	48 8b 34 c6          	mov    (%rsi,%rax,8),%rsi
  1006e2:	4c 89 e7             	mov    %r12,%rdi
  1006e5:	e8 7a fd ff ff       	callq  100464 <exists_in_between>
        assert(r);
  1006ea:	85 c0                	test   %eax,%eax
  1006ec:	74 46                	je     100734 <process_main+0x273>
    for(volatile int i = 0 ; i < h.num_allocs ; i++){
  1006ee:	8b 45 a4             	mov    -0x5c(%rbp),%eax
  1006f1:	83 c0 01             	add    $0x1,%eax
  1006f4:	89 45 a4             	mov    %eax,-0x5c(%rbp)
  1006f7:	8b 45 a4             	mov    -0x5c(%rbp),%eax
  1006fa:	39 45 a8             	cmp    %eax,-0x58(%rbp)
  1006fd:	7e 8a                	jle    100689 <process_main+0x1c8>
        assert(i == 0  || h.size_array[i] <= h.size_array[i-1]);
  1006ff:	8b 45 a4             	mov    -0x5c(%rbp),%eax
  100702:	85 c0                	test   %eax,%eax
  100704:	74 be                	je     1006c4 <process_main+0x203>
  100706:	48 8b 4d b0          	mov    -0x50(%rbp),%rcx
  10070a:	8b 55 a4             	mov    -0x5c(%rbp),%edx
  10070d:	8b 45 a4             	mov    -0x5c(%rbp),%eax
  100710:	48 63 d2             	movslq %edx,%rdx
  100713:	48 98                	cltq   
  100715:	48 8b 44 c1 f8       	mov    -0x8(%rcx,%rax,8),%rax
  10071a:	48 39 04 d1          	cmp    %rax,(%rcx,%rdx,8)
  10071e:	7e a4                	jle    1006c4 <process_main+0x203>
  100720:	ba d0 1e 10 00       	mov    $0x101ed0,%edx
  100725:	be 00 01 00 00       	mov    $0x100,%esi
  10072a:	bf 9e 1e 10 00       	mov    $0x101e9e,%edi
  10072f:	e8 f9 16 00 00       	callq  101e2d <assert_fail>
        assert(r);
  100734:	ba a7 1e 10 00       	mov    $0x101ea7,%edx
  100739:	be 02 01 00 00       	mov    $0x102,%esi
  10073e:	bf 9e 1e 10 00       	mov    $0x101e9e,%edi
  100743:	e8 e5 16 00 00       	callq  101e2d <assert_fail>

0000000000100748 <console_putc>:
typedef struct console_printer {
    printer p;
    uint16_t* cursor;
} console_printer;

static void console_putc(printer* p, unsigned char c, int color) {
  100748:	48 89 f9             	mov    %rdi,%rcx
  10074b:	89 d7                	mov    %edx,%edi
    console_printer* cp = (console_printer*) p;
    if (cp->cursor >= console + CONSOLE_ROWS * CONSOLE_COLUMNS) {
  10074d:	48 81 79 08 a0 8f 0b 	cmpq   $0xb8fa0,0x8(%rcx)
  100754:	00 
  100755:	72 08                	jb     10075f <console_putc+0x17>
        cp->cursor = console;
  100757:	48 c7 41 08 00 80 0b 	movq   $0xb8000,0x8(%rcx)
  10075e:	00 
    }
    if (c == '\n') {
  10075f:	40 80 fe 0a          	cmp    $0xa,%sil
  100763:	74 16                	je     10077b <console_putc+0x33>
        int pos = (cp->cursor - console) % 80;
        for (; pos != 80; pos++) {
            *cp->cursor++ = ' ' | color;
        }
    } else {
        *cp->cursor++ = c | color;
  100765:	48 8b 41 08          	mov    0x8(%rcx),%rax
  100769:	48 8d 50 02          	lea    0x2(%rax),%rdx
  10076d:	48 89 51 08          	mov    %rdx,0x8(%rcx)
  100771:	40 0f b6 f6          	movzbl %sil,%esi
  100775:	09 fe                	or     %edi,%esi
  100777:	66 89 30             	mov    %si,(%rax)
    }
}
  10077a:	c3                   	retq   
        int pos = (cp->cursor - console) % 80;
  10077b:	4c 8b 41 08          	mov    0x8(%rcx),%r8
  10077f:	49 81 e8 00 80 0b 00 	sub    $0xb8000,%r8
  100786:	4c 89 c6             	mov    %r8,%rsi
  100789:	48 d1 fe             	sar    %rsi
  10078c:	48 ba 67 66 66 66 66 	movabs $0x6666666666666667,%rdx
  100793:	66 66 66 
  100796:	48 89 f0             	mov    %rsi,%rax
  100799:	48 f7 ea             	imul   %rdx
  10079c:	48 c1 fa 05          	sar    $0x5,%rdx
  1007a0:	49 c1 f8 3f          	sar    $0x3f,%r8
  1007a4:	4c 29 c2             	sub    %r8,%rdx
  1007a7:	48 8d 14 92          	lea    (%rdx,%rdx,4),%rdx
  1007ab:	48 c1 e2 04          	shl    $0x4,%rdx
  1007af:	89 f0                	mov    %esi,%eax
  1007b1:	29 d0                	sub    %edx,%eax
            *cp->cursor++ = ' ' | color;
  1007b3:	83 cf 20             	or     $0x20,%edi
  1007b6:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  1007ba:	48 8d 72 02          	lea    0x2(%rdx),%rsi
  1007be:	48 89 71 08          	mov    %rsi,0x8(%rcx)
  1007c2:	66 89 3a             	mov    %di,(%rdx)
        for (; pos != 80; pos++) {
  1007c5:	83 c0 01             	add    $0x1,%eax
  1007c8:	83 f8 50             	cmp    $0x50,%eax
  1007cb:	75 e9                	jne    1007b6 <console_putc+0x6e>
  1007cd:	c3                   	retq   

00000000001007ce <string_putc>:
    char* end;
} string_printer;

static void string_putc(printer* p, unsigned char c, int color) {
    string_printer* sp = (string_printer*) p;
    if (sp->s < sp->end) {
  1007ce:	48 8b 47 08          	mov    0x8(%rdi),%rax
  1007d2:	48 3b 47 10          	cmp    0x10(%rdi),%rax
  1007d6:	73 0b                	jae    1007e3 <string_putc+0x15>
        *sp->s++ = c;
  1007d8:	48 8d 50 01          	lea    0x1(%rax),%rdx
  1007dc:	48 89 57 08          	mov    %rdx,0x8(%rdi)
  1007e0:	40 88 30             	mov    %sil,(%rax)
    }
    (void) color;
}
  1007e3:	c3                   	retq   

00000000001007e4 <memcpy>:
void* memcpy(void* dst, const void* src, size_t n) {
  1007e4:	48 89 f8             	mov    %rdi,%rax
    for (char* d = (char*) dst; n > 0; --n, ++s, ++d) {
  1007e7:	48 85 d2             	test   %rdx,%rdx
  1007ea:	74 17                	je     100803 <memcpy+0x1f>
  1007ec:	b9 00 00 00 00       	mov    $0x0,%ecx
        *d = *s;
  1007f1:	44 0f b6 04 0e       	movzbl (%rsi,%rcx,1),%r8d
  1007f6:	44 88 04 08          	mov    %r8b,(%rax,%rcx,1)
    for (char* d = (char*) dst; n > 0; --n, ++s, ++d) {
  1007fa:	48 83 c1 01          	add    $0x1,%rcx
  1007fe:	48 39 d1             	cmp    %rdx,%rcx
  100801:	75 ee                	jne    1007f1 <memcpy+0xd>
}
  100803:	c3                   	retq   

0000000000100804 <memmove>:
void* memmove(void* dst, const void* src, size_t n) {
  100804:	48 89 f8             	mov    %rdi,%rax
    if (s < d && s + n > d) {
  100807:	48 39 fe             	cmp    %rdi,%rsi
  10080a:	72 1d                	jb     100829 <memmove+0x25>
        while (n-- > 0) {
  10080c:	b9 00 00 00 00       	mov    $0x0,%ecx
  100811:	48 85 d2             	test   %rdx,%rdx
  100814:	74 12                	je     100828 <memmove+0x24>
            *d++ = *s++;
  100816:	0f b6 3c 0e          	movzbl (%rsi,%rcx,1),%edi
  10081a:	40 88 3c 08          	mov    %dil,(%rax,%rcx,1)
        while (n-- > 0) {
  10081e:	48 83 c1 01          	add    $0x1,%rcx
  100822:	48 39 ca             	cmp    %rcx,%rdx
  100825:	75 ef                	jne    100816 <memmove+0x12>
}
  100827:	c3                   	retq   
  100828:	c3                   	retq   
    if (s < d && s + n > d) {
  100829:	48 8d 0c 16          	lea    (%rsi,%rdx,1),%rcx
  10082d:	48 39 cf             	cmp    %rcx,%rdi
  100830:	73 da                	jae    10080c <memmove+0x8>
        while (n-- > 0) {
  100832:	48 8d 4a ff          	lea    -0x1(%rdx),%rcx
  100836:	48 85 d2             	test   %rdx,%rdx
  100839:	74 ec                	je     100827 <memmove+0x23>
            *--d = *--s;
  10083b:	0f b6 14 0e          	movzbl (%rsi,%rcx,1),%edx
  10083f:	88 14 08             	mov    %dl,(%rax,%rcx,1)
        while (n-- > 0) {
  100842:	48 83 e9 01          	sub    $0x1,%rcx
  100846:	48 83 f9 ff          	cmp    $0xffffffffffffffff,%rcx
  10084a:	75 ef                	jne    10083b <memmove+0x37>
  10084c:	c3                   	retq   

000000000010084d <memset>:
void* memset(void* v, int c, size_t n) {
  10084d:	48 89 f8             	mov    %rdi,%rax
    for (char* p = (char*) v; n > 0; ++p, --n) {
  100850:	48 85 d2             	test   %rdx,%rdx
  100853:	74 12                	je     100867 <memset+0x1a>
  100855:	48 01 fa             	add    %rdi,%rdx
  100858:	48 89 f9             	mov    %rdi,%rcx
        *p = c;
  10085b:	40 88 31             	mov    %sil,(%rcx)
    for (char* p = (char*) v; n > 0; ++p, --n) {
  10085e:	48 83 c1 01          	add    $0x1,%rcx
  100862:	48 39 ca             	cmp    %rcx,%rdx
  100865:	75 f4                	jne    10085b <memset+0xe>
}
  100867:	c3                   	retq   

0000000000100868 <strlen>:
    for (n = 0; *s != '\0'; ++s) {
  100868:	80 3f 00             	cmpb   $0x0,(%rdi)
  10086b:	74 10                	je     10087d <strlen+0x15>
  10086d:	b8 00 00 00 00       	mov    $0x0,%eax
        ++n;
  100872:	48 83 c0 01          	add    $0x1,%rax
    for (n = 0; *s != '\0'; ++s) {
  100876:	80 3c 07 00          	cmpb   $0x0,(%rdi,%rax,1)
  10087a:	75 f6                	jne    100872 <strlen+0xa>
  10087c:	c3                   	retq   
  10087d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100882:	c3                   	retq   

0000000000100883 <strnlen>:
size_t strnlen(const char* s, size_t maxlen) {
  100883:	48 89 f0             	mov    %rsi,%rax
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
  100886:	ba 00 00 00 00       	mov    $0x0,%edx
  10088b:	48 85 f6             	test   %rsi,%rsi
  10088e:	74 11                	je     1008a1 <strnlen+0x1e>
  100890:	80 3c 17 00          	cmpb   $0x0,(%rdi,%rdx,1)
  100894:	74 0c                	je     1008a2 <strnlen+0x1f>
        ++n;
  100896:	48 83 c2 01          	add    $0x1,%rdx
    for (n = 0; n != maxlen && *s != '\0'; ++s) {
  10089a:	48 39 d0             	cmp    %rdx,%rax
  10089d:	75 f1                	jne    100890 <strnlen+0xd>
  10089f:	eb 04                	jmp    1008a5 <strnlen+0x22>
  1008a1:	c3                   	retq   
  1008a2:	48 89 d0             	mov    %rdx,%rax
}
  1008a5:	c3                   	retq   

00000000001008a6 <strcpy>:
char* strcpy(char* dst, const char* src) {
  1008a6:	48 89 f8             	mov    %rdi,%rax
  1008a9:	ba 00 00 00 00       	mov    $0x0,%edx
        *d++ = *src++;
  1008ae:	0f b6 0c 16          	movzbl (%rsi,%rdx,1),%ecx
  1008b2:	88 0c 10             	mov    %cl,(%rax,%rdx,1)
    } while (d[-1]);
  1008b5:	48 83 c2 01          	add    $0x1,%rdx
  1008b9:	84 c9                	test   %cl,%cl
  1008bb:	75 f1                	jne    1008ae <strcpy+0x8>
}
  1008bd:	c3                   	retq   

00000000001008be <strcmp>:
    while (*a && *b && *a == *b) {
  1008be:	0f b6 07             	movzbl (%rdi),%eax
  1008c1:	84 c0                	test   %al,%al
  1008c3:	74 1a                	je     1008df <strcmp+0x21>
  1008c5:	0f b6 16             	movzbl (%rsi),%edx
  1008c8:	38 c2                	cmp    %al,%dl
  1008ca:	75 13                	jne    1008df <strcmp+0x21>
  1008cc:	84 d2                	test   %dl,%dl
  1008ce:	74 0f                	je     1008df <strcmp+0x21>
        ++a, ++b;
  1008d0:	48 83 c7 01          	add    $0x1,%rdi
  1008d4:	48 83 c6 01          	add    $0x1,%rsi
    while (*a && *b && *a == *b) {
  1008d8:	0f b6 07             	movzbl (%rdi),%eax
  1008db:	84 c0                	test   %al,%al
  1008dd:	75 e6                	jne    1008c5 <strcmp+0x7>
    return ((unsigned char) *a > (unsigned char) *b)
  1008df:	3a 06                	cmp    (%rsi),%al
  1008e1:	0f 97 c0             	seta   %al
  1008e4:	0f b6 c0             	movzbl %al,%eax
        - ((unsigned char) *a < (unsigned char) *b);
  1008e7:	83 d8 00             	sbb    $0x0,%eax
}
  1008ea:	c3                   	retq   

00000000001008eb <strchr>:
    while (*s && *s != (char) c) {
  1008eb:	0f b6 07             	movzbl (%rdi),%eax
  1008ee:	84 c0                	test   %al,%al
  1008f0:	74 10                	je     100902 <strchr+0x17>
  1008f2:	40 38 f0             	cmp    %sil,%al
  1008f5:	74 18                	je     10090f <strchr+0x24>
        ++s;
  1008f7:	48 83 c7 01          	add    $0x1,%rdi
    while (*s && *s != (char) c) {
  1008fb:	0f b6 07             	movzbl (%rdi),%eax
  1008fe:	84 c0                	test   %al,%al
  100900:	75 f0                	jne    1008f2 <strchr+0x7>
        return NULL;
  100902:	40 84 f6             	test   %sil,%sil
  100905:	b8 00 00 00 00       	mov    $0x0,%eax
  10090a:	48 0f 44 c7          	cmove  %rdi,%rax
}
  10090e:	c3                   	retq   
  10090f:	48 89 f8             	mov    %rdi,%rax
  100912:	c3                   	retq   

0000000000100913 <rand>:
    if (!rand_seed_set) {
  100913:	83 3d 0e 27 00 00 00 	cmpl   $0x0,0x270e(%rip)        # 103028 <rand_seed_set>
  10091a:	74 1b                	je     100937 <rand+0x24>
    rand_seed = rand_seed * 1664525U + 1013904223U;
  10091c:	69 05 fe 26 00 00 0d 	imul   $0x19660d,0x26fe(%rip),%eax        # 103024 <rand_seed>
  100923:	66 19 00 
  100926:	05 5f f3 6e 3c       	add    $0x3c6ef35f,%eax
  10092b:	89 05 f3 26 00 00    	mov    %eax,0x26f3(%rip)        # 103024 <rand_seed>
    return rand_seed & RAND_MAX;
  100931:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
}
  100936:	c3                   	retq   
    rand_seed = seed;
  100937:	c7 05 e3 26 00 00 9e 	movl   $0x30d4879e,0x26e3(%rip)        # 103024 <rand_seed>
  10093e:	87 d4 30 
    rand_seed_set = 1;
  100941:	c7 05 dd 26 00 00 01 	movl   $0x1,0x26dd(%rip)        # 103028 <rand_seed_set>
  100948:	00 00 00 
}
  10094b:	eb cf                	jmp    10091c <rand+0x9>

000000000010094d <srand>:
    rand_seed = seed;
  10094d:	89 3d d1 26 00 00    	mov    %edi,0x26d1(%rip)        # 103024 <rand_seed>
    rand_seed_set = 1;
  100953:	c7 05 cb 26 00 00 01 	movl   $0x1,0x26cb(%rip)        # 103028 <rand_seed_set>
  10095a:	00 00 00 
}
  10095d:	c3                   	retq   

000000000010095e <printer_vprintf>:
void printer_vprintf(printer* p, int color, const char* format, va_list val) {
  10095e:	55                   	push   %rbp
  10095f:	48 89 e5             	mov    %rsp,%rbp
  100962:	41 57                	push   %r15
  100964:	41 56                	push   %r14
  100966:	41 55                	push   %r13
  100968:	41 54                	push   %r12
  10096a:	53                   	push   %rbx
  10096b:	48 83 ec 58          	sub    $0x58,%rsp
  10096f:	48 89 4d 90          	mov    %rcx,-0x70(%rbp)
    for (; *format; ++format) {
  100973:	0f b6 02             	movzbl (%rdx),%eax
  100976:	84 c0                	test   %al,%al
  100978:	0f 84 b0 06 00 00    	je     10102e <printer_vprintf+0x6d0>
  10097e:	49 89 fe             	mov    %rdi,%r14
  100981:	49 89 d4             	mov    %rdx,%r12
            length = 1;
  100984:	41 89 f7             	mov    %esi,%r15d
  100987:	e9 a4 04 00 00       	jmpq   100e30 <printer_vprintf+0x4d2>
        for (++format; *format; ++format) {
  10098c:	49 8d 5c 24 01       	lea    0x1(%r12),%rbx
  100991:	45 0f b6 64 24 01    	movzbl 0x1(%r12),%r12d
  100997:	45 84 e4             	test   %r12b,%r12b
  10099a:	0f 84 82 06 00 00    	je     101022 <printer_vprintf+0x6c4>
        int flags = 0;
  1009a0:	41 bd 00 00 00 00    	mov    $0x0,%r13d
            const char* flagc = strchr(flag_chars, *format);
  1009a6:	41 0f be f4          	movsbl %r12b,%esi
  1009aa:	bf 01 21 10 00       	mov    $0x102101,%edi
  1009af:	e8 37 ff ff ff       	callq  1008eb <strchr>
  1009b4:	48 89 c1             	mov    %rax,%rcx
            if (flagc) {
  1009b7:	48 85 c0             	test   %rax,%rax
  1009ba:	74 55                	je     100a11 <printer_vprintf+0xb3>
                flags |= 1 << (flagc - flag_chars);
  1009bc:	48 81 e9 01 21 10 00 	sub    $0x102101,%rcx
  1009c3:	b8 01 00 00 00       	mov    $0x1,%eax
  1009c8:	d3 e0                	shl    %cl,%eax
  1009ca:	41 09 c5             	or     %eax,%r13d
        for (++format; *format; ++format) {
  1009cd:	48 83 c3 01          	add    $0x1,%rbx
  1009d1:	44 0f b6 23          	movzbl (%rbx),%r12d
  1009d5:	45 84 e4             	test   %r12b,%r12b
  1009d8:	75 cc                	jne    1009a6 <printer_vprintf+0x48>
  1009da:	44 89 6d a8          	mov    %r13d,-0x58(%rbp)
        int width = -1;
  1009de:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
        int precision = -1;
  1009e4:	c7 45 9c ff ff ff ff 	movl   $0xffffffff,-0x64(%rbp)
        if (*format == '.') {
  1009eb:	80 3b 2e             	cmpb   $0x2e,(%rbx)
  1009ee:	0f 84 a9 00 00 00    	je     100a9d <printer_vprintf+0x13f>
        int length = 0;
  1009f4:	b9 00 00 00 00       	mov    $0x0,%ecx
        switch (*format) {
  1009f9:	0f b6 13             	movzbl (%rbx),%edx
  1009fc:	8d 42 bd             	lea    -0x43(%rdx),%eax
  1009ff:	3c 37                	cmp    $0x37,%al
  100a01:	0f 87 c4 04 00 00    	ja     100ecb <printer_vprintf+0x56d>
  100a07:	0f b6 c0             	movzbl %al,%eax
  100a0a:	ff 24 c5 10 1f 10 00 	jmpq   *0x101f10(,%rax,8)
        if (*format >= '1' && *format <= '9') {
  100a11:	44 89 6d a8          	mov    %r13d,-0x58(%rbp)
  100a15:	41 8d 44 24 cf       	lea    -0x31(%r12),%eax
  100a1a:	3c 08                	cmp    $0x8,%al
  100a1c:	77 2f                	ja     100a4d <printer_vprintf+0xef>
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  100a1e:	0f b6 03             	movzbl (%rbx),%eax
  100a21:	8d 50 d0             	lea    -0x30(%rax),%edx
  100a24:	80 fa 09             	cmp    $0x9,%dl
  100a27:	77 5e                	ja     100a87 <printer_vprintf+0x129>
  100a29:	41 bd 00 00 00 00    	mov    $0x0,%r13d
                width = 10 * width + *format++ - '0';
  100a2f:	48 83 c3 01          	add    $0x1,%rbx
  100a33:	43 8d 54 ad 00       	lea    0x0(%r13,%r13,4),%edx
  100a38:	0f be c0             	movsbl %al,%eax
  100a3b:	44 8d 6c 50 d0       	lea    -0x30(%rax,%rdx,2),%r13d
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  100a40:	0f b6 03             	movzbl (%rbx),%eax
  100a43:	8d 50 d0             	lea    -0x30(%rax),%edx
  100a46:	80 fa 09             	cmp    $0x9,%dl
  100a49:	76 e4                	jbe    100a2f <printer_vprintf+0xd1>
  100a4b:	eb 97                	jmp    1009e4 <printer_vprintf+0x86>
        } else if (*format == '*') {
  100a4d:	41 80 fc 2a          	cmp    $0x2a,%r12b
  100a51:	75 3f                	jne    100a92 <printer_vprintf+0x134>
            width = va_arg(val, int);
  100a53:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  100a57:	8b 07                	mov    (%rdi),%eax
  100a59:	83 f8 2f             	cmp    $0x2f,%eax
  100a5c:	77 17                	ja     100a75 <printer_vprintf+0x117>
  100a5e:	89 c2                	mov    %eax,%edx
  100a60:	48 03 57 10          	add    0x10(%rdi),%rdx
  100a64:	83 c0 08             	add    $0x8,%eax
  100a67:	89 07                	mov    %eax,(%rdi)
  100a69:	44 8b 2a             	mov    (%rdx),%r13d
            ++format;
  100a6c:	48 83 c3 01          	add    $0x1,%rbx
  100a70:	e9 6f ff ff ff       	jmpq   1009e4 <printer_vprintf+0x86>
            width = va_arg(val, int);
  100a75:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  100a79:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  100a7d:	48 8d 42 08          	lea    0x8(%rdx),%rax
  100a81:	48 89 41 08          	mov    %rax,0x8(%rcx)
  100a85:	eb e2                	jmp    100a69 <printer_vprintf+0x10b>
            for (width = 0; *format >= '0' && *format <= '9'; ) {
  100a87:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  100a8d:	e9 52 ff ff ff       	jmpq   1009e4 <printer_vprintf+0x86>
        int width = -1;
  100a92:	41 bd ff ff ff ff    	mov    $0xffffffff,%r13d
  100a98:	e9 47 ff ff ff       	jmpq   1009e4 <printer_vprintf+0x86>
            ++format;
  100a9d:	48 8d 53 01          	lea    0x1(%rbx),%rdx
            if (*format >= '0' && *format <= '9') {
  100aa1:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  100aa5:	8d 48 d0             	lea    -0x30(%rax),%ecx
  100aa8:	80 f9 09             	cmp    $0x9,%cl
  100aab:	76 13                	jbe    100ac0 <printer_vprintf+0x162>
            } else if (*format == '*') {
  100aad:	3c 2a                	cmp    $0x2a,%al
  100aaf:	74 33                	je     100ae4 <printer_vprintf+0x186>
            ++format;
  100ab1:	48 89 d3             	mov    %rdx,%rbx
                precision = 0;
  100ab4:	c7 45 9c 00 00 00 00 	movl   $0x0,-0x64(%rbp)
  100abb:	e9 34 ff ff ff       	jmpq   1009f4 <printer_vprintf+0x96>
                for (precision = 0; *format >= '0' && *format <= '9'; ) {
  100ac0:	b9 00 00 00 00       	mov    $0x0,%ecx
                    precision = 10 * precision + *format++ - '0';
  100ac5:	48 83 c2 01          	add    $0x1,%rdx
  100ac9:	8d 0c 89             	lea    (%rcx,%rcx,4),%ecx
  100acc:	0f be c0             	movsbl %al,%eax
  100acf:	8d 4c 48 d0          	lea    -0x30(%rax,%rcx,2),%ecx
                for (precision = 0; *format >= '0' && *format <= '9'; ) {
  100ad3:	0f b6 02             	movzbl (%rdx),%eax
  100ad6:	8d 70 d0             	lea    -0x30(%rax),%esi
  100ad9:	40 80 fe 09          	cmp    $0x9,%sil
  100add:	76 e6                	jbe    100ac5 <printer_vprintf+0x167>
                    precision = 10 * precision + *format++ - '0';
  100adf:	48 89 d3             	mov    %rdx,%rbx
  100ae2:	eb 1c                	jmp    100b00 <printer_vprintf+0x1a2>
                precision = va_arg(val, int);
  100ae4:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  100ae8:	8b 07                	mov    (%rdi),%eax
  100aea:	83 f8 2f             	cmp    $0x2f,%eax
  100aed:	77 23                	ja     100b12 <printer_vprintf+0x1b4>
  100aef:	89 c2                	mov    %eax,%edx
  100af1:	48 03 57 10          	add    0x10(%rdi),%rdx
  100af5:	83 c0 08             	add    $0x8,%eax
  100af8:	89 07                	mov    %eax,(%rdi)
  100afa:	8b 0a                	mov    (%rdx),%ecx
                ++format;
  100afc:	48 83 c3 02          	add    $0x2,%rbx
            if (precision < 0) {
  100b00:	85 c9                	test   %ecx,%ecx
  100b02:	b8 00 00 00 00       	mov    $0x0,%eax
  100b07:	0f 49 c1             	cmovns %ecx,%eax
  100b0a:	89 45 9c             	mov    %eax,-0x64(%rbp)
  100b0d:	e9 e2 fe ff ff       	jmpq   1009f4 <printer_vprintf+0x96>
                precision = va_arg(val, int);
  100b12:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  100b16:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  100b1a:	48 8d 42 08          	lea    0x8(%rdx),%rax
  100b1e:	48 89 41 08          	mov    %rax,0x8(%rcx)
  100b22:	eb d6                	jmp    100afa <printer_vprintf+0x19c>
        switch (*format) {
  100b24:	be f0 ff ff ff       	mov    $0xfffffff0,%esi
  100b29:	e9 f3 00 00 00       	jmpq   100c21 <printer_vprintf+0x2c3>
            ++format;
  100b2e:	48 83 c3 01          	add    $0x1,%rbx
            length = 1;
  100b32:	b9 01 00 00 00       	mov    $0x1,%ecx
            goto again;
  100b37:	e9 bd fe ff ff       	jmpq   1009f9 <printer_vprintf+0x9b>
            long x = length ? va_arg(val, long) : va_arg(val, int);
  100b3c:	85 c9                	test   %ecx,%ecx
  100b3e:	74 55                	je     100b95 <printer_vprintf+0x237>
  100b40:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  100b44:	8b 07                	mov    (%rdi),%eax
  100b46:	83 f8 2f             	cmp    $0x2f,%eax
  100b49:	77 38                	ja     100b83 <printer_vprintf+0x225>
  100b4b:	89 c2                	mov    %eax,%edx
  100b4d:	48 03 57 10          	add    0x10(%rdi),%rdx
  100b51:	83 c0 08             	add    $0x8,%eax
  100b54:	89 07                	mov    %eax,(%rdi)
  100b56:	48 8b 12             	mov    (%rdx),%rdx
            int negative = x < 0 ? FLAG_NEGATIVE : 0;
  100b59:	48 89 d0             	mov    %rdx,%rax
  100b5c:	48 c1 f8 38          	sar    $0x38,%rax
            num = negative ? -x : x;
  100b60:	49 89 d0             	mov    %rdx,%r8
  100b63:	49 f7 d8             	neg    %r8
  100b66:	25 80 00 00 00       	and    $0x80,%eax
  100b6b:	4c 0f 44 c2          	cmove  %rdx,%r8
            flags |= FLAG_NUMERIC | FLAG_SIGNED | negative;
  100b6f:	0b 45 a8             	or     -0x58(%rbp),%eax
  100b72:	83 c8 60             	or     $0x60,%eax
  100b75:	89 45 a8             	mov    %eax,-0x58(%rbp)
        char* data = "";
  100b78:	41 bc b8 1e 10 00    	mov    $0x101eb8,%r12d
            break;
  100b7e:	e9 35 01 00 00       	jmpq   100cb8 <printer_vprintf+0x35a>
            long x = length ? va_arg(val, long) : va_arg(val, int);
  100b83:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  100b87:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  100b8b:	48 8d 42 08          	lea    0x8(%rdx),%rax
  100b8f:	48 89 41 08          	mov    %rax,0x8(%rcx)
  100b93:	eb c1                	jmp    100b56 <printer_vprintf+0x1f8>
  100b95:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  100b99:	8b 07                	mov    (%rdi),%eax
  100b9b:	83 f8 2f             	cmp    $0x2f,%eax
  100b9e:	77 10                	ja     100bb0 <printer_vprintf+0x252>
  100ba0:	89 c2                	mov    %eax,%edx
  100ba2:	48 03 57 10          	add    0x10(%rdi),%rdx
  100ba6:	83 c0 08             	add    $0x8,%eax
  100ba9:	89 07                	mov    %eax,(%rdi)
  100bab:	48 63 12             	movslq (%rdx),%rdx
  100bae:	eb a9                	jmp    100b59 <printer_vprintf+0x1fb>
  100bb0:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  100bb4:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  100bb8:	48 8d 42 08          	lea    0x8(%rdx),%rax
  100bbc:	48 89 47 08          	mov    %rax,0x8(%rdi)
  100bc0:	eb e9                	jmp    100bab <printer_vprintf+0x24d>
        int base = 10;
  100bc2:	be 0a 00 00 00       	mov    $0xa,%esi
  100bc7:	eb 58                	jmp    100c21 <printer_vprintf+0x2c3>
            num = length ? va_arg(val, unsigned long) : va_arg(val, unsigned);
  100bc9:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  100bcd:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  100bd1:	48 8d 42 08          	lea    0x8(%rdx),%rax
  100bd5:	48 89 41 08          	mov    %rax,0x8(%rcx)
  100bd9:	eb 60                	jmp    100c3b <printer_vprintf+0x2dd>
  100bdb:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  100bdf:	8b 07                	mov    (%rdi),%eax
  100be1:	83 f8 2f             	cmp    $0x2f,%eax
  100be4:	77 10                	ja     100bf6 <printer_vprintf+0x298>
  100be6:	89 c2                	mov    %eax,%edx
  100be8:	48 03 57 10          	add    0x10(%rdi),%rdx
  100bec:	83 c0 08             	add    $0x8,%eax
  100bef:	89 07                	mov    %eax,(%rdi)
  100bf1:	44 8b 02             	mov    (%rdx),%r8d
  100bf4:	eb 48                	jmp    100c3e <printer_vprintf+0x2e0>
  100bf6:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  100bfa:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  100bfe:	48 8d 42 08          	lea    0x8(%rdx),%rax
  100c02:	48 89 41 08          	mov    %rax,0x8(%rcx)
  100c06:	eb e9                	jmp    100bf1 <printer_vprintf+0x293>
  100c08:	41 89 f1             	mov    %esi,%r9d
        if (flags & FLAG_NUMERIC) {
  100c0b:	c7 45 8c 20 00 00 00 	movl   $0x20,-0x74(%rbp)
    const char* digits = upper_digits;
  100c12:	bf f0 20 10 00       	mov    $0x1020f0,%edi
  100c17:	e9 e2 02 00 00       	jmpq   100efe <printer_vprintf+0x5a0>
            base = 16;
  100c1c:	be 10 00 00 00       	mov    $0x10,%esi
            num = length ? va_arg(val, unsigned long) : va_arg(val, unsigned);
  100c21:	85 c9                	test   %ecx,%ecx
  100c23:	74 b6                	je     100bdb <printer_vprintf+0x27d>
  100c25:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  100c29:	8b 01                	mov    (%rcx),%eax
  100c2b:	83 f8 2f             	cmp    $0x2f,%eax
  100c2e:	77 99                	ja     100bc9 <printer_vprintf+0x26b>
  100c30:	89 c2                	mov    %eax,%edx
  100c32:	48 03 51 10          	add    0x10(%rcx),%rdx
  100c36:	83 c0 08             	add    $0x8,%eax
  100c39:	89 01                	mov    %eax,(%rcx)
  100c3b:	4c 8b 02             	mov    (%rdx),%r8
            flags |= FLAG_NUMERIC;
  100c3e:	83 4d a8 20          	orl    $0x20,-0x58(%rbp)
    if (base < 0) {
  100c42:	85 f6                	test   %esi,%esi
  100c44:	79 c2                	jns    100c08 <printer_vprintf+0x2aa>
        base = -base;
  100c46:	41 89 f1             	mov    %esi,%r9d
  100c49:	f7 de                	neg    %esi
  100c4b:	c7 45 8c 20 00 00 00 	movl   $0x20,-0x74(%rbp)
        digits = lower_digits;
  100c52:	bf d0 20 10 00       	mov    $0x1020d0,%edi
  100c57:	e9 a2 02 00 00       	jmpq   100efe <printer_vprintf+0x5a0>
            num = (uintptr_t) va_arg(val, void*);
  100c5c:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  100c60:	8b 07                	mov    (%rdi),%eax
  100c62:	83 f8 2f             	cmp    $0x2f,%eax
  100c65:	77 1c                	ja     100c83 <printer_vprintf+0x325>
  100c67:	89 c2                	mov    %eax,%edx
  100c69:	48 03 57 10          	add    0x10(%rdi),%rdx
  100c6d:	83 c0 08             	add    $0x8,%eax
  100c70:	89 07                	mov    %eax,(%rdi)
  100c72:	4c 8b 02             	mov    (%rdx),%r8
            flags |= FLAG_ALT | FLAG_ALT2 | FLAG_NUMERIC;
  100c75:	81 4d a8 21 01 00 00 	orl    $0x121,-0x58(%rbp)
            base = -16;
  100c7c:	be f0 ff ff ff       	mov    $0xfffffff0,%esi
  100c81:	eb c3                	jmp    100c46 <printer_vprintf+0x2e8>
            num = (uintptr_t) va_arg(val, void*);
  100c83:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  100c87:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  100c8b:	48 8d 42 08          	lea    0x8(%rdx),%rax
  100c8f:	48 89 41 08          	mov    %rax,0x8(%rcx)
  100c93:	eb dd                	jmp    100c72 <printer_vprintf+0x314>
            data = va_arg(val, char*);
  100c95:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  100c99:	8b 01                	mov    (%rcx),%eax
  100c9b:	83 f8 2f             	cmp    $0x2f,%eax
  100c9e:	0f 87 a5 01 00 00    	ja     100e49 <printer_vprintf+0x4eb>
  100ca4:	89 c2                	mov    %eax,%edx
  100ca6:	48 03 51 10          	add    0x10(%rcx),%rdx
  100caa:	83 c0 08             	add    $0x8,%eax
  100cad:	89 01                	mov    %eax,(%rcx)
  100caf:	4c 8b 22             	mov    (%rdx),%r12
        unsigned long num = 0;
  100cb2:	41 b8 00 00 00 00    	mov    $0x0,%r8d
        if (flags & FLAG_NUMERIC) {
  100cb8:	8b 45 a8             	mov    -0x58(%rbp),%eax
  100cbb:	83 e0 20             	and    $0x20,%eax
  100cbe:	89 45 8c             	mov    %eax,-0x74(%rbp)
  100cc1:	41 b9 0a 00 00 00    	mov    $0xa,%r9d
  100cc7:	0f 85 21 02 00 00    	jne    100eee <printer_vprintf+0x590>
        if ((flags & FLAG_NUMERIC) && (flags & FLAG_SIGNED)) {
  100ccd:	8b 45 a8             	mov    -0x58(%rbp),%eax
  100cd0:	89 45 88             	mov    %eax,-0x78(%rbp)
  100cd3:	83 e0 60             	and    $0x60,%eax
  100cd6:	83 f8 60             	cmp    $0x60,%eax
  100cd9:	0f 84 54 02 00 00    	je     100f33 <printer_vprintf+0x5d5>
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ALT)
  100cdf:	8b 45 a8             	mov    -0x58(%rbp),%eax
  100ce2:	83 e0 21             	and    $0x21,%eax
        const char* prefix = "";
  100ce5:	48 c7 45 a0 b8 1e 10 	movq   $0x101eb8,-0x60(%rbp)
  100cec:	00 
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ALT)
  100ced:	83 f8 21             	cmp    $0x21,%eax
  100cf0:	0f 84 79 02 00 00    	je     100f6f <printer_vprintf+0x611>
        if (precision >= 0 && !(flags & FLAG_NUMERIC)) {
  100cf6:	8b 7d 9c             	mov    -0x64(%rbp),%edi
  100cf9:	89 f8                	mov    %edi,%eax
  100cfb:	f7 d0                	not    %eax
  100cfd:	c1 e8 1f             	shr    $0x1f,%eax
  100d00:	89 45 84             	mov    %eax,-0x7c(%rbp)
  100d03:	83 7d 8c 00          	cmpl   $0x0,-0x74(%rbp)
  100d07:	0f 85 9e 02 00 00    	jne    100fab <printer_vprintf+0x64d>
  100d0d:	84 c0                	test   %al,%al
  100d0f:	0f 84 96 02 00 00    	je     100fab <printer_vprintf+0x64d>
            len = strnlen(data, precision);
  100d15:	48 63 f7             	movslq %edi,%rsi
  100d18:	4c 89 e7             	mov    %r12,%rdi
  100d1b:	e8 63 fb ff ff       	callq  100883 <strnlen>
  100d20:	89 45 98             	mov    %eax,-0x68(%rbp)
                   && !(flags & FLAG_LEFTJUSTIFY)
  100d23:	8b 45 88             	mov    -0x78(%rbp),%eax
  100d26:	83 e0 26             	and    $0x26,%eax
            zeros = 0;
  100d29:	c7 45 9c 00 00 00 00 	movl   $0x0,-0x64(%rbp)
        } else if ((flags & FLAG_NUMERIC) && (flags & FLAG_ZERO)
  100d30:	83 f8 22             	cmp    $0x22,%eax
  100d33:	0f 84 aa 02 00 00    	je     100fe3 <printer_vprintf+0x685>
        width -= len + zeros + strlen(prefix);
  100d39:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  100d3d:	e8 26 fb ff ff       	callq  100868 <strlen>
  100d42:	8b 55 9c             	mov    -0x64(%rbp),%edx
  100d45:	03 55 98             	add    -0x68(%rbp),%edx
  100d48:	44 89 e9             	mov    %r13d,%ecx
  100d4b:	29 d1                	sub    %edx,%ecx
  100d4d:	29 c1                	sub    %eax,%ecx
  100d4f:	89 4d 8c             	mov    %ecx,-0x74(%rbp)
  100d52:	41 89 cd             	mov    %ecx,%r13d
        for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width) {
  100d55:	f6 45 a8 04          	testb  $0x4,-0x58(%rbp)
  100d59:	75 2d                	jne    100d88 <printer_vprintf+0x42a>
  100d5b:	85 c9                	test   %ecx,%ecx
  100d5d:	7e 29                	jle    100d88 <printer_vprintf+0x42a>
            p->putc(p, ' ', color);
  100d5f:	44 89 fa             	mov    %r15d,%edx
  100d62:	be 20 00 00 00       	mov    $0x20,%esi
  100d67:	4c 89 f7             	mov    %r14,%rdi
  100d6a:	41 ff 16             	callq  *(%r14)
        for (; !(flags & FLAG_LEFTJUSTIFY) && width > 0; --width) {
  100d6d:	41 83 ed 01          	sub    $0x1,%r13d
  100d71:	45 85 ed             	test   %r13d,%r13d
  100d74:	7f e9                	jg     100d5f <printer_vprintf+0x401>
  100d76:	8b 7d 8c             	mov    -0x74(%rbp),%edi
  100d79:	85 ff                	test   %edi,%edi
  100d7b:	b8 01 00 00 00       	mov    $0x1,%eax
  100d80:	0f 4f c7             	cmovg  %edi,%eax
  100d83:	29 c7                	sub    %eax,%edi
  100d85:	41 89 fd             	mov    %edi,%r13d
        for (; *prefix; ++prefix) {
  100d88:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  100d8c:	0f b6 07             	movzbl (%rdi),%eax
  100d8f:	84 c0                	test   %al,%al
  100d91:	74 22                	je     100db5 <printer_vprintf+0x457>
  100d93:	48 89 5d a8          	mov    %rbx,-0x58(%rbp)
  100d97:	48 89 fb             	mov    %rdi,%rbx
            p->putc(p, *prefix, color);
  100d9a:	0f b6 f0             	movzbl %al,%esi
  100d9d:	44 89 fa             	mov    %r15d,%edx
  100da0:	4c 89 f7             	mov    %r14,%rdi
  100da3:	41 ff 16             	callq  *(%r14)
        for (; *prefix; ++prefix) {
  100da6:	48 83 c3 01          	add    $0x1,%rbx
  100daa:	0f b6 03             	movzbl (%rbx),%eax
  100dad:	84 c0                	test   %al,%al
  100daf:	75 e9                	jne    100d9a <printer_vprintf+0x43c>
  100db1:	48 8b 5d a8          	mov    -0x58(%rbp),%rbx
        for (; zeros > 0; --zeros) {
  100db5:	8b 45 9c             	mov    -0x64(%rbp),%eax
  100db8:	85 c0                	test   %eax,%eax
  100dba:	7e 1d                	jle    100dd9 <printer_vprintf+0x47b>
  100dbc:	48 89 5d a8          	mov    %rbx,-0x58(%rbp)
  100dc0:	89 c3                	mov    %eax,%ebx
            p->putc(p, '0', color);
  100dc2:	44 89 fa             	mov    %r15d,%edx
  100dc5:	be 30 00 00 00       	mov    $0x30,%esi
  100dca:	4c 89 f7             	mov    %r14,%rdi
  100dcd:	41 ff 16             	callq  *(%r14)
        for (; zeros > 0; --zeros) {
  100dd0:	83 eb 01             	sub    $0x1,%ebx
  100dd3:	75 ed                	jne    100dc2 <printer_vprintf+0x464>
  100dd5:	48 8b 5d a8          	mov    -0x58(%rbp),%rbx
        for (; len > 0; ++data, --len) {
  100dd9:	8b 45 98             	mov    -0x68(%rbp),%eax
  100ddc:	85 c0                	test   %eax,%eax
  100dde:	7e 27                	jle    100e07 <printer_vprintf+0x4a9>
  100de0:	89 c0                	mov    %eax,%eax
  100de2:	4c 01 e0             	add    %r12,%rax
  100de5:	48 89 5d a8          	mov    %rbx,-0x58(%rbp)
  100de9:	48 89 c3             	mov    %rax,%rbx
            p->putc(p, *data, color);
  100dec:	41 0f b6 34 24       	movzbl (%r12),%esi
  100df1:	44 89 fa             	mov    %r15d,%edx
  100df4:	4c 89 f7             	mov    %r14,%rdi
  100df7:	41 ff 16             	callq  *(%r14)
        for (; len > 0; ++data, --len) {
  100dfa:	49 83 c4 01          	add    $0x1,%r12
  100dfe:	49 39 dc             	cmp    %rbx,%r12
  100e01:	75 e9                	jne    100dec <printer_vprintf+0x48e>
  100e03:	48 8b 5d a8          	mov    -0x58(%rbp),%rbx
        for (; width > 0; --width) {
  100e07:	45 85 ed             	test   %r13d,%r13d
  100e0a:	7e 14                	jle    100e20 <printer_vprintf+0x4c2>
            p->putc(p, ' ', color);
  100e0c:	44 89 fa             	mov    %r15d,%edx
  100e0f:	be 20 00 00 00       	mov    $0x20,%esi
  100e14:	4c 89 f7             	mov    %r14,%rdi
  100e17:	41 ff 16             	callq  *(%r14)
        for (; width > 0; --width) {
  100e1a:	41 83 ed 01          	sub    $0x1,%r13d
  100e1e:	75 ec                	jne    100e0c <printer_vprintf+0x4ae>
    for (; *format; ++format) {
  100e20:	4c 8d 63 01          	lea    0x1(%rbx),%r12
  100e24:	0f b6 43 01          	movzbl 0x1(%rbx),%eax
  100e28:	84 c0                	test   %al,%al
  100e2a:	0f 84 fe 01 00 00    	je     10102e <printer_vprintf+0x6d0>
        if (*format != '%') {
  100e30:	3c 25                	cmp    $0x25,%al
  100e32:	0f 84 54 fb ff ff    	je     10098c <printer_vprintf+0x2e>
            p->putc(p, *format, color);
  100e38:	0f b6 f0             	movzbl %al,%esi
  100e3b:	44 89 fa             	mov    %r15d,%edx
  100e3e:	4c 89 f7             	mov    %r14,%rdi
  100e41:	41 ff 16             	callq  *(%r14)
            continue;
  100e44:	4c 89 e3             	mov    %r12,%rbx
  100e47:	eb d7                	jmp    100e20 <printer_vprintf+0x4c2>
            data = va_arg(val, char*);
  100e49:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  100e4d:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  100e51:	48 8d 42 08          	lea    0x8(%rdx),%rax
  100e55:	48 89 47 08          	mov    %rax,0x8(%rdi)
  100e59:	e9 51 fe ff ff       	jmpq   100caf <printer_vprintf+0x351>
            color = va_arg(val, int);
  100e5e:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  100e62:	8b 07                	mov    (%rdi),%eax
  100e64:	83 f8 2f             	cmp    $0x2f,%eax
  100e67:	77 10                	ja     100e79 <printer_vprintf+0x51b>
  100e69:	89 c2                	mov    %eax,%edx
  100e6b:	48 03 57 10          	add    0x10(%rdi),%rdx
  100e6f:	83 c0 08             	add    $0x8,%eax
  100e72:	89 07                	mov    %eax,(%rdi)
  100e74:	44 8b 3a             	mov    (%rdx),%r15d
            goto done;
  100e77:	eb a7                	jmp    100e20 <printer_vprintf+0x4c2>
            color = va_arg(val, int);
  100e79:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  100e7d:	48 8b 51 08          	mov    0x8(%rcx),%rdx
  100e81:	48 8d 42 08          	lea    0x8(%rdx),%rax
  100e85:	48 89 41 08          	mov    %rax,0x8(%rcx)
  100e89:	eb e9                	jmp    100e74 <printer_vprintf+0x516>
            numbuf[0] = va_arg(val, int);
  100e8b:	48 8b 4d 90          	mov    -0x70(%rbp),%rcx
  100e8f:	8b 01                	mov    (%rcx),%eax
  100e91:	83 f8 2f             	cmp    $0x2f,%eax
  100e94:	77 23                	ja     100eb9 <printer_vprintf+0x55b>
  100e96:	89 c2                	mov    %eax,%edx
  100e98:	48 03 51 10          	add    0x10(%rcx),%rdx
  100e9c:	83 c0 08             	add    $0x8,%eax
  100e9f:	89 01                	mov    %eax,(%rcx)
  100ea1:	8b 02                	mov    (%rdx),%eax
  100ea3:	88 45 b8             	mov    %al,-0x48(%rbp)
            numbuf[1] = '\0';
  100ea6:	c6 45 b9 00          	movb   $0x0,-0x47(%rbp)
            data = numbuf;
  100eaa:	4c 8d 65 b8          	lea    -0x48(%rbp),%r12
        unsigned long num = 0;
  100eae:	41 b8 00 00 00 00    	mov    $0x0,%r8d
            break;
  100eb4:	e9 ff fd ff ff       	jmpq   100cb8 <printer_vprintf+0x35a>
            numbuf[0] = va_arg(val, int);
  100eb9:	48 8b 7d 90          	mov    -0x70(%rbp),%rdi
  100ebd:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  100ec1:	48 8d 42 08          	lea    0x8(%rdx),%rax
  100ec5:	48 89 47 08          	mov    %rax,0x8(%rdi)
  100ec9:	eb d6                	jmp    100ea1 <printer_vprintf+0x543>
            numbuf[0] = (*format ? *format : '%');
  100ecb:	84 d2                	test   %dl,%dl
  100ecd:	0f 85 39 01 00 00    	jne    10100c <printer_vprintf+0x6ae>
  100ed3:	c6 45 b8 25          	movb   $0x25,-0x48(%rbp)
            numbuf[1] = '\0';
  100ed7:	c6 45 b9 00          	movb   $0x0,-0x47(%rbp)
                format--;
  100edb:	48 83 eb 01          	sub    $0x1,%rbx
            data = numbuf;
  100edf:	4c 8d 65 b8          	lea    -0x48(%rbp),%r12
        unsigned long num = 0;
  100ee3:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  100ee9:	e9 ca fd ff ff       	jmpq   100cb8 <printer_vprintf+0x35a>
        if (flags & FLAG_NUMERIC) {
  100eee:	41 b9 0a 00 00 00    	mov    $0xa,%r9d
    const char* digits = upper_digits;
  100ef4:	bf f0 20 10 00       	mov    $0x1020f0,%edi
        if (flags & FLAG_NUMERIC) {
  100ef9:	be 0a 00 00 00       	mov    $0xa,%esi
    *--numbuf_end = '\0';
  100efe:	c6 45 cf 00          	movb   $0x0,-0x31(%rbp)
  100f02:	4c 89 c1             	mov    %r8,%rcx
  100f05:	4c 8d 65 cf          	lea    -0x31(%rbp),%r12
        *--numbuf_end = digits[val % base];
  100f09:	48 63 f6             	movslq %esi,%rsi
  100f0c:	49 83 ec 01          	sub    $0x1,%r12
  100f10:	48 89 c8             	mov    %rcx,%rax
  100f13:	ba 00 00 00 00       	mov    $0x0,%edx
  100f18:	48 f7 f6             	div    %rsi
  100f1b:	0f b6 14 17          	movzbl (%rdi,%rdx,1),%edx
  100f1f:	41 88 14 24          	mov    %dl,(%r12)
        val /= base;
  100f23:	48 89 ca             	mov    %rcx,%rdx
  100f26:	48 89 c1             	mov    %rax,%rcx
    } while (val != 0);
  100f29:	48 39 d6             	cmp    %rdx,%rsi
  100f2c:	76 de                	jbe    100f0c <printer_vprintf+0x5ae>
  100f2e:	e9 9a fd ff ff       	jmpq   100ccd <printer_vprintf+0x36f>
                prefix = "-";
  100f33:	48 c7 45 a0 04 1f 10 	movq   $0x101f04,-0x60(%rbp)
  100f3a:	00 
            if (flags & FLAG_NEGATIVE) {
  100f3b:	8b 45 a8             	mov    -0x58(%rbp),%eax
  100f3e:	a8 80                	test   $0x80,%al
  100f40:	0f 85 b0 fd ff ff    	jne    100cf6 <printer_vprintf+0x398>
                prefix = "+";
  100f46:	48 c7 45 a0 ff 1e 10 	movq   $0x101eff,-0x60(%rbp)
  100f4d:	00 
            } else if (flags & FLAG_PLUSPOSITIVE) {
  100f4e:	a8 10                	test   $0x10,%al
  100f50:	0f 85 a0 fd ff ff    	jne    100cf6 <printer_vprintf+0x398>
                prefix = " ";
  100f56:	a8 08                	test   $0x8,%al
  100f58:	ba b8 1e 10 00       	mov    $0x101eb8,%edx
  100f5d:	b8 1f 21 10 00       	mov    $0x10211f,%eax
  100f62:	48 0f 44 c2          	cmove  %rdx,%rax
  100f66:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  100f6a:	e9 87 fd ff ff       	jmpq   100cf6 <printer_vprintf+0x398>
                   && (base == 16 || base == -16)
  100f6f:	41 8d 41 10          	lea    0x10(%r9),%eax
  100f73:	a9 df ff ff ff       	test   $0xffffffdf,%eax
  100f78:	0f 85 78 fd ff ff    	jne    100cf6 <printer_vprintf+0x398>
                   && (num || (flags & FLAG_ALT2))) {
  100f7e:	4d 85 c0             	test   %r8,%r8
  100f81:	75 0d                	jne    100f90 <printer_vprintf+0x632>
  100f83:	f7 45 a8 00 01 00 00 	testl  $0x100,-0x58(%rbp)
  100f8a:	0f 84 66 fd ff ff    	je     100cf6 <printer_vprintf+0x398>
            prefix = (base == -16 ? "0x" : "0X");
  100f90:	41 83 f9 f0          	cmp    $0xfffffff0,%r9d
  100f94:	ba 06 1f 10 00       	mov    $0x101f06,%edx
  100f99:	b8 01 1f 10 00       	mov    $0x101f01,%eax
  100f9e:	48 0f 44 c2          	cmove  %rdx,%rax
  100fa2:	48 89 45 a0          	mov    %rax,-0x60(%rbp)
  100fa6:	e9 4b fd ff ff       	jmpq   100cf6 <printer_vprintf+0x398>
            len = strlen(data);
  100fab:	4c 89 e7             	mov    %r12,%rdi
  100fae:	e8 b5 f8 ff ff       	callq  100868 <strlen>
  100fb3:	89 45 98             	mov    %eax,-0x68(%rbp)
        if ((flags & FLAG_NUMERIC) && precision >= 0) {
  100fb6:	83 7d 8c 00          	cmpl   $0x0,-0x74(%rbp)
  100fba:	0f 84 63 fd ff ff    	je     100d23 <printer_vprintf+0x3c5>
  100fc0:	80 7d 84 00          	cmpb   $0x0,-0x7c(%rbp)
  100fc4:	0f 84 59 fd ff ff    	je     100d23 <printer_vprintf+0x3c5>
            zeros = precision > len ? precision - len : 0;
  100fca:	8b 4d 9c             	mov    -0x64(%rbp),%ecx
  100fcd:	89 ca                	mov    %ecx,%edx
  100fcf:	29 c2                	sub    %eax,%edx
  100fd1:	39 c1                	cmp    %eax,%ecx
  100fd3:	b8 00 00 00 00       	mov    $0x0,%eax
  100fd8:	0f 4e d0             	cmovle %eax,%edx
  100fdb:	89 55 9c             	mov    %edx,-0x64(%rbp)
  100fde:	e9 56 fd ff ff       	jmpq   100d39 <printer_vprintf+0x3db>
                   && len + (int) strlen(prefix) < width) {
  100fe3:	48 8b 7d a0          	mov    -0x60(%rbp),%rdi
  100fe7:	e8 7c f8 ff ff       	callq  100868 <strlen>
  100fec:	8b 7d 98             	mov    -0x68(%rbp),%edi
  100fef:	8d 14 07             	lea    (%rdi,%rax,1),%edx
            zeros = width - len - strlen(prefix);
  100ff2:	44 89 e9             	mov    %r13d,%ecx
  100ff5:	29 f9                	sub    %edi,%ecx
  100ff7:	29 c1                	sub    %eax,%ecx
  100ff9:	44 39 ea             	cmp    %r13d,%edx
  100ffc:	b8 00 00 00 00       	mov    $0x0,%eax
  101001:	0f 4d c8             	cmovge %eax,%ecx
  101004:	89 4d 9c             	mov    %ecx,-0x64(%rbp)
  101007:	e9 2d fd ff ff       	jmpq   100d39 <printer_vprintf+0x3db>
            numbuf[0] = (*format ? *format : '%');
  10100c:	88 55 b8             	mov    %dl,-0x48(%rbp)
            numbuf[1] = '\0';
  10100f:	c6 45 b9 00          	movb   $0x0,-0x47(%rbp)
            data = numbuf;
  101013:	4c 8d 65 b8          	lea    -0x48(%rbp),%r12
        unsigned long num = 0;
  101017:	41 b8 00 00 00 00    	mov    $0x0,%r8d
  10101d:	e9 96 fc ff ff       	jmpq   100cb8 <printer_vprintf+0x35a>
        int flags = 0;
  101022:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%rbp)
  101029:	e9 b0 f9 ff ff       	jmpq   1009de <printer_vprintf+0x80>
}
  10102e:	48 83 c4 58          	add    $0x58,%rsp
  101032:	5b                   	pop    %rbx
  101033:	41 5c                	pop    %r12
  101035:	41 5d                	pop    %r13
  101037:	41 5e                	pop    %r14
  101039:	41 5f                	pop    %r15
  10103b:	5d                   	pop    %rbp
  10103c:	c3                   	retq   

000000000010103d <console_vprintf>:
int console_vprintf(int cpos, int color, const char* format, va_list val) {
  10103d:	55                   	push   %rbp
  10103e:	48 89 e5             	mov    %rsp,%rbp
  101041:	48 83 ec 10          	sub    $0x10,%rsp
    cp.p.putc = console_putc;
  101045:	48 c7 45 f0 48 07 10 	movq   $0x100748,-0x10(%rbp)
  10104c:	00 
        cpos = 0;
  10104d:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
  101053:	b8 00 00 00 00       	mov    $0x0,%eax
  101058:	0f 43 f8             	cmovae %eax,%edi
    cp.cursor = console + cpos;
  10105b:	48 63 ff             	movslq %edi,%rdi
  10105e:	48 8d 84 3f 00 80 0b 	lea    0xb8000(%rdi,%rdi,1),%rax
  101065:	00 
  101066:	48 89 45 f8          	mov    %rax,-0x8(%rbp)
    printer_vprintf(&cp.p, color, format, val);
  10106a:	48 8d 7d f0          	lea    -0x10(%rbp),%rdi
  10106e:	e8 eb f8 ff ff       	callq  10095e <printer_vprintf>
    return cp.cursor - console;
  101073:	48 8b 45 f8          	mov    -0x8(%rbp),%rax
  101077:	48 2d 00 80 0b 00    	sub    $0xb8000,%rax
  10107d:	48 d1 f8             	sar    %rax
}
  101080:	c9                   	leaveq 
  101081:	c3                   	retq   

0000000000101082 <console_printf>:
int console_printf(int cpos, int color, const char* format, ...) {
  101082:	55                   	push   %rbp
  101083:	48 89 e5             	mov    %rsp,%rbp
  101086:	48 83 ec 50          	sub    $0x50,%rsp
  10108a:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  10108e:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  101092:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_start(val, format);
  101096:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  10109d:	48 8d 45 10          	lea    0x10(%rbp),%rax
  1010a1:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  1010a5:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  1010a9:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    cpos = console_vprintf(cpos, color, format, val);
  1010ad:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  1010b1:	e8 87 ff ff ff       	callq  10103d <console_vprintf>
}
  1010b6:	c9                   	leaveq 
  1010b7:	c3                   	retq   

00000000001010b8 <vsnprintf>:

int vsnprintf(char* s, size_t size, const char* format, va_list val) {
  1010b8:	55                   	push   %rbp
  1010b9:	48 89 e5             	mov    %rsp,%rbp
  1010bc:	53                   	push   %rbx
  1010bd:	48 83 ec 28          	sub    $0x28,%rsp
  1010c1:	48 89 fb             	mov    %rdi,%rbx
    string_printer sp;
    sp.p.putc = string_putc;
  1010c4:	48 c7 45 d8 ce 07 10 	movq   $0x1007ce,-0x28(%rbp)
  1010cb:	00 
    sp.s = s;
  1010cc:	48 89 7d e0          	mov    %rdi,-0x20(%rbp)
    if (size) {
  1010d0:	48 85 f6             	test   %rsi,%rsi
  1010d3:	75 0b                	jne    1010e0 <vsnprintf+0x28>
        sp.end = s + size - 1;
        printer_vprintf(&sp.p, 0, format, val);
        *sp.s = 0;
    }
    return sp.s - s;
  1010d5:	8b 45 e0             	mov    -0x20(%rbp),%eax
  1010d8:	29 d8                	sub    %ebx,%eax
}
  1010da:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  1010de:	c9                   	leaveq 
  1010df:	c3                   	retq   
        sp.end = s + size - 1;
  1010e0:	48 8d 44 37 ff       	lea    -0x1(%rdi,%rsi,1),%rax
  1010e5:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
        printer_vprintf(&sp.p, 0, format, val);
  1010e9:	be 00 00 00 00       	mov    $0x0,%esi
  1010ee:	48 8d 7d d8          	lea    -0x28(%rbp),%rdi
  1010f2:	e8 67 f8 ff ff       	callq  10095e <printer_vprintf>
        *sp.s = 0;
  1010f7:	48 8b 45 e0          	mov    -0x20(%rbp),%rax
  1010fb:	c6 00 00             	movb   $0x0,(%rax)
  1010fe:	eb d5                	jmp    1010d5 <vsnprintf+0x1d>

0000000000101100 <snprintf>:

int snprintf(char* s, size_t size, const char* format, ...) {
  101100:	55                   	push   %rbp
  101101:	48 89 e5             	mov    %rsp,%rbp
  101104:	48 83 ec 50          	sub    $0x50,%rsp
  101108:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  10110c:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  101110:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    va_list val;
    va_start(val, format);
  101114:	c7 45 b8 18 00 00 00 	movl   $0x18,-0x48(%rbp)
  10111b:	48 8d 45 10          	lea    0x10(%rbp),%rax
  10111f:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  101123:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  101127:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    int n = vsnprintf(s, size, format, val);
  10112b:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  10112f:	e8 84 ff ff ff       	callq  1010b8 <vsnprintf>
    va_end(val);
    return n;
}
  101134:	c9                   	leaveq 
  101135:	c3                   	retq   

0000000000101136 <console_clear>:

// console_clear
//    Erases the console and moves the cursor to the upper left (CPOS(0, 0)).

void console_clear(void) {
    for (int i = 0; i < CONSOLE_ROWS * CONSOLE_COLUMNS; ++i) {
  101136:	b8 00 80 0b 00       	mov    $0xb8000,%eax
  10113b:	ba a0 8f 0b 00       	mov    $0xb8fa0,%edx
        console[i] = ' ' | 0x0700;
  101140:	66 c7 00 20 07       	movw   $0x720,(%rax)
    for (int i = 0; i < CONSOLE_ROWS * CONSOLE_COLUMNS; ++i) {
  101145:	48 83 c0 02          	add    $0x2,%rax
  101149:	48 39 d0             	cmp    %rdx,%rax
  10114c:	75 f2                	jne    101140 <console_clear+0xa>
    }
    cursorpos = 0;
  10114e:	c7 05 a4 7e fb ff 00 	movl   $0x0,-0x4815c(%rip)        # b8ffc <cursorpos>
  101155:	00 00 00 
}
  101158:	c3                   	retq   

0000000000101159 <cmp_ptr_ascending>:
	}
    }
}

int cmp_ptr_ascending( const void * a, const void * b){
    return (uintptr_t)((ptr_with_size *) a)->ptr - (uintptr_t)((ptr_with_size *) b)->ptr;
  101159:	48 8b 07             	mov    (%rdi),%rax
  10115c:	2b 06                	sub    (%rsi),%eax
}
  10115e:	c3                   	retq   

000000000010115f <cmp_size_descending>:
int cmp_size_descending( const void * a, const void * b){
    return (size_t)((ptr_with_size *) b)->size - (size_t)((ptr_with_size *) a)->size;
  10115f:	48 8b 46 08          	mov    0x8(%rsi),%rax
  101163:	2b 47 08             	sub    0x8(%rdi),%eax
}
  101166:	c3                   	retq   

0000000000101167 <__quicksort>:
{
  101167:	55                   	push   %rbp
  101168:	48 89 e5             	mov    %rsp,%rbp
  10116b:	41 57                	push   %r15
  10116d:	41 56                	push   %r14
  10116f:	41 55                	push   %r13
  101171:	41 54                	push   %r12
  101173:	53                   	push   %rbx
  101174:	48 81 ec 48 04 00 00 	sub    $0x448,%rsp
  10117b:	48 89 bd a0 fb ff ff 	mov    %rdi,-0x460(%rbp)
  101182:	48 89 b5 98 fb ff ff 	mov    %rsi,-0x468(%rbp)
  101189:	48 89 95 c8 fb ff ff 	mov    %rdx,-0x438(%rbp)
    if (total_elems == 0)
  101190:	48 85 f6             	test   %rsi,%rsi
  101193:	0f 84 94 03 00 00    	je     10152d <__quicksort+0x3c6>
  101199:	48 89 f0             	mov    %rsi,%rax
  10119c:	48 89 cb             	mov    %rcx,%rbx
    const size_t max_thresh = MAX_THRESH * size;
  10119f:	48 8d 0c 95 00 00 00 	lea    0x0(,%rdx,4),%rcx
  1011a6:	00 
  1011a7:	48 89 8d a8 fb ff ff 	mov    %rcx,-0x458(%rbp)
    if (total_elems > MAX_THRESH)
  1011ae:	48 83 fe 04          	cmp    $0x4,%rsi
  1011b2:	0f 86 bd 02 00 00    	jbe    101475 <__quicksort+0x30e>
	char *hi = &lo[size * (total_elems - 1)];
  1011b8:	48 83 e8 01          	sub    $0x1,%rax
  1011bc:	48 0f af c2          	imul   %rdx,%rax
  1011c0:	48 01 f8             	add    %rdi,%rax
  1011c3:	48 89 85 c0 fb ff ff 	mov    %rax,-0x440(%rbp)
	PUSH (NULL, NULL);
  1011ca:	48 c7 85 d0 fb ff ff 	movq   $0x0,-0x430(%rbp)
  1011d1:	00 00 00 00 
  1011d5:	48 c7 85 d8 fb ff ff 	movq   $0x0,-0x428(%rbp)
  1011dc:	00 00 00 00 
	char *lo = base_ptr;
  1011e0:	48 89 bd b8 fb ff ff 	mov    %rdi,-0x448(%rbp)
	PUSH (NULL, NULL);
  1011e7:	48 8d 85 e0 fb ff ff 	lea    -0x420(%rbp),%rax
  1011ee:	48 89 85 b0 fb ff ff 	mov    %rax,-0x450(%rbp)
	  right_ptr = hi - size;
  1011f5:	48 f7 da             	neg    %rdx
  1011f8:	49 89 d7             	mov    %rdx,%r15
  1011fb:	e9 8c 01 00 00       	jmpq   10138c <__quicksort+0x225>
  101200:	48 8b 85 c8 fb ff ff 	mov    -0x438(%rbp),%rax
  101207:	49 8d 7c 05 00       	lea    0x0(%r13,%rax,1),%rdi
	    if ((*cmp) ((void *) mid, (void *) lo) < 0)
  10120c:	48 8b 95 b8 fb ff ff 	mov    -0x448(%rbp),%rdx
		SWAP (mid, lo, size);
  101213:	4c 89 e8             	mov    %r13,%rax
  101216:	0f b6 08             	movzbl (%rax),%ecx
  101219:	48 83 c0 01          	add    $0x1,%rax
  10121d:	0f b6 32             	movzbl (%rdx),%esi
  101220:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  101224:	48 83 c2 01          	add    $0x1,%rdx
  101228:	88 4a ff             	mov    %cl,-0x1(%rdx)
  10122b:	48 39 c7             	cmp    %rax,%rdi
  10122e:	75 e6                	jne    101216 <__quicksort+0xaf>
  101230:	e9 92 01 00 00       	jmpq   1013c7 <__quicksort+0x260>
  101235:	48 8b 85 c8 fb ff ff 	mov    -0x438(%rbp),%rax
  10123c:	4d 8d 64 05 00       	lea    0x0(%r13,%rax,1),%r12
	    if ((*cmp) ((void *) hi, (void *) mid) < 0)
  101241:	48 8b 95 c0 fb ff ff 	mov    -0x440(%rbp),%rdx
		SWAP (mid, hi, size);
  101248:	4c 89 e8             	mov    %r13,%rax
  10124b:	0f b6 08             	movzbl (%rax),%ecx
  10124e:	48 83 c0 01          	add    $0x1,%rax
  101252:	0f b6 32             	movzbl (%rdx),%esi
  101255:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  101259:	48 83 c2 01          	add    $0x1,%rdx
  10125d:	88 4a ff             	mov    %cl,-0x1(%rdx)
  101260:	49 39 c4             	cmp    %rax,%r12
  101263:	75 e6                	jne    10124b <__quicksort+0xe4>
	    if ((*cmp) ((void *) mid, (void *) lo) < 0)
  101265:	48 8b b5 b8 fb ff ff 	mov    -0x448(%rbp),%rsi
  10126c:	4c 89 ef             	mov    %r13,%rdi
  10126f:	ff d3                	callq  *%rbx
  101271:	85 c0                	test   %eax,%eax
  101273:	0f 89 62 01 00 00    	jns    1013db <__quicksort+0x274>
  101279:	48 8b 95 b8 fb ff ff 	mov    -0x448(%rbp),%rdx
		SWAP (mid, lo, size);
  101280:	4c 89 e8             	mov    %r13,%rax
  101283:	0f b6 08             	movzbl (%rax),%ecx
  101286:	48 83 c0 01          	add    $0x1,%rax
  10128a:	0f b6 32             	movzbl (%rdx),%esi
  10128d:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  101291:	48 83 c2 01          	add    $0x1,%rdx
  101295:	88 4a ff             	mov    %cl,-0x1(%rdx)
  101298:	49 39 c4             	cmp    %rax,%r12
  10129b:	75 e6                	jne    101283 <__quicksort+0x11c>
jump_over:;
  10129d:	e9 39 01 00 00       	jmpq   1013db <__quicksort+0x274>
		  right_ptr -= size;
  1012a2:	4d 01 fc             	add    %r15,%r12
	      while ((*cmp) ((void *) mid, (void *) right_ptr) < 0)
  1012a5:	4c 89 e6             	mov    %r12,%rsi
  1012a8:	4c 89 ef             	mov    %r13,%rdi
  1012ab:	ff d3                	callq  *%rbx
  1012ad:	85 c0                	test   %eax,%eax
  1012af:	78 f1                	js     1012a2 <__quicksort+0x13b>
	      if (left_ptr < right_ptr)
  1012b1:	4d 39 e6             	cmp    %r12,%r14
  1012b4:	72 1c                	jb     1012d2 <__quicksort+0x16b>
	      else if (left_ptr == right_ptr)
  1012b6:	74 5e                	je     101316 <__quicksort+0x1af>
	  while (left_ptr <= right_ptr);
  1012b8:	4d 39 e6             	cmp    %r12,%r14
  1012bb:	77 63                	ja     101320 <__quicksort+0x1b9>
	      while ((*cmp) ((void *) left_ptr, (void *) mid) < 0)
  1012bd:	4c 89 ee             	mov    %r13,%rsi
  1012c0:	4c 89 f7             	mov    %r14,%rdi
  1012c3:	ff d3                	callq  *%rbx
  1012c5:	85 c0                	test   %eax,%eax
  1012c7:	79 dc                	jns    1012a5 <__quicksort+0x13e>
		  left_ptr += size;
  1012c9:	4c 03 b5 c8 fb ff ff 	add    -0x438(%rbp),%r14
  1012d0:	eb eb                	jmp    1012bd <__quicksort+0x156>
  1012d2:	48 8b 85 c8 fb ff ff 	mov    -0x438(%rbp),%rax
  1012d9:	49 8d 3c 06          	lea    (%r14,%rax,1),%rdi
	      if (left_ptr < right_ptr)
  1012dd:	4c 89 e2             	mov    %r12,%rdx
  1012e0:	4c 89 f0             	mov    %r14,%rax
		  SWAP (left_ptr, right_ptr, size);
  1012e3:	0f b6 08             	movzbl (%rax),%ecx
  1012e6:	48 83 c0 01          	add    $0x1,%rax
  1012ea:	0f b6 32             	movzbl (%rdx),%esi
  1012ed:	40 88 70 ff          	mov    %sil,-0x1(%rax)
  1012f1:	48 83 c2 01          	add    $0x1,%rdx
  1012f5:	88 4a ff             	mov    %cl,-0x1(%rdx)
  1012f8:	48 39 f8             	cmp    %rdi,%rax
  1012fb:	75 e6                	jne    1012e3 <__quicksort+0x17c>
		  if (mid == left_ptr)
  1012fd:	4d 39 ee             	cmp    %r13,%r14
  101300:	74 0f                	je     101311 <__quicksort+0x1aa>
		  else if (mid == right_ptr)
  101302:	4d 39 ec             	cmp    %r13,%r12
  101305:	4d 0f 44 ee          	cmove  %r14,%r13
		  right_ptr -= size;
  101309:	4d 01 fc             	add    %r15,%r12
		  left_ptr += size;
  10130c:	49 89 fe             	mov    %rdi,%r14
  10130f:	eb a7                	jmp    1012b8 <__quicksort+0x151>
  101311:	4d 89 e5             	mov    %r12,%r13
  101314:	eb f3                	jmp    101309 <__quicksort+0x1a2>
		  left_ptr += size;
  101316:	4c 03 b5 c8 fb ff ff 	add    -0x438(%rbp),%r14
		  right_ptr -= size;
  10131d:	4d 01 fc             	add    %r15,%r12
	  if ((size_t) (right_ptr - lo) <= max_thresh)
  101320:	4c 89 e0             	mov    %r12,%rax
  101323:	48 2b 85 b8 fb ff ff 	sub    -0x448(%rbp),%rax
  10132a:	48 8b bd a8 fb ff ff 	mov    -0x458(%rbp),%rdi
  101331:	48 39 f8             	cmp    %rdi,%rax
  101334:	0f 87 bf 00 00 00    	ja     1013f9 <__quicksort+0x292>
	      if ((size_t) (hi - left_ptr) <= max_thresh)
  10133a:	48 8b 85 c0 fb ff ff 	mov    -0x440(%rbp),%rax
  101341:	4c 29 f0             	sub    %r14,%rax
		  lo = left_ptr;
  101344:	4c 89 b5 b8 fb ff ff 	mov    %r14,-0x448(%rbp)
	      if ((size_t) (hi - left_ptr) <= max_thresh)
  10134b:	48 39 f8             	cmp    %rdi,%rax
  10134e:	77 28                	ja     101378 <__quicksort+0x211>
		  POP (lo, hi);
  101350:	48 8b 85 b0 fb ff ff 	mov    -0x450(%rbp),%rax
  101357:	48 8b 78 f0          	mov    -0x10(%rax),%rdi
  10135b:	48 89 bd b8 fb ff ff 	mov    %rdi,-0x448(%rbp)
  101362:	48 8b 78 f8          	mov    -0x8(%rax),%rdi
  101366:	48 89 bd c0 fb ff ff 	mov    %rdi,-0x440(%rbp)
  10136d:	48 8d 40 f0          	lea    -0x10(%rax),%rax
  101371:	48 89 85 b0 fb ff ff 	mov    %rax,-0x450(%rbp)
	while (STACK_NOT_EMPTY)
  101378:	48 8d 85 d0 fb ff ff 	lea    -0x430(%rbp),%rax
  10137f:	48 39 85 b0 fb ff ff 	cmp    %rax,-0x450(%rbp)
  101386:	0f 86 e9 00 00 00    	jbe    101475 <__quicksort+0x30e>
	    char *mid = lo + size * ((hi - lo) / size >> 1);
  10138c:	48 8b 85 c0 fb ff ff 	mov    -0x440(%rbp),%rax
  101393:	48 8b bd b8 fb ff ff 	mov    -0x448(%rbp),%rdi
  10139a:	48 29 f8             	sub    %rdi,%rax
  10139d:	48 8b 8d c8 fb ff ff 	mov    -0x438(%rbp),%rcx
  1013a4:	ba 00 00 00 00       	mov    $0x0,%edx
  1013a9:	48 f7 f1             	div    %rcx
  1013ac:	48 d1 e8             	shr    %rax
  1013af:	48 0f af c1          	imul   %rcx,%rax
  1013b3:	4c 8d 2c 07          	lea    (%rdi,%rax,1),%r13
	    if ((*cmp) ((void *) mid, (void *) lo) < 0)
  1013b7:	48 89 fe             	mov    %rdi,%rsi
  1013ba:	4c 89 ef             	mov    %r13,%rdi
  1013bd:	ff d3                	callq  *%rbx
  1013bf:	85 c0                	test   %eax,%eax
  1013c1:	0f 88 39 fe ff ff    	js     101200 <__quicksort+0x99>
	    if ((*cmp) ((void *) hi, (void *) mid) < 0)
  1013c7:	4c 89 ee             	mov    %r13,%rsi
  1013ca:	48 8b bd c0 fb ff ff 	mov    -0x440(%rbp),%rdi
  1013d1:	ff d3                	callq  *%rbx
  1013d3:	85 c0                	test   %eax,%eax
  1013d5:	0f 88 5a fe ff ff    	js     101235 <__quicksort+0xce>
	  left_ptr  = lo + size;
  1013db:	4c 8b b5 b8 fb ff ff 	mov    -0x448(%rbp),%r14
  1013e2:	4c 03 b5 c8 fb ff ff 	add    -0x438(%rbp),%r14
	  right_ptr = hi - size;
  1013e9:	48 8b 85 c0 fb ff ff 	mov    -0x440(%rbp),%rax
  1013f0:	4e 8d 24 38          	lea    (%rax,%r15,1),%r12
  1013f4:	e9 c4 fe ff ff       	jmpq   1012bd <__quicksort+0x156>
	  else if ((size_t) (hi - left_ptr) <= max_thresh)
  1013f9:	48 8b 95 c0 fb ff ff 	mov    -0x440(%rbp),%rdx
  101400:	4c 29 f2             	sub    %r14,%rdx
  101403:	48 3b 95 a8 fb ff ff 	cmp    -0x458(%rbp),%rdx
  10140a:	76 5d                	jbe    101469 <__quicksort+0x302>
	  else if ((right_ptr - lo) > (hi - left_ptr))
  10140c:	48 39 d0             	cmp    %rdx,%rax
  10140f:	7e 2c                	jle    10143d <__quicksort+0x2d6>
	      PUSH (lo, right_ptr);
  101411:	48 8b 85 b0 fb ff ff 	mov    -0x450(%rbp),%rax
  101418:	48 8b bd b8 fb ff ff 	mov    -0x448(%rbp),%rdi
  10141f:	48 89 38             	mov    %rdi,(%rax)
  101422:	4c 89 60 08          	mov    %r12,0x8(%rax)
  101426:	48 83 c0 10          	add    $0x10,%rax
  10142a:	48 89 85 b0 fb ff ff 	mov    %rax,-0x450(%rbp)
	      lo = left_ptr;
  101431:	4c 89 b5 b8 fb ff ff 	mov    %r14,-0x448(%rbp)
  101438:	e9 3b ff ff ff       	jmpq   101378 <__quicksort+0x211>
	      PUSH (left_ptr, hi);
  10143d:	48 8b 85 b0 fb ff ff 	mov    -0x450(%rbp),%rax
  101444:	4c 89 30             	mov    %r14,(%rax)
  101447:	48 8b bd c0 fb ff ff 	mov    -0x440(%rbp),%rdi
  10144e:	48 89 78 08          	mov    %rdi,0x8(%rax)
  101452:	48 83 c0 10          	add    $0x10,%rax
  101456:	48 89 85 b0 fb ff ff 	mov    %rax,-0x450(%rbp)
	      hi = right_ptr;
  10145d:	4c 89 a5 c0 fb ff ff 	mov    %r12,-0x440(%rbp)
  101464:	e9 0f ff ff ff       	jmpq   101378 <__quicksort+0x211>
	      hi = right_ptr;
  101469:	4c 89 a5 c0 fb ff ff 	mov    %r12,-0x440(%rbp)
  101470:	e9 03 ff ff ff       	jmpq   101378 <__quicksort+0x211>
	char *const end_ptr = &base_ptr[size * (total_elems - 1)];
  101475:	4c 8b bd 98 fb ff ff 	mov    -0x468(%rbp),%r15
  10147c:	49 83 ef 01          	sub    $0x1,%r15
  101480:	48 8b bd c8 fb ff ff 	mov    -0x438(%rbp),%rdi
  101487:	4c 0f af ff          	imul   %rdi,%r15
  10148b:	4c 8b ad a0 fb ff ff 	mov    -0x460(%rbp),%r13
  101492:	4d 01 ef             	add    %r13,%r15
	char *thresh = min(end_ptr, base_ptr + max_thresh);
  101495:	48 8b 85 a8 fb ff ff 	mov    -0x458(%rbp),%rax
  10149c:	4c 01 e8             	add    %r13,%rax
  10149f:	49 39 c7             	cmp    %rax,%r15
  1014a2:	49 0f 46 c7          	cmovbe %r15,%rax
	for (run_ptr = tmp_ptr + size; run_ptr <= thresh; run_ptr += size)
  1014a6:	4d 89 ec             	mov    %r13,%r12
  1014a9:	49 01 fc             	add    %rdi,%r12
  1014ac:	4c 39 e0             	cmp    %r12,%rax
  1014af:	72 66                	jb     101517 <__quicksort+0x3b0>
  1014b1:	4d 89 e6             	mov    %r12,%r14
	char *tmp_ptr = base_ptr;
  1014b4:	4c 89 a5 c0 fb ff ff 	mov    %r12,-0x440(%rbp)
  1014bb:	49 89 c4             	mov    %rax,%r12
	    if ((*cmp) ((void *) run_ptr, (void *) tmp_ptr) < 0)
  1014be:	4c 89 ee             	mov    %r13,%rsi
  1014c1:	4c 89 f7             	mov    %r14,%rdi
  1014c4:	ff d3                	callq  *%rbx
  1014c6:	85 c0                	test   %eax,%eax
  1014c8:	4d 0f 48 ee          	cmovs  %r14,%r13
	for (run_ptr = tmp_ptr + size; run_ptr <= thresh; run_ptr += size)
  1014cc:	4c 03 b5 c8 fb ff ff 	add    -0x438(%rbp),%r14
  1014d3:	4d 39 f4             	cmp    %r14,%r12
  1014d6:	73 e6                	jae    1014be <__quicksort+0x357>
  1014d8:	4c 8b a5 c0 fb ff ff 	mov    -0x440(%rbp),%r12
	if (tmp_ptr != base_ptr)
  1014df:	48 8b 85 c8 fb ff ff 	mov    -0x438(%rbp),%rax
  1014e6:	49 8d 4c 05 00       	lea    0x0(%r13,%rax,1),%rcx
  1014eb:	48 8b 85 a0 fb ff ff 	mov    -0x460(%rbp),%rax
  1014f2:	4c 3b ad a0 fb ff ff 	cmp    -0x460(%rbp),%r13
  1014f9:	74 1c                	je     101517 <__quicksort+0x3b0>
	    SWAP (tmp_ptr, base_ptr, size);
  1014fb:	41 0f b6 55 00       	movzbl 0x0(%r13),%edx
  101500:	49 83 c5 01          	add    $0x1,%r13
  101504:	0f b6 30             	movzbl (%rax),%esi
  101507:	41 88 75 ff          	mov    %sil,-0x1(%r13)
  10150b:	48 83 c0 01          	add    $0x1,%rax
  10150f:	88 50 ff             	mov    %dl,-0x1(%rax)
  101512:	49 39 cd             	cmp    %rcx,%r13
  101515:	75 e4                	jne    1014fb <__quicksort+0x394>
	while ((run_ptr += size) <= end_ptr)
  101517:	48 8b 85 c8 fb ff ff 	mov    -0x438(%rbp),%rax
  10151e:	4d 8d 34 04          	lea    (%r12,%rax,1),%r14
	    tmp_ptr = run_ptr - size;
  101522:	48 f7 d8             	neg    %rax
  101525:	49 89 c5             	mov    %rax,%r13
	while ((run_ptr += size) <= end_ptr)
  101528:	4d 39 f7             	cmp    %r14,%r15
  10152b:	73 15                	jae    101542 <__quicksort+0x3db>
}
  10152d:	48 81 c4 48 04 00 00 	add    $0x448,%rsp
  101534:	5b                   	pop    %rbx
  101535:	41 5c                	pop    %r12
  101537:	41 5d                	pop    %r13
  101539:	41 5e                	pop    %r14
  10153b:	41 5f                	pop    %r15
  10153d:	5d                   	pop    %rbp
  10153e:	c3                   	retq   
		tmp_ptr -= size;
  10153f:	4d 01 ec             	add    %r13,%r12
	    while ((*cmp) ((void *) run_ptr, (void *) tmp_ptr) < 0)
  101542:	4c 89 e6             	mov    %r12,%rsi
  101545:	4c 89 f7             	mov    %r14,%rdi
  101548:	ff d3                	callq  *%rbx
  10154a:	85 c0                	test   %eax,%eax
  10154c:	78 f1                	js     10153f <__quicksort+0x3d8>
	    tmp_ptr += size;
  10154e:	48 8b 85 c8 fb ff ff 	mov    -0x438(%rbp),%rax
  101555:	49 8d 34 04          	lea    (%r12,%rax,1),%rsi
	    if (tmp_ptr != run_ptr)
  101559:	4c 39 f6             	cmp    %r14,%rsi
  10155c:	75 17                	jne    101575 <__quicksort+0x40e>
	while ((run_ptr += size) <= end_ptr)
  10155e:	48 8b 85 c8 fb ff ff 	mov    -0x438(%rbp),%rax
  101565:	4c 01 f0             	add    %r14,%rax
  101568:	4d 89 f4             	mov    %r14,%r12
  10156b:	49 39 c7             	cmp    %rax,%r15
  10156e:	72 bd                	jb     10152d <__quicksort+0x3c6>
  101570:	49 89 c6             	mov    %rax,%r14
	    while ((*cmp) ((void *) run_ptr, (void *) tmp_ptr) < 0)
  101573:	eb cd                	jmp    101542 <__quicksort+0x3db>
		while (--trav >= run_ptr)
  101575:	49 8d 7c 06 ff       	lea    -0x1(%r14,%rax,1),%rdi
  10157a:	4c 39 f7             	cmp    %r14,%rdi
  10157d:	72 df                	jb     10155e <__quicksort+0x3f7>
  10157f:	4d 8d 46 ff          	lea    -0x1(%r14),%r8
  101583:	4d 89 c2             	mov    %r8,%r10
  101586:	eb 13                	jmp    10159b <__quicksort+0x434>
		    for (hi = lo = trav; (lo -= size) >= tmp_ptr; hi = lo)
  101588:	48 89 f9             	mov    %rdi,%rcx
		    *hi = c;
  10158b:	44 88 09             	mov    %r9b,(%rcx)
		while (--trav >= run_ptr)
  10158e:	48 83 ef 01          	sub    $0x1,%rdi
  101592:	49 83 e8 01          	sub    $0x1,%r8
  101596:	49 39 fa             	cmp    %rdi,%r10
  101599:	74 c3                	je     10155e <__quicksort+0x3f7>
		    char c = *trav;
  10159b:	44 0f b6 0f          	movzbl (%rdi),%r9d
		    for (hi = lo = trav; (lo -= size) >= tmp_ptr; hi = lo)
  10159f:	4c 89 c0             	mov    %r8,%rax
  1015a2:	4c 39 c6             	cmp    %r8,%rsi
  1015a5:	77 e1                	ja     101588 <__quicksort+0x421>
  1015a7:	48 89 fa             	mov    %rdi,%rdx
			*hi = *lo;
  1015aa:	0f b6 08             	movzbl (%rax),%ecx
  1015ad:	88 0a                	mov    %cl,(%rdx)
		    for (hi = lo = trav; (lo -= size) >= tmp_ptr; hi = lo)
  1015af:	48 89 c1             	mov    %rax,%rcx
  1015b2:	4c 01 e8             	add    %r13,%rax
  1015b5:	48 2b 95 c8 fb ff ff 	sub    -0x438(%rbp),%rdx
  1015bc:	48 39 c6             	cmp    %rax,%rsi
  1015bf:	76 e9                	jbe    1015aa <__quicksort+0x443>
  1015c1:	eb c8                	jmp    10158b <__quicksort+0x424>

00000000001015c3 <print_ptrs_with_size>:
void print_ptrs_with_size(ptr_with_size *ptrs_with_size, int end) {
  1015c3:	55                   	push   %rbp
  1015c4:	48 89 e5             	mov    %rsp,%rbp
  1015c7:	41 55                	push   %r13
  1015c9:	41 54                	push   %r12
  1015cb:	53                   	push   %rbx
  1015cc:	48 83 ec 08          	sub    $0x8,%rsp
  1015d0:	49 89 fd             	mov    %rdi,%r13
  1015d3:	41 89 f4             	mov    %esi,%r12d
    asm volatile ("int %0" : /* no result */
  1015d6:	bf 00 00 00 00       	mov    $0x0,%edi
  1015db:	cd 38                	int    $0x38
    mem_tog(0);
    app_printf(1, "Start");
  1015dd:	be 07 21 10 00       	mov    $0x102107,%esi
  1015e2:	bf 01 00 00 00       	mov    $0x1,%edi
  1015e7:	b8 00 00 00 00       	mov    $0x0,%eax
  1015ec:	e8 de 06 00 00       	callq  101ccf <app_printf>
    for (int i = 0; i < end; i++) {
  1015f1:	45 85 e4             	test   %r12d,%r12d
  1015f4:	7e 35                	jle    10162b <print_ptrs_with_size+0x68>
  1015f6:	4c 89 eb             	mov    %r13,%rbx
  1015f9:	41 8d 44 24 ff       	lea    -0x1(%r12),%eax
  1015fe:	48 c1 e0 04          	shl    $0x4,%rax
  101602:	4d 8d 64 05 10       	lea    0x10(%r13,%rax,1),%r12
        app_printf(1, " %x-%x ", ptrs_with_size[i].ptr, ptrs_with_size[i].size);
  101607:	48 8b 4b 08          	mov    0x8(%rbx),%rcx
  10160b:	48 8b 13             	mov    (%rbx),%rdx
  10160e:	be 0d 21 10 00       	mov    $0x10210d,%esi
  101613:	bf 01 00 00 00       	mov    $0x1,%edi
  101618:	b8 00 00 00 00       	mov    $0x0,%eax
  10161d:	e8 ad 06 00 00       	callq  101ccf <app_printf>
    for (int i = 0; i < end; i++) {
  101622:	48 83 c3 10          	add    $0x10,%rbx
  101626:	4c 39 e3             	cmp    %r12,%rbx
  101629:	75 dc                	jne    101607 <print_ptrs_with_size+0x44>
    }
    app_printf(1, "End");
  10162b:	be 15 21 10 00       	mov    $0x102115,%esi
  101630:	bf 01 00 00 00       	mov    $0x1,%edi
  101635:	b8 00 00 00 00       	mov    $0x0,%eax
  10163a:	e8 90 06 00 00       	callq  101ccf <app_printf>
}
  10163f:	48 83 c4 08          	add    $0x8,%rsp
  101643:	5b                   	pop    %rbx
  101644:	41 5c                	pop    %r12
  101646:	41 5d                	pop    %r13
  101648:	5d                   	pop    %rbp
  101649:	c3                   	retq   

000000000010164a <append_free_list_node>:
alloc_header *alloc_list_head = NULL;
alloc_header *alloc_list_tail = NULL;
int alloc_list_length = 0;

void append_free_list_node(free_list_node *node) {
    node->next = NULL;
  10164a:	48 c7 47 08 00 00 00 	movq   $0x0,0x8(%rdi)
  101651:	00 
    node->prev = NULL;
  101652:	48 c7 07 00 00 00 00 	movq   $0x0,(%rdi)
    if (free_list_head == NULL && free_list_tail == NULL) {
  101659:	48 83 3d f7 19 00 00 	cmpq   $0x0,0x19f7(%rip)        # 103058 <free_list_head>
  101660:	00 
  101661:	74 1d                	je     101680 <append_free_list_node+0x36>
        free_list_head = node;
        free_list_tail = node;
    } else {
        free_list_tail->next = node;
  101663:	48 8b 05 e6 19 00 00 	mov    0x19e6(%rip),%rax        # 103050 <free_list_tail>
  10166a:	48 89 78 08          	mov    %rdi,0x8(%rax)
        node->prev = free_list_tail;
  10166e:	48 89 07             	mov    %rax,(%rdi)
        free_list_tail = node;
  101671:	48 89 3d d8 19 00 00 	mov    %rdi,0x19d8(%rip)        # 103050 <free_list_tail>
        free_list_tail = node;
    }
    free_list_length++;
  101678:	83 05 c9 19 00 00 01 	addl   $0x1,0x19c9(%rip)        # 103048 <free_list_length>
}
  10167f:	c3                   	retq   
    if (free_list_head == NULL && free_list_tail == NULL) {
  101680:	48 83 3d c8 19 00 00 	cmpq   $0x0,0x19c8(%rip)        # 103050 <free_list_tail>
  101687:	00 
  101688:	75 d9                	jne    101663 <append_free_list_node+0x19>
        free_list_head = node;
  10168a:	48 89 3d c7 19 00 00 	mov    %rdi,0x19c7(%rip)        # 103058 <free_list_head>
        free_list_tail = node;
  101691:	eb de                	jmp    101671 <append_free_list_node+0x27>

0000000000101693 <remove_free_list_node>:

void remove_free_list_node(free_list_node *node) {
    if (node == free_list_head) free_list_head = node->next;
  101693:	48 39 3d be 19 00 00 	cmp    %rdi,0x19be(%rip)        # 103058 <free_list_head>
  10169a:	74 30                	je     1016cc <remove_free_list_node+0x39>
    if (node == free_list_tail) free_list_tail = node->prev;
  10169c:	48 39 3d ad 19 00 00 	cmp    %rdi,0x19ad(%rip)        # 103050 <free_list_tail>
  1016a3:	74 34                	je     1016d9 <remove_free_list_node+0x46>
    if (node->prev != NULL) node->prev->next = node->next;
  1016a5:	48 8b 07             	mov    (%rdi),%rax
  1016a8:	48 85 c0             	test   %rax,%rax
  1016ab:	74 08                	je     1016b5 <remove_free_list_node+0x22>
  1016ad:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  1016b1:	48 89 50 08          	mov    %rdx,0x8(%rax)
    if (node->next != NULL) node->next->prev = node->prev;
  1016b5:	48 8b 47 08          	mov    0x8(%rdi),%rax
  1016b9:	48 85 c0             	test   %rax,%rax
  1016bc:	74 06                	je     1016c4 <remove_free_list_node+0x31>
  1016be:	48 8b 17             	mov    (%rdi),%rdx
  1016c1:	48 89 10             	mov    %rdx,(%rax)
    free_list_length--;
  1016c4:	83 2d 7d 19 00 00 01 	subl   $0x1,0x197d(%rip)        # 103048 <free_list_length>
}
  1016cb:	c3                   	retq   
    if (node == free_list_head) free_list_head = node->next;
  1016cc:	48 8b 47 08          	mov    0x8(%rdi),%rax
  1016d0:	48 89 05 81 19 00 00 	mov    %rax,0x1981(%rip)        # 103058 <free_list_head>
  1016d7:	eb c3                	jmp    10169c <remove_free_list_node+0x9>
    if (node == free_list_tail) free_list_tail = node->prev;
  1016d9:	48 8b 07             	mov    (%rdi),%rax
  1016dc:	48 89 05 6d 19 00 00 	mov    %rax,0x196d(%rip)        # 103050 <free_list_tail>
  1016e3:	eb c0                	jmp    1016a5 <remove_free_list_node+0x12>

00000000001016e5 <append_alloc_list_node>:

void append_alloc_list_node(alloc_header *header) {
    header->next = NULL;
  1016e5:	48 c7 47 08 00 00 00 	movq   $0x0,0x8(%rdi)
  1016ec:	00 
    header->prev = NULL;
  1016ed:	48 c7 07 00 00 00 00 	movq   $0x0,(%rdi)
    if (alloc_list_head == NULL && alloc_list_tail == NULL) {
  1016f4:	48 83 3d 44 19 00 00 	cmpq   $0x0,0x1944(%rip)        # 103040 <alloc_list_head>
  1016fb:	00 
  1016fc:	74 1d                	je     10171b <append_alloc_list_node+0x36>
        alloc_list_head = header;
        alloc_list_tail = header;
    } else {
        alloc_list_tail->next = header;
  1016fe:	48 8b 05 33 19 00 00 	mov    0x1933(%rip),%rax        # 103038 <alloc_list_tail>
  101705:	48 89 78 08          	mov    %rdi,0x8(%rax)
        header->prev = alloc_list_tail;
  101709:	48 89 07             	mov    %rax,(%rdi)
        alloc_list_tail = header;
  10170c:	48 89 3d 25 19 00 00 	mov    %rdi,0x1925(%rip)        # 103038 <alloc_list_tail>
        alloc_list_tail = header;
    }
    alloc_list_length++;
  101713:	83 05 16 19 00 00 01 	addl   $0x1,0x1916(%rip)        # 103030 <alloc_list_length>
}
  10171a:	c3                   	retq   
    if (alloc_list_head == NULL && alloc_list_tail == NULL) {
  10171b:	48 83 3d 15 19 00 00 	cmpq   $0x0,0x1915(%rip)        # 103038 <alloc_list_tail>
  101722:	00 
  101723:	75 d9                	jne    1016fe <append_alloc_list_node+0x19>
        alloc_list_head = header;
  101725:	48 89 3d 14 19 00 00 	mov    %rdi,0x1914(%rip)        # 103040 <alloc_list_head>
        alloc_list_tail = header;
  10172c:	eb de                	jmp    10170c <append_alloc_list_node+0x27>

000000000010172e <remove_alloc_list_node>:

void remove_alloc_list_node(alloc_header *header) {
    if (header == alloc_list_head) alloc_list_head = header->next;
  10172e:	48 39 3d 0b 19 00 00 	cmp    %rdi,0x190b(%rip)        # 103040 <alloc_list_head>
  101735:	74 30                	je     101767 <remove_alloc_list_node+0x39>
    if (header == alloc_list_tail) alloc_list_tail = header->prev;
  101737:	48 39 3d fa 18 00 00 	cmp    %rdi,0x18fa(%rip)        # 103038 <alloc_list_tail>
  10173e:	74 34                	je     101774 <remove_alloc_list_node+0x46>
    if (header->prev != NULL) header->prev->next = header->next;
  101740:	48 8b 07             	mov    (%rdi),%rax
  101743:	48 85 c0             	test   %rax,%rax
  101746:	74 08                	je     101750 <remove_alloc_list_node+0x22>
  101748:	48 8b 57 08          	mov    0x8(%rdi),%rdx
  10174c:	48 89 50 08          	mov    %rdx,0x8(%rax)
    if (header->next != NULL) header->next->prev = header->prev;
  101750:	48 8b 47 08          	mov    0x8(%rdi),%rax
  101754:	48 85 c0             	test   %rax,%rax
  101757:	74 06                	je     10175f <remove_alloc_list_node+0x31>
  101759:	48 8b 17             	mov    (%rdi),%rdx
  10175c:	48 89 10             	mov    %rdx,(%rax)
    alloc_list_length--;
  10175f:	83 2d ca 18 00 00 01 	subl   $0x1,0x18ca(%rip)        # 103030 <alloc_list_length>
}
  101766:	c3                   	retq   
    if (header == alloc_list_head) alloc_list_head = header->next;
  101767:	48 8b 47 08          	mov    0x8(%rdi),%rax
  10176b:	48 89 05 ce 18 00 00 	mov    %rax,0x18ce(%rip)        # 103040 <alloc_list_head>
  101772:	eb c3                	jmp    101737 <remove_alloc_list_node+0x9>
    if (header == alloc_list_tail) alloc_list_tail = header->prev;
  101774:	48 8b 07             	mov    (%rdi),%rax
  101777:	48 89 05 ba 18 00 00 	mov    %rax,0x18ba(%rip)        # 103038 <alloc_list_tail>
  10177e:	eb c0                	jmp    101740 <remove_alloc_list_node+0x12>

0000000000101780 <get_free_block>:

struct free_list_node *get_free_block(uint64_t payload_sz) {
    free_list_node *ptr = free_list_head;
  101780:	48 8b 05 d1 18 00 00 	mov    0x18d1(%rip),%rax        # 103058 <free_list_head>
    while (ptr != NULL) {
  101787:	48 85 c0             	test   %rax,%rax
  10178a:	74 13                	je     10179f <get_free_block+0x1f>
        if (ptr->sz >= ALLOC_HEADER_SIZE + payload_sz) return ptr;
  10178c:	48 83 c7 18          	add    $0x18,%rdi
  101790:	48 39 78 10          	cmp    %rdi,0x10(%rax)
  101794:	73 09                	jae    10179f <get_free_block+0x1f>
        ptr = ptr->next;
  101796:	48 8b 40 08          	mov    0x8(%rax),%rax
    while (ptr != NULL) {
  10179a:	48 85 c0             	test   %rax,%rax
  10179d:	75 f1                	jne    101790 <get_free_block+0x10>
    }
    return NULL;
}
  10179f:	c3                   	retq   

00000000001017a0 <extend_heap>:


struct free_list_node *extend_heap(size_t sz) {
  1017a0:	55                   	push   %rbp
  1017a1:	48 89 e5             	mov    %rsp,%rbp
  1017a4:	53                   	push   %rbx
  1017a5:	48 83 ec 08          	sub    $0x8,%rsp
    size_t heap_extension = ROUNDUP(sz, BREAK_INCREMENT);
  1017a9:	48 8d 97 ff 9f 00 00 	lea    0x9fff(%rdi),%rdx
  1017b0:	48 b9 cd cc cc cc cc 	movabs $0xcccccccccccccccd,%rcx
  1017b7:	cc cc cc 
  1017ba:	48 89 d0             	mov    %rdx,%rax
  1017bd:	48 f7 e1             	mul    %rcx
  1017c0:	48 c1 ea 0f          	shr    $0xf,%rdx
  1017c4:	48 8d 3c 92          	lea    (%rdx,%rdx,4),%rdi
  1017c8:	48 c1 e7 0d          	shl    $0xd,%rdi
    asm volatile ("int %1" :  "=a" (result)
  1017cc:	cd 3a                	int    $0x3a
  1017ce:	48 89 05 8b 18 00 00 	mov    %rax,0x188b(%rip)        # 103060 <result.0>
    void *start = sbrk(heap_extension);
    if (start == (void *) -1) return NULL;
  1017d5:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  1017d9:	74 18                	je     1017f3 <extend_heap+0x53>
  1017db:	48 89 c3             	mov    %rax,%rbx
    struct free_list_node *node = (struct free_list_node *) start;
    node->sz = heap_extension;
  1017de:	48 89 78 10          	mov    %rdi,0x10(%rax)
    append_free_list_node(node);
  1017e2:	48 89 c7             	mov    %rax,%rdi
  1017e5:	e8 60 fe ff ff       	callq  10164a <append_free_list_node>
    return node;
}
  1017ea:	48 89 d8             	mov    %rbx,%rax
  1017ed:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  1017f1:	c9                   	leaveq 
  1017f2:	c3                   	retq   
    if (start == (void *) -1) return NULL;
  1017f3:	bb 00 00 00 00       	mov    $0x0,%ebx
  1017f8:	eb f0                	jmp    1017ea <extend_heap+0x4a>

00000000001017fa <allocate_to_free_block>:

// returns address of the block (alloc_header) if allocated properly
// NULL if there was no space
uintptr_t allocate_to_free_block(uint64_t sz) {
  1017fa:	55                   	push   %rbp
  1017fb:	48 89 e5             	mov    %rsp,%rbp
  1017fe:	41 56                	push   %r14
  101800:	41 55                	push   %r13
  101802:	41 54                	push   %r12
  101804:	53                   	push   %rbx
  101805:	48 89 fb             	mov    %rdi,%rbx
    // find a free block
    free_list_node *free_block = get_free_block(sz);
  101808:	e8 73 ff ff ff       	callq  101780 <get_free_block>
    if (free_block == NULL) return (uintptr_t) -1;
  10180d:	48 85 c0             	test   %rax,%rax
  101810:	74 54                	je     101866 <allocate_to_free_block+0x6c>
  101812:	49 89 c4             	mov    %rax,%r12

    // remove that free block
    uintptr_t block_addr = (uintptr_t) free_block;
  101815:	49 89 c6             	mov    %rax,%r14
    size_t block_size = free_block->sz;
  101818:	4c 8b 68 10          	mov    0x10(%rax),%r13
    remove_free_list_node(free_block);
  10181c:	48 89 c7             	mov    %rax,%rdi
  10181f:	e8 6f fe ff ff       	callq  101693 <remove_free_list_node>

    // replace it with an alloc_header
    struct alloc_header *header = (struct alloc_header *) block_addr;
    size_t payload_size = ROUNDUP(sz, ALIGNMENT);
  101824:	48 83 c3 07          	add    $0x7,%rbx
  101828:	48 83 e3 f8          	and    $0xfffffffffffffff8,%rbx
    size_t min_payload_size = FREE_LIST_NODE_SIZE - ALLOC_HEADER_SIZE;
    if (payload_size < min_payload_size) payload_size = min_payload_size;
    header->sz = payload_size;
  10182c:	49 89 5c 24 10       	mov    %rbx,0x10(%r12)
    append_alloc_list_node(header);
  101831:	4c 89 e7             	mov    %r12,%rdi
  101834:	e8 ac fe ff ff       	callq  1016e5 <append_alloc_list_node>

    // leftover stuff
    size_t data_size = ALLOC_HEADER_SIZE + payload_size;
  101839:	48 83 c3 18          	add    $0x18,%rbx
    size_t leftover = block_size - data_size;
  10183d:	49 29 dd             	sub    %rbx,%r13

    if (leftover >= FREE_LIST_NODE_SIZE) {
  101840:	49 83 fd 17          	cmp    $0x17,%r13
  101844:	77 11                	ja     101857 <allocate_to_free_block+0x5d>
        struct free_list_node *node = (struct free_list_node *) (block_addr + data_size);
        node->sz = leftover;
        append_free_list_node(node);
    } else header->sz += leftover;
  101846:	4d 01 6c 24 10       	add    %r13,0x10(%r12)

    return block_addr;
}
  10184b:	4c 89 f0             	mov    %r14,%rax
  10184e:	5b                   	pop    %rbx
  10184f:	41 5c                	pop    %r12
  101851:	41 5d                	pop    %r13
  101853:	41 5e                	pop    %r14
  101855:	5d                   	pop    %rbp
  101856:	c3                   	retq   
        struct free_list_node *node = (struct free_list_node *) (block_addr + data_size);
  101857:	49 8d 3c 1c          	lea    (%r12,%rbx,1),%rdi
        node->sz = leftover;
  10185b:	4c 89 6f 10          	mov    %r13,0x10(%rdi)
        append_free_list_node(node);
  10185f:	e8 e6 fd ff ff       	callq  10164a <append_free_list_node>
  101864:	eb e5                	jmp    10184b <allocate_to_free_block+0x51>
    if (free_block == NULL) return (uintptr_t) -1;
  101866:	49 c7 c6 ff ff ff ff 	mov    $0xffffffffffffffff,%r14
  10186d:	eb dc                	jmp    10184b <allocate_to_free_block+0x51>

000000000010186f <malloc>:
// allocates sz bytes of uninitialized memory and returns a pointer to the allocated memory
// if sz == 0, then malloc() either returns NULL or a unique pointer value that can be
// successfully passed to a later free
// the pointer should be aligned to 8 bytes
void *malloc(uint64_t sz) {
    if (sz == 0) return NULL;
  10186f:	b8 00 00 00 00       	mov    $0x0,%eax
  101874:	48 85 ff             	test   %rdi,%rdi
  101877:	74 3c                	je     1018b5 <malloc+0x46>
void *malloc(uint64_t sz) {
  101879:	55                   	push   %rbp
  10187a:	48 89 e5             	mov    %rsp,%rbp
  10187d:	53                   	push   %rbx
  10187e:	48 83 ec 08          	sub    $0x8,%rsp
  101882:	48 89 fb             	mov    %rdi,%rbx

    uintptr_t block_addr = allocate_to_free_block(sz);
  101885:	e8 70 ff ff ff       	callq  1017fa <allocate_to_free_block>
    while (block_addr == (uintptr_t) -1) {
  10188a:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  10188e:	75 1b                	jne    1018ab <malloc+0x3c>
        if (extend_heap(sz) == NULL) return NULL;
  101890:	48 89 df             	mov    %rbx,%rdi
  101893:	e8 08 ff ff ff       	callq  1017a0 <extend_heap>
  101898:	48 85 c0             	test   %rax,%rax
  10189b:	74 12                	je     1018af <malloc+0x40>
        block_addr = allocate_to_free_block(sz);
  10189d:	48 89 df             	mov    %rbx,%rdi
  1018a0:	e8 55 ff ff ff       	callq  1017fa <allocate_to_free_block>
    while (block_addr == (uintptr_t) -1) {
  1018a5:	48 83 f8 ff          	cmp    $0xffffffffffffffff,%rax
  1018a9:	74 e5                	je     101890 <malloc+0x21>
    }

    return (void *) (block_addr + ALLOC_HEADER_SIZE);
  1018ab:	48 83 c0 18          	add    $0x18,%rax
}
  1018af:	48 8b 5d f8          	mov    -0x8(%rbp),%rbx
  1018b3:	c9                   	leaveq 
  1018b4:	c3                   	retq   
  1018b5:	c3                   	retq   

00000000001018b6 <overflow>:
// to the allocated array. The memory is set to 0. if num or sz is equal to 0, then calloc
// returns NULL or a unique pointer value that can be successfully passed to a later free
// calloc also checks for size overflow caused by num*sz
// returns NULL on failure
int overflow(uint64_t a, uint64_t b) {
    return a * b / a != b || a * b / b != a;
  1018b6:	48 89 f9             	mov    %rdi,%rcx
  1018b9:	48 0f af ce          	imul   %rsi,%rcx
  1018bd:	48 89 c8             	mov    %rcx,%rax
  1018c0:	ba 00 00 00 00       	mov    $0x0,%edx
  1018c5:	48 f7 f7             	div    %rdi
  1018c8:	ba 01 00 00 00       	mov    $0x1,%edx
  1018cd:	48 39 f0             	cmp    %rsi,%rax
  1018d0:	74 03                	je     1018d5 <overflow+0x1f>
}
  1018d2:	89 d0                	mov    %edx,%eax
  1018d4:	c3                   	retq   
    return a * b / a != b || a * b / b != a;
  1018d5:	48 89 c8             	mov    %rcx,%rax
  1018d8:	ba 00 00 00 00       	mov    $0x0,%edx
  1018dd:	48 f7 f6             	div    %rsi
  1018e0:	48 39 f8             	cmp    %rdi,%rax
  1018e3:	0f 95 c2             	setne  %dl
  1018e6:	0f b6 d2             	movzbl %dl,%edx
  1018e9:	eb e7                	jmp    1018d2 <overflow+0x1c>

00000000001018eb <calloc>:

void *calloc(uint64_t num, uint64_t sz) {
  1018eb:	55                   	push   %rbp
  1018ec:	48 89 e5             	mov    %rsp,%rbp
  1018ef:	41 55                	push   %r13
  1018f1:	41 54                	push   %r12
  1018f3:	53                   	push   %rbx
  1018f4:	48 83 ec 08          	sub    $0x8,%rsp
    if (num == 0 || sz == 0 || overflow(num, sz)) return NULL;
  1018f8:	48 85 ff             	test   %rdi,%rdi
  1018fb:	74 54                	je     101951 <calloc+0x66>
  1018fd:	48 89 fb             	mov    %rdi,%rbx
  101900:	49 89 f4             	mov    %rsi,%r12
  101903:	48 85 f6             	test   %rsi,%rsi
  101906:	74 49                	je     101951 <calloc+0x66>
  101908:	e8 a9 ff ff ff       	callq  1018b6 <overflow>
  10190d:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  101913:	85 c0                	test   %eax,%eax
  101915:	75 2c                	jne    101943 <calloc+0x58>

    size_t size = ROUNDUP(num * sz, ALIGNMENT);
  101917:	49 0f af dc          	imul   %r12,%rbx
  10191b:	48 83 c3 07          	add    $0x7,%rbx
  10191f:	48 83 e3 f8          	and    $0xfffffffffffffff8,%rbx
    void *malloc_addr = malloc(size);
  101923:	48 89 df             	mov    %rbx,%rdi
  101926:	e8 44 ff ff ff       	callq  10186f <malloc>
  10192b:	49 89 c5             	mov    %rax,%r13
    if (malloc_addr == NULL) return NULL;
  10192e:	48 85 c0             	test   %rax,%rax
  101931:	74 10                	je     101943 <calloc+0x58>

    memset(malloc_addr, 0, size);
  101933:	48 89 da             	mov    %rbx,%rdx
  101936:	be 00 00 00 00       	mov    $0x0,%esi
  10193b:	48 89 c7             	mov    %rax,%rdi
  10193e:	e8 0a ef ff ff       	callq  10084d <memset>
    return malloc_addr;
}
  101943:	4c 89 e8             	mov    %r13,%rax
  101946:	48 83 c4 08          	add    $0x8,%rsp
  10194a:	5b                   	pop    %rbx
  10194b:	41 5c                	pop    %r12
  10194d:	41 5d                	pop    %r13
  10194f:	5d                   	pop    %rbp
  101950:	c3                   	retq   
    if (num == 0 || sz == 0 || overflow(num, sz)) return NULL;
  101951:	41 bd 00 00 00 00    	mov    $0x0,%r13d
  101957:	eb ea                	jmp    101943 <calloc+0x58>

0000000000101959 <free>:
// the free funtion frees the memory space pointed to by ptr, which must have been returned
// by a previous call to malloc or realloc, or if free has already been called before, then
// undefined behavior occurs
// if ptr == NULL, then no operation happens
void free(void *ptr) {
    if (ptr == NULL) return;
  101959:	48 85 ff             	test   %rdi,%rdi
  10195c:	74 2c                	je     10198a <free+0x31>
void free(void *ptr) {
  10195e:	55                   	push   %rbp
  10195f:	48 89 e5             	mov    %rsp,%rbp
  101962:	41 54                	push   %r12
  101964:	53                   	push   %rbx

    uintptr_t block_addr = (uintptr_t) ptr - ALLOC_HEADER_SIZE;
  101965:	48 8d 5f e8          	lea    -0x18(%rdi),%rbx
    struct alloc_header *header = (struct alloc_header *) block_addr;
    size_t block_size = ALLOC_HEADER_SIZE + header->sz;
  101969:	48 8b 47 f8          	mov    -0x8(%rdi),%rax
  10196d:	4c 8d 60 18          	lea    0x18(%rax),%r12
    remove_alloc_list_node(header);
  101971:	48 89 df             	mov    %rbx,%rdi
  101974:	e8 b5 fd ff ff       	callq  10172e <remove_alloc_list_node>

    struct free_list_node *node = (struct free_list_node *) block_addr;
    node->sz = block_size;
  101979:	4c 89 63 10          	mov    %r12,0x10(%rbx)
    append_free_list_node(node);
  10197d:	48 89 df             	mov    %rbx,%rdi
  101980:	e8 c5 fc ff ff       	callq  10164a <append_free_list_node>
    return;
}
  101985:	5b                   	pop    %rbx
  101986:	41 5c                	pop    %r12
  101988:	5d                   	pop    %rbp
  101989:	c3                   	retq   
  10198a:	c3                   	retq   

000000000010198b <realloc>:
void *realloc(void * ptr, uint64_t sz) {
  10198b:	55                   	push   %rbp
  10198c:	48 89 e5             	mov    %rsp,%rbp
  10198f:	41 54                	push   %r12
  101991:	53                   	push   %rbx
    if (ptr == NULL) return malloc(sz);
  101992:	48 85 ff             	test   %rdi,%rdi
  101995:	74 40                	je     1019d7 <realloc+0x4c>
  101997:	48 89 fb             	mov    %rdi,%rbx
    if (sz == 0) { free(ptr); return NULL; }
  10199a:	48 85 f6             	test   %rsi,%rsi
  10199d:	74 45                	je     1019e4 <realloc+0x59>
    if (original_sz == sz) return ptr;
  10199f:	49 89 fc             	mov    %rdi,%r12
  1019a2:	48 3b 77 f8          	cmp    -0x8(%rdi),%rsi
  1019a6:	74 27                	je     1019cf <realloc+0x44>
    void *malloc_addr = malloc(sz);
  1019a8:	48 89 f7             	mov    %rsi,%rdi
  1019ab:	e8 bf fe ff ff       	callq  10186f <malloc>
  1019b0:	49 89 c4             	mov    %rax,%r12
    if (malloc_addr == NULL) return NULL;
  1019b3:	48 85 c0             	test   %rax,%rax
  1019b6:	74 17                	je     1019cf <realloc+0x44>
    memcpy(malloc_addr, ptr, header->sz);
  1019b8:	48 8b 50 f8          	mov    -0x8(%rax),%rdx
  1019bc:	48 89 de             	mov    %rbx,%rsi
  1019bf:	48 89 c7             	mov    %rax,%rdi
  1019c2:	e8 1d ee ff ff       	callq  1007e4 <memcpy>
    free(ptr);
  1019c7:	48 89 df             	mov    %rbx,%rdi
  1019ca:	e8 8a ff ff ff       	callq  101959 <free>
}
  1019cf:	4c 89 e0             	mov    %r12,%rax
  1019d2:	5b                   	pop    %rbx
  1019d3:	41 5c                	pop    %r12
  1019d5:	5d                   	pop    %rbp
  1019d6:	c3                   	retq   
    if (ptr == NULL) return malloc(sz);
  1019d7:	48 89 f7             	mov    %rsi,%rdi
  1019da:	e8 90 fe ff ff       	callq  10186f <malloc>
  1019df:	49 89 c4             	mov    %rax,%r12
  1019e2:	eb eb                	jmp    1019cf <realloc+0x44>
    if (sz == 0) { free(ptr); return NULL; }
  1019e4:	e8 70 ff ff ff       	callq  101959 <free>
  1019e9:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  1019ef:	eb de                	jmp    1019cf <realloc+0x44>

00000000001019f1 <adjacent>:

int adjacent(ptr_with_size *ptrs_with_size, int i, int j) {
    ptr_with_size a = ptrs_with_size[i];
  1019f1:	48 63 f6             	movslq %esi,%rsi
  1019f4:	48 c1 e6 04          	shl    $0x4,%rsi
  1019f8:	48 01 fe             	add    %rdi,%rsi
    ptr_with_size b = ptrs_with_size[j];
    return (uintptr_t) a.ptr + a.size == (uintptr_t) b.ptr;
  1019fb:	48 8b 46 08          	mov    0x8(%rsi),%rax
  1019ff:	48 03 06             	add    (%rsi),%rax
    ptr_with_size b = ptrs_with_size[j];
  101a02:	48 63 d2             	movslq %edx,%rdx
  101a05:	48 c1 e2 04          	shl    $0x4,%rdx
    return (uintptr_t) a.ptr + a.size == (uintptr_t) b.ptr;
  101a09:	48 39 04 17          	cmp    %rax,(%rdi,%rdx,1)
  101a0d:	0f 94 c0             	sete   %al
  101a10:	0f b6 c0             	movzbl %al,%eax
}
  101a13:	c3                   	retq   

0000000000101a14 <coalesce>:

void coalesce(ptr_with_size *ptrs_with_size, int i, int j) {
  101a14:	55                   	push   %rbp
  101a15:	48 89 e5             	mov    %rsp,%rbp
    struct free_list_node *node_a = (struct free_list_node *) ptrs_with_size[i].ptr;
  101a18:	48 63 f6             	movslq %esi,%rsi
  101a1b:	48 c1 e6 04          	shl    $0x4,%rsi
  101a1f:	48 8b 04 37          	mov    (%rdi,%rsi,1),%rax
    struct free_list_node *node_b = (struct free_list_node *) ptrs_with_size[j].ptr;
  101a23:	48 63 d2             	movslq %edx,%rdx
  101a26:	48 c1 e2 04          	shl    $0x4,%rdx
  101a2a:	48 8b 3c 17          	mov    (%rdi,%rdx,1),%rdi
    node_a->sz += node_b->sz;
  101a2e:	48 8b 57 10          	mov    0x10(%rdi),%rdx
  101a32:	48 01 50 10          	add    %rdx,0x10(%rax)
    remove_free_list_node(node_b);
  101a36:	e8 58 fc ff ff       	callq  101693 <remove_free_list_node>
}
  101a3b:	5d                   	pop    %rbp
  101a3c:	c3                   	retq   

0000000000101a3d <defrag>:

void defrag() {
  101a3d:	55                   	push   %rbp
  101a3e:	48 89 e5             	mov    %rsp,%rbp
  101a41:	41 56                	push   %r14
  101a43:	41 55                	push   %r13
  101a45:	41 54                	push   %r12
  101a47:	53                   	push   %rbx
    ptr_with_size ptrs_with_size[free_list_length];
  101a48:	8b 0d fa 15 00 00    	mov    0x15fa(%rip),%ecx        # 103048 <free_list_length>
  101a4e:	48 63 f1             	movslq %ecx,%rsi
  101a51:	48 89 f0             	mov    %rsi,%rax
  101a54:	48 c1 e0 04          	shl    $0x4,%rax
  101a58:	48 29 c4             	sub    %rax,%rsp
  101a5b:	49 89 e5             	mov    %rsp,%r13
    free_list_node *curr = free_list_head;
  101a5e:	48 8b 15 f3 15 00 00 	mov    0x15f3(%rip),%rdx        # 103058 <free_list_head>
    for (int i = 0; i < free_list_length; i++, curr = curr->next) {
  101a65:	85 c9                	test   %ecx,%ecx
  101a67:	7e 24                	jle    101a8d <defrag+0x50>
  101a69:	4c 89 e8             	mov    %r13,%rax
  101a6c:	89 c9                	mov    %ecx,%ecx
  101a6e:	48 c1 e1 04          	shl    $0x4,%rcx
  101a72:	4c 01 e9             	add    %r13,%rcx
        ptrs_with_size[i].ptr = curr;
  101a75:	48 89 10             	mov    %rdx,(%rax)
        ptrs_with_size[i].size = curr->sz;
  101a78:	48 8b 7a 10          	mov    0x10(%rdx),%rdi
  101a7c:	48 89 78 08          	mov    %rdi,0x8(%rax)
    for (int i = 0; i < free_list_length; i++, curr = curr->next) {
  101a80:	48 8b 52 08          	mov    0x8(%rdx),%rdx
  101a84:	48 83 c0 10          	add    $0x10,%rax
  101a88:	48 39 c8             	cmp    %rcx,%rax
  101a8b:	75 e8                	jne    101a75 <defrag+0x38>
    }
    __quicksort(ptrs_with_size, free_list_length, sizeof(ptrs_with_size[0]), &cmp_ptr_ascending);
  101a8d:	b9 59 11 10 00       	mov    $0x101159,%ecx
  101a92:	ba 10 00 00 00       	mov    $0x10,%edx
  101a97:	4c 89 ef             	mov    %r13,%rdi
  101a9a:	e8 c8 f6 ff ff       	callq  101167 <__quicksort>

    int i = 0, length = free_list_length;
  101a9f:	44 8b 35 a2 15 00 00 	mov    0x15a2(%rip),%r14d        # 103048 <free_list_length>
    for (int j = 1; j < length; j++) {
  101aa6:	41 83 fe 01          	cmp    $0x1,%r14d
  101aaa:	7e 38                	jle    101ae4 <defrag+0xa7>
  101aac:	bb 01 00 00 00       	mov    $0x1,%ebx
    int i = 0, length = free_list_length;
  101ab1:	41 bc 00 00 00 00    	mov    $0x0,%r12d
  101ab7:	eb 15                	jmp    101ace <defrag+0x91>
        if (adjacent(ptrs_with_size, i, j)) coalesce(ptrs_with_size, i, j);
  101ab9:	89 da                	mov    %ebx,%edx
  101abb:	44 89 e6             	mov    %r12d,%esi
  101abe:	4c 89 ef             	mov    %r13,%rdi
  101ac1:	e8 4e ff ff ff       	callq  101a14 <coalesce>
    for (int j = 1; j < length; j++) {
  101ac6:	83 c3 01             	add    $0x1,%ebx
  101ac9:	41 39 de             	cmp    %ebx,%r14d
  101acc:	74 16                	je     101ae4 <defrag+0xa7>
        if (adjacent(ptrs_with_size, i, j)) coalesce(ptrs_with_size, i, j);
  101ace:	89 da                	mov    %ebx,%edx
  101ad0:	44 89 e6             	mov    %r12d,%esi
  101ad3:	4c 89 ef             	mov    %r13,%rdi
  101ad6:	e8 16 ff ff ff       	callq  1019f1 <adjacent>
  101adb:	85 c0                	test   %eax,%eax
  101add:	75 da                	jne    101ab9 <defrag+0x7c>
  101adf:	41 89 dc             	mov    %ebx,%r12d
  101ae2:	eb e2                	jmp    101ac6 <defrag+0x89>
        else i = j;
    }
}
  101ae4:	48 8d 65 e0          	lea    -0x20(%rbp),%rsp
  101ae8:	5b                   	pop    %rbx
  101ae9:	41 5c                	pop    %r12
  101aeb:	41 5d                	pop    %r13
  101aed:	41 5e                	pop    %r14
  101aef:	5d                   	pop    %rbp
  101af0:	c3                   	retq   

0000000000101af1 <heap_info>:
// the user, i.e. the process will be responsible for freeing these allocations
// note that the allocations used by the heap_info_struct will count as metadata
// and should NOT be included in the heap info
// return 0 for a successfull call
// if for any reason the information cannot be saved, return -1
int heap_info(heap_info_struct * info) {
  101af1:	55                   	push   %rbp
  101af2:	48 89 e5             	mov    %rsp,%rbp
  101af5:	41 57                	push   %r15
  101af7:	41 56                	push   %r14
  101af9:	41 55                	push   %r13
  101afb:	41 54                	push   %r12
  101afd:	53                   	push   %rbx
  101afe:	48 83 ec 18          	sub    $0x18,%rsp
  101b02:	49 89 fd             	mov    %rdi,%r13
    int init_alloc_list_length = alloc_list_length;
  101b05:	44 8b 3d 24 15 00 00 	mov    0x1524(%rip),%r15d        # 103030 <alloc_list_length>
    // free space + largest free chunk
    int largest_free_chunk = 0;
    int free_space = 0;
    free_list_node *curr_ = free_list_head;
  101b0c:	48 8b 05 45 15 00 00 	mov    0x1545(%rip),%rax        # 103058 <free_list_head>
    for (int i = 0; i < free_list_length; i++, curr_ = curr_->next) {
  101b13:	8b 3d 2f 15 00 00    	mov    0x152f(%rip),%edi        # 103048 <free_list_length>
  101b19:	85 ff                	test   %edi,%edi
  101b1b:	7e 5c                	jle    101b79 <heap_info+0x88>
  101b1d:	ba 00 00 00 00       	mov    $0x0,%edx
    int free_space = 0;
  101b22:	41 bc 00 00 00 00    	mov    $0x0,%r12d
    int largest_free_chunk = 0;
  101b28:	bb 00 00 00 00       	mov    $0x0,%ebx
        int sz = (int) curr_->sz;
  101b2d:	48 8b 48 10          	mov    0x10(%rax),%rcx
        largest_free_chunk = MAX(largest_free_chunk, sz);
  101b31:	39 cb                	cmp    %ecx,%ebx
  101b33:	0f 4c d9             	cmovl  %ecx,%ebx
        free_space += sz;
  101b36:	41 01 cc             	add    %ecx,%r12d
    for (int i = 0; i < free_list_length; i++, curr_ = curr_->next) {
  101b39:	83 c2 01             	add    $0x1,%edx
  101b3c:	48 8b 40 08          	mov    0x8(%rax),%rax
  101b40:	39 fa                	cmp    %edi,%edx
  101b42:	75 e9                	jne    101b2d <heap_info+0x3c>
    }

    // size + ptr arrays
    if (init_alloc_list_length == 0) {
  101b44:	45 85 ff             	test   %r15d,%r15d
  101b47:	75 3d                	jne    101b86 <heap_info+0x95>
        info->size_array = NULL;
  101b49:	49 c7 45 08 00 00 00 	movq   $0x0,0x8(%r13)
  101b50:	00 
        info->ptr_array = NULL;
  101b51:	49 c7 45 10 00 00 00 	movq   $0x0,0x10(%r13)
  101b58:	00 
        info->ptr_array = ptr_array;

        free(ptrs_with_size);
    }

    info->num_allocs = init_alloc_list_length;
  101b59:	45 89 7d 00          	mov    %r15d,0x0(%r13)
    info->largest_free_chunk = largest_free_chunk;
  101b5d:	41 89 5d 1c          	mov    %ebx,0x1c(%r13)
    info->free_space = free_space;
  101b61:	45 89 65 18          	mov    %r12d,0x18(%r13)

    return 0;
  101b65:	b8 00 00 00 00       	mov    $0x0,%eax
  101b6a:	48 83 c4 18          	add    $0x18,%rsp
  101b6e:	5b                   	pop    %rbx
  101b6f:	41 5c                	pop    %r12
  101b71:	41 5d                	pop    %r13
  101b73:	41 5e                	pop    %r14
  101b75:	41 5f                	pop    %r15
  101b77:	5d                   	pop    %rbp
  101b78:	c3                   	retq   
    int free_space = 0;
  101b79:	41 bc 00 00 00 00    	mov    $0x0,%r12d
    int largest_free_chunk = 0;
  101b7f:	bb 00 00 00 00       	mov    $0x0,%ebx
  101b84:	eb be                	jmp    101b44 <heap_info+0x53>
        ptr_with_size *ptrs_with_size = (ptr_with_size *) malloc(sizeof(ptr_with_size) * init_alloc_list_length);
  101b86:	49 63 c7             	movslq %r15d,%rax
  101b89:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
  101b8d:	48 89 c7             	mov    %rax,%rdi
  101b90:	48 c1 e7 04          	shl    $0x4,%rdi
  101b94:	e8 d6 fc ff ff       	callq  10186f <malloc>
  101b99:	49 89 c6             	mov    %rax,%r14
        alloc_header *curr = alloc_list_head;
  101b9c:	48 8b 15 9d 14 00 00 	mov    0x149d(%rip),%rdx        # 103040 <alloc_list_head>
        for (int i = 0; i < init_alloc_list_length; i++, curr = curr->next) {
  101ba3:	45 85 ff             	test   %r15d,%r15d
  101ba6:	0f 8e c0 00 00 00    	jle    101c6c <heap_info+0x17b>
  101bac:	44 89 fe             	mov    %r15d,%esi
  101baf:	48 c1 e6 04          	shl    $0x4,%rsi
  101bb3:	48 01 c6             	add    %rax,%rsi
            ptrs_with_size[i].ptr = (void *) ((uintptr_t) curr + ALLOC_HEADER_SIZE);
  101bb6:	48 8d 4a 18          	lea    0x18(%rdx),%rcx
  101bba:	48 89 08             	mov    %rcx,(%rax)
            ptrs_with_size[i].size = curr->sz;
  101bbd:	48 8b 4a 10          	mov    0x10(%rdx),%rcx
  101bc1:	48 89 48 08          	mov    %rcx,0x8(%rax)
        for (int i = 0; i < init_alloc_list_length; i++, curr = curr->next) {
  101bc5:	48 8b 52 08          	mov    0x8(%rdx),%rdx
  101bc9:	48 83 c0 10          	add    $0x10,%rax
  101bcd:	48 39 f0             	cmp    %rsi,%rax
  101bd0:	75 e4                	jne    101bb6 <heap_info+0xc5>
        __quicksort(ptrs_with_size, init_alloc_list_length, sizeof(ptrs_with_size[0]), &cmp_size_descending);
  101bd2:	b9 5f 11 10 00       	mov    $0x10115f,%ecx
  101bd7:	ba 10 00 00 00       	mov    $0x10,%edx
  101bdc:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  101be0:	4c 89 f7             	mov    %r14,%rdi
  101be3:	e8 7f f5 ff ff       	callq  101167 <__quicksort>
        long *size_array = (long *) malloc(sizeof(long) * init_alloc_list_length);
  101be8:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  101bec:	48 c1 e0 03          	shl    $0x3,%rax
  101bf0:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  101bf4:	48 89 c7             	mov    %rax,%rdi
  101bf7:	e8 73 fc ff ff       	callq  10186f <malloc>
  101bfc:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        void **ptr_array = (void **) malloc(sizeof(void *) * init_alloc_list_length);
  101c00:	48 8b 7d c0          	mov    -0x40(%rbp),%rdi
  101c04:	e8 66 fc ff ff       	callq  10186f <malloc>
  101c09:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
        if (size_array == NULL || ptr_array == NULL) { free(size_array); free(ptr_array); return -1; }
  101c0d:	48 85 c0             	test   %rax,%rax
  101c10:	0f 84 9d 00 00 00    	je     101cb3 <heap_info+0x1c2>
  101c16:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  101c1b:	0f 84 92 00 00 00    	je     101cb3 <heap_info+0x1c2>
  101c21:	44 89 f9             	mov    %r15d,%ecx
  101c24:	48 c1 e1 03          	shl    $0x3,%rcx
  101c28:	b8 00 00 00 00       	mov    $0x0,%eax
            size_array[i] = ptrs_with_size[i].size;
  101c2d:	49 8b 54 46 08       	mov    0x8(%r14,%rax,2),%rdx
  101c32:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  101c36:	48 89 14 07          	mov    %rdx,(%rdi,%rax,1)
            ptr_array[i] = ptrs_with_size[i].ptr;
  101c3a:	49 8b 14 46          	mov    (%r14,%rax,2),%rdx
  101c3e:	48 8b 7d c0          	mov    -0x40(%rbp),%rdi
  101c42:	48 89 14 07          	mov    %rdx,(%rdi,%rax,1)
        for (int i = 0; i < init_alloc_list_length; i++) {
  101c46:	48 83 c0 08          	add    $0x8,%rax
  101c4a:	48 39 c8             	cmp    %rcx,%rax
  101c4d:	75 de                	jne    101c2d <heap_info+0x13c>
        info->size_array = size_array;
  101c4f:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  101c53:	49 89 45 08          	mov    %rax,0x8(%r13)
        info->ptr_array = ptr_array;
  101c57:	48 8b 45 c0          	mov    -0x40(%rbp),%rax
  101c5b:	49 89 45 10          	mov    %rax,0x10(%r13)
        free(ptrs_with_size);
  101c5f:	4c 89 f7             	mov    %r14,%rdi
  101c62:	e8 f2 fc ff ff       	callq  101959 <free>
  101c67:	e9 ed fe ff ff       	jmpq   101b59 <heap_info+0x68>
        __quicksort(ptrs_with_size, init_alloc_list_length, sizeof(ptrs_with_size[0]), &cmp_size_descending);
  101c6c:	b9 5f 11 10 00       	mov    $0x10115f,%ecx
  101c71:	ba 10 00 00 00       	mov    $0x10,%edx
  101c76:	48 8b 75 c8          	mov    -0x38(%rbp),%rsi
  101c7a:	48 89 c7             	mov    %rax,%rdi
  101c7d:	e8 e5 f4 ff ff       	callq  101167 <__quicksort>
        long *size_array = (long *) malloc(sizeof(long) * init_alloc_list_length);
  101c82:	48 8b 45 c8          	mov    -0x38(%rbp),%rax
  101c86:	48 c1 e0 03          	shl    $0x3,%rax
  101c8a:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  101c8e:	48 89 c7             	mov    %rax,%rdi
  101c91:	e8 d9 fb ff ff       	callq  10186f <malloc>
  101c96:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
        void **ptr_array = (void **) malloc(sizeof(void *) * init_alloc_list_length);
  101c9a:	48 8b 7d c0          	mov    -0x40(%rbp),%rdi
  101c9e:	e8 cc fb ff ff       	callq  10186f <malloc>
  101ca3:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
        if (size_array == NULL || ptr_array == NULL) { free(size_array); free(ptr_array); return -1; }
  101ca7:	48 83 7d c8 00       	cmpq   $0x0,-0x38(%rbp)
  101cac:	74 05                	je     101cb3 <heap_info+0x1c2>
  101cae:	48 85 c0             	test   %rax,%rax
  101cb1:	75 9c                	jne    101c4f <heap_info+0x15e>
  101cb3:	48 8b 7d c8          	mov    -0x38(%rbp),%rdi
  101cb7:	e8 9d fc ff ff       	callq  101959 <free>
  101cbc:	48 8b 7d c0          	mov    -0x40(%rbp),%rdi
  101cc0:	e8 94 fc ff ff       	callq  101959 <free>
  101cc5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101cca:	e9 9b fe ff ff       	jmpq   101b6a <heap_info+0x79>

0000000000101ccf <app_printf>:
#include "process.h"

// app_printf
//     A version of console_printf that picks a sensible color by process ID.

void app_printf(int colorid, const char* format, ...) {
  101ccf:	55                   	push   %rbp
  101cd0:	48 89 e5             	mov    %rsp,%rbp
  101cd3:	48 83 ec 50          	sub    $0x50,%rsp
  101cd7:	49 89 f2             	mov    %rsi,%r10
  101cda:	48 89 55 e0          	mov    %rdx,-0x20(%rbp)
  101cde:	48 89 4d e8          	mov    %rcx,-0x18(%rbp)
  101ce2:	4c 89 45 f0          	mov    %r8,-0x10(%rbp)
  101ce6:	4c 89 4d f8          	mov    %r9,-0x8(%rbp)
    int color;
    if (colorid < 0) {
        color = 0x0700;
  101cea:	be 00 07 00 00       	mov    $0x700,%esi
    if (colorid < 0) {
  101cef:	85 ff                	test   %edi,%edi
  101cf1:	78 2e                	js     101d21 <app_printf+0x52>
    } else {
        static const uint8_t col[] = { 0x0E, 0x0F, 0x0C, 0x0A, 0x09 };
        color = col[colorid % sizeof(col)] << 8;
  101cf3:	48 63 ff             	movslq %edi,%rdi
  101cf6:	48 ba cd cc cc cc cc 	movabs $0xcccccccccccccccd,%rdx
  101cfd:	cc cc cc 
  101d00:	48 89 f8             	mov    %rdi,%rax
  101d03:	48 f7 e2             	mul    %rdx
  101d06:	48 89 d0             	mov    %rdx,%rax
  101d09:	48 c1 e8 02          	shr    $0x2,%rax
  101d0d:	48 83 e2 fc          	and    $0xfffffffffffffffc,%rdx
  101d11:	48 01 c2             	add    %rax,%rdx
  101d14:	48 29 d7             	sub    %rdx,%rdi
  101d17:	0f b6 b7 4d 21 10 00 	movzbl 0x10214d(%rdi),%esi
  101d1e:	c1 e6 08             	shl    $0x8,%esi
    }

    va_list val;
    va_start(val, format);
  101d21:	c7 45 b8 10 00 00 00 	movl   $0x10,-0x48(%rbp)
  101d28:	48 8d 45 10          	lea    0x10(%rbp),%rax
  101d2c:	48 89 45 c0          	mov    %rax,-0x40(%rbp)
  101d30:	48 8d 45 d0          	lea    -0x30(%rbp),%rax
  101d34:	48 89 45 c8          	mov    %rax,-0x38(%rbp)
    cursorpos = console_vprintf(cursorpos, color, format, val);
  101d38:	48 8d 4d b8          	lea    -0x48(%rbp),%rcx
  101d3c:	4c 89 d2             	mov    %r10,%rdx
  101d3f:	8b 3d b7 72 fb ff    	mov    -0x48d49(%rip),%edi        # b8ffc <cursorpos>
  101d45:	e8 f3 f2 ff ff       	callq  10103d <console_vprintf>
    va_end(val);

    if (CROW(cursorpos) >= 23) {
        cursorpos = CPOS(0, 0);
  101d4a:	3d 30 07 00 00       	cmp    $0x730,%eax
  101d4f:	ba 00 00 00 00       	mov    $0x0,%edx
  101d54:	0f 4d c2             	cmovge %edx,%eax
  101d57:	89 05 9f 72 fb ff    	mov    %eax,-0x48d61(%rip)        # b8ffc <cursorpos>
    }
}
  101d5d:	c9                   	leaveq 
  101d5e:	c3                   	retq   

0000000000101d5f <kernel_panic>:


// kernel_panic, assert_fail
//     Call the INT_SYS_PANIC system call so the kernel loops until Control-C.

void kernel_panic(const char* format, ...) {
  101d5f:	55                   	push   %rbp
  101d60:	48 89 e5             	mov    %rsp,%rbp
  101d63:	53                   	push   %rbx
  101d64:	48 81 ec f8 00 00 00 	sub    $0xf8,%rsp
  101d6b:	48 89 fb             	mov    %rdi,%rbx
  101d6e:	48 89 75 c8          	mov    %rsi,-0x38(%rbp)
  101d72:	48 89 55 d0          	mov    %rdx,-0x30(%rbp)
  101d76:	48 89 4d d8          	mov    %rcx,-0x28(%rbp)
  101d7a:	4c 89 45 e0          	mov    %r8,-0x20(%rbp)
  101d7e:	4c 89 4d e8          	mov    %r9,-0x18(%rbp)
    va_list val;
    va_start(val, format);
  101d82:	c7 45 a8 08 00 00 00 	movl   $0x8,-0x58(%rbp)
  101d89:	48 8d 45 10          	lea    0x10(%rbp),%rax
  101d8d:	48 89 45 b0          	mov    %rax,-0x50(%rbp)
  101d91:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
  101d95:	48 89 45 b8          	mov    %rax,-0x48(%rbp)
    char buf[160];
    memcpy(buf, "PANIC: ", 7);
  101d99:	ba 07 00 00 00       	mov    $0x7,%edx
  101d9e:	be 19 21 10 00       	mov    $0x102119,%esi
  101da3:	48 8d bd 08 ff ff ff 	lea    -0xf8(%rbp),%rdi
  101daa:	e8 35 ea ff ff       	callq  1007e4 <memcpy>
    int len = vsnprintf(&buf[7], sizeof(buf) - 7, format, val) + 7;
  101daf:	48 8d 4d a8          	lea    -0x58(%rbp),%rcx
  101db3:	48 89 da             	mov    %rbx,%rdx
  101db6:	be 99 00 00 00       	mov    $0x99,%esi
  101dbb:	48 8d bd 0f ff ff ff 	lea    -0xf1(%rbp),%rdi
  101dc2:	e8 f1 f2 ff ff       	callq  1010b8 <vsnprintf>
  101dc7:	8d 50 07             	lea    0x7(%rax),%edx
    va_end(val);
    if (len > 0 && buf[len - 1] != '\n') {
  101dca:	85 d2                	test   %edx,%edx
  101dcc:	7e 0f                	jle    101ddd <kernel_panic+0x7e>
  101dce:	83 c0 06             	add    $0x6,%eax
  101dd1:	48 98                	cltq   
  101dd3:	80 bc 05 08 ff ff ff 	cmpb   $0xa,-0xf8(%rbp,%rax,1)
  101dda:	0a 
  101ddb:	75 2a                	jne    101e07 <kernel_panic+0xa8>
        strcpy(buf + len - (len == (int) sizeof(buf) - 1), "\n");
    }
    (void) console_printf(CPOS(23, 0), 0xC000, "%s", buf);
  101ddd:	48 8d 9d 08 ff ff ff 	lea    -0xf8(%rbp),%rbx
  101de4:	48 89 d9             	mov    %rbx,%rcx
  101de7:	ba 21 21 10 00       	mov    $0x102121,%edx
  101dec:	be 00 c0 00 00       	mov    $0xc000,%esi
  101df1:	bf 30 07 00 00       	mov    $0x730,%edi
  101df6:	b8 00 00 00 00       	mov    $0x0,%eax
  101dfb:	e8 82 f2 ff ff       	callq  101082 <console_printf>
    asm volatile ("int %0" : /* no result */
  101e00:	48 89 df             	mov    %rbx,%rdi
  101e03:	cd 30                	int    $0x30
 loop: goto loop;
  101e05:	eb fe                	jmp    101e05 <kernel_panic+0xa6>
        strcpy(buf + len - (len == (int) sizeof(buf) - 1), "\n");
  101e07:	48 63 c2             	movslq %edx,%rax
  101e0a:	81 fa 9f 00 00 00    	cmp    $0x9f,%edx
  101e10:	0f 94 c2             	sete   %dl
  101e13:	0f b6 d2             	movzbl %dl,%edx
  101e16:	48 29 d0             	sub    %rdx,%rax
  101e19:	48 8d bc 05 08 ff ff 	lea    -0xf8(%rbp,%rax,1),%rdi
  101e20:	ff 
  101e21:	be b7 1e 10 00       	mov    $0x101eb7,%esi
  101e26:	e8 7b ea ff ff       	callq  1008a6 <strcpy>
  101e2b:	eb b0                	jmp    101ddd <kernel_panic+0x7e>

0000000000101e2d <assert_fail>:
    panic(buf);
 spinloop: goto spinloop;       // should never get here
}

void assert_fail(const char* file, int line, const char* msg) {
  101e2d:	55                   	push   %rbp
  101e2e:	48 89 e5             	mov    %rsp,%rbp
  101e31:	48 89 f9             	mov    %rdi,%rcx
  101e34:	41 89 f0             	mov    %esi,%r8d
  101e37:	49 89 d1             	mov    %rdx,%r9
    (void) console_printf(CPOS(23, 0), 0xC000,
  101e3a:	ba 28 21 10 00       	mov    $0x102128,%edx
  101e3f:	be 00 c0 00 00       	mov    $0xc000,%esi
  101e44:	bf 30 07 00 00       	mov    $0x730,%edi
  101e49:	b8 00 00 00 00       	mov    $0x0,%eax
  101e4e:	e8 2f f2 ff ff       	callq  101082 <console_printf>
    asm volatile ("int %0" : /* no result */
  101e53:	bf 00 00 00 00       	mov    $0x0,%edi
  101e58:	cd 30                	int    $0x30
 loop: goto loop;
  101e5a:	eb fe                	jmp    101e5a <assert_fail+0x2d>
