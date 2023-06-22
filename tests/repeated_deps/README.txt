Test for applications where multiple components require the same dependency

app_rep_deps0 |
              |--> lib0
              |--> lib1 |--> lib0

app_rep_deps1 |
              |--> lib1 |--> lib0
              |--> lib2 |--> lib0
