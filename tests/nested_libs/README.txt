Application that tests nested library dependencies:
 - app requires libintf0 and libstat0
 - libintf0 requires libintf1
 - libstat0 is compiled as a static library
 - libstat0 requires libintf2
 - libintf2 requires libintf3
