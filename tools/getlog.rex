/* REXX *****/
/* trace ?r */
sysut1=gitlog_ex.txt
sysut2=updates.txt

index=0
list.0 = 0

do while lines(sysut1)
  line = linein(sysut1)
  parse value line with key the_rest
  if translate(strip(key)) == "COMMIT" then do

    if index > 0 then do
      say right(index,2,"0") list.index.date list.index.desc
      end

    index = index + 1
    list.index.commit = strip(the_rest)
    iterate
    end

  if translate(strip(key)) == "AUTHOR:" then do
    list.index.author = strip(the_rest)
    iterate
    end

  if translate(strip(key)) == "DATE:" then do
    list.index.date = strip(the_rest)
    line = linein(sysut1)
    list.index.desc = strip(linein(sysut1))
    iterate
    end

  if translate(strip(key)) == "TASKS:" then do
    list.index.tasks = strip(the_rest)
    iterate
    end

  end

say done.
