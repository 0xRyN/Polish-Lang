Test de abs.p

  $ echo 5 | ../../polish.exe -eval abs.p
  n ? 5

  $ echo 0 | ../../polish.exe -eval abs.p
  n ? 0

  $ echo -5 | ../../polish.exe -eval abs.p
  n ? 5

  $ echo -123123 | ../../polish.exe -eval abs.p
  n ? 123123

Test de euclid.p

  $ { echo 20; echo 10; } | ../../polish.exe -eval euclid.p
  a ? b ? 2
  0

  $ { echo 123456; echo 100; } | ../../polish.exe -eval euclid.p
  a ? b ? 1234
  56

  $ { echo 123456; echo -100; } | ../../polish.exe -eval euclid.p
  a ? b ? 0
  0

  $ { echo 123456; echo 0; } | ../../polish.exe -eval euclid.p
  a ? b ? 0
  0

  $ { echo 0; echo 100; } | ../../polish.exe -eval euclid.p
  a ? b ? 0
  0

  $ { echo 123; echo 10; } | ../../polish.exe -eval euclid.p
  a ? b ? 12
  3

Test de euclid_binary.p

  $ { echo 20; echo 10; } | ../../polish.exe -eval euclid_binary.p
  a ? b ? 2
  0

  $ { echo 123456; echo 100; } | ../../polish.exe -eval euclid_binary.p
  a ? b ? 1234
  56

  $ { echo 123456; echo -100; } | ../../polish.exe -eval euclid_binary.p
  a ? b ? 0
  0

  $ { echo 123456; echo 0; } | ../../polish.exe -eval euclid_binary.p
  a ? b ? 0
  0

  $ { echo 0; echo 100; } | ../../polish.exe -eval euclid_binary.p
  a ? b ? 0
  0

  $ { echo 123; echo 10; } | ../../polish.exe -eval euclid_binary.p
  a ? b ? 12
  3

Test de factors.p

  $ echo 1 | ../../polish.exe -eval factors.p
  n ? 1

  $ echo 12 | ../../polish.exe -eval factors.p
  n ? 2
  2
  3

  $ echo 123 | ../../polish.exe -eval factors.p
  n ? 3
  41

  $ echo 1234 | ../../polish.exe -eval factors.p
  n ? 2
  617

  $ echo 12345 | ../../polish.exe -eval factors.p
  n ? 3
  5
  823

  $ echo 123456 | ../../polish.exe -eval factors.p
  n ? 2
  2
  2
  2
  2
  2
  3
  643

  $ echo 1234567 | ../../polish.exe -eval factors.p
  n ? 127
  9721

  $ echo 12345678 | ../../polish.exe -eval factors.p
  n ? 2
  3
  3
  47
  14593

  $ echo 123456789 | ../../polish.exe -eval factors.p
  n ? 3
  3
  3607
  3803

Test de fact.p

  $ echo -1 | ../../polish.exe -eval fact.p
  n ? 1

  $ echo 0 | ../../polish.exe -eval fact.p
  n ? 1

  $ echo 1 | ../../polish.exe -eval fact.p
  n ? 1
  1
  1

  $ echo 2 | ../../polish.exe -eval fact.p
  n ? 1
  1
  2
  1
  2

  $ echo 3 | ../../polish.exe -eval fact.p
  n ? 1
  1
  2
  1
  3
  2
  6

  $ echo 10 | ../../polish.exe -eval fact.p
  n ? 1
  1
  2
  1
  3
  2
  4
  6
  5
  24
  6
  120
  7
  720
  8
  5040
  9
  40320
  10
  362880
  3628800

Test de fibo.p

  $ echo -1 | ../../polish.exe -eval fibo.p
  n ? 1
  $ echo 0 | ../../polish.exe -eval fibo.p
  n ? 0
  $ echo 1 | ../../polish.exe -eval fibo.p
  n ? 1
  $ echo 2 | ../../polish.exe -eval fibo.p
  n ? 1
  $ echo 3 | ../../polish.exe -eval fibo.p
  n ? 2
  $ echo 4 | ../../polish.exe -eval fibo.p
  n ? 3
  $ echo 5 | ../../polish.exe -eval fibo.p
  n ? 5
  $ echo 6 | ../../polish.exe -eval fibo.p
  n ? 8
  $ echo 10 | ../../polish.exe -eval fibo.p
  n ? 55
  $ echo 20 | ../../polish.exe -eval fibo.p
  n ? 6765
  $ echo 30 | ../../polish.exe -eval fibo.p
  n ? 832040

Test de is_prime.p

  $ echo -1 | ../../polish.exe -eval is_prime.p
  n ? 2
  $ echo 0 | ../../polish.exe -eval is_prime.p
  n ? 2
  $ echo 1 | ../../polish.exe -eval is_prime.p
  n ? 0
  $ echo 2 | ../../polish.exe -eval is_prime.p
  n ? 0
  $ echo 3 | ../../polish.exe -eval is_prime.p
  n ? 0
  $ echo 4 | ../../polish.exe -eval is_prime.p
  n ? 2
  1
  $ echo 5 | ../../polish.exe -eval is_prime.p
  n ? 0
  $ echo 6 | ../../polish.exe -eval is_prime.p
  n ? 2
  3
  1
  $ echo 10 | ../../polish.exe -eval is_prime.p
  n ? 2
  5
  1
  $ echo 20 | ../../polish.exe -eval is_prime.p
  n ? 2
  4
  5
  10
  1
  $ echo 30 | ../../polish.exe -eval is_prime.p
  n ? 2
  3
  5
  6
  10
  15
  1

Test de mult_russe.p

  $ { echo 20; echo 10; } | ../../polish.exe -eval mult_russe.p
  m ? n ? 200
  $ { echo 123; echo 123; } | ../../polish.exe -eval mult_russe.p
  m ? n ? 15129
  $ { echo 3; echo 4; } | ../../polish.exe -eval mult_russe.p
  m ? n ? 12
  $ { echo 30; echo 31; } | ../../polish.exe -eval mult_russe.p
  m ? n ? 930
  $ { echo -30; echo 31; } | ../../polish.exe -eval mult_russe.p
  m ? n ? -930
  $ { echo 0; echo 31; } | ../../polish.exe -eval mult_russe.p
  m ? n ? 0
  $ { echo 31; echo 0; } | ../../polish.exe -eval mult_russe.p
  m ? n ? 0
  $ { echo -1; echo -1; } | ../../polish.exe -eval mult_russe.p
  m ? n ? 0

Test de syracuse.p

  $ echo 2 | ../../polish.exe -eval syracuse.p
  n ? 1
  $ echo 3 | ../../polish.exe -eval syracuse.p
  n ? 10
  5
  16
  8
  4
  2
  1
  $ echo 4 | ../../polish.exe -eval syracuse.p
  n ? 2
  1
  $ echo 5 | ../../polish.exe -eval syracuse.p
  n ? 16
  8
  4
  2
  1
  $ echo 6 | ../../polish.exe -eval syracuse.p
  n ? 3
  10
  5
  16
  8
  4
  2
  1
  $ echo 10 | ../../polish.exe -eval syracuse.p
  n ? 5
  16
  8
  4
  2
  1
  $ echo 20 | ../../polish.exe -eval syracuse.p
  n ? 10
  5
  16
  8
  4
  2
  1
  $ echo 30 | ../../polish.exe -eval syracuse.p
  n ? 15
  46
  23
  70
  35
  106
  53
  160
  80
  40
  20
  10
  5
  16
  8
  4
  2
  1

Test de to_base.p

  $ { echo 25; echo 8; } | ../../polish.exe -eval to_base.p
  n ? b ? 1
  3
  $ { echo 255; echo 16; } | ../../polish.exe -eval to_base.p
  n ? b ? 15
  15
  $ { echo 65536; echo 2; } | ../../polish.exe -eval to_base.p
  n ? b ? 0
  0
  0
  0
  0
  0
  0
  0
  0
  0
  0
  0
  0
  0
  0
  0
  1
  $ { echo 65536; echo 4; } | ../../polish.exe -eval to_base.p
  n ? b ? 0
  0
  0
  0
  0
  0
  0
  0
  1
  $ { echo 65536; echo 8; } | ../../polish.exe -eval to_base.p
  n ? b ? 0
  0
  0
  0
  0
  2
  $ { echo 65536; echo 16; } | ../../polish.exe -eval to_base.p
  n ? b ? 0
  0
  0
  0
  1
  $ { echo 65536; echo 32; } | ../../polish.exe -eval to_base.p
  n ? b ? 0
  0
  0
  2
  $ { echo 65536; echo -15; } | ../../polish.exe -eval to_base.p
  n ? b ? 1
  -4
  6
  -4
  1
