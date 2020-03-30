#!/bin/python
import re

def tobase32(p1,p2):
 base32='0123456789abcdfghjkmnpqrstuvwxyz'
 sqlhash=(p1<<32)|p2
 q=sqlhash/32
 r=sqlhash%32
 res=''
 res=base32[r]
 while q>0:
   r=q%32
   res=base32[r]+res
   q/=32
# res=res [::-1] 
 return res

f=open('events.txt','r')
events={}
for l in f:
 z=re.match("\s+(\d+)\s+(.*)$",l)
 if z:
  events[int(z.group(1))]=z.group(2)
f.close
f=open('perf.out','r')
for l in f:
 z=re.match(".*kskthbwt.*sid=(\S+)\sserial=(\S+)\s.*sql_id1=(\S+)\ssql_id2=(\S+)\sevent_id=(\S+)\stimestamp=(\S+).*",l)
 if z:
  print 'kskthbwt: sid:',int(z.group(1),16),'serial#:',int(z.group(2),16),'sql_id:',tobase32(int(z.group(3),16),int(z.group(4),16)),'event:',events[int(z.group(5),16)],'timestamp:',int(z.group(6),16)
 z=re.match(".*kskthewt.*sid=(\S+)\sserial=(\S+)\s.*sql_id1=(\S+)\ssql_id2=(\S+)\sevent_id=(\S+)\stimestamp=(\S+)\sp1=(\S+)\sp2=(\S+)\sp3=(\S+)\sseq=(\S+).*",l)
 if z:
  print 'kskthewt: sid:',int(z.group(1),16),'serial#:',int(z.group(2),16),'sql_id:',tobase32(int(z.group(3),16),int(z.group(4),16)),'event:',events[int(z.group(5),16)],'timestamp:',int(z.group(6),16),\
'p1:',int(z.group(7),16),'p2:',int(z.group(8),16),'p3:',int(z.group(9),16),'seq:',int(z.group(10),16)
