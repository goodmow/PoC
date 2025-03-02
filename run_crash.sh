#!/bin/bash

# afl minilize
# afl-cmin -i crashes -o crashes_min -C -m none -- ../program @@ /dev/null


OUTPUT_FILE="crash_reports_$(date).txt"

> "$OUTPUT_FILE"


for i in $(seq 130 255); do
    num=$(printf "%06d" "$i")
    echo "正在处理文件: $num"

    pre_out="/home/goodmow/Documents/Titan/benchmark/libming-048-address/util/obj-bc/bin/fuzz_out"
    crash_file_pattern=$pre_out"/crashes/id:$num*"
    for crash_file in $crash_file_pattern; do

        if [ -f "$crash_file" ]; then
            echo "正在处理文件: $crash_file" 
            {
            echo "=============================="
            echo "文件: $crash_file"
            echo "时间: $(date)"
            echo "-----------------------------"
            ASAN_OPTIONS=symbolize=1  ./swftoperl "$crash_file" /dev/null
            echo "-----------------------------"
            echo "=============================="
            echo ""
            } >> "$OUTPUT_FILE" 2>&1
            
            echo "处理完成: $crash_file"
        else
            echo "没有找到匹配的文件: $crash_file_pattern"
            break
        fi
    done
done

echo "所有文件处理完毕。崩溃报告已汇总至 $OUTPUT_FILE"