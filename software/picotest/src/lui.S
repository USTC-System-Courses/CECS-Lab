# See LICENSE for license details.

#*****************************************************************************
# lui.S
#-----------------------------------------------------------------------------
#
# Test lui instruction.
#

#include "riscv_test.h"
#include "test_macros.h"

.global lui
lui: 

  #-------------------------------------------------------------
  # Basic tests
  #-------------------------------------------------------------

  TEST_CASE( 2, x31, 0x00000000, lui x31, 0x00000 );
  TEST_CASE( 3, x31, 0xfffff800, lui x31, 0xfffff;sra x31,x31,1);
  TEST_CASE( 4, x31, 0x000007ff, lui x31, 0x7ffff;sra x31,x31,20);
  TEST_CASE( 5, x31, 0xfffff800, lui x31, 0x80000;sra x31,x31,20);

  TEST_CASE( 6, x0, 0, lui x0, 0x80000 );

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
