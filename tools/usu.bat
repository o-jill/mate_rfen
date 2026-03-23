@rem unite, sort and uniq

@rem usu.bat %1 %2 %3

if not exist "%1" (
  echo "%1 does not exist!"
  exit
)

if not exist "%2" (
  echo "%2 does not exist!"
  exit
)

copy %1 %3
type %2 >> %3

echo "merged."

sort /case /uniq %3

echo "done."
