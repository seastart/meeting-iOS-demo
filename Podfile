# 指明依赖库的来源地址
source 'https://cdn.cocoapods.org'

# 说明平台和版本
platform :ios, '10.0'

# 忽略引入库的所有警告
inhibit_all_warnings!
use_frameworks!

workspace 'MeetingExample.xcworkspace'
project 'MeetingExample.xcodeproj'

def commonPods
    # 网络请求库
    pod 'AFNetworking'
    # 图片加载库
    pod 'SDWebImage'
    # 重置键盘
    pod 'IQKeyboardManager'
    # 列表展位图
    pod 'LYEmptyView'
    # 动态响应链
    pod 'ReactiveObjC'
    # 内测泄漏监测
    pod 'MLeaksFinder'
    # 界面布局组件
    pod 'MyLayout'
    # 数据模型
    pod 'YYModel'
    # 集控引擎
    pod 'RTCControlLink'
end

def meetingPods
  # 实时音视频服务引擎
  pod 'RTCEngineKit', '1.0.8-alpha.1+20240629'
  # 依赖会议服务引擎
  # pod 'MeetingKit'
end

target 'MeetingExample' do
    commonPods
    meetingPods
end

target 'MeetingBroadcastUpload' do
  meetingPods
end

# 更改project配置
post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
        end
    end
end

pre_install do |installer|
  # 声明文件所在目录
  xcode12_temp_dir = "Pods/FBRetainCycleDetector/FBRetainCycleDetector/Layout/Classes/FBClassStrongLayout.mm"
  # 需要被替换的字符串
  xcode12_temp_findstr = "layoutCache[currentClass] = ivars;"
  # 需要替换成的字符串
  xcode12_temp_replacestr = "layoutCache[(id<NSCopying>)currentClass] = ivars;"
  # Fix for XCode 12.5
  find_and_replace(xcode12_temp_dir, xcode12_temp_findstr, xcode12_temp_replacestr);
  
  # 声明文件所在目录
  xcode13_temp_dir = "Pods/FBRetainCycleDetector/fishhook/fishhook.c"
  # 需要被替换的字符串
  xcode13_temp_findstr = "indirect_symbol_bindings[i] = cur->rebindings[j].replacement;"
  # 需要替换成的字符串
  xcode13_temp_replacestr = "if (i < (sizeof(indirect_symbol_bindings) / sizeof(indirect_symbol_bindings[0]))) { \n indirect_symbol_bindings[i]=cur->rebindings[j].replacement; \n }"
  # Fix for XCode 13.0
  find_and_replace(xcode13_temp_dir, xcode13_temp_findstr, xcode13_temp_replacestr);
  
  # 隐藏传递依赖错误
  def installer.verify_no_static_framework_transitive_dependencies; end
end

# 改动FBRetainCycleDetector适配代码
def find_and_replace(dir, findstr, replacestr)
  Dir[dir].each do |name|
      FileUtils.chmod("+w", name)
      text = File.read(name)
      replace = text.gsub(findstr,replacestr)
      if text != replace
          puts "Fix: " + name
          File.open(name, "w") { |file| file.puts replace }
          STDOUT.flush
      end
  end
  Dir[dir + '*/'].each(&method(:find_and_replace))
end
