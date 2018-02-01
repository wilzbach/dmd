compare()
{
    local actual expected
    actual="$1"
    expected="$2"
    if [ "$actual" != "$expected" ] ; then
        echo "Expected: $expected"
        echo "Actual:   $actual"
        echo "$expected" | hexdump -C
        echo "$actual" | hexdump -C
        exit 1
    fi
}

filterAnsi()
{
    cat | sed "s/$(printf "\x1b")\(\[[0-9;]*m\)/[\1/g" | sed "s/\[\[/[/g" | sed "s/m\[m/m/g" | tr -d "\n" | tr -d "\r"
}

check()
{
    local actual expected
    # try to emulate the `strings` command
    # sed on some OSes doesn't support direct hex byte in its input string
    actual=$(echo "$2" | ("$DMD" -c -o- "$1" - 2>&1 || true) | filterAnsi)
    compare "$actual" "$3"
}

expectedWithoutColor='__stdin.d(2): Error: no identifier for declarator `test`'
expectedWithColor="[1m__stdin.d(2): [1;31mError: [mno identifier for declarator [0;36m[1mtest[0;36m"

check -c "test" "$expectedWithoutColor"
check -color=auto "test" "$expectedWithoutColor"
check -color=on "test" "$expectedWithColor"

# Faking a TTY only works on Linux
#if [ "$OS" == "linux" ] ; then
    export SHELL="bash"
    script -q --return -c "echo test | $DMD -c -o- -"
    script -q --return -c "$DMD -c -o- foo.d"
    actual="$(! script -q --return -c "echo test | $DMD -c -o- -" /dev/null | filterAnsi)"
    compare "$actual" "$expectedWithColor"
#fi
