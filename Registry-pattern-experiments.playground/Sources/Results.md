Iterations:10000

Complete Memory Footprint Analysis
=====================================

Detailed Memory Debug Analysis
creating configs: 5.3 MB
enum fields: 1.1 MB
class fields: 1.2 MB
Enum field count: 10000
Class field count: 10000
-------------------------------------
Analyzing Switch Statement Memory Usage...
Switch-based fields created: 10000
Memory delta: 2.3 MB
Memory per field: 244 bytes
-------------------------------------
 Analyzing Registry Memory Usage...
Registry creation memory: 64.0 KB
Registry-based fields created: 10000
Field creation memory delta: 3.6 MB
Memory per field: 380 bytes
Total registry overhead: 64.0 KB
-------------------------------------
Analyzing Registry Factory Storage...
Factory dictionary entries: 15
Factory dictionary memory: 0 bytes
Memory per factory: 0 bytes
-------------------------------------
Complete perfomrance Analysis
=====================================

Round 1:
  Switch-Case: 0.0110s
  Registry: 0.0100s
  Speedup:     1.10x
Round 2:
  Switch-Case: 0.0103s
  Registry: 0.0098s
  Speedup:     1.05x
Round 3:
  Switch-Case: 0.0102s
  Registry: 0.0098s
  Speedup:     1.04x
Round 4:
  Switch-Case: 0.0102s
  Registry: 0.0098s
  Speedup:     1.04x
Round 5:
  Switch-Case: 0.0102s
  Registry: 0.0098s
  Speedup:     1.04x
Switch cases average time =       0.0104s
Registry average time =       0.0099s
Performance difference: -4.98689%



iterations 100000

=====================================

Detailed Memory Debug Analysis
creating configs: 40.7 MB
enum fields: 9.9 MB
class fields: 11.5 MB
Enum field count: 100000
Class field count: 100000
-------------------------------------
Analyzing Switch Statement Memory Usage...
Switch-based fields created: 100000
Memory delta: 34.7 MB
Memory per field: 363 bytes
-------------------------------------
 Analyzing Registry Memory Usage...
Registry creation memory: 32.0 KB
Registry-based fields created: 100000
Field creation memory delta: 27.3 MB
Memory per field: 286 bytes
Total registry overhead: 32.0 KB
-------------------------------------
Analyzing Registry Factory Storage...
Factory dictionary entries: 15
Factory dictionary memory: 0 bytes
Memory per factory: 0 bytes
-------------------------------------
Complete perfomrance Analysis
=====================================

Round 1:
  Switch-Case: 0.1033s
  Registry: 0.0985s
  Speedup:     1.05x
Round 2:
  Switch-Case: 0.1019s
  Registry: 0.0979s
  Speedup:     1.04x
Round 3:
  Switch-Case: 0.1015s
  Registry: 0.0976s
  Speedup:     1.04x
Round 4:
  Switch-Case: 0.1014s
  Registry: 0.0977s
  Speedup:     1.04x
Round 5:
  Switch-Case: 0.1022s
  Registry: 0.0975s
  Speedup:     1.05x
Switch cases average time =       0.1020s
Registry average time =       0.0979s
Performance difference: -4.10221%



1000000 ->

Complete Memory Footprint Analysis
=====================================

Detailed Memory Debug Analysis
creating configs: 308.1 MB
enum fields: 139.0 MB
class fields: 51.0 MB
Enum field count: 1000000
Class field count: 1000000
-------------------------------------
Analyzing Switch Statement Memory Usage...
Switch-based fields created: 1000000
Memory delta: 355.1 MB
Memory per field: 372 bytes
-------------------------------------
 Analyzing Registry Memory Usage...
Registry creation memory: 96.0 KB
Registry-based fields created: 1000000
Field creation memory delta: 276.1 MB
Memory per field: 289 bytes
Total registry overhead: 96.0 KB
-------------------------------------
Analyzing Registry Factory Storage...
Factory dictionary entries: 15
Factory dictionary memory: 32.0 KB
Memory per factory: 2.1 KB
-------------------------------------
Complete perfomrance Analysis
=====================================

Round 1:
  Switch-Case: 1.0357s
  Registry: 0.9940s
  Speedup:     1.04x
Round 2:
  Switch-Case: 1.0257s
  Registry: 1.0013s
  Speedup:     1.02x
Round 3:
  Switch-Case: 1.0414s
  Registry: 1.0024s
  Speedup:     1.04x
Round 4:
  Switch-Case: 1.0421s
  Registry: 0.9991s
  Speedup:     1.04x
Round 5:
  Switch-Case: 1.0343s
  Registry: 0.9988s
  Speedup:     1.04x
Switch cases average time =       1.0358s
Registry average time =       0.9991s
Performance difference: -3.54477%
