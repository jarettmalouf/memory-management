#include "malloc.h"
#define BREAK_INCREMENT (PAGESIZE * 10)
#define ALIGNMENT 8
#define ALLOC_HEADER_SIZE sizeof(struct alloc_header)
#define FREE_LIST_NODE_SIZE sizeof(struct free_list_node)

// __quicksort
typedef struct ptr_with_size{
    void * ptr;
    size_t size;
} ptr_with_size;
#define SWAP(a, b, size)                                                      \
  do                                                                              \
    {                                                                              \
      size_t __size = (size);                                                      \
      char *__a = (a), *__b = (b);                                              \
      do                                                                      \
        {                                                                      \
          char __tmp = *__a;                                                      \
          *__a++ = *__b;                                                      \
          *__b++ = __tmp;                                                      \
        } while (--__size > 0);                                                      \
    } while (0)
#define MAX_THRESH 4
typedef struct
  {
    char *lo;
    char *hi;
  } stack_node;
#  define CHAR_BIT        8
#define STACK_SIZE        (CHAR_BIT * sizeof (size_t))
#define PUSH(low, high)        ((void) ((top->lo = (low)), (top->hi = (high)), ++top))
#define        POP(low, high)        ((void) (--top, (low = top->lo), (high = top->hi)))
#define        STACK_NOT_EMPTY        (stack < top)
typedef int (*__compar_fn_t) (const void *, const void *);
void
__quicksort (void *const pbase, size_t total_elems, size_t size,
            __compar_fn_t cmp)
{
    char *base_ptr = (char *) pbase;
    const size_t max_thresh = MAX_THRESH * size;
    if (total_elems == 0)
	/* Avoid lossage with unsigned arithmetic below.  */
	return;
    if (total_elems > MAX_THRESH)
    {
	char *lo = base_ptr;
	char *hi = &lo[size * (total_elems - 1)];
	stack_node stack[STACK_SIZE];
	stack_node *top = stack;
	PUSH (NULL, NULL);
	while (STACK_NOT_EMPTY)
	{
	    char *left_ptr;
	    char *right_ptr;
	    /* Select median value from among LO, MID, and HI. Rearrange
	       LO and HI so the three values are sorted. This lowers the
	       probability of picking a pathological pivot value and
	       skips a comparison for both the LEFT_PTR and RIGHT_PTR in
	       the while loops. */
	    char *mid = lo + size * ((hi - lo) / size >> 1);
	    if ((*cmp) ((void *) mid, (void *) lo) < 0)
		SWAP (mid, lo, size);
	    if ((*cmp) ((void *) hi, (void *) mid) < 0)
		SWAP (mid, hi, size);
	    else
		goto jump_over;
	    if ((*cmp) ((void *) mid, (void *) lo) < 0)
		SWAP (mid, lo, size);
jump_over:;
	  left_ptr  = lo + size;
	  right_ptr = hi - size;
	  /* Here's the famous ``collapse the walls'' section of quicksort.
	     Gotta like those tight inner loops!  They are the main reason
	     that this algorithm runs much faster than others. */
	  do
	  {
	      while ((*cmp) ((void *) left_ptr, (void *) mid) < 0)
		  left_ptr += size;
	      while ((*cmp) ((void *) mid, (void *) right_ptr) < 0)
		  right_ptr -= size;
	      if (left_ptr < right_ptr)
	      {
		  SWAP (left_ptr, right_ptr, size);
		  if (mid == left_ptr)
		      mid = right_ptr;
		  else if (mid == right_ptr)
		      mid = left_ptr;
		  left_ptr += size;
		  right_ptr -= size;
	      }
	      else if (left_ptr == right_ptr)
	      {
		  left_ptr += size;
		  right_ptr -= size;
		  break;
	      }
	  }
	  while (left_ptr <= right_ptr);
	  /* Set up pointers for next iteration.  First determine whether
	     left and right partitions are below the threshold size.  If so,
	     ignore one or both.  Otherwise, push the larger partition's
	     bounds on the stack and continue sorting the smaller one. */
	  if ((size_t) (right_ptr - lo) <= max_thresh)
	  {
	      if ((size_t) (hi - left_ptr) <= max_thresh)
		  /* Ignore both small partitions. */
		  POP (lo, hi);
	      else
		  /* Ignore small left partition. */
		  lo = left_ptr;
	  }
	  else if ((size_t) (hi - left_ptr) <= max_thresh)
	      /* Ignore small right partition. */
	      hi = right_ptr;
	  else if ((right_ptr - lo) > (hi - left_ptr))
	  {
	      /* Push larger left partition indices. */
	      PUSH (lo, right_ptr);
	      lo = left_ptr;
	  }
	  else
	  {
	      /* Push larger right partition indices. */
	      PUSH (left_ptr, hi);
	      hi = right_ptr;
	  }
	}
    }
    /* Once the BASE_PTR array is partially sorted by quicksort the rest
       is completely sorted using insertion sort, since this is efficient
       for partitions below MAX_THRESH size. BASE_PTR points to the beginning
       of the array to sort, and END_PTR points at the very last element in
       the array (*not* one beyond it!). */
#define min(x, y) ((x) < (y) ? (x) : (y))
    {
	char *const end_ptr = &base_ptr[size * (total_elems - 1)];
	char *tmp_ptr = base_ptr;
	char *thresh = min(end_ptr, base_ptr + max_thresh);
	char *run_ptr;
	/* Find smallest element in first threshold and place it at the
	   array's beginning.  This is the smallest array element,
	   and the operation speeds up insertion sort's inner loop. */
	for (run_ptr = tmp_ptr + size; run_ptr <= thresh; run_ptr += size)
	    if ((*cmp) ((void *) run_ptr, (void *) tmp_ptr) < 0)
		tmp_ptr = run_ptr;
	if (tmp_ptr != base_ptr)
	    SWAP (tmp_ptr, base_ptr, size);
	/* Insertion sort, running from left-hand-side up to right-hand-side.  */
	run_ptr = base_ptr + size;
	while ((run_ptr += size) <= end_ptr)
	{
	    tmp_ptr = run_ptr - size;
	    while ((*cmp) ((void *) run_ptr, (void *) tmp_ptr) < 0)
		tmp_ptr -= size;
	    tmp_ptr += size;
	    if (tmp_ptr != run_ptr)
	    {
		char *trav;
		trav = run_ptr + size;
		while (--trav >= run_ptr)
		{
		    char c = *trav;
		    char *hi, *lo;
		    for (hi = lo = trav; (lo -= size) >= tmp_ptr; hi = lo)
			*hi = *lo;
		    *hi = c;
		}
	    }
	}
    }
}
int ptr_comparator_ptr_ascending( const void * a, const void * b){
    return (uintptr_t)((ptr_with_size *) a)->ptr - (uintptr_t)((ptr_with_size *) b)->ptr;
}
int ptr_comparator_size_descending( const void * a, const void * b){
    return (size_t)((ptr_with_size *) b)->size - (size_t)((ptr_with_size *) a)->size;
}
void print_ptrs_with_size(ptr_with_size *ptrs_with_size, int end) {
    mem_tog(0);
    app_printf(1, "Start");
    for (int i = 0; i < end; i++) {
        app_printf(1, " %x-%x ", ptrs_with_size[i].ptr, ptrs_with_size[i].size);
    }
    app_printf(1, "End");
}
//


free_list_node *free_list_head = NULL;
free_list_node *free_list_tail = NULL;
int free_list_length = 0;

alloc_header *alloc_list_head = NULL;
alloc_header *alloc_list_tail = NULL;
int alloc_list_length = 0;

void append_free_list_node(free_list_node *node) {
    node->next = NULL;
    node->prev = NULL;
    if (free_list_head == NULL && free_list_tail == NULL) {
        free_list_head = node;
        free_list_tail = node;
    } else {
        free_list_tail->next = node;
        node->prev = free_list_tail;
        free_list_tail = node;
    }
    free_list_length++;
}

void remove_free_list_node(free_list_node *node) {
    if (node == free_list_head) free_list_head = node->next;
    if (node == free_list_tail) free_list_tail = node->prev;
    if (node->prev != NULL) node->prev->next = node->next;
    if (node->next != NULL) node->next->prev = node->prev;
    free_list_length--;
}

void append_alloc_list_node(alloc_header *header) {
    header->next = NULL;
    header->prev = NULL;
    if (alloc_list_head == NULL && alloc_list_tail == NULL) {
        alloc_list_head = header;
        alloc_list_tail = header;
    } else {
        alloc_list_tail->next = header;
        header->prev = alloc_list_tail;
        alloc_list_tail = header;
    }
    alloc_list_length++;
}

void remove_alloc_list_node(alloc_header *header) {
    if (header == alloc_list_head) alloc_list_head = header->next;
    if (header == alloc_list_tail) alloc_list_tail = header->prev;
    if (header->prev != NULL) header->prev->next = header->next;
    if (header->next != NULL) header->next->prev = header->prev;
    alloc_list_length--;
}

struct free_list_node *get_free_block(uint64_t payload_sz) {
    free_list_node *ptr = free_list_head;
    while (ptr != NULL) {
        if (ptr->sz >= ALLOC_HEADER_SIZE + payload_sz) return ptr;
        ptr = ptr->next;
    }
    return NULL;
}


struct free_list_node *extend_heap(size_t sz) {
    size_t heap_extension = ROUNDUP(sz, BREAK_INCREMENT);
    void *start = sbrk(heap_extension);
    if (start == (void *) -1) return NULL;
    struct free_list_node *node = (struct free_list_node *) start;
    node->sz = heap_extension;
    append_free_list_node(node);
    return node;
}

// returns address of the block (alloc_header) if allocated properly
// NULL if there was no space
uintptr_t allocate_to_free_block(uint64_t sz) {
    // find a free block
    free_list_node *free_block = get_free_block(sz);
    if (free_block == NULL) return (uintptr_t) -1;

    // remove that free block
    uintptr_t block_addr = (uintptr_t) free_block;
    size_t block_size = free_block->sz;
    remove_free_list_node(free_block);

    // replace it with an alloc_header
    struct alloc_header *header = (struct alloc_header *) block_addr;
    size_t payload_size = ROUNDUP(sz, ALIGNMENT);
    size_t min_payload_size = FREE_LIST_NODE_SIZE - ALLOC_HEADER_SIZE;
    if (payload_size < min_payload_size) payload_size = min_payload_size;
    header->sz = payload_size;
    append_alloc_list_node(header);

    // leftover stuff
    size_t data_size = ALLOC_HEADER_SIZE + payload_size;
    size_t leftover = block_size - data_size;

    if (leftover >= FREE_LIST_NODE_SIZE) {
        struct free_list_node *node = (struct free_list_node *) (block_addr + data_size);
        node->sz = leftover;
        append_free_list_node(node);
    } else header->sz += leftover;

    return block_addr;
}
 
// malloc(sz):
// allocates sz bytes of uninitialized memory and returns a pointer to the allocated memory
// if sz == 0, then malloc() either returns NULL or a unique pointer value that can be
// successfully passed to a later free
// the pointer should be aligned to 8 bytes
void *malloc(uint64_t sz) {
    if (sz == 0) return NULL;

    uintptr_t block_addr = allocate_to_free_block(sz);
    while (block_addr == (uintptr_t) -1) {
        if (extend_heap(sz) == NULL) return NULL;
        block_addr = allocate_to_free_block(sz);
    }

    return (void *) (block_addr + ALLOC_HEADER_SIZE);
}


// calloc(num, sz):
// allocates memory of an array of num elements of size sz bytes each and returns a pointer 
// to the allocated array. The memory is set to 0. if num or sz is equal to 0, then calloc
// returns NULL or a unique pointer value that can be successfully passed to a later free
// calloc also checks for size overflow caused by num*sz
// returns NULL on failure
int overflow(uint64_t a, uint64_t b) {
    return a * b / a != b || a * b / b != a;
}

void *calloc(uint64_t num, uint64_t sz) {
    if (num == 0 || sz == 0 || overflow(num, sz)) return NULL;

    size_t size = ROUNDUP(num * sz, ALIGNMENT);
    void *malloc_addr = malloc(size);
    if (malloc_addr == NULL) return NULL;

    memset(malloc_addr, 0, size);
    return malloc_addr;
}

// realloc(ptr, sz)
// realloc changes the size of the memory block pointed to by ptr to size bytes.
// the contents will be unchanged in the range from the start of the region up to the
// minimum of the old and new sizes
// if the new size is larger than the old size, the added memory will not be initialized
// if ptr is NULL, then the call is equivalent to malloc(size) for all values of size
// if size is equal to zero, and ptr is not NULL, then the call is equivalent to free(ptr)
// unless ptr is NULL, it must have been returned by an earlier call to malloc(), or realloc().
// if the area pointed to was moved, a free(ptr) is done.



void *realloc(void * ptr, uint64_t sz) {
    if (ptr == NULL) return malloc(sz);
    if (sz == 0) { free(ptr); return NULL; }

    struct alloc_header *original_header = (struct alloc_header *) ((uintptr_t) ptr - ALLOC_HEADER_SIZE);
    size_t original_sz = original_header->sz;
    if (original_sz == sz) return ptr;

    void *malloc_addr = malloc(sz);
    if (malloc_addr == NULL) return NULL;
    struct alloc_header *header = (struct alloc_header *) ((uintptr_t) malloc_addr - ALLOC_HEADER_SIZE);
    memcpy(malloc_addr, ptr, header->sz);

    free(ptr);
    return malloc_addr;
}

// free(ptr)
// the free funtion frees the memory space pointed to by ptr, which must have been returned
// by a previous call to malloc or realloc, or if free has already been called before, then
// undefined behavior occurs
// if ptr == NULL, then no operation happens
void free(void *ptr) {
    if (ptr == NULL) return;

    uintptr_t block_addr = (uintptr_t) ptr - ALLOC_HEADER_SIZE;
    struct alloc_header *header = (struct alloc_header *) block_addr;
    size_t block_size = ALLOC_HEADER_SIZE + header->sz;
    remove_alloc_list_node(header);

    struct free_list_node *node = (struct free_list_node *) block_addr;
    node->sz = block_size;
    append_free_list_node(node);
    return;
}

int adjacent(ptr_with_size *ptrs_with_size, int i, int j) {
    ptr_with_size a = ptrs_with_size[i];
    ptr_with_size b = ptrs_with_size[j];
    return (uintptr_t) a.ptr + a.size == (uintptr_t) b.ptr;
}

void coalesce(ptr_with_size *ptrs_with_size, int i, int j) {
    struct free_list_node *node_a = (struct free_list_node *) ptrs_with_size[i].ptr;
    struct free_list_node *node_b = (struct free_list_node *) ptrs_with_size[j].ptr;
    node_a->sz += node_b->sz;
    remove_free_list_node(node_b);
}

void defrag() {
    ptr_with_size ptrs_with_size[free_list_length];
    free_list_node *curr = free_list_head;
    for (int i = 0; i < free_list_length; i++, curr = curr->next) {
        ptrs_with_size[i].ptr = curr;
        ptrs_with_size[i].size = curr->sz;
    }
    __quicksort(ptrs_with_size, free_list_length, sizeof(ptrs_with_size[0]), &ptr_comparator_ptr_ascending);

    int i = 0, j = 1;
    for (; j < free_list_length; j++) {
        if (adjacent(ptrs_with_size, i, j)) coalesce(ptrs_with_size, i, j);
        else i = j;
    }
}

// heap_info(info)
// set the appropriate values in the heap_info_struct passed
// the malloc library will be responsible for alloc'ing size_array and 
// ptr_array
// the user, i.e. the process will be responsible for freeing these allocations
// note that the allocations used by the heap_info_struct will count as metadata
// and should NOT be included in the heap info
// return 0 for a successfull call
// if for any reason the information cannot be saved, return -1


int heap_info(heap_info_struct * info) {
    // alloc_list_length
    info->num_allocs = alloc_list_length;

    // size+ptr arrays
    if (alloc_list_length == 0) {
        info->size_array = NULL;
        info->ptr_array = NULL;
    } else {
        ptr_with_size ptrs_with_size[alloc_list_length];
        alloc_header *curr = alloc_list_head;
        for (int i = 0; i < alloc_list_length; i++, curr = curr->next) {
            ptrs_with_size[i].ptr = (void *) ((uintptr_t) curr + ALLOC_HEADER_SIZE);
            ptrs_with_size[i].size = curr->sz;
        }
        __quicksort(ptrs_with_size, alloc_list_length, sizeof(ptrs_with_size[0]), &ptr_comparator_size_descending);

        long *size_array = (long *) malloc(sizeof(long) * alloc_list_length);
        uintptr_t *ptr_array = (uintptr_t *) malloc(sizeof(uintptr_t) * alloc_list_length);
        if (size_array == NULL || ptr_array == NULL) return -1;
        for (int i = 0; i < alloc_list_length; i++) {
            size_array[i] = ptrs_with_size[i].size;
            ptr_array[i] = (uintptr_t) ptrs_with_size[i].ptr;
        }

        info->size_array = size_array;
        info->ptr_array = (void **) ptr_array;
    }
   
    // free space
    size_t free_space = 0;
    size_t largest_free_chunk = 0;
    free_list_node *curr_ = free_list_head;
    for (int i = 0; i < free_list_length; i++, curr_ = curr_->next) {
        largest_free_chunk = MAX(largest_free_chunk, curr_->sz);
        free_space += curr_->sz;
    }
    info->free_space = (int) free_space;
    info->largest_free_chunk = (int) largest_free_chunk;
    
    return 0;
}