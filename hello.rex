/* REXX *****/
/* trace ?r */
parse arg argv

argc = words(argv)

pi = 3.1415927

say 'argc=' argc

do index=1 to 10
  say "Hello!" argv
  end

return
