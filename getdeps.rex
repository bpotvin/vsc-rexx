/* REXX *****/
/* trace ?r */

vars. = ""
sysin = ".\chrome-dep-list.txt"

files = 0
do while lines(sysin)
  files = files + 1
  call process_file linein(sysin)
  end

call lineout sysin
say 'done.' files 'files processed.'
return


/*++
--*/
process_file: procedure expose vars.
parse arg filename
  do while lines(filename)
    line = strip(linein(filename))
    if line == "vars = {" then do
      say "VARS FOUND IN FILE :" filename
      call process_vars filename
      say
    end
    if line == "deps = {" then do
      say "DEPS FOUND IN FILE :" filename
      call process_deps filename
      say
    end
    if line == "'android': = {" then do
      say "OS_DEPS FOUND IN FILE :" filename
      call process_deps filename
      say
    end
  end
  call lineout filename
  return

/*++
--*/
strip_quotes: procedure
parse arg string
  string = strip(translate(string, " ", "'"))
  return strip(translate(string, " ", '"'))

/*++
--*/
process_vars: procedure expose vars.
parse arg filename
  do while lines(filename)
    line = strip(linein(filename))
    if line == "" then do
      iterate
    end
    if line == "}" then do
      leave
    end
    if pos(":", line) <> 0 then do
      parse value line with key ":" val ","
      key = strip_quotes(key)
      val = strip_quotes(val)
      say "-->VAR token=" key "value=" val
      vars.key = val
    end
  end
  return

/*++
--*/
process_deps: procedure expose vars.
parse arg filename
goat = 0
  do while lines(filename)
    line = strip(linein(filename))
    if line == "" then do
      iterate
    end
    if line == "}" then do
      leave
    end
    if pos(":", line) <> 0 then do
      parse value line with key ":"
      key = strip_quotes(key)
      val = process_val(filename)
      say " key=" key "val=" val
/*
      if goat == 0 then do
      trace ?r
        parse value val with url "@" sha1
        dir = translate(key, "\", "/")
        address cmd 'mkdir .\' || dir
        address cmd "cd" dir "& git init & git remote add origin" url "& git fetch origin" sha1 "& git reset --hard FETCH_HEAD"
        goat = goat + 1
      end
*/      
    end
  end
  return

/*++
--*/
process_val: procedure expose vars.
parse arg filename
  line = ""
  do while lines(filename)
    line = line strip(linein(filename))
    if pos(",", line) <> 0 then do
      leave
    end
  end
  parse value line with val ","
  return collapse_val(val)

/*++
--*/
collapse_val: procedure expose vars.
parse arg string
  val = ""
  the_rest = string
  do FOREVER
    parse value the_rest with token "+" the_rest

    if pos("Var(", token) <> 0 then do
      parse value token with "Var(" var ")"
      var = strip_quotes(var)
      token = vars.var
    end

    token = strip_quotes(token)
    val = val || token
    if the_rest == "" then do
      leave
    end
  end
  return val


