#!/bin/bash

        dir=$1
        exe=$2
        input=$@

        cd $dir
        make > /dev/null
        res=$?

        if [[ $res -gt 0 ]]; then
                echo  "Compilation      Memory leaks    thread race"
                echo  "    FAIL            FAIL             FAIL"
		echo "7"
                exit 7
        fi
                valgrind --leak-check=full --error-exitcode=3 --log-file=/dev/null ./$exe <<< $input >> /dev/null
                res=$?


                if [[ $res -eq 0 ]]; then
                        leaks=0
                else
                        leaks=1
                fi

                valgrind --tool=helgrind --error-exitcode=3 --log-file=/dev/null ./$exe <<< $input >> /dev/null
                res=$?
		

		if [[ $res -eq 0 ]]; then
                        thrc=0
                else
                        thrc=1
                fi

                closing=$leaks$thrc

                if [[ $closing -eq 11 ]]; then
                        echo  "Compilation      Memory leaks    thread race"
                        echo "     PASS            FAIL            FAIL"
			echo "3"
                        exit 3
                elif [[ $closing -eq 01 ]]; then
                        echo  "Compilation      Memory leaks    thread race"
                        echo "     PASS            PASS           FAIL"
			echo "1"
                        exit 1
                elif [[ $closing -eq 10 ]]; then
                        echo  "Compilation      Memory leaks    thread race"
                        echo "     PASS            FAIL           PASS"
			echo "2"
                        exit 2
                else
                        echo  "Compilation      Memory leaks    thread race"
                        echo "     PASS            PASS           PASS"
			echo "0"
                        exit 0
                fi

    



