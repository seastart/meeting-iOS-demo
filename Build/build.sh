#!/bin/bash

# 导出数据目录(当前目录)
DERIVED_DATA_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# 获取工程文件目录
PROJECT_PATH="$( cd "$( dirname "$PWD" )" && pwd )"

# 项目Target名字
TARGET_NAME="MeetingExample"

# 项目Scheme名字
SCHEME_NAME="MeetingExample"

# 应用BundleID
BUNDLEID_NAME="cn.seastart.meetingkit"

# 导出包文件夹名称
PACKAGE_NAME="Package"

# AppStore ApiKey
APPSTORE_APIKEY="7SDG5NF5G6"

# AppStore ApiIssuer
APPSTORE_APIISSUER="69a6de85-498a-47e3-e053-5b8c7c11a4d1"

# Fir api token
FIR_UPLOAD_TOKEN="1535ba554a373a85e9aecdda3b8838df"

# 蒲公英API Key
PGYER_UPLOAD_APIKEY="71dfbbaa8dc0626d51367b8c097c71cd"

# 蒲公英User Key
PGYER_UPLOAD_USERKEY="50fa67a235488f0a48d97380847c549c"

# Bugly AppID
BUGLY_APPID="21acd998ee"

# Bugly AppKey
BUGLY_APPKEY="928570f4-a493-4e58-b78f-3f856a4c8c31"

# 上传平台
UPLOAD_PLATFORM="IOS"

# 上传日志
UPLOAD_LOG="上传日志"

# 项目Scheme Plist配置文件位置
SCHEME_PLIST_PATH=${PROJECT_PATH}/${TARGET_NAME}/Resources/${TARGET_NAME}-Info.plist
SCHEME_UPLOAD_PLIST_PATH=${PROJECT_PATH}/RTCReplayBroadcastUpload/Info.plist

# 提示用户选择打包环境
echo "请选择打包环境编号 [1:app-store 2:ad-hoc 3:debug]"

# 读取用户输入打包环境信息
read number
while [[ $number != 1 && $number != 2 && $number != 3 ]]; do
	echo "出错了！请输入正确的打包环境编号。[1-2-3]"
	echo "请选择打包环境编号 [1:app-store 2:ad-hoc 3:debug]"
	read number
done

# 确定用户输入的打包环境和Plist文件路径
if [[ $number == 1 ]]; then
	CONFIGURATION=Release
    PLIST_PATH="${DERIVED_DATA_PATH}/ExportOptions-release.plist"
elif [[ $number == 2 ]]; then
	CONFIGURATION=ReleaseAdhoc
	PLIST_PATH="${DERIVED_DATA_PATH}/ExportOptions-adhoc.plist"
elif [[ $number == 3 ]]; then
	CONFIGURATION=Debug
	PLIST_PATH="${DERIVED_DATA_PATH}/ExportOptions-debug.plist"
fi

# 只有非AppStore环境包可上传分发平台
if [[ $number != 1 ]]; then
	echo "请选择上传分发平台 [1:fir.im 2:蒲公英 3:fir.im和蒲公英 4:不分发]"
	# 读取用户输入分发情况
	read d_number
	while [[ $d_number != 1 && $d_number != 2 && $d_number != 3 && $d_number != 4 ]]; do
		echo "出错了！请输入正确的分发编号。[1-2-3-4]"
		echo "请选择上传分发平台 [1:fir.im 2:蒲公英 3:fir.im和蒲公英 4:不分发]"
		read d_number
	done
	if [[ $d_number != 4 ]]; then
		echo "请输入上传日志："
		# 读取用户输入上传日志
		read log
		while [[ -z "$log" ]]; do
			echo "出错了！上传日志不能为空。"
			echo "请输入上传日志："
			read log
		done
		UPLOAD_LOG=$log
	fi
else
	# 不支持上传分发平台置d_number为4
	d_number=4
	# 正式环境包提示是否需要上传AppStore
	echo "是否需要上传到AppStore？[1:YES 2:NO]"
	# 读取用户输入是否上传到AppStore
	read u_number
	while [[ $u_number != 1 && $u_number != 2 ]]; do
		echo "出错了！请输入正确的编号。[1-2]"
		echo "是否需要上传到AppStore？[1:YES 2:NO]"
		read u_number
	done
fi

# 获取当前项目版本号和构建号
MAINVERSION=$(/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" ${SCHEME_PLIST_PATH})
MAINBUILD=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" ${SCHEME_PLIST_PATH})

NEW_MAINVERSION=$MAINVERSION
NEW_MAINBUILD=$MAINBUILD

echo "${TARGET_NAME} 版本号：$MAINVERSION Build号：$MAINBUILD"

echo "您是否要重新设置版本号和Build号 [1:NO 2:Build号递增一位 3:YES]"
# 读取用户输入版本信息
read v_number
while [[ $v_number != 1 && $v_number != 2 && $v_number != 3 ]]; do
	echo "出错了！请输入正确的版本信息编号。[1-2-3]"
	echo "您是否要重新设置版本号和Build号 [1:NO 2:Build号递增一位 3:YES]"
	read v_number
done

# 确定用户输入的版本信息
if [[ $v_number == 1 ]]; then
	echo "#################### 版本未做更改 ####################"
elif [[ $v_number == 2 ]]; then
	echo "#################### Build号递增一位 ####################"
	NEW_MAINBUILD=$((${MAINBUILD} + 1))
elif [[ $v_number == 3 ]]; then
	echo "请输入新版本号:"
	read version
	NEW_MAINVERSION=$version
	echo "请输入新Build号:"
	read build
	NEW_MAINBUILD=$build
fi

# 设置新的版本号和Build号
plutil -replace CFBundleShortVersionString -string $NEW_MAINVERSION ${SCHEME_PLIST_PATH}
plutil -replace CFBundleVersion -string $NEW_MAINBUILD ${SCHEME_PLIST_PATH}
plutil -replace CFBundleShortVersionString -string $NEW_MAINVERSION ${SCHEME_UPLOAD_PLIST_PATH}
plutil -replace CFBundleVersion -string $NEW_MAINBUILD ${SCHEME_UPLOAD_PLIST_PATH}

echo "${TARGET_NAME} 当前版本号为：$NEW_MAINVERSION 当前Build号为：$NEW_MAINBUILD"

# 工程文件路径
APP_PATH="${PROJECT_PATH}/${TARGET_NAME}.xcworkspace"

# 打包时间戳
CURRENT_TIME=$(date "+%Y-%m-%d %H-%M-%S")

# 导出路径
EXPORT_PATH="${DERIVED_DATA_PATH}/${PACKAGE_NAME}/${TARGET_NAME}-${CONFIGURATION} ${CURRENT_TIME}"

# 归档路径
ARCHIVE_PATH="${EXPORT_PATH}/${TARGET_NAME}.xcarchive"

# IPA路径
IPA_PATH="${EXPORT_PATH}/${SCHEME_NAME}.ipa"

# dSYM文件路径
ARCHIVE_dSYM_PATH="${ARCHIVE_PATH}/dSYMs/${SCHEME_NAME}.app.dSYM"

# 记录开始发布时间
START_DATE=$(date "+%s")

echo "#################### step 1-clean ####################"
# clean
xcodebuild clean -workspace "${APP_PATH}" -configuration "${CONFIGURATION}" -scheme "${TARGET_NAME}"

echo "#################### step 2-archive ####################"
# archive
xcodebuild archive -workspace "${APP_PATH}" -scheme "${TARGET_NAME}" -configuration "${CONFIGURATION}" -archivePath "${ARCHIVE_PATH}"

echo "#################### step 3-export ####################"
# export ipa
xcodebuild -exportArchive -archivePath "${ARCHIVE_PATH}" -exportPath "${EXPORT_PATH}" -exportOptionsPlist "${PLIST_PATH}"

# 压缩导出包
if [[ -d "$EXPORT_PATH" ]]; then
	echo "#################### 压缩导出路径 ####################"
	# 压缩导出路径
	tar -zcvf "${PACKAGE_NAME}/${TARGET_NAME}-${CONFIGURATION} ${CURRENT_TIME}.tar.gz" "${PACKAGE_NAME}/${TARGET_NAME}-${CONFIGURATION} ${CURRENT_TIME}"
else
	echo "#################### 导出路径为空，不做压缩导出 ####################"
fi

# 上传分发包到fir、蒲公英平台
if [[ $d_number != 4 && -f "$IPA_PATH" ]]; then
	echo "#################### 需要上传分发平台 ####################"
	# 上传分发平台
	if [[ $d_number == 1 ]]; then
		echo "#################### 安装包上传到fir.im ####################"
		fir publish "$IPA_PATH" -c "$UPLOAD_LOG" -T "$FIR_UPLOAD_TOKEN"
	elif [[ $d_number == 2 ]]; then
		echo "#################### 安装包上传到蒲公英 ####################"
		curl -F "file=@${IPA_PATH}" -F "uKey=${PGYER_UPLOAD_USERKEY}" -F "_api_key=${PGYER_UPLOAD_APIKEY}" -F "buildUpdateDescription=${UPLOAD_LOG}" https://www.pgyer.com/apiv2/app/upload
	elif [[ $d_number == 3 ]]; then
		echo "#################### 安装包上传到fir.im ####################"
		fir publish "$IPA_PATH" -c "$UPLOAD_LOG" -T "$FIR_UPLOAD_TOKEN"
		echo "#################### 安装包上传到蒲公英 ####################"
		curl -F "file=@${IPA_PATH}" -F "uKey=${PGYER_UPLOAD_USERKEY}" -F "_api_key=${PGYER_UPLOAD_APIKEY}" -F "buildUpdateDescription=${UPLOAD_LOG}" https://www.pgyer.com/apiv2/app/upload
	fi
else
	echo "############### 不需要上传或程序包不存在或打包环境不支持上传分发平台 ###############"
fi

# 上传程序包到AppStore
if [[ $number == 1 && $u_number == 1 && -f "$IPA_PATH" ]]; then
	echo "#################### 需要上传程序包到AppStore ####################"
	# 验证App程序包
	echo "#################### 正在验证App程序包 ####################"
	xcrun altool --validate-app -f "$IPA_PATH" -t ios --apiKey "$APPSTORE_APIKEY" --apiIssuer "$APPSTORE_APIISSUER" --verbose
	# 上传App程序包
	echo "#################### 正在上传App程序包 ####################"
	xcrun altool --upload-app -f "$IPA_PATH" -t ios --apiKey "$APPSTORE_APIKEY" --apiIssuer "$APPSTORE_APIISSUER" --verbose
fi

# 上传dYSM文件到Bugly平台
echo "#################### 开始上传dYSM文件到Bugly平台 ####################"
java -jar buglyqq-upload-symbol.jar -appid "${BUGLY_APPID}" -appkey "${BUGLY_APPKEY}" -bundleid "${BUNDLEID_NAME}" -version "${NEW_MAINVERSION}-${NEW_MAINBUILD}" -platform "${UPLOAD_PLATFORM}" -inputSymbol "${ARCHIVE_dSYM_PATH}"

# 记录结束发布时间
END_DATE=$(date "+%s")
# 发布持续时间(秒级)
DURATION_SECOND_TIME=$((END_DATE-START_DATE))
# 小时
HOUR_TIME=$(( $DURATION_SECOND_TIME/3600 ))
# 分钟
MINUTE_TIME=$(( ($DURATION_SECOND_TIME-${HOUR_TIME}*3600)/60 ))
# 秒数
SECOND_TIME=$(( $DURATION_SECOND_TIME-${HOUR_TIME}*3600-${MINUTE_TIME}*60 ))
# 发布持续时间(时:分:秒)
DURATION_TIME="${HOUR_TIME}小时 ${MINUTE_TIME}分钟 ${SECOND_TIME}秒"

echo -e "\n#################### 构建版本用时：${DURATION_TIME} ####################"
