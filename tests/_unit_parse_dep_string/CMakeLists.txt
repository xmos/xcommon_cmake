cmake_minimum_required(VERSION 3.21)
include($ENV{XMOS_CMAKE_PATH}/xcommon.cmake)
project(unit_parse_dep_string)

function(unit_test input_str exp_repo exp_ver)
    parse_dep_string(${input_str} ret_repo ret_ver ret_name)

    if(NOT ret_repo STREQUAL exp_repo)
        message(FATAL_ERROR "expected: ${exp_repo}, got: ${ret_repo}")
    endif()

    if(NOT ret_ver STREQUAL exp_ver)
        message(FATAL_ERROR "expected: ${exp_ver}, got: ${ret_ver}")
    endif()
endfunction()


# Each grouped set of tests includes all the ways of choosing the version
# These repos don't exist, nothing is cloned. This is just to test the string outputs
# from the parse_dep_string() function with a range of valid inputs.

# No server specified, so expect SSH access to github.com/xmos
unit_test("lib_abc"                                       "git@github.com:xmos/lib_abc"         "HEAD")
unit_test("lib_abc(1.23.456)"                             "git@github.com:xmos/lib_abc"         "v1.23.456")
unit_test("lib_abc(develop)"                              "git@github.com:xmos/lib_abc"         "develop")
unit_test("lib_abc(v7.8.9)"                               "git@github.com:xmos/lib_abc"         "v7.8.9")

# Fork specified, so expect SSH access to github.com/fork
unit_test("fork/lib_012"                                  "git@github.com:fork/lib_012"         "HEAD")
unit_test("fork/lib_012(0.0.1)"                           "git@github.com:fork/lib_012"         "v0.0.1")
unit_test("fork/lib_012(feature/something)"               "git@github.com:fork/lib_012"         "feature/something")
unit_test("fork/lib_012(v789.56.4)"                       "git@github.com:fork/lib_012"         "v789.56.4")

# Non-github.com server with access via SSH
unit_test("github0.xmos.com:fork/lib_.-a"                 "git@github0.xmos.com:fork/lib_.-a"   "HEAD")
unit_test("github0.xmos.com:FORK/lib_.-a(333.444.555)"    "git@github0.xmos.com:FORK/lib_.-a"   "v333.444.555")
unit_test("github0.xmos.com:fork/lib_.-a(my_branch)"      "git@github0.xmos.com:fork/lib_.-a"   "my_branch")
unit_test("github0.xmos.com:FORK/lib_.-a(v0.1.2)"         "git@github0.xmos.com:FORK/lib_.-a"   "v0.1.2")

# Non-github.com server but fails on SSH access, so fallback to HTTPS
unit_test("othergitserver:fork/lib_ABC"                   "https://othergitserver/fork/lib_ABC" "HEAD")
unit_test("otherGITserver:fork/lib_ABC(123.45.6)"         "https://otherGITserver/fork/lib_ABC" "v123.45.6")
unit_test("othergitserver:fork/lib_ABC(branch-test)"      "https://othergitserver/fork/lib_ABC" "branch-test")
unit_test("otherGITserver:fork/lib_ABC(v7.8.9)"           "https://otherGITserver/fork/lib_ABC" "v7.8.9")

# Full URL for HTTPS non-github.com server
unit_test("https://otherGITserver/fork/lib_abc"           "https://otherGITserver/fork/lib_abc" "HEAD")
unit_test("HTTPS://othergitserver/fork/lib_abc(1.23.456)" "HTTPS://othergitserver/fork/lib_abc" "v1.23.456")
unit_test("https://othergitserver/fork/lib_abc(TEST1)"    "https://othergitserver/fork/lib_abc" "TEST1")
unit_test("HTTPS://otherGITserver/fork/lib_abc(v7.8.9)"   "HTTPS://otherGITserver/fork/lib_abc" "v7.8.9")
