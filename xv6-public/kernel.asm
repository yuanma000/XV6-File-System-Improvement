
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc c0 b5 10 80       	mov    $0x8010b5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 50 2f 10 80       	mov    $0x80102f50,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb f4 b5 10 80       	mov    $0x8010b5f4,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 a0 6f 10 80       	push   $0x80106fa0
80100051:	68 c0 b5 10 80       	push   $0x8010b5c0
80100056:	e8 55 42 00 00       	call   801042b0 <initlock>
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 0c fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd0c
80100062:	fc 10 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 10 fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd10
8010006c:	fc 10 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba bc fc 10 80       	mov    $0x8010fcbc,%edx
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	8d 43 0c             	lea    0xc(%ebx),%eax
80100085:	83 ec 08             	sub    $0x8,%esp
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 a7 6f 10 80       	push   $0x80106fa7
80100097:	50                   	push   %eax
80100098:	e8 e3 40 00 00       	call   80104180 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    bcache.head.next = b;
801000b0:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d bc fc 10 80       	cmp    $0x8010fcbc,%eax
801000bb:	72 c3                	jb     80100080 <binit+0x40>
  }
}
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 c0 b5 10 80       	push   $0x8010b5c0
801000e4:	e8 07 43 00 00       	call   801043f0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 10 fd 10 80    	mov    0x8010fd10,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c fd 10 80    	mov    0x8010fd0c,%ebx
80100126:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100139:	74 55                	je     80100190 <bread+0xc0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 c0 b5 10 80       	push   $0x8010b5c0
80100162:	e8 49 43 00 00       	call   801044b0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 4e 40 00 00       	call   801041c0 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 4d 20 00 00       	call   801021d0 <iderw>
80100183:	83 c4 10             	add    $0x10,%esp
  }
  return b;
}
80100186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100189:	89 d8                	mov    %ebx,%eax
8010018b:	5b                   	pop    %ebx
8010018c:	5e                   	pop    %esi
8010018d:	5f                   	pop    %edi
8010018e:	5d                   	pop    %ebp
8010018f:	c3                   	ret    
  panic("bget: no buffers");
80100190:	83 ec 0c             	sub    $0xc,%esp
80100193:	68 ae 6f 10 80       	push   $0x80106fae
80100198:	e8 f3 01 00 00       	call   80100390 <panic>
8010019d:	8d 76 00             	lea    0x0(%esi),%esi

801001a0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 10             	sub    $0x10,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	50                   	push   %eax
801001ae:	e8 ad 40 00 00       	call   80104260 <holdingsleep>
801001b3:	83 c4 10             	add    $0x10,%esp
801001b6:	85 c0                	test   %eax,%eax
801001b8:	74 0f                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ba:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c3:	c9                   	leave  
  iderw(b);
801001c4:	e9 07 20 00 00       	jmp    801021d0 <iderw>
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 bf 6f 10 80       	push   $0x80106fbf
801001d1:	e8 ba 01 00 00       	call   80100390 <panic>
801001d6:	8d 76 00             	lea    0x0(%esi),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001e8:	83 ec 0c             	sub    $0xc,%esp
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	56                   	push   %esi
801001ef:	e8 6c 40 00 00       	call   80104260 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 1c 40 00 00       	call   80104220 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010020b:	e8 e0 41 00 00       	call   801043f0 <acquire>
  b->refcnt--;
80100210:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100213:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100216:	83 e8 01             	sub    $0x1,%eax
  if (b->refcnt == 0) {
80100219:	85 c0                	test   %eax,%eax
  b->refcnt--;
8010021b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010021e:	75 2f                	jne    8010024f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100220:	8b 43 54             	mov    0x54(%ebx),%eax
80100223:	8b 53 50             	mov    0x50(%ebx),%edx
80100226:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100229:	8b 43 50             	mov    0x50(%ebx),%eax
8010022c:	8b 53 54             	mov    0x54(%ebx),%edx
8010022f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100232:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100241:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 c0 b5 10 80 	movl   $0x8010b5c0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010025c:	e9 4f 42 00 00       	jmp    801044b0 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 c6 6f 10 80       	push   $0x80106fc6
80100269:	e8 22 01 00 00       	call   80100390 <panic>
8010026e:	66 90                	xchg   %ax,%ax

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 28             	sub    $0x28,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	57                   	push   %edi
80100280:	e8 eb 14 00 00       	call   80101770 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010028c:	e8 5f 41 00 00       	call   801043f0 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e a1 00 00 00    	jle    80100342 <consoleread+0xd2>
    while(input.r == input.w){
801002a1:	8b 15 a0 ff 10 80    	mov    0x8010ffa0,%edx
801002a7:	39 15 a4 ff 10 80    	cmp    %edx,0x8010ffa4
801002ad:	74 2c                	je     801002db <consoleread+0x6b>
801002af:	eb 5f                	jmp    80100310 <consoleread+0xa0>
801002b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b8:	83 ec 08             	sub    $0x8,%esp
801002bb:	68 20 a5 10 80       	push   $0x8010a520
801002c0:	68 a0 ff 10 80       	push   $0x8010ffa0
801002c5:	e8 66 3b 00 00       	call   80103e30 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 a0 ff 10 80    	mov    0x8010ffa0,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 a4 ff 10 80    	cmp    0x8010ffa4,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 b0 35 00 00       	call   80103890 <myproc>
801002e0:	8b 40 24             	mov    0x24(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 20 a5 10 80       	push   $0x8010a520
801002ef:	e8 bc 41 00 00       	call   801044b0 <release>
        ilock(ip);
801002f4:	89 3c 24             	mov    %edi,(%esp)
801002f7:	e8 94 13 00 00       	call   80101690 <ilock>
        return -1;
801002fc:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100302:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100307:	5b                   	pop    %ebx
80100308:	5e                   	pop    %esi
80100309:	5f                   	pop    %edi
8010030a:	5d                   	pop    %ebp
8010030b:	c3                   	ret    
8010030c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100310:	8d 42 01             	lea    0x1(%edx),%eax
80100313:	a3 a0 ff 10 80       	mov    %eax,0x8010ffa0
80100318:	89 d0                	mov    %edx,%eax
8010031a:	83 e0 7f             	and    $0x7f,%eax
8010031d:	0f be 80 20 ff 10 80 	movsbl -0x7fef00e0(%eax),%eax
    if(c == C('D')){  // EOF
80100324:	83 f8 04             	cmp    $0x4,%eax
80100327:	74 3f                	je     80100368 <consoleread+0xf8>
    *dst++ = c;
80100329:	83 c6 01             	add    $0x1,%esi
    --n;
8010032c:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
8010032f:	83 f8 0a             	cmp    $0xa,%eax
    *dst++ = c;
80100332:	88 46 ff             	mov    %al,-0x1(%esi)
    if(c == '\n')
80100335:	74 43                	je     8010037a <consoleread+0x10a>
  while(n > 0){
80100337:	85 db                	test   %ebx,%ebx
80100339:	0f 85 62 ff ff ff    	jne    801002a1 <consoleread+0x31>
8010033f:	8b 45 10             	mov    0x10(%ebp),%eax
  release(&cons.lock);
80100342:	83 ec 0c             	sub    $0xc,%esp
80100345:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100348:	68 20 a5 10 80       	push   $0x8010a520
8010034d:	e8 5e 41 00 00       	call   801044b0 <release>
  ilock(ip);
80100352:	89 3c 24             	mov    %edi,(%esp)
80100355:	e8 36 13 00 00       	call   80101690 <ilock>
  return target - n;
8010035a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010035d:	83 c4 10             	add    $0x10,%esp
}
80100360:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100363:	5b                   	pop    %ebx
80100364:	5e                   	pop    %esi
80100365:	5f                   	pop    %edi
80100366:	5d                   	pop    %ebp
80100367:	c3                   	ret    
80100368:	8b 45 10             	mov    0x10(%ebp),%eax
8010036b:	29 d8                	sub    %ebx,%eax
      if(n < target){
8010036d:	3b 5d 10             	cmp    0x10(%ebp),%ebx
80100370:	73 d0                	jae    80100342 <consoleread+0xd2>
        input.r--;
80100372:	89 15 a0 ff 10 80    	mov    %edx,0x8010ffa0
80100378:	eb c8                	jmp    80100342 <consoleread+0xd2>
8010037a:	8b 45 10             	mov    0x10(%ebp),%eax
8010037d:	29 d8                	sub    %ebx,%eax
8010037f:	eb c1                	jmp    80100342 <consoleread+0xd2>
80100381:	eb 0d                	jmp    80100390 <panic>
80100383:	90                   	nop
80100384:	90                   	nop
80100385:	90                   	nop
80100386:	90                   	nop
80100387:	90                   	nop
80100388:	90                   	nop
80100389:	90                   	nop
8010038a:	90                   	nop
8010038b:	90                   	nop
8010038c:	90                   	nop
8010038d:	90                   	nop
8010038e:	90                   	nop
8010038f:	90                   	nop

80100390 <panic>:
{
80100390:	55                   	push   %ebp
80100391:	89 e5                	mov    %esp,%ebp
80100393:	56                   	push   %esi
80100394:	53                   	push   %ebx
80100395:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100398:	fa                   	cli    
  cons.locking = 0;
80100399:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
801003a0:	00 00 00 
  getcallerpcs(&s, pcs);
801003a3:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003a6:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003a9:	e8 32 24 00 00       	call   801027e0 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 cd 6f 10 80       	push   $0x80106fcd
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 17 79 10 80 	movl   $0x80107917,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 f3 3e 00 00       	call   801042d0 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 e1 6f 10 80       	push   $0x80106fe1
801003ed:	e8 6e 02 00 00       	call   80100660 <cprintf>
  for(i=0; i<10; i++)
801003f2:	83 c4 10             	add    $0x10,%esp
801003f5:	39 f3                	cmp    %esi,%ebx
801003f7:	75 e7                	jne    801003e0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003f9:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
80100400:	00 00 00 
80100403:	eb fe                	jmp    80100403 <panic+0x73>
80100405:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100410 <consputc>:
  if(panicked){
80100410:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
80100416:	85 c9                	test   %ecx,%ecx
80100418:	74 06                	je     80100420 <consputc+0x10>
8010041a:	fa                   	cli    
8010041b:	eb fe                	jmp    8010041b <consputc+0xb>
8010041d:	8d 76 00             	lea    0x0(%esi),%esi
{
80100420:	55                   	push   %ebp
80100421:	89 e5                	mov    %esp,%ebp
80100423:	57                   	push   %edi
80100424:	56                   	push   %esi
80100425:	53                   	push   %ebx
80100426:	89 c6                	mov    %eax,%esi
80100428:	83 ec 0c             	sub    $0xc,%esp
  if(c == BACKSPACE){
8010042b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100430:	0f 84 b1 00 00 00    	je     801004e7 <consputc+0xd7>
    uartputc(c);
80100436:	83 ec 0c             	sub    $0xc,%esp
80100439:	50                   	push   %eax
8010043a:	e8 71 57 00 00       	call   80105bb0 <uartputc>
8010043f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100442:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100447:	b8 0e 00 00 00       	mov    $0xe,%eax
8010044c:	89 da                	mov    %ebx,%edx
8010044e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010044f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100454:	89 ca                	mov    %ecx,%edx
80100456:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100457:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010045a:	89 da                	mov    %ebx,%edx
8010045c:	c1 e0 08             	shl    $0x8,%eax
8010045f:	89 c7                	mov    %eax,%edi
80100461:	b8 0f 00 00 00       	mov    $0xf,%eax
80100466:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100467:	89 ca                	mov    %ecx,%edx
80100469:	ec                   	in     (%dx),%al
8010046a:	0f b6 d8             	movzbl %al,%ebx
  pos |= inb(CRTPORT+1);
8010046d:	09 fb                	or     %edi,%ebx
  if(c == '\n')
8010046f:	83 fe 0a             	cmp    $0xa,%esi
80100472:	0f 84 f3 00 00 00    	je     8010056b <consputc+0x15b>
  else if(c == BACKSPACE){
80100478:	81 fe 00 01 00 00    	cmp    $0x100,%esi
8010047e:	0f 84 d7 00 00 00    	je     8010055b <consputc+0x14b>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100484:	89 f0                	mov    %esi,%eax
80100486:	0f b6 c0             	movzbl %al,%eax
80100489:	80 cc 07             	or     $0x7,%ah
8010048c:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
80100493:	80 
80100494:	83 c3 01             	add    $0x1,%ebx
  if(pos < 0 || pos > 25*80)
80100497:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
8010049d:	0f 8f ab 00 00 00    	jg     8010054e <consputc+0x13e>
  if((pos/80) >= 24){  // Scroll up.
801004a3:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
801004a9:	7f 66                	jg     80100511 <consputc+0x101>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004ab:	be d4 03 00 00       	mov    $0x3d4,%esi
801004b0:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b5:	89 f2                	mov    %esi,%edx
801004b7:	ee                   	out    %al,(%dx)
801004b8:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
  outb(CRTPORT+1, pos>>8);
801004bd:	89 d8                	mov    %ebx,%eax
801004bf:	c1 f8 08             	sar    $0x8,%eax
801004c2:	89 ca                	mov    %ecx,%edx
801004c4:	ee                   	out    %al,(%dx)
801004c5:	b8 0f 00 00 00       	mov    $0xf,%eax
801004ca:	89 f2                	mov    %esi,%edx
801004cc:	ee                   	out    %al,(%dx)
801004cd:	89 d8                	mov    %ebx,%eax
801004cf:	89 ca                	mov    %ecx,%edx
801004d1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004d2:	b8 20 07 00 00       	mov    $0x720,%eax
801004d7:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
801004de:	80 
}
801004df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004e2:	5b                   	pop    %ebx
801004e3:	5e                   	pop    %esi
801004e4:	5f                   	pop    %edi
801004e5:	5d                   	pop    %ebp
801004e6:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004e7:	83 ec 0c             	sub    $0xc,%esp
801004ea:	6a 08                	push   $0x8
801004ec:	e8 bf 56 00 00       	call   80105bb0 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 b3 56 00 00       	call   80105bb0 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 a7 56 00 00       	call   80105bb0 <uartputc>
80100509:	83 c4 10             	add    $0x10,%esp
8010050c:	e9 31 ff ff ff       	jmp    80100442 <consputc+0x32>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100511:	52                   	push   %edx
80100512:	68 60 0e 00 00       	push   $0xe60
    pos -= 80;
80100517:	83 eb 50             	sub    $0x50,%ebx
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
8010051a:	68 a0 80 0b 80       	push   $0x800b80a0
8010051f:	68 00 80 0b 80       	push   $0x800b8000
80100524:	e8 87 40 00 00       	call   801045b0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100529:	b8 80 07 00 00       	mov    $0x780,%eax
8010052e:	83 c4 0c             	add    $0xc,%esp
80100531:	29 d8                	sub    %ebx,%eax
80100533:	01 c0                	add    %eax,%eax
80100535:	50                   	push   %eax
80100536:	8d 04 1b             	lea    (%ebx,%ebx,1),%eax
80100539:	6a 00                	push   $0x0
8010053b:	2d 00 80 f4 7f       	sub    $0x7ff48000,%eax
80100540:	50                   	push   %eax
80100541:	e8 ba 3f 00 00       	call   80104500 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 e5 6f 10 80       	push   $0x80106fe5
80100556:	e8 35 fe ff ff       	call   80100390 <panic>
    if(pos > 0) --pos;
8010055b:	85 db                	test   %ebx,%ebx
8010055d:	0f 84 48 ff ff ff    	je     801004ab <consputc+0x9b>
80100563:	83 eb 01             	sub    $0x1,%ebx
80100566:	e9 2c ff ff ff       	jmp    80100497 <consputc+0x87>
    pos += 80 - pos%80;
8010056b:	89 d8                	mov    %ebx,%eax
8010056d:	b9 50 00 00 00       	mov    $0x50,%ecx
80100572:	99                   	cltd   
80100573:	f7 f9                	idiv   %ecx
80100575:	29 d1                	sub    %edx,%ecx
80100577:	01 cb                	add    %ecx,%ebx
80100579:	e9 19 ff ff ff       	jmp    80100497 <consputc+0x87>
8010057e:	66 90                	xchg   %ax,%ax

80100580 <printint>:
{
80100580:	55                   	push   %ebp
80100581:	89 e5                	mov    %esp,%ebp
80100583:	57                   	push   %edi
80100584:	56                   	push   %esi
80100585:	53                   	push   %ebx
80100586:	89 d3                	mov    %edx,%ebx
80100588:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
8010058b:	85 c9                	test   %ecx,%ecx
{
8010058d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
80100590:	74 04                	je     80100596 <printint+0x16>
80100592:	85 c0                	test   %eax,%eax
80100594:	78 5a                	js     801005f0 <printint+0x70>
    x = xx;
80100596:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  i = 0;
8010059d:	31 c9                	xor    %ecx,%ecx
8010059f:	8d 75 d7             	lea    -0x29(%ebp),%esi
801005a2:	eb 06                	jmp    801005aa <printint+0x2a>
801005a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    buf[i++] = digits[x % base];
801005a8:	89 f9                	mov    %edi,%ecx
801005aa:	31 d2                	xor    %edx,%edx
801005ac:	8d 79 01             	lea    0x1(%ecx),%edi
801005af:	f7 f3                	div    %ebx
801005b1:	0f b6 92 10 70 10 80 	movzbl -0x7fef8ff0(%edx),%edx
  }while((x /= base) != 0);
801005b8:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
801005ba:	88 14 3e             	mov    %dl,(%esi,%edi,1)
  }while((x /= base) != 0);
801005bd:	75 e9                	jne    801005a8 <printint+0x28>
  if(sign)
801005bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801005c2:	85 c0                	test   %eax,%eax
801005c4:	74 08                	je     801005ce <printint+0x4e>
    buf[i++] = '-';
801005c6:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
801005cb:	8d 79 02             	lea    0x2(%ecx),%edi
801005ce:	8d 5c 3d d7          	lea    -0x29(%ebp,%edi,1),%ebx
801005d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    consputc(buf[i]);
801005d8:	0f be 03             	movsbl (%ebx),%eax
801005db:	83 eb 01             	sub    $0x1,%ebx
801005de:	e8 2d fe ff ff       	call   80100410 <consputc>
  while(--i >= 0)
801005e3:	39 f3                	cmp    %esi,%ebx
801005e5:	75 f1                	jne    801005d8 <printint+0x58>
}
801005e7:	83 c4 2c             	add    $0x2c,%esp
801005ea:	5b                   	pop    %ebx
801005eb:	5e                   	pop    %esi
801005ec:	5f                   	pop    %edi
801005ed:	5d                   	pop    %ebp
801005ee:	c3                   	ret    
801005ef:	90                   	nop
    x = -xx;
801005f0:	f7 d8                	neg    %eax
801005f2:	eb a9                	jmp    8010059d <printint+0x1d>
801005f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100600 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 18             	sub    $0x18,%esp
80100609:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
8010060c:	ff 75 08             	pushl  0x8(%ebp)
8010060f:	e8 5c 11 00 00       	call   80101770 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010061b:	e8 d0 3d 00 00       	call   801043f0 <acquire>
  for(i = 0; i < n; i++)
80100620:	83 c4 10             	add    $0x10,%esp
80100623:	85 f6                	test   %esi,%esi
80100625:	7e 18                	jle    8010063f <consolewrite+0x3f>
80100627:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010062a:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010062d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100630:	0f b6 07             	movzbl (%edi),%eax
80100633:	83 c7 01             	add    $0x1,%edi
80100636:	e8 d5 fd ff ff       	call   80100410 <consputc>
  for(i = 0; i < n; i++)
8010063b:	39 fb                	cmp    %edi,%ebx
8010063d:	75 f1                	jne    80100630 <consolewrite+0x30>
  release(&cons.lock);
8010063f:	83 ec 0c             	sub    $0xc,%esp
80100642:	68 20 a5 10 80       	push   $0x8010a520
80100647:	e8 64 3e 00 00       	call   801044b0 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 3b 10 00 00       	call   80101690 <ilock>

  return n;
}
80100655:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100658:	89 f0                	mov    %esi,%eax
8010065a:	5b                   	pop    %ebx
8010065b:	5e                   	pop    %esi
8010065c:	5f                   	pop    %edi
8010065d:	5d                   	pop    %ebp
8010065e:	c3                   	ret    
8010065f:	90                   	nop

80100660 <cprintf>:
{
80100660:	55                   	push   %ebp
80100661:	89 e5                	mov    %esp,%ebp
80100663:	57                   	push   %edi
80100664:	56                   	push   %esi
80100665:	53                   	push   %ebx
80100666:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100669:	a1 54 a5 10 80       	mov    0x8010a554,%eax
  if(locking)
8010066e:	85 c0                	test   %eax,%eax
  locking = cons.locking;
80100670:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if(locking)
80100673:	0f 85 6f 01 00 00    	jne    801007e8 <cprintf+0x188>
  if (fmt == 0)
80100679:	8b 45 08             	mov    0x8(%ebp),%eax
8010067c:	85 c0                	test   %eax,%eax
8010067e:	89 c7                	mov    %eax,%edi
80100680:	0f 84 77 01 00 00    	je     801007fd <cprintf+0x19d>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100686:	0f b6 00             	movzbl (%eax),%eax
  argp = (uint*)(void*)(&fmt + 1);
80100689:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010068c:	31 db                	xor    %ebx,%ebx
  argp = (uint*)(void*)(&fmt + 1);
8010068e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100691:	85 c0                	test   %eax,%eax
80100693:	75 56                	jne    801006eb <cprintf+0x8b>
80100695:	eb 79                	jmp    80100710 <cprintf+0xb0>
80100697:	89 f6                	mov    %esi,%esi
80100699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[++i] & 0xff;
801006a0:	0f b6 16             	movzbl (%esi),%edx
    if(c == 0)
801006a3:	85 d2                	test   %edx,%edx
801006a5:	74 69                	je     80100710 <cprintf+0xb0>
801006a7:	83 c3 02             	add    $0x2,%ebx
    switch(c){
801006aa:	83 fa 70             	cmp    $0x70,%edx
801006ad:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
801006b0:	0f 84 84 00 00 00    	je     8010073a <cprintf+0xda>
801006b6:	7f 78                	jg     80100730 <cprintf+0xd0>
801006b8:	83 fa 25             	cmp    $0x25,%edx
801006bb:	0f 84 ff 00 00 00    	je     801007c0 <cprintf+0x160>
801006c1:	83 fa 64             	cmp    $0x64,%edx
801006c4:	0f 85 8e 00 00 00    	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 10, 1);
801006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801006cd:	ba 0a 00 00 00       	mov    $0xa,%edx
801006d2:	8d 48 04             	lea    0x4(%eax),%ecx
801006d5:	8b 00                	mov    (%eax),%eax
801006d7:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801006da:	b9 01 00 00 00       	mov    $0x1,%ecx
801006df:	e8 9c fe ff ff       	call   80100580 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006e4:	0f b6 06             	movzbl (%esi),%eax
801006e7:	85 c0                	test   %eax,%eax
801006e9:	74 25                	je     80100710 <cprintf+0xb0>
801006eb:	8d 53 01             	lea    0x1(%ebx),%edx
    if(c != '%'){
801006ee:	83 f8 25             	cmp    $0x25,%eax
801006f1:	8d 34 17             	lea    (%edi,%edx,1),%esi
801006f4:	74 aa                	je     801006a0 <cprintf+0x40>
801006f6:	89 55 e0             	mov    %edx,-0x20(%ebp)
      consputc(c);
801006f9:	e8 12 fd ff ff       	call   80100410 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006fe:	0f b6 06             	movzbl (%esi),%eax
      continue;
80100701:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100704:	89 d3                	mov    %edx,%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100706:	85 c0                	test   %eax,%eax
80100708:	75 e1                	jne    801006eb <cprintf+0x8b>
8010070a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(locking)
80100710:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100713:	85 c0                	test   %eax,%eax
80100715:	74 10                	je     80100727 <cprintf+0xc7>
    release(&cons.lock);
80100717:	83 ec 0c             	sub    $0xc,%esp
8010071a:	68 20 a5 10 80       	push   $0x8010a520
8010071f:	e8 8c 3d 00 00       	call   801044b0 <release>
80100724:	83 c4 10             	add    $0x10,%esp
}
80100727:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010072a:	5b                   	pop    %ebx
8010072b:	5e                   	pop    %esi
8010072c:	5f                   	pop    %edi
8010072d:	5d                   	pop    %ebp
8010072e:	c3                   	ret    
8010072f:	90                   	nop
    switch(c){
80100730:	83 fa 73             	cmp    $0x73,%edx
80100733:	74 43                	je     80100778 <cprintf+0x118>
80100735:	83 fa 78             	cmp    $0x78,%edx
80100738:	75 1e                	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 16, 0);
8010073a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010073d:	ba 10 00 00 00       	mov    $0x10,%edx
80100742:	8d 48 04             	lea    0x4(%eax),%ecx
80100745:	8b 00                	mov    (%eax),%eax
80100747:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010074a:	31 c9                	xor    %ecx,%ecx
8010074c:	e8 2f fe ff ff       	call   80100580 <printint>
      break;
80100751:	eb 91                	jmp    801006e4 <cprintf+0x84>
80100753:	90                   	nop
80100754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100758:	b8 25 00 00 00       	mov    $0x25,%eax
8010075d:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100760:	e8 ab fc ff ff       	call   80100410 <consputc>
      consputc(c);
80100765:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100768:	89 d0                	mov    %edx,%eax
8010076a:	e8 a1 fc ff ff       	call   80100410 <consputc>
      break;
8010076f:	e9 70 ff ff ff       	jmp    801006e4 <cprintf+0x84>
80100774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if((s = (char*)*argp++) == 0)
80100778:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010077b:	8b 10                	mov    (%eax),%edx
8010077d:	8d 48 04             	lea    0x4(%eax),%ecx
80100780:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100783:	85 d2                	test   %edx,%edx
80100785:	74 49                	je     801007d0 <cprintf+0x170>
      for(; *s; s++)
80100787:	0f be 02             	movsbl (%edx),%eax
      if((s = (char*)*argp++) == 0)
8010078a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
      for(; *s; s++)
8010078d:	84 c0                	test   %al,%al
8010078f:	0f 84 4f ff ff ff    	je     801006e4 <cprintf+0x84>
80100795:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80100798:	89 d3                	mov    %edx,%ebx
8010079a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801007a0:	83 c3 01             	add    $0x1,%ebx
        consputc(*s);
801007a3:	e8 68 fc ff ff       	call   80100410 <consputc>
      for(; *s; s++)
801007a8:	0f be 03             	movsbl (%ebx),%eax
801007ab:	84 c0                	test   %al,%al
801007ad:	75 f1                	jne    801007a0 <cprintf+0x140>
      if((s = (char*)*argp++) == 0)
801007af:	8b 45 e0             	mov    -0x20(%ebp),%eax
801007b2:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801007b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801007b8:	e9 27 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007bd:	8d 76 00             	lea    0x0(%esi),%esi
      consputc('%');
801007c0:	b8 25 00 00 00       	mov    $0x25,%eax
801007c5:	e8 46 fc ff ff       	call   80100410 <consputc>
      break;
801007ca:	e9 15 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007cf:	90                   	nop
        s = "(null)";
801007d0:	ba f8 6f 10 80       	mov    $0x80106ff8,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 20 a5 10 80       	push   $0x8010a520
801007f0:	e8 fb 3b 00 00       	call   801043f0 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 ff 6f 10 80       	push   $0x80106fff
80100805:	e8 86 fb ff ff       	call   80100390 <panic>
8010080a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100810 <consoleintr>:
{
80100810:	55                   	push   %ebp
80100811:	89 e5                	mov    %esp,%ebp
80100813:	57                   	push   %edi
80100814:	56                   	push   %esi
80100815:	53                   	push   %ebx
  int c, doprocdump = 0;
80100816:	31 f6                	xor    %esi,%esi
{
80100818:	83 ec 18             	sub    $0x18,%esp
8010081b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
8010081e:	68 20 a5 10 80       	push   $0x8010a520
80100823:	e8 c8 3b 00 00       	call   801043f0 <acquire>
  while((c = getc()) >= 0){
80100828:	83 c4 10             	add    $0x10,%esp
8010082b:	90                   	nop
8010082c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100830:	ff d3                	call   *%ebx
80100832:	85 c0                	test   %eax,%eax
80100834:	89 c7                	mov    %eax,%edi
80100836:	78 48                	js     80100880 <consoleintr+0x70>
    switch(c){
80100838:	83 ff 10             	cmp    $0x10,%edi
8010083b:	0f 84 e7 00 00 00    	je     80100928 <consoleintr+0x118>
80100841:	7e 5d                	jle    801008a0 <consoleintr+0x90>
80100843:	83 ff 15             	cmp    $0x15,%edi
80100846:	0f 84 ec 00 00 00    	je     80100938 <consoleintr+0x128>
8010084c:	83 ff 7f             	cmp    $0x7f,%edi
8010084f:	75 54                	jne    801008a5 <consoleintr+0x95>
      if(input.e != input.w){
80100851:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100856:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
8010085c:	74 d2                	je     80100830 <consoleintr+0x20>
        input.e--;
8010085e:	83 e8 01             	sub    $0x1,%eax
80100861:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
80100866:	b8 00 01 00 00       	mov    $0x100,%eax
8010086b:	e8 a0 fb ff ff       	call   80100410 <consputc>
  while((c = getc()) >= 0){
80100870:	ff d3                	call   *%ebx
80100872:	85 c0                	test   %eax,%eax
80100874:	89 c7                	mov    %eax,%edi
80100876:	79 c0                	jns    80100838 <consoleintr+0x28>
80100878:	90                   	nop
80100879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
80100880:	83 ec 0c             	sub    $0xc,%esp
80100883:	68 20 a5 10 80       	push   $0x8010a520
80100888:	e8 23 3c 00 00       	call   801044b0 <release>
  if(doprocdump) {
8010088d:	83 c4 10             	add    $0x10,%esp
80100890:	85 f6                	test   %esi,%esi
80100892:	0f 85 f8 00 00 00    	jne    80100990 <consoleintr+0x180>
}
80100898:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010089b:	5b                   	pop    %ebx
8010089c:	5e                   	pop    %esi
8010089d:	5f                   	pop    %edi
8010089e:	5d                   	pop    %ebp
8010089f:	c3                   	ret    
    switch(c){
801008a0:	83 ff 08             	cmp    $0x8,%edi
801008a3:	74 ac                	je     80100851 <consoleintr+0x41>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008a5:	85 ff                	test   %edi,%edi
801008a7:	74 87                	je     80100830 <consoleintr+0x20>
801008a9:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008ae:	89 c2                	mov    %eax,%edx
801008b0:	2b 15 a0 ff 10 80    	sub    0x8010ffa0,%edx
801008b6:	83 fa 7f             	cmp    $0x7f,%edx
801008b9:	0f 87 71 ff ff ff    	ja     80100830 <consoleintr+0x20>
801008bf:	8d 50 01             	lea    0x1(%eax),%edx
801008c2:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
801008c5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008c8:	89 15 a8 ff 10 80    	mov    %edx,0x8010ffa8
        c = (c == '\r') ? '\n' : c;
801008ce:	0f 84 cc 00 00 00    	je     801009a0 <consoleintr+0x190>
        input.buf[input.e++ % INPUT_BUF] = c;
801008d4:	89 f9                	mov    %edi,%ecx
801008d6:	88 88 20 ff 10 80    	mov    %cl,-0x7fef00e0(%eax)
        consputc(c);
801008dc:	89 f8                	mov    %edi,%eax
801008de:	e8 2d fb ff ff       	call   80100410 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008e3:	83 ff 0a             	cmp    $0xa,%edi
801008e6:	0f 84 c5 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008ec:	83 ff 04             	cmp    $0x4,%edi
801008ef:	0f 84 bc 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008f5:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801008fa:	83 e8 80             	sub    $0xffffff80,%eax
801008fd:	39 05 a8 ff 10 80    	cmp    %eax,0x8010ffa8
80100903:	0f 85 27 ff ff ff    	jne    80100830 <consoleintr+0x20>
          wakeup(&input.r);
80100909:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
8010090c:	a3 a4 ff 10 80       	mov    %eax,0x8010ffa4
          wakeup(&input.r);
80100911:	68 a0 ff 10 80       	push   $0x8010ffa0
80100916:	e8 c5 36 00 00       	call   80103fe0 <wakeup>
8010091b:	83 c4 10             	add    $0x10,%esp
8010091e:	e9 0d ff ff ff       	jmp    80100830 <consoleintr+0x20>
80100923:	90                   	nop
80100924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      doprocdump = 1;
80100928:	be 01 00 00 00       	mov    $0x1,%esi
8010092d:	e9 fe fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100938:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010093d:	39 05 a4 ff 10 80    	cmp    %eax,0x8010ffa4
80100943:	75 2b                	jne    80100970 <consoleintr+0x160>
80100945:	e9 e6 fe ff ff       	jmp    80100830 <consoleintr+0x20>
8010094a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
80100950:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
80100955:	b8 00 01 00 00       	mov    $0x100,%eax
8010095a:	e8 b1 fa ff ff       	call   80100410 <consputc>
      while(input.e != input.w &&
8010095f:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100964:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
8010096a:	0f 84 c0 fe ff ff    	je     80100830 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100970:	83 e8 01             	sub    $0x1,%eax
80100973:	89 c2                	mov    %eax,%edx
80100975:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100978:	80 ba 20 ff 10 80 0a 	cmpb   $0xa,-0x7fef00e0(%edx)
8010097f:	75 cf                	jne    80100950 <consoleintr+0x140>
80100981:	e9 aa fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100986:	8d 76 00             	lea    0x0(%esi),%esi
80100989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
}
80100990:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100993:	5b                   	pop    %ebx
80100994:	5e                   	pop    %esi
80100995:	5f                   	pop    %edi
80100996:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100997:	e9 24 37 00 00       	jmp    801040c0 <procdump>
8010099c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        input.buf[input.e++ % INPUT_BUF] = c;
801009a0:	c6 80 20 ff 10 80 0a 	movb   $0xa,-0x7fef00e0(%eax)
        consputc(c);
801009a7:	b8 0a 00 00 00       	mov    $0xa,%eax
801009ac:	e8 5f fa ff ff       	call   80100410 <consputc>
801009b1:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801009b6:	e9 4e ff ff ff       	jmp    80100909 <consoleintr+0xf9>
801009bb:	90                   	nop
801009bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801009c0 <consoleinit>:

void
consoleinit(void)
{
801009c0:	55                   	push   %ebp
801009c1:	89 e5                	mov    %esp,%ebp
801009c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801009c6:	68 08 70 10 80       	push   $0x80107008
801009cb:	68 20 a5 10 80       	push   $0x8010a520
801009d0:	e8 db 38 00 00       	call   801042b0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009d5:	58                   	pop    %eax
801009d6:	5a                   	pop    %edx
801009d7:	6a 00                	push   $0x0
801009d9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
801009db:	c7 05 6c 09 11 80 00 	movl   $0x80100600,0x8011096c
801009e2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009e5:	c7 05 68 09 11 80 70 	movl   $0x80100270,0x80110968
801009ec:	02 10 80 
  cons.locking = 1;
801009ef:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
801009f6:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
801009f9:	e8 82 19 00 00       	call   80102380 <ioapicenable>
}
801009fe:	83 c4 10             	add    $0x10,%esp
80100a01:	c9                   	leave  
80100a02:	c3                   	ret    
80100a03:	66 90                	xchg   %ax,%ax
80100a05:	66 90                	xchg   %ax,%ax
80100a07:	66 90                	xchg   %ax,%ax
80100a09:	66 90                	xchg   %ax,%ax
80100a0b:	66 90                	xchg   %ax,%ax
80100a0d:	66 90                	xchg   %ax,%ax
80100a0f:	90                   	nop

80100a10 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100a10:	55                   	push   %ebp
80100a11:	89 e5                	mov    %esp,%ebp
80100a13:	57                   	push   %edi
80100a14:	56                   	push   %esi
80100a15:	53                   	push   %ebx
80100a16:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100a1c:	e8 6f 2e 00 00       	call   80103890 <myproc>
80100a21:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
80100a27:	e8 24 22 00 00       	call   80102c50 <begin_op>

  if((ip = namei(path)) == 0){
80100a2c:	83 ec 0c             	sub    $0xc,%esp
80100a2f:	ff 75 08             	pushl  0x8(%ebp)
80100a32:	e8 59 15 00 00       	call   80101f90 <namei>
80100a37:	83 c4 10             	add    $0x10,%esp
80100a3a:	85 c0                	test   %eax,%eax
80100a3c:	0f 84 91 01 00 00    	je     80100bd3 <exec+0x1c3>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100a42:	83 ec 0c             	sub    $0xc,%esp
80100a45:	89 c3                	mov    %eax,%ebx
80100a47:	50                   	push   %eax
80100a48:	e8 43 0c 00 00       	call   80101690 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a4d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a53:	6a 34                	push   $0x34
80100a55:	6a 00                	push   $0x0
80100a57:	50                   	push   %eax
80100a58:	53                   	push   %ebx
80100a59:	e8 12 0f 00 00       	call   80101970 <readi>
80100a5e:	83 c4 20             	add    $0x20,%esp
80100a61:	83 f8 34             	cmp    $0x34,%eax
80100a64:	74 22                	je     80100a88 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a66:	83 ec 0c             	sub    $0xc,%esp
80100a69:	53                   	push   %ebx
80100a6a:	e8 b1 0e 00 00       	call   80101920 <iunlockput>
    end_op();
80100a6f:	e8 4c 22 00 00       	call   80102cc0 <end_op>
80100a74:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100a77:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a7f:	5b                   	pop    %ebx
80100a80:	5e                   	pop    %esi
80100a81:	5f                   	pop    %edi
80100a82:	5d                   	pop    %ebp
80100a83:	c3                   	ret    
80100a84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100a88:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a8f:	45 4c 46 
80100a92:	75 d2                	jne    80100a66 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100a94:	e8 67 62 00 00       	call   80106d00 <setupkvm>
80100a99:	85 c0                	test   %eax,%eax
80100a9b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100aa1:	74 c3                	je     80100a66 <exec+0x56>
  sz = 0;
80100aa3:	31 ff                	xor    %edi,%edi
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100aa5:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100aac:	00 
80100aad:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
80100ab3:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100ab9:	0f 84 8c 02 00 00    	je     80100d4b <exec+0x33b>
80100abf:	31 f6                	xor    %esi,%esi
80100ac1:	eb 7f                	jmp    80100b42 <exec+0x132>
80100ac3:	90                   	nop
80100ac4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ph.type != ELF_PROG_LOAD)
80100ac8:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100acf:	75 63                	jne    80100b34 <exec+0x124>
    if(ph.memsz < ph.filesz)
80100ad1:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100ad7:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100add:	0f 82 86 00 00 00    	jb     80100b69 <exec+0x159>
80100ae3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ae9:	72 7e                	jb     80100b69 <exec+0x159>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100aeb:	83 ec 04             	sub    $0x4,%esp
80100aee:	50                   	push   %eax
80100aef:	57                   	push   %edi
80100af0:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100af6:	e8 25 60 00 00       	call   80106b20 <allocuvm>
80100afb:	83 c4 10             	add    $0x10,%esp
80100afe:	85 c0                	test   %eax,%eax
80100b00:	89 c7                	mov    %eax,%edi
80100b02:	74 65                	je     80100b69 <exec+0x159>
    if(ph.vaddr % PGSIZE != 0)
80100b04:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b0a:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b0f:	75 58                	jne    80100b69 <exec+0x159>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b11:	83 ec 0c             	sub    $0xc,%esp
80100b14:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b1a:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100b20:	53                   	push   %ebx
80100b21:	50                   	push   %eax
80100b22:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b28:	e8 33 5f 00 00       	call   80106a60 <loaduvm>
80100b2d:	83 c4 20             	add    $0x20,%esp
80100b30:	85 c0                	test   %eax,%eax
80100b32:	78 35                	js     80100b69 <exec+0x159>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b34:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100b3b:	83 c6 01             	add    $0x1,%esi
80100b3e:	39 f0                	cmp    %esi,%eax
80100b40:	7e 3d                	jle    80100b7f <exec+0x16f>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100b42:	89 f0                	mov    %esi,%eax
80100b44:	6a 20                	push   $0x20
80100b46:	c1 e0 05             	shl    $0x5,%eax
80100b49:	03 85 ec fe ff ff    	add    -0x114(%ebp),%eax
80100b4f:	50                   	push   %eax
80100b50:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100b56:	50                   	push   %eax
80100b57:	53                   	push   %ebx
80100b58:	e8 13 0e 00 00       	call   80101970 <readi>
80100b5d:	83 c4 10             	add    $0x10,%esp
80100b60:	83 f8 20             	cmp    $0x20,%eax
80100b63:	0f 84 5f ff ff ff    	je     80100ac8 <exec+0xb8>
    freevm(pgdir);
80100b69:	83 ec 0c             	sub    $0xc,%esp
80100b6c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b72:	e8 09 61 00 00       	call   80106c80 <freevm>
80100b77:	83 c4 10             	add    $0x10,%esp
80100b7a:	e9 e7 fe ff ff       	jmp    80100a66 <exec+0x56>
80100b7f:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100b85:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100b8b:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100b91:	83 ec 0c             	sub    $0xc,%esp
80100b94:	53                   	push   %ebx
80100b95:	e8 86 0d 00 00       	call   80101920 <iunlockput>
  end_op();
80100b9a:	e8 21 21 00 00       	call   80102cc0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b9f:	83 c4 0c             	add    $0xc,%esp
80100ba2:	56                   	push   %esi
80100ba3:	57                   	push   %edi
80100ba4:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100baa:	e8 71 5f 00 00       	call   80106b20 <allocuvm>
80100baf:	83 c4 10             	add    $0x10,%esp
80100bb2:	85 c0                	test   %eax,%eax
80100bb4:	89 c6                	mov    %eax,%esi
80100bb6:	75 3a                	jne    80100bf2 <exec+0x1e2>
    freevm(pgdir);
80100bb8:	83 ec 0c             	sub    $0xc,%esp
80100bbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bc1:	e8 ba 60 00 00       	call   80106c80 <freevm>
80100bc6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100bc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bce:	e9 a9 fe ff ff       	jmp    80100a7c <exec+0x6c>
    end_op();
80100bd3:	e8 e8 20 00 00       	call   80102cc0 <end_op>
    cprintf("exec: fail\n");
80100bd8:	83 ec 0c             	sub    $0xc,%esp
80100bdb:	68 21 70 10 80       	push   $0x80107021
80100be0:	e8 7b fa ff ff       	call   80100660 <cprintf>
    return -1;
80100be5:	83 c4 10             	add    $0x10,%esp
80100be8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bed:	e9 8a fe ff ff       	jmp    80100a7c <exec+0x6c>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bf2:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100bf8:	83 ec 08             	sub    $0x8,%esp
  for(argc = 0; argv[argc]; argc++) {
80100bfb:	31 ff                	xor    %edi,%edi
80100bfd:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bff:	50                   	push   %eax
80100c00:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100c06:	e8 95 61 00 00       	call   80106da0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c0b:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c0e:	83 c4 10             	add    $0x10,%esp
80100c11:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c17:	8b 00                	mov    (%eax),%eax
80100c19:	85 c0                	test   %eax,%eax
80100c1b:	74 70                	je     80100c8d <exec+0x27d>
80100c1d:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100c23:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100c29:	eb 0a                	jmp    80100c35 <exec+0x225>
80100c2b:	90                   	nop
80100c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(argc >= MAXARG)
80100c30:	83 ff 20             	cmp    $0x20,%edi
80100c33:	74 83                	je     80100bb8 <exec+0x1a8>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c35:	83 ec 0c             	sub    $0xc,%esp
80100c38:	50                   	push   %eax
80100c39:	e8 e2 3a 00 00       	call   80104720 <strlen>
80100c3e:	f7 d0                	not    %eax
80100c40:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c42:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c45:	5a                   	pop    %edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c46:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c49:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c4c:	e8 cf 3a 00 00       	call   80104720 <strlen>
80100c51:	83 c0 01             	add    $0x1,%eax
80100c54:	50                   	push   %eax
80100c55:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c58:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c5b:	53                   	push   %ebx
80100c5c:	56                   	push   %esi
80100c5d:	e8 9e 62 00 00       	call   80106f00 <copyout>
80100c62:	83 c4 20             	add    $0x20,%esp
80100c65:	85 c0                	test   %eax,%eax
80100c67:	0f 88 4b ff ff ff    	js     80100bb8 <exec+0x1a8>
  for(argc = 0; argv[argc]; argc++) {
80100c6d:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100c70:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c77:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100c7a:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100c80:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c83:	85 c0                	test   %eax,%eax
80100c85:	75 a9                	jne    80100c30 <exec+0x220>
80100c87:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c8d:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100c94:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100c96:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100c9d:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100ca1:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100ca8:	ff ff ff 
  ustack[1] = argc;
80100cab:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cb1:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100cb3:	83 c0 0c             	add    $0xc,%eax
80100cb6:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cb8:	50                   	push   %eax
80100cb9:	52                   	push   %edx
80100cba:	53                   	push   %ebx
80100cbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cc1:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cc7:	e8 34 62 00 00       	call   80106f00 <copyout>
80100ccc:	83 c4 10             	add    $0x10,%esp
80100ccf:	85 c0                	test   %eax,%eax
80100cd1:	0f 88 e1 fe ff ff    	js     80100bb8 <exec+0x1a8>
  for(last=s=path; *s; s++)
80100cd7:	8b 45 08             	mov    0x8(%ebp),%eax
80100cda:	0f b6 00             	movzbl (%eax),%eax
80100cdd:	84 c0                	test   %al,%al
80100cdf:	74 17                	je     80100cf8 <exec+0x2e8>
80100ce1:	8b 55 08             	mov    0x8(%ebp),%edx
80100ce4:	89 d1                	mov    %edx,%ecx
80100ce6:	83 c1 01             	add    $0x1,%ecx
80100ce9:	3c 2f                	cmp    $0x2f,%al
80100ceb:	0f b6 01             	movzbl (%ecx),%eax
80100cee:	0f 44 d1             	cmove  %ecx,%edx
80100cf1:	84 c0                	test   %al,%al
80100cf3:	75 f1                	jne    80100ce6 <exec+0x2d6>
80100cf5:	89 55 08             	mov    %edx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100cf8:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100cfe:	50                   	push   %eax
80100cff:	6a 10                	push   $0x10
80100d01:	ff 75 08             	pushl  0x8(%ebp)
80100d04:	89 f8                	mov    %edi,%eax
80100d06:	83 c0 6c             	add    $0x6c,%eax
80100d09:	50                   	push   %eax
80100d0a:	e8 d1 39 00 00       	call   801046e0 <safestrcpy>
  curproc->pgdir = pgdir;
80100d0f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  oldpgdir = curproc->pgdir;
80100d15:	89 f9                	mov    %edi,%ecx
80100d17:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->tf->eip = elf.entry;  // main
80100d1a:	8b 41 18             	mov    0x18(%ecx),%eax
  curproc->sz = sz;
80100d1d:	89 31                	mov    %esi,(%ecx)
  curproc->pgdir = pgdir;
80100d1f:	89 51 04             	mov    %edx,0x4(%ecx)
  curproc->tf->eip = elf.entry;  // main
80100d22:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d28:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d2b:	8b 41 18             	mov    0x18(%ecx),%eax
80100d2e:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d31:	89 0c 24             	mov    %ecx,(%esp)
80100d34:	e8 97 5b 00 00       	call   801068d0 <switchuvm>
  freevm(oldpgdir);
80100d39:	89 3c 24             	mov    %edi,(%esp)
80100d3c:	e8 3f 5f 00 00       	call   80106c80 <freevm>
  return 0;
80100d41:	83 c4 10             	add    $0x10,%esp
80100d44:	31 c0                	xor    %eax,%eax
80100d46:	e9 31 fd ff ff       	jmp    80100a7c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d4b:	be 00 20 00 00       	mov    $0x2000,%esi
80100d50:	e9 3c fe ff ff       	jmp    80100b91 <exec+0x181>
80100d55:	66 90                	xchg   %ax,%ax
80100d57:	66 90                	xchg   %ax,%ax
80100d59:	66 90                	xchg   %ax,%ax
80100d5b:	66 90                	xchg   %ax,%ax
80100d5d:	66 90                	xchg   %ax,%ax
80100d5f:	90                   	nop

80100d60 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d60:	55                   	push   %ebp
80100d61:	89 e5                	mov    %esp,%ebp
80100d63:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100d66:	68 2d 70 10 80       	push   $0x8010702d
80100d6b:	68 c0 ff 10 80       	push   $0x8010ffc0
80100d70:	e8 3b 35 00 00       	call   801042b0 <initlock>
}
80100d75:	83 c4 10             	add    $0x10,%esp
80100d78:	c9                   	leave  
80100d79:	c3                   	ret    
80100d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100d80 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d80:	55                   	push   %ebp
80100d81:	89 e5                	mov    %esp,%ebp
80100d83:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d84:	bb f4 ff 10 80       	mov    $0x8010fff4,%ebx
{
80100d89:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100d8c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100d91:	e8 5a 36 00 00       	call   801043f0 <acquire>
80100d96:	83 c4 10             	add    $0x10,%esp
80100d99:	eb 10                	jmp    80100dab <filealloc+0x2b>
80100d9b:	90                   	nop
80100d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100da0:	83 c3 18             	add    $0x18,%ebx
80100da3:	81 fb 54 09 11 80    	cmp    $0x80110954,%ebx
80100da9:	73 25                	jae    80100dd0 <filealloc+0x50>
    if(f->ref == 0){
80100dab:	8b 43 04             	mov    0x4(%ebx),%eax
80100dae:	85 c0                	test   %eax,%eax
80100db0:	75 ee                	jne    80100da0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100db2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100db5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100dbc:	68 c0 ff 10 80       	push   $0x8010ffc0
80100dc1:	e8 ea 36 00 00       	call   801044b0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100dc6:	89 d8                	mov    %ebx,%eax
      return f;
80100dc8:	83 c4 10             	add    $0x10,%esp
}
80100dcb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dce:	c9                   	leave  
80100dcf:	c3                   	ret    
  release(&ftable.lock);
80100dd0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100dd3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100dd5:	68 c0 ff 10 80       	push   $0x8010ffc0
80100dda:	e8 d1 36 00 00       	call   801044b0 <release>
}
80100ddf:	89 d8                	mov    %ebx,%eax
  return 0;
80100de1:	83 c4 10             	add    $0x10,%esp
}
80100de4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100de7:	c9                   	leave  
80100de8:	c3                   	ret    
80100de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100df0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100df0:	55                   	push   %ebp
80100df1:	89 e5                	mov    %esp,%ebp
80100df3:	53                   	push   %ebx
80100df4:	83 ec 10             	sub    $0x10,%esp
80100df7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100dfa:	68 c0 ff 10 80       	push   $0x8010ffc0
80100dff:	e8 ec 35 00 00       	call   801043f0 <acquire>
  if(f->ref < 1)
80100e04:	8b 43 04             	mov    0x4(%ebx),%eax
80100e07:	83 c4 10             	add    $0x10,%esp
80100e0a:	85 c0                	test   %eax,%eax
80100e0c:	7e 1a                	jle    80100e28 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100e0e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e11:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100e14:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e17:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e1c:	e8 8f 36 00 00       	call   801044b0 <release>
  return f;
}
80100e21:	89 d8                	mov    %ebx,%eax
80100e23:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e26:	c9                   	leave  
80100e27:	c3                   	ret    
    panic("filedup");
80100e28:	83 ec 0c             	sub    $0xc,%esp
80100e2b:	68 34 70 10 80       	push   $0x80107034
80100e30:	e8 5b f5 ff ff       	call   80100390 <panic>
80100e35:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e40 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e40:	55                   	push   %ebp
80100e41:	89 e5                	mov    %esp,%ebp
80100e43:	57                   	push   %edi
80100e44:	56                   	push   %esi
80100e45:	53                   	push   %ebx
80100e46:	83 ec 28             	sub    $0x28,%esp
80100e49:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100e4c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e51:	e8 9a 35 00 00       	call   801043f0 <acquire>
  if(f->ref < 1)
80100e56:	8b 43 04             	mov    0x4(%ebx),%eax
80100e59:	83 c4 10             	add    $0x10,%esp
80100e5c:	85 c0                	test   %eax,%eax
80100e5e:	0f 8e 9b 00 00 00    	jle    80100eff <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100e64:	83 e8 01             	sub    $0x1,%eax
80100e67:	85 c0                	test   %eax,%eax
80100e69:	89 43 04             	mov    %eax,0x4(%ebx)
80100e6c:	74 1a                	je     80100e88 <fileclose+0x48>
    release(&ftable.lock);
80100e6e:	c7 45 08 c0 ff 10 80 	movl   $0x8010ffc0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e75:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e78:	5b                   	pop    %ebx
80100e79:	5e                   	pop    %esi
80100e7a:	5f                   	pop    %edi
80100e7b:	5d                   	pop    %ebp
    release(&ftable.lock);
80100e7c:	e9 2f 36 00 00       	jmp    801044b0 <release>
80100e81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ff = *f;
80100e88:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
80100e8c:	8b 3b                	mov    (%ebx),%edi
  release(&ftable.lock);
80100e8e:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100e91:	8b 73 0c             	mov    0xc(%ebx),%esi
  f->type = FD_NONE;
80100e94:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100e9a:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e9d:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100ea0:	68 c0 ff 10 80       	push   $0x8010ffc0
  ff = *f;
80100ea5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100ea8:	e8 03 36 00 00       	call   801044b0 <release>
  if(ff.type == FD_PIPE)
80100ead:	83 c4 10             	add    $0x10,%esp
80100eb0:	83 ff 01             	cmp    $0x1,%edi
80100eb3:	74 13                	je     80100ec8 <fileclose+0x88>
  else if(ff.type == FD_INODE){
80100eb5:	83 ff 02             	cmp    $0x2,%edi
80100eb8:	74 26                	je     80100ee0 <fileclose+0xa0>
}
80100eba:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ebd:	5b                   	pop    %ebx
80100ebe:	5e                   	pop    %esi
80100ebf:	5f                   	pop    %edi
80100ec0:	5d                   	pop    %ebp
80100ec1:	c3                   	ret    
80100ec2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pipeclose(ff.pipe, ff.writable);
80100ec8:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100ecc:	83 ec 08             	sub    $0x8,%esp
80100ecf:	53                   	push   %ebx
80100ed0:	56                   	push   %esi
80100ed1:	e8 2a 25 00 00       	call   80103400 <pipeclose>
80100ed6:	83 c4 10             	add    $0x10,%esp
80100ed9:	eb df                	jmp    80100eba <fileclose+0x7a>
80100edb:	90                   	nop
80100edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80100ee0:	e8 6b 1d 00 00       	call   80102c50 <begin_op>
    iput(ff.ip);
80100ee5:	83 ec 0c             	sub    $0xc,%esp
80100ee8:	ff 75 e0             	pushl  -0x20(%ebp)
80100eeb:	e8 d0 08 00 00       	call   801017c0 <iput>
    end_op();
80100ef0:	83 c4 10             	add    $0x10,%esp
}
80100ef3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ef6:	5b                   	pop    %ebx
80100ef7:	5e                   	pop    %esi
80100ef8:	5f                   	pop    %edi
80100ef9:	5d                   	pop    %ebp
    end_op();
80100efa:	e9 c1 1d 00 00       	jmp    80102cc0 <end_op>
    panic("fileclose");
80100eff:	83 ec 0c             	sub    $0xc,%esp
80100f02:	68 3c 70 10 80       	push   $0x8010703c
80100f07:	e8 84 f4 ff ff       	call   80100390 <panic>
80100f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f10 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100f10:	55                   	push   %ebp
80100f11:	89 e5                	mov    %esp,%ebp
80100f13:	53                   	push   %ebx
80100f14:	83 ec 04             	sub    $0x4,%esp
80100f17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100f1a:	83 3b 02             	cmpl   $0x2,(%ebx)
80100f1d:	75 31                	jne    80100f50 <filestat+0x40>
    ilock(f->ip);
80100f1f:	83 ec 0c             	sub    $0xc,%esp
80100f22:	ff 73 10             	pushl  0x10(%ebx)
80100f25:	e8 66 07 00 00       	call   80101690 <ilock>
    stati(f->ip, st);
80100f2a:	58                   	pop    %eax
80100f2b:	5a                   	pop    %edx
80100f2c:	ff 75 0c             	pushl  0xc(%ebp)
80100f2f:	ff 73 10             	pushl  0x10(%ebx)
80100f32:	e8 09 0a 00 00       	call   80101940 <stati>
    iunlock(f->ip);
80100f37:	59                   	pop    %ecx
80100f38:	ff 73 10             	pushl  0x10(%ebx)
80100f3b:	e8 30 08 00 00       	call   80101770 <iunlock>
    return 0;
80100f40:	83 c4 10             	add    $0x10,%esp
80100f43:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f48:	c9                   	leave  
80100f49:	c3                   	ret    
80100f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
80100f50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f55:	eb ee                	jmp    80100f45 <filestat+0x35>
80100f57:	89 f6                	mov    %esi,%esi
80100f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100f60 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f60:	55                   	push   %ebp
80100f61:	89 e5                	mov    %esp,%ebp
80100f63:	57                   	push   %edi
80100f64:	56                   	push   %esi
80100f65:	53                   	push   %ebx
80100f66:	83 ec 0c             	sub    $0xc,%esp
80100f69:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f6c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f6f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0) //if the file is unreadable
80100f72:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f76:	74 60                	je     80100fd8 <fileread+0x78>
    return -1;      
  if(f->type == FD_PIPE)
80100f78:	8b 03                	mov    (%ebx),%eax
80100f7a:	83 f8 01             	cmp    $0x1,%eax
80100f7d:	74 41                	je     80100fc0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){  //if the file type is FD_INODE
80100f7f:	83 f8 02             	cmp    $0x2,%eax
80100f82:	75 5b                	jne    80100fdf <fileread+0x7f>
    ilock(f->ip); //lock the inode
80100f84:	83 ec 0c             	sub    $0xc,%esp
80100f87:	ff 73 10             	pushl  0x10(%ebx)
80100f8a:	e8 01 07 00 00       	call   80101690 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f8f:	57                   	push   %edi
80100f90:	ff 73 14             	pushl  0x14(%ebx)
80100f93:	56                   	push   %esi
80100f94:	ff 73 10             	pushl  0x10(%ebx)
80100f97:	e8 d4 09 00 00       	call   80101970 <readi>
80100f9c:	83 c4 20             	add    $0x20,%esp
80100f9f:	85 c0                	test   %eax,%eax
80100fa1:	89 c6                	mov    %eax,%esi
80100fa3:	7e 03                	jle    80100fa8 <fileread+0x48>
      f->off += r;
80100fa5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100fa8:	83 ec 0c             	sub    $0xc,%esp
80100fab:	ff 73 10             	pushl  0x10(%ebx)
80100fae:	e8 bd 07 00 00       	call   80101770 <iunlock>
    return r;
80100fb3:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80100fb6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fb9:	89 f0                	mov    %esi,%eax
80100fbb:	5b                   	pop    %ebx
80100fbc:	5e                   	pop    %esi
80100fbd:	5f                   	pop    %edi
80100fbe:	5d                   	pop    %ebp
80100fbf:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80100fc0:	8b 43 0c             	mov    0xc(%ebx),%eax
80100fc3:	89 45 08             	mov    %eax,0x8(%ebp)
}
80100fc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fc9:	5b                   	pop    %ebx
80100fca:	5e                   	pop    %esi
80100fcb:	5f                   	pop    %edi
80100fcc:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80100fcd:	e9 de 25 00 00       	jmp    801035b0 <piperead>
80100fd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;      
80100fd8:	be ff ff ff ff       	mov    $0xffffffff,%esi
80100fdd:	eb d7                	jmp    80100fb6 <fileread+0x56>
  panic("fileread");
80100fdf:	83 ec 0c             	sub    $0xc,%esp
80100fe2:	68 46 70 10 80       	push   $0x80107046
80100fe7:	e8 a4 f3 ff ff       	call   80100390 <panic>
80100fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100ff0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100ff0:	55                   	push   %ebp
80100ff1:	89 e5                	mov    %esp,%ebp
80100ff3:	57                   	push   %edi
80100ff4:	56                   	push   %esi
80100ff5:	53                   	push   %ebx
80100ff6:	83 ec 1c             	sub    $0x1c,%esp
80100ff9:	8b 75 08             	mov    0x8(%ebp),%esi
80100ffc:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
80100fff:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
80101003:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101006:	8b 45 10             	mov    0x10(%ebp),%eax
80101009:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010100c:	0f 84 aa 00 00 00    	je     801010bc <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80101012:	8b 06                	mov    (%esi),%eax
80101014:	83 f8 01             	cmp    $0x1,%eax
80101017:	0f 84 c3 00 00 00    	je     801010e0 <filewrite+0xf0>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010101d:	83 f8 02             	cmp    $0x2,%eax
80101020:	0f 85 d9 00 00 00    	jne    801010ff <filewrite+0x10f>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101026:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101029:	31 ff                	xor    %edi,%edi
    while(i < n){
8010102b:	85 c0                	test   %eax,%eax
8010102d:	7f 34                	jg     80101063 <filewrite+0x73>
8010102f:	e9 9c 00 00 00       	jmp    801010d0 <filewrite+0xe0>
80101034:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101038:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010103b:	83 ec 0c             	sub    $0xc,%esp
8010103e:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101041:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101044:	e8 27 07 00 00       	call   80101770 <iunlock>
      end_op();
80101049:	e8 72 1c 00 00       	call   80102cc0 <end_op>
8010104e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101051:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101054:	39 c3                	cmp    %eax,%ebx
80101056:	0f 85 96 00 00 00    	jne    801010f2 <filewrite+0x102>
        panic("short filewrite");
      i += r;
8010105c:	01 df                	add    %ebx,%edi
    while(i < n){
8010105e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101061:	7e 6d                	jle    801010d0 <filewrite+0xe0>
      int n1 = n - i;
80101063:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101066:	b8 00 06 00 00       	mov    $0x600,%eax
8010106b:	29 fb                	sub    %edi,%ebx
8010106d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101073:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
80101076:	e8 d5 1b 00 00       	call   80102c50 <begin_op>
      ilock(f->ip);
8010107b:	83 ec 0c             	sub    $0xc,%esp
8010107e:	ff 76 10             	pushl  0x10(%esi)
80101081:	e8 0a 06 00 00       	call   80101690 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101086:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101089:	53                   	push   %ebx
8010108a:	ff 76 14             	pushl  0x14(%esi)
8010108d:	01 f8                	add    %edi,%eax
8010108f:	50                   	push   %eax
80101090:	ff 76 10             	pushl  0x10(%esi)
80101093:	e8 08 0a 00 00       	call   80101aa0 <writei>
80101098:	83 c4 20             	add    $0x20,%esp
8010109b:	85 c0                	test   %eax,%eax
8010109d:	7f 99                	jg     80101038 <filewrite+0x48>
      iunlock(f->ip);
8010109f:	83 ec 0c             	sub    $0xc,%esp
801010a2:	ff 76 10             	pushl  0x10(%esi)
801010a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801010a8:	e8 c3 06 00 00       	call   80101770 <iunlock>
      end_op();
801010ad:	e8 0e 1c 00 00       	call   80102cc0 <end_op>
      if(r < 0)
801010b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010b5:	83 c4 10             	add    $0x10,%esp
801010b8:	85 c0                	test   %eax,%eax
801010ba:	74 98                	je     80101054 <filewrite+0x64>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801010bf:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
801010c4:	89 f8                	mov    %edi,%eax
801010c6:	5b                   	pop    %ebx
801010c7:	5e                   	pop    %esi
801010c8:	5f                   	pop    %edi
801010c9:	5d                   	pop    %ebp
801010ca:	c3                   	ret    
801010cb:	90                   	nop
801010cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return i == n ? n : -1;
801010d0:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801010d3:	75 e7                	jne    801010bc <filewrite+0xcc>
}
801010d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010d8:	89 f8                	mov    %edi,%eax
801010da:	5b                   	pop    %ebx
801010db:	5e                   	pop    %esi
801010dc:	5f                   	pop    %edi
801010dd:	5d                   	pop    %ebp
801010de:	c3                   	ret    
801010df:	90                   	nop
    return pipewrite(f->pipe, addr, n);
801010e0:	8b 46 0c             	mov    0xc(%esi),%eax
801010e3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010e9:	5b                   	pop    %ebx
801010ea:	5e                   	pop    %esi
801010eb:	5f                   	pop    %edi
801010ec:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801010ed:	e9 ae 23 00 00       	jmp    801034a0 <pipewrite>
        panic("short filewrite");
801010f2:	83 ec 0c             	sub    $0xc,%esp
801010f5:	68 4f 70 10 80       	push   $0x8010704f
801010fa:	e8 91 f2 ff ff       	call   80100390 <panic>
  panic("filewrite");
801010ff:	83 ec 0c             	sub    $0xc,%esp
80101102:	68 55 70 10 80       	push   $0x80107055
80101107:	e8 84 f2 ff ff       	call   80100390 <panic>
8010110c:	66 90                	xchg   %ax,%ax
8010110e:	66 90                	xchg   %ax,%ax

80101110 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101110:	55                   	push   %ebp
80101111:	89 e5                	mov    %esp,%ebp
80101113:	57                   	push   %edi
80101114:	56                   	push   %esi
80101115:	53                   	push   %ebx
80101116:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101119:	8b 0d c0 09 11 80    	mov    0x801109c0,%ecx
{
8010111f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101122:	85 c9                	test   %ecx,%ecx
80101124:	0f 84 87 00 00 00    	je     801011b1 <balloc+0xa1>
8010112a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101131:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101134:	83 ec 08             	sub    $0x8,%esp
80101137:	89 f0                	mov    %esi,%eax
80101139:	c1 f8 0c             	sar    $0xc,%eax
8010113c:	03 05 d8 09 11 80    	add    0x801109d8,%eax
80101142:	50                   	push   %eax
80101143:	ff 75 d8             	pushl  -0x28(%ebp)
80101146:	e8 85 ef ff ff       	call   801000d0 <bread>
8010114b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010114e:	a1 c0 09 11 80       	mov    0x801109c0,%eax
80101153:	83 c4 10             	add    $0x10,%esp
80101156:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101159:	31 c0                	xor    %eax,%eax
8010115b:	eb 2f                	jmp    8010118c <balloc+0x7c>
8010115d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101160:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101162:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
80101165:	bb 01 00 00 00       	mov    $0x1,%ebx
8010116a:	83 e1 07             	and    $0x7,%ecx
8010116d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010116f:	89 c1                	mov    %eax,%ecx
80101171:	c1 f9 03             	sar    $0x3,%ecx
80101174:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101179:	85 df                	test   %ebx,%edi
8010117b:	89 fa                	mov    %edi,%edx
8010117d:	74 41                	je     801011c0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010117f:	83 c0 01             	add    $0x1,%eax
80101182:	83 c6 01             	add    $0x1,%esi
80101185:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010118a:	74 05                	je     80101191 <balloc+0x81>
8010118c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010118f:	77 cf                	ja     80101160 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101191:	83 ec 0c             	sub    $0xc,%esp
80101194:	ff 75 e4             	pushl  -0x1c(%ebp)
80101197:	e8 44 f0 ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010119c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801011a3:	83 c4 10             	add    $0x10,%esp
801011a6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801011a9:	39 05 c0 09 11 80    	cmp    %eax,0x801109c0
801011af:	77 80                	ja     80101131 <balloc+0x21>
  }
  panic("balloc: out of blocks");
801011b1:	83 ec 0c             	sub    $0xc,%esp
801011b4:	68 5f 70 10 80       	push   $0x8010705f
801011b9:	e8 d2 f1 ff ff       	call   80100390 <panic>
801011be:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801011c0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801011c3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801011c6:	09 da                	or     %ebx,%edx
801011c8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801011cc:	57                   	push   %edi
801011cd:	e8 4e 1c 00 00       	call   80102e20 <log_write>
        brelse(bp);
801011d2:	89 3c 24             	mov    %edi,(%esp)
801011d5:	e8 06 f0 ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
801011da:	58                   	pop    %eax
801011db:	5a                   	pop    %edx
801011dc:	56                   	push   %esi
801011dd:	ff 75 d8             	pushl  -0x28(%ebp)
801011e0:	e8 eb ee ff ff       	call   801000d0 <bread>
801011e5:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801011e7:	8d 40 5c             	lea    0x5c(%eax),%eax
801011ea:	83 c4 0c             	add    $0xc,%esp
801011ed:	68 00 02 00 00       	push   $0x200
801011f2:	6a 00                	push   $0x0
801011f4:	50                   	push   %eax
801011f5:	e8 06 33 00 00       	call   80104500 <memset>
  log_write(bp);
801011fa:	89 1c 24             	mov    %ebx,(%esp)
801011fd:	e8 1e 1c 00 00       	call   80102e20 <log_write>
  brelse(bp);
80101202:	89 1c 24             	mov    %ebx,(%esp)
80101205:	e8 d6 ef ff ff       	call   801001e0 <brelse>
}
8010120a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010120d:	89 f0                	mov    %esi,%eax
8010120f:	5b                   	pop    %ebx
80101210:	5e                   	pop    %esi
80101211:	5f                   	pop    %edi
80101212:	5d                   	pop    %ebp
80101213:	c3                   	ret    
80101214:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010121a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101220 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101220:	55                   	push   %ebp
80101221:	89 e5                	mov    %esp,%ebp
80101223:	57                   	push   %edi
80101224:	56                   	push   %esi
80101225:	53                   	push   %ebx
80101226:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101228:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010122a:	bb 14 0a 11 80       	mov    $0x80110a14,%ebx
{
8010122f:	83 ec 28             	sub    $0x28,%esp
80101232:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101235:	68 e0 09 11 80       	push   $0x801109e0
8010123a:	e8 b1 31 00 00       	call   801043f0 <acquire>
8010123f:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101242:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101245:	eb 17                	jmp    8010125e <iget+0x3e>
80101247:	89 f6                	mov    %esi,%esi
80101249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101250:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101256:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
8010125c:	73 22                	jae    80101280 <iget+0x60>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010125e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101261:	85 c9                	test   %ecx,%ecx
80101263:	7e 04                	jle    80101269 <iget+0x49>
80101265:	39 3b                	cmp    %edi,(%ebx)
80101267:	74 4f                	je     801012b8 <iget+0x98>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101269:	85 f6                	test   %esi,%esi
8010126b:	75 e3                	jne    80101250 <iget+0x30>
8010126d:	85 c9                	test   %ecx,%ecx
8010126f:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101272:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101278:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
8010127e:	72 de                	jb     8010125e <iget+0x3e>
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101280:	85 f6                	test   %esi,%esi
80101282:	74 5b                	je     801012df <iget+0xbf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
80101284:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
80101287:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101289:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
8010128c:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101293:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
8010129a:	68 e0 09 11 80       	push   $0x801109e0
8010129f:	e8 0c 32 00 00       	call   801044b0 <release>

  return ip;
801012a4:	83 c4 10             	add    $0x10,%esp
}
801012a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012aa:	89 f0                	mov    %esi,%eax
801012ac:	5b                   	pop    %ebx
801012ad:	5e                   	pop    %esi
801012ae:	5f                   	pop    %edi
801012af:	5d                   	pop    %ebp
801012b0:	c3                   	ret    
801012b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801012b8:	39 53 04             	cmp    %edx,0x4(%ebx)
801012bb:	75 ac                	jne    80101269 <iget+0x49>
      release(&icache.lock);
801012bd:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801012c0:	83 c1 01             	add    $0x1,%ecx
      return ip;
801012c3:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801012c5:	68 e0 09 11 80       	push   $0x801109e0
      ip->ref++;
801012ca:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
801012cd:	e8 de 31 00 00       	call   801044b0 <release>
      return ip;
801012d2:	83 c4 10             	add    $0x10,%esp
}
801012d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012d8:	89 f0                	mov    %esi,%eax
801012da:	5b                   	pop    %ebx
801012db:	5e                   	pop    %esi
801012dc:	5f                   	pop    %edi
801012dd:	5d                   	pop    %ebp
801012de:	c3                   	ret    
    panic("iget: no inodes");
801012df:	83 ec 0c             	sub    $0xc,%esp
801012e2:	68 75 70 10 80       	push   $0x80107075
801012e7:	e8 a4 f0 ff ff       	call   80100390 <panic>
801012ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801012f0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801012f0:	55                   	push   %ebp
801012f1:	89 e5                	mov    %esp,%ebp
801012f3:	57                   	push   %edi
801012f4:	56                   	push   %esi
801012f5:	53                   	push   %ebx
801012f6:	89 c6                	mov    %eax,%esi
801012f8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801012fb:	83 fa 0b             	cmp    $0xb,%edx
801012fe:	77 18                	ja     80101318 <bmap+0x28>
80101300:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
80101303:	8b 5f 5c             	mov    0x5c(%edi),%ebx
80101306:	85 db                	test   %ebx,%ebx
80101308:	74 76                	je     80101380 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010130a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010130d:	89 d8                	mov    %ebx,%eax
8010130f:	5b                   	pop    %ebx
80101310:	5e                   	pop    %esi
80101311:	5f                   	pop    %edi
80101312:	5d                   	pop    %ebp
80101313:	c3                   	ret    
80101314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bn -= NDIRECT;
80101318:	8d 5a f4             	lea    -0xc(%edx),%ebx
  if(bn < NINDIRECT){
8010131b:	83 fb 7f             	cmp    $0x7f,%ebx
8010131e:	0f 87 90 00 00 00    	ja     801013b4 <bmap+0xc4>
    if((addr = ip->addrs[NDIRECT]) == 0)
80101324:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
8010132a:	8b 00                	mov    (%eax),%eax
8010132c:	85 d2                	test   %edx,%edx
8010132e:	74 70                	je     801013a0 <bmap+0xb0>
    bp = bread(ip->dev, addr);
80101330:	83 ec 08             	sub    $0x8,%esp
80101333:	52                   	push   %edx
80101334:	50                   	push   %eax
80101335:	e8 96 ed ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
8010133a:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
8010133e:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
80101341:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
80101343:	8b 1a                	mov    (%edx),%ebx
80101345:	85 db                	test   %ebx,%ebx
80101347:	75 1d                	jne    80101366 <bmap+0x76>
      a[bn] = addr = balloc(ip->dev);
80101349:	8b 06                	mov    (%esi),%eax
8010134b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010134e:	e8 bd fd ff ff       	call   80101110 <balloc>
80101353:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
80101356:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101359:	89 c3                	mov    %eax,%ebx
8010135b:	89 02                	mov    %eax,(%edx)
      log_write(bp);
8010135d:	57                   	push   %edi
8010135e:	e8 bd 1a 00 00       	call   80102e20 <log_write>
80101363:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101366:	83 ec 0c             	sub    $0xc,%esp
80101369:	57                   	push   %edi
8010136a:	e8 71 ee ff ff       	call   801001e0 <brelse>
8010136f:	83 c4 10             	add    $0x10,%esp
}
80101372:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101375:	89 d8                	mov    %ebx,%eax
80101377:	5b                   	pop    %ebx
80101378:	5e                   	pop    %esi
80101379:	5f                   	pop    %edi
8010137a:	5d                   	pop    %ebp
8010137b:	c3                   	ret    
8010137c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[bn] = addr = balloc(ip->dev);
80101380:	8b 00                	mov    (%eax),%eax
80101382:	e8 89 fd ff ff       	call   80101110 <balloc>
80101387:	89 47 5c             	mov    %eax,0x5c(%edi)
}
8010138a:	8d 65 f4             	lea    -0xc(%ebp),%esp
      ip->addrs[bn] = addr = balloc(ip->dev);
8010138d:	89 c3                	mov    %eax,%ebx
}
8010138f:	89 d8                	mov    %ebx,%eax
80101391:	5b                   	pop    %ebx
80101392:	5e                   	pop    %esi
80101393:	5f                   	pop    %edi
80101394:	5d                   	pop    %ebp
80101395:	c3                   	ret    
80101396:	8d 76 00             	lea    0x0(%esi),%esi
80101399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801013a0:	e8 6b fd ff ff       	call   80101110 <balloc>
801013a5:	89 c2                	mov    %eax,%edx
801013a7:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801013ad:	8b 06                	mov    (%esi),%eax
801013af:	e9 7c ff ff ff       	jmp    80101330 <bmap+0x40>
  panic("bmap: out of range");
801013b4:	83 ec 0c             	sub    $0xc,%esp
801013b7:	68 85 70 10 80       	push   $0x80107085
801013bc:	e8 cf ef ff ff       	call   80100390 <panic>
801013c1:	eb 0d                	jmp    801013d0 <readsb>
801013c3:	90                   	nop
801013c4:	90                   	nop
801013c5:	90                   	nop
801013c6:	90                   	nop
801013c7:	90                   	nop
801013c8:	90                   	nop
801013c9:	90                   	nop
801013ca:	90                   	nop
801013cb:	90                   	nop
801013cc:	90                   	nop
801013cd:	90                   	nop
801013ce:	90                   	nop
801013cf:	90                   	nop

801013d0 <readsb>:
{
801013d0:	55                   	push   %ebp
801013d1:	89 e5                	mov    %esp,%ebp
801013d3:	56                   	push   %esi
801013d4:	53                   	push   %ebx
801013d5:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
801013d8:	83 ec 08             	sub    $0x8,%esp
801013db:	6a 01                	push   $0x1
801013dd:	ff 75 08             	pushl  0x8(%ebp)
801013e0:	e8 eb ec ff ff       	call   801000d0 <bread>
801013e5:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801013e7:	8d 40 5c             	lea    0x5c(%eax),%eax
801013ea:	83 c4 0c             	add    $0xc,%esp
801013ed:	6a 1c                	push   $0x1c
801013ef:	50                   	push   %eax
801013f0:	56                   	push   %esi
801013f1:	e8 ba 31 00 00       	call   801045b0 <memmove>
  brelse(bp);
801013f6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801013f9:	83 c4 10             	add    $0x10,%esp
}
801013fc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801013ff:	5b                   	pop    %ebx
80101400:	5e                   	pop    %esi
80101401:	5d                   	pop    %ebp
  brelse(bp);
80101402:	e9 d9 ed ff ff       	jmp    801001e0 <brelse>
80101407:	89 f6                	mov    %esi,%esi
80101409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101410 <bfree>:
{
80101410:	55                   	push   %ebp
80101411:	89 e5                	mov    %esp,%ebp
80101413:	56                   	push   %esi
80101414:	53                   	push   %ebx
80101415:	89 d3                	mov    %edx,%ebx
80101417:	89 c6                	mov    %eax,%esi
  readsb(dev, &sb);
80101419:	83 ec 08             	sub    $0x8,%esp
8010141c:	68 c0 09 11 80       	push   $0x801109c0
80101421:	50                   	push   %eax
80101422:	e8 a9 ff ff ff       	call   801013d0 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
80101427:	58                   	pop    %eax
80101428:	5a                   	pop    %edx
80101429:	89 da                	mov    %ebx,%edx
8010142b:	c1 ea 0c             	shr    $0xc,%edx
8010142e:	03 15 d8 09 11 80    	add    0x801109d8,%edx
80101434:	52                   	push   %edx
80101435:	56                   	push   %esi
80101436:	e8 95 ec ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
8010143b:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010143d:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
80101440:	ba 01 00 00 00       	mov    $0x1,%edx
80101445:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101448:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
8010144e:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101451:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101453:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101458:	85 d1                	test   %edx,%ecx
8010145a:	74 25                	je     80101481 <bfree+0x71>
  bp->data[bi/8] &= ~m;
8010145c:	f7 d2                	not    %edx
8010145e:	89 c6                	mov    %eax,%esi
  log_write(bp);
80101460:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101463:	21 ca                	and    %ecx,%edx
80101465:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
80101469:	56                   	push   %esi
8010146a:	e8 b1 19 00 00       	call   80102e20 <log_write>
  brelse(bp);
8010146f:	89 34 24             	mov    %esi,(%esp)
80101472:	e8 69 ed ff ff       	call   801001e0 <brelse>
}
80101477:	83 c4 10             	add    $0x10,%esp
8010147a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010147d:	5b                   	pop    %ebx
8010147e:	5e                   	pop    %esi
8010147f:	5d                   	pop    %ebp
80101480:	c3                   	ret    
    panic("freeing free block");
80101481:	83 ec 0c             	sub    $0xc,%esp
80101484:	68 98 70 10 80       	push   $0x80107098
80101489:	e8 02 ef ff ff       	call   80100390 <panic>
8010148e:	66 90                	xchg   %ax,%ax

80101490 <iinit>:
{
80101490:	55                   	push   %ebp
80101491:	89 e5                	mov    %esp,%ebp
80101493:	53                   	push   %ebx
80101494:	bb 20 0a 11 80       	mov    $0x80110a20,%ebx
80101499:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010149c:	68 ab 70 10 80       	push   $0x801070ab
801014a1:	68 e0 09 11 80       	push   $0x801109e0
801014a6:	e8 05 2e 00 00       	call   801042b0 <initlock>
801014ab:	83 c4 10             	add    $0x10,%esp
801014ae:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801014b0:	83 ec 08             	sub    $0x8,%esp
801014b3:	68 b2 70 10 80       	push   $0x801070b2
801014b8:	53                   	push   %ebx
801014b9:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014bf:	e8 bc 2c 00 00       	call   80104180 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801014c4:	83 c4 10             	add    $0x10,%esp
801014c7:	81 fb 40 26 11 80    	cmp    $0x80112640,%ebx
801014cd:	75 e1                	jne    801014b0 <iinit+0x20>
  readsb(dev, &sb);
801014cf:	83 ec 08             	sub    $0x8,%esp
801014d2:	68 c0 09 11 80       	push   $0x801109c0
801014d7:	ff 75 08             	pushl  0x8(%ebp)
801014da:	e8 f1 fe ff ff       	call   801013d0 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014df:	ff 35 d8 09 11 80    	pushl  0x801109d8
801014e5:	ff 35 d4 09 11 80    	pushl  0x801109d4
801014eb:	ff 35 d0 09 11 80    	pushl  0x801109d0
801014f1:	ff 35 cc 09 11 80    	pushl  0x801109cc
801014f7:	ff 35 c8 09 11 80    	pushl  0x801109c8
801014fd:	ff 35 c4 09 11 80    	pushl  0x801109c4
80101503:	ff 35 c0 09 11 80    	pushl  0x801109c0
80101509:	68 18 71 10 80       	push   $0x80107118
8010150e:	e8 4d f1 ff ff       	call   80100660 <cprintf>
}
80101513:	83 c4 30             	add    $0x30,%esp
80101516:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101519:	c9                   	leave  
8010151a:	c3                   	ret    
8010151b:	90                   	nop
8010151c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101520 <ialloc>:
{
80101520:	55                   	push   %ebp
80101521:	89 e5                	mov    %esp,%ebp
80101523:	57                   	push   %edi
80101524:	56                   	push   %esi
80101525:	53                   	push   %ebx
80101526:	83 ec 1c             	sub    $0x1c,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101529:	83 3d c8 09 11 80 01 	cmpl   $0x1,0x801109c8
{
80101530:	8b 45 0c             	mov    0xc(%ebp),%eax
80101533:	8b 75 08             	mov    0x8(%ebp),%esi
80101536:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101539:	0f 86 91 00 00 00    	jbe    801015d0 <ialloc+0xb0>
8010153f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101544:	eb 21                	jmp    80101567 <ialloc+0x47>
80101546:	8d 76 00             	lea    0x0(%esi),%esi
80101549:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
80101550:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101553:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
80101556:	57                   	push   %edi
80101557:	e8 84 ec ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010155c:	83 c4 10             	add    $0x10,%esp
8010155f:	39 1d c8 09 11 80    	cmp    %ebx,0x801109c8
80101565:	76 69                	jbe    801015d0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101567:	89 d8                	mov    %ebx,%eax
80101569:	83 ec 08             	sub    $0x8,%esp
8010156c:	c1 e8 03             	shr    $0x3,%eax
8010156f:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101575:	50                   	push   %eax
80101576:	56                   	push   %esi
80101577:	e8 54 eb ff ff       	call   801000d0 <bread>
8010157c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010157e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101580:	83 c4 10             	add    $0x10,%esp
    dip = (struct dinode*)bp->data + inum%IPB;
80101583:	83 e0 07             	and    $0x7,%eax
80101586:	c1 e0 06             	shl    $0x6,%eax
80101589:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010158d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101591:	75 bd                	jne    80101550 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101593:	83 ec 04             	sub    $0x4,%esp
80101596:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101599:	6a 40                	push   $0x40
8010159b:	6a 00                	push   $0x0
8010159d:	51                   	push   %ecx
8010159e:	e8 5d 2f 00 00       	call   80104500 <memset>
      dip->type = type;
801015a3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801015a7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801015aa:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801015ad:	89 3c 24             	mov    %edi,(%esp)
801015b0:	e8 6b 18 00 00       	call   80102e20 <log_write>
      brelse(bp);
801015b5:	89 3c 24             	mov    %edi,(%esp)
801015b8:	e8 23 ec ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
801015bd:	83 c4 10             	add    $0x10,%esp
}
801015c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801015c3:	89 da                	mov    %ebx,%edx
801015c5:	89 f0                	mov    %esi,%eax
}
801015c7:	5b                   	pop    %ebx
801015c8:	5e                   	pop    %esi
801015c9:	5f                   	pop    %edi
801015ca:	5d                   	pop    %ebp
      return iget(dev, inum);
801015cb:	e9 50 fc ff ff       	jmp    80101220 <iget>
  panic("ialloc: no inodes");
801015d0:	83 ec 0c             	sub    $0xc,%esp
801015d3:	68 b8 70 10 80       	push   $0x801070b8
801015d8:	e8 b3 ed ff ff       	call   80100390 <panic>
801015dd:	8d 76 00             	lea    0x0(%esi),%esi

801015e0 <iupdate>:
{
801015e0:	55                   	push   %ebp
801015e1:	89 e5                	mov    %esp,%ebp
801015e3:	56                   	push   %esi
801015e4:	53                   	push   %ebx
801015e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015e8:	83 ec 08             	sub    $0x8,%esp
801015eb:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015ee:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015f1:	c1 e8 03             	shr    $0x3,%eax
801015f4:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801015fa:	50                   	push   %eax
801015fb:	ff 73 a4             	pushl  -0x5c(%ebx)
801015fe:	e8 cd ea ff ff       	call   801000d0 <bread>
80101603:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101605:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
80101608:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010160c:	83 c4 0c             	add    $0xc,%esp
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010160f:	83 e0 07             	and    $0x7,%eax
80101612:	c1 e0 06             	shl    $0x6,%eax
80101615:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101619:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010161c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101620:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101623:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101627:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010162b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010162f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101633:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101637:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010163a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010163d:	6a 34                	push   $0x34
8010163f:	53                   	push   %ebx
80101640:	50                   	push   %eax
80101641:	e8 6a 2f 00 00       	call   801045b0 <memmove>
  log_write(bp);
80101646:	89 34 24             	mov    %esi,(%esp)
80101649:	e8 d2 17 00 00       	call   80102e20 <log_write>
  brelse(bp);
8010164e:	89 75 08             	mov    %esi,0x8(%ebp)
80101651:	83 c4 10             	add    $0x10,%esp
}
80101654:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101657:	5b                   	pop    %ebx
80101658:	5e                   	pop    %esi
80101659:	5d                   	pop    %ebp
  brelse(bp);
8010165a:	e9 81 eb ff ff       	jmp    801001e0 <brelse>
8010165f:	90                   	nop

80101660 <idup>:
{
80101660:	55                   	push   %ebp
80101661:	89 e5                	mov    %esp,%ebp
80101663:	53                   	push   %ebx
80101664:	83 ec 10             	sub    $0x10,%esp
80101667:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010166a:	68 e0 09 11 80       	push   $0x801109e0
8010166f:	e8 7c 2d 00 00       	call   801043f0 <acquire>
  ip->ref++;
80101674:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101678:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010167f:	e8 2c 2e 00 00       	call   801044b0 <release>
}
80101684:	89 d8                	mov    %ebx,%eax
80101686:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101689:	c9                   	leave  
8010168a:	c3                   	ret    
8010168b:	90                   	nop
8010168c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101690 <ilock>:
{
80101690:	55                   	push   %ebp
80101691:	89 e5                	mov    %esp,%ebp
80101693:	56                   	push   %esi
80101694:	53                   	push   %ebx
80101695:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101698:	85 db                	test   %ebx,%ebx
8010169a:	0f 84 b7 00 00 00    	je     80101757 <ilock+0xc7>
801016a0:	8b 53 08             	mov    0x8(%ebx),%edx
801016a3:	85 d2                	test   %edx,%edx
801016a5:	0f 8e ac 00 00 00    	jle    80101757 <ilock+0xc7>
  acquiresleep(&ip->lock);
801016ab:	8d 43 0c             	lea    0xc(%ebx),%eax
801016ae:	83 ec 0c             	sub    $0xc,%esp
801016b1:	50                   	push   %eax
801016b2:	e8 09 2b 00 00       	call   801041c0 <acquiresleep>
  if(ip->valid == 0){
801016b7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801016ba:	83 c4 10             	add    $0x10,%esp
801016bd:	85 c0                	test   %eax,%eax
801016bf:	74 0f                	je     801016d0 <ilock+0x40>
}
801016c1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016c4:	5b                   	pop    %ebx
801016c5:	5e                   	pop    %esi
801016c6:	5d                   	pop    %ebp
801016c7:	c3                   	ret    
801016c8:	90                   	nop
801016c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016d0:	8b 43 04             	mov    0x4(%ebx),%eax
801016d3:	83 ec 08             	sub    $0x8,%esp
801016d6:	c1 e8 03             	shr    $0x3,%eax
801016d9:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801016df:	50                   	push   %eax
801016e0:	ff 33                	pushl  (%ebx)
801016e2:	e8 e9 e9 ff ff       	call   801000d0 <bread>
801016e7:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016e9:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016ec:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016ef:	83 e0 07             	and    $0x7,%eax
801016f2:	c1 e0 06             	shl    $0x6,%eax
801016f5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801016f9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016fc:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801016ff:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101703:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101707:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010170b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010170f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101713:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101717:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010171b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010171e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101721:	6a 34                	push   $0x34
80101723:	50                   	push   %eax
80101724:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101727:	50                   	push   %eax
80101728:	e8 83 2e 00 00       	call   801045b0 <memmove>
    brelse(bp);
8010172d:	89 34 24             	mov    %esi,(%esp)
80101730:	e8 ab ea ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
80101735:	83 c4 10             	add    $0x10,%esp
80101738:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010173d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101744:	0f 85 77 ff ff ff    	jne    801016c1 <ilock+0x31>
      panic("ilock: no type");
8010174a:	83 ec 0c             	sub    $0xc,%esp
8010174d:	68 d0 70 10 80       	push   $0x801070d0
80101752:	e8 39 ec ff ff       	call   80100390 <panic>
    panic("ilock");
80101757:	83 ec 0c             	sub    $0xc,%esp
8010175a:	68 ca 70 10 80       	push   $0x801070ca
8010175f:	e8 2c ec ff ff       	call   80100390 <panic>
80101764:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010176a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101770 <iunlock>:
{
80101770:	55                   	push   %ebp
80101771:	89 e5                	mov    %esp,%ebp
80101773:	56                   	push   %esi
80101774:	53                   	push   %ebx
80101775:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101778:	85 db                	test   %ebx,%ebx
8010177a:	74 28                	je     801017a4 <iunlock+0x34>
8010177c:	8d 73 0c             	lea    0xc(%ebx),%esi
8010177f:	83 ec 0c             	sub    $0xc,%esp
80101782:	56                   	push   %esi
80101783:	e8 d8 2a 00 00       	call   80104260 <holdingsleep>
80101788:	83 c4 10             	add    $0x10,%esp
8010178b:	85 c0                	test   %eax,%eax
8010178d:	74 15                	je     801017a4 <iunlock+0x34>
8010178f:	8b 43 08             	mov    0x8(%ebx),%eax
80101792:	85 c0                	test   %eax,%eax
80101794:	7e 0e                	jle    801017a4 <iunlock+0x34>
  releasesleep(&ip->lock);
80101796:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101799:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010179c:	5b                   	pop    %ebx
8010179d:	5e                   	pop    %esi
8010179e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010179f:	e9 7c 2a 00 00       	jmp    80104220 <releasesleep>
    panic("iunlock");
801017a4:	83 ec 0c             	sub    $0xc,%esp
801017a7:	68 df 70 10 80       	push   $0x801070df
801017ac:	e8 df eb ff ff       	call   80100390 <panic>
801017b1:	eb 0d                	jmp    801017c0 <iput>
801017b3:	90                   	nop
801017b4:	90                   	nop
801017b5:	90                   	nop
801017b6:	90                   	nop
801017b7:	90                   	nop
801017b8:	90                   	nop
801017b9:	90                   	nop
801017ba:	90                   	nop
801017bb:	90                   	nop
801017bc:	90                   	nop
801017bd:	90                   	nop
801017be:	90                   	nop
801017bf:	90                   	nop

801017c0 <iput>:
{
801017c0:	55                   	push   %ebp
801017c1:	89 e5                	mov    %esp,%ebp
801017c3:	57                   	push   %edi
801017c4:	56                   	push   %esi
801017c5:	53                   	push   %ebx
801017c6:	83 ec 28             	sub    $0x28,%esp
801017c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801017cc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801017cf:	57                   	push   %edi
801017d0:	e8 eb 29 00 00       	call   801041c0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801017d5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801017d8:	83 c4 10             	add    $0x10,%esp
801017db:	85 d2                	test   %edx,%edx
801017dd:	74 07                	je     801017e6 <iput+0x26>
801017df:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801017e4:	74 32                	je     80101818 <iput+0x58>
  releasesleep(&ip->lock);
801017e6:	83 ec 0c             	sub    $0xc,%esp
801017e9:	57                   	push   %edi
801017ea:	e8 31 2a 00 00       	call   80104220 <releasesleep>
  acquire(&icache.lock);
801017ef:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801017f6:	e8 f5 2b 00 00       	call   801043f0 <acquire>
  ip->ref--;
801017fb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801017ff:	83 c4 10             	add    $0x10,%esp
80101802:	c7 45 08 e0 09 11 80 	movl   $0x801109e0,0x8(%ebp)
}
80101809:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010180c:	5b                   	pop    %ebx
8010180d:	5e                   	pop    %esi
8010180e:	5f                   	pop    %edi
8010180f:	5d                   	pop    %ebp
  release(&icache.lock);
80101810:	e9 9b 2c 00 00       	jmp    801044b0 <release>
80101815:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101818:	83 ec 0c             	sub    $0xc,%esp
8010181b:	68 e0 09 11 80       	push   $0x801109e0
80101820:	e8 cb 2b 00 00       	call   801043f0 <acquire>
    int r = ip->ref;
80101825:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101828:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010182f:	e8 7c 2c 00 00       	call   801044b0 <release>
    if(r == 1){
80101834:	83 c4 10             	add    $0x10,%esp
80101837:	83 fe 01             	cmp    $0x1,%esi
8010183a:	75 aa                	jne    801017e6 <iput+0x26>
8010183c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101842:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101845:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101848:	89 cf                	mov    %ecx,%edi
8010184a:	eb 0b                	jmp    80101857 <iput+0x97>
8010184c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101850:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101853:	39 fe                	cmp    %edi,%esi
80101855:	74 19                	je     80101870 <iput+0xb0>
    if(ip->addrs[i]){
80101857:	8b 16                	mov    (%esi),%edx
80101859:	85 d2                	test   %edx,%edx
8010185b:	74 f3                	je     80101850 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010185d:	8b 03                	mov    (%ebx),%eax
8010185f:	e8 ac fb ff ff       	call   80101410 <bfree>
      ip->addrs[i] = 0;
80101864:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010186a:	eb e4                	jmp    80101850 <iput+0x90>
8010186c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101870:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101876:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101879:	85 c0                	test   %eax,%eax
8010187b:	75 33                	jne    801018b0 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010187d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101880:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101887:	53                   	push   %ebx
80101888:	e8 53 fd ff ff       	call   801015e0 <iupdate>
      ip->type = 0;
8010188d:	31 c0                	xor    %eax,%eax
8010188f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101893:	89 1c 24             	mov    %ebx,(%esp)
80101896:	e8 45 fd ff ff       	call   801015e0 <iupdate>
      ip->valid = 0;
8010189b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
801018a2:	83 c4 10             	add    $0x10,%esp
801018a5:	e9 3c ff ff ff       	jmp    801017e6 <iput+0x26>
801018aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018b0:	83 ec 08             	sub    $0x8,%esp
801018b3:	50                   	push   %eax
801018b4:	ff 33                	pushl  (%ebx)
801018b6:	e8 15 e8 ff ff       	call   801000d0 <bread>
801018bb:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801018c1:	89 7d e0             	mov    %edi,-0x20(%ebp)
801018c4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
801018c7:	8d 70 5c             	lea    0x5c(%eax),%esi
801018ca:	83 c4 10             	add    $0x10,%esp
801018cd:	89 cf                	mov    %ecx,%edi
801018cf:	eb 0e                	jmp    801018df <iput+0x11f>
801018d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018d8:	83 c6 04             	add    $0x4,%esi
    for(j = 0; j < NINDIRECT; j++){
801018db:	39 fe                	cmp    %edi,%esi
801018dd:	74 0f                	je     801018ee <iput+0x12e>
      if(a[j])
801018df:	8b 16                	mov    (%esi),%edx
801018e1:	85 d2                	test   %edx,%edx
801018e3:	74 f3                	je     801018d8 <iput+0x118>
        bfree(ip->dev, a[j]);
801018e5:	8b 03                	mov    (%ebx),%eax
801018e7:	e8 24 fb ff ff       	call   80101410 <bfree>
801018ec:	eb ea                	jmp    801018d8 <iput+0x118>
    brelse(bp);
801018ee:	83 ec 0c             	sub    $0xc,%esp
801018f1:	ff 75 e4             	pushl  -0x1c(%ebp)
801018f4:	8b 7d e0             	mov    -0x20(%ebp),%edi
801018f7:	e8 e4 e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801018fc:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101902:	8b 03                	mov    (%ebx),%eax
80101904:	e8 07 fb ff ff       	call   80101410 <bfree>
    ip->addrs[NDIRECT] = 0;
80101909:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101910:	00 00 00 
80101913:	83 c4 10             	add    $0x10,%esp
80101916:	e9 62 ff ff ff       	jmp    8010187d <iput+0xbd>
8010191b:	90                   	nop
8010191c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101920 <iunlockput>:
{
80101920:	55                   	push   %ebp
80101921:	89 e5                	mov    %esp,%ebp
80101923:	53                   	push   %ebx
80101924:	83 ec 10             	sub    $0x10,%esp
80101927:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010192a:	53                   	push   %ebx
8010192b:	e8 40 fe ff ff       	call   80101770 <iunlock>
  iput(ip);
80101930:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101933:	83 c4 10             	add    $0x10,%esp
}
80101936:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101939:	c9                   	leave  
  iput(ip);
8010193a:	e9 81 fe ff ff       	jmp    801017c0 <iput>
8010193f:	90                   	nop

80101940 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101940:	55                   	push   %ebp
80101941:	89 e5                	mov    %esp,%ebp
80101943:	8b 55 08             	mov    0x8(%ebp),%edx
80101946:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101949:	8b 0a                	mov    (%edx),%ecx
8010194b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010194e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101951:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101954:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101958:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010195b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010195f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101963:	8b 52 58             	mov    0x58(%edx),%edx
80101966:	89 50 10             	mov    %edx,0x10(%eax)
}
80101969:	5d                   	pop    %ebp
8010196a:	c3                   	ret    
8010196b:	90                   	nop
8010196c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101970 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101970:	55                   	push   %ebp
80101971:	89 e5                	mov    %esp,%ebp
80101973:	57                   	push   %edi
80101974:	56                   	push   %esi
80101975:	53                   	push   %ebx
80101976:	83 ec 1c             	sub    $0x1c,%esp
80101979:	8b 45 08             	mov    0x8(%ebp),%eax
8010197c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010197f:	8b 7d 14             	mov    0x14(%ebp),%edi
80101982:	89 45 d8             	mov    %eax,-0x28(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101985:	0f b7 40 50          	movzwl 0x50(%eax),%eax
{
80101989:	89 75 e0             	mov    %esi,-0x20(%ebp)
8010198c:	89 7d e4             	mov    %edi,-0x1c(%ebp)
8010198f:	8b 75 10             	mov    0x10(%ebp),%esi
  if(ip->type == T_DEV){
80101992:	66 83 f8 03          	cmp    $0x3,%ax
80101996:	0f 84 b4 00 00 00    	je     80101a50 <readi+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off) // if the offset is bigger than the file size or n is negetive
8010199c:	8b 7d d8             	mov    -0x28(%ebp),%edi
8010199f:	8b 57 58             	mov    0x58(%edi),%edx
801019a2:	39 f2                	cmp    %esi,%edx
801019a4:	0f 82 e9 00 00 00    	jb     80101a93 <readi+0x123>
801019aa:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801019ad:	89 fb                	mov    %edi,%ebx
801019af:	01 f3                	add    %esi,%ebx
801019b1:	0f 82 dc 00 00 00    	jb     80101a93 <readi+0x123>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;//if the read length beyond the file length
801019b7:	89 d1                	mov    %edx,%ecx
801019b9:	29 f1                	sub    %esi,%ecx
801019bb:	39 da                	cmp    %ebx,%edx
801019bd:	0f 43 cf             	cmovae %edi,%ecx
  
  if(ip->type == T_SMALLFILE){
801019c0:	66 83 f8 04          	cmp    $0x4,%ax
    n = ip->size - off;//if the read length beyond the file length
801019c4:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(ip->type == T_SMALLFILE){
801019c7:	0f 84 ab 00 00 00    	je     80101a78 <readi+0x108>
    memmove(dst, (char*)(ip->addrs) + off, n);
  } else {
    for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801019d0:	31 ff                	xor    %edi,%edi
801019d2:	85 c0                	test   %eax,%eax
801019d4:	74 6c                	je     80101a42 <readi+0xd2>
801019d6:	8d 76 00             	lea    0x0(%esi),%esi
801019d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019e0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801019e3:	89 f2                	mov    %esi,%edx
801019e5:	c1 ea 09             	shr    $0x9,%edx
801019e8:	89 d8                	mov    %ebx,%eax
801019ea:	e8 01 f9 ff ff       	call   801012f0 <bmap>
801019ef:	83 ec 08             	sub    $0x8,%esp
801019f2:	50                   	push   %eax
801019f3:	ff 33                	pushl  (%ebx)
801019f5:	e8 d6 e6 ff ff       	call   801000d0 <bread>
      m = min(n - tot, BSIZE - off%BSIZE);
801019fa:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
      bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019fd:	89 c2                	mov    %eax,%edx
      m = min(n - tot, BSIZE - off%BSIZE);
801019ff:	89 f0                	mov    %esi,%eax
80101a01:	25 ff 01 00 00       	and    $0x1ff,%eax
80101a06:	b9 00 02 00 00       	mov    $0x200,%ecx
80101a0b:	83 c4 0c             	add    $0xc,%esp
80101a0e:	29 c1                	sub    %eax,%ecx
      memmove(dst, bp->data + off%BSIZE, m);
80101a10:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
80101a14:	89 55 dc             	mov    %edx,-0x24(%ebp)
      m = min(n - tot, BSIZE - off%BSIZE);
80101a17:	29 fb                	sub    %edi,%ebx
80101a19:	39 d9                	cmp    %ebx,%ecx
80101a1b:	0f 46 d9             	cmovbe %ecx,%ebx
      memmove(dst, bp->data + off%BSIZE, m);
80101a1e:	53                   	push   %ebx
80101a1f:	50                   	push   %eax
    for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a20:	01 df                	add    %ebx,%edi
      memmove(dst, bp->data + off%BSIZE, m);
80101a22:	ff 75 e0             	pushl  -0x20(%ebp)
    for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a25:	01 de                	add    %ebx,%esi
      memmove(dst, bp->data + off%BSIZE, m);
80101a27:	e8 84 2b 00 00       	call   801045b0 <memmove>
      brelse(bp);
80101a2c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a2f:	89 14 24             	mov    %edx,(%esp)
80101a32:	e8 a9 e7 ff ff       	call   801001e0 <brelse>
    for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a37:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a3a:	83 c4 10             	add    $0x10,%esp
80101a3d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a40:	77 9e                	ja     801019e0 <readi+0x70>
    }
  }
  return n;
80101a42:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a45:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a48:	5b                   	pop    %ebx
80101a49:	5e                   	pop    %esi
80101a4a:	5f                   	pop    %edi
80101a4b:	5d                   	pop    %ebp
80101a4c:	c3                   	ret    
80101a4d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a50:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a53:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101a57:	66 83 f8 09          	cmp    $0x9,%ax
80101a5b:	77 36                	ja     80101a93 <readi+0x123>
80101a5d:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
80101a64:	85 c0                	test   %eax,%eax
80101a66:	74 2b                	je     80101a93 <readi+0x123>
    return devsw[ip->major].read(ip, dst, n);
80101a68:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101a6b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a6e:	5b                   	pop    %ebx
80101a6f:	5e                   	pop    %esi
80101a70:	5f                   	pop    %edi
80101a71:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101a72:	ff e0                	jmp    *%eax
80101a74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memmove(dst, (char*)(ip->addrs) + off, n);
80101a78:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a7b:	83 ec 04             	sub    $0x4,%esp
80101a7e:	ff 75 e4             	pushl  -0x1c(%ebp)
80101a81:	8d 44 30 5c          	lea    0x5c(%eax,%esi,1),%eax
80101a85:	50                   	push   %eax
80101a86:	ff 75 e0             	pushl  -0x20(%ebp)
80101a89:	e8 22 2b 00 00       	call   801045b0 <memmove>
80101a8e:	83 c4 10             	add    $0x10,%esp
80101a91:	eb af                	jmp    80101a42 <readi+0xd2>
      return -1;
80101a93:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a98:	eb ab                	jmp    80101a45 <readi+0xd5>
80101a9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101aa0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101aa0:	55                   	push   %ebp
80101aa1:	89 e5                	mov    %esp,%ebp
80101aa3:	57                   	push   %edi
80101aa4:	56                   	push   %esi
80101aa5:	53                   	push   %ebx
80101aa6:	83 ec 1c             	sub    $0x1c,%esp
80101aa9:	8b 45 08             	mov    0x8(%ebp),%eax
80101aac:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101aaf:	8b 75 14             	mov    0x14(%ebp),%esi
80101ab2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ab5:	0f b7 40 50          	movzwl 0x50(%eax),%eax
{
80101ab9:	89 7d dc             	mov    %edi,-0x24(%ebp)
80101abc:	89 75 e0             	mov    %esi,-0x20(%ebp)
80101abf:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(ip->type == T_DEV){
80101ac2:	66 83 f8 03          	cmp    $0x3,%ax
80101ac6:	0f 84 14 01 00 00    	je     80101be0 <writei+0x140>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101acc:	8b 75 d8             	mov    -0x28(%ebp),%esi
80101acf:	39 7e 58             	cmp    %edi,0x58(%esi)
80101ad2:	0f 82 4d 01 00 00    	jb     80101c25 <writei+0x185>
80101ad8:	8b 75 e0             	mov    -0x20(%ebp),%esi
80101adb:	89 f1                	mov    %esi,%ecx
80101add:	01 f9                	add    %edi,%ecx
80101adf:	0f 82 40 01 00 00    	jb     80101c25 <writei+0x185>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    n = MAXFILE*BSIZE - off;
80101ae5:	ba 00 18 01 00       	mov    $0x11800,%edx
80101aea:	29 fa                	sub    %edi,%edx
80101aec:	81 f9 00 18 01 00    	cmp    $0x11800,%ecx
80101af2:	0f 46 d6             	cmovbe %esi,%edx
  if(ip->type == T_SMALLFILE && off + n > (NDIRECT + 1) * sizeof(uint))
80101af5:	66 83 f8 04          	cmp    $0x4,%ax
    n = MAXFILE*BSIZE - off;
80101af9:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(ip->type == T_SMALLFILE && off + n > (NDIRECT + 1) * sizeof(uint))
80101afc:	0f 84 96 00 00 00    	je     80101b98 <writei+0xf8>
  
  if(ip->type == T_SMALLFILE){
    memmove((char*)(ip->addrs + off), src, n);
    off += n;
  }else{
    for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b02:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101b05:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101b0c:	85 c0                	test   %eax,%eax
80101b0e:	0f 84 bc 00 00 00    	je     80101bd0 <writei+0x130>
80101b14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b18:	8b 75 d8             	mov    -0x28(%ebp),%esi
80101b1b:	89 fa                	mov    %edi,%edx
80101b1d:	c1 ea 09             	shr    $0x9,%edx
80101b20:	89 f0                	mov    %esi,%eax
80101b22:	e8 c9 f7 ff ff       	call   801012f0 <bmap>
80101b27:	83 ec 08             	sub    $0x8,%esp
80101b2a:	50                   	push   %eax
80101b2b:	ff 36                	pushl  (%esi)
80101b2d:	e8 9e e5 ff ff       	call   801000d0 <bread>
      m = min(n - tot, BSIZE - off%BSIZE);
80101b32:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101b35:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
      bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b38:	89 c6                	mov    %eax,%esi
      m = min(n - tot, BSIZE - off%BSIZE);
80101b3a:	89 f8                	mov    %edi,%eax
80101b3c:	b9 00 02 00 00       	mov    $0x200,%ecx
80101b41:	83 c4 0c             	add    $0xc,%esp
80101b44:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b49:	29 c1                	sub    %eax,%ecx
      memmove(bp->data + off%BSIZE, src, m);
80101b4b:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
      m = min(n - tot, BSIZE - off%BSIZE);
80101b4f:	39 d9                	cmp    %ebx,%ecx
80101b51:	0f 46 d9             	cmovbe %ecx,%ebx
      memmove(bp->data + off%BSIZE, src, m);
80101b54:	53                   	push   %ebx
80101b55:	ff 75 dc             	pushl  -0x24(%ebp)
    for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b58:	01 df                	add    %ebx,%edi
      memmove(bp->data + off%BSIZE, src, m);
80101b5a:	50                   	push   %eax
80101b5b:	e8 50 2a 00 00       	call   801045b0 <memmove>
      log_write(bp);
80101b60:	89 34 24             	mov    %esi,(%esp)
80101b63:	e8 b8 12 00 00       	call   80102e20 <log_write>
      brelse(bp);
80101b68:	89 34 24             	mov    %esi,(%esp)
80101b6b:	e8 70 e6 ff ff       	call   801001e0 <brelse>
    for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b70:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b73:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b76:	83 c4 10             	add    $0x10,%esp
80101b79:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101b7c:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101b7f:	77 97                	ja     80101b18 <writei+0x78>
    }
  }
  
  if(n > 0 && off > ip->size){
80101b81:	8b 55 d8             	mov    -0x28(%ebp),%edx
80101b84:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101b87:	39 7a 58             	cmp    %edi,0x58(%edx)
80101b8a:	72 7c                	jb     80101c08 <writei+0x168>
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
80101b8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b8f:	5b                   	pop    %ebx
80101b90:	5e                   	pop    %esi
80101b91:	5f                   	pop    %edi
80101b92:	5d                   	pop    %ebp
80101b93:	c3                   	ret    
80101b94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(ip->type == T_SMALLFILE && off + n > (NDIRECT + 1) * sizeof(uint))
80101b98:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101b9b:	8d 1c 38             	lea    (%eax,%edi,1),%ebx
80101b9e:	83 fb 34             	cmp    $0x34,%ebx
80101ba1:	76 0f                	jbe    80101bb2 <writei+0x112>
    n = (NDIRECT + 1) * sizeof(uint) - off;
80101ba3:	b8 34 00 00 00       	mov    $0x34,%eax
80101ba8:	bb 34 00 00 00       	mov    $0x34,%ebx
80101bad:	29 f8                	sub    %edi,%eax
80101baf:	89 45 e0             	mov    %eax,-0x20(%ebp)
    memmove((char*)(ip->addrs + off), src, n);
80101bb2:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101bb5:	8b 75 e0             	mov    -0x20(%ebp),%esi
80101bb8:	83 ec 04             	sub    $0x4,%esp
80101bbb:	8d 44 b8 5c          	lea    0x5c(%eax,%edi,4),%eax
80101bbf:	56                   	push   %esi
80101bc0:	ff 75 dc             	pushl  -0x24(%ebp)
80101bc3:	50                   	push   %eax
80101bc4:	e8 e7 29 00 00       	call   801045b0 <memmove>
  if(n > 0 && off > ip->size){
80101bc9:	83 c4 10             	add    $0x10,%esp
80101bcc:	85 f6                	test   %esi,%esi
80101bce:	75 5f                	jne    80101c2f <writei+0x18f>
}
80101bd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bd3:	31 c0                	xor    %eax,%eax
80101bd5:	5b                   	pop    %ebx
80101bd6:	5e                   	pop    %esi
80101bd7:	5f                   	pop    %edi
80101bd8:	5d                   	pop    %ebp
80101bd9:	c3                   	ret    
80101bda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101be0:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101be3:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101be7:	66 83 f8 09          	cmp    $0x9,%ax
80101beb:	77 38                	ja     80101c25 <writei+0x185>
80101bed:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
80101bf4:	85 c0                	test   %eax,%eax
80101bf6:	74 2d                	je     80101c25 <writei+0x185>
    return devsw[ip->major].write(ip, src, n);
80101bf8:	89 75 10             	mov    %esi,0x10(%ebp)
}
80101bfb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bfe:	5b                   	pop    %ebx
80101bff:	5e                   	pop    %esi
80101c00:	5f                   	pop    %edi
80101c01:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101c02:	ff e0                	jmp    *%eax
80101c04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iupdate(ip);
80101c08:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101c0b:	89 7a 58             	mov    %edi,0x58(%edx)
80101c0e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    iupdate(ip);
80101c11:	52                   	push   %edx
80101c12:	e8 c9 f9 ff ff       	call   801015e0 <iupdate>
  return n;
80101c17:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    iupdate(ip);
80101c1a:	83 c4 10             	add    $0x10,%esp
}
80101c1d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c20:	5b                   	pop    %ebx
80101c21:	5e                   	pop    %esi
80101c22:	5f                   	pop    %edi
80101c23:	5d                   	pop    %ebp
80101c24:	c3                   	ret    
      return -1;
80101c25:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c2a:	e9 5d ff ff ff       	jmp    80101b8c <writei+0xec>
    off += n;
80101c2f:	89 df                	mov    %ebx,%edi
80101c31:	e9 4b ff ff ff       	jmp    80101b81 <writei+0xe1>
80101c36:	8d 76 00             	lea    0x0(%esi),%esi
80101c39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101c40 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101c40:	55                   	push   %ebp
80101c41:	89 e5                	mov    %esp,%ebp
80101c43:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101c46:	6a 0e                	push   $0xe
80101c48:	ff 75 0c             	pushl  0xc(%ebp)
80101c4b:	ff 75 08             	pushl  0x8(%ebp)
80101c4e:	e8 cd 29 00 00       	call   80104620 <strncmp>
}
80101c53:	c9                   	leave  
80101c54:	c3                   	ret    
80101c55:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101c59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101c60 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101c60:	55                   	push   %ebp
80101c61:	89 e5                	mov    %esp,%ebp
80101c63:	57                   	push   %edi
80101c64:	56                   	push   %esi
80101c65:	53                   	push   %ebx
80101c66:	83 ec 1c             	sub    $0x1c,%esp
80101c69:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101c6c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101c71:	0f 85 85 00 00 00    	jne    80101cfc <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101c77:	8b 53 58             	mov    0x58(%ebx),%edx
80101c7a:	31 ff                	xor    %edi,%edi
80101c7c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101c7f:	85 d2                	test   %edx,%edx
80101c81:	74 3e                	je     80101cc1 <dirlookup+0x61>
80101c83:	90                   	nop
80101c84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101c88:	6a 10                	push   $0x10
80101c8a:	57                   	push   %edi
80101c8b:	56                   	push   %esi
80101c8c:	53                   	push   %ebx
80101c8d:	e8 de fc ff ff       	call   80101970 <readi>
80101c92:	83 c4 10             	add    $0x10,%esp
80101c95:	83 f8 10             	cmp    $0x10,%eax
80101c98:	75 55                	jne    80101cef <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101c9a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101c9f:	74 18                	je     80101cb9 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101ca1:	8d 45 da             	lea    -0x26(%ebp),%eax
80101ca4:	83 ec 04             	sub    $0x4,%esp
80101ca7:	6a 0e                	push   $0xe
80101ca9:	50                   	push   %eax
80101caa:	ff 75 0c             	pushl  0xc(%ebp)
80101cad:	e8 6e 29 00 00       	call   80104620 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101cb2:	83 c4 10             	add    $0x10,%esp
80101cb5:	85 c0                	test   %eax,%eax
80101cb7:	74 17                	je     80101cd0 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101cb9:	83 c7 10             	add    $0x10,%edi
80101cbc:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101cbf:	72 c7                	jb     80101c88 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101cc1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101cc4:	31 c0                	xor    %eax,%eax
}
80101cc6:	5b                   	pop    %ebx
80101cc7:	5e                   	pop    %esi
80101cc8:	5f                   	pop    %edi
80101cc9:	5d                   	pop    %ebp
80101cca:	c3                   	ret    
80101ccb:	90                   	nop
80101ccc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(poff)
80101cd0:	8b 45 10             	mov    0x10(%ebp),%eax
80101cd3:	85 c0                	test   %eax,%eax
80101cd5:	74 05                	je     80101cdc <dirlookup+0x7c>
        *poff = off;
80101cd7:	8b 45 10             	mov    0x10(%ebp),%eax
80101cda:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101cdc:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101ce0:	8b 03                	mov    (%ebx),%eax
80101ce2:	e8 39 f5 ff ff       	call   80101220 <iget>
}
80101ce7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101cea:	5b                   	pop    %ebx
80101ceb:	5e                   	pop    %esi
80101cec:	5f                   	pop    %edi
80101ced:	5d                   	pop    %ebp
80101cee:	c3                   	ret    
      panic("dirlookup read");
80101cef:	83 ec 0c             	sub    $0xc,%esp
80101cf2:	68 f9 70 10 80       	push   $0x801070f9
80101cf7:	e8 94 e6 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101cfc:	83 ec 0c             	sub    $0xc,%esp
80101cff:	68 e7 70 10 80       	push   $0x801070e7
80101d04:	e8 87 e6 ff ff       	call   80100390 <panic>
80101d09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101d10 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101d10:	55                   	push   %ebp
80101d11:	89 e5                	mov    %esp,%ebp
80101d13:	57                   	push   %edi
80101d14:	56                   	push   %esi
80101d15:	53                   	push   %ebx
80101d16:	89 cf                	mov    %ecx,%edi
80101d18:	89 c3                	mov    %eax,%ebx
80101d1a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101d1d:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101d20:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101d23:	0f 84 67 01 00 00    	je     80101e90 <namex+0x180>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101d29:	e8 62 1b 00 00       	call   80103890 <myproc>
  acquire(&icache.lock);
80101d2e:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101d31:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101d34:	68 e0 09 11 80       	push   $0x801109e0
80101d39:	e8 b2 26 00 00       	call   801043f0 <acquire>
  ip->ref++;
80101d3e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101d42:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101d49:	e8 62 27 00 00       	call   801044b0 <release>
80101d4e:	83 c4 10             	add    $0x10,%esp
80101d51:	eb 08                	jmp    80101d5b <namex+0x4b>
80101d53:	90                   	nop
80101d54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101d58:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101d5b:	0f b6 03             	movzbl (%ebx),%eax
80101d5e:	3c 2f                	cmp    $0x2f,%al
80101d60:	74 f6                	je     80101d58 <namex+0x48>
  if(*path == 0)
80101d62:	84 c0                	test   %al,%al
80101d64:	0f 84 ee 00 00 00    	je     80101e58 <namex+0x148>
  while(*path != '/' && *path != 0)
80101d6a:	0f b6 03             	movzbl (%ebx),%eax
80101d6d:	3c 2f                	cmp    $0x2f,%al
80101d6f:	0f 84 b3 00 00 00    	je     80101e28 <namex+0x118>
80101d75:	84 c0                	test   %al,%al
80101d77:	89 da                	mov    %ebx,%edx
80101d79:	75 09                	jne    80101d84 <namex+0x74>
80101d7b:	e9 a8 00 00 00       	jmp    80101e28 <namex+0x118>
80101d80:	84 c0                	test   %al,%al
80101d82:	74 0a                	je     80101d8e <namex+0x7e>
    path++;
80101d84:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101d87:	0f b6 02             	movzbl (%edx),%eax
80101d8a:	3c 2f                	cmp    $0x2f,%al
80101d8c:	75 f2                	jne    80101d80 <namex+0x70>
80101d8e:	89 d1                	mov    %edx,%ecx
80101d90:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101d92:	83 f9 0d             	cmp    $0xd,%ecx
80101d95:	0f 8e 91 00 00 00    	jle    80101e2c <namex+0x11c>
    memmove(name, s, DIRSIZ);
80101d9b:	83 ec 04             	sub    $0x4,%esp
80101d9e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101da1:	6a 0e                	push   $0xe
80101da3:	53                   	push   %ebx
80101da4:	57                   	push   %edi
80101da5:	e8 06 28 00 00       	call   801045b0 <memmove>
    path++;
80101daa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    memmove(name, s, DIRSIZ);
80101dad:	83 c4 10             	add    $0x10,%esp
    path++;
80101db0:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101db2:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101db5:	75 11                	jne    80101dc8 <namex+0xb8>
80101db7:	89 f6                	mov    %esi,%esi
80101db9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101dc0:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101dc3:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101dc6:	74 f8                	je     80101dc0 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101dc8:	83 ec 0c             	sub    $0xc,%esp
80101dcb:	56                   	push   %esi
80101dcc:	e8 bf f8 ff ff       	call   80101690 <ilock>
    if(ip->type != T_DIR){
80101dd1:	83 c4 10             	add    $0x10,%esp
80101dd4:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101dd9:	0f 85 91 00 00 00    	jne    80101e70 <namex+0x160>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101ddf:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101de2:	85 d2                	test   %edx,%edx
80101de4:	74 09                	je     80101def <namex+0xdf>
80101de6:	80 3b 00             	cmpb   $0x0,(%ebx)
80101de9:	0f 84 b7 00 00 00    	je     80101ea6 <namex+0x196>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101def:	83 ec 04             	sub    $0x4,%esp
80101df2:	6a 00                	push   $0x0
80101df4:	57                   	push   %edi
80101df5:	56                   	push   %esi
80101df6:	e8 65 fe ff ff       	call   80101c60 <dirlookup>
80101dfb:	83 c4 10             	add    $0x10,%esp
80101dfe:	85 c0                	test   %eax,%eax
80101e00:	74 6e                	je     80101e70 <namex+0x160>
  iunlock(ip);
80101e02:	83 ec 0c             	sub    $0xc,%esp
80101e05:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101e08:	56                   	push   %esi
80101e09:	e8 62 f9 ff ff       	call   80101770 <iunlock>
  iput(ip);
80101e0e:	89 34 24             	mov    %esi,(%esp)
80101e11:	e8 aa f9 ff ff       	call   801017c0 <iput>
80101e16:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101e19:	83 c4 10             	add    $0x10,%esp
80101e1c:	89 c6                	mov    %eax,%esi
80101e1e:	e9 38 ff ff ff       	jmp    80101d5b <namex+0x4b>
80101e23:	90                   	nop
80101e24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path != '/' && *path != 0)
80101e28:	89 da                	mov    %ebx,%edx
80101e2a:	31 c9                	xor    %ecx,%ecx
    memmove(name, s, len);
80101e2c:	83 ec 04             	sub    $0x4,%esp
80101e2f:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101e32:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101e35:	51                   	push   %ecx
80101e36:	53                   	push   %ebx
80101e37:	57                   	push   %edi
80101e38:	e8 73 27 00 00       	call   801045b0 <memmove>
    name[len] = 0;
80101e3d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101e40:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101e43:	83 c4 10             	add    $0x10,%esp
80101e46:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101e4a:	89 d3                	mov    %edx,%ebx
80101e4c:	e9 61 ff ff ff       	jmp    80101db2 <namex+0xa2>
80101e51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101e58:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101e5b:	85 c0                	test   %eax,%eax
80101e5d:	75 5d                	jne    80101ebc <namex+0x1ac>
    iput(ip);
    return 0;
  }
  return ip;
}
80101e5f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e62:	89 f0                	mov    %esi,%eax
80101e64:	5b                   	pop    %ebx
80101e65:	5e                   	pop    %esi
80101e66:	5f                   	pop    %edi
80101e67:	5d                   	pop    %ebp
80101e68:	c3                   	ret    
80101e69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101e70:	83 ec 0c             	sub    $0xc,%esp
80101e73:	56                   	push   %esi
80101e74:	e8 f7 f8 ff ff       	call   80101770 <iunlock>
  iput(ip);
80101e79:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101e7c:	31 f6                	xor    %esi,%esi
  iput(ip);
80101e7e:	e8 3d f9 ff ff       	call   801017c0 <iput>
      return 0;
80101e83:	83 c4 10             	add    $0x10,%esp
}
80101e86:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e89:	89 f0                	mov    %esi,%eax
80101e8b:	5b                   	pop    %ebx
80101e8c:	5e                   	pop    %esi
80101e8d:	5f                   	pop    %edi
80101e8e:	5d                   	pop    %ebp
80101e8f:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80101e90:	ba 01 00 00 00       	mov    $0x1,%edx
80101e95:	b8 01 00 00 00       	mov    $0x1,%eax
80101e9a:	e8 81 f3 ff ff       	call   80101220 <iget>
80101e9f:	89 c6                	mov    %eax,%esi
80101ea1:	e9 b5 fe ff ff       	jmp    80101d5b <namex+0x4b>
      iunlock(ip);
80101ea6:	83 ec 0c             	sub    $0xc,%esp
80101ea9:	56                   	push   %esi
80101eaa:	e8 c1 f8 ff ff       	call   80101770 <iunlock>
      return ip;
80101eaf:	83 c4 10             	add    $0x10,%esp
}
80101eb2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101eb5:	89 f0                	mov    %esi,%eax
80101eb7:	5b                   	pop    %ebx
80101eb8:	5e                   	pop    %esi
80101eb9:	5f                   	pop    %edi
80101eba:	5d                   	pop    %ebp
80101ebb:	c3                   	ret    
    iput(ip);
80101ebc:	83 ec 0c             	sub    $0xc,%esp
80101ebf:	56                   	push   %esi
    return 0;
80101ec0:	31 f6                	xor    %esi,%esi
    iput(ip);
80101ec2:	e8 f9 f8 ff ff       	call   801017c0 <iput>
    return 0;
80101ec7:	83 c4 10             	add    $0x10,%esp
80101eca:	eb 93                	jmp    80101e5f <namex+0x14f>
80101ecc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101ed0 <dirlink>:
{
80101ed0:	55                   	push   %ebp
80101ed1:	89 e5                	mov    %esp,%ebp
80101ed3:	57                   	push   %edi
80101ed4:	56                   	push   %esi
80101ed5:	53                   	push   %ebx
80101ed6:	83 ec 20             	sub    $0x20,%esp
80101ed9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101edc:	6a 00                	push   $0x0
80101ede:	ff 75 0c             	pushl  0xc(%ebp)
80101ee1:	53                   	push   %ebx
80101ee2:	e8 79 fd ff ff       	call   80101c60 <dirlookup>
80101ee7:	83 c4 10             	add    $0x10,%esp
80101eea:	85 c0                	test   %eax,%eax
80101eec:	75 67                	jne    80101f55 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101eee:	8b 7b 58             	mov    0x58(%ebx),%edi
80101ef1:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101ef4:	85 ff                	test   %edi,%edi
80101ef6:	74 29                	je     80101f21 <dirlink+0x51>
80101ef8:	31 ff                	xor    %edi,%edi
80101efa:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101efd:	eb 09                	jmp    80101f08 <dirlink+0x38>
80101eff:	90                   	nop
80101f00:	83 c7 10             	add    $0x10,%edi
80101f03:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101f06:	73 19                	jae    80101f21 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f08:	6a 10                	push   $0x10
80101f0a:	57                   	push   %edi
80101f0b:	56                   	push   %esi
80101f0c:	53                   	push   %ebx
80101f0d:	e8 5e fa ff ff       	call   80101970 <readi>
80101f12:	83 c4 10             	add    $0x10,%esp
80101f15:	83 f8 10             	cmp    $0x10,%eax
80101f18:	75 4e                	jne    80101f68 <dirlink+0x98>
    if(de.inum == 0)
80101f1a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101f1f:	75 df                	jne    80101f00 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80101f21:	8d 45 da             	lea    -0x26(%ebp),%eax
80101f24:	83 ec 04             	sub    $0x4,%esp
80101f27:	6a 0e                	push   $0xe
80101f29:	ff 75 0c             	pushl  0xc(%ebp)
80101f2c:	50                   	push   %eax
80101f2d:	e8 4e 27 00 00       	call   80104680 <strncpy>
  de.inum = inum;
80101f32:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f35:	6a 10                	push   $0x10
80101f37:	57                   	push   %edi
80101f38:	56                   	push   %esi
80101f39:	53                   	push   %ebx
  de.inum = inum;
80101f3a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f3e:	e8 5d fb ff ff       	call   80101aa0 <writei>
80101f43:	83 c4 20             	add    $0x20,%esp
80101f46:	83 f8 10             	cmp    $0x10,%eax
80101f49:	75 2a                	jne    80101f75 <dirlink+0xa5>
  return 0;
80101f4b:	31 c0                	xor    %eax,%eax
}
80101f4d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f50:	5b                   	pop    %ebx
80101f51:	5e                   	pop    %esi
80101f52:	5f                   	pop    %edi
80101f53:	5d                   	pop    %ebp
80101f54:	c3                   	ret    
    iput(ip);
80101f55:	83 ec 0c             	sub    $0xc,%esp
80101f58:	50                   	push   %eax
80101f59:	e8 62 f8 ff ff       	call   801017c0 <iput>
    return -1;
80101f5e:	83 c4 10             	add    $0x10,%esp
80101f61:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f66:	eb e5                	jmp    80101f4d <dirlink+0x7d>
      panic("dirlink read");
80101f68:	83 ec 0c             	sub    $0xc,%esp
80101f6b:	68 08 71 10 80       	push   $0x80107108
80101f70:	e8 1b e4 ff ff       	call   80100390 <panic>
    panic("dirlink");
80101f75:	83 ec 0c             	sub    $0xc,%esp
80101f78:	68 fe 76 10 80       	push   $0x801076fe
80101f7d:	e8 0e e4 ff ff       	call   80100390 <panic>
80101f82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f90 <namei>:

struct inode*
namei(char *path)
{
80101f90:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101f91:	31 d2                	xor    %edx,%edx
{
80101f93:	89 e5                	mov    %esp,%ebp
80101f95:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80101f98:	8b 45 08             	mov    0x8(%ebp),%eax
80101f9b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101f9e:	e8 6d fd ff ff       	call   80101d10 <namex>
}
80101fa3:	c9                   	leave  
80101fa4:	c3                   	ret    
80101fa5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101fa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101fb0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101fb0:	55                   	push   %ebp
  return namex(path, 1, name);
80101fb1:	ba 01 00 00 00       	mov    $0x1,%edx
{
80101fb6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101fb8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101fbb:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101fbe:	5d                   	pop    %ebp
  return namex(path, 1, name);
80101fbf:	e9 4c fd ff ff       	jmp    80101d10 <namex>
80101fc4:	66 90                	xchg   %ax,%ax
80101fc6:	66 90                	xchg   %ax,%ax
80101fc8:	66 90                	xchg   %ax,%ax
80101fca:	66 90                	xchg   %ax,%ax
80101fcc:	66 90                	xchg   %ax,%ax
80101fce:	66 90                	xchg   %ax,%ax

80101fd0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101fd0:	55                   	push   %ebp
80101fd1:	89 e5                	mov    %esp,%ebp
80101fd3:	57                   	push   %edi
80101fd4:	56                   	push   %esi
80101fd5:	53                   	push   %ebx
80101fd6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80101fd9:	85 c0                	test   %eax,%eax
80101fdb:	0f 84 b4 00 00 00    	je     80102095 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101fe1:	8b 58 08             	mov    0x8(%eax),%ebx
80101fe4:	89 c6                	mov    %eax,%esi
80101fe6:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80101fec:	0f 87 96 00 00 00    	ja     80102088 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101ff2:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80101ff7:	89 f6                	mov    %esi,%esi
80101ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102000:	89 ca                	mov    %ecx,%edx
80102002:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102003:	83 e0 c0             	and    $0xffffffc0,%eax
80102006:	3c 40                	cmp    $0x40,%al
80102008:	75 f6                	jne    80102000 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010200a:	31 ff                	xor    %edi,%edi
8010200c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102011:	89 f8                	mov    %edi,%eax
80102013:	ee                   	out    %al,(%dx)
80102014:	b8 01 00 00 00       	mov    $0x1,%eax
80102019:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010201e:	ee                   	out    %al,(%dx)
8010201f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102024:	89 d8                	mov    %ebx,%eax
80102026:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102027:	89 d8                	mov    %ebx,%eax
80102029:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010202e:	c1 f8 08             	sar    $0x8,%eax
80102031:	ee                   	out    %al,(%dx)
80102032:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102037:	89 f8                	mov    %edi,%eax
80102039:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010203a:	0f b6 46 04          	movzbl 0x4(%esi),%eax
8010203e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102043:	c1 e0 04             	shl    $0x4,%eax
80102046:	83 e0 10             	and    $0x10,%eax
80102049:	83 c8 e0             	or     $0xffffffe0,%eax
8010204c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010204d:	f6 06 04             	testb  $0x4,(%esi)
80102050:	75 16                	jne    80102068 <idestart+0x98>
80102052:	b8 20 00 00 00       	mov    $0x20,%eax
80102057:	89 ca                	mov    %ecx,%edx
80102059:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010205a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010205d:	5b                   	pop    %ebx
8010205e:	5e                   	pop    %esi
8010205f:	5f                   	pop    %edi
80102060:	5d                   	pop    %ebp
80102061:	c3                   	ret    
80102062:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102068:	b8 30 00 00 00       	mov    $0x30,%eax
8010206d:	89 ca                	mov    %ecx,%edx
8010206f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102070:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102075:	83 c6 5c             	add    $0x5c,%esi
80102078:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010207d:	fc                   	cld    
8010207e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102080:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102083:	5b                   	pop    %ebx
80102084:	5e                   	pop    %esi
80102085:	5f                   	pop    %edi
80102086:	5d                   	pop    %ebp
80102087:	c3                   	ret    
    panic("incorrect blockno");
80102088:	83 ec 0c             	sub    $0xc,%esp
8010208b:	68 74 71 10 80       	push   $0x80107174
80102090:	e8 fb e2 ff ff       	call   80100390 <panic>
    panic("idestart");
80102095:	83 ec 0c             	sub    $0xc,%esp
80102098:	68 6b 71 10 80       	push   $0x8010716b
8010209d:	e8 ee e2 ff ff       	call   80100390 <panic>
801020a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801020b0 <ideinit>:
{
801020b0:	55                   	push   %ebp
801020b1:	89 e5                	mov    %esp,%ebp
801020b3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801020b6:	68 86 71 10 80       	push   $0x80107186
801020bb:	68 80 a5 10 80       	push   $0x8010a580
801020c0:	e8 eb 21 00 00       	call   801042b0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801020c5:	58                   	pop    %eax
801020c6:	a1 00 2d 11 80       	mov    0x80112d00,%eax
801020cb:	5a                   	pop    %edx
801020cc:	83 e8 01             	sub    $0x1,%eax
801020cf:	50                   	push   %eax
801020d0:	6a 0e                	push   $0xe
801020d2:	e8 a9 02 00 00       	call   80102380 <ioapicenable>
801020d7:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020da:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020df:	90                   	nop
801020e0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020e1:	83 e0 c0             	and    $0xffffffc0,%eax
801020e4:	3c 40                	cmp    $0x40,%al
801020e6:	75 f8                	jne    801020e0 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801020e8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801020ed:	ba f6 01 00 00       	mov    $0x1f6,%edx
801020f2:	ee                   	out    %al,(%dx)
801020f3:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020f8:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020fd:	eb 06                	jmp    80102105 <ideinit+0x55>
801020ff:	90                   	nop
  for(i=0; i<1000; i++){
80102100:	83 e9 01             	sub    $0x1,%ecx
80102103:	74 0f                	je     80102114 <ideinit+0x64>
80102105:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102106:	84 c0                	test   %al,%al
80102108:	74 f6                	je     80102100 <ideinit+0x50>
      havedisk1 = 1;
8010210a:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80102111:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102114:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102119:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010211e:	ee                   	out    %al,(%dx)
}
8010211f:	c9                   	leave  
80102120:	c3                   	ret    
80102121:	eb 0d                	jmp    80102130 <ideintr>
80102123:	90                   	nop
80102124:	90                   	nop
80102125:	90                   	nop
80102126:	90                   	nop
80102127:	90                   	nop
80102128:	90                   	nop
80102129:	90                   	nop
8010212a:	90                   	nop
8010212b:	90                   	nop
8010212c:	90                   	nop
8010212d:	90                   	nop
8010212e:	90                   	nop
8010212f:	90                   	nop

80102130 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102130:	55                   	push   %ebp
80102131:	89 e5                	mov    %esp,%ebp
80102133:	57                   	push   %edi
80102134:	56                   	push   %esi
80102135:	53                   	push   %ebx
80102136:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102139:	68 80 a5 10 80       	push   $0x8010a580
8010213e:	e8 ad 22 00 00       	call   801043f0 <acquire>

  if((b = idequeue) == 0){
80102143:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
80102149:	83 c4 10             	add    $0x10,%esp
8010214c:	85 db                	test   %ebx,%ebx
8010214e:	74 67                	je     801021b7 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102150:	8b 43 58             	mov    0x58(%ebx),%eax
80102153:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102158:	8b 3b                	mov    (%ebx),%edi
8010215a:	f7 c7 04 00 00 00    	test   $0x4,%edi
80102160:	75 31                	jne    80102193 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102162:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102167:	89 f6                	mov    %esi,%esi
80102169:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102170:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102171:	89 c6                	mov    %eax,%esi
80102173:	83 e6 c0             	and    $0xffffffc0,%esi
80102176:	89 f1                	mov    %esi,%ecx
80102178:	80 f9 40             	cmp    $0x40,%cl
8010217b:	75 f3                	jne    80102170 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010217d:	a8 21                	test   $0x21,%al
8010217f:	75 12                	jne    80102193 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
80102181:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102184:	b9 80 00 00 00       	mov    $0x80,%ecx
80102189:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010218e:	fc                   	cld    
8010218f:	f3 6d                	rep insl (%dx),%es:(%edi)
80102191:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102193:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
80102196:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102199:	89 f9                	mov    %edi,%ecx
8010219b:	83 c9 02             	or     $0x2,%ecx
8010219e:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
801021a0:	53                   	push   %ebx
801021a1:	e8 3a 1e 00 00       	call   80103fe0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801021a6:	a1 64 a5 10 80       	mov    0x8010a564,%eax
801021ab:	83 c4 10             	add    $0x10,%esp
801021ae:	85 c0                	test   %eax,%eax
801021b0:	74 05                	je     801021b7 <ideintr+0x87>
    idestart(idequeue);
801021b2:	e8 19 fe ff ff       	call   80101fd0 <idestart>
    release(&idelock);
801021b7:	83 ec 0c             	sub    $0xc,%esp
801021ba:	68 80 a5 10 80       	push   $0x8010a580
801021bf:	e8 ec 22 00 00       	call   801044b0 <release>

  release(&idelock);
}
801021c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021c7:	5b                   	pop    %ebx
801021c8:	5e                   	pop    %esi
801021c9:	5f                   	pop    %edi
801021ca:	5d                   	pop    %ebp
801021cb:	c3                   	ret    
801021cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801021d0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801021d0:	55                   	push   %ebp
801021d1:	89 e5                	mov    %esp,%ebp
801021d3:	53                   	push   %ebx
801021d4:	83 ec 10             	sub    $0x10,%esp
801021d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801021da:	8d 43 0c             	lea    0xc(%ebx),%eax
801021dd:	50                   	push   %eax
801021de:	e8 7d 20 00 00       	call   80104260 <holdingsleep>
801021e3:	83 c4 10             	add    $0x10,%esp
801021e6:	85 c0                	test   %eax,%eax
801021e8:	0f 84 c6 00 00 00    	je     801022b4 <iderw+0xe4>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801021ee:	8b 03                	mov    (%ebx),%eax
801021f0:	83 e0 06             	and    $0x6,%eax
801021f3:	83 f8 02             	cmp    $0x2,%eax
801021f6:	0f 84 ab 00 00 00    	je     801022a7 <iderw+0xd7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801021fc:	8b 53 04             	mov    0x4(%ebx),%edx
801021ff:	85 d2                	test   %edx,%edx
80102201:	74 0d                	je     80102210 <iderw+0x40>
80102203:	a1 60 a5 10 80       	mov    0x8010a560,%eax
80102208:	85 c0                	test   %eax,%eax
8010220a:	0f 84 b1 00 00 00    	je     801022c1 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102210:	83 ec 0c             	sub    $0xc,%esp
80102213:	68 80 a5 10 80       	push   $0x8010a580
80102218:	e8 d3 21 00 00       	call   801043f0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010221d:	8b 15 64 a5 10 80    	mov    0x8010a564,%edx
80102223:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
80102226:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010222d:	85 d2                	test   %edx,%edx
8010222f:	75 09                	jne    8010223a <iderw+0x6a>
80102231:	eb 6d                	jmp    801022a0 <iderw+0xd0>
80102233:	90                   	nop
80102234:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102238:	89 c2                	mov    %eax,%edx
8010223a:	8b 42 58             	mov    0x58(%edx),%eax
8010223d:	85 c0                	test   %eax,%eax
8010223f:	75 f7                	jne    80102238 <iderw+0x68>
80102241:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102244:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102246:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
8010224c:	74 42                	je     80102290 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010224e:	8b 03                	mov    (%ebx),%eax
80102250:	83 e0 06             	and    $0x6,%eax
80102253:	83 f8 02             	cmp    $0x2,%eax
80102256:	74 23                	je     8010227b <iderw+0xab>
80102258:	90                   	nop
80102259:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
80102260:	83 ec 08             	sub    $0x8,%esp
80102263:	68 80 a5 10 80       	push   $0x8010a580
80102268:	53                   	push   %ebx
80102269:	e8 c2 1b 00 00       	call   80103e30 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010226e:	8b 03                	mov    (%ebx),%eax
80102270:	83 c4 10             	add    $0x10,%esp
80102273:	83 e0 06             	and    $0x6,%eax
80102276:	83 f8 02             	cmp    $0x2,%eax
80102279:	75 e5                	jne    80102260 <iderw+0x90>
  }


  release(&idelock);
8010227b:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
80102282:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102285:	c9                   	leave  
  release(&idelock);
80102286:	e9 25 22 00 00       	jmp    801044b0 <release>
8010228b:	90                   	nop
8010228c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
80102290:	89 d8                	mov    %ebx,%eax
80102292:	e8 39 fd ff ff       	call   80101fd0 <idestart>
80102297:	eb b5                	jmp    8010224e <iderw+0x7e>
80102299:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801022a0:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
801022a5:	eb 9d                	jmp    80102244 <iderw+0x74>
    panic("iderw: nothing to do");
801022a7:	83 ec 0c             	sub    $0xc,%esp
801022aa:	68 a0 71 10 80       	push   $0x801071a0
801022af:	e8 dc e0 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
801022b4:	83 ec 0c             	sub    $0xc,%esp
801022b7:	68 8a 71 10 80       	push   $0x8010718a
801022bc:	e8 cf e0 ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
801022c1:	83 ec 0c             	sub    $0xc,%esp
801022c4:	68 b5 71 10 80       	push   $0x801071b5
801022c9:	e8 c2 e0 ff ff       	call   80100390 <panic>
801022ce:	66 90                	xchg   %ax,%ax

801022d0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801022d0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801022d1:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
801022d8:	00 c0 fe 
{
801022db:	89 e5                	mov    %esp,%ebp
801022dd:	56                   	push   %esi
801022de:	53                   	push   %ebx
  ioapic->reg = reg;
801022df:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801022e6:	00 00 00 
  return ioapic->data;
801022e9:	a1 34 26 11 80       	mov    0x80112634,%eax
801022ee:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
801022f1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
801022f7:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801022fd:	0f b6 15 60 27 11 80 	movzbl 0x80112760,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102304:	c1 eb 10             	shr    $0x10,%ebx
  return ioapic->data;
80102307:	8b 41 10             	mov    0x10(%ecx),%eax
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
8010230a:	0f b6 db             	movzbl %bl,%ebx
  id = ioapicread(REG_ID) >> 24;
8010230d:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102310:	39 c2                	cmp    %eax,%edx
80102312:	74 16                	je     8010232a <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102314:	83 ec 0c             	sub    $0xc,%esp
80102317:	68 d4 71 10 80       	push   $0x801071d4
8010231c:	e8 3f e3 ff ff       	call   80100660 <cprintf>
80102321:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80102327:	83 c4 10             	add    $0x10,%esp
8010232a:	83 c3 21             	add    $0x21,%ebx
{
8010232d:	ba 10 00 00 00       	mov    $0x10,%edx
80102332:	b8 20 00 00 00       	mov    $0x20,%eax
80102337:	89 f6                	mov    %esi,%esi
80102339:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ioapic->reg = reg;
80102340:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
80102342:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102348:	89 c6                	mov    %eax,%esi
8010234a:	81 ce 00 00 01 00    	or     $0x10000,%esi
80102350:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102353:	89 71 10             	mov    %esi,0x10(%ecx)
80102356:	8d 72 01             	lea    0x1(%edx),%esi
80102359:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
8010235c:	39 d8                	cmp    %ebx,%eax
  ioapic->reg = reg;
8010235e:	89 31                	mov    %esi,(%ecx)
  ioapic->data = data;
80102360:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80102366:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010236d:	75 d1                	jne    80102340 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010236f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102372:	5b                   	pop    %ebx
80102373:	5e                   	pop    %esi
80102374:	5d                   	pop    %ebp
80102375:	c3                   	ret    
80102376:	8d 76 00             	lea    0x0(%esi),%esi
80102379:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102380 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102380:	55                   	push   %ebp
  ioapic->reg = reg;
80102381:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
{
80102387:	89 e5                	mov    %esp,%ebp
80102389:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010238c:	8d 50 20             	lea    0x20(%eax),%edx
8010238f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102393:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102395:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010239b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010239e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801023a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801023a4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801023a6:	a1 34 26 11 80       	mov    0x80112634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801023ab:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801023ae:	89 50 10             	mov    %edx,0x10(%eax)
}
801023b1:	5d                   	pop    %ebp
801023b2:	c3                   	ret    
801023b3:	66 90                	xchg   %ax,%ax
801023b5:	66 90                	xchg   %ax,%ax
801023b7:	66 90                	xchg   %ax,%ax
801023b9:	66 90                	xchg   %ax,%ax
801023bb:	66 90                	xchg   %ax,%ax
801023bd:	66 90                	xchg   %ax,%ax
801023bf:	90                   	nop

801023c0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801023c0:	55                   	push   %ebp
801023c1:	89 e5                	mov    %esp,%ebp
801023c3:	53                   	push   %ebx
801023c4:	83 ec 04             	sub    $0x4,%esp
801023c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801023ca:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801023d0:	75 70                	jne    80102442 <kfree+0x82>
801023d2:	81 fb a8 54 11 80    	cmp    $0x801154a8,%ebx
801023d8:	72 68                	jb     80102442 <kfree+0x82>
801023da:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801023e0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801023e5:	77 5b                	ja     80102442 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801023e7:	83 ec 04             	sub    $0x4,%esp
801023ea:	68 00 10 00 00       	push   $0x1000
801023ef:	6a 01                	push   $0x1
801023f1:	53                   	push   %ebx
801023f2:	e8 09 21 00 00       	call   80104500 <memset>

  if(kmem.use_lock)
801023f7:	8b 15 74 26 11 80    	mov    0x80112674,%edx
801023fd:	83 c4 10             	add    $0x10,%esp
80102400:	85 d2                	test   %edx,%edx
80102402:	75 2c                	jne    80102430 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102404:	a1 78 26 11 80       	mov    0x80112678,%eax
80102409:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010240b:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.freelist = r;
80102410:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
80102416:	85 c0                	test   %eax,%eax
80102418:	75 06                	jne    80102420 <kfree+0x60>
    release(&kmem.lock);
}
8010241a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010241d:	c9                   	leave  
8010241e:	c3                   	ret    
8010241f:	90                   	nop
    release(&kmem.lock);
80102420:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
80102427:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010242a:	c9                   	leave  
    release(&kmem.lock);
8010242b:	e9 80 20 00 00       	jmp    801044b0 <release>
    acquire(&kmem.lock);
80102430:	83 ec 0c             	sub    $0xc,%esp
80102433:	68 40 26 11 80       	push   $0x80112640
80102438:	e8 b3 1f 00 00       	call   801043f0 <acquire>
8010243d:	83 c4 10             	add    $0x10,%esp
80102440:	eb c2                	jmp    80102404 <kfree+0x44>
    panic("kfree");
80102442:	83 ec 0c             	sub    $0xc,%esp
80102445:	68 06 72 10 80       	push   $0x80107206
8010244a:	e8 41 df ff ff       	call   80100390 <panic>
8010244f:	90                   	nop

80102450 <freerange>:
{
80102450:	55                   	push   %ebp
80102451:	89 e5                	mov    %esp,%ebp
80102453:	56                   	push   %esi
80102454:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102455:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102458:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010245b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102461:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102467:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010246d:	39 de                	cmp    %ebx,%esi
8010246f:	72 23                	jb     80102494 <freerange+0x44>
80102471:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102478:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010247e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102481:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102487:	50                   	push   %eax
80102488:	e8 33 ff ff ff       	call   801023c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010248d:	83 c4 10             	add    $0x10,%esp
80102490:	39 f3                	cmp    %esi,%ebx
80102492:	76 e4                	jbe    80102478 <freerange+0x28>
}
80102494:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102497:	5b                   	pop    %ebx
80102498:	5e                   	pop    %esi
80102499:	5d                   	pop    %ebp
8010249a:	c3                   	ret    
8010249b:	90                   	nop
8010249c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801024a0 <kinit1>:
{
801024a0:	55                   	push   %ebp
801024a1:	89 e5                	mov    %esp,%ebp
801024a3:	56                   	push   %esi
801024a4:	53                   	push   %ebx
801024a5:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801024a8:	83 ec 08             	sub    $0x8,%esp
801024ab:	68 0c 72 10 80       	push   $0x8010720c
801024b0:	68 40 26 11 80       	push   $0x80112640
801024b5:	e8 f6 1d 00 00       	call   801042b0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
801024ba:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024bd:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
801024c0:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
801024c7:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
801024ca:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801024d0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024d6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801024dc:	39 de                	cmp    %ebx,%esi
801024de:	72 1c                	jb     801024fc <kinit1+0x5c>
    kfree(p);
801024e0:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801024e6:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024e9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801024ef:	50                   	push   %eax
801024f0:	e8 cb fe ff ff       	call   801023c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024f5:	83 c4 10             	add    $0x10,%esp
801024f8:	39 de                	cmp    %ebx,%esi
801024fa:	73 e4                	jae    801024e0 <kinit1+0x40>
}
801024fc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801024ff:	5b                   	pop    %ebx
80102500:	5e                   	pop    %esi
80102501:	5d                   	pop    %ebp
80102502:	c3                   	ret    
80102503:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102509:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102510 <kinit2>:
{
80102510:	55                   	push   %ebp
80102511:	89 e5                	mov    %esp,%ebp
80102513:	56                   	push   %esi
80102514:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102515:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102518:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010251b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102521:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102527:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010252d:	39 de                	cmp    %ebx,%esi
8010252f:	72 23                	jb     80102554 <kinit2+0x44>
80102531:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102538:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010253e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102541:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102547:	50                   	push   %eax
80102548:	e8 73 fe ff ff       	call   801023c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010254d:	83 c4 10             	add    $0x10,%esp
80102550:	39 de                	cmp    %ebx,%esi
80102552:	73 e4                	jae    80102538 <kinit2+0x28>
  kmem.use_lock = 1;
80102554:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
8010255b:	00 00 00 
}
8010255e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102561:	5b                   	pop    %ebx
80102562:	5e                   	pop    %esi
80102563:	5d                   	pop    %ebp
80102564:	c3                   	ret    
80102565:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102569:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102570 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102570:	a1 74 26 11 80       	mov    0x80112674,%eax
80102575:	85 c0                	test   %eax,%eax
80102577:	75 1f                	jne    80102598 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102579:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(r)
8010257e:	85 c0                	test   %eax,%eax
80102580:	74 0e                	je     80102590 <kalloc+0x20>
    kmem.freelist = r->next;
80102582:	8b 10                	mov    (%eax),%edx
80102584:	89 15 78 26 11 80    	mov    %edx,0x80112678
8010258a:	c3                   	ret    
8010258b:	90                   	nop
8010258c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
80102590:	f3 c3                	repz ret 
80102592:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
80102598:	55                   	push   %ebp
80102599:	89 e5                	mov    %esp,%ebp
8010259b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
8010259e:	68 40 26 11 80       	push   $0x80112640
801025a3:	e8 48 1e 00 00       	call   801043f0 <acquire>
  r = kmem.freelist;
801025a8:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(r)
801025ad:	83 c4 10             	add    $0x10,%esp
801025b0:	8b 15 74 26 11 80    	mov    0x80112674,%edx
801025b6:	85 c0                	test   %eax,%eax
801025b8:	74 08                	je     801025c2 <kalloc+0x52>
    kmem.freelist = r->next;
801025ba:	8b 08                	mov    (%eax),%ecx
801025bc:	89 0d 78 26 11 80    	mov    %ecx,0x80112678
  if(kmem.use_lock)
801025c2:	85 d2                	test   %edx,%edx
801025c4:	74 16                	je     801025dc <kalloc+0x6c>
    release(&kmem.lock);
801025c6:	83 ec 0c             	sub    $0xc,%esp
801025c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801025cc:	68 40 26 11 80       	push   $0x80112640
801025d1:	e8 da 1e 00 00       	call   801044b0 <release>
  return (char*)r;
801025d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
801025d9:	83 c4 10             	add    $0x10,%esp
}
801025dc:	c9                   	leave  
801025dd:	c3                   	ret    
801025de:	66 90                	xchg   %ax,%ax

801025e0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801025e0:	ba 64 00 00 00       	mov    $0x64,%edx
801025e5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801025e6:	a8 01                	test   $0x1,%al
801025e8:	0f 84 c2 00 00 00    	je     801026b0 <kbdgetc+0xd0>
801025ee:	ba 60 00 00 00       	mov    $0x60,%edx
801025f3:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
801025f4:	0f b6 d0             	movzbl %al,%edx
801025f7:	8b 0d b4 a5 10 80    	mov    0x8010a5b4,%ecx

  if(data == 0xE0){
801025fd:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102603:	0f 84 7f 00 00 00    	je     80102688 <kbdgetc+0xa8>
{
80102609:	55                   	push   %ebp
8010260a:	89 e5                	mov    %esp,%ebp
8010260c:	53                   	push   %ebx
8010260d:	89 cb                	mov    %ecx,%ebx
8010260f:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102612:	84 c0                	test   %al,%al
80102614:	78 4a                	js     80102660 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102616:	85 db                	test   %ebx,%ebx
80102618:	74 09                	je     80102623 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010261a:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
8010261d:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
80102620:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102623:	0f b6 82 40 73 10 80 	movzbl -0x7fef8cc0(%edx),%eax
8010262a:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
8010262c:	0f b6 82 40 72 10 80 	movzbl -0x7fef8dc0(%edx),%eax
80102633:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102635:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102637:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
8010263d:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102640:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102643:	8b 04 85 20 72 10 80 	mov    -0x7fef8de0(,%eax,4),%eax
8010264a:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
8010264e:	74 31                	je     80102681 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
80102650:	8d 50 9f             	lea    -0x61(%eax),%edx
80102653:	83 fa 19             	cmp    $0x19,%edx
80102656:	77 40                	ja     80102698 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102658:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
8010265b:	5b                   	pop    %ebx
8010265c:	5d                   	pop    %ebp
8010265d:	c3                   	ret    
8010265e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102660:	83 e0 7f             	and    $0x7f,%eax
80102663:	85 db                	test   %ebx,%ebx
80102665:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80102668:	0f b6 82 40 73 10 80 	movzbl -0x7fef8cc0(%edx),%eax
8010266f:	83 c8 40             	or     $0x40,%eax
80102672:	0f b6 c0             	movzbl %al,%eax
80102675:	f7 d0                	not    %eax
80102677:	21 c1                	and    %eax,%ecx
    return 0;
80102679:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
8010267b:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
}
80102681:	5b                   	pop    %ebx
80102682:	5d                   	pop    %ebp
80102683:	c3                   	ret    
80102684:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
80102688:	83 c9 40             	or     $0x40,%ecx
    return 0;
8010268b:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
8010268d:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
    return 0;
80102693:	c3                   	ret    
80102694:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102698:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010269b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010269e:	5b                   	pop    %ebx
      c += 'a' - 'A';
8010269f:	83 f9 1a             	cmp    $0x1a,%ecx
801026a2:	0f 42 c2             	cmovb  %edx,%eax
}
801026a5:	5d                   	pop    %ebp
801026a6:	c3                   	ret    
801026a7:	89 f6                	mov    %esi,%esi
801026a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801026b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801026b5:	c3                   	ret    
801026b6:	8d 76 00             	lea    0x0(%esi),%esi
801026b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801026c0 <kbdintr>:

void
kbdintr(void)
{
801026c0:	55                   	push   %ebp
801026c1:	89 e5                	mov    %esp,%ebp
801026c3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801026c6:	68 e0 25 10 80       	push   $0x801025e0
801026cb:	e8 40 e1 ff ff       	call   80100810 <consoleintr>
}
801026d0:	83 c4 10             	add    $0x10,%esp
801026d3:	c9                   	leave  
801026d4:	c3                   	ret    
801026d5:	66 90                	xchg   %ax,%ax
801026d7:	66 90                	xchg   %ax,%ax
801026d9:	66 90                	xchg   %ax,%ax
801026db:	66 90                	xchg   %ax,%ax
801026dd:	66 90                	xchg   %ax,%ax
801026df:	90                   	nop

801026e0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
801026e0:	a1 7c 26 11 80       	mov    0x8011267c,%eax
{
801026e5:	55                   	push   %ebp
801026e6:	89 e5                	mov    %esp,%ebp
  if(!lapic)
801026e8:	85 c0                	test   %eax,%eax
801026ea:	0f 84 c8 00 00 00    	je     801027b8 <lapicinit+0xd8>
  lapic[index] = value;
801026f0:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801026f7:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026fa:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026fd:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102704:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102707:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010270a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102711:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102714:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102717:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010271e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102721:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102724:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010272b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010272e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102731:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102738:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010273b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010273e:	8b 50 30             	mov    0x30(%eax),%edx
80102741:	c1 ea 10             	shr    $0x10,%edx
80102744:	80 fa 03             	cmp    $0x3,%dl
80102747:	77 77                	ja     801027c0 <lapicinit+0xe0>
  lapic[index] = value;
80102749:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102750:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102753:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102756:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010275d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102760:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102763:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010276a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010276d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102770:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102777:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010277a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010277d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102784:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102787:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010278a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102791:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102794:	8b 50 20             	mov    0x20(%eax),%edx
80102797:	89 f6                	mov    %esi,%esi
80102799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801027a0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801027a6:	80 e6 10             	and    $0x10,%dh
801027a9:	75 f5                	jne    801027a0 <lapicinit+0xc0>
  lapic[index] = value;
801027ab:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801027b2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027b5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801027b8:	5d                   	pop    %ebp
801027b9:	c3                   	ret    
801027ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
801027c0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801027c7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801027ca:	8b 50 20             	mov    0x20(%eax),%edx
801027cd:	e9 77 ff ff ff       	jmp    80102749 <lapicinit+0x69>
801027d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801027e0 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
801027e0:	8b 15 7c 26 11 80    	mov    0x8011267c,%edx
{
801027e6:	55                   	push   %ebp
801027e7:	31 c0                	xor    %eax,%eax
801027e9:	89 e5                	mov    %esp,%ebp
  if (!lapic)
801027eb:	85 d2                	test   %edx,%edx
801027ed:	74 06                	je     801027f5 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
801027ef:	8b 42 20             	mov    0x20(%edx),%eax
801027f2:	c1 e8 18             	shr    $0x18,%eax
}
801027f5:	5d                   	pop    %ebp
801027f6:	c3                   	ret    
801027f7:	89 f6                	mov    %esi,%esi
801027f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102800 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102800:	a1 7c 26 11 80       	mov    0x8011267c,%eax
{
80102805:	55                   	push   %ebp
80102806:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102808:	85 c0                	test   %eax,%eax
8010280a:	74 0d                	je     80102819 <lapiceoi+0x19>
  lapic[index] = value;
8010280c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102813:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102816:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102819:	5d                   	pop    %ebp
8010281a:	c3                   	ret    
8010281b:	90                   	nop
8010281c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102820 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102820:	55                   	push   %ebp
80102821:	89 e5                	mov    %esp,%ebp
}
80102823:	5d                   	pop    %ebp
80102824:	c3                   	ret    
80102825:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102829:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102830 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102830:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102831:	b8 0f 00 00 00       	mov    $0xf,%eax
80102836:	ba 70 00 00 00       	mov    $0x70,%edx
8010283b:	89 e5                	mov    %esp,%ebp
8010283d:	53                   	push   %ebx
8010283e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102841:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102844:	ee                   	out    %al,(%dx)
80102845:	b8 0a 00 00 00       	mov    $0xa,%eax
8010284a:	ba 71 00 00 00       	mov    $0x71,%edx
8010284f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102850:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102852:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102855:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010285b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010285d:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
80102860:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
80102863:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
80102865:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102868:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
8010286e:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102873:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102879:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010287c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102883:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102886:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102889:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102890:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102893:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102896:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010289c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010289f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801028a5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801028a8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801028ae:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028b1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801028b7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
801028ba:	5b                   	pop    %ebx
801028bb:	5d                   	pop    %ebp
801028bc:	c3                   	ret    
801028bd:	8d 76 00             	lea    0x0(%esi),%esi

801028c0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
801028c0:	55                   	push   %ebp
801028c1:	b8 0b 00 00 00       	mov    $0xb,%eax
801028c6:	ba 70 00 00 00       	mov    $0x70,%edx
801028cb:	89 e5                	mov    %esp,%ebp
801028cd:	57                   	push   %edi
801028ce:	56                   	push   %esi
801028cf:	53                   	push   %ebx
801028d0:	83 ec 4c             	sub    $0x4c,%esp
801028d3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028d4:	ba 71 00 00 00       	mov    $0x71,%edx
801028d9:	ec                   	in     (%dx),%al
801028da:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028dd:	bb 70 00 00 00       	mov    $0x70,%ebx
801028e2:	88 45 b3             	mov    %al,-0x4d(%ebp)
801028e5:	8d 76 00             	lea    0x0(%esi),%esi
801028e8:	31 c0                	xor    %eax,%eax
801028ea:	89 da                	mov    %ebx,%edx
801028ec:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028ed:	b9 71 00 00 00       	mov    $0x71,%ecx
801028f2:	89 ca                	mov    %ecx,%edx
801028f4:	ec                   	in     (%dx),%al
801028f5:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028f8:	89 da                	mov    %ebx,%edx
801028fa:	b8 02 00 00 00       	mov    $0x2,%eax
801028ff:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102900:	89 ca                	mov    %ecx,%edx
80102902:	ec                   	in     (%dx),%al
80102903:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102906:	89 da                	mov    %ebx,%edx
80102908:	b8 04 00 00 00       	mov    $0x4,%eax
8010290d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010290e:	89 ca                	mov    %ecx,%edx
80102910:	ec                   	in     (%dx),%al
80102911:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102914:	89 da                	mov    %ebx,%edx
80102916:	b8 07 00 00 00       	mov    $0x7,%eax
8010291b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010291c:	89 ca                	mov    %ecx,%edx
8010291e:	ec                   	in     (%dx),%al
8010291f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102922:	89 da                	mov    %ebx,%edx
80102924:	b8 08 00 00 00       	mov    $0x8,%eax
80102929:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010292a:	89 ca                	mov    %ecx,%edx
8010292c:	ec                   	in     (%dx),%al
8010292d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010292f:	89 da                	mov    %ebx,%edx
80102931:	b8 09 00 00 00       	mov    $0x9,%eax
80102936:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102937:	89 ca                	mov    %ecx,%edx
80102939:	ec                   	in     (%dx),%al
8010293a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010293c:	89 da                	mov    %ebx,%edx
8010293e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102943:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102944:	89 ca                	mov    %ecx,%edx
80102946:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102947:	84 c0                	test   %al,%al
80102949:	78 9d                	js     801028e8 <cmostime+0x28>
  return inb(CMOS_RETURN);
8010294b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
8010294f:	89 fa                	mov    %edi,%edx
80102951:	0f b6 fa             	movzbl %dl,%edi
80102954:	89 f2                	mov    %esi,%edx
80102956:	0f b6 f2             	movzbl %dl,%esi
80102959:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010295c:	89 da                	mov    %ebx,%edx
8010295e:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102961:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102964:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102968:	89 45 bc             	mov    %eax,-0x44(%ebp)
8010296b:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
8010296f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102972:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102976:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102979:	31 c0                	xor    %eax,%eax
8010297b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010297c:	89 ca                	mov    %ecx,%edx
8010297e:	ec                   	in     (%dx),%al
8010297f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102982:	89 da                	mov    %ebx,%edx
80102984:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102987:	b8 02 00 00 00       	mov    $0x2,%eax
8010298c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010298d:	89 ca                	mov    %ecx,%edx
8010298f:	ec                   	in     (%dx),%al
80102990:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102993:	89 da                	mov    %ebx,%edx
80102995:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102998:	b8 04 00 00 00       	mov    $0x4,%eax
8010299d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010299e:	89 ca                	mov    %ecx,%edx
801029a0:	ec                   	in     (%dx),%al
801029a1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029a4:	89 da                	mov    %ebx,%edx
801029a6:	89 45 d8             	mov    %eax,-0x28(%ebp)
801029a9:	b8 07 00 00 00       	mov    $0x7,%eax
801029ae:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029af:	89 ca                	mov    %ecx,%edx
801029b1:	ec                   	in     (%dx),%al
801029b2:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029b5:	89 da                	mov    %ebx,%edx
801029b7:	89 45 dc             	mov    %eax,-0x24(%ebp)
801029ba:	b8 08 00 00 00       	mov    $0x8,%eax
801029bf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029c0:	89 ca                	mov    %ecx,%edx
801029c2:	ec                   	in     (%dx),%al
801029c3:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029c6:	89 da                	mov    %ebx,%edx
801029c8:	89 45 e0             	mov    %eax,-0x20(%ebp)
801029cb:	b8 09 00 00 00       	mov    $0x9,%eax
801029d0:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029d1:	89 ca                	mov    %ecx,%edx
801029d3:	ec                   	in     (%dx),%al
801029d4:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801029d7:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
801029da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801029dd:	8d 45 d0             	lea    -0x30(%ebp),%eax
801029e0:	6a 18                	push   $0x18
801029e2:	50                   	push   %eax
801029e3:	8d 45 b8             	lea    -0x48(%ebp),%eax
801029e6:	50                   	push   %eax
801029e7:	e8 64 1b 00 00       	call   80104550 <memcmp>
801029ec:	83 c4 10             	add    $0x10,%esp
801029ef:	85 c0                	test   %eax,%eax
801029f1:	0f 85 f1 fe ff ff    	jne    801028e8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
801029f7:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
801029fb:	75 78                	jne    80102a75 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801029fd:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102a00:	89 c2                	mov    %eax,%edx
80102a02:	83 e0 0f             	and    $0xf,%eax
80102a05:	c1 ea 04             	shr    $0x4,%edx
80102a08:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a0b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a0e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102a11:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102a14:	89 c2                	mov    %eax,%edx
80102a16:	83 e0 0f             	and    $0xf,%eax
80102a19:	c1 ea 04             	shr    $0x4,%edx
80102a1c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a1f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a22:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102a25:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102a28:	89 c2                	mov    %eax,%edx
80102a2a:	83 e0 0f             	and    $0xf,%eax
80102a2d:	c1 ea 04             	shr    $0x4,%edx
80102a30:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a33:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a36:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102a39:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102a3c:	89 c2                	mov    %eax,%edx
80102a3e:	83 e0 0f             	and    $0xf,%eax
80102a41:	c1 ea 04             	shr    $0x4,%edx
80102a44:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a47:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a4a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102a4d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102a50:	89 c2                	mov    %eax,%edx
80102a52:	83 e0 0f             	and    $0xf,%eax
80102a55:	c1 ea 04             	shr    $0x4,%edx
80102a58:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a5b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a5e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102a61:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102a64:	89 c2                	mov    %eax,%edx
80102a66:	83 e0 0f             	and    $0xf,%eax
80102a69:	c1 ea 04             	shr    $0x4,%edx
80102a6c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a6f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a72:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102a75:	8b 75 08             	mov    0x8(%ebp),%esi
80102a78:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102a7b:	89 06                	mov    %eax,(%esi)
80102a7d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102a80:	89 46 04             	mov    %eax,0x4(%esi)
80102a83:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102a86:	89 46 08             	mov    %eax,0x8(%esi)
80102a89:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102a8c:	89 46 0c             	mov    %eax,0xc(%esi)
80102a8f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102a92:	89 46 10             	mov    %eax,0x10(%esi)
80102a95:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102a98:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102a9b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102aa2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102aa5:	5b                   	pop    %ebx
80102aa6:	5e                   	pop    %esi
80102aa7:	5f                   	pop    %edi
80102aa8:	5d                   	pop    %ebp
80102aa9:	c3                   	ret    
80102aaa:	66 90                	xchg   %ax,%ax
80102aac:	66 90                	xchg   %ax,%ax
80102aae:	66 90                	xchg   %ax,%ax

80102ab0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102ab0:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102ab6:	85 c9                	test   %ecx,%ecx
80102ab8:	0f 8e 8a 00 00 00    	jle    80102b48 <install_trans+0x98>
{
80102abe:	55                   	push   %ebp
80102abf:	89 e5                	mov    %esp,%ebp
80102ac1:	57                   	push   %edi
80102ac2:	56                   	push   %esi
80102ac3:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102ac4:	31 db                	xor    %ebx,%ebx
{
80102ac6:	83 ec 0c             	sub    $0xc,%esp
80102ac9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102ad0:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102ad5:	83 ec 08             	sub    $0x8,%esp
80102ad8:	01 d8                	add    %ebx,%eax
80102ada:	83 c0 01             	add    $0x1,%eax
80102add:	50                   	push   %eax
80102ade:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102ae4:	e8 e7 d5 ff ff       	call   801000d0 <bread>
80102ae9:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102aeb:	58                   	pop    %eax
80102aec:	5a                   	pop    %edx
80102aed:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
80102af4:	ff 35 c4 26 11 80    	pushl  0x801126c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102afa:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102afd:	e8 ce d5 ff ff       	call   801000d0 <bread>
80102b02:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102b04:	8d 47 5c             	lea    0x5c(%edi),%eax
80102b07:	83 c4 0c             	add    $0xc,%esp
80102b0a:	68 00 02 00 00       	push   $0x200
80102b0f:	50                   	push   %eax
80102b10:	8d 46 5c             	lea    0x5c(%esi),%eax
80102b13:	50                   	push   %eax
80102b14:	e8 97 1a 00 00       	call   801045b0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102b19:	89 34 24             	mov    %esi,(%esp)
80102b1c:	e8 7f d6 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102b21:	89 3c 24             	mov    %edi,(%esp)
80102b24:	e8 b7 d6 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102b29:	89 34 24             	mov    %esi,(%esp)
80102b2c:	e8 af d6 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102b31:	83 c4 10             	add    $0x10,%esp
80102b34:	39 1d c8 26 11 80    	cmp    %ebx,0x801126c8
80102b3a:	7f 94                	jg     80102ad0 <install_trans+0x20>
  }
}
80102b3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102b3f:	5b                   	pop    %ebx
80102b40:	5e                   	pop    %esi
80102b41:	5f                   	pop    %edi
80102b42:	5d                   	pop    %ebp
80102b43:	c3                   	ret    
80102b44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102b48:	f3 c3                	repz ret 
80102b4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102b50 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102b50:	55                   	push   %ebp
80102b51:	89 e5                	mov    %esp,%ebp
80102b53:	56                   	push   %esi
80102b54:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
80102b55:	83 ec 08             	sub    $0x8,%esp
80102b58:	ff 35 b4 26 11 80    	pushl  0x801126b4
80102b5e:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102b64:	e8 67 d5 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102b69:	8b 1d c8 26 11 80    	mov    0x801126c8,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102b6f:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102b72:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
80102b74:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
80102b76:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102b79:	7e 16                	jle    80102b91 <write_head+0x41>
80102b7b:	c1 e3 02             	shl    $0x2,%ebx
80102b7e:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80102b80:	8b 8a cc 26 11 80    	mov    -0x7feed934(%edx),%ecx
80102b86:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
80102b8a:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
80102b8d:	39 da                	cmp    %ebx,%edx
80102b8f:	75 ef                	jne    80102b80 <write_head+0x30>
  }
  bwrite(buf);
80102b91:	83 ec 0c             	sub    $0xc,%esp
80102b94:	56                   	push   %esi
80102b95:	e8 06 d6 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102b9a:	89 34 24             	mov    %esi,(%esp)
80102b9d:	e8 3e d6 ff ff       	call   801001e0 <brelse>
}
80102ba2:	83 c4 10             	add    $0x10,%esp
80102ba5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102ba8:	5b                   	pop    %ebx
80102ba9:	5e                   	pop    %esi
80102baa:	5d                   	pop    %ebp
80102bab:	c3                   	ret    
80102bac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102bb0 <initlog>:
{
80102bb0:	55                   	push   %ebp
80102bb1:	89 e5                	mov    %esp,%ebp
80102bb3:	53                   	push   %ebx
80102bb4:	83 ec 2c             	sub    $0x2c,%esp
80102bb7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102bba:	68 40 74 10 80       	push   $0x80107440
80102bbf:	68 80 26 11 80       	push   $0x80112680
80102bc4:	e8 e7 16 00 00       	call   801042b0 <initlock>
  readsb(dev, &sb);
80102bc9:	58                   	pop    %eax
80102bca:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102bcd:	5a                   	pop    %edx
80102bce:	50                   	push   %eax
80102bcf:	53                   	push   %ebx
80102bd0:	e8 fb e7 ff ff       	call   801013d0 <readsb>
  log.size = sb.nlog;
80102bd5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102bd8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102bdb:	59                   	pop    %ecx
  log.dev = dev;
80102bdc:	89 1d c4 26 11 80    	mov    %ebx,0x801126c4
  log.size = sb.nlog;
80102be2:	89 15 b8 26 11 80    	mov    %edx,0x801126b8
  log.start = sb.logstart;
80102be8:	a3 b4 26 11 80       	mov    %eax,0x801126b4
  struct buf *buf = bread(log.dev, log.start);
80102bed:	5a                   	pop    %edx
80102bee:	50                   	push   %eax
80102bef:	53                   	push   %ebx
80102bf0:	e8 db d4 ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80102bf5:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80102bf8:	83 c4 10             	add    $0x10,%esp
80102bfb:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102bfd:	89 1d c8 26 11 80    	mov    %ebx,0x801126c8
  for (i = 0; i < log.lh.n; i++) {
80102c03:	7e 1c                	jle    80102c21 <initlog+0x71>
80102c05:	c1 e3 02             	shl    $0x2,%ebx
80102c08:	31 d2                	xor    %edx,%edx
80102c0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80102c10:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102c14:	83 c2 04             	add    $0x4,%edx
80102c17:	89 8a c8 26 11 80    	mov    %ecx,-0x7feed938(%edx)
  for (i = 0; i < log.lh.n; i++) {
80102c1d:	39 d3                	cmp    %edx,%ebx
80102c1f:	75 ef                	jne    80102c10 <initlog+0x60>
  brelse(buf);
80102c21:	83 ec 0c             	sub    $0xc,%esp
80102c24:	50                   	push   %eax
80102c25:	e8 b6 d5 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102c2a:	e8 81 fe ff ff       	call   80102ab0 <install_trans>
  log.lh.n = 0;
80102c2f:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102c36:	00 00 00 
  write_head(); // clear the log
80102c39:	e8 12 ff ff ff       	call   80102b50 <write_head>
}
80102c3e:	83 c4 10             	add    $0x10,%esp
80102c41:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c44:	c9                   	leave  
80102c45:	c3                   	ret    
80102c46:	8d 76 00             	lea    0x0(%esi),%esi
80102c49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102c50 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102c50:	55                   	push   %ebp
80102c51:	89 e5                	mov    %esp,%ebp
80102c53:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102c56:	68 80 26 11 80       	push   $0x80112680
80102c5b:	e8 90 17 00 00       	call   801043f0 <acquire>
80102c60:	83 c4 10             	add    $0x10,%esp
80102c63:	eb 18                	jmp    80102c7d <begin_op+0x2d>
80102c65:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102c68:	83 ec 08             	sub    $0x8,%esp
80102c6b:	68 80 26 11 80       	push   $0x80112680
80102c70:	68 80 26 11 80       	push   $0x80112680
80102c75:	e8 b6 11 00 00       	call   80103e30 <sleep>
80102c7a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102c7d:	a1 c0 26 11 80       	mov    0x801126c0,%eax
80102c82:	85 c0                	test   %eax,%eax
80102c84:	75 e2                	jne    80102c68 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102c86:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102c8b:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102c91:	83 c0 01             	add    $0x1,%eax
80102c94:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102c97:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102c9a:	83 fa 1e             	cmp    $0x1e,%edx
80102c9d:	7f c9                	jg     80102c68 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102c9f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102ca2:	a3 bc 26 11 80       	mov    %eax,0x801126bc
      release(&log.lock);
80102ca7:	68 80 26 11 80       	push   $0x80112680
80102cac:	e8 ff 17 00 00       	call   801044b0 <release>
      break;
    }
  }
}
80102cb1:	83 c4 10             	add    $0x10,%esp
80102cb4:	c9                   	leave  
80102cb5:	c3                   	ret    
80102cb6:	8d 76 00             	lea    0x0(%esi),%esi
80102cb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102cc0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102cc0:	55                   	push   %ebp
80102cc1:	89 e5                	mov    %esp,%ebp
80102cc3:	57                   	push   %edi
80102cc4:	56                   	push   %esi
80102cc5:	53                   	push   %ebx
80102cc6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102cc9:	68 80 26 11 80       	push   $0x80112680
80102cce:	e8 1d 17 00 00       	call   801043f0 <acquire>
  log.outstanding -= 1;
80102cd3:	a1 bc 26 11 80       	mov    0x801126bc,%eax
  if(log.committing)
80102cd8:	8b 35 c0 26 11 80    	mov    0x801126c0,%esi
80102cde:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102ce1:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80102ce4:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80102ce6:	89 1d bc 26 11 80    	mov    %ebx,0x801126bc
  if(log.committing)
80102cec:	0f 85 1a 01 00 00    	jne    80102e0c <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
80102cf2:	85 db                	test   %ebx,%ebx
80102cf4:	0f 85 ee 00 00 00    	jne    80102de8 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102cfa:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
80102cfd:	c7 05 c0 26 11 80 01 	movl   $0x1,0x801126c0
80102d04:	00 00 00 
  release(&log.lock);
80102d07:	68 80 26 11 80       	push   $0x80112680
80102d0c:	e8 9f 17 00 00       	call   801044b0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102d11:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102d17:	83 c4 10             	add    $0x10,%esp
80102d1a:	85 c9                	test   %ecx,%ecx
80102d1c:	0f 8e 85 00 00 00    	jle    80102da7 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102d22:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102d27:	83 ec 08             	sub    $0x8,%esp
80102d2a:	01 d8                	add    %ebx,%eax
80102d2c:	83 c0 01             	add    $0x1,%eax
80102d2f:	50                   	push   %eax
80102d30:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102d36:	e8 95 d3 ff ff       	call   801000d0 <bread>
80102d3b:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102d3d:	58                   	pop    %eax
80102d3e:	5a                   	pop    %edx
80102d3f:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
80102d46:	ff 35 c4 26 11 80    	pushl  0x801126c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102d4c:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102d4f:	e8 7c d3 ff ff       	call   801000d0 <bread>
80102d54:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102d56:	8d 40 5c             	lea    0x5c(%eax),%eax
80102d59:	83 c4 0c             	add    $0xc,%esp
80102d5c:	68 00 02 00 00       	push   $0x200
80102d61:	50                   	push   %eax
80102d62:	8d 46 5c             	lea    0x5c(%esi),%eax
80102d65:	50                   	push   %eax
80102d66:	e8 45 18 00 00       	call   801045b0 <memmove>
    bwrite(to);  // write the log
80102d6b:	89 34 24             	mov    %esi,(%esp)
80102d6e:	e8 2d d4 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102d73:	89 3c 24             	mov    %edi,(%esp)
80102d76:	e8 65 d4 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102d7b:	89 34 24             	mov    %esi,(%esp)
80102d7e:	e8 5d d4 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102d83:	83 c4 10             	add    $0x10,%esp
80102d86:	3b 1d c8 26 11 80    	cmp    0x801126c8,%ebx
80102d8c:	7c 94                	jl     80102d22 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102d8e:	e8 bd fd ff ff       	call   80102b50 <write_head>
    install_trans(); // Now install writes to home locations
80102d93:	e8 18 fd ff ff       	call   80102ab0 <install_trans>
    log.lh.n = 0;
80102d98:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102d9f:	00 00 00 
    write_head();    // Erase the transaction from the log
80102da2:	e8 a9 fd ff ff       	call   80102b50 <write_head>
    acquire(&log.lock);
80102da7:	83 ec 0c             	sub    $0xc,%esp
80102daa:	68 80 26 11 80       	push   $0x80112680
80102daf:	e8 3c 16 00 00       	call   801043f0 <acquire>
    wakeup(&log);
80102db4:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
    log.committing = 0;
80102dbb:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
80102dc2:	00 00 00 
    wakeup(&log);
80102dc5:	e8 16 12 00 00       	call   80103fe0 <wakeup>
    release(&log.lock);
80102dca:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102dd1:	e8 da 16 00 00       	call   801044b0 <release>
80102dd6:	83 c4 10             	add    $0x10,%esp
}
80102dd9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102ddc:	5b                   	pop    %ebx
80102ddd:	5e                   	pop    %esi
80102dde:	5f                   	pop    %edi
80102ddf:	5d                   	pop    %ebp
80102de0:	c3                   	ret    
80102de1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
80102de8:	83 ec 0c             	sub    $0xc,%esp
80102deb:	68 80 26 11 80       	push   $0x80112680
80102df0:	e8 eb 11 00 00       	call   80103fe0 <wakeup>
  release(&log.lock);
80102df5:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102dfc:	e8 af 16 00 00       	call   801044b0 <release>
80102e01:	83 c4 10             	add    $0x10,%esp
}
80102e04:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e07:	5b                   	pop    %ebx
80102e08:	5e                   	pop    %esi
80102e09:	5f                   	pop    %edi
80102e0a:	5d                   	pop    %ebp
80102e0b:	c3                   	ret    
    panic("log.committing");
80102e0c:	83 ec 0c             	sub    $0xc,%esp
80102e0f:	68 44 74 10 80       	push   $0x80107444
80102e14:	e8 77 d5 ff ff       	call   80100390 <panic>
80102e19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102e20 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102e20:	55                   	push   %ebp
80102e21:	89 e5                	mov    %esp,%ebp
80102e23:	53                   	push   %ebx
80102e24:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102e27:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
{
80102e2d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102e30:	83 fa 1d             	cmp    $0x1d,%edx
80102e33:	0f 8f 9d 00 00 00    	jg     80102ed6 <log_write+0xb6>
80102e39:	a1 b8 26 11 80       	mov    0x801126b8,%eax
80102e3e:	83 e8 01             	sub    $0x1,%eax
80102e41:	39 c2                	cmp    %eax,%edx
80102e43:	0f 8d 8d 00 00 00    	jge    80102ed6 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102e49:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102e4e:	85 c0                	test   %eax,%eax
80102e50:	0f 8e 8d 00 00 00    	jle    80102ee3 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102e56:	83 ec 0c             	sub    $0xc,%esp
80102e59:	68 80 26 11 80       	push   $0x80112680
80102e5e:	e8 8d 15 00 00       	call   801043f0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102e63:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102e69:	83 c4 10             	add    $0x10,%esp
80102e6c:	83 f9 00             	cmp    $0x0,%ecx
80102e6f:	7e 57                	jle    80102ec8 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102e71:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80102e74:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102e76:	3b 15 cc 26 11 80    	cmp    0x801126cc,%edx
80102e7c:	75 0b                	jne    80102e89 <log_write+0x69>
80102e7e:	eb 38                	jmp    80102eb8 <log_write+0x98>
80102e80:	39 14 85 cc 26 11 80 	cmp    %edx,-0x7feed934(,%eax,4)
80102e87:	74 2f                	je     80102eb8 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80102e89:	83 c0 01             	add    $0x1,%eax
80102e8c:	39 c1                	cmp    %eax,%ecx
80102e8e:	75 f0                	jne    80102e80 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102e90:	89 14 85 cc 26 11 80 	mov    %edx,-0x7feed934(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
80102e97:	83 c0 01             	add    $0x1,%eax
80102e9a:	a3 c8 26 11 80       	mov    %eax,0x801126c8
  b->flags |= B_DIRTY; // prevent eviction
80102e9f:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102ea2:	c7 45 08 80 26 11 80 	movl   $0x80112680,0x8(%ebp)
}
80102ea9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102eac:	c9                   	leave  
  release(&log.lock);
80102ead:	e9 fe 15 00 00       	jmp    801044b0 <release>
80102eb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102eb8:	89 14 85 cc 26 11 80 	mov    %edx,-0x7feed934(,%eax,4)
80102ebf:	eb de                	jmp    80102e9f <log_write+0x7f>
80102ec1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ec8:	8b 43 08             	mov    0x8(%ebx),%eax
80102ecb:	a3 cc 26 11 80       	mov    %eax,0x801126cc
  if (i == log.lh.n)
80102ed0:	75 cd                	jne    80102e9f <log_write+0x7f>
80102ed2:	31 c0                	xor    %eax,%eax
80102ed4:	eb c1                	jmp    80102e97 <log_write+0x77>
    panic("too big a transaction");
80102ed6:	83 ec 0c             	sub    $0xc,%esp
80102ed9:	68 53 74 10 80       	push   $0x80107453
80102ede:	e8 ad d4 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80102ee3:	83 ec 0c             	sub    $0xc,%esp
80102ee6:	68 69 74 10 80       	push   $0x80107469
80102eeb:	e8 a0 d4 ff ff       	call   80100390 <panic>

80102ef0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102ef0:	55                   	push   %ebp
80102ef1:	89 e5                	mov    %esp,%ebp
80102ef3:	53                   	push   %ebx
80102ef4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102ef7:	e8 74 09 00 00       	call   80103870 <cpuid>
80102efc:	89 c3                	mov    %eax,%ebx
80102efe:	e8 6d 09 00 00       	call   80103870 <cpuid>
80102f03:	83 ec 04             	sub    $0x4,%esp
80102f06:	53                   	push   %ebx
80102f07:	50                   	push   %eax
80102f08:	68 84 74 10 80       	push   $0x80107484
80102f0d:	e8 4e d7 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80102f12:	e8 a9 28 00 00       	call   801057c0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102f17:	e8 d4 08 00 00       	call   801037f0 <mycpu>
80102f1c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102f1e:	b8 01 00 00 00       	mov    $0x1,%eax
80102f23:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102f2a:	e8 21 0c 00 00       	call   80103b50 <scheduler>
80102f2f:	90                   	nop

80102f30 <mpenter>:
{
80102f30:	55                   	push   %ebp
80102f31:	89 e5                	mov    %esp,%ebp
80102f33:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102f36:	e8 75 39 00 00       	call   801068b0 <switchkvm>
  seginit();
80102f3b:	e8 e0 38 00 00       	call   80106820 <seginit>
  lapicinit();
80102f40:	e8 9b f7 ff ff       	call   801026e0 <lapicinit>
  mpmain();
80102f45:	e8 a6 ff ff ff       	call   80102ef0 <mpmain>
80102f4a:	66 90                	xchg   %ax,%ax
80102f4c:	66 90                	xchg   %ax,%ax
80102f4e:	66 90                	xchg   %ax,%ax

80102f50 <main>:
{
80102f50:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102f54:	83 e4 f0             	and    $0xfffffff0,%esp
80102f57:	ff 71 fc             	pushl  -0x4(%ecx)
80102f5a:	55                   	push   %ebp
80102f5b:	89 e5                	mov    %esp,%ebp
80102f5d:	53                   	push   %ebx
80102f5e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102f5f:	83 ec 08             	sub    $0x8,%esp
80102f62:	68 00 00 40 80       	push   $0x80400000
80102f67:	68 a8 54 11 80       	push   $0x801154a8
80102f6c:	e8 2f f5 ff ff       	call   801024a0 <kinit1>
  kvmalloc();      // kernel page table
80102f71:	e8 0a 3e 00 00       	call   80106d80 <kvmalloc>
  mpinit();        // detect other processors
80102f76:	e8 75 01 00 00       	call   801030f0 <mpinit>
  lapicinit();     // interrupt controller
80102f7b:	e8 60 f7 ff ff       	call   801026e0 <lapicinit>
  seginit();       // segment descriptors
80102f80:	e8 9b 38 00 00       	call   80106820 <seginit>
  picinit();       // disable pic
80102f85:	e8 46 03 00 00       	call   801032d0 <picinit>
  ioapicinit();    // another interrupt controller
80102f8a:	e8 41 f3 ff ff       	call   801022d0 <ioapicinit>
  consoleinit();   // console hardware
80102f8f:	e8 2c da ff ff       	call   801009c0 <consoleinit>
  uartinit();      // serial port
80102f94:	e8 57 2b 00 00       	call   80105af0 <uartinit>
  pinit();         // process table
80102f99:	e8 32 08 00 00       	call   801037d0 <pinit>
  tvinit();        // trap vectors
80102f9e:	e8 9d 27 00 00       	call   80105740 <tvinit>
  binit();         // buffer cache
80102fa3:	e8 98 d0 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80102fa8:	e8 b3 dd ff ff       	call   80100d60 <fileinit>
  ideinit();       // disk 
80102fad:	e8 fe f0 ff ff       	call   801020b0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102fb2:	83 c4 0c             	add    $0xc,%esp
80102fb5:	68 8a 00 00 00       	push   $0x8a
80102fba:	68 8c a4 10 80       	push   $0x8010a48c
80102fbf:	68 00 70 00 80       	push   $0x80007000
80102fc4:	e8 e7 15 00 00       	call   801045b0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102fc9:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102fd0:	00 00 00 
80102fd3:	83 c4 10             	add    $0x10,%esp
80102fd6:	05 80 27 11 80       	add    $0x80112780,%eax
80102fdb:	3d 80 27 11 80       	cmp    $0x80112780,%eax
80102fe0:	76 71                	jbe    80103053 <main+0x103>
80102fe2:	bb 80 27 11 80       	mov    $0x80112780,%ebx
80102fe7:	89 f6                	mov    %esi,%esi
80102fe9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == mycpu())  // We've started already.
80102ff0:	e8 fb 07 00 00       	call   801037f0 <mycpu>
80102ff5:	39 d8                	cmp    %ebx,%eax
80102ff7:	74 41                	je     8010303a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102ff9:	e8 72 f5 ff ff       	call   80102570 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
80102ffe:	05 00 10 00 00       	add    $0x1000,%eax
    *(void(**)(void))(code-8) = mpenter;
80103003:	c7 05 f8 6f 00 80 30 	movl   $0x80102f30,0x80006ff8
8010300a:	2f 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
8010300d:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80103014:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80103017:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
8010301c:	0f b6 03             	movzbl (%ebx),%eax
8010301f:	83 ec 08             	sub    $0x8,%esp
80103022:	68 00 70 00 00       	push   $0x7000
80103027:	50                   	push   %eax
80103028:	e8 03 f8 ff ff       	call   80102830 <lapicstartap>
8010302d:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103030:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103036:	85 c0                	test   %eax,%eax
80103038:	74 f6                	je     80103030 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
8010303a:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80103041:	00 00 00 
80103044:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
8010304a:	05 80 27 11 80       	add    $0x80112780,%eax
8010304f:	39 c3                	cmp    %eax,%ebx
80103051:	72 9d                	jb     80102ff0 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103053:	83 ec 08             	sub    $0x8,%esp
80103056:	68 00 00 00 8e       	push   $0x8e000000
8010305b:	68 00 00 40 80       	push   $0x80400000
80103060:	e8 ab f4 ff ff       	call   80102510 <kinit2>
  userinit();      // first user process
80103065:	e8 56 08 00 00       	call   801038c0 <userinit>
  mpmain();        // finish this processor's setup
8010306a:	e8 81 fe ff ff       	call   80102ef0 <mpmain>
8010306f:	90                   	nop

80103070 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103070:	55                   	push   %ebp
80103071:	89 e5                	mov    %esp,%ebp
80103073:	57                   	push   %edi
80103074:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103075:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010307b:	53                   	push   %ebx
  e = addr+len;
8010307c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010307f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103082:	39 de                	cmp    %ebx,%esi
80103084:	72 10                	jb     80103096 <mpsearch1+0x26>
80103086:	eb 50                	jmp    801030d8 <mpsearch1+0x68>
80103088:	90                   	nop
80103089:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103090:	39 fb                	cmp    %edi,%ebx
80103092:	89 fe                	mov    %edi,%esi
80103094:	76 42                	jbe    801030d8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103096:	83 ec 04             	sub    $0x4,%esp
80103099:	8d 7e 10             	lea    0x10(%esi),%edi
8010309c:	6a 04                	push   $0x4
8010309e:	68 98 74 10 80       	push   $0x80107498
801030a3:	56                   	push   %esi
801030a4:	e8 a7 14 00 00       	call   80104550 <memcmp>
801030a9:	83 c4 10             	add    $0x10,%esp
801030ac:	85 c0                	test   %eax,%eax
801030ae:	75 e0                	jne    80103090 <mpsearch1+0x20>
801030b0:	89 f1                	mov    %esi,%ecx
801030b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801030b8:	0f b6 11             	movzbl (%ecx),%edx
801030bb:	83 c1 01             	add    $0x1,%ecx
801030be:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
801030c0:	39 f9                	cmp    %edi,%ecx
801030c2:	75 f4                	jne    801030b8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801030c4:	84 c0                	test   %al,%al
801030c6:	75 c8                	jne    80103090 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801030c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801030cb:	89 f0                	mov    %esi,%eax
801030cd:	5b                   	pop    %ebx
801030ce:	5e                   	pop    %esi
801030cf:	5f                   	pop    %edi
801030d0:	5d                   	pop    %ebp
801030d1:	c3                   	ret    
801030d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801030d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801030db:	31 f6                	xor    %esi,%esi
}
801030dd:	89 f0                	mov    %esi,%eax
801030df:	5b                   	pop    %ebx
801030e0:	5e                   	pop    %esi
801030e1:	5f                   	pop    %edi
801030e2:	5d                   	pop    %ebp
801030e3:	c3                   	ret    
801030e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801030ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801030f0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801030f0:	55                   	push   %ebp
801030f1:	89 e5                	mov    %esp,%ebp
801030f3:	57                   	push   %edi
801030f4:	56                   	push   %esi
801030f5:	53                   	push   %ebx
801030f6:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801030f9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103100:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103107:	c1 e0 08             	shl    $0x8,%eax
8010310a:	09 d0                	or     %edx,%eax
8010310c:	c1 e0 04             	shl    $0x4,%eax
8010310f:	85 c0                	test   %eax,%eax
80103111:	75 1b                	jne    8010312e <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103113:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010311a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103121:	c1 e0 08             	shl    $0x8,%eax
80103124:	09 d0                	or     %edx,%eax
80103126:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103129:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010312e:	ba 00 04 00 00       	mov    $0x400,%edx
80103133:	e8 38 ff ff ff       	call   80103070 <mpsearch1>
80103138:	85 c0                	test   %eax,%eax
8010313a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010313d:	0f 84 3d 01 00 00    	je     80103280 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103143:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103146:	8b 58 04             	mov    0x4(%eax),%ebx
80103149:	85 db                	test   %ebx,%ebx
8010314b:	0f 84 4f 01 00 00    	je     801032a0 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103151:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
80103157:	83 ec 04             	sub    $0x4,%esp
8010315a:	6a 04                	push   $0x4
8010315c:	68 b5 74 10 80       	push   $0x801074b5
80103161:	56                   	push   %esi
80103162:	e8 e9 13 00 00       	call   80104550 <memcmp>
80103167:	83 c4 10             	add    $0x10,%esp
8010316a:	85 c0                	test   %eax,%eax
8010316c:	0f 85 2e 01 00 00    	jne    801032a0 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
80103172:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103179:	3c 01                	cmp    $0x1,%al
8010317b:	0f 95 c2             	setne  %dl
8010317e:	3c 04                	cmp    $0x4,%al
80103180:	0f 95 c0             	setne  %al
80103183:	20 c2                	and    %al,%dl
80103185:	0f 85 15 01 00 00    	jne    801032a0 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
8010318b:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
80103192:	66 85 ff             	test   %di,%di
80103195:	74 1a                	je     801031b1 <mpinit+0xc1>
80103197:	89 f0                	mov    %esi,%eax
80103199:	01 f7                	add    %esi,%edi
  sum = 0;
8010319b:	31 d2                	xor    %edx,%edx
8010319d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801031a0:	0f b6 08             	movzbl (%eax),%ecx
801031a3:	83 c0 01             	add    $0x1,%eax
801031a6:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801031a8:	39 c7                	cmp    %eax,%edi
801031aa:	75 f4                	jne    801031a0 <mpinit+0xb0>
801031ac:	84 d2                	test   %dl,%dl
801031ae:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
801031b1:	85 f6                	test   %esi,%esi
801031b3:	0f 84 e7 00 00 00    	je     801032a0 <mpinit+0x1b0>
801031b9:	84 d2                	test   %dl,%dl
801031bb:	0f 85 df 00 00 00    	jne    801032a0 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801031c1:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
801031c7:	a3 7c 26 11 80       	mov    %eax,0x8011267c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801031cc:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
801031d3:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
801031d9:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801031de:	01 d6                	add    %edx,%esi
801031e0:	39 c6                	cmp    %eax,%esi
801031e2:	76 23                	jbe    80103207 <mpinit+0x117>
    switch(*p){
801031e4:	0f b6 10             	movzbl (%eax),%edx
801031e7:	80 fa 04             	cmp    $0x4,%dl
801031ea:	0f 87 ca 00 00 00    	ja     801032ba <mpinit+0x1ca>
801031f0:	ff 24 95 dc 74 10 80 	jmp    *-0x7fef8b24(,%edx,4)
801031f7:	89 f6                	mov    %esi,%esi
801031f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103200:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103203:	39 c6                	cmp    %eax,%esi
80103205:	77 dd                	ja     801031e4 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103207:	85 db                	test   %ebx,%ebx
80103209:	0f 84 9e 00 00 00    	je     801032ad <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010320f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103212:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80103216:	74 15                	je     8010322d <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103218:	b8 70 00 00 00       	mov    $0x70,%eax
8010321d:	ba 22 00 00 00       	mov    $0x22,%edx
80103222:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103223:	ba 23 00 00 00       	mov    $0x23,%edx
80103228:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103229:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010322c:	ee                   	out    %al,(%dx)
  }
}
8010322d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103230:	5b                   	pop    %ebx
80103231:	5e                   	pop    %esi
80103232:	5f                   	pop    %edi
80103233:	5d                   	pop    %ebp
80103234:	c3                   	ret    
80103235:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
80103238:	8b 0d 00 2d 11 80    	mov    0x80112d00,%ecx
8010323e:	83 f9 07             	cmp    $0x7,%ecx
80103241:	7f 19                	jg     8010325c <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103243:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103247:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
8010324d:	83 c1 01             	add    $0x1,%ecx
80103250:	89 0d 00 2d 11 80    	mov    %ecx,0x80112d00
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103256:	88 97 80 27 11 80    	mov    %dl,-0x7feed880(%edi)
      p += sizeof(struct mpproc);
8010325c:	83 c0 14             	add    $0x14,%eax
      continue;
8010325f:	e9 7c ff ff ff       	jmp    801031e0 <mpinit+0xf0>
80103264:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103268:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
8010326c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
8010326f:	88 15 60 27 11 80    	mov    %dl,0x80112760
      continue;
80103275:	e9 66 ff ff ff       	jmp    801031e0 <mpinit+0xf0>
8010327a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
80103280:	ba 00 00 01 00       	mov    $0x10000,%edx
80103285:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010328a:	e8 e1 fd ff ff       	call   80103070 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010328f:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
80103291:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103294:	0f 85 a9 fe ff ff    	jne    80103143 <mpinit+0x53>
8010329a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
801032a0:	83 ec 0c             	sub    $0xc,%esp
801032a3:	68 9d 74 10 80       	push   $0x8010749d
801032a8:	e8 e3 d0 ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
801032ad:	83 ec 0c             	sub    $0xc,%esp
801032b0:	68 bc 74 10 80       	push   $0x801074bc
801032b5:	e8 d6 d0 ff ff       	call   80100390 <panic>
      ismp = 0;
801032ba:	31 db                	xor    %ebx,%ebx
801032bc:	e9 26 ff ff ff       	jmp    801031e7 <mpinit+0xf7>
801032c1:	66 90                	xchg   %ax,%ax
801032c3:	66 90                	xchg   %ax,%ax
801032c5:	66 90                	xchg   %ax,%ax
801032c7:	66 90                	xchg   %ax,%ax
801032c9:	66 90                	xchg   %ax,%ax
801032cb:	66 90                	xchg   %ax,%ax
801032cd:	66 90                	xchg   %ax,%ax
801032cf:	90                   	nop

801032d0 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
801032d0:	55                   	push   %ebp
801032d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801032d6:	ba 21 00 00 00       	mov    $0x21,%edx
801032db:	89 e5                	mov    %esp,%ebp
801032dd:	ee                   	out    %al,(%dx)
801032de:	ba a1 00 00 00       	mov    $0xa1,%edx
801032e3:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801032e4:	5d                   	pop    %ebp
801032e5:	c3                   	ret    
801032e6:	66 90                	xchg   %ax,%ax
801032e8:	66 90                	xchg   %ax,%ax
801032ea:	66 90                	xchg   %ax,%ax
801032ec:	66 90                	xchg   %ax,%ax
801032ee:	66 90                	xchg   %ax,%ax

801032f0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801032f0:	55                   	push   %ebp
801032f1:	89 e5                	mov    %esp,%ebp
801032f3:	57                   	push   %edi
801032f4:	56                   	push   %esi
801032f5:	53                   	push   %ebx
801032f6:	83 ec 0c             	sub    $0xc,%esp
801032f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801032fc:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801032ff:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103305:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010330b:	e8 70 da ff ff       	call   80100d80 <filealloc>
80103310:	85 c0                	test   %eax,%eax
80103312:	89 03                	mov    %eax,(%ebx)
80103314:	74 22                	je     80103338 <pipealloc+0x48>
80103316:	e8 65 da ff ff       	call   80100d80 <filealloc>
8010331b:	85 c0                	test   %eax,%eax
8010331d:	89 06                	mov    %eax,(%esi)
8010331f:	74 3f                	je     80103360 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103321:	e8 4a f2 ff ff       	call   80102570 <kalloc>
80103326:	85 c0                	test   %eax,%eax
80103328:	89 c7                	mov    %eax,%edi
8010332a:	75 54                	jne    80103380 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
8010332c:	8b 03                	mov    (%ebx),%eax
8010332e:	85 c0                	test   %eax,%eax
80103330:	75 34                	jne    80103366 <pipealloc+0x76>
80103332:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
80103338:	8b 06                	mov    (%esi),%eax
8010333a:	85 c0                	test   %eax,%eax
8010333c:	74 0c                	je     8010334a <pipealloc+0x5a>
    fileclose(*f1);
8010333e:	83 ec 0c             	sub    $0xc,%esp
80103341:	50                   	push   %eax
80103342:	e8 f9 da ff ff       	call   80100e40 <fileclose>
80103347:	83 c4 10             	add    $0x10,%esp
  return -1;
}
8010334a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010334d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103352:	5b                   	pop    %ebx
80103353:	5e                   	pop    %esi
80103354:	5f                   	pop    %edi
80103355:	5d                   	pop    %ebp
80103356:	c3                   	ret    
80103357:	89 f6                	mov    %esi,%esi
80103359:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
80103360:	8b 03                	mov    (%ebx),%eax
80103362:	85 c0                	test   %eax,%eax
80103364:	74 e4                	je     8010334a <pipealloc+0x5a>
    fileclose(*f0);
80103366:	83 ec 0c             	sub    $0xc,%esp
80103369:	50                   	push   %eax
8010336a:	e8 d1 da ff ff       	call   80100e40 <fileclose>
  if(*f1)
8010336f:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
80103371:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103374:	85 c0                	test   %eax,%eax
80103376:	75 c6                	jne    8010333e <pipealloc+0x4e>
80103378:	eb d0                	jmp    8010334a <pipealloc+0x5a>
8010337a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
80103380:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
80103383:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010338a:	00 00 00 
  p->writeopen = 1;
8010338d:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103394:	00 00 00 
  p->nwrite = 0;
80103397:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010339e:	00 00 00 
  p->nread = 0;
801033a1:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801033a8:	00 00 00 
  initlock(&p->lock, "pipe");
801033ab:	68 f0 74 10 80       	push   $0x801074f0
801033b0:	50                   	push   %eax
801033b1:	e8 fa 0e 00 00       	call   801042b0 <initlock>
  (*f0)->type = FD_PIPE;
801033b6:	8b 03                	mov    (%ebx),%eax
  return 0;
801033b8:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801033bb:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801033c1:	8b 03                	mov    (%ebx),%eax
801033c3:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801033c7:	8b 03                	mov    (%ebx),%eax
801033c9:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801033cd:	8b 03                	mov    (%ebx),%eax
801033cf:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801033d2:	8b 06                	mov    (%esi),%eax
801033d4:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801033da:	8b 06                	mov    (%esi),%eax
801033dc:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801033e0:	8b 06                	mov    (%esi),%eax
801033e2:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801033e6:	8b 06                	mov    (%esi),%eax
801033e8:	89 78 0c             	mov    %edi,0xc(%eax)
}
801033eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801033ee:	31 c0                	xor    %eax,%eax
}
801033f0:	5b                   	pop    %ebx
801033f1:	5e                   	pop    %esi
801033f2:	5f                   	pop    %edi
801033f3:	5d                   	pop    %ebp
801033f4:	c3                   	ret    
801033f5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801033f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103400 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103400:	55                   	push   %ebp
80103401:	89 e5                	mov    %esp,%ebp
80103403:	56                   	push   %esi
80103404:	53                   	push   %ebx
80103405:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103408:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010340b:	83 ec 0c             	sub    $0xc,%esp
8010340e:	53                   	push   %ebx
8010340f:	e8 dc 0f 00 00       	call   801043f0 <acquire>
  if(writable){
80103414:	83 c4 10             	add    $0x10,%esp
80103417:	85 f6                	test   %esi,%esi
80103419:	74 45                	je     80103460 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010341b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103421:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
80103424:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010342b:	00 00 00 
    wakeup(&p->nread);
8010342e:	50                   	push   %eax
8010342f:	e8 ac 0b 00 00       	call   80103fe0 <wakeup>
80103434:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103437:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010343d:	85 d2                	test   %edx,%edx
8010343f:	75 0a                	jne    8010344b <pipeclose+0x4b>
80103441:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103447:	85 c0                	test   %eax,%eax
80103449:	74 35                	je     80103480 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010344b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010344e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103451:	5b                   	pop    %ebx
80103452:	5e                   	pop    %esi
80103453:	5d                   	pop    %ebp
    release(&p->lock);
80103454:	e9 57 10 00 00       	jmp    801044b0 <release>
80103459:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
80103460:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103466:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
80103469:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103470:	00 00 00 
    wakeup(&p->nwrite);
80103473:	50                   	push   %eax
80103474:	e8 67 0b 00 00       	call   80103fe0 <wakeup>
80103479:	83 c4 10             	add    $0x10,%esp
8010347c:	eb b9                	jmp    80103437 <pipeclose+0x37>
8010347e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103480:	83 ec 0c             	sub    $0xc,%esp
80103483:	53                   	push   %ebx
80103484:	e8 27 10 00 00       	call   801044b0 <release>
    kfree((char*)p);
80103489:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010348c:	83 c4 10             	add    $0x10,%esp
}
8010348f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103492:	5b                   	pop    %ebx
80103493:	5e                   	pop    %esi
80103494:	5d                   	pop    %ebp
    kfree((char*)p);
80103495:	e9 26 ef ff ff       	jmp    801023c0 <kfree>
8010349a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801034a0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801034a0:	55                   	push   %ebp
801034a1:	89 e5                	mov    %esp,%ebp
801034a3:	57                   	push   %edi
801034a4:	56                   	push   %esi
801034a5:	53                   	push   %ebx
801034a6:	83 ec 28             	sub    $0x28,%esp
801034a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801034ac:	53                   	push   %ebx
801034ad:	e8 3e 0f 00 00       	call   801043f0 <acquire>
  for(i = 0; i < n; i++){
801034b2:	8b 45 10             	mov    0x10(%ebp),%eax
801034b5:	83 c4 10             	add    $0x10,%esp
801034b8:	85 c0                	test   %eax,%eax
801034ba:	0f 8e c9 00 00 00    	jle    80103589 <pipewrite+0xe9>
801034c0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801034c3:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801034c9:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
801034cf:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801034d2:	03 4d 10             	add    0x10(%ebp),%ecx
801034d5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801034d8:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
801034de:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
801034e4:	39 d0                	cmp    %edx,%eax
801034e6:	75 71                	jne    80103559 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
801034e8:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801034ee:	85 c0                	test   %eax,%eax
801034f0:	74 4e                	je     80103540 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801034f2:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
801034f8:	eb 3a                	jmp    80103534 <pipewrite+0x94>
801034fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
80103500:	83 ec 0c             	sub    $0xc,%esp
80103503:	57                   	push   %edi
80103504:	e8 d7 0a 00 00       	call   80103fe0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103509:	5a                   	pop    %edx
8010350a:	59                   	pop    %ecx
8010350b:	53                   	push   %ebx
8010350c:	56                   	push   %esi
8010350d:	e8 1e 09 00 00       	call   80103e30 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103512:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103518:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010351e:	83 c4 10             	add    $0x10,%esp
80103521:	05 00 02 00 00       	add    $0x200,%eax
80103526:	39 c2                	cmp    %eax,%edx
80103528:	75 36                	jne    80103560 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
8010352a:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103530:	85 c0                	test   %eax,%eax
80103532:	74 0c                	je     80103540 <pipewrite+0xa0>
80103534:	e8 57 03 00 00       	call   80103890 <myproc>
80103539:	8b 40 24             	mov    0x24(%eax),%eax
8010353c:	85 c0                	test   %eax,%eax
8010353e:	74 c0                	je     80103500 <pipewrite+0x60>
        release(&p->lock);
80103540:	83 ec 0c             	sub    $0xc,%esp
80103543:	53                   	push   %ebx
80103544:	e8 67 0f 00 00       	call   801044b0 <release>
        return -1;
80103549:	83 c4 10             	add    $0x10,%esp
8010354c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103551:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103554:	5b                   	pop    %ebx
80103555:	5e                   	pop    %esi
80103556:	5f                   	pop    %edi
80103557:	5d                   	pop    %ebp
80103558:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103559:	89 c2                	mov    %eax,%edx
8010355b:	90                   	nop
8010355c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103560:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103563:	8d 42 01             	lea    0x1(%edx),%eax
80103566:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
8010356c:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103572:	83 c6 01             	add    $0x1,%esi
80103575:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
80103579:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010357c:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010357f:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103583:	0f 85 4f ff ff ff    	jne    801034d8 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103589:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
8010358f:	83 ec 0c             	sub    $0xc,%esp
80103592:	50                   	push   %eax
80103593:	e8 48 0a 00 00       	call   80103fe0 <wakeup>
  release(&p->lock);
80103598:	89 1c 24             	mov    %ebx,(%esp)
8010359b:	e8 10 0f 00 00       	call   801044b0 <release>
  return n;
801035a0:	83 c4 10             	add    $0x10,%esp
801035a3:	8b 45 10             	mov    0x10(%ebp),%eax
801035a6:	eb a9                	jmp    80103551 <pipewrite+0xb1>
801035a8:	90                   	nop
801035a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801035b0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801035b0:	55                   	push   %ebp
801035b1:	89 e5                	mov    %esp,%ebp
801035b3:	57                   	push   %edi
801035b4:	56                   	push   %esi
801035b5:	53                   	push   %ebx
801035b6:	83 ec 18             	sub    $0x18,%esp
801035b9:	8b 75 08             	mov    0x8(%ebp),%esi
801035bc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801035bf:	56                   	push   %esi
801035c0:	e8 2b 0e 00 00       	call   801043f0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801035c5:	83 c4 10             	add    $0x10,%esp
801035c8:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801035ce:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801035d4:	75 6a                	jne    80103640 <piperead+0x90>
801035d6:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
801035dc:	85 db                	test   %ebx,%ebx
801035de:	0f 84 c4 00 00 00    	je     801036a8 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801035e4:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801035ea:	eb 2d                	jmp    80103619 <piperead+0x69>
801035ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801035f0:	83 ec 08             	sub    $0x8,%esp
801035f3:	56                   	push   %esi
801035f4:	53                   	push   %ebx
801035f5:	e8 36 08 00 00       	call   80103e30 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801035fa:	83 c4 10             	add    $0x10,%esp
801035fd:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103603:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103609:	75 35                	jne    80103640 <piperead+0x90>
8010360b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103611:	85 d2                	test   %edx,%edx
80103613:	0f 84 8f 00 00 00    	je     801036a8 <piperead+0xf8>
    if(myproc()->killed){
80103619:	e8 72 02 00 00       	call   80103890 <myproc>
8010361e:	8b 48 24             	mov    0x24(%eax),%ecx
80103621:	85 c9                	test   %ecx,%ecx
80103623:	74 cb                	je     801035f0 <piperead+0x40>
      release(&p->lock);
80103625:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103628:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
8010362d:	56                   	push   %esi
8010362e:	e8 7d 0e 00 00       	call   801044b0 <release>
      return -1;
80103633:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103636:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103639:	89 d8                	mov    %ebx,%eax
8010363b:	5b                   	pop    %ebx
8010363c:	5e                   	pop    %esi
8010363d:	5f                   	pop    %edi
8010363e:	5d                   	pop    %ebp
8010363f:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103640:	8b 45 10             	mov    0x10(%ebp),%eax
80103643:	85 c0                	test   %eax,%eax
80103645:	7e 61                	jle    801036a8 <piperead+0xf8>
    if(p->nread == p->nwrite)
80103647:	31 db                	xor    %ebx,%ebx
80103649:	eb 13                	jmp    8010365e <piperead+0xae>
8010364b:	90                   	nop
8010364c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103650:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103656:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
8010365c:	74 1f                	je     8010367d <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
8010365e:	8d 41 01             	lea    0x1(%ecx),%eax
80103661:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80103667:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
8010366d:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
80103672:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103675:	83 c3 01             	add    $0x1,%ebx
80103678:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010367b:	75 d3                	jne    80103650 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010367d:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103683:	83 ec 0c             	sub    $0xc,%esp
80103686:	50                   	push   %eax
80103687:	e8 54 09 00 00       	call   80103fe0 <wakeup>
  release(&p->lock);
8010368c:	89 34 24             	mov    %esi,(%esp)
8010368f:	e8 1c 0e 00 00       	call   801044b0 <release>
  return i;
80103694:	83 c4 10             	add    $0x10,%esp
}
80103697:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010369a:	89 d8                	mov    %ebx,%eax
8010369c:	5b                   	pop    %ebx
8010369d:	5e                   	pop    %esi
8010369e:	5f                   	pop    %edi
8010369f:	5d                   	pop    %ebp
801036a0:	c3                   	ret    
801036a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801036a8:	31 db                	xor    %ebx,%ebx
801036aa:	eb d1                	jmp    8010367d <piperead+0xcd>
801036ac:	66 90                	xchg   %ax,%ax
801036ae:	66 90                	xchg   %ax,%ax

801036b0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801036b0:	55                   	push   %ebp
801036b1:	89 e5                	mov    %esp,%ebp
801036b3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801036b4:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
801036b9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801036bc:	68 20 2d 11 80       	push   $0x80112d20
801036c1:	e8 2a 0d 00 00       	call   801043f0 <acquire>
801036c6:	83 c4 10             	add    $0x10,%esp
801036c9:	eb 10                	jmp    801036db <allocproc+0x2b>
801036cb:	90                   	nop
801036cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801036d0:	83 c3 7c             	add    $0x7c,%ebx
801036d3:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
801036d9:	73 75                	jae    80103750 <allocproc+0xa0>
    if(p->state == UNUSED)
801036db:	8b 43 0c             	mov    0xc(%ebx),%eax
801036de:	85 c0                	test   %eax,%eax
801036e0:	75 ee                	jne    801036d0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801036e2:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
801036e7:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801036ea:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
801036f1:	8d 50 01             	lea    0x1(%eax),%edx
801036f4:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
801036f7:	68 20 2d 11 80       	push   $0x80112d20
  p->pid = nextpid++;
801036fc:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
80103702:	e8 a9 0d 00 00       	call   801044b0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103707:	e8 64 ee ff ff       	call   80102570 <kalloc>
8010370c:	83 c4 10             	add    $0x10,%esp
8010370f:	85 c0                	test   %eax,%eax
80103711:	89 43 08             	mov    %eax,0x8(%ebx)
80103714:	74 53                	je     80103769 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103716:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010371c:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010371f:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103724:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103727:	c7 40 14 32 57 10 80 	movl   $0x80105732,0x14(%eax)
  p->context = (struct context*)sp;
8010372e:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103731:	6a 14                	push   $0x14
80103733:	6a 00                	push   $0x0
80103735:	50                   	push   %eax
80103736:	e8 c5 0d 00 00       	call   80104500 <memset>
  p->context->eip = (uint)forkret;
8010373b:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
8010373e:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103741:	c7 40 10 80 37 10 80 	movl   $0x80103780,0x10(%eax)
}
80103748:	89 d8                	mov    %ebx,%eax
8010374a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010374d:	c9                   	leave  
8010374e:	c3                   	ret    
8010374f:	90                   	nop
  release(&ptable.lock);
80103750:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103753:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103755:	68 20 2d 11 80       	push   $0x80112d20
8010375a:	e8 51 0d 00 00       	call   801044b0 <release>
}
8010375f:	89 d8                	mov    %ebx,%eax
  return 0;
80103761:	83 c4 10             	add    $0x10,%esp
}
80103764:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103767:	c9                   	leave  
80103768:	c3                   	ret    
    p->state = UNUSED;
80103769:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103770:	31 db                	xor    %ebx,%ebx
80103772:	eb d4                	jmp    80103748 <allocproc+0x98>
80103774:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010377a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103780 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103780:	55                   	push   %ebp
80103781:	89 e5                	mov    %esp,%ebp
80103783:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103786:	68 20 2d 11 80       	push   $0x80112d20
8010378b:	e8 20 0d 00 00       	call   801044b0 <release>

  if (first) {
80103790:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80103795:	83 c4 10             	add    $0x10,%esp
80103798:	85 c0                	test   %eax,%eax
8010379a:	75 04                	jne    801037a0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010379c:	c9                   	leave  
8010379d:	c3                   	ret    
8010379e:	66 90                	xchg   %ax,%ax
    iinit(ROOTDEV);
801037a0:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
801037a3:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
801037aa:	00 00 00 
    iinit(ROOTDEV);
801037ad:	6a 01                	push   $0x1
801037af:	e8 dc dc ff ff       	call   80101490 <iinit>
    initlog(ROOTDEV);
801037b4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801037bb:	e8 f0 f3 ff ff       	call   80102bb0 <initlog>
801037c0:	83 c4 10             	add    $0x10,%esp
}
801037c3:	c9                   	leave  
801037c4:	c3                   	ret    
801037c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801037d0 <pinit>:
{
801037d0:	55                   	push   %ebp
801037d1:	89 e5                	mov    %esp,%ebp
801037d3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801037d6:	68 f5 74 10 80       	push   $0x801074f5
801037db:	68 20 2d 11 80       	push   $0x80112d20
801037e0:	e8 cb 0a 00 00       	call   801042b0 <initlock>
}
801037e5:	83 c4 10             	add    $0x10,%esp
801037e8:	c9                   	leave  
801037e9:	c3                   	ret    
801037ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801037f0 <mycpu>:
{
801037f0:	55                   	push   %ebp
801037f1:	89 e5                	mov    %esp,%ebp
801037f3:	56                   	push   %esi
801037f4:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801037f5:	9c                   	pushf  
801037f6:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801037f7:	f6 c4 02             	test   $0x2,%ah
801037fa:	75 5e                	jne    8010385a <mycpu+0x6a>
  apicid = lapicid();
801037fc:	e8 df ef ff ff       	call   801027e0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103801:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
80103807:	85 f6                	test   %esi,%esi
80103809:	7e 42                	jle    8010384d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
8010380b:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
80103812:	39 d0                	cmp    %edx,%eax
80103814:	74 30                	je     80103846 <mycpu+0x56>
80103816:	b9 30 28 11 80       	mov    $0x80112830,%ecx
  for (i = 0; i < ncpu; ++i) {
8010381b:	31 d2                	xor    %edx,%edx
8010381d:	8d 76 00             	lea    0x0(%esi),%esi
80103820:	83 c2 01             	add    $0x1,%edx
80103823:	39 f2                	cmp    %esi,%edx
80103825:	74 26                	je     8010384d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103827:	0f b6 19             	movzbl (%ecx),%ebx
8010382a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103830:	39 c3                	cmp    %eax,%ebx
80103832:	75 ec                	jne    80103820 <mycpu+0x30>
80103834:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
8010383a:	05 80 27 11 80       	add    $0x80112780,%eax
}
8010383f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103842:	5b                   	pop    %ebx
80103843:	5e                   	pop    %esi
80103844:	5d                   	pop    %ebp
80103845:	c3                   	ret    
    if (cpus[i].apicid == apicid)
80103846:	b8 80 27 11 80       	mov    $0x80112780,%eax
      return &cpus[i];
8010384b:	eb f2                	jmp    8010383f <mycpu+0x4f>
  panic("unknown apicid\n");
8010384d:	83 ec 0c             	sub    $0xc,%esp
80103850:	68 fc 74 10 80       	push   $0x801074fc
80103855:	e8 36 cb ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
8010385a:	83 ec 0c             	sub    $0xc,%esp
8010385d:	68 d8 75 10 80       	push   $0x801075d8
80103862:	e8 29 cb ff ff       	call   80100390 <panic>
80103867:	89 f6                	mov    %esi,%esi
80103869:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103870 <cpuid>:
cpuid() {
80103870:	55                   	push   %ebp
80103871:	89 e5                	mov    %esp,%ebp
80103873:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103876:	e8 75 ff ff ff       	call   801037f0 <mycpu>
8010387b:	2d 80 27 11 80       	sub    $0x80112780,%eax
}
80103880:	c9                   	leave  
  return mycpu()-cpus;
80103881:	c1 f8 04             	sar    $0x4,%eax
80103884:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010388a:	c3                   	ret    
8010388b:	90                   	nop
8010388c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103890 <myproc>:
myproc(void) {
80103890:	55                   	push   %ebp
80103891:	89 e5                	mov    %esp,%ebp
80103893:	53                   	push   %ebx
80103894:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103897:	e8 84 0a 00 00       	call   80104320 <pushcli>
  c = mycpu();
8010389c:	e8 4f ff ff ff       	call   801037f0 <mycpu>
  p = c->proc;
801038a1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801038a7:	e8 b4 0a 00 00       	call   80104360 <popcli>
}
801038ac:	83 c4 04             	add    $0x4,%esp
801038af:	89 d8                	mov    %ebx,%eax
801038b1:	5b                   	pop    %ebx
801038b2:	5d                   	pop    %ebp
801038b3:	c3                   	ret    
801038b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801038ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801038c0 <userinit>:
{
801038c0:	55                   	push   %ebp
801038c1:	89 e5                	mov    %esp,%ebp
801038c3:	53                   	push   %ebx
801038c4:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
801038c7:	e8 e4 fd ff ff       	call   801036b0 <allocproc>
801038cc:	89 c3                	mov    %eax,%ebx
  initproc = p;
801038ce:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  if((p->pgdir = setupkvm()) == 0)
801038d3:	e8 28 34 00 00       	call   80106d00 <setupkvm>
801038d8:	85 c0                	test   %eax,%eax
801038da:	89 43 04             	mov    %eax,0x4(%ebx)
801038dd:	0f 84 bd 00 00 00    	je     801039a0 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801038e3:	83 ec 04             	sub    $0x4,%esp
801038e6:	68 2c 00 00 00       	push   $0x2c
801038eb:	68 60 a4 10 80       	push   $0x8010a460
801038f0:	50                   	push   %eax
801038f1:	e8 ea 30 00 00       	call   801069e0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
801038f6:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
801038f9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801038ff:	6a 4c                	push   $0x4c
80103901:	6a 00                	push   $0x0
80103903:	ff 73 18             	pushl  0x18(%ebx)
80103906:	e8 f5 0b 00 00       	call   80104500 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010390b:	8b 43 18             	mov    0x18(%ebx),%eax
8010390e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103913:	b9 23 00 00 00       	mov    $0x23,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103918:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010391b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010391f:	8b 43 18             	mov    0x18(%ebx),%eax
80103922:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103926:	8b 43 18             	mov    0x18(%ebx),%eax
80103929:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010392d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103931:	8b 43 18             	mov    0x18(%ebx),%eax
80103934:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103938:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010393c:	8b 43 18             	mov    0x18(%ebx),%eax
8010393f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103946:	8b 43 18             	mov    0x18(%ebx),%eax
80103949:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103950:	8b 43 18             	mov    0x18(%ebx),%eax
80103953:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
8010395a:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010395d:	6a 10                	push   $0x10
8010395f:	68 25 75 10 80       	push   $0x80107525
80103964:	50                   	push   %eax
80103965:	e8 76 0d 00 00       	call   801046e0 <safestrcpy>
  p->cwd = namei("/");
8010396a:	c7 04 24 2e 75 10 80 	movl   $0x8010752e,(%esp)
80103971:	e8 1a e6 ff ff       	call   80101f90 <namei>
80103976:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103979:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103980:	e8 6b 0a 00 00       	call   801043f0 <acquire>
  p->state = RUNNABLE;
80103985:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
8010398c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103993:	e8 18 0b 00 00       	call   801044b0 <release>
}
80103998:	83 c4 10             	add    $0x10,%esp
8010399b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010399e:	c9                   	leave  
8010399f:	c3                   	ret    
    panic("userinit: out of memory?");
801039a0:	83 ec 0c             	sub    $0xc,%esp
801039a3:	68 0c 75 10 80       	push   $0x8010750c
801039a8:	e8 e3 c9 ff ff       	call   80100390 <panic>
801039ad:	8d 76 00             	lea    0x0(%esi),%esi

801039b0 <growproc>:
{
801039b0:	55                   	push   %ebp
801039b1:	89 e5                	mov    %esp,%ebp
801039b3:	56                   	push   %esi
801039b4:	53                   	push   %ebx
801039b5:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
801039b8:	e8 63 09 00 00       	call   80104320 <pushcli>
  c = mycpu();
801039bd:	e8 2e fe ff ff       	call   801037f0 <mycpu>
  p = c->proc;
801039c2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801039c8:	e8 93 09 00 00       	call   80104360 <popcli>
  if(n > 0){
801039cd:	83 fe 00             	cmp    $0x0,%esi
  sz = curproc->sz;
801039d0:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
801039d2:	7f 1c                	jg     801039f0 <growproc+0x40>
  } else if(n < 0){
801039d4:	75 3a                	jne    80103a10 <growproc+0x60>
  switchuvm(curproc);
801039d6:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
801039d9:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
801039db:	53                   	push   %ebx
801039dc:	e8 ef 2e 00 00       	call   801068d0 <switchuvm>
  return 0;
801039e1:	83 c4 10             	add    $0x10,%esp
801039e4:	31 c0                	xor    %eax,%eax
}
801039e6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801039e9:	5b                   	pop    %ebx
801039ea:	5e                   	pop    %esi
801039eb:	5d                   	pop    %ebp
801039ec:	c3                   	ret    
801039ed:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
801039f0:	83 ec 04             	sub    $0x4,%esp
801039f3:	01 c6                	add    %eax,%esi
801039f5:	56                   	push   %esi
801039f6:	50                   	push   %eax
801039f7:	ff 73 04             	pushl  0x4(%ebx)
801039fa:	e8 21 31 00 00       	call   80106b20 <allocuvm>
801039ff:	83 c4 10             	add    $0x10,%esp
80103a02:	85 c0                	test   %eax,%eax
80103a04:	75 d0                	jne    801039d6 <growproc+0x26>
      return -1;
80103a06:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103a0b:	eb d9                	jmp    801039e6 <growproc+0x36>
80103a0d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103a10:	83 ec 04             	sub    $0x4,%esp
80103a13:	01 c6                	add    %eax,%esi
80103a15:	56                   	push   %esi
80103a16:	50                   	push   %eax
80103a17:	ff 73 04             	pushl  0x4(%ebx)
80103a1a:	e8 31 32 00 00       	call   80106c50 <deallocuvm>
80103a1f:	83 c4 10             	add    $0x10,%esp
80103a22:	85 c0                	test   %eax,%eax
80103a24:	75 b0                	jne    801039d6 <growproc+0x26>
80103a26:	eb de                	jmp    80103a06 <growproc+0x56>
80103a28:	90                   	nop
80103a29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103a30 <fork>:
{
80103a30:	55                   	push   %ebp
80103a31:	89 e5                	mov    %esp,%ebp
80103a33:	57                   	push   %edi
80103a34:	56                   	push   %esi
80103a35:	53                   	push   %ebx
80103a36:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103a39:	e8 e2 08 00 00       	call   80104320 <pushcli>
  c = mycpu();
80103a3e:	e8 ad fd ff ff       	call   801037f0 <mycpu>
  p = c->proc;
80103a43:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103a49:	e8 12 09 00 00       	call   80104360 <popcli>
  if((np = allocproc()) == 0){
80103a4e:	e8 5d fc ff ff       	call   801036b0 <allocproc>
80103a53:	85 c0                	test   %eax,%eax
80103a55:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103a58:	0f 84 b7 00 00 00    	je     80103b15 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103a5e:	83 ec 08             	sub    $0x8,%esp
80103a61:	ff 33                	pushl  (%ebx)
80103a63:	ff 73 04             	pushl  0x4(%ebx)
80103a66:	89 c7                	mov    %eax,%edi
80103a68:	e8 63 33 00 00       	call   80106dd0 <copyuvm>
80103a6d:	83 c4 10             	add    $0x10,%esp
80103a70:	85 c0                	test   %eax,%eax
80103a72:	89 47 04             	mov    %eax,0x4(%edi)
80103a75:	0f 84 a1 00 00 00    	je     80103b1c <fork+0xec>
  np->sz = curproc->sz;
80103a7b:	8b 03                	mov    (%ebx),%eax
80103a7d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103a80:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
80103a82:	89 59 14             	mov    %ebx,0x14(%ecx)
80103a85:	89 c8                	mov    %ecx,%eax
  *np->tf = *curproc->tf;
80103a87:	8b 79 18             	mov    0x18(%ecx),%edi
80103a8a:	8b 73 18             	mov    0x18(%ebx),%esi
80103a8d:	b9 13 00 00 00       	mov    $0x13,%ecx
80103a92:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103a94:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103a96:	8b 40 18             	mov    0x18(%eax),%eax
80103a99:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103aa0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103aa4:	85 c0                	test   %eax,%eax
80103aa6:	74 13                	je     80103abb <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103aa8:	83 ec 0c             	sub    $0xc,%esp
80103aab:	50                   	push   %eax
80103aac:	e8 3f d3 ff ff       	call   80100df0 <filedup>
80103ab1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103ab4:	83 c4 10             	add    $0x10,%esp
80103ab7:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103abb:	83 c6 01             	add    $0x1,%esi
80103abe:	83 fe 10             	cmp    $0x10,%esi
80103ac1:	75 dd                	jne    80103aa0 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103ac3:	83 ec 0c             	sub    $0xc,%esp
80103ac6:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103ac9:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103acc:	e8 8f db ff ff       	call   80101660 <idup>
80103ad1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103ad4:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103ad7:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103ada:	8d 47 6c             	lea    0x6c(%edi),%eax
80103add:	6a 10                	push   $0x10
80103adf:	53                   	push   %ebx
80103ae0:	50                   	push   %eax
80103ae1:	e8 fa 0b 00 00       	call   801046e0 <safestrcpy>
  pid = np->pid;
80103ae6:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103ae9:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103af0:	e8 fb 08 00 00       	call   801043f0 <acquire>
  np->state = RUNNABLE;
80103af5:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103afc:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103b03:	e8 a8 09 00 00       	call   801044b0 <release>
  return pid;
80103b08:	83 c4 10             	add    $0x10,%esp
}
80103b0b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103b0e:	89 d8                	mov    %ebx,%eax
80103b10:	5b                   	pop    %ebx
80103b11:	5e                   	pop    %esi
80103b12:	5f                   	pop    %edi
80103b13:	5d                   	pop    %ebp
80103b14:	c3                   	ret    
    return -1;
80103b15:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103b1a:	eb ef                	jmp    80103b0b <fork+0xdb>
    kfree(np->kstack);
80103b1c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103b1f:	83 ec 0c             	sub    $0xc,%esp
80103b22:	ff 73 08             	pushl  0x8(%ebx)
80103b25:	e8 96 e8 ff ff       	call   801023c0 <kfree>
    np->kstack = 0;
80103b2a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
80103b31:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103b38:	83 c4 10             	add    $0x10,%esp
80103b3b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103b40:	eb c9                	jmp    80103b0b <fork+0xdb>
80103b42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103b50 <scheduler>:
{
80103b50:	55                   	push   %ebp
80103b51:	89 e5                	mov    %esp,%ebp
80103b53:	57                   	push   %edi
80103b54:	56                   	push   %esi
80103b55:	53                   	push   %ebx
80103b56:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103b59:	e8 92 fc ff ff       	call   801037f0 <mycpu>
80103b5e:	8d 78 04             	lea    0x4(%eax),%edi
80103b61:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103b63:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103b6a:	00 00 00 
80103b6d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103b70:	fb                   	sti    
    acquire(&ptable.lock);
80103b71:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b74:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
    acquire(&ptable.lock);
80103b79:	68 20 2d 11 80       	push   $0x80112d20
80103b7e:	e8 6d 08 00 00       	call   801043f0 <acquire>
80103b83:	83 c4 10             	add    $0x10,%esp
80103b86:	8d 76 00             	lea    0x0(%esi),%esi
80103b89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      if(p->state != RUNNABLE)
80103b90:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103b94:	75 33                	jne    80103bc9 <scheduler+0x79>
      switchuvm(p);
80103b96:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103b99:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103b9f:	53                   	push   %ebx
80103ba0:	e8 2b 2d 00 00       	call   801068d0 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103ba5:	58                   	pop    %eax
80103ba6:	5a                   	pop    %edx
80103ba7:	ff 73 1c             	pushl  0x1c(%ebx)
80103baa:	57                   	push   %edi
      p->state = RUNNING;
80103bab:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103bb2:	e8 84 0b 00 00       	call   8010473b <swtch>
      switchkvm();
80103bb7:	e8 f4 2c 00 00       	call   801068b0 <switchkvm>
      c->proc = 0;
80103bbc:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103bc3:	00 00 00 
80103bc6:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103bc9:	83 c3 7c             	add    $0x7c,%ebx
80103bcc:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80103bd2:	72 bc                	jb     80103b90 <scheduler+0x40>
    release(&ptable.lock);
80103bd4:	83 ec 0c             	sub    $0xc,%esp
80103bd7:	68 20 2d 11 80       	push   $0x80112d20
80103bdc:	e8 cf 08 00 00       	call   801044b0 <release>
    sti();
80103be1:	83 c4 10             	add    $0x10,%esp
80103be4:	eb 8a                	jmp    80103b70 <scheduler+0x20>
80103be6:	8d 76 00             	lea    0x0(%esi),%esi
80103be9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103bf0 <sched>:
{
80103bf0:	55                   	push   %ebp
80103bf1:	89 e5                	mov    %esp,%ebp
80103bf3:	56                   	push   %esi
80103bf4:	53                   	push   %ebx
  pushcli();
80103bf5:	e8 26 07 00 00       	call   80104320 <pushcli>
  c = mycpu();
80103bfa:	e8 f1 fb ff ff       	call   801037f0 <mycpu>
  p = c->proc;
80103bff:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c05:	e8 56 07 00 00       	call   80104360 <popcli>
  if(!holding(&ptable.lock))
80103c0a:	83 ec 0c             	sub    $0xc,%esp
80103c0d:	68 20 2d 11 80       	push   $0x80112d20
80103c12:	e8 a9 07 00 00       	call   801043c0 <holding>
80103c17:	83 c4 10             	add    $0x10,%esp
80103c1a:	85 c0                	test   %eax,%eax
80103c1c:	74 4f                	je     80103c6d <sched+0x7d>
  if(mycpu()->ncli != 1)
80103c1e:	e8 cd fb ff ff       	call   801037f0 <mycpu>
80103c23:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103c2a:	75 68                	jne    80103c94 <sched+0xa4>
  if(p->state == RUNNING)
80103c2c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103c30:	74 55                	je     80103c87 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103c32:	9c                   	pushf  
80103c33:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103c34:	f6 c4 02             	test   $0x2,%ah
80103c37:	75 41                	jne    80103c7a <sched+0x8a>
  intena = mycpu()->intena;
80103c39:	e8 b2 fb ff ff       	call   801037f0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103c3e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103c41:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103c47:	e8 a4 fb ff ff       	call   801037f0 <mycpu>
80103c4c:	83 ec 08             	sub    $0x8,%esp
80103c4f:	ff 70 04             	pushl  0x4(%eax)
80103c52:	53                   	push   %ebx
80103c53:	e8 e3 0a 00 00       	call   8010473b <swtch>
  mycpu()->intena = intena;
80103c58:	e8 93 fb ff ff       	call   801037f0 <mycpu>
}
80103c5d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103c60:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103c66:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103c69:	5b                   	pop    %ebx
80103c6a:	5e                   	pop    %esi
80103c6b:	5d                   	pop    %ebp
80103c6c:	c3                   	ret    
    panic("sched ptable.lock");
80103c6d:	83 ec 0c             	sub    $0xc,%esp
80103c70:	68 30 75 10 80       	push   $0x80107530
80103c75:	e8 16 c7 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
80103c7a:	83 ec 0c             	sub    $0xc,%esp
80103c7d:	68 5c 75 10 80       	push   $0x8010755c
80103c82:	e8 09 c7 ff ff       	call   80100390 <panic>
    panic("sched running");
80103c87:	83 ec 0c             	sub    $0xc,%esp
80103c8a:	68 4e 75 10 80       	push   $0x8010754e
80103c8f:	e8 fc c6 ff ff       	call   80100390 <panic>
    panic("sched locks");
80103c94:	83 ec 0c             	sub    $0xc,%esp
80103c97:	68 42 75 10 80       	push   $0x80107542
80103c9c:	e8 ef c6 ff ff       	call   80100390 <panic>
80103ca1:	eb 0d                	jmp    80103cb0 <exit>
80103ca3:	90                   	nop
80103ca4:	90                   	nop
80103ca5:	90                   	nop
80103ca6:	90                   	nop
80103ca7:	90                   	nop
80103ca8:	90                   	nop
80103ca9:	90                   	nop
80103caa:	90                   	nop
80103cab:	90                   	nop
80103cac:	90                   	nop
80103cad:	90                   	nop
80103cae:	90                   	nop
80103caf:	90                   	nop

80103cb0 <exit>:
{
80103cb0:	55                   	push   %ebp
80103cb1:	89 e5                	mov    %esp,%ebp
80103cb3:	57                   	push   %edi
80103cb4:	56                   	push   %esi
80103cb5:	53                   	push   %ebx
80103cb6:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80103cb9:	e8 62 06 00 00       	call   80104320 <pushcli>
  c = mycpu();
80103cbe:	e8 2d fb ff ff       	call   801037f0 <mycpu>
  p = c->proc;
80103cc3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103cc9:	e8 92 06 00 00       	call   80104360 <popcli>
  if(curproc == initproc)
80103cce:	39 35 b8 a5 10 80    	cmp    %esi,0x8010a5b8
80103cd4:	8d 5e 28             	lea    0x28(%esi),%ebx
80103cd7:	8d 7e 68             	lea    0x68(%esi),%edi
80103cda:	0f 84 e7 00 00 00    	je     80103dc7 <exit+0x117>
    if(curproc->ofile[fd]){
80103ce0:	8b 03                	mov    (%ebx),%eax
80103ce2:	85 c0                	test   %eax,%eax
80103ce4:	74 12                	je     80103cf8 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80103ce6:	83 ec 0c             	sub    $0xc,%esp
80103ce9:	50                   	push   %eax
80103cea:	e8 51 d1 ff ff       	call   80100e40 <fileclose>
      curproc->ofile[fd] = 0;
80103cef:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103cf5:	83 c4 10             	add    $0x10,%esp
80103cf8:	83 c3 04             	add    $0x4,%ebx
  for(fd = 0; fd < NOFILE; fd++){
80103cfb:	39 fb                	cmp    %edi,%ebx
80103cfd:	75 e1                	jne    80103ce0 <exit+0x30>
  begin_op();
80103cff:	e8 4c ef ff ff       	call   80102c50 <begin_op>
  iput(curproc->cwd);
80103d04:	83 ec 0c             	sub    $0xc,%esp
80103d07:	ff 76 68             	pushl  0x68(%esi)
80103d0a:	e8 b1 da ff ff       	call   801017c0 <iput>
  end_op();
80103d0f:	e8 ac ef ff ff       	call   80102cc0 <end_op>
  curproc->cwd = 0;
80103d14:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80103d1b:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103d22:	e8 c9 06 00 00       	call   801043f0 <acquire>
  wakeup1(curproc->parent);
80103d27:	8b 56 14             	mov    0x14(%esi),%edx
80103d2a:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d2d:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103d32:	eb 0e                	jmp    80103d42 <exit+0x92>
80103d34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d38:	83 c0 7c             	add    $0x7c,%eax
80103d3b:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103d40:	73 1c                	jae    80103d5e <exit+0xae>
    if(p->state == SLEEPING && p->chan == chan)
80103d42:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103d46:	75 f0                	jne    80103d38 <exit+0x88>
80103d48:	3b 50 20             	cmp    0x20(%eax),%edx
80103d4b:	75 eb                	jne    80103d38 <exit+0x88>
      p->state = RUNNABLE;
80103d4d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d54:	83 c0 7c             	add    $0x7c,%eax
80103d57:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103d5c:	72 e4                	jb     80103d42 <exit+0x92>
      p->parent = initproc;
80103d5e:	8b 0d b8 a5 10 80    	mov    0x8010a5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d64:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103d69:	eb 10                	jmp    80103d7b <exit+0xcb>
80103d6b:	90                   	nop
80103d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d70:	83 c2 7c             	add    $0x7c,%edx
80103d73:	81 fa 54 4c 11 80    	cmp    $0x80114c54,%edx
80103d79:	73 33                	jae    80103dae <exit+0xfe>
    if(p->parent == curproc){
80103d7b:	39 72 14             	cmp    %esi,0x14(%edx)
80103d7e:	75 f0                	jne    80103d70 <exit+0xc0>
      if(p->state == ZOMBIE)
80103d80:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103d84:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103d87:	75 e7                	jne    80103d70 <exit+0xc0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d89:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103d8e:	eb 0a                	jmp    80103d9a <exit+0xea>
80103d90:	83 c0 7c             	add    $0x7c,%eax
80103d93:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103d98:	73 d6                	jae    80103d70 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
80103d9a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103d9e:	75 f0                	jne    80103d90 <exit+0xe0>
80103da0:	3b 48 20             	cmp    0x20(%eax),%ecx
80103da3:	75 eb                	jne    80103d90 <exit+0xe0>
      p->state = RUNNABLE;
80103da5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103dac:	eb e2                	jmp    80103d90 <exit+0xe0>
  curproc->state = ZOMBIE;
80103dae:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80103db5:	e8 36 fe ff ff       	call   80103bf0 <sched>
  panic("zombie exit");
80103dba:	83 ec 0c             	sub    $0xc,%esp
80103dbd:	68 7d 75 10 80       	push   $0x8010757d
80103dc2:	e8 c9 c5 ff ff       	call   80100390 <panic>
    panic("init exiting");
80103dc7:	83 ec 0c             	sub    $0xc,%esp
80103dca:	68 70 75 10 80       	push   $0x80107570
80103dcf:	e8 bc c5 ff ff       	call   80100390 <panic>
80103dd4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103dda:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103de0 <yield>:
{
80103de0:	55                   	push   %ebp
80103de1:	89 e5                	mov    %esp,%ebp
80103de3:	53                   	push   %ebx
80103de4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103de7:	68 20 2d 11 80       	push   $0x80112d20
80103dec:	e8 ff 05 00 00       	call   801043f0 <acquire>
  pushcli();
80103df1:	e8 2a 05 00 00       	call   80104320 <pushcli>
  c = mycpu();
80103df6:	e8 f5 f9 ff ff       	call   801037f0 <mycpu>
  p = c->proc;
80103dfb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e01:	e8 5a 05 00 00       	call   80104360 <popcli>
  myproc()->state = RUNNABLE;
80103e06:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80103e0d:	e8 de fd ff ff       	call   80103bf0 <sched>
  release(&ptable.lock);
80103e12:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e19:	e8 92 06 00 00       	call   801044b0 <release>
}
80103e1e:	83 c4 10             	add    $0x10,%esp
80103e21:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103e24:	c9                   	leave  
80103e25:	c3                   	ret    
80103e26:	8d 76 00             	lea    0x0(%esi),%esi
80103e29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103e30 <sleep>:
{
80103e30:	55                   	push   %ebp
80103e31:	89 e5                	mov    %esp,%ebp
80103e33:	57                   	push   %edi
80103e34:	56                   	push   %esi
80103e35:	53                   	push   %ebx
80103e36:	83 ec 0c             	sub    $0xc,%esp
80103e39:	8b 7d 08             	mov    0x8(%ebp),%edi
80103e3c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80103e3f:	e8 dc 04 00 00       	call   80104320 <pushcli>
  c = mycpu();
80103e44:	e8 a7 f9 ff ff       	call   801037f0 <mycpu>
  p = c->proc;
80103e49:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e4f:	e8 0c 05 00 00       	call   80104360 <popcli>
  if(p == 0)
80103e54:	85 db                	test   %ebx,%ebx
80103e56:	0f 84 87 00 00 00    	je     80103ee3 <sleep+0xb3>
  if(lk == 0)
80103e5c:	85 f6                	test   %esi,%esi
80103e5e:	74 76                	je     80103ed6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103e60:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80103e66:	74 50                	je     80103eb8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103e68:	83 ec 0c             	sub    $0xc,%esp
80103e6b:	68 20 2d 11 80       	push   $0x80112d20
80103e70:	e8 7b 05 00 00       	call   801043f0 <acquire>
    release(lk);
80103e75:	89 34 24             	mov    %esi,(%esp)
80103e78:	e8 33 06 00 00       	call   801044b0 <release>
  p->chan = chan;
80103e7d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103e80:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103e87:	e8 64 fd ff ff       	call   80103bf0 <sched>
  p->chan = 0;
80103e8c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80103e93:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e9a:	e8 11 06 00 00       	call   801044b0 <release>
    acquire(lk);
80103e9f:	89 75 08             	mov    %esi,0x8(%ebp)
80103ea2:	83 c4 10             	add    $0x10,%esp
}
80103ea5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ea8:	5b                   	pop    %ebx
80103ea9:	5e                   	pop    %esi
80103eaa:	5f                   	pop    %edi
80103eab:	5d                   	pop    %ebp
    acquire(lk);
80103eac:	e9 3f 05 00 00       	jmp    801043f0 <acquire>
80103eb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80103eb8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103ebb:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103ec2:	e8 29 fd ff ff       	call   80103bf0 <sched>
  p->chan = 0;
80103ec7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80103ece:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ed1:	5b                   	pop    %ebx
80103ed2:	5e                   	pop    %esi
80103ed3:	5f                   	pop    %edi
80103ed4:	5d                   	pop    %ebp
80103ed5:	c3                   	ret    
    panic("sleep without lk");
80103ed6:	83 ec 0c             	sub    $0xc,%esp
80103ed9:	68 8f 75 10 80       	push   $0x8010758f
80103ede:	e8 ad c4 ff ff       	call   80100390 <panic>
    panic("sleep");
80103ee3:	83 ec 0c             	sub    $0xc,%esp
80103ee6:	68 89 75 10 80       	push   $0x80107589
80103eeb:	e8 a0 c4 ff ff       	call   80100390 <panic>

80103ef0 <wait>:
{
80103ef0:	55                   	push   %ebp
80103ef1:	89 e5                	mov    %esp,%ebp
80103ef3:	56                   	push   %esi
80103ef4:	53                   	push   %ebx
  pushcli();
80103ef5:	e8 26 04 00 00       	call   80104320 <pushcli>
  c = mycpu();
80103efa:	e8 f1 f8 ff ff       	call   801037f0 <mycpu>
  p = c->proc;
80103eff:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103f05:	e8 56 04 00 00       	call   80104360 <popcli>
  acquire(&ptable.lock);
80103f0a:	83 ec 0c             	sub    $0xc,%esp
80103f0d:	68 20 2d 11 80       	push   $0x80112d20
80103f12:	e8 d9 04 00 00       	call   801043f0 <acquire>
80103f17:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80103f1a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f1c:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103f21:	eb 10                	jmp    80103f33 <wait+0x43>
80103f23:	90                   	nop
80103f24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f28:	83 c3 7c             	add    $0x7c,%ebx
80103f2b:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80103f31:	73 1b                	jae    80103f4e <wait+0x5e>
      if(p->parent != curproc)
80103f33:	39 73 14             	cmp    %esi,0x14(%ebx)
80103f36:	75 f0                	jne    80103f28 <wait+0x38>
      if(p->state == ZOMBIE){
80103f38:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103f3c:	74 32                	je     80103f70 <wait+0x80>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f3e:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
80103f41:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f46:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80103f4c:	72 e5                	jb     80103f33 <wait+0x43>
    if(!havekids || curproc->killed){
80103f4e:	85 c0                	test   %eax,%eax
80103f50:	74 74                	je     80103fc6 <wait+0xd6>
80103f52:	8b 46 24             	mov    0x24(%esi),%eax
80103f55:	85 c0                	test   %eax,%eax
80103f57:	75 6d                	jne    80103fc6 <wait+0xd6>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103f59:	83 ec 08             	sub    $0x8,%esp
80103f5c:	68 20 2d 11 80       	push   $0x80112d20
80103f61:	56                   	push   %esi
80103f62:	e8 c9 fe ff ff       	call   80103e30 <sleep>
    havekids = 0;
80103f67:	83 c4 10             	add    $0x10,%esp
80103f6a:	eb ae                	jmp    80103f1a <wait+0x2a>
80103f6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        kfree(p->kstack);
80103f70:	83 ec 0c             	sub    $0xc,%esp
80103f73:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
80103f76:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103f79:	e8 42 e4 ff ff       	call   801023c0 <kfree>
        freevm(p->pgdir);
80103f7e:	5a                   	pop    %edx
80103f7f:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
80103f82:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103f89:	e8 f2 2c 00 00       	call   80106c80 <freevm>
        release(&ptable.lock);
80103f8e:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
        p->pid = 0;
80103f95:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103f9c:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103fa3:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103fa7:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103fae:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103fb5:	e8 f6 04 00 00       	call   801044b0 <release>
        return pid;
80103fba:	83 c4 10             	add    $0x10,%esp
}
80103fbd:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103fc0:	89 f0                	mov    %esi,%eax
80103fc2:	5b                   	pop    %ebx
80103fc3:	5e                   	pop    %esi
80103fc4:	5d                   	pop    %ebp
80103fc5:	c3                   	ret    
      release(&ptable.lock);
80103fc6:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103fc9:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80103fce:	68 20 2d 11 80       	push   $0x80112d20
80103fd3:	e8 d8 04 00 00       	call   801044b0 <release>
      return -1;
80103fd8:	83 c4 10             	add    $0x10,%esp
80103fdb:	eb e0                	jmp    80103fbd <wait+0xcd>
80103fdd:	8d 76 00             	lea    0x0(%esi),%esi

80103fe0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80103fe0:	55                   	push   %ebp
80103fe1:	89 e5                	mov    %esp,%ebp
80103fe3:	53                   	push   %ebx
80103fe4:	83 ec 10             	sub    $0x10,%esp
80103fe7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80103fea:	68 20 2d 11 80       	push   $0x80112d20
80103fef:	e8 fc 03 00 00       	call   801043f0 <acquire>
80103ff4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ff7:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103ffc:	eb 0c                	jmp    8010400a <wakeup+0x2a>
80103ffe:	66 90                	xchg   %ax,%ax
80104000:	83 c0 7c             	add    $0x7c,%eax
80104003:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80104008:	73 1c                	jae    80104026 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
8010400a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010400e:	75 f0                	jne    80104000 <wakeup+0x20>
80104010:	3b 58 20             	cmp    0x20(%eax),%ebx
80104013:	75 eb                	jne    80104000 <wakeup+0x20>
      p->state = RUNNABLE;
80104015:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010401c:	83 c0 7c             	add    $0x7c,%eax
8010401f:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80104024:	72 e4                	jb     8010400a <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
80104026:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
8010402d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104030:	c9                   	leave  
  release(&ptable.lock);
80104031:	e9 7a 04 00 00       	jmp    801044b0 <release>
80104036:	8d 76 00             	lea    0x0(%esi),%esi
80104039:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104040 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104040:	55                   	push   %ebp
80104041:	89 e5                	mov    %esp,%ebp
80104043:	53                   	push   %ebx
80104044:	83 ec 10             	sub    $0x10,%esp
80104047:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010404a:	68 20 2d 11 80       	push   $0x80112d20
8010404f:	e8 9c 03 00 00       	call   801043f0 <acquire>
80104054:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104057:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
8010405c:	eb 0c                	jmp    8010406a <kill+0x2a>
8010405e:	66 90                	xchg   %ax,%ax
80104060:	83 c0 7c             	add    $0x7c,%eax
80104063:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80104068:	73 36                	jae    801040a0 <kill+0x60>
    if(p->pid == pid){
8010406a:	39 58 10             	cmp    %ebx,0x10(%eax)
8010406d:	75 f1                	jne    80104060 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010406f:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104073:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010407a:	75 07                	jne    80104083 <kill+0x43>
        p->state = RUNNABLE;
8010407c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104083:	83 ec 0c             	sub    $0xc,%esp
80104086:	68 20 2d 11 80       	push   $0x80112d20
8010408b:	e8 20 04 00 00       	call   801044b0 <release>
      return 0;
80104090:	83 c4 10             	add    $0x10,%esp
80104093:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80104095:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104098:	c9                   	leave  
80104099:	c3                   	ret    
8010409a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
801040a0:	83 ec 0c             	sub    $0xc,%esp
801040a3:	68 20 2d 11 80       	push   $0x80112d20
801040a8:	e8 03 04 00 00       	call   801044b0 <release>
  return -1;
801040ad:	83 c4 10             	add    $0x10,%esp
801040b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801040b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801040b8:	c9                   	leave  
801040b9:	c3                   	ret    
801040ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801040c0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801040c0:	55                   	push   %ebp
801040c1:	89 e5                	mov    %esp,%ebp
801040c3:	57                   	push   %edi
801040c4:	56                   	push   %esi
801040c5:	53                   	push   %ebx
801040c6:	8d 75 e8             	lea    -0x18(%ebp),%esi
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040c9:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
801040ce:	83 ec 3c             	sub    $0x3c,%esp
801040d1:	eb 24                	jmp    801040f7 <procdump+0x37>
801040d3:	90                   	nop
801040d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801040d8:	83 ec 0c             	sub    $0xc,%esp
801040db:	68 17 79 10 80       	push   $0x80107917
801040e0:	e8 7b c5 ff ff       	call   80100660 <cprintf>
801040e5:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040e8:	83 c3 7c             	add    $0x7c,%ebx
801040eb:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
801040f1:	0f 83 81 00 00 00    	jae    80104178 <procdump+0xb8>
    if(p->state == UNUSED)
801040f7:	8b 43 0c             	mov    0xc(%ebx),%eax
801040fa:	85 c0                	test   %eax,%eax
801040fc:	74 ea                	je     801040e8 <procdump+0x28>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801040fe:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
80104101:	ba a0 75 10 80       	mov    $0x801075a0,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104106:	77 11                	ja     80104119 <procdump+0x59>
80104108:	8b 14 85 00 76 10 80 	mov    -0x7fef8a00(,%eax,4),%edx
      state = "???";
8010410f:	b8 a0 75 10 80       	mov    $0x801075a0,%eax
80104114:	85 d2                	test   %edx,%edx
80104116:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104119:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010411c:	50                   	push   %eax
8010411d:	52                   	push   %edx
8010411e:	ff 73 10             	pushl  0x10(%ebx)
80104121:	68 a4 75 10 80       	push   $0x801075a4
80104126:	e8 35 c5 ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
8010412b:	83 c4 10             	add    $0x10,%esp
8010412e:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80104132:	75 a4                	jne    801040d8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104134:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104137:	83 ec 08             	sub    $0x8,%esp
8010413a:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010413d:	50                   	push   %eax
8010413e:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104141:	8b 40 0c             	mov    0xc(%eax),%eax
80104144:	83 c0 08             	add    $0x8,%eax
80104147:	50                   	push   %eax
80104148:	e8 83 01 00 00       	call   801042d0 <getcallerpcs>
8010414d:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104150:	8b 17                	mov    (%edi),%edx
80104152:	85 d2                	test   %edx,%edx
80104154:	74 82                	je     801040d8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104156:	83 ec 08             	sub    $0x8,%esp
80104159:	83 c7 04             	add    $0x4,%edi
8010415c:	52                   	push   %edx
8010415d:	68 e1 6f 10 80       	push   $0x80106fe1
80104162:	e8 f9 c4 ff ff       	call   80100660 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104167:	83 c4 10             	add    $0x10,%esp
8010416a:	39 fe                	cmp    %edi,%esi
8010416c:	75 e2                	jne    80104150 <procdump+0x90>
8010416e:	e9 65 ff ff ff       	jmp    801040d8 <procdump+0x18>
80104173:	90                   	nop
80104174:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
}
80104178:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010417b:	5b                   	pop    %ebx
8010417c:	5e                   	pop    %esi
8010417d:	5f                   	pop    %edi
8010417e:	5d                   	pop    %ebp
8010417f:	c3                   	ret    

80104180 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104180:	55                   	push   %ebp
80104181:	89 e5                	mov    %esp,%ebp
80104183:	53                   	push   %ebx
80104184:	83 ec 0c             	sub    $0xc,%esp
80104187:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010418a:	68 18 76 10 80       	push   $0x80107618
8010418f:	8d 43 04             	lea    0x4(%ebx),%eax
80104192:	50                   	push   %eax
80104193:	e8 18 01 00 00       	call   801042b0 <initlock>
  lk->name = name;
80104198:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010419b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801041a1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
801041a4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
801041ab:	89 43 38             	mov    %eax,0x38(%ebx)
}
801041ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801041b1:	c9                   	leave  
801041b2:	c3                   	ret    
801041b3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801041b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801041c0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801041c0:	55                   	push   %ebp
801041c1:	89 e5                	mov    %esp,%ebp
801041c3:	56                   	push   %esi
801041c4:	53                   	push   %ebx
801041c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801041c8:	83 ec 0c             	sub    $0xc,%esp
801041cb:	8d 73 04             	lea    0x4(%ebx),%esi
801041ce:	56                   	push   %esi
801041cf:	e8 1c 02 00 00       	call   801043f0 <acquire>
  while (lk->locked) {
801041d4:	8b 13                	mov    (%ebx),%edx
801041d6:	83 c4 10             	add    $0x10,%esp
801041d9:	85 d2                	test   %edx,%edx
801041db:	74 16                	je     801041f3 <acquiresleep+0x33>
801041dd:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
801041e0:	83 ec 08             	sub    $0x8,%esp
801041e3:	56                   	push   %esi
801041e4:	53                   	push   %ebx
801041e5:	e8 46 fc ff ff       	call   80103e30 <sleep>
  while (lk->locked) {
801041ea:	8b 03                	mov    (%ebx),%eax
801041ec:	83 c4 10             	add    $0x10,%esp
801041ef:	85 c0                	test   %eax,%eax
801041f1:	75 ed                	jne    801041e0 <acquiresleep+0x20>
  }
  lk->locked = 1;
801041f3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801041f9:	e8 92 f6 ff ff       	call   80103890 <myproc>
801041fe:	8b 40 10             	mov    0x10(%eax),%eax
80104201:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104204:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104207:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010420a:	5b                   	pop    %ebx
8010420b:	5e                   	pop    %esi
8010420c:	5d                   	pop    %ebp
  release(&lk->lk);
8010420d:	e9 9e 02 00 00       	jmp    801044b0 <release>
80104212:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104220 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104220:	55                   	push   %ebp
80104221:	89 e5                	mov    %esp,%ebp
80104223:	56                   	push   %esi
80104224:	53                   	push   %ebx
80104225:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104228:	83 ec 0c             	sub    $0xc,%esp
8010422b:	8d 73 04             	lea    0x4(%ebx),%esi
8010422e:	56                   	push   %esi
8010422f:	e8 bc 01 00 00       	call   801043f0 <acquire>
  lk->locked = 0;
80104234:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010423a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104241:	89 1c 24             	mov    %ebx,(%esp)
80104244:	e8 97 fd ff ff       	call   80103fe0 <wakeup>
  release(&lk->lk);
80104249:	89 75 08             	mov    %esi,0x8(%ebp)
8010424c:	83 c4 10             	add    $0x10,%esp
}
8010424f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104252:	5b                   	pop    %ebx
80104253:	5e                   	pop    %esi
80104254:	5d                   	pop    %ebp
  release(&lk->lk);
80104255:	e9 56 02 00 00       	jmp    801044b0 <release>
8010425a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104260 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104260:	55                   	push   %ebp
80104261:	89 e5                	mov    %esp,%ebp
80104263:	57                   	push   %edi
80104264:	56                   	push   %esi
80104265:	53                   	push   %ebx
80104266:	31 ff                	xor    %edi,%edi
80104268:	83 ec 18             	sub    $0x18,%esp
8010426b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010426e:	8d 73 04             	lea    0x4(%ebx),%esi
80104271:	56                   	push   %esi
80104272:	e8 79 01 00 00       	call   801043f0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104277:	8b 03                	mov    (%ebx),%eax
80104279:	83 c4 10             	add    $0x10,%esp
8010427c:	85 c0                	test   %eax,%eax
8010427e:	74 13                	je     80104293 <holdingsleep+0x33>
80104280:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104283:	e8 08 f6 ff ff       	call   80103890 <myproc>
80104288:	39 58 10             	cmp    %ebx,0x10(%eax)
8010428b:	0f 94 c0             	sete   %al
8010428e:	0f b6 c0             	movzbl %al,%eax
80104291:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
80104293:	83 ec 0c             	sub    $0xc,%esp
80104296:	56                   	push   %esi
80104297:	e8 14 02 00 00       	call   801044b0 <release>
  return r;
}
8010429c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010429f:	89 f8                	mov    %edi,%eax
801042a1:	5b                   	pop    %ebx
801042a2:	5e                   	pop    %esi
801042a3:	5f                   	pop    %edi
801042a4:	5d                   	pop    %ebp
801042a5:	c3                   	ret    
801042a6:	66 90                	xchg   %ax,%ax
801042a8:	66 90                	xchg   %ax,%ax
801042aa:	66 90                	xchg   %ax,%ax
801042ac:	66 90                	xchg   %ax,%ax
801042ae:	66 90                	xchg   %ax,%ax

801042b0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801042b0:	55                   	push   %ebp
801042b1:	89 e5                	mov    %esp,%ebp
801042b3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801042b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801042b9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801042bf:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
801042c2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801042c9:	5d                   	pop    %ebp
801042ca:	c3                   	ret    
801042cb:	90                   	nop
801042cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801042d0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801042d0:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801042d1:	31 d2                	xor    %edx,%edx
{
801042d3:	89 e5                	mov    %esp,%ebp
801042d5:	53                   	push   %ebx
  ebp = (uint*)v - 2;
801042d6:	8b 45 08             	mov    0x8(%ebp),%eax
{
801042d9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
801042dc:	83 e8 08             	sub    $0x8,%eax
801042df:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801042e0:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801042e6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801042ec:	77 1a                	ja     80104308 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
801042ee:	8b 58 04             	mov    0x4(%eax),%ebx
801042f1:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
801042f4:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
801042f7:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801042f9:	83 fa 0a             	cmp    $0xa,%edx
801042fc:	75 e2                	jne    801042e0 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801042fe:	5b                   	pop    %ebx
801042ff:	5d                   	pop    %ebp
80104300:	c3                   	ret    
80104301:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104308:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010430b:	83 c1 28             	add    $0x28,%ecx
8010430e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104310:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104316:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104319:	39 c1                	cmp    %eax,%ecx
8010431b:	75 f3                	jne    80104310 <getcallerpcs+0x40>
}
8010431d:	5b                   	pop    %ebx
8010431e:	5d                   	pop    %ebp
8010431f:	c3                   	ret    

80104320 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104320:	55                   	push   %ebp
80104321:	89 e5                	mov    %esp,%ebp
80104323:	53                   	push   %ebx
80104324:	83 ec 04             	sub    $0x4,%esp
80104327:	9c                   	pushf  
80104328:	5b                   	pop    %ebx
  asm volatile("cli");
80104329:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010432a:	e8 c1 f4 ff ff       	call   801037f0 <mycpu>
8010432f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104335:	85 c0                	test   %eax,%eax
80104337:	75 11                	jne    8010434a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104339:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010433f:	e8 ac f4 ff ff       	call   801037f0 <mycpu>
80104344:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
8010434a:	e8 a1 f4 ff ff       	call   801037f0 <mycpu>
8010434f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104356:	83 c4 04             	add    $0x4,%esp
80104359:	5b                   	pop    %ebx
8010435a:	5d                   	pop    %ebp
8010435b:	c3                   	ret    
8010435c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104360 <popcli>:

void
popcli(void)
{
80104360:	55                   	push   %ebp
80104361:	89 e5                	mov    %esp,%ebp
80104363:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104366:	9c                   	pushf  
80104367:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104368:	f6 c4 02             	test   $0x2,%ah
8010436b:	75 35                	jne    801043a2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010436d:	e8 7e f4 ff ff       	call   801037f0 <mycpu>
80104372:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104379:	78 34                	js     801043af <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010437b:	e8 70 f4 ff ff       	call   801037f0 <mycpu>
80104380:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104386:	85 d2                	test   %edx,%edx
80104388:	74 06                	je     80104390 <popcli+0x30>
    sti();
}
8010438a:	c9                   	leave  
8010438b:	c3                   	ret    
8010438c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104390:	e8 5b f4 ff ff       	call   801037f0 <mycpu>
80104395:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010439b:	85 c0                	test   %eax,%eax
8010439d:	74 eb                	je     8010438a <popcli+0x2a>
  asm volatile("sti");
8010439f:	fb                   	sti    
}
801043a0:	c9                   	leave  
801043a1:	c3                   	ret    
    panic("popcli - interruptible");
801043a2:	83 ec 0c             	sub    $0xc,%esp
801043a5:	68 23 76 10 80       	push   $0x80107623
801043aa:	e8 e1 bf ff ff       	call   80100390 <panic>
    panic("popcli");
801043af:	83 ec 0c             	sub    $0xc,%esp
801043b2:	68 3a 76 10 80       	push   $0x8010763a
801043b7:	e8 d4 bf ff ff       	call   80100390 <panic>
801043bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801043c0 <holding>:
{
801043c0:	55                   	push   %ebp
801043c1:	89 e5                	mov    %esp,%ebp
801043c3:	56                   	push   %esi
801043c4:	53                   	push   %ebx
801043c5:	8b 75 08             	mov    0x8(%ebp),%esi
801043c8:	31 db                	xor    %ebx,%ebx
  pushcli();
801043ca:	e8 51 ff ff ff       	call   80104320 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801043cf:	8b 06                	mov    (%esi),%eax
801043d1:	85 c0                	test   %eax,%eax
801043d3:	74 10                	je     801043e5 <holding+0x25>
801043d5:	8b 5e 08             	mov    0x8(%esi),%ebx
801043d8:	e8 13 f4 ff ff       	call   801037f0 <mycpu>
801043dd:	39 c3                	cmp    %eax,%ebx
801043df:	0f 94 c3             	sete   %bl
801043e2:	0f b6 db             	movzbl %bl,%ebx
  popcli();
801043e5:	e8 76 ff ff ff       	call   80104360 <popcli>
}
801043ea:	89 d8                	mov    %ebx,%eax
801043ec:	5b                   	pop    %ebx
801043ed:	5e                   	pop    %esi
801043ee:	5d                   	pop    %ebp
801043ef:	c3                   	ret    

801043f0 <acquire>:
{
801043f0:	55                   	push   %ebp
801043f1:	89 e5                	mov    %esp,%ebp
801043f3:	56                   	push   %esi
801043f4:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
801043f5:	e8 26 ff ff ff       	call   80104320 <pushcli>
  if(holding(lk))
801043fa:	8b 5d 08             	mov    0x8(%ebp),%ebx
801043fd:	83 ec 0c             	sub    $0xc,%esp
80104400:	53                   	push   %ebx
80104401:	e8 ba ff ff ff       	call   801043c0 <holding>
80104406:	83 c4 10             	add    $0x10,%esp
80104409:	85 c0                	test   %eax,%eax
8010440b:	0f 85 83 00 00 00    	jne    80104494 <acquire+0xa4>
80104411:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104413:	ba 01 00 00 00       	mov    $0x1,%edx
80104418:	eb 09                	jmp    80104423 <acquire+0x33>
8010441a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104420:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104423:	89 d0                	mov    %edx,%eax
80104425:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104428:	85 c0                	test   %eax,%eax
8010442a:	75 f4                	jne    80104420 <acquire+0x30>
  __sync_synchronize();
8010442c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104431:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104434:	e8 b7 f3 ff ff       	call   801037f0 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104439:	8d 53 0c             	lea    0xc(%ebx),%edx
  lk->cpu = mycpu();
8010443c:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
8010443f:	89 e8                	mov    %ebp,%eax
80104441:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104448:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
8010444e:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
80104454:	77 1a                	ja     80104470 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104456:	8b 48 04             	mov    0x4(%eax),%ecx
80104459:	89 0c b2             	mov    %ecx,(%edx,%esi,4)
  for(i = 0; i < 10; i++){
8010445c:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
8010445f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104461:	83 fe 0a             	cmp    $0xa,%esi
80104464:	75 e2                	jne    80104448 <acquire+0x58>
}
80104466:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104469:	5b                   	pop    %ebx
8010446a:	5e                   	pop    %esi
8010446b:	5d                   	pop    %ebp
8010446c:	c3                   	ret    
8010446d:	8d 76 00             	lea    0x0(%esi),%esi
80104470:	8d 04 b2             	lea    (%edx,%esi,4),%eax
80104473:	83 c2 28             	add    $0x28,%edx
80104476:	8d 76 00             	lea    0x0(%esi),%esi
80104479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
80104480:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104486:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104489:	39 d0                	cmp    %edx,%eax
8010448b:	75 f3                	jne    80104480 <acquire+0x90>
}
8010448d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104490:	5b                   	pop    %ebx
80104491:	5e                   	pop    %esi
80104492:	5d                   	pop    %ebp
80104493:	c3                   	ret    
    panic("acquire");
80104494:	83 ec 0c             	sub    $0xc,%esp
80104497:	68 41 76 10 80       	push   $0x80107641
8010449c:	e8 ef be ff ff       	call   80100390 <panic>
801044a1:	eb 0d                	jmp    801044b0 <release>
801044a3:	90                   	nop
801044a4:	90                   	nop
801044a5:	90                   	nop
801044a6:	90                   	nop
801044a7:	90                   	nop
801044a8:	90                   	nop
801044a9:	90                   	nop
801044aa:	90                   	nop
801044ab:	90                   	nop
801044ac:	90                   	nop
801044ad:	90                   	nop
801044ae:	90                   	nop
801044af:	90                   	nop

801044b0 <release>:
{
801044b0:	55                   	push   %ebp
801044b1:	89 e5                	mov    %esp,%ebp
801044b3:	53                   	push   %ebx
801044b4:	83 ec 10             	sub    $0x10,%esp
801044b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
801044ba:	53                   	push   %ebx
801044bb:	e8 00 ff ff ff       	call   801043c0 <holding>
801044c0:	83 c4 10             	add    $0x10,%esp
801044c3:	85 c0                	test   %eax,%eax
801044c5:	74 22                	je     801044e9 <release+0x39>
  lk->pcs[0] = 0;
801044c7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801044ce:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801044d5:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801044da:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801044e0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801044e3:	c9                   	leave  
  popcli();
801044e4:	e9 77 fe ff ff       	jmp    80104360 <popcli>
    panic("release");
801044e9:	83 ec 0c             	sub    $0xc,%esp
801044ec:	68 49 76 10 80       	push   $0x80107649
801044f1:	e8 9a be ff ff       	call   80100390 <panic>
801044f6:	66 90                	xchg   %ax,%ax
801044f8:	66 90                	xchg   %ax,%ax
801044fa:	66 90                	xchg   %ax,%ax
801044fc:	66 90                	xchg   %ax,%ax
801044fe:	66 90                	xchg   %ax,%ax

80104500 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104500:	55                   	push   %ebp
80104501:	89 e5                	mov    %esp,%ebp
80104503:	57                   	push   %edi
80104504:	53                   	push   %ebx
80104505:	8b 55 08             	mov    0x8(%ebp),%edx
80104508:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
8010450b:	f6 c2 03             	test   $0x3,%dl
8010450e:	75 05                	jne    80104515 <memset+0x15>
80104510:	f6 c1 03             	test   $0x3,%cl
80104513:	74 13                	je     80104528 <memset+0x28>
  asm volatile("cld; rep stosb" :
80104515:	89 d7                	mov    %edx,%edi
80104517:	8b 45 0c             	mov    0xc(%ebp),%eax
8010451a:	fc                   	cld    
8010451b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
8010451d:	5b                   	pop    %ebx
8010451e:	89 d0                	mov    %edx,%eax
80104520:	5f                   	pop    %edi
80104521:	5d                   	pop    %ebp
80104522:	c3                   	ret    
80104523:	90                   	nop
80104524:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80104528:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010452c:	c1 e9 02             	shr    $0x2,%ecx
8010452f:	89 f8                	mov    %edi,%eax
80104531:	89 fb                	mov    %edi,%ebx
80104533:	c1 e0 18             	shl    $0x18,%eax
80104536:	c1 e3 10             	shl    $0x10,%ebx
80104539:	09 d8                	or     %ebx,%eax
8010453b:	09 f8                	or     %edi,%eax
8010453d:	c1 e7 08             	shl    $0x8,%edi
80104540:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104542:	89 d7                	mov    %edx,%edi
80104544:	fc                   	cld    
80104545:	f3 ab                	rep stos %eax,%es:(%edi)
}
80104547:	5b                   	pop    %ebx
80104548:	89 d0                	mov    %edx,%eax
8010454a:	5f                   	pop    %edi
8010454b:	5d                   	pop    %ebp
8010454c:	c3                   	ret    
8010454d:	8d 76 00             	lea    0x0(%esi),%esi

80104550 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104550:	55                   	push   %ebp
80104551:	89 e5                	mov    %esp,%ebp
80104553:	57                   	push   %edi
80104554:	56                   	push   %esi
80104555:	53                   	push   %ebx
80104556:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104559:	8b 75 08             	mov    0x8(%ebp),%esi
8010455c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010455f:	85 db                	test   %ebx,%ebx
80104561:	74 29                	je     8010458c <memcmp+0x3c>
    if(*s1 != *s2)
80104563:	0f b6 16             	movzbl (%esi),%edx
80104566:	0f b6 0f             	movzbl (%edi),%ecx
80104569:	38 d1                	cmp    %dl,%cl
8010456b:	75 2b                	jne    80104598 <memcmp+0x48>
8010456d:	b8 01 00 00 00       	mov    $0x1,%eax
80104572:	eb 14                	jmp    80104588 <memcmp+0x38>
80104574:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104578:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
8010457c:	83 c0 01             	add    $0x1,%eax
8010457f:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80104584:	38 ca                	cmp    %cl,%dl
80104586:	75 10                	jne    80104598 <memcmp+0x48>
  while(n-- > 0){
80104588:	39 d8                	cmp    %ebx,%eax
8010458a:	75 ec                	jne    80104578 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
8010458c:	5b                   	pop    %ebx
  return 0;
8010458d:	31 c0                	xor    %eax,%eax
}
8010458f:	5e                   	pop    %esi
80104590:	5f                   	pop    %edi
80104591:	5d                   	pop    %ebp
80104592:	c3                   	ret    
80104593:	90                   	nop
80104594:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
80104598:	0f b6 c2             	movzbl %dl,%eax
}
8010459b:	5b                   	pop    %ebx
      return *s1 - *s2;
8010459c:	29 c8                	sub    %ecx,%eax
}
8010459e:	5e                   	pop    %esi
8010459f:	5f                   	pop    %edi
801045a0:	5d                   	pop    %ebp
801045a1:	c3                   	ret    
801045a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801045b0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801045b0:	55                   	push   %ebp
801045b1:	89 e5                	mov    %esp,%ebp
801045b3:	56                   	push   %esi
801045b4:	53                   	push   %ebx
801045b5:	8b 45 08             	mov    0x8(%ebp),%eax
801045b8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801045bb:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801045be:	39 c3                	cmp    %eax,%ebx
801045c0:	73 26                	jae    801045e8 <memmove+0x38>
801045c2:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
801045c5:	39 c8                	cmp    %ecx,%eax
801045c7:	73 1f                	jae    801045e8 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
801045c9:	85 f6                	test   %esi,%esi
801045cb:	8d 56 ff             	lea    -0x1(%esi),%edx
801045ce:	74 0f                	je     801045df <memmove+0x2f>
      *--d = *--s;
801045d0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
801045d4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
801045d7:	83 ea 01             	sub    $0x1,%edx
801045da:	83 fa ff             	cmp    $0xffffffff,%edx
801045dd:	75 f1                	jne    801045d0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801045df:	5b                   	pop    %ebx
801045e0:	5e                   	pop    %esi
801045e1:	5d                   	pop    %ebp
801045e2:	c3                   	ret    
801045e3:	90                   	nop
801045e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
801045e8:	31 d2                	xor    %edx,%edx
801045ea:	85 f6                	test   %esi,%esi
801045ec:	74 f1                	je     801045df <memmove+0x2f>
801045ee:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
801045f0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
801045f4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
801045f7:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
801045fa:	39 d6                	cmp    %edx,%esi
801045fc:	75 f2                	jne    801045f0 <memmove+0x40>
}
801045fe:	5b                   	pop    %ebx
801045ff:	5e                   	pop    %esi
80104600:	5d                   	pop    %ebp
80104601:	c3                   	ret    
80104602:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104609:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104610 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104610:	55                   	push   %ebp
80104611:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104613:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80104614:	eb 9a                	jmp    801045b0 <memmove>
80104616:	8d 76 00             	lea    0x0(%esi),%esi
80104619:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104620 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104620:	55                   	push   %ebp
80104621:	89 e5                	mov    %esp,%ebp
80104623:	57                   	push   %edi
80104624:	56                   	push   %esi
80104625:	8b 7d 10             	mov    0x10(%ebp),%edi
80104628:	53                   	push   %ebx
80104629:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010462c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
8010462f:	85 ff                	test   %edi,%edi
80104631:	74 2f                	je     80104662 <strncmp+0x42>
80104633:	0f b6 01             	movzbl (%ecx),%eax
80104636:	0f b6 1e             	movzbl (%esi),%ebx
80104639:	84 c0                	test   %al,%al
8010463b:	74 37                	je     80104674 <strncmp+0x54>
8010463d:	38 c3                	cmp    %al,%bl
8010463f:	75 33                	jne    80104674 <strncmp+0x54>
80104641:	01 f7                	add    %esi,%edi
80104643:	eb 13                	jmp    80104658 <strncmp+0x38>
80104645:	8d 76 00             	lea    0x0(%esi),%esi
80104648:	0f b6 01             	movzbl (%ecx),%eax
8010464b:	84 c0                	test   %al,%al
8010464d:	74 21                	je     80104670 <strncmp+0x50>
8010464f:	0f b6 1a             	movzbl (%edx),%ebx
80104652:	89 d6                	mov    %edx,%esi
80104654:	38 d8                	cmp    %bl,%al
80104656:	75 1c                	jne    80104674 <strncmp+0x54>
    n--, p++, q++;
80104658:	8d 56 01             	lea    0x1(%esi),%edx
8010465b:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010465e:	39 fa                	cmp    %edi,%edx
80104660:	75 e6                	jne    80104648 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104662:	5b                   	pop    %ebx
    return 0;
80104663:	31 c0                	xor    %eax,%eax
}
80104665:	5e                   	pop    %esi
80104666:	5f                   	pop    %edi
80104667:	5d                   	pop    %ebp
80104668:	c3                   	ret    
80104669:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104670:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80104674:	29 d8                	sub    %ebx,%eax
}
80104676:	5b                   	pop    %ebx
80104677:	5e                   	pop    %esi
80104678:	5f                   	pop    %edi
80104679:	5d                   	pop    %ebp
8010467a:	c3                   	ret    
8010467b:	90                   	nop
8010467c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104680 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104680:	55                   	push   %ebp
80104681:	89 e5                	mov    %esp,%ebp
80104683:	56                   	push   %esi
80104684:	53                   	push   %ebx
80104685:	8b 45 08             	mov    0x8(%ebp),%eax
80104688:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010468b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010468e:	89 c2                	mov    %eax,%edx
80104690:	eb 19                	jmp    801046ab <strncpy+0x2b>
80104692:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104698:	83 c3 01             	add    $0x1,%ebx
8010469b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
8010469f:	83 c2 01             	add    $0x1,%edx
801046a2:	84 c9                	test   %cl,%cl
801046a4:	88 4a ff             	mov    %cl,-0x1(%edx)
801046a7:	74 09                	je     801046b2 <strncpy+0x32>
801046a9:	89 f1                	mov    %esi,%ecx
801046ab:	85 c9                	test   %ecx,%ecx
801046ad:	8d 71 ff             	lea    -0x1(%ecx),%esi
801046b0:	7f e6                	jg     80104698 <strncpy+0x18>
    ;
  while(n-- > 0)
801046b2:	31 c9                	xor    %ecx,%ecx
801046b4:	85 f6                	test   %esi,%esi
801046b6:	7e 17                	jle    801046cf <strncpy+0x4f>
801046b8:	90                   	nop
801046b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
801046c0:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
801046c4:	89 f3                	mov    %esi,%ebx
801046c6:	83 c1 01             	add    $0x1,%ecx
801046c9:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
801046cb:	85 db                	test   %ebx,%ebx
801046cd:	7f f1                	jg     801046c0 <strncpy+0x40>
  return os;
}
801046cf:	5b                   	pop    %ebx
801046d0:	5e                   	pop    %esi
801046d1:	5d                   	pop    %ebp
801046d2:	c3                   	ret    
801046d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801046d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801046e0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801046e0:	55                   	push   %ebp
801046e1:	89 e5                	mov    %esp,%ebp
801046e3:	56                   	push   %esi
801046e4:	53                   	push   %ebx
801046e5:	8b 4d 10             	mov    0x10(%ebp),%ecx
801046e8:	8b 45 08             	mov    0x8(%ebp),%eax
801046eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
801046ee:	85 c9                	test   %ecx,%ecx
801046f0:	7e 26                	jle    80104718 <safestrcpy+0x38>
801046f2:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
801046f6:	89 c1                	mov    %eax,%ecx
801046f8:	eb 17                	jmp    80104711 <safestrcpy+0x31>
801046fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104700:	83 c2 01             	add    $0x1,%edx
80104703:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104707:	83 c1 01             	add    $0x1,%ecx
8010470a:	84 db                	test   %bl,%bl
8010470c:	88 59 ff             	mov    %bl,-0x1(%ecx)
8010470f:	74 04                	je     80104715 <safestrcpy+0x35>
80104711:	39 f2                	cmp    %esi,%edx
80104713:	75 eb                	jne    80104700 <safestrcpy+0x20>
    ;
  *s = 0;
80104715:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104718:	5b                   	pop    %ebx
80104719:	5e                   	pop    %esi
8010471a:	5d                   	pop    %ebp
8010471b:	c3                   	ret    
8010471c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104720 <strlen>:

int
strlen(const char *s)
{
80104720:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104721:	31 c0                	xor    %eax,%eax
{
80104723:	89 e5                	mov    %esp,%ebp
80104725:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104728:	80 3a 00             	cmpb   $0x0,(%edx)
8010472b:	74 0c                	je     80104739 <strlen+0x19>
8010472d:	8d 76 00             	lea    0x0(%esi),%esi
80104730:	83 c0 01             	add    $0x1,%eax
80104733:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104737:	75 f7                	jne    80104730 <strlen+0x10>
    ;
  return n;
}
80104739:	5d                   	pop    %ebp
8010473a:	c3                   	ret    

8010473b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010473b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010473f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104743:	55                   	push   %ebp
  pushl %ebx
80104744:	53                   	push   %ebx
  pushl %esi
80104745:	56                   	push   %esi
  pushl %edi
80104746:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104747:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104749:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
8010474b:	5f                   	pop    %edi
  popl %esi
8010474c:	5e                   	pop    %esi
  popl %ebx
8010474d:	5b                   	pop    %ebx
  popl %ebp
8010474e:	5d                   	pop    %ebp
  ret
8010474f:	c3                   	ret    

80104750 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104750:	55                   	push   %ebp
80104751:	89 e5                	mov    %esp,%ebp
80104753:	53                   	push   %ebx
80104754:	83 ec 04             	sub    $0x4,%esp
80104757:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010475a:	e8 31 f1 ff ff       	call   80103890 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010475f:	8b 00                	mov    (%eax),%eax
80104761:	39 d8                	cmp    %ebx,%eax
80104763:	76 1b                	jbe    80104780 <fetchint+0x30>
80104765:	8d 53 04             	lea    0x4(%ebx),%edx
80104768:	39 d0                	cmp    %edx,%eax
8010476a:	72 14                	jb     80104780 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
8010476c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010476f:	8b 13                	mov    (%ebx),%edx
80104771:	89 10                	mov    %edx,(%eax)
  return 0;
80104773:	31 c0                	xor    %eax,%eax
}
80104775:	83 c4 04             	add    $0x4,%esp
80104778:	5b                   	pop    %ebx
80104779:	5d                   	pop    %ebp
8010477a:	c3                   	ret    
8010477b:	90                   	nop
8010477c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104780:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104785:	eb ee                	jmp    80104775 <fetchint+0x25>
80104787:	89 f6                	mov    %esi,%esi
80104789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104790 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104790:	55                   	push   %ebp
80104791:	89 e5                	mov    %esp,%ebp
80104793:	53                   	push   %ebx
80104794:	83 ec 04             	sub    $0x4,%esp
80104797:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010479a:	e8 f1 f0 ff ff       	call   80103890 <myproc>

  if(addr >= curproc->sz)
8010479f:	39 18                	cmp    %ebx,(%eax)
801047a1:	76 29                	jbe    801047cc <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
801047a3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801047a6:	89 da                	mov    %ebx,%edx
801047a8:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
801047aa:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
801047ac:	39 c3                	cmp    %eax,%ebx
801047ae:	73 1c                	jae    801047cc <fetchstr+0x3c>
    if(*s == 0)
801047b0:	80 3b 00             	cmpb   $0x0,(%ebx)
801047b3:	75 10                	jne    801047c5 <fetchstr+0x35>
801047b5:	eb 39                	jmp    801047f0 <fetchstr+0x60>
801047b7:	89 f6                	mov    %esi,%esi
801047b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801047c0:	80 3a 00             	cmpb   $0x0,(%edx)
801047c3:	74 1b                	je     801047e0 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
801047c5:	83 c2 01             	add    $0x1,%edx
801047c8:	39 d0                	cmp    %edx,%eax
801047ca:	77 f4                	ja     801047c0 <fetchstr+0x30>
    return -1;
801047cc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
801047d1:	83 c4 04             	add    $0x4,%esp
801047d4:	5b                   	pop    %ebx
801047d5:	5d                   	pop    %ebp
801047d6:	c3                   	ret    
801047d7:	89 f6                	mov    %esi,%esi
801047d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801047e0:	83 c4 04             	add    $0x4,%esp
801047e3:	89 d0                	mov    %edx,%eax
801047e5:	29 d8                	sub    %ebx,%eax
801047e7:	5b                   	pop    %ebx
801047e8:	5d                   	pop    %ebp
801047e9:	c3                   	ret    
801047ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
801047f0:	31 c0                	xor    %eax,%eax
      return s - *pp;
801047f2:	eb dd                	jmp    801047d1 <fetchstr+0x41>
801047f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801047fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104800 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104800:	55                   	push   %ebp
80104801:	89 e5                	mov    %esp,%ebp
80104803:	56                   	push   %esi
80104804:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104805:	e8 86 f0 ff ff       	call   80103890 <myproc>
8010480a:	8b 40 18             	mov    0x18(%eax),%eax
8010480d:	8b 55 08             	mov    0x8(%ebp),%edx
80104810:	8b 40 44             	mov    0x44(%eax),%eax
80104813:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104816:	e8 75 f0 ff ff       	call   80103890 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010481b:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010481d:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104820:	39 c6                	cmp    %eax,%esi
80104822:	73 1c                	jae    80104840 <argint+0x40>
80104824:	8d 53 08             	lea    0x8(%ebx),%edx
80104827:	39 d0                	cmp    %edx,%eax
80104829:	72 15                	jb     80104840 <argint+0x40>
  *ip = *(int*)(addr);
8010482b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010482e:	8b 53 04             	mov    0x4(%ebx),%edx
80104831:	89 10                	mov    %edx,(%eax)
  return 0;
80104833:	31 c0                	xor    %eax,%eax
}
80104835:	5b                   	pop    %ebx
80104836:	5e                   	pop    %esi
80104837:	5d                   	pop    %ebp
80104838:	c3                   	ret    
80104839:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104840:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104845:	eb ee                	jmp    80104835 <argint+0x35>
80104847:	89 f6                	mov    %esi,%esi
80104849:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104850 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104850:	55                   	push   %ebp
80104851:	89 e5                	mov    %esp,%ebp
80104853:	56                   	push   %esi
80104854:	53                   	push   %ebx
80104855:	83 ec 10             	sub    $0x10,%esp
80104858:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010485b:	e8 30 f0 ff ff       	call   80103890 <myproc>
80104860:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104862:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104865:	83 ec 08             	sub    $0x8,%esp
80104868:	50                   	push   %eax
80104869:	ff 75 08             	pushl  0x8(%ebp)
8010486c:	e8 8f ff ff ff       	call   80104800 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104871:	83 c4 10             	add    $0x10,%esp
80104874:	85 c0                	test   %eax,%eax
80104876:	78 28                	js     801048a0 <argptr+0x50>
80104878:	85 db                	test   %ebx,%ebx
8010487a:	78 24                	js     801048a0 <argptr+0x50>
8010487c:	8b 16                	mov    (%esi),%edx
8010487e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104881:	39 c2                	cmp    %eax,%edx
80104883:	76 1b                	jbe    801048a0 <argptr+0x50>
80104885:	01 c3                	add    %eax,%ebx
80104887:	39 da                	cmp    %ebx,%edx
80104889:	72 15                	jb     801048a0 <argptr+0x50>
    return -1;
  *pp = (char*)i;
8010488b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010488e:	89 02                	mov    %eax,(%edx)
  return 0;
80104890:	31 c0                	xor    %eax,%eax
}
80104892:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104895:	5b                   	pop    %ebx
80104896:	5e                   	pop    %esi
80104897:	5d                   	pop    %ebp
80104898:	c3                   	ret    
80104899:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801048a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801048a5:	eb eb                	jmp    80104892 <argptr+0x42>
801048a7:	89 f6                	mov    %esi,%esi
801048a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801048b0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801048b0:	55                   	push   %ebp
801048b1:	89 e5                	mov    %esp,%ebp
801048b3:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
801048b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801048b9:	50                   	push   %eax
801048ba:	ff 75 08             	pushl  0x8(%ebp)
801048bd:	e8 3e ff ff ff       	call   80104800 <argint>
801048c2:	83 c4 10             	add    $0x10,%esp
801048c5:	85 c0                	test   %eax,%eax
801048c7:	78 17                	js     801048e0 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
801048c9:	83 ec 08             	sub    $0x8,%esp
801048cc:	ff 75 0c             	pushl  0xc(%ebp)
801048cf:	ff 75 f4             	pushl  -0xc(%ebp)
801048d2:	e8 b9 fe ff ff       	call   80104790 <fetchstr>
801048d7:	83 c4 10             	add    $0x10,%esp
}
801048da:	c9                   	leave  
801048db:	c3                   	ret    
801048dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801048e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801048e5:	c9                   	leave  
801048e6:	c3                   	ret    
801048e7:	89 f6                	mov    %esi,%esi
801048e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801048f0 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
801048f0:	55                   	push   %ebp
801048f1:	89 e5                	mov    %esp,%ebp
801048f3:	53                   	push   %ebx
801048f4:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
801048f7:	e8 94 ef ff ff       	call   80103890 <myproc>
801048fc:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
801048fe:	8b 40 18             	mov    0x18(%eax),%eax
80104901:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104904:	8d 50 ff             	lea    -0x1(%eax),%edx
80104907:	83 fa 14             	cmp    $0x14,%edx
8010490a:	77 1c                	ja     80104928 <syscall+0x38>
8010490c:	8b 14 85 80 76 10 80 	mov    -0x7fef8980(,%eax,4),%edx
80104913:	85 d2                	test   %edx,%edx
80104915:	74 11                	je     80104928 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80104917:	ff d2                	call   *%edx
80104919:	8b 53 18             	mov    0x18(%ebx),%edx
8010491c:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
8010491f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104922:	c9                   	leave  
80104923:	c3                   	ret    
80104924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104928:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104929:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
8010492c:	50                   	push   %eax
8010492d:	ff 73 10             	pushl  0x10(%ebx)
80104930:	68 51 76 10 80       	push   $0x80107651
80104935:	e8 26 bd ff ff       	call   80100660 <cprintf>
    curproc->tf->eax = -1;
8010493a:	8b 43 18             	mov    0x18(%ebx),%eax
8010493d:	83 c4 10             	add    $0x10,%esp
80104940:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104947:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010494a:	c9                   	leave  
8010494b:	c3                   	ret    
8010494c:	66 90                	xchg   %ax,%ax
8010494e:	66 90                	xchg   %ax,%ax

80104950 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104950:	55                   	push   %ebp
80104951:	89 e5                	mov    %esp,%ebp
80104953:	57                   	push   %edi
80104954:	56                   	push   %esi
80104955:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;//inode path, directory path
  char name[DIRSIZ];//file name

  if((dp = nameiparent(path, name)) == 0)// to get the node of the parent directory, if not 
80104956:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80104959:	83 ec 44             	sub    $0x44,%esp
8010495c:	89 4d c0             	mov    %ecx,-0x40(%ebp)
8010495f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)// to get the node of the parent directory, if not 
80104962:	56                   	push   %esi
80104963:	50                   	push   %eax
{
80104964:	89 55 c4             	mov    %edx,-0x3c(%ebp)
80104967:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)// to get the node of the parent directory, if not 
8010496a:	e8 41 d6 ff ff       	call   80101fb0 <nameiparent>
8010496f:	83 c4 10             	add    $0x10,%esp
80104972:	85 c0                	test   %eax,%eax
80104974:	0f 84 46 01 00 00    	je     80104ac0 <create+0x170>
    return 0;
  ilock(dp);
8010497a:	83 ec 0c             	sub    $0xc,%esp
8010497d:	89 c3                	mov    %eax,%ebx
8010497f:	50                   	push   %eax
80104980:	e8 0b cd ff ff       	call   80101690 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){// look up hte directory to find the file, if exists
80104985:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104988:	83 c4 0c             	add    $0xc,%esp
8010498b:	50                   	push   %eax
8010498c:	56                   	push   %esi
8010498d:	53                   	push   %ebx
8010498e:	e8 cd d2 ff ff       	call   80101c60 <dirlookup>
80104993:	83 c4 10             	add    $0x10,%esp
80104996:	85 c0                	test   %eax,%eax
80104998:	89 c7                	mov    %eax,%edi
8010499a:	74 54                	je     801049f0 <create+0xa0>
    iunlockput(dp);
8010499c:	83 ec 0c             	sub    $0xc,%esp
8010499f:	53                   	push   %ebx
801049a0:	e8 7b cf ff ff       	call   80101920 <iunlockput>
    ilock(ip);
801049a5:	89 3c 24             	mov    %edi,(%esp)
801049a8:	e8 e3 cc ff ff       	call   80101690 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801049ad:	83 c4 10             	add    $0x10,%esp
801049b0:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
801049b5:	74 19                	je     801049d0 <create+0x80>
      return ip;
    if(type == T_SMALLFILE && ip->type == T_SMALLFILE)
801049b7:	66 83 7d c4 04       	cmpw   $0x4,-0x3c(%ebp)
801049bc:	75 19                	jne    801049d7 <create+0x87>
801049be:	66 83 7f 50 04       	cmpw   $0x4,0x50(%edi)
801049c3:	75 12                	jne    801049d7 <create+0x87>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801049c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801049c8:	89 f8                	mov    %edi,%eax
801049ca:	5b                   	pop    %ebx
801049cb:	5e                   	pop    %esi
801049cc:	5f                   	pop    %edi
801049cd:	5d                   	pop    %ebp
801049ce:	c3                   	ret    
801049cf:	90                   	nop
    if(type == T_FILE && ip->type == T_FILE)
801049d0:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
801049d5:	74 ee                	je     801049c5 <create+0x75>
    iunlockput(ip);
801049d7:	83 ec 0c             	sub    $0xc,%esp
801049da:	57                   	push   %edi
    return 0;
801049db:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
801049dd:	e8 3e cf ff ff       	call   80101920 <iunlockput>
    return 0;
801049e2:	83 c4 10             	add    $0x10,%esp
}
801049e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801049e8:	89 f8                	mov    %edi,%eax
801049ea:	5b                   	pop    %ebx
801049eb:	5e                   	pop    %esi
801049ec:	5f                   	pop    %edi
801049ed:	5d                   	pop    %ebp
801049ee:	c3                   	ret    
801049ef:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)// alloc inode fail
801049f0:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
801049f4:	83 ec 08             	sub    $0x8,%esp
801049f7:	50                   	push   %eax
801049f8:	ff 33                	pushl  (%ebx)
801049fa:	e8 21 cb ff ff       	call   80101520 <ialloc>
801049ff:	83 c4 10             	add    $0x10,%esp
80104a02:	85 c0                	test   %eax,%eax
80104a04:	89 c7                	mov    %eax,%edi
80104a06:	0f 84 c8 00 00 00    	je     80104ad4 <create+0x184>
  ilock(ip);
80104a0c:	83 ec 0c             	sub    $0xc,%esp
80104a0f:	50                   	push   %eax
80104a10:	e8 7b cc ff ff       	call   80101690 <ilock>
  ip->major = major;
80104a15:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80104a19:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
80104a1d:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80104a21:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80104a25:	b8 01 00 00 00       	mov    $0x1,%eax
80104a2a:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
80104a2e:	89 3c 24             	mov    %edi,(%esp)
80104a31:	e8 aa cb ff ff       	call   801015e0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104a36:	83 c4 10             	add    $0x10,%esp
80104a39:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
80104a3e:	74 30                	je     80104a70 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104a40:	83 ec 04             	sub    $0x4,%esp
80104a43:	ff 77 04             	pushl  0x4(%edi)
80104a46:	56                   	push   %esi
80104a47:	53                   	push   %ebx
80104a48:	e8 83 d4 ff ff       	call   80101ed0 <dirlink>
80104a4d:	83 c4 10             	add    $0x10,%esp
80104a50:	85 c0                	test   %eax,%eax
80104a52:	78 73                	js     80104ac7 <create+0x177>
  iunlockput(dp);
80104a54:	83 ec 0c             	sub    $0xc,%esp
80104a57:	53                   	push   %ebx
80104a58:	e8 c3 ce ff ff       	call   80101920 <iunlockput>
  return ip;
80104a5d:	83 c4 10             	add    $0x10,%esp
}
80104a60:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104a63:	89 f8                	mov    %edi,%eax
80104a65:	5b                   	pop    %ebx
80104a66:	5e                   	pop    %esi
80104a67:	5f                   	pop    %edi
80104a68:	5d                   	pop    %ebp
80104a69:	c3                   	ret    
80104a6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink++;  // for ".."
80104a70:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104a75:	83 ec 0c             	sub    $0xc,%esp
80104a78:	53                   	push   %ebx
80104a79:	e8 62 cb ff ff       	call   801015e0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104a7e:	83 c4 0c             	add    $0xc,%esp
80104a81:	ff 77 04             	pushl  0x4(%edi)
80104a84:	68 f4 76 10 80       	push   $0x801076f4
80104a89:	57                   	push   %edi
80104a8a:	e8 41 d4 ff ff       	call   80101ed0 <dirlink>
80104a8f:	83 c4 10             	add    $0x10,%esp
80104a92:	85 c0                	test   %eax,%eax
80104a94:	78 18                	js     80104aae <create+0x15e>
80104a96:	83 ec 04             	sub    $0x4,%esp
80104a99:	ff 73 04             	pushl  0x4(%ebx)
80104a9c:	68 f3 76 10 80       	push   $0x801076f3
80104aa1:	57                   	push   %edi
80104aa2:	e8 29 d4 ff ff       	call   80101ed0 <dirlink>
80104aa7:	83 c4 10             	add    $0x10,%esp
80104aaa:	85 c0                	test   %eax,%eax
80104aac:	79 92                	jns    80104a40 <create+0xf0>
      panic("create dots");
80104aae:	83 ec 0c             	sub    $0xc,%esp
80104ab1:	68 e7 76 10 80       	push   $0x801076e7
80104ab6:	e8 d5 b8 ff ff       	call   80100390 <panic>
80104abb:	90                   	nop
80104abc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80104ac0:	31 ff                	xor    %edi,%edi
80104ac2:	e9 fe fe ff ff       	jmp    801049c5 <create+0x75>
    panic("create: dirlink");
80104ac7:	83 ec 0c             	sub    $0xc,%esp
80104aca:	68 f6 76 10 80       	push   $0x801076f6
80104acf:	e8 bc b8 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80104ad4:	83 ec 0c             	sub    $0xc,%esp
80104ad7:	68 d8 76 10 80       	push   $0x801076d8
80104adc:	e8 af b8 ff ff       	call   80100390 <panic>
80104ae1:	eb 0d                	jmp    80104af0 <argfd.constprop.0>
80104ae3:	90                   	nop
80104ae4:	90                   	nop
80104ae5:	90                   	nop
80104ae6:	90                   	nop
80104ae7:	90                   	nop
80104ae8:	90                   	nop
80104ae9:	90                   	nop
80104aea:	90                   	nop
80104aeb:	90                   	nop
80104aec:	90                   	nop
80104aed:	90                   	nop
80104aee:	90                   	nop
80104aef:	90                   	nop

80104af0 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80104af0:	55                   	push   %ebp
80104af1:	89 e5                	mov    %esp,%ebp
80104af3:	56                   	push   %esi
80104af4:	53                   	push   %ebx
80104af5:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80104af7:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80104afa:	89 d6                	mov    %edx,%esi
80104afc:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104aff:	50                   	push   %eax
80104b00:	6a 00                	push   $0x0
80104b02:	e8 f9 fc ff ff       	call   80104800 <argint>
80104b07:	83 c4 10             	add    $0x10,%esp
80104b0a:	85 c0                	test   %eax,%eax
80104b0c:	78 2a                	js     80104b38 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104b0e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104b12:	77 24                	ja     80104b38 <argfd.constprop.0+0x48>
80104b14:	e8 77 ed ff ff       	call   80103890 <myproc>
80104b19:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104b1c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104b20:	85 c0                	test   %eax,%eax
80104b22:	74 14                	je     80104b38 <argfd.constprop.0+0x48>
  if(pfd)
80104b24:	85 db                	test   %ebx,%ebx
80104b26:	74 02                	je     80104b2a <argfd.constprop.0+0x3a>
    *pfd = fd;
80104b28:	89 13                	mov    %edx,(%ebx)
    *pf = f;
80104b2a:	89 06                	mov    %eax,(%esi)
  return 0;
80104b2c:	31 c0                	xor    %eax,%eax
}
80104b2e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b31:	5b                   	pop    %ebx
80104b32:	5e                   	pop    %esi
80104b33:	5d                   	pop    %ebp
80104b34:	c3                   	ret    
80104b35:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104b38:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b3d:	eb ef                	jmp    80104b2e <argfd.constprop.0+0x3e>
80104b3f:	90                   	nop

80104b40 <sys_dup>:
{
80104b40:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80104b41:	31 c0                	xor    %eax,%eax
{
80104b43:	89 e5                	mov    %esp,%ebp
80104b45:	56                   	push   %esi
80104b46:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80104b47:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
80104b4a:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80104b4d:	e8 9e ff ff ff       	call   80104af0 <argfd.constprop.0>
80104b52:	85 c0                	test   %eax,%eax
80104b54:	78 42                	js     80104b98 <sys_dup+0x58>
  if((fd=fdalloc(f)) < 0)
80104b56:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104b59:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80104b5b:	e8 30 ed ff ff       	call   80103890 <myproc>
80104b60:	eb 0e                	jmp    80104b70 <sys_dup+0x30>
80104b62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104b68:	83 c3 01             	add    $0x1,%ebx
80104b6b:	83 fb 10             	cmp    $0x10,%ebx
80104b6e:	74 28                	je     80104b98 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
80104b70:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104b74:	85 d2                	test   %edx,%edx
80104b76:	75 f0                	jne    80104b68 <sys_dup+0x28>
      curproc->ofile[fd] = f;
80104b78:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104b7c:	83 ec 0c             	sub    $0xc,%esp
80104b7f:	ff 75 f4             	pushl  -0xc(%ebp)
80104b82:	e8 69 c2 ff ff       	call   80100df0 <filedup>
  return fd;
80104b87:	83 c4 10             	add    $0x10,%esp
}
80104b8a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b8d:	89 d8                	mov    %ebx,%eax
80104b8f:	5b                   	pop    %ebx
80104b90:	5e                   	pop    %esi
80104b91:	5d                   	pop    %ebp
80104b92:	c3                   	ret    
80104b93:	90                   	nop
80104b94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b98:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104b9b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104ba0:	89 d8                	mov    %ebx,%eax
80104ba2:	5b                   	pop    %ebx
80104ba3:	5e                   	pop    %esi
80104ba4:	5d                   	pop    %ebp
80104ba5:	c3                   	ret    
80104ba6:	8d 76 00             	lea    0x0(%esi),%esi
80104ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104bb0 <sys_read>:
{
80104bb0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104bb1:	31 c0                	xor    %eax,%eax
{
80104bb3:	89 e5                	mov    %esp,%ebp
80104bb5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104bb8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104bbb:	e8 30 ff ff ff       	call   80104af0 <argfd.constprop.0>
80104bc0:	85 c0                	test   %eax,%eax
80104bc2:	78 4c                	js     80104c10 <sys_read+0x60>
80104bc4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104bc7:	83 ec 08             	sub    $0x8,%esp
80104bca:	50                   	push   %eax
80104bcb:	6a 02                	push   $0x2
80104bcd:	e8 2e fc ff ff       	call   80104800 <argint>
80104bd2:	83 c4 10             	add    $0x10,%esp
80104bd5:	85 c0                	test   %eax,%eax
80104bd7:	78 37                	js     80104c10 <sys_read+0x60>
80104bd9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104bdc:	83 ec 04             	sub    $0x4,%esp
80104bdf:	ff 75 f0             	pushl  -0x10(%ebp)
80104be2:	50                   	push   %eax
80104be3:	6a 01                	push   $0x1
80104be5:	e8 66 fc ff ff       	call   80104850 <argptr>
80104bea:	83 c4 10             	add    $0x10,%esp
80104bed:	85 c0                	test   %eax,%eax
80104bef:	78 1f                	js     80104c10 <sys_read+0x60>
  return fileread(f, p, n);
80104bf1:	83 ec 04             	sub    $0x4,%esp
80104bf4:	ff 75 f0             	pushl  -0x10(%ebp)
80104bf7:	ff 75 f4             	pushl  -0xc(%ebp)
80104bfa:	ff 75 ec             	pushl  -0x14(%ebp)
80104bfd:	e8 5e c3 ff ff       	call   80100f60 <fileread>
80104c02:	83 c4 10             	add    $0x10,%esp
}
80104c05:	c9                   	leave  
80104c06:	c3                   	ret    
80104c07:	89 f6                	mov    %esi,%esi
80104c09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80104c10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c15:	c9                   	leave  
80104c16:	c3                   	ret    
80104c17:	89 f6                	mov    %esi,%esi
80104c19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c20 <sys_write>:
{
80104c20:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104c21:	31 c0                	xor    %eax,%eax
{
80104c23:	89 e5                	mov    %esp,%ebp
80104c25:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104c28:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104c2b:	e8 c0 fe ff ff       	call   80104af0 <argfd.constprop.0>
80104c30:	85 c0                	test   %eax,%eax
80104c32:	78 4c                	js     80104c80 <sys_write+0x60>
80104c34:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104c37:	83 ec 08             	sub    $0x8,%esp
80104c3a:	50                   	push   %eax
80104c3b:	6a 02                	push   $0x2
80104c3d:	e8 be fb ff ff       	call   80104800 <argint>
80104c42:	83 c4 10             	add    $0x10,%esp
80104c45:	85 c0                	test   %eax,%eax
80104c47:	78 37                	js     80104c80 <sys_write+0x60>
80104c49:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104c4c:	83 ec 04             	sub    $0x4,%esp
80104c4f:	ff 75 f0             	pushl  -0x10(%ebp)
80104c52:	50                   	push   %eax
80104c53:	6a 01                	push   $0x1
80104c55:	e8 f6 fb ff ff       	call   80104850 <argptr>
80104c5a:	83 c4 10             	add    $0x10,%esp
80104c5d:	85 c0                	test   %eax,%eax
80104c5f:	78 1f                	js     80104c80 <sys_write+0x60>
  return filewrite(f, p, n);
80104c61:	83 ec 04             	sub    $0x4,%esp
80104c64:	ff 75 f0             	pushl  -0x10(%ebp)
80104c67:	ff 75 f4             	pushl  -0xc(%ebp)
80104c6a:	ff 75 ec             	pushl  -0x14(%ebp)
80104c6d:	e8 7e c3 ff ff       	call   80100ff0 <filewrite>
80104c72:	83 c4 10             	add    $0x10,%esp
}
80104c75:	c9                   	leave  
80104c76:	c3                   	ret    
80104c77:	89 f6                	mov    %esi,%esi
80104c79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80104c80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c85:	c9                   	leave  
80104c86:	c3                   	ret    
80104c87:	89 f6                	mov    %esi,%esi
80104c89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c90 <sys_close>:
{
80104c90:	55                   	push   %ebp
80104c91:	89 e5                	mov    %esp,%ebp
80104c93:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80104c96:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104c99:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104c9c:	e8 4f fe ff ff       	call   80104af0 <argfd.constprop.0>
80104ca1:	85 c0                	test   %eax,%eax
80104ca3:	78 2b                	js     80104cd0 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80104ca5:	e8 e6 eb ff ff       	call   80103890 <myproc>
80104caa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80104cad:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80104cb0:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104cb7:	00 
  fileclose(f);
80104cb8:	ff 75 f4             	pushl  -0xc(%ebp)
80104cbb:	e8 80 c1 ff ff       	call   80100e40 <fileclose>
  return 0;
80104cc0:	83 c4 10             	add    $0x10,%esp
80104cc3:	31 c0                	xor    %eax,%eax
}
80104cc5:	c9                   	leave  
80104cc6:	c3                   	ret    
80104cc7:	89 f6                	mov    %esi,%esi
80104cc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80104cd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104cd5:	c9                   	leave  
80104cd6:	c3                   	ret    
80104cd7:	89 f6                	mov    %esi,%esi
80104cd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ce0 <sys_fstat>:
{
80104ce0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104ce1:	31 c0                	xor    %eax,%eax
{
80104ce3:	89 e5                	mov    %esp,%ebp
80104ce5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104ce8:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104ceb:	e8 00 fe ff ff       	call   80104af0 <argfd.constprop.0>
80104cf0:	85 c0                	test   %eax,%eax
80104cf2:	78 2c                	js     80104d20 <sys_fstat+0x40>
80104cf4:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104cf7:	83 ec 04             	sub    $0x4,%esp
80104cfa:	6a 14                	push   $0x14
80104cfc:	50                   	push   %eax
80104cfd:	6a 01                	push   $0x1
80104cff:	e8 4c fb ff ff       	call   80104850 <argptr>
80104d04:	83 c4 10             	add    $0x10,%esp
80104d07:	85 c0                	test   %eax,%eax
80104d09:	78 15                	js     80104d20 <sys_fstat+0x40>
  return filestat(f, st);
80104d0b:	83 ec 08             	sub    $0x8,%esp
80104d0e:	ff 75 f4             	pushl  -0xc(%ebp)
80104d11:	ff 75 f0             	pushl  -0x10(%ebp)
80104d14:	e8 f7 c1 ff ff       	call   80100f10 <filestat>
80104d19:	83 c4 10             	add    $0x10,%esp
}
80104d1c:	c9                   	leave  
80104d1d:	c3                   	ret    
80104d1e:	66 90                	xchg   %ax,%ax
    return -1;
80104d20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d25:	c9                   	leave  
80104d26:	c3                   	ret    
80104d27:	89 f6                	mov    %esi,%esi
80104d29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d30 <sys_link>:
{
80104d30:	55                   	push   %ebp
80104d31:	89 e5                	mov    %esp,%ebp
80104d33:	57                   	push   %edi
80104d34:	56                   	push   %esi
80104d35:	53                   	push   %ebx
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104d36:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80104d39:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104d3c:	50                   	push   %eax
80104d3d:	6a 00                	push   $0x0
80104d3f:	e8 6c fb ff ff       	call   801048b0 <argstr>
80104d44:	83 c4 10             	add    $0x10,%esp
80104d47:	85 c0                	test   %eax,%eax
80104d49:	0f 88 fb 00 00 00    	js     80104e4a <sys_link+0x11a>
80104d4f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104d52:	83 ec 08             	sub    $0x8,%esp
80104d55:	50                   	push   %eax
80104d56:	6a 01                	push   $0x1
80104d58:	e8 53 fb ff ff       	call   801048b0 <argstr>
80104d5d:	83 c4 10             	add    $0x10,%esp
80104d60:	85 c0                	test   %eax,%eax
80104d62:	0f 88 e2 00 00 00    	js     80104e4a <sys_link+0x11a>
  begin_op();
80104d68:	e8 e3 de ff ff       	call   80102c50 <begin_op>
  if((ip = namei(old)) == 0){
80104d6d:	83 ec 0c             	sub    $0xc,%esp
80104d70:	ff 75 d4             	pushl  -0x2c(%ebp)
80104d73:	e8 18 d2 ff ff       	call   80101f90 <namei>
80104d78:	83 c4 10             	add    $0x10,%esp
80104d7b:	85 c0                	test   %eax,%eax
80104d7d:	89 c3                	mov    %eax,%ebx
80104d7f:	0f 84 ea 00 00 00    	je     80104e6f <sys_link+0x13f>
  ilock(ip);
80104d85:	83 ec 0c             	sub    $0xc,%esp
80104d88:	50                   	push   %eax
80104d89:	e8 02 c9 ff ff       	call   80101690 <ilock>
  if(ip->type == T_DIR){
80104d8e:	83 c4 10             	add    $0x10,%esp
80104d91:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104d96:	0f 84 bb 00 00 00    	je     80104e57 <sys_link+0x127>
  ip->nlink++;
80104d9c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80104da1:	83 ec 0c             	sub    $0xc,%esp
  if((dp = nameiparent(new, name)) == 0)
80104da4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80104da7:	53                   	push   %ebx
80104da8:	e8 33 c8 ff ff       	call   801015e0 <iupdate>
  iunlock(ip);
80104dad:	89 1c 24             	mov    %ebx,(%esp)
80104db0:	e8 bb c9 ff ff       	call   80101770 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80104db5:	58                   	pop    %eax
80104db6:	5a                   	pop    %edx
80104db7:	57                   	push   %edi
80104db8:	ff 75 d0             	pushl  -0x30(%ebp)
80104dbb:	e8 f0 d1 ff ff       	call   80101fb0 <nameiparent>
80104dc0:	83 c4 10             	add    $0x10,%esp
80104dc3:	85 c0                	test   %eax,%eax
80104dc5:	89 c6                	mov    %eax,%esi
80104dc7:	74 5b                	je     80104e24 <sys_link+0xf4>
  ilock(dp);
80104dc9:	83 ec 0c             	sub    $0xc,%esp
80104dcc:	50                   	push   %eax
80104dcd:	e8 be c8 ff ff       	call   80101690 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104dd2:	83 c4 10             	add    $0x10,%esp
80104dd5:	8b 03                	mov    (%ebx),%eax
80104dd7:	39 06                	cmp    %eax,(%esi)
80104dd9:	75 3d                	jne    80104e18 <sys_link+0xe8>
80104ddb:	83 ec 04             	sub    $0x4,%esp
80104dde:	ff 73 04             	pushl  0x4(%ebx)
80104de1:	57                   	push   %edi
80104de2:	56                   	push   %esi
80104de3:	e8 e8 d0 ff ff       	call   80101ed0 <dirlink>
80104de8:	83 c4 10             	add    $0x10,%esp
80104deb:	85 c0                	test   %eax,%eax
80104ded:	78 29                	js     80104e18 <sys_link+0xe8>
  iunlockput(dp);
80104def:	83 ec 0c             	sub    $0xc,%esp
80104df2:	56                   	push   %esi
80104df3:	e8 28 cb ff ff       	call   80101920 <iunlockput>
  iput(ip);
80104df8:	89 1c 24             	mov    %ebx,(%esp)
80104dfb:	e8 c0 c9 ff ff       	call   801017c0 <iput>
  end_op();
80104e00:	e8 bb de ff ff       	call   80102cc0 <end_op>
  return 0;
80104e05:	83 c4 10             	add    $0x10,%esp
80104e08:	31 c0                	xor    %eax,%eax
}
80104e0a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e0d:	5b                   	pop    %ebx
80104e0e:	5e                   	pop    %esi
80104e0f:	5f                   	pop    %edi
80104e10:	5d                   	pop    %ebp
80104e11:	c3                   	ret    
80104e12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80104e18:	83 ec 0c             	sub    $0xc,%esp
80104e1b:	56                   	push   %esi
80104e1c:	e8 ff ca ff ff       	call   80101920 <iunlockput>
    goto bad;
80104e21:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80104e24:	83 ec 0c             	sub    $0xc,%esp
80104e27:	53                   	push   %ebx
80104e28:	e8 63 c8 ff ff       	call   80101690 <ilock>
  ip->nlink--;
80104e2d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104e32:	89 1c 24             	mov    %ebx,(%esp)
80104e35:	e8 a6 c7 ff ff       	call   801015e0 <iupdate>
  iunlockput(ip);
80104e3a:	89 1c 24             	mov    %ebx,(%esp)
80104e3d:	e8 de ca ff ff       	call   80101920 <iunlockput>
  end_op();
80104e42:	e8 79 de ff ff       	call   80102cc0 <end_op>
  return -1;
80104e47:	83 c4 10             	add    $0x10,%esp
}
80104e4a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80104e4d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e52:	5b                   	pop    %ebx
80104e53:	5e                   	pop    %esi
80104e54:	5f                   	pop    %edi
80104e55:	5d                   	pop    %ebp
80104e56:	c3                   	ret    
    iunlockput(ip);
80104e57:	83 ec 0c             	sub    $0xc,%esp
80104e5a:	53                   	push   %ebx
80104e5b:	e8 c0 ca ff ff       	call   80101920 <iunlockput>
    end_op();
80104e60:	e8 5b de ff ff       	call   80102cc0 <end_op>
    return -1;
80104e65:	83 c4 10             	add    $0x10,%esp
80104e68:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e6d:	eb 9b                	jmp    80104e0a <sys_link+0xda>
    end_op();
80104e6f:	e8 4c de ff ff       	call   80102cc0 <end_op>
    return -1;
80104e74:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e79:	eb 8f                	jmp    80104e0a <sys_link+0xda>
80104e7b:	90                   	nop
80104e7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104e80 <sys_unlink>:
{
80104e80:	55                   	push   %ebp
80104e81:	89 e5                	mov    %esp,%ebp
80104e83:	57                   	push   %edi
80104e84:	56                   	push   %esi
80104e85:	53                   	push   %ebx
  if(argstr(0, &path) < 0)
80104e86:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80104e89:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
80104e8c:	50                   	push   %eax
80104e8d:	6a 00                	push   $0x0
80104e8f:	e8 1c fa ff ff       	call   801048b0 <argstr>
80104e94:	83 c4 10             	add    $0x10,%esp
80104e97:	85 c0                	test   %eax,%eax
80104e99:	0f 88 77 01 00 00    	js     80105016 <sys_unlink+0x196>
  if((dp = nameiparent(path, name)) == 0){
80104e9f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
80104ea2:	e8 a9 dd ff ff       	call   80102c50 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80104ea7:	83 ec 08             	sub    $0x8,%esp
80104eaa:	53                   	push   %ebx
80104eab:	ff 75 c0             	pushl  -0x40(%ebp)
80104eae:	e8 fd d0 ff ff       	call   80101fb0 <nameiparent>
80104eb3:	83 c4 10             	add    $0x10,%esp
80104eb6:	85 c0                	test   %eax,%eax
80104eb8:	89 c6                	mov    %eax,%esi
80104eba:	0f 84 60 01 00 00    	je     80105020 <sys_unlink+0x1a0>
  ilock(dp);
80104ec0:	83 ec 0c             	sub    $0xc,%esp
80104ec3:	50                   	push   %eax
80104ec4:	e8 c7 c7 ff ff       	call   80101690 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104ec9:	58                   	pop    %eax
80104eca:	5a                   	pop    %edx
80104ecb:	68 f4 76 10 80       	push   $0x801076f4
80104ed0:	53                   	push   %ebx
80104ed1:	e8 6a cd ff ff       	call   80101c40 <namecmp>
80104ed6:	83 c4 10             	add    $0x10,%esp
80104ed9:	85 c0                	test   %eax,%eax
80104edb:	0f 84 03 01 00 00    	je     80104fe4 <sys_unlink+0x164>
80104ee1:	83 ec 08             	sub    $0x8,%esp
80104ee4:	68 f3 76 10 80       	push   $0x801076f3
80104ee9:	53                   	push   %ebx
80104eea:	e8 51 cd ff ff       	call   80101c40 <namecmp>
80104eef:	83 c4 10             	add    $0x10,%esp
80104ef2:	85 c0                	test   %eax,%eax
80104ef4:	0f 84 ea 00 00 00    	je     80104fe4 <sys_unlink+0x164>
  if((ip = dirlookup(dp, name, &off)) == 0)
80104efa:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104efd:	83 ec 04             	sub    $0x4,%esp
80104f00:	50                   	push   %eax
80104f01:	53                   	push   %ebx
80104f02:	56                   	push   %esi
80104f03:	e8 58 cd ff ff       	call   80101c60 <dirlookup>
80104f08:	83 c4 10             	add    $0x10,%esp
80104f0b:	85 c0                	test   %eax,%eax
80104f0d:	89 c3                	mov    %eax,%ebx
80104f0f:	0f 84 cf 00 00 00    	je     80104fe4 <sys_unlink+0x164>
  ilock(ip);
80104f15:	83 ec 0c             	sub    $0xc,%esp
80104f18:	50                   	push   %eax
80104f19:	e8 72 c7 ff ff       	call   80101690 <ilock>
  if(ip->nlink < 1)
80104f1e:	83 c4 10             	add    $0x10,%esp
80104f21:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80104f26:	0f 8e 10 01 00 00    	jle    8010503c <sys_unlink+0x1bc>
  if(ip->type == T_DIR && !isdirempty(ip)){
80104f2c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104f31:	74 6d                	je     80104fa0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80104f33:	8d 45 d8             	lea    -0x28(%ebp),%eax
80104f36:	83 ec 04             	sub    $0x4,%esp
80104f39:	6a 10                	push   $0x10
80104f3b:	6a 00                	push   $0x0
80104f3d:	50                   	push   %eax
80104f3e:	e8 bd f5 ff ff       	call   80104500 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104f43:	8d 45 d8             	lea    -0x28(%ebp),%eax
80104f46:	6a 10                	push   $0x10
80104f48:	ff 75 c4             	pushl  -0x3c(%ebp)
80104f4b:	50                   	push   %eax
80104f4c:	56                   	push   %esi
80104f4d:	e8 4e cb ff ff       	call   80101aa0 <writei>
80104f52:	83 c4 20             	add    $0x20,%esp
80104f55:	83 f8 10             	cmp    $0x10,%eax
80104f58:	0f 85 eb 00 00 00    	jne    80105049 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
80104f5e:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104f63:	0f 84 97 00 00 00    	je     80105000 <sys_unlink+0x180>
  iunlockput(dp);
80104f69:	83 ec 0c             	sub    $0xc,%esp
80104f6c:	56                   	push   %esi
80104f6d:	e8 ae c9 ff ff       	call   80101920 <iunlockput>
  ip->nlink--;
80104f72:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104f77:	89 1c 24             	mov    %ebx,(%esp)
80104f7a:	e8 61 c6 ff ff       	call   801015e0 <iupdate>
  iunlockput(ip);
80104f7f:	89 1c 24             	mov    %ebx,(%esp)
80104f82:	e8 99 c9 ff ff       	call   80101920 <iunlockput>
  end_op();
80104f87:	e8 34 dd ff ff       	call   80102cc0 <end_op>
  return 0;
80104f8c:	83 c4 10             	add    $0x10,%esp
80104f8f:	31 c0                	xor    %eax,%eax
}
80104f91:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f94:	5b                   	pop    %ebx
80104f95:	5e                   	pop    %esi
80104f96:	5f                   	pop    %edi
80104f97:	5d                   	pop    %ebp
80104f98:	c3                   	ret    
80104f99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80104fa0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80104fa4:	76 8d                	jbe    80104f33 <sys_unlink+0xb3>
80104fa6:	bf 20 00 00 00       	mov    $0x20,%edi
80104fab:	eb 0f                	jmp    80104fbc <sys_unlink+0x13c>
80104fad:	8d 76 00             	lea    0x0(%esi),%esi
80104fb0:	83 c7 10             	add    $0x10,%edi
80104fb3:	3b 7b 58             	cmp    0x58(%ebx),%edi
80104fb6:	0f 83 77 ff ff ff    	jae    80104f33 <sys_unlink+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104fbc:	8d 45 d8             	lea    -0x28(%ebp),%eax
80104fbf:	6a 10                	push   $0x10
80104fc1:	57                   	push   %edi
80104fc2:	50                   	push   %eax
80104fc3:	53                   	push   %ebx
80104fc4:	e8 a7 c9 ff ff       	call   80101970 <readi>
80104fc9:	83 c4 10             	add    $0x10,%esp
80104fcc:	83 f8 10             	cmp    $0x10,%eax
80104fcf:	75 5e                	jne    8010502f <sys_unlink+0x1af>
    if(de.inum != 0)
80104fd1:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80104fd6:	74 d8                	je     80104fb0 <sys_unlink+0x130>
    iunlockput(ip);
80104fd8:	83 ec 0c             	sub    $0xc,%esp
80104fdb:	53                   	push   %ebx
80104fdc:	e8 3f c9 ff ff       	call   80101920 <iunlockput>
    goto bad;
80104fe1:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
80104fe4:	83 ec 0c             	sub    $0xc,%esp
80104fe7:	56                   	push   %esi
80104fe8:	e8 33 c9 ff ff       	call   80101920 <iunlockput>
  end_op();
80104fed:	e8 ce dc ff ff       	call   80102cc0 <end_op>
  return -1;
80104ff2:	83 c4 10             	add    $0x10,%esp
80104ff5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ffa:	eb 95                	jmp    80104f91 <sys_unlink+0x111>
80104ffc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink--;
80105000:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105005:	83 ec 0c             	sub    $0xc,%esp
80105008:	56                   	push   %esi
80105009:	e8 d2 c5 ff ff       	call   801015e0 <iupdate>
8010500e:	83 c4 10             	add    $0x10,%esp
80105011:	e9 53 ff ff ff       	jmp    80104f69 <sys_unlink+0xe9>
    return -1;
80105016:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010501b:	e9 71 ff ff ff       	jmp    80104f91 <sys_unlink+0x111>
    end_op();
80105020:	e8 9b dc ff ff       	call   80102cc0 <end_op>
    return -1;
80105025:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010502a:	e9 62 ff ff ff       	jmp    80104f91 <sys_unlink+0x111>
      panic("isdirempty: readi");
8010502f:	83 ec 0c             	sub    $0xc,%esp
80105032:	68 18 77 10 80       	push   $0x80107718
80105037:	e8 54 b3 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
8010503c:	83 ec 0c             	sub    $0xc,%esp
8010503f:	68 06 77 10 80       	push   $0x80107706
80105044:	e8 47 b3 ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80105049:	83 ec 0c             	sub    $0xc,%esp
8010504c:	68 2a 77 10 80       	push   $0x8010772a
80105051:	e8 3a b3 ff ff       	call   80100390 <panic>
80105056:	8d 76 00             	lea    0x0(%esi),%esi
80105059:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105060 <sys_open>:

int
sys_open(void)
{
80105060:	55                   	push   %ebp
80105061:	89 e5                	mov    %esp,%ebp
80105063:	57                   	push   %edi
80105064:	56                   	push   %esi
80105065:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105066:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105069:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010506c:	50                   	push   %eax
8010506d:	6a 00                	push   $0x0
8010506f:	e8 3c f8 ff ff       	call   801048b0 <argstr>
80105074:	83 c4 10             	add    $0x10,%esp
80105077:	85 c0                	test   %eax,%eax
80105079:	0f 88 5d 01 00 00    	js     801051dc <sys_open+0x17c>
8010507f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105082:	83 ec 08             	sub    $0x8,%esp
80105085:	50                   	push   %eax
80105086:	6a 01                	push   $0x1
80105088:	e8 73 f7 ff ff       	call   80104800 <argint>
8010508d:	83 c4 10             	add    $0x10,%esp
80105090:	85 c0                	test   %eax,%eax
80105092:	0f 88 44 01 00 00    	js     801051dc <sys_open+0x17c>
    return -1;

  begin_op();
80105098:	e8 b3 db ff ff       	call   80102c50 <begin_op>

  if(omode & O_CREATE){
8010509d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801050a0:	f6 c6 02             	test   $0x2,%dh
801050a3:	0f 85 e7 00 00 00    	jne    80105190 <sys_open+0x130>
    cprintf("%d\n",ip->type);
    if(ip == 0){
      end_op();
      return -1;
    }
  } else if(omode & O_SMALL){
801050a9:	80 e6 04             	and    $0x4,%dh
801050ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
801050af:	0f 85 ab 00 00 00    	jne    80105160 <sys_open+0x100>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {    
    if((ip = namei(path)) == 0){// path node exits
801050b5:	83 ec 0c             	sub    $0xc,%esp
801050b8:	50                   	push   %eax
801050b9:	e8 d2 ce ff ff       	call   80101f90 <namei>
801050be:	83 c4 10             	add    $0x10,%esp
801050c1:	85 c0                	test   %eax,%eax
801050c3:	89 c6                	mov    %eax,%esi
801050c5:	0f 84 b3 00 00 00    	je     8010517e <sys_open+0x11e>
      end_op();
      return -1;
    }
    ilock(ip);
801050cb:	83 ec 0c             	sub    $0xc,%esp
801050ce:	50                   	push   %eax
801050cf:	e8 bc c5 ff ff       	call   80101690 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801050d4:	83 c4 10             	add    $0x10,%esp
801050d7:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801050dc:	0f 84 de 00 00 00    	je     801051c0 <sys_open+0x160>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801050e2:	e8 99 bc ff ff       	call   80100d80 <filealloc>
801050e7:	85 c0                	test   %eax,%eax
801050e9:	89 c7                	mov    %eax,%edi
801050eb:	0f 84 da 00 00 00    	je     801051cb <sys_open+0x16b>
  struct proc *curproc = myproc();
801050f1:	e8 9a e7 ff ff       	call   80103890 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801050f6:	31 db                	xor    %ebx,%ebx
801050f8:	eb 12                	jmp    8010510c <sys_open+0xac>
801050fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105100:	83 c3 01             	add    $0x1,%ebx
80105103:	83 fb 10             	cmp    $0x10,%ebx
80105106:	0f 84 e4 00 00 00    	je     801051f0 <sys_open+0x190>
    if(curproc->ofile[fd] == 0){
8010510c:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105110:	85 d2                	test   %edx,%edx
80105112:	75 ec                	jne    80105100 <sys_open+0xa0>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105114:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105117:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010511b:	56                   	push   %esi
8010511c:	e8 4f c6 ff ff       	call   80101770 <iunlock>
  end_op();
80105121:	e8 9a db ff ff       	call   80102cc0 <end_op>

  f->type = FD_INODE;
80105126:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
8010512c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010512f:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105132:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105135:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
8010513c:	89 d0                	mov    %edx,%eax
8010513e:	f7 d0                	not    %eax
80105140:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105143:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105146:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105149:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
8010514d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105150:	89 d8                	mov    %ebx,%eax
80105152:	5b                   	pop    %ebx
80105153:	5e                   	pop    %esi
80105154:	5f                   	pop    %edi
80105155:	5d                   	pop    %ebp
80105156:	c3                   	ret    
80105157:	89 f6                	mov    %esi,%esi
80105159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_SMALLFILE, 0, 0);
80105160:	83 ec 0c             	sub    $0xc,%esp
80105163:	31 c9                	xor    %ecx,%ecx
80105165:	ba 04 00 00 00       	mov    $0x4,%edx
8010516a:	6a 00                	push   $0x0
8010516c:	e8 df f7 ff ff       	call   80104950 <create>
    if(ip == 0){
80105171:	83 c4 10             	add    $0x10,%esp
80105174:	85 c0                	test   %eax,%eax
    ip = create(path, T_SMALLFILE, 0, 0);
80105176:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105178:	0f 85 64 ff ff ff    	jne    801050e2 <sys_open+0x82>
      end_op();
8010517e:	e8 3d db ff ff       	call   80102cc0 <end_op>
      return -1;
80105183:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105188:	eb c3                	jmp    8010514d <sys_open+0xed>
8010518a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    ip = create(path, T_FILE, 0, 0); //create fail
80105190:	83 ec 0c             	sub    $0xc,%esp
80105193:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105196:	31 c9                	xor    %ecx,%ecx
80105198:	6a 00                	push   $0x0
8010519a:	ba 02 00 00 00       	mov    $0x2,%edx
8010519f:	e8 ac f7 ff ff       	call   80104950 <create>
801051a4:	89 c6                	mov    %eax,%esi
    cprintf("%d\n",ip->type);
801051a6:	0f bf 40 50          	movswl 0x50(%eax),%eax
801051aa:	5b                   	pop    %ebx
801051ab:	5f                   	pop    %edi
801051ac:	50                   	push   %eax
801051ad:	68 94 74 10 80       	push   $0x80107494
801051b2:	e8 a9 b4 ff ff       	call   80100660 <cprintf>
801051b7:	83 c4 10             	add    $0x10,%esp
801051ba:	e9 23 ff ff ff       	jmp    801050e2 <sys_open+0x82>
801051bf:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
801051c0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801051c3:	85 c9                	test   %ecx,%ecx
801051c5:	0f 84 17 ff ff ff    	je     801050e2 <sys_open+0x82>
    iunlockput(ip);
801051cb:	83 ec 0c             	sub    $0xc,%esp
801051ce:	56                   	push   %esi
801051cf:	e8 4c c7 ff ff       	call   80101920 <iunlockput>
    end_op();
801051d4:	e8 e7 da ff ff       	call   80102cc0 <end_op>
    return -1;
801051d9:	83 c4 10             	add    $0x10,%esp
801051dc:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801051e1:	e9 67 ff ff ff       	jmp    8010514d <sys_open+0xed>
801051e6:	8d 76 00             	lea    0x0(%esi),%esi
801051e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      fileclose(f);
801051f0:	83 ec 0c             	sub    $0xc,%esp
801051f3:	57                   	push   %edi
801051f4:	e8 47 bc ff ff       	call   80100e40 <fileclose>
801051f9:	83 c4 10             	add    $0x10,%esp
801051fc:	eb cd                	jmp    801051cb <sys_open+0x16b>
801051fe:	66 90                	xchg   %ax,%ax

80105200 <sys_mkdir>:

int
sys_mkdir(void)
{
80105200:	55                   	push   %ebp
80105201:	89 e5                	mov    %esp,%ebp
80105203:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105206:	e8 45 da ff ff       	call   80102c50 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010520b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010520e:	83 ec 08             	sub    $0x8,%esp
80105211:	50                   	push   %eax
80105212:	6a 00                	push   $0x0
80105214:	e8 97 f6 ff ff       	call   801048b0 <argstr>
80105219:	83 c4 10             	add    $0x10,%esp
8010521c:	85 c0                	test   %eax,%eax
8010521e:	78 30                	js     80105250 <sys_mkdir+0x50>
80105220:	83 ec 0c             	sub    $0xc,%esp
80105223:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105226:	31 c9                	xor    %ecx,%ecx
80105228:	6a 00                	push   $0x0
8010522a:	ba 01 00 00 00       	mov    $0x1,%edx
8010522f:	e8 1c f7 ff ff       	call   80104950 <create>
80105234:	83 c4 10             	add    $0x10,%esp
80105237:	85 c0                	test   %eax,%eax
80105239:	74 15                	je     80105250 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010523b:	83 ec 0c             	sub    $0xc,%esp
8010523e:	50                   	push   %eax
8010523f:	e8 dc c6 ff ff       	call   80101920 <iunlockput>
  end_op();
80105244:	e8 77 da ff ff       	call   80102cc0 <end_op>
  return 0;
80105249:	83 c4 10             	add    $0x10,%esp
8010524c:	31 c0                	xor    %eax,%eax
}
8010524e:	c9                   	leave  
8010524f:	c3                   	ret    
    end_op();
80105250:	e8 6b da ff ff       	call   80102cc0 <end_op>
    return -1;
80105255:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010525a:	c9                   	leave  
8010525b:	c3                   	ret    
8010525c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105260 <sys_mknod>:

int
sys_mknod(void)
{
80105260:	55                   	push   %ebp
80105261:	89 e5                	mov    %esp,%ebp
80105263:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105266:	e8 e5 d9 ff ff       	call   80102c50 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010526b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010526e:	83 ec 08             	sub    $0x8,%esp
80105271:	50                   	push   %eax
80105272:	6a 00                	push   $0x0
80105274:	e8 37 f6 ff ff       	call   801048b0 <argstr>
80105279:	83 c4 10             	add    $0x10,%esp
8010527c:	85 c0                	test   %eax,%eax
8010527e:	78 60                	js     801052e0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105280:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105283:	83 ec 08             	sub    $0x8,%esp
80105286:	50                   	push   %eax
80105287:	6a 01                	push   $0x1
80105289:	e8 72 f5 ff ff       	call   80104800 <argint>
  if((argstr(0, &path)) < 0 ||
8010528e:	83 c4 10             	add    $0x10,%esp
80105291:	85 c0                	test   %eax,%eax
80105293:	78 4b                	js     801052e0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105295:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105298:	83 ec 08             	sub    $0x8,%esp
8010529b:	50                   	push   %eax
8010529c:	6a 02                	push   $0x2
8010529e:	e8 5d f5 ff ff       	call   80104800 <argint>
     argint(1, &major) < 0 ||
801052a3:	83 c4 10             	add    $0x10,%esp
801052a6:	85 c0                	test   %eax,%eax
801052a8:	78 36                	js     801052e0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
801052aa:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
801052ae:	83 ec 0c             	sub    $0xc,%esp
     (ip = create(path, T_DEV, major, minor)) == 0){
801052b1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
     argint(2, &minor) < 0 ||
801052b5:	ba 03 00 00 00       	mov    $0x3,%edx
801052ba:	50                   	push   %eax
801052bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801052be:	e8 8d f6 ff ff       	call   80104950 <create>
801052c3:	83 c4 10             	add    $0x10,%esp
801052c6:	85 c0                	test   %eax,%eax
801052c8:	74 16                	je     801052e0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
801052ca:	83 ec 0c             	sub    $0xc,%esp
801052cd:	50                   	push   %eax
801052ce:	e8 4d c6 ff ff       	call   80101920 <iunlockput>
  end_op();
801052d3:	e8 e8 d9 ff ff       	call   80102cc0 <end_op>
  return 0;
801052d8:	83 c4 10             	add    $0x10,%esp
801052db:	31 c0                	xor    %eax,%eax
}
801052dd:	c9                   	leave  
801052de:	c3                   	ret    
801052df:	90                   	nop
    end_op();
801052e0:	e8 db d9 ff ff       	call   80102cc0 <end_op>
    return -1;
801052e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801052ea:	c9                   	leave  
801052eb:	c3                   	ret    
801052ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801052f0 <sys_chdir>:

int
sys_chdir(void)
{
801052f0:	55                   	push   %ebp
801052f1:	89 e5                	mov    %esp,%ebp
801052f3:	56                   	push   %esi
801052f4:	53                   	push   %ebx
801052f5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801052f8:	e8 93 e5 ff ff       	call   80103890 <myproc>
801052fd:	89 c6                	mov    %eax,%esi
  
  begin_op();
801052ff:	e8 4c d9 ff ff       	call   80102c50 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105304:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105307:	83 ec 08             	sub    $0x8,%esp
8010530a:	50                   	push   %eax
8010530b:	6a 00                	push   $0x0
8010530d:	e8 9e f5 ff ff       	call   801048b0 <argstr>
80105312:	83 c4 10             	add    $0x10,%esp
80105315:	85 c0                	test   %eax,%eax
80105317:	78 77                	js     80105390 <sys_chdir+0xa0>
80105319:	83 ec 0c             	sub    $0xc,%esp
8010531c:	ff 75 f4             	pushl  -0xc(%ebp)
8010531f:	e8 6c cc ff ff       	call   80101f90 <namei>
80105324:	83 c4 10             	add    $0x10,%esp
80105327:	85 c0                	test   %eax,%eax
80105329:	89 c3                	mov    %eax,%ebx
8010532b:	74 63                	je     80105390 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010532d:	83 ec 0c             	sub    $0xc,%esp
80105330:	50                   	push   %eax
80105331:	e8 5a c3 ff ff       	call   80101690 <ilock>
  if(ip->type != T_DIR){
80105336:	83 c4 10             	add    $0x10,%esp
80105339:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010533e:	75 30                	jne    80105370 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105340:	83 ec 0c             	sub    $0xc,%esp
80105343:	53                   	push   %ebx
80105344:	e8 27 c4 ff ff       	call   80101770 <iunlock>
  iput(curproc->cwd);
80105349:	58                   	pop    %eax
8010534a:	ff 76 68             	pushl  0x68(%esi)
8010534d:	e8 6e c4 ff ff       	call   801017c0 <iput>
  end_op();
80105352:	e8 69 d9 ff ff       	call   80102cc0 <end_op>
  curproc->cwd = ip;
80105357:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010535a:	83 c4 10             	add    $0x10,%esp
8010535d:	31 c0                	xor    %eax,%eax
}
8010535f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105362:	5b                   	pop    %ebx
80105363:	5e                   	pop    %esi
80105364:	5d                   	pop    %ebp
80105365:	c3                   	ret    
80105366:	8d 76 00             	lea    0x0(%esi),%esi
80105369:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
80105370:	83 ec 0c             	sub    $0xc,%esp
80105373:	53                   	push   %ebx
80105374:	e8 a7 c5 ff ff       	call   80101920 <iunlockput>
    end_op();
80105379:	e8 42 d9 ff ff       	call   80102cc0 <end_op>
    return -1;
8010537e:	83 c4 10             	add    $0x10,%esp
80105381:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105386:	eb d7                	jmp    8010535f <sys_chdir+0x6f>
80105388:	90                   	nop
80105389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105390:	e8 2b d9 ff ff       	call   80102cc0 <end_op>
    return -1;
80105395:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010539a:	eb c3                	jmp    8010535f <sys_chdir+0x6f>
8010539c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801053a0 <sys_exec>:

int
sys_exec(void)
{
801053a0:	55                   	push   %ebp
801053a1:	89 e5                	mov    %esp,%ebp
801053a3:	57                   	push   %edi
801053a4:	56                   	push   %esi
801053a5:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801053a6:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
801053ac:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801053b2:	50                   	push   %eax
801053b3:	6a 00                	push   $0x0
801053b5:	e8 f6 f4 ff ff       	call   801048b0 <argstr>
801053ba:	83 c4 10             	add    $0x10,%esp
801053bd:	85 c0                	test   %eax,%eax
801053bf:	0f 88 87 00 00 00    	js     8010544c <sys_exec+0xac>
801053c5:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801053cb:	83 ec 08             	sub    $0x8,%esp
801053ce:	50                   	push   %eax
801053cf:	6a 01                	push   $0x1
801053d1:	e8 2a f4 ff ff       	call   80104800 <argint>
801053d6:	83 c4 10             	add    $0x10,%esp
801053d9:	85 c0                	test   %eax,%eax
801053db:	78 6f                	js     8010544c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801053dd:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801053e3:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
801053e6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801053e8:	68 80 00 00 00       	push   $0x80
801053ed:	6a 00                	push   $0x0
801053ef:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
801053f5:	50                   	push   %eax
801053f6:	e8 05 f1 ff ff       	call   80104500 <memset>
801053fb:	83 c4 10             	add    $0x10,%esp
801053fe:	eb 2c                	jmp    8010542c <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
80105400:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105406:	85 c0                	test   %eax,%eax
80105408:	74 56                	je     80105460 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
8010540a:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105410:	83 ec 08             	sub    $0x8,%esp
80105413:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105416:	52                   	push   %edx
80105417:	50                   	push   %eax
80105418:	e8 73 f3 ff ff       	call   80104790 <fetchstr>
8010541d:	83 c4 10             	add    $0x10,%esp
80105420:	85 c0                	test   %eax,%eax
80105422:	78 28                	js     8010544c <sys_exec+0xac>
  for(i=0;; i++){
80105424:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105427:	83 fb 20             	cmp    $0x20,%ebx
8010542a:	74 20                	je     8010544c <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
8010542c:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105432:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105439:	83 ec 08             	sub    $0x8,%esp
8010543c:	57                   	push   %edi
8010543d:	01 f0                	add    %esi,%eax
8010543f:	50                   	push   %eax
80105440:	e8 0b f3 ff ff       	call   80104750 <fetchint>
80105445:	83 c4 10             	add    $0x10,%esp
80105448:	85 c0                	test   %eax,%eax
8010544a:	79 b4                	jns    80105400 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010544c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010544f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105454:	5b                   	pop    %ebx
80105455:	5e                   	pop    %esi
80105456:	5f                   	pop    %edi
80105457:	5d                   	pop    %ebp
80105458:	c3                   	ret    
80105459:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105460:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105466:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80105469:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105470:	00 00 00 00 
  return exec(path, argv);
80105474:	50                   	push   %eax
80105475:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
8010547b:	e8 90 b5 ff ff       	call   80100a10 <exec>
80105480:	83 c4 10             	add    $0x10,%esp
}
80105483:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105486:	5b                   	pop    %ebx
80105487:	5e                   	pop    %esi
80105488:	5f                   	pop    %edi
80105489:	5d                   	pop    %ebp
8010548a:	c3                   	ret    
8010548b:	90                   	nop
8010548c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105490 <sys_pipe>:

int
sys_pipe(void)
{
80105490:	55                   	push   %ebp
80105491:	89 e5                	mov    %esp,%ebp
80105493:	57                   	push   %edi
80105494:	56                   	push   %esi
80105495:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105496:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105499:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010549c:	6a 08                	push   $0x8
8010549e:	50                   	push   %eax
8010549f:	6a 00                	push   $0x0
801054a1:	e8 aa f3 ff ff       	call   80104850 <argptr>
801054a6:	83 c4 10             	add    $0x10,%esp
801054a9:	85 c0                	test   %eax,%eax
801054ab:	0f 88 ae 00 00 00    	js     8010555f <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801054b1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801054b4:	83 ec 08             	sub    $0x8,%esp
801054b7:	50                   	push   %eax
801054b8:	8d 45 e0             	lea    -0x20(%ebp),%eax
801054bb:	50                   	push   %eax
801054bc:	e8 2f de ff ff       	call   801032f0 <pipealloc>
801054c1:	83 c4 10             	add    $0x10,%esp
801054c4:	85 c0                	test   %eax,%eax
801054c6:	0f 88 93 00 00 00    	js     8010555f <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801054cc:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
801054cf:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801054d1:	e8 ba e3 ff ff       	call   80103890 <myproc>
801054d6:	eb 10                	jmp    801054e8 <sys_pipe+0x58>
801054d8:	90                   	nop
801054d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
801054e0:	83 c3 01             	add    $0x1,%ebx
801054e3:	83 fb 10             	cmp    $0x10,%ebx
801054e6:	74 60                	je     80105548 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
801054e8:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801054ec:	85 f6                	test   %esi,%esi
801054ee:	75 f0                	jne    801054e0 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
801054f0:	8d 73 08             	lea    0x8(%ebx),%esi
801054f3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801054f7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
801054fa:	e8 91 e3 ff ff       	call   80103890 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801054ff:	31 d2                	xor    %edx,%edx
80105501:	eb 0d                	jmp    80105510 <sys_pipe+0x80>
80105503:	90                   	nop
80105504:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105508:	83 c2 01             	add    $0x1,%edx
8010550b:	83 fa 10             	cmp    $0x10,%edx
8010550e:	74 28                	je     80105538 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
80105510:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105514:	85 c9                	test   %ecx,%ecx
80105516:	75 f0                	jne    80105508 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
80105518:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
8010551c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010551f:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105521:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105524:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105527:	31 c0                	xor    %eax,%eax
}
80105529:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010552c:	5b                   	pop    %ebx
8010552d:	5e                   	pop    %esi
8010552e:	5f                   	pop    %edi
8010552f:	5d                   	pop    %ebp
80105530:	c3                   	ret    
80105531:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80105538:	e8 53 e3 ff ff       	call   80103890 <myproc>
8010553d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105544:	00 
80105545:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
80105548:	83 ec 0c             	sub    $0xc,%esp
8010554b:	ff 75 e0             	pushl  -0x20(%ebp)
8010554e:	e8 ed b8 ff ff       	call   80100e40 <fileclose>
    fileclose(wf);
80105553:	58                   	pop    %eax
80105554:	ff 75 e4             	pushl  -0x1c(%ebp)
80105557:	e8 e4 b8 ff ff       	call   80100e40 <fileclose>
    return -1;
8010555c:	83 c4 10             	add    $0x10,%esp
8010555f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105564:	eb c3                	jmp    80105529 <sys_pipe+0x99>
80105566:	66 90                	xchg   %ax,%ax
80105568:	66 90                	xchg   %ax,%ax
8010556a:	66 90                	xchg   %ax,%ax
8010556c:	66 90                	xchg   %ax,%ax
8010556e:	66 90                	xchg   %ax,%ax

80105570 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105570:	55                   	push   %ebp
80105571:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105573:	5d                   	pop    %ebp
  return fork();
80105574:	e9 b7 e4 ff ff       	jmp    80103a30 <fork>
80105579:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105580 <sys_exit>:

int
sys_exit(void)
{
80105580:	55                   	push   %ebp
80105581:	89 e5                	mov    %esp,%ebp
80105583:	83 ec 08             	sub    $0x8,%esp
  exit();
80105586:	e8 25 e7 ff ff       	call   80103cb0 <exit>
  return 0;  // not reached
}
8010558b:	31 c0                	xor    %eax,%eax
8010558d:	c9                   	leave  
8010558e:	c3                   	ret    
8010558f:	90                   	nop

80105590 <sys_wait>:

int
sys_wait(void)
{
80105590:	55                   	push   %ebp
80105591:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105593:	5d                   	pop    %ebp
  return wait();
80105594:	e9 57 e9 ff ff       	jmp    80103ef0 <wait>
80105599:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801055a0 <sys_kill>:

int
sys_kill(void)
{
801055a0:	55                   	push   %ebp
801055a1:	89 e5                	mov    %esp,%ebp
801055a3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801055a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055a9:	50                   	push   %eax
801055aa:	6a 00                	push   $0x0
801055ac:	e8 4f f2 ff ff       	call   80104800 <argint>
801055b1:	83 c4 10             	add    $0x10,%esp
801055b4:	85 c0                	test   %eax,%eax
801055b6:	78 18                	js     801055d0 <sys_kill+0x30>
    return -1;
  return kill(pid);
801055b8:	83 ec 0c             	sub    $0xc,%esp
801055bb:	ff 75 f4             	pushl  -0xc(%ebp)
801055be:	e8 7d ea ff ff       	call   80104040 <kill>
801055c3:	83 c4 10             	add    $0x10,%esp
}
801055c6:	c9                   	leave  
801055c7:	c3                   	ret    
801055c8:	90                   	nop
801055c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801055d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055d5:	c9                   	leave  
801055d6:	c3                   	ret    
801055d7:	89 f6                	mov    %esi,%esi
801055d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801055e0 <sys_getpid>:

int
sys_getpid(void)
{
801055e0:	55                   	push   %ebp
801055e1:	89 e5                	mov    %esp,%ebp
801055e3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801055e6:	e8 a5 e2 ff ff       	call   80103890 <myproc>
801055eb:	8b 40 10             	mov    0x10(%eax),%eax
}
801055ee:	c9                   	leave  
801055ef:	c3                   	ret    

801055f0 <sys_sbrk>:

int
sys_sbrk(void)
{
801055f0:	55                   	push   %ebp
801055f1:	89 e5                	mov    %esp,%ebp
801055f3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
801055f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801055f7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801055fa:	50                   	push   %eax
801055fb:	6a 00                	push   $0x0
801055fd:	e8 fe f1 ff ff       	call   80104800 <argint>
80105602:	83 c4 10             	add    $0x10,%esp
80105605:	85 c0                	test   %eax,%eax
80105607:	78 27                	js     80105630 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105609:	e8 82 e2 ff ff       	call   80103890 <myproc>
  if(growproc(n) < 0)
8010560e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105611:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105613:	ff 75 f4             	pushl  -0xc(%ebp)
80105616:	e8 95 e3 ff ff       	call   801039b0 <growproc>
8010561b:	83 c4 10             	add    $0x10,%esp
8010561e:	85 c0                	test   %eax,%eax
80105620:	78 0e                	js     80105630 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105622:	89 d8                	mov    %ebx,%eax
80105624:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105627:	c9                   	leave  
80105628:	c3                   	ret    
80105629:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105630:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105635:	eb eb                	jmp    80105622 <sys_sbrk+0x32>
80105637:	89 f6                	mov    %esi,%esi
80105639:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105640 <sys_sleep>:

int
sys_sleep(void)
{
80105640:	55                   	push   %ebp
80105641:	89 e5                	mov    %esp,%ebp
80105643:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105644:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105647:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010564a:	50                   	push   %eax
8010564b:	6a 00                	push   $0x0
8010564d:	e8 ae f1 ff ff       	call   80104800 <argint>
80105652:	83 c4 10             	add    $0x10,%esp
80105655:	85 c0                	test   %eax,%eax
80105657:	0f 88 8a 00 00 00    	js     801056e7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
8010565d:	83 ec 0c             	sub    $0xc,%esp
80105660:	68 60 4c 11 80       	push   $0x80114c60
80105665:	e8 86 ed ff ff       	call   801043f0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010566a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010566d:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80105670:	8b 1d a0 54 11 80    	mov    0x801154a0,%ebx
  while(ticks - ticks0 < n){
80105676:	85 d2                	test   %edx,%edx
80105678:	75 27                	jne    801056a1 <sys_sleep+0x61>
8010567a:	eb 54                	jmp    801056d0 <sys_sleep+0x90>
8010567c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105680:	83 ec 08             	sub    $0x8,%esp
80105683:	68 60 4c 11 80       	push   $0x80114c60
80105688:	68 a0 54 11 80       	push   $0x801154a0
8010568d:	e8 9e e7 ff ff       	call   80103e30 <sleep>
  while(ticks - ticks0 < n){
80105692:	a1 a0 54 11 80       	mov    0x801154a0,%eax
80105697:	83 c4 10             	add    $0x10,%esp
8010569a:	29 d8                	sub    %ebx,%eax
8010569c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010569f:	73 2f                	jae    801056d0 <sys_sleep+0x90>
    if(myproc()->killed){
801056a1:	e8 ea e1 ff ff       	call   80103890 <myproc>
801056a6:	8b 40 24             	mov    0x24(%eax),%eax
801056a9:	85 c0                	test   %eax,%eax
801056ab:	74 d3                	je     80105680 <sys_sleep+0x40>
      release(&tickslock);
801056ad:	83 ec 0c             	sub    $0xc,%esp
801056b0:	68 60 4c 11 80       	push   $0x80114c60
801056b5:	e8 f6 ed ff ff       	call   801044b0 <release>
      return -1;
801056ba:	83 c4 10             	add    $0x10,%esp
801056bd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
801056c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801056c5:	c9                   	leave  
801056c6:	c3                   	ret    
801056c7:	89 f6                	mov    %esi,%esi
801056c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
801056d0:	83 ec 0c             	sub    $0xc,%esp
801056d3:	68 60 4c 11 80       	push   $0x80114c60
801056d8:	e8 d3 ed ff ff       	call   801044b0 <release>
  return 0;
801056dd:	83 c4 10             	add    $0x10,%esp
801056e0:	31 c0                	xor    %eax,%eax
}
801056e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801056e5:	c9                   	leave  
801056e6:	c3                   	ret    
    return -1;
801056e7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056ec:	eb f4                	jmp    801056e2 <sys_sleep+0xa2>
801056ee:	66 90                	xchg   %ax,%ax

801056f0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801056f0:	55                   	push   %ebp
801056f1:	89 e5                	mov    %esp,%ebp
801056f3:	53                   	push   %ebx
801056f4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
801056f7:	68 60 4c 11 80       	push   $0x80114c60
801056fc:	e8 ef ec ff ff       	call   801043f0 <acquire>
  xticks = ticks;
80105701:	8b 1d a0 54 11 80    	mov    0x801154a0,%ebx
  release(&tickslock);
80105707:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
8010570e:	e8 9d ed ff ff       	call   801044b0 <release>
  return xticks;
}
80105713:	89 d8                	mov    %ebx,%eax
80105715:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105718:	c9                   	leave  
80105719:	c3                   	ret    

8010571a <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010571a:	1e                   	push   %ds
  pushl %es
8010571b:	06                   	push   %es
  pushl %fs
8010571c:	0f a0                	push   %fs
  pushl %gs
8010571e:	0f a8                	push   %gs
  pushal
80105720:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105721:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105725:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105727:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105729:	54                   	push   %esp
  call trap
8010572a:	e8 c1 00 00 00       	call   801057f0 <trap>
  addl $4, %esp
8010572f:	83 c4 04             	add    $0x4,%esp

80105732 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105732:	61                   	popa   
  popl %gs
80105733:	0f a9                	pop    %gs
  popl %fs
80105735:	0f a1                	pop    %fs
  popl %es
80105737:	07                   	pop    %es
  popl %ds
80105738:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105739:	83 c4 08             	add    $0x8,%esp
  iret
8010573c:	cf                   	iret   
8010573d:	66 90                	xchg   %ax,%ax
8010573f:	90                   	nop

80105740 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105740:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105741:	31 c0                	xor    %eax,%eax
{
80105743:	89 e5                	mov    %esp,%ebp
80105745:	83 ec 08             	sub    $0x8,%esp
80105748:	90                   	nop
80105749:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105750:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105757:	c7 04 c5 a2 4c 11 80 	movl   $0x8e000008,-0x7feeb35e(,%eax,8)
8010575e:	08 00 00 8e 
80105762:	66 89 14 c5 a0 4c 11 	mov    %dx,-0x7feeb360(,%eax,8)
80105769:	80 
8010576a:	c1 ea 10             	shr    $0x10,%edx
8010576d:	66 89 14 c5 a6 4c 11 	mov    %dx,-0x7feeb35a(,%eax,8)
80105774:	80 
  for(i = 0; i < 256; i++)
80105775:	83 c0 01             	add    $0x1,%eax
80105778:	3d 00 01 00 00       	cmp    $0x100,%eax
8010577d:	75 d1                	jne    80105750 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010577f:	a1 08 a1 10 80       	mov    0x8010a108,%eax

  initlock(&tickslock, "time");
80105784:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105787:	c7 05 a2 4e 11 80 08 	movl   $0xef000008,0x80114ea2
8010578e:	00 00 ef 
  initlock(&tickslock, "time");
80105791:	68 39 77 10 80       	push   $0x80107739
80105796:	68 60 4c 11 80       	push   $0x80114c60
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010579b:	66 a3 a0 4e 11 80    	mov    %ax,0x80114ea0
801057a1:	c1 e8 10             	shr    $0x10,%eax
801057a4:	66 a3 a6 4e 11 80    	mov    %ax,0x80114ea6
  initlock(&tickslock, "time");
801057aa:	e8 01 eb ff ff       	call   801042b0 <initlock>
}
801057af:	83 c4 10             	add    $0x10,%esp
801057b2:	c9                   	leave  
801057b3:	c3                   	ret    
801057b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801057ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801057c0 <idtinit>:

void
idtinit(void)
{
801057c0:	55                   	push   %ebp
  pd[0] = size-1;
801057c1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801057c6:	89 e5                	mov    %esp,%ebp
801057c8:	83 ec 10             	sub    $0x10,%esp
801057cb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801057cf:	b8 a0 4c 11 80       	mov    $0x80114ca0,%eax
801057d4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801057d8:	c1 e8 10             	shr    $0x10,%eax
801057db:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
801057df:	8d 45 fa             	lea    -0x6(%ebp),%eax
801057e2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801057e5:	c9                   	leave  
801057e6:	c3                   	ret    
801057e7:	89 f6                	mov    %esi,%esi
801057e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801057f0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801057f0:	55                   	push   %ebp
801057f1:	89 e5                	mov    %esp,%ebp
801057f3:	57                   	push   %edi
801057f4:	56                   	push   %esi
801057f5:	53                   	push   %ebx
801057f6:	83 ec 1c             	sub    $0x1c,%esp
801057f9:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
801057fc:	8b 47 30             	mov    0x30(%edi),%eax
801057ff:	83 f8 40             	cmp    $0x40,%eax
80105802:	0f 84 f0 00 00 00    	je     801058f8 <trap+0x108>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105808:	83 e8 20             	sub    $0x20,%eax
8010580b:	83 f8 1f             	cmp    $0x1f,%eax
8010580e:	77 10                	ja     80105820 <trap+0x30>
80105810:	ff 24 85 e0 77 10 80 	jmp    *-0x7fef8820(,%eax,4)
80105817:	89 f6                	mov    %esi,%esi
80105819:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105820:	e8 6b e0 ff ff       	call   80103890 <myproc>
80105825:	85 c0                	test   %eax,%eax
80105827:	8b 5f 38             	mov    0x38(%edi),%ebx
8010582a:	0f 84 14 02 00 00    	je     80105a44 <trap+0x254>
80105830:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80105834:	0f 84 0a 02 00 00    	je     80105a44 <trap+0x254>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010583a:	0f 20 d1             	mov    %cr2,%ecx
8010583d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105840:	e8 2b e0 ff ff       	call   80103870 <cpuid>
80105845:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105848:	8b 47 34             	mov    0x34(%edi),%eax
8010584b:	8b 77 30             	mov    0x30(%edi),%esi
8010584e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105851:	e8 3a e0 ff ff       	call   80103890 <myproc>
80105856:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105859:	e8 32 e0 ff ff       	call   80103890 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010585e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105861:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105864:	51                   	push   %ecx
80105865:	53                   	push   %ebx
80105866:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80105867:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010586a:	ff 75 e4             	pushl  -0x1c(%ebp)
8010586d:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
8010586e:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105871:	52                   	push   %edx
80105872:	ff 70 10             	pushl  0x10(%eax)
80105875:	68 9c 77 10 80       	push   $0x8010779c
8010587a:	e8 e1 ad ff ff       	call   80100660 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
8010587f:	83 c4 20             	add    $0x20,%esp
80105882:	e8 09 e0 ff ff       	call   80103890 <myproc>
80105887:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010588e:	e8 fd df ff ff       	call   80103890 <myproc>
80105893:	85 c0                	test   %eax,%eax
80105895:	74 1d                	je     801058b4 <trap+0xc4>
80105897:	e8 f4 df ff ff       	call   80103890 <myproc>
8010589c:	8b 50 24             	mov    0x24(%eax),%edx
8010589f:	85 d2                	test   %edx,%edx
801058a1:	74 11                	je     801058b4 <trap+0xc4>
801058a3:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
801058a7:	83 e0 03             	and    $0x3,%eax
801058aa:	66 83 f8 03          	cmp    $0x3,%ax
801058ae:	0f 84 4c 01 00 00    	je     80105a00 <trap+0x210>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801058b4:	e8 d7 df ff ff       	call   80103890 <myproc>
801058b9:	85 c0                	test   %eax,%eax
801058bb:	74 0b                	je     801058c8 <trap+0xd8>
801058bd:	e8 ce df ff ff       	call   80103890 <myproc>
801058c2:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801058c6:	74 68                	je     80105930 <trap+0x140>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801058c8:	e8 c3 df ff ff       	call   80103890 <myproc>
801058cd:	85 c0                	test   %eax,%eax
801058cf:	74 19                	je     801058ea <trap+0xfa>
801058d1:	e8 ba df ff ff       	call   80103890 <myproc>
801058d6:	8b 40 24             	mov    0x24(%eax),%eax
801058d9:	85 c0                	test   %eax,%eax
801058db:	74 0d                	je     801058ea <trap+0xfa>
801058dd:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
801058e1:	83 e0 03             	and    $0x3,%eax
801058e4:	66 83 f8 03          	cmp    $0x3,%ax
801058e8:	74 37                	je     80105921 <trap+0x131>
    exit();
}
801058ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
801058ed:	5b                   	pop    %ebx
801058ee:	5e                   	pop    %esi
801058ef:	5f                   	pop    %edi
801058f0:	5d                   	pop    %ebp
801058f1:	c3                   	ret    
801058f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed)
801058f8:	e8 93 df ff ff       	call   80103890 <myproc>
801058fd:	8b 58 24             	mov    0x24(%eax),%ebx
80105900:	85 db                	test   %ebx,%ebx
80105902:	0f 85 e8 00 00 00    	jne    801059f0 <trap+0x200>
    myproc()->tf = tf;
80105908:	e8 83 df ff ff       	call   80103890 <myproc>
8010590d:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80105910:	e8 db ef ff ff       	call   801048f0 <syscall>
    if(myproc()->killed)
80105915:	e8 76 df ff ff       	call   80103890 <myproc>
8010591a:	8b 48 24             	mov    0x24(%eax),%ecx
8010591d:	85 c9                	test   %ecx,%ecx
8010591f:	74 c9                	je     801058ea <trap+0xfa>
}
80105921:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105924:	5b                   	pop    %ebx
80105925:	5e                   	pop    %esi
80105926:	5f                   	pop    %edi
80105927:	5d                   	pop    %ebp
      exit();
80105928:	e9 83 e3 ff ff       	jmp    80103cb0 <exit>
8010592d:	8d 76 00             	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
80105930:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80105934:	75 92                	jne    801058c8 <trap+0xd8>
    yield();
80105936:	e8 a5 e4 ff ff       	call   80103de0 <yield>
8010593b:	eb 8b                	jmp    801058c8 <trap+0xd8>
8010593d:	8d 76 00             	lea    0x0(%esi),%esi
    if(cpuid() == 0){
80105940:	e8 2b df ff ff       	call   80103870 <cpuid>
80105945:	85 c0                	test   %eax,%eax
80105947:	0f 84 c3 00 00 00    	je     80105a10 <trap+0x220>
    lapiceoi();
8010594d:	e8 ae ce ff ff       	call   80102800 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105952:	e8 39 df ff ff       	call   80103890 <myproc>
80105957:	85 c0                	test   %eax,%eax
80105959:	0f 85 38 ff ff ff    	jne    80105897 <trap+0xa7>
8010595f:	e9 50 ff ff ff       	jmp    801058b4 <trap+0xc4>
80105964:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105968:	e8 53 cd ff ff       	call   801026c0 <kbdintr>
    lapiceoi();
8010596d:	e8 8e ce ff ff       	call   80102800 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105972:	e8 19 df ff ff       	call   80103890 <myproc>
80105977:	85 c0                	test   %eax,%eax
80105979:	0f 85 18 ff ff ff    	jne    80105897 <trap+0xa7>
8010597f:	e9 30 ff ff ff       	jmp    801058b4 <trap+0xc4>
80105984:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105988:	e8 53 02 00 00       	call   80105be0 <uartintr>
    lapiceoi();
8010598d:	e8 6e ce ff ff       	call   80102800 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105992:	e8 f9 de ff ff       	call   80103890 <myproc>
80105997:	85 c0                	test   %eax,%eax
80105999:	0f 85 f8 fe ff ff    	jne    80105897 <trap+0xa7>
8010599f:	e9 10 ff ff ff       	jmp    801058b4 <trap+0xc4>
801059a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801059a8:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
801059ac:	8b 77 38             	mov    0x38(%edi),%esi
801059af:	e8 bc de ff ff       	call   80103870 <cpuid>
801059b4:	56                   	push   %esi
801059b5:	53                   	push   %ebx
801059b6:	50                   	push   %eax
801059b7:	68 44 77 10 80       	push   $0x80107744
801059bc:	e8 9f ac ff ff       	call   80100660 <cprintf>
    lapiceoi();
801059c1:	e8 3a ce ff ff       	call   80102800 <lapiceoi>
    break;
801059c6:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801059c9:	e8 c2 de ff ff       	call   80103890 <myproc>
801059ce:	85 c0                	test   %eax,%eax
801059d0:	0f 85 c1 fe ff ff    	jne    80105897 <trap+0xa7>
801059d6:	e9 d9 fe ff ff       	jmp    801058b4 <trap+0xc4>
801059db:	90                   	nop
801059dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
801059e0:	e8 4b c7 ff ff       	call   80102130 <ideintr>
801059e5:	e9 63 ff ff ff       	jmp    8010594d <trap+0x15d>
801059ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
801059f0:	e8 bb e2 ff ff       	call   80103cb0 <exit>
801059f5:	e9 0e ff ff ff       	jmp    80105908 <trap+0x118>
801059fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
80105a00:	e8 ab e2 ff ff       	call   80103cb0 <exit>
80105a05:	e9 aa fe ff ff       	jmp    801058b4 <trap+0xc4>
80105a0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80105a10:	83 ec 0c             	sub    $0xc,%esp
80105a13:	68 60 4c 11 80       	push   $0x80114c60
80105a18:	e8 d3 e9 ff ff       	call   801043f0 <acquire>
      wakeup(&ticks);
80105a1d:	c7 04 24 a0 54 11 80 	movl   $0x801154a0,(%esp)
      ticks++;
80105a24:	83 05 a0 54 11 80 01 	addl   $0x1,0x801154a0
      wakeup(&ticks);
80105a2b:	e8 b0 e5 ff ff       	call   80103fe0 <wakeup>
      release(&tickslock);
80105a30:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
80105a37:	e8 74 ea ff ff       	call   801044b0 <release>
80105a3c:	83 c4 10             	add    $0x10,%esp
80105a3f:	e9 09 ff ff ff       	jmp    8010594d <trap+0x15d>
80105a44:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105a47:	e8 24 de ff ff       	call   80103870 <cpuid>
80105a4c:	83 ec 0c             	sub    $0xc,%esp
80105a4f:	56                   	push   %esi
80105a50:	53                   	push   %ebx
80105a51:	50                   	push   %eax
80105a52:	ff 77 30             	pushl  0x30(%edi)
80105a55:	68 68 77 10 80       	push   $0x80107768
80105a5a:	e8 01 ac ff ff       	call   80100660 <cprintf>
      panic("trap");
80105a5f:	83 c4 14             	add    $0x14,%esp
80105a62:	68 3e 77 10 80       	push   $0x8010773e
80105a67:	e8 24 a9 ff ff       	call   80100390 <panic>
80105a6c:	66 90                	xchg   %ax,%ax
80105a6e:	66 90                	xchg   %ax,%ax

80105a70 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105a70:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
{
80105a75:	55                   	push   %ebp
80105a76:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105a78:	85 c0                	test   %eax,%eax
80105a7a:	74 1c                	je     80105a98 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105a7c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105a81:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105a82:	a8 01                	test   $0x1,%al
80105a84:	74 12                	je     80105a98 <uartgetc+0x28>
80105a86:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105a8b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105a8c:	0f b6 c0             	movzbl %al,%eax
}
80105a8f:	5d                   	pop    %ebp
80105a90:	c3                   	ret    
80105a91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105a98:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a9d:	5d                   	pop    %ebp
80105a9e:	c3                   	ret    
80105a9f:	90                   	nop

80105aa0 <uartputc.part.0>:
uartputc(int c)
80105aa0:	55                   	push   %ebp
80105aa1:	89 e5                	mov    %esp,%ebp
80105aa3:	57                   	push   %edi
80105aa4:	56                   	push   %esi
80105aa5:	53                   	push   %ebx
80105aa6:	89 c7                	mov    %eax,%edi
80105aa8:	bb 80 00 00 00       	mov    $0x80,%ebx
80105aad:	be fd 03 00 00       	mov    $0x3fd,%esi
80105ab2:	83 ec 0c             	sub    $0xc,%esp
80105ab5:	eb 1b                	jmp    80105ad2 <uartputc.part.0+0x32>
80105ab7:	89 f6                	mov    %esi,%esi
80105ab9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
80105ac0:	83 ec 0c             	sub    $0xc,%esp
80105ac3:	6a 0a                	push   $0xa
80105ac5:	e8 56 cd ff ff       	call   80102820 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105aca:	83 c4 10             	add    $0x10,%esp
80105acd:	83 eb 01             	sub    $0x1,%ebx
80105ad0:	74 07                	je     80105ad9 <uartputc.part.0+0x39>
80105ad2:	89 f2                	mov    %esi,%edx
80105ad4:	ec                   	in     (%dx),%al
80105ad5:	a8 20                	test   $0x20,%al
80105ad7:	74 e7                	je     80105ac0 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105ad9:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105ade:	89 f8                	mov    %edi,%eax
80105ae0:	ee                   	out    %al,(%dx)
}
80105ae1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ae4:	5b                   	pop    %ebx
80105ae5:	5e                   	pop    %esi
80105ae6:	5f                   	pop    %edi
80105ae7:	5d                   	pop    %ebp
80105ae8:	c3                   	ret    
80105ae9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105af0 <uartinit>:
{
80105af0:	55                   	push   %ebp
80105af1:	31 c9                	xor    %ecx,%ecx
80105af3:	89 c8                	mov    %ecx,%eax
80105af5:	89 e5                	mov    %esp,%ebp
80105af7:	57                   	push   %edi
80105af8:	56                   	push   %esi
80105af9:	53                   	push   %ebx
80105afa:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80105aff:	89 da                	mov    %ebx,%edx
80105b01:	83 ec 0c             	sub    $0xc,%esp
80105b04:	ee                   	out    %al,(%dx)
80105b05:	bf fb 03 00 00       	mov    $0x3fb,%edi
80105b0a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105b0f:	89 fa                	mov    %edi,%edx
80105b11:	ee                   	out    %al,(%dx)
80105b12:	b8 0c 00 00 00       	mov    $0xc,%eax
80105b17:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105b1c:	ee                   	out    %al,(%dx)
80105b1d:	be f9 03 00 00       	mov    $0x3f9,%esi
80105b22:	89 c8                	mov    %ecx,%eax
80105b24:	89 f2                	mov    %esi,%edx
80105b26:	ee                   	out    %al,(%dx)
80105b27:	b8 03 00 00 00       	mov    $0x3,%eax
80105b2c:	89 fa                	mov    %edi,%edx
80105b2e:	ee                   	out    %al,(%dx)
80105b2f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105b34:	89 c8                	mov    %ecx,%eax
80105b36:	ee                   	out    %al,(%dx)
80105b37:	b8 01 00 00 00       	mov    $0x1,%eax
80105b3c:	89 f2                	mov    %esi,%edx
80105b3e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105b3f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105b44:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105b45:	3c ff                	cmp    $0xff,%al
80105b47:	74 5a                	je     80105ba3 <uartinit+0xb3>
  uart = 1;
80105b49:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
80105b50:	00 00 00 
80105b53:	89 da                	mov    %ebx,%edx
80105b55:	ec                   	in     (%dx),%al
80105b56:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105b5b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105b5c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80105b5f:	bb 60 78 10 80       	mov    $0x80107860,%ebx
  ioapicenable(IRQ_COM1, 0);
80105b64:	6a 00                	push   $0x0
80105b66:	6a 04                	push   $0x4
80105b68:	e8 13 c8 ff ff       	call   80102380 <ioapicenable>
80105b6d:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80105b70:	b8 78 00 00 00       	mov    $0x78,%eax
80105b75:	eb 13                	jmp    80105b8a <uartinit+0x9a>
80105b77:	89 f6                	mov    %esi,%esi
80105b79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105b80:	83 c3 01             	add    $0x1,%ebx
80105b83:	0f be 03             	movsbl (%ebx),%eax
80105b86:	84 c0                	test   %al,%al
80105b88:	74 19                	je     80105ba3 <uartinit+0xb3>
  if(!uart)
80105b8a:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
80105b90:	85 d2                	test   %edx,%edx
80105b92:	74 ec                	je     80105b80 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
80105b94:	83 c3 01             	add    $0x1,%ebx
80105b97:	e8 04 ff ff ff       	call   80105aa0 <uartputc.part.0>
80105b9c:	0f be 03             	movsbl (%ebx),%eax
80105b9f:	84 c0                	test   %al,%al
80105ba1:	75 e7                	jne    80105b8a <uartinit+0x9a>
}
80105ba3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ba6:	5b                   	pop    %ebx
80105ba7:	5e                   	pop    %esi
80105ba8:	5f                   	pop    %edi
80105ba9:	5d                   	pop    %ebp
80105baa:	c3                   	ret    
80105bab:	90                   	nop
80105bac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105bb0 <uartputc>:
  if(!uart)
80105bb0:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
{
80105bb6:	55                   	push   %ebp
80105bb7:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105bb9:	85 d2                	test   %edx,%edx
{
80105bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80105bbe:	74 10                	je     80105bd0 <uartputc+0x20>
}
80105bc0:	5d                   	pop    %ebp
80105bc1:	e9 da fe ff ff       	jmp    80105aa0 <uartputc.part.0>
80105bc6:	8d 76 00             	lea    0x0(%esi),%esi
80105bc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105bd0:	5d                   	pop    %ebp
80105bd1:	c3                   	ret    
80105bd2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105be0 <uartintr>:

void
uartintr(void)
{
80105be0:	55                   	push   %ebp
80105be1:	89 e5                	mov    %esp,%ebp
80105be3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105be6:	68 70 5a 10 80       	push   $0x80105a70
80105beb:	e8 20 ac ff ff       	call   80100810 <consoleintr>
}
80105bf0:	83 c4 10             	add    $0x10,%esp
80105bf3:	c9                   	leave  
80105bf4:	c3                   	ret    

80105bf5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105bf5:	6a 00                	push   $0x0
  pushl $0
80105bf7:	6a 00                	push   $0x0
  jmp alltraps
80105bf9:	e9 1c fb ff ff       	jmp    8010571a <alltraps>

80105bfe <vector1>:
.globl vector1
vector1:
  pushl $0
80105bfe:	6a 00                	push   $0x0
  pushl $1
80105c00:	6a 01                	push   $0x1
  jmp alltraps
80105c02:	e9 13 fb ff ff       	jmp    8010571a <alltraps>

80105c07 <vector2>:
.globl vector2
vector2:
  pushl $0
80105c07:	6a 00                	push   $0x0
  pushl $2
80105c09:	6a 02                	push   $0x2
  jmp alltraps
80105c0b:	e9 0a fb ff ff       	jmp    8010571a <alltraps>

80105c10 <vector3>:
.globl vector3
vector3:
  pushl $0
80105c10:	6a 00                	push   $0x0
  pushl $3
80105c12:	6a 03                	push   $0x3
  jmp alltraps
80105c14:	e9 01 fb ff ff       	jmp    8010571a <alltraps>

80105c19 <vector4>:
.globl vector4
vector4:
  pushl $0
80105c19:	6a 00                	push   $0x0
  pushl $4
80105c1b:	6a 04                	push   $0x4
  jmp alltraps
80105c1d:	e9 f8 fa ff ff       	jmp    8010571a <alltraps>

80105c22 <vector5>:
.globl vector5
vector5:
  pushl $0
80105c22:	6a 00                	push   $0x0
  pushl $5
80105c24:	6a 05                	push   $0x5
  jmp alltraps
80105c26:	e9 ef fa ff ff       	jmp    8010571a <alltraps>

80105c2b <vector6>:
.globl vector6
vector6:
  pushl $0
80105c2b:	6a 00                	push   $0x0
  pushl $6
80105c2d:	6a 06                	push   $0x6
  jmp alltraps
80105c2f:	e9 e6 fa ff ff       	jmp    8010571a <alltraps>

80105c34 <vector7>:
.globl vector7
vector7:
  pushl $0
80105c34:	6a 00                	push   $0x0
  pushl $7
80105c36:	6a 07                	push   $0x7
  jmp alltraps
80105c38:	e9 dd fa ff ff       	jmp    8010571a <alltraps>

80105c3d <vector8>:
.globl vector8
vector8:
  pushl $8
80105c3d:	6a 08                	push   $0x8
  jmp alltraps
80105c3f:	e9 d6 fa ff ff       	jmp    8010571a <alltraps>

80105c44 <vector9>:
.globl vector9
vector9:
  pushl $0
80105c44:	6a 00                	push   $0x0
  pushl $9
80105c46:	6a 09                	push   $0x9
  jmp alltraps
80105c48:	e9 cd fa ff ff       	jmp    8010571a <alltraps>

80105c4d <vector10>:
.globl vector10
vector10:
  pushl $10
80105c4d:	6a 0a                	push   $0xa
  jmp alltraps
80105c4f:	e9 c6 fa ff ff       	jmp    8010571a <alltraps>

80105c54 <vector11>:
.globl vector11
vector11:
  pushl $11
80105c54:	6a 0b                	push   $0xb
  jmp alltraps
80105c56:	e9 bf fa ff ff       	jmp    8010571a <alltraps>

80105c5b <vector12>:
.globl vector12
vector12:
  pushl $12
80105c5b:	6a 0c                	push   $0xc
  jmp alltraps
80105c5d:	e9 b8 fa ff ff       	jmp    8010571a <alltraps>

80105c62 <vector13>:
.globl vector13
vector13:
  pushl $13
80105c62:	6a 0d                	push   $0xd
  jmp alltraps
80105c64:	e9 b1 fa ff ff       	jmp    8010571a <alltraps>

80105c69 <vector14>:
.globl vector14
vector14:
  pushl $14
80105c69:	6a 0e                	push   $0xe
  jmp alltraps
80105c6b:	e9 aa fa ff ff       	jmp    8010571a <alltraps>

80105c70 <vector15>:
.globl vector15
vector15:
  pushl $0
80105c70:	6a 00                	push   $0x0
  pushl $15
80105c72:	6a 0f                	push   $0xf
  jmp alltraps
80105c74:	e9 a1 fa ff ff       	jmp    8010571a <alltraps>

80105c79 <vector16>:
.globl vector16
vector16:
  pushl $0
80105c79:	6a 00                	push   $0x0
  pushl $16
80105c7b:	6a 10                	push   $0x10
  jmp alltraps
80105c7d:	e9 98 fa ff ff       	jmp    8010571a <alltraps>

80105c82 <vector17>:
.globl vector17
vector17:
  pushl $17
80105c82:	6a 11                	push   $0x11
  jmp alltraps
80105c84:	e9 91 fa ff ff       	jmp    8010571a <alltraps>

80105c89 <vector18>:
.globl vector18
vector18:
  pushl $0
80105c89:	6a 00                	push   $0x0
  pushl $18
80105c8b:	6a 12                	push   $0x12
  jmp alltraps
80105c8d:	e9 88 fa ff ff       	jmp    8010571a <alltraps>

80105c92 <vector19>:
.globl vector19
vector19:
  pushl $0
80105c92:	6a 00                	push   $0x0
  pushl $19
80105c94:	6a 13                	push   $0x13
  jmp alltraps
80105c96:	e9 7f fa ff ff       	jmp    8010571a <alltraps>

80105c9b <vector20>:
.globl vector20
vector20:
  pushl $0
80105c9b:	6a 00                	push   $0x0
  pushl $20
80105c9d:	6a 14                	push   $0x14
  jmp alltraps
80105c9f:	e9 76 fa ff ff       	jmp    8010571a <alltraps>

80105ca4 <vector21>:
.globl vector21
vector21:
  pushl $0
80105ca4:	6a 00                	push   $0x0
  pushl $21
80105ca6:	6a 15                	push   $0x15
  jmp alltraps
80105ca8:	e9 6d fa ff ff       	jmp    8010571a <alltraps>

80105cad <vector22>:
.globl vector22
vector22:
  pushl $0
80105cad:	6a 00                	push   $0x0
  pushl $22
80105caf:	6a 16                	push   $0x16
  jmp alltraps
80105cb1:	e9 64 fa ff ff       	jmp    8010571a <alltraps>

80105cb6 <vector23>:
.globl vector23
vector23:
  pushl $0
80105cb6:	6a 00                	push   $0x0
  pushl $23
80105cb8:	6a 17                	push   $0x17
  jmp alltraps
80105cba:	e9 5b fa ff ff       	jmp    8010571a <alltraps>

80105cbf <vector24>:
.globl vector24
vector24:
  pushl $0
80105cbf:	6a 00                	push   $0x0
  pushl $24
80105cc1:	6a 18                	push   $0x18
  jmp alltraps
80105cc3:	e9 52 fa ff ff       	jmp    8010571a <alltraps>

80105cc8 <vector25>:
.globl vector25
vector25:
  pushl $0
80105cc8:	6a 00                	push   $0x0
  pushl $25
80105cca:	6a 19                	push   $0x19
  jmp alltraps
80105ccc:	e9 49 fa ff ff       	jmp    8010571a <alltraps>

80105cd1 <vector26>:
.globl vector26
vector26:
  pushl $0
80105cd1:	6a 00                	push   $0x0
  pushl $26
80105cd3:	6a 1a                	push   $0x1a
  jmp alltraps
80105cd5:	e9 40 fa ff ff       	jmp    8010571a <alltraps>

80105cda <vector27>:
.globl vector27
vector27:
  pushl $0
80105cda:	6a 00                	push   $0x0
  pushl $27
80105cdc:	6a 1b                	push   $0x1b
  jmp alltraps
80105cde:	e9 37 fa ff ff       	jmp    8010571a <alltraps>

80105ce3 <vector28>:
.globl vector28
vector28:
  pushl $0
80105ce3:	6a 00                	push   $0x0
  pushl $28
80105ce5:	6a 1c                	push   $0x1c
  jmp alltraps
80105ce7:	e9 2e fa ff ff       	jmp    8010571a <alltraps>

80105cec <vector29>:
.globl vector29
vector29:
  pushl $0
80105cec:	6a 00                	push   $0x0
  pushl $29
80105cee:	6a 1d                	push   $0x1d
  jmp alltraps
80105cf0:	e9 25 fa ff ff       	jmp    8010571a <alltraps>

80105cf5 <vector30>:
.globl vector30
vector30:
  pushl $0
80105cf5:	6a 00                	push   $0x0
  pushl $30
80105cf7:	6a 1e                	push   $0x1e
  jmp alltraps
80105cf9:	e9 1c fa ff ff       	jmp    8010571a <alltraps>

80105cfe <vector31>:
.globl vector31
vector31:
  pushl $0
80105cfe:	6a 00                	push   $0x0
  pushl $31
80105d00:	6a 1f                	push   $0x1f
  jmp alltraps
80105d02:	e9 13 fa ff ff       	jmp    8010571a <alltraps>

80105d07 <vector32>:
.globl vector32
vector32:
  pushl $0
80105d07:	6a 00                	push   $0x0
  pushl $32
80105d09:	6a 20                	push   $0x20
  jmp alltraps
80105d0b:	e9 0a fa ff ff       	jmp    8010571a <alltraps>

80105d10 <vector33>:
.globl vector33
vector33:
  pushl $0
80105d10:	6a 00                	push   $0x0
  pushl $33
80105d12:	6a 21                	push   $0x21
  jmp alltraps
80105d14:	e9 01 fa ff ff       	jmp    8010571a <alltraps>

80105d19 <vector34>:
.globl vector34
vector34:
  pushl $0
80105d19:	6a 00                	push   $0x0
  pushl $34
80105d1b:	6a 22                	push   $0x22
  jmp alltraps
80105d1d:	e9 f8 f9 ff ff       	jmp    8010571a <alltraps>

80105d22 <vector35>:
.globl vector35
vector35:
  pushl $0
80105d22:	6a 00                	push   $0x0
  pushl $35
80105d24:	6a 23                	push   $0x23
  jmp alltraps
80105d26:	e9 ef f9 ff ff       	jmp    8010571a <alltraps>

80105d2b <vector36>:
.globl vector36
vector36:
  pushl $0
80105d2b:	6a 00                	push   $0x0
  pushl $36
80105d2d:	6a 24                	push   $0x24
  jmp alltraps
80105d2f:	e9 e6 f9 ff ff       	jmp    8010571a <alltraps>

80105d34 <vector37>:
.globl vector37
vector37:
  pushl $0
80105d34:	6a 00                	push   $0x0
  pushl $37
80105d36:	6a 25                	push   $0x25
  jmp alltraps
80105d38:	e9 dd f9 ff ff       	jmp    8010571a <alltraps>

80105d3d <vector38>:
.globl vector38
vector38:
  pushl $0
80105d3d:	6a 00                	push   $0x0
  pushl $38
80105d3f:	6a 26                	push   $0x26
  jmp alltraps
80105d41:	e9 d4 f9 ff ff       	jmp    8010571a <alltraps>

80105d46 <vector39>:
.globl vector39
vector39:
  pushl $0
80105d46:	6a 00                	push   $0x0
  pushl $39
80105d48:	6a 27                	push   $0x27
  jmp alltraps
80105d4a:	e9 cb f9 ff ff       	jmp    8010571a <alltraps>

80105d4f <vector40>:
.globl vector40
vector40:
  pushl $0
80105d4f:	6a 00                	push   $0x0
  pushl $40
80105d51:	6a 28                	push   $0x28
  jmp alltraps
80105d53:	e9 c2 f9 ff ff       	jmp    8010571a <alltraps>

80105d58 <vector41>:
.globl vector41
vector41:
  pushl $0
80105d58:	6a 00                	push   $0x0
  pushl $41
80105d5a:	6a 29                	push   $0x29
  jmp alltraps
80105d5c:	e9 b9 f9 ff ff       	jmp    8010571a <alltraps>

80105d61 <vector42>:
.globl vector42
vector42:
  pushl $0
80105d61:	6a 00                	push   $0x0
  pushl $42
80105d63:	6a 2a                	push   $0x2a
  jmp alltraps
80105d65:	e9 b0 f9 ff ff       	jmp    8010571a <alltraps>

80105d6a <vector43>:
.globl vector43
vector43:
  pushl $0
80105d6a:	6a 00                	push   $0x0
  pushl $43
80105d6c:	6a 2b                	push   $0x2b
  jmp alltraps
80105d6e:	e9 a7 f9 ff ff       	jmp    8010571a <alltraps>

80105d73 <vector44>:
.globl vector44
vector44:
  pushl $0
80105d73:	6a 00                	push   $0x0
  pushl $44
80105d75:	6a 2c                	push   $0x2c
  jmp alltraps
80105d77:	e9 9e f9 ff ff       	jmp    8010571a <alltraps>

80105d7c <vector45>:
.globl vector45
vector45:
  pushl $0
80105d7c:	6a 00                	push   $0x0
  pushl $45
80105d7e:	6a 2d                	push   $0x2d
  jmp alltraps
80105d80:	e9 95 f9 ff ff       	jmp    8010571a <alltraps>

80105d85 <vector46>:
.globl vector46
vector46:
  pushl $0
80105d85:	6a 00                	push   $0x0
  pushl $46
80105d87:	6a 2e                	push   $0x2e
  jmp alltraps
80105d89:	e9 8c f9 ff ff       	jmp    8010571a <alltraps>

80105d8e <vector47>:
.globl vector47
vector47:
  pushl $0
80105d8e:	6a 00                	push   $0x0
  pushl $47
80105d90:	6a 2f                	push   $0x2f
  jmp alltraps
80105d92:	e9 83 f9 ff ff       	jmp    8010571a <alltraps>

80105d97 <vector48>:
.globl vector48
vector48:
  pushl $0
80105d97:	6a 00                	push   $0x0
  pushl $48
80105d99:	6a 30                	push   $0x30
  jmp alltraps
80105d9b:	e9 7a f9 ff ff       	jmp    8010571a <alltraps>

80105da0 <vector49>:
.globl vector49
vector49:
  pushl $0
80105da0:	6a 00                	push   $0x0
  pushl $49
80105da2:	6a 31                	push   $0x31
  jmp alltraps
80105da4:	e9 71 f9 ff ff       	jmp    8010571a <alltraps>

80105da9 <vector50>:
.globl vector50
vector50:
  pushl $0
80105da9:	6a 00                	push   $0x0
  pushl $50
80105dab:	6a 32                	push   $0x32
  jmp alltraps
80105dad:	e9 68 f9 ff ff       	jmp    8010571a <alltraps>

80105db2 <vector51>:
.globl vector51
vector51:
  pushl $0
80105db2:	6a 00                	push   $0x0
  pushl $51
80105db4:	6a 33                	push   $0x33
  jmp alltraps
80105db6:	e9 5f f9 ff ff       	jmp    8010571a <alltraps>

80105dbb <vector52>:
.globl vector52
vector52:
  pushl $0
80105dbb:	6a 00                	push   $0x0
  pushl $52
80105dbd:	6a 34                	push   $0x34
  jmp alltraps
80105dbf:	e9 56 f9 ff ff       	jmp    8010571a <alltraps>

80105dc4 <vector53>:
.globl vector53
vector53:
  pushl $0
80105dc4:	6a 00                	push   $0x0
  pushl $53
80105dc6:	6a 35                	push   $0x35
  jmp alltraps
80105dc8:	e9 4d f9 ff ff       	jmp    8010571a <alltraps>

80105dcd <vector54>:
.globl vector54
vector54:
  pushl $0
80105dcd:	6a 00                	push   $0x0
  pushl $54
80105dcf:	6a 36                	push   $0x36
  jmp alltraps
80105dd1:	e9 44 f9 ff ff       	jmp    8010571a <alltraps>

80105dd6 <vector55>:
.globl vector55
vector55:
  pushl $0
80105dd6:	6a 00                	push   $0x0
  pushl $55
80105dd8:	6a 37                	push   $0x37
  jmp alltraps
80105dda:	e9 3b f9 ff ff       	jmp    8010571a <alltraps>

80105ddf <vector56>:
.globl vector56
vector56:
  pushl $0
80105ddf:	6a 00                	push   $0x0
  pushl $56
80105de1:	6a 38                	push   $0x38
  jmp alltraps
80105de3:	e9 32 f9 ff ff       	jmp    8010571a <alltraps>

80105de8 <vector57>:
.globl vector57
vector57:
  pushl $0
80105de8:	6a 00                	push   $0x0
  pushl $57
80105dea:	6a 39                	push   $0x39
  jmp alltraps
80105dec:	e9 29 f9 ff ff       	jmp    8010571a <alltraps>

80105df1 <vector58>:
.globl vector58
vector58:
  pushl $0
80105df1:	6a 00                	push   $0x0
  pushl $58
80105df3:	6a 3a                	push   $0x3a
  jmp alltraps
80105df5:	e9 20 f9 ff ff       	jmp    8010571a <alltraps>

80105dfa <vector59>:
.globl vector59
vector59:
  pushl $0
80105dfa:	6a 00                	push   $0x0
  pushl $59
80105dfc:	6a 3b                	push   $0x3b
  jmp alltraps
80105dfe:	e9 17 f9 ff ff       	jmp    8010571a <alltraps>

80105e03 <vector60>:
.globl vector60
vector60:
  pushl $0
80105e03:	6a 00                	push   $0x0
  pushl $60
80105e05:	6a 3c                	push   $0x3c
  jmp alltraps
80105e07:	e9 0e f9 ff ff       	jmp    8010571a <alltraps>

80105e0c <vector61>:
.globl vector61
vector61:
  pushl $0
80105e0c:	6a 00                	push   $0x0
  pushl $61
80105e0e:	6a 3d                	push   $0x3d
  jmp alltraps
80105e10:	e9 05 f9 ff ff       	jmp    8010571a <alltraps>

80105e15 <vector62>:
.globl vector62
vector62:
  pushl $0
80105e15:	6a 00                	push   $0x0
  pushl $62
80105e17:	6a 3e                	push   $0x3e
  jmp alltraps
80105e19:	e9 fc f8 ff ff       	jmp    8010571a <alltraps>

80105e1e <vector63>:
.globl vector63
vector63:
  pushl $0
80105e1e:	6a 00                	push   $0x0
  pushl $63
80105e20:	6a 3f                	push   $0x3f
  jmp alltraps
80105e22:	e9 f3 f8 ff ff       	jmp    8010571a <alltraps>

80105e27 <vector64>:
.globl vector64
vector64:
  pushl $0
80105e27:	6a 00                	push   $0x0
  pushl $64
80105e29:	6a 40                	push   $0x40
  jmp alltraps
80105e2b:	e9 ea f8 ff ff       	jmp    8010571a <alltraps>

80105e30 <vector65>:
.globl vector65
vector65:
  pushl $0
80105e30:	6a 00                	push   $0x0
  pushl $65
80105e32:	6a 41                	push   $0x41
  jmp alltraps
80105e34:	e9 e1 f8 ff ff       	jmp    8010571a <alltraps>

80105e39 <vector66>:
.globl vector66
vector66:
  pushl $0
80105e39:	6a 00                	push   $0x0
  pushl $66
80105e3b:	6a 42                	push   $0x42
  jmp alltraps
80105e3d:	e9 d8 f8 ff ff       	jmp    8010571a <alltraps>

80105e42 <vector67>:
.globl vector67
vector67:
  pushl $0
80105e42:	6a 00                	push   $0x0
  pushl $67
80105e44:	6a 43                	push   $0x43
  jmp alltraps
80105e46:	e9 cf f8 ff ff       	jmp    8010571a <alltraps>

80105e4b <vector68>:
.globl vector68
vector68:
  pushl $0
80105e4b:	6a 00                	push   $0x0
  pushl $68
80105e4d:	6a 44                	push   $0x44
  jmp alltraps
80105e4f:	e9 c6 f8 ff ff       	jmp    8010571a <alltraps>

80105e54 <vector69>:
.globl vector69
vector69:
  pushl $0
80105e54:	6a 00                	push   $0x0
  pushl $69
80105e56:	6a 45                	push   $0x45
  jmp alltraps
80105e58:	e9 bd f8 ff ff       	jmp    8010571a <alltraps>

80105e5d <vector70>:
.globl vector70
vector70:
  pushl $0
80105e5d:	6a 00                	push   $0x0
  pushl $70
80105e5f:	6a 46                	push   $0x46
  jmp alltraps
80105e61:	e9 b4 f8 ff ff       	jmp    8010571a <alltraps>

80105e66 <vector71>:
.globl vector71
vector71:
  pushl $0
80105e66:	6a 00                	push   $0x0
  pushl $71
80105e68:	6a 47                	push   $0x47
  jmp alltraps
80105e6a:	e9 ab f8 ff ff       	jmp    8010571a <alltraps>

80105e6f <vector72>:
.globl vector72
vector72:
  pushl $0
80105e6f:	6a 00                	push   $0x0
  pushl $72
80105e71:	6a 48                	push   $0x48
  jmp alltraps
80105e73:	e9 a2 f8 ff ff       	jmp    8010571a <alltraps>

80105e78 <vector73>:
.globl vector73
vector73:
  pushl $0
80105e78:	6a 00                	push   $0x0
  pushl $73
80105e7a:	6a 49                	push   $0x49
  jmp alltraps
80105e7c:	e9 99 f8 ff ff       	jmp    8010571a <alltraps>

80105e81 <vector74>:
.globl vector74
vector74:
  pushl $0
80105e81:	6a 00                	push   $0x0
  pushl $74
80105e83:	6a 4a                	push   $0x4a
  jmp alltraps
80105e85:	e9 90 f8 ff ff       	jmp    8010571a <alltraps>

80105e8a <vector75>:
.globl vector75
vector75:
  pushl $0
80105e8a:	6a 00                	push   $0x0
  pushl $75
80105e8c:	6a 4b                	push   $0x4b
  jmp alltraps
80105e8e:	e9 87 f8 ff ff       	jmp    8010571a <alltraps>

80105e93 <vector76>:
.globl vector76
vector76:
  pushl $0
80105e93:	6a 00                	push   $0x0
  pushl $76
80105e95:	6a 4c                	push   $0x4c
  jmp alltraps
80105e97:	e9 7e f8 ff ff       	jmp    8010571a <alltraps>

80105e9c <vector77>:
.globl vector77
vector77:
  pushl $0
80105e9c:	6a 00                	push   $0x0
  pushl $77
80105e9e:	6a 4d                	push   $0x4d
  jmp alltraps
80105ea0:	e9 75 f8 ff ff       	jmp    8010571a <alltraps>

80105ea5 <vector78>:
.globl vector78
vector78:
  pushl $0
80105ea5:	6a 00                	push   $0x0
  pushl $78
80105ea7:	6a 4e                	push   $0x4e
  jmp alltraps
80105ea9:	e9 6c f8 ff ff       	jmp    8010571a <alltraps>

80105eae <vector79>:
.globl vector79
vector79:
  pushl $0
80105eae:	6a 00                	push   $0x0
  pushl $79
80105eb0:	6a 4f                	push   $0x4f
  jmp alltraps
80105eb2:	e9 63 f8 ff ff       	jmp    8010571a <alltraps>

80105eb7 <vector80>:
.globl vector80
vector80:
  pushl $0
80105eb7:	6a 00                	push   $0x0
  pushl $80
80105eb9:	6a 50                	push   $0x50
  jmp alltraps
80105ebb:	e9 5a f8 ff ff       	jmp    8010571a <alltraps>

80105ec0 <vector81>:
.globl vector81
vector81:
  pushl $0
80105ec0:	6a 00                	push   $0x0
  pushl $81
80105ec2:	6a 51                	push   $0x51
  jmp alltraps
80105ec4:	e9 51 f8 ff ff       	jmp    8010571a <alltraps>

80105ec9 <vector82>:
.globl vector82
vector82:
  pushl $0
80105ec9:	6a 00                	push   $0x0
  pushl $82
80105ecb:	6a 52                	push   $0x52
  jmp alltraps
80105ecd:	e9 48 f8 ff ff       	jmp    8010571a <alltraps>

80105ed2 <vector83>:
.globl vector83
vector83:
  pushl $0
80105ed2:	6a 00                	push   $0x0
  pushl $83
80105ed4:	6a 53                	push   $0x53
  jmp alltraps
80105ed6:	e9 3f f8 ff ff       	jmp    8010571a <alltraps>

80105edb <vector84>:
.globl vector84
vector84:
  pushl $0
80105edb:	6a 00                	push   $0x0
  pushl $84
80105edd:	6a 54                	push   $0x54
  jmp alltraps
80105edf:	e9 36 f8 ff ff       	jmp    8010571a <alltraps>

80105ee4 <vector85>:
.globl vector85
vector85:
  pushl $0
80105ee4:	6a 00                	push   $0x0
  pushl $85
80105ee6:	6a 55                	push   $0x55
  jmp alltraps
80105ee8:	e9 2d f8 ff ff       	jmp    8010571a <alltraps>

80105eed <vector86>:
.globl vector86
vector86:
  pushl $0
80105eed:	6a 00                	push   $0x0
  pushl $86
80105eef:	6a 56                	push   $0x56
  jmp alltraps
80105ef1:	e9 24 f8 ff ff       	jmp    8010571a <alltraps>

80105ef6 <vector87>:
.globl vector87
vector87:
  pushl $0
80105ef6:	6a 00                	push   $0x0
  pushl $87
80105ef8:	6a 57                	push   $0x57
  jmp alltraps
80105efa:	e9 1b f8 ff ff       	jmp    8010571a <alltraps>

80105eff <vector88>:
.globl vector88
vector88:
  pushl $0
80105eff:	6a 00                	push   $0x0
  pushl $88
80105f01:	6a 58                	push   $0x58
  jmp alltraps
80105f03:	e9 12 f8 ff ff       	jmp    8010571a <alltraps>

80105f08 <vector89>:
.globl vector89
vector89:
  pushl $0
80105f08:	6a 00                	push   $0x0
  pushl $89
80105f0a:	6a 59                	push   $0x59
  jmp alltraps
80105f0c:	e9 09 f8 ff ff       	jmp    8010571a <alltraps>

80105f11 <vector90>:
.globl vector90
vector90:
  pushl $0
80105f11:	6a 00                	push   $0x0
  pushl $90
80105f13:	6a 5a                	push   $0x5a
  jmp alltraps
80105f15:	e9 00 f8 ff ff       	jmp    8010571a <alltraps>

80105f1a <vector91>:
.globl vector91
vector91:
  pushl $0
80105f1a:	6a 00                	push   $0x0
  pushl $91
80105f1c:	6a 5b                	push   $0x5b
  jmp alltraps
80105f1e:	e9 f7 f7 ff ff       	jmp    8010571a <alltraps>

80105f23 <vector92>:
.globl vector92
vector92:
  pushl $0
80105f23:	6a 00                	push   $0x0
  pushl $92
80105f25:	6a 5c                	push   $0x5c
  jmp alltraps
80105f27:	e9 ee f7 ff ff       	jmp    8010571a <alltraps>

80105f2c <vector93>:
.globl vector93
vector93:
  pushl $0
80105f2c:	6a 00                	push   $0x0
  pushl $93
80105f2e:	6a 5d                	push   $0x5d
  jmp alltraps
80105f30:	e9 e5 f7 ff ff       	jmp    8010571a <alltraps>

80105f35 <vector94>:
.globl vector94
vector94:
  pushl $0
80105f35:	6a 00                	push   $0x0
  pushl $94
80105f37:	6a 5e                	push   $0x5e
  jmp alltraps
80105f39:	e9 dc f7 ff ff       	jmp    8010571a <alltraps>

80105f3e <vector95>:
.globl vector95
vector95:
  pushl $0
80105f3e:	6a 00                	push   $0x0
  pushl $95
80105f40:	6a 5f                	push   $0x5f
  jmp alltraps
80105f42:	e9 d3 f7 ff ff       	jmp    8010571a <alltraps>

80105f47 <vector96>:
.globl vector96
vector96:
  pushl $0
80105f47:	6a 00                	push   $0x0
  pushl $96
80105f49:	6a 60                	push   $0x60
  jmp alltraps
80105f4b:	e9 ca f7 ff ff       	jmp    8010571a <alltraps>

80105f50 <vector97>:
.globl vector97
vector97:
  pushl $0
80105f50:	6a 00                	push   $0x0
  pushl $97
80105f52:	6a 61                	push   $0x61
  jmp alltraps
80105f54:	e9 c1 f7 ff ff       	jmp    8010571a <alltraps>

80105f59 <vector98>:
.globl vector98
vector98:
  pushl $0
80105f59:	6a 00                	push   $0x0
  pushl $98
80105f5b:	6a 62                	push   $0x62
  jmp alltraps
80105f5d:	e9 b8 f7 ff ff       	jmp    8010571a <alltraps>

80105f62 <vector99>:
.globl vector99
vector99:
  pushl $0
80105f62:	6a 00                	push   $0x0
  pushl $99
80105f64:	6a 63                	push   $0x63
  jmp alltraps
80105f66:	e9 af f7 ff ff       	jmp    8010571a <alltraps>

80105f6b <vector100>:
.globl vector100
vector100:
  pushl $0
80105f6b:	6a 00                	push   $0x0
  pushl $100
80105f6d:	6a 64                	push   $0x64
  jmp alltraps
80105f6f:	e9 a6 f7 ff ff       	jmp    8010571a <alltraps>

80105f74 <vector101>:
.globl vector101
vector101:
  pushl $0
80105f74:	6a 00                	push   $0x0
  pushl $101
80105f76:	6a 65                	push   $0x65
  jmp alltraps
80105f78:	e9 9d f7 ff ff       	jmp    8010571a <alltraps>

80105f7d <vector102>:
.globl vector102
vector102:
  pushl $0
80105f7d:	6a 00                	push   $0x0
  pushl $102
80105f7f:	6a 66                	push   $0x66
  jmp alltraps
80105f81:	e9 94 f7 ff ff       	jmp    8010571a <alltraps>

80105f86 <vector103>:
.globl vector103
vector103:
  pushl $0
80105f86:	6a 00                	push   $0x0
  pushl $103
80105f88:	6a 67                	push   $0x67
  jmp alltraps
80105f8a:	e9 8b f7 ff ff       	jmp    8010571a <alltraps>

80105f8f <vector104>:
.globl vector104
vector104:
  pushl $0
80105f8f:	6a 00                	push   $0x0
  pushl $104
80105f91:	6a 68                	push   $0x68
  jmp alltraps
80105f93:	e9 82 f7 ff ff       	jmp    8010571a <alltraps>

80105f98 <vector105>:
.globl vector105
vector105:
  pushl $0
80105f98:	6a 00                	push   $0x0
  pushl $105
80105f9a:	6a 69                	push   $0x69
  jmp alltraps
80105f9c:	e9 79 f7 ff ff       	jmp    8010571a <alltraps>

80105fa1 <vector106>:
.globl vector106
vector106:
  pushl $0
80105fa1:	6a 00                	push   $0x0
  pushl $106
80105fa3:	6a 6a                	push   $0x6a
  jmp alltraps
80105fa5:	e9 70 f7 ff ff       	jmp    8010571a <alltraps>

80105faa <vector107>:
.globl vector107
vector107:
  pushl $0
80105faa:	6a 00                	push   $0x0
  pushl $107
80105fac:	6a 6b                	push   $0x6b
  jmp alltraps
80105fae:	e9 67 f7 ff ff       	jmp    8010571a <alltraps>

80105fb3 <vector108>:
.globl vector108
vector108:
  pushl $0
80105fb3:	6a 00                	push   $0x0
  pushl $108
80105fb5:	6a 6c                	push   $0x6c
  jmp alltraps
80105fb7:	e9 5e f7 ff ff       	jmp    8010571a <alltraps>

80105fbc <vector109>:
.globl vector109
vector109:
  pushl $0
80105fbc:	6a 00                	push   $0x0
  pushl $109
80105fbe:	6a 6d                	push   $0x6d
  jmp alltraps
80105fc0:	e9 55 f7 ff ff       	jmp    8010571a <alltraps>

80105fc5 <vector110>:
.globl vector110
vector110:
  pushl $0
80105fc5:	6a 00                	push   $0x0
  pushl $110
80105fc7:	6a 6e                	push   $0x6e
  jmp alltraps
80105fc9:	e9 4c f7 ff ff       	jmp    8010571a <alltraps>

80105fce <vector111>:
.globl vector111
vector111:
  pushl $0
80105fce:	6a 00                	push   $0x0
  pushl $111
80105fd0:	6a 6f                	push   $0x6f
  jmp alltraps
80105fd2:	e9 43 f7 ff ff       	jmp    8010571a <alltraps>

80105fd7 <vector112>:
.globl vector112
vector112:
  pushl $0
80105fd7:	6a 00                	push   $0x0
  pushl $112
80105fd9:	6a 70                	push   $0x70
  jmp alltraps
80105fdb:	e9 3a f7 ff ff       	jmp    8010571a <alltraps>

80105fe0 <vector113>:
.globl vector113
vector113:
  pushl $0
80105fe0:	6a 00                	push   $0x0
  pushl $113
80105fe2:	6a 71                	push   $0x71
  jmp alltraps
80105fe4:	e9 31 f7 ff ff       	jmp    8010571a <alltraps>

80105fe9 <vector114>:
.globl vector114
vector114:
  pushl $0
80105fe9:	6a 00                	push   $0x0
  pushl $114
80105feb:	6a 72                	push   $0x72
  jmp alltraps
80105fed:	e9 28 f7 ff ff       	jmp    8010571a <alltraps>

80105ff2 <vector115>:
.globl vector115
vector115:
  pushl $0
80105ff2:	6a 00                	push   $0x0
  pushl $115
80105ff4:	6a 73                	push   $0x73
  jmp alltraps
80105ff6:	e9 1f f7 ff ff       	jmp    8010571a <alltraps>

80105ffb <vector116>:
.globl vector116
vector116:
  pushl $0
80105ffb:	6a 00                	push   $0x0
  pushl $116
80105ffd:	6a 74                	push   $0x74
  jmp alltraps
80105fff:	e9 16 f7 ff ff       	jmp    8010571a <alltraps>

80106004 <vector117>:
.globl vector117
vector117:
  pushl $0
80106004:	6a 00                	push   $0x0
  pushl $117
80106006:	6a 75                	push   $0x75
  jmp alltraps
80106008:	e9 0d f7 ff ff       	jmp    8010571a <alltraps>

8010600d <vector118>:
.globl vector118
vector118:
  pushl $0
8010600d:	6a 00                	push   $0x0
  pushl $118
8010600f:	6a 76                	push   $0x76
  jmp alltraps
80106011:	e9 04 f7 ff ff       	jmp    8010571a <alltraps>

80106016 <vector119>:
.globl vector119
vector119:
  pushl $0
80106016:	6a 00                	push   $0x0
  pushl $119
80106018:	6a 77                	push   $0x77
  jmp alltraps
8010601a:	e9 fb f6 ff ff       	jmp    8010571a <alltraps>

8010601f <vector120>:
.globl vector120
vector120:
  pushl $0
8010601f:	6a 00                	push   $0x0
  pushl $120
80106021:	6a 78                	push   $0x78
  jmp alltraps
80106023:	e9 f2 f6 ff ff       	jmp    8010571a <alltraps>

80106028 <vector121>:
.globl vector121
vector121:
  pushl $0
80106028:	6a 00                	push   $0x0
  pushl $121
8010602a:	6a 79                	push   $0x79
  jmp alltraps
8010602c:	e9 e9 f6 ff ff       	jmp    8010571a <alltraps>

80106031 <vector122>:
.globl vector122
vector122:
  pushl $0
80106031:	6a 00                	push   $0x0
  pushl $122
80106033:	6a 7a                	push   $0x7a
  jmp alltraps
80106035:	e9 e0 f6 ff ff       	jmp    8010571a <alltraps>

8010603a <vector123>:
.globl vector123
vector123:
  pushl $0
8010603a:	6a 00                	push   $0x0
  pushl $123
8010603c:	6a 7b                	push   $0x7b
  jmp alltraps
8010603e:	e9 d7 f6 ff ff       	jmp    8010571a <alltraps>

80106043 <vector124>:
.globl vector124
vector124:
  pushl $0
80106043:	6a 00                	push   $0x0
  pushl $124
80106045:	6a 7c                	push   $0x7c
  jmp alltraps
80106047:	e9 ce f6 ff ff       	jmp    8010571a <alltraps>

8010604c <vector125>:
.globl vector125
vector125:
  pushl $0
8010604c:	6a 00                	push   $0x0
  pushl $125
8010604e:	6a 7d                	push   $0x7d
  jmp alltraps
80106050:	e9 c5 f6 ff ff       	jmp    8010571a <alltraps>

80106055 <vector126>:
.globl vector126
vector126:
  pushl $0
80106055:	6a 00                	push   $0x0
  pushl $126
80106057:	6a 7e                	push   $0x7e
  jmp alltraps
80106059:	e9 bc f6 ff ff       	jmp    8010571a <alltraps>

8010605e <vector127>:
.globl vector127
vector127:
  pushl $0
8010605e:	6a 00                	push   $0x0
  pushl $127
80106060:	6a 7f                	push   $0x7f
  jmp alltraps
80106062:	e9 b3 f6 ff ff       	jmp    8010571a <alltraps>

80106067 <vector128>:
.globl vector128
vector128:
  pushl $0
80106067:	6a 00                	push   $0x0
  pushl $128
80106069:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010606e:	e9 a7 f6 ff ff       	jmp    8010571a <alltraps>

80106073 <vector129>:
.globl vector129
vector129:
  pushl $0
80106073:	6a 00                	push   $0x0
  pushl $129
80106075:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010607a:	e9 9b f6 ff ff       	jmp    8010571a <alltraps>

8010607f <vector130>:
.globl vector130
vector130:
  pushl $0
8010607f:	6a 00                	push   $0x0
  pushl $130
80106081:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106086:	e9 8f f6 ff ff       	jmp    8010571a <alltraps>

8010608b <vector131>:
.globl vector131
vector131:
  pushl $0
8010608b:	6a 00                	push   $0x0
  pushl $131
8010608d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106092:	e9 83 f6 ff ff       	jmp    8010571a <alltraps>

80106097 <vector132>:
.globl vector132
vector132:
  pushl $0
80106097:	6a 00                	push   $0x0
  pushl $132
80106099:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010609e:	e9 77 f6 ff ff       	jmp    8010571a <alltraps>

801060a3 <vector133>:
.globl vector133
vector133:
  pushl $0
801060a3:	6a 00                	push   $0x0
  pushl $133
801060a5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801060aa:	e9 6b f6 ff ff       	jmp    8010571a <alltraps>

801060af <vector134>:
.globl vector134
vector134:
  pushl $0
801060af:	6a 00                	push   $0x0
  pushl $134
801060b1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801060b6:	e9 5f f6 ff ff       	jmp    8010571a <alltraps>

801060bb <vector135>:
.globl vector135
vector135:
  pushl $0
801060bb:	6a 00                	push   $0x0
  pushl $135
801060bd:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801060c2:	e9 53 f6 ff ff       	jmp    8010571a <alltraps>

801060c7 <vector136>:
.globl vector136
vector136:
  pushl $0
801060c7:	6a 00                	push   $0x0
  pushl $136
801060c9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801060ce:	e9 47 f6 ff ff       	jmp    8010571a <alltraps>

801060d3 <vector137>:
.globl vector137
vector137:
  pushl $0
801060d3:	6a 00                	push   $0x0
  pushl $137
801060d5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801060da:	e9 3b f6 ff ff       	jmp    8010571a <alltraps>

801060df <vector138>:
.globl vector138
vector138:
  pushl $0
801060df:	6a 00                	push   $0x0
  pushl $138
801060e1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801060e6:	e9 2f f6 ff ff       	jmp    8010571a <alltraps>

801060eb <vector139>:
.globl vector139
vector139:
  pushl $0
801060eb:	6a 00                	push   $0x0
  pushl $139
801060ed:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801060f2:	e9 23 f6 ff ff       	jmp    8010571a <alltraps>

801060f7 <vector140>:
.globl vector140
vector140:
  pushl $0
801060f7:	6a 00                	push   $0x0
  pushl $140
801060f9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801060fe:	e9 17 f6 ff ff       	jmp    8010571a <alltraps>

80106103 <vector141>:
.globl vector141
vector141:
  pushl $0
80106103:	6a 00                	push   $0x0
  pushl $141
80106105:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010610a:	e9 0b f6 ff ff       	jmp    8010571a <alltraps>

8010610f <vector142>:
.globl vector142
vector142:
  pushl $0
8010610f:	6a 00                	push   $0x0
  pushl $142
80106111:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106116:	e9 ff f5 ff ff       	jmp    8010571a <alltraps>

8010611b <vector143>:
.globl vector143
vector143:
  pushl $0
8010611b:	6a 00                	push   $0x0
  pushl $143
8010611d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106122:	e9 f3 f5 ff ff       	jmp    8010571a <alltraps>

80106127 <vector144>:
.globl vector144
vector144:
  pushl $0
80106127:	6a 00                	push   $0x0
  pushl $144
80106129:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010612e:	e9 e7 f5 ff ff       	jmp    8010571a <alltraps>

80106133 <vector145>:
.globl vector145
vector145:
  pushl $0
80106133:	6a 00                	push   $0x0
  pushl $145
80106135:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010613a:	e9 db f5 ff ff       	jmp    8010571a <alltraps>

8010613f <vector146>:
.globl vector146
vector146:
  pushl $0
8010613f:	6a 00                	push   $0x0
  pushl $146
80106141:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106146:	e9 cf f5 ff ff       	jmp    8010571a <alltraps>

8010614b <vector147>:
.globl vector147
vector147:
  pushl $0
8010614b:	6a 00                	push   $0x0
  pushl $147
8010614d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106152:	e9 c3 f5 ff ff       	jmp    8010571a <alltraps>

80106157 <vector148>:
.globl vector148
vector148:
  pushl $0
80106157:	6a 00                	push   $0x0
  pushl $148
80106159:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010615e:	e9 b7 f5 ff ff       	jmp    8010571a <alltraps>

80106163 <vector149>:
.globl vector149
vector149:
  pushl $0
80106163:	6a 00                	push   $0x0
  pushl $149
80106165:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010616a:	e9 ab f5 ff ff       	jmp    8010571a <alltraps>

8010616f <vector150>:
.globl vector150
vector150:
  pushl $0
8010616f:	6a 00                	push   $0x0
  pushl $150
80106171:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106176:	e9 9f f5 ff ff       	jmp    8010571a <alltraps>

8010617b <vector151>:
.globl vector151
vector151:
  pushl $0
8010617b:	6a 00                	push   $0x0
  pushl $151
8010617d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106182:	e9 93 f5 ff ff       	jmp    8010571a <alltraps>

80106187 <vector152>:
.globl vector152
vector152:
  pushl $0
80106187:	6a 00                	push   $0x0
  pushl $152
80106189:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010618e:	e9 87 f5 ff ff       	jmp    8010571a <alltraps>

80106193 <vector153>:
.globl vector153
vector153:
  pushl $0
80106193:	6a 00                	push   $0x0
  pushl $153
80106195:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010619a:	e9 7b f5 ff ff       	jmp    8010571a <alltraps>

8010619f <vector154>:
.globl vector154
vector154:
  pushl $0
8010619f:	6a 00                	push   $0x0
  pushl $154
801061a1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801061a6:	e9 6f f5 ff ff       	jmp    8010571a <alltraps>

801061ab <vector155>:
.globl vector155
vector155:
  pushl $0
801061ab:	6a 00                	push   $0x0
  pushl $155
801061ad:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801061b2:	e9 63 f5 ff ff       	jmp    8010571a <alltraps>

801061b7 <vector156>:
.globl vector156
vector156:
  pushl $0
801061b7:	6a 00                	push   $0x0
  pushl $156
801061b9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801061be:	e9 57 f5 ff ff       	jmp    8010571a <alltraps>

801061c3 <vector157>:
.globl vector157
vector157:
  pushl $0
801061c3:	6a 00                	push   $0x0
  pushl $157
801061c5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801061ca:	e9 4b f5 ff ff       	jmp    8010571a <alltraps>

801061cf <vector158>:
.globl vector158
vector158:
  pushl $0
801061cf:	6a 00                	push   $0x0
  pushl $158
801061d1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801061d6:	e9 3f f5 ff ff       	jmp    8010571a <alltraps>

801061db <vector159>:
.globl vector159
vector159:
  pushl $0
801061db:	6a 00                	push   $0x0
  pushl $159
801061dd:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801061e2:	e9 33 f5 ff ff       	jmp    8010571a <alltraps>

801061e7 <vector160>:
.globl vector160
vector160:
  pushl $0
801061e7:	6a 00                	push   $0x0
  pushl $160
801061e9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801061ee:	e9 27 f5 ff ff       	jmp    8010571a <alltraps>

801061f3 <vector161>:
.globl vector161
vector161:
  pushl $0
801061f3:	6a 00                	push   $0x0
  pushl $161
801061f5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801061fa:	e9 1b f5 ff ff       	jmp    8010571a <alltraps>

801061ff <vector162>:
.globl vector162
vector162:
  pushl $0
801061ff:	6a 00                	push   $0x0
  pushl $162
80106201:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106206:	e9 0f f5 ff ff       	jmp    8010571a <alltraps>

8010620b <vector163>:
.globl vector163
vector163:
  pushl $0
8010620b:	6a 00                	push   $0x0
  pushl $163
8010620d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106212:	e9 03 f5 ff ff       	jmp    8010571a <alltraps>

80106217 <vector164>:
.globl vector164
vector164:
  pushl $0
80106217:	6a 00                	push   $0x0
  pushl $164
80106219:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010621e:	e9 f7 f4 ff ff       	jmp    8010571a <alltraps>

80106223 <vector165>:
.globl vector165
vector165:
  pushl $0
80106223:	6a 00                	push   $0x0
  pushl $165
80106225:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010622a:	e9 eb f4 ff ff       	jmp    8010571a <alltraps>

8010622f <vector166>:
.globl vector166
vector166:
  pushl $0
8010622f:	6a 00                	push   $0x0
  pushl $166
80106231:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106236:	e9 df f4 ff ff       	jmp    8010571a <alltraps>

8010623b <vector167>:
.globl vector167
vector167:
  pushl $0
8010623b:	6a 00                	push   $0x0
  pushl $167
8010623d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106242:	e9 d3 f4 ff ff       	jmp    8010571a <alltraps>

80106247 <vector168>:
.globl vector168
vector168:
  pushl $0
80106247:	6a 00                	push   $0x0
  pushl $168
80106249:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010624e:	e9 c7 f4 ff ff       	jmp    8010571a <alltraps>

80106253 <vector169>:
.globl vector169
vector169:
  pushl $0
80106253:	6a 00                	push   $0x0
  pushl $169
80106255:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010625a:	e9 bb f4 ff ff       	jmp    8010571a <alltraps>

8010625f <vector170>:
.globl vector170
vector170:
  pushl $0
8010625f:	6a 00                	push   $0x0
  pushl $170
80106261:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106266:	e9 af f4 ff ff       	jmp    8010571a <alltraps>

8010626b <vector171>:
.globl vector171
vector171:
  pushl $0
8010626b:	6a 00                	push   $0x0
  pushl $171
8010626d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106272:	e9 a3 f4 ff ff       	jmp    8010571a <alltraps>

80106277 <vector172>:
.globl vector172
vector172:
  pushl $0
80106277:	6a 00                	push   $0x0
  pushl $172
80106279:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010627e:	e9 97 f4 ff ff       	jmp    8010571a <alltraps>

80106283 <vector173>:
.globl vector173
vector173:
  pushl $0
80106283:	6a 00                	push   $0x0
  pushl $173
80106285:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010628a:	e9 8b f4 ff ff       	jmp    8010571a <alltraps>

8010628f <vector174>:
.globl vector174
vector174:
  pushl $0
8010628f:	6a 00                	push   $0x0
  pushl $174
80106291:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106296:	e9 7f f4 ff ff       	jmp    8010571a <alltraps>

8010629b <vector175>:
.globl vector175
vector175:
  pushl $0
8010629b:	6a 00                	push   $0x0
  pushl $175
8010629d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801062a2:	e9 73 f4 ff ff       	jmp    8010571a <alltraps>

801062a7 <vector176>:
.globl vector176
vector176:
  pushl $0
801062a7:	6a 00                	push   $0x0
  pushl $176
801062a9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801062ae:	e9 67 f4 ff ff       	jmp    8010571a <alltraps>

801062b3 <vector177>:
.globl vector177
vector177:
  pushl $0
801062b3:	6a 00                	push   $0x0
  pushl $177
801062b5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801062ba:	e9 5b f4 ff ff       	jmp    8010571a <alltraps>

801062bf <vector178>:
.globl vector178
vector178:
  pushl $0
801062bf:	6a 00                	push   $0x0
  pushl $178
801062c1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801062c6:	e9 4f f4 ff ff       	jmp    8010571a <alltraps>

801062cb <vector179>:
.globl vector179
vector179:
  pushl $0
801062cb:	6a 00                	push   $0x0
  pushl $179
801062cd:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801062d2:	e9 43 f4 ff ff       	jmp    8010571a <alltraps>

801062d7 <vector180>:
.globl vector180
vector180:
  pushl $0
801062d7:	6a 00                	push   $0x0
  pushl $180
801062d9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801062de:	e9 37 f4 ff ff       	jmp    8010571a <alltraps>

801062e3 <vector181>:
.globl vector181
vector181:
  pushl $0
801062e3:	6a 00                	push   $0x0
  pushl $181
801062e5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801062ea:	e9 2b f4 ff ff       	jmp    8010571a <alltraps>

801062ef <vector182>:
.globl vector182
vector182:
  pushl $0
801062ef:	6a 00                	push   $0x0
  pushl $182
801062f1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801062f6:	e9 1f f4 ff ff       	jmp    8010571a <alltraps>

801062fb <vector183>:
.globl vector183
vector183:
  pushl $0
801062fb:	6a 00                	push   $0x0
  pushl $183
801062fd:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106302:	e9 13 f4 ff ff       	jmp    8010571a <alltraps>

80106307 <vector184>:
.globl vector184
vector184:
  pushl $0
80106307:	6a 00                	push   $0x0
  pushl $184
80106309:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010630e:	e9 07 f4 ff ff       	jmp    8010571a <alltraps>

80106313 <vector185>:
.globl vector185
vector185:
  pushl $0
80106313:	6a 00                	push   $0x0
  pushl $185
80106315:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010631a:	e9 fb f3 ff ff       	jmp    8010571a <alltraps>

8010631f <vector186>:
.globl vector186
vector186:
  pushl $0
8010631f:	6a 00                	push   $0x0
  pushl $186
80106321:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106326:	e9 ef f3 ff ff       	jmp    8010571a <alltraps>

8010632b <vector187>:
.globl vector187
vector187:
  pushl $0
8010632b:	6a 00                	push   $0x0
  pushl $187
8010632d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106332:	e9 e3 f3 ff ff       	jmp    8010571a <alltraps>

80106337 <vector188>:
.globl vector188
vector188:
  pushl $0
80106337:	6a 00                	push   $0x0
  pushl $188
80106339:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010633e:	e9 d7 f3 ff ff       	jmp    8010571a <alltraps>

80106343 <vector189>:
.globl vector189
vector189:
  pushl $0
80106343:	6a 00                	push   $0x0
  pushl $189
80106345:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010634a:	e9 cb f3 ff ff       	jmp    8010571a <alltraps>

8010634f <vector190>:
.globl vector190
vector190:
  pushl $0
8010634f:	6a 00                	push   $0x0
  pushl $190
80106351:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106356:	e9 bf f3 ff ff       	jmp    8010571a <alltraps>

8010635b <vector191>:
.globl vector191
vector191:
  pushl $0
8010635b:	6a 00                	push   $0x0
  pushl $191
8010635d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106362:	e9 b3 f3 ff ff       	jmp    8010571a <alltraps>

80106367 <vector192>:
.globl vector192
vector192:
  pushl $0
80106367:	6a 00                	push   $0x0
  pushl $192
80106369:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010636e:	e9 a7 f3 ff ff       	jmp    8010571a <alltraps>

80106373 <vector193>:
.globl vector193
vector193:
  pushl $0
80106373:	6a 00                	push   $0x0
  pushl $193
80106375:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010637a:	e9 9b f3 ff ff       	jmp    8010571a <alltraps>

8010637f <vector194>:
.globl vector194
vector194:
  pushl $0
8010637f:	6a 00                	push   $0x0
  pushl $194
80106381:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106386:	e9 8f f3 ff ff       	jmp    8010571a <alltraps>

8010638b <vector195>:
.globl vector195
vector195:
  pushl $0
8010638b:	6a 00                	push   $0x0
  pushl $195
8010638d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106392:	e9 83 f3 ff ff       	jmp    8010571a <alltraps>

80106397 <vector196>:
.globl vector196
vector196:
  pushl $0
80106397:	6a 00                	push   $0x0
  pushl $196
80106399:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010639e:	e9 77 f3 ff ff       	jmp    8010571a <alltraps>

801063a3 <vector197>:
.globl vector197
vector197:
  pushl $0
801063a3:	6a 00                	push   $0x0
  pushl $197
801063a5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801063aa:	e9 6b f3 ff ff       	jmp    8010571a <alltraps>

801063af <vector198>:
.globl vector198
vector198:
  pushl $0
801063af:	6a 00                	push   $0x0
  pushl $198
801063b1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801063b6:	e9 5f f3 ff ff       	jmp    8010571a <alltraps>

801063bb <vector199>:
.globl vector199
vector199:
  pushl $0
801063bb:	6a 00                	push   $0x0
  pushl $199
801063bd:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801063c2:	e9 53 f3 ff ff       	jmp    8010571a <alltraps>

801063c7 <vector200>:
.globl vector200
vector200:
  pushl $0
801063c7:	6a 00                	push   $0x0
  pushl $200
801063c9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801063ce:	e9 47 f3 ff ff       	jmp    8010571a <alltraps>

801063d3 <vector201>:
.globl vector201
vector201:
  pushl $0
801063d3:	6a 00                	push   $0x0
  pushl $201
801063d5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801063da:	e9 3b f3 ff ff       	jmp    8010571a <alltraps>

801063df <vector202>:
.globl vector202
vector202:
  pushl $0
801063df:	6a 00                	push   $0x0
  pushl $202
801063e1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801063e6:	e9 2f f3 ff ff       	jmp    8010571a <alltraps>

801063eb <vector203>:
.globl vector203
vector203:
  pushl $0
801063eb:	6a 00                	push   $0x0
  pushl $203
801063ed:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801063f2:	e9 23 f3 ff ff       	jmp    8010571a <alltraps>

801063f7 <vector204>:
.globl vector204
vector204:
  pushl $0
801063f7:	6a 00                	push   $0x0
  pushl $204
801063f9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801063fe:	e9 17 f3 ff ff       	jmp    8010571a <alltraps>

80106403 <vector205>:
.globl vector205
vector205:
  pushl $0
80106403:	6a 00                	push   $0x0
  pushl $205
80106405:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010640a:	e9 0b f3 ff ff       	jmp    8010571a <alltraps>

8010640f <vector206>:
.globl vector206
vector206:
  pushl $0
8010640f:	6a 00                	push   $0x0
  pushl $206
80106411:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106416:	e9 ff f2 ff ff       	jmp    8010571a <alltraps>

8010641b <vector207>:
.globl vector207
vector207:
  pushl $0
8010641b:	6a 00                	push   $0x0
  pushl $207
8010641d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106422:	e9 f3 f2 ff ff       	jmp    8010571a <alltraps>

80106427 <vector208>:
.globl vector208
vector208:
  pushl $0
80106427:	6a 00                	push   $0x0
  pushl $208
80106429:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010642e:	e9 e7 f2 ff ff       	jmp    8010571a <alltraps>

80106433 <vector209>:
.globl vector209
vector209:
  pushl $0
80106433:	6a 00                	push   $0x0
  pushl $209
80106435:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010643a:	e9 db f2 ff ff       	jmp    8010571a <alltraps>

8010643f <vector210>:
.globl vector210
vector210:
  pushl $0
8010643f:	6a 00                	push   $0x0
  pushl $210
80106441:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106446:	e9 cf f2 ff ff       	jmp    8010571a <alltraps>

8010644b <vector211>:
.globl vector211
vector211:
  pushl $0
8010644b:	6a 00                	push   $0x0
  pushl $211
8010644d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106452:	e9 c3 f2 ff ff       	jmp    8010571a <alltraps>

80106457 <vector212>:
.globl vector212
vector212:
  pushl $0
80106457:	6a 00                	push   $0x0
  pushl $212
80106459:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010645e:	e9 b7 f2 ff ff       	jmp    8010571a <alltraps>

80106463 <vector213>:
.globl vector213
vector213:
  pushl $0
80106463:	6a 00                	push   $0x0
  pushl $213
80106465:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010646a:	e9 ab f2 ff ff       	jmp    8010571a <alltraps>

8010646f <vector214>:
.globl vector214
vector214:
  pushl $0
8010646f:	6a 00                	push   $0x0
  pushl $214
80106471:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106476:	e9 9f f2 ff ff       	jmp    8010571a <alltraps>

8010647b <vector215>:
.globl vector215
vector215:
  pushl $0
8010647b:	6a 00                	push   $0x0
  pushl $215
8010647d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106482:	e9 93 f2 ff ff       	jmp    8010571a <alltraps>

80106487 <vector216>:
.globl vector216
vector216:
  pushl $0
80106487:	6a 00                	push   $0x0
  pushl $216
80106489:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010648e:	e9 87 f2 ff ff       	jmp    8010571a <alltraps>

80106493 <vector217>:
.globl vector217
vector217:
  pushl $0
80106493:	6a 00                	push   $0x0
  pushl $217
80106495:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010649a:	e9 7b f2 ff ff       	jmp    8010571a <alltraps>

8010649f <vector218>:
.globl vector218
vector218:
  pushl $0
8010649f:	6a 00                	push   $0x0
  pushl $218
801064a1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801064a6:	e9 6f f2 ff ff       	jmp    8010571a <alltraps>

801064ab <vector219>:
.globl vector219
vector219:
  pushl $0
801064ab:	6a 00                	push   $0x0
  pushl $219
801064ad:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801064b2:	e9 63 f2 ff ff       	jmp    8010571a <alltraps>

801064b7 <vector220>:
.globl vector220
vector220:
  pushl $0
801064b7:	6a 00                	push   $0x0
  pushl $220
801064b9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801064be:	e9 57 f2 ff ff       	jmp    8010571a <alltraps>

801064c3 <vector221>:
.globl vector221
vector221:
  pushl $0
801064c3:	6a 00                	push   $0x0
  pushl $221
801064c5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801064ca:	e9 4b f2 ff ff       	jmp    8010571a <alltraps>

801064cf <vector222>:
.globl vector222
vector222:
  pushl $0
801064cf:	6a 00                	push   $0x0
  pushl $222
801064d1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801064d6:	e9 3f f2 ff ff       	jmp    8010571a <alltraps>

801064db <vector223>:
.globl vector223
vector223:
  pushl $0
801064db:	6a 00                	push   $0x0
  pushl $223
801064dd:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801064e2:	e9 33 f2 ff ff       	jmp    8010571a <alltraps>

801064e7 <vector224>:
.globl vector224
vector224:
  pushl $0
801064e7:	6a 00                	push   $0x0
  pushl $224
801064e9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801064ee:	e9 27 f2 ff ff       	jmp    8010571a <alltraps>

801064f3 <vector225>:
.globl vector225
vector225:
  pushl $0
801064f3:	6a 00                	push   $0x0
  pushl $225
801064f5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801064fa:	e9 1b f2 ff ff       	jmp    8010571a <alltraps>

801064ff <vector226>:
.globl vector226
vector226:
  pushl $0
801064ff:	6a 00                	push   $0x0
  pushl $226
80106501:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106506:	e9 0f f2 ff ff       	jmp    8010571a <alltraps>

8010650b <vector227>:
.globl vector227
vector227:
  pushl $0
8010650b:	6a 00                	push   $0x0
  pushl $227
8010650d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106512:	e9 03 f2 ff ff       	jmp    8010571a <alltraps>

80106517 <vector228>:
.globl vector228
vector228:
  pushl $0
80106517:	6a 00                	push   $0x0
  pushl $228
80106519:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010651e:	e9 f7 f1 ff ff       	jmp    8010571a <alltraps>

80106523 <vector229>:
.globl vector229
vector229:
  pushl $0
80106523:	6a 00                	push   $0x0
  pushl $229
80106525:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010652a:	e9 eb f1 ff ff       	jmp    8010571a <alltraps>

8010652f <vector230>:
.globl vector230
vector230:
  pushl $0
8010652f:	6a 00                	push   $0x0
  pushl $230
80106531:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106536:	e9 df f1 ff ff       	jmp    8010571a <alltraps>

8010653b <vector231>:
.globl vector231
vector231:
  pushl $0
8010653b:	6a 00                	push   $0x0
  pushl $231
8010653d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106542:	e9 d3 f1 ff ff       	jmp    8010571a <alltraps>

80106547 <vector232>:
.globl vector232
vector232:
  pushl $0
80106547:	6a 00                	push   $0x0
  pushl $232
80106549:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010654e:	e9 c7 f1 ff ff       	jmp    8010571a <alltraps>

80106553 <vector233>:
.globl vector233
vector233:
  pushl $0
80106553:	6a 00                	push   $0x0
  pushl $233
80106555:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010655a:	e9 bb f1 ff ff       	jmp    8010571a <alltraps>

8010655f <vector234>:
.globl vector234
vector234:
  pushl $0
8010655f:	6a 00                	push   $0x0
  pushl $234
80106561:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106566:	e9 af f1 ff ff       	jmp    8010571a <alltraps>

8010656b <vector235>:
.globl vector235
vector235:
  pushl $0
8010656b:	6a 00                	push   $0x0
  pushl $235
8010656d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106572:	e9 a3 f1 ff ff       	jmp    8010571a <alltraps>

80106577 <vector236>:
.globl vector236
vector236:
  pushl $0
80106577:	6a 00                	push   $0x0
  pushl $236
80106579:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010657e:	e9 97 f1 ff ff       	jmp    8010571a <alltraps>

80106583 <vector237>:
.globl vector237
vector237:
  pushl $0
80106583:	6a 00                	push   $0x0
  pushl $237
80106585:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010658a:	e9 8b f1 ff ff       	jmp    8010571a <alltraps>

8010658f <vector238>:
.globl vector238
vector238:
  pushl $0
8010658f:	6a 00                	push   $0x0
  pushl $238
80106591:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106596:	e9 7f f1 ff ff       	jmp    8010571a <alltraps>

8010659b <vector239>:
.globl vector239
vector239:
  pushl $0
8010659b:	6a 00                	push   $0x0
  pushl $239
8010659d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801065a2:	e9 73 f1 ff ff       	jmp    8010571a <alltraps>

801065a7 <vector240>:
.globl vector240
vector240:
  pushl $0
801065a7:	6a 00                	push   $0x0
  pushl $240
801065a9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801065ae:	e9 67 f1 ff ff       	jmp    8010571a <alltraps>

801065b3 <vector241>:
.globl vector241
vector241:
  pushl $0
801065b3:	6a 00                	push   $0x0
  pushl $241
801065b5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801065ba:	e9 5b f1 ff ff       	jmp    8010571a <alltraps>

801065bf <vector242>:
.globl vector242
vector242:
  pushl $0
801065bf:	6a 00                	push   $0x0
  pushl $242
801065c1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801065c6:	e9 4f f1 ff ff       	jmp    8010571a <alltraps>

801065cb <vector243>:
.globl vector243
vector243:
  pushl $0
801065cb:	6a 00                	push   $0x0
  pushl $243
801065cd:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801065d2:	e9 43 f1 ff ff       	jmp    8010571a <alltraps>

801065d7 <vector244>:
.globl vector244
vector244:
  pushl $0
801065d7:	6a 00                	push   $0x0
  pushl $244
801065d9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801065de:	e9 37 f1 ff ff       	jmp    8010571a <alltraps>

801065e3 <vector245>:
.globl vector245
vector245:
  pushl $0
801065e3:	6a 00                	push   $0x0
  pushl $245
801065e5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801065ea:	e9 2b f1 ff ff       	jmp    8010571a <alltraps>

801065ef <vector246>:
.globl vector246
vector246:
  pushl $0
801065ef:	6a 00                	push   $0x0
  pushl $246
801065f1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801065f6:	e9 1f f1 ff ff       	jmp    8010571a <alltraps>

801065fb <vector247>:
.globl vector247
vector247:
  pushl $0
801065fb:	6a 00                	push   $0x0
  pushl $247
801065fd:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106602:	e9 13 f1 ff ff       	jmp    8010571a <alltraps>

80106607 <vector248>:
.globl vector248
vector248:
  pushl $0
80106607:	6a 00                	push   $0x0
  pushl $248
80106609:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010660e:	e9 07 f1 ff ff       	jmp    8010571a <alltraps>

80106613 <vector249>:
.globl vector249
vector249:
  pushl $0
80106613:	6a 00                	push   $0x0
  pushl $249
80106615:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010661a:	e9 fb f0 ff ff       	jmp    8010571a <alltraps>

8010661f <vector250>:
.globl vector250
vector250:
  pushl $0
8010661f:	6a 00                	push   $0x0
  pushl $250
80106621:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106626:	e9 ef f0 ff ff       	jmp    8010571a <alltraps>

8010662b <vector251>:
.globl vector251
vector251:
  pushl $0
8010662b:	6a 00                	push   $0x0
  pushl $251
8010662d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106632:	e9 e3 f0 ff ff       	jmp    8010571a <alltraps>

80106637 <vector252>:
.globl vector252
vector252:
  pushl $0
80106637:	6a 00                	push   $0x0
  pushl $252
80106639:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010663e:	e9 d7 f0 ff ff       	jmp    8010571a <alltraps>

80106643 <vector253>:
.globl vector253
vector253:
  pushl $0
80106643:	6a 00                	push   $0x0
  pushl $253
80106645:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010664a:	e9 cb f0 ff ff       	jmp    8010571a <alltraps>

8010664f <vector254>:
.globl vector254
vector254:
  pushl $0
8010664f:	6a 00                	push   $0x0
  pushl $254
80106651:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106656:	e9 bf f0 ff ff       	jmp    8010571a <alltraps>

8010665b <vector255>:
.globl vector255
vector255:
  pushl $0
8010665b:	6a 00                	push   $0x0
  pushl $255
8010665d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106662:	e9 b3 f0 ff ff       	jmp    8010571a <alltraps>
80106667:	66 90                	xchg   %ax,%ax
80106669:	66 90                	xchg   %ax,%ax
8010666b:	66 90                	xchg   %ax,%ax
8010666d:	66 90                	xchg   %ax,%ax
8010666f:	90                   	nop

80106670 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106670:	55                   	push   %ebp
80106671:	89 e5                	mov    %esp,%ebp
80106673:	57                   	push   %edi
80106674:	56                   	push   %esi
80106675:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106676:	89 d3                	mov    %edx,%ebx
{
80106678:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
8010667a:	c1 eb 16             	shr    $0x16,%ebx
8010667d:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
80106680:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106683:	8b 06                	mov    (%esi),%eax
80106685:	a8 01                	test   $0x1,%al
80106687:	74 27                	je     801066b0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106689:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010668e:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106694:	c1 ef 0a             	shr    $0xa,%edi
}
80106697:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
8010669a:	89 fa                	mov    %edi,%edx
8010669c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801066a2:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
801066a5:	5b                   	pop    %ebx
801066a6:	5e                   	pop    %esi
801066a7:	5f                   	pop    %edi
801066a8:	5d                   	pop    %ebp
801066a9:	c3                   	ret    
801066aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801066b0:	85 c9                	test   %ecx,%ecx
801066b2:	74 2c                	je     801066e0 <walkpgdir+0x70>
801066b4:	e8 b7 be ff ff       	call   80102570 <kalloc>
801066b9:	85 c0                	test   %eax,%eax
801066bb:	89 c3                	mov    %eax,%ebx
801066bd:	74 21                	je     801066e0 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
801066bf:	83 ec 04             	sub    $0x4,%esp
801066c2:	68 00 10 00 00       	push   $0x1000
801066c7:	6a 00                	push   $0x0
801066c9:	50                   	push   %eax
801066ca:	e8 31 de ff ff       	call   80104500 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801066cf:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801066d5:	83 c4 10             	add    $0x10,%esp
801066d8:	83 c8 07             	or     $0x7,%eax
801066db:	89 06                	mov    %eax,(%esi)
801066dd:	eb b5                	jmp    80106694 <walkpgdir+0x24>
801066df:	90                   	nop
}
801066e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
801066e3:	31 c0                	xor    %eax,%eax
}
801066e5:	5b                   	pop    %ebx
801066e6:	5e                   	pop    %esi
801066e7:	5f                   	pop    %edi
801066e8:	5d                   	pop    %ebp
801066e9:	c3                   	ret    
801066ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801066f0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801066f0:	55                   	push   %ebp
801066f1:	89 e5                	mov    %esp,%ebp
801066f3:	57                   	push   %edi
801066f4:	56                   	push   %esi
801066f5:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
801066f6:	89 d3                	mov    %edx,%ebx
801066f8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
801066fe:	83 ec 1c             	sub    $0x1c,%esp
80106701:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106704:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106708:	8b 7d 08             	mov    0x8(%ebp),%edi
8010670b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106710:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106713:	8b 45 0c             	mov    0xc(%ebp),%eax
80106716:	29 df                	sub    %ebx,%edi
80106718:	83 c8 01             	or     $0x1,%eax
8010671b:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010671e:	eb 15                	jmp    80106735 <mappages+0x45>
    if(*pte & PTE_P)
80106720:	f6 00 01             	testb  $0x1,(%eax)
80106723:	75 45                	jne    8010676a <mappages+0x7a>
    *pte = pa | perm | PTE_P;
80106725:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80106728:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
8010672b:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010672d:	74 31                	je     80106760 <mappages+0x70>
      break;
    a += PGSIZE;
8010672f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106735:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106738:	b9 01 00 00 00       	mov    $0x1,%ecx
8010673d:	89 da                	mov    %ebx,%edx
8010673f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106742:	e8 29 ff ff ff       	call   80106670 <walkpgdir>
80106747:	85 c0                	test   %eax,%eax
80106749:	75 d5                	jne    80106720 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
8010674b:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010674e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106753:	5b                   	pop    %ebx
80106754:	5e                   	pop    %esi
80106755:	5f                   	pop    %edi
80106756:	5d                   	pop    %ebp
80106757:	c3                   	ret    
80106758:	90                   	nop
80106759:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106760:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106763:	31 c0                	xor    %eax,%eax
}
80106765:	5b                   	pop    %ebx
80106766:	5e                   	pop    %esi
80106767:	5f                   	pop    %edi
80106768:	5d                   	pop    %ebp
80106769:	c3                   	ret    
      panic("remap");
8010676a:	83 ec 0c             	sub    $0xc,%esp
8010676d:	68 68 78 10 80       	push   $0x80107868
80106772:	e8 19 9c ff ff       	call   80100390 <panic>
80106777:	89 f6                	mov    %esi,%esi
80106779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106780 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106780:	55                   	push   %ebp
80106781:	89 e5                	mov    %esp,%ebp
80106783:	57                   	push   %edi
80106784:	56                   	push   %esi
80106785:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106786:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
8010678c:	89 c7                	mov    %eax,%edi
  a = PGROUNDUP(newsz);
8010678e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106794:	83 ec 1c             	sub    $0x1c,%esp
80106797:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
8010679a:	39 d3                	cmp    %edx,%ebx
8010679c:	73 66                	jae    80106804 <deallocuvm.part.0+0x84>
8010679e:	89 d6                	mov    %edx,%esi
801067a0:	eb 3d                	jmp    801067df <deallocuvm.part.0+0x5f>
801067a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
801067a8:	8b 10                	mov    (%eax),%edx
801067aa:	f6 c2 01             	test   $0x1,%dl
801067ad:	74 26                	je     801067d5 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
801067af:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
801067b5:	74 58                	je     8010680f <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
801067b7:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
801067ba:	81 c2 00 00 00 80    	add    $0x80000000,%edx
801067c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
801067c3:	52                   	push   %edx
801067c4:	e8 f7 bb ff ff       	call   801023c0 <kfree>
      *pte = 0;
801067c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801067cc:	83 c4 10             	add    $0x10,%esp
801067cf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
801067d5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801067db:	39 f3                	cmp    %esi,%ebx
801067dd:	73 25                	jae    80106804 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
801067df:	31 c9                	xor    %ecx,%ecx
801067e1:	89 da                	mov    %ebx,%edx
801067e3:	89 f8                	mov    %edi,%eax
801067e5:	e8 86 fe ff ff       	call   80106670 <walkpgdir>
    if(!pte)
801067ea:	85 c0                	test   %eax,%eax
801067ec:	75 ba                	jne    801067a8 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801067ee:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
801067f4:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
801067fa:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106800:	39 f3                	cmp    %esi,%ebx
80106802:	72 db                	jb     801067df <deallocuvm.part.0+0x5f>
    }
  }
  return newsz;
}
80106804:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106807:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010680a:	5b                   	pop    %ebx
8010680b:	5e                   	pop    %esi
8010680c:	5f                   	pop    %edi
8010680d:	5d                   	pop    %ebp
8010680e:	c3                   	ret    
        panic("kfree");
8010680f:	83 ec 0c             	sub    $0xc,%esp
80106812:	68 06 72 10 80       	push   $0x80107206
80106817:	e8 74 9b ff ff       	call   80100390 <panic>
8010681c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106820 <seginit>:
{
80106820:	55                   	push   %ebp
80106821:	89 e5                	mov    %esp,%ebp
80106823:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106826:	e8 45 d0 ff ff       	call   80103870 <cpuid>
8010682b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
80106831:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106836:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010683a:	c7 80 f8 27 11 80 ff 	movl   $0xffff,-0x7feed808(%eax)
80106841:	ff 00 00 
80106844:	c7 80 fc 27 11 80 00 	movl   $0xcf9a00,-0x7feed804(%eax)
8010684b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010684e:	c7 80 00 28 11 80 ff 	movl   $0xffff,-0x7feed800(%eax)
80106855:	ff 00 00 
80106858:	c7 80 04 28 11 80 00 	movl   $0xcf9200,-0x7feed7fc(%eax)
8010685f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106862:	c7 80 08 28 11 80 ff 	movl   $0xffff,-0x7feed7f8(%eax)
80106869:	ff 00 00 
8010686c:	c7 80 0c 28 11 80 00 	movl   $0xcffa00,-0x7feed7f4(%eax)
80106873:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106876:	c7 80 10 28 11 80 ff 	movl   $0xffff,-0x7feed7f0(%eax)
8010687d:	ff 00 00 
80106880:	c7 80 14 28 11 80 00 	movl   $0xcff200,-0x7feed7ec(%eax)
80106887:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010688a:	05 f0 27 11 80       	add    $0x801127f0,%eax
  pd[1] = (uint)p;
8010688f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106893:	c1 e8 10             	shr    $0x10,%eax
80106896:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010689a:	8d 45 f2             	lea    -0xe(%ebp),%eax
8010689d:	0f 01 10             	lgdtl  (%eax)
}
801068a0:	c9                   	leave  
801068a1:	c3                   	ret    
801068a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801068a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801068b0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801068b0:	a1 a4 54 11 80       	mov    0x801154a4,%eax
{
801068b5:	55                   	push   %ebp
801068b6:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801068b8:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801068bd:	0f 22 d8             	mov    %eax,%cr3
}
801068c0:	5d                   	pop    %ebp
801068c1:	c3                   	ret    
801068c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801068c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801068d0 <switchuvm>:
{
801068d0:	55                   	push   %ebp
801068d1:	89 e5                	mov    %esp,%ebp
801068d3:	57                   	push   %edi
801068d4:	56                   	push   %esi
801068d5:	53                   	push   %ebx
801068d6:	83 ec 1c             	sub    $0x1c,%esp
801068d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
801068dc:	85 db                	test   %ebx,%ebx
801068de:	0f 84 cb 00 00 00    	je     801069af <switchuvm+0xdf>
  if(p->kstack == 0)
801068e4:	8b 43 08             	mov    0x8(%ebx),%eax
801068e7:	85 c0                	test   %eax,%eax
801068e9:	0f 84 da 00 00 00    	je     801069c9 <switchuvm+0xf9>
  if(p->pgdir == 0)
801068ef:	8b 43 04             	mov    0x4(%ebx),%eax
801068f2:	85 c0                	test   %eax,%eax
801068f4:	0f 84 c2 00 00 00    	je     801069bc <switchuvm+0xec>
  pushcli();
801068fa:	e8 21 da ff ff       	call   80104320 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801068ff:	e8 ec ce ff ff       	call   801037f0 <mycpu>
80106904:	89 c6                	mov    %eax,%esi
80106906:	e8 e5 ce ff ff       	call   801037f0 <mycpu>
8010690b:	89 c7                	mov    %eax,%edi
8010690d:	e8 de ce ff ff       	call   801037f0 <mycpu>
80106912:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106915:	83 c7 08             	add    $0x8,%edi
80106918:	e8 d3 ce ff ff       	call   801037f0 <mycpu>
8010691d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106920:	83 c0 08             	add    $0x8,%eax
80106923:	ba 67 00 00 00       	mov    $0x67,%edx
80106928:	c1 e8 18             	shr    $0x18,%eax
8010692b:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80106932:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80106939:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010693f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106944:	83 c1 08             	add    $0x8,%ecx
80106947:	c1 e9 10             	shr    $0x10,%ecx
8010694a:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80106950:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106955:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010695c:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80106961:	e8 8a ce ff ff       	call   801037f0 <mycpu>
80106966:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010696d:	e8 7e ce ff ff       	call   801037f0 <mycpu>
80106972:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106976:	8b 73 08             	mov    0x8(%ebx),%esi
80106979:	e8 72 ce ff ff       	call   801037f0 <mycpu>
8010697e:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106984:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106987:	e8 64 ce ff ff       	call   801037f0 <mycpu>
8010698c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106990:	b8 28 00 00 00       	mov    $0x28,%eax
80106995:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106998:	8b 43 04             	mov    0x4(%ebx),%eax
8010699b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801069a0:	0f 22 d8             	mov    %eax,%cr3
}
801069a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801069a6:	5b                   	pop    %ebx
801069a7:	5e                   	pop    %esi
801069a8:	5f                   	pop    %edi
801069a9:	5d                   	pop    %ebp
  popcli();
801069aa:	e9 b1 d9 ff ff       	jmp    80104360 <popcli>
    panic("switchuvm: no process");
801069af:	83 ec 0c             	sub    $0xc,%esp
801069b2:	68 6e 78 10 80       	push   $0x8010786e
801069b7:	e8 d4 99 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
801069bc:	83 ec 0c             	sub    $0xc,%esp
801069bf:	68 99 78 10 80       	push   $0x80107899
801069c4:	e8 c7 99 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
801069c9:	83 ec 0c             	sub    $0xc,%esp
801069cc:	68 84 78 10 80       	push   $0x80107884
801069d1:	e8 ba 99 ff ff       	call   80100390 <panic>
801069d6:	8d 76 00             	lea    0x0(%esi),%esi
801069d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801069e0 <inituvm>:
{
801069e0:	55                   	push   %ebp
801069e1:	89 e5                	mov    %esp,%ebp
801069e3:	57                   	push   %edi
801069e4:	56                   	push   %esi
801069e5:	53                   	push   %ebx
801069e6:	83 ec 1c             	sub    $0x1c,%esp
801069e9:	8b 75 10             	mov    0x10(%ebp),%esi
801069ec:	8b 45 08             	mov    0x8(%ebp),%eax
801069ef:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
801069f2:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
801069f8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
801069fb:	77 49                	ja     80106a46 <inituvm+0x66>
  mem = kalloc();
801069fd:	e8 6e bb ff ff       	call   80102570 <kalloc>
  memset(mem, 0, PGSIZE);
80106a02:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
80106a05:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106a07:	68 00 10 00 00       	push   $0x1000
80106a0c:	6a 00                	push   $0x0
80106a0e:	50                   	push   %eax
80106a0f:	e8 ec da ff ff       	call   80104500 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106a14:	58                   	pop    %eax
80106a15:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106a1b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106a20:	5a                   	pop    %edx
80106a21:	6a 06                	push   $0x6
80106a23:	50                   	push   %eax
80106a24:	31 d2                	xor    %edx,%edx
80106a26:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106a29:	e8 c2 fc ff ff       	call   801066f0 <mappages>
  memmove(mem, init, sz);
80106a2e:	89 75 10             	mov    %esi,0x10(%ebp)
80106a31:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106a34:	83 c4 10             	add    $0x10,%esp
80106a37:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106a3a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a3d:	5b                   	pop    %ebx
80106a3e:	5e                   	pop    %esi
80106a3f:	5f                   	pop    %edi
80106a40:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106a41:	e9 6a db ff ff       	jmp    801045b0 <memmove>
    panic("inituvm: more than a page");
80106a46:	83 ec 0c             	sub    $0xc,%esp
80106a49:	68 ad 78 10 80       	push   $0x801078ad
80106a4e:	e8 3d 99 ff ff       	call   80100390 <panic>
80106a53:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106a59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106a60 <loaduvm>:
{
80106a60:	55                   	push   %ebp
80106a61:	89 e5                	mov    %esp,%ebp
80106a63:	57                   	push   %edi
80106a64:	56                   	push   %esi
80106a65:	53                   	push   %ebx
80106a66:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80106a69:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106a70:	0f 85 91 00 00 00    	jne    80106b07 <loaduvm+0xa7>
  for(i = 0; i < sz; i += PGSIZE){
80106a76:	8b 75 18             	mov    0x18(%ebp),%esi
80106a79:	31 db                	xor    %ebx,%ebx
80106a7b:	85 f6                	test   %esi,%esi
80106a7d:	75 1a                	jne    80106a99 <loaduvm+0x39>
80106a7f:	eb 6f                	jmp    80106af0 <loaduvm+0x90>
80106a81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a88:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106a8e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106a94:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106a97:	76 57                	jbe    80106af0 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106a99:	8b 55 0c             	mov    0xc(%ebp),%edx
80106a9c:	8b 45 08             	mov    0x8(%ebp),%eax
80106a9f:	31 c9                	xor    %ecx,%ecx
80106aa1:	01 da                	add    %ebx,%edx
80106aa3:	e8 c8 fb ff ff       	call   80106670 <walkpgdir>
80106aa8:	85 c0                	test   %eax,%eax
80106aaa:	74 4e                	je     80106afa <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
80106aac:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106aae:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
80106ab1:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80106ab6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106abb:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106ac1:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106ac4:	01 d9                	add    %ebx,%ecx
80106ac6:	05 00 00 00 80       	add    $0x80000000,%eax
80106acb:	57                   	push   %edi
80106acc:	51                   	push   %ecx
80106acd:	50                   	push   %eax
80106ace:	ff 75 10             	pushl  0x10(%ebp)
80106ad1:	e8 9a ae ff ff       	call   80101970 <readi>
80106ad6:	83 c4 10             	add    $0x10,%esp
80106ad9:	39 f8                	cmp    %edi,%eax
80106adb:	74 ab                	je     80106a88 <loaduvm+0x28>
}
80106add:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106ae0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106ae5:	5b                   	pop    %ebx
80106ae6:	5e                   	pop    %esi
80106ae7:	5f                   	pop    %edi
80106ae8:	5d                   	pop    %ebp
80106ae9:	c3                   	ret    
80106aea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106af0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106af3:	31 c0                	xor    %eax,%eax
}
80106af5:	5b                   	pop    %ebx
80106af6:	5e                   	pop    %esi
80106af7:	5f                   	pop    %edi
80106af8:	5d                   	pop    %ebp
80106af9:	c3                   	ret    
      panic("loaduvm: address should exist");
80106afa:	83 ec 0c             	sub    $0xc,%esp
80106afd:	68 c7 78 10 80       	push   $0x801078c7
80106b02:	e8 89 98 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80106b07:	83 ec 0c             	sub    $0xc,%esp
80106b0a:	68 68 79 10 80       	push   $0x80107968
80106b0f:	e8 7c 98 ff ff       	call   80100390 <panic>
80106b14:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106b1a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106b20 <allocuvm>:
{
80106b20:	55                   	push   %ebp
80106b21:	89 e5                	mov    %esp,%ebp
80106b23:	57                   	push   %edi
80106b24:	56                   	push   %esi
80106b25:	53                   	push   %ebx
80106b26:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80106b29:	8b 7d 10             	mov    0x10(%ebp),%edi
80106b2c:	85 ff                	test   %edi,%edi
80106b2e:	0f 88 8e 00 00 00    	js     80106bc2 <allocuvm+0xa2>
  if(newsz < oldsz)
80106b34:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106b37:	0f 82 93 00 00 00    	jb     80106bd0 <allocuvm+0xb0>
  a = PGROUNDUP(oldsz);
80106b3d:	8b 45 0c             	mov    0xc(%ebp),%eax
80106b40:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106b46:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80106b4c:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80106b4f:	0f 86 7e 00 00 00    	jbe    80106bd3 <allocuvm+0xb3>
80106b55:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80106b58:	8b 7d 08             	mov    0x8(%ebp),%edi
80106b5b:	eb 42                	jmp    80106b9f <allocuvm+0x7f>
80106b5d:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
80106b60:	83 ec 04             	sub    $0x4,%esp
80106b63:	68 00 10 00 00       	push   $0x1000
80106b68:	6a 00                	push   $0x0
80106b6a:	50                   	push   %eax
80106b6b:	e8 90 d9 ff ff       	call   80104500 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106b70:	58                   	pop    %eax
80106b71:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106b77:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106b7c:	5a                   	pop    %edx
80106b7d:	6a 06                	push   $0x6
80106b7f:	50                   	push   %eax
80106b80:	89 da                	mov    %ebx,%edx
80106b82:	89 f8                	mov    %edi,%eax
80106b84:	e8 67 fb ff ff       	call   801066f0 <mappages>
80106b89:	83 c4 10             	add    $0x10,%esp
80106b8c:	85 c0                	test   %eax,%eax
80106b8e:	78 50                	js     80106be0 <allocuvm+0xc0>
  for(; a < newsz; a += PGSIZE){
80106b90:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106b96:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80106b99:	0f 86 81 00 00 00    	jbe    80106c20 <allocuvm+0x100>
    mem = kalloc();
80106b9f:	e8 cc b9 ff ff       	call   80102570 <kalloc>
    if(mem == 0){
80106ba4:	85 c0                	test   %eax,%eax
    mem = kalloc();
80106ba6:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80106ba8:	75 b6                	jne    80106b60 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80106baa:	83 ec 0c             	sub    $0xc,%esp
80106bad:	68 e5 78 10 80       	push   $0x801078e5
80106bb2:	e8 a9 9a ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
80106bb7:	83 c4 10             	add    $0x10,%esp
80106bba:	8b 45 0c             	mov    0xc(%ebp),%eax
80106bbd:	39 45 10             	cmp    %eax,0x10(%ebp)
80106bc0:	77 6e                	ja     80106c30 <allocuvm+0x110>
}
80106bc2:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80106bc5:	31 ff                	xor    %edi,%edi
}
80106bc7:	89 f8                	mov    %edi,%eax
80106bc9:	5b                   	pop    %ebx
80106bca:	5e                   	pop    %esi
80106bcb:	5f                   	pop    %edi
80106bcc:	5d                   	pop    %ebp
80106bcd:	c3                   	ret    
80106bce:	66 90                	xchg   %ax,%ax
    return oldsz;
80106bd0:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
80106bd3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106bd6:	89 f8                	mov    %edi,%eax
80106bd8:	5b                   	pop    %ebx
80106bd9:	5e                   	pop    %esi
80106bda:	5f                   	pop    %edi
80106bdb:	5d                   	pop    %ebp
80106bdc:	c3                   	ret    
80106bdd:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80106be0:	83 ec 0c             	sub    $0xc,%esp
80106be3:	68 fd 78 10 80       	push   $0x801078fd
80106be8:	e8 73 9a ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
80106bed:	83 c4 10             	add    $0x10,%esp
80106bf0:	8b 45 0c             	mov    0xc(%ebp),%eax
80106bf3:	39 45 10             	cmp    %eax,0x10(%ebp)
80106bf6:	76 0d                	jbe    80106c05 <allocuvm+0xe5>
80106bf8:	89 c1                	mov    %eax,%ecx
80106bfa:	8b 55 10             	mov    0x10(%ebp),%edx
80106bfd:	8b 45 08             	mov    0x8(%ebp),%eax
80106c00:	e8 7b fb ff ff       	call   80106780 <deallocuvm.part.0>
      kfree(mem);
80106c05:	83 ec 0c             	sub    $0xc,%esp
      return 0;
80106c08:	31 ff                	xor    %edi,%edi
      kfree(mem);
80106c0a:	56                   	push   %esi
80106c0b:	e8 b0 b7 ff ff       	call   801023c0 <kfree>
      return 0;
80106c10:	83 c4 10             	add    $0x10,%esp
}
80106c13:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c16:	89 f8                	mov    %edi,%eax
80106c18:	5b                   	pop    %ebx
80106c19:	5e                   	pop    %esi
80106c1a:	5f                   	pop    %edi
80106c1b:	5d                   	pop    %ebp
80106c1c:	c3                   	ret    
80106c1d:	8d 76 00             	lea    0x0(%esi),%esi
80106c20:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80106c23:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c26:	5b                   	pop    %ebx
80106c27:	89 f8                	mov    %edi,%eax
80106c29:	5e                   	pop    %esi
80106c2a:	5f                   	pop    %edi
80106c2b:	5d                   	pop    %ebp
80106c2c:	c3                   	ret    
80106c2d:	8d 76 00             	lea    0x0(%esi),%esi
80106c30:	89 c1                	mov    %eax,%ecx
80106c32:	8b 55 10             	mov    0x10(%ebp),%edx
80106c35:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
80106c38:	31 ff                	xor    %edi,%edi
80106c3a:	e8 41 fb ff ff       	call   80106780 <deallocuvm.part.0>
80106c3f:	eb 92                	jmp    80106bd3 <allocuvm+0xb3>
80106c41:	eb 0d                	jmp    80106c50 <deallocuvm>
80106c43:	90                   	nop
80106c44:	90                   	nop
80106c45:	90                   	nop
80106c46:	90                   	nop
80106c47:	90                   	nop
80106c48:	90                   	nop
80106c49:	90                   	nop
80106c4a:	90                   	nop
80106c4b:	90                   	nop
80106c4c:	90                   	nop
80106c4d:	90                   	nop
80106c4e:	90                   	nop
80106c4f:	90                   	nop

80106c50 <deallocuvm>:
{
80106c50:	55                   	push   %ebp
80106c51:	89 e5                	mov    %esp,%ebp
80106c53:	8b 55 0c             	mov    0xc(%ebp),%edx
80106c56:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106c59:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80106c5c:	39 d1                	cmp    %edx,%ecx
80106c5e:	73 10                	jae    80106c70 <deallocuvm+0x20>
}
80106c60:	5d                   	pop    %ebp
80106c61:	e9 1a fb ff ff       	jmp    80106780 <deallocuvm.part.0>
80106c66:	8d 76 00             	lea    0x0(%esi),%esi
80106c69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106c70:	89 d0                	mov    %edx,%eax
80106c72:	5d                   	pop    %ebp
80106c73:	c3                   	ret    
80106c74:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106c7a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106c80 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106c80:	55                   	push   %ebp
80106c81:	89 e5                	mov    %esp,%ebp
80106c83:	57                   	push   %edi
80106c84:	56                   	push   %esi
80106c85:	53                   	push   %ebx
80106c86:	83 ec 0c             	sub    $0xc,%esp
80106c89:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106c8c:	85 f6                	test   %esi,%esi
80106c8e:	74 59                	je     80106ce9 <freevm+0x69>
80106c90:	31 c9                	xor    %ecx,%ecx
80106c92:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106c97:	89 f0                	mov    %esi,%eax
80106c99:	e8 e2 fa ff ff       	call   80106780 <deallocuvm.part.0>
80106c9e:	89 f3                	mov    %esi,%ebx
80106ca0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80106ca6:	eb 0f                	jmp    80106cb7 <freevm+0x37>
80106ca8:	90                   	nop
80106ca9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106cb0:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106cb3:	39 fb                	cmp    %edi,%ebx
80106cb5:	74 23                	je     80106cda <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106cb7:	8b 03                	mov    (%ebx),%eax
80106cb9:	a8 01                	test   $0x1,%al
80106cbb:	74 f3                	je     80106cb0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106cbd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80106cc2:	83 ec 0c             	sub    $0xc,%esp
80106cc5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106cc8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80106ccd:	50                   	push   %eax
80106cce:	e8 ed b6 ff ff       	call   801023c0 <kfree>
80106cd3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80106cd6:	39 fb                	cmp    %edi,%ebx
80106cd8:	75 dd                	jne    80106cb7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80106cda:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106cdd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ce0:	5b                   	pop    %ebx
80106ce1:	5e                   	pop    %esi
80106ce2:	5f                   	pop    %edi
80106ce3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80106ce4:	e9 d7 b6 ff ff       	jmp    801023c0 <kfree>
    panic("freevm: no pgdir");
80106ce9:	83 ec 0c             	sub    $0xc,%esp
80106cec:	68 19 79 10 80       	push   $0x80107919
80106cf1:	e8 9a 96 ff ff       	call   80100390 <panic>
80106cf6:	8d 76 00             	lea    0x0(%esi),%esi
80106cf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106d00 <setupkvm>:
{
80106d00:	55                   	push   %ebp
80106d01:	89 e5                	mov    %esp,%ebp
80106d03:	56                   	push   %esi
80106d04:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80106d05:	e8 66 b8 ff ff       	call   80102570 <kalloc>
80106d0a:	85 c0                	test   %eax,%eax
80106d0c:	89 c6                	mov    %eax,%esi
80106d0e:	74 42                	je     80106d52 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80106d10:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106d13:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
80106d18:	68 00 10 00 00       	push   $0x1000
80106d1d:	6a 00                	push   $0x0
80106d1f:	50                   	push   %eax
80106d20:	e8 db d7 ff ff       	call   80104500 <memset>
80106d25:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80106d28:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106d2b:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106d2e:	83 ec 08             	sub    $0x8,%esp
80106d31:	8b 13                	mov    (%ebx),%edx
80106d33:	ff 73 0c             	pushl  0xc(%ebx)
80106d36:	50                   	push   %eax
80106d37:	29 c1                	sub    %eax,%ecx
80106d39:	89 f0                	mov    %esi,%eax
80106d3b:	e8 b0 f9 ff ff       	call   801066f0 <mappages>
80106d40:	83 c4 10             	add    $0x10,%esp
80106d43:	85 c0                	test   %eax,%eax
80106d45:	78 19                	js     80106d60 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106d47:	83 c3 10             	add    $0x10,%ebx
80106d4a:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106d50:	75 d6                	jne    80106d28 <setupkvm+0x28>
}
80106d52:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106d55:	89 f0                	mov    %esi,%eax
80106d57:	5b                   	pop    %ebx
80106d58:	5e                   	pop    %esi
80106d59:	5d                   	pop    %ebp
80106d5a:	c3                   	ret    
80106d5b:	90                   	nop
80106d5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80106d60:	83 ec 0c             	sub    $0xc,%esp
80106d63:	56                   	push   %esi
      return 0;
80106d64:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80106d66:	e8 15 ff ff ff       	call   80106c80 <freevm>
      return 0;
80106d6b:	83 c4 10             	add    $0x10,%esp
}
80106d6e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106d71:	89 f0                	mov    %esi,%eax
80106d73:	5b                   	pop    %ebx
80106d74:	5e                   	pop    %esi
80106d75:	5d                   	pop    %ebp
80106d76:	c3                   	ret    
80106d77:	89 f6                	mov    %esi,%esi
80106d79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106d80 <kvmalloc>:
{
80106d80:	55                   	push   %ebp
80106d81:	89 e5                	mov    %esp,%ebp
80106d83:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106d86:	e8 75 ff ff ff       	call   80106d00 <setupkvm>
80106d8b:	a3 a4 54 11 80       	mov    %eax,0x801154a4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106d90:	05 00 00 00 80       	add    $0x80000000,%eax
80106d95:	0f 22 d8             	mov    %eax,%cr3
}
80106d98:	c9                   	leave  
80106d99:	c3                   	ret    
80106d9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106da0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106da0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106da1:	31 c9                	xor    %ecx,%ecx
{
80106da3:	89 e5                	mov    %esp,%ebp
80106da5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80106da8:	8b 55 0c             	mov    0xc(%ebp),%edx
80106dab:	8b 45 08             	mov    0x8(%ebp),%eax
80106dae:	e8 bd f8 ff ff       	call   80106670 <walkpgdir>
  if(pte == 0)
80106db3:	85 c0                	test   %eax,%eax
80106db5:	74 05                	je     80106dbc <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106db7:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106dba:	c9                   	leave  
80106dbb:	c3                   	ret    
    panic("clearpteu");
80106dbc:	83 ec 0c             	sub    $0xc,%esp
80106dbf:	68 2a 79 10 80       	push   $0x8010792a
80106dc4:	e8 c7 95 ff ff       	call   80100390 <panic>
80106dc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106dd0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80106dd0:	55                   	push   %ebp
80106dd1:	89 e5                	mov    %esp,%ebp
80106dd3:	57                   	push   %edi
80106dd4:	56                   	push   %esi
80106dd5:	53                   	push   %ebx
80106dd6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106dd9:	e8 22 ff ff ff       	call   80106d00 <setupkvm>
80106dde:	85 c0                	test   %eax,%eax
80106de0:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106de3:	0f 84 9f 00 00 00    	je     80106e88 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106de9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106dec:	85 c9                	test   %ecx,%ecx
80106dee:	0f 84 94 00 00 00    	je     80106e88 <copyuvm+0xb8>
80106df4:	31 ff                	xor    %edi,%edi
80106df6:	eb 4a                	jmp    80106e42 <copyuvm+0x72>
80106df8:	90                   	nop
80106df9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106e00:	83 ec 04             	sub    $0x4,%esp
80106e03:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80106e09:	68 00 10 00 00       	push   $0x1000
80106e0e:	53                   	push   %ebx
80106e0f:	50                   	push   %eax
80106e10:	e8 9b d7 ff ff       	call   801045b0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80106e15:	58                   	pop    %eax
80106e16:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106e1c:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106e21:	5a                   	pop    %edx
80106e22:	ff 75 e4             	pushl  -0x1c(%ebp)
80106e25:	50                   	push   %eax
80106e26:	89 fa                	mov    %edi,%edx
80106e28:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106e2b:	e8 c0 f8 ff ff       	call   801066f0 <mappages>
80106e30:	83 c4 10             	add    $0x10,%esp
80106e33:	85 c0                	test   %eax,%eax
80106e35:	78 61                	js     80106e98 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80106e37:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106e3d:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80106e40:	76 46                	jbe    80106e88 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106e42:	8b 45 08             	mov    0x8(%ebp),%eax
80106e45:	31 c9                	xor    %ecx,%ecx
80106e47:	89 fa                	mov    %edi,%edx
80106e49:	e8 22 f8 ff ff       	call   80106670 <walkpgdir>
80106e4e:	85 c0                	test   %eax,%eax
80106e50:	74 61                	je     80106eb3 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
80106e52:	8b 00                	mov    (%eax),%eax
80106e54:	a8 01                	test   $0x1,%al
80106e56:	74 4e                	je     80106ea6 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80106e58:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
80106e5a:	25 ff 0f 00 00       	and    $0xfff,%eax
    pa = PTE_ADDR(*pte);
80106e5f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    flags = PTE_FLAGS(*pte);
80106e65:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80106e68:	e8 03 b7 ff ff       	call   80102570 <kalloc>
80106e6d:	85 c0                	test   %eax,%eax
80106e6f:	89 c6                	mov    %eax,%esi
80106e71:	75 8d                	jne    80106e00 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80106e73:	83 ec 0c             	sub    $0xc,%esp
80106e76:	ff 75 e0             	pushl  -0x20(%ebp)
80106e79:	e8 02 fe ff ff       	call   80106c80 <freevm>
  return 0;
80106e7e:	83 c4 10             	add    $0x10,%esp
80106e81:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80106e88:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106e8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e8e:	5b                   	pop    %ebx
80106e8f:	5e                   	pop    %esi
80106e90:	5f                   	pop    %edi
80106e91:	5d                   	pop    %ebp
80106e92:	c3                   	ret    
80106e93:	90                   	nop
80106e94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80106e98:	83 ec 0c             	sub    $0xc,%esp
80106e9b:	56                   	push   %esi
80106e9c:	e8 1f b5 ff ff       	call   801023c0 <kfree>
      goto bad;
80106ea1:	83 c4 10             	add    $0x10,%esp
80106ea4:	eb cd                	jmp    80106e73 <copyuvm+0xa3>
      panic("copyuvm: page not present");
80106ea6:	83 ec 0c             	sub    $0xc,%esp
80106ea9:	68 4e 79 10 80       	push   $0x8010794e
80106eae:	e8 dd 94 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80106eb3:	83 ec 0c             	sub    $0xc,%esp
80106eb6:	68 34 79 10 80       	push   $0x80107934
80106ebb:	e8 d0 94 ff ff       	call   80100390 <panic>

80106ec0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106ec0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106ec1:	31 c9                	xor    %ecx,%ecx
{
80106ec3:	89 e5                	mov    %esp,%ebp
80106ec5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80106ec8:	8b 55 0c             	mov    0xc(%ebp),%edx
80106ecb:	8b 45 08             	mov    0x8(%ebp),%eax
80106ece:	e8 9d f7 ff ff       	call   80106670 <walkpgdir>
  if((*pte & PTE_P) == 0)
80106ed3:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80106ed5:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80106ed6:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80106ed8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80106edd:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80106ee0:	05 00 00 00 80       	add    $0x80000000,%eax
80106ee5:	83 fa 05             	cmp    $0x5,%edx
80106ee8:	ba 00 00 00 00       	mov    $0x0,%edx
80106eed:	0f 45 c2             	cmovne %edx,%eax
}
80106ef0:	c3                   	ret    
80106ef1:	eb 0d                	jmp    80106f00 <copyout>
80106ef3:	90                   	nop
80106ef4:	90                   	nop
80106ef5:	90                   	nop
80106ef6:	90                   	nop
80106ef7:	90                   	nop
80106ef8:	90                   	nop
80106ef9:	90                   	nop
80106efa:	90                   	nop
80106efb:	90                   	nop
80106efc:	90                   	nop
80106efd:	90                   	nop
80106efe:	90                   	nop
80106eff:	90                   	nop

80106f00 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80106f00:	55                   	push   %ebp
80106f01:	89 e5                	mov    %esp,%ebp
80106f03:	57                   	push   %edi
80106f04:	56                   	push   %esi
80106f05:	53                   	push   %ebx
80106f06:	83 ec 1c             	sub    $0x1c,%esp
80106f09:	8b 5d 14             	mov    0x14(%ebp),%ebx
80106f0c:	8b 55 0c             	mov    0xc(%ebp),%edx
80106f0f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106f12:	85 db                	test   %ebx,%ebx
80106f14:	75 40                	jne    80106f56 <copyout+0x56>
80106f16:	eb 70                	jmp    80106f88 <copyout+0x88>
80106f18:	90                   	nop
80106f19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80106f20:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106f23:	89 f1                	mov    %esi,%ecx
80106f25:	29 d1                	sub    %edx,%ecx
80106f27:	81 c1 00 10 00 00    	add    $0x1000,%ecx
80106f2d:	39 d9                	cmp    %ebx,%ecx
80106f2f:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106f32:	29 f2                	sub    %esi,%edx
80106f34:	83 ec 04             	sub    $0x4,%esp
80106f37:	01 d0                	add    %edx,%eax
80106f39:	51                   	push   %ecx
80106f3a:	57                   	push   %edi
80106f3b:	50                   	push   %eax
80106f3c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80106f3f:	e8 6c d6 ff ff       	call   801045b0 <memmove>
    len -= n;
    buf += n;
80106f44:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
80106f47:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
80106f4a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
80106f50:	01 cf                	add    %ecx,%edi
  while(len > 0){
80106f52:	29 cb                	sub    %ecx,%ebx
80106f54:	74 32                	je     80106f88 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80106f56:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80106f58:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80106f5b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80106f5e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80106f64:	56                   	push   %esi
80106f65:	ff 75 08             	pushl  0x8(%ebp)
80106f68:	e8 53 ff ff ff       	call   80106ec0 <uva2ka>
    if(pa0 == 0)
80106f6d:	83 c4 10             	add    $0x10,%esp
80106f70:	85 c0                	test   %eax,%eax
80106f72:	75 ac                	jne    80106f20 <copyout+0x20>
  }
  return 0;
}
80106f74:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106f77:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106f7c:	5b                   	pop    %ebx
80106f7d:	5e                   	pop    %esi
80106f7e:	5f                   	pop    %edi
80106f7f:	5d                   	pop    %ebp
80106f80:	c3                   	ret    
80106f81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f88:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106f8b:	31 c0                	xor    %eax,%eax
}
80106f8d:	5b                   	pop    %ebx
80106f8e:	5e                   	pop    %esi
80106f8f:	5f                   	pop    %edi
80106f90:	5d                   	pop    %ebp
80106f91:	c3                   	ret    
