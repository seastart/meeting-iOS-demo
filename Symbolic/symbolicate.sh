#!/bin/bash

echo -e "🚧🚧🚧🚧🚧🚧 开始符号化解析 🚧🚧🚧🚧🚧🚧\n"

export DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer

./symbolicatecrash ./crash.txt ./MeetingExample.app.dSYM > result.log --verbose

echo -e "\n🚀🚀🚀🚀🚀🚀 解析完成 🚀🚀🚀🚀🚀🚀"
