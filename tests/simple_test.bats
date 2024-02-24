#!/usr/bin/env bats

@test "Check that the script runs successfully" {
    run ./start.sh
    [ "$status" -eq 0 ] || {
        echo "Script failed with exit code $status"
        echo "Script output: $output"
        echo "Script error: $error"
        false
}
