cmake_minimum_required(VERSION 3.21)
include($ENV{XMOS_CMAKE_PATH}/xcommon.cmake)
project(unit_parse_dep_string)


function(unit_test input_name input_repo input_branch input_tag input_commit_hash input_status exp_str)
    form_manifest_string("${input_name}" "${input_repo}" "${input_branch}" "${input_tag}" "${input_commit_hash}" "${input_status}" ret_str)

    set(DEBUG FALSE)

    if(DEBUG)
        if(NOT ret_str STREQUAL exp_str)
            message(STATUS "FAIL: expected: ${exp_str}\n              got: ${ret_str}\n")
        else()
            message(STATUS "PASS: expected: ${exp_str}\n              got: ${ret_str}\n")
        endif()
    else()
        if(NOT ret_str STREQUAL exp_str)
            message(FATAL_ERROR "FAIL: expected: ${exp_str}, got: ${ret_str}")
        endif()
    endif()
endfunction()


# Section 1: no input name or version string; this is the case for the top-level application or static library

# 1.1 Not a git repo
unit_test("" "" "" "" "" ""
          "-                         -                                                 -                        -")

# 1.2 Git repo without a remote, branch checked out
unit_test("" "" "develop" "" "776d465d604783f2a7072b3d406466d184d2fa21"
          "On branch develop\nnothing to commit, working tree clean\n"
          "-                         -                                                 develop                  776d465d604783f2a7072b3d406466d184d2fa21")

# 1.3 Git repo without a remote, tag checked out
unit_test("" "" "" "v1.0.0" "776d465d604783f2a7072b3d406466d184d2fa21"
          "HEAD detached at v1.0.0\nnothing to commit, working tree clean\n"
          "-                         -                                                 v1.0.0                   776d465d604783f2a7072b3d406466d184d2fa21")

# 1.4 Git repo without a remote, changeset checked out
unit_test("" "" "" "" "776d465d604783f2a7072b3d406466d184d2fa21"
          "HEAD detached at 776d465\nnothing to commit, working tree clean\n"
          "-                         -                                                 -                        776d465d604783f2a7072b3d406466d184d2fa21")

# 1.5 Git repo with remote, branch checked out
unit_test("" "git@github.com:xmos/sw_foo.git" "develop" "" "776d465d604783f2a7072b3d406466d184d2fa21"
          "On branch develop\nnothing to commit, working tree clean\n"
          "sw_foo                    git@github.com:xmos/sw_foo.git                    develop                  776d465d604783f2a7072b3d406466d184d2fa21")

# 1.6 Git repo with remote, branch checked out by detaching from the head of the remote branch (some older versions of git)
unit_test("" "git@github.com:xmos/sw_foo" "develop" "" "776d465d604783f2a7072b3d406466d184d2fa21"
          "HEAD detached at origin/develop\nnothing to commit, working tree clean\n"
          "sw_foo                    git@github.com:xmos/sw_foo                        develop                  776d465d604783f2a7072b3d406466d184d2fa21")

# 1.7 Git repo with remote, tag checked out
unit_test("" "https://github.com/xmos/sw_foo.git" "" "v1.0.0" "776d465d604783f2a7072b3d406466d184d2fa21"
          "HEAD detached at v1.0.0\nnothing to commit, working tree clean\n"
          "sw_foo                    https://github.com/xmos/sw_foo.git                v1.0.0                   776d465d604783f2a7072b3d406466d184d2fa21")

# 1.8 Git repo with remote, changeset checked out
unit_test("" "https://github.com/xmos/sw_foo" "" "" "776d465d604783f2a7072b3d406466d184d2fa21"
          "HEAD detached at 776d465\nnothing to commit, working tree clean\n"
          "sw_foo                    https://github.com/xmos/sw_foo                    -                        776d465d604783f2a7072b3d406466d184d2fa21")

# 1.9 Git repo with remote, branch checked out, but head of branch is tagged
unit_test("" "git@github.com:xmos/sw_foo.git" "develop" "v1.0.0" "776d465d604783f2a7072b3d406466d184d2fa21"
          "On branch develop\nnothing to commit, working tree clean\n"
          "sw_foo                    git@github.com:xmos/sw_foo.git                    v1.0.0                   776d465d604783f2a7072b3d406466d184d2fa21")

# 1.10 Git repo with remote, branch checked as in test 1.6, but head of branch is tagged
unit_test("" "git@github.com:xmos/sw_foo" "develop" "v1.0.0" "776d465d604783f2a7072b3d406466d184d2fa21"
          "HEAD detached at origin/develop\nnothing to commit, working tree clean\n"
          "sw_foo                    git@github.com:xmos/sw_foo                        v1.0.0                   776d465d604783f2a7072b3d406466d184d2fa21")

# 1.11 Git repo with remote, tagged changeset checked out
unit_test("" "https://github.com/xmos/sw_foo" "" "v1.0.0" "776d465d604783f2a7072b3d406466d184d2fa21"
          "HEAD detached at 776d465\nnothing to commit, working tree clean\n"
          "sw_foo                    https://github.com/xmos/sw_foo                    v1.0.0                   776d465d604783f2a7072b3d406466d184d2fa21")


# Section 2: input name and version provided by dependent modules list, where version matches currently checked out version

# 2.1 Not a git repo
unit_test("lib_abc" "" "" "" "" ""
          "lib_abc                   -                                                 -                        -")

# 2.2 Git repo without a remote, branch checked out
unit_test("lib_abc" "" "develop" "" "776d465d604783f2a7072b3d406466d184d2fa21"
          "On branch develop\nnothing to commit, working tree clean\n"
          "lib_abc                   -                                                 develop                  776d465d604783f2a7072b3d406466d184d2fa21")

# 2.3 Git repo without a remote, tag checked out
unit_test("lib_abc" "" "" "v1.0.0" "776d465d604783f2a7072b3d406466d184d2fa21"
          "HEAD detached at v1.0.0\nnothing to commit, working tree clean\n"
          "lib_abc                   -                                                 v1.0.0                   776d465d604783f2a7072b3d406466d184d2fa21")

# 2.4 Git repo without a remote, changeset checked out
unit_test("lib_abc"  "" "" "" "776d465d604783f2a7072b3d406466d184d2fa21"
          "HEAD detached at 776d465\nnothing to commit, working tree clean\n"
          "lib_abc                   -                                                 -                        776d465d604783f2a7072b3d406466d184d2fa21")

# 2.5 Git repo with a remote, branch checked out
unit_test("lib_abc" "git@github.com:xmos/lib_abc.git" "develop" "" "776d465d604783f2a7072b3d406466d184d2fa21"
          "On branch develop\nnothing to commit, working tree clean\n"
          "lib_abc                   git@github.com:xmos/lib_abc.git                   develop                  776d465d604783f2a7072b3d406466d184d2fa21")

# 2.6 Git repo with remote, branch checkout out by detaching from the head of the remote branch (some older versions of git)
unit_test("lib_abc" "https://github.com/xmos/lib_abc" "develop" "" "776d465d604783f2a7072b3d406466d184d2fa21"
          "HEAD detached at origin/develop\nnothing to commit, working tree clean\n"
          "lib_abc                   https://github.com/xmos/lib_abc                   develop                  776d465d604783f2a7072b3d406466d184d2fa21")

# 2.7 Git repo with remote, tag checked out
unit_test("lib_abc" "git@github.com:xmos/lib_abc" "" "v1.0.0" "776d465d604783f2a7072b3d406466d184d2fa21"
          "HEAD detached at v1.0.0\nnothing to commit, working tree clean\n"
          "lib_abc                   git@github.com:xmos/lib_abc                       v1.0.0                   776d465d604783f2a7072b3d406466d184d2fa21")

# 2.8 Git repo with remote, changeset checked out
unit_test("lib_abc" "https://github.com/xmos/lib_abc" "" "" "776d465d604783f2a7072b3d406466d184d2fa21"
          "HEAD detached at 776d465\nnothing to commit, working tree clean\n"
          "lib_abc                   https://github.com/xmos/lib_abc                   -                        776d465d604783f2a7072b3d406466d184d2fa21")

# 2.9 Git repo with a remote, branch checked out, but head of branch is tagged
unit_test("lib_abc" "git@github.com:xmos/lib_abc.git" "develop" "v1.0.0" "776d465d604783f2a7072b3d406466d184d2fa21"
          "On branch develop\nnothing to commit, working tree clean\n"
          "lib_abc                   git@github.com:xmos/lib_abc.git                   v1.0.0                   776d465d604783f2a7072b3d406466d184d2fa21")

# 2.10 Git repo with remote, branch checked out as in test 2.9, but head of branch is tagged
unit_test("lib_abc" "https://github.com/xmos/lib_abc" "develop" "v1.0.0" "776d465d604783f2a7072b3d406466d184d2fa21"
          "HEAD detached at origin/develop\nnothing to commit, working tree clean\n"
          "lib_abc                   https://github.com/xmos/lib_abc                   v1.0.0                   776d465d604783f2a7072b3d406466d184d2fa21")

# 2.11 Git repo with remote, tagged changeset checked out
unit_test("lib_abc" "https://github.com/xmos/lib_abc" "" "v1.0.0" "776d465d604783f2a7072b3d406466d184d2fa21"
          "HEAD detached at 776d465\nnothing to commit, working tree clean\n"
          "lib_abc                   https://github.com/xmos/lib_abc                   v1.0.0                   776d465d604783f2a7072b3d406466d184d2fa21")


# Section 3: input name and version provided by dependent modules list, but version does not match currently checked out version.
# This covers cases where dependencies have initially been fetched, but then changed to a different commit/tag via a git command.

# 3.1 Git repo without a remote, branch checked out
unit_test("lib_abc" "" "develop" "" "776d465d604783f2a7072b3d406466d184d2fa21"
          "On branch develop\nnothing to commit, working tree clean\n"
          "lib_abc                   -                                                 develop                  776d465d604783f2a7072b3d406466d184d2fa21")

# 3.2 Git repo without a remote, tag checked out
unit_test("lib_abc"  "" "" "v1.1.0" "776d465d604783f2a7072b3d406466d184d2fa21"
          "HEAD detached at v1.1.0\nnothing to commit, working tree clean\n"
          "lib_abc                   -                                                 v1.1.0                   776d465d604783f2a7072b3d406466d184d2fa21")

# 3.3 Git repo without a remote, changeset checked out
unit_test("lib_abc" "" "" "" "776d465d604783f2a7072b3d406466d184d2fa21"
          "HEAD detached at 776d465\nnothing to commit, working tree clean\n"
          "lib_abc                   -                                                 -                        776d465d604783f2a7072b3d406466d184d2fa21")

# 3.4 Git repo with a remote, branch checked out
unit_test("lib_abc" "git@github.com:xmos/lib_abc.git" "develop" "" "776d465d604783f2a7072b3d406466d184d2fa21"
          "On branch develop\nnothing to commit, working tree clean\n"
          "lib_abc                   git@github.com:xmos/lib_abc.git                   develop                  776d465d604783f2a7072b3d406466d184d2fa21")


# 3.5 Git repo with remote, tag checked out
unit_test("lib_abc" "git@github.com:xmos/lib_abc" "" "v1.1.0" "776d465d604783f2a7072b3d406466d184d2fa21"
          "HEAD detached at v1.1.0\nnothing to commit, working tree clean\n"
          "lib_abc                   git@github.com:xmos/lib_abc                       v1.1.0                   776d465d604783f2a7072b3d406466d184d2fa21")

# 3.6 Git repo with remote, changeset checked out
unit_test("lib_abc" "https://github.com/xmos/lib_abc" "" "" "776d465d604783f2a7072b3d406466d184d2fa21"
          "HEAD detached at 776d465\nnothing to commit, working tree clean\n"
          "lib_abc                   https://github.com/xmos/lib_abc                   -                        776d465d604783f2a7072b3d406466d184d2fa21")

# 3.7 Git repo with a remote, branch checked out, but head of branch is tagged
unit_test("lib_abc" "git@github.com:xmos/lib_abc.git" "develop" "v1.1.0" "776d465d604783f2a7072b3d406466d184d2fa21"
          "On branch develop\nnothing to commit, working tree clean\n"
          "lib_abc                   git@github.com:xmos/lib_abc.git                   v1.1.0                   776d465d604783f2a7072b3d406466d184d2fa21")

# 3.8 Git repo with remote, tagged changeset checked out
unit_test("lib_abc" "https://github.com/xmos/lib_abc" "" "v1.1.0" "776d465d604783f2a7072b3d406466d184d2fa21"
          "HEAD detached at 776d465\nnothing to commit, working tree clean\n"
          "lib_abc                   https://github.com/xmos/lib_abc                   v1.1.0                   776d465d604783f2a7072b3d406466d184d2fa21")
