#!/bin/sh

set -e

. /usr/share/debconf/confmodule
progname=$(basename "$0")

tmpfile=$(mktemp -t "$progname.XXXXXXXXXX")
cat >"$tmpfile" <<-EOF
	Template: my-package/progress_title
	Type: text
	Description: Doing Something Useful, I Assure You

	Template: my-package/progress_info
	Type: text
	Description: \${PROGRESS}
EOF
db_x_loadtemplatefile "$tmpfile" my-package
rm "$tmpfile"

db_progress START 0 4 my-package/progress_title

for step in foo bar baz; do
	db_progress STEP 1
	db_subst my-package/progress_info PROGRESS "$step"
	db_progress INFO my-package/progress_info
	sleep 1
done

db_progress SET 4
db_subst my-package/progress_info PROGRESS Done.
db_progress INFO my-package/progress_info
sleep 1
db_progress STOP

db_unregister my-package/progress_title
db_unregister my-package/progress_info
