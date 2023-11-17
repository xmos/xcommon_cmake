Test for applications where multiple components require the same dependency

app_rep_deps0 |
              |--> mod0
              |--> mod1 |--> mod0

app_rep_deps1 |
              |--> mod1 |--> mod0
              |--> mod2 |--> mod0
