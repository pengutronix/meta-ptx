#!/bin/sh

RC_ONCE_DIR=/etc/rc.once.d
DONE_DIR="$RC_ONCE_DIR/.done"
STAMP="$DONE_DIR/rc-once"

mount_root_rw() {

    touch "/.root_is_rw" > /dev/null 2>&1 && return

    echo -n "remounting root rw..."
    mount /dev/root / -n -o remount,rw > /dev/null 2>&1
    if [ "$?" -ne "0" ]; then
        echo "failed, aborting"
        return 1
    fi
    echo "done"
}

mount_root_restore() {

    rm "/.root_is_rw" > /dev/null 2>&1 && return

    echo -n "remounting root ro..."
    mount /dev/root / -n -o remount,ro > /dev/null 2>&1
    if [ "$?" -ne "0" ]; then
        echo "failed, aborting"
        return 1
    fi
    echo "done"
}

run_rc_once() {
	failed=0
	echo "running rc.once.d services..."
	cd "$RC_ONCE_DIR" || exit 1
	mkdir -p "$DONE_DIR"
	for script in *; do
		test -x "$script" || continue
		test -e "$DONE_DIR/$script" && continue
		"$RC_ONCE_DIR/$script"
		if [ $? -ne 0 ]; then
			echo "running $script failed."
			failed=1
		else
			: > "$DONE_DIR/$script"
		fi
	done
	return $failed
}

