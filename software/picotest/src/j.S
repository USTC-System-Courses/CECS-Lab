# See LICENSE for license details.

#*****************************************************************************
# j.S
#-----------------------------------------------------------------------------
#
# Test j instruction.
#

#include "riscv_test.h"
#include "test_macros.h"
.global j
j: 

  #-------------------------------------------------------------
  # Test basic
  #-------------------------------------------------------------

  li  TESTNUM, 2;
  j test_2;
  j fail;
test_2:

  #-------------------------------------------------------------
  # Test delay slot instructions not executed nor bypassed
  #-------------------------------------------------------------

  TEST_CASE( 3, x31, 3, \
    li  x31, 1; \
    j 1f; \
    addi x31, x31, 1; \
    addi x31, x31, 1; \
    addi x31, x31, 1; \
    addi x31, x31, 1; \
1:  addi x31, x31, 1; \
    addi x31, x31, 1; \
  )

  TEST_PASSFAIL

RVTEST_CODE_END

  .data
RVTEST_DATA_BEGIN

  TEST_DATA

RVTEST_DATA_END
